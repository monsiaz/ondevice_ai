import Foundation

struct LLMSelection {
    let llm: LocalLLM
    let backendName: String
}

enum LLMSelector {
    @MainActor
    static func select() -> LLMSelection {
        // Default: Apple FoundationModels when available. This is the baseline
        // experience for iOS 26+ devices with Apple Intelligence support.
        if DeviceInfo.current.supportsAppleIntelligence {
            print("🧠 Default: Apple FoundationModels - Neural Engine powered!")
            return LLMSelection(llm: AppleFoundationLLM(), backendName: "Neural Engine")
        }
        // Devices without Apple Intelligence will still start on Apple FM UI,
        // but the first generation will prompt to download a tiny local model.
        print("ℹ️ Apple Intelligence not available on this device; MLX will be offered via downloads.")
        return LLMSelection(llm: MLXLLM(), backendName: "MLX")
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
