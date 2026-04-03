#!/bin/bash
set -euo pipefail

pkgname="$1"
pkgver="$2"
pkgdesc="$3"
asset="$4"
sha_asset="$5"
sha_license="$6"
tag="$7"

source_archive="${pkgname}-${pkgver}.zip"

# Create package directory
mkdir -p "$pkgname"
cd "$pkgname"

# Generate PKGBUILD
cat > PKGBUILD <<EOF
# Maintainer: lyk <lyk-boya@outlook.com>
pkgname=$pkgname
pkgver=$pkgver
pkgrel=1
pkgdesc="$pkgdesc"
arch=('any')
url="https://github.com/Yikai-Liao/LxgwWenKaiNerdFont"
license=('OFL')
depends=()
_tag='$tag'
_asset='$asset'
source=("${source_archive}::https://github.com/Yikai-Liao/LxgwWenKaiNerdFont/releases/download/\${_tag}/\${_asset}" \\
        "OFL.txt::https://raw.githubusercontent.com/Yikai-Liao/LxgwWenKaiNerdFont/\${_tag}/OFL.txt")
sha256sums=('$sha_asset' '$sha_license')

package() {
  cd "\${srcdir}"
  mkdir -p "\${pkgdir}/usr/share/fonts/TTF"
  mkdir extracted
  bsdtar -xf "\${srcdir}/${source_archive}" -C extracted
  find extracted -type f -name '*.ttf' -exec install -Dm644 {} "\${pkgdir}/usr/share/fonts/TTF/" \\;
  install -Dm644 OFL.txt "\${pkgdir}/usr/share/licenses/\${pkgname}/OFL.txt"
}
EOF

echo "Generated PKGBUILD for $pkgname:"
head -10 PKGBUILD

cd - >/dev/null
