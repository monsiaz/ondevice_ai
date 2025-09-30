import SwiftUI
import UIKit

struct ChatView: View {
    @ObservedObject var vm: ChatVM
    @State private var showModels = false
    @State private var showModelSelector = false
    @FocusState private var inputFocused: Bool
    @EnvironmentObject var keyboard: KeyboardObserver
    @State private var inputBarHeight: CGFloat = 0
    
    @AppStorage("showKeyboardOnLaunch") private var showKeyboardOnLaunch = false
    @AppStorage("appLanguage") private var appLanguage: String = "en"
    @State private var showMemoryAlert = false
    
    private var currentLanguage: AppLanguage {
        AppLanguage(rawValue: appLanguage) ?? .english
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                header
                messageArea
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            inputBar
                .padding(.bottom, keyboard.height > 0 ? keyboard.height - (firstKeyWindow?.safeAreaInsets.bottom ?? 0) : 0)
                .animation(.interactiveSpring(response: 0.35, dampingFraction: 0.86, blendDuration: 0.25), value: keyboard.height)
        }
        .background(.thinMaterial)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear {
            if showKeyboardOnLaunch {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    inputFocused = true
                }
            }
        }
        .onChange(of: showKeyboardOnLaunch) { _, newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    inputFocused = true
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didReceiveMemoryWarningNotification)) { _ in
            vm.unloadModel()
            showMemoryAlert = true
        }
        .alert("Memory pressure detected", isPresented: $showMemoryAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("The model was unloaded to free memory. You can reload a model from the selector.")
        }
    }
    
    private var header: some View {
        HStack {
            NavigationLink(destination: HistoryView { conv in vm.load(conversation: conv) }) {
                Image(systemName: "clock")
                    .font(.title2)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .accessibilityLabel("Conversation History")
            .accessibilityHint("View and load previous conversations")
            
            Spacer()

            Button(action: { showModelSelector = true }) {
                HStack(spacing: 8) {
                    Image(systemName: vm.backendName == "Apple FM" ? "apple.logo" : "brain.head.profile")
                    VStack(alignment: .leading, spacing: 2) {
                        Text(vm.currentModel)
                            .font(.headline)
                            .lineLimit(1)
                        
                        if vm.isGenerating {
                            Text(vm.generationStats)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .transition(.opacity)
                        } else {
                            Text(vm.backendName)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.thinMaterial)
                .cornerRadius(16)
                .animation(.default, value: vm.isGenerating)
            }
            .sheet(isPresented: $showModelSelector) {
                QuickModelSelector { url in
                    vm.load(modelURL: url)
                }
            }

            Spacer()

            HStack {
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gearshape")
                        .font(.title2)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }

                Button(action: { 
                    HistoryStore.shared.upsertCurrent(from: vm)
                    vm.clear(); hideKeyboard() 
                }) {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.title2)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                .accessibilityLabel("New Conversation")
                .accessibilityHint("Save current chat and start a new conversation")
            }
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
    }

    private var messageArea: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 16) {
                    if vm.isDownloadingInitialModel {
                        VStack {
                            ProgressView()
                            Text("Preparing initial model…")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if vm.messages.isEmpty {
                        VStack(spacing: 16) {
                            SuggestedPrompts(language: currentLanguage) { prompt in
                                DebugLog.shared.log("SuggestedPrompts tapped: '\(prompt)'")
                                vm.input = prompt
                                DebugLog.shared.log("Set vm.input to: '\(vm.input)', isModelLoaded=\(vm.isModelLoaded), modelLoadingStatus='\(vm.modelLoadingStatus)'")
                                vm.send()
                                DebugLog.shared.log("Called vm.send()")
                            }
                            .disabled(!vm.modelLoadingStatus.isEmpty)
                            
                            if !vm.modelLoadingStatus.isEmpty {
                                VStack(spacing: 8) {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                    Text(vm.modelLoadingStatus)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                .padding()
                                .background(.ultraThinMaterial)
                                .cornerRadius(12)
                            }
                        }
                        .padding(.top, 32)
                    } else {
                        ForEach(vm.messages) { message in
                            AnimatedChatBubble(message: message)
                                .padding(.horizontal)
                        }
                        if vm.isGenerating && !vm.messages.isEmpty {
                            HStack {
                                Spacer(minLength: 40)
                                TypingIndicator()
                                    .padding(.trailing)
                            }
                        }
                    }
                }
                .padding(.bottom, keyboard.height > 0 ? keyboard.height + 24 : inputBarHeight + 32)
            }
            .scrollDismissesKeyboard(.interactively)
            .scrollIndicators(.hidden)
            .onTapGesture(perform: hideKeyboard)
            .onChange(of: vm.messages.count) { _, _ in scrollToBottom(proxy: proxy) }
            .onAppear { scrollToBottom(proxy: proxy) }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("ChatVM.didAppendToken"))) { _ in
                scrollToBottom(proxy: proxy)
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("ChatVM.didClear"))) { _ in
                withAnimation(.spring()) {
                }
            }
        }
    }
    
    private var inputBar: some View {
        AnimatedInputBar(
            input: $vm.input,
            isGenerating: $vm.isGenerating,
            inputFocused: $inputFocused,
            onSend: {
                vm.send()
                hideKeyboard()
            }
        )
        .padding(.top, 8)
        .padding(.bottom, (firstKeyWindow?.safeAreaInsets.bottom ?? 0) == 0 ? 8 : 0)
        .background(
            GeometryReader { proxy in
                Color.clear
                    .onAppear { inputBarHeight = proxy.size.height }
                    .onChange(of: proxy.size.height) { _, newValue in inputBarHeight = newValue }
            }
            .background(.regularMaterial)
        )
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    private func scrollToBottom(proxy: ScrollViewProxy) {
        guard let lastId = vm.messages.last?.id else { return }
        DispatchQueue.main.async {
            withAnimation(.spring()) {
                proxy.scrollTo(lastId, anchor: .bottom)
            }
        }
    }
    
    private var firstKeyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}