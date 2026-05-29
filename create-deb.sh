#!/bin/bash

checkinstall \
    --pkgname=cronitor-ping \
    --pkgversion=1.0 \
    --backup=no \
    --nodoc=yes \
    --fstrans=no \
    make install PREFIX=/opt/cronitor-ping