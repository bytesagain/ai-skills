#!/usr/bin/env bash
# auditd — Linux Audit Framework reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail
VERSION="1.0.0"

show_help() {
    cat << 'HELPEOF'
auditd v1.0.0 — Linux Audit Framework Reference

Usage: auditd <command>

Commands:
  intro       What is auditd, kernel audit system
  rules       auditctl rules, watches, syscalls
  config      auditd.conf reference
  search      ausearch queries
  report      aureport summaries
  logs        audit.log format
  compliance  PCI-DSS, HIPAA, CIS rules
  tools       auditctl, audit2allow, aulast

Powered by BytesAgain | bytesagain.com
HELPEOF
}

cmd_intro() {
    cat << 'EOF'
# Linux Audit Framework (auditd)

## What is auditd?
The Linux Audit system provides a way to track security-relevant events
on a system. It records who did what, when, and the outcome — essential
for compliance (PCI-DSS, HIPAA, SOX) and forensic analysis.

## Architecture
```
Kernel ──audit subsystem──→ kauditd ──→ auditd daemon
                                          │
                    ┌─────────────────────┤
                    ▼                     ▼
              audit.log            audisp (dispatcher)
                                    │
                              ┌─────┼─────┐
                              ▼     ▼     ▼
                          syslog  plugin  remote
```

## Components
- **auditd**: Daemon that writes audit records to disk
- **auditctl**: Control utility to manage rules and status
- **ausearch**: Search audit logs by criteria
- **aureport**: Generate summary reports
- **augenrules**: Merge rule files from /etc/audit/rules.d/
- **aulast**: Similar to `last` but from audit logs
- **auvirt**: Report VM-related events

## Quick Start
```bash
# Check if running
systemctl status auditd

# Check audit status
auditctl -s

# List current rules
auditctl -l

# Watch a file
auditctl -w /etc/passwd -p wa -k identity

# Search for events
ausearch -k identity

# Generate report
aureport --summary
```
EOF
}

cmd_rules() {
    cat << 'EOF'
# Audit Rules

## Rule Types

### File/Directory Watch (-w)
```bash
# Watch file for writes and attribute changes
auditctl -w /etc/passwd -p wa -k identity

# Watch directory recursively
auditctl -w /etc/ssh/ -p wa -k sshd_config

# Permission filters: r=read, w=write, x=execute, a=attribute
auditctl -w /etc/shadow -p rwxa -k shadow_access
```

### System Call Rules (-a)
```bash
# Log all execve calls (every command execution)
auditctl -a always,exit -F arch=b64 -S execve -k exec_commands

# Log file deletions
auditctl -a always,exit -F arch=b64 -S unlink -S unlinkat -S rename \
  -S renameat -k file_deletion

# Log all mount operations
auditctl -a always,exit -F arch=b64 -S mount -k mounts

# Log time changes
auditctl -a always,exit -F arch=b64 -S adjtimex -S settimeofday \
  -S clock_settime -k time_change

# Log by specific user
auditctl -a always,exit -F arch=b64 -S open -F auid=1000 -k user_files
```

### Filter Fields (-F)
| Field | Example | Meaning |
|-------|---------|---------|
| arch | b64, b32 | Architecture |
| auid | 1000 | Audit UID (login user) |
| uid | 0 | Effective UID |
| euid | 0 | Effective UID |
| pid | 1234 | Process ID |
| path | /etc/passwd | File path |
| perm | wa | Permission filter |
| key | -k mykey | Search key |
| success | 0 or 1 | Syscall succeeded? |
| exit | -EACCES | Exit value |

## Persistent Rules
```bash
# Rules in /etc/audit/rules.d/*.rules survive reboot
# File: /etc/audit/rules.d/10-identity.rules
-w /etc/passwd -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/group -p wa -k identity
-w /etc/gshadow -p wa -k identity

# Load rules
augenrules --load

# Or directly
auditctl -R /etc/audit/rules.d/10-identity.rules
```

## Delete Rules
```bash
# Delete all rules
auditctl -D

# Delete specific watch
auditctl -W /etc/passwd -p wa -k identity

# Lock rules (prevent changes until reboot)
auditctl -e 2
```
EOF
}

cmd_config() {
    cat << 'EOF'
# auditd.conf Configuration

## File Location
```
/etc/audit/auditd.conf
```

## Key Settings
```ini
# Where to write logs
log_file = /var/log/audit/audit.log
log_format = ENRICHED

# Log rotation
max_log_file = 50        # MB per log file
num_logs = 5             # Number of rotated logs
max_log_file_action = ROTATE

# Disk space management
space_left = 75          # MB remaining threshold
space_left_action = SYSLOG
admin_space_left = 50    # Critical threshold
admin_space_left_action = SUSPEND
disk_full_action = SUSPEND
disk_error_action = SUSPEND

# Flush policy
flush = INCREMENTAL_ASYNC
freq = 50                # Flush every 50 records

# Network (receive from remote)
tcp_listen_port = 60     # Uncomment to receive remote logs
tcp_max_per_addr = 1
```

## Log Format Options
| Format | Description |
|--------|-------------|
| RAW | UID/GID as numbers |
| ENRICHED | UID/GID resolved to names |

## Space Actions
| Action | Effect |
|--------|--------|
| IGNORE | Do nothing |
| SYSLOG | Send warning to syslog |
| SUSPEND | Stop writing audit records |
| ROTATE | Rotate log file |
| HALT | Shut down the system |

## Restart After Changes
```bash
# auditd doesn't respond to systemctl restart normally
service auditd restart    # Use service command
# Or
kill -HUP $(pidof auditd)
```
EOF
}

