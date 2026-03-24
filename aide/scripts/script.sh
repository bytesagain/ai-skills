#!/usr/bin/env bash
# aide — Advanced Intrusion Detection Environment reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail
VERSION="1.0.0"

show_help() {
    cat << 'HELPEOF'
aide v1.0.0 — File Integrity Monitoring Reference

Usage: aide <command>

Commands:
  intro       What is AIDE, how it works
  init        Initialize the database
  check       Run integrity check
  update      Update database after changes
  config      aide.conf configuration
  rules       Selection rules and groups
  reporting   Report formats and alerts
  deploy      Production deployment guide

Powered by BytesAgain | bytesagain.com
HELPEOF
}

cmd_intro() {
    cat << 'EOF'
# AIDE — Advanced Intrusion Detection Environment

## What is AIDE?
AIDE is a file and directory integrity checker. It creates a database of
file attributes (permissions, checksums, timestamps) and later compares
the current state against this baseline to detect unauthorized changes.

## How It Works
1. **Initialize**: Scan filesystem, record attributes → database
2. **Check**: Compare current filesystem against stored database
3. **Update**: Accept legitimate changes, create new baseline

## Key Features
- Monitors: permissions, ownership, size, mtime, ctime, inode, link count
- Hash algorithms: md5, sha1, sha256, sha512, rmd160, tiger, crc32
- Extended attributes: SELinux contexts, POSIX ACLs
- Regex-based file selection rules
- No daemon required — runs from cron

## vs Tripwire
| Feature | AIDE | Tripwire |
|---------|------|---------|
| License | GPL (free) | Commercial + OSS |
| Config | Single file | Policy + config + keys |
| Setup | Simpler | More complex |
| Signing | No built-in | Cryptographic signing |

## Install
```bash
# RHEL/CentOS
yum install aide

# Debian/Ubuntu
apt install aide

# Config location
/etc/aide.conf        # RHEL
/etc/aide/aide.conf   # Debian
```
EOF
}

cmd_init() {
    cat << 'EOF'
# Initialize AIDE Database

## First-Time Setup
```bash
# Generate initial database
aide --init

# Output goes to (RHEL default):
/var/lib/aide/aide.db.new.gz

# Move to active database
mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
```

## What Gets Recorded
For each monitored file, AIDE stores:
- Inode number
- Permission bits
- Owner (uid/gid)
- Size in bytes
- Modified time (mtime)
- Changed time (ctime)
- Number of hard links
- Checksums (md5, sha256, etc.)
- SELinux context (if enabled)
- ACL entries (if enabled)

## Initialization Time
- Small server (10K files): ~30 seconds
- Medium server (100K files): ~5 minutes
- Large server (1M+ files): 30+ minutes
- Tip: exclude /tmp, /var/cache, /proc, /sys

## Verify Database
```bash
# Check database exists and is readable
file /var/lib/aide/aide.db.gz
# aide.db.gz: gzip compressed data

# Check entry count (decompress and count)
zcat /var/lib/aide/aide.db.gz | grep -c "^/"
```
EOF
}

cmd_check() {
    cat << 'EOF'
# Run AIDE Integrity Check

## Basic Check
```bash
aide --check
```

## Output Format
```
AIDE found differences between database and filesystem!!

Summary:
  Total number of entries:    45678
  Added entries:              3
  Removed entries:            1
  Changed entries:            7

---
Added entries:
  f+++++++++++++: /usr/local/bin/newscript

Removed entries:
  f-----------: /tmp/oldfile

Changed entries:
  File: /etc/passwd
    Size     : 1842       | 1901
    Mtime    : 2026-03-20 | 2026-03-24
    SHA256   : abc123...  | def456...
```

## Exit Codes
| Code | Meaning |
|------|---------|
| 0 | No changes detected |
| 1 | Added entries found |
| 2 | Removed entries found |
| 4 | Changed entries found |
| 7 | Added + removed + changed |
| 14 | Error writing report |
| 15 | Invalid argument |

Codes are bitmasks — can combine (e.g., 5 = added + changed)

## Verbose Output
```bash
# Show all checked entries (very verbose)
aide --check --verbose=255

# Limit to specific directory
aide --check --limit /etc
```

## Cron Check
```bash
# /etc/cron.daily/aide-check
#!/bin/bash
/usr/sbin/aide --check | mail -s "AIDE Report $(hostname)" admin@example.com
```
EOF
}

