import SwiftUI

struct RootView: View {
    @ObservedObject var vm: ChatVM
    @StateObject private var keyboard = KeyboardObserver()
    @State private var showingHistory = false

    var body: some View {
        NavigationStack {
            ChatView(vm: vm)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: { showingHistory = true }) {
                            Image(systemName: "text.justify")
                        }
                        .accessibilityLabel("Conversations")
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: newConversation) {
                            Image(systemName: "plus")
                        }
                        .accessibilityLabel("New conversation")
                    }
                }
                .sheet(isPresented: $showingHistory) {
                    HistoryView { conv in
                        vm.load(conversation: conv)
                        showingHistory = false
                    }
                }
        }
        .environmentObject(keyboard)
        .background(LiquidGlass().ignoresSafeArea())
    }

    private func newConversation() {
        HistoryStore.shared.upsertCurrent(from: vm)
        vm.clear()
    }
}
