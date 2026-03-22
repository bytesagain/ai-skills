#!/usr/bin/env bash
# coppa — COPPA Compliance Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== COPPA — Children's Online Privacy Protection Act ===

The Children's Online Privacy Protection Act (COPPA) is a U.S. federal law
enacted in 1998 (effective April 2000) that imposes requirements on operators
of websites and online services directed at children under 13.

Enforcing Agency: Federal Trade Commission (FTC)
Statute: 15 U.S.C. §§ 6501–6506
Rule: 16 CFR Part 312 (COPPA Rule)

Key Dates:
  1998    COPPA signed into law
  2000    FTC COPPA Rule takes effect
  2013    Major amendments — mobile apps, geolocation, photos/video added
  2024    FTC proposes further updates (ed-tech, targeted ads)

Core Requirements:
  1. Post a clear, comprehensive privacy policy
  2. Provide direct notice to parents before collecting data
  3. Obtain verifiable parental consent (VPC) before collection
  4. Allow parents to review/delete their child's data
  5. Allow parents to revoke consent
  6. Maintain confidentiality, security, and integrity of data
  7. Retain data only as long as needed
  8. Do not condition participation on unnecessary data collection

Penalties:
  - Up to $50,120 per violation (2024 adjusted amount)
  - FTC can seek injunctions, civil penalties, and consent decrees
  - No private right of action (only FTC enforces)
EOF
}

cmd_scope() {
    cat << 'EOF'
=== COPPA Scope — Who Must Comply ===

COPPA applies to:

1. Operators of Commercial Websites/Online Services
   - Directed to children under 13, OR
   - Have actual knowledge they collect PI from children under 13

2. "Directed to Children" Factors (FTC totality test):
   - Subject matter (kid-friendly content)
   - Visual content (animated characters, bright colors)
   - Use of child-oriented language
   - Music and audio content targeting children
   - Age of models/actors on the site
   - Presence of child celebrities or characters
   - Ads for/on the service targeting children
   - Competent empirical evidence about age of audience

3. Mixed-Audience Sites:
   - Sites that attract BOTH adults and children
   - May use age-screening to identify child users
   - COPPA applies only to users identified as under 13
   - Age gate must not encourage false age entry

4. "Actual Knowledge" Standard:
   - Non-child-directed sites that learn a user is under 13
   - Triggered by: age disclosure, parental complaint, chat content
   - Once triggered, must comply for that user

5. Third-Party Operators:
   - Ad networks, plug-ins, analytics SDKs on child-directed sites
   - Share COPPA obligations with the site operator
   - Can be independently liable for collecting child PI

NOT Covered:
   - Non-commercial sites (nonprofits under certain conditions)
   - Sites directed to general audience with no child focus
   - Offline data collection
   - Children 13 and older (see state laws like CCPA for teens)
EOF
}

cmd_data() {
    cat << 'EOF'
=== Personal Information Under COPPA ===

COPPA defines "personal information" broadly for children under 13:

Covered Data Types:
  1. Full name (first + last)
  2. Home or physical address (including street name and city/town)
  3. Online contact info (email, IM identifier)
  4. Screen name / username (if used as online contact info)
  5. Telephone number
  6. Social Security number
  7. Persistent identifier (cookie, IP, device ID, processor serial)
     — when used to recognize a user over time/across sites
  8. Photo, video, or audio file containing child's image or voice
  9. Geolocation info (precise enough to identify street/city)
  10. Any combination of info that permits physical or online contact

2013 Amendments Added:
  - Photos/video/audio with child's image or voice
  - Geolocation information
  - Persistent identifiers used for behavioral advertising
  - Screen names that function as online contact information

What's NOT Personal Information:
  - Aggregated, de-identified data (properly anonymized)
  - Persistent identifiers used solely for internal operations:
    • Maintaining or analyzing site function
    • Performing network communications
    • Serving contextual ads (not behavioral)
    • Capping ad frequency
    • Protecting security/integrity
    • Legal compliance

Internal Operations Exception:
  Operators may collect persistent identifiers WITHOUT consent
  IF used solely for "support for internal operations" AND
  no personal information is otherwise collected.
  This allows basic analytics without parental consent.
EOF
}

