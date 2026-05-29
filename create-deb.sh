#!/bin/bash

checkinstall \
    --default \
    --pkgname=cronitor-ping \
    --pkgversion=1.0 \
    --nodoc \
    --fstrans=yes \
    make install PREFIX=/opt/cronitor-ping