#!/bin/bash
set -euo pipefail

token="$1"
version="$2"
sha256="$3"
asset="$4"
name="$5"
desc="$6"
tag="$7"
archive_dir="$8"
shift 8

mkdir -p Casks

cask_path="Casks/${token}.rb"

{
    echo "cask \"${token}\" do"
    echo "  version \"${version}\""
    echo "  sha256 \"${sha256}\""
    echo
    echo "  url \"https://github.com/Yikai-Liao/LxgwWenKaiNerdFont/releases/download/${tag}/${asset}\","
    echo "      verified: \"github.com/Yikai-Liao/LxgwWenKaiNerdFont/\""
    echo "  name \"${name}\""
    echo "  desc \"${desc}\""
    echo "  homepage \"https://github.com/Yikai-Liao/LxgwWenKaiNerdFont\""
    echo

    for font_file in "$@"; do
        echo "  font \"${archive_dir}/${font_file}\""
    done

    echo "end"
} > "$cask_path"

echo "Generated Homebrew cask: $cask_path"
