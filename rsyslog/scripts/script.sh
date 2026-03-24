#!/usr/bin/env bash
# rsyslog — RSyslog advanced logging reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail
VERSION="1.0.0"

show_help() {
    cat << 'HELPEOF'
rsyslog v1.0.0 — Advanced System Logging Reference

Usage: rsyslog <command>

Commands:
  intro         What is RSyslog, architecture
  config        rsyslog.conf structure and syntax
  modules       Input/output/parser modules
  templates     Property replacer, JSON output
  filtering     Property-based and expression filtering
  remote        Remote logging, TCP/UDP, TLS
  performance   Queues, async, rate limiting
  troubleshoot  Debug mode, impstats, validation

Powered by BytesAgain | bytesagain.com
HELPEOF
}

cmd_intro() {
    cat << 'EOF'
# RSyslog — Rocket-Fast System Logging

## What is RSyslog?
RSyslog is the default syslog daemon on most Linux distributions (RHEL, Ubuntu,
Debian, SUSE). It extends traditional syslog with high-performance features:
multi-threading, TCP/TLS transport, database output, and content-based filtering.

## Key Features
- Processes 1 million+ messages per second
- Multi-threaded with configurable queues
- Input: UDP/TCP syslog, files, journals, SNMP traps
- Output: files, databases, Elasticsearch, Kafka, remote syslog
- Content filtering with regex, property comparisons, RainerScript
- TLS encryption for secure transport
- Rate limiting and message deduplication

## Architecture
```
Input Modules (im*)     →  Main Queue  →  RuleSet  →  Action Queues  →  Output Modules (om*)
  imudp (UDP:514)           │               │            │                omfile (files)
  imtcp (TCP:514)           │          Filters/          │                omfwd (forward)
  imfile (file tail)        │          Templates         │                ommysql (MySQL)
  imjournal (systemd)       │               │            │                omelasticsearch
  immark (heartbeat)        └───────────────┘            └──────────────  omkafka
```

## Config Location
```
/etc/rsyslog.conf                  # Main config
/etc/rsyslog.d/*.conf              # Drop-in configs
```

## Quick Check
```bash
# Version and features
rsyslogd -v

# Validate config
rsyslogd -N1

# Status
systemctl status rsyslog
```
EOF
}

cmd_config() {
    cat << 'EOF'
# RSyslog Configuration

## Config File Structure
```bash
# /etc/rsyslog.conf

################
# GLOBAL DIRECTIVES
################
global(
    workDirectory="/var/lib/rsyslog"
    maxMessageSize="64k"
)

################
# MODULES
################
module(load="imuxsock")    # Local system logging
module(load="imjournal")   # systemd journal
module(load="imudp")       # UDP syslog input
input(type="imudp" port="514")
module(load="imtcp")       # TCP syslog input
input(type="imtcp" port="514")

################
# TEMPLATES
################
template(name="DynFile" type="string"
    string="/var/log/remote/%HOSTNAME%/%PROGRAMNAME%.log"
)

################
# RULES
################
# Traditional selector format
*.info;mail.none;authpriv.none;cron.none  /var/log/messages
authpriv.*                                 /var/log/secure
mail.*                                     -/var/log/maillog
cron.*                                     /var/log/cron
*.emerg                                    :omusrmsg:*
```

## Config Syntax Formats
RSyslog supports THREE syntax formats:
```bash
# 1. Legacy (sysklogd compatible)
mail.* /var/log/maillog

# 2. Legacy directive
$ModLoad imudp
$UDPServerRun 514

# 3. RainerScript (recommended)
module(load="imudp")
input(type="imudp" port="514")

action(type="omfile" file="/var/log/maillog")
```

## Load Order
1. /etc/rsyslog.conf (top to bottom)
2. Files in /etc/rsyslog.d/ (alphabetical)
3. First matching rule wins (unless using `&` or `stop`)
EOF
}

