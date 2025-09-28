import Foundation

#if canImport(FoundationModels)
import FoundationModels

@available(iOS 26.0, *)
@MainActor
final class AppleFoundationLLM: LocalLLM {
    private var session: LanguageModelSession?
    private var currentTask: Task<Void, Never>?

    func load(modelURL: URL) throws {
        // No external URL needed for system model; create session lazily in generate
    }

    func unload() {
        currentTask?.cancel()
        currentTask = nil
        session = nil
    }

    func generate(prompt: String, onToken: @escaping (String) -> Void) throws {
        if session == nil {
            // Configure a simple instruction; adjust as needed
            let instructions = "You are a helpful assistant. Answer concisely."
            session = LanguageModelSession(model: .default, tools: [], instructions: instructions)
            session?.prewarm()
        }
        guard let session else { throw NSError(domain: "AppleFM", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to create session"]) }

        // Cancel any previous generation task
        currentTask?.cancel()
        
        // If session is busy, wait politely then try again
        currentTask = Task {
            // Wait for previous response to finish
            while session.isResponding {
                try? await Task.sleep(nanoseconds: 100_000_000) // 100ms
            }
            
            // Now we can safely start the new generation
            let stream: LanguageModelSession.ResponseStream<String> = session.streamResponse(to: prompt)
            do {
                var iterator = stream.makeAsyncIterator()
                var previous = ""
                while let snapshot = try await iterator.next() {
                    let current = snapshot.content
                    if current.count >= previous.count {
                        let delta = String(current.dropFirst(previous.count))
                        if !delta.isEmpty { onToken(delta) }
                        previous = current
                    } else {
                        onToken(current)
                        previous = current
                    }
                }
            } catch {
                onToken("\n[Error: \(error.localizedDescription)]")
            }
        }
    }
}

#else

@MainActor
final class AppleFoundationLLM: LocalLLM {
    func load(modelURL: URL) throws {}
    func unload() {}
    func generate(prompt: String, onToken: @escaping (String) -> Void) throws {
        throw NSError(domain: "AppleFM", code: 2, userInfo: [NSLocalizedDescriptionKey: "FoundationModels framework not available on this platform"])
    }
}

#endif


