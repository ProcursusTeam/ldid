#!/bin/bash

set -e

if which xcrun &>/dev/null; then
    flags=(xcrun -sdk macosx g++)
    flags+=(-mmacosx-version-min=10.4)

    for arch in i386 x86_64; do
        flags+=(-arch "${arch}")
    done
else
    flags=(g++)
fi

set -x
"${flags[@]}" -o ldid ldid.cpp -I. -x c lookup2.c -x c sha1.c
