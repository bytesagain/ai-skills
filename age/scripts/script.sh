#!/bin/bash
# age - Simple, Modern File Encryption Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              AGE ENCRYPTION REFERENCE                       ║
║          Simple, Modern, and Secure File Encryption         ║
╚══════════════════════════════════════════════════════════════╝

age (pronounced "aghe") is a simple, modern, and secure file encryption
tool designed by Filippo Valsorda (Go security lead at Google).
It's the spiritual successor to GPG for file encryption.

PHILOSOPHY:
  - No config files
  - No key servers
  - No key IDs or web of trust
  - No ASN.1 or X.509
  - Just encrypt and decrypt files

KEY TYPES:
  age keys      Native X25519 keys (recommended)
  SSH keys      Reuse existing SSH keys (ed25519, RSA)
  Passphrase    Password-based encryption (scrypt)

age vs GPG:
  ┌────────────────┬────────────────┬────────────────┐
  │ Feature        │ age            │ GPG            │
  ├────────────────┼────────────────┼────────────────┤
  │ Key format     │ X25519         │ RSA/DSA/ECC    │
  │ Config needed  │ None           │ ~/.gnupg/      │
  │ Key management │ Just files     │ Keyring/server │
  │ Trust model    │ None           │ Web of Trust   │
  │ Signing        │ No             │ Yes            │
  │ Key size       │ 62 chars       │ Variable       │
  │ Line noise     │ Minimal        │ Maximum        │
  │ Learning curve │ 5 minutes      │ 5 hours        │
  │ Streaming      │ Yes (v2)       │ Yes            │
  │ Armor output   │ PEM-like       │ ASCII Armor    │
  └────────────────┴────────────────┴────────────────┘

CRYPTO UNDER THE HOOD:
  Key exchange:    X25519 (Curve25519 ECDH)
  Symmetric:       ChaCha20-Poly1305
  KDF:             HKDF-SHA-256
  Passphrase KDF:  scrypt (N=2^18, r=8, p=1)
  Header MAC:      HMAC-SHA-256
EOF
}

cmd_keygen() {
cat << 'EOF'
KEY GENERATION & MANAGEMENT
=============================

GENERATE A KEY PAIR:
  age-keygen -o key.txt

  Output (key.txt):
    # created: 2026-03-24T12:00:00+08:00
    # public key: age1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    AGE-SECRET-KEY-1XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

  The public key (age1...) is safe to share.
  The secret key (AGE-SECRET-KEY-1...) must be kept private.

MULTIPLE KEYS:
  # Generate keys for different purposes
  age-keygen -o personal.key
  age-keygen -o work.key
  age-keygen -o backup.key

  # Extract public key from secret key
  age-keygen -y key.txt
  # Output: age1xxxxxxx...

KEY STORAGE BEST PRACTICES:
  # Set restrictive permissions
  chmod 600 key.txt

  # Store in secure location
  mkdir -p ~/.config/age
  mv key.txt ~/.config/age/identity.txt
  chmod 700 ~/.config/age

  # Back up your secret key!
  # If you lose it, encrypted files are gone forever.
  # Unlike GPG, there's no key recovery mechanism.

USING SSH KEYS INSTEAD:
  age supports encrypting to SSH public keys directly.
  No need to generate age-specific keys.

  Supported SSH key types:
  - ssh-ed25519 (recommended)
  - ssh-rsa (2048+ bits)

  # Encrypt to SSH key
  age -R ~/.ssh/id_ed25519.pub -o secret.age plaintext.txt

  # Decrypt with SSH private key
  age -d -i ~/.ssh/id_ed25519 -o plaintext.txt secret.age

  # Encrypt to GitHub user's SSH keys
  curl -s https://github.com/username.keys | age -R - -o secret.age file.txt
EOF
}

cmd_encrypt() {
cat << 'EOF'
ENCRYPTION OPERATIONS
=======================

BASIC ENCRYPTION:
  # Encrypt to a recipient (public key)
  age -r age1recipient... -o secret.age plaintext.txt

  # Encrypt from stdin
  echo "secret message" | age -r age1recipient... -o message.age

  # Encrypt with ASCII armor (PEM format, for pasting)
  age -r age1recipient... -a -o secret.age.pem plaintext.txt

MULTIPLE RECIPIENTS:
  # Multiple -r flags
  age -r age1alice... -r age1bob... -o shared.age document.pdf

  # Recipients file (one public key per line)
  cat > recipients.txt << KEYS
  age1alice_key_here
  age1bob_key_here
  age1carol_key_here
  KEYS

  age -R recipients.txt -o shared.age document.pdf

PASSPHRASE ENCRYPTION:
  # No keys needed, just a password
  age -p -o secret.age plaintext.txt
  # Prompts: Enter passphrase:

  # From stdin
  echo "password123" | age -p -o secret.age plaintext.txt

  # Passphrase uses scrypt KDF — slow by design (anti-brute-force)
  # Good for: personal files, one-off sharing
  # Bad for: automated systems (use keys instead)

ENCRYPT DIRECTORIES:
  # age works on files, use tar for directories
  tar czf - my-folder/ | age -r age1recipient... -o folder.tar.gz.age

  # Or with compression choice
  tar cf - my-folder/ | zstd | age -r age1recipient... -o folder.tar.zst.age

PIPE OPERATIONS:
  # Encrypt and stream
  mysqldump mydb | age -r age1recipient... | aws s3 cp - s3://bucket/backup.sql.age

  # Compress then encrypt (recommended order)
  cat largefile.bin | gzip | age -r age1recipient... -o largefile.gz.age

  # Encrypt then base64 (for text transport)
  age -r age1recipient... -a < secret.txt  # -a flag = ASCII armor
EOF
}

