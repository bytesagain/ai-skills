#!/usr/bin/env bash
# civil-service — Public Administration Reference
set -euo pipefail
VERSION="5.0.0"

cmd_intro() { cat << 'EOF'
# Public Administration & Civil Service — Overview

## Civil Service Systems Worldwide
  Merit-Based Systems:
    Weberian Model: Professional bureaucracy, career civil servants
    Countries: Germany, France (ENA), UK (Senior Civil Service), Japan
    Key features: Competitive exams, tenure, political neutrality

  Patronage/Spoils System:
    Political appointments, loyalty-based, turnover with elections
    Historical: US pre-1883 (before Pendleton Act)
    Modern remnants: Political appointees in top positions (US ~4,000)

  Hybrid Systems:
    Most modern democracies: Career service + political appointees
    US: Senior Executive Service (SES) bridges career and political
    China: National Civil Service Exam (国考) + party appointments

## Key Principles
  Merit:          Hiring based on competence, not connections
  Neutrality:     Serve any government impartially
  Accountability: Answerable to elected officials and public
  Rule of Law:    Act within legal authority
  Transparency:   Open records, public reporting
  Equity:         Equal treatment regardless of background

## Scale of Government Employment
  China:          ~7.2 million civil servants + 50M public sector
  India:          ~3.1 million central government employees
  United States:  ~2.1 million federal civilian employees
  European Union: ~46,000 EU institution staff
  UK:             ~485,000 civil servants
  Most spend 30-50% of GDP through public sector
EOF
}

cmd_standards() { cat << 'EOF'
# Government Standards & Frameworks

## Weberian Bureaucracy Principles (Max Weber)
  1. Hierarchical organization (clear chain of command)
  2. Formal rules and procedures (SOPs for consistency)
  3. Division of labor and specialization
  4. Impersonal relationships (decisions by rules, not favoritism)
  5. Career advancement based on merit and seniority
  6. Written documentation (everything on record)

## New Public Management (NPM) Reforms
  Origin: UK (Thatcher), NZ, Australia in 1980s-90s
  Core ideas:
    - Run government like a business (efficiency focus)
    - Performance measurement and accountability
    - Decentralization and agency autonomy
    - Competitive tendering and privatization
    - Customer orientation (citizens as customers)
  Criticism: Undermines public service ethos, gaming of metrics

## Good Governance Indicators (World Bank)
  1. Voice and Accountability
  2. Political Stability and Absence of Violence
  3. Government Effectiveness
  4. Regulatory Quality
  5. Rule of Law
  6. Control of Corruption
  Top ranked (2024): Denmark, Finland, Switzerland, New Zealand
  Assessment: wgi.worldbank.org (updated annually)

## Digital Government Standards
  OECD Digital Government Policy Framework:
    1. Digital by design (not just digitizing paper)
    2. Data-driven public sector
    3. Government as a platform
    4. Open by default
    5. User-driven
    6. Proactiveness
  E-Government Development Index (UN): Denmark, Finland, Korea top 3
EOF
}

