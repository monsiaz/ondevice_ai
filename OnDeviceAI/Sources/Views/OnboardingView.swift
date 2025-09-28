import SwiftUI

struct OnboardingView: View {
    var onDone: () -> Void
    var body: some View {
        VStack(spacing: 24) {
            Text("Welcome to OnDeviceAI").font(.largeTitle.bold())
            Text("Private, offline AI on your iPhone. No login. No data collection.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            Spacer()
            Button(action: onDone) {
                Text("Get Started").frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(LiquidGlass().ignoresSafeArea())
    }
}
