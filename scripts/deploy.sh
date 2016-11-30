#!/bin/sh

cd "$(dirname "$0")/../aur/"
updpkgsums
makepkg --printsrcinfo > .SRCINFO
git commit -m 'update PKGBUILD' PKGBUILD .SRCINFO
cd ..
git subtree push -P aur/ ssh://aur@aur.archlinux.org/ddns.git master
