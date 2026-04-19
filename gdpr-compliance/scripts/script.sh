#!/usr/bin/env bash
# gdpr-compliance — GDPR compliance tools and document generator
set -euo pipefail

cmd_audit() {
    cat << 'EOF'
GDPR COMPLIANCE AUDIT CHECKLIST
================================
Generated: $(date '+%Y-%m-%d')

── LAWFUL BASIS FOR PROCESSING ──
  [ ] 1. Identified legal basis for each type of data processing
  [ ] 2. Consent obtained where required (explicit, freely given, specific)
  [ ] 3. Legitimate interest assessment (LIA) documented where applicable
  [ ] 4. Records of processing activities (RoPA) maintained (Art. 30)

── DATA COLLECTION ──
  [ ] 5. Data minimization: only collecting what is necessary
  [ ] 6. Purpose limitation: data used only for stated purposes
  [ ] 7. Privacy notice provided at point of collection (Art. 13/14)
  [ ] 8. Age verification for users under 16 (or local threshold)

── DATA STORAGE & SECURITY ──
  [ ] 9.  Data stored in secure, access-controlled systems
  [ ] 10. Encryption at rest and in transit implemented
  [ ] 11. Data retention policy defined and enforced
  [ ] 12. Backups secured and tested regularly
  [ ] 13. Data Processing Agreements (DPAs) signed with all processors

── DATA SUBJECT RIGHTS ──
  [ ] 14. Process in place to handle access requests (within 30 days)
  [ ] 15. Process in place for erasure requests ("right to be forgotten")
  [ ] 16. Data portability mechanism available
  [ ] 17. Objection and restriction requests handled

── BREACH RESPONSE ──
  [ ] 18. Data breach response plan documented
  [ ] 19. Breach notification to supervisory authority within 72 hours (Art. 33)
  [ ] 20. Breach notification to affected individuals when required (Art. 34)

── GOVERNANCE ──
  [ ] 21. Privacy Policy up to date and accessible
  [ ] 22. Data Protection Officer (DPO) appointed if required
  [ ] 23. Privacy Impact Assessments (DPIA) conducted for high-risk processing
  [ ] 24. Cross-border transfer mechanisms in place (SCCs, adequacy decision)

SCORING: Count checked items / 24 × 100 = Compliance %
  90-100%: Fully compliant ✅
  70-89%:  Mostly compliant ⚠️  — address gaps
  50-69%:  Partially compliant 🟠 — significant work needed
  Below 50%: High risk 🔴 — immediate action required
EOF
    # Re-run with date substitution
    date_str=$(date '+%Y-%m-%d')
    sed "s/\$(date '+%Y-%m-%d')/$date_str/" << 'INNEREOF'
GDPR COMPLIANCE AUDIT CHECKLIST
================================
Generated: DATE_PLACEHOLDER

── LAWFUL BASIS FOR PROCESSING ──
  [ ] 1. Identified legal basis for each type of data processing
  [ ] 2. Consent obtained where required (explicit, freely given, specific)
  [ ] 3. Legitimate interest assessment (LIA) documented where applicable
  [ ] 4. Records of processing activities (RoPA) maintained (Art. 30)

── DATA COLLECTION ──
  [ ] 5. Data minimization: only collecting what is necessary
  [ ] 6. Purpose limitation: data used only for stated purposes
  [ ] 7. Privacy notice provided at point of collection (Art. 13/14)
  [ ] 8. Age verification for users under 16 (or local threshold)

── DATA STORAGE & SECURITY ──
  [ ] 9.  Data stored in secure, access-controlled systems
  [ ] 10. Encryption at rest and in transit implemented
  [ ] 11. Data retention policy defined and enforced
  [ ] 12. Backups secured and tested regularly
  [ ] 13. Data Processing Agreements (DPAs) signed with all processors

── DATA SUBJECT RIGHTS ──
  [ ] 14. Process in place to handle access requests (within 30 days)
  [ ] 15. Process in place for erasure requests ("right to be forgotten")
  [ ] 16. Data portability mechanism available
  [ ] 17. Objection and restriction requests handled

── BREACH RESPONSE ──
  [ ] 18. Data breach response plan documented
  [ ] 19. Breach notification to supervisory authority within 72 hours (Art. 33)
  [ ] 20. Breach notification to affected individuals when required (Art. 34)

── GOVERNANCE ──
  [ ] 21. Privacy Policy up to date and accessible
  [ ] 22. Data Protection Officer (DPO) appointed if required
  [ ] 23. Privacy Impact Assessments (DPIA) conducted for high-risk processing
  [ ] 24. Cross-border transfer mechanisms in place (SCCs, adequacy decision)

SCORING: Count checked items / 24 × 100 = Compliance %
  90-100%: Fully compliant ✅
  70-89%:  Mostly compliant ⚠️  — address gaps
  50-69%:  Partially compliant 🟠 — significant work needed
  Below 50%: High risk 🔴 — immediate action required
INNEREOF
}

