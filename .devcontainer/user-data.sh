#!/bin/bash
sudo yum update -y
sudo yum install -y docker

wget https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)
sudo mv docker-compose-$(uname -s)-$(uname -m) /usr/local/bin/docker-compose
sudo chmod -v +x /usr/local/bin/docker-compose

echo ' {"hosts": ["tcp://0.0.0.0:2375", "unix:///var/run/docker.sock"]}' | sudo tee /etc/docker/daemon.json
cat << EOF | sudo tee /etc/docker/daemon.json
{
  "hosts": ["tcp://0.0.0.0:2375", "unix:///var/run/docker.sock"],
  "runtimes": {
    "nvidia": {
      "path": "nvidia-container-runtime",
      "runtimeArgs": []
    }
  }
}
EOF
sudo mkdir /etc/systemd/system/docker.service.d
cat << EOF | sudo tee /etc/systemd/system/docker.service.d/override.conf
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd
EOF

sudo systemctl daemon-reload
sudo systemctl enable docker.service
sudo systemctl start docker.service
