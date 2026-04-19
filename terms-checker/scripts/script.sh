#!/usr/bin/env bash
# terms-checker — Analyze and check Terms of Service documents
set -euo pipefail

cmd_check() {
    local file="${1:-}"
    [[ -z "$file" || ! -f "$file" ]] && { echo "Usage: check <terms-file.txt>"; exit 1; }
    python3 - "$file" << 'PYEOF'
import sys
file = sys.argv[1]
content = open(file).read().lower()

sections = [
    ("Acceptance of terms",          ["acceptance", "agree to", "by using"]),
    ("Description of service",       ["service", "platform", "product description"]),
    ("User accounts",                ["account", "registration", "username", "password"]),
    ("Prohibited activities",        ["prohibited", "not allowed", "you may not"]),
    ("Intellectual property",        ["intellectual property", "copyright", "trademark", "ownership"]),
    ("Termination clause",           ["termination", "terminate", "suspend"]),
    ("Limitation of liability",      ["limitation of liability", "not liable", "maximum liability"]),
    ("Disclaimer of warranties",     ["disclaimer", "as is", "no warranty"]),
    ("Governing law",                ["governing law", "jurisdiction", "dispute"]),
    ("Privacy policy reference",     ["privacy policy", "privacy"]),
    ("Modification of terms",        ["modify", "update these terms", "changes to these terms"]),
    ("Contact information",          ["contact us", "contact:", "support@"]),
]

print(f"Terms of Service Check: {file}")
print("=" * 55)
passed = 0
for name, kws in sections:
    found = any(k in content for k in kws)
    status = "✅" if found else "❌"
    print(f"  {status} {name}")
    if found:
        passed += 1

pct = passed * 100 // len(sections)
print(f"\nCompleteness: {passed}/{len(sections)} ({pct}%)")
if pct >= 80:
    print("✅ Terms of Service is comprehensive.")
elif pct >= 60:
    print("⚠️  Terms of Service is adequate but missing some sections.")
else:
    print("❌ Terms of Service is incomplete. Add missing sections.")
PYEOF
}

cmd_unfair() {
    local file="${1:-}"
    [[ -z "$file" || ! -f "$file" ]] && { echo "Usage: unfair <terms-file.txt>"; exit 1; }
    python3 - "$file" << 'PYEOF'
import sys, re
file = sys.argv[1]
content = open(file).read().lower()

unfair_patterns = [
    ("Unilateral modification without notice", ["may change at any time", "modify without notice", "sole discretion"]),
    ("Binding arbitration / class action waiver", ["binding arbitration", "waive.*class action", "class action waiver"]),
    ("Unlimited liability waiver", ["not liable for any", "no liability whatsoever", "exempt from all liability"]),
    ("Broad IP rights grab", ["assign all rights", "irrevocable license", "perpetual worldwide license to use"]),
    ("Auto-renewal trap", ["auto-renew", "automatically renew", "unless cancelled"]),
    ("One-sided termination", ["terminate at any time", "suspend without notice", "discretion to terminate"]),
    ("Retroactive changes", ["apply to past", "retroactively", "effective immediately without notice"]),
    ("Data sale without opt-out", ["sell your data", "share with advertisers", "third-party marketing"]),
]

print(f"Unfair Clause Detection: {file}")
print("=" * 55)
found_issues = []
for name, patterns in unfair_patterns:
    detected = [p for p in patterns if re.search(p.replace(".*", ".*?"), content)]
    if detected:
        found_issues.append((name, detected))
        print(f"  ⚠️  {name}")
        print(f"      Matched: '{detected[0]}'")
    else:
        print(f"  ✅ {name} — not detected")

print(f"\nPotential issues found: {len(found_issues)}")
if found_issues:
    print("\nRecommendation: Review flagged clauses for fairness.")
    print("Consider consulting a lawyer before accepting these terms.")
else:
    print("✅ No major unfair clauses detected.")
PYEOF
}

cmd_summary() {
    local file="${1:-}"
    [[ -z "$file" || ! -f "$file" ]] && { echo "Usage: summary <terms-file.txt>"; exit 1; }
    python3 - "$file" << 'PYEOF'
import sys, re
file = sys.argv[1]
content = open(file).read()
lower = content.lower()

print(f"TL;DR — Terms of Service Summary")
print(f"File: {file}")
print("=" * 55)

# Extract key info
# Data selling
if any(x in lower for x in ["sell your data", "sell your information"]):
    print("📛 Data: MAY sell your personal data to third parties")
elif any(x in lower for x in ["do not sell", "not sell your"]):
    print("✅ Data: Does NOT sell your personal data")
else:
    print("❓ Data: Data selling policy unclear")

# Arbitration
if "arbitration" in lower:
    print("⚠️  Disputes: Requires binding arbitration (no court cases)")
else:
    print("✅ Disputes: Standard court dispute resolution")

# Auto-renewal
if any(x in lower for x in ["auto-renew", "automatically renew"]):
    print("⚠️  Billing: Auto-renewal — remember to cancel")
else:
    print("✅ Billing: No auto-renewal mentioned")

# Account termination
if any(x in lower for x in ["terminate at any time", "suspend without notice"]):
    print("⚠️  Account: Can be terminated/suspended without notice")
else:
    print("✅ Account: Termination requires notice or cause")

# IP rights
if any(x in lower for x in ["assign all", "irrevocable license", "perpetual license"]):
    print("⚠️  Content: Broad license granted over your content")
else:
    print("✅ Content: You retain ownership of your content")

# Governing law
m = re.search(r'govern(?:ed|ing) by the laws? of ([^.]+)\.', lower)
if m:
    print(f"📍 Law: Governed by {m.group(1).strip().title()}")
else:
    print("❓ Law: Governing law not clearly specified")

# Age restriction
if "13" in lower or "18" in lower:
    age = "18" if "18" in lower else "13"
    print(f"👤 Age: Minimum age requirement: {age}+")
else:
    print("❓ Age: No age restriction mentioned")

print("\n[Auto-generated summary — read the full terms for complete details]")
PYEOF
}