cmd_modules() {
    cat << 'EOF'
# RSyslog Modules

## Input Modules (im*)
| Module | Purpose | Config |
|--------|---------|--------|
| imuxsock | Unix socket (/dev/log) | Always loaded |
| imjournal | systemd journal | `module(load="imjournal")` |
| imudp | UDP syslog receiver | `input(type="imudp" port="514")` |
| imtcp | TCP syslog receiver | `input(type="imtcp" port="514")` |
| imptcp | High-performance TCP | `input(type="imptcp" port="514")` |
| imfile | Tail log files | `input(type="imfile" file="/var/log/app.log")` |
| imklog | Kernel log (dmesg) | `module(load="imklog")` |
| immark | Periodic mark msgs | `module(load="immark" interval="600")` |

## Output Modules (om*)
| Module | Purpose | Config |
|--------|---------|--------|
| omfile | Write to file | `action(type="omfile" file="/var/log/x.log")` |
| omfwd | Forward to remote | `action(type="omfwd" target="logserver" port="514")` |
| ommysql | MySQL output | `action(type="ommysql" server="db" db="Syslog")` |
| ompgsql | PostgreSQL output | `action(type="ompgsql" server="db" db="syslog")` |
| omelasticsearch | Elasticsearch | `action(type="omelasticsearch" server="es01")` |
| omkafka | Apache Kafka | `action(type="omkafka" topic="syslog" broker="kafka:9092")` |
| omhiredis | Redis output | `action(type="omhiredis" server="redis")` |
| omrelp | RELP (reliable) | `action(type="omrelp" target="logserver")` |

## File Input Example
```
module(load="imfile")
input(type="imfile"
    File="/var/log/nginx/access.log"
    Tag="nginx-access"
    Severity="info"
    Facility="local6"
    PersistStateInterval="200"
)
```

## Parser Modules
| Module | Purpose |
|--------|---------|
| pmrfc5424 | RFC 5424 parser |
| pmrfc3164 | Traditional BSD syslog |
| pmlastmsg | Handles "last message repeated" |
| mmjsonparse | Parse JSON in msg |
| mmnormalize | Normalize with liblognorm |
EOF
}

cmd_templates() {
    cat << 'EOF'
# RSyslog Templates

## Template Types
```bash
# String template (most common)
template(name="FileFormat" type="string"
    string="%TIMESTAMP% %HOSTNAME% %syslogtag%%msg:::sp-if-no-1st-sp%%msg:::drop-last-lf%\n"
)

# List template (structured)
template(name="JsonFormat" type="list") {
    constant(value="{\"timestamp\":\"")
    property(name="timereported" dateFormat="rfc3339")
    constant(value="\",\"host\":\"")
    property(name="hostname")
    constant(value="\",\"severity\":\"")
    property(name="syslogseverity-text")
    constant(value="\",\"program\":\"")
    property(name="programname")
    constant(value="\",\"message\":\"")
    property(name="msg" format="jsonf")
    constant(value="\"}\n")
}

# Plugin template (for databases)
template(name="SQLFormat" type="plugin" plugin="ommysql")
```

## Property Replacer
| Property | Value |
|----------|-------|
| %msg% | Message content |
| %hostname% | Source hostname |
| %fromhost-ip% | Source IP address |
| %syslogtag% | Program name + PID |
| %programname% | Program name only |
| %syslogfacility-text% | Facility as text |
| %syslogseverity-text% | Severity as text |
| %timereported% | Message timestamp |
| %timegenerated% | Reception timestamp |
| %pri% | Priority value |
| %rawmsg% | Original raw message |

## Modifiers
```bash
%msg:1:50%           # Characters 1-50
%msg:::drop-last-lf% # Remove trailing newline
%msg:::sp-if-no-1st-sp%  # Add space if none
%msg:::lowercase%    # Lowercase
%msg:::csv%          # CSV escape
%msg:::jsonf%        # JSON field escape
%msg:R,ERE,0,FIELD,--end% # Regex extraction
```

## Dynamic File Names
```bash
template(name="RemoteHost" type="string"
    string="/var/log/remote/%HOSTNAME%/%PROGRAMNAME%.log"
)

# Usage
*.* ?RemoteHost
```
EOF
}

