#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

echo "*** Mount /dev/sdc as /opt..."
echo "================================================================="
mkfs.ext4 /dev/sdc
sed -i '/dev\/sdc/d' /etc/fstab
echo "/dev/sdc /opt  ext4  defaults 0 0" >> /etc/fstab

mv /opt /opt1
mkdir /opt
mount /opt
mv /opt1/* /opt
rm -rf /opt1
echo "-----------------------------------------------------------------"

echo "-----------------------------------------------------------------"
echo " *** Updating Ubuntu Packages List ..."
echo "================================================================="
apt-get update && apt-get upgrade -y
echo "-----------------------------------------------------------------"

echo "*** Installing Development Tools ..."
echo "================================================================="
apt-get install -y git-core default-jdk wget curl dos2unix build-essential bash-completion squid htop tree jq
apt-get install -y unzip xvfb libxi6 libgconf-2-4 chromium-browser chromium-chromedriver
echo "-----------------------------------------------------------------"

echo "*** Installing Docker Engine ..."
echo "================================================================="
apt-get install -y docker.io
curl -L https://github.com/docker/compose/releases/download/1.24.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
echo "-----------------------------------------------------------------"

echo "*** Installing Python ..."
echo "================================================================="
apt-get install -y python
echo "-----------------------------------------------------------------"

echo "*** Installing Node Version Manager (NVM) ..."
echo "================================================================="
wget -nv https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh
mv install.sh /home/vagrant/bin/nvm_install.sh
chmod +x /home/vagrant/bin/nvm_install.sh
chown vagrant:vagrant /home/vagrant/bin/nvm_install.sh
echo "-----------------------------------------------------------------"

echo "*** Installing FakeSMTP ..."
echo "================================================================="
mkdir -p /opt/fakesmtp

wget -nv http://nilhcem.github.com/FakeSMTP/downloads/fakeSMTP-latest.zip
unzip fakeSMTP-latest.zip
cp fakeSMTP-2.0.jar /opt/fakesmtp/fakesmtp-2.0.jar 
rm fakeSMTP-latest.zip
echo "-----------------------------------------------------------------"
