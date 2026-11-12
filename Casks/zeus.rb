# Rendered by .claude/skills/release-and-launch/scripts/release_files.py, which
# fills the three mustache placeholders below with the release's own values (it
# refuses if any of the three is missing, or if any placeholder is left
# unfilled). Mustache rather than this repository's usual <key> spelling because
# < and > are ordinary characters inside Ruby source, so a <version> here would
# be ambiguous — as readily a comparison as a slot. Do not name a placeholder in
# a comment here — the renderer would substitute it there too. The tap's copy
# (Zeus-Mode/homebrew-tap, Casks/zeus.rb) is DERIVED from this file by a release
# run: edit it here, never there, or the next release overwrites it.
#
# depends_on below is Homebrew's symbolic spelling of the same floor the helper
# receives as a number and writes into the appcast: both change together.
cask "zeus" do
  version "0.36.0"
  sha256 "e7b9321699c470b36689f1bbdbd09cb2e97187cc111c0af5327308c0f71e8722"

  url "https://zeusmode.ai/releases/Zeus-#{version}.dmg"
  name "Zeus"
  desc "One window over every Claude Code and Codex session"
  homepage "https://zeusmode.ai/"

  livecheck do
    url "https://zeusmode.ai/releases/latest.json"
    regex(/"version"\s*:\s*"v?(\d+(?:\.\d+)+)"/i)
  end

  # The app updates itself: a Homebrew copy runs Sparkle as a download does (Zeus
  # distribution brief, D2 amended), so plain brew upgrade leaves it to Sparkle.
  # True from the release after v0.27.0, which shipped that app under false.
  auto_updates true
  depends_on macos: ">= :sonoma"

  app "Zeus.app"
  binary "#{appdir}/Zeus.app/Contents/MacOS/zeus-daemon", target: "zeus"

  uninstall launchctl: "ai.zeus.daemon"

  zap trash: [
    "~/Library/Application Support/Zeus",
    "~/Library/LaunchAgents/ai.zeus.daemon.plist",
  ]

  caveats do
    <<~EOS
      Zeus writes a short block into ~/.claude/CLAUDE.md and ~/.codex/AGENTS.md and
      registers itself as an MCP server. To remove those, run
        zeus integrate uninstall
      BEFORE `brew uninstall zeus` — after it, the command is gone.
    EOS
  end
end
