# Mason python tools break when mise prunes a python version

Status: open, not decided yet
Date: 2026-07-20

## What happened

Opened a Dockerfile, wired up nvim-lint, and found yamllint dead:

```
bad interpreter: .../mason/packages/yamllint/venv/bin/python: no such file or directory
```

Mason builds python tools (yamllint, ansible-lint, python-lsp-server) into venvs.
A venv bakes in the absolute path of the interpreter it was built with. Mason had
pinned `mise/installs/python/3.14.2`. We bumped mise to 3.14.6, 3.14.2 got pruned,
and the venv's interpreter was gone. A `:MasonInstall yamllint` fixed it by
rebuilding against 3.14.6, so it'll break again the next time 3.14.6 is pruned.

Node/Go based Mason tools (markdownlint, gopls, the LSP servers) don't have this
problem. It only hits python tools.

Same root cause bites in the ansible repo: direnv activates a project venv and
puts it first on PATH, so a Mason install run from inside that repo pins the venv
to the project's python, which is even more transient.

The breakage is silent. Mason still thinks the tool is installed (the symlink
exists), so nothing flags it. `mason-tool-installer` won't catch it either.

## Constraints that shape the fix

1. This config ships to servers via chezmoi. Any fix has to be portable, no
   machine-specific absolute paths.
2. The Mason LSPs and linters are wanted on those servers too, so "drop Mason"
   is off the table.
3. Tools only needed inside vim should not leak into the global user environment.
   That rules out `uv tool install yamllint` and friends, since those land in
   `~/.local/bin` outside vim.

## Options

### A. Manual hygiene (least change)

Accept that it only breaks when a python version is *removed*. After any mise
python major/minor bump, reinstall the python-based Mason tools:

```
:MasonInstall yamllint ansible-lint python-lsp-server
```

Detection one-liner to catch dead venvs anytime:

```bash
for b in ~/.local/share/nvim/mason/bin/*; do "$b" --version >/dev/null 2>&1 || echo "BROKEN: $(basename "$b")"; done
```

Pro: zero new moving parts. Con: manual, easy to forget, silent until you run the check.

### B. uv / mise-global for python tools (REJECTED)

`uv tool install yamllint ansible-lint`, drop them from Mason's `ensure_installed`.

Rejected because it installs vim-only tools into the global env (`~/.local/bin`),
which violates constraint 3, and splits tooling across two managers on servers.
Documented here so we don't re-litigate it.

### C. In-nvim detection + self-heal (most promising, needs a spike)

A small lua function that lives in the config (so it deploys via chezmoi and works
identically on every server), that:

- runs each python-based Mason tool's `--version`
- reinstalls via `mason-registry` the ones that fail
- exposed as `:MasonHealPython`, optionally run on a deferred startup autocmd

Keeps everything inside Mason, stays portable, self-heals across servers, no uv.
Cost is a startup check (keep it deferred or on-demand so it doesn't slow launch).
Open question: reinstall-on-startup could be slow or hit the network at bad times,
so probably make it a command plus a `:checkhealth` extension rather than automatic.

### D. Make the pinned python path stable (mitigation, stackable with C)

The venv breaks because it points at a patch-specific path. Two angles to research:

- Stop pruning old mise pythons (don't run `mise prune` / keep old versions), so
  the pinned interpreter survives. Simple, but accumulates python installs.
- Get the venv to target mise's `.../python/3.14/bin/python3` major.minor symlink
  instead of the resolved `3.14.6`. `python -m venv` resolves symlinks by default,
  so this needs verifying, probably not controllable through Mason.

## Research / open questions

- Does mason.nvim expose any way to pin the python interpreter it builds venvs
  with? Last checked, no first-class option. Recheck upstream, there may be an env
  var or a registry setting now.
- Is there a maintained plugin that health-checks Mason tool integrity (not just
  "is the symlink there")? If yes, it could replace the hand-rolled part of C.
- Confirm whether `python -m venv` can be pointed at a symlinked interpreter that
  survives patch bumps.

## Leaning

A as the stopgap (already have the detection one-liner). Spike C, since it's the
only option that fits all three constraints and fixes the silent-failure part.
Fold in D's "don't prune" habit as cheap insurance.
