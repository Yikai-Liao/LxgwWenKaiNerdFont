#!/bin/bash
set -euo pipefail

pkgver="$1"
tag="$2"

for dir in ttf-lxgw-wenkai-nerd ttf-lxgw-wenkai-mono-nerd; do
    echo "Processing $dir..."
    
    # 检查目录是否存在
    if [ ! -d "$dir" ]; then
        echo "Directory $dir not found, skipping..."
        continue
    fi
    
    # 进入目录并配置git
    (
        cd "$dir"
        
        # 配置git用户信息
        git config user.name "github-actions[bot]"
        git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
        
        # 检查是否有变更
        if git diff --quiet --exit-code PKGBUILD .SRCINFO 2>/dev/null; then
            echo "No change for $dir"
            exit 0
        fi
        
        # 提交并推送
        git add PKGBUILD .SRCINFO
        git commit -m "update: $dir to $pkgver (release $tag)"
        git push || true
        
        echo "Updated $dir to version $pkgver"
    )
done
