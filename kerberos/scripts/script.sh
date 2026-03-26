#!/bin/bash
# Kerberos - Network Authentication Protocol Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              KERBEROS REFERENCE                             ║
║          Network Authentication Protocol                    ║
╚══════════════════════════════════════════════════════════════╝

Kerberos is a network authentication protocol that uses tickets
to authenticate users without sending passwords over the network.
It's the backbone of Active Directory authentication.

HOW KERBEROS WORKS:
  1. User → KDC: "I'm alice" (AS-REQ)
  2. KDC → User: Ticket Granting Ticket (TGT) (AS-REP)
     (encrypted with user's password hash)
  3. User decrypts TGT with password
  4. User → KDC: "I need access to fileserver" + TGT (TGS-REQ)
  5. KDC → User: Service Ticket for fileserver (TGS-REP)
  6. User → FileServer: Service Ticket (AP-REQ)
  7. FileServer validates ticket → access granted

  KDC = Key Distribution Center
  TGT = Ticket Granting Ticket (master ticket)
  TGS = Ticket Granting Service (issues service tickets)

KEY CONCEPTS:
  Realm          EXAMPLE.COM (uppercase domain)
  Principal      alice@EXAMPLE.COM (user identity)
  KDC            Central authentication server
  TGT            Master ticket (valid ~10 hours)
  Service ticket Ticket for specific service
  Keytab         File containing service keys
  krb5.conf      Client configuration

WHY KERBEROS:
  ✅ Passwords never sent over network
  ✅ Single Sign-On (SSO) via TGT
  ✅ Mutual authentication (server proves identity too)
  ✅ Industry standard (30+ years)
  ❌ Requires time synchronization (±5 min)
  ❌ Single point of failure (KDC)
  ❌ Complex to set up and debug
EOF
}

cmd_config() {
cat << 'EOF'
CONFIGURATION & COMMANDS
===========================

CLIENT CONFIG (/etc/krb5.conf):
  [libdefaults]
      default_realm = EXAMPLE.COM
      dns_lookup_realm = false
      dns_lookup_kdc = true
      ticket_lifetime = 10h
      renew_lifetime = 7d
      forwardable = true
      rdns = false

  [realms]
      EXAMPLE.COM = {
          kdc = kdc.example.com
          admin_server = kdc.example.com
      }

  [domain_realm]
      .example.com = EXAMPLE.COM
      example.com = EXAMPLE.COM

USER COMMANDS:
  kinit alice                    # Get TGT (prompts for password)
  kinit -kt /etc/alice.keytab alice  # Get TGT with keytab
  klist                          # List current tickets
  klist -e                       # Show encryption types
  kdestroy                       # Delete all tickets
  kpasswd                        # Change password
  kvno HTTP/web.example.com      # Get service ticket + version

TICKET CACHE:
  # Default: /tmp/krb5cc_<UID>
  # Or set:
  export KRB5CCNAME=FILE:/tmp/mytickets
  export KRB5CCNAME=DIR:/tmp/krb5cc_dir/
  export KRB5CCNAME=KEYRING:persistent:1000

KEYTAB MANAGEMENT:
  # Create keytab for service
  kadmin: addprinc -randkey HTTP/web.example.com
  kadmin: ktadd -k /etc/http.keytab HTTP/web.example.com

  # View keytab contents
  klist -kt /etc/http.keytab

  # Merge keytabs
  ktutil
  > read_kt /etc/http.keytab
  > read_kt /etc/nfs.keytab
  > write_kt /etc/combined.keytab

KDC SETUP (MIT Kerberos):
  sudo apt install krb5-kdc krb5-admin-server
  sudo krb5_newrealm

  # Admin operations
  kadmin.local
  > addprinc alice                     # Add user
  > addprinc -randkey HTTP/web.example.com  # Add service
  > listprincs                         # List all principals
  > delprinc alice                     # Delete principal
  > modprinc -maxlife 24h alice        # Modify
  > cpw alice                          # Change password
EOF
}

cmd_integration() {
cat << 'EOF'
INTEGRATION & DEBUGGING
==========================

SSH WITH KERBEROS:
  # /etc/ssh/sshd_config
  GSSAPIAuthentication yes
  GSSAPICleanupCredentials yes

  # /etc/ssh/ssh_config
  GSSAPIAuthentication yes
  GSSAPIDelegateCredentials yes

  # Usage: get TGT first, then SSH without password
  kinit alice
  ssh web.example.com    # No password prompt!

APACHE/NGINX WITH KERBEROS:
  # Apache (mod_auth_gssapi)
  <Location /secure>
      AuthType GSSAPI
      AuthName "Kerberos Login"
      GssapiCredStore keytab:/etc/http.keytab
      Require valid-user
  </Location>

  # Nginx (spnego-http-auth-nginx-module)
  location /secure {
      auth_gss on;
      auth_gss_realm EXAMPLE.COM;
      auth_gss_keytab /etc/http.keytab;
  }

ACTIVE DIRECTORY INTEGRATION:
  # Linux joining AD (realmd + sssd)
  sudo realm discover example.com
  sudo realm join example.com
  # Now AD users can login to Linux!

  # Verify
  id alice@example.com
  getent passwd alice@example.com

PYTHON (gssapi):
  import gssapi

  # Client: get service ticket
  name = gssapi.Name("HTTP@web.example.com",
      name_type=gssapi.NameType.hostbased_service)
  ctx = gssapi.SecurityContext(name=name, usage="initiate")
  token = ctx.step()
  # Send token in HTTP header: Authorization: Negotiate <base64>

DEBUGGING:
  # Enable debug logging
  export KRB5_TRACE=/dev/stderr
  kinit alice    # Shows detailed Kerberos messages

  # Common errors
  "Clock skew too great"    → Sync time (ntpd/chrony)
  "Server not found"        → Check DNS SRV records
  "Key version not available" → Recreate keytab
  "Cannot find KDC"          → Check krb5.conf
  "Preauthentication failed"  → Wrong password/keytab

  # Check DNS SRV records
  dig _kerberos._tcp.example.com SRV
  dig _kerberos._udp.example.com SRV
  dig _kerberos-master._tcp.example.com SRV

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Kerberos - Network Authentication Protocol Reference

Commands:
  intro        How Kerberos works, concepts
  config       krb5.conf, kinit, keytabs, KDC setup
  integration  SSH, Apache/Nginx, Active Directory, debugging

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)       cmd_intro ;;
  config)      cmd_config ;;
  integration) cmd_integration ;;
  help|*)      show_help ;;
esac
