---
name: "syslog"
version: "1.0.0"
description: "Syslog protocol and daemon reference. RFC 5424, facility/severity codes, remote logging over TCP/UDP/TLS, logrotate integration, logger testing, and log security hardening."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [syslog, logging, linux, monitoring, rfc5424, sysops]
category: "sysops"
---

# Syslog

Syslog protocol and daemon reference. RFC 5424, facilities, severity levels, remote logging.

## Commands

| Command | Description |
|---------|-------------|
| `intro` | RFC 5424, facility/severity, UDP 514 |
| `config` | syslog.conf selectors and actions |
| `facilities` | kern/user/mail/daemon/auth/local0-7 |
| `severity` | emerg/alert/crit/err/warning/notice/info/debug |
| `remote` | Remote logging, TCP vs UDP, TLS |
| `rotation` | logrotate integration, compression, retention |
| `troubleshoot` | logger command, tcpdump on 514 |
| `security` | Log tampering prevention, immutable logs |
