#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive

echo "waiting 180 seconds for cloud-init to update /etc/apt/sources.list"
timeout 180 /bin/bash -c \
  'until stat /var/lib/cloud/instance/boot-finished 2>/dev/null; do echo waiting ...; sleep 1; done'

apt-get update && apt-get -y upgrade
apt-get -y install \
    git curl wget \
    apt-transport-https \
    ca-certificates \
    curl \
    sudo \
    jq \
    vim \
    nano \
    unzip \
    software-properties-common

# Install Docker
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
   $(lsb_release -cs) \
   stable"

apt-get update && apt-get install -y docker-ce

# Install Nomad
curl -fsSL -o /tmp/nomad.zip https://releases.hashicorp.com/nomad/0.8.7/nomad_0.8.7_linux_amd64.zip
unzip -o -d /usr/local/bin/ /tmp/nomad.zip

# Install Consul
curl -fsSL -o /tmp/consul.zip https://releases.hashicorp.com/consul/1.4.3/consul_1.4.3_linux_amd64.zip
unzip -o -d /usr/local/bin/ /tmp/consul.zip

# Improve the startup sequence
cp /tmp/resources/nomad.service /etc/systemd/system/nomad.service
cp /tmp/resources/consul.service /etc/systemd/system/consul.service
cp /tmp/resources/google-startup-scripts.service /etc/systemd/system/multi-user.target.wants/google-startup-scripts.service

systemctl daemon-reload
systemctl enable consul.service
systemctl enable nomad.service
