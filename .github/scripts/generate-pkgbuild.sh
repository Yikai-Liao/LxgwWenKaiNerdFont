#!/bin/bash
set -euo pipefail

pkgname="$1"
pkgver="$2"
asset="$3"
sha_asset="$4"
sha_license="$5"
tag="$6"
is_mono="$7"

# 创建包目录
mkdir -p "$pkgname"
cd "$pkgname"

# 确定描述和安装模式
if [ "$is_mono" = "true" ]; then
    pkgdesc="LXGW WenKai Mono patched with Nerd Font glyphs"
    find_pattern='*MonoNerdFont-*.ttf'
else
    pkgdesc="LXGW WenKai patched with Nerd Font glyphs"
    find_pattern='*NerdFont-*.ttf ! -name *MonoNerdFont-*'
fi

# 生成PKGBUILD
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
makedepends=('unzip')
_tag='$tag'
source=("https://github.com/Yikai-Liao/LxgwWenKaiNerdFont/releases/download/\${_tag}/${asset}" \\
        "OFL.txt::https://raw.githubusercontent.com/Yikai-Liao/LxgwWenKaiNerdFont/\${_tag}/OFL.txt")
sha256sums=('$sha_asset' '$sha_license')

package() {
  cd "\${srcdir}"
  mkdir -p "\${pkgdir}/usr/share/fonts/TTF"
  unzip -q "\${srcdir}/${asset}" -d extracted
EOF

if [ "$is_mono" = "true" ]; then
    cat >> PKGBUILD <<EOF
  find extracted -type f -name '*MonoNerdFont-*.ttf' -exec install -Dm644 {} "\${pkgdir}/usr/share/fonts/TTF/" \\;
EOF
else
    cat >> PKGBUILD <<EOF
  find extracted -type f -name '*NerdFont-*.ttf' ! -name '*MonoNerdFont-*' -exec install -Dm644 {} "\${pkgdir}/usr/share/fonts/TTF/" \\;
EOF
fi

cat >> PKGBUILD <<EOF
  install -Dm644 OFL.txt "\${pkgdir}/usr/share/licenses/\${pkgname}/OFL.txt"
}
EOF

echo "Generated PKGBUILD for $pkgname (mono=$is_mono):"
head -10 PKGBUILD

cd - >/dev/null
