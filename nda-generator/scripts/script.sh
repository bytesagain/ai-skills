#!/usr/bin/env bash
# nda-generator — Generate and review Non-Disclosure Agreements
set -euo pipefail

cmd_generate() {
    local type="${1:-mutual}"
    local party_a="${2:-Party A}"
    local party_b="${3:-Party B}"
    local years="${4:-2}"
    cat << EOF
NON-DISCLOSURE AGREEMENT (NDA)
Type: $(echo "$type" | tr '[:lower:]' '[:upper:]') NDA

This Non-Disclosure Agreement ("Agreement") is entered into as of $(date '+%B %d, %Y'),
by and between:

  Disclosing Party: ${party_a} ("Discloser")
  Receiving Party:  ${party_b} ("Recipient")

$([ "$type" = "mutual" ] && echo "  [Note: This is a MUTUAL NDA — both parties may share and receive confidential information]" || echo "  [Note: This is a ONE-WAY NDA — only the Discloser shares confidential information]")

1. DEFINITION OF CONFIDENTIAL INFORMATION
   "Confidential Information" means any non-public information that Discloser designates
   as being confidential or which, under the circumstances surrounding disclosure, ought
   to be treated as confidential. This includes, without limitation:
   - Business plans, strategies, and forecasts
   - Technical data, trade secrets, and know-how
   - Research, product plans, and services
   - Customer lists and customer information
   - Financial information and projections
   - Software, inventions, and processes

2. OBLIGATIONS OF RECIPIENT
   The Recipient agrees to:
   a) Hold the Confidential Information in strict confidence
   b) Not disclose Confidential Information to any third party without prior written consent
   c) Use the Confidential Information solely for evaluating or engaging in discussions
      concerning a potential business relationship
   d) Limit access to Confidential Information to employees with a need to know
   e) Notify Discloser promptly of any unauthorized use or disclosure

3. EXCLUSIONS
   This Agreement does not apply to information that:
   - Is or becomes publicly available through no breach of this Agreement
   - Was rightfully known to Recipient before disclosure
   - Is independently developed by Recipient without use of Confidential Information
   - Is required to be disclosed by law or court order (with prompt notice to Discloser)

4. TERM AND TERMINATION
   This Agreement shall remain in effect for ${years} year(s) from the date of execution.
   Obligations regarding Confidential Information shall survive termination for an additional
   2 years.

5. RETURN OF INFORMATION
   Upon request, Recipient shall promptly return or destroy all Confidential Information
   and certify in writing that it has done so.

6. NO LICENSE
   Nothing in this Agreement grants Recipient any rights in or to Confidential Information
   except as expressly set forth herein.

7. REMEDIES
   Recipient acknowledges that breach of this Agreement may cause irreparable harm,
   entitling Discloser to seek injunctive relief in addition to other remedies.

8. GOVERNING LAW
   This Agreement shall be governed by the laws of [Jurisdiction].

9. ENTIRE AGREEMENT
   This Agreement constitutes the entire agreement between the parties concerning
   Confidential Information and supersedes all prior agreements.

SIGNATURES:

${party_a}:
Signature: _________________________ Date: ____________
Name:      _________________________
Title:     _________________________

${party_b}:
Signature: _________________________ Date: ____________
Name:      _________________________
Title:     _________________________

EOF
}

cmd_review() {
    local file="${1:-}"
    [[ -z "$file" || ! -f "$file" ]] && { echo "Usage: review <nda-file.txt>"; exit 1; }
    python3 - "$file" << 'PYEOF'
import sys
file = sys.argv[1]
content = open(file).read().lower()

checks = [
    ("Definition of Confidential Information", ["confidential information", "definition"]),
    ("Recipient obligations",                  ["obligations", "shall not disclose", "agrees to"]),
    ("Exclusions/Exceptions",                  ["exclusion", "exception", "does not apply"]),
    ("Term/Duration",                          ["term", "years", "duration", "expire"]),
    ("Return/Destruction of information",      ["return", "destroy", "destruction"]),
    ("Remedies clause",                        ["remedies", "injunctive", "irreparable"]),
    ("Governing law",                          ["governing law", "jurisdiction"]),
    ("Signatures/Execution",                   ["signature", "signed", "execution"]),
    ("Non-solicitation (optional)",            ["solicit", "non-solicitation"]),
    ("Penalty/Liquidated damages (optional)",  ["penalty", "damages", "liquidated"]),
]

print(f"NDA Review: {file}")
print("=" * 50)
missing = []
for name, kws in checks:
    found = any(k in content for k in kws)
    opt = "(optional)" in name
    status = "✅" if found else ("⚠️ " if opt else "❌")
    print(f"  {status} {name}")
    if not found and not opt:
        missing.append(name)

print(f"\nMissing critical clauses: {len(missing)}")
for m in missing:
    print(f"  → Add: {m}")
PYEOF
}

