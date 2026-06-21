class Tollgate < Formula
  include Language::Python::Virtualenv

  desc "Pre-submission safety gate for ISO 20022 pacs.008 payment messages"
  homepage "https://github.com/ArunMishra1/tollgate"

  # NOT YET LIVE (2026-06-20): url and sha256 below are placeholders.
  # This formula cannot install anything until iso-tollgate has a real
  # release with a source distribution (sdist) on PyPI -- see
  # https://pypi.org/project/iso-tollgate/#files once it exists.
  #
  # To activate this formula once a release exists:
  #   1. Publish iso-tollgate to PyPI with a source distribution
  #      (not just a wheel -- Homebrew's Python virtualenv formulas
  #      build from sdist).
  #   2. Get the sdist URL and its sha256:
  #        curl -sL <sdist-url> | shasum -a 256
  #   3. Replace url/sha256 below with the real values.
  #   4. Generate resource stanzas for dependencies with:
  #        pip install homebrew-pypi-poet
  #        poet -f iso-tollgate > formula_deps.rb
  #      and paste the `resource` blocks below the dependencies note.
  #   5. Test locally before pushing:
  #        brew install --build-from-source --verbose --debug ./tollgate.rb
  url "https://files.pythonhosted.org/packages/PLACEHOLDER/iso-tollgate-0.1.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  license "Apache-2.0"

  depends_on "python@3.11"

  # Runtime dependencies (xmlschema, lxml, typer, rich, anthropic,
  # pydantic) need their own `resource` stanzas here, generated via
  # homebrew-pypi-poet against the real published package -- not
  # hand-written, since exact pinned versions and their own sha256
  # checksums need to come from what's actually on PyPI at release
  # time, not guessed.

  def install
    virtualenv_install_with_resources
  end

  test do
    # A formula must have a working test block before submission.
    # This one is intentionally minimal -- confirms the CLI entrypoint
    # exists and responds, not a full functional test (that lives in
    # the main tollgate repo's own pytest suite).
    assert_match "Pre-submission safety gate", shell_output("#{bin}/tollgate --help")
  end
end
