#!/usr/bin/env bash
# tripwire — Tripwire host-based IDS reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail
VERSION="1.0.0"

show_help() {
    cat << 'HELPEOF'
tripwire v1.0.0 — Host-Based Intrusion Detection Reference

Usage: tripwire <command>

Commands:
  intro       What is Tripwire, architecture
  install     Installation and key setup
  init        Initialize baseline database
  check       Run integrity check
  update      Update database and policy
  policy      Policy file (twpol.txt) reference
  config      Configuration file (twcfg.txt)
  reporting   twprint, reports, email alerts

Powered by BytesAgain | bytesagain.com
HELPEOF
}

cmd_intro() {
    cat << 'EOF'
# Tripwire — Host-Based Intrusion Detection System

## What is Tripwire?
Tripwire monitors filesystem integrity by comparing current file states
against a known-good baseline. It uses cryptographic signatures to detect
unauthorized modifications to critical system files.

## Architecture
```
twcfg.txt (config)  →  tw.cfg (encrypted)
twpol.txt (policy)  →  tw.pol (encrypted)
                    →  tw.db  (database)
                    →  twr.*  (reports)
```

## Key Components
- **Site Key**: Protects config and policy files
- **Local Key**: Protects database and reports
- **Policy File**: Defines what to monitor and how
- **Database**: Stores baseline file attributes
- **Reports**: Results of each integrity check

## How It Works
1. Define policy (what files to watch, what attributes)
2. Initialize database (snapshot of current state)
3. Run checks (compare current state vs database)
4. Review reports (investigate changes)
5. Update database (accept legitimate changes)

## Editions
- **Open Source**: GPLv2, command-line only
- **Tripwire Enterprise**: Commercial, GUI, central management
- **Tripwire IP360**: Vulnerability management (different product)

## Install
```bash
# RHEL/CentOS (EPEL required)
yum install epel-release
yum install tripwire

# Debian/Ubuntu
apt install tripwire
# Interactive: asks for site and local passphrases
```
EOF
}

cmd_install() {
    cat << 'EOF'
# Tripwire Installation & Key Setup

## Install
```bash
# RHEL/CentOS
yum install tripwire

# Debian/Ubuntu (interactive setup)
apt install tripwire
```

## Generate Keys
```bash
# Site key (protects policy and config)
twadmin --generate-keys --site-keyfile /etc/tripwire/site.key
# Enter site passphrase (REMEMBER THIS!)

# Local key (protects database and reports)
twadmin --generate-keys --local-keyfile /etc/tripwire/$(hostname)-local.key
# Enter local passphrase
```

## Create Signed Config
```bash
# Edit plain-text config
vi /etc/tripwire/twcfg.txt

# Sign it (creates tw.cfg)
twadmin --create-cfgfile --cfgfile /etc/tripwire/tw.cfg \
  --site-keyfile /etc/tripwire/site.key /etc/tripwire/twcfg.txt
```

## Create Signed Policy
```bash
# Edit plain-text policy
vi /etc/tripwire/twpol.txt

# Sign it (creates tw.pol)
twadmin --create-polfile --cfgfile /etc/tripwire/tw.cfg \
  --site-keyfile /etc/tripwire/site.key /etc/tripwire/twpol.txt
```

## Security
After signing, remove plain-text versions:
```bash
rm /etc/tripwire/twcfg.txt /etc/tripwire/twpol.txt
```
To recover plain-text:
```bash
twadmin --print-cfgfile > /etc/tripwire/twcfg.txt
twadmin --print-polfile > /etc/tripwire/twpol.txt
```
EOF
}

cmd_init() {
    cat << 'EOF'
# Initialize Tripwire Database

## Create Baseline
```bash
tripwire --init --cfgfile /etc/tripwire/tw.cfg \
  --polfile /etc/tripwire/tw.pol \
  --site-keyfile /etc/tripwire/site.key \
  --local-keyfile /etc/tripwire/$(hostname)-local.key
```

## What Happens
1. Reads policy file (tw.pol) to know what to monitor
2. Scans all specified files and directories
3. Records attributes (hashes, permissions, timestamps)
4. Saves encrypted database signed with local key
5. Database location: /var/lib/tripwire/$(hostname).twd

## Common Errors During Init
```
### Filename: /usr/sbin/somecommand
### No such file or directory
```
This means the default policy references files that don't exist
on your system. Edit twpol.txt to comment out or remove those entries.

## Fix Missing File Errors
```bash
# Print policy to text
twadmin --print-polfile > /etc/tripwire/twpol.txt

# Comment out missing files
vi /etc/tripwire/twpol.txt

# Recreate signed policy
twadmin --create-polfile --site-keyfile /etc/tripwire/site.key \
  /etc/tripwire/twpol.txt

# Re-initialize
tripwire --init
```
EOF
}

