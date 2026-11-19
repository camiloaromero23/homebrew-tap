class RexSessionManager < Formula
  desc "Project session manager for the Rex terminal multiplexer"
  homepage "https://github.com/camiloaromero23/rex-session-manager"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/camiloaromero23/rex-session-manager/releases/download/v0.2.0/rex-session-manager-aarch64-apple-darwin.tar.xz"
      sha256 "6060af522c4ec72359188f6bd8bac0016d6a46c771438ff527afc06e0a947f45"
    end
    if Hardware::CPU.intel?
      url "https://github.com/camiloaromero23/rex-session-manager/releases/download/v0.2.0/rex-session-manager-x86_64-apple-darwin.tar.xz"
      sha256 "2c222c2f7308673b20434036807bfdf2ab309277550d71793bec25cf6e760974"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin":  {},
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
      bin.install "rex-session-manager"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "rex-session-manager"
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
