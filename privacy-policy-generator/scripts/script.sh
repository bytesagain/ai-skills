#!/usr/bin/env bash
# privacy-policy-generator — Generate and check privacy policy documents
set -euo pipefail

cmd_generate() {
    local company="${1:-Your Company}"
    local business="${2:-web application}"
    local data="${3:-name,email,usage data}"
    cat << EOF
PRIVACY POLICY

Last updated: $(date '+%B %d, %Y')

1. INTRODUCTION
   ${company} ("we," "us," or "our") operates a ${business}. This Privacy Policy explains how we collect, use, disclose, and safeguard your information.

2. INFORMATION WE COLLECT
   We may collect the following personal information:
$(echo "$data" | tr ',' '\n' | while read -r item; do echo "   - $(echo "$item" | xargs)"; done)

3. HOW WE USE YOUR INFORMATION
   We use the information we collect to:
   - Provide, operate, and maintain our services
   - Improve, personalize, and expand our services
   - Understand and analyze how you use our services
   - Develop new products, services, features, and functionality
   - Communicate with you for customer service and updates
   - Send you emails and other communications
   - Find and prevent fraud and abuse

4. SHARING YOUR INFORMATION
   We do not sell, trade, or rent your personal information to third parties.
   We may share information with:
   - Service providers who assist in our operations
   - Business partners with your consent
   - Law enforcement when required by law

5. DATA RETENTION
   We retain your personal data only as long as necessary for the purposes outlined in this policy, or as required by law.

6. SECURITY
   We implement appropriate technical and organizational measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.

7. YOUR RIGHTS
   You have the right to:
   - Access your personal data
   - Correct inaccurate data
   - Request deletion of your data
   - Object to processing of your data
   - Data portability

8. COOKIES
   We use cookies and similar tracking technologies to track activity on our service and hold certain information. You can instruct your browser to refuse all cookies.

9. CHILDREN'S PRIVACY
   Our service does not address anyone under the age of 13. We do not knowingly collect personally identifiable information from children under 13.

10. CHANGES TO THIS POLICY
    We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.

11. CONTACT US
    If you have any questions about this Privacy Policy, please contact us at:
    Email: privacy@${company,,}.com
    Address: [Your Address]

EOF
}

cmd_check() {
    local file="${1:-}"
    [[ -z "$file" ]] && { echo "Usage: check <privacy-policy-file.txt>"; exit 1; }
    [[ ! -f "$file" ]] && { echo "❌ File not found: $file"; exit 1; }

    python3 << 'PYEOF'
import sys, re

file = sys.argv[1] if len(sys.argv) > 1 else ""
try:
    content = open(file).read().lower()
except:
    print("❌ Cannot read file")
    sys.exit(1)

checks = [
    ("Data collection disclosure",   ["collect", "information we collect", "data we collect"]),
    ("Purpose of data use",          ["how we use", "use your information", "purpose"]),
    ("Third-party sharing",          ["third party", "share", "disclose"]),
    ("User rights",                  ["your rights", "right to access", "right to delete", "opt-out"]),
    ("Data retention policy",        ["retention", "how long", "store your data"]),
    ("Security measures",            ["security", "protect", "safeguard", "encryption"]),
    ("Cookie policy",                ["cookie", "tracking", "analytics"]),
    ("Contact information",          ["contact us", "contact:", "email:"]),
    ("Children's privacy (COPPA)",   ["children", "under 13", "child"]),
    ("Policy update notice",         ["update", "changes to this policy", "last updated"]),
]

print(f"Privacy Policy Check: {file}")
print("=" * 50)
passed = 0
for name, keywords in checks:
    found = any(kw in content for kw in keywords)
    status = "✅" if found else "❌"
    print(f"  {status} {name}")
    if found:
        passed += 1

print(f"\nScore: {passed}/{len(checks)} ({passed*100//len(checks)}%)")
if passed < 7:
    print("⚠️  Privacy policy is incomplete. Consider adding missing sections.")
else:
    print("✅ Privacy policy covers essential requirements.")
PYEOF
    python3 - "$file" << 'PYEOF'
import sys, re

file = sys.argv[1] if len(sys.argv) > 1 else ""
try:
    content = open(file).read().lower()
except:
    print("❌ Cannot read file")
    sys.exit(1)

checks = [
    ("Data collection disclosure",   ["collect", "information we collect", "data we collect"]),
    ("Purpose of data use",          ["how we use", "use your information", "purpose"]),
    ("Third-party sharing",          ["third party", "share", "disclose"]),
    ("User rights",                  ["your rights", "right to access", "right to delete", "opt-out"]),
    ("Data retention policy",        ["retention", "how long", "store your data"]),
    ("Security measures",            ["security", "protect", "safeguard", "encryption"]),
    ("Cookie policy",                ["cookie", "tracking", "analytics"]),
    ("Contact information",          ["contact us", "contact:", "email:"]),
    ("Children's privacy (COPPA)",   ["children", "under 13", "child"]),
    ("Policy update notice",         ["update", "changes to this policy", "last updated"]),
]

print(f"Privacy Policy Check: {file}")
print("=" * 50)
passed = 0
for name, keywords in checks:
    found = any(kw in content for kw in keywords)
    status = "✅" if found else "❌"
    print(f"  {status} {name}")
    if found:
        passed += 1

print(f"\nScore: {passed}/{len(checks)} ({passed*100//len(checks)}%)")
PYEOF
}

