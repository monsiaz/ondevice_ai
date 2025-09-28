import SwiftUI

struct ResourcesView: View {
    @State private var deviceInfo = DeviceInfo.current
    @State private var selectedTab = 0
    @State private var showingLegalDocument: LegalDocument?
    
    enum LegalDocument: String, CaseIterable, Identifiable {
        case privacy = "Privacy Policy"
        case terms = "Terms of Service"  
        case licenses = "Licenses & Attributions"
        
        var fileName: String {
            switch self {
            case .privacy: return "Privacy"
            case .terms: return "Terms"
            case .licenses: return "Licenses"
            }
        }
        
        var icon: String {
            switch self {
            case .privacy: return "shield.lefthalf.filled"
            case .terms: return "doc.text"
            case .licenses: return "info.circle"
            }
        }
        
        var color: Color {
            switch self {
            case .privacy: return .blue
            case .terms: return .green
            case .licenses: return .orange
            }
        }
        
        var description: String {
            switch self {
            case .privacy: return "How we protect your data and privacy"
            case .terms: return "Terms and conditions for using OnDeviceAI"
            case .licenses: return "Third-party software and model licenses"
            }
        }
        
        var id: String { self.rawValue }
    }
    
    struct DeviceBenchmark: Identifiable {
        let id = UUID()
        let deviceName: String
        let ram: String
        let idealModels: [String]
        let color: Color
    }
    
    let benchmarks: [DeviceBenchmark] = [
        DeviceBenchmark(
            deviceName: "High-end devices (iPhone 17 Pro+)",
            ram: "10-12 GB",
            idealModels: ["SOLAR 10.7B", "Gemma 2 9B", "LLaVA 1.6"],
            color: .purple
        ),
        DeviceBenchmark(
            deviceName: "Pro devices (iPhone 16 Pro+)",
            ram: "8-10 GB",
            idealModels: ["Llama 3.1 8B", "Mistral Nemo 12B"],
            color: .blue
        ),
        DeviceBenchmark(
            deviceName: "Modern devices (iPhone 15 Pro+)",
            ram: "6-8 GB",
            idealModels: ["Gemma 2 2B", "Phi-3 Mini", "CodeGemma 2B"],
            color: .orange
        ),
        DeviceBenchmark(
            deviceName: "Standard devices",
            ram: "4-6 GB",
            idealModels: ["Qwen 2.5 0.5B", "TinyLlama 1.1B"],
            color: .green
        )
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Custom Tab Picker
            HStack(spacing: 0) {
                TabButton(title: "Models", systemImage: "chart.bar", isSelected: selectedTab == 0) {
                    withAnimation(.easeInOut(duration: 0.2)) { selectedTab = 0 }
                }
                TabButton(title: "Legal", systemImage: "shield", isSelected: selectedTab == 1) {
                    withAnimation(.easeInOut(duration: 0.2)) { selectedTab = 1 }
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            // Content
            TabView(selection: $selectedTab) {
                // Models Tab
                modelsView
                    .tag(0)
                
                // Legal Tab  
                legalView
                    .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut(duration: 0.3), value: selectedTab)
        }
        .navigationTitle("Resources")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $showingLegalDocument) { document in
            LegalDocumentView(document: document)
        }
    }
    
