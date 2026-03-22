#!/usr/bin/env bash
# subpoena — Legal Subpoena Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Subpoenas — Overview ===

A subpoena is a court order compelling a person to testify,
produce documents, or both. Failure to comply can result in
contempt of court.

Etymology:
  Latin "sub poena" = "under penalty"
  The recipient faces penalties for non-compliance

Purpose:
  - Compel witness testimony at trial or hearing
  - Obtain documents and records in litigation
  - Gather evidence during discovery phase
  - Require testimony at depositions
  - Administrative and regulatory investigations

Legal Authority:
  Federal:    FRCP Rule 45 (civil), FRCrP Rule 17 (criminal)
  State:      Each state has its own subpoena rules
  Admin:      Agencies have statutory subpoena power (e.g., SEC, IRS, FTC)
  Grand Jury: Broad investigative subpoena power

Key Characteristics:
  - Not a request — it's a court ORDER
  - Can be issued by attorneys (not just judges in most jurisdictions)
  - Subject to constitutional protections (5th Amendment privilege)
  - Can be challenged through motion to quash
  - Geographic reach limitations apply
  - Must be properly served to be enforceable

Who Can Be Subpoenaed:
  - Any person within the court's jurisdiction
  - Non-party witnesses (not involved in the case)
  - Custodians of records (corporations, agencies)
  - Expert witnesses (under certain conditions)
  - NOT immune officials (legislative/diplomatic immunity exceptions)

Distinction from Other Court Orders:
  Subpoena     Compels non-parties to produce evidence/testify
  Summons      Notifies a defendant of a lawsuit
  Warrant      Authorizes law enforcement search/arrest
  Court Order  Broader directive from a judge
EOF
}

cmd_types() {
    cat << 'EOF'
=== Types of Subpoenas ===

Subpoena Ad Testificandum:
  Purpose: Compels a person to testify
  When: At trial, hearing, or deposition
  Requirements:
    - Identify the witness
    - State date, time, and location of testimony
    - Specify the proceeding and court
  Notes:
    - Witness must appear in person
    - May request travel accommodations in some jurisdictions
    - Remote testimony may be permitted (post-COVID rules)

Subpoena Duces Tecum:
  Purpose: Compels production of documents, records, or things
  When: Discovery phase, pre-trial, or at trial
  Requirements:
    - Describe documents with reasonable particularity
    - Cannot be overly broad or unduly burdensome
    - Must allow reasonable time for compliance
  Common Targets:
    - Business records, emails, contracts
    - Medical records
    - Financial records (bank, tax)
    - Electronic data (ESI - Electronically Stored Information)
    - Phone records, surveillance footage

Combined Subpoena (Testify + Produce):
  Most common in practice
  Witness must appear AND bring documents
  Example: "Appear on [date] and bring all contracts between..."

Deposition Subpoena:
  Compels testimony at a deposition (out-of-court, under oath)
  Can include duces tecum component
  Used primarily during discovery
  Rules vary: federal vs state procedures

Administrative Subpoena:
  Issued by government agencies (not courts)
  Authority: Enabling statute grants subpoena power
  Examples:
    SEC subpoena for trading records
    IRS summons for tax documents
    OSHA investigation records
    FTC investigation demands
  Enforcement: Agency must petition court if recipient refuses

Grand Jury Subpoena:
  Issued as part of criminal investigation
  Very broad scope (relevant to investigation)
  Harder to challenge than civil subpoenas
  Secrecy rules apply (Fed. R. Crim. P. 6(e))
  Fifth Amendment privilege against self-incrimination applies
EOF
}

