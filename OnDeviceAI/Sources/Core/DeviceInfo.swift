import Foundation

struct DeviceInfo {
    static let current = DeviceInfo()
    
    let ramGB: Double

    private init() {
        self.ramGB = Double(ProcessInfo.processInfo.physicalMemory) / (1024 * 1024 * 1024)
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
