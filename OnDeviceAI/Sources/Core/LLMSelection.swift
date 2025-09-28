import Foundation

struct LLMSelection {
    let llm: LocalLLM
    let backendName: String
}

enum LLMSelector {
    @MainActor
    static func select() -> LLMSelection {
        // Always use MLX for demo version - Apple FM requires iOS 26+
        return LLMSelection(llm: MLXLLM(), backendName: "MLX")
    }
}
