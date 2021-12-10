#!/usr/bin/env zsh

echo "\n<<< Starting Node Setup >>>\n"

# Node versions are managed with `n`, which is in the Brewfile.
# See `zshenv` for the setting of the `N_PREFIX` variable,
# thus making it available below during the first install.
# See `zshrc` where `N_PREFIX/bin` is added to `$path`.

source $(brew --prefix nvm)/nvm.sh
if [ ! -d "${HOME}/.nvm" ]; then
  mkdir ~/.nvm
fi

while read v; do
  echo "Node: $v"
  CURRENT=`nvm version $v`
  NEW=`nvm version-remote $v`

  # Install or Update if needed
  if [ "$CURRENT" = "N/A" ]; then
    echo " -> Install version $NEW"
    nvm install $v
  elif ! [ "$CURRENT" = "$NEW" ]; then
    echo " -> Update version $CURRENT to $NEW"
    nvm install $NEW --reinstall-packages-from=$CURRENT
    nvm uninstall $CURENNT
  else
    echo " -> Version $CURRENT is up to date"
  fi

  nvm use $v

  # Global packages
  echo " -> Manage global modules"
  while read p; do
    if ! npm list -g $p > /dev/null 2>/dev/null; then
      echo "   -> install $p"
      npm install -g $p
    fi
  done < node/modules/$v
  npm update -g
  npm list --global --depth=0

done < node/versions

DEFAULT=`cat node/default`
nvm alias default $DEFAULT
nvm use $DEFAULT
