cask "ax-code-desktop" do
  version "7.6.1"
  sha256 "2b214243f470482b42ce9e82653d3b1b1210d84959c1c637e71a276bfb257e95"

  url "https://github.com/defai-digital/ax-code/releases/download/desktop-v7.6.1/AX-Code-#{version}-mac-arm64.dmg"
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
