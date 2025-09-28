import SwiftUI

struct UsageTipsView: View {
    @AppStorage("appLanguage") private var appLanguage: String = "en"
    private var currentLanguage: AppLanguage { AppLanguage(rawValue: appLanguage) ?? .english }
    
    private let tips = [
        ("lightbulb.fill", Color.yellow),
        ("person.fill.questionmark", Color.blue),
        ("doc.text.fill", Color.green),
        ("arrow.triangle.2.circlepath", Color.purple)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(.yellow)
                    Text(LocalizedString.get("usage_tips", language: currentLanguage))
                        .font(.title.bold())
                    Text("Get the best results from your AI assistant")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 20)
                
                VStack(spacing: 20) {
                    TipCard(
                        icon: "lightbulb.fill",
                        iconColor: .yellow,
                        title: LocalizedString.get("tip_context_title", language: currentLanguage),
                        description: LocalizedString.get("tip_context_desc", language: currentLanguage)
                    )
                    
                    TipCard(
                        icon: "person.fill.questionmark",
                        iconColor: .blue,
                        title: LocalizedString.get("tip_persona_title", language: currentLanguage),
                        description: LocalizedString.get("tip_persona_desc", language: currentLanguage)
                    )
                    
                    TipCard(
                        icon: "doc.text.fill",
                        iconColor: .green,
                        title: LocalizedString.get("tip_format_title", language: currentLanguage),
                        description: LocalizedString.get("tip_format_desc", language: currentLanguage)
                    )
                    
                    TipCard(
                        icon: "arrow.triangle.2.circlepath",
                        iconColor: .purple,
                        title: LocalizedString.get("tip_iterate_title", language: currentLanguage),
                        description: LocalizedString.get("tip_iterate_desc", language: currentLanguage)
                    )
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(LocalizedString.get("usage_tips", language: currentLanguage))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TipCard: View {
    let icon: String
    let iconColor: Color
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(iconColor)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(description)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}
