import SwiftUI

struct RootView: View {
    @ObservedObject var vm: ChatVM
    @StateObject private var keyboard = KeyboardObserver()

    var body: some View {
        NavigationStack {
            ChatView(vm: vm)
        }
        .environmentObject(keyboard)
        .background(LiquidGlass().ignoresSafeArea())
    }
}
