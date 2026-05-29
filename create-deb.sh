#!/bin/bash

set -e

PKG=cronitor-ping
VERSION=1.0
ARCH=all
STAGEDIR="$(pwd)/pkg-root"

rm -rf "$STAGEDIR"
make install PREFIX=/opt/cronitor-ping DESTDIR="$STAGEDIR"

mkdir -p "$STAGEDIR/DEBIAN"
cat > "$STAGEDIR/DEBIAN/control" <<EOF
Package: $PKG
Version: $VERSION
Architecture: $ARCH
Maintainer: gianmarco@AsusDesktop
Description: cronitor-ping
Depends: bash, curl, procps
EOF

cat > "$STAGEDIR/DEBIAN/postinst" <<'EOF'
#!/bin/bash
set -e

systemctl daemon-reload

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                     cronitor-ping installed                  ║"
echo "╠══════════════════════════════════════════════════════════════╣"
echo "║  1. Create /etc/cronitor.url with the URL to ping:           ║"
echo "║       echo 'https://...' > /etc/cronitor.url                 ║"
echo "║       chmod 600 /etc/cronitor.url                            ║"
echo "║                                                               ║"
echo "║  2. Enable the timer:                                         ║"
echo "║       systemctl enable --now cronitor-ping.timer             ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
EOF
chmod 0755 "$STAGEDIR/DEBIAN/postinst"


dpkg-deb --build --root-owner-group "$STAGEDIR" "${PKG}_${VERSION}_${ARCH}.deb"