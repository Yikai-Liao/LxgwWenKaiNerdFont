#!/bin/bash
set -euo pipefail

for dir in ttf-lxgw-wenkai-nerd ttf-lxgw-wenkai-mono-nerd; do
    echo "Generating .SRCINFO for $dir..."
    
    if [ ! -d "$dir" ]; then
        echo "Directory $dir not found, skipping..."
        continue
    fi
    
    # 确保目录权限
    chmod -R u+w "$dir" || true
    
    ( cd "$dir"
      # 生成 .SRCINFO
      docker run --rm -v "$PWD":/pkg -w /pkg archlinux:base bash -lc \
        "pacman -Sy --noconfirm base-devel unzip git && useradd build && chown -R build . && su build -c 'makepkg --printsrcinfo > .SRCINFO'"
      
      # 确保生成的文件有正确权限
      chmod 644 .SRCINFO 2>/dev/null || true
    )
    
    echo "==== $dir/.SRCINFO ===="
    sed -n '1,20p' "$dir/.SRCINFO" 2>/dev/null || echo "Failed to read .SRCINFO"
done
