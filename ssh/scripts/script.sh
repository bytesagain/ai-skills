#!/usr/bin/env bash
# ssh — Secure Shell Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== SSH Fundamentals ===

SSH (Secure Shell) is a cryptographic network protocol for secure
communication over an unsecured network. Default port: 22.

Protocol Versions:
  SSH-1    Obsolete, vulnerable to attacks. Never use.
  SSH-2    Current standard. All modern implementations.

Authentication Methods (in typical order):
  1. Public Key    Client proves ownership of private key
  2. Password      User enters password (least secure)
  3. Keyboard-Interactive  Challenge-response (2FA, PAM)
  4. Certificate   CA-signed keys (scales for organizations)
  5. GSSAPI/Kerberos  Enterprise single sign-on

Connection Flow:
  1. TCP connection to port 22
  2. Protocol version exchange
  3. Key exchange (Diffie-Hellman) → shared secret
  4. Server authentication (host key verification)
  5. User authentication (key, password, etc.)
  6. Channel opened (session, forwarding, etc.)
  7. Encrypted communication begins

Host Key Verification:
  First connection: "The authenticity of host can't be established"
  Known hosts stored in: ~/.ssh/known_hosts
  TOFU model: Trust On First Use, verify fingerprint out-of-band
  If host key changes → WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!
  This could mean MITM attack or legitimate server rebuild.

Common Implementations:
  OpenSSH     Standard on Linux/macOS/Windows 10+
  Dropbear    Lightweight, embedded systems
  PuTTY       Windows GUI client (uses .ppk key format)
  libssh      Library for embedding SSH in applications
EOF
}

cmd_keys() {
    cat << 'EOF'
=== SSH Key Management ===

GENERATING KEYS:
  # Ed25519 (recommended — fast, secure, short keys)
  ssh-keygen -t ed25519 -C "user@host"

  # RSA (legacy compatibility — use 4096 bits minimum)
  ssh-keygen -t rsa -b 4096 -C "user@host"

  # ECDSA (alternative — smaller than RSA, NIST curves)
  ssh-keygen -t ecdsa -b 521

Key Files:
  ~/.ssh/id_ed25519        Private key (NEVER share)
  ~/.ssh/id_ed25519.pub    Public key (safe to share)

  Permissions (must be correct or SSH refuses):
    ~/.ssh/              700 (drwx------)
    ~/.ssh/id_*          600 (-rw-------)
    ~/.ssh/id_*.pub      644 (-rw-r--r--)
    ~/.ssh/authorized_keys  600 (-rw-------)
    ~/.ssh/config        600 (-rw-------)

DISTRIBUTING PUBLIC KEY:
  # Copy to remote server (adds to authorized_keys)
  ssh-copy-id user@remote-host

  # Manual method
  cat ~/.ssh/id_ed25519.pub | ssh user@host \
    "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"

KEY PASSPHRASE:
  # Add passphrase to existing key
  ssh-keygen -p -f ~/.ssh/id_ed25519

  # Always use a passphrase for keys on laptops/desktops
  # Use ssh-agent to avoid retyping (see 'agent' command)

CONVERTING KEYS:
  # PuTTY .ppk → OpenSSH
  puttygen key.ppk -O private-openssh -o id_rsa

  # OpenSSH → PuTTY .ppk
  puttygen id_rsa -o key.ppk

  # View key fingerprint
  ssh-keygen -lf ~/.ssh/id_ed25519.pub

CERTIFICATE-BASED AUTH (for organizations):
  # Create CA
  ssh-keygen -t ed25519 -f ca_key -C "SSH CA"

  # Sign a user key (valid 52 weeks)
  ssh-keygen -s ca_key -I user@org -n username -V +52w id_ed25519.pub

  # Server trusts CA in sshd_config:
  TrustedUserCAKeys /etc/ssh/ca_key.pub
EOF
}

