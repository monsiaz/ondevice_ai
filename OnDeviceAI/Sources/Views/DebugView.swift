import SwiftUI

struct DebugView: View {
    @StateObject private var log = DebugLog.shared
    @State private var copied = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Debug & Memory Log").font(.headline)
                Spacer()
                Button("Copy") {
                    UIPasteboard.general.string = header() + "\n\n" + log.text
                    copied = true
                }
                .buttonStyle(.bordered)
            }
            .padding(.horizontal)
            .padding(.top)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    Text(header())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                    Divider()
                    Text(log.text.isEmpty ? "No logs yet." : log.text)
                        .font(.system(.footnote, design: .monospaced))
                        .padding(.horizontal)
                        .textSelection(.enabled)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .overlay(alignment: .topTrailing) {
                if copied { Text("Copied").font(.caption2).padding(6).background(.thinMaterial).cornerRadius(6).padding(.trailing, 12) }
            }
            
            HStack {
                Button("Refresh Stats") { DebugLog.shared.log("RAM: \(String(format: "%.1f", MemoryStats.currentUsageMB())) MB in use") }
                Button("Clear Log", role: .destructive) { DebugLog.shared.clear() }
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Debug")
        .onAppear {
            DebugLog.shared.log("Opened DebugView. RAM: \(String(format: "%.1f", MemoryStats.currentUsageMB())) MB")
        }
    }
    
    private func header() -> String {
        let ram = String(format: "%.1f", DeviceInfo.current.ramGB)
        let mem = String(format: "%.1f", MemoryStats.currentUsageMB())
        return "Device RAM: \(ram) GB • Current usage: \(mem) MB"
    }
}


