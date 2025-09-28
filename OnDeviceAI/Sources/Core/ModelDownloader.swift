import Foundation
import SwiftUI

struct AvailableModel: Identifiable, Codable {
    let id = UUID()
    let name: String
    let displayName: String
    let description: String
    let size: String
    let downloadURL: String
    let tags: [String]
    let deviceRequirement: String
    let performance: ModelPerformance
    var isRecommended: Bool = false
    let category: ModelCategory
    
    static var catalog: [AvailableModel] {
        var models: [AvailableModel] = [
            // Recommandés
            AvailableModel(
                name: "qwen2.5-0.5b-instruct-4bit",
                displayName: "Qwen 2.5 0.5B",
                description: "Ultra-fast, ideal for quick questions and simple tasks.",
                size: "350 MB",
                downloadURL: "https://huggingface.co/mlx-community/Qwen2.5-0.5B-Instruct-4bit/resolve/main/",
                tags: ["General", "Fast", "Lightweight"],
                deviceRequirement: "iPhone 15+",
                performance: .ultraFast,
                category: .recommended
            ),
            AvailableModel(
                name: "gemma-2-2b-it-4bit",
                displayName: "Gemma 2 2B",
                description: "Google's efficient model for creative tasks like writing.",
                size: "1.2 GB",
                downloadURL: "https://huggingface.co/mlx-community/gemma-2-2b-it-4bit/resolve/main/",
                tags: ["Creative", "Google", "Balanced"],
                deviceRequirement: "iPhone 15 Pro+",
                performance: .fast,
                category: .recommended
            ),
            AvailableModel(
                name: "Meta-Llama-3.1-8B-Instruct-4bit",
                displayName: "Llama 3.1 8B",
                description: "Meta's flagship model for complex reasoning and quality responses.",
                size: "4.2 GB",
                downloadURL: "https://huggingface.co/mlx-community/Meta-Llama-3.1-8B-Instruct-4bit/resolve/main/",
                tags: ["Complex", "High Quality", "Meta"],
                deviceRequirement: "iPhone 16 Pro+",
                performance: .highQuality,
                category: .recommended
            ),

            // Rapides & Légers
            AvailableModel(
                name: "TinyLlama-1.1B-Chat-v1.0-4bit",
                displayName: "TinyLlama 1.1B",
                description: "The smallest Llama, optimized for casual chat.",
                size: "650 MB",
                downloadURL: "https://huggingface.co/mlx-community/TinyLlama-1.1B-Chat-v1.0-4bit/resolve/main/",
                tags: ["Chat", "Tiny"],
                deviceRequirement: "iPhone 15+",
                performance: .ultraFast,
                category: .fastAndLight
            ),
            AvailableModel(
                name: "Phi-3-mini-4k-instruct-4bit",
                displayName: "Phi-3 Mini 4K",
                description: "Microsoft's compact model with strong reasoning.",
                size: "1.1 GB",
                downloadURL: "https://huggingface.co/mlx-community/Phi-3-mini-4k-instruct-4bit/resolve/main/",
                tags: ["Reasoning", "Microsoft"],
                deviceRequirement: "iPhone 15 Pro+",
                performance: .fast,
                category: .fastAndLight
            ),

            // Puissants & Polyvalents
            AvailableModel(
                name: "Mistral-Nemo-Instruct-2407-4bit",
                displayName: "Mistral Nemo 12B",
                description: "Advanced reasoning and multilingual capabilities.",
                size: "2.4 GB",
                downloadURL: "https://huggingface.co/mlx-community/Mistral-Nemo-Instruct-2407-4bit/resolve/main/",
                tags: ["Multilingual", "Reasoning", "Advanced"],
                deviceRequirement: "iPhone 16+",
                performance: .balanced,
                category: .powerful
            ),
            AvailableModel(
                name: "gemma-2-9b-it-4bit",
                displayName: "Gemma 2 9B",
                description: "Google's powerful model for demanding applications.",
                size: "5.1 GB",
                downloadURL: "https://huggingface.co/mlx-community/gemma-2-9b-it-4bit/resolve/main/",
                tags: ["Creative", "Google", "Large"],
                deviceRequirement: "iPhone 17 Pro+",
                performance: .highQuality,
                category: .powerful
            ),
            AvailableModel(
                name: "SOLAR-10.7B-Instruct-v1.0-4bit",
                displayName: "SOLAR 10.7B",
                description: "Upstage's premium model for complex reasoning and analysis.",
                size: "5.8 GB",
                downloadURL: "https://huggingface.co/mlx-community/SOLAR-10.7B-Instruct-v1.0-4bit/resolve/main/",
                tags: ["Premium", "Reasoning", "Advanced"],
                deviceRequirement: "iPhone 17 Pro+",
                performance: .premium,
                category: .powerful
            ),

            // Spécialisés (Code, Vision)
            AvailableModel(
                name: "CodeGemma-1.1-2b-it-4bit",
                displayName: "CodeGemma 2B",
                description: "Google's specialized assistant for code generation and explanation.",
                size: "1.3 GB",
                downloadURL: "https://huggingface.co/mlx-community/CodeGemma-1.1-2b-it-4bit/resolve/main/",
                tags: ["Coding", "Google", "Fast"],
                deviceRequirement: "iPhone 15 Pro+",
                performance: .fast,
                category: .specialized
            ),
            AvailableModel(
                name: "llava-v1.6-mistral-7b-hf-4bit",
                displayName: "LLaVA 1.6 Mistral 7B",
                description: "Vision-language model to analyze photos and describe scenes.",
                size: "4.8 GB",
                downloadURL: "https://huggingface.co/mlx-community/llava-v1.6-mistral-7b-hf-4bit/resolve/main/",
                tags: ["Vision", "Multimodal", "High Quality"],
                deviceRequirement: "iPhone 17+",
                performance: .highQuality,
                category: .specialized
            ),
            AvailableModel(
                name: "OpenELM-450M-Instruct-4bit",
                displayName: "OpenELM 450M",
                description: "Apple's extremely efficient and lightweight instruction-following model.",
                size: "260 MB",
                downloadURL: "https://huggingface.co/mlx-community/OpenELM-450M-Instruct-4bit/resolve/main/",
                tags: ["Apple", "Efficient", "Tiny"],
                deviceRequirement: "iPhone 15+",
                performance: .ultraFast,
                category: .fastAndLight
            ),
            AvailableModel(
                name: "Qwen2-7B-Instruct-4bit",
                displayName: "Qwen2 7B",
                description: "A powerful model from Alibaba with strong multilingual capabilities.",
                size: "4.1 GB",
                downloadURL: "https://huggingface.co/mlx-community/Qwen2-7B-Instruct-4bit/resolve/main/",
                tags: ["Multilingual", "Flagship", "Qwen"],
                deviceRequirement: "iPhone 16 Pro+",
                performance: .highQuality,
                category: .powerful
            )
        ]
        
        return models
    }
}

