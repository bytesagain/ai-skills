#!/bin/bash
# Alpine Linux - Minimal Container & Security OS Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              ALPINE LINUX REFERENCE                         ║
║          Minimal, Security-Oriented Linux Distribution      ║
╚══════════════════════════════════════════════════════════════╝

Alpine Linux is a lightweight Linux distribution built on musl libc
and BusyBox. Famous for tiny Docker images (5MB base vs 72MB Ubuntu).

WHY ALPINE:
  Size        5MB base image, ~50MB installed system
  Security    musl libc (smaller attack surface), PaX/grsecurity
  Simplicity  BusyBox userland, OpenRC init, apk package manager
  Speed       Fast boot, fast package install
  Docker      #1 choice for minimal container images

ALPINE vs OTHERS:
  ┌─────────────┬──────────┬──────────┬──────────┬──────────┐
  │ Feature     │ Alpine   │ Ubuntu   │ Debian   │ Distroless│
  ├─────────────┼──────────┼──────────┼──────────┼──────────┤
  │ Base image  │ 5MB      │ 72MB     │ 48MB     │ ~20MB    │
  │ libc        │ musl     │ glibc    │ glibc    │ glibc    │
  │ Shell       │ ash/bash │ bash     │ bash     │ None     │
  │ Pkg manager │ apk      │ apt      │ apt      │ None     │
  │ Init system │ OpenRC   │ systemd  │ systemd  │ N/A      │
  │ Debug tools │ Yes      │ Yes      │ Yes      │ No       │
  │ CVE surface │ Minimal  │ Large    │ Medium   │ Minimal  │
  └─────────────┴──────────┴──────────┴──────────┴──────────┘

MUSL vs GLIBC:
  musl libc is Alpine's C library. It's smaller and simpler than glibc
  but has compatibility implications:

  Works fine:    Go, Rust, Python (pure), Node.js, most tools
  May need work: Python C extensions, pre-compiled binaries, Java (use Eclipse Temurin)
  Won't work:    Binaries compiled against glibc (use compatibility layer)

  Compatibility options:
  - Install gcompat: apk add gcompat
  - Use libc6-compat: apk add libc6-compat
  - Compile from source against musl
  - Use multi-stage build with glibc stage
EOF
}

cmd_apk() {
cat << 'EOF'
APK PACKAGE MANAGER
=====================

BASIC OPERATIONS:
  apk update                 Update package index
  apk upgrade                Upgrade all packages
  apk add <pkg>              Install package
  apk del <pkg>              Remove package
  apk search <term>          Search packages
  apk info <pkg>             Package info
  apk info -L <pkg>          List package files

INSTALL PATTERNS:
  # Install specific version
  apk add nginx=1.24.0-r5

  # Install from edge (testing) repo
  apk add --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing <pkg>

  # Install without cache (Docker best practice)
  apk add --no-cache curl wget

  # Virtual package (group for easy removal)
  apk add --virtual .build-deps gcc musl-dev make
  # ... build stuff ...
  apk del .build-deps

  # Pin package version range
  apk add "nginx>1.24" "nginx<1.26"

REPOSITORY CONFIGURATION:
  /etc/apk/repositories:
    https://dl-cdn.alpinelinux.org/alpine/v3.19/main
    https://dl-cdn.alpinelinux.org/alpine/v3.19/community
    # Uncomment for edge packages:
    # https://dl-cdn.alpinelinux.org/alpine/edge/main
    # https://dl-cdn.alpinelinux.org/alpine/edge/community
    # https://dl-cdn.alpinelinux.org/alpine/edge/testing

COMMON PACKAGES:
  Shells:      bash, zsh, fish
  Editors:     vim, nano, neovim
  Network:     curl, wget, bind-tools, iptables, tcpdump
  System:      htop, procps, coreutils, shadow, sudo
  Build:       gcc, g++, make, musl-dev, linux-headers
  Python:      python3, py3-pip, python3-dev
  Node.js:     nodejs, npm
  Go:          go
  TLS:         openssl, ca-certificates
  Containers:  docker, docker-compose, podman

APK vs APT CHEATSHEET:
  ┌────────────────────┬──────────────────────┐
  │ apt (Debian/Ubuntu)│ apk (Alpine)         │
  ├────────────────────┼──────────────────────┤
  │ apt update         │ apk update           │
  │ apt upgrade        │ apk upgrade          │
  │ apt install pkg    │ apk add pkg          │
  │ apt remove pkg     │ apk del pkg          │
  │ apt search term    │ apk search term      │
  │ apt show pkg       │ apk info pkg         │
  │ dpkg -L pkg        │ apk info -L pkg      │
  │ apt autoremove     │ (not needed)         │
  │ apt-cache policy   │ apk policy           │
  └────────────────────┴──────────────────────┘
EOF
}

