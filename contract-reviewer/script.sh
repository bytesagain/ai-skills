#!/usr/bin/env bash
# Contract Reviewer - Analyze, risk-score, and summarize legal contracts
# Powered by BytesAgain | bytesagain.com
set -euo pipefail

SKILL_NAME="contract-reviewer"
VERSION="1.0.0"

usage() {
  cat <<'EOF'
Contract Reviewer - Legal contract analysis tool

Usage: script.sh <command> [options]

Commands:
  analyze   <file>              Full clause-by-clause analysis
  risk      <file>              Risk scoring (0-100) with findings
  compare   <file1> <file2>     Compare two contracts for differences
  summary   <file>              Executive summary of contract
  checklist <file>              Due diligence checklist validation
  help                          Show this help

Examples:
  script.sh analyze contract.txt
  script.sh risk agreement.pdf.txt
  script.sh compare v1.txt v2.txt
  script.sh summary nda.txt
  script.sh checklist lease.txt
EOF
}

require_file() {
  local f="$1"
  if [[ ! -f "$f" ]]; then
    echo "ERROR: File not found: $f" >&2
    exit 1
  fi
}

cmd_analyze() {
  local file="${1:-}"
  if [[ -z "$file" ]]; then echo "Usage: analyze <file>"; exit 1; fi
  require_file "$file"
  echo "=== CONTRACT ANALYSIS: $file ==="
  echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')"
  echo ""
  python3 << 'PYEOF'
import sys, re, os

file_path = sys.argv[1] if len(sys.argv) > 1 else ""

# Read from environment since heredoc can't pass args easily
import os
file_path = os.environ.get("_CR_FILE", "")

if not file_path or not os.path.isfile(file_path):
    print("ERROR: file not readable")
    sys.exit(1)

with open(file_path, "r", encoding="utf-8", errors="replace") as f:
    text = f.read()

words = len(text.split())
chars = len(text)
lines = text.count("\n")

print(f"📄 Document Stats")
print(f"   Words: {words:,}")
print(f"   Characters: {chars:,}")
print(f"   Lines: {lines:,}")
print("")

# Clause detection patterns
clauses = {
    "Parties":           r"(party|parties|between|hereinafter|undersigned)",
    "Term / Duration":   r"(term|duration|period|expires?|effective\s+date|commencement)",
    "Payment / Fees":    r"(payment|fee|invoice|compensation|salary|remuneration|price|cost)",
    "Termination":       r"(terminat|cancel|end\s+of\s+agreement|notice\s+period|exit\s+clause)",
    "Confidentiality":   r"(confidential|non-disclosure|nda|proprietary|trade\s+secret)",
    "Liability":         r"(liabilit|indemnif|hold\s+harmless|limitation\s+of\s+liability|damages)",
    "Intellectual Property": r"(intellectual\s+property|copyright|patent|trademark|ip\s+rights|ownership)",
    "Dispute Resolution":r"(arbitrat|mediat|litigation|jurisdiction|governing\s+law|dispute)",
    "Force Majeure":     r"(force\s+majeure|act\s+of\s+god|pandemic|beyond.*control)",
    "Assignment":        r"(assign|transfer\s+rights|novation|delegate)",
    "Warranties":        r"(warrant|represent|guarantee|as-is|fitness\s+for)",
    "Amendment":         r"(amend|modif|supplement|addendum|vary|change\s+to\s+this\s+agreement)",
}

print("📋 Detected Clauses")
found = []
missing = []
for clause, pattern in clauses.items():
    matches = re.findall(pattern, text, re.IGNORECASE)
    if matches:
        found.append(clause)
        print(f"   ✅ {clause} ({len(matches)} references)")
    else:
        missing.append(clause)
        print(f"   ❌ {clause} — NOT FOUND")

print("")
print(f"📊 Coverage: {len(found)}/{len(clauses)} standard clauses detected")

if missing:
    print("")
    print("⚠️  Missing Clauses (recommend adding):")
    for m in missing:
        print(f"   • {m}")

# Obligation extraction
obligations = re.findall(r"(?:shall|must|will|agrees? to|is required to)[^.]{10,80}\.", text, re.IGNORECASE)
print("")
print(f"📌 Key Obligations Found: {len(obligations)}")
for i, ob in enumerate(obligations[:5], 1):
    ob_clean = re.sub(r"\s+", " ", ob).strip()
    print(f"   {i}. {ob_clean[:120]}{'...' if len(ob_clean)>120 else ''}")
if len(obligations) > 5:
    print(f"   ... and {len(obligations)-5} more")

# Date extraction
dates = re.findall(r"\b(?:\d{1,2}[/-]\d{1,2}[/-]\d{2,4}|\d{4}-\d{2}-\d{2}|(?:January|February|March|April|May|June|July|August|September|October|November|December)\s+\d{1,2},?\s+\d{4})\b", text)
if dates:
    print("")
    print(f"📅 Dates Referenced: {len(dates)}")
    for d in list(set(dates))[:5]:
        print(f"   • {d}")

print("")
print("✅ Analysis complete.")
PYEOF
}

