#!/bin/bash
set -euo pipefail
umask 022

version="$1"
source_dir="$2"
output_dir="${3:-.}"

package="fonts-lxgw-wenkai-nerd"
font_dir="usr/share/fonts/truetype/lxgw-wenkai-nerd"
doc_dir="usr/share/doc/$package"

staging_dir=$(mktemp -d)
trap 'rm -rf "$staging_dir"' EXIT

package_root="$staging_dir/$package"
mkdir -p \
    "$package_root/DEBIAN" \
    "$package_root/$font_dir" \
    "$package_root/$doc_dir"

find "$source_dir" -type f -name '*.ttf' -print0 | sort -z | while IFS= read -r -d '' font; do
    install -m644 "$font" "$package_root/$font_dir/$(basename "$font")"
done

if ! find "$package_root/$font_dir" -type f -name '*.ttf' | grep -q .; then
    echo "No .ttf files found in $source_dir" >&2
    exit 1
fi

install -m644 OFL.txt "$package_root/$doc_dir/copyright"

cat > "$package_root/$doc_dir/changelog" <<EOF
$package ($version) stable; urgency=medium

  * Release LXGW WenKai Nerd Font $version.

 -- LXGW WenKai Nerd Font maintainers <noreply@github.com>  $(date -u -R)
EOF
gzip -n -9 "$package_root/$doc_dir/changelog"

cat > "$package_root/DEBIAN/postinst" <<'EOF'
#!/bin/sh
set -e

if command -v fc-cache >/dev/null 2>&1; then
    fc-cache -f >/dev/null 2>&1 || true
fi

#DEBHELPER#
EOF

cat > "$package_root/DEBIAN/postrm" <<'EOF'
#!/bin/sh
set -e

if command -v fc-cache >/dev/null 2>&1; then
    fc-cache -f >/dev/null 2>&1 || true
fi

#DEBHELPER#
EOF

chmod 755 "$package_root/DEBIAN/postinst" "$package_root/DEBIAN/postrm"
find "$package_root" -type d -exec chmod 755 {} +

installed_size=$(du -sk "$package_root/usr" | awk '{print $1}')

cat > "$package_root/DEBIAN/control" <<EOF
Package: $package
Version: $version
Section: fonts
Priority: optional
Architecture: all
Maintainer: LXGW WenKai Nerd Font maintainers <noreply@github.com>
Installed-Size: $installed_size
Depends: fontconfig
Description: LXGW WenKai fonts patched with Nerd Font glyphs
 LXGW WenKai Nerd Font is a patched build of LXGW WenKai with Nerd Font
 symbols. This package includes proportional and monospace variants in Light,
 Regular, and Medium weights.
EOF

mkdir -p "$output_dir"
deb_file="$output_dir/${package}_${version}_all.deb"
dpkg-deb --root-owner-group --build "$package_root" "$deb_file" >/dev/null

printf '%s\n' "$deb_file"
