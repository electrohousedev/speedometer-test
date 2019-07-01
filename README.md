
[![CircleCI](https://circleci.com/gh/electrohousedev/speedometer-test/tree/master.svg?style=svg)](https://circleci.com/gh/electrohousedev/speedometer-test/tree/master)

## Build 

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

## Description

Some amound of over engeenering just for practical C++11 features learning.
