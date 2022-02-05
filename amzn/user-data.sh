#!/bin/bash
# curl https://raw.githubusercontent.com/mazerte/dotfiles/main/amzn/user-data.sh -sSf | bash


if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  CURRENT_OSTYPE="linux"
  CURRENT_ARCH=$(/usr/bin/arch)
  CURRENT_LINUX_OS=$(egrep '^ID=' /etc/os-release | cut -d "=" -f 2 | sed 's/\"//g')
elif [[ "$OSTYPE" == "darwin"* ]]; then
  CURRENT_OSTYPE="macos"
  CURRENT_ARCH=$(/usr/bin/arch)
else
  CURRENT_OSTYPE="unknown"
fi

# Install SSM
if [[ $(sudo ps -ax | grep amazon-ssm-agents | wc -l) -eq 1 ]]; then
  EC2_AVAIL_ZONE=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
  EC2_REGION="`echo \"$EC2_AVAIL_ZONE\" | sed 's/[a-z]$//'`"
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')"
  mkdir /tmp/ssm
  cd /tmp/ssm
  if [[ "$CURRENT_LINUX_OS" == "debian" ]]; then
    wget https://s3.$EC2_REGION.amazonaws.com/amazon-ssm-$EC2_REGION/latest/debian_$ARCH/amazon-ssm-agent.deb
    sudo dpkg -i amazon-ssm-agent.deb
    sudo systemctl enable amazon-ssm-agent
  elif [[ "$CURRENT_LINUX_OS" == "ubuntu" ]]; then
    sudo snap install amazon-ssm-agent --classic
  elif [[ "$CURRENT_LINUX_OS" == "rhel" ]]; then
    sudo dnf install -y https://s3.$EC2_REGION.amazonaws.com/amazon-ssm-$EC2_REGION/latest/linux_$ARCH/amazon-ssm-agent.rpm
    sudo systemctl enable amazon-ssm-agent
  elif [[ "$CURRENT_OSTYPE" == "macos" ]]; then
    sudo wget https://s3.$EC2_REGION.amazonaws.com/amazon-ssm-$EC2_REGION/latest/darwin_$ARCH/amazon-ssm-agent.pkg
    sudo installer -pkg amazon-ssm-agent.pkg -target /
    sudo launchctl load -w /Library/LaunchDaemons/com.amazon.aws.ssm.plist && sudo launchctl start com.amazon.aws.ssm
  fi
fi

if [[ "$CURRENT_OSTYPE" == "linux" ]]; then
  if [[ "$CURRENT_LINUX_OS" == "debian" ]] || [[ "$CURRENT_LINUX_OS" == "ubuntu" ]]; then
    sudo apt update -y
    sudo apt install -y git zsh
    if [[ "$CURRENT_LINUX_OS" == "ubuntu" ]]; then
      sudo adduser --system  --disabled-password --shell /bin/zsh mazerte
    else
      sudo adduser --system --shell /bin/zsh mazerte
    fi
  elif [[ "$CURRENT_LINUX_OS" == "amzn" ]] || [[ "$CURRENT_LINUX_OS" == "rhel" ]]; then
    sudo yum install -y git zsh
    sudo adduser -r -m -s /bin/zsh mazerte
  fi
  echo 'mazerte ALL=(ALL) NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo
fi

sudo su mazerte <<'EOF'
git clone https://github.com/mazerte/dotfiles ~/.dotfiles
cd ~/.dotfiles
./install
EOF
