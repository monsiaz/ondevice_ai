import Foundation
import SwiftUI

@MainActor
struct ChatBubble: Identifiable {
    enum Role { case user, assistant, system }
    let id = UUID()
    let role: Role
    var text: String
}

@MainActor
final class ChatVM: ObservableObject {
    @Published var messages: [ChatBubble] = [] {
        didSet { persist() }
    }
    @Published var input: String = ""
    @Published var isGenerating = false
    @Published var backendName: String
    @Published var currentModel: String
    @Published var generationStats: String = ""
    @Published var isDownloadingInitialModel = false
    @Published private(set) var isModelLoaded = false
    @Published var modelLoadingStatus: String = ""

    private let llm: LocalLLM
    private var isRestored = false
    private var tokenBuffer: String = ""
    private var coalesceTask: Task<Void, Never>?
    private var streamMonitorTask: Task<Void, Never>?
    private var lastTokenAt: Date = Date()
    private var queuedPrompt: String?

    init(llm: LocalLLM, backendName: String) {
        self.llm = llm
        self.backendName = "MLX" // Commence par MLX
        self.currentModel = "Qwen 2.5 0.5B" // Modèle par défaut
        self.modelLoadingStatus = "Checking for models..."

        Task {
            // 1) If a model is already installed, load the first one
            let installed = ModelManager.shared.listInstalled()
            if let first = installed.first {
                await MainActor.run { self.modelLoadingStatus = "Loading \(first.displayName)..." }
                try? await Task.sleep(nanoseconds: 100_000_000)
                await MainActor.run { self.load(modelURL: ModelManager.shared.url(for: first)) }
                return
            }
            // 2) Otherwise, auto-download a very light default (TinyLlama 1.1B 4-bit)
            await MainActor.run { self.modelLoadingStatus = "Downloading default model..." }
            await self.installAndLoadDefaultTinyModel()
        }
    }

    func setupInitialModel() async {
        // Cette fonction n'est plus nécessaire car le modèle est embarqué
    }

    func load(conversation: Conversation) {
        // Stop current streaming and tasks before swapping context
        cancelStreaming()
        isModelLoaded = false
        messages = conversation.messages.map {
            ChatBubble(role: $0.role == "user" ? .user : .assistant, text: $0.text)
        }
        
        // Mettre à jour l'UI pour afficher le modèle de la conversation
        self.currentModel = conversation.modelName
        self.backendName = conversation.backendName
        
        // Tenter de charger le modèle MLX correspondant
        if true { // MLX only
            let candidate = conversation.modelName.contains("-4bit") ? conversation.modelName : conversation.modelName + "-4bit"
            let exists = ModelManager.shared.modelExists(folderName: candidate)
            if exists {
                let model = LocalModel(displayName: candidate, folderName: candidate)
                let url = ModelManager.shared.url(for: model)
                load(modelURL: url)
            } else {
                // Fallback sur le modèle MLX par défaut installé
                if ModelManager.shared.modelExists(folderName: "qwen2.5-0.5b-instruct-4bit") {
                    let url = ModelManager.shared.url(for: LocalModel(displayName: "Qwen 2.5 0.5B", folderName: "qwen2.5-0.5b-instruct-4bit"))
                    load(modelURL: url)
                } else {
                    self.currentModel = "Qwen 2.5 0.5B"
                    self.backendName = "MLX"
                }
            }
        }
    }

    func load(modelURL: URL) {
        // Annuler le stream en cours et décharger l'ancien modèle
        cancelStreaming()
        llm.unload()
        isModelLoaded = false
        modelLoadingStatus = "Loading model..."
        
        // MLX only now
        
        do { 
            try llm.load(modelURL: modelURL)
            // Update current model name from the URL
            currentModel = modelURL.lastPathComponent
            backendName = "MLX"
            print("✅ Model loaded: \(currentModel) via MLX")
            
            // Délai de warm-up pour que le modèle soit vraiment prêt
            Task {
                try? await Task.sleep(nanoseconds: 500_000_000) // 500ms
                await MainActor.run {
                    self.isModelLoaded = true
                    self.modelLoadingStatus = ""
                    DebugLog.shared.log("Model \(self.currentModel) ready for generation")
                    // Si un prompt était en file d'attente, le traiter maintenant
                    self.processQueuedIfNeeded()
                }
            }
        } catch { 
            print("❌ Load error: \(error)")
            currentModel = "Error: \(error.localizedDescription)"
            isModelLoaded = false
            modelLoadingStatus = "Error loading model"
        }
    }

    func clear() { 
        // Annuler toute génération en cours
        cancelStreaming()
        messages.removeAll() 
        persist() // Persist the empty state for the current session
        NotificationCenter.default.post(name: Notification.Name("ChatVM.didClear"), object: nil)
        DebugLog.shared.log("Chat cleared and generation cancelled")
    }

