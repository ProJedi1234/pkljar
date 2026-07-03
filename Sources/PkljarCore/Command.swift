/// The core pkljar operations, independent of how they are invoked.
///
/// Both the headless CLI (`pkljar generate …`) and the Whisker TUI call through
/// this single entry point so behavior stays identical regardless of front end.
/// The real implementations land in milestone M1 (Generate); for now they throw
/// `PkljarError.notImplemented` so both front ends surface a consistent message.
public enum Command {
    /// Evaluate a Pkl contract and return the flattened `.env` body.
    ///
    /// - Parameters:
    ///   - contract: Path to the Pkl contract file.
    ///   - out: When provided, the caller is expected to write the result to this
    ///          path instead of stdout. (Writing is the caller's responsibility.)
    /// - Returns: The `.env` contents (`KEY=value` lines).
    public static func generate(contract: String, out: String?) throws -> String {
        _ = (contract, out)
        throw PkljarError.notImplemented("generate")
    }

    /// Evaluate a Pkl contract and exec a command with the resulting environment.
    ///
    /// - Parameters:
    ///   - contract: Path to the Pkl contract file.
    ///   - command: The command and arguments to run.
    public static func run(contract: String, command: [String]) throws {
        _ = (contract, command)
        throw PkljarError.notImplemented("run")
    }

    /// Reconcile local values against a Pkl contract and return a human-readable report.
    ///
    /// - Parameter contract: Path to the Pkl contract file.
    /// - Returns: A summary of the reconciliation.
    public static func sync(contract: String) throws -> String {
        _ = contract
        throw PkljarError.notImplemented("sync")
    }
}
