#!/usr/bin/env zsh

echo "\n<<< Starting Python Setup >>>\n"

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

create_or_update_env tensorflow ./conda/tensorflow-apple-metal.yml "Python 3.9 (tensorflow)"