    func send() {
        guard !input.isEmpty else { 
            DebugLog.shared.log("Send blocked: empty input")
            return 
        }
        
        DebugLog.shared.log("Send called: input='\(input)', isModelLoaded=\(isModelLoaded), modelLoadingStatus='\(modelLoadingStatus)', isGenerating=\(isGenerating)")
        
        // Si une génération est en cours, l'annuler proprement
        if isGenerating {
            DebugLog.shared.log("Cancelling current generation to process new prompt")
            cancelStreaming()
            // Attendre un court délai pour que l'annulation prenne effet
            Task {
                try? await Task.sleep(nanoseconds: 100_000_000) // 100ms
                await MainActor.run {
                    self.processSend()
                }
            }
            return
        }
        
        processSend()
    }
    
    private func processSend() {
        // Compose prompt now
        let userPrompt = input
        let sys = UserDefaults.standard.string(forKey: "systemPrompt") ?? ""
        let finalPrompt = sys.isEmpty ? userPrompt : "\(sys)\n\nUser: \(userPrompt)"
        input = ""
        
        // Simplifier la logique - soit le modèle est chargé, soit on charge et on traite
        if !isModelLoaded || !modelLoadingStatus.isEmpty {
            // Queue le prompt et charge le modèle
            queuedPrompt = finalPrompt
            DebugLog.shared.log("Queued prompt, ensuring model is loaded...")
            ensureModelLoaded()
            return
        }

        DebugLog.shared.log("Starting generation with loaded model")
        startSending(finalPrompt: finalPrompt, userPrompt: userPrompt)
    }
    
    private func ensureModelLoaded() {
        guard !isModelLoaded else { return }
        
        if ModelManager.shared.modelExists(folderName: "qwen2.5-0.5b-instruct-4bit") {
            let url = ModelManager.shared.url(for: LocalModel(displayName: "Qwen 2.5 0.5B", folderName: "qwen2.5-0.5b-instruct-4bit"))
            DebugLog.shared.log("Loading Qwen 2.5 0.5B from: \(url.path)")
            load(modelURL: url)
        } else if let first = ModelManager.shared.listInstalled().first {
            DebugLog.shared.log("Loading first installed model: \(first.displayName)")
            load(modelURL: ModelManager.shared.url(for: first))
        } else {
            DebugLog.shared.log("No models installed, showing error message")
            messages.append(ChatBubble(role: .assistant, text: "No local model installed. Open Models and download Qwen 2.5 0.5B 4-bit."))
            queuedPrompt = nil
        }
    }

    private func startSending(finalPrompt: String, userPrompt: String) {
        // Limiter la taille du contexte pour éviter les problèmes de mémoire
        trimMessagesIfNeeded()
        
        messages.append(ChatBubble(role: .user, text: userPrompt))
        isGenerating = true
        var assistantId: UUID? = nil
        
        let startTime = Date()
        var tokenCount = 0
        lastTokenAt = Date()
        
        // Buffer pour coalescer les tokens et éviter trop d'updates UI
        var localTokenBuffer = ""
        var updateCounter = 0
        let batchSize = 3 // Taille de batch pour optimiser les performances
        
        DebugLog.shared.log("Starting optimized token processing")
        
        do {
            DebugLog.shared.log("Calling llm.generate with backend: \(backendName)")
            try llm.generate(prompt: finalPrompt) { token in
                Task { @MainActor in
                    guard self.isGenerating else { 
                        DebugLog.shared.log("Token ignored - generation was cancelled")
                        return 
                    }
                    
                    tokenCount += 1
                    localTokenBuffer += token
                    updateCounter += 1
                    
                    // Mettre à jour les stats moins fréquemment pour optimiser les performances
                    if tokenCount % 5 == 0 {
                        let elapsedTime = Date().timeIntervalSince(startTime)
                        if elapsedTime > 0 {
                            let tokensPerSecond = Double(tokenCount) / elapsedTime
                            self.generationStats = String(format: "%.1f t/s", tokensPerSecond)
                        }
                    }
                    
                    // Mettre à jour l'UI par batch pour éviter la surcharge
                    // Adapter le comportement selon les performances
                    let shouldUpdate = updateCounter >= batchSize || 
                                     token.contains("\n") || 
                                     token.contains(".") ||
                                     updateCounter >= 1
                    
                    if shouldUpdate {
                        // Créer ou mettre à jour la bulle assistant
                        if let id = assistantId, let i = self.messages.firstIndex(where: { $0.id == id }) {
                            self.messages[i].text += localTokenBuffer
                        } else {
                            let bubble = ChatBubble(role: .assistant, text: localTokenBuffer)
                            assistantId = bubble.id
                            self.messages.append(bubble)
                        }
                        
                        localTokenBuffer = ""
                        updateCounter = 0
                        self.lastTokenAt = Date()
                        
                        // Notification pour le scrolling
                        NotificationCenter.default.post(name: Notification.Name("ChatVM.didAppendToken"), object: nil)
                    }
                }
            }
            
            // Monitorer la fin de génération avec timeout plus robuste
            streamMonitorTask = Task {
                var consecutiveNoTokens = 0
                while self.isGenerating && !Task.isCancelled {
                    try? await Task.sleep(nanoseconds: 300_000_000) // 300ms
                    
                    await MainActor.run {
                        let timeSinceLastToken = Date().timeIntervalSince(self.lastTokenAt)
                        if timeSinceLastToken > 1.0 { // Timeout plus long
                            consecutiveNoTokens += 1
                            if consecutiveNoTokens >= 2 {
                                DebugLog.shared.log("Generation completed (timeout after 2 seconds)")
                                self.finishGeneration(assistantId: assistantId, finalTokenBuffer: localTokenBuffer)
                            }
                        } else {
                            consecutiveNoTokens = 0
                        }
                    }
                }
            }
            
        } catch {
            DebugLog.shared.log("Error during generation: \(error.localizedDescription)")
            finishGeneration(assistantId: assistantId, finalTokenBuffer: localTokenBuffer, error: error)
        }
    }
    