cmd_customize() {
    local scope="${1:-software development}"
    local penalty="${2:-50000}"
    local years="${3:-3}"
    cat << EOF
NDA CUSTOMIZATION ADDENDUM

This addendum supplements the main NDA with the following custom terms:

SPECIFIC CONFIDENTIALITY SCOPE
   The confidential information covered by this agreement is specifically limited to:
   ${scope}
   
   All other information exchanged between parties is NOT covered by this NDA
   unless explicitly marked "CONFIDENTIAL" in writing.

ENHANCED PENALTY CLAUSE
   In addition to injunctive relief, a breach of this Agreement shall result in
   liquidated damages of USD ${penalty} per incident, as the parties agree this
   represents a reasonable estimate of damages from unauthorized disclosure.

EXTENDED PROTECTION PERIOD
   For information related to [Core Technology/Product], the confidentiality
   obligation extends to ${years} years post-termination (instead of standard 2 years).

NON-COMPETE PROVISION (if applicable)
   During the term and for 1 year thereafter, Recipient shall not directly compete
   with Discloser in the field of: ${scope}

AUDIT RIGHTS
   Discloser may audit Recipient's compliance with this Agreement upon 30 days notice.

Generated: $(date '+%Y-%m-%d')
EOF
}

cmd_export() {
    local file="${1:-}"
    if [[ -z "$file" ]]; then
        cmd_generate mutual "Party A" "Party B" 2
    else
        [[ ! -f "$file" ]] && { echo "❌ File not found: $file"; exit 1; }
        cat "$file"
    fi
    echo ""
    echo "---"
    echo "Exported: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "Format: Plain Text"
}

cmd_translate() {
    local party_a="${1:-甲方}"
    local party_b="${2:-乙方}"
    cat << EOF
保密协议（NDA）中英对照版
NON-DISCLOSURE AGREEMENT — BILINGUAL VERSION

签署日期 / Date: $(date '+%Y年%m月%d日 / %B %d, %Y')
甲方 / Party A: ${party_a}
乙方 / Party B: ${party_b}

第一条 保密信息定义 / Article 1: Definition of Confidential Information
   "保密信息"是指甲方向乙方披露的，包括但不限于以下内容的非公开信息：
   "Confidential Information" means non-public information disclosed by Party A, including but not limited to:
   - 商业计划和战略 / Business plans and strategies
   - 技术数据和商业秘密 / Technical data and trade secrets
   - 客户名单和财务信息 / Customer lists and financial information

第二条 保密义务 / Article 2: Confidentiality Obligations
   乙方同意对保密信息严格保密，未经甲方书面同意不得向第三方披露。
   Recipient agrees to keep Confidential Information strictly confidential and not disclose it to any third party without prior written consent.

第三条 保密期限 / Article 3: Term
   本协议自签署之日起2年内有效。
   This Agreement shall remain in effect for 2 years from the date of execution.

第四条 违约责任 / Article 4: Breach and Remedies
   违反本协议的一方应承担因违约给对方造成的全部损失。
   The breaching party shall be liable for all damages caused to the other party.

甲方签字 / Party A Signature: _______________ 日期/Date: ________
乙方签字 / Party B Signature: _______________ 日期/Date: ________

EOF
}

cmd_help() {
    cat << 'EOF'
nda-generator — Generate and review Non-Disclosure Agreements

Commands:
  generate  [type] [party-a] [party-b] [years]   Generate NDA (type: mutual|oneway)
  review    <file>                                 Review existing NDA for missing clauses
  customize [scope] [penalty] [years]             Generate custom addendum
  export    [file]                                 Export NDA as plain text
  translate [party-a-cn] [party-b-cn]             Generate bilingual (EN/CN) version
  help                                             Show this help

Examples:
  bash scripts/script.sh generate mutual "Acme Corp" "Beta Inc" 3
  bash scripts/script.sh generate oneway "StartupX" "Investor Y"
  bash scripts/script.sh review existing-nda.txt
  bash scripts/script.sh customize "AI model training" 100000 5
  bash scripts/script.sh translate 甲方公司 乙方公司 > nda-bilingual.txt

Powered by BytesAgain | bytesagain.com
EOF
}

case "${1:-help}" in
    generate)  shift; cmd_generate "$@" ;;
    review)    shift; cmd_review "$@" ;;
    customize) shift; cmd_customize "$@" ;;
    export)    shift; cmd_export "$@" ;;
    translate) shift; cmd_translate "$@" ;;
    help|*)    cmd_help ;;
esac
