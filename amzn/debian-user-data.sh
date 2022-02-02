#!/bin/bash
EC2_AVAIL_ZONE=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
EC2_REGION="`echo \"$EC2_AVAIL_ZONE\" | sed 's/[a-z]$//'`"
ARCH=$([ "$(uname -m)" = "arm64" ] && echo "arm64" || echo "amd64")
mkdir /tmp/ssm
cd /tmp/ssm
wget https://s3.$EC2_REGION.amazonaws.com/amazon-ssm-$EC2_REGION/latest/debian_$ARCH/amazon-ssm-agent.deb
sudo dpkg -i amazon-ssm-agent.deb
sudo systemctl status amazon-ssm-agent
sudo systemctl enable amazon-ssm-agent

sudo apt install update
sudo apt install -y git zsh
sudo adduser --system --shell /bin/zsh mazerte
echo 'mazerte ALL=(ALL) NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo

su mazerte <<'EOF'
git clone https://github.com/mazerte/dotfiles ~/.dotfiles
cd ~/.dotfiles
./install
EOF
