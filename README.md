# vagrant-ubuntu

Ubuntu 14.04 for Development (devops)

## Features

* build essential
* git
* wget
* curl
* dos2unix
* tree
* docker
* java8 (openjdk8)
* jq
* python

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