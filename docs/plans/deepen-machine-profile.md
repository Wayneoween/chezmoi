# Plan: Deepen the machine profile

Status: planned (not started)
Scope: template data plumbing only, no behavior change intended on macOS.

## Goal

One module owns the per-machine facts. Templates consume named facts
(`.miseBin`, `.brewPrefix`, ...) instead of each re-branching on
`.chezmoi.os` and re-deriving paths. OS branches survive only where the
structure differs (grml prompt vs starship, brew shellenv), not where
just a value does.

## Current friction

- `.chezmoi.toml.tmpl` hardcodes the age identity to a macOS home path.
  On any Linux machine the identity path is wrong.
- `dot_gitconfig.tmpl` has an unconditional `[maintenance]` block with
  macOS-only repo paths. `git maintenance` misbehaves everywhere else.
- The mise binary path is spelled three ways: homebrew prefix path in
  `dot_zshrc.tmpl` (darwin branch), `~/.local/bin/mise` in the linux
  branch and in `run_once_before_00-install-mise.sh.tmpl`, and bare
  `mise` elsewhere.
- `osid` is computed in `.chezmoi.toml.tmpl` `[data]` but nothing reads
  it (dead interface).
- The LM Studio PATH entry in `dot_zshrc.tmpl` hardcodes the macOS home
  directory instead of using `$HOME`.

## Design

`.chezmoidata/` is static (no template execution), so per-OS resolution
lives in `.chezmoi.toml.tmpl` `[data]`, which IS a template. That
section becomes the machine-profile module. Suggested facts:

```toml
[data]
  brewPrefix = ...        # "/opt/homebrew" on darwin, "" elsewhere
  miseBin    = ...        # brewPrefix-based on darwin, ~/.local/bin/mise on linux
  ageIdentity = ...       # {{ .chezmoi.homeDir }}/.age/key.txt
  maintenanceRepos = [...] # darwin only, empty list elsewhere
```

Identity facts (git name/email, repo URL) stay in `.chezmoidata/base.toml`
as today; the profile only owns facts that vary per machine/OS.

## Steps

1. Add the named facts to `[data]` in `.chezmoi.toml.tmpl`.
2. Fix the age `identity` to derive from `.chezmoi.homeDir`.
3. `dot_gitconfig.tmpl`: render `[maintenance]` from `maintenanceRepos`
   (block disappears when the list is empty).
4. `dot_zshrc.tmpl`, `dot_zprofile.tmpl`,
   `run_once_before_00-install-mise.sh.tmpl`: replace literal paths with
   `.miseBin` / `.brewPrefix`; use `$HOME` for the LM Studio entry.
5. Delete `osid` unless a consumer appears in step 1-4.
6. Sweep for remaining `{{ if eq .chezmoi.os` branches; keep only the
   structural ones.

## Verification

- `chezmoi execute-template < <file>.tmpl` renders cleanly for both OS
  values (override with `--init --promptString` style data as needed).
- `chezmoi init` (re-render the config, required for `.chezmoi.toml.tmpl`
  changes; `apply` alone does not re-read it), then `chezmoi diff`:
  on macOS the diff should be empty except the `[maintenance]` guard;
  on Linux the age identity and maintenance block change intentionally.
- `zsh -n` on the rendered zshrc.

## Gotchas

- `.chezmoi.toml.tmpl` edits only take effect after `chezmoi init`
  re-runs on each machine, not on plain `chezmoi apply`.
- `git.autoCommit`/`autoPush` are enabled: chezmoi-driven edits publish
  immediately. Do the work via plain git on a branch if review is wanted.