cmd_risk() {
  local file="${1:-}"
  if [[ -z "$file" ]]; then echo "Usage: risk <file>"; exit 1; fi
  require_file "$file"
  echo "=== RISK ASSESSMENT: $file ==="
  echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')"
  echo ""
  export _CR_FILE="$file"
  python3 << 'PYEOF'
import re, os, sys

file_path = os.environ.get("_CR_FILE", "")
if not file_path or not os.path.isfile(file_path):
    print("ERROR: file not readable"); sys.exit(1)

with open(file_path, "r", encoding="utf-8", errors="replace") as f:
    text = f.read()

risk_score = 0
findings = []

# High-risk patterns
high_risk = [
    (r"unlimited\s+liabilit", "Unlimited liability clause detected", 20),
    (r"sole\s+discretion", "Unilateral sole discretion rights granted", 15),
    (r"irrevocable", "Irrevocable rights or obligations present", 12),
    (r"perpetual", "Perpetual obligations or licenses detected", 12),
    (r"indemnif.*all.*claims", "Broad indemnification — 'all claims' language", 18),
    (r"auto.{0,10}renew", "Auto-renewal clause — cancellation risk", 8),
    (r"liquidated\s+damages", "Liquidated damages clause present", 10),
    (r"non-compet", "Non-compete clause detected", 14),
    (r"exclusiv", "Exclusivity obligations present", 8),
    (r"waive.*right", "Rights waiver language present", 10),
]

# Medium-risk patterns
medium_risk = [
    (r"may\s+terminat.*without\s+cause", "Termination without cause allowed", 6),
    (r"change.*terms.*notice", "Unilateral terms change with notice", 5),
    (r"third.party.*assign", "Third-party assignment permitted", 5),
    (r"no\s+warrant", "No warranties / as-is clause", 4),
    (r"consequential.*damages.*disclaim", "Consequential damages disclaimed", 4),
    (r"force\s+majeure", "Force majeure — check scope definition", 3),
]

# Protective clauses (reduce risk)
protective = [
    (r"mutual.*terminat", "Mutual termination rights", -3),
    (r"limitation.*liabilit", "Liability cap present", -5),
    (r"governing\s+law", "Governing law specified", -2),
    (r"dispute.*arbitrat", "Arbitration clause — faster resolution", -2),
    (r"notice.*period.*\d+\s+days", "Defined notice period", -2),
]

print("🔴 HIGH RISK FINDINGS:")
high_count = 0
for pattern, desc, weight in high_risk:
    if re.search(pattern, text, re.IGNORECASE):
        risk_score += weight
        findings.append((weight, desc))
        high_count += 1
        print(f"   ⛔ [{weight:+d} pts] {desc}")
if high_count == 0:
    print("   None detected ✅")

print("")
print("🟡 MEDIUM RISK FINDINGS:")
med_count = 0
for pattern, desc, weight in medium_risk:
    if re.search(pattern, text, re.IGNORECASE):
        risk_score += weight
        findings.append((weight, desc))
        med_count += 1
        print(f"   ⚠️  [{weight:+d} pts] {desc}")
if med_count == 0:
    print("   None detected ✅")

print("")
print("🟢 PROTECTIVE CLAUSES:")
prot_count = 0
for pattern, desc, weight in protective:
    if re.search(pattern, text, re.IGNORECASE):
        risk_score += weight
        prot_count += 1
        print(f"   ✅ [{weight:+d} pts] {desc}")
if prot_count == 0:
    print("   None detected ⚠️")

risk_score = max(0, min(100, risk_score))

print("")
print("=" * 50)
if risk_score >= 60:
    level = "🔴 HIGH RISK"
    rec = "Do NOT sign without legal review. Significant risks identified."
elif risk_score >= 35:
    level = "🟡 MEDIUM RISK"
    rec = "Review flagged clauses carefully before signing."
elif risk_score >= 15:
    level = "🟠 LOW-MEDIUM RISK"
    rec = "Minor concerns. Negotiate flagged items if possible."
else:
    level = "🟢 LOW RISK"
    rec = "Contract appears balanced. Standard review recommended."

print(f"📊 RISK SCORE: {risk_score}/100")
print(f"📈 RISK LEVEL: {level}")
print(f"💡 RECOMMENDATION: {rec}")
PYEOF
}

