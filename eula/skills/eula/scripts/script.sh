#!/usr/bin/env bash
# eula — End User License Agreement Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== EULA — End User License Agreement Overview ===

A EULA is a legal contract between a software developer/publisher
and the end user that governs how the software may be used.

What Is a EULA?
  A license agreement (not a sale) that grants the user a limited
  right to use the software under specified conditions. The user
  does not own the software — they receive a license to use it.

EULA vs Terms of Service:
  EULA                              Terms of Service
  ─────────────────────────────     ──────────────────────────
  Software license                  Service usage terms
  Downloaded/installed software     Web-based services (SaaS)
  Focus: license grant/restrictions Focus: acceptable use/policies
  One-time or subscription          Ongoing service relationship
  IP ownership central              Platform rules central
  Often includes installation       Often includes account terms

When Is a EULA Needed?
  - Desktop or mobile applications
  - Downloadable software
  - SDK or API libraries
  - Firmware or embedded software
  - Game software
  - SaaS products (often combined with ToS)
  - Browser extensions
  - WordPress plugins / themes

Key Legal Principles:
  License vs Sale:
    Software is licensed, not sold (per most EULAs)
    UCC Article 2 (sale of goods) may not apply
    Copyright law governs (17 U.S.C. § 106)
    First sale doctrine may be limited

  Contract Formation:
    Requires: offer, acceptance, consideration
    Click-wrap: user clicks "I Agree" → valid contract
    Shrink-wrap: opening package = acceptance (varies)
    Browse-wrap: mere use = acceptance (weakest)

  Enforceability Varies By:
    Jurisdiction (US vs EU vs other)
    Consumer vs business user
    Conspicuousness of terms
    Reasonableness of restrictions
    Whether user had meaningful choice
EOF
}

cmd_grant() {
    cat << 'EOF'
=== License Grant Clauses ===

Standard License Grant Elements:

  1. Scope of License:
     - Personal vs commercial use
     - Single user vs multi-user vs site license
     - Number of installations/devices
     - Territory restrictions (geographic)

  2. License Types:
     Perpetual         One-time purchase, use forever
     Subscription      Time-limited (monthly/annual renewal)
     Evaluation/Trial  Free limited-time evaluation
     Freemium          Free basic + paid premium features
     Per-Seat          License per named user
     Concurrent        License per simultaneous user
     Site License      Unlimited users at one location
     Enterprise        Organization-wide, negotiated terms

  3. Grant Language:
     "Licensor grants Licensee a [non-exclusive, non-transferable,
     revocable, limited] license to [install and use / access] the
     Software on [one device / up to N devices] solely for
     [personal / internal business] purposes, subject to the terms
     of this Agreement."

  Key Modifiers:
     Non-exclusive     Others can also be licensed
     Non-transferable  Cannot give or sell the license
     Revocable         Licensor can terminate
     Limited           Not unlimited rights
     Worldwide         Or specific territories
     Sublicensable     Can the user grant sub-licenses?

  Open Source vs Proprietary:
     Open Source                    Proprietary EULA
     ─────────────────────         ──────────────────
     Can modify source code         No modification
     Can redistribute               No redistribution
     Must comply with license       Must comply with EULA
     (GPL, MIT, Apache, etc.)       Custom restrictions
     Copyright remains w/ author    Copyright w/ company
     No warranty (typically)        No warranty (typically)

  SaaS License Grant:
     "We grant you a limited, non-exclusive right to access
     and use the Service during the Subscription Term for your
     internal business purposes, subject to the terms herein."
     Key: "access and use" not "install"
EOF
}