    private var modelsView: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "chart.bar.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(.blue)
                    Text("Model Recommendations")
                        .font(.title2.bold())
                    Text("Optimal AI models based on your device capabilities")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 20)
                
                // Your Device
                VStack(spacing: 16) {
                    HStack {
                        Image(systemName: "iphone")
                            .font(.title2)
                            .foregroundStyle(.blue)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Your Device")
                                .font(.headline)
                            Label("\(String(format: "%.1f", deviceInfo.ramGB)) GB RAM", systemImage: "memorychip")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        
                        // Performance indicator
                        let tier = getTierForRAM(deviceInfo.ramGB)
                        Circle()
                            .fill(tier.color)
                            .frame(width: 16, height: 16)
                            .overlay(
                                Text(getTierLabel(deviceInfo.ramGB))
                                    .font(.caption2.bold())
                                    .foregroundColor(.white)
                            )
                    }
                    .padding(20)
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(getTierForRAM(deviceInfo.ramGB).color.opacity(0.3), lineWidth: 1)
                    )
                }
                .padding(.horizontal)
                
                // Device Tiers
                VStack(spacing: 16) {
                    ForEach(benchmarks) { benchmark in
                        let isCurrentTier = isDeviceInTier(benchmark: benchmark, ramGB: deviceInfo.ramGB)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Circle()
                                    .fill(benchmark.color)
                                    .frame(width: 12, height: 12)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(benchmark.deviceName)
                                        .font(.headline)
                                        .lineLimit(2)
                                    Label(benchmark.ram + " RAM", systemImage: "memorychip")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                
                                if isCurrentTier {
                                    Text("YOUR TIER")
                                        .font(.caption2.bold())
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(benchmark.color)
                                        .cornerRadius(8)
                                }
                            }
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                                ForEach(benchmark.idealModels, id: \.self) { modelName in
                                    Text(modelName)
                                        .font(.caption.bold())
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(benchmark.color.opacity(isCurrentTier ? 0.25 : 0.15))
                                        .foregroundColor(benchmark.color)
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .padding(20)
                        .background(.ultraThinMaterial)
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(isCurrentTier ? benchmark.color.opacity(0.4) : Color.clear, lineWidth: 2)
                        )
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
        }
    }
    
    private var legalView: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "shield.checkerboard")
                        .font(.system(size: 40))
                        .foregroundStyle(.green)
                    Text("Legal & Privacy")
                        .font(.title2.bold())
                    Text("Transparent policies and licensing information")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 20)
                
                // Privacy Commitment Banner
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "lock.shield")
                            .font(.title2)
                            .foregroundStyle(.blue)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Privacy-First Design")
                                .font(.headline)
                                .foregroundColor(.blue)
                            Text("All processing happens on your device. No data leaves your iPhone.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                    
                    HStack(spacing: 20) {
                        PrivacyFeature(icon: "wifi.slash", text: "Offline AI", color: .green)
                        PrivacyFeature(icon: "eye.slash", text: "No Tracking", color: .orange)
                        PrivacyFeature(icon: "server.rack", text: "No Servers", color: .red)
                    }
                }
                .padding(20)
                .background(.ultraThinMaterial)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.blue.opacity(0.3), lineWidth: 1)
                )
                .padding(.horizontal)
                
                // Legal Documents
                VStack(spacing: 16) {
                    ForEach(LegalDocument.allCases) { document in
                        LegalDocumentCard(document: document) {
                            showingLegalDocument = document
                        }
                    }
                }
                .padding(.horizontal)
                
                // Footer info
                VStack(spacing: 8) {
                    Text("Last Updated: September 28, 2025")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("For questions: support@ondeviceai.app")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 24)
            }
        }
    }
    
    private func getTierForRAM(_ ramGB: Double) -> DeviceBenchmark {
        if ramGB >= 10 { return benchmarks[0] }
        else if ramGB >= 8 { return benchmarks[1] }
        else if ramGB >= 6 { return benchmarks[2] }
        else { return benchmarks[3] }
    }
    
    private func getTierLabel(_ ramGB: Double) -> String {
        if ramGB >= 10 { return "S" }
        else if ramGB >= 8 { return "A" }
        else if ramGB >= 6 { return "B" }
        else { return "C" }
    }
    
    private func isDeviceInTier(benchmark: DeviceBenchmark, ramGB: Double) -> Bool {
        let tier = getTierForRAM(ramGB)
        return tier.id == benchmark.id
    }
}

struct TabButton: View {
    let title: String
    let systemImage: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: systemImage)
                    .font(.system(size: 16, weight: isSelected ? .semibold : .regular))
                Text(title)
                    .font(.caption.weight(isSelected ? .semibold : .regular))
            }
            .foregroundColor(isSelected ? .accentColor : .secondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? Color.accentColor.opacity(0.1) : Color.clear)
            )
        }
        .buttonStyle(.plain)
    }
}

struct PrivacyFeature: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
            Text(text)
                .font(.caption2.weight(.medium))
                .foregroundStyle(.secondary)
        }
    }
}

struct LegalDocumentCard: View {
    let document: ResourcesView.LegalDocument
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: document.icon)
                    .font(.title2)
                    .foregroundStyle(document.color)
                    .frame(width: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(document.rawValue)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(document.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(20)
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}

struct LegalDocumentView: View {
    let document: ResourcesView.LegalDocument
    @Environment(\.dismiss) private var dismiss
    @State private var content = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                Text(content)
                    .font(.system(.body, design: .monospaced))
                    .padding()
            }
            .navigationTitle(document.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .onAppear {
            loadContent()
        }
    }
    
    private func loadContent() {
        if let path = Bundle.main.path(forResource: document.fileName, ofType: "txt"),
           let fileContent = try? String(contentsOfFile: path) {
            content = fileContent
        } else {
            content = "Unable to load document content."
        }
    }
}

