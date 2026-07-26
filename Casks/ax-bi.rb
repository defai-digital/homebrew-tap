cask "ax-bi" do
  version "2.2.2"
  sha256 "047dcb507ffecace9991397e12f8f83e4e0158f80b9198a0fda94c49f2b08179"

  url "https://github.com/defai-digital/ax-bi/releases/download/ax-bi-desktop-v2.2.2/AX.BI_#{version}_aarch64.dmg"
  name "AX BI"
  desc "Desktop client and local runtime launcher for AX BI"
  homepage "https://github.com/defai-digital/ax-bi"

  livecheck do
    url "https://github.com/defai-digital/ax-bi.git"
    regex(/^ax-bi-desktop-v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on arch: :arm64
  depends_on macos: :monterey
  depends_on formula: "colima"
  depends_on formula: "lima"
  depends_on formula: "docker"
  depends_on formula: "docker-compose"

  app "AX BI.app"

  preflight do
    # Clears any pre-existing bundle so upgrades from untracked installs do not
    # hit Homebrew's "already an App" guard.
    app_path = "#{appdir}/AX BI.app"
    FileUtils.rm_r(app_path) if File.exist?(app_path)
  end

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/AX BI.app"]
  end

  zap trash: [
    "~/Library/Application Support/com.axbi.desktop",
    "~/Library/Caches/com.axbi.desktop",
    "~/Library/Logs/com.axbi.desktop",
    "~/Library/Preferences/com.axbi.desktop.plist",
    "~/Library/Saved Application State/com.axbi.desktop.savedState",
  ]
end
