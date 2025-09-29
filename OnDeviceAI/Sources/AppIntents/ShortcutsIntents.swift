import AppIntents
import EventKit
import UIKit

@available(iOS 16.0, *)
struct AddToCalendarIntent: AppIntent {
    static var title: LocalizedStringResource = "Add to Calendar"
    static var description = IntentDescription("Add text to your calendar as an event")
    
    @Parameter(title: "Text")
    var text: String
    
    @Parameter(title: "Date", default: Date().addingTimeInterval(3600))
    var date: Date
    
    func perform() async throws -> some IntentResult {
        let store = EKEventStore()
        try await store.requestAccess(to: .event)
        
        let event = EKEvent(eventStore: store)
        event.title = text.components(separatedBy: "\n").first ?? "OnDeviceAI Event"
        event.startDate = date
        event.endDate = date.addingTimeInterval(3600)
        event.calendar = store.defaultCalendarForNewEvents
        
        try store.save(event, span: .thisEvent, commit: true)
        
        return .result(value: "Event added to calendar")
    }
}

@available(iOS 16.0, *)
struct CreateReminderIntent: AppIntent {
    static var title: LocalizedStringResource = "Create Reminder"
    static var description = IntentDescription("Create a reminder from text")
    
    @Parameter(title: "Text")
    var text: String
    
    @Parameter(title: "Due Date", default: Date().addingTimeInterval(86400))
    var dueDate: Date
    
    func perform() async throws -> some IntentResult {
        let store = EKEventStore()
        try await store.requestAccess(to: .reminder)
        
        let reminder = EKReminder(eventStore: store)
        reminder.title = text.components(separatedBy: "\n").first ?? "OnDeviceAI Reminder"
        reminder.calendar = store.defaultCalendarForNewReminders()
        reminder.dueDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
        
        try store.save(reminder, commit: true)
        
        return .result(value: "Reminder created")
    }
}

@available(iOS 16.0, *)
struct SaveToNotesIntent: AppIntent {
    static var title: LocalizedStringResource = "Save to Notes"
    static var description = IntentDescription("Share text to Notes or other apps")
    
    @Parameter(title: "Text")
    var text: String
    
    func perform() async throws -> some IntentResult {
        // For Shortcuts, we can't present UIActivityViewController directly
        // Instead, return the text so user can use Share action in Shortcuts
        return .result(value: text)
    }
}

@available(iOS 16.0, *)
struct OnDeviceAIShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AddToCalendarIntent(),
            phrases: ["Add \(\.$text) to calendar in \(.applicationName)"],
            shortTitle: "Add to Calendar",
            systemImageName: "calendar.badge.plus"
        )
        AppShortcut(
            intent: CreateReminderIntent(),
            phrases: ["Create reminder for \(\.$text) in \(.applicationName)"],
            shortTitle: "Create Reminder",
            systemImageName: "checklist"
        )
        AppShortcut(
            intent: SaveToNotesIntent(),
            phrases: ["Save \(\.$text) to notes in \(.applicationName)"],
            shortTitle: "Save to Notes",
            systemImageName: "note.text"
        )
    }
}
