#!/usr/bin/env bash
# sox — Sarbanes-Oxley Act Compliance Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Sarbanes-Oxley Act (SOX) ===

The Sarbanes-Oxley Act of 2002 (SOX) is a U.S. federal law enacted in
response to corporate accounting scandals (Enron, WorldCom, Tyco).

Purpose:
  - Protect investors from fraudulent financial reporting
  - Improve accuracy and reliability of corporate disclosures
  - Restore public confidence in capital markets

Key Facts:
  Full Name:    Sarbanes-Oxley Act of 2002 (Pub.L. 107-204)
  Sponsors:     Senator Paul Sarbanes, Rep. Michael Oxley
  Signed:       July 30, 2002 by President George W. Bush
  Applies to:   All U.S. public companies (SEC registrants)
  Enforced by:  SEC and PCAOB

Major Provisions:
  Title I     Public Company Accounting Oversight Board (PCAOB)
  Title II    Auditor Independence
  Title III   Corporate Responsibility (CEO/CFO certifications)
  Title IV    Enhanced Financial Disclosures (Section 404)
  Title V     Analyst Conflicts of Interest
  Title VI    Commission Resources and Authority
  Title VII   Studies and Reports
  Title VIII  Corporate Fraud Accountability
  Title IX    White-Collar Crime Penalty Enhancements
  Title X     Corporate Tax Returns
  Title XI    Corporate Fraud and Accountability

Impact:
  - Created PCAOB to oversee auditors of public companies
  - Required CEO/CFO personal certification of financial statements
  - Mandated internal control assessments and auditor attestation
  - Established criminal penalties for securities fraud
  - Average compliance cost: $1-5M/year for large companies
EOF
}

cmd_sections() {
    cat << 'EOF'
=== Key SOX Sections ===

Section 302 — Corporate Responsibility for Financial Reports
  CEO and CFO must personally certify that:
    - They reviewed the report
    - It contains no material misstatements or omissions
    - Financial statements fairly present the company's condition
    - They are responsible for internal controls
    - They disclosed any control deficiencies to auditors
  Frequency: Every quarterly (10-Q) and annual (10-K) filing
  Penalty: Up to $5M fine and/or 20 years imprisonment for willful violations

Section 404 — Management Assessment of Internal Controls
  404(a) — Management must:
    - Assess effectiveness of ICFR (Internal Controls over Financial Reporting)
    - Include assessment in annual report
    - Use a recognized framework (typically COSO)
  404(b) — External auditor must:
    - Attest to and report on management's assessment
    - Issue opinion on effectiveness of ICFR
  Note: 404(b) exemption for smaller reporting companies (<$75M public float)

Section 409 — Real-Time Issuer Disclosures
  Companies must disclose material changes in financial condition
  "on a rapid and current basis" (Form 8-K within 4 business days)
  Material events: acquisitions, dispositions, defaults, delisting

Section 802 — Criminal Penalties for Document Destruction
  Illegal to alter, destroy, conceal, or falsify records
  with intent to impede a federal investigation
  Penalty: Up to 20 years imprisonment
  Applies to auditors retaining workpapers (minimum 7 years)

Section 806 — Whistleblower Protection
  Protects employees who report fraud from retaliation
  Covers discharge, demotion, suspension, threats, harassment
  Employees can file complaints with DOL within 180 days
  Remedies: reinstatement, back pay, compensatory damages

Section 906 — Corporate Responsibility for Financial Reports
  CEO/CFO must certify reports "fully comply" with SEC requirements
  and "fairly present" the financial condition
  Criminal penalties: Up to $5M fine and 20 years (willful)
  Knowing violation: Up to $1M fine and 10 years
EOF
}

cmd_controls() {
    cat << 'EOF'
=== Internal Controls Framework (COSO) ===

SOX Section 404 requires using a recognized framework.
Most companies use COSO (Committee of Sponsoring Organizations).

COSO 2013 Framework — 5 Components:

1. Control Environment
   - Tone at the top (management integrity and ethics)
   - Board of Directors oversight
   - Organizational structure and authority
   - Commitment to competence
   - Accountability mechanisms

2. Risk Assessment
   - Identify risks to financial reporting objectives
   - Assess likelihood and impact
   - Consider fraud risk (incentive, opportunity, rationalization)
   - Identify and assess changes that could affect controls

3. Control Activities
   - Policies and procedures that enforce directives
   Types:
     Preventive    Stop errors before they occur (approvals, segregation)
     Detective     Find errors after they occur (reconciliations, reviews)
     Manual        Human judgment required (management review)
     Automated     System-enforced (access controls, edit checks)
   Key controls:
     - Segregation of duties (authorize ≠ record ≠ custody)
     - Authorization and approval limits
     - Reconciliations (bank, intercompany, subledger)
     - Physical controls (asset safeguarding)

4. Information & Communication
   - Relevant financial information captured and communicated
   - Internal communication (up, down, across)
   - External communication (regulators, auditors, investors)
   - IT systems that support financial reporting

5. Monitoring Activities
   - Ongoing evaluations (daily supervision, metrics)
   - Separate evaluations (internal audit, SOX testing)
   - Report deficiencies to management and board
   - Track remediation of identified issues

Control Deficiency Severity:
  Deficiency          Control does not operate as designed
  Significant         Reasonable possibility of material misstatement
    Deficiency          (less severe than material weakness)
  Material Weakness   Reasonable possibility of material misstatement
                       not being prevented or detected timely
                       → Must be disclosed in 10-K filing
EOF
}

