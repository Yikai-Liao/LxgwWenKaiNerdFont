# LXGW WenKai Nerd Font

**LXGW WenKai** patched with **Nerd Font** glyphs for enhanced terminal and coding experience.

## Font Family

This repository provides two variants of LXGW WenKai fonts:

### LXGWWenKai Nerd Font (Proportional)
- LXGWWenKaiNerdFont-Light.ttf
- LXGWWenKaiNerdFont-Regular.ttf 
- LXGWWenKaiNerdFont-Medium.ttf

### LXGWWenKaiMono Nerd Font (Monospace)
- LXGWWenKaiMonoNerdFont-Light.ttf
- LXGWWenKaiMonoNerdFont-Regular.ttf
- LXGWWenKaiMonoNerdFont-Medium.ttf

## Installation

### macOS (Homebrew)

Install the fonts using Homebrew by adding this repository as a custom tap:

```bash
# Add this repository as a custom Homebrew tap
brew tap Yikai-Liao/LxgwWenKaiNerdFont

# Install proportional variant (LXGWWenKai Nerd Font)
brew install --cask font-lxgw-wenkai-nerd

# Install monospace variant (LXGWWenKaiMono Nerd Font)
brew install --cask font-lxgw-wenkai-mono-nerd

# Or install both variants at once
brew install --cask font-lxgw-wenkai-nerd font-lxgw-wenkai-mono-nerd
```

- **font-lxgw-wenkai-nerd**: Contains the proportional variants (Light, Regular, Medium)
- **font-lxgw-wenkai-mono-nerd**: Contains the monospace variants (Light, Regular, Medium)

**Note**: These formulas can also be submitted to the official [homebrew-cask-fonts](https://github.com/Homebrew/homebrew-cask-fonts) repository for wider distribution. See the [Casks/README.md](Casks/README.md) for submission instructions.

### Arch Linux (AUR)

Install the fonts using your favorite AUR helper. The fonts are split into two separate packages:

```bash
# Install proportional variant (LXGWWenKai Nerd Font)
paru -S ttf-lxgw-wenkai-nerd

# Install monospace variant (LXGWWenKaiMono Nerd Font)  
paru -S ttf-lxgw-wenkai-mono-nerd

# Or using yay
yay -S ttf-lxgw-wenkai-nerd ttf-lxgw-wenkai-mono-nerd
```

- **ttf-lxgw-wenkai-nerd**: Contains the proportional variants (Light, Regular, Medium)
- **ttf-lxgw-wenkai-mono-nerd**: Contains the monospace variants (Light, Regular, Medium)

### Manual Installation

1. Download the latest release from [Releases](https://github.com/Yikai-Liao/LxgwWenKaiNerdFont/releases)
2. Extract the zip file
3. Install the font files:
   - **Linux**: Copy TTF files to `~/.local/share/fonts/` or `/usr/share/fonts/`
   - **Windows**: Right-click font files and select "Install"
   - **macOS**: Double-click font files and click "Install Font"

## Font Features

- **Chinese Support**: Excellent Chinese character coverage from LXGW WenKai
- **Nerd Font Icons**: Complete set of developer-friendly icons and symbols
- **Programming**: Optimized for coding with clear distinction between similar characters
- **Multiple Weights**: Light, Regular, and Medium weights available
- **Dual Variants**: Both proportional and monospace versions

## Font Names in Applications

When selecting fonts in applications, use these names:

- **Proportional**: `LXGWWenKai Nerd Font`
- **Monospace**: `LXGWWenKaiMono Nerd Font`

## License

This font is licensed under the [SIL Open Font License 1.1](OFL.txt).

## Credits

- **Original Font**: [LXGW WenKai](https://github.com/lxgw/LxgwWenKai) by [lxgw](https://github.com/lxgw)
- **Nerd Font Patcher**: [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts)
