#!/bin/bash

set -eou pipefail
sudo apt update
sudo apt upgrade -y
sudo apt-get install -y --no-install-recommends \
    apt-transport-https \
    build-essential \
    ca-certificates \
    curl \
    gnupg-agent \
    linux-headers-$(uname -r) \
    python3-pip \
    python3-setuptools \
    software-properties-common \
    virtualenv
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update && \
    sudo apt-get install -y --no-install-recommends \
        net-tools \
        netcat \
        docker-ce \
        docker-ce-cli \
        containerd.io

if [[ $? > 0 ]]
then
    echo "Installation failures, exiting."
    exit
else
    sudo groupadd --force docker && \
    sudo usermod -aG docker nanda && \
    newgrp docker
    docker run hello-world
    sudo systemctl enable docker.service && \
        sudo systemctl enable containerd.service
    sudo swapoff -a && \
        sudo echo "vm.swappiness=0" | sudo tee — append /etc/sysctl.conf && \
        sudo sed -i '/swap/ s/^\(.*\)$/#\1/g' /etc/fstab
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
    sudo reboot
fi
