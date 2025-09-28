import SwiftUI

struct HistoryView: View {
    @StateObject var store = HistoryStore.shared
    @State private var showClearAlert = false
    @Environment(\.dismiss) private var dismiss
    var onLoad: (Conversation) -> Void

    var body: some View {
        VStack(spacing: 0) {
            TextField(LocalizedString.get("search_conversations", language: currentLanguage), text: $store.query)
                .textFieldStyle(.roundedBorder)
                .padding()
            List {
                ForEach(store.filtered) { conv in
                    Button(action: {
                        onLoad(conv)
                        dismiss()
                    }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(conv.title).font(.headline)
                                Text(conv.updatedAt.formatted(date: .abbreviated, time: .shortened))
                                    .font(.caption).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle(LocalizedString.get("history", language: currentLanguage))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showClearAlert = true }) {
                    Image(systemName: "trash")
                }
                .disabled(store.conversations.isEmpty)
            }
        }
        .alert(LocalizedString.get("clear_history_alert_title", language: currentLanguage), isPresented: $showClearAlert) {
            Button(LocalizedString.get("clear_all_button", language: currentLanguage), role: .destructive) {
                store.clearAll()
            }
        }
    }
    
    private var currentLanguage: AppLanguage {
        AppLanguage(rawValue: appLanguage) ?? .english
    }
    @AppStorage("appLanguage") private var appLanguage: String = "en"
}


