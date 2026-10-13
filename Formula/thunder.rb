class Thunder < Formula
  desc "A small FL Studio-style DAW in Rust"
  homepage "https://cotanjant.github.io/thunder/"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cotanjant/thunder/releases/download/v0.3.0/thunder-aarch64-apple-darwin.tar.xz"
      sha256 "15cfc181b2f5c2885e75a224f37faff40b540671fbf4a3f8967b1eca5d7897ca"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cotanjant/thunder/releases/download/v0.3.0/thunder-x86_64-apple-darwin.tar.xz"
      sha256 "10d62c1b2d4e221a216c4246ba8034c8336510075a8463baba9817185aa93560"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/cotanjant/thunder/releases/download/v0.3.0/thunder-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "81a8fbfb88528a9a09106cd52a5422b7a0b4fe15ce43d50b35039f6a4504b870"
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