cmd_compare() {
  local file1="${1:-}" file2="${2:-}"
  if [[ -z "$file1" || -z "$file2" ]]; then echo "Usage: compare <file1> <file2>"; exit 1; fi
  require_file "$file1"
  require_file "$file2"
  echo "=== CONTRACT COMPARISON ==="
  echo "File 1: $file1"
  echo "File 2: $file2"
  echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')"
  echo ""
  export _CR_F1="$file1" _CR_F2="$file2"
  python3 << 'PYEOF'
import os, re, difflib

f1 = os.environ.get("_CR_F1","")
f2 = os.environ.get("_CR_F2","")

with open(f1,"r",encoding="utf-8",errors="replace") as fh: text1 = fh.read()
with open(f2,"r",encoding="utf-8",errors="replace") as fh: text2 = fh.read()

w1, w2 = len(text1.split()), len(text2.split())
print(f"📄 Size comparison: File1={w1:,} words | File2={w2:,} words | Δ={w2-w1:+,} words")
print("")

lines1 = text1.splitlines()
lines2 = text2.splitlines()
diff = list(difflib.unified_diff(lines1, lines2, lineterm="", n=0))
adds = sum(1 for l in diff if l.startswith("+") and not l.startswith("+++"))
dels = sum(1 for l in diff if l.startswith("-") and not l.startswith("---"))
print(f"📊 Line-level changes: +{adds} added, -{dels} removed")
print("")

# Clause-by-clause comparison
clauses = {
    "Term":           r"(term|duration|expires?)",
    "Payment":        r"(payment|fee|compensation|price)",
    "Termination":    r"(terminat|cancel)",
    "Liability":      r"(liabilit|indemnif)",
    "Confidentiality":r"(confidential|nda)",
    "IP Rights":      r"(intellectual\s+property|copyright|patent)",
    "Governing Law":  r"(governing\s+law|jurisdiction)",
    "Warranties":     r"(warrant|represent|guarantee)",
}

print("📋 Clause Presence Comparison:")
print(f"{'Clause':<22} {'File1':<10} {'File2':<10} {'Status'}")
print("-" * 55)
for clause, pattern in clauses.items():
    in1 = bool(re.search(pattern, text1, re.IGNORECASE))
    in2 = bool(re.search(pattern, text2, re.IGNORECASE))
    s1 = "✅ Yes" if in1 else "❌ No"
    s2 = "✅ Yes" if in2 else "❌ No"
    if in1 == in2:
        status = "Same"
    elif in2 and not in1:
        status = "⬆️ Added in v2"
    else:
        status = "⬇️ Removed in v2"
    print(f"{clause:<22} {s1:<10} {s2:<10} {status}")

# Similarity
seq = difflib.SequenceMatcher(None, text1, text2)
sim = seq.ratio() * 100
print("")
print(f"📐 Text Similarity: {sim:.1f}%")
if sim > 90:
    print("   → Documents are nearly identical")
elif sim > 70:
    print("   → Documents have minor differences")
elif sim > 40:
    print("   → Documents have significant differences")
else:
    print("   → Documents are substantially different")
PYEOF
}

cmd_summary() {
  local file="${1:-}"
  if [[ -z "$file" ]]; then echo "Usage: summary <file>"; exit 1; fi
  require_file "$file"
  echo "=== CONTRACT EXECUTIVE SUMMARY: $file ==="
  echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')"
  echo ""
  export _CR_FILE="$file"
  python3 << 'PYEOF'
import os, re

file_path = os.environ.get("_CR_FILE", "")
with open(file_path, "r", encoding="utf-8", errors="replace") as f:
    text = f.read()

# Extract contract type
contract_types = {
    "NDA / Non-Disclosure Agreement": r"non.disclosure|confidentialit",
    "Employment Agreement":           r"employ|worker|staff|salary",
    "Service Agreement":              r"service\s+agreement|statement\s+of\s+work|sow",
    "Lease Agreement":                r"lease|landlord|tenant|rent",
    "Purchase Agreement":             r"purchase|sale\s+of\s+goods|buyer|seller",
    "License Agreement":              r"licen[sc]e\s+agreement|licensed\s+to|licensee",
    "Partnership Agreement":          r"partnership|joint\s+venture",
    "Software / SaaS Agreement":      r"software|saas|subscription|api\s+access",
}
detected_type = "General Contract"
for ctype, pattern in contract_types.items():
    if re.search(pattern, text, re.IGNORECASE):
        detected_type = ctype
        break

print(f"📄 Contract Type: {detected_type}")
print("")

# Extract parties
party_patterns = [
    r"between\s+([A-Z][A-Za-z\s,\.]{3,50})\s+(?:and|&)\s+([A-Z][A-Za-z\s,\.]{3,50})",
    r"([A-Z][A-Za-z\s]+(?:LLC|Inc|Ltd|Corp|GmbH|Co\.))",
]
parties = []
m = re.search(party_patterns[0], text)
if m:
    parties = [m.group(1).strip(), m.group(2).strip()]
else:
    parties = re.findall(party_patterns[1], text)[:2]

if parties:
    print("👥 Parties Involved:")
    for p in parties[:3]:
        print(f"   • {p}")
    print("")

# Key dates
dates = re.findall(r"\b(?:\d{1,2}[/-]\d{1,2}[/-]\d{2,4}|\d{4}-\d{2}-\d{2}|(?:January|February|March|April|May|June|July|August|September|October|November|December)\s+\d{1,2},?\s+\d{4})\b", text)
if dates:
    unique_dates = list(dict.fromkeys(dates))
    print(f"📅 Key Dates: {', '.join(unique_dates[:4])}")
    print("")

# Payment terms
amounts = re.findall(r"(?:USD?|€|£|\$|EUR|GBP)\s*[\d,]+(?:\.\d{2})?|\d[\d,]+\s*(?:dollars?|euros?|pounds?)", text, re.IGNORECASE)
if amounts:
    print(f"💰 Financial Terms: {', '.join(list(set(amounts))[:4])}")
    print("")

# Notice period
notices = re.findall(r"(\d+)\s*(?:calendar\s+)?days?\s+(?:prior\s+)?(?:written\s+)?notice", text, re.IGNORECASE)
if notices:
    print(f"📬 Notice Period: {notices[0]} days")
    print("")

# Governing law
gov_law = re.search(r"(?:governed\s+by|laws\s+of|jurisdiction\s+of)\s+(?:the\s+)?([A-Z][A-Za-z\s]+?)(?:\.|,|\n)", text, re.IGNORECASE)
if gov_law:
    print(f"⚖️  Governing Law: {gov_law.group(1).strip()}")
    print("")

# Summary bullets
print("📝 Key Points:")
bullets = []
if re.search(r"auto.{0,10}renew", text, re.IGNORECASE):
    bullets.append("Contract includes auto-renewal — cancellation notice required")
if re.search(r"non-compet", text, re.IGNORECASE):
    bullets.append("Non-compete restrictions apply")
if re.search(r"confidential", text, re.IGNORECASE):
    bullets.append("Confidentiality obligations present")
if re.search(r"indemnif", text, re.IGNORECASE):
    bullets.append("Indemnification obligations present")
if re.search(r"limitation.*liabilit", text, re.IGNORECASE):
    bullets.append("Liability is capped / limited")
for b in bullets:
    print(f"   • {b}")
if not bullets:
    print("   • Standard contract structure, no major red flags detected")
print("")
print("✅ Summary complete. Consult a qualified attorney for legal advice.")
PYEOF
}

