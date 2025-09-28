import Foundation
import SwiftUI

@MainActor
final class DebugLog: ObservableObject {
    static let shared = DebugLog()
    @Published private(set) var entries: [String] = []
    private init() {}
    
    func log(_ message: String) {
        let timestamp = ISO8601DateFormatter().string(from: Date())
        entries.append("[\(timestamp)] \(message)")
        if entries.count > 1000 { entries.removeFirst(entries.count - 1000) }
    }
    
    var text: String { entries.joined(separator: "\n") }
    
    func clear() { entries.removeAll() }
}

struct MemoryStats {
    static func currentUsageMB() -> Double {
        // Simplified placeholder; replace with precise mach-based impl if needed
        return -1
    }
}

