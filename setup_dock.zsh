#!/usr/bin/env zsh

set -e

__dock_item() {
    printf '%s%s%s%s%s' \
           '<dict><key>tile-data</key><dict><key>file-data</key><dict>' \
           '<key>_CFURLString</key><string>' \
           "$1" \
           '</string><key>_CFURLStringType</key><integer>0</integer>' \
           '</dict></dict></dict>'
}

printf '%s' 'Setting up Dock icons...'
defaults write com.apple.dock \
              persistent-apps -array "$(__dock_item /System/Applications/System\ Settings.app)" \
                                      "$(__dock_item /Applications/VeraCrypt.app)" \
                                      "$(__dock_item /Applications/1Password.app)" \
                                      "$(__dock_item /Applications/Whatsapp.app)" \
                                      "$(__dock_item /Applications/Slack.app)" \
                                      "$(__dock_item /Applications/Discord.app)" \
                                      "$(__dock_item /Applications/iTerm.app)" \
                                      "$(__dock_item /Applications/Visual\ Studio\ Code.app)" \
                                      "$(__dock_item /Applications/Spotify.app)" \
                                      "$(__dock_item /Applications/Google\ Chrome.app)"

killall Dock

printf '%s' 'Setting up Startup items...'

# osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Alfred 4.app", hidden:true}'
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Whatsapp.app", hidden:true}'
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Discord.app", hidden:true}'
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Slack.app", hidden:true}'
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Dropbox.app", hidden:true}'

printf '%s\n' ' done.'
