import Whisker

/// The command chooser. Tab/↑/↓ to move between entries, Enter to select.
struct MenuView: View {
    let navigate: Binding<Screen>
    let quit: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text("What would you like to do?").bold()

            VStack(alignment: .leading, spacing: 0) {
                Button("generate  · evaluate a contract → .env") {
                    navigate.wrappedValue = .generate
                }
                Button("run       · inject a contract into a process") {
                    navigate.wrappedValue = .run
                }
                Button("sync      · reconcile local values vs contract") {
                    navigate.wrappedValue = .sync
                }
                Button("quit") {
                    quit()
                }
            }

            Text("Tab/↑/↓ to move · Enter to select · Ctrl+C to exit")
                .foregroundColor(.brightBlack)
        }
    }
}