    private func finishGeneration(assistantId: UUID?, finalTokenBuffer: String, error: Error? = nil) {
        // Flush le buffer final s'il reste des tokens
        if !finalTokenBuffer.isEmpty, let id = assistantId, let i = messages.firstIndex(where: { $0.id == id }) {
            messages[i].text += finalTokenBuffer
        }
        
        // Gérer l'erreur si présente
        if let error = error {
            if let id = assistantId, let i = messages.firstIndex(where: { $0.id == id }) {
                messages[i].text += "\n\n[Error: \(error.localizedDescription)]"
            } else {
                let bubble = ChatBubble(role: .assistant, text: "Error: \(error.localizedDescription)")
                messages.append(bubble)
            }
        }
        
        isGenerating = false
        generationStats = ""
        streamMonitorTask?.cancel()
        streamMonitorTask = nil
    }
    
    private func trimMessagesIfNeeded() {
        // Limiter le contexte à 20 messages pour éviter les problèmes de mémoire
        let maxMessages = 20
        if messages.count > maxMessages {
            let keepCount = maxMessages - 2 // Garder de la place pour user + assistant
            messages = Array(messages.suffix(keepCount))
            DebugLog.shared.log("Trimmed conversation to \(messages.count) messages")
        }
    }

    func unloadModel() {
        llm.unload()
        isModelLoaded = false
    }

    private func cancelStreaming() {
        isGenerating = false
        coalesceTask?.cancel()
        streamMonitorTask?.cancel()
        coalesceTask = nil
        streamMonitorTask = nil
        tokenBuffer.removeAll(keepingCapacity: false)
    }


    // MARK: - Default model bootstrap (optimal quality/speed)
    private func installAndLoadDefaultTinyModel() async {
        await MainActor.run { self.isDownloadingInitialModel = true }
        let defaultModel = AvailableModel(
            name: "qwen2.5-0.5b-instruct-4bit",
            displayName: "Qwen 2.5 0.5B",
            description: "Ultra-fast, ideal for quick questions and simple tasks.",
            size: "350 MB",
            downloadURL: "https://huggingface.co/mlx-community/Qwen2.5-0.5B-Instruct-4bit/resolve/main/",
            tags: ["General", "Fast", "Lightweight"],
            deviceRequirement: "iPhone 15+",
            performance: .ultraFast,
            category: .recommended
        )
        let downloader = ModelDownloader()
        do {
            try await downloader.downloadModel(defaultModel)
            let url = ModelManager.shared.url(for: LocalModel(displayName: defaultModel.displayName, folderName: defaultModel.name))
            await MainActor.run { 
                self.load(modelURL: url)
                self.isDownloadingInitialModel = false
            }
        } catch {
            await MainActor.run {
                DebugLog.shared.log("Default tiny model download failed: \(error.localizedDescription)")
                self.isDownloadingInitialModel = false
                self.modelLoadingStatus = "Download failed"
            }
        }
    }

    private func processQueuedIfNeeded() {
        guard let qp = queuedPrompt, isModelLoaded, !isGenerating, modelLoadingStatus.isEmpty else { return }
        queuedPrompt = nil
        // Re-exécuter avec le prompt en file
        let userPrompt = qp
        startSending(finalPrompt: userPrompt, userPrompt: userPrompt)
    }

    // Persistence
    private func persist() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(messages.map { PersistedBubble(role: $0.role == .user ? "user" : "assistant", text: $0.text) }) {
            UserDefaults.standard.set(data, forKey: "chat.history")
        }
        UserDefaults.standard.set(currentModel, forKey: "chat.modelName")
        UserDefaults.standard.set(backendName, forKey: "chat.backendName")
    }
    private func restore() -> Bool {
        guard let data = UserDefaults.standard.data(forKey: "chat.history") else { return false }
        if let persisted = try? JSONDecoder().decode([PersistedBubble].self, from: data) {
            self.messages = persisted.map { ChatBubble(role: $0.role == "user" ? .user : .assistant, text: $0.text) }
            // Restore model info if available
            self.currentModel = UserDefaults.standard.string(forKey: "chat.modelName") ?? "Qwen 2.5 0.5B"
            self.backendName = UserDefaults.standard.string(forKey: "chat.backendName") ?? "MLX"
            return true
        }
        return false
    }
}

private struct PersistedBubble: Codable { let role: String; let text: String }


