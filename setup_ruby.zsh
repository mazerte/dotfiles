#!/usr/bin/env zsh

echo "\n<<< Starting Ruby Setup >>>\n"

if exists rvm; then
  echo "RVM exists, skipping install"
else
  echo "RVM doesn't exist, continuing with install"
  curl -sSL https://get.rvm.io | bash -s -- --ignore-dotfiles

  rvm install 2.7
  rvm install 3.0
fi

# Select ruby version
rvm use 2.7

# Install gems
gem install rails


