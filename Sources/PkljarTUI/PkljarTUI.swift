import Whisker

/// Which screen the TUI should show first.
public enum Screen: Equatable {
    /// The command chooser shown when `pkljar` is run with no subcommand.
    case menu
    /// The `generate` input form.
    case generate
    /// The `run` input form.
    case run
    /// The `sync` input form.
    case sync
}

/// Holds a reference to the running `Application` so views can ask it to quit
/// without touching `Application.shared` (a nonisolated mutable static that is
/// unavailable under Swift 6 strict concurrency).
final class TUIController {
    weak var app: Application?

    func quit() {
        app?.quit()
    }
}

/// Entry point for pkljar's Whisker-powered terminal UI.
///
/// The CLI (`Sources/pkljar`) decides *when* to launch this — only on an
/// interactive TTY — and *where* to start (the full menu, or straight into a
/// specific command's form when that command was invoked without its arguments).
public enum PkljarTUI {
    /// Launch the interactive TUI, blocking until the user quits.
    ///
    /// - Parameter start: The screen to open on. Defaults to the command menu.
    public static func run(start: Screen = .menu) throws {
        let controller = TUIController()
        let app = Application(mode: .inline) {
            RootView(start: start, quit: { controller.quit() })
        }
        controller.app = app
        try app.run()
    }
}