cmd_search() {
    cat << 'EOF'
# ausearch — Search Audit Logs

## Search by Key
```bash
# Events tagged with a key
ausearch -k identity
ausearch -k sshd_config
ausearch -k exec_commands
```

## Search by Time
```bash
# Today's events
ausearch -ts today

# Last hour
ausearch -ts recent

# Specific time range
ausearch -ts 03/24/2026 08:00:00 -te 03/24/2026 12:00:00

# Relative
ausearch -ts this-week
ausearch -ts this-month
```

## Search by User
```bash
# By login UID (who originally logged in)
ausearch -ua 1000

# By effective UID
ausearch -ue 0     # Actions done as root

# By specific user
ausearch -ua root
```

## Search by Event Type
```bash
# Login events
ausearch -m USER_LOGIN

# Authentication
ausearch -m USER_AUTH

# File access
ausearch -m PATH

# System calls
ausearch -m SYSCALL

# Configuration changes
ausearch -m CONFIG_CHANGE
```

## Search by File
```bash
ausearch -f /etc/passwd
ausearch -f /etc/shadow
```

## Output Formats
```bash
# Interpreted (human-readable)
ausearch -i -k identity

# CSV format
ausearch -k identity --format csv

# Just the raw text
ausearch -k identity --raw
```

## Combine Filters
```bash
# Root actions on /etc/passwd today
ausearch -ua 0 -f /etc/passwd -ts today -i
```
EOF
}

cmd_report() {
    cat << 'EOF'
# aureport — Audit Report Summaries

## Summary Report
```bash
aureport --summary
```

Output:
```
Range of time in logs: 03/01/2026 00:00:00 - 03/24/2026 12:00:00
Selected time for report: 03/01/2026 00:00:00 - 03/24/2026 12:00:00
Number of changes in configuration: 15
Number of changes to accounts: 3
Number of logins: 142
Number of failed logins: 7
Number of authentications: 285
Number of failed authentications: 12
Number of anomalies: 0
Number of responses to anomalies: 0
Number of keys: 8
```

## Specific Reports
```bash
# Login report
aureport --login
aureport --login --failed    # Failed logins only

# Authentication
aureport --auth
aureport --auth --failed

# File access
aureport --file

# Executable report
aureport --executable

# System call report
aureport --syscall

# User report
aureport --user

# Terminal report (which TTY)
aureport --terminal

# Anomaly report
aureport --anomaly
```

## Time-Filtered Reports
```bash
# Today only
aureport --login -ts today

# This week
aureport --auth -ts this-week

# Specific range
aureport --file -ts 03/20/2026 -te 03/24/2026
```

## Key Report
```bash
# Events by audit key
aureport --key

# Output:
# Key            Count
# identity       15
# sshd_config    3
# exec_commands  892
```
EOF
}

cmd_logs() {
    cat << 'EOF'
# Audit Log Format

## Log Location
```
/var/log/audit/audit.log
```

## Log Entry Format
```
type=SYSCALL msg=audit(1711267200.123:456): arch=c000003e syscall=2
success=yes exit=3 a0=7ffd1234 a1=0 a2=0 a3=0 items=1 ppid=1234
pid=5678 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0
fsgid=0 tty=pts0 ses=1 comm="cat" exe="/usr/bin/cat"
key="shadow_access"

type=PATH msg=audit(1711267200.123:456): item=0 name="/etc/shadow"
inode=12345 dev=fd:01 mode=0100000 ouid=0 ogid=0 rdev=00:00
nametype=NORMAL cap_fp=0 cap_fi=0 cap_fe=0 cap_fver=0
```

## Key Fields
| Field | Meaning |
|-------|---------|
| type | Record type (SYSCALL, PATH, USER_AUTH...) |
| msg | Timestamp(epoch:serial) |
| arch | System architecture |
| syscall | Syscall number (2=open, 59=execve) |
| success | yes/no |
| auid | Audit UID (original login user) |
| uid | Effective UID at time of event |
| pid | Process ID |
| comm | Command name |
| exe | Full executable path |
| key | Matching audit rule key |
| tty | Terminal |
| ses | Session ID |

## Common Record Types
| Type | Meaning |
|------|---------|
| SYSCALL | System call event |
| PATH | File path in syscall |
| CWD | Current working directory |
| EXECVE | Command + arguments |
| USER_AUTH | Authentication attempt |
| USER_LOGIN | Login event |
| USER_LOGOUT | Logout event |
| CONFIG_CHANGE | Audit config changed |
| ANOM_PROMISCUOUS | Interface in promisc mode |

## Parse with Python
```python
import re
with open('/var/log/audit/audit.log') as f:
    for line in f:
        m = re.search(r'comm="([^"]+)".*key="([^"]+)"', line)
        if m:
            print(f'{m.group(2)}: {m.group(1)}')
```
EOF
}

