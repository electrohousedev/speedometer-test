
[![CircleCI](https://circleci.com/gh/electrohousedev/speedometer-test/tree/master.svg?style=svg)](https://circleci.com/gh/electrohousedev/speedometer-test/tree/master)

## Build on Linux or OSX

Initialize and build dependencies.
Need only once.

```
./scripts/bootstrap.sh
```

Configure android SDK and NDK location:

Create file `config.sh` at root of repo with paths, eg:
```
ANDROIDSDK=$SDKROOT/android-sdk
ANDROIDNDK=$SDKROOT/android-ndk-r19c
```

Create project files.
Need after add files and change settings.

```
./scripts/make_project.sh
```

Build android apk.

```
cd projects/android
./gradlew assembleRelease
```

## Build on Windows 

Install android SDK (Command line tools only)

Download and unzip sdk-tools-windows-.zip from https://developer.android.com/studio#downloads 

Eg C:\sdk\android-sdk

Download and unzip android NDK (r19C) from https://developer.android.com/ndk/downloads/older_releases.html

Eg C:\sdk\android-ndk-r19c

Install JDK http://jdk.java.net/12/ 

Eg C:\sdk\jdk-12.0.1

Build host tools with gnu toolchain.


Install MSYS2 (https://www.msys2.org) or Cygwin (https://www.cygwin.com)

Install development packages.

MSYS2:

use mingw64 shell: open C:\msys64\mingw64.exe

```
pacman -S git mingw-w64-x86_64-toolchain bash make curl unzip
```

clone this project

```
git clone https://github.com/electrohousedev/speedometer-test.git
cd speedometer-test
```
Download submodules and build host tools
```
./scripts/bootstrap.sh
```

Create file `config.sh` at root of repo with MSYS paths to SDK and NDK, eg:
```
ANDROIDSDK=/c/sdk/android-sdk
ANDROIDNDK=/c/sdk/android-ndk-r19c
```

Download android SDK components:
```
/c/sdk/android-sdk/tools/bin/sdkmanager.bat "platforms;android-28"
/c/sdk/android-sdk/tools/bin/sdkmanager.bat "build-tools;28.0.3"
```

Generate projects
``` 
./scripts/make_project.sh
```

Build apk.
``` 
export JAVA_HOME=/c/sdk/jdk-12.0.1
cd projects/android
./gradlew assembleRelease
```

## Description

Some amound of over engeenering just for practical C++11 features learning.
