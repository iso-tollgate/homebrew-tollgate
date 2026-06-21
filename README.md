# homebrew-tollgate

Homebrew tap for [Tollgate](https://github.com/iso-tollgate/tollgate), a pre-submission safety gate for ISO 20022 pacs.008 payment messages.

## Install

```bash
brew tap iso-tollgate/tollgate
brew install iso-tollgate
```

## Usage

```bash
tollgate validate path/to/message.xml
tollgate validate-dir path/to/messages/
tollgate generate --count 10 --out fixtures/
```

See the [main repo](https://github.com/iso-tollgate/tollgate) and [`docs/usage.md`](https://github.com/iso-tollgate/tollgate/blob/main/docs/usage.md) for full CLI and library documentation.

## Updating the formula for a new release

1. Publish the new version to PyPI first (`twine upload dist/*`).
2. Get the new sdist URL and sha256 from PyPI's JSON API:
   ```bash
   curl -s https://pypi.org/pypi/iso-tollgate/<new-version>/json | python3 -c "
   import json, sys
   data = json.load(sys.stdin)
   for url in data['urls']:
       if url['packagetype'] == 'sdist':
           print(url['url'])
           print(url['digests']['sha256'])
   "
   ```
3. Update `url` and `sha256` in `Formula/iso-tollgate.rb`.
4. Regenerate dependency resource blocks if any dependency versions changed:
   ```bash
   gem install homebrew-pypi-poet
   pip install iso-tollgate==<new-version>
   poet iso-tollgate
   ```
5. Run the full test sequence below before opening a PR.

## Testing the formula locally

Requires Homebrew installed on a real machine — this cannot be verified in a sandboxed environment.

```bash
# From the root of this tap repo:
brew tap iso-tollgate/local-testing "$(pwd)"
brew install --build-from-source iso-tollgate/local-testing/iso-tollgate
brew test iso-tollgate/local-testing/iso-tollgate
brew audit --strict iso-tollgate/local-testing/iso-tollgate
```

A bare relative path (`./Formula/iso-tollgate.rb`) does not work — Homebrew requires formulae to be installed from a registered tap, not a raw file path. Use a tap name distinct from the real `iso-tollgate/tollgate` (e.g. `local-testing`) so a local test tap can never collide with the real one or with leftover state from a previous test run. If you've tapped under a different name before, untap it first: `brew untap iso-tollgate/local-testing 2>/dev/null || true`.

All three commands should complete without errors before merging a formula change. `brew audit --strict` in particular catches style and metadata issues that `brew install` alone won't. Building from source compiles `jiter` and `pydantic_core`'s Rust extensions — expect roughly 8-10 minutes, not a hang (see Known Issues below).

If you need to start over (e.g. after editing the formula):

```bash
brew uninstall iso-tollgate
brew untap iso-tollgate/local-testing
```

## Known issues / future work

**Build time (~8-10 minutes per CI run).** `jiter` and `pydantic_core` are Rust-backed packages. Homebrew's `resource` blocks always point at PyPI sdists, never prebuilt wheels, so every CI run compiles both extensions from source via `maturin` (`depends_on "rust" => :build`) — this is what makes `brew install --build-from-source` slow compared to a normal `pip install iso-tollgate`, which just downloads PyPI's prebuilt wheels for these two packages.

Real options for reducing this, none implemented yet:
- **Homebrew bottles.** The standard fix for exactly this problem — a bottle is a prebuilt binary Homebrew caches and serves, so `brew install iso-tollgate` (no `--build-from-source`) skips compilation entirely for anyone using a bottled release. Requires setting up bottle publishing (`brew pr-pull` / GitHub Packages) for this tap, which hasn't been done — right now every install, CI or end-user, builds from source every time.
- **Cache the Cargo/maturin build artifacts between CI runs** (e.g. `actions/cache` keyed on the resource versions) — would speed up CI specifically without addressing end-user install time at all.
- **Audit whether jiter could be dropped or replaced.** It's a transitive dependency via `anthropic` (used for `--explain`). Worth checking on a future pass whether a pure-Python JSON parser would be an acceptable substitute for tollgate's actual usage pattern, if Rust compilation continues to be a recurring source of friction. Not investigated yet — flagging as a question, not a decision.

## Status

Live as of `2026-06-21`. CI (`.github/workflows/tests.yml`) runs `brew audit --strict` against the formula file on every push/PR — this catches Ruby syntax errors, style violations, and metadata problems, but does **not** install or run the formula. A full `brew install --build-from-source` + `brew test` pass (see "Testing the formula locally" above) is required manually before merging any formula change; CI deliberately doesn't attempt this on every push, both because tapping a local path in CI hit several Homebrew tap-naming issues (see commit history) and because the install itself is slow (~8-10 min, compiling Rust extensions from source every time). Targets `iso-tollgate==0.1.0` (first PyPI release).