cmd_compliance() {
    cat << 'EOF'
# Compliance Audit Rules

## CIS Benchmark (RHEL 7/8/9)
```bash
# /etc/audit/rules.d/50-cis.rules

# 4.1.3 Record events that modify date/time
-a always,exit -F arch=b64 -S adjtimex -S settimeofday -k time-change
-a always,exit -F arch=b64 -S clock_settime -k time-change
-w /etc/localtime -p wa -k time-change

# 4.1.4 Record events that modify user/group info
-w /etc/group -p wa -k identity
-w /etc/passwd -p wa -k identity
-w /etc/gshadow -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/security/opasswd -p wa -k identity

# 4.1.5 Record events that modify network
-a always,exit -F arch=b64 -S sethostname -S setdomainname -k system-locale
-w /etc/issue -p wa -k system-locale
-w /etc/issue.net -p wa -k system-locale
-w /etc/hosts -p wa -k system-locale
-w /etc/sysconfig/network -p wa -k system-locale

# 4.1.6 Record login and logout events
-w /var/log/lastlog -p wa -k logins
-w /var/run/faillock/ -p wa -k logins

# 4.1.7 Record session initiation
-w /var/run/utmp -p wa -k session
-w /var/log/wtmp -p wa -k logins
-w /var/log/btmp -p wa -k logins

# 4.1.8 Record permission changes
-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -k perm_mod
-a always,exit -F arch=b64 -S chown -S fchown -S fchownat -S lchown -k perm_mod
-a always,exit -F arch=b64 -S setxattr -S lsetxattr -S fsetxattr -k perm_mod
-a always,exit -F arch=b64 -S removexattr -S lremovexattr -S fremovexattr -k perm_mod

# 4.1.11 Record use of privileged commands
# Generate with: find / -xdev -perm /6000 -type f
-a always,exit -F path=/usr/bin/sudo -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged
-a always,exit -F path=/usr/bin/su -F perm=x -F auid>=1000 -F auid!=4294967295 -k privileged

# 4.1.17 Make rules immutable
-e 2
```

## PCI-DSS Requirements
```bash
# Req 10.2.1: All individual user access to cardholder data
# Req 10.2.2: All actions by root/admin
# Req 10.2.3: All access to audit trails
# Req 10.2.4: Invalid logical access attempts
# Req 10.2.5: Use of identification/authentication mechanisms
# Req 10.2.6: Initialization/stopping of audit logs
# Req 10.2.7: Creation/deletion of system-level objects
```
EOF
}

cmd_tools() {
    cat << 'EOF'
# Audit Tools Reference

## auditctl — Runtime Rule Management
```bash
auditctl -s              # Show status
auditctl -l              # List rules
auditctl -D              # Delete all rules
auditctl -e 1            # Enable auditing
auditctl -e 0            # Disable auditing
auditctl -e 2            # Lock rules (immutable)
auditctl -b 8192         # Set backlog buffer
auditctl -f 1            # Set failure flag (0=silent, 1=printk, 2=panic)
auditctl -r 100          # Rate limit (messages/sec, 0=unlimited)
```

## aulast — Login History from Audit
```bash
aulast              # Like 'last' but from audit logs
aulast --bad        # Failed logins
aulast -f /var/log/audit/audit.log.1  # From specific file
```

## auvirt — Virtual Machine Events
```bash
auvirt --summary    # VM event summary
auvirt --all-events # All VM events
```

## audit2allow — SELinux Policy from Denials
```bash
# Generate SELinux policy from audit denials
audit2allow -a              # From all audit logs
ausearch -m AVC | audit2allow -M mypolicy
semodule -i mypolicy.pp
```

## autrace — Trace Process
```bash
# Trace a command (like strace but via audit)
autrace /bin/ls /tmp
ausearch -p <pid_from_autrace>
```

## Useful One-Liners
```bash
# Top 10 most executed commands
ausearch -m EXECVE -ts today -i | grep 'comm=' | \
  sed 's/.*comm="\([^"]*\)".*/\1/' | sort | uniq -c | sort -rn | head

# Failed logins today
aureport --login --failed -ts today

# Who used sudo
ausearch -k privileged -ts today -i | grep 'auid='

# Files accessed by specific user
ausearch -ua 1000 -ts today -i | grep name=
```
EOF
}

case "${1:-help}" in
    intro)      cmd_intro ;;
    rules)      cmd_rules ;;
    config)     cmd_config ;;
    search)     cmd_search ;;
    report)     cmd_report ;;
    logs)       cmd_logs ;;
    compliance) cmd_compliance ;;
    tools)      cmd_tools ;;
    help|-h)    show_help ;;
    version|-v) echo "auditd v$VERSION" ;;
    *)          echo "Unknown: $1"; show_help ;;
esac
