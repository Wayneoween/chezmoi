# grml.zsh stays vendored in the repo

The other zsh plugins come in through `.chezmoiexternal.toml`, so reviews keep suggesting grml.zsh should move there too. It stays vendored on purpose: I want the Linux prompt setup pinned and readable in the repo, not refreshed from upstream on a timer. Updates happen by hand when there's a reason to (last synced against upstream 2026-07-17). Don't re-suggest externalizing it.
