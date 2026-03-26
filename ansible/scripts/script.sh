#!/usr/bin/env bash
# ansible — Ansible automation reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail
VERSION="1.0.0"

show_help() {
    cat << 'HELPEOF'
ansible v1.0.0 — IT Automation Reference

Usage: ansible <command>

Commands:
  intro         Ansible overview, architecture
  inventory     Static/dynamic inventory, groups
  playbooks     Plays, tasks, handlers, tags
  modules       Built-in modules reference
  roles         Role structure, Galaxy
  vault         Secrets encryption
  galaxy         Collections, requirements
  best-practices Directory layout, strategies

Powered by BytesAgain | bytesagain.com
HELPEOF
}

cmd_intro() {
    cat << 'EOF'
# Ansible — Agentless IT Automation

## What is Ansible?
Ansible automates configuration management, application deployment,
and orchestration. It connects via SSH (Linux) or WinRM (Windows),
requires no agent, and uses YAML playbooks for human-readable automation.

## Key Features
- Agentless — only needs SSH + Python on target
- Idempotent — running twice produces same result
- YAML-based — human-readable playbooks
- 3000+ built-in modules
- Push-based (no daemon on managed nodes)
- Jinja2 templating
- Ansible Galaxy for sharing roles/collections

## Architecture
```
Control Node (your laptop/CI server)
    │
    ├── ansible.cfg    (configuration)
    ├── inventory      (hosts to manage)
    ├── playbook.yml   (what to do)
    └── roles/         (reusable components)
    │
    │ SSH/WinRM
    ▼
Managed Nodes (servers)
    └── Python 3 (only requirement)
```

## Install
```bash
# pip (recommended)
pip install ansible

# RHEL/CentOS
yum install ansible-core

# Ubuntu
apt install ansible

# Version check
ansible --version
ansible-playbook --version
```

## Quick Start
```bash
# Ad-hoc command
ansible all -i "web01,web02," -m ping
ansible all -i inventory.ini -m shell -a "uptime"
ansible webservers -m copy -a "src=file.txt dest=/tmp/"

# Run playbook
ansible-playbook -i inventory.ini playbook.yml

# Dry run
ansible-playbook playbook.yml --check --diff
```
EOF
}

cmd_inventory() {
    cat << 'EOF'
# Inventory — Hosts and Groups

## INI Format
```ini
# inventory.ini
[webservers]
web01.example.com
web02.example.com ansible_port=2222
web03.example.com ansible_user=deploy

[databases]
db01.example.com
db02.example.com

[loadbalancers]
lb01.example.com

# Group of groups
[production:children]
webservers
databases
loadbalancers

# Group variables
[webservers:vars]
http_port=80
app_env=production
```

## YAML Format
```yaml
# inventory.yml
all:
  children:
    webservers:
      hosts:
        web01.example.com:
        web02.example.com:
          ansible_port: 2222
      vars:
        http_port: 80
    databases:
      hosts:
        db01.example.com:
        db02.example.com:
```

## Host Variables
```yaml
# host_vars/web01.example.com.yml
nginx_worker_processes: 8
app_instances: 4
ssl_certificate: /etc/ssl/web01.pem
```

## Group Variables
```yaml
# group_vars/webservers.yml
nginx_port: 80
app_env: production
deploy_user: deploy
```

## Dynamic Inventory
```bash
# Script that outputs JSON
./inventory.py --list

# AWS EC2
ansible-inventory -i aws_ec2.yml --list

# aws_ec2.yml
plugin: amazon.aws.aws_ec2
regions:
  - us-east-1
keyed_groups:
  - key: tags.Environment
    prefix: env
```

## Special Variables
| Variable | Purpose |
|----------|---------|
| ansible_host | Connection address |
| ansible_port | SSH port (default 22) |
| ansible_user | SSH user |
| ansible_ssh_private_key_file | SSH key |
| ansible_become | Enable sudo (true/false) |
| ansible_become_password | Sudo password |
| ansible_python_interpreter | Python path on target |
EOF
}

