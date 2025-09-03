# LXGWWenKai Nerd Font Repository

This repository automatically patches LXGW WenKai fonts with Nerd Font glyphs and creates releases. It uses GitHub Actions for automated font patching and AUR publishing.

Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.

## Working Effectively

### Bootstrap and Build Process
- Install dependencies:
  ```bash
  sudo apt-get update
  sudo apt-get install -y fontforge python3 python3-pip python3-fontforge tree jq unzip
  ```
  - Takes ~18 seconds. NEVER CANCEL. Set timeout to 60+ seconds.

- Download FontPatcher:
  ```bash
  wget -q -O FontPatcher.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FontPatcher.zip
  unzip -q FontPatcher.zip -d FontPatcher
  chmod +x FontPatcher/font-patcher
  ```
  - Takes <1 second each. Set timeout to 120+ seconds.

- Test FontPatcher installation:
  ```bash
  ./FontPatcher/font-patcher --help
  ```

### Font Patching Process
- Patch a single font (test timing):
  ```bash
  mkdir -p patched-fonts
  ./FontPatcher/font-patcher --complete --quiet --careful INPUT_FONT.ttf -o patched-fonts/
  ```
  - Takes ~41 seconds per font. NEVER CANCEL. Set timeout to 300+ seconds for single fonts.
  - For multiple fonts in production, expect 5-10 minutes total. Set timeout to 900+ seconds.

### Build Scripts Testing
- Test tag resolution script (requires environment variables):
  ```bash
  export GITHUB_TOKEN="your_token"
  export GITHUB_REPOSITORY="Yikai-Liao/LxgwWenKaiNerdFont"
  bash .github/scripts/resolve-tag.sh
  ```

- Test PKGBUILD generation:
  ```bash
  bash .github/scripts/generate-pkgbuild.sh 'test-package' 'v1.520' 'test.zip' 'sha256hash' 'sha256hash2' 'v1.520' 'false'
  ```
  - Takes <1 second. Output in `test-package/PKGBUILD`.

## Validation
- Always manually validate font patching by running the complete workflow with test fonts first.
- ALWAYS test both normal and mono PKGBUILD generation modes (last parameter 'false' vs 'true').
- Font patching produces expected output files with `.ttf` extension and Nerd Font naming.
- Never commit FontPatcher directory, test fonts, or temporary build artifacts.
- Always validate that scripts work with expected parameters before making changes.

## Common Tasks

### Repository Structure
```
ls -la /
.github/
├── scripts/
│   ├── generate-pkgbuild.sh    # PKGBUILD generation for AUR
│   ├── resolve-tag.sh          # Tag resolution for CI/CD
│   └── README.md               # Script documentation
└── workflows/
    ├── patch-fonts.yml         # Main font patching workflow
    ├── aur-publish.yml         # AUR package publishing
    └── keepalive.yml           # Repository maintenance
KEEPALIVE                       # Date file for repository activity
OFL.txt                         # Open Font License
README.md                       # Main documentation
```

### Key Workflow: patch-fonts.yml
1. **Dependency Installation** (~18 seconds)
2. **Source Font Download** (from lxgw/LxgwWenKai releases)
3. **FontPatcher Setup** (<1 second)
4. **Font Patching** (5-10 minutes for all fonts, NEVER CANCEL)
5. **Packaging** (tar.gz and zip creation)
6. **Release Creation** (GitHub release with assets)

### Key Workflow: aur-publish.yml
1. **Tag Resolution** (from release events or API)
2. **Asset Hash Calculation** (downloads for SHA256 verification)
3. **PKGBUILD Generation** (both normal and mono variants)
4. **AUR Publishing** (using third-party action)

### Files You Should Not Modify
- `KEEPALIVE` - Automated maintenance file
- `OFL.txt` - Font license (upstream dependency)

### Files You Can Safely Modify
- `.github/workflows/*.yml` - Workflow configurations
- `.github/scripts/*.sh` - Build and publishing scripts
- `README.md` - Documentation
- `.github/copilot-instructions.md` - These instructions

## Font Variants

### Proportional Fonts (Normal)
- LXGWWenKaiNerdFont-Light.ttf
- LXGWWenKaiNerdFont-Regular.ttf  
- LXGWWenKaiNerdFont-Medium.ttf

### Monospace Fonts
- LXGWWenKaiMonoNerdFont-Light.ttf
- LXGWWenKaiMonoNerdFont-Regular.ttf
- LXGWWenKaiMonoNerdFont-Medium.ttf

## Critical Timing Information
- **NEVER CANCEL** font patching operations - they may take 5-10 minutes for full font sets
- **NEVER CANCEL** dependency installation - can take up to 60 seconds with package updates
- **Always set timeouts of 900+ seconds** for font patching workflows
- **Always set timeouts of 300+ seconds** for individual font operations
- **Always set timeouts of 120+ seconds** for download operations

## Testing External Dependencies
- GitHub API access may be blocked in some environments
- FontPatcher download from GitHub releases should work
- Test with local/system fonts when upstream fonts are unavailable
- Use `/usr/share/fonts/truetype/` for testing font patching functionality

## Environment Limitations
- External GitHub API calls may be blocked by DNS monitoring
- Large file downloads may have firewall restrictions
- Font patching requires X11 libraries (provided by python3-fontforge)
- AUR publishing requires SSH keys and specific GitHub Action secrets

## Debug Commands
- Check FontPatcher help: `./FontPatcher/font-patcher --help`
- List available system fonts: `find /usr/share/fonts -name "*.ttf" | head -5`
- Verify patched fonts: `file patched-fonts/*.ttf`
- Check script syntax: `bash -n .github/scripts/SCRIPT_NAME.sh`