# vagrant-ubuntu

Ubuntu 16.04 for Development (DevOps)

## Features

* build essential
* git - v2.7.4
* wget - v1.17.1
* curl - v7.47
* dos2unix - v6.0.4
* tree - v1.7.0
* docker - v18.09.2
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