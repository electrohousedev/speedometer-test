#!/bin/bash

PLATFORM=`uname -s`

case "$PLATFORM" in

   Darwin)
     xcode-select --install
     PLATFORM=osx
     ;;

   Linux)
     PLATFORM=linux
     ;;

   CYGWIN*|MSYS*|MINGW32*)
     echo "please use mingw64 shell";
     exit 1;
     ;;

   MINGW64*)
     PLATFORM=windows
     EXE=".exe"
     ;;

   # Add here more strings to compare
   # See correspondence table at the bottom of this answer

   *)
     echo 'other OS' 
     ;;
esac


git submodule init || exit 1
git submodule update --init --recursive || exit 1

ROOT=`pwd`
BOOTSTRAPPREMAKE=$ROOT/sandbox/bin/$PLATFORM/premake5$EXE

if [ "$PLATFORM" == "windows" ]; then
    # build broken, download
    if [ ! -f $BOOTSTRAPPREMAKE ]; then
        rm premake5.exe
        rm premake5.zip
        curl -L "https://github.com/premake/premake-core/releases/download/v5.0.0-alpha14/premake-5.0.0-alpha14-windows.zip" -o premake.zip 
        unzip premake.zip
        mv premake5.exe $BOOTSTRAPPREMAKE
        rm premake.zip
    fi
  
    cd sandbox/utils

    echo "rebuild assetsbuilder"
    cd assetsbuilder
    ../../bin/$PLATFORM/premake5.exe --scripts=../../premake gmake --to=. || exit 1
    make config=release -j2 || exit 1
    cp bin/release/*.exe $ROOT/sandbox/bin/$PLATFORM/
    cd ..

    exit 0
fi

#rm -f $BOOTSTRAPPREMAKE
if [ ! -f $BOOTSTRAPPREMAKE ]; then
    echo "bootstrap premake5 at $PLATFORM"
    
    mkdir -p sandbox/bin/$PLATFORM
       
    find ./sandbox/utils/premake5 -name "obj" -type d -exec rm -rf {} +
    find ./sandbox/utils/premake5 -name "bin" -type d -exec rm -rf {} +
    rm -rf build/bootstrap

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


