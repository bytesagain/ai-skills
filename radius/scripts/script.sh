#!/bin/bash
# RADIUS - Network Authentication Protocol Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              RADIUS REFERENCE                               ║
║          Network Authentication Protocol                    ║
╚══════════════════════════════════════════════════════════════╝

RADIUS (Remote Authentication Dial-In User Service) is the
standard protocol for network authentication, authorization,
and accounting (AAA). Used by Wi-Fi, VPN, switches, routers.

AAA MODEL:
  Authentication   Who are you? (username/password/cert)
  Authorization    What can you access? (VLAN, ACL, role)
  Accounting       What did you do? (session logging)

WHERE RADIUS IS USED:
  Wi-Fi (802.1X)       Enterprise WPA2/WPA3-Enterprise
  VPN                  Authenticate VPN connections
  Network switches     Port-based access control (802.1X)
  ISP                  PPPoE/dial-up authentication
  Firewall             Admin login authentication
  SSH/RDP              Centralized login for network gear

RADIUS FLOW:
  User → Network Device → RADIUS Server → User Database
  (supplicant)  (NAS/authenticator)  (FreeRADIUS)  (LDAP/AD/SQL)

  1. User connects to Wi-Fi/VPN/switch
  2. Network device sends Access-Request to RADIUS
  3. RADIUS checks credentials against backend (LDAP/AD/SQL)
  4. RADIUS returns Access-Accept or Access-Reject
  5. Network device grants/denies access
  6. Accounting packets track session duration/data

RADIUS vs TACACS+ vs LDAP:
  ┌──────────────┬──────────┬──────────┬──────────┐
  │ Feature      │ RADIUS   │ TACACS+  │ LDAP     │
  ├──────────────┼──────────┼──────────┼──────────┤
  │ Use case     │ Network  │ Net admin│ Directory│
  │ Transport    │ UDP      │ TCP      │ TCP      │
  │ Encryption   │ Password │ Full     │ TLS      │
  │ AAA          │ Combined │ Separate │ AuthN    │
  │ Ports        │ 1812,1813│ 49       │ 389,636  │
  │ Vendor       │ Open     │ Cisco    │ Open     │
  │ Standard     │ RFC 2865 │ Cisco    │ RFC 4511 │
  └──────────────┴──────────┴──────────┴──────────┘

INSTALL:
  # FreeRADIUS (most popular)
  sudo apt install freeradius freeradius-utils
  sudo systemctl start freeradius
EOF
}

cmd_config() {
cat << 'EOF'
FREERADIUS CONFIGURATION
==========================

DIRECTORY STRUCTURE:
  /etc/freeradius/3.0/      (or /etc/raddb/)
  ├── radiusd.conf           Main config
  ├── clients.conf           NAS devices (switches, APs)
  ├── users                  Local user database
  ├── proxy.conf             Proxy/realm config
  ├── mods-enabled/          Active modules
  │   ├── eap                EAP config (802.1X)
  │   ├── ldap               LDAP backend
  │   ├── sql                SQL backend
  │   └── pap, mschap, etc.
  └── sites-enabled/         Virtual servers
      ├── default            Main auth site
      └── inner-tunnel       EAP inner auth

CLIENTS (clients.conf):
  # Wi-Fi access point
  client ap-floor1 {
      ipaddr    = 192.168.1.10
      secret    = SharedSecretHere
      shortname = ap-floor1
      nastype   = other
  }

  # VPN concentrator
  client vpn-server {
      ipaddr    = 10.0.0.1
      secret    = VpnRadiusSecret
      shortname = vpn
  }

  # Subnet (all devices)
  client office-network {
      ipaddr    = 192.168.0.0/24
      secret    = OfficeSecret
  }

LOCAL USERS (users file):
  # Simple password auth
  alice   Cleartext-Password := "password123"
          Reply-Message = "Welcome Alice"

  # With VLAN assignment
  bob     Cleartext-Password := "bobpass"
          Tunnel-Type = VLAN,
          Tunnel-Medium-Type = IEEE-802,
          Tunnel-Private-Group-Id = 100

  # Default reject
  DEFAULT Auth-Type := Reject
          Reply-Message = "Access denied"

EAP (802.1X Wi-Fi):
  # mods-enabled/eap
  eap {
      default_eap_type = peap     # Most common
      timer_expire = 60
      tls-config tls-common {
          private_key_file = /etc/freeradius/certs/server.key
          certificate_file = /etc/freeradius/certs/server.pem
          ca_file = /etc/freeradius/certs/ca.pem
      }
      peap {
          default_eap_type = mschapv2
          inner_eap_type = mschapv2
      }
      tls {
          tls = tls-common
      }
  }
EOF
}

cmd_backends() {
cat << 'EOF'
BACKENDS & TESTING
====================

LDAP BACKEND:
  # mods-enabled/ldap
  ldap {
      server   = "ldap://ldap.example.com"
      port     = 389
      identity = "cn=radius,dc=example,dc=com"
      password = "ldap-bind-password"
      base_dn  = "dc=example,dc=com"

      user {
          base_dn  = "ou=users,${..base_dn}"
          filter   = "(uid=%{%{Stripped-User-Name}:-%{User-Name}})"
      }
      group {
          base_dn  = "ou=groups,${..base_dn}"
          filter   = "(objectClass=posixGroup)"
          membership_attribute = "memberOf"
      }
  }

SQL BACKEND:
  # mods-enabled/sql
  sql {
      driver   = "rlm_sql_mysql"
      server   = "localhost"
      port     = 3306
      login    = "radius"
      password = "radiuspass"
      radius_db = "radius"
  }

  # Schema
  CREATE TABLE radcheck (
      id INT AUTO_INCREMENT PRIMARY KEY,
      username VARCHAR(64) NOT NULL,
      attribute VARCHAR(64) NOT NULL,
      op CHAR(2) DEFAULT ':=',
      value VARCHAR(253) NOT NULL
  );
  INSERT INTO radcheck (username, attribute, op, value)
  VALUES ('alice', 'Cleartext-Password', ':=', 'password123');

ACTIVE DIRECTORY:
  # Use mschap + ntlm_auth
  # mods-enabled/mschap
  mschap {
      ntlm_auth = "/usr/bin/ntlm_auth --request-nt-key
          --username=%{%{Stripped-User-Name}:-%{User-Name}}
          --domain=MYDOMAIN
          --challenge=%{%{mschap:Challenge}:-00}
          --nt-response=%{%{mschap:NT-Response}:-00}"
  }

TESTING:
  # Debug mode (foreground, verbose)
  sudo freeradius -X

  # Test authentication
  radtest alice password123 localhost 0 testing123
  # Expected: Access-Accept

  # Test with EAP
  eapol_test -c eapol_test.conf -s SharedSecret

  # Send accounting
  echo "User-Name=alice,Acct-Status-Type=Start" | \
    radclient localhost acct testing123

COMMON ATTRIBUTES:
  User-Name            Username
  User-Password        Cleartext password
  NAS-IP-Address       Network device IP
  NAS-Port             Physical port
  Service-Type         Login/Framed/etc.
  Framed-IP-Address    IP to assign to user
  Reply-Message        Message shown to user
  Session-Timeout      Max session length (seconds)
  Tunnel-Private-Group-Id  VLAN assignment

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
RADIUS - Network Authentication Protocol Reference

Commands:
  intro      AAA model, flow, comparison
  config     FreeRADIUS clients, users, EAP/802.1X
  backends   LDAP, SQL, Active Directory, testing

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)    cmd_intro ;;
  config)   cmd_config ;;
  backends) cmd_backends ;;
  help|*)   show_help ;;
esac
