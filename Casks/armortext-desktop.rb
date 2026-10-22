cask "armortext-desktop" do
  arch arm: "mac64a", intel: "mac64"

  version "0.37.1"
  sha256 arm:   "1aaecd494d11e9f08f6e0549cea124ca82d84439624e658742101799fe5212c1",
         intel: "a87f532984540c36074de69f13f7b0223098904b81e69fb21ff2da3c68dbc050"

  url "https://cdn.armortext.com/development/downloads/desktop/release/#{version}/ArmorText-#{version}-#{arch}.dmg"
  name "ArmorText"
  desc "ArmorText Desktop Messaging Client"
  homepage "https://armortext.com/"

  conflicts_with cask: "armortext-desktop-debug"
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
    # Upgrades keep the existing app folder, which the last install made
    # root-owned, so changing its mode needs sudo as well
    run "/bin/chmod",
        args: ["-R", "ug+w", "{{appdir}}/ArmorText.app"],
        sudo: true
    run "/bin/chmod",
        args: ["-R", "go+rX", "{{appdir}}/ArmorText.app"],
        sudo: true
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
