#!/bin/bash

sudo yum install -y git zsh
sudo adduser -r -m -s /bin/zsh -g ssm-user mazerte
echo 'mazerte ALL=(ALL) NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo

su mazerte <<'EOF'
git clone https://github.com/mazerte/dotfiles ~/.dotfiles
cd ~/.dotfiles
./install
EOF
