import SwiftUI

struct HowItWorksView: View {
    @AppStorage("appLanguage") private var appLanguage: String = "en"
    private var currentLanguage: AppLanguage { AppLanguage(rawValue: appLanguage) ?? .english }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header élégant
                VStack(spacing: 12) {
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(.yellow)
                    Text(LocalizedString.get("how_it_works", language: currentLanguage))
                        .font(.title.bold())
                    Text("Understanding on-device AI technology")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 20)
                
                VStack(spacing: 20) {
                    FeatureCard(
                        icon: "lock.shield.fill",
                        iconColor: .green,
                        title: LocalizedString.get("howitworks_privacy_title", language: currentLanguage),
                        description: LocalizedString.get("howitworks_privacy_desc", language: currentLanguage)
                    )
                    
                    FeatureCard(
                        icon: "airplane",
                        iconColor: .blue,
                        title: LocalizedString.get("howitworks_offline_title", language: currentLanguage),
                        description: LocalizedString.get("howitworks_offline_desc", language: currentLanguage)
                    )
                    
                    FeatureCard(
                        icon: "bolt.fill",
                        iconColor: .orange,
                        title: LocalizedString.get("howitworks_performance_title", language: currentLanguage),
                        description: LocalizedString.get("howitworks_performance_desc", language: currentLanguage)
                    )
                    
                    FeatureCard(
                        icon: "brain.head.profile",
                        iconColor: .purple,
                        title: LocalizedString.get("howitworks_models_title", language: currentLanguage),
                        description: LocalizedString.get("howitworks_models_desc", language: currentLanguage)
                    )
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(LocalizedString.get("how_it_works", language: currentLanguage))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FeatureCard: View {
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
