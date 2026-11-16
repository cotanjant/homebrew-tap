class Thunder < Formula
  desc "A small FL Studio-style DAW in Rust"
  homepage "https://cotanjant.github.io/thunder/"
  version "1.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cotanjant/thunder/releases/download/v1.0.0/thunder-aarch64-apple-darwin.tar.xz"
      sha256 "4d8a962f860729011881009ec97069569e5ce050ae360674a8e59b08b8026a2b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cotanjant/thunder/releases/download/v1.0.0/thunder-x86_64-apple-darwin.tar.xz"
      sha256 "444f559883ca7d29f8064a3358514ccf3a862f4675adba14267366bd8ca9726f"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/cotanjant/thunder/releases/download/v1.0.0/thunder-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "13f012093f971a19ad6bde0ab7258b738e0b0a8e068657ae6c89797aca50571d"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "thunder"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "thunder"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "thunder"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
