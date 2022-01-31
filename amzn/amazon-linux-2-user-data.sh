#!/bin/bash

sudo yum install -y git zsh

sudo su ssm-user
git clone https://github.com/mazerte/dotfiles ~/.dotfiles
cd ~/.dotfiles
./install

sudo su ec2-user
git clone https://github.com/mazerte/dotfiles ~/.dotfiles
cd ~/.dotfiles
./install
