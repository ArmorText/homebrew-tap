cask "armortext-desktop-debug" do
  arch arm: "mac64a", intel: "mac64"

  version "0.37.3"
  sha256 arm:   "d3bd36c7b5248afd28217f8bec1edf2abf432fa508fe6e1e05aea52aa5f89181",
         intel: "5bcacc9b99396df212cc6791fe8aa0d27ae16d1ee7aca7f9d3714b0cd7cbc496"

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
