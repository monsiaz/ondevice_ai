import Foundation
import EventKit
import UIKit

enum CalendarActions {
    static func addEvent(with text: String) {
        let store = EKEventStore()
        store.requestAccess(to: .event) { granted, _ in
            guard granted else { return }
            let event = EKEvent(eventStore: store)
            event.title = text.components(separatedBy: "\n").first ?? "OnDeviceAI Event"
            event.startDate = Date().addingTimeInterval(3600)
            event.endDate = event.startDate.addingTimeInterval(3600)
            event.calendar = store.defaultCalendarForNewEvents
            do { try store.save(event, span: .thisEvent, commit: true) } catch {}
        }
    }

    static func addReminder(with text: String) {
        let store = EKEventStore()
        store.requestAccess(to: .reminder) { granted, _ in
            guard granted else { return }
            let reminder = EKReminder(eventStore: store)
            reminder.title = text.components(separatedBy: "\n").first ?? "OnDeviceAI Reminder"
            reminder.calendar = store.defaultCalendarForNewReminders()
            do { try store.save(reminder, commit: true) } catch {}
        }
    }

    static func saveToNotes(with text: String) {
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .rootViewController?
            .present(activityVC, animated: true)
    }
}


