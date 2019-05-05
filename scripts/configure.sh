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
echo 'DOCKER_CONFIG=${HOME}/.docker' | sudo tee -a /etc/environment
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
echo "|  vagrant@devops:~\$cd /workspace                               |"
echo "|  vagrant@devops:~\$cd <project>                                |"
echo "|                                                               |"
echo "|  vagrant@devops:~\$make                                        |"
echo "+---------------------------------------------------------------+"