cmd_check() {
    cat << 'EOF'
# Run Tripwire Integrity Check

## Basic Check
```bash
tripwire --check
```

## Check Specific File/Directory
```bash
tripwire --check /etc/passwd
tripwire --check /usr/bin
```

## Report Severity Levels
```bash
# Only report severity >= 66
tripwire --check --severity 66
```

## Check with Email Report
```bash
tripwire --check --email-report --email-report-level 3
```

## Output Format
```
Parsing policy file: /etc/tripwire/tw.pol
*** Processing Unix File System ***
Performing integrity check...

Object Summary:
-------------------------------------------------------
# Section: Critical System Boot Files
-------------------------------------------------------
Added:    0
Removed:  0
Modified: 2

Modified Objects: 2
-------------------------------------------------------
  /etc/passwd          Modified
  /etc/shadow          Modified

Rule Name           Severity Level  Added  Removed  Modified
---------           --------------  -----  -------  --------
Boot Scripts             100          0       0        0
Root config files         66          0       0        2
```

## Exit Codes
| Code | Meaning |
|------|---------|
| 0 | No violations |
| 1 | Violations found |
| 2 | Error |
| 4 | Database not found |

## Cron Automation
```bash
# /etc/cron.daily/tripwire-check
#!/bin/bash
/usr/sbin/tripwire --check --quiet \
  | mail -s "Tripwire $(hostname)" admin@example.com
```
EOF
}

cmd_update() {
    cat << 'EOF'
# Update Tripwire Database

## Interactive Update (after check)
```bash
# Run check and save report
tripwire --check --interactive

# This opens an editor showing all changes
# Mark with [x] to accept, [ ] to reject
# Save and exit → database updates with accepted changes
```

## Update from Report File
```bash
# First, find the latest report
ls -lt /var/lib/tripwire/report/

# Update using specific report
tripwire --update --twrfile \
  /var/lib/tripwire/report/$(hostname)-20260324-100000.twr
```

## Update Policy
When you modify the policy:
```bash
# 1. Export current policy
twadmin --print-polfile > /etc/tripwire/twpol.txt

# 2. Edit policy
vi /etc/tripwire/twpol.txt

# 3. Test policy (dry run)
tripwire --test --cfgfile /etc/tripwire/tw.cfg

# 4. Update policy AND re-init database
tripwire --update-policy /etc/tripwire/twpol.txt

# This signs the new policy AND rebuilds the database
```

## Workflow After System Updates
```bash
# 1. Apply updates
yum update -y

# 2. Run check (will show many changes)
tripwire --check > /tmp/tripwire-post-update.txt

# 3. Review changes (all should be expected)
cat /tmp/tripwire-post-update.txt

# 4. If all OK, interactive update
tripwire --check --interactive
# Accept all changes → new baseline
```
EOF
}

cmd_policy() {
    cat << 'EOF'
# Tripwire Policy File (twpol.txt)

## Policy Structure
```
# Global variable
@@section GLOBAL
TWROOT=/usr/sbin;
TWBIN=/usr/sbin;
TWPOL="/etc/tripwire";
TWDB="/var/lib/tripwire";
TWSKEY="/etc/tripwire";
TWLKEY="/etc/tripwire";
TWREPORT="/var/lib/tripwire/report";

@@section FS
# Rules follow...
```

## Rule Syntax
```
(rulename = "Rule Name", severity = 100, emailto = admin@example.com)
{
    /path/to/monitor -> $(Property_Mask);
    !/path/to/exclude;
}
```

## Property Masks
| Mask | Meaning |
|------|---------|
| p | permissions |
| i | inode |
| n | link count |
| u | uid |
| g | gid |
| t | file type |
| s | size |
| d | device ID |
| b | blocks |
| m | mtime |
| c | ctime |
| a | atime |
| C | CRC-32 |
| M | MD5 |
| S | SHA |
| H | Haval |

## Predefined Variables
```
ReadOnly     = +pinugtsdbmCM-rlacSH     # Binaries, libs
Dynamic      = +pinugtd-srlbamcCMSH      # Log files
Growing      = +pinugtdl-srbamcCMSH       # Growing logs
Device       = +pugsdr-intlbamcCMSH       # Device files
IgnoreAll    = -pinusgtsdbmCMSH           # Monitor nothing
IgnoreNone   = +pinusgtsdbmCMSH-rlaH      # Monitor everything
```

## Example Rules
```
# Critical system binaries
(rulename = "System Binaries", severity = 100)
{
    /bin         -> $(ReadOnly);
    /sbin        -> $(ReadOnly);
    /usr/bin     -> $(ReadOnly);
    /usr/sbin    -> $(ReadOnly);
}

# Config files (permissions matter, content changes expected)
(rulename = "Config Files", severity = 66)
{
    /etc         -> $(Dynamic);
    !/etc/mtab;
    !/etc/resolv.conf;
}

# Log files (only check they exist, growing is expected)
(rulename = "Log Files", severity = 33)
{
    /var/log     -> $(Growing);
}
```

## Severity Levels
- 100: Critical (binaries, kernel)
- 66: Important (config files)
- 33: Low (log files)
EOF
}