cmd_decrypt() {
cat << 'EOF'
DECRYPTION OPERATIONS
=======================

BASIC DECRYPTION:
  # Decrypt with identity (secret key)
  age -d -i key.txt -o plaintext.txt secret.age

  # Decrypt to stdout
  age -d -i key.txt secret.age

  # Decrypt from stdin
  cat secret.age | age -d -i key.txt

  # Decrypt ASCII armored file
  age -d -i key.txt secret.age.pem

PASSPHRASE DECRYPTION:
  age -d -o plaintext.txt secret.age
  # Prompts: Enter passphrase:

  # age auto-detects passphrase vs key encryption

MULTIPLE IDENTITIES:
  # Try multiple keys (first match wins)
  age -d -i personal.key -i work.key -o output.txt secret.age

  # Identity file with multiple keys
  cat personal.key work.key > all-keys.txt
  age -d -i all-keys.txt secret.age

DECRYPT WITH SSH KEY:
  age -d -i ~/.ssh/id_ed25519 -o plaintext.txt secret.age

  # SSH agent support
  age -d -i ~/.ssh/id_ed25519 secret.age
  # If key has passphrase, ssh-agent handles it

DECRYPT DIRECTORIES:
  age -d -i key.txt folder.tar.gz.age | tar xzf -

PIPE DECRYPTION:
  # Decrypt from S3
  aws s3 cp s3://bucket/backup.sql.age - | age -d -i key.txt | mysql mydb

  # Decrypt and decompress
  age -d -i key.txt largefile.gz.age | gunzip > largefile.bin

ERROR HANDLING:
  "no identity matched any of the recipients"
    → Wrong key. Check which public key was used to encrypt.

  "incorrect passphrase"
    → Wrong password. No recovery possible.

  "unknown format"
    → File is not age-encrypted, or corrupted.

  "failed to open identity file"
    → Check file path and permissions.
EOF
}

cmd_recipes() {
cat << 'EOF'
PRACTICAL RECIPES
===================

1. ENCRYPTED BACKUPS
   # Daily backup script
   #!/bin/bash
   RECIPIENT="age1xxxxxxx..."
   BACKUP_DIR="/backups"
   DATE=$(date +%Y%m%d)

   tar czf - /etc /home/user/documents | \
     age -r "$RECIPIENT" -o "$BACKUP_DIR/backup-$DATE.tar.gz.age"

   # Cleanup old backups (keep 30 days)
   find "$BACKUP_DIR" -name "*.age" -mtime +30 -delete

2. ENCRYPTED DOTFILES IN GIT
   # Encrypt sensitive files before committing
   age -R ~/.config/age/recipients.txt -o .env.age .env
   git add .env.age
   echo ".env" >> .gitignore

   # Decrypt after cloning
   age -d -i ~/.config/age/identity.txt -o .env .env.age

3. SHARE SECRETS WITH TEAM
   # Create team recipients file
   cat > team-keys.txt << KEYS
   # Alice (DevOps)
   age1alice...
   # Bob (Backend)
   age1bob...
   # Carol (Security)
   age1carol...
   KEYS

   # Encrypt secret for team
   age -R team-keys.txt -o api-keys.age api-keys.env

   # Anyone on the team can decrypt
   age -d -i ~/.config/age/identity.txt api-keys.age

4. ENCRYPTED CLIPBOARD
   # macOS
   pbpaste | age -r age1recipient... -a | pbcopy
   pbpaste | age -d -i key.txt

   # Linux (xclip)
   xclip -o | age -r age1recipient... -a | xclip
   xclip -o | age -d -i key.txt

5. ENCRYPT TO GITHUB USER
   # Encrypt using someone's GitHub SSH keys
   curl -s https://github.com/username.keys | \
     age -R - -o message.age secret.txt

   # Great for one-off secure sharing
   # Verify keys match the person you expect!

6. SOPS INTEGRATION
   # Mozilla SOPS uses age for config file encryption
   # .sops.yaml
   creation_rules:
     - path_regex: \.enc\.yaml$
       age: "age1recipient1...,age1recipient2..."

   # Encrypt
   sops -e secrets.yaml > secrets.enc.yaml

   # Edit in place
   sops secrets.enc.yaml

   # Decrypt
   sops -d secrets.enc.yaml

7. PASSWORD MANAGER BACKUP
   # Encrypt your password database
   age -p -o keepass-backup.kdbx.age passwords.kdbx
   # Use a strong passphrase different from your master password
EOF
}

