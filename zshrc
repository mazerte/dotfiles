# Set Variables
unset PREFIX
export NULLCMD=bat
if [ -e /workspaces/.codespaces/.persistedshare/dotfiles ]; then
  export DOTFILES="/workspaces/.codespaces/.persistedshare/dotfiles"
else
  export DOTFILES="$HOME/.dotfiles"
fi

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

function watchcmd () {
    IN=2
    case $1 in
        -n)
            IN=$2
            shift 2
            ;;
    esac
    printf '\033c' # clear
    CM="$*"
    LEFT="$(printf 'Every %.1f: %s' $IN $CM)"
    ((PAD = COLUMNS - ${#LEFT}))
    while :
    do
        DT=$(date)
        printf "$LEFT%${PAD}s\n" "$HOST $(date)"
        eval "$CM"
        sleep $IN
        printf '\033c'
    done
}

# Create Aliases
# Commons
alias watch='watchcmd' # https://unix.stackexchange.com/questions/25327/watch-command-alias-expansion
exists bat && alias cat='bat'
exists batcat && alias cat='batcat'
alias exa='exa -laFh --git'
alias trail='<<<${(F)path}'
alias ftrail='<<<${(F)fpath}'
alias lp='sudo lsof -i -P | grep LISTEN'
alias man=batman
alias ohmyzsh='_ohmyzsh(){ open "https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/$@";  unset -f _ohmyzsh; }; _ohmyzsh'
alias pf='_pf(){ ssh -L ${1}:localhost:${2} -N $3;  unset -f _pf; }; _pf'

if exists http-server; then
  alias https-server='_https-server(){ http-server -S -C ~/.certs/local.test.crt -K ~/.certs/local.test.key $@;  unset -f _https-server; }; _https-server'
fi

if exists brew; then
  # Brew
  alias bbd="brew bundle dump --force --describe"
fi

if exists aws; then
  # AWS
  alias s3cat='_s3cat(){ aws s3 cp "$1" -;  unset -f _s3cat; }; _s3cat'
  alias ass='_ass(){ aws ssm start-session --target $(ec2 id $1);  unset -f _ass; }; _ass'
  alias assm='_ass(){ aws ssm start-session --target $(ec2 id $1) --document-name AWS-StartSSHSession;  unset -f _ass; }; _ass'
  alias assh='_assh(){ ssh mazerte@$(ec2 id $1);  unset -f _assh; }; _assh'
  alias apf='_apf(){ ssh -L ${1}:localhost:${2} -N mazerte@$(ec2 id $3);  unset -f _apf; }; _apf'
  function asspf() {
    local instance=`ec2 id $1`
    local params="{\"portNumber\": [\"$2\"], \"localPortNumber\": [\"${3:-$2}\"]}"
    aws ssm start-session \
      --target $instance \
      --document-name AWS-StartPortForwardingSession \
      --parameters $params
  }
  function asspftohost() {
    local instance=`ec2 id $1`
    local params="{\"portNumber\": [\"$2\"], \"localPortNumber\": [\"$3\"], \"host\":[\"$4\"]}}"
    aws ssm start-session \
      --target $instance \
      --document-name AWS-StartPortForwardingSessionToRemoteHost \
      --parameters $params
  }
  function ecspf() {
    local cluster=`ecs id $1 | awk -F"/" '{print $NF}'`
    local task=`ecs task-id $1 $2 | awk -F"/" '{print $NF}'`
    local container=`ecs task-runtime-id $1 $2 $3`
    local params="{\"portNumber\": [\"$4\"], \"localPortNumber\": [\"${5:-$4}\"]}"
    aws ssm start-session \
      --target "ecs:${cluster}_${task}_${container}" \
      --document-name AWS-StartPortForwardingSession \
      --parameters $params
  }
  function ecspftohost() {
    local cluster=`ecs id $1 | awk -F"/" '{print $NF}'`
    local task=`ecs task-id $1 $2 | awk -F"/" '{print $NF}'`
    local container=`ecs task-runtime-id $1 $2 $3`
    local params="{\"portNumber\": [\"$4\"], \"localPortNumber\": [\"$5\"], \"host\":[\"$6\"]}"
    aws ssm start-session \
      --target "ecs:${cluster}_${task}_${container}" \
      --document-name AWS-StartPortForwardingSessionToRemoteHost \
      --parameters $params
  }
  function asr() {
    if exists aws; then
      if [[ -z "$1" ]]; then
        unset AWS_DEFAULT_REGION
        echo AWS region cleared.
        return
      fi

      export AWS_DEFAULT_REGION=$1
    fi
  }
  function aar() {
    local account=`aws sts get-caller-identity | jq -r ".Account"`
    local identity=`aws sts assume-role --role-arn "arn:aws:iam::${account}:role/$1" --role-session-name aws-cli`
    local access_key_id=`echo $identity | jq -r .Credentials.AccessKeyId`
    local secret_access_key=`echo $identity | jq -r .Credentials.SecretAccessKey`
    local session_token=`echo $identity | jq -r .Credentials.SessionToken`
    echo "Switch to arn:aws:iam::${account}:role/$1 to exit tap CTRL-D"
    AWS_ACCESS_KEY_ID=$access_key_id AWS_SECRET_ACCESS_KEY=$secret_access_key AWS_SESSION_TOKEN=$session_token AWS_PROFILE=$1 zsh -l
  }
  function ec2() {
    param="$2"
    if [ -p /dev/stdin ]; then
      read -r param
    fi
    case $1 in
      ls)
        aws ec2 describe-instances | jq -r "[.Reservations[].Instances[] | first( . | select(.Tags[].Value | contains(\"$param\"))) | {Name:(.Tags[] | select(.Key == \"Name\") | .Value), Instance:.InstanceType, State: .State.Name, Id: .InstanceId, DNS: .PublicDnsName}]" | in2csv -f json | csvlook
        ;;
      id)
        aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" "Name=tag:Name,Values=\"*$param*\"" | jq -r  ".Reservations[0].Instances[0].InstanceId"
        ;;
      public)
        aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" "Name=tag:Name,Values=\"*$param*\"" | jq -r  ".Reservations[0].Instances[0].PublicDnsName"
        ;;
      private)
        aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" "Name=tag:Name,Values=\"*$param*\"" | jq -r  ".Reservations[0].Instances[0].PrivateDnsName"
        ;;
      id-all)
        aws ec2 describe-instances --filters "Name=tag:Name,Values=\"*$param*\"" | jq -r  ".Reservations[0].Instances[0].InstanceId"
        ;;
      stop)
        aws ec2 stop-instances --instance-ids $(ec2 id $param)
        ;;
      start)
        aws ec2 start-instances --instance-ids $(ec2 id-all $param)
        ;;
      terminate)
        aws ec2 terminate-instances --instance-ids $(ec2 id $param)
        ;;
      switch)
        TYPE="$3"
        aws ec2 modify-instance-attribute --instance-id $(ec2 id-all $param) --instance-type "{\"Value\": \"$TYPE\"}"
        ;;
    esac
  }

  function ecs() {
    param="$2"
    if [ -p /dev/stdin ]; then
      read -r param
    fi
    case $1 in
      ls)
        aws ecs describe-clusters --clusters $(aws ecs list-clusters | jq -r ".clusterArns | join(\" \")") | jq -r "[.clusters[] | {Name:.clusterName, Status:.status}]"  | in2csv -f json | csvlook
        ;;
      id)
        aws ecs list-clusters | jq -r '.clusterArns[]' | grep $param
        ;;
      services)
        aws ecs describe-services --cluster $(ecs id $param) --services $(aws ecs list-services --cluster $(ecs id Infra) | jq -r '.serviceArns | join(" ")') | jq -r "[.services[] | {Name:.serviceName, Status:.status, TasksCount:.runningCount, TaskDefinition:.taskDefinition}]" | in2csv -f json | csvlook
        ;;
      service-id)
        aws ecs list-services --cluster $(ecs id $param) | jq -r ".serviceArns[]" | grep $3
        ;;
      task-id)
        aws ecs list-tasks --cluster $(ecs id $param) --service $(ecs service-id $param $3) | jq -r ".taskArns[0]"
        ;;
      task-runtime-id)
        aws ecs describe-tasks --cluster $(ecs id $param) --task $(ecs task-id $param $3) | jq -r ".tasks[0].containers[] | select(.name=\"$4\") | .runtimeId"
        ;;
      ssh)
        aws ecs execute-command  \
          --cluster $(ecs id $param) \
          --task $(ecs task-id $param $3) \
          --container $4 \
          --command "/bin/bash" \
          --interactive
        ;;
    esac
  }
