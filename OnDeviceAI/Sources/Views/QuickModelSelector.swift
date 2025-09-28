import SwiftUI

struct QuickModelSelector: View {
    var onPick: (URL) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var models: [LocalModel] = []
    @State private var modelToDelete: LocalModel?
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section("Downloaded Models") {
                        if models.isEmpty {
                            Text("No other models downloaded yet.")
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(models) { model in
                                Button(action: {
                                    let url = ModelManager.shared.url(for: model)
                                    onPick(url)
                                    dismiss()
                                }) {
                                    HStack {
                                        Circle()
                                            .fill(Color.orange)
                                            .frame(width: 12, height: 12)
                                        VStack(alignment: .leading) {
                                            Text(model.displayName)
                                                .font(.headline)
                                            Text("MLX • \(model.folderName)")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                        Spacer()
                                        Text("Downloaded")
                                            .font(.caption2.weight(.semibold))
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.green.opacity(0.2))
                                            .foregroundColor(.green)
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
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle(LocalizedString.get("switch_model", language: currentLanguage))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: ModelPickerView(onPick: { url in onPick(url); dismiss() })) {
                        Text(LocalizedString.get("download_more", language: currentLanguage))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(LocalizedString.get("done", language: currentLanguage)) { dismiss() }
                }
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
