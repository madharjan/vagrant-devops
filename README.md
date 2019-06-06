# vagrant-devops

Ubuntu 16.04 for Development (DevOps)

## Features

* build essential
* git - v2.7.4
* wget - v1.17.1
* curl - v7.47
* dos2unix - v6.0.4
* squid - v3.5.12
* tree - v1.7.0
* docker - v18.09.2
* docker-compose- v1.24.0
* java7 - OpenJDK v1.8.0_191
* jq - v1.5.1
* python - v2.7.12
* nvm - v0.33.11
* fakesmtp - v2.0
* swagger editor - latest

## Installation

* Install Vagrant
  * VirtualBox 5.1.38 http://download.virtualbox.org/virtualbox/5.1.38/
  * Vagrant 1.9.1 https://releases.hashicorp.com/vagrant/1.9.1/

* Vagrant Plugins
  * vagrant-vbguest
  * vagrant-proxyconf

 ```bash
 vagrant plugin install vagrant-vbguest
 vagrant plugin install vagrant-proxyconf
 ```

## Clone this project

```bash
git clone https://github.com/madharjan/vagrant-devops
cd vagrant-devops


```

### Provision VM

```bash
## proxy configuration if necessary
#export http_proxy="http://username:password@proxy.company.com:8080"
#export https_proxy="http://username:password@proxy.company.com:8080"
#export no_proxy="localhost,127.0.0.1"

vagrant up
```

### Configure work folder

```bash
 export WORKSPACE_ROOT='<workspace location>'
 # e.g. export WORKSPACE_ROOT='D:\Workspace'
 #      export WORKSPACE_ROOT='/Users/username/Workspace'

unset http_proxy https_proxy no_proxy
vagrant reload
```

### SSH and Navigate to Project Folder

```bash
vagrant ssh

## enable proxy configuration if necessary
#squid-proxy-enable <proxy-server> <proxy-port> [username] [password]
## to disable
#squid-proxy-disable

vagrant@devops:~$ cd /workspace/<project>
```
