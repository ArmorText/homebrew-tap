cask "armortext-desktop" do
  version "0.35.15"
  sha256 "555b1d149565cbee372fc009967cb6c4cfa261315e40279013c74c9c16921e30"

  url "https://downloads.armortext.com/desktop/release/#{version}/ArmorText-#{version}-mac64.dmg"
  name "ArmorText"
  desc "ArmorText Desktop Messaging Client"
  homepage "https://armortext.com"

  app "ArmorText.app"

  # Correcting permissions and ownership post-installation
  postflight do
    # chmod -R ug+w ArmorText.app
    system_command "/bin/chmod",
                   args: ["-R", "ug+w", "#{appdir}/ArmorText.app"],
                   sudo: true

    # chmod -R go+rX ArmorText.app
    system_command "/bin/chmod",
                   args: ["-R", "go+rX", "#{appdir}/ArmorText.app"],
                   sudo: true

    # chown -R root:staff ArmorText.app
    system_command "/usr/sbin/chown",
                   args: ["-R", "root:staff", "#{appdir}/ArmorText.app"],
                   sudo: true
  end
  
end
