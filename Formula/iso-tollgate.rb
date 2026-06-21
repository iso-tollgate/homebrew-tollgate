class IsoTollgate < Formula
  include Language::Python::Virtualenv

  desc "Pre-submission safety gate for ISO 20022 pacs.008 payment messages"
  homepage "https://github.com/iso-tollgate/tollgate"
  url "https://files.pythonhosted.org/packages/a3/78/2831498f7459be58619d3b1f973d16d49f18c587d794ae611d87e8a02815/iso_tollgate-0.1.0.tar.gz"
  sha256 "c77d68fcf27c8e92e939d88a944a31fb5de5e4ff1cc475b1981aebd77c3f28d9"
  license "Apache-2.0"

  depends_on "python@3.12"

  # =========================================================================
  # TODO before merging: paste in resource blocks for every runtime
  # dependency (xmlschema, lxml, typer, rich, anthropic, pydantic), each
  # pinned to a specific version with its own sha256. Generate these with:
  #
  #   gem install homebrew-pypi-poet
  #   pip install iso-tollgate
  #   poet iso-tollgate
  #
  # Paste poet's output here, replacing this comment block. Do NOT guess or
  # hand-write these hashes -- a wrong one breaks `brew install` silently.
  # =========================================================================

  test do
    system bin/"tollgate", "--help"
  end
end
