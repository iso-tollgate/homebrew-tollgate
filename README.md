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
brew install --build-from-source ./Formula/iso-tollgate.rb
brew test iso-tollgate
brew audit --strict --online iso-tollgate
```

All three should complete without errors before merging a formula change. `brew audit --strict --online` in particular catches style and metadata issues that `brew install` alone won't.

If you need to start over (e.g. after editing the formula):

```bash
brew uninstall iso-tollgate
brew install --build-from-source ./Formula/iso-tollgate.rb
```

## Status

Scaffolded `2026-06-21`, formula targets `iso-tollgate==0.1.0` (first PyPI release). The `resource` blocks for runtime dependencies (`xmlschema`, `lxml`, `typer`, `rich`, `anthropic`, `pydantic`) still need to be generated with `poet` and added — see the `TODO` comment in `Formula/iso-tollgate.rb`.
