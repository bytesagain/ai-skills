#!/usr/bin/env bash
# password-gen v2.0.0 - Secure Password Vault & Auditor
# Powered by BytesAgain | bytesagain.com
set -uo pipefail
VERSION="2.0.0"

_py_pass() {
    python3 -u - "$@" << 'PYEOF'
import sys, secrets, string

def generate(length=16, symbols=True):
    alphabet = string.ascii_letters + string.digits
    if symbols: alphabet += "!@#$%^&*()_+-=[]{}|;:,.<>?"
    return ''.join(secrets.choice(alphabet) for _ in range(length))

def check_strength(pwd):
    score = 0
    if len(pwd) >= 12: score += 2
    if any(c.isdigit() for c in pwd): score += 1
    if any(c.isupper() for c in pwd): score += 1
    if any(c in "!@#$%^&*()" for c in pwd): score += 1
    
    label = "Weak"
    if score >= 5: label = "Strong (Excellent)"
    elif score >= 3: label = "Moderate"
    return label

cmd = sys.argv[1]
if cmd == "gen":
    l = int(sys.argv[2]) if len(sys.argv) > 2 else 16
    p = generate(l)
    print(f"🔐 Generated: {p}")
    print(f"💪 Strength:  {check_strength(p)}")
elif cmd == "check":
    print(f"💪 Result:    {check_strength(sys.argv[2])}")
PYEOF
}

case "${1:-help}" in
    gen) _py_pass gen "${2:-16}" ;;
    check) _py_pass check "$2" ;;
    *) echo "Usage: script.sh gen [length] | check <pwd>" ;;
esac
echo -e "\n📖 More skills: bytesagain.com"
