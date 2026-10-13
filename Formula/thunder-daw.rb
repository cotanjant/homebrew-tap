class ThunderDaw < Formula
  desc "A small FL Studio-style DAW in Rust"
  homepage "https://canureal.github.io/thunder-daw/"
  version "0.2.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/canureal/thunder-daw/releases/download/v0.2.6/thunder-daw-aarch64-apple-darwin.tar.xz"
      sha256 "b8ea660ccb7c2d8317e77bdc606580b05715ce26e79a319a06ab12af7dd33342"
    end
    if Hardware::CPU.intel?
      url "https://github.com/canureal/thunder-daw/releases/download/v0.2.6/thunder-daw-x86_64-apple-darwin.tar.xz"
      sha256 "7e5652c4eb37f50099b1197b62c1c8822a3c934b461225d6425a3ba5136332a5"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/canureal/thunder-daw/releases/download/v0.2.6/thunder-daw-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "e76fba37a7e42c16abee4bb6df3edae41ef871f90c47ba137058ce4ed9b73745"
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
      bin.install "thunder-daw"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "thunder-daw"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "thunder-daw"
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
