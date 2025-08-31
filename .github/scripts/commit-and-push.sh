#!/bin/bash
set -euo pipefail

pkgver="$1"
tag="$2"

# 配置全局git用户信息（避免权限问题）
git config --global user.name "github-actions[bot]"
git config --global user.email "41898282+github-actions[bot]@users.noreply.github.com"

for dir in ttf-lxgw-wenkai-nerd ttf-lxgw-wenkai-mono-nerd; do
    echo "Processing $dir..."
    
    # 检查目录是否存在
    if [ ! -d "$dir" ]; then
        echo "Directory $dir not found, skipping..."
        continue
    fi
    
    # 进入目录处理
    (
        cd "$dir"
        
        # 检查是否有变更
        if git diff --quiet --exit-code PKGBUILD .SRCINFO 2>/dev/null; then
            echo "No change for $dir"
            exit 0
        fi
        
        # 显示变更内容
        echo "Changes detected in $dir:"
        git diff --name-only PKGBUILD .SRCINFO 2>/dev/null || true
        
        # 提交并推送
        git add PKGBUILD .SRCINFO
        git commit -m "update: $dir to $pkgver (release $tag)"
        git push || true
        
        echo "Updated $dir to version $pkgver"
    )
done

echo "Commit and push completed for all packages"
