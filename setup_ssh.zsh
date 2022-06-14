#!/usr/bin/env zsh

if [ -e /workspaces/.codespaces/.persistedshare/dotfiles ]; then
  DOTFILES="/workspaces/.codespaces/.persistedshare/dotfiles"
else
  DOTFILES="$HOME/.dotfiles"
fi

if [ -e $HOME/.ssh/authorized_keys ]; then
  echo ".ssh and authorized keys exist"
else
  touch $HOME/.ssh/authorized_keys
  chmod 0600 $HOME/.ssh/authorized_keys
  cat $DOTFILES/ssh/authorized_keys >> $HOME/.ssh/authorized_keys
fi
