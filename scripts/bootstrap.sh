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
    echo "bootstrap premake5 at $PLATFORM"
    
    
    find ./sandbox/utils/premake5 -name "obj" -type d -exec rm -rf {} +
    find ./sandbox/utils/premake5 -name "bin" -type d -exec rm -rf {} +
    rm -rf build/bootstrap

    mkdir -p sandbox/bin/$PLATFORM
    cd sandbox/utils/premake5
    make -f Bootstrap.mak $PLATFORM ||  echo "make failed"
    ./build/bootstrap/premake_bootstrap --to=build/bootstrap --no-zlib=true --no-curl=true gmake 
    make -C build/bootstrap clean
    make -C build/bootstrap V=1
    cd ../../..
    cp sandbox/utils/premake5/bin/release/premake5 $BOOTSTRAPPREMAKE

    rm -rf sandbox/utils/premake5/obj
    rm -rf sandbox/utils/premake5/bin

    find ./sandbox/utils/premake5 -name "obj" -type d -exec rm -rf {} +
    find ./sandbox/utils/premake5 -name "bin" -type d -exec rm -rf {} +

    rm -rf build/bootstrap

    echo "premake5 ready"
fi

cd sandbox/utils
./build.sh || exit 1
cd ../..


