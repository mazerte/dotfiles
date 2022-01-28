# Set Variables
unset PREFIX
export NULLCMD=bat
export DOTFILES="$HOME/.dotfiles"

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

# Create Aliases
# Commons
alias watch='watch --color ' # https://unix.stackexchange.com/questions/25327/watch-command-alias-expansion
alias ls='exa'
alias cat='bat'
alias exa='exa -laFh --git'
alias trail='<<<${(F)path}'
alias ftrail='<<<${(F)fpath}'
alias lp='sudo lsof -i -P | grep LISTEN'
alias man=batman
alias ohmyzsh='_ohmyzsh(){ open "https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/$@";  unset -f _ohmyzsh; }; _ohmyzsh'

if exists brew; then
  # Brew
  alias bbd="brew bundle dump --force --describe"
fi

if exists aws; then
  # AWS
  alias s3cat='_s3cat(){ aws s3 cp "$1" -;  unset -f _s3cat; }; _s3cat'
fi

if exists kubectl; then
  # Kube
  alias kubectl='kubecolor'
  alias kcc='kubectl config unset current-context'
  alias krc='kubectl config rename-context $(kubectl config current-context)'
  alias kdr='kubectl --dry-run=client -o yaml'
  alias kbg='_kbg(){ kubectl get "$@" -o yaml | bat -l yaml;  unset -f _kbg; }; _kbg'
  alias wkg='_wkg(){ watch --color kubecolor --force-colors get "$@";  unset -f _wkg; }; _wkg'
fi

if exists kubectl && exists aws; then
  # Kube & AWS
  alias kassh='_kassh(){ aws ssm start-session --target $(kubectl get node "$@" -o json | jq -r ".metadata.labels[\"alpha.eksctl.io/instance-id\"]");  unset -f _kassh; }; _kassh'
  alias kpssh='_kpssh(){ k exec -ti "$1" -- /bin/bash;  unset -f _kpssh; }; _kpssh'
  alias assh='_assh(){ aws ssm start-session --target $(aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" "Name=tag:Name,Values=\"*$@*\"" | jq -r  ".Reservations[0].Instances[0].InstanceId");  unset -f _assh; }; _assh'
  alias eksuk='_eksuk(){ aws eks update-kubeconfig --name $1; kubectl config rename-context $(kubectl config current-context) $1 }; _eksuk'
fi

if exists terraform; then
  # Terraform
  alias tfaa='terraform apply -auto-approve'
fi

# Write Handy Functions
function mkcd() {
  mkdir -p "$@" && cd "$_";
}

if exists brew; then
  function cleardns() {
    sudo brew services restart dnsmasq
    sudo dscacheutil -flushcache
    sudo killall -HUP mDNSResponder
  }
fi

# Use ZSH Plugins
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Customize Prompt(s)
export TERM="xterm-256color"

if exists conda; then
  prompt_canaconda() {
    # Depending on the conda version, either might be set. This
    # variant works even if both are set.
    local _path=$CONDA_ENV_PATH$CONDA_PREFIX
    local _env=`basename $_path`
    if ! [ -z "$_path" ] | [ "$_env" = "base" ]; then
      # config - can be overwritten in users' zshrc file.
      set_default POWERLEVEL9K_ANACONDA_LEFT_DELIMITER "("
      set_default POWERLEVEL9K_ANACONDA_RIGHT_DELIMITER ")"
      "$1_prompt_segment" "$0" "$2" "blue" "$DEFAULT_COLOR" "$POWERLEVEL9K_ANACONDA_LEFT_DELIMITER$(basename $_path)$POWERLEVEL9K_ANACONDA_RIGHT_DELIMITER" 'PYTHON_ICON'
    fi
  }
fi

if exists rvm; then
  prompt_crvm() {
    local _rvm_current=`rvm current`
    local _rvm_default=`rvm alias show default`
    if ! [ "$_rvm_current" = "$_rvm_default" ]; then
      if [ $commands[rvm-prompt] ]; then
        local version_and_gemset=${$(rvm-prompt v p)/ruby-}

        if [[ -n "$version_and_gemset" ]]; then
          "$1_prompt_segment" "$0" "$2" "240" "$DEFAULT_COLOR" "$version_and_gemset" 'RUBY_ICON'
        fi
      fi
    fi
  }
fi

