#!/bin/bash
set -euo pipefail

for dir in ttf-lxgw-wenkai-nerd ttf-lxgw-wenkai-mono-nerd; do
    echo "Generating .SRCINFO for $dir..."
    ( cd "$dir"
      docker run --rm -v "$PWD":/pkg -w /pkg archlinux:base bash -lc \
        "pacman -Sy --noconfirm base-devel unzip git && useradd build && chown -R build . && su build -c 'makepkg --printsrcinfo > .SRCINFO'"
    )
    echo "==== $dir/.SRCINFO ===="
    sed -n '1,20p' "$dir/.SRCINFO"
done
