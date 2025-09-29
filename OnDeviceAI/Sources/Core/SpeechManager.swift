import Foundation
import AVFoundation
import Speech

@MainActor
final class SpeechManager: NSObject, ObservableObject {
    @Published var isDictating: Bool = false
    @Published var transcript: String = ""
    @Published var isSpeaking: Bool = false

    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let speechRecognizer = SFSpeechRecognizer()
    private let synthesizer = AVSpeechSynthesizer()

    override init() {
        synthesizer.delegate = self
    }

    func requestAuthorization() async {
        let _ = await SFSpeechRecognizer.requestAuthorization()
        AVAudioApplication.requestRecordPermission { _ in }
    }

    func toggleDictation() {
        isDictating ? stopDictation() : startDictation()
    }

    func startDictation() {
        guard !audioEngine.isRunning else { return }
        transcript = ""

        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try? audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest else { return }
        recognitionRequest.shouldReportPartialResults = true

        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.removeTap(onBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
            self?.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        try? audioEngine.start()

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self else { return }
            if let result = result {
                Task { @MainActor in
                    self.transcript = result.bestTranscription.formattedString
                }
            }
            if error != nil || (result?.isFinal ?? false) {
                Task { @MainActor in
                    self.stopDictation()
                }
            }
        }

        isDictating = true
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
    }

    func speak(_ text: String) {
        guard !text.isEmpty else { return }
        stopSpeaking()
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: Locale.current.identifier)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        synthesizer.speak(utterance)
        isSpeaking = true
    }

    func stopSpeaking() {
        if synthesizer.isSpeaking { synthesizer.stopSpeaking(at: .immediate) }
        isSpeaking = false
    }
}

extension SpeechManager: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeaking = false
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        isSpeaking = false
    }
}


