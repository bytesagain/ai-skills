#!/bin/bash
# Fail2Ban - Intrusion Prevention System Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              FAIL2BAN REFERENCE                             ║
║          Log-Based Intrusion Prevention                     ║
╚══════════════════════════════════════════════════════════════╝

Fail2Ban scans log files for malicious activity (brute-force,
scanning, spam) and bans offending IPs by adding firewall rules.

HOW IT WORKS:
  1. Monitor log files (auth.log, nginx, mail, etc.)
  2. Match failed attempts using regex filters
  3. Count failures per IP within a time window
  4. Ban IP via iptables/nftables/firewalld
  5. Auto-unban after configured time

KEY CONCEPTS:
  Jail         A monitoring unit (service + filter + action)
  Filter       Regex patterns to match log lines
  Action       What to do when threshold hit (ban, email, etc.)
  Ban time     How long to ban an IP
  Find time    Time window to count failures
  Max retry    Number of failures before ban

INSTALL:
  sudo apt install fail2ban          # Debian/Ubuntu
  sudo yum install fail2ban          # RHEL/CentOS
  sudo pacman -S fail2ban            # Arch

  sudo systemctl enable --now fail2ban
EOF
}

cmd_config() {
cat << 'EOF'
CONFIGURATION
===============

FILES:
  /etc/fail2ban/jail.conf          # Defaults (DON'T edit)
  /etc/fail2ban/jail.local         # Your overrides
  /etc/fail2ban/jail.d/*.conf      # Drop-in configs
  /etc/fail2ban/filter.d/          # Filter definitions
  /etc/fail2ban/action.d/          # Action definitions

JAIL.LOCAL (create this file):
  [DEFAULT]
  bantime  = 1h               # Ban duration (use 1d, 1w, etc.)
  findtime = 10m              # Time window for counting failures
  maxretry = 5                # Failures before ban
  banaction = iptables-multiport
  ignoreip = 127.0.0.1/8 ::1 192.168.0.0/16  # Never ban these

  # Email notifications
  destemail = admin@example.com
  sender = fail2ban@example.com
  mta = sendmail
  action = %(action_mwl)s     # Ban + email with whois + log lines

  [sshd]
  enabled = true
  port = ssh
  maxretry = 3
  bantime = 24h

  [nginx-http-auth]
  enabled = true
  port = http,https
  logpath = /var/log/nginx/error.log

  [nginx-limit-req]
  enabled = true
  port = http,https
  logpath = /var/log/nginx/error.log
  maxretry = 10

  [nginx-botsearch]
  enabled = true
  port = http,https
  logpath = /var/log/nginx/access.log
  maxretry = 2

  [postfix]
  enabled = true
  port = smtp,465,587
  logpath = /var/log/mail.log

  [dovecot]
  enabled = true
  port = pop3,imap,993,995

PROGRESSIVE BANNING:
  [DEFAULT]
  bantime.increment = true        # Enable progressive bans
  bantime.factor = 2              # Double ban time each offense
  bantime.maxtime = 4w            # Maximum ban time
  bantime.rndtime = 10m           # Add random time to prevent sync

  # Offense 1: 1h, Offense 2: 2h, Offense 3: 4h, ... up to 4 weeks

ACTION LEVELS:
  action_       = ban only
  action_mw     = ban + email with whois
  action_mwl    = ban + email with whois + relevant log lines
  action_cf     = ban via Cloudflare API
EOF
}

cmd_filters() {
cat << 'EOF'
CUSTOM FILTERS
================

FILTER SYNTAX:
  # /etc/fail2ban/filter.d/my-app.conf
  [Definition]
  failregex = ^<HOST> - .* "POST /login" 401
              ^Failed login from <HOST>
              ^Authentication failure for .* from <HOST>

  ignoreregex = ^<HOST> - .* "GET /health"

  # <HOST> is the magic placeholder that captures the IP

TESTING FILTERS:
  # Test against a log file
  fail2ban-regex /var/log/auth.log /etc/fail2ban/filter.d/sshd.conf

  # Test with specific filter
  fail2ban-regex /var/log/nginx/access.log \
    "^<HOST> - .* \"POST /wp-login.php\" 200"

  # Show matched lines
  fail2ban-regex --print-all-matched /var/log/auth.log sshd

COMMON CUSTOM FILTERS:

  WordPress brute force:
  # /etc/fail2ban/filter.d/wordpress.conf
  [Definition]
  failregex = ^<HOST> .* "POST /wp-login.php
              ^<HOST> .* "POST /xmlrpc.php

  # jail.local
  [wordpress]
  enabled = true
  filter = wordpress
  logpath = /var/log/nginx/access.log
  maxretry = 5
  bantime = 1d

  API rate limiting:
  # /etc/fail2ban/filter.d/api-abuse.conf
  [Definition]
  failregex = ^<HOST> .* "POST /api/" 429
              ^<HOST> .* "GET /api/" 429

  # jail.local
  [api-abuse]
  enabled = true
  filter = api-abuse
  logpath = /var/log/nginx/access.log
  maxretry = 20
  findtime = 1m
  bantime = 30m
EOF
}

cmd_management() {
cat << 'EOF'
MANAGEMENT & MONITORING
==========================

FAIL2BAN-CLIENT:
  # Status
  sudo fail2ban-client status
  sudo fail2ban-client status sshd

  # Manual ban/unban
  sudo fail2ban-client set sshd banip 1.2.3.4
  sudo fail2ban-client set sshd unbanip 1.2.3.4

  # Reload after config change
  sudo fail2ban-client reload
  sudo fail2ban-client reload sshd

  # Check jail config
  sudo fail2ban-client get sshd bantime
  sudo fail2ban-client get sshd maxretry
  sudo fail2ban-client get sshd findtime

  # List banned IPs
  sudo fail2ban-client status sshd | grep "Banned IP"

  # Set ban time on the fly
  sudo fail2ban-client set sshd bantime 86400

STATUS OUTPUT EXAMPLE:
  Status for the jail: sshd
  |- Filter
  |  |- Currently failed: 3
  |  |- Total failed:     847
  |  `- File list:        /var/log/auth.log
  `- Actions
     |- Currently banned: 12
     |- Total banned:     156
     `- Banned IP list:   1.2.3.4 5.6.7.8 ...

MONITORING:
  # Fail2ban log
  tail -f /var/log/fail2ban.log

  # Count bans today
  grep "Ban" /var/log/fail2ban.log | grep "$(date +%Y-%m-%d)" | wc -l

  # Top banned IPs
  grep "Ban" /var/log/fail2ban.log | awk '{print $NF}' | sort | uniq -c | sort -rn | head -20

  # Check iptables rules
  sudo iptables -L f2b-sshd -n --line-numbers

DATABASE:
  # Fail2ban stores bans in SQLite
  /var/lib/fail2ban/fail2ban.sqlite3

  # Query banned IPs
  sudo sqlite3 /var/lib/fail2ban/fail2ban.sqlite3 \
    "SELECT ip, timeofban, bantime FROM bans WHERE jail='sshd' ORDER BY timeofban DESC LIMIT 20;"

TROUBLESHOOTING:
  # Fail2ban not starting
  sudo fail2ban-client -d        # Dump config (check for errors)
  journalctl -u fail2ban -f      # Check systemd logs

  # Filter not matching
  fail2ban-regex /var/log/auth.log /etc/fail2ban/filter.d/sshd.conf --print-all-missed

  # Banned but still can connect
  sudo iptables -L -n | grep f2b  # Check iptables rules
  # Maybe IP is in ignoreip list

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Fail2Ban - Intrusion Prevention System Reference

Commands:
  intro       Overview, concepts, install
  config      Jails, actions, progressive banning
  filters     Custom filters, testing, WordPress/API
  management  Status, ban/unban, monitoring, troubleshooting

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)      cmd_intro ;;
  config)     cmd_config ;;
  filters)    cmd_filters ;;
  management) cmd_management ;;
  help|*)     show_help ;;
esac