cmd_procedure() {
    cat << 'EOF'
=== Issuing and Serving Subpoenas ===

Issuing a Subpoena (Federal — FRCP Rule 45):

Who Can Issue:
  - Clerk of court issues blank subpoenas
  - Attorney authorized to practice in issuing court
  - Attorney signs and fills in details
  - Pro se litigants: must request from clerk

Required Contents:
  1. Name of the court
  2. Title and case number of the action
  3. Name of the person commanded
  4. Command to attend/testify and/or produce documents
  5. Date, time, and place of compliance
  6. Text of Rule 45(d) and (e) — rights of recipient
  7. Attorney signature and contact information

Service Requirements:
  Personal Service:
    - Deliver a copy to the named person
    - Must be served by a non-party (18+ years old)
    - Some states allow service by mail or email
  
  Witness Fees:
    - Must tender witness fee with service (federal: $40/day)
    - Must tender mileage costs (federal: $0.655/mile)
    - Failure to tender fees = subpoena unenforceable
    - Some states don't require advance tender

  Timing:
    - "Reasonable time" before compliance date
    - No specific federal minimum (but courts require reasonableness)
    - State rules vary: some require 5-14 days minimum
    - Document subpoenas: typically 30 days for production

Geographic Limits (Federal):
  Trial subpoena:
    - Within 100 miles of courthouse, OR
    - Within the state if state law allows
  Deposition subpoena:
    - Within 100 miles of deposition location
  Note: FRCP Rule 45(c) — must not impose undue burden

Service on Corporations:
  Rule 30(b)(6) deposition notice (not technically a subpoena)
  Corporation designates person(s) most knowledgeable
  Topics must be described with reasonable particularity
  Corporation must prepare designated witness on listed topics

Proof of Service:
  File proof of service with the court
  Include: date, time, place, manner of service
  Affidavit or declaration of the process server
EOF
}