cmd_restrictions() {
    cat << 'EOF'
=== Common EULA Restrictions ===

Reverse Engineering:
  "You shall not reverse engineer, decompile, disassemble, or
  otherwise attempt to derive the source code of the Software."

  Enforceability:
  - Generally enforceable in US (DMCA supports this)
  - EU: cannot prohibit decompilation for interoperability
    (EU Software Directive, Article 6)
  - May not apply to open-source components

Redistribution:
  "You may not distribute, sublicense, lease, rent, loan, or
  otherwise transfer the Software or any copy thereof to any
  third party."

  Variations:
  - May allow copies for backup purposes
  - May allow transfer with entire device sale
  - Must address both physical and digital distribution

Modification:
  "You may not modify, adapt, translate, or create derivative
  works based upon the Software."

  Note: Limits user's ability to customize or extend
  Exception: API/SDK EULAs often permit integration

Copying:
  "You may make one copy of the Software solely for backup
  or archival purposes."

  Issues:
  - Backup copies are often legally permitted regardless
  - Digital copies for cloud backup unclear
  - Installation itself creates a copy

Commercial Use Restrictions:
  "The Software is licensed for personal, non-commercial use only.
  Any commercial use requires a separate commercial license."

  Define "commercial use" clearly:
  - Direct revenue generation using the software
  - Internal business operations
  - Academic/research vs commercial

Competitive Use:
  "You may not use the Software to develop a competing product
  or service."

  Enforceability varies by jurisdiction
  Must be reasonable in scope

Usage Limitations:
  - Number of users/seats
  - Number of API calls
  - Data volume or storage limits
  - Feature restrictions (free vs paid tiers)
  - Geographic restrictions
  - Industry restrictions (no military/nuclear use)

Circumvention:
  "You shall not circumvent, disable, or interfere with any
  security, licensing, or access control features."

  Supported by DMCA Section 1201 (anti-circumvention)
EOF
}

cmd_ip() {
    cat << 'EOF'
=== Intellectual Property Clauses ===

Software Ownership:
  "The Software is owned by [Company] and is protected by
  copyright laws and international treaty provisions. All
  rights not expressly granted herein are reserved."

  Key principle:
  - License ≠ ownership transfer
  - Copyright, patents, trade secrets remain with developer
  - User receives only the rights explicitly granted
  - "All rights reserved" for anything not mentioned

User-Generated Content:
  "You retain ownership of any content you create using the
  Software. By using the Software, you grant [Company] a
  non-exclusive, worldwide, royalty-free license to [use/
  display/process] your content solely for providing the Service."

  Considerations:
  - Who owns output generated by AI tools?
  - License scope (broad vs narrow)
  - Can company use content for training/improvement?
  - Data portability rights

Feedback & Suggestions:
  "Any feedback, suggestions, or ideas you provide regarding
  the Software shall become the exclusive property of [Company],
  which may use such feedback without restriction or compensation."

  Alternative (less aggressive):
  "You grant [Company] a perpetual, irrevocable, royalty-free
  license to use any feedback you provide to improve the Software."

Trademarks:
  "The name, logo, and all related names, logos, product and
  service names are trademarks of [Company]. You may not use
  these marks without prior written permission."

  Restrictions:
  - No use in user's marketing without permission
  - No modification of trademarks
  - No registration of similar marks

Third-Party Components:
  "The Software may include third-party components subject to
  separate license terms. Such terms are set forth in the
  THIRD_PARTY_LICENSES file or documentation."

  Requirements:
  - List all open-source components used
  - Include their respective license texts
  - Comply with attribution requirements
  - Ensure license compatibility
  - GPL components require special attention (copyleft)

Trade Secrets:
  "The Software contains trade secrets and proprietary
  information of [Company]. You agree to maintain the
  confidentiality of such information."
EOF
}

cmd_liability() {
    cat << 'EOF'
=== Liability & Warranty Clauses ===

Warranty Disclaimer:
  "THE SOFTWARE IS PROVIDED 'AS IS' WITHOUT WARRANTY OF ANY
  KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
  IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
  PARTICULAR PURPOSE, AND NONINFRINGEMENT."

  Must be CONSPICUOUS (caps, bold, or highlighted)
  Under UCC, must specifically mention "merchantability"

Limited Warranty (alternative to full disclaimer):
  "Licensor warrants that the Software will perform substantially
  in accordance with the documentation for [90 days / 1 year]
  from the date of purchase. Licensor's sole obligation under
  this warranty shall be, at Licensor's option, to repair or
  replace the Software."

  Limits:
  - Time-limited (not indefinite)
  - Performance standard (not bug-free)
  - Remedy specified (repair/replace, not unlimited damages)

Limitation of Liability:
  "IN NO EVENT SHALL [COMPANY] BE LIABLE FOR ANY INDIRECT,
  INCIDENTAL, SPECIAL, CONSEQUENTIAL, OR PUNITIVE DAMAGES,
  INCLUDING BUT NOT LIMITED TO LOSS OF PROFITS, DATA, USE,
  GOODWILL, OR OTHER INTANGIBLE LOSSES."

  Damage Cap:
  "TOTAL LIABILITY SHALL NOT EXCEED THE AMOUNT PAID BY YOU
  FOR THE SOFTWARE IN THE [12 MONTHS / PERIOD] PRECEDING
  THE CLAIM."

  Cannot Disclaim (typically):
  - Death or personal injury from negligence
  - Fraud or fraudulent misrepresentation
  - Gross negligence or willful misconduct
  - Statutory consumer rights (varies by jurisdiction)

Indemnification:
  "You agree to indemnify and hold harmless [Company] from
  any claims, damages, losses, or expenses arising from your
  use of the Software or violation of this Agreement."

  Direction:
  - User indemnifies developer (most common in EULA)
  - Developer indemnifies user (enterprise/B2B agreements)
  - Mutual indemnification (balanced enterprise deals)

  IP Indemnity (enterprise):
  "Licensor shall defend and indemnify Licensee against any
  third-party claim that the Software infringes any patent
  or copyright."

Data Loss Disclaimer:
  "Licensor shall not be liable for any loss, corruption,
  or unauthorized access to your data. You are solely
  responsible for maintaining backup copies of your data."
EOF
}

