class AxEngine < Formula
  desc "Mac-first LLM inference engine targeting Apple M4+ Silicon"
  homepage "https://github.com/defai-digital/ax-engine"
  url "https://github.com/defai-digital/ax-engine/releases/download/v6.11.1/ax-engine-v6.11.1-macos-arm64.tar.gz"
  sha256 "57ffc6a7eb2d461cef8bc85551f9464b61b4093f493ed3af0c3df59328a24235"
  version "6.11.1"
  license "Apache-2.0"

  # Tap-local mlx/mlx-c, not homebrew-core's: homebrew-core's mlx formula
  # derives its build's MACOSX_DEPLOYMENT_TARGET from
  # MacOS.version.major.minor, which Homebrew always reports as "<major>.0"
  # on macOS 11+ -- structurally below the 26.2 floor MLX's NAX (Neural
  # Accelerator) GEMM/attention kernels require, so the homebrew-core build
  # silently loses ~3-4x prefill throughput with no error. See
  # Formula/mlx.rb in this tap for the fix.
  #
  # Explicit mlx dep (not only via mlx-c) so install-time linkage rewrite
  # always resolves the tap's dylib, never a core bottle or a pip wheel path.
  depends_on arch: :arm64
  depends_on :macos
  depends_on "defai-digital/tap/mlx"
  depends_on "defai-digital/tap/mlx-c"

  # Mach-O names that load libmlx at runtime. The GitHub release archive is
  # built against pip/venv MLX (correct for source and wheel perf parity) and
  # therefore embeds @rpath/libmlx.dylib plus a builder-host LC_RPATH. Homebrew
  # must re-point those load commands at this tap's mlx formula before the
  # binaries can run on user machines.
  MLX_LINKED_BINS = %w[ax-engine-server ax-engine-bench].freeze

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

    # Clear quarantine while files are still writable. Relinking below
    # may drop write bits after codesign.
    bin.children.each do |executable|
      system "xattr", "-dr", "com.apple.quarantine", executable
    end

    relink_release_binaries_to_tap_mlx!
  end

  def caveats
    <<~EOS
      ax-engine binaries for this release are Developer ID signed and notarized by Apple.

      Install rewrites libmlx load commands on ax-engine-server and
      ax-engine-bench to this tap's mlx formula, then ad-hoc re-signs
      those binaries (required after Mach-O edits). Do not expect the
      release tarball to run against pip site-packages MLX on its own.

      The mlx / mlx-c dependencies build from this tap's formulas (not
      homebrew-core bottles) so MLX NAX acceleration is not silently
      disabled on macOS 26.x. Xcode -- including its Metal Toolchain
      component, a separate download since Xcode 26
      (xcodebuild -downloadComponent metalToolchain) -- is required for
      that source build; an Apple Developer account is not.
    EOS
  end

  test do
    assert_match "ax-engine", shell_output("#{bin}/ax-engine --help 2>&1")
    # These two load libmlx; --help must succeed under dyld (catches broken rpath).
    assert_match "ax-engine-server", shell_output("#{bin}/ax-engine-server --help 2>&1")
    assert_match "ax-engine-bench", shell_output("#{bin}/ax-engine-bench --help 2>&1")
  end

  # Re-point release-archive Mach-O load commands at the tap-local libmlx.
  # Keep this logic in the formula (not the release tarball): release builds
  # intentionally link pip MLX for performance parity; Homebrew users must
  # use the formula-owned dylib under HOMEBREW_PREFIX.
  def relink_release_binaries_to_tap_mlx!
    mlx = Formula["defai-digital/tap/mlx"]
    libmlx = mlx.opt_lib/"libmlx.dylib"
    odie "tap mlx dylib missing: #{libmlx}" unless libmlx.exist?

    MLX_LINKED_BINS.each do |name|
      binary = bin/name
      next unless binary.file?

      macho = MachO.open(binary.to_s)
      libmlx_refs = macho.linked_dylibs.select { |d| File.basename(d) == "libmlx.dylib" }
      next if libmlx_refs.empty?

      chmod "u+w", binary

      libmlx_refs.uniq.each do |old|
        next if old == libmlx.to_s

        MachO::Tools.change_install_name(binary.to_s, old, libmlx.to_s)
      end

      # Drop builder-host LC_RPATH entries (pip site-packages, venv paths, etc.).
      # Absolute install names do not need them; leaving them confuses diagnosis.
      MachO.open(binary.to_s).rpaths.uniq.each do |rpath|
        MachO::Tools.delete_rpath(binary.to_s, rpath)
      rescue MachO::RpathUnknownError, MachO::MachOError
        # Concurrent delete or already removed — safe to ignore.
      end

      # install_name_tool / ruby-macho invalidate the Developer ID signature.
      # Ad-hoc re-sign is the Homebrew-compatible pattern for edited prebuilts.
      system "codesign", "--force", "--sign", "-", binary
    end
  end
end
