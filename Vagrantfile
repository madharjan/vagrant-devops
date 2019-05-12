# -*- mode: ruby -*-
# vi: set ft=ruby :

require "rbconfig"

vmName = "vagrant-ubuntu"
workspaceRoot = ENV['WORKSPACE_ROOT'] || './workspace'

Vagrant.configure("2") do |config|

  # network
  config.vm.network "forwarded_port", guest: 3306,  host: 3306 # mysql
  config.vm.network "forwarded_port", guest: 5432,  host: 5432 # postgres
  config.vm.network "forwarded_port", guest: 8080,  host: 8080 # tomcat
  config.vm.network "forwarded_port", guest: 80,    host: 1080 # nginx
  config.vm.network "forwarded_port", guest: 8000,  host: 8000 # java remode debug
  config.vm.network "forwarded_port", guest: 9000,  host: 9000 # swagger-editor
  config.vm.network "forwarded_port", guest: 2525,  host: 2525 # fakesmtp
  config.vm.network "private_network", ip: "192.168.56.254"
  config.vm.hostname = "devops"

  # sync folders
  config.vm.synced_folder ".", "/vagrant", type: "virtualbox", disabled: true
  config.vm.synced_folder workspaceRoot, "/workspace", type: "virtualbox"

  # provisioning
  config.vm.provision "file", source: "./bin", destination: "$HOME/"
  config.vm.provision "file", source: "./conf", destination: "$HOME/"
  config.vm.provision :shell, path: "./scripts/install.sh"
  config.vm.provision :shell, path: "./scripts/configure.sh", privileged: false

  # configure provider
  config.vm.provider "virtualbox" do |virtualbox, override|

    override.vm.box = "ubuntu/xenial64"
    override.vm.box_url = "https://cloud-images.ubuntu.com/releases/16.04/release/ubuntu-16.04-server-cloudimg-amd64-vagrant.box"
    override.vm.box_check_update = false
    override.vm.usable_port_range= 2800..2900
    override.vm.boot_timeout = 600

    host = RbConfig::CONFIG['host_os']
    # Give VM 1/4 system memory & access to all cpu cores on the host
    if host =~ /darwin/
      cpus = `sysctl -n hw.ncpu`.to_i
      # sysctl returns Bytes and we need to convert to MB
      mem = `sysctl -n hw.memsize`.to_i / 1024 / 1024 / 4
    elsif host =~ /linux/
      cpus = `nproc`.to_i
      # meminfo shows KB and we need to convert to MB
      mem = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024 / 4
    else # sorry Windows folks, I can't help you
      cpus = 4
      mem = 4096
    end

    virtualbox.gui = false
    virtualbox.customize ["modifyvm", :id, "--memory", mem]
    virtualbox.customize ["modifyvm", :id, "--cpus", cpus]
    virtualbox.customize ["modifyvm", :id, "--uartmode1", "disconnected"]
    virtualbox.customize ["modifyvm", :id, "--natdnsproxy1", "off"]
    virtualbox.customize ["modifyvm", :id, "--natdnshostresolver1", "off"]
    virtualbox.customize ["modifyvm", :id, "--nictype1", "virtio"]
    virtualbox.customize ["modifyvm", :id, "--nictype2", "virtio"]
    virtualbox.name = vmName

    extraDisk = ENV['HOME'] + "/VirtualBox VMs/" + vmName + "/ubuntu-extra.vmdk"
    unless File.exist?(extraDisk)
      virtualbox.customize ['createhd', '--filename', extraDisk, '--variant', 'Standard', '--size', 5 * 1024]
    end
    virtualbox.customize ['storageattach', :id,  '--storagectl', 'SCSI', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', extraDisk]

  end
  
end