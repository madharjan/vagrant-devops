#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

echo "-----------------------------------------------------------------"
echo " *** Updating Ubuntu Packages List ..."
echo "================================================================="
apt-get update && apt-get upgrade -y
echo "-----------------------------------------------------------------"

echo "*** Installing Development Tools ..."
echo "================================================================="
apt-get install -y git-core default-jdk wget curl dos2unix build-essential bash-completion htop tree jq
apt-get install -y unzip xvfb libxi6 libgconf-2-4 chromium-browser chromium-chromedriver
echo "-----------------------------------------------------------------"

echo "*** Installing Docker Engine ..."
echo "================================================================="
apt-get install -y docker.io
echo "-----------------------------------------------------------------"

echo "*** Installing Python ..."
echo "================================================================="
apt-get install -y python
echo "-----------------------------------------------------------------"

echo "*** Installing Node Version Manager (NVM) ..."
echo "================================================================="
curl -o /home/vagrant/bin/nvm_install.sh https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh
chmod +x /home/vagrant/bin/nvm_install.sh
chown vagrant:vagrant /home/vagrant/bin/nvm_install.sh
echo "-----------------------------------------------------------------"

echo "*** Installing FakeSMTP ..."
echo "================================================================="
mkdir -p /opt/fakesmtp
curl --noproxy "*" --insecure -o /opt/fakesmtp/fakesmtp-2.0.jar https://nexus.local/repository/downloads/fakesmtp/fakeSMTP-2.0.jar
echo "-----------------------------------------------------------------"
