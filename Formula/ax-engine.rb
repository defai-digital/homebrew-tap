class AxEngine < Formula
  desc "Mac-first LLM inference engine targeting Apple M4+ Silicon"
  homepage "https://github.com/defai-digital/ax-engine"
  url "https://github.com/defai-digital/ax-engine/releases/download/v6.13.1/ax-engine-v6.13.1-macos-arm64.tar.gz"
  version "6.13.1"
  sha256 "a47126f938eda22b4fa904b5367aa65201722b314f707fca3f7ab58ee7c820c0"
  license "Apache-2.0"

  depends_on arch: :arm64
  depends_on :macos

  def install
    bin.install "ax-engine",
                "ax-engine-server",
                "ax-engine-bench",
                "ax-engine-download-model.py",
                "ax-engine-prepare-mtp-sidecar.py",
                "ax-engine-prepare-gemma4-assistant-mtp.py",
                "ax-engine-prepare-glm-mtp-sidecar.py",
                "ax-engine-prepare-qwen36-mtp-sidecar.py",
                "ax-engine-check-mtp-sidecar-provenance.py"
    # Keep mlx.metallib beside libmlx.dylib: MLX resolves its precompiled
    # kernels relative to the loaded dylib. Release binaries also carry
    # @loader_path/../libexec so this private Homebrew runtime remains
    # relocatable without editing or invalidating Developer ID signatures.
    # libexec also avoids colliding with a separately installed mlx formula.
    libexec.install "libmlx.dylib", "libjaccl.dylib", "mlx.metallib"
    doc.install "MLX-LICENSE.txt"
  end

  def caveats
    <<~EOS
      ax-engine binaries for this release are Developer ID signed and notarized
      by Apple. The formula installs the release's pinned, prebuilt MLX runtime
      beside its mlx.metallib without rewriting the signed Mach-O files.
      End users do not need Python, Homebrew MLX, Xcode, or the Metal Toolchain.
    EOS
  end

  test do
    assert_match "ax-engine", shell_output("#{bin}/ax-engine --help 2>&1")
    # These two load libmlx; --help must succeed under dyld (catches broken rpath).
    assert_match "ax-engine-server", shell_output("#{bin}/ax-engine-server --help 2>&1")
    assert_match "ax-engine-bench", shell_output("#{bin}/ax-engine-bench --help 2>&1")
  end
end
