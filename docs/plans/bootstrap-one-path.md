# Plan: Collapse the bootstrap to one path

Status: planned (not started)
Scope: `dot_zsh/executable_install.sh.tmpl`, README.

## Goal

One bootstrap interface: the documented get.chezmoi.io one-liner.
`install.sh` shrinks to a thin remote adapter that runs that one-liner
over ssh. No home directories or binary locations baked in.

## Current friction

- Two adapters for "bootstrap a machine": the README one-liner and
  `install.sh local`, which re-implements the same download-and-init.
- The remote path makes four ssh/scp round-trips: scp the script, run
  it, `bin/chezmoi update`, then set `pull.rebase` with a hardcoded
  home directory. It assumes the remote user and the chezmoi binary
  location.
- The final round-trip is redundant: `dot_gitconfig.tmpl` already sets
  `[pull] rebase = true` globally, which covers the source repo once
  applied.
- `install_local` runs `chezmoi init` without `--apply`, so the remote
  flow needs the extra `chezmoi update` call to actually apply.

## Steps

1. Rewrite `install.sh` around a single remote invocation:
   `ssh -A -t <host> 'sh -c "$(curl -fsSL get.chezmoi.io)" -- init --apply <repo>'`
   Keep `-A` (agent forwarding) so the private repo clone works, keep
   the `--repo` flag, drop the scp step entirely.
2. Decide the fate of `local` mode: either delete it (the README
   one-liner is the local path) or keep it as a one-line exec of the
   same command. Leaning delete.
3. Drop the `bin/chezmoi update` and `pull.rebase` round-trips
   (`init --apply` plus the applied gitconfig cover both).
4. Keep a wget fallback only if a target without curl is realistic;
   otherwise let it fail loudly.
5. Update the README "Push it to another host" section.

## Verification

- `shellcheck` on the rendered script.
- Dry run against a disposable container or VM with ssh: fresh bootstrap
  ends with `chezmoi doctor` clean and the source repo on `main` with
  rebase pulls.
- Confirm a second run is idempotent (init on an existing install must
  not clobber local state).

## Open questions (settle before implementing)

- Does any target host lack curl in practice?
- Is `local` mode used often enough to keep as an alias for the
  one-liner?