cmd_docker() {
cat << 'EOF'
ALPINE IN DOCKER
==================

BASIC DOCKERFILE:
  FROM alpine:3.19
  RUN apk add --no-cache curl
  CMD ["sh"]

PYTHON APP:
  FROM python:3.12-alpine
  WORKDIR /app
  RUN apk add --no-cache gcc musl-dev  # For C extensions
  COPY requirements.txt .
  RUN pip install --no-cache-dir -r requirements.txt
  RUN apk del gcc musl-dev             # Remove build deps
  COPY . .
  CMD ["python", "app.py"]

NODE.JS APP:
  FROM node:20-alpine
  WORKDIR /app
  COPY package*.json ./
  RUN npm ci --omit=dev
  COPY . .
  EXPOSE 3000
  CMD ["node", "server.js"]

GO APP (Multi-stage):
  # Build stage
  FROM golang:1.22-alpine AS builder
  WORKDIR /app
  COPY go.* ./
  RUN go mod download
  COPY . .
  RUN CGO_ENABLED=0 go build -o /app/server

  # Runtime stage
  FROM alpine:3.19
  RUN apk add --no-cache ca-certificates
  COPY --from=builder /app/server /server
  CMD ["/server"]

DOCKER BEST PRACTICES:
  1. Use --no-cache: apk add --no-cache pkg
     Avoids storing package index in image layer.

  2. Use virtual packages for build deps:
     RUN apk add --virtual .build-deps gcc musl-dev \
       && pip install -r requirements.txt \
       && apk del .build-deps

  3. Combine RUN commands:
     RUN apk add --no-cache curl \
       && curl -fsSL https://example.com/script.sh | sh \
       && rm -rf /tmp/*

  4. Use specific Alpine version tag:
     FROM alpine:3.19    # Not just alpine:latest

  5. Add non-root user:
     RUN adduser -D -s /bin/sh appuser
     USER appuser

  6. Install ca-certificates for HTTPS:
     RUN apk add --no-cache ca-certificates

IMAGE SIZE COMPARISON:
  alpine:3.19           ~7MB
  python:3.12-alpine    ~52MB
  node:20-alpine        ~126MB
  python:3.12-slim      ~150MB
  python:3.12           ~1.01GB
  node:20               ~1.1GB
  ubuntu:22.04          ~72MB
EOF
}

cmd_system() {
cat << 'EOF'
SYSTEM ADMINISTRATION
=======================

OPENRC (Init System):
  rc-service <svc> start|stop|restart|status
  rc-update add <svc> default     # Enable at boot
  rc-update del <svc> default     # Disable at boot
  rc-status                       # Show service status

  Common services:
    crond       Cron daemon
    sshd        SSH server
    networking  Network configuration
    ntpd        Time synchronization
    iptables    Firewall

NETWORKING:
  /etc/network/interfaces:
    auto eth0
    iface eth0 inet dhcp

    auto eth0
    iface eth0 inet static
      address 192.168.1.100
      netmask 255.255.255.0
      gateway 192.168.1.1

  Restart: rc-service networking restart

  DNS: /etc/resolv.conf
    nameserver 1.1.1.1
    nameserver 8.8.8.8

USER MANAGEMENT:
  adduser username                Add user (interactive)
  adduser -D username             Add user (no password prompt)
  adduser -D -s /bin/bash username  Add user with bash shell
  addgroup groupname              Add group
  addgroup username groupname     Add user to group
  deluser username                Remove user

  Note: Alpine uses BusyBox adduser, not useradd.
  For useradd compatibility: apk add shadow

CRON:
  # Start crond
  rc-service crond start
  rc-update add crond default

  # Edit crontab
  crontab -e

  # Cron log: /var/log/cron (may need syslog)

DISK & FILESYSTEM:
  apk add e2fsprogs           # ext4 tools
  apk add btrfs-progs         # btrfs tools
  apk add lvm2                # LVM tools

  setup-disk                  # Interactive disk setup
  setup-alpine                # Full system setup wizard

FIREWALL (iptables):
  apk add iptables ip6tables
  rc-service iptables save    # Save rules
  rc-update add iptables      # Enable at boot

  # Or use awall (Alpine Wall):
  apk add awall
  # Simpler firewall configuration
EOF
}

cmd_security() {
cat << 'EOF'
ALPINE SECURITY
=================

SECURITY FEATURES:
  - musl libc: smaller codebase = fewer vulnerabilities
  - PIE (Position Independent Executables) by default
  - Stack protector enabled by default
  - No SUID binaries in base install
  - Minimal default install (less attack surface)

HARDENING CHECKLIST:

  1. Keep updated:
     apk update && apk upgrade

  2. Remove unnecessary packages:
     apk info | sort    # Review installed packages
     apk del <pkg>      # Remove what you don't need

  3. Disable root login:
     # /etc/ssh/sshd_config
     PermitRootLogin no

  4. Configure firewall:
     apk add iptables
     iptables -A INPUT -i lo -j ACCEPT
     iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
     iptables -A INPUT -p tcp --dport 22 -j ACCEPT
     iptables -A INPUT -j DROP
     rc-service iptables save

  5. Enable audit logging:
     apk add audit
     rc-service auditd start

  6. File integrity:
     apk add aide
     aide --init
     aide --check

DOCKER SECURITY:
  # Scan Alpine image for CVEs
  docker scout cves alpine:3.19
  trivy image alpine:3.19

  # Non-root container
  FROM alpine:3.19
  RUN adduser -D -s /sbin/nologin appuser
  USER appuser

  # Read-only filesystem
  docker run --read-only alpine:3.19

  # Drop all capabilities
  docker run --cap-drop=ALL alpine:3.19

CVE TRACKING:
  Alpine security advisories: https://security.alpinelinux.org/
  RSS feed available for automated monitoring.

  Patch workflow:
  1. apk update
  2. apk upgrade --available
  3. Rebuild Docker images with --no-cache
  4. Deploy updated images
EOF
}

cmd_troubleshoot() {
cat << 'EOF'
TROUBLESHOOTING ALPINE
========================

1. "NOT FOUND" WHEN RUNNING BINARIES
   Error: /app/binary: not found (but file exists!)
   Cause: Binary linked against glibc, Alpine uses musl.

   Fix options:
   a) Install glibc compatibility:
      apk add gcompat
      # or
      apk add libc6-compat

   b) Compile from source against musl

   c) Use Alpine-native package if available

   d) Switch to -slim image instead of -alpine

2. PYTHON C EXTENSIONS FAIL
   Error: gcc: command not found / musl-dev: not found

   Fix:
   apk add --virtual .build-deps \
     gcc musl-dev python3-dev libffi-dev openssl-dev
   pip install cryptography  # Now it compiles
   apk del .build-deps

   Common Python deps needed:
   - cryptography → openssl-dev libffi-dev
   - Pillow → jpeg-dev zlib-dev
   - psycopg2 → postgresql-dev
   - lxml → libxml2-dev libxslt-dev
   - numpy → gfortran openblas-dev

3. DNS RESOLUTION ISSUES
   musl's DNS resolver differs from glibc:
   - No /etc/nsswitch.conf support
   - Different timeout behavior
   - May not respect search domains the same way

   Fix: Ensure /etc/resolv.conf has correct nameservers
   For Docker: usually inherited from host

4. LOCALE ISSUES
   Alpine doesn't have full locale support by default.
   Error: locale.Error: unsupported locale setting

   Fix:
   apk add musl-locales musl-locales-lang
   export LANG=en_US.UTF-8
   export LC_ALL=en_US.UTF-8

5. BASH NOT FOUND
   Alpine uses ash (BusyBox) by default, not bash.

   Fix: apk add bash
   Or: rewrite scripts to be POSIX sh compatible

6. TIMEZONE
   Alpine ships with UTC only.
   apk add tzdata
   cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
   echo "Asia/Shanghai" > /etc/timezone

   Docker:
   ENV TZ=Asia/Shanghai
   RUN apk add --no-cache tzdata

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Alpine Linux Reference

Commands:
  intro          Overview, musl vs glibc, size comparison
  apk            Package manager commands and patterns
  docker         Dockerfiles, multi-stage builds, best practices
  system         OpenRC, networking, users, cron, firewall
  security       Hardening, CVE tracking, container security
  troubleshoot   glibc compat, Python deps, DNS, locale fixes

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)        cmd_intro ;;
  apk)          cmd_apk ;;
  docker)       cmd_docker ;;
  system)       cmd_system ;;
  security)     cmd_security ;;
  troubleshoot) cmd_troubleshoot ;;
  help|*)       show_help ;;
esac
