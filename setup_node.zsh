#!/usr/bin/env zsh

echo "\n<<< Starting Node Setup >>>\n"

# Node versions are managed with `n`, which is in the Brewfile.
# See `zshenv` for the setting of the `N_PREFIX` variable,
# thus making it available below during the first install.
# See `zshrc` where `N_PREFIX/bin` is added to `$path`.

unset PREFIX
source $(brew --prefix nvm)/nvm.sh
if [ ! -d "${HOME}/.nvm" ]; then
  mkdir ~/.nvm
  nvm install node
  nvm install --lts
  nvm install 14
  nvm install 10
fi

nvm use node

# Install Global NPM Packages
npm install --global typescript
npm install --global http-server

echo "Global NPM Packages Installed:"
npm list --global --depth=0
