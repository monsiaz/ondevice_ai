import SwiftUI
import UIKit

@main
struct OnDeviceAIApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var chatVM: ChatVM
    
    @AppStorage("appTheme") private var appTheme: String = "system"

    init() {
        let initialLLM = LLMSelector.select()
        let vm = ChatVM(llm: initialLLM.llm, backendName: initialLLM.backendName)
        _chatVM = StateObject(wrappedValue: vm)

        // Ensure a default MLX model is installed to appear in selectors
        // Use the lightweight bundled Qwen by default if present
        if let _ = Bundle.main.url(forResource: "qwen2.5-0.5b-instruct-4bit", withExtension: nil) {
            ModelManager.shared.installBundledModelIfNeeded(folderName: "qwen2.5-0.5b-instruct-4bit", displayName: "Qwen 2.5 0.5B")
        }
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
}
