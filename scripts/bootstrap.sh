#!/bin/bash

PLATFORM=`uname -s`

if [ "$PLATFORM" = "Darwin" ]; then
    xcode-select --install
    PLATFORM=osx
fi
if [ "$PLATFORM" = "Linux" ]; then
    PLATFORM=linux
fi

git submodule init || exit 1
git submodule update --init --recursive || exit 1

BOOTSTRAPPREMAKE=sandbox/bin/$PLATFORM/premake5$EXE
#rm -f $BOOTSTRAPPREMAKE
if [ ! -f $BOOTSTRAPPREMAKE ]; then
    mkdir -p sandbox/bin/$PLATFORM
    cd sandbox/utils/premake5
    make -f Bootstrap.mak $PLATFORM ||  echo "make failed"
    ./build/bootstrap/premake_bootstrap --to=build/bootstrap --no-zlib=true --no-curl=true gmake 
    make -C build/bootstrap 
    cd ../../..
    cp sandbox/utils/premake5/bin/release/premake5 $BOOTSTRAPPREMAKE
fi

cd sandbox/utils
./build.sh || exit 1
cd ../..


