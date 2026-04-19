#!/bin/sh

set -eu

if [ -z "${DEVKITPRO:-}" ] && [ -d /opt/devkitpro ]; then
    export DEVKITPRO=/opt/devkitpro
fi

if [ -z "${DEVKITARM:-}" ] && [ -n "${DEVKITPRO:-}" ] && [ -d "${DEVKITPRO}/devkitARM" ]; then
    export DEVKITARM="${DEVKITPRO}/devkitARM"
fi

# builds a preset
build_preset() {
    echo Configuring $1 ...
    cmake --preset $1
    echo Building $1 ...
    cmake --build --preset $1
}

build_preset Release

rm -rf out

# --- SWITCH --- #
mkdir -p out/switch/sphaira/
cp -r build/Release/*.nro out/switch/sphaira/sphaira.nro
pushd out
zip -r9 sphaira.zip switch
popd