cmd_troubleshooting() { cat << 'EOF'
# Government Operations Troubleshooting

## Red Tape Reduction
  Problem: Excessive bureaucracy slows service delivery
  Common causes:
    - Legacy regulations never reviewed/sunset
    - Risk-averse culture (more forms = more covered)
    - Siloed departments with redundant requirements
  Solutions:
    - Regulatory guillotine: Catalog all regulations, eliminate outdated
    - One-stop shop: Single window for multiple services
    - "Tell us once" principle: Don't ask citizens for info government already has
    - Automatic approvals: If no response in X days, application approved
    - Estonia model: X-Road platform, 99% of services online

## Interagency Coordination Failures
  Problem: Agencies don't share information or collaborate
  Causes: Turf wars, incompatible IT systems, legal barriers to data sharing
  Solutions:
    - Interagency task forces with clear mandate and sunset date
    - Shared data infrastructure (government data exchange platform)
    - MOU (Memorandum of Understanding) between agencies
    - Joint performance metrics (measured on shared outcomes)
    - Chief Data Officer with cross-agency authority

## Citizen Complaint Handling
  Best practices:
    1. Multi-channel intake: Online, phone, in-person, mail
    2. Acknowledgment within 24 hours
    3. Classification: Urgent (<3 days), Standard (<14 days), Complex (<30 days)
    4. Tracking number for citizen follow-up
    5. Root cause analysis (not just individual resolution)
    6. Published complaint statistics (transparency)
  Ombudsman: Independent body for government accountability
  International standard: ISO 10002 (complaint management systems)

## Procurement Bottlenecks
  Problem: Government procurement takes 6-18 months
  Solutions: Dynamic purchasing systems, framework agreements,
  e-procurement platforms, raising small purchase thresholds,
  agile procurement for IT (break into smaller contracts)
EOF
}

cmd_performance() { cat << 'EOF'
# Government Performance Management

## Key Performance Indicators (KPIs) for Public Services
  Service delivery:
    - Processing time (average days to complete)
    - First-contact resolution rate
    - Citizen satisfaction score (CSAT)
    - Digital take-up rate (% using online channel)
    - Error rate in decisions/processing

  Financial:
    - Cost per transaction
    - Budget execution rate (spent/allocated)
    - Revenue collection efficiency
    - Procurement savings percentage

  HR/Workforce:
    - Employee engagement score
    - Vacancy rate and time-to-hire
    - Training hours per employee
    - Diversity representation at senior levels

## E-Government Maturity Model (UN)
  Stage 1 — Emerging:   Basic information online (one-way)
  Stage 2 — Enhanced:   Downloadable forms, email contact
  Stage 3 — Transactional: Complete services online (payments, applications)
  Stage 4 — Connected:  Integrated services across agencies, proactive
  Top: Denmark (0.99), Finland (0.98), Korea (0.98), Estonia (0.97)

## Digital Transformation Metrics
  Digital channel shift: % of transactions completed online
    Target: >80% for routine services (licenses, permits, payments)
  User satisfaction: System Usability Scale (SUS) >70 = "good"
  Cost reduction: Digital transaction = ~$0.10 vs in-person = ~$15
  Uptime: Government services SLA typically 99.5-99.9%
  Accessibility: WCAG 2.1 AA compliance mandatory in most countries

## Balanced Scorecard for Government
  Adapted from Kaplan & Norton:
    Mission (replaces Financial): Are we achieving public outcomes?
    Stakeholder: Are citizens satisfied? Are elected officials informed?
    Internal Process: Are operations efficient and compliant?
    Learning & Growth: Is the workforce capable and engaged?
EOF
}

cmd_security() { cat << 'EOF'
# Government Information Security

## Data Protection in Government
  Classification levels (US):
    Top Secret:     Grave damage to national security
    Secret:         Serious damage to national security
    Confidential:   Damage to national security
    CUI:            Controlled Unclassified Information
    Public:         No restrictions

  GDPR impact on government (EU):
    - Government agencies cannot rely on "legitimate interest"
    - Must use "public task" or "legal obligation" as legal basis
    - Data Protection Impact Assessment required for high-risk processing
    - Citizens retain right to access, rectify, object
    - DPO (Data Protection Officer) mandatory for all public authorities

## FISMA (US Federal)
  Federal Information Security Modernization Act
  Requirements:
    - Inventory all information systems
    - Categorize by impact level (Low/Moderate/High) per FIPS 199
    - Apply NIST SP 800-53 security controls
    - Continuous monitoring program
    - Annual security assessments
    - Report to Congress through OMB
  FedRAMP: Cloud services must be FedRAMP authorized

## Government Cybersecurity
  Common threats: Ransomware, phishing, insider threats, APTs
  Recent incidents: SolarWinds (2020), OPM breach (2015, 22M records)
  Zero Trust Architecture: NIST SP 800-207, required by EO 14028
  CISA (US): Binding Operational Directives for federal agencies
  Multi-Factor Authentication: Required for all federal employees
  Incident response: 72-hour reporting requirement (CIRCIA Act)

## Classified Information Handling
  Need-to-know basis: Clearance alone is not sufficient
  Physical security: SCIFs (Sensitive Compartmented Information Facilities)
  Digital: Air-gapped networks (SIPRNet for Secret, JWICS for Top Secret)
  Violations: Criminal penalties under Espionage Act, administrative sanctions
  Whistleblower protections: Legal channels exist (IG, Congressional committees)
EOF
}