cmd_config() {
    cat << 'EOF'
# Tripwire Configuration (twcfg.txt)

## Default Location
```
/etc/tripwire/twcfg.txt  → (signed) → /etc/tripwire/tw.cfg
```

## Configuration Options
```
ROOT          = /usr/sbin
POLFILE       = /etc/tripwire/tw.pol
DBFILE        = /var/lib/tripwire/$(HOSTNAME).twd
REPORTFILE    = /var/lib/tripwire/report/$(HOSTNAME)-$(DATE).twr
SITEKEYFILE   = /etc/tripwire/site.key
LOCALKEYFILE  = /etc/tripwire/$(HOSTNAME)-local.key

EDITOR        = /usr/bin/vi
LATEPROMPTING  = false
LOOSEDIRECTORYCHECKING = false
MAILNOVIOLATIONS = true
EMAILREPORTLEVEL = 3
REPORTLEVEL   = 3
SYSLOGREPORTING = true
MAILMETHOD    = SENDMAIL
MAILPROGRAM   = /usr/sbin/sendmail -oi -t
```

## Report Levels
| Level | Content |
|-------|---------|
| 0 | Single line summary |
| 1 | Added/removed file names |
| 2 | Above + changed file names |
| 3 | Above + property details |
| 4 | Everything |

## Email Configuration
```
MAILMETHOD    = SENDMAIL
MAILPROGRAM   = /usr/sbin/sendmail -oi -t

# Or use SMTP directly
MAILMETHOD    = SMTP
SMTPHOST      = mail.example.com
SMTPPORT      = 25
```

## View Signed Config
```bash
# Decrypt and print current config
twadmin --print-cfgfile --cfgfile /etc/tripwire/tw.cfg

# Update: edit text, then re-sign
twadmin --create-cfgfile --site-keyfile /etc/tripwire/site.key \
  /etc/tripwire/twcfg.txt
```
EOF
}

cmd_reporting() {
    cat << 'EOF'
# Tripwire Reporting

## View Reports
```bash
# List all reports
ls -lt /var/lib/tripwire/report/

# Print report in human-readable format
twprint --print-report --twrfile \
  /var/lib/tripwire/report/myhost-20260324-100000.twr

# Print database contents
twprint --print-dbfile --dbfile /var/lib/tripwire/$(hostname).twd
```

## Report Filtering
```bash
# Show only specific severity
twprint --print-report --twrfile report.twr \
  | grep -A5 "Severity Level.*100"

# Show only modified files
twprint --print-report --twrfile report.twr \
  | grep "Modified"
```

## Email Integration
```bash
#!/bin/bash
# /etc/cron.daily/tripwire-email
REPORT=$(ls -t /var/lib/tripwire/report/*.twr | head -1)
twprint --print-report --twrfile "$REPORT" \
  | mail -s "Tripwire Daily - $(hostname)" security@example.com
```

## Syslog Integration
Enable in twcfg.txt:
```
SYSLOGREPORTING = true
```

Then check:
```bash
grep tripwire /var/log/messages
```

## Parse for Monitoring
```bash
# Exit code based alerting
tripwire --check --quiet
if [ $? -ne 0 ]; then
    # Send to PagerDuty/Slack/etc
    curl -X POST https://hooks.slack.com/services/xxx \
      -d '{"text":"⚠️ Tripwire violation on '"$(hostname)"'"}'
fi
```

## Historical Reports
```bash
# Compare two reports
for rpt in /var/lib/tripwire/report/*.twr; do
    echo "=== $(basename $rpt) ==="
    twprint --print-report --twrfile "$rpt" | head -5
done
```
EOF
}

case "${1:-help}" in
    intro)      cmd_intro ;;
    install)    cmd_install ;;
    init)       cmd_init ;;
    check)      cmd_check ;;
    update)     cmd_update ;;
    policy)     cmd_policy ;;
    config)     cmd_config ;;
    reporting)  cmd_reporting ;;
    help|-h)    show_help ;;
    version|-v) echo "tripwire v$VERSION" ;;
    *)          echo "Unknown: $1"; show_help ;;
esac
