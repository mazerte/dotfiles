#!/bin/bash

# apk add curl bash git python
# git clone https://github.com/mazerte/dotfiles ~/.dotfiles
# cd ~/.dotfiles
# ./install

start() {
  cd $HOME
}

install-linux-packages() {
  echo "==========================================================="
  echo "* Install following packages:"
  echo "-----------------------------------------------------------"

  apk update
  apk add alpine-sdk build-base musl-dev
  apk add make gcc patch readline readline-dev zlib zlib-dev
  apk add libffi-dev openssl-dev bzip2 autoconf automake libtool bison
  apk add zsh tree jq
  apk add whois lshw
  apk add bind-utils
  apk add wget curl python3 python3-dev py3-pip
  apk add exa bat
}

install-kubecolor(){
  KUBECOLOR_VERISON=$(curl -s "https://api.github.com/repos/hidetatz/kubecolor/releases/latest" | jq -r ".tag_name" | sed s/v//g)
  ARCH="$(uname -m | sed -e 's/amd64/x86_64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64/arm64/')"
  wget -O /tmp/kubecolor.tar.gz https://github.com/hidetatz/kubecolor/releases/download/v${KUBECOLOR_VERISON}/kubecolor_${KUBECOLOR_VERISON}_Linux_$ARCH.tar.gz
  tar -xvzf /tmp/kubecolor.tar.gz -C /tmp
  mv /tmp/kubecolor /usr/local/bin/kubecolor
}

install-pip-packages(){
  pip3 install awscli
  pip3 install sqlalchemy
  easy_install csvkit
  easy_install-3 csvkit
}

install-antibody(){
  curl -sfL git.io/antibody | sh -s - -b /usr/local/bin
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
install-kubecolor
install-pip-packages
install-antibody
finish
