cask "ax-code-desktop" do
  version "7.10.0"
  sha256 "ee79e3117baf72eb24d72c85333156c3ea03e8c0d1d8c86d0ddb1d0575cb3d51"

  url "https://github.com/defai-digital/ax-code/releases/download/desktop-v7.10.0/AX-Code-#{version}-mac-arm64.dmg"
  name "AX Code Desktop"
  desc "AI coding assistant desktop app powered by AX Code"
  homepage "https://github.com/defai-digital/ax-code"

  livecheck do
    url "https://github.com/defai-digital/ax-code.git"
    regex(/^desktop-v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on arch: :arm64
  depends_on macos: :monterey

  app "AX Code.app"

  zap trash: [
    "~/Library/Application Support/AX Code Desktop",
    "~/Library/Caches/AX Code Desktop",
    "~/Library/Logs/AX Code Desktop",
    "~/Library/Preferences/ai.defai.ax-code-app.plist",
  ]
end
