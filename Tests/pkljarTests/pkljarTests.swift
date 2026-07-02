import PkljarCore
import Testing

@Test func exitCodeValues() {
    #expect(ExitCode.success.rawValue == 0)
    #expect(ExitCode.runtime.rawValue == 1)
    #expect(ExitCode.usage.rawValue == 2)
    #expect(ExitCode.unavailable.rawValue == 127)
}

@Test func pkljarErrorCarriesMessageAndExitCode() {
    let error = PkljarError("something went wrong", exitCode: .unavailable)

    #expect(error.message == "something went wrong")
    #expect(error.exitCode == .unavailable)
}

@Test func notImplementedErrorUsesRuntimeExitCode() {
    let error = PkljarError.notImplemented("generate")

    #expect(error.message == "generate is not implemented yet")
    #expect(error.exitCode == .runtime)
}