cmd_dpa() {
    local controller="${1:-Data Controller Company}"
    local processor="${2:-Data Processor Company}"
    cat << EOF
DATA PROCESSING AGREEMENT (DPA)
================================
Date: $(date '+%B %d, %Y')

Between:
  Data Controller: ${controller} ("Controller")
  Data Processor:  ${processor} ("Processor")

1. SUBJECT MATTER AND DURATION
   This DPA governs the processing of personal data by the Processor on behalf
   of the Controller in connection with the services provided under the main
   service agreement. This DPA remains in force for the duration of that agreement.

2. NATURE AND PURPOSE OF PROCESSING
   The Processor shall process personal data solely for the purpose of delivering
   the contracted services and in accordance with the Controller's documented
   instructions.

3. TYPE OF PERSONAL DATA
   The Processor may process the following categories of data:
   - Contact information (name, email, phone)
   - Account credentials (hashed passwords, tokens)
   - Usage data (logs, analytics, session data)
   - Payment information (processed via compliant payment providers)

4. OBLIGATIONS OF THE PROCESSOR (Art. 28 GDPR)
   The Processor shall:
   a) Process personal data only on documented instructions from the Controller
   b) Ensure personnel authorized to process data are bound by confidentiality
   c) Implement appropriate technical and organizational security measures (Art. 32)
   d) Not engage sub-processors without prior written authorization
   e) Assist the Controller in responding to data subject rights requests
   f) Delete or return all personal data upon termination of services
   g) Provide all information necessary to demonstrate compliance
   h) Notify the Controller within 48 hours of becoming aware of a data breach

5. SECURITY MEASURES (Art. 32)
   The Processor shall implement measures including:
   - Pseudonymization and encryption of personal data
   - Ongoing confidentiality, integrity, and availability of systems
   - Regular testing and evaluation of security measures
   - Access controls and audit logging

6. SUB-PROCESSORS
   The Processor may only engage sub-processors with prior written consent.
   Current approved sub-processors: [List here]
   The Processor shall impose equivalent data protection obligations on sub-processors.

7. DATA SUBJECT RIGHTS
   The Processor shall assist the Controller in fulfilling obligations under
   Articles 15-22 GDPR (access, rectification, erasure, restriction, portability,
   objection) within 5 business days of a request.

8. DATA BREACH NOTIFICATION
   In the event of a personal data breach, the Processor shall notify the Controller
   without undue delay and no later than 48 hours after becoming aware of the breach.

9. DATA RETURN AND DELETION
   Upon termination, the Processor shall, at the Controller's choice:
   - Return all personal data in a machine-readable format, OR
   - Securely delete all personal data and certify deletion in writing
   within 30 days of termination.

10. GOVERNING LAW
    This DPA is governed by the laws of the European Union and the applicable
    national laws of the Controller's EU member state.

SIGNATURES:

${controller} (Controller):
Signature: _________________________ Date: ____________
Name/Title: ________________________

${processor} (Processor):
Signature: _________________________ Date: ____________
Name/Title: ________________________

EOF
}