cmd_config() {
    cat << 'EOF'
=== SSH Client Config (~/.ssh/config) ===

Basic Host Entry:
  Host myserver
      HostName 192.168.1.100
      User admin
      Port 22
      IdentityFile ~/.ssh/id_ed25519

Now: ssh myserver  (instead of ssh -i ~/.ssh/id_ed25519 admin@192.168.1.100 -p 22)

Wildcard Patterns:
  Host *.prod
      User deploy
      IdentityFile ~/.ssh/prod_key

  Host 10.0.*
      User admin
      StrictHostKeyChecking no  # internal network

Jump Host (ProxyJump):
  Host internal-server
      HostName 10.0.1.50
      User admin
      ProxyJump bastion

  # Equivalent command:
  ssh -J bastion internal-server

  # Multi-hop:
  Host deep-server
      ProxyJump bastion1,bastion2

Connection Multiplexing (reuse connections):
  Host *
      ControlMaster auto
      ControlPath ~/.ssh/sockets/%r@%h-%p
      ControlPersist 600
  # First connection opens socket, subsequent ones reuse it
  # mkdir -p ~/.ssh/sockets first!

Keep-Alive (prevent timeouts):
  Host *
      ServerAliveInterval 60
      ServerAliveCountMax 3
  # Sends keepalive every 60 sec, disconnects after 3 failures

Compression:
  Host slow-link
      Compression yes  # useful for slow connections

Multiple Identity Files:
  Host github.com
      IdentityFile ~/.ssh/github_ed25519
      IdentitiesOnly yes  # don't try other keys

  Host gitlab.com
      IdentityFile ~/.ssh/gitlab_ed25519
      IdentitiesOnly yes
EOF
}

cmd_tunnels() {
    cat << 'EOF'
=== SSH Tunneling & Port Forwarding ===

LOCAL FORWARD (-L): Access remote service through local port
  ssh -L local_port:target_host:target_port user@ssh_server

  Example: Access remote database (port 5432) on localhost:15432
  ssh -L 15432:localhost:5432 user@db-server

  Example: Access internal web app through bastion
  ssh -L 8080:internal-app:80 user@bastion
  Then browse: http://localhost:8080

REMOTE FORWARD (-R): Expose local service to remote network
  ssh -R remote_port:target_host:target_port user@ssh_server

  Example: Expose local dev server (port 3000) on remote port 8080
  ssh -R 8080:localhost:3000 user@remote-server
  Anyone on remote-server can access your app on port 8080

  Note: GatewayPorts must be enabled in sshd_config for
  remote forwards to bind to 0.0.0.0 (not just localhost)

DYNAMIC FORWARD (-D): SOCKS proxy
  ssh -D 1080 user@ssh_server

  Creates a SOCKS5 proxy on localhost:1080
  Configure browser/apps to use SOCKS proxy → all traffic
  goes through the SSH tunnel.

  Useful for: browsing from remote location, bypassing
  geo-restrictions, securing traffic on untrusted networks.

USEFUL FLAGS:
  -N    No remote command (just tunnel)
  -f    Go to background after auth
  -T    Disable pseudo-terminal allocation

  # Background tunnel that stays up:
  ssh -fNT -L 5432:localhost:5432 user@db-server

  # Persistent tunnel with autossh:
  autossh -M 0 -fNT -L 5432:localhost:5432 user@db-server

ON-THE-FLY FORWARDS (during session):
  Press ~C (tilde, shift-C) to open ssh> prompt
  ssh> -L 8080:localhost:80    # add local forward
  ssh> -R 9090:localhost:3000  # add remote forward
  ssh> -KL 8080               # cancel local forward
EOF
}