fi

if exists kubectl; then
  # Kube
  alias kubectl='kubecolor'
  alias kcc='kubectl config unset current-context'
  alias kcscc='kubectl config set current-context'
  alias krc='kubectl config rename-context $(kubectl config current-context)'
  alias kdr='kubectl --dry-run=client -o yaml'
  alias kbg='_kbg(){ kubectl get "$@" -o yaml | bat -l yaml;  unset -f _kbg; }; _kbg'
  alias wkg='_wkg(){ watch --color kubecolor --force-colors get "$@";  unset -f _wkg; }; _wkg'
fi

if exists kubectl && exists aws; then
  # Kube & AWS
  alias kassh='_kassh(){ aws ssm start-session --target $(kubectl get node "$@" -o json | jq -r ".metadata.labels[\"alpha.eksctl.io/instance-id\"]");  unset -f _kassh; }; _kassh'
  alias kpssh='_kpssh(){ k exec -ti "$1" -- /bin/bash;  unset -f _kpssh; }; _kpssh'
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

prompt_canaconda () {
  if exists conda; then
    local msg
    if _p9k_python_version
    then
      P9K_ANACONDA_PYTHON_VERSION=$_p9k__ret
      if (( _POWERLEVEL9K_ANACONDA_SHOW_PYTHON_VERSION ))
      then
              msg="${P9K_ANACONDA_PYTHON_VERSION//\%/%%} "
      fi
    else
      unset P9K_ANACONDA_PYTHON_VERSION
    fi
    local p=${CONDA_PREFIX:-$CONDA_ENV_PATH}
    local _env=`basename $p`
    if ! [ -z "$p" ] && [ "$_env" != "base" ] && [ "$_env" != "conda" ]; then
        msg+="$_POWERLEVEL9K_ANACONDA_LEFT_DELIMITER$_env$_POWERLEVEL9K_ANACONDA_RIGHT_DELIMITER"
        _p9k_prompt_segment "$0" "blue" "$_p9k_color1" 'PYTHON_ICON' 0 '' "$msg"
    fi
  fi
}

