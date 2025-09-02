# Homebrew Support for LxgwWenKaiNerdFont

This directory contains Homebrew cask formulas for installing LxgwWenKaiNerdFont on macOS.

## Usage

### Option 1: Use as Custom Tap (Recommended for Now)

Add this repository as a custom Homebrew tap and install the fonts:

```bash
# Add this repository as a custom tap
brew tap Yikai-Liao/LxgwWenKaiNerdFont

# Install the fonts
brew install --cask font-lxgw-wenkai-nerd
brew install --cask font-lxgw-wenkai-mono-nerd
```

### Option 2: Submit to Official homebrew-cask-fonts

The formulas in this directory can be submitted to the official [homebrew-cask-fonts](https://github.com/Homebrew/homebrew-cask-fonts) repository for wider distribution.

To submit:

1. Fork the [homebrew-cask-fonts](https://github.com/Homebrew/homebrew-cask-fonts) repository
2. Copy the cask files to their `Casks/` directory
3. Submit a pull request

## Formulas Included

- **font-lxgw-wenkai-nerd.rb**: Proportional variant (LXGWWenKai Nerd Font)
- **font-lxgw-wenkai-mono-nerd.rb**: Monospace variant (LXGWWenKaiMono Nerd Font)

## Updating Formulas

When a new release is published, update the `version` and `sha256` fields in both formula files. The SHA256 checksum can be found in the GitHub release assets or calculated using:

```bash
curl -sL https://github.com/Yikai-Liao/LxgwWenKaiNerdFont/releases/download/v1.520/lxgw-wenkai-nerd.zip | shasum -a 256
```

## Font Installation Locations

Homebrew installs fonts to:
- **User**: `~/Library/Fonts/`
- **System**: `/Library/Fonts/` (with sudo)

After installation, the fonts will be available in all macOS applications.