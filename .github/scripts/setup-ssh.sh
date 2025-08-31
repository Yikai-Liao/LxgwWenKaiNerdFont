#!/bin/bash
set -euo pipefail

# 设置SSH配置
install -m 700 -d ~/.ssh
printf '%s\n' "$AUR_SSH_PRIVATE_KEY" > ~/.ssh/aur
chmod 600 ~/.ssh/aur
printf 'Host aur.archlinux.org\n  HostName aur.archlinux.org\n  User aur\n  IdentityFile ~/.ssh/aur\n  StrictHostKeyChecking accept-new\n' > ~/.ssh/config

echo "SSH configured for AUR access"
