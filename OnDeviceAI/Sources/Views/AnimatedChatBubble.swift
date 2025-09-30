import SwiftUI

struct AnimatedChatBubble: View {
    let message: ChatBubble
    @State private var showTTS = true
    @AppStorage("enableTTS") private var enableTTS: Bool = true
    @AppStorage("enableContextActions") private var enableContextActions: Bool = true
    @AppStorage("bubbleAnimation") private var bubbleAnimation: Bool = true
    @AppStorage("appLanguage") private var appLanguage: String = "en"
    @StateObject private var speech = SpeechManager()
    @State private var isVisible = false
    @State private var shimmer = false
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    private var currentLanguage: AppLanguage {
        AppLanguage(rawValue: appLanguage) ?? .english
    }
    
    var body: some View {
        HStack {
            if message.role == .assistant { Spacer(minLength: 40) }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(message.text)
                    .contextMenu {
                        if enableContextActions {
                            Button(action: {
                                UIPasteboard.general.string = message.text
                            }) {
                                Label(LocalizedString.get("copy", language: currentLanguage), systemImage: "doc.on.doc")
                            }
                            
                            Button(action: {
                                let activityVC = UIActivityViewController(activityItems: [message.text], applicationActivities: nil)
                                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                   let window = scene.windows.first,
                                   let rootVC = window.rootViewController {
                                    rootVC.present(activityVC, animated: true)
                                }
                            }) {
                                Label(LocalizedString.get("share", language: currentLanguage), systemImage: "square.and.arrow.up")
                            }
                        }
                    }
                if message.role == .assistant && enableTTS {
                    HStack(spacing: 12) {
                        Button(action: { 
                            if speech.isSpeaking { speech.stopSpeaking() } else { speech.speak(message.text) }
                        }) {
                            Label(speech.isSpeaking ? LocalizedString.get("stop", language: currentLanguage) : LocalizedString.get("listen", language: currentLanguage), 
                                  systemImage: speech.isSpeaking ? "stop.fill" : "speaker.wave.2")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .symbolEffect(.variableColor.iterative, isActive: speech.isSpeaking)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.top, 2)
                }
            }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            // Shimmer effect for assistant messages
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(
                                    LinearGradient(
                                        colors: message.role == .assistant && shimmer ? 
                                            [Color.clear, Color.blue.opacity(0.3), Color.clear] :
                                            [Color.white.opacity(0.2), Color.clear],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                        .shadow(
                            color: message.role == .user ? 
                                Color.blue.opacity(0.2) : Color.black.opacity(0.1),
                            radius: isVisible ? 8 : 2,
                            x: 0,
                            y: 2
                        )
                )
                .foregroundStyle(message.role == .user ? .blue : .primary)
                .textSelection(.enabled)
                .scaleEffect(isVisible ? 1.0 : 0.8)
                .opacity(isVisible ? 1.0 : 0.0)
                .offset(y: isVisible ? 0 : 20)
                .id(message.id)
            
            if message.role == .user { Spacer(minLength: 40) }
        }
        .onAppear {
            // Respect user's animation preference
            if bubbleAnimation && !reduceMotion {
                withAnimation(.spring(duration: 0.4, bounce: 0.2)) {
                    isVisible = true
                }
                
                // Add shimmer for assistant messages
                if message.role == .assistant {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                            shimmer = true
                        }
                    }
                }
            } else {
                isVisible = true
            }
        }
        .accessibilityElement(children: .combine)
    }
}

struct AnimatedInputBar: View {
    @Binding var input: String
    @Binding var isGenerating: Bool
    @FocusState.Binding var inputFocused: Bool
    let onSend: () -> Void
    @StateObject private var speechManager = SpeechManager()
    @AppStorage("enableMic") private var enableMic: Bool = true
    
