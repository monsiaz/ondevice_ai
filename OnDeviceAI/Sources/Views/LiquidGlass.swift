import SwiftUI

struct LiquidGlass: View {
    @Environment(\.colorScheme) private var scheme
    @State private var animate = false
    @State private var secondaryAnimate = false
    
    var body: some View {
        GeometryReader { geo in
            let primaryColors: [Color] = scheme == .dark ? [
                Color.blue.opacity(0.15),
                Color.purple.opacity(0.12),
                Color.cyan.opacity(0.08),
                Color.indigo.opacity(0.10)
            ] : [
                Color.blue.opacity(0.25),
                Color.purple.opacity(0.20),
                Color.cyan.opacity(0.15),
                Color.white.opacity(0.8)
            ]
            
            ZStack {
                // Base gradient
                LinearGradient(
                    colors: primaryColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                // Animated orbs for liquid effect
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.white.opacity(scheme == .dark ? 0.08 : 0.3),
                                Color.blue.opacity(scheme == .dark ? 0.06 : 0.2),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 10,
                            endRadius: 100
                        )
                    )
                    .blur(radius: animate ? 80 : 60)
                    .offset(
                        x: animate ? -geo.size.width * 0.15 : -geo.size.width * 0.35,
                        y: animate ? -geo.size.height * 0.2 : -geo.size.height * 0.3
                    )
                    .animation(.easeInOut(duration: 8).repeatForever(autoreverses: true), value: animate)
                
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.purple.opacity(scheme == .dark ? 0.08 : 0.25),
                                Color.pink.opacity(scheme == .dark ? 0.06 : 0.15),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 20,
                            endRadius: 120
                        )
                    )
                    .blur(radius: secondaryAnimate ? 100 : 70)
                    .offset(
                        x: secondaryAnimate ? geo.size.width * 0.4 : geo.size.width * 0.2,
                        y: secondaryAnimate ? geo.size.height * 0.3 : geo.size.height * 0.4
                    )
                    .animation(.easeInOut(duration: 12).repeatForever(autoreverses: true), value: secondaryAnimate)
                
                // Subtle mesh gradient overlay
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.clear,
                                Color.white.opacity(scheme == .dark ? 0.02 : 0.1),
                                Color.clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .onAppear {
                animate = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    secondaryAnimate = true
                }
            }
            .ignoresSafeArea(.all)
        }
    }
}