cmd_update() {
    cat << 'EOF'
# Update AIDE Database

## After Legitimate Changes
When you've made intentional system changes (installed packages, edited configs):

```bash
# Generate new database incorporating current state
aide --update

# Review the changes reported
# If all changes are expected, rotate the database:
mv /var/lib/aide/aide.db.gz /var/lib/aide/aide.db.old.gz
mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz
```

## Workflow
1. Make system changes (yum update, edit configs)
2. Run `aide --update`
3. Review changes — verify all are expected
4. If unexpected changes found → INVESTIGATE
5. If all OK → rotate database files

## Partial Update
AIDE doesn't support partial updates. Each `--update` rebuilds
the entire database. This is by design — ensures consistency.

## Automation Warning
⚠️ Never auto-rotate databases without human review!
An attacker could make changes and then the auto-rotation
would accept them as the new baseline.

## Best Practice
```bash
# Keep dated backups
cp /var/lib/aide/aide.db.gz /var/lib/aide/aide.db.$(date +%Y%m%d).gz

# Rotate
mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz

# Store offsite
scp /var/lib/aide/aide.db.gz backup@remote:/aide-backups/
```
EOF
}

cmd_config() {
    cat << 'EOF'
# AIDE Configuration

## Config File Location
```
/etc/aide.conf         # RHEL/CentOS
/etc/aide/aide.conf    # Debian/Ubuntu
```

## Config Structure
```ini
# Database locations
@@define DBDIR /var/lib/aide
database_in=file:@@{DBDIR}/aide.db.gz
database_out=file:@@{DBDIR}/aide.db.new.gz
database_new=file:@@{DBDIR}/aide.db.new.gz

# What to check
gzip_dbout=yes
verbose=5
report_url=file:/var/log/aide/aide.log
report_url=stdout

# Hash algorithms
ALLXTRAHASHES = sha1+rmd160+sha512+tiger

# Predefined groups
NORMAL = R+rmd160+sha256
DIR = p+i+n+u+g+acl+selinux+xattrs
PERMS = p+u+g+acl+selinux+xattrs
LOG = p+u+g+n+acl+selinux+ftype
CONTENT = sha256+ftype
DATAONLY = p+n+u+g+s+acl+selinux+xattrs+sha256

# Selection rules
/boot/   NORMAL
/bin/    NORMAL
/sbin/   NORMAL
/lib/    NORMAL
/lib64/  NORMAL
/opt/    NORMAL
/usr/    NORMAL
/etc/    PERMS

# Exclusions
!/etc/mtab$
!/var/log/.*
!/var/spool/.*
!/tmp/
!/proc/
!/sys/
!/dev/
!/run/
```

## Macros
```ini
@@define VAR value        # Define variable
@@{VAR}                   # Use variable
@@ifdef VAR               # Conditional
@@endif
@@include /path/to/file   # Include external config
```
EOF
}

cmd_rules() {
    cat << 'EOF'
# AIDE Selection Rules

## Rule Format
```
/path/to/monitor  GROUP
!/path/to/exclude
```

## Attribute Flags
| Flag | Attribute |
|------|-----------|
| p | permissions |
| i | inode number |
| n | number of hard links |
| u | user (uid) |
| g | group (gid) |
| s | size |
| b | block count |
| m | mtime |
| a | atime |
| c | ctime |
| S | check for growing size |
| md5 | MD5 checksum |
| sha1 | SHA-1 checksum |
| sha256 | SHA-256 checksum |
| sha512 | SHA-512 checksum |
| rmd160 | RIPEMD-160 |
| tiger | Tiger checksum |
| acl | POSIX ACL |
| selinux | SELinux context |
| xattrs | Extended attributes |
| ftype | File type |

## Predefined Groups
```ini
# R = p+i+n+u+g+s+m+c+md5+tiger (default read-only)
# L = p+i+n+u+g (permissions only)
# E = empty group
# > = growing log file (size only grows)
```

## Custom Groups
```ini
# Critical binaries — full checksums
CRITICAL = p+i+n+u+g+s+m+c+sha256+sha512

# Config files — permissions + content
CONFIG = p+i+n+u+g+sha256

# Log files — growing, don't hash
LOGS = p+u+g+n+S+ftype

# Apply
/usr/sbin/ CRITICAL
/etc/ CONFIG
/var/log/ LOGS
```

## Regex Rules
```ini
# Exclude backup files
!/.*~$
!/.*\.bak$
!/.*\.swp$

# Monitor specific file types
=/etc/.*\.conf$ CONFIG
```
EOF
}

