import Foundation
import SwiftUI

struct Conversation: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var messages: [HistoryMessage]
    var updatedAt: Date
    var modelName: String
    var backendName: String
}

struct HistoryMessage: Codable, Equatable {
    var role: String
    var text: String
}

@MainActor
final class HistoryStore: ObservableObject {
    static let shared = HistoryStore()
    
    @Published var conversations: [Conversation] = []
    @Published var query: String = ""

    private let url: URL

    private init() {
        url = try! FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("history.json")
        load()
        if conversations.isEmpty && !UserDefaults.standard.bool(forKey: "didCreateFakeHistory") {
            createFakeHistory()
            UserDefaults.standard.set(true, forKey: "didCreateFakeHistory")
        }
    }

    func createFakeHistory() {
        print("Creating fake history for testing...")
        self.conversations = [
            Conversation(id: UUID(), title: "Planning a trip to Japan", messages: [HistoryMessage(role: "user", text: "Help me plan a 10-day trip to Japan."), HistoryMessage(role: "assistant", text: "Of course! For a 10-day trip, I'd recommend focusing on Tokyo and Kyoto...")], updatedAt: Date().addingTimeInterval(-86400 * 2), modelName: "Gemma 2 2B", backendName: "MLX"),
            Conversation(id: UUID(), title: "Recipe for Carbonara", messages: [HistoryMessage(role: "user", text: "What's a classic recipe for Spaghetti Carbonara?"), HistoryMessage(role: "assistant", text: "A traditional Carbonara uses guanciale, eggs, Pecorino Romano, and black pepper. No cream!")], updatedAt: Date().addingTimeInterval(-86400), modelName: "Qwen 2.5 0.5B", backendName: "MLX"),
            Conversation(id: UUID(), title: "Learning about SwiftUI", messages: [HistoryMessage(role: "user", text: "Explain what @State is in SwiftUI."), HistoryMessage(role: "assistant", text: "@State is a property wrapper that allows you to modify values inside a struct, which would normally not be allowed, so that the view can update and re-render itself.")], updatedAt: Date(), modelName: "Qwen 2.5 0.5B", backendName: "MLX")
        ]
        save()
    }
    
    func load() {
        guard let data = try? Data(contentsOf: url) else { return }
        if let convs = try? JSONDecoder().decode([Conversation].self, from: data) {
            conversations = convs.sorted { $0.updatedAt > $1.updatedAt }
        }
    }

    func save() {
        let data = try? JSONEncoder().encode(conversations)
        if let data { try? data.write(to: url) }
    }

    func upsertCurrent(from vm: ChatVM) {
        guard vm.messages.count > 1 else { return }
        let title: String = {
            if let firstUser = vm.messages.first(where: { $0.role == .user })?.text {
                return String(firstUser.prefix(60))
            } else {
                return "Conversation"
            }
        }()
        let mapped = vm.messages.map { HistoryMessage(role: $0.role == .user ? "user" : "assistant", text: $0.text) }
        
        conversations.insert(Conversation(
            id: UUID(),
            title: title,
            messages: mapped,
            updatedAt: Date(),
            modelName: vm.currentModel,
            backendName: vm.backendName
        ), at: 0)
        
        // Keep only the 10 most recent conversations
        if conversations.count > 10 {
            conversations = Array(conversations.prefix(10))
        }
        
        save()
    }

    func clearAll() {
        conversations = []
        save()
    }

    var filtered: [Conversation] {
        guard !query.isEmpty else { return conversations }
        let q = query.lowercased()
        return conversations.filter { c in
            c.title.lowercased().contains(q) || c.messages.contains { $0.text.lowercased().contains(q) }
        }
    }
}


