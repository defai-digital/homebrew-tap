cask "ax-studio" do
  version "2.2.2"
  sha256 "a6e4be21ebd74f6663e309ce954453e5b346af9a1d69712b28646be36e984e8d"

  url "https://github.com/defai-digital/ax-studio/releases/download/v#{version}/AX.Studio_#{version}_aarch64.dmg"
  name "AX Studio"
  desc "AI workspace for cloud models, local inference, tools, and research"
  homepage "https://github.com/defai-digital/ax-studio"

  depends_on arch: :arm64
  depends_on macos: :sequoia

  # In-app updater is for manual/DMG installs only. Homebrew owns upgrades.
  auto_updates false

  preflight do
    # Clears any pre-existing bundle (current or pre-rename "Ax-Studio.app" name) so
    # upgrades from untracked installs don't hit Homebrew's "already an App" guard.
    [
      "#{appdir}/AX Studio.app",
      "#{appdir}/Ax-Studio.app",
    ].each { |legacy_app| FileUtils.rm_rf(legacy_app) }
  end

  app "AX Studio.app"

  zap trash: [
    "~/Library/Application Support/AX Studio",
    "~/Library/Application Support/Ax-Studio",
    "~/Library/Caches/ai.axstudio.app",
    "~/Library/Logs/AX Studio",
    "~/Library/Logs/Ax-Studio",
    "~/Library/Preferences/ai.axstudio.app.plist",
    "~/Library/Saved Application State/ai.axstudio.app.savedState",
  ]

  caveats <<~EOS
    AX Studio also ships an in-app updater for manual DMG installs.
    If you installed with Homebrew, prefer:

      brew upgrade --cask ax-studio

    Using the in-app "Update Now" action can desync the Homebrew cask.
  EOS
end
