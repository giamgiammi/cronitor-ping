#!/bin/bash

DESTDIR="$(pwd)/pkg-root"
rm -rf "$DESTDIR"

make install PREFIX=/opt/cronitor-ping DESTDIR="$DESTDIR"

checkinstall \
    --default \
    --pkgname=cronitor-ping \
    --pkgversion=1.0 \
    --nodoc \
    --fstrans=no \
    --install=no \
    make install PREFIX=/opt/cronitor-ping DESTDIR="$DESTDIR"