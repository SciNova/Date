#!/bin/sh
# Build python3-date_<version>_all.deb from Date.py.
# Usage: packaging/deb/build.sh
set -eu

cd "$(dirname "$0")/../.."
REPO_ROOT="$(pwd)"
PKG_DIR="$REPO_ROOT/debian-pkg"
VERSION="$(sed -n 's/^Version: //p' packaging/deb/control)"

rm -rf "$PKG_DIR"
mkdir -p "$PKG_DIR/DEBIAN" "$PKG_DIR/usr/lib/python3/dist-packages"

cp packaging/deb/control "$PKG_DIR/DEBIAN/control"
cp Date.py "$PKG_DIR/usr/lib/python3/dist-packages/"

dpkg-deb --build --root-owner-group "$PKG_DIR" "python3-date_${VERSION}_all.deb"

rm -rf "$PKG_DIR"
echo "Built python3-date_${VERSION}_all.deb"
