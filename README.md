
[![CircleCI](https://circleci.com/gh/electrohousedev/speedometer-test/tree/master.svg?style=svg)](https://circleci.com/gh/electrohousedev/speedometer-test/tree/master)

## Build 

Initialize and build dependencies.
Need only once.

```
./scripts/bootstrap.sh
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
