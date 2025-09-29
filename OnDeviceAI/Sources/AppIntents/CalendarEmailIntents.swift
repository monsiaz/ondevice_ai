import AppIntents
import Foundation

@available(iOS 17.0, *)
struct CheckCalendarAndDraftEmail: AppIntent {
    static var title: LocalizedStringResource = "Check Calendar & Draft Email"
    static var description = IntentDescription("Checks today's next calendar event title (conceptual placeholder) and drafts an apology email text.")

    @Parameter(title: "Delay (minutes)")
    var delayMinutes: Int

    func perform() async throws -> some IntentResult & ProvidesDialog {
        // Placeholder: EventKit requires explicit permissions and UI. We return a draft string for now.
        let minutes = max(1, delayMinutes)
        let draft = "Hello, I will be about \(minutes) minute(s) late to our meeting. Thank you for your understanding."
        return .result(dialog: "Draft prepared:", result: draft)
    }
}