cmd_hardening() {
    cat << 'EOF'
=== SSH Server Hardening (sshd_config) ===

/etc/ssh/sshd_config recommended settings:

# --- Authentication ---
PermitRootLogin no                 # Never allow root SSH login
PasswordAuthentication no          # Key-only authentication
PubkeyAuthentication yes           # Enable public key auth
AuthenticationMethods publickey    # Explicit method list
MaxAuthTries 3                     # Lock out after 3 failures
LoginGraceTime 30                  # 30 sec to authenticate
PermitEmptyPasswords no            # Obviously

# --- Access Control ---
AllowUsers deploy admin            # Whitelist specific users
AllowGroups ssh-users              # Or whitelist by group
DenyUsers root nobody              # Explicit deny

# --- Network ---
Port 22                            # Consider non-standard port
ListenAddress 0.0.0.0              # Or restrict to specific IP
AddressFamily inet                 # inet = IPv4 only

# --- Security ---
Protocol 2                         # SSH-2 only (SSH-1 is broken)
X11Forwarding no                   # Disable unless needed
AllowTcpForwarding no              # Disable unless needed
AllowAgentForwarding no            # Disable unless needed
PermitTunnel no                    # Disable VPN tunneling

# --- Crypto (modern, hardened) ---
KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com
HostKeyAlgorithms ssh-ed25519,rsa-sha2-512

# --- Logging ---
LogLevel VERBOSE                   # Detailed auth logging
SyslogFacility AUTH

# --- Rate Limiting ---
MaxStartups 10:30:60               # Start dropping at 10, 100% drop at 60
ClientAliveInterval 300
ClientAliveCountMax 2

ADDITIONAL MEASURES:
  fail2ban — auto-ban IPs after repeated failures
  ufw/iptables — firewall SSH to trusted IPs only
  Port knocking — require secret port sequence before 22 opens
  2FA — Google Authenticator PAM module for keyboard-interactive
  SSH certificates — centralized CA instead of authorized_keys sprawl

After changes:
  sshd -t                          # Test config for errors
  systemctl reload sshd            # Reload without disconnecting
EOF
}

cmd_agent() {
    cat << 'EOF'
=== SSH Agent ===

SSH agent holds decrypted private keys in memory so you don't
retype passphrases for every connection.

STARTING THE AGENT:
  eval $(ssh-agent -s)             # Start and set env vars
  # Or: most desktop environments auto-start ssh-agent

ADDING KEYS:
  ssh-add                          # Add default key (~/.ssh/id_*)
  ssh-add ~/.ssh/specific_key      # Add specific key
  ssh-add -t 3600 ~/.ssh/key       # Add with 1-hour timeout
  ssh-add -l                       # List loaded keys (fingerprints)
  ssh-add -L                       # List loaded keys (full public keys)
  ssh-add -d ~/.ssh/key            # Remove specific key
  ssh-add -D                       # Remove all keys

macOS KEYCHAIN:
  ssh-add --apple-use-keychain ~/.ssh/id_ed25519
  # In ~/.ssh/config:
  Host *
      UseKeychain yes
      AddKeysToAgent yes

AGENT FORWARDING:
  ssh -A user@bastion              # Forward agent to bastion
  # Now from bastion, you can SSH to other hosts using YOUR keys
  # without copying private keys to bastion

  # In config:
  Host bastion
      ForwardAgent yes

  ⚠️  SECURITY WARNING:
  Agent forwarding is dangerous! Anyone with root on the
  intermediate host can use your agent socket to authenticate
  as you to ANY host your key can access.

  Safer alternative: ProxyJump (-J)
    ssh -J bastion internal-host
    # Keys never leave your machine

AGENT SOCKET:
  SSH_AUTH_SOCK environment variable points to the socket
  echo $SSH_AUTH_SOCK
  # Common issue: socket not found after sudo or screen/tmux
  # Fix: preserve the variable or set it manually
EOF
}

