#!/usr/bin/env bash
# puppet — Puppet configuration management reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail
VERSION="1.0.0"

show_help() {
    cat << 'HELPEOF'
puppet v1.0.0 — Configuration Management Reference

Usage: puppet <command>

Commands:
  intro       Puppet overview, architecture
  manifests   Classes, resources, resource types
  modules     Module structure, Forge, r10k
  hiera       Data hierarchy, auto lookup
  facts       Facter, custom facts, external facts
  catalog     Compilation, node classification
  types       Built-in and custom resource types
  bolt        Agentless execution, plans, tasks

Powered by BytesAgain | bytesagain.com
HELPEOF
}

cmd_intro() {
    cat << 'EOF'
# Puppet — Configuration Management

## What is Puppet?
Puppet is a configuration management tool that automates the provisioning,
configuration, and management of servers. You declare the desired state of
your infrastructure in Puppet's DSL, and Puppet enforces that state.

## Architecture
```
Puppet Master (Server)
    │
    │ HTTPS (8140)
    │ Agent pulls catalog every 30 min
    │
    ▼
Puppet Agent (Node)
    │
    ├── Collects Facts (facter)
    ├── Sends Facts to Master
    ├── Receives compiled Catalog
    ├── Applies resources in order
    └── Reports status back
```

## Key Concepts
- **Manifest**: .pp files containing Puppet code
- **Resource**: A unit of configuration (file, package, service)
- **Class**: A named block of resources
- **Module**: Self-contained collection of classes/files/templates
- **Catalog**: Compiled set of resources for a specific node
- **Facts**: System information collected by Facter
- **Hiera**: Hierarchical data lookup system

## Install
```bash
# Agent (on managed nodes)
rpm -Uvh https://yum.puppet.com/puppet8-release-el-8.noarch.rpm
yum install puppet-agent
export PATH=/opt/puppetlabs/bin:$PATH

# Server
yum install puppetserver

# Standalone (no server needed)
puppet apply manifest.pp
```

## Quick Start
```bash
# Create a simple manifest
cat > hello.pp << 'PPEOF'
file { '/tmp/hello.txt':
  ensure  => file,
  content => "Hello from Puppet!\n",
  mode    => '0644',
}
PPEOF

# Apply locally
puppet apply hello.pp
```
EOF
}

cmd_manifests() {
    cat << 'EOF'
# Manifests — Puppet Code

## Resource Declaration
```puppet
# Basic resource syntax
type { 'title':
  attribute => value,
  ...
}

# File resource
file { '/etc/motd':
  ensure  => file,
  content => "Welcome to ${facts['hostname']}\n",
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
}

# Package resource
package { 'nginx':
  ensure => installed,
}

# Service resource
service { 'nginx':
  ensure => running,
  enable => true,
}
```

## Classes
```puppet
class webserver {
  package { 'nginx':
    ensure => installed,
  }

  file { '/etc/nginx/nginx.conf':
    ensure  => file,
    source  => 'puppet:///modules/webserver/nginx.conf',
    require => Package['nginx'],
    notify  => Service['nginx'],
  }

  service { 'nginx':
    ensure    => running,
    enable    => true,
    subscribe => File['/etc/nginx/nginx.conf'],
  }
}

# Include class
include webserver

# Include with parameters
class { 'webserver':
  port    => 8080,
  docroot => '/var/www/html',
}
```

## Parameterized Classes
```puppet
class webserver (
  Integer $port    = 80,
  String  $docroot = '/var/www/html',
) {
  file { '/etc/nginx/conf.d/default.conf':
    ensure  => file,
    content => template('webserver/default.conf.erb'),
  }
}
```

## Resource Ordering
```puppet
# Require (B after A)
service { 'nginx':
  require => Package['nginx'],
}

# Before (A before B)
package { 'nginx':
  before => Service['nginx'],
}

# Notify (trigger refresh)
file { '/etc/nginx/nginx.conf':
  notify => Service['nginx'],
}

# Subscribe (listen for refresh)
service { 'nginx':
  subscribe => File['/etc/nginx/nginx.conf'],
}

# Arrow syntax
Package['nginx'] -> File['/etc/nginx/nginx.conf'] ~> Service['nginx']
# -> = ordering
# ~> = ordering + notification
```

## Conditionals
```puppet
if $facts['os']['family'] == 'RedHat' {
  package { 'httpd': ensure => installed }
} elsif $facts['os']['family'] == 'Debian' {
  package { 'apache2': ensure => installed }
}

case $facts['os']['name'] {
  'CentOS', 'RedHat': { $pkg = 'httpd' }
  'Ubuntu', 'Debian': { $pkg = 'apache2' }
  default:            { fail("Unsupported OS") }
}
```
EOF
}

cmd_modules() {
    cat << 'EOF'
# Puppet Modules

## Module Structure
```
mymodule/
├── manifests/
│   ├── init.pp        # Main class (class mymodule)
│   ├── install.pp     # class mymodule::install
│   ├── config.pp      # class mymodule::config
│   └── service.pp     # class mymodule::service
├── files/             # Static files
│   └── myfile.conf
├── templates/         # ERB/EPP templates
│   └── config.erb
├── lib/               # Custom facts/functions
│   └── facter/
│       └── custom_fact.rb
├── data/              # Hiera data (module level)
│   └── common.yaml
├── spec/              # Tests
│   └── classes/
│       └── mymodule_spec.rb
├── metadata.json      # Module metadata
└── README.md
```

## Generate Module Skeleton
```bash
pdk new module mymodule
# or
puppet module generate author-mymodule
```

## metadata.json
```json
{
  "name": "yourname-mymodule",
  "version": "1.0.0",
  "author": "Your Name",
  "license": "Apache-2.0",
  "summary": "Module description",
  "dependencies": [
    {"name": "puppetlabs-stdlib", "version_requirement": ">= 6.0.0"}
  ],
  "operatingsystem_support": [
    {"operatingsystem": "CentOS", "operatingsystemrelease": ["7","8"]}
  ]
}
```

## Puppet Forge
```bash
# Search
puppet module search nginx

# Install from Forge
puppet module install puppetlabs-nginx

# List installed
puppet module list

# Upgrade
puppet module upgrade puppetlabs-nginx
```

## r10k (Module Management)
```bash
# Puppetfile
mod 'puppetlabs-stdlib', '9.0.0'
mod 'puppetlabs-nginx', :latest
mod 'custom-module',
  :git => 'https://github.com/org/puppet-custom.git',
  :tag => 'v1.0.0'

# Deploy
r10k deploy environment -p
r10k puppetfile install
```
EOF
}

cmd_hiera() {
    cat << 'EOF'
# Hiera — Hierarchical Data

## What is Hiera?
Hiera separates data from code. Instead of hardcoding values in manifests,
you define them in YAML/JSON files organized by hierarchy (OS, datacenter,
node, etc.). Puppet automatically looks up values.

## hiera.yaml (Global)
```yaml
# /etc/puppetlabs/puppet/hiera.yaml
---
version: 5
defaults:
  datadir: data
  data_hash: yaml_data

hierarchy:
  - name: "Per-node data"
    path: "nodes/%{trusted.certname}.yaml"
  - name: "Per-OS family"
    path: "os/%{facts.os.family}.yaml"
  - name: "Per-datacenter"
    path: "datacenter/%{facts.datacenter}.yaml"
  - name: "Common data"
    path: "common.yaml"
```

## Data Files
```yaml
# data/common.yaml
nginx::port: 80
nginx::worker_processes: 4

# data/nodes/web01.example.com.yaml
nginx::port: 8080
nginx::worker_processes: 8

# data/os/RedHat.yaml
nginx::package_name: nginx
nginx::config_path: /etc/nginx/nginx.conf
```

## Automatic Parameter Lookup
```puppet
class nginx (
  Integer $port,              # Auto-looks up nginx::port
  Integer $worker_processes,  # Auto-looks up nginx::worker_processes
) {
  # ...
}
```

## Manual Lookup
```puppet
$db_host = lookup('database::host')
$db_port = lookup('database::port', Integer, 'first', 5432)  # with default

# Array merge
$packages = lookup('base_packages', Array, 'unique')

# Hash merge
$settings = lookup('app_settings', Hash, 'deep')
```

## Lookup Types
| Merge Strategy | Behavior |
|---------------|----------|
| first | First match wins (default) |
| unique | Merge arrays, deduplicate |
| hash | Merge hashes (first key wins) |
| deep | Deep merge hashes |

## Encrypt Secrets (hiera-eyaml)
```yaml
# Encrypted values in YAML
database::password: ENC[PKCS7,MIIBeQYJKoZIhvc...]

# Decrypt
eyaml decrypt -f common.yaml
```
EOF
}