cmd_reporting() {
    cat << 'EOF'
# AIDE Reporting

## Report Configuration
```ini
# In aide.conf
report_url=file:/var/log/aide/aide.log
report_url=stdout

# Verbose levels (0-255)
verbose=5

# Report attributes
report_attributes=p+i+n+u+g+s+m+c+sha256
```

## Email Reports
```bash
#!/bin/bash
# /etc/cron.daily/aide-report
SUBJECT="AIDE Report - $(hostname) - $(date +%Y-%m-%d)"
MAILTO="security@example.com"
LOGFILE="/var/log/aide/aide-$(date +%Y%m%d).log"

aide --check > "$LOGFILE" 2>&1
EXIT=$?

if [ $EXIT -ne 0 ]; then
    SUBJECT="⚠️ $SUBJECT — CHANGES DETECTED"
fi

mail -s "$SUBJECT" "$MAILTO" < "$LOGFILE"
```

## Parse Report
```bash
# Count changes
grep "^Changed entries:" /var/log/aide/aide.log

# List added files
grep "^f+++++++++" /var/log/aide/aide.log

# List removed files
grep "^f----------" /var/log/aide/aide.log

# List changed files
awk '/^Changed entries:/,/^$/' /var/log/aide/aide.log
```

## Integrate with Syslog
```bash
# Send AIDE results to syslog
aide --check 2>&1 | logger -t aide -p authpriv.notice
```

## SIEM Integration
```bash
# JSON output for log aggregators
aide --check | python3 -c "
import sys, json, re
for line in sys.stdin:
    m = re.match(r'File: (.+)', line.strip())
    if m:
        print(json.dumps({'tool':'aide','file':m.group(1),'event':'changed'}))
"
```
EOF
}

cmd_deploy() {
    cat << 'EOF'
# AIDE Production Deployment

## Step-by-Step
```bash
# 1. Install
yum install aide    # RHEL
apt install aide    # Debian

# 2. Customize config
vi /etc/aide.conf

# 3. Initialize database
aide --init
mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz

# 4. Set up cron
echo '05 4 * * * root /usr/sbin/aide --check | mail -s "AIDE $(hostname)" admin@example.com' \
  >> /etc/crontab

# 5. Protect database
chmod 600 /var/lib/aide/aide.db.gz
chattr +i /var/lib/aide/aide.db.gz  # immutable flag

# 6. Store offsite copy
scp /var/lib/aide/aide.db.gz backup@secure-host:/aide/
```

## Best Practices
1. **Store database offsite** — if attacker has root, they can modify local DB
2. **Use strong hashes** — sha256 minimum, ideally sha512
3. **Exclude noisy paths** — /tmp, /var/cache, /proc, /sys, /run
4. **Review changes before rotating** — never auto-accept
5. **Run after maintenance** — update DB after planned changes
6. **Monitor the monitor** — alert if cron job stops running
7. **Baseline clean system** — init on a known-good state

## Common Pitfalls
- Forgetting to rotate database after `yum update`
- Monitoring /var/log (constant changes = noise)
- Not excluding compiler/build directories
- Running init on a compromised system
- Using md5 alone (collision-vulnerable)

## CIS Benchmark
CIS recommends AIDE for:
- Section 1.3.1: Ensure AIDE is installed
- Section 1.3.2: Ensure filesystem integrity is regularly checked
EOF
}

case "${1:-help}" in
    intro)      cmd_intro ;;
    init)       cmd_init ;;
    check)      cmd_check ;;
    update)     cmd_update ;;
    config)     cmd_config ;;
    rules)      cmd_rules ;;
    reporting)  cmd_reporting ;;
    deploy)     cmd_deploy ;;
    help|-h)    show_help ;;
    version|-v) echo "aide v$VERSION" ;;
    *)          echo "Unknown: $1"; show_help ;;
esac
