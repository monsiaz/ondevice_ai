import AppIntents
import Foundation

@available(iOS 16.0, *)
struct AskOnDeviceAIIntent: AppIntent {
    static var title: LocalizedStringResource = "Ask OnDeviceAI"
    static var description = IntentDescription("Ask a question to OnDeviceAI and get an AI-powered answer")
    
    @Parameter(title: "Question")
    var question: String
    
    static var parameterSummary: some ParameterSummary {
        Summary("Ask \(\.$question)")
    }
    
    func perform() async throws -> some IntentResult & ProvidesDialog & ReturnsValue<String> {
        // In a real Shortcuts integration, this would:
        // 1. Load the AI model
        // 2. Generate a response
        // 3. Return the answer
        
        // For now, we return a placeholder that indicates the app should open
        let response = "Opening OnDeviceAI to answer: \(question)"
        
        // Post notification to trigger app to handle this
        await MainActor.run {
            NotificationCenter.default.post(
                name: Notification.Name("Siri.AskQuestion"),
                object: question
            )
        }
        
        return .result(
            value: response,
            dialog: "I'll help you with: \(question)"
        )
    }
}

@available(iOS 16.0, *)
struct OnDeviceAISiriShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AskOnDeviceAIIntent(),
            phrases: [
                "Ask \(\.$question) in \(.applicationName)",
                "Use \(.applicationName) to answer \(\.$question)",
                "\(.applicationName) \(\.$question)"
            ],
            shortTitle: "Ask AI",
            systemImageName: "brain.head.profile"
        )
    }
}
