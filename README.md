# ArmorText Homebrew Tap

This is the official [Homebrew](https://brew.sh/) tap for **ArmorText**. It provides a streamlined way to install and manage the ArmorText Desktop Client on macOS via the command line, modeled after the official HashiCorp distribution style.

---

## How do I use these?

To install the ArmorText Desktop Client directly, run:

```bash
brew install armortext/tap/armortext-desktop
```

Alternatively, you can add the tap to your local Homebrew installation to make updates more seamless:

```bash
brew tap armortext/tap
brew install armortext-desktop
```

## Available Build Flavors

We provide multiple builds of the desktop client to support different use cases.

| Build Flavor | Installation Command | Description |
| :--- | :--- | :--- |
| **Release** | `brew install armortext/tap/armortext-desktop` | The official stable production build (Recommended). |
| **Debug** | `brew install armortext/tap/armortext-desktop-debug` | Build intended for troubleshooting and development. |

> [!IMPORTANT]
> Both versions install to `/Applications/ArmorText.app`. You should only have one flavor installed at a time. To switch flavors, please uninstall the current version first.

---

## Maintenance and Updates

To ensure you are running the latest version of ArmorText (currently **0.35.15**):

```bash
brew update
brew upgrade armortext-desktop
```

## Troubleshooting

### Overwriting Manual Installations
If you previously installed ArmorText by downloading the `.dmg` from our portal, Homebrew may require a "force" install to take over management of the application:

```bash
brew install --cask --force armortext/tap/armortext-desktop
```

### Verification
To check the installed version, installation path, and metadata:

```bash
brew info --cask armortext-desktop
```

---

## Other Platforms

This tap specifically supports **macOS (64-bit)**. For Windows (64-bit/32-bit) or Linux (64-bit) installers, please visit our official download portal:

👉 [**ArmorText Download Portal**](https://portal.armortext.co/#!/download/desktop)

## Contributing

If you encounter issues with this cask or wish to suggest improvements:

1.  Search for existing [Issues](https://github.com/armortext/homebrew-tap/issues).
2.  If the issue is new, please open a new issue with details about your macOS version.
3.  Pull Requests are welcome. Please ensure that any version updates include the correct `sha256` checksum for the latest `.dmg`.

---

**Note:** This repository is maintained by ArmorText. For security-related inquiries or enterprise support, please contact your account representative or visit the [ArmorText Support Portal](https://portal.armortext.co/).
