import PkljarCore
import Whisker

/// Collects inputs for `sync` and runs it through `PkljarCore.Command`.
struct SyncFormView: View {
    let navigate: Binding<Screen>

    @State private var contract = ""
    @State private var status = ""
    @State private var statusColor: Color = .brightBlack

    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text("sync").bold().foregroundColor(.cyan)
            Text("Reconcile local values against a Pkl contract.")
                .foregroundColor(.brightBlack)

            HStack(spacing: 1) {
                Text("Contract").bold()
                Text("›").foregroundColor(.brightBlack)
                TextField("path/to/contract.pkl", text: $contract)
            }

            HStack(spacing: 2) {
                Button("Sync") { sync() }
                Button("Back") { navigate.wrappedValue = .menu }
            }

            if !status.isEmpty {
                Text(status).foregroundColor(statusColor)
            }
        }
    }

    private func sync() {
        guard !contract.isEmpty else {
            status = "Enter a contract path first."
            statusColor = .yellow
            return
        }
        do {
            status = try Command.sync(contract: contract)
            statusColor = .green
        } catch let error as PkljarError {
            status = error.message
            statusColor = .red
        } catch {
            status = "\(error)"
            statusColor = .red
        }
    }
}