cmd_plugins() {
cat << 'EOF'
AGE PLUGINS & ECOSYSTEM
=========================

age supports a plugin system for extending encryption capabilities.

OFFICIAL PLUGINS:

  age-plugin-yubikey
    Encrypt to YubiKey PIV slot.
    Install: go install filippo.io/age/cmd/age-plugin-yubikey@latest
    Setup:   age-plugin-yubikey
    Usage:   age -r age1yubikey1... -o secret.age plaintext.txt
    Decrypt: age -d -i yubikey-identity.txt secret.age (tap YubiKey)

COMMUNITY PLUGINS:

  age-plugin-tpm
    Use TPM 2.0 hardware for key storage.
    Keys never leave the TPM chip.

  age-plugin-se (Apple Secure Enclave)
    Use iPhone/Mac Secure Enclave for key storage.
    Keys are hardware-bound and non-exportable.

  age-plugin-fido2-hmac
    Use FIDO2 hardware keys (YubiKey, SoloKeys).

RELATED TOOLS:

  rage (Rust implementation)
    100% compatible with age.
    Install: cargo install rage
    Commands: rage, rage-keygen (same flags as age)
    Sometimes faster for large files.

  kage (Kotlin/JVM implementation)
    For Java/Android integration.

  wage (WASM implementation)
    Run age in the browser.

  passage (password-store + age)
    Drop-in replacement for pass, using age instead of GPG.
    Install: brew install passage
    Usage:   passage insert email/gmail
             passage show email/gmail

  sops (Mozilla)
    Encrypt YAML/JSON/ENV config files.
    Uses age as encryption backend.
    Essential for GitOps and Kubernetes secrets.

  git-crypt alternative
    Use age + git hooks for encrypted files in repos.
    Or use sops for structured config files.
EOF
}

cmd_security() {
cat << 'EOF'
SECURITY CONSIDERATIONS
========================

1. KEY COMPROMISE
   If your secret key is compromised:
   - All files encrypted to that key are compromised
   - Generate new key pair immediately
   - Re-encrypt sensitive files with new key
   - There is no key revocation in age (by design)

   Mitigation:
   - Use hardware keys (YubiKey) for high-value secrets
   - Encrypt to multiple recipients (if one key leaks, re-encrypt with others)
   - Rotate keys periodically

2. FORWARD SECRECY
   age does NOT provide forward secrecy.
   If your key is compromised, past encrypted files can be decrypted.
   This is inherent to file encryption (vs. session encryption like TLS).

   For forward secrecy, use Signal/TLS/SSH for communication.
   Use age for data at rest.

3. AUTHENTICATION
   age provides confidentiality, NOT authentication.
   age does NOT sign files — you don't know WHO encrypted something.

   If you need authentication:
   - Use minisign/signify for signatures
   - Or use age + SSH signatures together
   - Or use GPG (which combines encryption + signing)

4. PASSPHRASE STRENGTH
   For passphrase-encrypted files:
   - Minimum 20 characters recommended
   - Use a passphrase, not a password
   - scrypt protects against brute force, but not weak passphrases
   - Consider using a password manager to generate

5. MEMORY SAFETY
   age (Go) and rage (Rust) are memory-safe.
   Secret keys are not zeroed from memory after use (Go limitation).
   For highest security, use rage (Rust) which zeros secrets.

6. FILE INTEGRITY
   age provides authenticated encryption (ChaCha20-Poly1305).
   Tampered ciphertext will fail to decrypt.
   The header is also authenticated (HMAC-SHA-256).

THREAT MODEL:
  age protects against:
    ✓ Unauthorized file access
    ✓ Data breaches (encrypted data is useless)
    ✓ Tampering (authenticated encryption)
    ✓ Cloud provider snooping

  age does NOT protect against:
    ✗ Key compromise
    ✗ Rubber-hose cryptanalysis
    ✗ Compromised endpoint (malware on your machine)
    ✗ Identifying who encrypted a file

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
age - Simple, Modern File Encryption Reference

Commands:
  intro       Overview, philosophy, and comparison with GPG
  keygen      Key generation, SSH keys, and key management
  encrypt     Encryption operations and pipe patterns
  decrypt     Decryption operations and error handling
  recipes     Practical recipes (backups, git, team sharing, SOPS)
  plugins     YubiKey, TPM, rage, passage, sops ecosystem
  security    Threat model, key compromise, authentication limits

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)     cmd_intro ;;
  keygen)    cmd_keygen ;;
  encrypt)   cmd_encrypt ;;
  decrypt)   cmd_decrypt ;;
  recipes)   cmd_recipes ;;
  plugins)   cmd_plugins ;;
  security)  cmd_security ;;
  help|*)    show_help ;;
esac