cmd_playbooks() {
    cat << 'EOF'
# Playbooks — Automation Scripts

## Basic Playbook
```yaml
# deploy.yml
---
- name: Deploy web application
  hosts: webservers
  become: true
  vars:
    app_version: "2.0.0"
    app_port: 8080

  tasks:
    - name: Install nginx
      ansible.builtin.yum:
        name: nginx
        state: present

    - name: Deploy app config
      ansible.builtin.template:
        src: templates/app.conf.j2
        dest: /etc/nginx/conf.d/app.conf
        owner: root
        mode: '0644'
      notify: Restart nginx

    - name: Start nginx
      ansible.builtin.service:
        name: nginx
        state: started
        enabled: true

  handlers:
    - name: Restart nginx
      ansible.builtin.service:
        name: nginx
        state: restarted
```

## Run Playbook
```bash
ansible-playbook deploy.yml
ansible-playbook deploy.yml -i production.ini
ansible-playbook deploy.yml --limit web01
ansible-playbook deploy.yml --tags deploy
ansible-playbook deploy.yml --check --diff   # Dry run
ansible-playbook deploy.yml -e "app_version=3.0.0"  # Override vars
```

## Task Keywords
```yaml
tasks:
  - name: Install packages
    yum:
      name: "{{ item }}"
      state: present
    loop:
      - nginx
      - vim
      - curl

  - name: Only on CentOS
    yum:
      name: epel-release
    when: ansible_distribution == "CentOS"

  - name: Register output
    command: cat /etc/hostname
    register: hostname_output
    changed_when: false

  - name: Use registered variable
    debug:
      msg: "Hostname is {{ hostname_output.stdout }}"

  - name: Ignore errors
    command: /usr/local/bin/optional-check
    ignore_errors: true

  - name: Block with rescue
    block:
      - name: Try this
        command: /opt/deploy.sh
    rescue:
      - name: If failed, rollback
        command: /opt/rollback.sh
    always:
      - name: Always notify
        debug:
          msg: "Deployment attempt completed"
```

## Tags
```yaml
tasks:
  - name: Install packages
    yum: name=nginx state=present
    tags: [install, nginx]

  - name: Deploy config
    template: src=nginx.conf.j2 dest=/etc/nginx/nginx.conf
    tags: [config, nginx]
```

```bash
ansible-playbook site.yml --tags install
ansible-playbook site.yml --skip-tags config
ansible-playbook site.yml --list-tags
```
EOF
}

cmd_modules() {
    cat << 'EOF'
# Built-in Modules

## File Operations
```yaml
# Copy file
- copy:
    src: files/app.conf
    dest: /etc/app.conf
    owner: root
    mode: '0644'

# Template (Jinja2)
- template:
    src: templates/nginx.conf.j2
    dest: /etc/nginx/nginx.conf

# File state
- file:
    path: /opt/myapp
    state: directory
    owner: deploy
    mode: '0755'

# Line in file
- lineinfile:
    path: /etc/sysctl.conf
    regexp: '^net.ipv4.ip_forward'
    line: 'net.ipv4.ip_forward = 1'

# Block in file
- blockinfile:
    path: /etc/ssh/sshd_config
    block: |
      PermitRootLogin no
      PasswordAuthentication no
```

## Package Management
```yaml
# YUM/DNF
- yum:
    name: ['nginx', 'vim', 'curl']
    state: present

# APT
- apt:
    name: nginx
    state: present
    update_cache: true

# pip
- pip:
    name: flask
    version: "2.0"
    virtualenv: /opt/myapp/venv
```

## Services
```yaml
- service:
    name: nginx
    state: started    # started/stopped/restarted/reloaded
    enabled: true

- systemd:
    name: myapp
    state: started
    daemon_reload: true
```

## Commands
```yaml
# Simple command
- command: /usr/bin/mycmd --arg1 value
  args:
    creates: /opt/result.txt    # Skip if exists

# Shell (supports pipes, redirects)
- shell: cat /etc/passwd | grep deploy > /tmp/deploy.txt
  args:
    executable: /bin/bash

# Script
- script: files/setup.sh
  args:
    creates: /opt/.setup_done
```

## Users/Groups
```yaml
- user:
    name: deploy
    groups: ['docker', 'wheel']
    shell: /bin/bash
    generate_ssh_key: true

- group:
    name: deploy
    gid: 2000
```

## Common Modules
| Module | Purpose |
|--------|---------|
| debug | Print messages/variables |
| assert | Validate conditions |
| wait_for | Wait for port/file/condition |
| uri | HTTP requests |
| get_url | Download files |
| unarchive | Extract tar/zip |
| cron | Manage cron jobs |
| docker_container | Manage Docker |
| mysql_db | MySQL databases |
| postgresql_db | PostgreSQL databases |
EOF
}