cmd_migration() { cat << 'EOF'
# Government Modernization Guide

## Paper → Digital Government
  Phase 1 (Months 1-6): Foundation
    - Inventory all services and forms
    - Prioritize by volume and citizen impact
    - Establish digital identity system (eID)
    - Choose cloud strategy (government cloud or public)

  Phase 2 (Months 6-18): Core Services
    - Digitize top 20 highest-volume services first
    - Implement e-signature (legally binding under eIDAS/ESIGN Act)
    - Create citizen portal (single sign-on)
    - Build API layer for inter-agency data sharing

  Phase 3 (Months 18-36): Integration
    - "No wrong door" policy: Any entry point, correct routing
    - Proactive services: Government acts without citizen request
    - Open data portal for transparency
    - AI-assisted case processing for routine decisions

  Success examples:
    Estonia: 99% services online, X-Road data exchange, e-Residency
    Singapore: SingPass + Moments of Life app
    UK: GOV.UK unified portal, Government Digital Service (GDS)
    Denmark: Digital Post (mandatory digital mailbox for citizens)

## Legacy IT Modernization
  Challenges: COBOL systems from 1960s still running tax/benefits
  US: $100B+ annual IT spending, 80% on maintenance
  Strategies:
    - Encapsulate: Wrap legacy with APIs (short-term)
    - Re-platform: Move to modern infrastructure (medium-term)
    - Re-architect: Rebuild as microservices (long-term)
  Risk: IRS modernization took 20+ years and billions
  Best practice: Incremental replacement, not "big bang"
EOF
}

cmd_cheatsheet() { cat << 'EOF'
# Public Administration Quick Reference

## Government Frameworks Comparison
  Framework              Focus                Origin
  Weberian Bureaucracy   Rules & hierarchy    Germany 1920s
  NPM                    Efficiency & market  UK/NZ 1980s
  New Public Governance  Networks & co-prod   EU 2000s
  Digital-Era Governance IT-enabled reform    UK 2010s
  Agile Government       Iterative delivery   US/UK 2020s

## Common Government Acronyms
  FOI/FOIA: Freedom of Information (Act)
  GAO:      Government Accountability Office (US)
  NAO:      National Audit Office (UK)
  IG:       Inspector General
  OMB:      Office of Management and Budget
  OPM:      Office of Personnel Management
  SES:      Senior Executive Service
  GS:       General Schedule (US pay scale: GS-1 to GS-15)
  CISA:     Cybersecurity & Infrastructure Security Agency
  FedRAMP:  Federal Risk and Authorization Management Program
  CUI:      Controlled Unclassified Information

## FOI Request Process
  1. Identify correct agency holding the records
  2. Submit written request (email or letter, cite FOIA/FOI law)
  3. Be specific about records sought (dates, topics, departments)
  4. Agency must respond within 20 business days (US FOIA)
  5. Fees: Search, review, duplication (may be waived for media/education)
  6. Exemptions: 9 exemptions in US (national security, privacy, law enforcement)
  7. Appeal: Administrative appeal, then federal court

## Citizen Satisfaction Surveys
  ACSI (American Customer Satisfaction Index): Federal benchmark ~64/100
  CES (Customer Effort Score): How easy was it? (1-7 scale)
  NPS (Net Promoter Score): Would you recommend? (-100 to +100)
  GovTech benchmark: Digital services should score >70 CSAT

## Budget Cycle (Typical)
  Formulation:  Agencies submit requests (18 months before fiscal year)
  Approval:     Legislature appropriates funds
  Execution:    Agencies spend within authorized limits
  Audit:        Supreme audit institution reviews spending
  US fiscal year: October 1 - September 30
  Most countries: January 1 - December 31
EOF
}