cmd_itgc() {
    cat << 'EOF'
=== IT General Controls (ITGCs) ===

ITGCs support the reliability of automated controls and
financial data integrity. Four key domains:

1. Access to Programs and Data
   Purpose: Only authorized users access financial systems
   Key Controls:
     - User access provisioning (approval workflow)
     - Periodic access reviews (quarterly/semi-annual)
     - Privileged access management (admin accounts)
     - Termination/transfer access removal (<24 hours)
     - Password policies (complexity, rotation, lockout)
     - Segregation of duties in system access
   Common Findings:
     - Stale accounts not removed
     - Shared admin credentials
     - No periodic access review evidence

2. Program Change Management
   Purpose: Changes to financial systems are authorized and tested
   Key Controls:
     - Change request and approval process
     - Segregation: developer ≠ approver ≠ deployer
     - Testing before production deployment
     - Version control and rollback capability
     - Emergency change procedures with post-hoc approval
   Common Findings:
     - Developers with production access
     - Missing test evidence
     - Undocumented emergency changes

3. Program Development (SDLC)
   Purpose: New systems meet business requirements
   Key Controls:
     - Requirements documentation and sign-off
     - Design review and approval
     - User acceptance testing (UAT)
     - Data migration validation
     - Go-live authorization
   Common Findings:
     - Insufficient UAT documentation
     - No data conversion reconciliation

4. Computer Operations
   Purpose: Systems operate reliably for financial processing
   Key Controls:
     - Job scheduling and monitoring
     - Backup and recovery procedures
     - Disaster recovery / business continuity plan
     - Incident management and escalation
     - Batch processing integrity checks
   Common Findings:
     - Untested disaster recovery plan
     - Missing backup restoration tests
     - No monitoring for failed batch jobs
EOF
}

cmd_audit() {
    cat << 'EOF'
=== SOX Audit Process ===

Phase 1: Scoping and Planning
  - Identify significant accounts and disclosures
  - Determine materiality thresholds
    Typical: 5% of pre-tax income, 0.5-1% of revenue
  - Map accounts to business processes
  - Identify relevant IT systems (in-scope applications)
  - Determine locations in scope (quantitative + qualitative)
  - Identify key controls for each process
  Timeline: 3-4 months before year-end

Phase 2: Walkthroughs
  - Trace one transaction end-to-end through each process
  - Verify control design (would it prevent/detect misstatement?)
  - Confirm control owner understands responsibilities
  - Document using flowcharts and narratives
  - Identify gaps in control design
  Timeline: 2-3 months before year-end

Phase 3: Testing
  Testing approaches:
    Inquiry       Ask control owner how control operates
    Observation   Watch control being performed
    Inspection    Examine evidence (approvals, reconciliations)
    Re-performance Re-execute the control procedure

  Sample sizes (risk-based):
    Control Frequency    Typical Sample
    Annual               1 (the instance)
    Quarterly            2-4
    Monthly              3-5
    Weekly               5-15
    Daily                20-30
    Per occurrence        25-40

  Testing must cover entire audit period (usually fiscal year)
  Interim testing + rollforward testing for remaining period

Phase 4: Evaluation and Reporting
  - Aggregate deficiencies by process
  - Evaluate compensating controls for deficiencies
  - Classify: deficiency / significant deficiency / material weakness
  - Management remediation of identified issues
  - External auditor issues opinion on ICFR effectiveness
  - Adverse opinion if material weakness exists at year-end
  Timeline: Within 60-90 days of fiscal year-end

Phase 5: Remediation
  - Develop corrective action plans
  - Assign owners and deadlines
  - Implement fixes and re-test
  - Track closure in GRC system
  - Design sustainable controls (not just fixing one instance)
EOF
}

