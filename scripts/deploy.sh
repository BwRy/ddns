#!/bin/sh

cd "$(dirname "$0")/../aur/"
updpkgsums
makepkg --printsrcinfo > .SRCINFO
git commit -m 'update PKGBUILD' PKGBUILD .SRCINFO
cd ..
url=ssh://aur@aur.archlinux.org/ddns.git
git fetch $url
git subtree push -P aur $url master
