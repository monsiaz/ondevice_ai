import SwiftUI

struct RootView: View {
    @ObservedObject var vm: ChatVM
    @StateObject private var keyboard = KeyboardObserver()
    @State private var showingHistory = false

    var body: some View {
        NavigationStack {
            ChatView(vm: vm)
        }
        .environmentObject(keyboard)
        .background(LiquidGlass().ignoresSafeArea())
    }

    private func newConversation() {
        HistoryStore.shared.upsertCurrent(from: vm)
        vm.clear()
    }
}
