import Foundation
import PkljarCore
import Whisker

/// Collects inputs for `generate` and runs it through `PkljarCore.Command`.
struct GenerateFormView: View {
    let navigate: Binding<Screen>

    @State private var contract = ""
    @State private var writeToFile = false
    @State private var outPath = ".env"
    @State private var status = ""
    @State private var statusColor: Color = .brightBlack

    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text("generate").bold().foregroundColor(.cyan)
            Text("Evaluate a Pkl contract and emit a .env file.")
                .foregroundColor(.brightBlack)

            HStack(spacing: 1) {
                Text("Contract").bold()
                Text("›").foregroundColor(.brightBlack)
                TextField("path/to/contract.pkl", text: $contract)
            }

            Toggle("Write to a file instead of stdout (--out)", isOn: $writeToFile)

            if writeToFile {
                HStack(spacing: 1) {
                    Text("Out path").bold()
                    Text("›").foregroundColor(.brightBlack)
                    TextField(".env", text: $outPath)
                }
            }

            HStack(spacing: 2) {
                Button("Generate") { generate() }
                Button("Back") { navigate.wrappedValue = .menu }
            }

            if !status.isEmpty {
                Text(status).foregroundColor(statusColor)
            }
        }
    }

    private func generate() {
        guard !contract.isEmpty else {
            status = "Enter a contract path first."
            statusColor = .yellow
            return
        }
        do {
            let env = try Command.generate(contract: contract, out: writeToFile ? outPath : nil)
            if writeToFile {
                try env.write(toFile: outPath, atomically: true, encoding: .utf8)
                status = "Wrote \(outPath)."
            } else {
                status = env
            }
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