cmd_score() {
    local file="${1:-}"
    [[ -z "$file" || ! -f "$file" ]] && { echo "Usage: score <terms-file.txt>"; exit 1; }
    python3 - "$file" << 'PYEOF'
import sys, re
file = sys.argv[1]
content = open(file).read().lower()

score = 50  # baseline
details = []

# Positive factors
positives = [
    (10, "does not sell", "Does not sell user data"),
    (8,  "right to delete", "Provides right to delete data"),
    (8,  "30 days notice", "Provides 30-day notice for changes"),
    (7,  "data portability", "Offers data portability"),
    (7,  "opt-out", "Provides opt-out options"),
    (5,  "plain language", "Uses plain language"),
    (5,  "open source", "Uses open source / transparent"),
]
# Negative factors
negatives = [
    (-15, "binding arbitration", "Requires binding arbitration"),
    (-12, "class action waiver", "Waives class action rights"),
    (-10, "sell your data", "Sells user data to third parties"),
    (-10, "sole discretion", "Has many 'sole discretion' clauses"),
    (-8,  "auto-renew", "Auto-renewal without easy cancellation"),
    (-7,  "irrevocable license", "Claims broad irrevocable license to content"),
    (-5,  "no liability whatsoever", "Excessive liability disclaimers"),
]

for pts, kw, desc in positives:
    if kw in content:
        score += pts
        details.append(f"  +{pts:2d}  ✅ {desc}")

for pts, kw, desc in negatives:
    if kw in content:
        score += pts
        details.append(f"  {pts:3d}  ❌ {desc}")

score = max(0, min(100, score))

print(f"Terms Fairness Score: {file}")
print("=" * 50)
for d in details:
    print(d)
print(f"\n{'='*50}")
print(f"SCORE: {score}/100  ", end="")
if score >= 80:
    print("🟢 User-Friendly")
elif score >= 60:
    print("🟡 Average")
elif score >= 40:
    print("🟠 Concerning")
else:
    print("🔴 User-Hostile")
print(f"\nHigher score = more user-friendly terms")
PYEOF
}

cmd_compare() {
    local file1="${1:-}"; local file2="${2:-}"
    [[ -z "$file1" || -z "$file2" ]] && { echo "Usage: compare <old-terms.txt> <new-terms.txt>"; exit 1; }
    [[ ! -f "$file1" ]] && { echo "❌ File not found: $file1"; exit 1; }
    [[ ! -f "$file2" ]] && { echo "❌ File not found: $file2"; exit 1; }
    python3 - "$file1" "$file2" << 'PYEOF'
import sys, difflib
f1, f2 = sys.argv[1], sys.argv[2]
old = open(f1).readlines()
new = open(f2).readlines()

diff = list(difflib.unified_diff(old, new, fromfile=f"Old: {f1}", tofile=f"New: {f2}", lineterm=""))

if not diff:
    print("✅ No differences found between the two documents.")
else:
    added = sum(1 for l in diff if l.startswith('+') and not l.startswith('+++'))
    removed = sum(1 for l in diff if l.startswith('-') and not l.startswith('---'))
    print(f"Changes: +{added} lines added, -{removed} lines removed\n")
    for line in diff[:80]:
        if line.startswith('+') and not line.startswith('+++'):
            print(f"  ➕ {line[1:].rstrip()}")
        elif line.startswith('-') and not line.startswith('---'):
            print(f"  ➖ {line[1:].rstrip()}")
        elif line.startswith('@@'):
            print(f"\n  {line.rstrip()}")
    if len(diff) > 80:
        print(f"\n  ... ({len(diff)-80} more lines)")
PYEOF
}

cmd_help() {
    cat << 'EOF'
terms-checker — Analyze and check Terms of Service documents

Commands:
  check    <file>              Check ToS completeness (12 required sections)
  unfair   <file>              Detect potentially unfair clauses
  summary  <file>              Generate TL;DR summary for users
  score    <file>              Score ToS fairness (0-100)
  compare  <old> <new>         Compare two versions of ToS
  help                         Show this help

Examples:
  bash scripts/script.sh check terms.txt
  bash scripts/script.sh unfair terms-of-service.txt
  bash scripts/script.sh summary tos.txt
  bash scripts/script.sh score terms.txt
  bash scripts/script.sh compare old-tos.txt new-tos.txt

Powered by BytesAgain | bytesagain.com
EOF
}

case "${1:-help}" in
    check)   shift; cmd_check "$@" ;;
    unfair)  shift; cmd_unfair "$@" ;;
    summary) shift; cmd_summary "$@" ;;
    score)   shift; cmd_score "$@" ;;
    compare) shift; cmd_compare "$@" ;;
    help|*)  cmd_help ;;
esac
