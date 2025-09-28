import SwiftUI

struct ModelBenchmarksView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Device & Model Compatibility")
                        .font(.title2.bold())
                    Text("Choose the right model for your device to get optimal performance.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal)
                
                // Device compatibility table
                VStack(spacing: 12) {
                    Text("iPhone Compatibility Guide")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    DeviceTable()
                }
                
                // Model benchmarks
                VStack(spacing: 16) {
                    Text("Model Performance Benchmarks")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    BenchmarkCard(
                        modelName: "Qwen 2.5 0.5B",
                        size: "350 MB",
                        iphone15: "25 tok/s",
                        iphone16: "35 tok/s", 
                        iphone17: "45 tok/s",
                        quality: "Basic",
                        useCases: ["Quick Q&A", "Simple chat", "Fast responses"]
                    )
                    
                    BenchmarkCard(
                        modelName: "Gemma 2 2B",
                        size: "1.2 GB",
                        iphone15: "15 tok/s",
                        iphone16: "25 tok/s",
                        iphone17: "35 tok/s", 
                        quality: "Good",
                        useCases: ["Creative writing", "Conversations", "Content creation"]
                    )
                    
                    BenchmarkCard(
                        modelName: "Llama 3.2 3B",
                        size: "1.8 GB",
                        iphone15: "10 tok/s",
                        iphone16: "20 tok/s",
                        iphone17: "30 tok/s",
                        quality: "High",
                        useCases: ["Complex reasoning", "Analysis", "Professional tasks"]
                    )
                    
                    BenchmarkCard(
                        modelName: "Llama 3.1 8B",
                        size: "4.2 GB",
                        iphone15: "N/A",
                        iphone16: "12 tok/s",
                        iphone17: "20 tok/s",
                        quality: "Premium",
                        useCases: ["Research", "Detailed analysis", "Expert-level tasks"]
                    )
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Benchmarks")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DeviceTable: View {
    private let devices = [
        ("iPhone 17 Pro Max", "A19 Pro", "12 GB", "SOLAR 10.7B, Llama 8B"),
        ("iPhone 17 Pro", "A19 Pro", "10 GB", "Llama 8B, Qwen 7B"),
        ("iPhone 17", "A19", "8 GB", "Llama 3.2 3B, Gemma 2B"),
        ("iPhone 16 Pro Max", "A18 Pro", "8 GB", "Llama 8B, Code Llama"),
        ("iPhone 16 Pro", "A18 Pro", "8 GB", "Llama 3.2 3B, Mistral"),
        ("iPhone 16/Plus", "A18", "8 GB", "Gemma 2B, Qwen 1.5B"),
        ("iPhone 15 Pro Max", "A17 Pro", "8 GB", "Llama 3.2 3B, Phi-3"),
        ("iPhone 15 Pro", "A17 Pro", "8 GB", "Qwen 1.5B, Gemma 2B"),
        ("iPhone 15/Plus", "A16", "6 GB", "TinyLlama, Qwen 0.5B")
    ]
    
    var body: some View {
        VStack(spacing: 8) {
            // Table header
            HStack {
                Text("Device")
                    .font(.caption.weight(.semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Chip")
                    .font(.caption.weight(.semibold))
                    .frame(width: 60, alignment: .center)
                Text("RAM")
                    .font(.caption.weight(.semibold))
                    .frame(width: 50, alignment: .center)
                Text("Best Models")
                    .font(.caption.weight(.semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial)
            .cornerRadius(8)
            
            // Table rows
            ForEach(Array(devices.enumerated()), id: \.offset) { index, device in
                HStack {
                    Text(device.0)
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(device.1)
                        .font(.caption2)
                        .frame(width: 60, alignment: .center)
                    Text(device.2)
                        .font(.caption2.weight(.medium))
                        .frame(width: 50, alignment: .center)
                    Text(device.3)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(2)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(index % 2 == 0 ? Color.clear : Color.gray.opacity(0.05))
            }
        }
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct BenchmarkCard: View {
    let modelName: String
    let size: String
    let iphone15: String
    let iphone16: String
    let iphone17: String
    let quality: String
    let useCases: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(modelName)
                    .font(.headline.weight(.semibold))
                Spacer()
                Text(size)
                    .font(.caption.weight(.medium))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(.blue.opacity(0.15))
                    .foregroundColor(.blue)
                    .cornerRadius(6)
            }
            
            // Performance table
            VStack(spacing: 6) {
                HStack {
                    Text("Device")
                        .font(.caption.weight(.medium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Speed")
                        .font(.caption.weight(.medium))
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .foregroundStyle(.secondary)
                
                Divider()
                
                PerformanceRow(device: "iPhone 15 Pro", speed: iphone15)
                PerformanceRow(device: "iPhone 16 Pro", speed: iphone16)
                PerformanceRow(device: "iPhone 17 Pro", speed: iphone17)
            }
            .padding(10)
            .background(.gray.opacity(0.05))
            .cornerRadius(8)
            
            // Use cases
            VStack(alignment: .leading, spacing: 4) {
                Text("Best for:")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
                
                ForEach(useCases, id: \.self) { useCase in
                    Text("• \(useCase)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
    }
}

struct PerformanceRow: View {
    let device: String
    let speed: String
    
    var body: some View {
        HStack {
            Text(device)
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(speed)
                .font(.caption.weight(.medium))
                .foregroundColor(speed == "N/A" ? .secondary : .primary)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}
