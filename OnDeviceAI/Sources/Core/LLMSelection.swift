import Foundation

struct LLMSelection {
    let llm: LocalLLM
    let backendName: String
}

enum LLMSelector {
    @MainActor
    static func select() -> LLMSelection {
        #if canImport(FoundationModels)
        return LLMSelection(llm: AppleFoundationLLM(), backendName: "Apple FM")
        #else
        return LLMSelection(llm: MLXLLM(), backendName: "MLX")
        #endif
    }
}
