#!/usr/bin/env bash
# vault — HashiCorp Vault secrets management reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail
VERSION="1.0.0"

show_help() {
    cat << 'HELPEOF'
vault v1.0.0 — Secrets Management Reference

Usage: vault <command>

Commands:
  intro       Vault overview, seal/unseal
  basics      Dev server, init, root token
  secrets     Secret engines (KV, transit, PKI)
  auth        Auth methods (token, userpass, approle)
  policies    HCL policies, capabilities
  dynamic     Dynamic secrets (database, AWS, PKI)
  transit     Encryption as a service
  ops         HA, auto-unseal, audit, backup

Powered by BytesAgain | bytesagain.com
HELPEOF
}

cmd_intro() {
    cat << 'EOF'
# HashiCorp Vault

## What is Vault?
Vault secures, stores, and controls access to secrets: API keys, passwords,
certificates, encryption keys. It provides a unified interface to secrets
while maintaining tight access control and a detailed audit log.

## Core Concepts
- **Secrets Engine**: Backend that stores/generates secrets (KV, PKI, AWS, DB)
- **Auth Method**: How users/apps prove identity (token, LDAP, K8s, AppRole)
- **Policy**: Rules defining what paths a token can access
- **Seal/Unseal**: Vault starts sealed (encrypted); must be unsealed to operate
- **Lease**: Secrets have TTL; auto-revoked when expired

## Architecture
```
Client → Auth Method → Token → Policy → Secret Engine
                                            │
                                   ┌────────┼────────┐
                                   ▼        ▼        ▼
                                KV v2    Transit   Database
                               (static) (encrypt) (dynamic)
```

## Seal/Unseal
```
Vault starts SEALED:
  - Data encrypted with master key
  - Master key encrypted with unseal keys (Shamir's Secret Sharing)
  - Need threshold of unseal keys to unlock

Default: 5 keys generated, 3 required (threshold)
```

## Quick Start
```bash
# Dev mode (in-memory, auto-unsealed, root token = "root")
vault server -dev

# Set address
export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN='root'

# Check status
vault status

# Write a secret
vault kv put secret/myapp password=s3cr3t

# Read a secret
vault kv get secret/myapp

# Delete
vault kv delete secret/myapp
```
EOF
}

cmd_basics() {
    cat << 'EOF'
# Vault Basics

## Production Init
```bash
# Start server
vault server -config=/etc/vault.d/vault.hcl

# Initialize (creates unseal keys + root token)
vault operator init

# Output:
# Unseal Key 1: xxxxx
# Unseal Key 2: xxxxx
# Unseal Key 3: xxxxx
# Unseal Key 4: xxxxx
# Unseal Key 5: xxxxx
# Initial Root Token: hvs.xxxxx
#
# SAVE THESE SECURELY. Distribute keys to different people.

# Unseal (need 3 of 5 by default)
vault operator unseal <key1>
vault operator unseal <key2>
vault operator unseal <key3>

# Login with root token
vault login hvs.xxxxx
```

## Server Config
```hcl
# /etc/vault.d/vault.hcl
storage "raft" {
  path    = "/var/lib/vault/data"
  node_id = "vault-1"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_cert_file = "/etc/vault.d/tls/cert.pem"
  tls_key_file  = "/etc/vault.d/tls/key.pem"
}

api_addr     = "https://vault.example.com:8200"
cluster_addr = "https://vault.example.com:8201"
ui           = true
```

## Storage Backends
| Backend | HA | Description |
|---------|-----|------------|
| raft | Yes | Integrated storage (recommended) |
| consul | Yes | HashiCorp Consul |
| file | No | Local filesystem |
| s3 | No | AWS S3 |
| mysql | No | MySQL database |

## Seal Again
```bash
# Manually seal (emergency)
vault operator seal
```
EOF
}

