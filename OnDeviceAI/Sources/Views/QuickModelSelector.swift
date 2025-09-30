import SwiftUI

struct QuickModelSelector: View {
    var onPick: (URL) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var models: [LocalModel] = []
    @State private var modelToDelete: LocalModel?
    @State private var showingAppleIntelligence = true
    @State private var showDownloadSheet = false
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    // Apple Intelligence (système par défaut)
                    Section(LocalizedString.get("system_ai", language: currentLanguage)) {
                        Button(action: { 
                            onPick(URL(fileURLWithPath: "/System/AppleIntelligence"))
                            dismiss()
                        }) {
                            HStack {
                                Image(systemName: "brain.head.profile")
                                    .foregroundColor(.blue)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(LocalizedString.get("apple_intelligence", language: currentLanguage))
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    Text(LocalizedString.get("neural_engine_model", language: currentLanguage))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Text(LocalizedString.get("default", language: currentLanguage))
                                    .font(.caption2.weight(.semibold))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(.blue.opacity(0.2))
                                    .foregroundColor(.blue)
                                    .cornerRadius(6)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    
                    // Modèles téléchargés (MLX)
                    Section(LocalizedString.get("downloaded_models_mlx", language: currentLanguage)) {
                        if models.isEmpty {
                            Button(action: { showDownloadSheet = true }) {
                                HStack {
                                    Image(systemName: "arrow.down.circle.fill")
                                        .foregroundStyle(.green)
                                    Text(LocalizedString.get("download_more", language: currentLanguage))
                                        .foregroundStyle(.primary)
                                    Spacer()
                                }
                            }
                        } else {
                            ForEach(models) { model in
                                Button(action: {
                                    let url = ModelManager.shared.url(for: model)
                                    onPick(url)
                                    dismiss()
                                }) {
                                    HStack {
                                        Image(systemName: "cpu")
                                            .foregroundColor(.orange)
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(model.displayName)
                                                .font(.headline)
                                                .foregroundColor(.primary)
                                            Text("MLX • \(model.folderName)")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                        Spacer()
                                        Text("MLX")
                                            .font(.caption2.weight(.semibold))
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(.orange.opacity(0.2))
                                            .foregroundColor(.orange)
                                            .cornerRadius(6)
                                        Button(role: .destructive) {
                                            modelToDelete = model
                                        } label: {
                                            Image(systemName: "trash")
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                            
                            Button(action: { showDownloadSheet = true }) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundStyle(.green)
                                    Text(LocalizedString.get("download_more_models", language: currentLanguage))
                                        .foregroundStyle(.primary)
                                    Spacer()
                                }
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle(LocalizedString.get("switch_model", language: currentLanguage))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(LocalizedString.get("done", language: currentLanguage)) { dismiss() }
                }
            }
            .sheet(isPresented: $showDownloadSheet) {
                ModelPickerView(onPick: { url in 
                    onPick(url)
                    dismiss()
                })
            }
        }
        .onAppear { refresh() }
        .onReceive(NotificationCenter.default.publisher(for: .modelsDidChange)) { _ in
            refresh()
        }
        .presentationDetents([.medium, .large])
        .alert("Remove model?", isPresented: Binding(get: { modelToDelete != nil }, set: { if !$0 { modelToDelete = nil } })) {
            Button("Delete", role: .destructive) {
                if let m = modelToDelete {
                    ModelManager.shared.deleteInstalled(folderName: m.folderName)
                    models = ModelManager.shared.listInstalled()
                    modelToDelete = nil
                }
            }
            Button("Cancel", role: .cancel) { modelToDelete = nil }
        } message: {
            Text("This will permanently remove the downloaded files from your device.")
        }
    }
    
    private var currentLanguage: AppLanguage {
        AppLanguage(rawValue: appLanguage) ?? .english
    }
    @AppStorage("appLanguage") private var appLanguage: String = "en"

    private func refresh() { models = ModelManager.shared.listInstalled() }
}
