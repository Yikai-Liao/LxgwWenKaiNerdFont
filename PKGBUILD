# Maintainer: desemai <desemai@outlook.com>

pkgname=ttf-lxgw-wenkai-nerd
pkgver=1.501
pkgrel=1
pkgdesc="LxgwWenKai with latest updated nerd font patch."
arch=('any')
url='https://github.com/Yikai-Liao/LxgwWenKaiNerdFont'
license=('OFL-1.1')
makedepends=('git')

source=("$url/releases/download/v$pkgver/lxgw-wenkai-nerd.tar.gz"
        "repo::git+$url.git"
)

sha256sums=('fffe2377666839fb8a85c1d3d71eb70bebf4b65be76ff2514087eda5fc67d952'
            'SKIP'
)

prepare() {
    cd "${srcdir}/repo"
    cp "OFL.txt" "${srcdir}"
}

package() {
    cd "$srcdir"
    install -d "$pkgdir/usr/share/fonts/TTF"
    cp *.ttf "$pkgdir/usr/share/fonts/TTF"
    install -Dm644 "OFL.txt" "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
}