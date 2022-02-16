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
# work profile
if [[ "$USER" == "desvem" ]]; then
  defaults write com.apple.dock \
                persistent-apps -array "$(__dock_item /System/Applications/System\ Preferences.app)" \
                                        "$(__dock_item /Applications/Cisco/Cisco\ AnyConnect\ Secure\ Mobility\ Client.app)" \
                                        "$(__dock_item /Applications/Slack.app)" \
                                        "$(__dock_item /Applications/Discord.app)" \
                                        "$(__dock_item /Applications/Amazon\ Chime.app)" \
                                        "$(__dock_item /Applications/Microsoft\ Outlook.app)" \
                                        "$(__dock_item /Applications/VeraCrypt.app)" \
                                        "$(__dock_item /Applications/1Password\ 7.app)" \
                                        "$(__dock_item /Applications/iTerm.app)" \
                                        "$(__dock_item /Applications/Visual\ Studio\ Code.app)" \
                                        "$(__dock_item /Applications/Spotify.app)" \
                                        "$(__dock_item /Applications/Google\ Chrome.app)" \
                                        "$(__dock_item /Applications/Microsoft\ Excel.app)" \
                                        "$(__dock_item /Applications/Microsoft\ PowerPoint.app)" \
                                        "$(__dock_item /Applications/Microsoft\ Word.app)"
else
  defaults write com.apple.dock \
                persistent-apps -array "$(__dock_item /System/Applications/System\ Preferences.app)" \
                                        "$(__dock_item /Applications/Slack.app)" \
                                        "$(__dock_item /Applications/Discord.app)" \
                                        "$(__dock_item /Applications/VeraCrypt.app)" \
                                        "$(__dock_item /Applications/1Password\ 7.app)" \
                                        "$(__dock_item /Applications/iTerm.app)" \
                                        "$(__dock_item /Applications/Visual\ Studio\ Code.app)" \
                                        "$(__dock_item /Applications/Spotify.app)" \
                                        "$(__dock_item /Applications/Google\ Chrome.app)"
fi

killall Dock
printf '%s\n' ' done.'
