#!/usr/bin/env zsh

if [ -e $HOME/.ssh/authorized_keys ]; then
  echo ".ssh and authorized keys exist"
else
  touch $HOME/.ssh/authorized_keys
  chmod 0600 $HOME/.ssh/authorized_keys
  cat ~/.dotfiles/ssh/authorized_keys >> $HOME/.ssh/authorized_keys
fi
