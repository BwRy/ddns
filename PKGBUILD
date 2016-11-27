# Maintainer: Kieran Colford <kieran@kcolford.com>
pkgname=ddns
pkgver=1.0
pkgrel=1
epoch=
pkgdesc="Automatic provisioning of Dynamic DNS."
arch=('i686' 'x86_64')
url=""
license=('GPL')
groups=()
depends=('bind-tools' 'bash' 'curl')
makedepends=()
checkdepends=()
optdepends=('bind: for tsig-keygen')
provides=()
conflicts=()
replaces=()
backup=()
options=()
install=
changelog=
source=("https://github.com/kcolford/$pkgname/archive/v$pkgver.tar.gz")
md5sums=('01e87d12c670fd985ed63d00b37d0acd')
noextract=()

package() {
  cd "$srcdir/$pkgname-$pkgver"

  install -Dm755 ddns.sh "$pkgdir/usr/bin/ddns.sh"
  install -Dm644 systemd/ddns.service "$pkgdir/usr/lib/systemd/system/ddns.service"
  install -Dm644 systemd/ddns.timer "$pkgdir/usr/lib/systemd/system/ddns.timer"
  mkdir -pm700 "$pkgdir/etc/ddns/"
}

# vim:set ts=2 sw=2 et:
