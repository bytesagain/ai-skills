#!/usr/bin/env bash
# syslog — Syslog protocol and daemon reference.
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

show_help() {
    cat << 'HELPEOF'
syslog — Syslog Protocol & Daemon Reference

Usage: syslog <command>

Commands:
  intro           RFC 5424, facility/severity model, UDP 514
  config          /etc/syslog.conf and /etc/rsyslog.conf configuration
  facilities      Facility codes: kern, user, mail, daemon, auth, local0-7
  severity        Severity levels: emerg through debug (0-7)
  remote          Remote logging: TCP vs UDP, TLS transport
  rotation        Logrotate integration, compression, retention
  troubleshoot    Testing with logger, tcpdump on port 514
  security        Log tampering prevention, immutable and centralized logs
  help            Show this help
  version         Show version

Powered by BytesAgain | bytesagain.com
HELPEOF
}

cmd_intro() {
    cat << 'EOF'
# Syslog — Protocol Overview

## History & Standards
Syslog was originally developed by Eric Allman as part of Sendmail in the 1980s.
It became the de facto Unix logging standard long before formal specification.

  RFC 3164 (2001)  — "BSD Syslog Protocol" — documented existing practice
  RFC 5424 (2009)  — "The Syslog Protocol" — modern structured format
  RFC 5425 (2009)  — TLS Transport Mapping for Syslog
  RFC 5426 (2009)  — UDP Transport Mapping for Syslog

## RFC 5424 Message Format
  <PRI>VERSION TIMESTAMP HOSTNAME APP-NAME PROCID MSGID STRUCTURED-DATA MSG

  Example:
  <165>1 2024-03-15T09:30:00.003Z server1 myapp 1234 ID47 [exampleSDID@32473 iut="3"] Login failed

  PRI = facility × 8 + severity
  <165> = facility 20 (local4) × 8 + severity 5 (notice) = 165

## Default Transport
  - UDP port 514 (original, no delivery guarantee)
  - TCP port 514 or 6514 (reliable delivery)
  - TLS over TCP port 6514 (encrypted + reliable)

## Core Architecture
  ┌─────────────┐    ┌────────────────┐    ┌──────────────┐
  │ Application  │───▶│  Syslog Daemon  │───▶│  Log Files   │
  │  (logger)    │    │ (syslogd/rsyslog│    │ /var/log/*   │
  └─────────────┘    │  /syslog-ng)    │    └──────────────┘
                     └────────────────┘           │
                            │                     ▼
                            │              ┌──────────────┐
                            └─────────────▶│ Remote Server│
                                           └──────────────┘

## Common Implementations
  - syslogd       — Traditional BSD syslog daemon
  - rsyslog       — Rocket-fast system for log processing (default on RHEL/Debian)
  - syslog-ng     — Next-generation syslog daemon (advanced filtering)
  - systemd-journald — Binary journal (often forwards to rsyslog)
EOF
}

cmd_config() {
    cat << 'EOF'
# Syslog — Configuration

## Traditional /etc/syslog.conf (BSD syslogd)
Format: selector <TAB> action
Selector = facility.severity

  # Log all kernel messages to console
  kern.*                          /dev/console

  # Log mail messages at info and above
  mail.info                       /var/log/maillog

  # Log auth messages to a separate file
  auth,authpriv.*                 /var/log/auth.log

  # Everything except mail/auth at info+
  *.info;mail.none;authpriv.none  /var/log/messages

  # Emergency messages to all logged-in users
  *.emerg                         *

  # Send to remote host
  *.*                             @logserver.example.com

## Selector Syntax
  facility.severity     — Match severity and above
  facility.=severity    — Match exact severity only
  facility.!severity    — Match below this severity
  facility.none         — Exclude this facility
  *.*                   — Match everything

## Action Types
  /path/to/file         — Write to file
  -/path/to/file        — Write to file (no sync after each line, faster)
  @hostname             — Send via UDP to remote host
  @@hostname            — Send via TCP to remote host (rsyslog extension)
  |/path/to/pipe        — Write to named pipe (FIFO)
  *                     — Send to all logged-in users (wall)
  username              — Send to specific user's terminal

## /etc/rsyslog.conf (modern systems)
  # Load modules
  module(load="imuxsock")              # Local socket input
  module(load="imklog")                # Kernel log input

  # Legacy format (still works)
  auth,authpriv.*     /var/log/auth.log

  # RainerScript format
  if $syslogfacility-text == 'auth' then {
      action(type="omfile" file="/var/log/auth.log")
  }

## After Changes
  # Traditional syslogd
  kill -HUP $(cat /var/run/syslog.pid)

  # rsyslog
  systemctl restart rsyslog

  # Validate rsyslog config before restart
  rsyslogd -N1
EOF
}

cmd_facilities() {
    cat << 'EOF'
# Syslog — Facility Codes

Facilities categorize the source/type of the log message.
Defined in RFC 5424 §6.2.1.

  Code  Keyword      Description
  ────  ───────      ───────────
   0    kern         Kernel messages (generated internally, not via syslog())
   1    user         User-level messages (default when no facility specified)
   2    mail         Mail subsystem (sendmail, postfix, dovecot)
   3    daemon       System daemons (sshd, cron when not using facility 9)
   4    auth         Authentication/authorization (login, su, getty, PAM)
   5    syslog       Messages generated by syslogd itself
   6    lpr          Line printer subsystem (cupsd)
   7    news         Network news subsystem (NNTP, INN)
   8    uucp         UUCP subsystem (mostly historical)
   9    cron         Cron daemon (crond, atd)
  10    authpriv     Private authentication messages (may contain sensitive data)
  11    ftp          FTP daemon (vsftpd, proftpd)
  12    ntp          NTP subsystem (RFC 5424)
  13    security     Log audit (RFC 5424)
  14    console      Log alert (RFC 5424)
  15    solaris-cron Solaris cron (RFC 5424)
  16    local0       Locally defined — often used for firewalls, load balancers
  17    local1       Locally defined — custom applications
  18    local2       Locally defined — custom applications
  19    local3       Locally defined — custom applications
  20    local4       Locally defined — custom applications
  21    local5       Locally defined — custom applications
  22    local6       Locally defined — custom applications
  23    local7       Locally defined — often used for boot messages

## PRI Calculation
  PRI = (facility × 8) + severity

  Example: auth.err = (4 × 8) + 3 = 35  →  <35>
  Example: local0.info = (16 × 8) + 6 = 134  →  <134>

## Common Conventions
  - local0   → Network devices (Cisco, Juniper routers/switches)
  - local1   → Load balancers (HAProxy, F5)
  - local2   → Web servers (custom app logs)
  - local3   → Database servers
  - local4   → Application tier
  - local5   → Middleware
  - local6   → Security appliances
  - local7   → Boot/startup messages

## Usage in C
  #include <syslog.h>
  openlog("myapp", LOG_PID | LOG_CONS, LOG_LOCAL3);
  syslog(LOG_ERR, "Database connection failed: %s", strerror(errno));
  closelog();
EOF
}

cmd_severity() {
    cat << 'EOF'
# Syslog — Severity Levels

Severity levels indicate the urgency/impact of the message.
Defined in RFC 5424 §6.2.1. Lower number = higher severity.

  Code  Keyword    Description                     Action Expected
  ────  ───────    ───────────                     ───────────────
   0    emerg      System is unusable               Immediate intervention required
   1    alert      Action must be taken immediately  Wake someone up at 3 AM
   2    crit       Critical conditions               Hardware/core service failure
   3    err        Error conditions                  Application errors, failures
   4    warning    Warning conditions                Something unusual, may degrade
   5    notice     Normal but significant            State changes, important events
   6    info       Informational messages            Regular operational messages
   7    debug      Debug-level messages              Verbose diagnostic output

## Selector Matching Rules
  mail.err        — Match err AND above (err, crit, alert, emerg)
  mail.=err       — Match ONLY err
  mail.!err       — Match below err (warning, notice, info, debug)
  mail.!=err      — Match everything EXCEPT err
  mail.*          — Match ALL severity levels
  mail.none       — Match NO messages from mail

## Real-World Examples

  # Severity 0 - emerg: Kernel panic, filesystem corruption
  kernel: Kernel panic - not syncing: VFS: Unable to mount root fs

  # Severity 1 - alert: RAID array degraded
  md/raid1:md0: Disk failure on sdb1, disabling device.

  # Severity 2 - crit: Out of memory killer activated
  kernel: Out of memory: Kill process 1234 (mysqld)

  # Severity 3 - err: Service failed to start
  sshd[5432]: error: Bind to port 22 on 0.0.0.0 failed: Address already in use

  # Severity 4 - warning: Disk space getting low
  systemd[1]: /etc/systemd/system/myapp.service:12: Unknown lvalue 'ExecRestart'

  # Severity 5 - notice: Interface state change
  NetworkManager[876]: <notice> eth0: link connected

  # Severity 6 - info: Normal operation
  sshd[5432]: Accepted publickey for admin from 10.0.1.5 port 54321

  # Severity 7 - debug: Detailed diagnostic
  sshd[5432]: debug1: Entering interactive session for SSH2.

## Recommended Logging Strategy
  - Production:  Log info and above (*.info)
  - Staging:     Log notice and above with debug for specific apps
  - Debug:       Log everything (*.debug) — WARNING: high volume
  - Security:    Always log auth.* at all levels
  - Alerting:    Trigger pages on emerg/alert/crit only
EOF
}

cmd_remote() {
    cat << 'EOF'
# Syslog — Remote Logging

## UDP Transport (Traditional)
  - Port 514 (default)
  - No delivery guarantee (fire-and-forget)
  - No congestion control
  - Maximum message size: 480 bytes (RFC 3164) or 2048 (RFC 5426)

  # Client: send to remote (syslog.conf)
  *.*    @logserver.example.com          # UDP port 514
  *.*    @logserver.example.com:1514     # UDP custom port

  # Server: listen on UDP 514 (rsyslog)
  module(load="imudp")
  input(type="imudp" port="514")

## TCP Transport (Reliable)
  - Guarantees delivery (TCP retransmission)
  - Connection-oriented — detects server unavailability
  - Supports queuing on connection loss

  # Client: send via TCP (rsyslog @@)
  *.*    @@logserver.example.com         # TCP port 514
  *.*    @@logserver.example.com:6514    # TCP custom port

  # Server: listen on TCP
  module(load="imtcp")
  input(type="imtcp" port="514")

## TLS Encrypted Transport (RFC 5425)
  - Encrypts log data in transit
  - Mutual authentication via X.509 certificates
  - Port 6514 (IANA assigned for syslog over TLS)

  # rsyslog TLS client configuration
  global(
      DefaultNetstreamDriver="gtls"
      DefaultNetstreamDriverCAFile="/etc/pki/tls/certs/ca.pem"
      DefaultNetstreamDriverCertFile="/etc/pki/tls/certs/client-cert.pem"
      DefaultNetstreamDriverKeyFile="/etc/pki/tls/private/client-key.pem"
  )

  action(
      type="omfwd"
      target="logserver.example.com"
      port="6514"
      protocol="tcp"
      StreamDriver="gtls"
      StreamDriverMode="1"           # 1 = TLS required
      StreamDriverAuthMode="x509/name"
      StreamDriverPermittedPeers="logserver.example.com"
      queue.type="LinkedList"        # Disk-assisted queue for reliability
      queue.filename="fwd_tls"
      queue.maxdiskspace="1g"
      queue.saveonshutdown="on"
      action.resumeRetryCount="-1"   # Infinite retries
  )

  # rsyslog TLS server configuration
  module(load="imtcp"
      StreamDriver.Name="gtls"
      StreamDriver.Mode="1"
      StreamDriver.AuthMode="x509/name"
      PermittedPeer=["client1.example.com","client2.example.com"]
  )
  input(type="imtcp" port="6514")

## UDP vs TCP vs TLS Decision Matrix
  ┌──────────┬──────────┬──────────┬──────────┐
  │ Factor   │   UDP    │   TCP    │   TLS    │
  ├──────────┼──────────┼──────────┼──────────┤
  │ Reliable │   No     │   Yes    │   Yes    │
  │ Ordered  │   No     │   Yes    │   Yes    │
  │ Encrypted│   No     │   No     │   Yes    │
  │ Speed    │ Fastest  │  Fast    │ Slower   │
  │ CPU cost │ Minimal  │  Low     │ Moderate │
  │ Firewall │ Stateless│ Stateful │ Stateful │
  └──────────┴──────────┴──────────┴──────────┘
EOF
}

cmd_rotation() {
    cat << 'EOF'
# Syslog — Log Rotation

## Logrotate Integration
Logrotate is the standard tool for managing log file rotation on Linux.
Config: /etc/logrotate.conf (global) and /etc/logrotate.d/* (per-service)

## /etc/logrotate.d/syslog (RHEL/CentOS)
  /var/log/messages
  /var/log/secure
  /var/log/maillog
  /var/log/spooler
  /var/log/boot.log
  /var/log/cron
  {
      missingok
      sharedscripts
      postrotate
          /usr/bin/systemctl kill -s HUP rsyslog.service 2>/dev/null || true
      endscript
  }

## /etc/logrotate.d/rsyslog (Debian/Ubuntu)
  /var/log/syslog
  /var/log/mail.info
  /var/log/mail.warn
  /var/log/mail.err
  /var/log/mail.log
  /var/log/daemon.log
  /var/log/kern.log
  /var/log/auth.log
  /var/log/user.log
  /var/log/debug
  /var/log/messages
  {
      rotate 4
      weekly
      missingok
      notifempty
      compress
      delaycompress
      sharedscripts
      postrotate
          /usr/lib/rsyslog/rsyslog-rotate
      endscript
  }

## Key Directives
  rotate N          — Keep N rotated files (rotate 7 = 7 old files)
  daily/weekly/monthly — Rotation frequency
  compress          — gzip old logs (.gz)
  delaycompress     — Don't compress the most recent rotated file
                      (allows processes still writing to it)
  copytruncate      — Truncate original file after copying
                      (use when app can't reopen files)
  create 0640 root adm — Set permissions on new log file
  maxsize 100M      — Rotate when file exceeds 100MB regardless of schedule
  minsize 1M        — Don't rotate unless file is at least 1MB
  dateext           — Use date in rotated filename (messages-20240315.gz)
  dateformat -%Y%m%d — Date format for dateext
  olddir /var/log/archive — Move rotated logs to archive directory

## The HUP Signal
After rotation, syslogd must be told to reopen its log files:
  - syslogd/rsyslog: SIGHUP reopens all files
  - If you use copytruncate, HUP is not needed (but wastes disk briefly)
  - postrotate script sends HUP only once (sharedscripts)

## Testing
  # Dry run — see what would happen
  logrotate -d /etc/logrotate.d/syslog

  # Force rotation now (regardless of schedule)
  logrotate -f /etc/logrotate.d/syslog

  # Verbose output
  logrotate -v /etc/logrotate.d/syslog

## Retention Policy Example (90-day compliance)
  /var/log/auth.log {
      daily
      rotate 90
      compress
      delaycompress
      missingok
      notifempty
      create 0640 root adm
      postrotate
          systemctl kill -s HUP rsyslog.service
      endscript
  }
EOF
}

cmd_troubleshoot() {
    cat << 'EOF'
# Syslog — Troubleshooting

## Testing with logger(1)
The logger command sends test messages to syslog from the command line.

  # Basic test message (goes to user facility, notice severity)
  logger "Test message from command line"

  # Specify facility and severity
  logger -p local0.err "Test error on local0"
  logger -p auth.warning "Test auth warning"
  logger -p mail.info "Test mail info message"

  # Specify a tag (appears as program name)
  logger -t myapp "Application started successfully"

  # Include PID
  logger -t myapp -i "Process handling request"

  # Send to specific socket or remote host
  logger -n logserver.example.com -P 514 "Remote test"
  logger --tcp -n logserver.example.com -P 514 "TCP test"

  # Send structured data (RFC 5424)
  logger --rfc5424 -t myapp "Structured test message"

## Checking Syslog Daemon Status
  # Is rsyslog running?
  systemctl status rsyslog
  ps aux | grep rsyslog

  # Check for config errors
  rsyslogd -N1                    # Validate configuration
  rsyslogd -N1 -f /etc/rsyslog.conf  # Validate specific file

  # Check what syslog is listening on
  ss -ulnp | grep 514            # UDP listeners
  ss -tlnp | grep 514            # TCP listeners

## Network Debugging with tcpdump
  # Capture syslog traffic on UDP 514
  tcpdump -i eth0 -nn port 514

  # Capture with message content (ASCII)
  tcpdump -i eth0 -nn -A port 514

  # Capture syslog traffic to/from specific host
  tcpdump -i eth0 -nn host 10.0.1.50 and port 514

  # Save to file for later analysis
  tcpdump -i eth0 -nn -w /tmp/syslog.pcap port 514

  # Read captured file
  tcpdump -nn -A -r /tmp/syslog.pcap

## Common Issues

  Problem: Messages not appearing in log file
  ──────────────────────────────────────────────
  1. Check selector in config: facility.severity must match
  2. Check file permissions: syslog user must be able to write
  3. Check if file exists: syslog won't create directories
  4. Check SELinux context: ls -Z /var/log/messages
  5. Restart after config change: systemctl restart rsyslog

  Problem: Remote logs not arriving
  ──────────────────────────────────
  1. Firewall: firewall-cmd --add-port=514/udp --permanent
  2. Server not listening: check imudp/imtcp module is loaded
  3. DNS resolution: try IP address instead of hostname
  4. Verify with tcpdump on the server side

  Problem: Log file growing too fast
  ────────────────────────────────────
  1. Check for debug-level logging: *.debug fills disks fast
  2. Rate-limit in rsyslog: SystemLogRateLimitInterval/Burst
  3. Filter out noisy sources
  4. Ensure logrotate is actually running: cat /var/lib/logrotate/status
EOF
}

cmd_security() {
    cat << 'EOF'
# Syslog — Security

## Threat: Log Tampering
Attackers who gain access often modify or delete logs to cover their tracks.
Protecting log integrity is critical for forensics and compliance.

## Immutable Log Files (chattr)
  # Make log file append-only (even root can't delete/modify existing lines)
  chattr +a /var/log/auth.log
  chattr +a /var/log/messages

  # Verify attribute
  lsattr /var/log/auth.log
  # -----a---------- /var/log/auth.log

  # Note: logrotate needs to remove +a before rotating
  # Add to logrotate prerotate:
  prerotate
      chattr -a /var/log/auth.log
  endscript
  postrotate
      systemctl kill -s HUP rsyslog.service
      chattr +a /var/log/auth.log
  endscript

## Centralized Logging (Defense in Depth)
  - Send logs to a hardened remote server attackers can't reach
  - Use TLS to prevent interception (RFC 5425)
  - Even if a host is compromised, logs are already off-box

  # Send everything to central server via TLS
  *.* action(type="omfwd"
      target="siem.example.com"
      port="6514"
      protocol="tcp"
      StreamDriver="gtls"
      StreamDriverMode="1"
      StreamDriverAuthMode="x509/name"
  )

## File Permissions
  # Restrict log file access
  chmod 640 /var/log/auth.log
  chown root:adm /var/log/auth.log

  # Recommended permissions by log type:
  #   auth.log     0640 root:adm    — Contains authentication details
  #   kern.log     0640 root:adm    — Kernel messages
  #   syslog       0640 root:adm    — General system log
  #   messages     0644 root:root   — Less sensitive

## Log Integrity Verification
  # Generate hashes of log files for tamper detection
  sha256sum /var/log/auth.log > /var/log/.auth.log.sha256

  # Use AIDE (Advanced Intrusion Detection Environment)
  # /etc/aide.conf
  /var/log/auth.log    p+i+n+u+g+s+sha256

## Auditd Integration
  # Monitor who reads/modifies log files
  -w /var/log/auth.log -p wa -k log_tampering
  -w /var/log/messages -p wa -k log_tampering
  -w /etc/rsyslog.conf -p wa -k syslog_config_change

## SELinux Contexts
  # Ensure proper SELinux labels on log files
  ls -Z /var/log/messages
  # system_u:object_r:var_log_t:s0

  # Restore context if needed
  restorecon -Rv /var/log/

## Compliance Considerations
  - PCI DSS 10.5: Secure audit trails so they cannot be altered
  - HIPAA §164.312(b): Audit controls — record and examine activity
  - SOX: Retain audit logs for 7 years minimum
  - GDPR: Log access to personal data; protect log data itself

## Recommended Architecture
  ┌──────────┐    TLS    ┌──────────────┐    ┌─────────┐
  │  Servers  │────────▶│ Log Collector │───▶│  SIEM   │
  │ (rsyslog) │         │ (rsyslog/     │    │(Splunk/ │
  └──────────┘         │  Logstash)    │    │ ELK/    │
  ┌──────────┐  TLS    │              │    │ Graylog)│
  │  Network  │────────▶│              │    └─────────┘
  │  Devices  │         └──────────────┘         │
  └──────────┘               │                   ▼
                             ▼            ┌─────────────┐
                      ┌──────────────┐    │ Long-term    │
                      │ Local backup │    │ Archive (S3) │
                      │ (immutable)  │    └─────────────┘
                      └──────────────┘
EOF
}

case "${1:-help}" in
    intro)        cmd_intro ;;
    config)       cmd_config ;;
    facilities)   cmd_facilities ;;
    severity)     cmd_severity ;;
    remote)       cmd_remote ;;
    rotation)     cmd_rotation ;;
    troubleshoot) cmd_troubleshoot ;;
    security)     cmd_security ;;
    version)      echo "syslog v$VERSION" ;;
    help|*)       show_help ;;
esac