    var body: some View {
        HStack(spacing: 10) {
            TextField(
                LocalizedString.get("ask_anything", language: AppLanguage(rawValue: UserDefaults.standard.string(forKey: "appLanguage") ?? "en") ?? .english),
                text: $input,
                axis: .vertical
            )
            .textFieldStyle(.plain)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .focused($inputFocused)
            .onSubmit(handleSend)
            .lineLimit(input.count > 200 ? 4 : 1)
            .frame(minHeight: 44)
            .frame(maxHeight: input.count > 200 ? 100 : 44)

            if enableMic {
                Button(action: {
                    if speechManager.isDictating {
                        speechManager.stopDictation()
                    } else {
                        Task {
                            await speechManager.requestAuthorization()
                            await MainActor.run {
                                speechManager.startDictation()
                            }
                        }
                    }
                }) {
                    Image(systemName: speechManager.isDictating ? "mic.fill" : "mic")
                        .font(.headline)
                        .foregroundStyle(speechManager.isDictating ? .red : .primary)
                        .frame(width: 28, height: 28)
                        .padding(10)
                        .symbolEffect(.pulse, isActive: speechManager.isDictating)
                }
                .accessibilityLabel(speechManager.isDictating ? "Stop dictation" : "Start dictation")
            }

            Button(action: handleSend) {
                Image(systemName: "arrow.up")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(width: 28, height: 28)
                    .padding(10)
                    .background(input.isEmpty ? Color.gray.opacity(0.5) : Color.blue)
                    .clipShape(Circle())
            }
            .disabled(input.isEmpty)
        }
        .padding(4)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
        .onChange(of: speechManager.transcript) { oldValue, newValue in
            if !newValue.isEmpty && newValue != oldValue {
                input = newValue
            }
        }
        .onAppear {
            Task {
                await speechManager.requestAuthorization()
            }
        }
    }
    
    private func handleSend() {
        guard !input.isEmpty else { return }
        
        // Stop dictation if active
        if speechManager.isDictating {
            speechManager.stopDictation()
        }
        
        onSend()
        
        // Close keyboard after send (unless user wants it to stay)
        let keepKeyboardOpen = UserDefaults.standard.bool(forKey: "keepKeyboardAfterSend")
        if !keepKeyboardOpen {
            inputFocused = false
        }
    }
}

// Typing indicator (iMessage-like)
struct TypingIndicator: View {
    @State private var phase: Double = 0
    var body: some View {
        HStack(spacing: 6) {
            Circle().fill(.secondary).frame(width: 6, height: 6).opacity(opacity(0))
            Circle().fill(.secondary).frame(width: 6, height: 6).opacity(opacity(0.2))
            Circle().fill(.secondary).frame(width: 6, height: 6).opacity(opacity(0.4))
        }
        .padding(10)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) { phase = 1 }
        }
    }
    private func opacity(_ offset: Double) -> Double {
        let v = 0.3 + 0.7 * abs(sin((phase + offset) * .pi))
        return v
    }
}

// (Removed KeyboardManagementPadding that required an EnvironmentObject and caused runtime pause)

struct FloatingPromptBubble: View {
    let prompt: SuggestedPrompt
    let onTap: () -> Void
    @State private var isHovered = false
    @State private var floatOffset: CGFloat = 0
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            onTap()
        }) {
            VStack(alignment: .leading, spacing: 6) {
                Text(prompt.title)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary)
                Text(prompt.subtitle)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(.ultraThinMaterial)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        LinearGradient(
                            colors: isHovered ? 
                                [Color.blue.opacity(0.4), Color.purple.opacity(0.3)] :
                                [Color.white.opacity(0.2), Color.clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: isHovered ? 1.5 : 0.5
                    )
            )
            .scaleEffect(isHovered ? 1.05 : 1.0)
            .offset(y: floatOffset)
            .shadow(color: .black.opacity(isHovered ? 0.15 : 0.05), radius: isHovered ? 12 : 4, x: 0, y: isHovered ? 6 : 2)
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            if !reduceMotion {
                withAnimation(.spring(duration: 0.3)) {
                    isHovered = hovering
                }
            }
        }
        .onAppear {
            if !reduceMotion {
                // Subtle floating animation
                withAnimation(.easeInOut(duration: Double.random(in: 3...5)).repeatForever(autoreverses: true)) {
                    floatOffset = CGFloat.random(in: -3...3)
                }
            }
        }
        .accessibilityAddTraits(.isButton)
        .accessibilityLabel(prompt.title)
        .accessibilityHint(prompt.subtitle)
    }
}
