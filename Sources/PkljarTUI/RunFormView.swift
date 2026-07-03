import PkljarCore
import Whisker

/// Collects inputs for `run` and dispatches through `PkljarCore.Command`.
///
/// Note: actually exec'ing a child process while the terminal is in raw mode is
/// deferred to when `run` is implemented (M1). For now this surfaces the shared
/// not-implemented message, keeping the TUI consistent with the headless CLI.
struct RunFormView: View {
    let navigate: Binding<Screen>

    @State private var contract = ""
    @State private var commandLine = ""
    @State private var status = ""
    @State private var statusColor: Color = .brightBlack

    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text("run").bold().foregroundColor(.cyan)
            Text("Evaluate a Pkl contract and exec a command with the environment.")
                .foregroundColor(.brightBlack)

            HStack(spacing: 1) {
                Text("Contract").bold()
                Text("›").foregroundColor(.brightBlack)
                TextField("path/to/contract.pkl", text: $contract)
            }

            HStack(spacing: 1) {
                Text("Command ").bold()
                Text("›").foregroundColor(.brightBlack)
                TextField("npm start", text: $commandLine)
            }

            HStack(spacing: 2) {
                Button("Run") { runCommand() }
                Button("Back") { navigate.wrappedValue = .menu }
            }

            if !status.isEmpty {
                Text(status).foregroundColor(statusColor)
            }
        }
    }

    private func runCommand() {
        guard !contract.isEmpty else {
            status = "Enter a contract path first."
            statusColor = .yellow
            return
        }
        let parts = commandLine.split(separator: " ").map(String.init)
        guard !parts.isEmpty else {
            status = "Enter a command to run."
            statusColor = .yellow
            return
        }
        do {
            try Command.run(contract: contract, command: parts)
            status = "Started."
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
