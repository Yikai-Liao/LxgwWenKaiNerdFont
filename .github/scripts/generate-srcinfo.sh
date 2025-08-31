#!/bin/bash
set -euo pipefail

# 获取当前用户ID和组ID
CURRENT_UID=$(id -u)
CURRENT_GID=$(id -g)

for dir in ttf-lxgw-wenkai-nerd ttf-lxgw-wenkai-mono-nerd; do
    echo "Generating .SRCINFO for $dir..."
    
    if [ ! -d "$dir" ]; then
        echo "Directory $dir not found, skipping..."
        continue
    fi
    
    ( cd "$dir"
      # 使用当前用户ID运行Docker，避免所有权问题
      docker run --rm \
        --user "$CURRENT_UID:$CURRENT_GID" \
        -v "$PWD":/pkg \
        -w /pkg \
        archlinux:base bash -c \
        "pacman -Sy --noconfirm base-devel unzip git sudo && makepkg --printsrcinfo > .SRCINFO"
    )
    
    echo "==== $dir/.SRCINFO ===="
    sed -n '1,20p' "$dir/.SRCINFO" 2>/dev/null || echo "Failed to read .SRCINFO"
done
