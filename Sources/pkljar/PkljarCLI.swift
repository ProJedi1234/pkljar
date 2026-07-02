#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#endif
import ArgumentParser
import Foundation
import PkljarCore

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
    }
}

struct Generate: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Evaluate a Pkl contract and emit a .env file."
    )

    @Argument(help: "Path to the Pkl contract file.")
    var contract: String

    @Option(name: .long, help: "Write output to this file instead of stdout.")
    var out: String?

    func run() throws {
        try throwCLIError(PkljarError.notImplemented("generate"))
    }
}

struct Run: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Evaluate a Pkl contract and exec a command with the environment."
    )

    @Argument(help: "Path to the Pkl contract file.")
    var contract: String

    @Argument(parsing: .captureForPassthrough, help: "Command and arguments to run.")
    var command: [String]

    func run() throws {
        try throwCLIError(PkljarError.notImplemented("run"))
    }
}

struct Sync: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Reconcile local values against a Pkl contract."
    )

    @Argument(help: "Path to the Pkl contract file.")
    var contract: String

    func run() throws {
        try throwCLIError(PkljarError.notImplemented("sync"))
    }
}

private func throwCLIError(_ error: PkljarError) throws -> Never {
    writeToStandardError("\(error.message)\n")
    throw ArgumentParser.ExitCode(error.exitCode.rawValue)
}

private func writeToStandardError(_ message: String) {
    message.withCString { cString in
        _ = write(STDERR_FILENO, cString, strlen(cString))
    }
}