cmd_roles() {
    cat << 'EOF'
# Roles — Reusable Components

## Role Directory Structure
```
roles/
└── webserver/
    ├── tasks/
    │   └── main.yml        # Main task list
    ├── handlers/
    │   └── main.yml        # Handler definitions
    ├── templates/
    │   └── nginx.conf.j2   # Jinja2 templates
    ├── files/
    │   └── index.html      # Static files
    ├── vars/
    │   └── main.yml        # Role variables (high priority)
    ├── defaults/
    │   └── main.yml        # Default variables (low priority)
    ├── meta/
    │   └── main.yml        # Role metadata, dependencies
    └── README.md
```

## Create Role
```bash
ansible-galaxy init roles/webserver
```

## Role Tasks
```yaml
# roles/webserver/tasks/main.yml
---
- name: Install nginx
  yum:
    name: nginx
    state: present

- name: Deploy nginx config
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
  notify: Restart nginx

- name: Ensure nginx running
  service:
    name: nginx
    state: started
    enabled: true
```

## Role Defaults
```yaml
# roles/webserver/defaults/main.yml
---
nginx_port: 80
nginx_worker_processes: auto
nginx_user: nginx
nginx_docroot: /usr/share/nginx/html
```

## Role Dependencies
```yaml
# roles/webserver/meta/main.yml
---
dependencies:
  - role: common
  - role: ssl
    vars:
      ssl_domain: example.com
```

## Use Roles in Playbook
```yaml
# site.yml
---
- hosts: webservers
  become: true
  roles:
    - common
    - webserver
    - role: ssl
      vars:
        ssl_cert: /etc/ssl/cert.pem

# Or with include_role (conditional)
  tasks:
    - include_role:
        name: monitoring
      when: enable_monitoring | bool
```
EOF
}

cmd_vault() {
    cat << 'EOF'
# Ansible Vault — Secrets Management

## Encrypt a File
```bash
# Encrypt existing file
ansible-vault encrypt group_vars/production/secrets.yml

# Create new encrypted file
ansible-vault create group_vars/production/secrets.yml

# Encrypt with vault ID
ansible-vault encrypt --vault-id prod@prompt secrets.yml
```

## Decrypt / Edit
```bash
# Decrypt file
ansible-vault decrypt secrets.yml

# Edit in-place (decrypts, opens editor, re-encrypts)
ansible-vault edit secrets.yml

# View without decrypting to disk
ansible-vault view secrets.yml

# Rekey (change password)
ansible-vault rekey secrets.yml
```

## Encrypted File Format
```yaml
# group_vars/production/secrets.yml (before encryption)
db_password: s3cr3t_passw0rd
api_key: abc123xyz
ssl_private_key: |
  -----BEGIN RSA PRIVATE KEY-----
  MIIEowIBAAKCAQEA...
  -----END RSA PRIVATE KEY-----
```

After encryption:
```
$ANSIBLE_VAULT;1.1;AES256
36363661396662333733393733...
```

## Inline Encrypted Variables
```bash
# Encrypt a single value
ansible-vault encrypt_string 's3cr3t' --name 'db_password'
```

Use in YAML:
```yaml
db_password: !vault |
  $ANSIBLE_VAULT;1.1;AES256
  36363661396662333733...
```

## Running with Vault
```bash
# Prompt for password
ansible-playbook site.yml --ask-vault-pass

# Password file
ansible-playbook site.yml --vault-password-file ~/.vault_pass

# Multiple vault IDs
ansible-playbook site.yml \
  --vault-id dev@~/.vault_dev \
  --vault-id prod@prompt
```

## ansible.cfg
```ini
[defaults]
vault_password_file = ~/.vault_pass
# Or
vault_identity_list = dev@~/.vault_dev, prod@~/.vault_prod
```
EOF
}

