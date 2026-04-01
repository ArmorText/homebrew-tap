cask "armortext-desktop" do
  version "0.35.15"
  sha256 "555b1d149565cbee372fc009967cb6c4cfa261315e40279013c74c9c16921e30"

  url "https://downloads.armortext.com/desktop/release/#{version}/ArmorText-#{version}-mac64.dmg"
  name "ArmorText"
  desc "ArmorText Desktop Messaging Client"
  homepage "https://armortext.com"

  app "ArmorText.app"
end