cmd_consent() {
    cat << 'EOF'
=== Verifiable Parental Consent (VPC) Methods ===

Before collecting PI from a child under 13, operators must obtain
verifiable parental consent using one of these FTC-approved methods:

Approved Methods:

1. Signed Consent Form (mail/fax/scan)
   - Parent prints, signs, and returns a physical form
   - Most burdensome; rarely used for digital services

2. Credit Card Transaction
   - Parent provides credit card for a purchase or fee
   - Notify parent that card is being used for consent verification
   - Transaction must be monetary (not just card number)

3. Toll-Free Phone Call
   - Parent calls a toll-free number to provide consent
   - Trained personnel must verify caller is parent
   - Must maintain records

4. Video Conference
   - Parent connects via video call
   - Operator verifies parent's identity visually
   - Must match to a form of ID

5. Government-Issued ID Check
   - Parent submits copy of government ID
   - Operator verifies and deletes ID after verification
   - Cross-reference with database, then delete

6. Knowledge-Based Authentication
   - Parent answers questions from a database
   - Questions must be sufficiently difficult
   - Not easily guessable by a child

7. "Email Plus" (limited use only)
   - Parent provides consent via email
   - PLUS operator sends a delayed confirmation email
   - Only for internal use — NOT for disclosing data to third parties

Consent Must Include:
  - Types of PI being collected
  - How PI will be used
  - Whether PI will be disclosed to third parties
  - Parent's right to refuse and still let child use service
  - Link to online privacy policy

Consent Is NOT Required When:
  - Collecting email solely to respond one time to a child
  - Collecting email for safety/security purposes
  - Collecting persistent identifiers for internal operations only
EOF
}

