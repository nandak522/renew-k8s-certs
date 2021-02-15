#!/bin/bash

set -eou pipefail

sudo kubeadm init --config kubeadm_config.yaml --upload-certs
