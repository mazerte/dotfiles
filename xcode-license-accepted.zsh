#!/usr/bin/env zsh

# https://stackoverflow.com/questions/58632629/how-to-check-if-xcode-license-needs-to-be-accepted
XCODE_VERSION=`xcodebuild -version | grep '^Xcode\s' | sed -E 's/^Xcode[[:space:]]+([0-9\.]+)/\1/'`
ACCEPTED_LICENSE_VERSION=`defaults read /Library/Preferences/com.apple.dt.Xcode 2> /dev/null | grep IDEXcodeVersionForAgreedToGMLicense | cut -d '"' -f 2`

if [ "$XCODE_VERSION" = "$ACCEPTED_LICENSE_VERSION" ]
then
    exit 0 #success
else
    exit 1
fi
