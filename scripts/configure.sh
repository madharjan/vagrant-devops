#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

echo " *** Configuring System ..."
echo "================================================================="
echo " * Locale ..."
echo "-----------------------------------------------------------------"
sudo sed -i 's/Prompt=.*/Prompt=never/' /etc/update-manager/release-upgrades
sudo sed -i -e'/LANGUAGE/d' /etc/environment
sudo sed -i -e'/LANG/d' /etc/environment
sudo sed -i -e'/LC_ALL/d' /etc/environment
echo 'LANGUAGE="en_US.UTF-8"' | sudo tee -a /etc/environment
echo 'LANG="en_US.UTF-8"' | sudo tee -a /etc/environment
echo 'LC_ALL="en_US.UTF-8"' | sudo tee -a /etc/environment
sudo locale-gen en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
echo "-----------------------------------------------------------------"

echo " * Environment ..."
echo "-----------------------------------------------------------------"
sudo sed -i -e'/JAVA_HOME/d' /etc/environment
echo 'JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64/"' | sudo tee -a /etc/environment
sudo sed -i -e'/DOCKER_DRIVER/d' /etc/environment
echo 'DOCKER_DRIVER=overlay2' | sudo tee -a /etc/environment
sudo sed -i -e'/DOCKER_CONFIG/d' /etc/environment
echo "DOCKER_CONFIG=${HOME}/.docker" | sudo tee -a /etc/environment
echo "-----------------------------------------------------------------"