cmd_filtering() {
    cat << 'EOF'
# RSyslog Filtering

## Traditional Selectors
```bash
# facility.severity
mail.*           /var/log/maillog      # All mail messages
*.crit           /var/log/critical     # All critical
kern.warning     /var/log/kern-warn    # Kernel warnings+
```

## Property-Based Filters
```bash
# Syntax: :property, [!]compare-operation, "value"

# Match program name
:programname, isequal, "sshd"    /var/log/sshd.log

# Match message content
:msg, contains, "error"          /var/log/errors.log

# Regex match
:msg, regex, "failed.*authentication" /var/log/auth-failures.log

# NOT match (! prefix)
:msg, !contains, "debug"        /var/log/no-debug.log

# By hostname
:hostname, isequal, "webserver1" /var/log/web1.log
```

## Compare Operations
| Operation | Meaning |
|-----------|---------|
| contains | Substring match |
| isequal | Exact match |
| startswith | Starts with |
| regex | POSIX regex |
| ereregex | Extended regex |
| isempty | Empty string |

## RainerScript Filters (Recommended)
```bash
# If-then-else
if $programname == 'sshd' then {
    action(type="omfile" file="/var/log/sshd.log")
    stop
}

# Complex conditions
if $syslogseverity <= 3 and $hostname == 'prodserver' then {
    action(type="omfile" file="/var/log/prod-critical.log")
    action(type="omfwd" target="logserver" port="514" protocol="tcp")
}

# Regex in RainerScript
if re_match($msg, 'error|fail|critical') then {
    action(type="omfile" file="/var/log/problems.log")
}
```

## Discard (Stop Processing)
```bash
# Legacy
:msg, contains, "CRON" ~

# RainerScript (preferred)
if $programname == 'CRON' then stop
```
EOF
}

cmd_remote() {
    cat << 'EOF'
# Remote Logging

## Client → Server Setup

### Client (sender)
```bash
# /etc/rsyslog.d/50-remote.conf

# UDP forwarding (simple, lossy)
*.* @logserver.example.com:514

# TCP forwarding (reliable)
*.* @@logserver.example.com:514

# RainerScript (recommended)
action(
    type="omfwd"
    target="logserver.example.com"
    port="514"
    protocol="tcp"
    queue.type="LinkedList"       # Disk-assisted queue
    queue.filename="fwd_to_logserver"
    queue.maxdiskspace="1g"
    queue.saveonshutdown="on"
    action.resumeRetryCount="-1"  # Retry forever
)
```

### Server (receiver)
```bash
# /etc/rsyslog.d/10-receive.conf

module(load="imtcp")
input(type="imtcp" port="514")

# Store by hostname
template(name="RemoteLog" type="string"
    string="/var/log/remote/%HOSTNAME%/%PROGRAMNAME%.log"
)

if $fromhost-ip != '127.0.0.1' then {
    action(type="omfile" dynaFile="RemoteLog")
    stop
}
```

## TLS Encryption
```bash
# Server
module(
    load="imtcp"
    StreamDriver.Name="gtls"
    StreamDriver.Mode="1"
    StreamDriver.AuthMode="anon"
)
input(type="imtcp" port="6514")

global(
    DefaultNetstreamDriverCAFile="/etc/pki/rsyslog/ca.pem"
    DefaultNetstreamDriverCertFile="/etc/pki/rsyslog/server-cert.pem"
    DefaultNetstreamDriverKeyFile="/etc/pki/rsyslog/server-key.pem"
)

# Client
action(
    type="omfwd"
    target="logserver"
    port="6514"
    protocol="tcp"
    StreamDriver="gtls"
    StreamDriverMode="1"
    StreamDriverAuthMode="anon"
)
```

## RELP (Reliable Event Logging Protocol)
```bash
# Server
module(load="imrelp")
input(type="imrelp" port="2514")

# Client
module(load="omrelp")
action(type="omrelp" target="logserver" port="2514")
```
EOF
}

