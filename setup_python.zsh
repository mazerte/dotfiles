#!/usr/bin/env zsh

echo "\n<<< Starting Python Setup >>>\n"

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

LIST_ENVS=`conda env list --json | jq -r ".envs[]"`

# https://stackoverflow.com/questions/66640705/how-can-i-install-grpcio-on-an-apple-m1-silicon-laptop
GRPC_PYTHON_BUILD_SYSTEM_OPENSSL=1
GRPC_PYTHON_BUILD_SYSTEM_ZLIB=1

function create_or_update_env() {
  if [[ $LIST_ENVS =~ $1$ ]]; then
    echo ">>> Update conda env \"$1\"\n"
    conda activate $1
    conda env update -f $2
  else
    echo ">>> Create conda env \"$1\"\n"
    conda env create -f $2 -n $1
    conda install nb_conda
    python -m ipykernel install --user --name $1 --display-name "$3"
  fi
}

# default pip install
pip install boto3

# conda env
create_or_update_env tensorflow ./conda/tensorflow-apple-metal.yml "Python 3.9 (tensorflow)"
create_or_update_env pytorch ./conda/pytorch-apple-metal.yml "Python 3.8 (pytorch)"
