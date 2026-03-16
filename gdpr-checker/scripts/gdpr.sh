#!/usr/bin/env bash
# gdpr-checker — GDPR合规检查工具
set -euo pipefail
CMD="${1:-help}"; shift 2>/dev/null || true; INPUT="$*"
run_python() {
python3 << 'PYEOF'
import sys, json
from datetime import datetime

cmd = sys.argv[1] if len(sys.argv) > 1 else "help"
inp = " ".join(sys.argv[2:]) if len(sys.argv) > 2 else ""

CHECKLIST = {
    "Data Collection": [
        ("Lawful basis identified for each processing activity", 10),
        ("Privacy notice provided before data collection", 10),
        ("Consent mechanism is opt-in (not pre-checked)", 8),
        ("Purpose of data collection clearly stated", 8),
        ("Data minimization: only necessary data collected", 7),
    ],
    "Data Storage": [
        ("Data encrypted at rest", 10),
        ("Data encrypted in transit (HTTPS)", 10),
        ("Access controls and authentication", 8),
        ("Data retention policy defined", 7),
        ("Regular data purging process", 6),
    ],
    "User Rights": [
        ("Right to access (SAR process)", 10),
        ("Right to erasure (deletion process)", 10),
        ("Right to data portability", 8),
        ("Right to rectification", 7),
        ("Right to object to processing", 7),
        ("Right to restrict processing", 6),
    ],
    "Documentation": [
        ("Record of processing activities (ROPA)", 9),
        ("Data Protection Impact Assessment (DPIA)", 8),
        ("Data Processing Agreement with processors", 9),
        ("Breach notification procedure", 10),
        ("DPO appointed (if required)", 7),
    ],
    "Website Compliance": [
        ("Cookie consent banner (not just notice)", 10),
        ("Cookie policy page", 7),
        ("Privacy policy accessible from every page", 8),
        ("Contact details for data inquiries", 6),
        ("Age verification (if applicable)", 5),
    ],
}

def cmd_audit():
    print("=" * 60)
    print("  GDPR Compliance Audit Checklist")
    print("  Date: {}".format(datetime.now().strftime("%Y-%m-%d")))
    print("=" * 60)
    print("")

    total_score = 0
    max_score = 0
    for category, items in CHECKLIST.items():
        print("  {} ({} items)".format(category, len(items)))
        print("  " + "-" * 50)
        for item, weight in items:
            max_score += weight
            print("    [ ] {} ({}pts)".format(item, weight))
        print("")

    print("  Max possible score: {}".format(max_score))
    print("  Your score: ___ / {}".format(max_score))
    print("")
    print("  Rating:")
    print("    90%+: Excellent compliance")
    print("    70-89%: Good, minor gaps")
    print("    50-69%: Significant gaps, action needed")
    print("    <50%: Critical non-compliance risk")

def cmd_score():
    if not inp:
        print("Usage: score <yes_count> (out of 26 items)")
        print("Example: score 20")
        return
    yes = int(inp)
    total = 26
    pct = yes / total * 100

    print("=" * 45)
    print("  GDPR Compliance Score")
    print("=" * 45)
    print("")
    print("  Passed: {} / {}".format(yes, total))
    print("  Score: {:.0f}%".format(pct))
    print("")

    bar_len = 30
    filled = int(bar_len * pct / 100)
    bar = "#" * filled + "-" * (bar_len - filled)
    print("  [{}] {:.0f}%".format(bar, pct))
    print("")

    if pct >= 90:
        print("  Rating: EXCELLENT")
        print("  Your organization demonstrates strong GDPR compliance.")
    elif pct >= 70:
        print("  Rating: GOOD")
        print("  Minor gaps exist. Address them to reach full compliance.")
    elif pct >= 50:
        print("  Rating: NEEDS IMPROVEMENT")
        print("  Significant gaps. Prioritize the missing items.")
    else:
        print("  Rating: CRITICAL")
        print("  High risk of non-compliance. Immediate action required.")
        print("  Potential fines: up to 20M EUR or 4% annual turnover.")

def cmd_privacy_policy():
    if not inp:
        print("Usage: privacy-policy <company_name> [website] [email]")
        return
    parts = inp.split()
    company = parts[0]
    website = parts[1] if len(parts) > 1 else "www.{}.com".format(company.lower())
    email = parts[2] if len(parts) > 2 else "privacy@{}.com".format(company.lower())

    print("PRIVACY POLICY")
    print("=" * 55)
    print("")
    print("Last Updated: {}".format(datetime.now().strftime("%Y-%m-%d")))
    print("")
    print("1. INTRODUCTION")
    print("{} ({}) is committed to protecting your".format(company, website))
    print("personal data in accordance with the General Data")
    print("Protection Regulation (GDPR) (EU) 2016/679.")
    print("")
    print("2. DATA CONTROLLER")
    print("Company: {}".format(company))
    print("Contact: {}".format(email))
    print("")
    print("3. DATA WE COLLECT")
    print("- Identity data (name, username)")
    print("- Contact data (email, phone)")
    print("- Technical data (IP, browser, device)")
    print("- Usage data (pages visited, features used)")
    print("")
    print("4. LAWFUL BASIS")
    print("- Consent: marketing communications")
    print("- Contract: service delivery")
    print("- Legitimate interest: analytics, security")
    print("- Legal obligation: tax, regulatory")
    print("")
    print("5. YOUR RIGHTS")
    print("You have the right to:")
    print("- Access your data")
    print("- Correct inaccurate data")
    print("- Delete your data")
    print("- Restrict processing")
    print("- Data portability")
    print("- Object to processing")
    print("- Withdraw consent")
    print("")
    print("To exercise these rights, contact: {}".format(email))
    print("")
    print("6. DATA RETENTION")
    print("We retain data only as long as necessary for the")
    print("purposes stated above, or as required by law.")
    print("")
    print("7. COOKIES")
    print("We use cookies. See our Cookie Policy for details.")
    print("")
    print("8. COMPLAINTS")
    print("You may lodge a complaint with your local")
    print("supervisory authority.")

def cmd_dpa():
    if not inp:
        print("Usage: dpa <controller_name> <processor_name>")
        return
    parts = inp.split()
    controller = parts[0]
    processor = parts[1] if len(parts) > 1 else "Processor"

    print("DATA PROCESSING AGREEMENT")
    print("=" * 55)
    print("")
    print("Between:")
    print("  Controller: {} (Data Controller)".format(controller))
    print("  Processor: {} (Data Processor)".format(processor))
    print("  Date: {}".format(datetime.now().strftime("%Y-%m-%d")))
    print("")
    print("1. SCOPE")
    print("   Processing type: ___")
    print("   Data categories: ___")
    print("   Data subjects: ___")
    print("   Duration: ___")
    print("")
    print("2. PROCESSOR OBLIGATIONS")
    print("   - Process data only on Controller instructions")
    print("   - Ensure staff confidentiality")
    print("   - Implement appropriate security measures")
    print("   - Assist with data subject requests")
    print("   - Delete/return data upon contract end")
    print("   - Submit to audits")
    print("")
    print("3. SUB-PROCESSORS")
    print("   - Prior written consent required")
    print("   - Same obligations flow down")
    print("   - List of current sub-processors: ___")
    print("")
    print("4. BREACH NOTIFICATION")
    print("   - Notify Controller within 72 hours")
    print("   - Include nature, scope, and remediation plan")
    print("")
    print("5. INTERNATIONAL TRANSFERS")
    print("   - Standard Contractual Clauses apply if needed")
    print("   - Transfer Impact Assessment completed")

def cmd_breach():
    print("=" * 55)
    print("  Data Breach Response Checklist")
    print("=" * 55)
    print("")
    print("  PHASE 1: CONTAIN (0-4 hours)")
    print("    [ ] Identify the breach scope")
    print("    [ ] Isolate affected systems")
    print("    [ ] Preserve evidence")
    print("    [ ] Activate incident response team")
    print("")
    print("  PHASE 2: ASSESS (4-24 hours)")
    print("    [ ] Determine data types affected")
    print("    [ ] Estimate number of individuals")
    print("    [ ] Assess risk to individuals")
    print("    [ ] Document timeline of events")
    print("")
    print("  PHASE 3: NOTIFY (within 72 hours)")
    print("    [ ] Notify supervisory authority (if high risk)")
    print("    [ ] Prepare individual notifications (if required)")
    print("    [ ] Include: what happened, data affected,")
    print("          measures taken, contact for questions")
    print("")
    print("  PHASE 4: REMEDIATE")
    print("    [ ] Fix root cause")
    print("    [ ] Update security measures")
    print("    [ ] Review and update policies")
    print("    [ ] Post-incident report")

commands = {
    "audit": cmd_audit, "score": cmd_score,
    "privacy-policy": cmd_privacy_policy, "dpa": cmd_dpa, "breach": cmd_breach,
}
if cmd == "help":
    print("GDPR Compliance Checker")
    print("")
    print("Commands:")
    print("  audit                         — Full compliance checklist (26 items)")
    print("  score <yes_count>             — Calculate compliance score")
    print("  privacy-policy <co> [url] [email] — Generate privacy policy")
    print("  dpa <controller> <processor>  — Data Processing Agreement template")
    print("  breach                        — Breach response checklist")
elif cmd in commands:
    commands[cmd]()
else:
    print("Unknown: {}".format(cmd))
print("")
print("Powered by BytesAgain | bytesagain.com")
print("Note: This tool provides templates. Consult a legal professional.")
PYEOF
}
run_python "$CMD" $INPUT
