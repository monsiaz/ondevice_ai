import SwiftUI

struct ModelPickerView: View {
    var onPick: (URL) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab = 0
    @State private var installedModels: [LocalModel] = []
    @StateObject private var downloader = ModelDownloader()
    @AppStorage("appLanguage") private var appLanguage: String = "en"
    private var currentLanguage: AppLanguage { AppLanguage(rawValue: appLanguage) ?? .english }

    var body: some View {
        NavigationStack {
            VStack {
                Picker("", selection: $selectedTab) {
                    Text(LocalizedString.get("installed", language: currentLanguage)).tag(0)
                    Text(LocalizedString.get("available", language: currentLanguage)).tag(1)
                }
                .pickerStyle(.segmented)
                .padding()
                
                if selectedTab == 0 {
                    InstalledModelsView(models: installedModels, onPick: onPick, onDismiss: { dismiss() })
                } else {
                    // Horizontal carousels by category
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            ForEach(ModelCategory.allCases, id: \.self) { category in
                                VStack(alignment: .leading, spacing: 12) {
                                    Text(LocalizedString.get(category.rawValue, language: currentLanguage))
                                        .font(.headline)
                                        .padding(.horizontal)
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 12) {
                                            ForEach(Dictionary(grouping: AvailableModel.catalog, by: { $0.category })[category] ?? []) { model in
                                                ModelCard(model: model, downloader: downloader, currentLanguage: currentLanguage)
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle(LocalizedString.get("models", language: currentLanguage))
            .onAppear {
                installedModels = ModelManager.shared.listInstalled()
                for model in installedModels { downloader.downloaded.insert(model.folderName) }
            }
        }
    }
}

struct InstalledModelsView: View {
    let models: [LocalModel]
    let onPick: (URL) -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        List {
            if models.isEmpty {
                Text("No models installed. Download one from the Available tab.")
                    .foregroundStyle(.secondary)
                    .italic()
            } else {
                ForEach(models) { model in
                Button(action: {
                        let url = ModelManager.shared.url(for: model)
                        print("🔄 Switching to model: \(model.displayName) at \(url)")
                    onPick(url)
                        onDismiss()
                }) {
                    HStack {
                        VStack(alignment: .leading) {
                                Text(model.displayName).font(.headline)
                                Text(model.folderName)
                                .font(.caption).foregroundStyle(.secondary)
                        }
                        Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .listStyle(.plain)
    }
}

struct AvailableModelsView: View {
    @ObservedObject var downloader: ModelDownloader
    @AppStorage("appLanguage") private var appLanguage: String = "en"
    @State private var search: String = ""
    @State private var showMultilingual = false
    @State private var showCreative = false
    @State private var showReasoning = false
    
    private var currentLanguage: AppLanguage {
        AppLanguage(rawValue: appLanguage) ?? .english
    }
    
    private var filteredCatalog: [AvailableModel] {
        var items = AvailableModel.catalog
        if !search.isEmpty {
            let q = search.lowercased()
            items = items.filter { m in
                m.displayName.lowercased().contains(q) ||
                ModelTranslations.getDescription(for: m.name, language: currentLanguage).lowercased().contains(q)
            }
        }
        if showMultilingual {
            items = items.filter { m in
                ModelTranslations.getTags(for: m.name, language: currentLanguage)
                    .contains(where: { $0.localizedCaseInsensitiveContains("multilingual") })
            }
        }
        if showCreative {
            items = items.filter { m in
                ModelTranslations.getTags(for: m.name, language: currentLanguage)
                    .contains(where: { $0.localizedCaseInsensitiveContains("creative") })
            }
        }
        if showReasoning {
            items = items.filter { m in
                ModelTranslations.getTags(for: m.name, language: currentLanguage)
                    .contains(where: { $0.localizedCaseInsensitiveContains("reasoning") })
            }
        }
        return items
    }
    
    private var categorizedModels: [ModelCategory: [AvailableModel]] {
        Dictionary(grouping: filteredCatalog, by: { $0.category })
    }
    
    var body: some View {
        List {
            Section {
                TextField(LocalizedString.get("search_models", language: currentLanguage), text: $search)
                Toggle(LocalizedString.get("filter_multilingual", language: currentLanguage), isOn: $showMultilingual)
                Toggle(LocalizedString.get("filter_creative", language: currentLanguage), isOn: $showCreative)
                Toggle(LocalizedString.get("filter_reasoning", language: currentLanguage), isOn: $showReasoning)
            }
            ForEach(ModelCategory.allCases, id: \.self) { category in
                Section(header: Text(LocalizedString.get(category.rawValue, language: currentLanguage))) {
                    ForEach(categorizedModels[category] ?? []) { model in
                        ModelRow(model: model, downloader: downloader, currentLanguage: currentLanguage)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }
}

struct ModelRow: View {
    let model: AvailableModel
    @ObservedObject var downloader: ModelDownloader
    let currentLanguage: AppLanguage
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(model.displayName)
                        .font(.headline)
                    Text(model.deviceRequirement)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                if downloader.isDownloading[model.name] == true {
                    VStack {
                        ProgressView(value: downloader.downloadProgress[model.name] ?? 0.0)
                            .frame(width: 60)
                        Text("\(Int((downloader.downloadProgress[model.name] ?? 0.0) * 100))%")
                            .font(.caption2)
                    }
                } else if downloader.downloaded.contains(model.name) {
                    Label(LocalizedString.get("done", language: currentLanguage), systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(.green)
                } else {
                    Button(LocalizedString.get("download", language: currentLanguage)) {
                        Task {
                            try? await downloader.downloadModel(model)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .font(.caption)
                }
            }
            
            Text(ModelTranslations.getDescription(for: model.name, language: currentLanguage))
                .font(.caption)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 6) {
                if model.isRecommended {
                    Text("Recommended")
                        .font(.caption2.weight(.bold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.green.opacity(0.15))
                        .foregroundColor(.green)
                        .cornerRadius(6)
                }
                
                Text(model.performance.rawValue)
                    .font(.caption2.weight(.medium))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(model.performance.color.opacity(0.15))
                    .foregroundColor(model.performance.color)
                    .cornerRadius(6)
                
                // Feature tags (translated)
                ForEach(ModelTranslations.getTags(for: model.name, language: currentLanguage).prefix(3), id: \.self) { tag in
                    Text(tag)
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(.ultraThinMaterial)
                        .cornerRadius(4)
                }
                
                Spacer()
                
                // Size
                Text(model.size)
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 6)
    }
}

struct ModelCard: View {
    let model: AvailableModel
    @ObservedObject var downloader: ModelDownloader
    let currentLanguage: AppLanguage
    @State private var deviceRamGB: Double = DeviceInfo.current.ramGB
    @State private var showDetail = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(model.displayName).font(.headline)
            Text(ModelTranslations.getDescription(for: model.name, language: currentLanguage))
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(3)
                .frame(width: 220, alignment: .leading)
            HStack(spacing: 6) {
                ForEach(ModelTranslations.getTags(for: model.name, language: currentLanguage).prefix(3), id: \.self) { tag in
                    Text(tag)
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(.ultraThinMaterial)
                        .cornerRadius(4)
                }
                Spacer()
                Text(model.size)
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(.secondary)
            }
            HStack(spacing: 6) {
                // Recommended ribbon if flagged
                if model.category == .recommended {
                    Text("Recommended")
                        .font(.caption2.weight(.bold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.green.opacity(0.2))
                        .foregroundColor(.green)
                        .cornerRadius(6)
                }
                // RAM badge for quick guidance
                Label("\(String(format: "%.1f", deviceRamGB)) GB RAM", systemImage: "memorychip")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            HStack {
                if downloader.isDownloading[model.name] == true {
                    ProgressView(value: downloader.downloadProgress[model.name] ?? 0.0)
                        .frame(width: 120)
                } else if downloader.downloaded.contains(model.name) {
                    Label(LocalizedString.get("done", language: currentLanguage), systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(.green)
                } else {
                    Button(LocalizedString.get("download", language: currentLanguage)) {
                        Task { try? await downloader.downloadModel(model) }
                    }
                    .buttonStyle(.borderedProminent)
                    .font(.caption)
                }
            }
        }
        .padding(12)
        .frame(width: 240)
        .background(.ultraThinMaterial)
        .cornerRadius(14)
        .onTapGesture { showDetail = true }
        .popover(isPresented: $showDetail) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(model.displayName).font(.headline)
                    Spacer()
                    Text(model.size).font(.caption).foregroundStyle(.secondary)
                }
                Text(ModelTranslations.getDescription(for: model.name, language: currentLanguage))
                    .font(.body)
                    .foregroundStyle(.primary)
                HStack(spacing: 6) {
                    ForEach(ModelTranslations.getTags(for: model.name, language: currentLanguage), id: \.self) { tag in
                        Text(tag)
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.ultraThinMaterial)
                            .cornerRadius(4)
                    }
                }
                HStack(spacing: 8) {
                    Label("\(String(format: "%.1f", deviceRamGB)) GB RAM", systemImage: "memorychip")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    if downloader.isDownloading[model.name] == true {
                        ProgressView(value: downloader.downloadProgress[model.name] ?? 0.0)
                            .frame(width: 120)
                    } else if downloader.downloaded.contains(model.name) {
                        Label(LocalizedString.get("done", language: currentLanguage), systemImage: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundStyle(.green)
                    } else {
                        Button(LocalizedString.get("download", language: currentLanguage)) {
                            Task { try? await downloader.downloadModel(model) }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            .padding()
            .presentationDetents([.medium])
        }
    }
}
