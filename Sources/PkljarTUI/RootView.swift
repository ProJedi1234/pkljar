import Whisker

/// Top-level navigator. Owns the current `Screen` and swaps in the matching view.
struct RootView: View {
    @State private var screen: Screen
    let quit: () -> Void

    init(start: Screen, quit: @escaping () -> Void) {
        self._screen = State(wrappedValue: start)
        self.quit = quit
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            HStack(spacing: 1) {
                Text("📦")
                Text("pkljar").bold().foregroundColor(.cyan)
                Text("Pkl environments — generate, inject, sync.")
                    .foregroundColor(.brightBlack)
            }

            switch screen {
            case .menu:
                MenuView(navigate: $screen, quit: quit)
            case .generate:
                GenerateFormView(navigate: $screen)
            case .run:
                RunFormView(navigate: $screen)
            case .sync:
                SyncFormView(navigate: $screen)
            }
        }
    }
}
