/// Shared error type for deterministic pkljar failures.
public struct PkljarError: Error, Sendable, Equatable {
    public let message: String
    public let exitCode: ExitCode

    public init(_ message: String, exitCode: ExitCode = .runtime) {
        self.message = message
        self.exitCode = exitCode
    }

    public static func notImplemented(_ command: String) -> PkljarError {
        PkljarError("\(command) is not implemented yet")
    }
}
