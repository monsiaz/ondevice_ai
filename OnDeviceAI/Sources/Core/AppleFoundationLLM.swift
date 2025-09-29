import Foundation

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
            // Optimized instructions for better responses
            let instructions = "You are an intelligent AI assistant. Provide helpful, accurate, and contextual responses. Analyze the user's question carefully and respond appropriately to their specific needs."
            session = LanguageModelSession(model: .default, tools: [], instructions: instructions)
            session?.prewarm()
            print("🧠 Apple FoundationModels session initialized with Neural Engine")
        }
        guard let session else { throw NSError(domain: "AppleFM", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to create Neural Engine session"]) }

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


