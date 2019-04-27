#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

echo "-----------------------------------------------------------------"
echo " *** Updating Ubuntu Packages List ..."
echo "================================================================="
apt-get update && apt-get upgrade -y
echo "-----------------------------------------------------------------"

echo "*** Installing Development Tools ..."
echo "================================================================="
apt-get install -y git-core default-jdk wget curl dos2unix build-essential bash-completion squid htop tree jq
echo "-----------------------------------------------------------------"

echo "*** Installing Docker Engine ..."
echo "================================================================="
apt-get install -y docker.io
echo "-----------------------------------------------------------------"

echo "*** Installing Python ..."
echo "================================================================="
apt-get install -y python
echo "-----------------------------------------------------------------"