cmd_gdpr() {
    local company="${1:-Your Company}"
    cat << EOF
GDPR SUPPLEMENTAL CLAUSES FOR PRIVACY POLICY

Applicable to users in the European Economic Area (EEA)

LEGAL BASIS FOR PROCESSING
   We process your personal data under the following legal bases (Article 6 GDPR):
   - Consent: where you have given explicit consent
   - Contract: where processing is necessary for a contract with you
   - Legal obligation: where we must comply with a legal requirement
   - Legitimate interests: where we have legitimate business interests

YOUR GDPR RIGHTS (Articles 15-22)
   As an EEA resident, you have the right to:
   - Access (Art. 15): Obtain confirmation and a copy of your personal data
   - Rectification (Art. 16): Correct inaccurate personal data
   - Erasure (Art. 17): Request deletion ("right to be forgotten")
   - Restriction (Art. 18): Restrict how we process your data
   - Portability (Art. 20): Receive your data in a machine-readable format
   - Objection (Art. 21): Object to processing based on legitimate interests
   - Automated decisions (Art. 22): Not be subject to solely automated decisions

DATA TRANSFERS
   If we transfer your data outside the EEA, we ensure adequate protection through:
   - EU Standard Contractual Clauses (SCCs)
   - Adequacy decisions by the European Commission
   - Other approved transfer mechanisms

DATA PROTECTION OFFICER
   Contact our DPO at: dpo@${company,,}.com

RIGHT TO LODGE COMPLAINT
   You have the right to lodge a complaint with your local supervisory authority.

Company: ${company}
Generated: $(date '+%Y-%m-%d')
EOF
}

cmd_ccpa() {
    local company="${1:-Your Company}"
    cat << EOF
CCPA SUPPLEMENTAL CLAUSES FOR CALIFORNIA RESIDENTS

Effective for California residents under the California Consumer Privacy Act (CCPA)
and California Privacy Rights Act (CPRA).

CATEGORIES OF PERSONAL INFORMATION COLLECTED
   In the past 12 months, we have collected:
   - Identifiers (name, email, IP address)
   - Internet activity (browsing history, search history)
   - Commercial information (purchase history)
   - Professional information (if applicable)

YOUR CALIFORNIA RIGHTS
   California residents have the right to:
   1. KNOW: Request disclosure of personal information collected, used, disclosed, or sold
   2. DELETE: Request deletion of personal information (with exceptions)
   3. OPT-OUT: Opt out of the sale of personal information
   4. NON-DISCRIMINATION: Not receive discriminatory treatment for exercising CCPA rights
   5. CORRECT: Correct inaccurate personal information (CPRA)
   6. LIMIT: Limit use of sensitive personal information (CPRA)

DO NOT SELL MY PERSONAL INFORMATION
   ${company} does not sell personal information. If this changes, we will update this policy
   and provide an opt-out mechanism at: [Your Website]/do-not-sell

HOW TO SUBMIT A REQUEST
   Email: privacy@${company,,}.com
   Subject: "CCPA Rights Request"
   We will respond within 45 days.

VERIFICATION
   We may need to verify your identity before processing your request.

Company: ${company}
Generated: $(date '+%Y-%m-%d')
EOF
}

cmd_update() {
    local new_data="${1:-location data}"
    cat << EOF
PRIVACY POLICY AMENDMENT

Date: $(date '+%B %d, %Y')
Change Type: Addition of new data collection

NEW DATA COLLECTION NOTICE
   We have updated our privacy policy to reflect the collection of: ${new_data}

   Reason for collection: To improve our services and user experience
   Legal basis: Legitimate interests / User consent
   Retention period: As long as necessary for the stated purpose

   You may opt out of this collection by:
   - Adjusting your account settings
   - Contacting us at privacy@yourcompany.com

   If you have questions about this update, please contact our Privacy Team.

WHAT CHANGED
   Previous policy: Did not mention collection of ${new_data}
   Updated policy:  Now explicitly discloses collection and use of ${new_data}

EOF
}

cmd_help() {
    cat << 'EOF'
privacy-policy-generator — Generate and check privacy policy documents

Commands:
  generate  [company] [business] [data]   Generate a full privacy policy
  check     <file>                         Check existing policy completeness
  gdpr      [company]                      Generate GDPR supplemental clauses
  ccpa      [company]                      Generate CCPA/California clauses
  update    [new-data-type]               Generate policy amendment notice
  help                                     Show this help

Examples:
  bash scripts/script.sh generate "Acme Corp" "e-commerce platform" "name,email,address"
  bash scripts/script.sh check privacy-policy.txt
  bash scripts/script.sh gdpr "Acme Corp"
  bash scripts/script.sh ccpa "Acme Corp"
  bash scripts/script.sh update "location data"

Output is plain text — redirect to file:
  bash scripts/script.sh generate "MyApp" > privacy-policy.txt

Powered by BytesAgain | bytesagain.com
EOF
}

case "${1:-help}" in
    generate) shift; cmd_generate "$@" ;;
    check)    shift; cmd_check "$@" ;;
    gdpr)     shift; cmd_gdpr "$@" ;;
    ccpa)     shift; cmd_ccpa "$@" ;;
    update)   shift; cmd_update "$@" ;;
    help|*)   cmd_help ;;
esac
