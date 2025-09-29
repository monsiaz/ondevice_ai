import Foundation
import AVFoundation
import Speech
import UIKit

@MainActor
final class SpeechManager: NSObject, ObservableObject {
    private let speechQueue = DispatchQueue(label: "com.ondeviceai.speech", qos: .userInitiated)
    @Published var isDictating: Bool = false
    @Published var transcript: String = ""
    @Published var isSpeaking: Bool = false

    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var speechRecognizer: SFSpeechRecognizer?
    private let synthesizer = AVSpeechSynthesizer()
    private var currentLocale: Locale

    override init() {
        // Default to English, then sync with app language setting
        let appLang = UserDefaults.standard.string(forKey: "appLanguage") ?? "en"
        currentLocale = localeForLanguage(appLang)
        speechRecognizer = SFSpeechRecognizer(locale: currentLocale)
        
        super.init()
        synthesizer.delegate = self
        print("🎤 SpeechManager initialized for locale: \(currentLocale.identifier)")
        
        // Listen for language changes
        NotificationCenter.default.addObserver(
            forName: UserDefaults.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateLanguage()
        }
    }
    
    private func updateLanguage() {
        let appLang = UserDefaults.standard.string(forKey: "appLanguage") ?? "en"
        let newLocale = Self.localeForLanguage(appLang)
        
        if newLocale.identifier != currentLocale.identifier {
            currentLocale = newLocale
            speechRecognizer = SFSpeechRecognizer(locale: currentLocale)
            print("🔄 Speech language updated to: \(currentLocale.identifier)")
        }
    }
    
    private static func localeForLanguage(_ lang: String) -> Locale {
        switch lang {
        case "fr": return Locale(identifier: "fr-FR")
        case "es": return Locale(identifier: "es-ES")
        case "de": return Locale(identifier: "de-DE")
        case "it": return Locale(identifier: "it-IT")
        case "pt": return Locale(identifier: "pt-PT")
        case "nl": return Locale(identifier: "nl-NL")
        case "pl": return Locale(identifier: "pl-PL")
        case "ru": return Locale(identifier: "ru-RU")
        case "zh": return Locale(identifier: "zh-CN")
        case "ja": return Locale(identifier: "ja-JP")
        case "ko": return Locale(identifier: "ko-KR")
        case "ar": return Locale(identifier: "ar-SA")
        default: return Locale(identifier: "en-US") // Default English
        }
    }

    func requestAuthorization() async {
        await withCheckedContinuation { (cont: CheckedContinuation<Void, Never>) in
            SFSpeechRecognizer.requestAuthorization { _ in cont.resume() }
        }
        if #available(iOS 17.0, *) {
            AVAudioApplication.requestRecordPermission { _ in }
        } else {
            let session = AVAudioSession.sharedInstance()
            session.requestRecordPermission { _ in }
        }
    }

    func toggleDictation() {
        isDictating ? stopDictation() : startDictation()
    }

    func startDictation() {
        guard !audioEngine.isRunning else { 
            print("⚠️ Audio engine already running")
            return 
        }
        
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        guard speechRecognizer?.isAvailable == true else {
            print("❌ Speech recognition not available")
            return
        }
        
        // Reset transcript
        transcript = ""

        // Configure audio session for recording
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("❌ Audio session error: \(error)")
            return
        }

        // Create recognition request
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest else { 
            print("❌ Unable to create recognition request")
            return 
        }
        recognitionRequest.shouldReportPartialResults = true
        recognitionRequest.requiresOnDeviceRecognition = true // Force on-device for privacy

        // Setup audio tap
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.removeTap(onBus: 0) // Clean any existing tap
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
            self?.recognitionRequest?.append(buffer)
        }

        // Start audio engine
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("❌ Audio engine error: \(error)")
            return
        }

        // Start recognition task
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self else { return }
            
            if let result = result {
                let transcribedText = result.bestTranscription.formattedString
                Task { @MainActor in
                    self.transcript = transcribedText
                    print("🎤 Transcription: \(transcribedText)")
                }
            }
            
            if let error = error {
                print("❌ Recognition error: \(error.localizedDescription)")
                Task { @MainActor in
                    self.stopDictation()
                }
            } else if result?.isFinal == true {
                print("✅ Recognition final")
                Task { @MainActor in
                    self.stopDictation()
                }
            }
        }

        isDictating = true
        print("🎤 Dictation started")
    }

    func stopDictation() {
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionRequest = nil
        recognitionTask = nil
        isDictating = false
        
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }

    func speak(_ text: String) {
        guard !text.isEmpty else { return }
        stopSpeaking()
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: currentLocale.identifier)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        synthesizer.speak(utterance)
        isSpeaking = true
        
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
        
        print("🔊 Speaking in \(currentLocale.identifier)")
    }

    func stopSpeaking() {
        if synthesizer.isSpeaking { synthesizer.stopSpeaking(at: .immediate) }
        isSpeaking = false
    }
}

extension SpeechManager: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        Task { @MainActor in self.isSpeaking = false }
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        Task { @MainActor in self.isSpeaking = false }
    }
}


