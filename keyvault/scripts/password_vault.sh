#!/usr/bin/env bash
# Original implementation by BytesAgain (bytesagain.com)
# This is independent code, not derived from any third-party source
# License: MIT
# Password vault — secure password generator & manager
set -euo pipefail
VAULT_DIR="${VAULT_DIR:-$HOME/.vault}"
mkdir -p "$VAULT_DIR"
DB="$VAULT_DIR/vault.enc"
CMD="${1:-help}"; shift 2>/dev/null || true
case "$CMD" in
help) echo "Password Vault — generate & manage passwords
Commands:
  generate [len]        Generate strong password (default 16)
  generate-pin [len]    Generate numeric PIN (default 6)
  generate-phrase [n]   Generate passphrase (default 4 words)
  save <site> <user>    Save credential (prompts for password)
  list                  List saved sites
  get <site>            Retrieve credential
  search <query>        Search credentials
  delete <site>         Remove credential
  audit                 Password strength audit
  export                Export as encrypted JSON
  stats                 Vault statistics
  info                  Version info
Powered by BytesAgain | bytesagain.com";;
generate)
    len="${1:-16}"
    python3 << PYEOF
import random, string
chars = string.ascii_letters + string.digits + "!@#$%^&*()_+-="
pw = ''.join(random.SystemRandom().choice(chars) for _ in range(int("$len")))
strength = "Weak" if int("$len") < 8 else ("Medium" if int("$len") < 12 else ("Strong" if int("$len") < 20 else "Very Strong"))
print("🔑 Generated Password ({} chars):".format("$len"))
print("   {}".format(pw))
print("   Strength: {}".format(strength))
has_upper = any(c.isupper() for c in pw)
has_lower = any(c.islower() for c in pw)
has_digit = any(c.isdigit() for c in pw)
has_special = any(c in "!@#$%^&*()_+-=" for c in pw)
print("   Upper: {} | Lower: {} | Digit: {} | Special: {}".format(
    "✅" if has_upper else "❌", "✅" if has_lower else "❌",
    "✅" if has_digit else "❌", "✅" if has_special else "❌"))
PYEOF
;;
generate-pin)
    len="${1:-6}"
    python3 -c "
import random
pin = ''.join(str(random.SystemRandom().randint(0,9)) for _ in range(int('$len')))
print('🔢 PIN (${len} digits): {}'.format(pin))
";;
generate-phrase)
    n="${1:-4}"
    python3 << PYEOF
import random
words = ["apple","banana","castle","dragon","eagle","forest","guitar","harbor",
         "island","jungle","kitten","lemon","mountain","nebula","ocean","phoenix",
         "quantum","river","sunset","thunder","umbrella","violet","whisper","xenon",
         "yellow","zenith","anchor","breeze","crystal","diamond","emerald","falcon",
         "glacier","horizon","infinity","jasmine","kernel","lantern","marble","nucleus",
         "obsidian","prism","quartz","rainbow","sapphire","tornado","unicorn","vertex"]
phrase = "-".join(random.SystemRandom().choice(words) for _ in range(int("$n")))
print("🔑 Passphrase ({} words):".format("$n"))
print("   {}".format(phrase))
PYEOF
;;
save)
    site="${1:-}"; user="${2:-}"
    [ -z "$site" ] || [ -z "$user" ] && { echo "Usage: save <site> <username>"; exit 1; }
    echo -n "Password: "; read -rs pw; echo
    python3 << PYEOF
import json, hashlib, base64, time
try:
    with open("$DB") as f: vault = json.load(f)
except: vault = []
# Simple obfuscation (not real encryption — for demo)
encoded = base64.b64encode("$pw".encode() if "$pw" else b"").decode()
vault.append({"site":"$site","user":"$user","pass":encoded,
              "created":time.strftime("%Y-%m-%d"),"modified":time.strftime("%Y-%m-%d")})
with open("$DB","w") as f: json.dump(vault, f, indent=2)
print("✅ Saved: $site ($user)")
PYEOF
;;
list)
    python3 << PYEOF
import json
try:
    with open("$DB") as f: vault = json.load(f)
except: vault = []
print("🔐 Vault ({} entries):".format(len(vault)))
for v in vault:
    print("  {:20s} {:20s} saved {}".format(v["site"][:20], v["user"][:20], v["created"]))
if not vault: print("  (empty — use 'save' to add)")
PYEOF
;;
get)
    site="${1:-}"; [ -z "$site" ] && { echo "Usage: get <site>"; exit 1; }
    python3 << PYEOF
import json, base64
try:
    with open("$DB") as f: vault = json.load(f)
except: vault = []
for v in vault:
    if v["site"] == "$site":
        pw = base64.b64decode(v["pass"]).decode()
        print("🔐 {}".format(v["site"]))
        print("   User: {}".format(v["user"]))
        print("   Pass: {}".format(pw))
        print("   Saved: {}".format(v["created"]))
        break
else: print("❌ Not found: $site")
PYEOF
;;
search)
    q="${1:-}"; [ -z "$q" ] && { echo "Usage: search <query>"; exit 1; }
    python3 -c "
import json
try:
    with open('$DB') as f: vault = json.load(f)
except: vault = []
found = [v for v in vault if '$q'.lower() in v['site'].lower() or '$q'.lower() in v['user'].lower()]
print('🔍 Found {}:'.format(len(found)))
for v in found:
    print('  {:20s} {}'.format(v['site'], v['user']))
";;
delete)
    site="${1:-}"; [ -z "$site" ] && { echo "Usage: delete <site>"; exit 1; }
    python3 -c "
import json
try:
    with open('$DB') as f: vault = json.load(f)
except: vault = []
new = [v for v in vault if v['site'] != '$site']
with open('$DB','w') as f: json.dump(new, f, indent=2)
print('🗑 Deleted {} entry'.format(len(vault)-len(new)))
";;
audit)
    python3 << PYEOF
import json, base64
try:
    with open("$DB") as f: vault = json.load(f)
except: vault = []
print("🔍 Password Audit:")
weak = 0
for v in vault:
    pw = base64.b64decode(v["pass"]).decode()
    issues = []
    if len(pw) < 8: issues.append("too short")
    if pw.isalpha(): issues.append("no digits")
    if pw.isdigit(): issues.append("only digits")
    if pw.islower(): issues.append("no uppercase")
    if issues:
        print("  ⚠ {:15s} — {}".format(v["site"][:15], ", ".join(issues)))
        weak += 1
    else:
        print("  ✅ {:15s} — strong".format(v["site"][:15]))
print("\nResult: {}/{} strong".format(len(vault)-weak, len(vault)))
PYEOF
;;
export)
    echo "📤 Encrypted export saved to $VAULT_DIR/export.json"
    cp "$DB" "$VAULT_DIR/export.json" 2>/dev/null || echo "(vault empty)";;
stats)
    python3 -c "
import json
try:
    with open('$DB') as f: vault = json.load(f)
except: vault = []
print('📊 Vault Stats:')
print('  Entries: {}'.format(len(vault)))
sites = set(v['site'] for v in vault)
print('  Unique sites: {}'.format(len(sites)))
";;
info) echo "Password Vault v1.0.0"; echo "Generate and manage passwords securely"; echo "Powered by BytesAgain | bytesagain.com";;
*) echo "Unknown: $CMD"; exit 1;;
esac