echo " * Adding MOTD ..."
echo "-----------------------------------------------------------------"
sudo mv $HOME/bin/99-devops /etc/update-motd.d/
sudo chmod +x /etc/update-motd.d/*
sudo dos2unix /etc/update-motd.d/*
echo "-----------------------------------------------------------------"

echo " * Adding $USER to docker group ..."
echo "-----------------------------------------------------------------"
sudo usermod -aG docker $USER > /dev/null
echo "-----------------------------------------------------------------"

echo " * Making $HOME/bin/* executable ..."
echo "-----------------------------------------------------------------"
chmod +x $HOME/bin/*
dos2unix $HOME/bin/*
echo "-----------------------------------------------------------------"

echo " * Adding Proxy related Environment ..."
echo "-----------------------------------------------------------------"
MY_IP=$(ifconfig enp0s8 2>/dev/null|awk '/inet addr:/ {print $2}'|sed 's/addr://')
sudo sed -i -e'/proxy-server/d' /etc/hosts
echo "${MY_IP} proxy-server" | sudo tee -a /etc/hosts
sudo sed -i -e'/proxy_host/d' /etc/environment
sudo sed -i -e'/proxy_port/d' /etc/environment
sudo sed -i -e'/non_proxy/d' /etc/environment
echo "proxy_host=proxy-server" | sudo tee -a /etc/environment
echo "proxy_port=3128" | sudo tee -a /etc/environment
echo 'non_proxy="localhost|127.0.0.1|192.168.56.*"' | sudo tee -a /etc/environment
echo "http_proxy=http://proxy-server:3128" | sudo tee -a /etc/environment
echo "http_proxy=http://proxy-server:3128" | sudo tee -a /etc/environment
echo "no_proxy=localhost.127.0.0.1,192.168.56.0/24" | sudo tee -a /etc/environment
echo "-----------------------------------------------------------------"

echo " * Configuring Docker for local Squid ..."
echo "-----------------------------------------------------------------"
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo cat <<EOT | sudo tee /etc/systemd/system/docker.service.d/http-proxy.conf
[Service]
Environment="http_proxy=http://localhost:3128"
Environment="https_proxy=http://localhost:3128"
Environment="no_proxy=localhost,127.0.0.1,192.168.56.0/24"
EOT
echo "-----------------------------------------------------------------"

echo " * Configuring Docker working folder ..."
echo "-----------------------------------------------------------------"
sudo mkdir -p /opt/lib/docker
sudo rm -rf /var/lib/docker
sudo cp /lib/systemd/system/docker.service /etc/systemd/system/docker.service
sudo sed -i 's#dockerd -H#dockerd -g /opt/lib/docker -H#g' /etc/systemd/system/docker.service
sudo sudo systemctl daemon-reload
sudo systemctl start docker
echo "-----------------------------------------------------------------"

daemon -g /new/path/docker

echo " * Configure Squid to cache packages"
echo "-----------------------------------------------------------------"

sudo sed -i -e'/refresh_/d' /etc/squid/squid.conf
cat <<EOT | sudo tee -a /etc/squid/squid.conf
# refresh_pattern for debs and udebs
refresh_pattern deb$         20160 100%   20160
refresh_pattern udeb$        20160 100%   20160
refresh_pattern tar.gz$      20160 100%   20160
refresh_pattern Release$      1440  40%   20160
refresh_pattern Sources.gz$   1440  40%   20160
refresh_pattern Packages.gz$  1440  40%   20160
refresh_pattern cvd$          1440  40%   20160
refresh_pattern .                0  20%    1440
refresh_all_ims on
EOT

sudo mkdir -p /var/cache/squid
sudo chown -R proxy:proxy /var/cache/squid
squid-proxy-disable

echo " * Disable IPv6"
echo "-----------------------------------------------------------------"
cat <<EOT | sudo tee /etc/sysctl.d/88-disable_ipv6.conf
net.ipv6.conf.all.disable_ipv6=1
net.ipv6.conf.default.disable_ipv6=1
net.ipv6.conf.lo.disable_ipv6=1
EOT
sudo sysctl -f /etc/sysctl.d/88-disable_ipv6.conf
echo "-----------------------------------------------------------------"

echo " * Installing Node via NVM ..."
echo "-----------------------------------------------------------------"
/home/vagrant/bin/nvm_install.sh
echo "-----------------------------------------------------------------"

echo " * Configure FakeSMTP"
echo "-----------------------------------------------------------------"
sudo chown -R vagrant:vagrant /opt/fakesmtp
sudo mv $HOME/conf/fakesmtp.service /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable fakesmtp
sudo systemctl start fakesmtp
echo "-----------------------------------------------------------------"

echo " * Installing Swagger Editor"
echo "-----------------------------------------------------------------"
sudo mv $HOME/conf/swagger-editor.service /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable swagger-editor
sudo systemctl start swagger-editor
echo "-----------------------------------------------------------------"


echo " * Configure Working folder /opt/data/"
echo "-----------------------------------------------------------------"
sudo mkdir -p /opt/data
sudo chown vagrant:vagrant /opt/data
echo "-----------------------------------------------------------------"

echo " * Cleanup ..."
echo "-----------------------------------------------------------------"

sudo apt-get remove -y --purge at snapd lxcfs accountsservice mdadm policykit-1 open-iscsi

sudo apt-get autoremove -y
sudo apt-get clean
sudo rm -rf /tmp/* /var/tmp/*
sudo rm -rf /var/lib/apt/lists/*
sudo rm -f /etc/dpkg/dpkg.cfg.d/02apt-speedup
sudo rm -rf /usr/share/doc/*
echo "-----------------------------------------------------------------"

MY_IP=$(ifconfig enp0s8 2>/dev/null|awk '/inet addr:/ {print $2}'|sed 's/addr://')

echo "*** Done"
echo ""
echo "                   __             ___                            "
echo "                 / __ \___ _   __/ __ \____  _____               "
echo "                / / / / _ \ | / / / / / __ \/  __/               "
echo "               / /_/ /  __/ |/ / /_/ / /_/ /(_  )                "
echo "              /_____/\___/|___/\____/ .___/____/                 "
echo "                                   /_/                           "
echo "+---------------------------------------------------------------+"
echo "|  Vagrant DevOps Tools VM need to be restarted as shown below  |"
echo "|  ===========================================================  |"
echo "|  # Note: Add "${MY_IP} devops.local" to hosts file        |"
echo "|                                                               |"
echo "|  # clear proxy related environment variables                  |"
echo "|  \$unset http_proxy https_proxy no_proxy                       |"
echo "|                                                               |"
echo "|  # set WORKSPACE_ROOT environment variables                   |"
echo "|  #  e.g. 'D:\Workspace' or /Users/<name>/Workspace            |"
echo "|  \$export WORKSPACE_ROOT='<workspace location>'                |"
echo "|                                                               |"
echo "|  # reload the VM                                              |"
echo "|  \$vagrant reload                                              |"
echo "|                                                               |"
echo "|  # SSH into the VM                                            |"
echo "|  \$vagrant ssh                                                 |"
echo "|                                                               |"
echo "|  # setup proxy with username & password if required           |"
echo "|  vagrant@devops:~\$squid-proxy-enable \                        |"
echo "|                      <proxy-server> <proxy-port> \            |"
echo "|                      '[user]' '[password]'                    |"
echo "|                                                               |"
echo "|  vagrant@devops:~\$cd /workspace                               |"
echo "|  vagrant@devops:~\$cd <project>                                |"
echo "|                                                               |"
echo "|  vagrant@devops:~\$make                                        |"
echo "+---------------------------------------------------------------+"
