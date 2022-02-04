#!/bin/bash

start() {
  cd $HOME
}

install-linux-packages() {
  echo "==========================================================="
  echo "* Install following packages:"
  echo "-----------------------------------------------------------"

  sudo apt-get update -y
  sudo apt-get install -y apt-file aptitude deborphan
  sudo apt-get install -y build-essential libreadline-dev
  sudo apt-get install -y zsh curl wget git tree unzip ncdu tmux trash-cli
  sudo apt-get install -y lsof whois traceroute lshw
  sudo apt-get install -y net-tools iputils-tracepath dnsutils
  sudo apt-get install -y netcat-openbsd
  sudo apt-get install -y jq vim gnupg csvkit
  sudo apt-get install -y zsh-theme-powerlevel9k
  sudo apt-get install -y bat

  if [[ "$CURRENT_LINUX_OS" == "ubuntu" ]]; then
    ARCH=$([ "$(uname -m)" = "arm64" ] && echo "arm64" || echo "amd64")
    sudo apt-get install -y awscli

    # Kubecolor
    KUBECOLOR_VERISON="0.0.20"
    wget -O /tmp/kubecolor.tar.gz https://github.com/hidetatz/kubecolor/releases/download/v${KUBECOLOR_VERISON}/kubecolor_${KUBECOLOR_VERISON}_Linux_$ARCH.tar.gz
    tar -xvzf /tmp/kubecolor.tar.gz -C /tmp
    sudo mv /tmp/kubecolor /usr/local/bin/kubecolor

    # Exa
    EXA_VERISON="0.8.0"
    wget -O /tmp/exa.zip https://github.com/ogham/exa/releases/download/v${EXA_VERISON}/exa-linux-$ARCH-${EXA_VERISON}.zip
    unzip /tmp/exa.zip -d /tmp
    sudo mv /tmp/exa-linux-$ARCH /usr/local/bin/exa
  else
    sudo apt-get install -y exa kubecolor
  fi
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
