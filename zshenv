function exists() {
  # `command -v` is similar to `which`
  # https://stackoverflow.com/a/677212/1341838
  command -v $1 >/dev/null 2>&1

  # More explicitly written:
  # command -v $1 1>/dev/null 2>/dev/null
}

# https://superuser.com/questions/590099/can-i-make-curl-fail-with-an-exitcode-different-than-0-if-the-http-status-code-i
function curlf() {
  OUTPUT_FILE=$(mktemp)
  HTTP_CODE=$(curl --silent --output $OUTPUT_FILE --write-out "%{http_code}" "$@")
  if [[ ${HTTP_CODE} -lt 200 || ${HTTP_CODE} -gt 299 ]] ; then
    >&2 cat $OUTPUT_FILE
    return 22
  fi
  cat $OUTPUT_FILE
  rm $OUTPUT_FILE
}

# https://serverfault.com/questions/462903/how-to-know-if-a-machine-is-an-ec2-instance
function is_ec2() {
  if [ -f /sys/hypervisor/uuid ]; then
    # File should be readable by non-root users.
    if [ `head -c 3 /sys/hypervisor/uuid | tr '[:upper:]' '[:lower:]'` = "ec2" ]; then
      return 0
    else
      return 1
    fi
  elif sudo -n true > /dev/null 2>/dev/null && sudo [ -r /sys/devices/virtual/dmi/id/product_uuid ]; then
    # If the file exists AND is readable by us, we can rely on it.
    if [ `sudo head -c 3 /sys/devices/virtual/dmi/id/product_uuid | tr '[:upper:]' '[:lower:]'` = "ec2" ]; then
      return 0
    else
      return 1
    fi
  fi
  return 1
}

if [[ "$(uname)" == "Linux" ]]; then
  export CURRENT_OSTYPE="linux"
  export CURRENT_ARCH="$(uname -m | sed -e 's/amd64/x86_64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')"
  export CURRENT_LINUX_OS=$(egrep '^ID=' /etc/os-release | cut -d "=" -f 2 | sed 's/\"//g')
  export CURRENT_VERSION=$(egrep '^VERSION_ID=' /etc/os-release | cut -d "=" -f 2 | sed 's/\"//g')
elif [[ "$(uname)" == "Darwin" ]]; then
  export CURRENT_OSTYPE="macos"
  export CURRENT_ARCH=$(/usr/bin/arch)
  export CURRENT_VERSION=$(sw_vers -productVersion)
else
  export CURRENT_OSTYPE="unknown"
fi

if [ -f /.dockerenv ]; then
  export CURRENT_IS_DOCKER=1
else
  export CURRENT_IS_DOCKER=0
fi

if [[ "$CURRENT_OSTYPE" == "macos" ]]; then
  export HOMEBREW_CASK_OPTS=x"--no-quarantine --no-binaries"
fi

if [[ "$CURRENT_OSTYPE" == "macos" ]] && exists nvm; then
  # NVM
  export NVM_DIR="$HOME/.nvm"
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
    [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"   # This loads nvm bash_completion
  source "/opt/homebrew/opt/nvm/nvm.sh"
fi

# Add Locations to $path Array
typeset -U path

if [[ "$CURRENT_OSTYPE" == "macos" ]] && [ $CURRENT_IS_DOCKER -eq 0 ]; then
  export PATH="/opt/homebrew/Cellar/rust/1.56.1/bin:$PATH"
  export PATH="/Applications/Docker.app/Contents/Resources/bin:$PATH"
  export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
  export PATH="/opt/homebrew/bin:$PATH"
  export PATH="/opt/homebrew/sbin:$PATH"
fi
export PATH="$HOME/.krew/bin:$PATH"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:/usr/local/bin"


if [ -f ~/.rvm/scripts/rvm ]; then
  # RVM
  source ~/.rvm/scripts/rvm
fi

if exists rust; then
  # RSVM (Rust)
  [[ -s ~/.rsvm/rsvm.sh ]] && . ~/.rsvm/rsvm.sh
fi

export LC_CTYPE=en_US.UTF-8
