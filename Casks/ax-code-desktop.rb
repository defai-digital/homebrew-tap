cask "ax-code-desktop" do
  version "7.7.0"
  sha256 "168f8ebd36c621ea93f25a15bbb8d9b1b86d0c0a01c84c69df1231505d9ca0ec"

  url "https://github.com/defai-digital/ax-code/releases/download/desktop-v7.7.0/AX-Code-#{version}-mac-arm64.dmg"
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
