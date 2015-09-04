#!/bin/bash

export ANDROID_HOME=$HOME/ADT-SDK/sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
cd ./ebapp
bundle exec middleman build
cd ..
cordova build android
cordova run android
# cordova run --emulator android
