#!/usr/bin/env zsh

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
  sudo yum install -y zsh tree jq
  sudo yum install -y whois lshw
  sudo yum install -y bind-utils
}

install-amazon-extras(){
  sudo amazon-linux-extras install -y rust1
}

install-cargo-packages(){
  cargo install exa
}

install-bat(){
  # https://github.com/sharkdp/bat
  BAT_VERISON=$(curl -s "https://api.github.com/repos/sharkdp/bat/releases/latest" | jq -r ".tag_name" | sed s/v//g)
  ARCH="$(uname -m | sed -e 's/amd64/x86_64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/arm64/aarch64/')"
  wget -O /tmp/bat.tar.gz https://github.com/sharkdp/bat/releases/download/v$BAT_VERISON/bat-v$BAT_VERISON-$ARCH-unknown-linux-gnu.tar.gz
  tar -xvzf /tmp/bat.tar.gz -C /tmp
  sudo mv /tmp/bat-v$BAT_VERISON-$ARCH--unknown-linux-gnu/bat /usr/local/bin/bat
}

install-kubecolor(){
  KUBECOLOR_VERISON=$(curl -s "https://api.github.com/repos/hidetatz/kubecolor/releases/latest" | jq -r ".tag_name" | sed s/v//g)
  ARCH="$(uname -m | sed -e 's/amd64/x86_64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64/arm64/')"
  wget -O /tmp/kubecolor.tar.gz https://github.com/hidetatz/kubecolor/releases/download/v${KUBECOLOR_VERISON}/kubecolor_${KUBECOLOR_VERISON}_Linux_$ARCH.tar.gz
  tar -xvzf /tmp/kubecolor.tar.gz -C /tmp
  sudo mv /tmp/kubecolor /usr/local/bin/kubecolor
}

install-pip-packages(){
  sudo pip3 install sqlalchemy
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
install-kubecolor
install-pip-packages
install-antibody
upgrade-packages
finish
