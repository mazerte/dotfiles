#!/bin/bash

start() {
  cd $HOME
}

install-linux-packages() {
  echo "==========================================================="
  echo "* Install following packages:"
  echo "-----------------------------------------------------------"

  sudo yum update
  sudo yum install -y make glibc-devel gcc patch readline readline-devel zlib zlib-devel
  sudo yum install -y libyaml-devel libffi-devel openssl-devel make bzip2 autoconf automake libtool bison iconv-devel
  sudo yum install -y zsh tree
  sudo yum install -y whois lshw
  sudo yum install -y bind-utils
  sudo yum install -y netcat
}

install-amazon-extras(){
  sudo amazon-linux-extras install -y rust1
  sudo amazon-linux-extras install -y golang1.11
}

install-cargo-packages(){
  cargo install exa
}

install-bat(){
  # https://github.com/sharkdp/bat
  BAT_VERISON="0.19.0"
  ARCH=$(/usr/bin/arch)
  wget -O /tmp/bat.tar.gz https://github.com/sharkdp/bat/releases/download/v$BAT_VERISON/bat-v$BAT_VERISON-$ARCH-unknown-linux-gnu.tar.gz
  tar -xvzf /tmp/bat.tar.gz -C /tmp
  sudo mv /tmp/bat-v$BAT_VERISON-$ARCH--unknown-linux-gnu/bat /usr/local/bin/bat
}

install-go-packages(){
  # go install github.com/hidetatz/kubecolor/cmd/kubecolor@latest*
}

install-pip-packages(){
  sudo easy_install csvkit
}

install-antibody(){
  curl -sfL git.io/antibody | sudo sh -s - -b /usr/local/bin
}

upgrade-packages() {
  echo "==========================================================="
  echo "                      Upgrade packages                     "
  echo "-----------------------------------------------------------"

  sudo yum update && sudo yum upgrade -y
}

finish() {
    echo "==========================================================="
    echo "> Do not forget run those things:"
    echo ""
    echo "- chsh -s /usr/bin/zsh"
    echo "- git-config"
    echo "- u-update"
    echo "==========================================================="
}

start
install-linux-packages
install-amazon-extras
install-cargo-packages
install-go-packages
install-bat
install-go-packages
install-pip-packages
install-antibody
upgrade-packages
finish