cmd_rights() {
    cat << 'EOF'
GDPR DATA SUBJECT RIGHTS — Enterprise Response Guide
=====================================================

Art. 15 — RIGHT OF ACCESS
  What: Individual can request confirmation and copy of their personal data
  Deadline: 30 days (extendable by 2 months for complex requests)
  Response: Provide data in commonly used electronic format
  Exemptions: Third-party rights, trade secrets
  Action: Build subject access request (SAR) process

Art. 16 — RIGHT TO RECTIFICATION
  What: Correct inaccurate personal data without undue delay
  Deadline: 30 days
  Response: Correct data and notify third parties data was shared with
  Action: Provide a mechanism for users to update their data

Art. 17 — RIGHT TO ERASURE ("Right to be Forgotten")
  What: Delete personal data when no longer necessary or consent withdrawn
  Deadline: 30 days
  Response: Delete data and notify sub-processors
  Exemptions: Legal obligation, public interest, archiving, legal claims
  Action: Implement full account deletion flow

Art. 18 — RIGHT TO RESTRICTION
  What: Restrict processing while accuracy or lawfulness is contested
  Deadline: 30 days
  Response: Mark data as restricted; only store, not process
  Action: Add "restricted" flag to user data model

Art. 20 — RIGHT TO DATA PORTABILITY
  What: Receive personal data in structured, machine-readable format
  Deadline: 30 days
  Response: Provide JSON/CSV export of all user data
  Applies to: Consent-based or contract-based processing only
  Action: Build data export feature

Art. 21 — RIGHT TO OBJECT
  What: Object to processing based on legitimate interests or direct marketing
  Deadline: Immediately for direct marketing; 30 days otherwise
  Response: Stop processing unless compelling legitimate grounds demonstrated
  Action: Provide opt-out for marketing; document legitimate interest assessments

Art. 22 — RIGHTS RELATED TO AUTOMATED DECISIONS
  What: Not be subject to solely automated decisions with significant effects
  Deadline: 30 days
  Response: Provide human review option; explain the logic involved
  Action: Audit automated decision systems (e.g., credit scoring, profiling)

Art. 77 — RIGHT TO LODGE A COMPLAINT
  What: Lodge complaint with supervisory authority (e.g., ICO, CNIL, BfDI)
  Deadline: No deadline — can be done at any time
  Action: Include supervisory authority contact in privacy policy

IMPLEMENTATION CHECKLIST:
  [ ] SARs handled within 30 days
  [ ] Identity verification process for requesters
  [ ] Data deletion covers all systems including backups
  [ ] Portability export covers all data collected
  [ ] Marketing opt-out effective immediately
  [ ] DPO or privacy contact clearly published

EOF
}

cmd_breach() {
    local severity="${1:-medium}"
    local date_str
    date_str=$(date '+%B %d, %Y')
    cat << EOF
DATA BREACH NOTIFICATION TEMPLATE
===================================
Severity: $(echo "$severity" | tr '[:lower:]' '[:upper:]')
Date: ${date_str}

── NOTIFICATION TO SUPERVISORY AUTHORITY (Art. 33) ──
[Submit within 72 hours of discovery]

To: [Supervisory Authority Name, e.g., ICO / CNIL / BfDI]
From: [Your Organization Name]
Date: ${date_str}

BREACH DETAILS:
  Nature of breach: [Unauthorized access / Data loss / Accidental disclosure]
  Categories of data: [e.g., name, email, hashed passwords]
  Approximate number affected: [X individuals]
  Discovery date/time: [Date and time]

LIKELY CONSEQUENCES:
$(case "$severity" in
  low)    echo "  Low risk — limited personal data exposed, no financial or sensitive data" ;;
  medium) echo "  Medium risk — personal contact data exposed, potential phishing risk" ;;
  high)   echo "  High risk — sensitive data exposed (financial, health, ID numbers)" ;;
  *)      echo "  Risk level: $severity" ;;
esac)

MEASURES TAKEN:
  - [Describe immediate containment actions]
  - [System patch / access revocation / password reset]
  - [Forensic investigation initiated]
  - [Affected users notified: Yes / No / Pending]

CONTACT:
  Name: [DPO or Privacy Contact]
  Email: [dpo@yourcompany.com]
  Phone: [+XX XXX XXX XXX]

── NOTIFICATION TO AFFECTED INDIVIDUALS (Art. 34) ──
$(if [[ "$severity" == "high" ]]; then
echo "[Required for high-risk breaches — send promptly]"
else
echo "[May not be required for low/medium risk — assess case by case]"
fi)

Subject: Important Security Notice — Your Account May Be Affected

Dear [User Name],

We are writing to inform you of a data security incident that may have affected your account.

WHAT HAPPENED:
On [Date], we discovered that [brief description of the breach].

