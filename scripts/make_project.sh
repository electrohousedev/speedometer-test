#!/bin/bash

if [ -f config.sh ]; then
	source config.sh
fi

HOST_PLATFORM=`uname -s`
if [[ "$HOST_PLATFORM" == "mingw"* ]]; then
	HOST_PLATFORM="windows"
elif [[ "$HOST_PLATFORM" == "MINGW32"* ]]; then
	HOST_PLATFORM="windows"
elif [[ "$HOST_PLATFORM" == "MINGW64"* ]]; then
	HOST_PLATFORM="windows"
elif [[ "$HOST_PLATFORM" == "Darwin" ]]; then
	HOST_PLATFORM="osx"
elif [[ "$HOST_PLATFORM" == "Linux" ]]; then
	HOST_PLATFORM="linux"
fi


./sandbox/bin/$HOST_PLATFORM/premake5 --scripts=./sandbox/premake --os=android \
	--android-sdk-dir=$ANDROIDSDK \
	--android-ndk-dir=$ANDROIDNDK \
	android $@ || exit 2
if [[ "$HOST_PLATFORM" == "osx" ]]; then
	./sandbox/bin/$HOST_PLATFORM/premake5 --scripts=./sandbox/premake \
		xcode4 $@ || exit 2
fi