cmd_checklist() {
  local file="${1:-}"
  if [[ -z "$file" ]]; then echo "Usage: checklist <file>"; exit 1; fi
  require_file "$file"
  echo "=== DUE DILIGENCE CHECKLIST: $file ==="
  echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')"
  echo ""
  export _CR_FILE="$file"
  python3 << 'PYEOF'
import os, re

file_path = os.environ.get("_CR_FILE", "")
with open(file_path, "r", encoding="utf-8", errors="replace") as f:
    text = f.read()

checklist = [
    # (item, pattern, required)
    ("Parties clearly identified",          r"(between|party|parties|hereinafter)", True),
    ("Effective date specified",            r"(effective\s+date|commenc|start\s+date)", True),
    ("Contract term/duration defined",      r"(term|duration|period|expires?)", True),
    ("Payment terms specified",             r"(payment|fee|invoice|due\s+within)", True),
    ("Termination conditions defined",      r"(terminat|cancel|end\s+of)", True),
    ("Notice period specified",             r"(\d+\s+days?\s+notice|notice\s+period)", True),
    ("Confidentiality clause present",      r"(confidential|non-disclosure)", False),
    ("Liability limitation present",        r"(limitation.*liabilit|liabilit.*cap|maximum.*liabilit)", False),
    ("Indemnification clause defined",      r"(indemnif|hold\s+harmless)", False),
    ("Dispute resolution specified",        r"(arbitrat|mediat|litigation|dispute\s+resolution)", True),
    ("Governing law specified",             r"(governing\s+law|jurisdiction)", True),
    ("IP ownership addressed",              r"(intellectual\s+property|copyright|ip\s+rights|ownership)", False),
    ("Assignment rights defined",           r"(assign|transfer\s+rights)", False),
    ("Amendment procedure specified",       r"(amend|modif|supplement|written.*agreement)", False),
    ("Force majeure clause present",        r"(force\s+majeure|act\s+of\s+god)", False),
    ("Warranty provisions defined",         r"(warrant|represent|as-is|guarantee)", False),
    ("Signatures/execution block present",  r"(sign|execut|witness|signature)", True),
    ("Entire agreement clause present",     r"(entire\s+agreement|whole\s+agreement|supersedes)", False),
]

passed = 0
failed_required = []
failed_optional = []

for item, pattern, required in checklist:
    found = bool(re.search(pattern, text, re.IGNORECASE))
    mark = "✅" if found else ("❌" if required else "⚠️ ")
    req_label = "[REQUIRED]" if required else "[optional]"
    print(f"  {mark} {item:<42} {req_label}")
    if found:
        passed += 1
    elif required:
        failed_required.append(item)
    else:
        failed_optional.append(item)

total = len(checklist)
score = int(passed / total * 100)
print("")
print(f"{'='*55}")
print(f"📊 Checklist Score: {passed}/{total} items ({score}%)")

if failed_required:
    print(f"\n❌ Missing REQUIRED items ({len(failed_required)}):")
    for item in failed_required:
        print(f"   • {item}")

if failed_optional:
    print(f"\n⚠️  Missing optional items ({len(failed_optional)}):")
    for item in failed_optional:
        print(f"   • {item}")

if not failed_required:
    print("\n✅ All required items present. Contract is structurally complete.")
else:
    print("\n⛔ Contract is INCOMPLETE. Address required items before signing.")
PYEOF
}

# ── Main dispatch ──────────────────────────────────────────────────────────────
COMMAND="${1:-help}"
shift || true

case "$COMMAND" in
  analyze)   export _CR_FILE="${1:-}"; cmd_analyze "${1:-}" ;;
  risk)      export _CR_FILE="${1:-}"; cmd_risk    "${1:-}" ;;
  compare)   cmd_compare "${1:-}" "${2:-}" ;;
  summary)   export _CR_FILE="${1:-}"; cmd_summary "${1:-}" ;;
  checklist) export _CR_FILE="${1:-}"; cmd_checklist "${1:-}" ;;
  help|--help|-h) usage ;;
  *) echo "Unknown command: $COMMAND"; usage; exit 1 ;;
esac

echo ""
echo "---"
echo "Powered by BytesAgain | bytesagain.com"
