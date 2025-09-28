import SwiftUI

struct SuggestedPrompts: View {
    let language: AppLanguage
    let onPromptTap: (String) -> Void
    
    private var prompts: [SuggestedPrompt] {
        return PromptLibrary.getPrompts(for: language)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 16) {
                if let logoImage = UIImage(named: "AppLogo") {
                    Image(uiImage: logoImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
                }
                
                VStack(spacing: 8) {
                    Text(LocalizedString.get("app_name", language: language))
                        .font(.title2.bold())
                        .foregroundStyle(.primary)
                    
                    Text(LocalizedString.get("privacy_tagline", language: language))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                ForEach(prompts) { prompt in
                    FloatingPromptBubble(prompt: prompt) {
                        onPromptTap(prompt.prompt)
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top, 40)
    }
}
