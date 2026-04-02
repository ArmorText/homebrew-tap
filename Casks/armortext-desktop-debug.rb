cask "armortext-desktop-debug" do
  version "0.35.15"
  sha256 "4d85240aa47e51509748bfca3cb4d2b32ea17fd0030d55bb776ccc5d273cb989"

  url "https://downloads.armortext.com/desktop/debug/#{version}/ArmorText-#{version}-mac64.dmg"
  name "ArmorText"
  desc "ArmorText Desktop Messaging Client"
  homepage "https://armortext.com"

  conflicts_with cask: "armortext-desktop"

  app "ArmorText.app"

  # For some reason this does not work on re-install
  uninstall quit: "co.armortext.desktop"

  # Aggressive close at the very start of the process
  preflight do
    system_command "osascript",
                   args: ["-e", 'tell application id "co.armortext.desktop" to quit'],
                   must_succeed: false
  end

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

    config_path = "/Library/Application Support/ArmorText/config.ini"
    config_content = "updatesEnabled = false\n"

    # Create the directory
    system_command "/bin/mkdir", 
                   args: ["-p", File.dirname(config_path)], 
                   sudo: true

    # Write the file content using 'tee' and the 'input' parameter
    # This pipes the Ruby string 'config_content' directly into the file via sudo
    system_command "/usr/bin/tee", 
                   args: [config_path], 
                   input: config_content, 
                   sudo: true, 
                   print_stdout: false

    # Open the app
    system_command "/usr/bin/open", args: ["#{appdir}/ArmorText.app"]
  end

  zap trash: [
    "~/Library/Application Support/ArmorText/config.ini"
  ]
  
end