cmd_facts() {
    cat << 'EOF'
# Facter — System Facts

## Built-in Facts
```bash
# List all facts
facter

# Specific fact
facter os.family
# RedHat

facter networking.ip
# 10.0.0.1

facter memory.system.total
# 16.00 GiB
```

## Common Facts
| Fact | Example |
|------|---------|
| facts['os']['family'] | RedHat, Debian |
| facts['os']['name'] | CentOS, Ubuntu |
| facts['os']['release']['major'] | 8, 22 |
| facts['networking']['ip'] | 10.0.0.1 |
| facts['networking']['fqdn'] | web01.example.com |
| facts['hostname'] | web01 |
| facts['memory']['system']['total'] | 16.00 GiB |
| facts['processors']['count'] | 4 |
| facts['kernel'] | Linux |
| facts['virtual'] | kvm, vmware, physical |

## Using Facts in Manifests
```puppet
if $facts['os']['family'] == 'RedHat' {
  $config_path = '/etc/sysconfig/network'
} else {
  $config_path = '/etc/network/interfaces'
}

file { '/etc/motd':
  content => "Hostname: ${facts['hostname']}
OS: ${facts['os']['name']} ${facts['os']['release']['full']}
IP: ${facts['networking']['ip']}
Memory: ${facts['memory']['system']['total']}
",
}
```

## Custom Facts (Ruby)
```ruby
# lib/facter/application_version.rb
Facter.add(:application_version) do
  setcode do
    if File.exist?('/opt/myapp/VERSION')
      File.read('/opt/myapp/VERSION').strip
    else
      'not installed'
    end
  end
end
```

## External Facts
```bash
# /etc/facter/facts.d/datacenter.txt
datacenter=us-east-1
environment=production
role=webserver

# Or YAML
# /etc/facter/facts.d/custom.yaml
datacenter: us-east-1
environment: production

# Or executable script
# /etc/facter/facts.d/custom.sh (must be +x)
#!/bin/bash
echo "app_version=$(cat /opt/myapp/VERSION)"
echo "disk_usage=$(df -h / | awk 'NR==2{print $5}')"
```
EOF
}

cmd_catalog() {
    cat << 'EOF'
# Catalog Compilation

## How It Works
```
1. Agent starts run (every 30 min by default)
2. Agent collects facts via Facter
3. Agent sends facts to Puppet Server
4. Server determines node's classes (via node classifier)
5. Server compiles manifest + hiera data + facts → Catalog
6. Server sends catalog (JSON) to agent
7. Agent applies resources in dependency order
8. Agent sends report to server
```

## Node Classification

### Site Manifest (site.pp)
```puppet
# /etc/puppetlabs/code/environments/production/manifests/site.pp

node 'web01.example.com' {
  include role::webserver
}

node 'db01.example.com' {
  include role::database
}

# Regex matching
node /^web\d+\.example\.com$/ {
  include role::webserver
}

# Default node
node default {
  include role::base
}
```

### External Node Classifier (ENC)
```yaml
# Returns YAML for a node
---
classes:
  role::webserver:
  nginx:
    port: 8080
parameters:
  datacenter: us-east-1
environment: production
```

## Environments
```
/etc/puppetlabs/code/environments/
├── production/
│   ├── manifests/
│   ├── modules/
│   ├── data/
│   └── hiera.yaml
├── staging/
│   ├── manifests/
│   └── modules/
└── development/
```

```bash
# Agent uses production by default
puppet agent --environment=staging  # Override
```

## Run Modes
```bash
# Agent daemon (default, runs every 30 min)
puppet agent --enable
systemctl start puppet

# Manual run
puppet agent --test          # One-time run with verbose output
puppet agent --test --noop   # Dry run (show what would change)

# Standalone (no server)
puppet apply manifest.pp
puppet apply --noop manifest.pp
```
EOF
}

