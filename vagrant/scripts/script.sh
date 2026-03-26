#!/bin/bash
# Vagrant - Development Environment Manager Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              VAGRANT REFERENCE                              ║
║          Reproducible Development Environments              ║
╚══════════════════════════════════════════════════════════════╝

Vagrant creates and manages portable development environments
using VMs or containers. "Works on my machine" → "Works on
everyone's machine."

WHY VAGRANT:
  Reproducible     Same environment for entire team
  Isolated         Don't pollute host machine
  Disposable       Destroy and recreate in minutes
  Multi-machine    Test distributed systems locally
  Provider-agnostic VirtualBox, VMware, Docker, Hyper-V

VAGRANT vs DOCKER vs DEVCONTAINERS:
  ┌──────────────┬──────────┬──────────┬──────────────┐
  │ Feature      │ Vagrant  │ Docker   │ DevContainers│
  ├──────────────┼──────────┼──────────┼──────────────┤
  │ Type         │ VM       │ Container│ Container    │
  │ Isolation    │ Full     │ Partial  │ Partial      │
  │ Speed        │ Minutes  │ Seconds  │ Seconds      │
  │ Use case     │ Full OS  │ Services │ IDE          │
  │ Networking   │ Full     │ Bridged  │ Port forward │
  │ GUI          │ Yes      │ No       │ No           │
  │ Resource     │ Heavy    │ Light    │ Light        │
  └──────────────┴──────────┴──────────┴──────────────┘

INSTALL:
  # Install VirtualBox + Vagrant
  brew install vagrant               # macOS
  # Or download from vagrantup.com

WORKFLOW:
  vagrant init ubuntu/jammy64        # Create Vagrantfile
  vagrant up                         # Start VM
  vagrant ssh                        # SSH into VM
  vagrant halt                       # Stop VM
  vagrant destroy                    # Delete VM
  vagrant reload                     # Restart + re-provision
EOF
}

cmd_config() {
cat << 'EOF'
VAGRANTFILE
=============

BASIC:
  Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/jammy64"
    config.vm.hostname = "dev"

    # Port forwarding
    config.vm.network "forwarded_port", guest: 3000, host: 3000
    config.vm.network "forwarded_port", guest: 5432, host: 5432

    # Private network (host-only)
    config.vm.network "private_network", ip: "192.168.56.10"

    # Synced folder
    config.vm.synced_folder ".", "/vagrant"
    config.vm.synced_folder "./src", "/home/vagrant/app"

    # Resources
    config.vm.provider "virtualbox" do |vb|
      vb.memory = "4096"
      vb.cpus = 2
      vb.name = "my-dev-vm"
    end

    # Provisioning
    config.vm.provision "shell", inline: <<-SHELL
      apt-get update
      apt-get install -y docker.io nodejs npm postgresql
      systemctl enable docker
      usermod -aG docker vagrant
    SHELL
  end

MULTI-MACHINE:
  Vagrant.configure("2") do |config|
    config.vm.define "web" do |web|
      web.vm.box = "ubuntu/jammy64"
      web.vm.hostname = "web"
      web.vm.network "private_network", ip: "192.168.56.10"
      web.vm.provision "shell", inline: "apt install -y nginx"
    end

    config.vm.define "db" do |db|
      db.vm.box = "ubuntu/jammy64"
      db.vm.hostname = "db"
      db.vm.network "private_network", ip: "192.168.56.11"
      db.vm.provision "shell", inline: "apt install -y postgresql"
    end

    config.vm.define "redis" do |redis|
      redis.vm.box = "ubuntu/jammy64"
      redis.vm.hostname = "redis"
      redis.vm.network "private_network", ip: "192.168.56.12"
      redis.vm.provision "shell", inline: "apt install -y redis-server"
    end
  end

  vagrant up                         # Start all
  vagrant up web                     # Start specific
  vagrant ssh web                    # SSH to specific

ANSIBLE PROVISIONER:
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbook.yml"
    ansible.groups = {
      "webservers" => ["web"],
      "databases" => ["db"]
    }
  end

BOXES:
  # Popular boxes
  ubuntu/jammy64       # Ubuntu 22.04
  debian/bookworm64    # Debian 12
  centos/stream9       # CentOS Stream 9
  generic/alpine318    # Alpine 3.18
  hashicorp/bionic64   # HashiCorp Ubuntu 18.04

  vagrant box add ubuntu/jammy64
  vagrant box list
  vagrant box update

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Vagrant - Development Environment Manager Reference

Commands:
  intro    Overview, comparison, workflow
  config   Vagrantfile, multi-machine, provisioners, boxes

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)   cmd_intro ;;
  config)  cmd_config ;;
  help|*)  show_help ;;
esac