cmd_faq() { cat << 'EOF'
# Public Administration — FAQ

Q: What's the difference between civil servants and political appointees?
A: Civil servants are career professionals hired through merit-based process
   (exams, qualifications). They serve regardless of which party is in power.
   Political appointees are chosen by elected officials, serve at their pleasure,
   and typically leave when administration changes.
   US: ~2.1M career civil servants vs ~4,000 political appointees.

Q: How do government pay scales work?
A: US General Schedule (GS): 15 grades, 10 steps each.
   GS-1 (entry): ~$24K/year. GS-15 Step 10: ~$191K. SES: up to ~$221K.
   Locality pay adjustments: +15-45% based on region (DC highest).
   UK: Administrative Officer to Permanent Secretary, pay bands published.
   Most countries: Published pay scales, annual increments, pension benefits.
   Government typically pays 10-30% less than private sector for equivalent roles.

Q: How does government procurement work?
A: Below thresholds (US <$250K): Simplified acquisition, competitive quotes.
   Above thresholds: Full and open competition, published solicitation.
   Sole source: Justified exception (unique capability, urgency, national security).
   Process: Requirement → solicitation → evaluation → award → protest period.
   Timeline: Simple purchase weeks, major contract 6-18 months.
   Protests: Losing bidders can protest to GAO (US) or courts.

Q: What is "digital by default" in government?
A: Policy where the primary channel for government services is digital.
   Citizens should be able to complete transactions entirely online.
   UK pioneered this through Government Digital Service (GDS) since 2012.
   Does NOT mean eliminating in-person: Assisted digital for those who need it.
   Savings: Digital transaction costs ~1/50th of face-to-face.

Q: How do I become a civil servant?
A: Varies by country. US: USAJobs.gov, apply to specific positions.
   UK: Civil Service Jobs website, competency-based assessments.
   France: Concours (competitive exam), grandes écoles pathway.
   China: National Civil Service Exam (国考), extremely competitive (~2% pass rate).
   India: UPSC exam, one of the most competitive globally (~0.1% success rate).
   Common requirements: Citizenship, background check, relevant qualification.
EOF
}

cmd_help() {
    echo "civil-service v$VERSION — Public Administration Reference"
    echo ""
    echo "Usage: civil-service <command>"
    echo ""
    echo "Commands:"
    echo "  intro           Civil service systems worldwide"
    echo "  standards       Weberian bureaucracy, NPM, good governance"
    echo "  troubleshooting Red tape reduction, interagency coordination"
    echo "  performance     KPIs, e-government maturity, digital metrics"
    echo "  security        Data protection, FISMA, classified info"
    echo "  migration       Paper→digital, legacy IT modernization"
    echo "  cheatsheet      Frameworks, acronyms, FOI process, budget cycle"
    echo "  faq             Career paths, pay scales, procurement, digital"
    echo "  help            Show this help"
}

case "${1:-help}" in
    intro) cmd_intro ;; standards) cmd_standards ;;
    troubleshooting) cmd_troubleshooting ;; performance) cmd_performance ;;
    security) cmd_security ;; migration) cmd_migration ;;
    cheatsheet) cmd_cheatsheet ;; faq) cmd_faq ;;
    help|--help|-h) cmd_help ;;
    *) echo "Unknown: $1"; echo "Run: civil-service help" ;;
esac
