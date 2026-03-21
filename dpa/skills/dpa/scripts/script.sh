#!/usr/bin/env bash
# dpa — Data Processing Agreement Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Data Processing Agreements (DPA) Overview ===

A Data Processing Agreement is a legally binding contract between a
data controller and a data processor, required under GDPR Article 28
whenever personal data processing is outsourced.

What Is a DPA?
  A contract that sets out the terms and conditions for how a
  processor handles personal data on behalf of a controller.

When Is a DPA Required?
  Whenever a controller engages a processor to handle personal data:
  - Cloud hosting providers (AWS, Azure, GCP)
  - SaaS tools (CRM, email marketing, analytics)
  - Payroll processors
  - Customer support outsourcing
  - Data analytics vendors
  - IT service providers with system access
  - Backup and disaster recovery services

When Is a DPA NOT Required?
  - Employee relationships (not a processor relationship)
  - Joint controllers (need a joint controller agreement instead)
  - Data shared with independent controllers
  - Professional advisors acting in their own capacity (lawyers, auditors)
  - One-off data access without systematic processing

Legal Basis:
  GDPR Article 28     EU/EEA mandatory requirement
  UK GDPR Article 28  UK equivalent (post-Brexit)
  LGPD Article 39     Brazilian equivalent
  POPIA Section 19    South African equivalent
  PDPA                Singapore, Thailand equivalents

Consequences of No DPA:
  - Administrative fines up to €10M or 2% of global turnover
  - Regulatory enforcement action
  - Loss of customer trust
  - Insurance coverage issues
  - Contractual liability to data subjects
  - Inability to demonstrate GDPR compliance
EOF
}

