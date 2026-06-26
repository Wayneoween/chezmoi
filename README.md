# dotfiles

My personal dotfiles, managed with [chezmoi](https://chezmoi.io). Works on macOS (Homebrew + Brewfile) and Linux (mise). Covers zsh, git, tmux, nvim, and a stack of CLI tooling.

## Bootstrap a new machine

You need an SSH key that can clone the repo, plus internet access. chezmoi and everything else pulls itself in.

```sh
sh -c "$(curl -fsSL get.chezmoi.io)" -- init --apply git@gitlab.com:marius.schuller/chezmoi.git
```

That clones into `~/.local/share/chezmoi`, applies the files, then runs the `run_once_` scripts: Homebrew + `brew bundle` on macOS, mise on Linux, and SSH `known_hosts` for GitHub and GitLab.

## Push it to another host

Once one machine is set up, `~/.zsh/install.sh` carries the setup elsewhere. The target needs internet access.

```sh
# install onto a remote SSH host you can reach
~/.zsh/install.sh <ssh-host>

# or run it directly on the target machine
~/.zsh/install.sh local
```

The remote path scp's the script over, installs chezmoi there, applies the repo, and sets `pull.rebase true`.

## Adding skills

Agent skills live in `~/.agents/skills`, installed with `npx skills`. They're
gitignored by default so vendored or work-internal ones never get committed by
accident. A freshly added skill won't show up in `git status` until you
allowlist it in `.gitignore`:

```
!dot_agents/skills/<name>/
```

The lockfile (`dot_skill-lock.json`) stays untracked too, so on a new machine you
re-run `npx skills` to pull your set back rather than relying on this repo.

## EurKey (optional)

If you want my keyboard layout, grab [EurKey](https://eurkey.steffen.bruentjen.eu/) v1.3 Beta.