cmd_termination() {
    cat << 'EOF'
=== Termination Clauses ===

Termination for Breach:
  "This Agreement and the license granted hereunder will
  terminate automatically if you fail to comply with any
  term or condition of this Agreement."

  Options:
  - Automatic termination (immediate upon breach)
  - Termination with cure period (30 days to fix)
  - Termination with notice (written notice required)

Termination for Convenience:
  "Either party may terminate this Agreement at any time
  by providing [30 days] written notice to the other party."

  For subscriptions:
  - Non-renewal at end of term
  - Mid-term cancellation (refund policy?)
  - Auto-renewal disclosure requirements

Effects of Termination:
  User Must:
  - Cease all use of the Software
  - Uninstall/delete all copies
  - Destroy any documentation
  - Certify destruction in writing (if requested)

  Licensor May:
  - Deactivate license keys
  - Disable access to online features
  - Delete user account and data
  - Provide data export period (grace period)

Survival Clauses:
  "The following sections shall survive termination:
  [IP Ownership, Warranty Disclaimer, Limitation of Liability,
  Confidentiality, Governing Law, Dispute Resolution]."

  Should survive termination:
  - Intellectual property rights
  - Confidentiality obligations
  - Limitation of liability
  - Indemnification
  - Dispute resolution
  - Any accrued payment obligations

Subscription-Specific:
  Auto-Renewal:
  "Subscriptions automatically renew for successive [monthly/
  annual] periods unless cancelled [30 days] before renewal."

  Refund Policy:
  - Pro-rata refund for unused time?
  - No refund for mid-term cancellation?
  - Free trial conversion rules
  - Must comply with app store policies (Apple, Google)

  Data After Termination:
  "Upon termination, your data will be retained for [30 days]
  to allow export. After this period, data will be permanently
  deleted."
EOF
}