cmd_article28() {
    cat << 'EOF'
=== GDPR Article 28 Requirements ===

Article 28 sets out mandatory terms that MUST be in every DPA:

28(3)(a) — Documented Instructions
  Processor shall process data ONLY on documented instructions
  from the controller, including transfers to third countries.
  Exception: required by EU or Member State law.

28(3)(b) — Confidentiality
  Processor must ensure that persons authorized to process
  personal data have committed to confidentiality or are
  under statutory obligation of confidentiality.

28(3)(c) — Security Measures
  Processor must take all measures required under Article 32:
  - Pseudonymization and encryption
  - Confidentiality, integrity, availability, resilience
  - Ability to restore availability after incident
  - Regular testing and evaluation of measures

28(3)(d) — Sub-processor Conditions
  Processor must not engage sub-processors without:
  - Prior specific authorization, OR
  - Prior general written authorization (with notification right)
  Sub-processor must have same data protection obligations.

28(3)(e) — Data Subject Rights Assistance
  Processor must assist controller in responding to data
  subject requests (access, rectification, erasure, portability).

28(3)(f) — Security, Breach, and DPIA Assistance
  Processor must assist controller with:
  - Article 32 security obligations
  - Article 33-34 breach notification
  - Article 35-36 DPIA and prior consultation

28(3)(g) — Deletion or Return
  After end of processing, processor must:
  - Delete or return all personal data (controller's choice)
  - Delete existing copies (unless law requires retention)

28(3)(h) — Audit Rights
  Processor must make available all information necessary
  to demonstrate compliance and allow for audits and
  inspections by the controller or appointed auditor.

Article 28(9) — Written Form
  The DPA must be in writing, including electronic form.
EOF
}

cmd_roles() {
    cat << 'EOF'
=== Controller vs Processor vs Sub-Processor ===

Data Controller:
  Definition: Determines the purposes and means of processing
  Examples:
    - Company collecting customer data
    - Employer processing employee data
    - Hospital managing patient records

  Obligations:
    - Determine lawful basis for processing
    - Provide privacy notices to data subjects
    - Respond to data subject requests
    - Conduct DPIAs when required
    - Select compliant processors
    - Execute DPAs with all processors
    - Report breaches to supervisory authority (72 hours)

Data Processor:
  Definition: Processes personal data on behalf of the controller
  Examples:
    - Cloud hosting provider storing data
    - Payroll company processing salaries
    - Email service provider sending newsletters
    - Analytics tool tracking website usage

  Obligations:
    - Process only on controller's documented instructions
    - Maintain records of processing (Article 30)
    - Implement appropriate security measures
    - Assist controller with data subject requests
    - Notify controller of data breaches without undue delay
    - Appoint DPO if required
    - Not engage sub-processors without authorization

Sub-Processor:
  Definition: A processor engaged by another processor
  Example: Cloud provider (processor) using CDN service (sub-processor)

  Chain of Liability:
    Controller ← DPA → Processor ← DPA → Sub-Processor
    Initial processor remains fully liable to controller
    for sub-processor's performance

Determining Roles (key questions):
  1. Who decides WHY data is processed?     → Controller
  2. Who decides HOW data is processed?     → May be shared
  3. Who benefits from the processing?      → Usually controller
  4. Whose customers/users are the data subjects? → Controller
  5. Does the entity have its own purpose for the data? → Controller

Joint Controllers (Article 26):
  When two+ parties jointly determine purposes and means
  Requires: Joint Controller Agreement
  Each controller responsible for their part of compliance
  Data subjects can exercise rights against either controller
EOF
}

cmd_clauses() {
    cat << 'EOF'
=== Essential DPA Clauses ===

1. Scope & Purpose
   - Description of processing activities
   - Types of personal data processed
   - Categories of data subjects
   - Duration of processing
   - Nature and purpose of processing
   - Must be specific (not "all purposes")

2. Processor Obligations
   - Process only on documented instructions
   - Not process for own purposes
   - Maintain confidentiality
   - Implement security measures (per Article 32)
   - Assist with data subject requests
   - Assist with DPIAs and breach notification
   - Return or delete data on termination

3. Controller Obligations
   - Provide lawful instructions
   - Ensure lawful basis for processing
   - Provide data only as needed
   - Respond to data subject requests promptly
   - Conduct due diligence on processor

4. Security Measures (Article 32)
   - Encryption at rest and in transit
   - Access controls (RBAC, MFA)
   - Regular security testing
   - Incident response procedures
   - Business continuity / disaster recovery
   - Employee training and awareness
   - Physical security measures
   - Specific measures should be listed in annex

5. Sub-Processor Management
   - Authorization mechanism (specific or general)
   - Notification requirements for changes
   - Objection rights for controller
   - Flow-down of DPA obligations
   - Current sub-processor list (annex or URL)

6. Data Breach Notification
   - "Without undue delay" (typically 24-48 hours)
   - Information to provide (nature, scope, measures)
   - Cooperation requirements
   - Documentation obligations

7. International Transfers
   - Transfer mechanisms (SCCs, adequacy, BCRs)
   - Supplementary measures if required
   - Transfer impact assessment obligations

8. Audit Rights
   - Controller's right to audit processor
   - Reasonable notice period (typically 30 days)
   - Scope of audit
   - Cost allocation
   - Acceptance of third-party audit reports

9. Liability & Indemnification
   - Allocation of liability between parties
   - Indemnification for breaches of DPA
   - Insurance requirements

10. Term & Termination
    - DPA term aligns with service agreement
    - Data return/deletion upon termination
    - Survival clauses (which obligations persist)
    - Transition assistance period
EOF
}

cmd_subprocessors() {
    cat << 'EOF'
=== Sub-Processor Management ===

Authorization Models:

  Specific Authorization:
    - Controller approves each sub-processor individually
    - More control but operationally heavy
    - Processor must request approval before engaging

  General Written Authorization (more common):
    - Controller gives blanket authorization
    - Processor must notify of changes
    - Controller has right to object
    - Objection window (typically 30 days)
    - If controller objects → termination right or processor
      must not use that sub-processor for controller's data

Notification Requirements:
  Processor must inform controller of:
    - New sub-processors being added
    - Changes to existing sub-processors
    - Removal of sub-processors
    
  Notification methods:
    - Email to designated contact
    - Published list (URL in DPA)
    - Subscription notification service
    - Registered webhook

Sub-Processor DPA Requirements:
  Same Article 28 obligations must flow down:
    - Process only on instructions
    - Security measures
    - Confidentiality
    - Breach notification
    - Deletion/return on termination
    - Audit rights (controller can audit sub-processor)

Liability Chain:
  Controller → Processor → Sub-Processor
  
  Key principle: Initial processor remains FULLY LIABLE to the
  controller for the sub-processor's performance.
  
  If sub-processor fails:
    1. Controller claims against processor
    2. Processor claims against sub-processor (back-to-back)
    3. Controller cannot typically go directly to sub-processor

Common Sub-Processor Categories:
  Infrastructure:  AWS, Azure, GCP, data centers
  CDN:             Cloudflare, Fastly, Akamai
  Email:           SendGrid, Mailgun, SES
  Support:         Zendesk, Intercom
  Analytics:       Datadog, New Relic
  Payment:         Stripe, Adyen
  Communication:   Twilio, Vonage

Best Practices:
  - Maintain current sub-processor register
  - Review sub-processor list at least annually
  - Conduct due diligence before approving sub-processors
  - Ensure geographic restrictions are respected
  - Monitor sub-processor compliance
  - Have contingency plans for sub-processor changes
EOF
}

cmd_transfers() {
    cat << 'EOF'
=== Cross-Border Data Transfers ===

GDPR restricts transfers of personal data outside the EEA
unless adequate safeguards are in place.

Transfer Mechanisms:

1. Adequacy Decisions (Article 45)
   Countries deemed adequate by EU Commission:
   - Andorra, Argentina, Canada (PIPEDA), Faroe Islands
   - Guernsey, Israel, Isle of Man, Japan, Jersey
   - New Zealand, Republic of Korea, Switzerland
   - United Kingdom, Uruguay
   - EU-US Data Privacy Framework (2023)
   
   No additional safeguards needed for adequate countries.

2. Standard Contractual Clauses (SCCs) (Article 46)
   EU Commission-approved contract templates:
   
   Module 1: Controller → Controller
   Module 2: Controller → Processor (most common for DPAs)
   Module 3: Processor → Sub-Processor
   Module 4: Processor → Controller
   
   Requirements:
   - Cannot be modified (but annexes are customizable)
   - Must complete Transfer Impact Assessment (TIA)
   - Supplementary measures may be required
   - Must be kept up to date

3. Binding Corporate Rules (BCRs) (Article 47)
   - For multinational groups
   - Approved by lead supervisory authority
   - Covers intra-group transfers globally
   - Expensive and time-consuming to implement (12-24 months)

4. Derogations (Article 49) — Limited Use
   - Explicit consent (informed, specific)
   - Necessary for contract performance
   - Important public interest
   - Legal claims
   - Vital interests
   - Public register data

Transfer Impact Assessment (TIA):
  Required for SCCs — assess destination country's laws:
  1. Nature of data being transferred
  2. Purpose and context of transfer
  3. Destination country's legal framework
  4. Government surveillance laws
  5. Rule of law and judicial independence
  6. Whether supplementary measures can bridge gaps

Supplementary Measures:
  Technical:   Encryption (controller holds keys), pseudonymization
  Contractual: Additional contractual commitments
  Organizational: Transparency reports, warrant canaries
EOF
}

cmd_breaches() {
    cat << 'EOF'
=== Data Breach Handling in DPAs ===

Breach Notification Timeline:

  Processor → Controller:
    "Without undue delay" after becoming aware
    Best practice: within 24 hours
    Some DPAs specify: within 48 or 72 hours
    Cannot wait for full investigation to notify

  Controller → Supervisory Authority:
    Within 72 hours of becoming aware (GDPR Article 33)
    Must include available information, can supplement later

  Controller → Data Subjects:
    "Without undue delay" if high risk to rights/freedoms
    Must describe likely consequences and measures taken

DPA Breach Notification Clause Should Include:

  Processor Must Notify Controller Of:
    - Nature of the breach
    - Categories and approximate number of data subjects
    - Categories and approximate number of records
    - Name and contact of DPO or contact point
    - Likely consequences of the breach
    - Measures taken or proposed to address the breach
    - Measures to mitigate possible adverse effects

  Processor Obligations During Breach:
    - Immediately contain the breach
    - Preserve evidence for investigation
    - Cooperate fully with controller's investigation
    - Not communicate with data subjects without controller's consent
    - Not communicate with media without controller's consent
    - Provide ongoing updates as information becomes available
    - Implement remediation measures as directed

  Controller Obligations:
    - Assess risk to data subjects
    - Determine whether to notify supervisory authority
    - Determine whether to notify data subjects
    - Coordinate messaging and response
    - Document the breach (Article 33(5))

Breach Documentation Requirements:
  Must record regardless of notification threshold:
    - Facts relating to the breach
    - Effects of the breach
    - Remedial action taken
    - Reasoning if no notification was made

Common DPA Weaknesses in Breach Clauses:
  ✗ Vague notification timeline ("promptly" instead of hours)
  ✗ No obligation to preserve evidence
  ✗ No restriction on processor contacting data subjects
  ✗ No ongoing cooperation obligation
  ✗ Missing cost allocation for breach response
  ✗ No root cause analysis requirement
  ✗ No post-breach improvement obligation
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== DPA Review Checklist ===

Article 28 Mandatory Requirements:
  [ ] Processing only on documented instructions
  [ ] Confidentiality obligations for personnel
  [ ] Appropriate security measures (Article 32)
  [ ] Sub-processor authorization mechanism
  [ ] Assistance with data subject requests
  [ ] Assistance with security, breach, and DPIA obligations
  [ ] Data deletion or return on termination
  [ ] Audit rights for controller

Scope & Description:
  [ ] Subject matter of processing defined
  [ ] Duration specified (or tied to service agreement)
  [ ] Nature and purpose of processing clear
  [ ] Types of personal data listed
  [ ] Categories of data subjects identified
  [ ] Special category data handling addressed (if applicable)

Security:
  [ ] Specific technical measures listed (encryption, access control)
  [ ] Organizational measures described
  [ ] Regular testing and assessment commitment
  [ ] Security annex or appendix with detail
  [ ] Right to update security measures over time

Sub-Processors:
  [ ] Authorization model clear (specific or general)
  [ ] Notification mechanism defined
  [ ] Objection right with reasonable timeframe
  [ ] Current sub-processor list available
  [ ] Flow-down obligations confirmed
  [ ] Processor remains liable for sub-processors

International Transfers:
  [ ] Transfer mechanisms identified (SCCs, adequacy, etc.)
  [ ] Countries where data may be processed listed
  [ ] Transfer Impact Assessment addressed
  [ ] Supplementary measures if required
  [ ] Controller approval for new transfer destinations

Breach Notification:
  [ ] Specific notification timeframe (hours, not "promptly")
  [ ] Required notification content defined
  [ ] Cooperation obligations clear
  [ ] Evidence preservation required
  [ ] Cost allocation for breach response addressed

Termination:
  [ ] Data return procedure defined
  [ ] Data deletion confirmation required
  [ ] Retention exceptions documented
  [ ] Transition assistance period specified
  [ ] Survival clauses identified

Practical Items:
  [ ] DPA is executed (signed by both parties)
  [ ] Contact points for data protection matters identified
  [ ] DPA version tracked and dated
  [ ] Review schedule established (annual recommended)
  [ ] Consistent with main service agreement
  [ ] Governing law and jurisdiction specified
EOF
}

show_help() {
    cat << EOF
dpa v$VERSION — Data Processing Agreement Reference

Usage: script.sh <command>

Commands:
  intro          DPA overview — what, when, and legal basis
  article28      GDPR Article 28 mandatory requirements
  roles          Controller vs Processor vs Sub-processor roles
  clauses        Essential DPA clauses and structure
  subprocessors  Sub-processor management and authorization
  transfers      Cross-border data transfers and mechanisms
  breaches       Data breach handling and notification
  checklist      DPA review checklist for compliance
  help           Show this help
  version        Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)         cmd_intro ;;
    article28)     cmd_article28 ;;
    roles)         cmd_roles ;;
    clauses)       cmd_clauses ;;
    subprocessors) cmd_subprocessors ;;
    transfers)     cmd_transfers ;;
    breaches)      cmd_breaches ;;
    checklist)     cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "dpa v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
