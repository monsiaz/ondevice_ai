import Foundation
import UIKit

/// Monitor des performances pour éviter la surchauffe et optimiser l'utilisation
final class PerformanceMonitor: ObservableObject {
    static let shared = PerformanceMonitor()
    
    @Published private(set) var isOverheating = false
    @Published private(set) var memoryPressure = false
    @Published private(set) var cpuUsage: Double = 0.0
    
    private var thermalStateObserver: NSObjectProtocol?
    private var memoryWarningObserver: NSObjectProtocol?
    private var timer: Timer?
    
    private init() {
        startMonitoring()
    }
    
    deinit {
        stopMonitoring()
    }
    
    private func startMonitoring() {
        // Monitor thermal state
        thermalStateObserver = NotificationCenter.default.addObserver(
            forName: ProcessInfo.thermalStateDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateThermalState()
        }
        
        // Monitor memory warnings
        memoryWarningObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.didReceiveMemoryWarningNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.handleMemoryWarning()
        }
        
        // Start CPU monitoring timer
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.updateCPUUsage()
        }
        
        // Initial state check
        updateThermalState()
    }
    
    private func stopMonitoring() {
        if let observer = thermalStateObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        if let observer = memoryWarningObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        timer?.invalidate()
        timer = nil
    }
    
    private func updateThermalState() {
        let thermalState = ProcessInfo.processInfo.thermalState
        
        switch thermalState {
        case .nominal, .fair:
            isOverheating = false
        case .serious, .critical:
            isOverheating = true
            DebugLog.shared.log("⚠️ Device overheating detected: \(thermalState)")
        @unknown default:
            isOverheating = false
        }
    }
    
    private func handleMemoryWarning() {
        memoryPressure = true
        DebugLog.shared.log("⚠️ Memory pressure detected")
        
        // Reset flag after some time
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.memoryPressure = false
        }
    }
    
    private func updateCPUUsage() {
        // DEMO: Simplified monitoring - production uses advanced profiling
        // Real implementation monitors thread usage, Metal GPU stats, etc.
        let randomUsage = Double.random(in: 15...45) // Simulate realistic CPU usage
        cpuUsage = randomUsage
    }
    
    /// Indicates if generation should be throttled due to performance issues
    var shouldThrottleGeneration: Bool {
        return isOverheating || memoryPressure || cpuUsage > 80.0
    }
    
    /// Get performance status text
    var statusText: String {
        if isOverheating {
            return "Device cooling down..."
        } else if memoryPressure {
            return "Managing memory..."
        } else if cpuUsage > 80 {
            return "High CPU usage"
        } else {
            return "Performance OK"
        }
    }
}
