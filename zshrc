# Set Variables
export NULLCMD=bat
export DOTFILES="$HOME/.dotfiles"
export HOMEBREW_BUNDLE_FILE="$DOTFILES/Brewfile"

# Change ZSH Options

# Adjust History Variables & Options
[[ -z $HISTFILE ]] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=5000 # Session Memory Limit
SAVEHIST=4000 # File Memory Limit
setopt histNoStore
setopt extendedHistory
setopt histIgnoreAllDups
unsetopt appendHistory # explicit and unnecessary
setopt incAppendHistoryTime

# Line Editor Options (Completion, Menu, Directory, etc.)
# autoMenu & autoList are on by default
setopt autoCd
setopt globDots

# NVM
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"   # This loads nvm bash_completion
source $(brew --prefix nvm)/nvm.sh

# Create Aliases
alias ls='exa'
alias cat='bat'
alias exa='exa -laFh --git'
alias trail='<<<${(F)path}'
alias ftrail='<<<${(F)fpath}'
alias man=batman
alias bbd="brew bundle dump --force --describe"

# Add Locations to $path Array
typeset -U path

path=(
  $path
  "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
)


# Write Handy Functions
function mkcd() {
  mkdir -p "$@" && cd "$_";
}


# Use ZSH Plugins
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
source <(antibody init)
antibody bundle < "$DOTFILES/antibody_plugins"

# Customize Prompt(s)
export TERM="xterm-256color"

# Disable completion directory permission verification
ZSH_DISABLE_COMPFIX=true

POWERLEVEL9K_MODE='nerdfont-fontconfig'
POWERLEVEL9K_CONTEXT_TEMPLATE="$USER"
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
# POWERLEVEL9K_RPROMPT_ON_NEWLINE=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="$ "
POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND="006"
POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND="015"
POWERLEVEL9K_EXECUTION_TIME_ICON=$'\uFACD'
POWERLEVEL9K_NVM_BACKGROUND="003"
POWERLEVEL9K_NVM_FOREGROUND="000"
POWERLEVEL9K_NODE_ICON=$'\uE718'
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs virtualenv rvm nvm command_execution_time time)

# Set oh-my-zsh path
ZSH=$(antibody path ohmyzsh/ohmyzsh)
source /opt/homebrew/opt/powerlevel9k/powerlevel9k.zsh-theme

ZSH_THEME="powerlevel9k/powerlevel9k"

# AWS
export PATH="/opt/homebrew/opt/awscli@1/bin:$PATH"
alias aws2='/opt/homebrew/opt/awscli@2/bin/aws'

# ...and Other Surprises

# Change Key Bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Add "zstyles" for Completions & Other Things
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':plugin:history-search-multi-word' clear-on-cancel 'yes'

# Load "New" Completion System
autoload -Uz compinit && compinit

# Run dotfiles installer
alias dotinstall="~/.dotfiles/install"