if exists kubectl; then
  prompt_ckubecontext() {
    local kubectl_version="$(kubectl version --client 2>/dev/null)"

    if [[ -n "$kubectl_version" ]]; then
      # Get the current Kuberenetes context
      local cur_ctx=$(kubectl config view -o=jsonpath='{.current-context}')
      if ! [ -z "$cur_ctx" ]; then
        cur_namespace="$(kubectl config view -o=jsonpath="{.contexts[?(@.name==\"${cur_ctx}\")].context.namespace}")"
        # If the namespace comes back empty set it default.
        if [[ -z "${cur_namespace}" ]]; then
          cur_namespace="default"
        fi

        local k8s_final_text=""

        if [[ "$cur_ctx" == "$cur_namespace" ]]; then
          # No reason to print out the same identificator twice
          k8s_final_text="$cur_ctx"
        else
          k8s_final_text="$cur_ctx/$cur_namespace"
        fi

        "$1_prompt_segment" "$0" "$2" "27" "white" "$k8s_final_text" "KUBERNETES_ICON"
      fi
    fi
  }
fi

if exists aws; then
  prompt_caws() {
    local aws_region=`aws configure get region`
    local _region="${AWS_DEFAULT_REGION:-$aws_region}"
    local aws_profile="${AWS_PROFILE:-$AWS_DEFAULT_PROFILE}"

    if [[ -n "$aws_profile" ]]; then
      "$1_prompt_segment" "$0" "$2" red white "$aws_profile ($_region)" 'AWS_ICON'
    fi
  }

  function asr() {
    if [[ -z "$1" ]]; then
      unset AWS_DEFAULT_REGION
      echo AWS region cleared.
      return
    fi

    export AWS_DEFAULT_REGION=$1
  }
fi

if exists terraform; then
  prompt_terraform() {
    local tfp=`tf_prompt_info | sed 's/[][]//g'`
    if [[ -n "$tfp" ]]; then
      "$1_prompt_segment" "$0" "$2" "56" white "\uF0EE  $tfp"
    fi
  }
fi

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
POWERLEVEL9K_AWS_BACKGROUND="208"
POWERLEVEL9K_CAWS_BACKGROUND="208"
POWERLEVEL9K_CRVM_BACKGROUND="160"
POWERLEVEL9K_CRVM_FOREGROUND="007"
POWERLEVEL9K_ANACONDA_LEFT_DELIMITER=""
POWERLEVEL9K_ANACONDA_RIGHT_DELIMITER=""
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs canaconda terraform ckubecontext crvm nvm caws command_execution_time time)


if exists nvm; then
  # NVM
  NVM_HOMEBREW=$(brew --prefix nvm)
  # https://github.com/nvm-sh/nvm
  # place this after nvm initialization!
  autoload -U add-zsh-hook
  load-nvmrc() {
    local node_version="$(nvm version)"
    local nvmrc_path="$(nvm_find_nvmrc)"

    if [ -n "$nvmrc_path" ]; then
      local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

      if [ "$nvmrc_node_version" = "N/A" ]; then
        nvm install
      elif [ "$nvmrc_node_version" != "$node_version" ]; then
        nvm use
      fi
    elif [ "$node_version" != "$(nvm version default)" ]; then
      echo "Reverting to nvm default version"
      nvm use default
    fi
  }
  add-zsh-hook chpwd load-nvmrc
  load-nvmrc
fi

source <(antibody init)
antibody bundle < "$DOTFILES/antibody_plugins"

# Set oh-my-zsh path
plugins=(
  nvm
  aws
  kubectl
  terraform
)
ZSH=$(antibody path ohmyzsh/ohmyzsh)
source /opt/homebrew/opt/powerlevel9k/powerlevel9k.zsh-theme

ZSH_THEME="powerlevel9k/powerlevel9k"

if exists aws && exists brew; then
  # AWS
  export PATH="/opt/homebrew/opt/awscli@1/bin:$PATH"
  export PATH="/usr/local/sessionmanagerplugin/bin/:$PATH"
  alias aws2='/opt/homebrew/opt/awscli@2/bin/aws'
fi

if exists conda; then
  # Conda
  # >>> conda initialize >>>
  # !! Contents within this block are managed by 'conda init' !!
  __conda_setup="$('/opt/homebrew/Caskroom/miniforge/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
      eval "$__conda_setup"
  else
      if [ -f "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh" ]; then
          . "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh"
      else
          export PATH="/opt/homebrew/Caskroom/miniforge/base/bin:$PATH"
      fi
  fi
  unset __conda_setup
  # <<< conda initialize <<<
fi

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
fpath=($fpath ~/.zsh/completion)

# Run dotfiles installer
alias dotinstall="~/.dotfiles/install"
alias dotupdate="~/.dotfiles/update"

