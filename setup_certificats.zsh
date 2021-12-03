#!/usr/bin/env zsh

echo "\n<<< Starting certificats Setup >>>\n"

__create_and_install_cert() {
  echo "Certificat: $1"
  local __cert=`echo $1 | sed "s/\*\.//g"`
  if [ -z "$(security find-certificate -a -c "$1" /Library/Keychains/System.keychain)" ]; then
    echo "-> Create"
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout "$HOME/.certs/$__cert.key" -out "$HOME/.certs/$__cert.crt" -subj "/CN=$1/O=$1"
    echo "-> Install"
    sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain "$HOME/.certs/$__cert.crt"
  else
    echo " -> certificat already installed"
  fi
}

mkdir -pv ~/.certs
__create_and_install_cert "*.local.test"
