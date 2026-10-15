cask "armortext-desktop-debug" do
  arch arm: "mac64a", intel: "mac64"

  version "0.37.0"
  sha256 arm:   "140b2c4761bfdbe6d8246873f85ee4dfe83a9be9333e9ca3285af7a83bbbd8fb",
         intel: "ac0cac78d2e3327bca4a23795cd1e22e7532dc91243a45fb9117485dc1414082"

  url "https://cdn.armortext.com/development/downloads/desktop/debug/#{version}/ArmorText-#{version}-#{arch}.dmg"
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

    # The sandbox blocks open, and only sudo steps run outside it, so drop
    # back to the installing user to launch the app as them, not as root
    run "/bin/sh",
        args:         [
          "-c",
          'exec /bin/launchctl asuser "$SUDO_UID" /usr/bin/sudo -u "$SUDO_USER" /usr/bin/open "$1"',
          "sh",
          "{{appdir}}/ArmorText.app",
        ],
        sudo:         true,
        must_succeed: false
  end

  # For some reason this does not work on re-install
  uninstall quit: "co.armortext.desktop"

  zap trash: "/Library/Application Support/ArmorText"
end
