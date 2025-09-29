import SwiftUI

struct SettingsView: View {
    @AppStorage("appTheme") private var appTheme: String = "system"
    @AppStorage("showKeyboardOnLaunch") private var showKeyboardOnLaunch = false
    @AppStorage("appLanguage") private var appLanguage: String = "en"
    
    private var currentLanguage: AppLanguage {
        AppLanguage(rawValue: appLanguage) ?? .english
    }

    var body: some View {
        Form {
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
                        Text("v1.0.0 • \(LocalizedString.get("privacy_tagline", language: currentLanguage))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                    Spacer()
                }
                .padding(.vertical, 4)
            }
            Section(LocalizedString.get("language", language: currentLanguage)) {
                Picker(LocalizedString.get("language", language: currentLanguage), selection: $appLanguage) {
                    ForEach(AppLanguage.allCases, id: \.rawValue) { lang in
                        Text("\(lang.flag) \(lang.displayName)")
                            .tag(lang.rawValue)
                    }
                }
                .pickerStyle(.menu)
                .labelsHidden()
            }
            
            Section(LocalizedString.get("appearance", language: currentLanguage)) {
                Picker(LocalizedString.get("theme", language: currentLanguage), selection: $appTheme) {
                    Text(LocalizedString.get("system", language: currentLanguage)).tag("system")
                    Text(LocalizedString.get("light", language: currentLanguage)).tag("light")
                    Text(LocalizedString.get("dark", language: currentLanguage)).tag("dark")
                }
            }
            
            Section(LocalizedString.get("behavior", language: currentLanguage)) {
                Toggle(LocalizedString.get("show_keyboard_launch", language: currentLanguage), isOn: $showKeyboardOnLaunch)
            }

            Section("Advanced Features") {
                NavigationLink("Voice & Shortcuts") { AdvancedFeaturesView(language: currentLanguage) }
            }

            Section(LocalizedString.get("models", language: currentLanguage)) {
                NavigationLink(LocalizedString.get("download_models", language: currentLanguage)) { ModelPickerView(onPick: { _ in }) }
            }

            Section(LocalizedString.get("about", language: currentLanguage)) {
                NavigationLink(LocalizedString.get("how_it_works", language: currentLanguage)) { HowItWorksView() }
                NavigationLink(LocalizedString.get("usage_tips", language: currentLanguage)) { UsageTipsView() }
                NavigationLink(LocalizedString.get("resources", language: currentLanguage)) { ResourcesView() }
                NavigationLink(LocalizedString.get("legal", language: currentLanguage)) { LegalView(language: currentLanguage) }
                NavigationLink("Debug") { DebugView() }
            }

            Section("Developer Mode") {
                NavigationLink("Logs & Memory") { DebugView() }
                Button("Clear app cache (models & history)") {
                    ModelManager.shared.clearAll()
                    HistoryStore.shared.clearAll()
                    UserDefaults.standard.removeObject(forKey: "chat.history")
                    UserDefaults.standard.removeObject(forKey: "chat.modelName")
                    UserDefaults.standard.removeObject(forKey: "chat.backendName")
                    UserDefaults.standard.removeObject(forKey: "systemPrompt")
                }
                .foregroundColor(.red)
            }
            
            Section(LocalizedString.get("personalization", language: currentLanguage)) {
                NavigationLink(LocalizedString.get("system_prompt", language: currentLanguage)) { PersonalizationView(language: currentLanguage) }
            }
            
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
    }
}

struct LegalView: View {
    let language: AppLanguage
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header avec icône
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
        if let url = Bundle.main.url(forResource: filename.replacingOccurrences(of: ".txt", with: ""), withExtension: "txt"),
           let s = try? String(contentsOf: url, encoding: .utf8) { return s }
        return "Coming soon."
    }
}

struct TutorialView: View {
    let language: AppLanguage
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("How to use OnDeviceAI").font(.title2.bold())
                Text((try? String(contentsOf: Bundle.main.url(forResource: "Tutorial", withExtension: "txt")!)) ?? "")
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
            
            Section("Shortcuts & Actions") {
                Toggle("Context Menu Actions", isOn: $enableContextActions)
                Text("Enable long-press actions: Add to Calendar, Create Reminder, Save to Notes")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Section {
                Text("These features require permissions (Microphone, Calendar, Reminders). You will be prompted when needed.")
                    .font(.caption)
                    .foregroundStyle(.orange)
            }
        }
        .navigationTitle("Voice & Shortcuts")
        .navigationBarTitleDisplayMode(.inline)
    }
}