cmd_secrets() {
    cat << 'EOF'
# Secret Engines

## KV Version 2 (Default)
```bash
# Enable KV v2 at custom path
vault secrets enable -path=kv kv-v2

# Write
vault kv put kv/myapp/config \
  db_host=10.0.0.1 \
  db_port=5432 \
  db_pass=s3cr3t

# Read
vault kv get kv/myapp/config

# Read specific field
vault kv get -field=db_pass kv/myapp/config

# Read as JSON
vault kv get -format=json kv/myapp/config

# List keys
vault kv list kv/myapp/

# Versioning
vault kv get -version=1 kv/myapp/config   # Old version
vault kv rollback -version=1 kv/myapp/config  # Rollback

# Delete (soft)
vault kv delete kv/myapp/config

# Undelete
vault kv undelete -versions=2 kv/myapp/config

# Destroy (permanent)
vault kv destroy -versions=2 kv/myapp/config
```

## List All Engines
```bash
vault secrets list
```

## Secret Engine Types
| Engine | Purpose |
|--------|---------|
| kv | Static key/value pairs |
| transit | Encryption as a service |
| database | Dynamic database credentials |
| aws | Dynamic AWS IAM credentials |
| pki | X.509 certificates |
| ssh | SSH key signing |
| totp | Time-based OTP |
| cubbyhole | Per-token private storage |
| consul | Consul ACL tokens |

## Enable/Disable
```bash
vault secrets enable -path=pki pki
vault secrets disable pki/
```
EOF
}

cmd_auth() {
    cat << 'EOF'
# Authentication Methods

## Token Auth (Built-in)
```bash
# Create token
vault token create -policy=my-policy -ttl=1h

# Create with metadata
vault token create -policy=reader -metadata="user=john" -display-name="john-token"

# Lookup token info
vault token lookup
vault token lookup <token>

# Renew token
vault token renew <token>

# Revoke
vault token revoke <token>
vault token revoke -self
```

## UserPass
```bash
# Enable
vault auth enable userpass

# Create user
vault write auth/userpass/users/john \
  password=changeme \
  policies=dev-policy

# Login
vault login -method=userpass username=john password=changeme
```

## AppRole (Machine Auth)
```bash
# Enable
vault auth enable approle

# Create role
vault write auth/approle/role/myapp \
  token_policies="myapp-policy" \
  token_ttl=1h \
  token_max_ttl=4h \
  secret_id_ttl=720h

# Get role-id (embed in app config)
vault read auth/approle/role/myapp/role-id

# Generate secret-id (deliver securely)
vault write -f auth/approle/role/myapp/secret-id

# Login (from app)
vault write auth/approle/login \
  role_id=xxx \
  secret_id=yyy
```

## Kubernetes
```bash
# Enable
vault auth enable kubernetes

# Configure
vault write auth/kubernetes/config \
  kubernetes_host="https://kubernetes.default.svc:443" \
  token_reviewer_jwt="@/var/run/secrets/kubernetes.io/serviceaccount/token"

# Create role
vault write auth/kubernetes/role/myapp \
  bound_service_account_names=myapp \
  bound_service_account_namespaces=default \
  policies=myapp-policy \
  ttl=1h
```

## LDAP
```bash
vault auth enable ldap
vault write auth/ldap/config \
  url="ldaps://ldap.example.com" \
  userdn="ou=Users,dc=example,dc=com" \
  groupdn="ou=Groups,dc=example,dc=com" \
  groupfilter="(&(objectClass=group)(member:1.2.840.113556.1.4.1941:={{.UserDN}}))" \
  binddn="cn=vault,ou=Service,dc=example,dc=com" \
  bindpass="xxx"
```

## List Auth Methods
```bash
vault auth list
```
EOF
}

