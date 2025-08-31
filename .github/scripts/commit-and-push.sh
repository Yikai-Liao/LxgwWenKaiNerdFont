#!/bin/bash
set -euo pipefail

pkgver="$1"
tag="$2"

# 配置全局git用户信息
git config --global user.name "github-actions[bot]"
git config --global user.email "41898282+github-actions[bot]@users.noreply.github.com"

for dir in ttf-lxgw-wenkai-nerd ttf-lxgw-wenkai-mono-nerd; do
    echo "Processing $dir..."
    
    if [ ! -d "$dir" ]; then
        echo "Directory $dir not found, skipping..."
        continue
    fi
    
    # 进入目录处理
    (
        cd "$dir"
        
        # 确保文件存在
        if [ ! -f PKGBUILD ]; then
            echo "PKGBUILD not found in $dir, skipping..."
            exit 0
        fi
        
        # 修复文件所有权 - 这是关键！
        sudo chown -R "$(id -u):$(id -g)" . || true
        
        # 检查是否需要提交
        if [ -f .SRCINFO ] && git diff --quiet HEAD -- PKGBUILD .SRCINFO 2>/dev/null; then
            echo "No change for $dir"
            exit 0
        fi
        
        # 显示变更内容
        echo "Changes detected in $dir:"
        ls -la PKGBUILD .SRCINFO 2>/dev/null || true
        
        # 添加文件到暂存区
        git add PKGBUILD .SRCINFO
        
        # 提交变更
        git commit -m "update: $dir to $pkgver (release $tag)"
        
        # 推送到远程
        git push
        
        echo "Successfully updated $dir to version $pkgver"
    )
done

echo "Commit and push completed for all packages"
