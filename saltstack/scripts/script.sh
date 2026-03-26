#!/bin/bash
# SaltStack - Infrastructure Automation Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              SALTSTACK REFERENCE                            ║
║          Infrastructure Automation & Configuration          ║
╚══════════════════════════════════════════════════════════════╝

SaltStack (Salt) is an infrastructure automation tool for
configuration management, remote execution, and orchestration.
It uses a master-minion architecture with ZeroMQ messaging.

ARCHITECTURE:
  Salt Master       Central control server
  Salt Minion       Agent on managed nodes
  Salt SSH          Agentless mode (no minion needed)
  Pillar            Secure per-minion data
  Grains            Minion hardware/OS info
  States            Desired configuration (YAML)
  Modules           Execution modules (Python)

SALT vs ANSIBLE vs PUPPET:
  ┌──────────────┬──────────┬──────────┬──────────┐
  │ Feature      │ Salt     │ Ansible  │ Puppet   │
  ├──────────────┼──────────┼──────────┼──────────┤
  │ Agent        │ Yes/SSH  │ No       │ Yes      │
  │ Speed        │ Fastest  │ Slow     │ Medium   │
  │ Language     │ Python   │ Python   │ Ruby     │
  │ Config       │ YAML     │ YAML     │ DSL      │
  │ Push/Pull    │ Both     │ Push     │ Pull     │
  │ Scale        │ 10,000+  │ ~500     │ ~5,000   │
  │ Real-time    │ Yes      │ No       │ No       │
  │ Event system │ Yes      │ No       │ No       │
  └──────────────┴──────────┴──────────┴──────────┘

INSTALL:
  # Master
  curl -L https://bootstrap.saltproject.io | sudo sh -s -- -M
  # Minion
  curl -L https://bootstrap.saltproject.io | sudo sh -s --
EOF
}

cmd_states() {
cat << 'EOF'
STATES & PILLAR
=================

STATE FILE (SLS):
  # /srv/salt/webserver.sls
  nginx:
    pkg.installed: []
    service.running:
      - enable: True
      - watch:
        - file: /etc/nginx/nginx.conf

  /etc/nginx/nginx.conf:
    file.managed:
      - source: salt://nginx/nginx.conf
      - user: root
      - group: root
      - mode: 644
      - template: jinja

  /var/www/html:
    file.directory:
      - user: www-data
      - makedirs: True

  firewall-http:
    firewalld.present:
      - name: public
      - services:
        - http
        - https

JINJA TEMPLATING:
  # /srv/salt/nginx/nginx.conf
  server {
      listen {{ pillar['nginx_port'] | default(80) }};
      server_name {{ grains['fqdn'] }};
      root /var/www/{{ pillar['site_name'] }};

      {% if pillar.get('ssl_enabled', False) %}
      listen 443 ssl;
      ssl_certificate /etc/ssl/{{ grains['id'] }}.crt;
      {% endif %}
  }

PILLAR (secure data):
  # /srv/pillar/secrets.sls
  mysql_root_password: 's3cr3t_p@ss'
  api_keys:
    production: 'ak_prod_xxx'
    staging: 'ak_stag_xxx'

  # /srv/pillar/top.sls
  base:
    'web*':
      - webserver
    'db*':
      - database
    '*':
      - common

TOP FILE:
  # /srv/salt/top.sls
  base:
    '*':
      - common
      - users
    'web*':
      - webserver
      - monitoring
    'db*':
      - database
    'G@os:Ubuntu':           # Grain matching
      - ubuntu-specific
EOF
}

cmd_commands() {
cat << 'EOF'
REMOTE EXECUTION & ORCHESTRATION
====================================

REMOTE EXECUTION:
  salt '*' test.ping                  # Ping all minions
  salt 'web*' cmd.run 'uptime'        # Run command
  salt 'web1' pkg.install nginx       # Install package
  salt '*' service.restart nginx       # Restart service
  salt '*' disk.usage                  # Disk usage
  salt '*' network.interfaces          # Network info
  salt 'web*' state.apply webserver    # Apply state
  salt '*' state.highstate             # Apply all states
  salt '*' saltutil.refresh_pillar     # Refresh pillar

TARGETING:
  salt '*'                            # All minions
  salt 'web*'                         # Glob
  salt -L 'web1,web2,db1'            # List
  salt -G 'os:Ubuntu'                # Grain
  salt -E 'web[0-9]+'               # Regex
  salt -N 'webservers'               # Nodegroup
  salt -C 'G@os:Ubuntu and web*'     # Compound

GRAINS:
  salt '*' grains.items               # All grains
  salt '*' grains.get os              # Specific grain
  salt -G 'os:CentOS' cmd.run 'yum update -y'
  salt -G 'num_cpus:8' cmd.run 'cat /proc/cpuinfo'

KEY MANAGEMENT:
  salt-key -L                         # List all keys
  salt-key -A                         # Accept all pending
  salt-key -a 'web3'                  # Accept specific
  salt-key -d 'old-server'            # Delete key

ORCHESTRATION:
  # /srv/salt/orch/deploy.sls
  deploy_database:
    salt.state:
      - tgt: 'db*'
      - sls: database.upgrade

  deploy_web:
    salt.state:
      - tgt: 'web*'
      - sls: webserver.deploy
      - require:
        - salt: deploy_database

  salt-run state.orchestrate orch.deploy

EVENT SYSTEM:
  # Watch events
  salt-run state.event pretty=True

  # Fire custom event
  salt '*' event.fire_master '{"data": "deploy_complete"}' 'custom/deploy'

  # Reactor (auto-respond to events)
  # /etc/salt/master.d/reactor.conf
  reactor:
    - 'salt/minion/*/start':
      - /srv/reactor/new_minion.sls

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
SaltStack - Infrastructure Automation Reference

Commands:
  intro      Architecture, comparison
  states     SLS states, Jinja, Pillar, top file
  commands   Remote execution, targeting, orchestration

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)    cmd_intro ;;
  states)   cmd_states ;;
  commands) cmd_commands ;;
  help|*)   show_help ;;
esac
