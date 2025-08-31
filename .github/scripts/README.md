# AUR Publish Scripts

This directory contains scripts for automatically publishing AUR packages, used in conjunction with the [KSXGitHub/github-actions-deploy-aur](https://github.com/KSXGitHub/github-actions-deploy-aur) Action.

## Script Description

### resolve-tag.sh
- **Function**: Automatically detect the latest git tag and corresponding package version
- **Output**: `tag` and `pkgver` to GitHub Actions output
- **Fallback Logic**: release event → latest release → tags list

### generate-pkgbuild.sh
- **Function**: Generate PKGBUILD file for specified package
- **Parameters**: `pkgname` `pkgver` `asset` `sha_asset` `sha_license` `tag` `is_mono`
- **Features**: Supports both normal and mono variants, automatically creates package directory

## Workflow

The workflow uses the mature third-party Action `KSXGitHub/github-actions-deploy-aur@v4.1.1` to handle:
- SSH configuration
- AUR repository cloning
- `.SRCINFO` file generation
- Git commit and push
- Checksum updates (`updpkgsums`)

## Usage

These scripts are automatically called through GitHub Actions workflow (aur-publish.yml). When a new release is published, the workflow will:

1. Detect latest version (resolve-tag.sh)
2. Get SHA256 of asset files (**without downloading** large files, avoiding AUR size limits)
3. Download license file
4. Generate PKGBUILD for both normal and mono variants (generate-pkgbuild.sh)
5. Use third-party Action to publish to AUR

## Permission Requirements

- `AUR_SSH_PRIVATE_KEY`: SSH private key for AUR access (GitHub Secret)
- `GITHUB_TOKEN`: GitHub API access token (automatically provided)

## Advantages

- **Reliability**: Uses proven third-party Action, avoiding complex permission and Docker issues
- **Simplicity**: Significantly reduces custom script code
- **Parallel Processing**: Normal and mono packages can be published in parallel
- **Automatic Validation**: Action automatically handles `updpkgsums` and `.SRCINFO` generation
- **AUR Compliant**: Doesn't commit source files to AUR repository, avoiding size limit issues
