#!/bin/bash

sudo yum install -y git zsh
git clone https://github.com/mazerte/dotfiles ~/.dotfiles
cd ~/.dotfiles
./install

su ssm-user <<'EOF'
git clone https://github.com/mazerte/dotfiles ~/.dotfiles
cd ~/.dotfiles
./install
EOF

su ec2-user <<'EOF'
git clone https://github.com/mazerte/dotfiles ~/.dotfiles
cd ~/.dotfiles
./install
EOF
