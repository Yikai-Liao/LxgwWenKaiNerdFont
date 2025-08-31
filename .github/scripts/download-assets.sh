#!/bin/bash
set -euo pipefail

tag="$1"
asset="$2"
repo="$3"

url="https://github.com/${repo}/releases/download/${tag}/${asset}"
echo "Downloading $url"

# 下载主要资源文件
curl -fL "$url" -o "$asset"

# 下载许可证文件
curl -fL "https://raw.githubusercontent.com/${repo}/${tag}/OFL.txt" -o OFL.txt

# 计算SHA256
sha_asset=$(sha256sum "$asset" | cut -d' ' -f1)
sha_license=$(sha256sum OFL.txt | cut -d' ' -f1)

echo "Asset SHA256: $sha_asset"
echo "License SHA256: $sha_license"

# 输出到GitHub Actions
echo "sha_asset=$sha_asset" >> "$GITHUB_OUTPUT"
echo "sha_license=$sha_license" >> "$GITHUB_OUTPUT"
echo "asset=$asset" >> "$GITHUB_OUTPUT"
