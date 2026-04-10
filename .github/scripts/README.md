# AUR Publish Scripts

This directory contains scripts for automatically publishing AUR packages, used in conjunction with the [KSXGitHub/github-actions-deploy-aur](https://github.com/KSXGitHub/github-actions-deploy-aur) Action.

## Script Description

### resolve-tag.sh
- **Function**: Resolve the release tag and corresponding package version from workflow context
- **Output**: `tag` and `pkgver` to GitHub Actions output
- **Tag Sources**: release event → repository_dispatch `client_payload.tag_name` → workflow_dispatch `tag_name`
- **Safety**: no implicit fallback to `latest release`; manual runs must provide an explicit tag to avoid publishing stale release assets

### generate-pkgbuild.sh
- **Function**: Generate PKGBUILD file for specified package
- **Parameters**: `pkgname` `pkgver` `pkgdesc` `asset` `sha_asset` `sha_license` `tag`
- **Features**: Uses versioned local source archive names to avoid AUR helper cache collisions

### package-release-assets.sh
- **Function**: Split patched fonts into full/proportional/mono release bundles
- **Parameters**: `version` `source_dir`
- **Features**: Produces versioned asset names for release publishing and downstream package managers

### generate-homebrew-cask.sh
- **Function**: Generate Homebrew Cask files for the external tap repository
- **Parameters**: `token` `version` `sha256` `asset` `name` `desc` `tag` `archive_dir` `font_files...`
- **Features**: Generates deterministic cask definitions that point to versioned GitHub Release assets

## Workflow

The workflow uses the mature third-party Action `KSXGitHub/github-actions-deploy-aur@v4.1.1` to handle:
- SSH configuration
- AUR repository cloning
- `.SRCINFO` file generation
- Git commit and push
- Checksum updates (`updpkgsums`)

## Usage

These scripts are automatically called through GitHub Actions workflow (aur-publish.yml). When a new release is published, the workflow will:

1. Resolve the release tag from the triggering event (resolve-tag.sh)
2. Get SHA256 of asset files (**without downloading** large files, avoiding AUR size limits)
3. Download license file
4. Generate PKGBUILD for both normal and mono variants (generate-pkgbuild.sh)
5. Use third-party Action to publish to AUR

For Homebrew publishing, the workflow will:

1. Resolve the release tag from the triggering event (resolve-tag.sh)
2. Compute SHA256 for proportional and mono release assets
3. Generate cask files (generate-homebrew-cask.sh)
4. Push the updated casks to the external tap repository

## Permission Requirements

- `AUR_SSH_PRIVATE_KEY`: SSH private key for AUR access (GitHub Secret)
- `GITHUB_TOKEN`: GitHub API access token (automatically provided)
- `HOMEBREW_TAP_PUSH_TOKEN`: GitHub token with contents write permission for `Yikai-Liao/homebrew-fonts`

## Advantages

- **Reliability**: Uses proven third-party Action, avoiding complex permission and Docker issues
- **Simplicity**: Significantly reduces custom script code
- **No cache collisions**: Versioned source archive names avoid stale AUR helper caches
- **No redundant downloads**: Normal and mono packages consume different release assets
- **Parallel Processing**: Normal and mono packages are published in parallel via matrix strategy
- **Automatic Validation**: Action automatically handles `updpkgsums` and `.SRCINFO` generation
- **AUR Compliant**: Doesn't commit source files to AUR repository, avoiding size limit issues
