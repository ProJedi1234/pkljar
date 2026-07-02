/// Process exit codes used across pkljar.
public enum ExitCode: Int32, Sendable, Equatable {
    /// Successful execution.
    case success = 0
    /// General runtime failure.
    case runtime = 1
    /// Invalid usage or argument parsing failure.
    case usage = 2
    /// Required dependency unavailable (for example, `pkl` not found on PATH).
    case unavailable = 127
}
