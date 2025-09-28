import Foundation

public protocol LocalLLM {
    func load(modelURL: URL) throws
    func generate(prompt: String, onToken: @escaping (String) -> Void) throws
    func unload()
}