prompt_crvm() {
  if exists rvm; then
    local _rvm_current=`rvm current`
    local _rvm_default=`rvm alias show default`
    if ! [ "$_rvm_current" = "$_rvm_default" ]; then
      if [ $commands[rvm-prompt] ]; then
        local version_and_gemset=${$(rvm-prompt v p)/ruby-}

        if [[ -n "$version_and_gemset" ]]; then
        _p9k_prompt_segment "$0$state" "240" "$DEFAULT_COLOR" 'RUBY_ICON' 0 '' "$version_and_gemset"
        fi
      fi
    fi
  fi
}

prompt_ckubecontext() {
  if exists kubectl; then
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

        _p9k_prompt_segment "$0$state" "27" white 'KUBERNETES_ICON' 0 '' "$k8s_final_text"
      fi
    fi
  fi
}

prompt_caws() {
  if exists aws; then
    if is_ec2; then
      # On EC2 instance
      local EC2_AVAIL_ZONE=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
      local _region="`echo \"$EC2_AVAIL_ZONE\" | sed 's/[a-z]$//'`"
      local aws_profile=$(curl -s http://169.254.169.254/latest/meta-data/iam/info | jq -r ".InstanceProfileArn" | cut -d "/" -f 2)
    else
      local aws_region=`aws configure get region`
      local _region="${AWS_DEFAULT_REGION:-$aws_region}"
      local aws_profile="${AWS_PROFILE:-$AWS_DEFAULT_PROFILE}"
    fi

    if [[ -n "$aws_profile" ]]; then
      _p9k_prompt_segment "$0$state" red white 'AWS_ICON' 0 '' "$aws_profile ($_region)"
    fi
  fi
}

prompt_cterraform() {
  if exists terraform; then
    local tfp=`tf_prompt_info | sed 's/[][]//g'`
    if [[ -n "$tfp" ]]; then
      _p9k_prompt_segment "$0$state" "56" white '' 0 '' "$tfp"
    fi
  fi
}

prompt_compute() {
  local compute="${CURRENT_LINUX_OS:-$CURRENT_OSTYPE}$CURRENT_VERSION($CURRENT_ARCH)"
  local icon=''
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if [[ "$CURRENT_LINUX_OS" == "debian" ]]; then
      icon='LINUX_DEBIAN_ICON'
    elif [[ "$CURRENT_LINUX_OS" == "ubuntu" ]]; then
      icon='LINUX_UBUNTU_ICON'
    elif [[ "$CURRENT_LINUX_OS" == "amzn" ]]; then
      icon='AWS_ICON'
    else
      icon='LINUX_ICON'
    fi
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    icon='APPLE_ICON'
  fi
  _p9k_prompt_segment "$0$state" "29" white "$icon" 0 '' "$compute"
}

prompt_ec2() {
  if is_ec2; then
    local ec2_id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
    local ec2_type=$(curl -s http://169.254.169.254/latest/meta-data/instance-type)
    local ec2_name=$(curlf -s http://169.254.169.254/latest/meta-data/tags/instance/Name 2> /dev/null|| echo "Unknown")
    local ec2="$ec2_name | $ec2_type | $ec2_id"

    _p9k_prompt_segment "$0$state" "240" white "AWS_ICON" 0 '' "$ec2"
  fi
}

prompt_is_docker() {
  if [ $CURRENT_IS_DOCKER = 1 ]; then
    _p9k_prompt_segment "$0$state" "027" white "" 0 '' $'\uf308'
  fi
}

prompt_docker() {
  if exists docker; then
    local docker_context=`docker context inspect | jq -r '.[0].Name'`
    if ! [ "$docker_context" = "default" ]; then
      _p9k_prompt_segment "$0$state" "027" white '' 0 '' "$docker_context  "
    fi
  fi
}

# Disable completion directory permission verification
ZSH_DISABLE_COMPFIX=true

POWERLEVEL9K_MODE='nerdfont-fontconfig'
POWERLEVEL9K_CONTEXT_TEMPLATE="$USER"
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
# POWERLEVEL9K_RPROMPT_ON_NEWLINE=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="$ "
POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX=""
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
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  is_docker
  compute
  ec2
  newline
  context
  dir
  vcs
)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  background_jobs
  canaconda
  cterraform
  ckubecontext
  crvm
  nvm
  caws
  docker
  newline
  status
  command_execution_time
  time
)


if exists nvm; then
  # NVM
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

source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh
antidote load "$DOTFILES/antibody_plugins"

# Set oh-my-zsh path
plugins=(
  nvm
  aws
  kubectl
  terraform
)
ZSH=$(antidote path ohmyzsh/ohmyzsh)
# ZSH_THEME="powerlevel9k/powerlevel9k"

if exists aws && exists brew; then
  # AWS
  export PATH="/opt/homebrew/opt/awscli@1/bin:$PATH"
  export PATH="/usr/local/sessionmanagerplugin/bin/:$PATH"
  alias aws2='/opt/homebrew/opt/awscli@2/bin/aws'
fi

if [ -f /opt/homebrew/Caskroom/miniforge/base/bin/conda ]; then
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

if [ -f /opt/conda/bin/conda ]; then
  # >>> conda initialize >>>
  # !! Contents within this block are managed by 'conda init' !!
  __conda_setup="$('/opt/conda/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
      eval "$__conda_setup"
  else
      if [ -f "/opt/conda/etc/profile.d/conda.sh" ]; then
          . "/opt/conda/etc/profile.d/conda.sh"
      else
          export PATH="/opt/conda/bin:$PATH"
      fi
  fi
  unset __conda_setup
  # <<< conda initialize <<
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
alias dotinstall="$DOTFILES/install"
alias dotupdate="$DOTFILES/update"

# Override Alias
alias ls='exa'

export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

if exists isengardcli; then
  eval "$(isengardcli shell-profile)"
fi