cmd_types() {
    cat << 'EOF'
# Resource Types

## Built-in Types

### file
```puppet
file { '/etc/myapp.conf':
  ensure  => file,
  content => template('mymodule/myapp.conf.erb'),
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  backup  => true,
}

file { '/opt/myapp/':
  ensure  => directory,
  recurse => true,
  source  => 'puppet:///modules/mymodule/myapp/',
}

file { '/etc/mylink':
  ensure => link,
  target => '/etc/myapp.conf',
}
```

### package
```puppet
package { 'nginx':
  ensure   => '1.24.0',     # Specific version
  # ensure => installed,    # Any version
  # ensure => latest,       # Always update
  # ensure => absent,       # Remove
  provider => 'yum',        # Override provider
}

package { ['vim', 'curl', 'wget', 'htop']:
  ensure => installed,
}
```

### service
```puppet
service { 'nginx':
  ensure     => running,
  enable     => true,
  hasrestart => true,
  hasstatus  => true,
}
```

### user
```puppet
user { 'deploy':
  ensure     => present,
  uid        => 2000,
  gid        => 'deploy',
  home       => '/home/deploy',
  shell      => '/bin/bash',
  managehome => true,
  groups     => ['docker', 'wheel'],
  password   => '$6$salt$hashedpassword',
}
```

### exec
```puppet
exec { 'install-app':
  command => '/usr/local/bin/install.sh',
  creates => '/opt/myapp/bin/myapp',    # Only run if file doesn't exist
  timeout => 300,
  user    => 'root',
  path    => ['/usr/bin', '/usr/local/bin'],
}

# With unless/onlyif
exec { 'import-db':
  command => 'mysql mydb < /tmp/schema.sql',
  unless  => 'mysql mydb -e "SHOW TABLES" | grep users',
  path    => '/usr/bin',
}
```

### cron
```puppet
cron { 'backup':
  command => '/usr/local/bin/backup.sh',
  user    => 'root',
  hour    => 2,
  minute  => 0,
}
```

### host
```puppet
host { 'db.internal':
  ensure       => present,
  ip           => '10.0.0.5',
  host_aliases => ['database'],
}
```
EOF
}

cmd_bolt() {
    cat << 'EOF'
# Puppet Bolt — Agentless Execution

## What is Bolt?
Bolt is Puppet's agentless automation tool. It runs tasks and plans
over SSH or WinRM without installing a Puppet agent.

## Install
```bash
# RHEL
rpm -Uvh https://yum.puppet.com/puppet-tools-release-el-8.noarch.rpm
yum install puppet-bolt

# Ubuntu
wget https://apt.puppet.com/puppet-tools-release-focal.deb
dpkg -i puppet-tools-release-focal.deb
apt update && apt install puppet-bolt
```

## Inventory
```yaml
# inventory.yaml
groups:
  - name: webservers
    targets:
      - web01.example.com
      - web02.example.com
    config:
      ssh:
        user: deploy
        private-key: ~/.ssh/deploy_key
        host-key-check: false
  - name: databases
    targets:
      - db01.example.com
    config:
      ssh:
        user: admin
        run-as: root
```

## Commands
```bash
# Run a command
bolt command run 'uptime' --targets webservers

# Run on specific host
bolt command run 'df -h' --targets web01.example.com --user admin

# Run a script
bolt script run ./check_disk.sh --targets webservers

# Upload file
bolt file upload local.conf /etc/app.conf --targets webservers
```

## Tasks
```bash
# tasks/restart_service.sh
#!/bin/bash
# Input: service (string)
systemctl restart "$PT_service"
echo "Restarted $PT_service"
```

```json
// tasks/restart_service.json
{
  "description": "Restart a system service",
  "input_method": "environment",
  "parameters": {
    "service": {
      "type": "String",
      "description": "Service name to restart"
    }
  }
}
```

```bash
bolt task run mymodule::restart_service service=nginx --targets webservers
```

## Plans
```puppet
# plans/deploy.pp
plan mymodule::deploy (
  TargetSpec $targets,
  String     $version,
) {
  # Stop service
  run_command('systemctl stop myapp', $targets)

  # Upload new version
  upload_file("/releases/myapp-${version}.tar.gz", '/tmp/', $targets)

  # Install
  run_command("tar xzf /tmp/myapp-${version}.tar.gz -C /opt/myapp/", $targets)

  # Start service
  run_command('systemctl start myapp', $targets)

  return "Deployed v${version} to ${$targets.count} nodes"
}
```

```bash
bolt plan run mymodule::deploy targets=webservers version=2.0.0
```
EOF
}

case "${1:-help}" in
    intro)     cmd_intro ;;
    manifests) cmd_manifests ;;
    modules)   cmd_modules ;;
    hiera)     cmd_hiera ;;
    facts)     cmd_facts ;;
    catalog)   cmd_catalog ;;
    types)     cmd_types ;;
    bolt)      cmd_bolt ;;
    help|-h)   show_help ;;
    version|-v) echo "puppet v$VERSION" ;;
    *)         echo "Unknown: $1"; show_help ;;
esac