cmd_notice() {
    cat << 'EOF'
=== COPPA Notice Requirements ===

Two Types of Notice Required:

1. ONLINE PRIVACY POLICY (posted on website/app)

Must Include:
  □ Name, address, phone, email of all operators collecting data
  □ Description of PI collected from children
  □ Description of how PI is used
  □ Whether PI is disclosed to third parties and for what purpose
  □ Parent's right to:
    - Review child's PI
    - Delete child's PI
    - Refuse further collection/use
  □ Procedures for parent to exercise rights
  □ Statement that operator cannot condition participation
    on collection of more PI than reasonably necessary

Placement:
  - Homepage link: clear, prominent ("Privacy Policy" or
    "Children's Privacy")
  - Each area where PI is collected must link to policy
  - Must be legible and clearly written (no legal jargon overload)

2. DIRECT NOTICE TO PARENTS (before collecting data)

Must Include:
  □ That the site is collecting PI from their child
  □ That parental consent is required
  □ Specific PI being collected
  □ How the PI will be used
  □ Whether PI will be shared with third parties
  □ Link to the full online privacy policy
  □ How parent can provide consent
  □ That if parent doesn't consent within reasonable time,
    operator will delete PI collected from the child

Format:
  - Email to parent (child provides parent's email)
  - Must be clear and not buried in other content
  - Must be in language parent can understand
EOF
}

cmd_safeharbor() {
    cat << 'EOF'
=== COPPA Safe Harbor Programs ===

Safe Harbor allows industry groups to submit self-regulatory guidelines
to the FTC for approval. Members who comply with approved guidelines
are deemed in compliance with COPPA.

Benefits of Safe Harbor Membership:
  - Compliance presumption (burden shifts to FTC to disprove)
  - Industry-specific guidance tailored to sector
  - Monitoring and accountability framework
  - Reduced regulatory risk

FTC-Approved Safe Harbor Programs:

1. kidSAFE Seal Program
   - For child-directed websites and apps
   - Covers digital products, games, educational tools
   - Provides kidSAFE, kidSAFE+, and COPPA+ seals

2. CARU (Children's Advertising Review Unit)
   - Part of BBB National Programs
   - Focus on advertising practices directed at children
   - Monitors national child-directed advertising

3. Aristotle Inc. (COPPA Certification)
   - Age/identity verification specialist
   - Provides parental consent verification services
   - Focuses on age-gating and identity tech

4. ESRB Privacy Certified
   - Entertainment Software Rating Board program
   - Focus on games, apps, and digital entertainment
   - Well-known in gaming industry

5. PRIVO (Privacy Vaults Online)
   - Age verification and parental consent platform
   - Ed-tech and kids' app focused
   - Provides SDK/API for consent management

Requirements to Maintain Safe Harbor:
  - Subject to self-regulatory program's oversight
  - Regular audits and assessments
  - Breach notification obligations
  - Annual reporting to FTC
  - FTC can revoke Safe Harbor status
EOF
}

cmd_enforcement() {
    cat << 'EOF'
=== COPPA Enforcement — FTC Actions ===

The FTC has brought 40+ enforcement actions since COPPA's enactment.

Notable Cases:

Epic Games / Fortnite (2022)
  Fine: $275 million (largest COPPA penalty ever)
  Violation: Collected PI from children without parental consent,
  enabled live voice/text chat with strangers by default,
  used dark patterns to trick users into purchases.

Google / YouTube (2019)
  Fine: $170 million
  Violation: Collected persistent identifiers from child viewers
  for behavioral advertising without parental consent.
  Led to YouTube creating "YouTube Kids" and restricting
  data collection on child-directed channels.

Musical.ly / TikTok (2019)
  Fine: $5.7 million
  Violation: Collected PI (names, emails, bios, location) from
  children under 13 with actual knowledge of their age.
  App required to delete underage accounts.

VTech Electronics (2018)
  Fine: $650,000
  Violation: Collected PI from children through kids' tablets
  and learning apps without proper parental notice/consent.

Yelp (2014)
  Fine: $450,000
  Violation: App registration collected birthdates showing
  users were under 13, but continued collecting PI anyway.

Common Violation Patterns:
  - Failing to post compliant privacy policies
  - Collecting data without parental consent
  - Inadequate data security for children's PI
  - Using persistent identifiers for behavioral ads on kid sites
  - Third-party SDKs collecting data from child-directed apps
  - Not providing parents with access/deletion rights
  - Using dark patterns to circumvent age gates
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== COPPA Compliance Checklist ===

Threshold Assessment:
  [ ] Determine if site/app is "directed to children" under 13
  [ ] If mixed-audience, implement age-screening mechanism
  [ ] Identify all points where PI is collected
  [ ] Inventory all third-party SDKs/plug-ins and their data practices

Privacy Policy:
  [ ] Policy is prominently linked from homepage
  [ ] Lists all operators collecting PI
  [ ] Describes types of PI collected
  [ ] Explains how PI is used and shared
  [ ] Describes parental rights (review, delete, revoke)
  [ ] States operator won't condition access on excess collection
  [ ] Policy is clear, readable, and up-to-date

Parental Consent:
  [ ] VPC mechanism implemented (FTC-approved method)
  [ ] Direct notice sent to parent before collection
  [ ] Notice describes PI collected and how it's used
  [ ] Parent can decline and child can still use basic features
  [ ] Consent records maintained

Data Practices:
  [ ] Collect only PI reasonably necessary
  [ ] PI retained only as long as needed
  [ ] Reasonable security measures for child PI
  [ ] Child PI not disclosed to unauthorized third parties
  [ ] Third-party recipients maintain adequate protections

Parental Rights:
  [ ] Parents can request review of child's PI
  [ ] Parents can request deletion of child's PI
  [ ] Parents can revoke consent for future collection
  [ ] Respond to parent requests in reasonable timeframe

Third-Party Compliance:
  [ ] Audit all SDKs for COPPA compliance
  [ ] Disable behavioral advertising on child-directed content
  [ ] Contractual obligations for third parties handling child PI
  [ ] Regular monitoring of third-party data practices

Age Verification (if mixed-audience):
  [ ] Age gate does not encourage falsification
  [ ] Age gate uses neutral date entry (not "are you 13?")
  [ ] Under-13 users routed to COPPA-compliant experience
  [ ] Age information not stored as persistent identifier
EOF
}

show_help() {
    cat << EOF
coppa v$VERSION — COPPA Compliance Reference

Usage: script.sh <command>

Commands:
  intro        COPPA overview — history, purpose, and core requirements
  scope        Who COPPA applies to — operators, sites, and thresholds
  data         Personal information defined under COPPA
  consent      Verifiable Parental Consent (VPC) approved methods
  notice       Privacy notice requirements for parents
  safeharbor   COPPA Safe Harbor programs and self-regulation
  enforcement  FTC enforcement actions and notable cases
  checklist    COPPA compliance checklist for developers
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    scope)      cmd_scope ;;
    data)       cmd_data ;;
    consent)    cmd_consent ;;
    notice)     cmd_notice ;;
    safeharbor) cmd_safeharbor ;;
    enforcement) cmd_enforcement ;;
    checklist)  cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "coppa v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
