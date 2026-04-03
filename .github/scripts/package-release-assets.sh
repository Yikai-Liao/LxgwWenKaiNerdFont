#!/bin/bash
set -euo pipefail

version="$1"
source_dir="$2"

full_dir="lxgw-wenkai-nerd-${version}"
proportional_dir="lxgw-wenkai-nerd-proportional-${version}"
mono_dir="lxgw-wenkai-nerd-mono-${version}"

staging_dir=$(mktemp -d)
trap 'rm -rf "$staging_dir"' EXIT

mkdir -p \
    "$staging_dir/$full_dir" \
    "$staging_dir/$proportional_dir" \
    "$staging_dir/$mono_dir"

find "$source_dir" -type f -name '*.ttf' | while IFS= read -r font; do
    font_name=$(basename "$font")

    install -m644 "$font" "$staging_dir/$full_dir/$font_name"

    if [[ "$font_name" == *MonoNerdFont-* ]]; then
        install -m644 "$font" "$staging_dir/$mono_dir/$font_name"
    else
        install -m644 "$font" "$staging_dir/$proportional_dir/$font_name"
    fi
done

(
    cd "$staging_dir"
    tar -czf "$OLDPWD/${full_dir}.tar.gz" "$full_dir"
    zip -qr "$OLDPWD/${full_dir}.zip" "$full_dir"
    zip -qr "$OLDPWD/${proportional_dir}.zip" "$proportional_dir"
    zip -qr "$OLDPWD/${mono_dir}.zip" "$mono_dir"
)

printf '%s\n' \
    "${full_dir}.tar.gz" \
    "${full_dir}.zip" \
    "${proportional_dir}.zip" \
    "${mono_dir}.zip"
