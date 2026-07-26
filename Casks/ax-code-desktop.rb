cask "ax-code-desktop" do
  version "7.1.0"
  sha256 "6e0b0ccb4c0ca7700ac12b0aa3982a3d24cdf4c9246c5fb1ab951fa18b316aec"

  url "https://github.com/defai-digital/ax-code/releases/download/desktop-v7.1.0/AX-Code-#{version}-mac-arm64.dmg"
  name "AX Code Desktop"
  desc "AI coding assistant desktop app powered by AX Code"
  homepage "https://github.com/defai-digital/ax-code"

  app "AX Code.app"

  postflight do
    system_command "/usr/bin/xattr",
      args: ["-cr", "#{appdir}/AX Code.app"]
  end

  zap trash: [
    "~/Library/Application Support/AX Code Desktop",
    "~/Library/Preferences/ai.defai.ax-code-app.plist",
    "~/Library/Caches/AX Code Desktop",
    "~/Library/Logs/AX Code Desktop",
  ]
end
