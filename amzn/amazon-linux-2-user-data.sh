#!/bin/bash

sudo yum install -y git zsh
git clone https://github.com/mazerte/dotfiles ~/.dotfiles
cd ~/.dotfiles
./install