WHAT INFORMATION WAS INVOLVED:
$(case "$severity" in
  low)    echo "  Your [email address / username] may have been exposed." ;;
  medium) echo "  Your contact information (name, email) may have been accessed." ;;
  high)   echo "  Your personal information including [specific data types] was compromised." ;;
esac)

WHAT WE ARE DOING:
  We have [describe steps taken — patched systems, reset credentials, etc.].
  We have notified the relevant data protection authority.

WHAT YOU SHOULD DO:
  1. Change your password immediately at [URL]
  2. Enable two-factor authentication if available
$(if [[ "$severity" == "high" ]]; then
echo "  3. Monitor your financial accounts for suspicious activity"
echo "  4. Consider placing a fraud alert with credit bureaus"
fi)

If you have questions, contact our privacy team at: privacy@yourcompany.com

Sincerely,
[Company Name] Privacy Team

EOF
}

cmd_consent() {
    cat << 'EOF'
COOKIE CONSENT BANNER — Standard Text Templates
=================================================

── MINIMAL BANNER (GDPR compliant) ──
"We use cookies to improve your experience. By continuing to use this site,
you accept our use of cookies. [Accept] [Reject] [Manage Preferences]"

── DETAILED BANNER ──
"We use cookies and similar technologies on this website.
• Essential cookies: Required for the site to function (always active)
• Analytics cookies: Help us understand how visitors interact with the site
• Marketing cookies: Used to deliver relevant advertisements

You can accept all cookies, reject non-essential cookies, or customize
your preferences. Your choice will be saved for 12 months.

[Accept All] [Reject Non-Essential] [Customize Settings]

Privacy Policy | Cookie Policy"

── COOKIE CATEGORIES DESCRIPTION ──
Strictly Necessary:
  These cookies are essential for the website to function. They cannot be
  disabled. Examples: session cookies, security tokens, load balancers.

Analytics / Performance:
  These cookies help us understand how visitors use our site (e.g., Google
  Analytics, Hotjar). Data is anonymized where possible.
  Default: OFF — requires user consent.

Functional:
  These cookies enable enhanced functionality such as live chat, video
  players, or language preferences.
  Default: OFF — requires user consent.

Targeting / Marketing:
  These cookies track your browsing to deliver relevant ads (e.g., Google
  Ads, Facebook Pixel). They may share data with third parties.
  Default: OFF — requires explicit consent.

── CONSENT RECORD (what to log) ──
  user_id or session_id: [identifier]
  consent_date: [ISO 8601 timestamp]
  consent_version: [policy version number]
  categories_accepted: [list]
  ip_address: [hashed]
  user_agent: [browser info]

── IMPLEMENTATION CHECKLIST ──
  [ ] Banner appears before non-essential cookies are set
  [ ] Reject option is as prominent as Accept
  [ ] Granular control available (not just all-or-nothing)
  [ ] Consent is recorded with timestamp and version
  [ ] Easy to withdraw consent at any time
  [ ] Banner re-appears after 12 months or policy change
  [ ] Cookie policy linked from banner
EOF
}

cmd_help() {
    cat << 'EOF'
gdpr-compliance — GDPR compliance tools and document generator

Commands:
  audit                           Full GDPR compliance audit checklist (24 items)
  dpa    [controller] [processor] Generate Data Processing Agreement template
  rights                          Guide to all 8 GDPR data subject rights
  breach [low|medium|high]        Generate data breach notification template
  consent                         Generate Cookie consent banner text
  help                            Show this help

Examples:
  bash scripts/script.sh audit
  bash scripts/script.sh dpa "Acme Corp" "CloudProvider Inc"
  bash scripts/script.sh rights
  bash scripts/script.sh breach high
  bash scripts/script.sh consent

Output is plain text — redirect to save:
  bash scripts/script.sh dpa "MyCompany" "AWS" > dpa-aws.txt

Powered by BytesAgain | bytesagain.com
EOF
}

case "${1:-help}" in
    audit)   cmd_audit ;;
    dpa)     shift; cmd_dpa "$@" ;;
    rights)  cmd_rights ;;
    breach)  shift; cmd_breach "$@" ;;
    consent) cmd_consent ;;
    help|*)  cmd_help ;;
esac
