import Foundation

struct DeviceInfo {
    static let current = DeviceInfo()
    
    let ramGB: Double
    let supportsAppleIntelligence: Bool

    private init() {
        self.ramGB = Double(ProcessInfo.processInfo.physicalMemory) / (1024 * 1024 * 1024)
        if #available(iOS 26.0, *) {
            // Basic gate: Apple Intelligence is available only on iOS 26+ devices that Apple enables.
            // We conservatively allow when running on iOS 26 or later; finer-grained checks can be
            // added if Apple exposes runtime APIs for exact device support.
            self.supportsAppleIntelligence = true
        } else {
            self.supportsAppleIntelligence = false
        }
    }
    
    var performanceTier: Int {
        if ramGB >= 10.0 {
            return 3 // iPhone 17 Pro level (estimé)
        } else if ramGB >= 8.0 {
            return 2 // iPhone 16 Pro level
        } else if ramGB >= 6.0 {
            return 1 // iPhone 15 Pro level
        } else {
            return 0 // Base models
        }
    }
}
