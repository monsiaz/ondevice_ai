import SwiftUI

struct SettingsView: View {
    @AppStorage("appTheme") private var appTheme: String = "system"
    @AppStorage("showKeyboardOnLaunch") private var showKeyboardOnLaunch = false
    @AppStorage("appLanguage") private var appLanguage: String = "en"
    @State private var showClearConfirmation = false
    @State private var showClearSuccess = false
    @State private var clearMessage = ""
    
    private var currentLanguage: AppLanguage {
        AppLanguage(rawValue: appLanguage) ?? .english
    }

    var body: some View {
        Form {
            // App Info
            Section {
                HStack {
                    if let logoImage = UIImage(named: "AppLogo") {
                        Image(uiImage: logoImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .cornerRadius(8)
                    }
                    VStack(alignment: .leading) {
                        Text(LocalizedString.get("app_name", language: currentLanguage))
                            .font(.headline)
                        Text("v1.4 • \(LocalizedString.get("privacy_tagline", language: currentLanguage))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                    Spacer()
                }
                .padding(.vertical, 4)
            }
            
            // Language (controls UI, voice, TTS)
            Section {
                Picker(LocalizedString.get("language", language: currentLanguage), selection: $appLanguage) {
                    ForEach(AppLanguage.allCases, id: \.rawValue) { lang in
                        Text("\(lang.flag) \(lang.displayName)")
                            .tag(lang.rawValue)
                    }
                }
                .pickerStyle(.menu)
                
                Text(LocalizedString.get("controls_language_note", language: currentLanguage))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text(LocalizedString.get("language", language: currentLanguage))
            }
            
            // System Prompt (Personalization)
            Section {
                NavigationLink(LocalizedString.get("system_prompt", language: currentLanguage)) { 
                    PersonalizationView(language: currentLanguage) 
                }
            } header: {
                Text(LocalizedString.get("personalization", language: currentLanguage))
            } footer: {
                Text(LocalizedString.get("customize_ai_note", language: currentLanguage))
                    .font(.caption)
            }
            
            // Appearance
            Section(LocalizedString.get("appearance", language: currentLanguage)) {
                Picker(LocalizedString.get("theme", language: currentLanguage), selection: $appTheme) {
                    Text(LocalizedString.get("system", language: currentLanguage)).tag("system")
                    Text(LocalizedString.get("light", language: currentLanguage)).tag("light")
                    Text(LocalizedString.get("dark", language: currentLanguage)).tag("dark")
                }
            }
            
            // Behavior
            Section(LocalizedString.get("behavior", language: currentLanguage)) {
                Toggle(LocalizedString.get("show_keyboard_launch", language: currentLanguage), isOn: $showKeyboardOnLaunch)
                Toggle(LocalizedString.get("keep_keyboard_after_send", language: currentLanguage), isOn: .init(
                    get: { UserDefaults.standard.bool(forKey: "keepKeyboardAfterSend") },
                    set: { UserDefaults.standard.set($0, forKey: "keepKeyboardAfterSend") }
                ))
            }
            
            // Visual Effects & Animations
            Section(LocalizedString.get("visual_effects", language: currentLanguage)) {
                NavigationLink(LocalizedString.get("animation_scroll", language: currentLanguage)) {
                    VisualEffectsView()
                }
            }

            // Voice & Shortcuts
            Section(LocalizedString.get("advanced_features", language: currentLanguage)) {
                NavigationLink(LocalizedString.get("voice_and_shortcuts", language: currentLanguage)) { 
                    AdvancedFeaturesView(language: currentLanguage) 
                }
            }

            // Models
            Section(LocalizedString.get("models", language: currentLanguage)) {
                NavigationLink(LocalizedString.get("download_models", language: currentLanguage)) { 
                    ModelPickerView(onPick: { _ in }) 
                }
            }

            // About
            Section(LocalizedString.get("about", language: currentLanguage)) {
                NavigationLink(LocalizedString.get("how_it_works", language: currentLanguage)) { HowItWorksView() }
                NavigationLink(LocalizedString.get("usage_tips", language: currentLanguage)) { UsageTipsView() }
                NavigationLink(LocalizedString.get("resources", language: currentLanguage)) { ResourcesView() }
                NavigationLink(LocalizedString.get("legal", language: currentLanguage)) { LegalView(language: currentLanguage) }
            }

            // Developer
            Section("Developer") {
                NavigationLink("Logs & Memory") { DebugView() }
                
                Button("Clear app cache (models & history)") {
                    showClearConfirmation = true
                }
                .foregroundColor(.red)
            }
            
            // Connect
            Section(LocalizedString.get("connect", language: currentLanguage)) {
                Link(destination: URL(string: "https://x.com/SimonAzoulayFr")!) {
                    HStack {
                        Image(systemName: "at")
                            .foregroundColor(.blue)
                        Text(LocalizedString.get("follow_twitter", language: currentLanguage))
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle(LocalizedString.get("settings", language: currentLanguage))
        .alert("Clear Cache", isPresented: $showClearConfirmation) {
            Button("Cancel", role: .cancel) {}
                Button(LocalizedString.get("clear", language: currentLanguage), role: .destructive) {
                clearCache()
            }
        } message: {
            Text("This will delete all downloaded models and conversation history. This action cannot be undone.")
        }
        .alert("Cache Cleared", isPresented: $showClearSuccess) {
            Button("OK") { 
                showClearSuccess = false
                clearMessage = ""
            }
        } message: {
            Text(clearMessage)
        }
    }
    
    private func clearCache() {
        var freedSpace: UInt64 = 0
        
        // Calculate models size
        let fm = FileManager.default
        if let supportDir = try? fm.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            let modelsPath = supportDir.appendingPathComponent("Models")
            if let enumerator = fm.enumerator(at: modelsPath, includingPropertiesForKeys: [.fileSizeKey, .isRegularFileKey]) {
                for case let fileURL as URL in enumerator {
                    if let resourceValues = try? fileURL.resourceValues(forKeys: [.fileSizeKey, .isRegularFileKey]),
                       let isFile = resourceValues.isRegularFile,
                       isFile,
                       let fileSize = resourceValues.fileSize {
                        freedSpace += UInt64(fileSize)
                    }
                }
            }
            
            // Calculate history size
            let historyPath = supportDir.appendingPathComponent("history.json")
            if let attrs = try? fm.attributesOfItem(atPath: historyPath.path),
               let fileSize = attrs[.size] as? UInt64 {
                freedSpace += fileSize
            }
        }
        
        // Clear everything
        ModelManager.shared.clearAll()
        HistoryStore.shared.clearAll()
        UserDefaults.standard.removeObject(forKey: "chat.history")
        UserDefaults.standard.removeObject(forKey: "chat.modelName")
        UserDefaults.standard.removeObject(forKey: "chat.backendName")
        UserDefaults.standard.removeObject(forKey: "systemPrompt")
        
        let freedMB = Double(freedSpace) / (1024 * 1024)
        clearMessage = String(format: "✅ Cache cleared!\n%.1f MB freed", max(freedMB, 0.1))
        showClearSuccess = true
    }
}

struct VisualEffectsView: View {
    @AppStorage("bubbleAnimation") private var bubbleAnimation: Bool = true
    @AppStorage("scrollAnimation") private var scrollAnimation: Bool = true
    @AppStorage("messageBottomSpace") private var messageBottomSpace: Double = 125
    
    var body: some View {
        Form {
            Section {
                Text("Customize the visual behavior of chat bubbles and scrolling.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Section("Animations") {
                Toggle(LocalizedString.get("bubble_animation", language: currentLanguage), isOn: $bubbleAnimation)
                Toggle(LocalizedString.get("smooth_scroll", language: currentLanguage), isOn: $scrollAnimation)
            }
            
            Section("Layout") {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(LocalizedString.get("space_below_messages", language: currentLanguage))
                        Spacer()
                        Text("\(Int(messageBottomSpace))px")
                            .foregroundStyle(.secondary)
                    }
                    Slider(value: $messageBottomSpace, in: 80...250, step: 10)
                }
                
                Text("Adjusts how much empty space appears below the last message. Higher values lift messages further above the input bar.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Section {
                Button(LocalizedString.get("reset_defaults", language: currentLanguage)) {
                    bubbleAnimation = true
                    scrollAnimation = true
                    messageBottomSpace = 125
                }
            }
        }
        .navigationTitle("Animation & Scroll")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LegalView: View {
    let language: AppLanguage
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Image(systemName: "doc.text.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(.blue)
                    Text(LocalizedString.get("legal", language: language))
                        .font(.title.bold())
                    Text("Important information about your rights and our policies")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 20)
                
                VStack(spacing: 16) {
                    LegalCard(
                        icon: "checkmark.shield.fill",
                        title: LocalizedString.get("terms_of_use", language: language),
                        subtitle: "Terms and conditions for using OnDeviceAI",
                        destination: LegalTextView(title: "Terms of Use", filename: "Terms.txt")
                    )
                    
                    LegalCard(
                        icon: "lock.shield.fill",
                        title: LocalizedString.get("privacy_policy", language: language),
                        subtitle: "How we protect your privacy and data",
                        destination: LegalTextView(title: "Privacy Policy", filename: "Privacy.txt")
                    )
                    
                    LegalCard(
                        icon: "books.vertical.fill",
                        title: LocalizedString.get("licenses", language: language),
                        subtitle: "Open source licenses and attributions",
                        destination: LegalTextView(title: "Licenses", filename: "Licenses.txt")
                    )
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(LocalizedString.get("legal", language: language))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LegalCard<Destination: View>: View {
    let icon: String
    let title: String
    let subtitle: String
    let destination: Destination
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(.blue)
                    .frame(width: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(20)
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}

struct LegalTextView: View {
    let title: String
    let filename: String
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(loadText())
                    .font(.body)
                    .lineSpacing(4)
                    .textSelection(.enabled)
            }
            .padding(20)
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.large)
        .background(.regularMaterial.opacity(0.3))
    }
    private func loadText() -> String {
        if let url = Bundle.main.url(forResource: filename.replacingOccurrences(of: ".txt", with: ""), withExtension: "txt") {
            do {
                return try String(contentsOf: url, encoding: .utf8)
            } catch {
                return "Error loading content: \(error.localizedDescription)"
            }
        }
        return "Coming soon."
    }
}

struct TutorialView: View {
    let language: AppLanguage
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("How to use OnDeviceAI").font(.title2.bold())
                if let url = Bundle.main.url(forResource: "Tutorial", withExtension: "txt"),
                   let content = try? String(contentsOf: url, encoding: .utf8) {
                    Text(content)
                } else {
                    Text("Tutorial content not available")
                }
            }
            .padding()
        }
        .navigationTitle(LocalizedString.get("tutorial", language: language))
    }
}

struct PersonalizationView: View {
    @AppStorage("systemPrompt") private var systemPrompt: String = ""
    @Environment(\.dismiss) private var dismiss
    let language: AppLanguage

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(LocalizedString.get("personalization_desc", language: language))
                .font(.body)
                .foregroundStyle(.secondary)
            TextEditor(text: $systemPrompt)
                .frame(minHeight: 200)
                .padding(8)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            HStack {
                Button(LocalizedString.get("reset", language: language)) { systemPrompt = "" }
                Spacer()
                Button(LocalizedString.get("save", language: language)) { dismiss() }.buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .navigationTitle(LocalizedString.get("personalization", language: language))
    }
}

struct AdvancedFeaturesView: View {
    let language: AppLanguage
    @AppStorage("enableMic") private var enableMic: Bool = true
    @AppStorage("enableTTS") private var enableTTS: Bool = true
    @AppStorage("enableContextActions") private var enableContextActions: Bool = true
    
    var body: some View {
        Form {
            Section {
                Text("Control advanced features like voice dictation, text-to-speech, and context actions. Disabling these options will hide the buttons and remove functionality.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Section("Voice Features") {
                Toggle("Microphone (Dictation)", isOn: $enableMic)
                Text("Show microphone button in input bar for voice dictation")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Toggle("Text-to-Speech", isOn: $enableTTS)
                Text("Show 'Listen' button under assistant replies")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Section(LocalizedString.get("quick_actions", language: language)) {
                Toggle(LocalizedString.get("context_menu", language: language), isOn: $enableContextActions)
                Text(LocalizedString.get("copy_share_hint", language: language))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Section {
                Text(LocalizedString.get("voice_permission_note", language: language))
                    .font(.caption)
                    .foregroundStyle(.orange)
            }
        }
        .navigationTitle("Voice & Shortcuts")
        .navigationBarTitleDisplayMode(.inline)
    }
}