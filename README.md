# vagrant-ubuntu

Ubuntu 14.04 for Development (devops)

## Features

* build essential
* git 1.9.1
* wget 1.5
* curl 7.35
* dos2unix 6.0.4
* tree 1.6
* docker server/client 1.6.2, API 1.18
* java7 OpenJDK 7u211
* jq 1.3
* python 2.7.6

## Installation

* Install Vagrant
  * VirtualBox 5.1.38 http://download.virtualbox.org/virtualbox/5.1.38/
  * Vagrant 1.9.1 https://releases.hashicorp.com/vagrant/1.9.1/

* Vagrant Plugins
  * vagrant-vbguest

 ```bash
 vagrant plugin install vagrant-vbguest
 ```

## Clone this project

```bash
git clone https://github.com/madharjan/vagrant-ubuntu
cd vagrant-ubuntu
```

### Provision VM

```bash
vagrant up
```

### Configure work folder

```bash
 export WORKSPACE_ROOT='<workspace location>'
 # e.g. export WORKSPACE_ROOT='D:\Workspace'
 #      export WORKSPACE_ROOT='/Users/username/Workspace'
vagrant reload
```

### SSH and Navigate to Project Folder

```bash
vagrant ssh

vagrant@devops:~$ cd /workspace/<project>
```