cmd_penalties() {
    cat << 'EOF'
=== SOX Penalties and Enforcement ===

Criminal Penalties:
  Section 906 (False Certification):
    Knowing:   Up to $1,000,000 fine and/or 10 years imprisonment
    Willful:   Up to $5,000,000 fine and/or 20 years imprisonment

  Section 802 (Document Destruction):
    Up to $250,000 fine and/or 20 years imprisonment
    Applies to anyone who alters/destroys records in federal investigations

  Section 807 (Securities Fraud):
    Up to $5,000,000 fine and/or 25 years imprisonment

  Section 1107 (Whistleblower Retaliation):
    Up to $250,000 fine and/or 10 years imprisonment

Civil Penalties:
  SEC enforcement actions
  Officer and director bars
  Disgorgement of ill-gotten gains
  Civil monetary penalties per violation

PCAOB Enforcement:
  Sanctions against audit firms
    - Censure
    - Temporary or permanent suspension
    - Monetary penalties ($750K individual, $15M firm)
  Required for firms auditing public companies

Notable Enforcement Cases:
  Enron (2001)       Triggered SOX; $74B in shareholder losses
  WorldCom (2002)    $11B accounting fraud; CEO sentenced 25 years
  Tyco (2002)        CEO looted $600M; sentenced to 8-25 years
  HealthSouth (2003) $2.7B fraud; CEO acquitted, CFOs convicted
  Satyam (2009)      India's Enron; $1B fabricated cash balances

Recent Trends:
  - Increased focus on cybersecurity as SOX control
  - Cloud computing and third-party risk in ITGC scope
  - SEC proposed rules on climate-related disclosures
  - Remote work impact on control environment
  - AI/automation in testing and monitoring
EOF
}

cmd_examples() {
    cat << 'EOF'
=== SOX Compliance Scenarios ===

--- Revenue Recognition Controls ---
Risk: Revenue recorded in wrong period or overstated
Key Controls:
  1. System-enforced cutoff (orders cannot ship after period close)
  2. Three-way match: PO → receiving → invoice
  3. Management review of revenue journal entries >$X
  4. Automated calculation of multi-element arrangements
  5. Quarterly analytical review of revenue trends
  Common Finding: Manual journal entries to revenue without
  adequate documentation or independent review

--- Segregation of Duties (SoD) ---
Risk: Single person can initiate and approve transactions
Example Conflict Matrix:
  Create Vendor     ×  Approve Payments     = CONFLICT
  Create PO         ×  Receive Goods        = CONFLICT
  Process Payroll   ×  Add Employees        = CONFLICT
  Post JE           ×  Approve JE           = CONFLICT
Mitigation: Role-based access, compensating detective controls

--- Financial Close Process ---
Risk: Errors in period-end financial statements
Key Controls:
  1. Close calendar with defined deadlines
  2. Account reconciliation (balance sheet accounts monthly)
  3. Journal entry approval (all manual JEs reviewed)
  4. Intercompany elimination and reconciliation
  5. Management review of financial statements (flux analysis)
  6. Disclosure checklist completion
  Typical timeline: 5-10 business days for quarterly close

--- IT Application Control Example ---
ERP System: Three-way match
  PO amount ± tolerance → invoice automatically approved
  Outside tolerance → routed to manager for approval
  Testing: Select sample of invoices, verify matching logic
  Evidence: System configuration screenshot, sample transactions
  Key: Automated controls tested once if ITGCs are effective
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== SOX Compliance Readiness Checklist ===

Governance and Oversight:
  [ ] Audit committee established with financial expert
  [ ] Code of ethics adopted and communicated
  [ ] Whistleblower hotline operational
  [ ] Disclosure committee formed and meeting regularly
  [ ] CEO/CFO certification process documented

Risk Assessment:
  [ ] Significant accounts and disclosures identified
  [ ] Materiality thresholds determined
  [ ] Fraud risk assessment completed
  [ ] Entity-level controls evaluated
  [ ] Risk of material misstatement mapped to controls

Control Documentation:
  [ ] Process narratives/flowcharts current
  [ ] Key controls identified and documented
  [ ] Control owners assigned and acknowledged
  [ ] Control design evaluated (preventive vs detective)
  [ ] Compensating controls documented where needed

IT Controls:
  [ ] In-scope applications identified
  [ ] User access reviews completed and documented
  [ ] Change management procedures followed with evidence
  [ ] Segregation of duties enforced in systems
  [ ] Backup and recovery tested
  [ ] Third-party SOC reports obtained and reviewed (SOC 1 Type II)

Testing and Monitoring:
  [ ] Test plan covers all key controls
  [ ] Sample sizes aligned with control frequency
  [ ] Testing covers full audit period
  [ ] Deficiencies evaluated and classified
  [ ] Remediation plans in place with deadlines

Reporting:
  [ ] Management assessment of ICFR completed
  [ ] Material weaknesses disclosed (if any)
  [ ] External auditor opinion obtained
  [ ] Section 302 certifications signed
  [ ] Section 906 certifications signed
EOF
}

show_help() {
    cat << EOF
sox v$VERSION — Sarbanes-Oxley Act Compliance Reference

Usage: script.sh <command>

Commands:
  intro        SOX overview — history, purpose, and key provisions
  sections     Key SOX sections: 302, 404, 802, 906
  controls     COSO internal controls framework
  itgc         IT General Controls — access, change, operations
  audit        SOX audit process — planning through remediation
  penalties    Penalties and enforcement actions
  examples     Real-world compliance scenarios and findings
  checklist    SOX compliance readiness checklist
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    sections)   cmd_sections ;;
    controls)   cmd_controls ;;
    itgc)       cmd_itgc ;;
    audit)      cmd_audit ;;
    penalties)  cmd_penalties ;;
    examples)   cmd_examples ;;
    checklist)  cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "sox v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