cmd_policies() {
    cat << 'EOF'
# Vault Policies

## Policy Syntax (HCL)
```hcl
# Read-only access to secrets
path "secret/data/myapp/*" {
  capabilities = ["read", "list"]
}

# Full access to specific path
path "secret/data/myapp/config" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Deny access
path "secret/data/admin/*" {
  capabilities = ["deny"]
}
```

## Capabilities
| Capability | HTTP Verb | Description |
|-----------|-----------|-------------|
| create | POST | Create new secrets |
| read | GET | Read secrets |
| update | PUT/POST | Update existing |
| delete | DELETE | Delete secrets |
| list | LIST | List keys |
| sudo | - | Access root-protected paths |
| deny | - | Explicitly deny |

## Policy Management
```bash
# Write policy from file
vault policy write myapp-policy myapp-policy.hcl

# Write inline
vault policy write dev-read - <<POLICY
path "secret/data/dev/*" {
  capabilities = ["read", "list"]
}
POLICY

# List policies
vault policy list

# Read policy
vault policy read myapp-policy

# Delete policy
vault policy delete myapp-policy

# Test capabilities
vault token capabilities secret/data/myapp/config
```

## Templated Policies
```hcl
# Use identity entity name
path "secret/data/{{identity.entity.name}}/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Use auth metadata
path "secret/data/teams/{{identity.entity.aliases.auth_ldap.metadata.group}}/*" {
  capabilities = ["read", "list"]
}
```

## Built-in Policies
| Policy | Purpose |
|--------|---------|
| root | Full access (never grant to apps) |
| default | Attached to all tokens (basic self-management) |
EOF
}

cmd_dynamic() {
    cat << 'EOF'
# Dynamic Secrets

## Database (PostgreSQL)
```bash
# Enable
vault secrets enable database

# Configure connection
vault write database/config/mydb \
  plugin_name=postgresql-database-plugin \
  connection_url="postgresql://{{username}}:{{password}}@db.example.com:5432/mydb" \
  allowed_roles="readonly,readwrite" \
  username="vault_admin" \
  password="vault_admin_pass"

# Create role
vault write database/roles/readonly \
  db_name=mydb \
  creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";" \
  default_ttl="1h" \
  max_ttl="24h"

# Get dynamic credentials
vault read database/creds/readonly
# Key              Value
# lease_id         database/creds/readonly/abc123
# lease_duration   1h
# username         v-token-readonly-xyz789
# password         A1B2C3D4E5...

# Revoke lease (credentials deleted from DB)
vault lease revoke database/creds/readonly/abc123
```

## AWS IAM
```bash
# Enable
vault secrets enable aws

# Configure root credentials
vault write aws/config/root \
  access_key=AKIAXXXXXXXX \
  secret_key=xxxxxxxxxxxx \
  region=us-east-1

# Create role
vault write aws/roles/s3-reader \
  credential_type=iam_user \
  policy_document=-<<AWSPOLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::mybucket/*"
    }
  ]
}
AWSPOLICY

# Get credentials
vault read aws/creds/s3-reader
```

## PKI (Certificates)
```bash
# Enable
vault secrets enable pki
vault secrets tune -max-lease-ttl=87600h pki

# Generate root CA
vault write pki/root/generate/internal \
  common_name="Example CA" \
  ttl=87600h

# Create role
vault write pki/roles/example-dot-com \
  allowed_domains="example.com" \
  allow_subdomains=true \
  max_ttl=720h

# Issue certificate
vault write pki/issue/example-dot-com \
  common_name="web.example.com" \
  ttl=24h
```
EOF
}

