cask "ax-code-desktop" do
  version "7.8.3"
  sha256 "a745985d915836a6120a0bc2fb80473ac35b38d2f0b7216ac4a510dbb653c2c0"

  url "https://github.com/defai-digital/ax-code/releases/download/desktop-v7.8.3/AX-Code-#{version}-mac-arm64.dmg"
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