cmd_enforcement() {
    cat << 'EOF'
=== EULA Enforceability ===

Formation Methods (strongest to weakest):

  1. Signed Agreement (strongest):
     - Physical or electronic signature (ESIGN Act / eIDAS)
     - Clear mutual assent
     - Used for enterprise/B2B licenses

  2. Click-Wrap (strong):
     - User must click "I Agree" or check a box
     - Full text available before acceptance
     - Scroll requirement (some jurisdictions)
     - Generally enforceable (ProCD v. Zeidenberg)

  3. Shrink-Wrap (moderate):
     - Terms inside sealed package
     - Opening package = acceptance
     - Enforceability varies by jurisdiction
     - Less common in digital era

  4. Browse-Wrap (weakest):
     - Terms available via hyperlink
     - No affirmative action required
     - Often NOT enforceable (Specht v. Netscape)
     - Must show "inquiry notice" (user should have seen it)

Enforceability Factors:
  ✓ User had notice of terms
  ✓ User took affirmative action to accept
  ✓ Terms were available before purchase/use
  ✓ Terms are readable and accessible
  ✓ User is of legal age to contract
  ✓ Adequate consideration exists
  ✗ Terms are unconscionable (substantive or procedural)
  ✗ Terms violate statutory consumer rights
  ✗ No meaningful choice (adhesion contract issues)

Key Court Cases (US):
  ProCD v. Zeidenberg (1996)
    Shrink-wrap license enforceable
    Terms inside box accepted by use

  Specht v. Netscape (2002)
    Browse-wrap NOT enforceable
    Users didn't have to scroll past terms

  Nguyen v. Barnes & Noble (2014)
    Browse-wrap link insufficient
    No "reasonably conspicuous notice"

  Meyer v. Uber (2017)
    Small hyperlink in registration flow
    Not conspicuous enough for arbitration clause

EU Consumer Protections:
  Unfair Contract Terms Directive:
    - Terms must be in plain language
    - Unfair terms not binding on consumers
    - Core terms exempt only if clear/plain
    - Significant imbalance = unfair

  Consumer Rights Directive:
    - 14-day withdrawal right for digital content
    - Must inform before withdrawal right is waived
    - Pre-contractual information requirements

Best Practices for Enforcement:
  1. Use click-wrap (not browse-wrap)
  2. Require scrolling before "I Agree" button activates
  3. Make terms readable (not 50 pages of legalese)
  4. Version and date the EULA
  5. Notify users of material changes
  6. Re-consent for significant updates
  7. Keep records of acceptance (timestamp, IP, version)
  8. Separate arbitration clause with explicit consent
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== EULA Drafting Checklist ===

Core Provisions:
  [ ] License grant (scope, type, duration)
  [ ] License restrictions clearly stated
  [ ] Intellectual property ownership affirmed
  [ ] Warranty disclaimer (conspicuous)
  [ ] Limitation of liability
  [ ] Termination provisions
  [ ] Governing law and jurisdiction

User Rights:
  [ ] Permitted uses clearly described
  [ ] Number of installations/devices specified
  [ ] Backup copy rights addressed
  [ ] Transfer/assignment rights (or restrictions)
  [ ] Free trial terms (if applicable)
  [ ] Subscription auto-renewal disclosure

Restrictions:
  [ ] Reverse engineering prohibition
  [ ] Redistribution prohibition
  [ ] Modification restrictions
  [ ] Commercial use restrictions (if applicable)
  [ ] Competitive use restrictions (if applicable)
  [ ] Usage limits (API calls, storage, users)

Data & Privacy:
  [ ] Data collection disclosure
  [ ] Privacy policy reference or inclusion
  [ ] User content ownership clarified
  [ ] Data portability/export rights
  [ ] Data handling on termination
  [ ] Analytics/telemetry disclosure

Third-Party:
  [ ] Third-party component licenses listed
  [ ] Open-source attribution included
  [ ] Third-party service disclaimers
  [ ] App store terms compliance (Apple, Google)

Technical:
  [ ] System requirements stated
  [ ] Update/upgrade policy
  [ ] Support terms (scope, hours, channels)
  [ ] Service level agreements (if SaaS)
  [ ] Maintenance windows and downtime policy

Legal:
  [ ] Dispute resolution mechanism (arbitration, courts)
  [ ] Class action waiver (where enforceable)
  [ ] Export compliance statement
  [ ] Government use restrictions
  [ ] Severability clause
  [ ] Entire agreement clause
  [ ] Amendment/modification process

Presentation:
  [ ] Plain language (readable by non-lawyers)
  [ ] Effective date clearly shown
  [ ] Version number for tracking
  [ ] Click-wrap acceptance mechanism
  [ ] Conspicuous warranty/liability sections
  [ ] Table of contents for long agreements
  [ ] Available in user's language (if international)
  [ ] Acceptance records retained (timestamp, version, IP)
EOF
}

show_help() {
    cat << EOF
eula v$VERSION — End User License Agreement Reference

Usage: script.sh <command>

Commands:
  intro        EULA overview — purpose, legal basis, EULA vs ToS
  grant        License grant clauses — scope, types, language
  restrictions Common restrictions — reverse engineering, redistribution
  ip           Intellectual property — ownership, user content, trademarks
  liability    Liability limits, warranty disclaimers, indemnification
  termination  Termination — breach, convenience, effects, survival
  enforcement  Enforceability — click-wrap, browse-wrap, court cases
  checklist    EULA drafting checklist
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)       cmd_intro ;;
    grant)       cmd_grant ;;
    restrictions) cmd_restrictions ;;
    ip)          cmd_ip ;;
    liability)   cmd_liability ;;
    termination) cmd_termination ;;
    enforcement) cmd_enforcement ;;
    checklist)   cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "eula v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
