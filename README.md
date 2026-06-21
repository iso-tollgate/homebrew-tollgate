# homebrew-tollgate

Homebrew tap for [tollgate](https://github.com/ArunMishra1/tollgate) — a pre-submission safety gate for ISO 20022 pacs.008 payment messages.

## Status: scaffolded, not live yet

This formula cannot currently install anything. `Formula/tollgate.rb` has placeholder values for the package URL and checksum because **tollgate has no PyPI release yet** — Homebrew's Python virtualenv formulas need a real source distribution to build from.

Once `iso-tollgate` has a real release on PyPI, the formula needs:
1. The real sdist URL and its SHA256 checksum
2. Resource stanzas for runtime dependencies (generated via `homebrew-pypi-poet` against the real published package)
3. A local test install before this tap goes live: `brew install --build-from-source --verbose --debug ./Formula/tollgate.rb`

See the comments in `Formula/tollgate.rb` for the exact steps.

## Once it's live, installation will look like

```bash
brew tap ArunMishra1/tollgate
brew install tollgate
```

or in one line:

```bash
brew install ArunMishra1/tollgate/tollgate
```

## License

Apache 2.0, matching the main tollgate repository.
