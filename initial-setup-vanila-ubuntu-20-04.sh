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
sudo apt-get update && \
    sudo apt-get install -y --no-install-recommends \
        net-tools \
        netcat
