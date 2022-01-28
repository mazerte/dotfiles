#!/bin/bash

start() {
  cd $HOME
}

install-linux-packages() {
  echo "==========================================================="
  echo "* Install following packages:"
  echo "-----------------------------------------------------------"

  sudo apt-get update
  sudo apt-get install -y apt-file aptitude deborphan
  sudo apt-get install -y build-essential libreadline-dev
  sudo apt-get install -y zsh curl wget git tree unzip ncdu tmux trash-cli
  sudo apt-get install -y lsof whois traceroute
  sudo apt-get install -y net-tools iputils-tracepath dnsutils
  sudo apt-get install -y netcat-openbsd
  sudo apt-get install -y exa jq vim gnupg
  sudo apt-get install -y zsh-theme-powerlevel9k
  sudo apt-get install -y bat kubecolor
}

install-antibody(){
  curl -sfL git.io/antibody | sudo sh -s - -b /usr/local/bin
}

upgrade-packages() {
  echo "==========================================================="
  echo "                      Upgrade packages                     "
  echo "-----------------------------------------------------------"

  sudo apt-get update && sudo apt-get upgrade -y
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
install-antibody
upgrade-packages
finish
