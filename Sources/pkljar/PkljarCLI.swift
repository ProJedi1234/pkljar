import ArgumentParser
import Foundation
import PkljarCore
import PkljarTUI

@main
struct PkljarCLI: ParsableCommand {
    static let version = "0.1.0"

    static let configuration = CommandConfiguration(
        commandName: "pkljar",
        abstract: "Pkl environments — generate, inject, sync.",
        subcommands: [
            Generate.self,
            Run.self,
            Sync.self,
        ]
    )

    @Flag(name: ["-v", "--version"], help: "Show the version.")
    var showVersion = false

    func run() throws {
        if showVersion {
            print(Self.version)
            throw CleanExit.message("")
        }
        // No subcommand: drop into the full TUI when we have an interactive
        // terminal, otherwise fall back to help (keeps pipes/CI scriptable).
        if isInteractive() {
            try PkljarTUI.run(start: .menu)
            return
        }
        throw CleanExit.helpRequest(Self.self)
    }
}

struct Generate: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Evaluate a Pkl contract and emit a .env file."
    )

    @Argument(help: "Path to the Pkl contract file.")
    var contract: String?

    @Option(name: .long, help: "Write output to this file instead of stdout.")
    var out: String?

    func run() throws {
        guard let contract else {
            if isInteractive() {
                try PkljarTUI.run(start: .generate)
                return
            }
            try throwCLIError(PkljarError("missing 'contract' argument", exitCode: .usage))
        }
        do {
            let env = try Command.generate(contract: contract, out: out)
            if let out {
                try env.write(toFile: out, atomically: true, encoding: .utf8)
            } else {
                print(env)
            }
        } catch let error as PkljarError {
            try throwCLIError(error)
        }
    }
}

struct Run: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Evaluate a Pkl contract and exec a command with the environment."
    )

    @Argument(help: "Path to the Pkl contract file.")
    var contract: String?

    @Argument(parsing: .captureForPassthrough, help: "Command and arguments to run.")
    var command: [String] = []

    func run() throws {
        guard let contract, !command.isEmpty else {
            if isInteractive() {
                try PkljarTUI.run(start: .run)
                return
            }
            if contract == nil {
                try throwCLIError(PkljarError("missing 'contract' argument", exitCode: .usage))
            }
            try throwCLIError(PkljarError("missing command argument", exitCode: .usage))
        }
        do {
            try Command.run(contract: contract, command: command)
        } catch let error as PkljarError {
            try throwCLIError(error)
        }
    }
}

struct Sync: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Reconcile local values against a Pkl contract."
    )

    @Argument(help: "Path to the Pkl contract file.")
    var contract: String?

    func run() throws {
        guard let contract else {
            if isInteractive() {
                try PkljarTUI.run(start: .sync)
                return
            }
            try throwCLIError(PkljarError("missing 'contract' argument", exitCode: .usage))
        }
        do {
            let report = try Command.sync(contract: contract)
            print(report)
        } catch let error as PkljarError {
            try throwCLIError(error)
        }
    }
}

/// Whether both stdin and stdout are attached to a terminal. The TUI is only
/// launched when this is true so piped/redirected/CI usage stays deterministic.
private func isInteractive() -> Bool {
    isatty(STDIN_FILENO) == 1 && isatty(STDOUT_FILENO) == 1
}

private func throwCLIError(_ error: PkljarError) throws -> Never {
    writeToStandardError("\(error.message)\n")
    throw ArgumentParser.ExitCode(error.exitCode.rawValue)
}

private func writeToStandardError(_ message: String) {
    FileHandle.standardError.write(Data(message.utf8))
}
