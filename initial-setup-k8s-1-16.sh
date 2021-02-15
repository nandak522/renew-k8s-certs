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
        docker-ce=5:19.03.4~3-0~ubuntu-bionic \
        docker-ce-cli=5:19.03.4~3-0~ubuntu-bionic \
        containerd.io=1.2.10-3 \
        kubelet=1.16.7-00 \
        # kubeadm=1.16.7-00 \
        kubectl=1.16.7-00

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
    sudo reboot
fi