cmd_performance() {
    cat << 'EOF'
# RSyslog Performance Tuning

## Queue Types
```bash
# Main message queue
main_queue(
    queue.type="LinkedList"     # LinkedList (default) or FixedArray
    queue.size="100000"         # Max messages in memory
    queue.dequeueBatchSize="64" # Process N messages at once
    queue.workerThreads="4"     # Worker threads
)
```

| Queue Type | Use Case |
|-----------|---------|
| Direct | No queue, synchronous (slow but safe) |
| FixedArray | Fast, fixed size, memory only |
| LinkedList | Dynamic size, good for spikes |
| Disk | Overflow to disk, survives restart |

## Disk-Assisted Queue
```bash
action(
    type="omfwd"
    target="logserver"
    port="514"
    protocol="tcp"
    queue.type="LinkedList"
    queue.filename="fwd_logserver"
    queue.maxDiskSpace="2g"
    queue.saveOnShutdown="on"
    queue.highWatermark="50000"
    queue.lowWatermark="10000"
    queue.discardMark="90000"
    queue.discardSeverity="5"   # Discard info+ when full
)
```

## Rate Limiting
```bash
# Limit messages per second from any source
module(load="imuxsock"
    SysSock.RateLimit.Interval="5"
    SysSock.RateLimit.Burst="200"
)

# Per-action rate limiting
action(type="omfile" file="/var/log/app.log"
    action.execOnlyOnceEveryInterval="60"
)
```

## High-Performance Input
```bash
# Use imptcp instead of imtcp for high volume
module(load="imptcp" threads="4")
input(type="imptcp" port="514")
```

## impstats — Performance Monitoring
```bash
module(load="impstats"
    interval="60"
    severity="7"
    log.file="/var/log/rsyslog-stats.log"
    log.syslog="off"
)
```

Stats output:
```
action 0: processed=15234 failed=0 suspended=0
imtcp: submitted=8921 connections=3
main Q: size=12 enqueued=15234 maxqsize=145
```

## Benchmarks
- Single-threaded file output: ~200K msg/sec
- Multi-threaded (4 workers): ~800K msg/sec
- With TLS: ~100K msg/sec
- To Elasticsearch: ~50K msg/sec
EOF
}

cmd_troubleshoot() {
    cat << 'EOF'
# RSyslog Troubleshooting

## Validate Config
```bash
# Check config syntax
rsyslogd -N1

# Output: rsyslogd: version X, config validation run...
# Errors will show file:line
```

## Debug Mode
```bash
# Run in foreground with debug
rsyslogd -dn

# Or set debug level in config
global(debug.onShutdown="on")

# Debug specific module
module(load="imtcp" debug="on")
```

## Test with logger
```bash
# Send test message
logger "Test message from $(hostname)"
logger -p local0.info "Test local0"
logger -t myapp "Test from myapp"

# Verify it arrived
tail /var/log/messages
```

## Common Problems

### Messages not arriving
```bash
# Check rsyslog is running
systemctl status rsyslog

# Check if port is open
ss -tlnp | grep 514

# Check firewall
firewall-cmd --list-ports
iptables -L -n | grep 514

# Test connectivity
nc -zv logserver 514
```

### High CPU Usage
```bash
# Check impstats for bottleneck
grep "action.*suspended" /var/log/rsyslog-stats.log

# Common cause: slow output (disk full, DB down)
# Fix: add queue to action
```

### Messages getting lost
```bash
# Check queue overflow
grep "queue full" /var/log/messages

# Fix: increase queue size or add disk assist
main_queue(queue.size="500000")
```

### Duplicate Messages
```bash
# Likely cause: multiple rules matching
# Fix: use 'stop' after handling
if $programname == 'myapp' then {
    action(type="omfile" file="/var/log/myapp.log")
    stop   # Don't process this message further
}
```

## Log Levels for Debug
```bash
global(debug.logFile="/var/log/rsyslog-debug.log")
```
EOF
}

case "${1:-help}" in
    intro)        cmd_intro ;;
    config)       cmd_config ;;
    modules)      cmd_modules ;;
    templates)    cmd_templates ;;
    filtering)    cmd_filtering ;;
    remote)       cmd_remote ;;
    performance)  cmd_performance ;;
    troubleshoot) cmd_troubleshoot ;;
    help|-h)      show_help ;;
    version|-v)   echo "rsyslog v$VERSION" ;;
    *)            echo "Unknown: $1"; show_help ;;
esac
