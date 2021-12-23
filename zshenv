export HOMEBREW_CASK_OPTS="--no-quarantine --no-binaries"

# NVM
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"   # This loads nvm bash_completion
source "/opt/homebrew/opt/nvm/nvm.sh"

# Add Locations to $path Array
typeset -U path

export PATH="/opt/homebrew/Cellar/rust/1.56.1/bin:$PATH"
export PATH="/Applications/Docker.app/Contents/Resources/bin:$PATH"
export PATH="$HOME/.krew/bin:$PATH"
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
export PATH="$PATH:/opt/homebrew/bin"
export PATH="$PATH:/opt/homebrew/sbin"
export PATH="$PATH:/usr/local/bin"

# RVM
source ~/.rvm/scripts/rvm

# RSVM (Rust)
[[ -s ~/.rsvm/rsvm.sh ]] && . ~/.rsvm/rsvm.sh

function exists() {
  # `command -v` is similar to `which`
  # https://stackoverflow.com/a/677212/1341838
  command -v $1 >/dev/null 2>&1

  # More explicitly written:
  # command -v $1 1>/dev/null 2>/dev/null
}
