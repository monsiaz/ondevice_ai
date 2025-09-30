import SwiftUI
import UIKit

@main
struct OnDeviceAIApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.openURL) private var openURL
    @StateObject private var chatVM: ChatVM
    
    @AppStorage("appTheme") private var appTheme: String = "system"

    init() {
        let initialLLM = LLMSelector.select()
        let vm = ChatVM(llm: initialLLM.llm, backendName: initialLLM.backendName)
        _chatVM = StateObject(wrappedValue: vm)
        
        // Register URL scheme
        URLScheme.registerHandlers()
    }

    var body: some Scene {
        WindowGroup {
            RootView(vm: chatVM)
                .preferredColorScheme(appTheme == "light" ? .light : (appTheme == "dark" ? .dark : nil))
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didReceiveMemoryWarningNotification)) { _ in
                    // Décharger immédiatement en cas de pression mémoire
                    chatVM.unloadModel()
                }
                .task {
                    // Auto-install recommended models on first launch
                    await autoInstallRecommendedModels()
                }
                .onReceive(NotificationCenter.default.publisher(for: Notification.Name("Siri.AskQuestion"))) { notif in
                    if let question = notif.object as? String {
                        chatVM.input = question
                        chatVM.send()
                    }
                }
                .onOpenURL { url in
                    handleURL(url)
                }
        }
        .onChange(of: scenePhase) { _, newPhase in
            switch newPhase {
            case .background:
                HistoryStore.shared.upsertCurrent(from: chatVM)
                // Ne pas décharger immédiatement - donner du temps pour revenir
                Task {
                    try? await Task.sleep(nanoseconds: 30_000_000_000) // 30 seconds
                    // Si toujours en arrière-plan après 30s, décharger
                    if self.scenePhase == .background {
                        await MainActor.run {
                            chatVM.unloadModel()
                        }
                    }
                }
            case .active:
                // Rien à faire - le modèle sera rechargé automatiquement si nécessaire
                break
            case .inactive:
                // Sauvegarder mais ne pas décharger
                HistoryStore.shared.upsertCurrent(from: chatVM)
            @unknown default:
                break
            }
        }
    }
    
    private func handleURL(_ url: URL) {
        guard url.scheme == "ondeviceai" else { return }
        
        if url.host == "analyze",
           let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
           let textItem = components.queryItems?.first(where: { $0.name == "text" }),
           let text = textItem.value?.removingPercentEncoding {
            chatVM.input = text
            chatVM.send()
        }
    }
}

enum URLScheme {
    static func registerHandlers() {
        // URL scheme registered in Info.plist: ondeviceai://
        print("📱 URL scheme registered: ondeviceai://")
    }
}

extension OnDeviceAIApp {
    private func autoInstallRecommendedModels() async {
        // Check if models already installed
        let hasModels = !ModelManager.shared.listInstalled().isEmpty
        guard !hasModels else {
            print("📦 Models already installed, skipping auto-install")
            return
        }
        
        // Auto-download Qwen and TinyLlama on first launch
        print("📥 First launch: auto-installing recommended models...")
        
        let qwen = AvailableModel(
            name: "qwen2.5-0.5b-instruct-4bit",
            displayName: "Qwen 2.5 0.5B",
            description: "Ultra-fast, ideal for quick questions",
            size: "350 MB",
            downloadURL: "https://huggingface.co/mlx-community/Qwen2.5-0.5B-Instruct-4bit/resolve/main/",
            tags: ["Fast", "Recommended"],
            deviceRequirement: "iPhone 15+",
            performance: .ultraFast,
            category: .recommended
        )
        
        let downloader = ModelDownloader()
        do {
            try await downloader.downloadModel(qwen)
            print("✅ Qwen installed successfully")
        } catch {
            print("⚠️ Failed to install Qwen: \(error)")
        }
    }
}