cmd_troubleshoot() {
    cat << 'EOF'
=== SSH Troubleshooting ===

VERBOSE MODE (most useful debug tool):
  ssh -v user@host                 # Level 1 verbose
  ssh -vv user@host                # Level 2
  ssh -vvv user@host               # Level 3 (maximum detail)

COMMON ERRORS:

"Permission denied (publickey)"
  → Key not in authorized_keys
  → Wrong key being offered (use -i to specify)
  → File permissions too open (chmod 600 ~/.ssh/authorized_keys)
  → SELinux context wrong: restorecon -R ~/.ssh/
  → Check: ssh -vvv to see which keys are being tried

"WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!"
  → Host key mismatch (server rebuilt, MITM, IP reuse)
  → Fix: ssh-keygen -R hostname (remove old key)
  → Verify new fingerprint before accepting!

"Connection refused"
  → sshd not running: systemctl status sshd
  → Firewall blocking: iptables -L, ufw status
  → Wrong port: ssh -p 2222 user@host
  → ListenAddress binding issue in sshd_config

"Connection timed out"
  → Host unreachable (network issue)
  → Firewall dropping (not rejecting) packets
  → Try: ping, traceroute, telnet host 22

"Too many authentication failures"
  → ssh-agent offering many keys before the right one
  → Fix: ssh -o IdentitiesOnly=yes -i ~/.ssh/correct_key user@host
  → Or: IdentitiesOnly yes in ~/.ssh/config

"broken pipe" / Disconnections
  → Add to ~/.ssh/config:
    ServerAliveInterval 60
    ServerAliveCountMax 3
  → Or server-side: ClientAliveInterval in sshd_config

SERVER-SIDE DEBUGGING:
  # Run sshd in debug mode on alternate port
  /usr/sbin/sshd -d -p 2222
  # Watch auth attempts in real-time
  tail -f /var/log/auth.log        # Debian/Ubuntu
  tail -f /var/log/secure          # RHEL/CentOS
  journalctl -u sshd -f            # systemd
EOF
}

cmd_escapes() {
    cat << 'EOF'
=== SSH Escape Sequences ===

Escape character: ~ (tilde) — must be at start of line (after Enter)

~.      Disconnect (kill hung session)
~^Z     Suspend ssh (background, return with fg)
~#      List forwarded connections
~&      Background ssh while waiting for forwarded connections to close
~?      Show escape help
~C      Open command line for on-the-fly port forwards
~R      Request rekeying (refresh encryption)
~V      Show version info
~~      Send literal tilde

USING ~C (Interactive Tunnel Manager):
  Press Enter, then ~C
  ssh> -L 8080:localhost:80      Add local forward
  ssh> -R 9090:localhost:3000    Add remote forward
  ssh> -D 1080                   Add SOCKS proxy
  ssh> -KL 8080                  Cancel local forward 8080
  ssh> -KR 9090                  Cancel remote forward 9090
  ssh> -KD 1080                  Cancel SOCKS proxy

KILLING HUNG SESSIONS:
  If SSH session is frozen:
    1. Press Enter (ensure at beginning of line)
    2. Type ~.
    3. You'll see "Connection to host closed."
  
  If that doesn't work:
    1. Press Enter
    2. Type ~. quickly (within 1 second)

  Multiple jump hosts? Each tilde must be doubled:
    ~.          Kill outermost connection
    ~~.         Kill second-level connection
    ~~~.        Kill third-level connection

Note: Escape character can be changed with -e flag
  ssh -e '%' user@host   # Use % instead of ~
  ssh -e none user@host  # Disable escapes entirely
EOF
}

show_help() {
    cat << EOF
ssh v$VERSION — Secure Shell Reference

Usage: script.sh <command>

Commands:
  intro        SSH protocol overview and authentication methods
  keys         Key generation, distribution, and certificate auth
  config       SSH client config patterns and examples
  tunnels      Local, remote, dynamic port forwarding
  hardening    sshd_config best practices and server security
  agent        SSH agent usage, forwarding, and security
  troubleshoot Debugging connections and common error fixes
  escapes      Escape sequences and session control
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)        cmd_intro ;;
    keys)         cmd_keys ;;
    config)       cmd_config ;;
    tunnels)      cmd_tunnels ;;
    hardening)    cmd_hardening ;;
    agent)        cmd_agent ;;
    troubleshoot) cmd_troubleshoot ;;
    escapes)      cmd_escapes ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "ssh v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
