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

        // Note: No bundled models since v1.2 (removed to avoid App Store routing app detection)
        // Models are now downloaded on-demand for enhanced flexibility
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
                    // La logique de configuration initiale est maintenant dans ChatVM
                }
                .onReceive(NotificationCenter.default.publisher(for: Notification.Name("Action.AddToCalendar"))) { notif in
                    if let text = notif.object as? String { CalendarActions.addEvent(with: text) }
                }
                .onReceive(NotificationCenter.default.publisher(for: Notification.Name("Action.CreateReminder"))) { notif in
                    if let text = notif.object as? String { CalendarActions.addReminder(with: text) }
                }
                .onReceive(NotificationCenter.default.publisher(for: Notification.Name("Action.SaveToNotes"))) { notif in
                    if let text = notif.object as? String { CalendarActions.saveToNotes(with: text) }
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