cmd_galaxy() {
    cat << 'EOF'
# Ansible Galaxy — Collections & Sharing

## Collections (Recommended)
```bash
# Install collection
ansible-galaxy collection install community.general
ansible-galaxy collection install amazon.aws

# From requirements file
ansible-galaxy collection install -r requirements.yml

# List installed
ansible-galaxy collection list
```

## requirements.yml
```yaml
---
collections:
  - name: community.general
    version: ">=7.0.0"
  - name: amazon.aws
    version: "7.0.0"
  - name: community.docker
  - name: community.postgresql

roles:
  - name: geerlingguy.docker
    version: "6.1.0"
  - name: geerlingguy.nginx
  - src: https://github.com/org/ansible-role-myapp.git
    scm: git
    version: v1.0.0
    name: myapp
```

## Install All Dependencies
```bash
ansible-galaxy install -r requirements.yml
ansible-galaxy collection install -r requirements.yml
```

## Popular Collections
| Collection | Contents |
|-----------|----------|
| community.general | 200+ modules (filesystem, packaging, etc.) |
| amazon.aws | EC2, S3, IAM, RDS, etc. |
| community.docker | Docker container management |
| community.postgresql | PostgreSQL management |
| community.mysql | MySQL management |
| ansible.posix | POSIX system modules |
| community.crypto | Certificate management |
| kubernetes.core | K8s resource management |

## Create Collection
```bash
ansible-galaxy collection init mynamespace.mycollection
```

Structure:
```
mynamespace/mycollection/
├── galaxy.yml        # Metadata
├── plugins/
│   ├── modules/      # Custom modules
│   ├── inventory/    # Inventory plugins
│   └── filter/       # Filter plugins
├── roles/            # Roles in collection
├── playbooks/        # Reusable playbooks
└── docs/
```

## Publish to Galaxy
```bash
ansible-galaxy collection build
ansible-galaxy collection publish mynamespace-mycollection-1.0.0.tar.gz --token=xxx
```
EOF
}

cmd_best_practices() {
    cat << 'EOF'
# Ansible Best Practices

## Directory Layout
```
production.ini          # Production inventory
staging.ini             # Staging inventory
ansible.cfg             # Configuration

group_vars/
  all/
    vars.yml            # Variables for all hosts
    vault.yml           # Encrypted secrets
  webservers/
    vars.yml
  databases/
    vars.yml

host_vars/
  web01.example.com.yml

roles/
  common/               # Base config for all servers
  webserver/             # Nginx/Apache setup
  database/              # PostgreSQL/MySQL setup
  monitoring/            # Prometheus/Node exporter

site.yml                # Master playbook
webservers.yml          # Web-only playbook
databases.yml           # DB-only playbook
```

## Master Playbook
```yaml
# site.yml
---
- import_playbook: common.yml
- import_playbook: webservers.yml
- import_playbook: databases.yml
- import_playbook: monitoring.yml
```

## Idempotency Rules
```yaml
# BAD: Not idempotent
- shell: echo "export APP=prod" >> /etc/profile

# GOOD: Idempotent
- lineinfile:
    path: /etc/profile
    line: 'export APP=prod'
    regexp: '^export APP='

# BAD: Always shows "changed"
- command: date

# GOOD: Mark as unchanged
- command: date
  changed_when: false
```

## Check Mode (Dry Run)
```bash
# Show what would change
ansible-playbook site.yml --check --diff

# Force check mode in task
- command: cat /etc/hostname
  check_mode: false  # Always run, even in check mode
```

## Performance
```yaml
# ansible.cfg
[defaults]
forks = 20              # Parallel execution (default 5)
pipelining = True       # Reduce SSH operations
gathering = smart       # Cache facts
fact_caching = jsonfile
fact_caching_connection = /tmp/ansible_facts
fact_caching_timeout = 7200

[ssh_connection]
ssh_args = -o ControlMaster=auto -o ControlPersist=60s
```

## Strategy
```yaml
# Default: linear (task-by-task across all hosts)
- hosts: all
  strategy: linear

# Free: each host runs independently
- hosts: all
  strategy: free

# Serial: rolling update
- hosts: webservers
  serial: 2          # 2 hosts at a time
  # serial: "25%"    # 25% at a time
```
EOF
}

case "${1:-help}" in
    intro)          cmd_intro ;;
    inventory)      cmd_inventory ;;
    playbooks)      cmd_playbooks ;;
    modules)        cmd_modules ;;
    roles)          cmd_roles ;;
    vault)          cmd_vault ;;
    galaxy)         cmd_galaxy ;;
    best-practices) cmd_best_practices ;;
    help|-h)        show_help ;;
    version|-v)     echo "ansible v$VERSION" ;;
    *)              echo "Unknown: $1"; show_help ;;
esac
