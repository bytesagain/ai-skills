#!/bin/bash
# LDAP - Lightweight Directory Access Protocol Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              LDAP REFERENCE                                 ║
║          Lightweight Directory Access Protocol              ║
╚══════════════════════════════════════════════════════════════╝

LDAP is the standard protocol for accessing directory services
— centralized databases of users, groups, computers, and other
resources. Active Directory is Microsoft's LDAP implementation.

KEY CONCEPTS:
  DIT        Directory Information Tree (hierarchy)
  DN         Distinguished Name (unique path to entry)
  RDN        Relative Distinguished Name (one level)
  Entry      Object with attributes (user, group, OU)
  Attribute  Key-value pair (cn, sn, mail, uid)
  Schema     Rules for what attributes entries can have
  ObjectClass Defines required/optional attributes

DN ANATOMY:
  cn=Alice Smith,ou=Users,dc=example,dc=com
  │              │         └─ Domain component
  │              └─ Organizational Unit
  └─ Common Name (RDN)

COMMON ATTRIBUTES:
  dc    Domain Component       dc=example,dc=com
  ou    Organizational Unit    ou=Users
  cn    Common Name            cn=Alice Smith
  sn    Surname                sn=Smith
  uid   User ID                uid=asmith
  mail  Email                  mail=alice@example.com
  userPassword                 Hashed password
  memberOf                     Group membership
  objectClass                  Entry type

LDAP IMPLEMENTATIONS:
  OpenLDAP           Open-source, Linux
  Active Directory   Microsoft, Windows
  389 Directory      Red Hat/Fedora
  OpenDJ             Forgerock
  Apache DS          Apache Foundation
  LLDAP              Lightweight, Rust

PORTS:
  389     LDAP (plaintext/STARTTLS)
  636     LDAPS (TLS)
  3268    Global Catalog (AD)
  3269    Global Catalog SSL (AD)
EOF
}

cmd_operations() {
cat << 'EOF'
LDAP OPERATIONS
=================

LDAPSEARCH:
  # Search all users
  ldapsearch -x -H ldap://ldap.example.com \
    -b "ou=Users,dc=example,dc=com" \
    -D "cn=admin,dc=example,dc=com" -W \
    "(objectClass=inetOrgPerson)"

  # Find specific user
  ldapsearch -x -H ldap://ldap.example.com \
    -b "dc=example,dc=com" \
    -D "cn=admin,dc=example,dc=com" -W \
    "(uid=asmith)" cn mail memberOf

  # Search with TLS
  ldapsearch -x -H ldaps://ldap.example.com \
    -b "dc=example,dc=com" "(cn=*)"

  # Anonymous search (if allowed)
  ldapsearch -x -H ldap://ldap.example.com \
    -b "dc=example,dc=com" "(objectClass=*)" dn

SEARCH FILTERS:
  (uid=asmith)                    Exact match
  (cn=Alice*)                     Wildcard
  (mail=*@example.com)            Suffix match
  (&(objectClass=person)(uid=a*)) AND
  (|(uid=alice)(uid=bob))         OR
  (!(uid=admin))                  NOT
  (&(objectClass=group)(cn=dev*)) Groups starting with "dev"
  (memberOf=cn=admins,ou=Groups,dc=example,dc=com)

LDAPADD (create entry):
  # user.ldif
  dn: uid=jdoe,ou=Users,dc=example,dc=com
  objectClass: inetOrgPerson
  objectClass: posixAccount
  objectClass: shadowAccount
  uid: jdoe
  cn: John Doe
  sn: Doe
  mail: john@example.com
  uidNumber: 10001
  gidNumber: 10000
  homeDirectory: /home/jdoe
  loginShell: /bin/bash
  userPassword: {SSHA}hashed_password

  ldapadd -x -H ldap://ldap.example.com \
    -D "cn=admin,dc=example,dc=com" -W -f user.ldif

LDAPMODIFY (update entry):
  # modify.ldif
  dn: uid=jdoe,ou=Users,dc=example,dc=com
  changetype: modify
  replace: mail
  mail: newemail@example.com
  -
  add: telephoneNumber
  telephoneNumber: +1-555-1234
  -
  delete: description

  ldapmodify -x -H ldap://ldap.example.com \
    -D "cn=admin,dc=example,dc=com" -W -f modify.ldif

LDAPDELETE:
  ldapdelete -x -H ldap://ldap.example.com \
    -D "cn=admin,dc=example,dc=com" -W \
    "uid=jdoe,ou=Users,dc=example,dc=com"

LDAPPASSWD:
  ldappasswd -x -H ldap://ldap.example.com \
    -D "cn=admin,dc=example,dc=com" -W \
    -S "uid=jdoe,ou=Users,dc=example,dc=com"
EOF
}

cmd_setup() {
cat << 'EOF'
OPENLDAP SETUP & APP INTEGRATION
====================================

OPENLDAP SETUP:
  sudo apt install slapd ldap-utils
  sudo dpkg-reconfigure slapd
  # Set domain: example.com → dc=example,dc=com
  # Set admin password

  # Create organizational units
  cat << LDIF | ldapadd -x -D "cn=admin,dc=example,dc=com" -W
  dn: ou=Users,dc=example,dc=com
  objectClass: organizationalUnit
  ou: Users

  dn: ou=Groups,dc=example,dc=com
  objectClass: organizationalUnit
  ou: Groups
  LDIF

PYTHON (ldap3):
  pip install ldap3
  from ldap3 import Server, Connection, ALL

  server = Server("ldap://ldap.example.com", get_info=ALL)
  conn = Connection(server,
      user="cn=admin,dc=example,dc=com",
      password="adminpass",
      auto_bind=True)

  # Search
  conn.search("ou=Users,dc=example,dc=com",
      "(objectClass=inetOrgPerson)",
      attributes=["cn", "mail", "uid"])
  for entry in conn.entries:
      print(entry.cn, entry.mail)

  # Add user
  conn.add("uid=newuser,ou=Users,dc=example,dc=com",
      ["inetOrgPerson", "posixAccount"],
      {"cn": "New User", "sn": "User", "uid": "newuser",
       "uidNumber": 10002, "gidNumber": 10000,
       "homeDirectory": "/home/newuser"})

  # Authenticate user
  user_conn = Connection(server,
      user="uid=jdoe,ou=Users,dc=example,dc=com",
      password="userpass")
  if user_conn.bind():
      print("Auth success")

APP INTEGRATION:
  # Nginx (ngx_http_auth_request)
  # GitLab → Admin → LDAP
  # Nextcloud → Settings → LDAP
  # Jenkins → Manage → Configure → LDAP
  # Grafana → grafana.ini → [auth.ldap]

  [auth.ldap]
  enabled = true
  config_file = /etc/grafana/ldap.toml
  allow_sign_up = true

  # /etc/grafana/ldap.toml
  [[servers]]
  host = "ldap.example.com"
  port = 636
  use_ssl = true
  bind_dn = "cn=grafana,ou=Services,dc=example,dc=com"
  bind_password = "secret"
  search_filter = "(uid=%s)"
  search_base_dns = ["ou=Users,dc=example,dc=com"]

  [servers.attributes]
  name = "cn"
  surname = "sn"
  username = "uid"
  email = "mail"

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
LDAP - Lightweight Directory Access Protocol Reference

Commands:
  intro       Concepts, DN anatomy, implementations
  operations  Search, add, modify, delete, filters
  setup       OpenLDAP install, Python ldap3, app integration

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)      cmd_intro ;;
  operations) cmd_operations ;;
  setup)      cmd_setup ;;
  help|*)     show_help ;;
esac