enum ModelCategory: String, CaseIterable, Codable {
    case recommended = "Recommended for you"
    case fastAndLight = "Fast & Light"
    case powerful = "Powerful & Versatile"
    case specialized = "Specialized (Code, Vision)"
}

enum ModelPerformance: String, CaseIterable, Codable {
    case ultraFast = "Ultra Fast"
    case fast = "Fast"
    case balanced = "Balanced"
    case highQuality = "High Quality"
    case premium = "Premium"
    
    var color: Color {
        switch self {
        case .ultraFast: return .green
        case .fast: return .blue
        case .balanced: return .orange
        case .highQuality: return .purple
        case .premium: return .red
        }
    }
}

@MainActor
final class ModelDownloader: ObservableObject {
    @Published var downloadProgress: [String: Double] = [:]
    @Published var isDownloading: [String: Bool] = [:]
    @Published var downloaded: Set<String> = [] // folder names already present
    
    func downloadModel(_ model: AvailableModel) async throws {
        // If already downloaded, bail early
        let targetDir = ModelManager.shared.url(for: LocalModel(displayName: model.displayName, folderName: model.name))
        if FileManager.default.fileExists(atPath: targetDir.path) {
            downloaded.insert(model.name)
            return
        }
        isDownloading[model.name] = true
        downloadProgress[model.name] = 0.0
        
        let modelDir = targetDir
        
        try FileManager.default.createDirectory(at: modelDir, withIntermediateDirectories: true)
        
        // Download essential files for MLX models
        let files = ["config.json", "model.safetensors", "tokenizer.json", "tokenizer_config.json"]
        
        for (index, file) in files.enumerated() {
            let url = URL(string: model.downloadURL + file)!
            let (data, _) = try await URLSession.shared.data(from: url)
            let fileURL = modelDir.appendingPathComponent(file)
            try data.write(to: fileURL)
            
            downloadProgress[model.name] = Double(index + 1) / Double(files.count)
        }
        
        isDownloading[model.name] = false
        downloadProgress[model.name] = 1.0
        downloaded.insert(model.name)
    }
    
    func cancelDownload(_ modelName: String) {
        isDownloading[modelName] = false
        downloadProgress[modelName] = 0.0
    }
}