cmd_compliance() {
    cat << 'EOF'
=== Responding to Subpoenas ===

Recipient's Obligations:
  1. Take the subpoena seriously (it's a court order)
  2. Note the compliance deadline
  3. Review scope of documents/testimony requested
  4. Preserve all responsive materials (litigation hold)
  5. Consult an attorney if unclear
  6. Respond by the deadline (even if objecting)

Response Options:
  Full Compliance:
    - Produce all requested documents
    - Appear for testimony as commanded
    - Certify completeness of production

  Partial Compliance with Objections:
    - Produce non-objectionable documents
    - Serve written objections before deadline
    - Common objections:
      · Overly broad or unduly burdensome
      · Seeks privileged information
      · Not relevant to the case
      · Trade secrets / confidential business info
      · Compliance impossible (documents don't exist)

  Negotiate Modification:
    - Contact issuing attorney to narrow scope
    - Agree on search terms, date ranges, custodians
    - Most courts prefer informal resolution
    - Document the agreement in writing

Privilege Considerations:
  Attorney-Client Privilege:
    - Communications with your lawyer for legal advice
    - Must be claimed specifically (not blanket)
    - Produce privilege log describing withheld documents
  
  Work Product Doctrine:
    - Materials prepared in anticipation of litigation
    - Qualified protection (can be overcome by need)
  
  Fifth Amendment:
    - Privilege against self-incrimination
    - Applies to testimony, not existing documents (generally)
    - Must be claimed question-by-question
  
  Other Privileges:
    - Doctor-patient, clergy-penitent, spousal
    - Trade secrets (may require protective order)
    - Journalist's privilege (shield laws, varies by state)

Privilege Log Requirements:
  For each withheld document:
    - Date of document
    - Author and recipients
    - Subject matter (without revealing privileged content)
    - Privilege claimed (A/C, work product, etc.)
    - Basis for the claim

Consequences of Non-Compliance:
  Contempt of Court:
    - Civil contempt: coercive fines until compliance
    - Criminal contempt: punitive fines and/or jail
  Sanctions:
    - Monetary penalties
    - Adverse inference (court assumes documents harmful)
  Warrant: Court may issue warrant for arrest
EOF
}

cmd_quash() {
    cat << 'EOF'
=== Motions to Quash or Modify ===

Motion to Quash:
  Asks the court to invalidate the subpoena entirely
  Filed by the subpoena recipient or affected party
  Must be filed "timely" — typically before compliance deadline

Grounds for Quashing (FRCP 45(d)(3)):

  Mandatory Quashing — Court MUST quash if subpoena:
    (A) Fails to allow reasonable time for compliance
    (B) Requires travel beyond geographic limits
    (C) Requires disclosure of privileged matter (no waiver)
    (D) Subjects person to undue burden

  Discretionary Quashing — Court MAY quash if subpoena:
    (A) Requires disclosure of trade secrets or confidential info
        (may modify with protective order instead)
    (B) Requires unretained expert opinion
        (unless exceptional circumstances)

Filing Procedure:
  1. Draft motion identifying defects or grounds
  2. File in the court where compliance is required
     (not necessarily the court where case is pending)
  3. Include supporting declaration/affidavit
  4. Serve on all parties
  5. Request hearing (may be decided on papers)

Motion to Modify:
  Alternative to quashing — asks court to narrow scope
  Common modifications:
    - Reduce date range of document requests
    - Limit number of custodians searched
    - Allow redaction of irrelevant information
    - Set a protective order for confidential material
    - Change location or date of testimony
    - Allow remote testimony instead of in-person

Protective Orders:
  Used with trade secrets or confidential information
  Common terms:
    - "Attorneys' Eyes Only" designation
    - Limited use (only for this litigation)
    - Return/destroy after case concludes
    - Penalties for unauthorized disclosure

Meet and Confer Requirement:
  Most courts require parties to try resolving disputes
  before filing motions
  Federal: Rule 45 Advisory Committee Notes encourage negotiation
  State: Many require certification of good-faith effort
  Document all communications about the dispute

Strategic Considerations:
  - Quashing may delay but not eliminate the obligation
  - Court may order compliance with modified terms
  - Excessive objections can antagonize the court
  - Negotiate first, litigate second
  - Cost-shifting: court may order issuing party to pay costs
EOF
}

cmd_federal() {
    cat << 'EOF'
=== FRCP Rule 45 — Key Provisions ===

Rule 45(a) — In General:
  - Subpoenas issued from court where action is pending
  - Clerk must issue to party who requests it
  - Attorney may issue as officer of the court
  - Must include text of 45(d) and (e)

Rule 45(b) — Service:
  - Personal delivery to named person
  - Tender fees for one day's attendance + mileage
  - Notice to all parties before serving non-party subpoena
  - Proof of service filed with issuing court

Rule 45(c) — Place of Compliance:
  Trial/Hearing: Within 100 miles or within state
  Deposition: Within 100 miles of where person resides,
    works, or regularly transacts business
  Documents only: May be produced at place of compliance
    or at another reasonably agreed location

Rule 45(d) — Protecting Rights:
  (1) Avoid undue burden or expense
  (2) Party/attorney responsible for compliance violations
  (3) Court must quash or modify if:
      - Unreasonable time
      - Beyond geographic limits
      - Requires privileged disclosure
      - Undue burden
  (3)(B) Court may quash/modify if:
      - Trade secrets (unless exceptional circumstances + fees)
      - Unretained expert opinion

Rule 45(e) — Duties in Responding:
  (1) Producing documents:
      - As kept in ordinary course of business, OR
      - Organized and labeled by request category
  (2) Claiming privilege:
      - Expressly claim privilege
      - Describe nature of documents sufficiently
      - Notify all parties

Rule 45(g) — Contempt:
  Court may hold in contempt any person who:
  - Fails to obey without adequate excuse
  - Must be served in the issuing court's jurisdiction
  
2013 Amendments (Major):
  - Subpoena issued only from court where action pending
  - Compliance disputes resolved in district where compliance required
  - Transfer provision for exceptional circumstances
  - Harmonized geographic limitations
EOF
}

cmd_examples() {
    cat << 'EOF'
=== Subpoena Scenarios ===

--- Third-Party Document Subpoena ---
Scenario: Plaintiff suing employer needs payroll records
from outsourced payroll company (non-party)

Steps:
  1. Attorney issues subpoena duces tecum
  2. Serve on payroll company's registered agent
  3. Include $40 witness fee + mileage
  4. Allow 30 days for document production
  5. Describe documents: "All payroll records for [employee]
     from January 2020 to present"
  6. Notice sent to opposing counsel

Potential Issues:
  - Payroll company may object (privacy, burden)
  - May require protective order for employee data
  - HIPAA considerations if health deductions included

--- Deposition of Treating Physician ---
Scenario: Defense wants to depose plaintiff's doctor

Steps:
  1. Issue deposition subpoena ad testificandum
  2. Serve on physician personally
  3. Include duces tecum for medical records
  4. Coordinate schedule (medical professionals get courtesy)
  5. Tender expert witness fee (if opinion testimony expected)

Potential Issues:
  - Doctor-patient privilege (plaintiff may waive by suing)
  - Expert vs fact witness distinction affects fees
  - May need patient authorization for records

--- Corporate Records Subpoena ---
Scenario: Regulatory investigation of company's practices

Steps:
  1. Agency issues administrative subpoena
  2. Serve on company's registered agent
  3. Broad request: "All documents related to..."
  4. Company reviews, collects, processes responsive docs
  5. Company produces non-privileged docs + privilege log

Practical Reality:
  - E-discovery: may involve terabytes of email
  - Proportionality: negotiate reasonable scope
  - Cost: $50K-$500K+ for large corporate productions
  - Timeline: often months for large productions

--- Motion to Quash — Trade Secrets ---
Scenario: Competitor subpoenas proprietary pricing formulas

Response:
  1. File motion to quash (trade secret protection)
  2. Alternatively: request protective order
  3. Court may order production under "AEO" designation
  4. Only attorneys can view the information
  5. Must destroy after litigation concludes
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== Subpoena Checklist ===

Issuing a Subpoena:
  [ ] Identify correct type (testimony, documents, or both)
  [ ] Verify court has jurisdiction over the recipient
  [ ] Check geographic compliance limits (100-mile rule)
  [ ] Draft with required contents (court, case, command)
  [ ] Include Rule 45(d)/(e) text (federal)
  [ ] Describe documents with reasonable particularity
  [ ] Set reasonable compliance deadline
  [ ] Arrange proper service (non-party, 18+)
  [ ] Tender witness fee and mileage
  [ ] Serve notice on all parties
  [ ] File proof of service with court

Responding to a Subpoena:
  [ ] Note the compliance deadline immediately
  [ ] Determine if subpoena is valid (proper service, jurisdiction)
  [ ] Issue litigation hold for responsive materials
  [ ] Review scope — identify responsive documents
  [ ] Identify any privileged or confidential materials
  [ ] Consider objections (burden, relevance, privilege)
  [ ] Contact issuing attorney to negotiate scope if needed
  [ ] Prepare privilege log for withheld documents
  [ ] Produce documents in organized manner
  [ ] Respond by deadline (even if filing objections)

Challenging a Subpoena:
  [ ] Evaluate grounds for motion to quash
  [ ] Check timing — file before compliance date
  [ ] Attempt meet-and-confer with issuing party
  [ ] Draft motion with supporting declaration
  [ ] File in correct court (compliance district)
  [ ] Request hearing or expedited ruling
  [ ] Propose modifications as alternative to quashing

Preparing Witness for Testimony:
  [ ] Review subpoena scope with witness
  [ ] Prepare witness on anticipated questions
  [ ] Gather and organize requested documents
  [ ] Advise on privilege assertions (5th Amendment, A/C)
  [ ] Arrange travel and logistics
  [ ] Confirm date, time, and location
EOF
}

show_help() {
    cat << EOF
subpoena v$VERSION — Legal Subpoena Reference

Usage: script.sh <command>

Commands:
  intro        Subpoenas overview — definition and legal authority
  types        Types — testimony, documents, deposition, admin
  procedure    Issuing and serving subpoenas
  compliance   Responding — obligations, privilege, consequences
  quash        Motions to quash or modify
  federal      FRCP Rule 45 key provisions
  examples     Practical subpoena scenarios
  checklist    Issuance and response checklist
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    types)      cmd_types ;;
    procedure)  cmd_procedure ;;
    compliance) cmd_compliance ;;
    quash)      cmd_quash ;;
    federal)    cmd_federal ;;
    examples)   cmd_examples ;;
    checklist)  cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "subpoena v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
