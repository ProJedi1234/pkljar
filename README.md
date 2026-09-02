# pkljar

**Pkl environments: generate, inject, sync.**

Turn a typed [Pkl](https://pkl-lang.org) contract into a real environment, and keep your local environment reconciled with that contract as it changes.

> Status: early development. The design is settled; the converter is the first thing being built.

## The problem

Environment files drift. A team commits a template — `.env.example` or similar — and everyone keeps their own local `.env` beside it. The template is a dead copy that has to be hand-maintained, so it rots: keys get added to the app and never make it into everyone's file, missing values silently fall back to defaults, and nobody can tell whose `.env` is actually correct. As the config grows and changes quickly, the drift only gets worse.

The real problem isn't formatting a `.env`. It's **synchronization** — keeping many local environments aligned with a single source of truth as that truth evolves.

## The idea

`.env` is the wrong place to *author* configuration. The process environment is a flat `map<string, string>` with no types, no validation, and no structure — which is exactly why every language and runtime can read it, and exactly why you shouldn't be hand-editing it. It's a compile *target*, not a source.

So pkljar moves authoring up a layer. You describe your environment once, in a **Pkl contract** — typed, validated, committed, and free of secret values. pkljar handles the two things Pkl itself doesn't: turning that contract into an actual environment, and reconciling your local values against it over time.

Pkl is a real configuration-as-code language — types, constraints, defaults, computed values, templating, and clear error messages. pkljar treats it as a read-only dependency: it *calls* `pkl`, consumes its output, and never edits Pkl source.

## What it does

Two jobs, one binary.

### Generate & inject — the everyday verbs

```sh
pkljar generate contract.pkl             # evaluate → flatten → print .env
pkljar generate contract.pkl --out .env  # ...or write a file
pkljar run contract.pkl -- npm start     # ...or inject straight into a process
```

Evaluate the contract, flatten the result to `KEY=value` (nested values become `DATABASE_HOST`, `FEATURE_FLAGS_NEW_DASHBOARD`, …), and either write a `.env` or exec your command with the environment already in place — no file on disk required.

### Sync — the depth verb

```sh
pkljar sync contract.pkl
```

When the contract changes, reconcile it against your local values with a three-way diff — contract now, your values, and the last-synced snapshot. New keys are surfaced, removed keys become orphans you resolve rather than lose, renames are detected and offered, and stored values that no longer satisfy the contract are flagged. The same source of truth drives an interactive migration locally and a pass/fail gate in CI.

## A contract looks like this

```pkl
appEnv: "dev" | "staging" | "prod" = "dev"

server: Server = new {}
class Server {
  port: UInt16(this >= 1024) = 8080
  host: String = "0.0.0.0"
}

featureFlags: FeatureFlags = new {}
class FeatureFlags {
  newDashboard: Boolean = false
}
```

lowers to:

```
APP_ENV=dev
SERVER_PORT=8080
SERVER_HOST=0.0.0.0
FEATURE_FLAGS_NEW_DASHBOARD=false
```



## Principles

- **Pkl is a dependency, not a fork.** pkljar shells out to the stock `pkl` binary and consumes its output. Everything from evaluation onward is application logic.
- **Author the contract, generate the env.** The `.env` is a build artifact. Don't hand-edit it.
- **The contract holds shape; values live apart.** The committed contract is typed and secret-free. Real values stay in a separate, gitignored file (or a secret manager).
- **Computed fields are read-only.** A value derived inside the contract — `url = "...\(host):\(port)"` — is shown, never edited, and recomputes on its own. Only stored inputs participate in sync.
- **Nothing is destroyed by inference.** Removed keys are held as orphans until you decide. Suspected renames are proposed, never auto-applied. A wrong guess costs you a confirmation, never a value.



## Requirements

- [Pkl](https://pkl-lang.org) installed and on `PATH` (`brew install pkl`).
- A Swift toolchain to build (`swift build`).



## Status

Early. The architecture is decided; the converter (`generate` / `run`) is the first milestone, with `sync` layered on top once the core is solid.