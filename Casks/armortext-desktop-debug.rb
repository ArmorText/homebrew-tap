cask "armortext-desktop-debug" do
  version "0.35.15"
  sha256 "4d85240aa47e51509748bfca3cb4d2b32ea17fd0030d55bb776ccc5d273cb989"

  url "https://downloads.armortext.com/desktop/debug/#{version}/ArmorText-#{version}-mac64.dmg"
  name "ArmorText (Debug)"
  desc "ArmorText Desktop Messaging Client (Debug Build)"
  homepage "https://armortext.com/"

  conflicts_with cask: "armortext-desktop"
  depends_on :macos

  app "ArmorText.app"

  # Aggressive close at the very start of the process
  preflight_steps do
    run "/usr/bin/osascript",
        args:         ["-e", 'tell application id "co.armortext.desktop" to quit'],
        must_succeed: false
  end

  # Correcting permissions and ownership post-installation
  postflight_steps do
    set_permissions "{{appdir}}/ArmorText.app", "ug+w"
    set_permissions "{{appdir}}/ArmorText.app", "go+rX"
    set_ownership "{{appdir}}/ArmorText.app", user: "root"

    # write_file cannot use sudo, so stage the content and copy it into place with tee
    write_file "config.ini", "updatesEnabled = false\n"
    run "/bin/mkdir",
        args: ["-p", "/Library/Application Support/ArmorText"],
        sudo: true
    run "/usr/bin/tee",
        args:       ["/Library/Application Support/ArmorText/config.ini"],
        stdin_path: "config.ini",
        sudo:       true

    run "/usr/bin/open",
        args: ["{{appdir}}/ArmorText.app"]
  end

  # For some reason this does not work on re-install
  uninstall quit: "co.armortext.desktop"

  zap trash: "/Library/Application Support/ArmorText"
end
