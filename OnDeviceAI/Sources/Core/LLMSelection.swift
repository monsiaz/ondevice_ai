import Foundation

struct LLMSelection {
    let llm: LocalLLM
    let backendName: String
}

enum LLMSelector {
    @MainActor
    static func select() -> LLMSelection {
        // Default: Apple FoundationModels for system-level AI (Neural Engine)
        print("🧠 Default: Apple FoundationModels - Neural Engine powered!")
        return LLMSelection(llm: AppleFoundationLLM(), backendName: "Neural Engine")
    }
    
    @MainActor
    static func selectForModel(_ modelName: String) -> LLMSelection {
        let lowercaseName = modelName.lowercased()
        
        // Use Apple FM for system/default models
        if modelName.isEmpty || lowercaseName.contains("default") || lowercaseName.contains("system") {
            print("🧠 Using Apple FoundationModels for default model")
            return LLMSelection(llm: AppleFoundationLLM(), backendName: "Neural Engine")
        }
        
        // Use MLX for downloaded custom models (Qwen, LLaMA, etc.)
        if lowercaseName.contains("qwen") || lowercaseName.contains("llama") || 
           lowercaseName.contains("mistral") || lowercaseName.contains("gemma") ||
           lowercaseName.contains("phi") || lowercaseName.contains("code") {
            print("🔧 Using MLX for custom model: \(modelName)")
            return LLMSelection(llm: MLXLLM(), backendName: "MLX")
        }
        
        // Fallback to MLX for any downloaded model
        print("🔧 Using MLX for downloaded model: \(modelName)")
        return LLMSelection(llm: MLXLLM(), backendName: "MLX")
    }
}
