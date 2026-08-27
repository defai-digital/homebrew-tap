cask "ax-code-desktop" do
  version "7.9.0"
  sha256 "375da97cafa32c2c69b64d34b896c11e684b7369390ddd183c21c52fb99b57e1"

  url "https://github.com/defai-digital/ax-code/releases/download/desktop-v7.9.0/AX-Code-#{version}-mac-arm64.dmg"
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