cmd_transit() {
    cat << 'EOF'
# Transit Engine — Encryption as a Service

## Enable
```bash
vault secrets enable transit
```

## Create Encryption Key
```bash
vault write -f transit/keys/myapp-key

# With specific type
vault write -f transit/keys/payment-key type=aes256-gcm96

# Key types: aes128-gcm96, aes256-gcm96, chacha20-poly1305,
#             ed25519, ecdsa-p256, ecdsa-p384, rsa-2048, rsa-4096
```

## Encrypt
```bash
# Encode plaintext as base64 first
vault write transit/encrypt/myapp-key \
  plaintext=$(echo -n "my secret data" | base64)

# Returns: vault:v1:xxxxxxxxxxxxx
```

## Decrypt
```bash
vault write transit/decrypt/myapp-key \
  ciphertext=vault:v1:xxxxxxxxxxxxx

# Returns base64: decode it
echo "bXkgc2VjcmV0IGRhdGE=" | base64 -d
```

## Key Rotation
```bash
# Rotate key (new version, old versions still decrypt)
vault write -f transit/keys/myapp-key/rotate

# Rewrap existing ciphertext with latest key version
vault write transit/rewrap/myapp-key \
  ciphertext=vault:v1:xxxxxxxxxxxxx
# Returns: vault:v2:yyyyyyyyyyyyy

# Set minimum decryption version (disable old versions)
vault write transit/keys/myapp-key \
  min_decryption_version=2
```

## HMAC
```bash
vault write transit/hmac/myapp-key \
  input=$(echo -n "verify this" | base64)
```

## Sign/Verify (with ed25519/RSA/ECDSA key)
```bash
vault write transit/sign/signing-key \
  input=$(echo -n "sign this" | base64)

vault write transit/verify/signing-key \
  input=$(echo -n "sign this" | base64) \
  signature=vault:v1:xxxxx
```

## Batch Operations
```bash
vault write transit/encrypt/myapp-key \
  batch_input='[{"plaintext":"aGVsbG8="},{"plaintext":"d29ybGQ="}]'
```

## Use Case: Application-Level Encryption
```python
import hvac, base64

client = hvac.Client(url='http://vault:8200', token='xxx')

# Encrypt
result = client.secrets.transit.encrypt_data(
    name='myapp-key',
    plaintext=base64.b64encode(b'credit-card-1234').decode()
)
ciphertext = result['data']['ciphertext']
# Store ciphertext in database

# Decrypt
result = client.secrets.transit.decrypt_data(
    name='myapp-key',
    ciphertext=ciphertext
)
plaintext = base64.b64decode(result['data']['plaintext']).decode()
```
EOF
}

cmd_ops() {
    cat << 'EOF'
# Vault Operations

## Auto-Unseal
```hcl
# Instead of manual unseal keys, use a cloud KMS

# AWS KMS
seal "awskms" {
  region     = "us-east-1"
  kms_key_id = "arn:aws:kms:us-east-1:123456:key/xxx-xxx"
}

# Azure Key Vault
seal "azurekeyvault" {
  vault_name = "myvault"
  key_name   = "vault-unseal"
}

# GCP Cloud KMS
seal "gcpckms" {
  project    = "myproject"
  region     = "global"
  key_ring   = "vault"
  crypto_key = "unseal"
}

# Transit (another Vault instance)
seal "transit" {
  address     = "https://other-vault:8200"
  token       = "xxx"
  key_name    = "auto-unseal"
  mount_path  = "transit"
}
```

## High Availability
```hcl
# Integrated Raft Storage (recommended)
storage "raft" {
  path    = "/var/lib/vault/data"
  node_id = "vault-1"
  
  retry_join {
    leader_api_addr = "https://vault-2:8200"
  }
  retry_join {
    leader_api_addr = "https://vault-3:8200"
  }
}
```

## Audit Devices
```bash
# Enable file audit
vault audit enable file file_path=/var/log/vault/audit.log

# Enable syslog audit
vault audit enable syslog tag="vault" facility="AUTH"

# List audit devices
vault audit list

# All requests AND responses are logged (sensitive data hashed)
```

## Backup & Restore
```bash
# Raft snapshot
vault operator raft snapshot save vault-backup.snap

# Restore
vault operator raft snapshot restore vault-backup.snap

# Automated backup
0 */6 * * * vault operator raft snapshot save /backup/vault-$(date +\%Y\%m\%d-\%H).snap
```

## Token Housekeeping
```bash
# List accessors (find all tokens)
vault list auth/token/accessors

# Revoke all tokens for a user
vault token revoke -mode=orphan <accessor>

# Tidy up expired leases
vault lease tidy
```

## Health Check
```bash
# HTTP health endpoint
curl https://vault:8200/v1/sys/health

# Response codes:
# 200 = initialized, unsealed, active
# 429 = unsealed, standby
# 472 = disaster recovery standby
# 473 = performance standby
# 501 = not initialized
# 503 = sealed
```
EOF
}

case "${1:-help}" in
    intro)    cmd_intro ;;
    basics)   cmd_basics ;;
    secrets)  cmd_secrets ;;
    auth)     cmd_auth ;;
    policies) cmd_policies ;;
    dynamic)  cmd_dynamic ;;
    transit)  cmd_transit ;;
    ops)      cmd_ops ;;
    help|-h)  show_help ;;
    version|-v) echo "vault v$VERSION" ;;
    *)        echo "Unknown: $1"; show_help ;;
esac
