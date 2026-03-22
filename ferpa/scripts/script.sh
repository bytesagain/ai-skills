#!/usr/bin/env bash
# ferpa — FERPA Compliance Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== FERPA — Family Educational Rights and Privacy Act ===

FERPA (20 U.S.C. § 1232g) is a federal law that protects the privacy
of student education records. Also known as the Buckley Amendment.

Enacted: 1974 (amended multiple times since)
Enforced by: U.S. Department of Education, FPCO
             (Family Policy Compliance Office)

Who Must Comply:
  Any educational institution that receives federal funding
  Includes: public schools K-12, most colleges/universities
  Does NOT directly apply to: private schools without federal funds
  Note: nearly all colleges receive federal student aid = FERPA applies

Key Definitions:

  Eligible Student:
    Student who has reached 18 years old OR
    attends a postsecondary institution at any age
    Rights transfer from parent to student at this point

  Education Records:
    Records directly related to a student AND
    maintained by the institution or a party acting for it
    Format doesn't matter: paper, digital, film, microfilm

  School Official:
    Person with a legitimate educational interest
    Includes: teachers, administrators, counselors,
    attorneys, auditors, contractors with service agreements

  Legitimate Educational Interest:
    Official needs the record to fulfill professional responsibilities
    This is the key test for internal access

Core Principles:
  1. Parents/students have the right to inspect records
  2. Parents/students can request amendments
  3. Institutions need written consent for most disclosures
  4. Certain exceptions allow disclosure without consent
  5. Institutions must notify students of their FERPA rights annually
EOF
}

cmd_rights() {
    cat << 'EOF'
=== FERPA Rights ===

--- Right to Inspect and Review ---
  Who: Parents (K-12) or eligible students (18+ or postsecondary)
  What: All education records maintained by the institution
  When: Institution must respond within 45 days of request
  How: Cannot charge for copies if it would prevent access
       Can charge reasonable copy fees otherwise

  Institution must NOT:
    - Destroy records after a request is made
    - Refuse access because of outstanding fees (debatable, see case law)
    - Require students to explain why they want to see records

--- Right to Request Amendment ---
  If a record is inaccurate, misleading, or violates privacy:
    1. Student/parent requests amendment in writing
    2. Institution decides within reasonable time
    3. If denied → institution must inform of right to a hearing
    4. Hearing → impartial official reviews evidence
    5. If still denied → student can place a statement in the record

  Important limitations:
    - Cannot challenge a grade through FERPA amendment process
    - Cannot challenge substantive judgments (teacher's academic evaluation)
    - Only factual accuracy and relevance can be challenged

--- Right to Consent ---
  Written consent required before disclosure, must include:
    - Specific records to be disclosed
    - Purpose of disclosure
    - Identity of parties receiving records
    - Signature and date

  Consent can be electronic if it:
    - Identifies and authenticates the person
    - Indicates the person's approval of the information

--- Right to File Complaints ---
  Filed with: Family Policy Compliance Office (FPCO)
  Address: U.S. Department of Education
           400 Maryland Avenue, SW
           Washington, DC 20202-5920
  Deadline: within 180 days of alleged violation
             or within 180 days of learning about it

--- Annual Notification ---
  Institutions must annually notify eligible students of:
    - Right to inspect and review records
    - Right to seek amendment
    - Right to consent to disclosures
    - FERPA exceptions to consent
    - Right to file complaints with FPCO
  Method: student handbook, catalog, email, website
EOF
}

cmd_records() {
    cat << 'EOF'
=== Education Records — What Counts ===

--- IS an Education Record ---
  Transcripts and grade reports
  Class schedules and enrollment status
  Financial aid records
  Student account / billing records
  Disciplinary records
  Special education records (IEP, 504 plans)
  Admissions records (for enrolled students)
  Email about a student (if maintained by institution)
  Learning management system (LMS) data
  Student ID photos
  Disability accommodation documentation

--- IS NOT an Education Record ---

  Sole Possession Records:
    Notes kept by a single school official
    Used only as personal memory aids
    Not shared with anyone else
    Example: teacher's private grade book notes
    ⚠ If shared with anyone → becomes education record

  Law Enforcement Records:
    Created by campus law enforcement unit
    For law enforcement purposes
    Maintained separately from education records
    Not shared with non-law enforcement school officials

  Employment Records:
    When student is employed by institution
    NOT related to student status
    ⚠ Work-study records ARE education records

  Medical/Treatment Records:
    Created by health professionals
    Used only for treatment purposes
    Shared only with professionals treating the student
    ⚠ If shared with non-treatment staff → education record

  Alumni Records:
    Information collected AFTER the person is no longer a student
    Records from when they WERE a student are still protected

  De-identified Records:
    Personally identifiable information removed
    No reasonable basis to identify the student
    Can be disclosed freely

--- Gray Areas ---
  Student email metadata: generally yes (institutional records)
  CCTV footage of student: depends on context and maintenance
  Peer-graded assignments: not education records until recorded by teacher
  Letters of recommendation: student can waive access rights
EOF
}

cmd_directory() {
    cat << 'EOF'
=== Directory Information ===

Directory information CAN be disclosed without consent, but only
if the institution has properly notified students.

--- Typical Directory Information ---
  Student name
  Address (local and permanent)
  Email address
  Phone number
  Date and place of birth
  Major field of study
  Enrollment status (full-time, half-time, etc.)
  Dates of attendance
  Degrees and awards received
  Most recent previous institution attended
  Participation in officially recognized activities/sports
  Weight and height (for athletic team members)
  Photograph

--- NOT Directory Information ---
  Social Security Number (NEVER)
  Student ID number (unless it can't be used for access)
  Grades or GPA
  Race, ethnicity, nationality
  Gender (in most policies)
  Disability status
  Financial information

--- Opt-Out Requirements ---
  Before disclosing directory information:
    1. Institution must define what it considers directory information
    2. Notify all students annually
    3. Give students reasonable period to opt out
    4. Track and honor opt-out requests

  If a student opts out:
    - NO directory information released about that student
    - Includes: graduation programs, dean's list, athletic rosters
    - Cannot even confirm the student is enrolled

--- Solomon Amendment ---
  Federal law requiring institutions to provide directory information
  to military recruiters upon request
  Students CANNOT opt out of Solomon Amendment disclosures
  Information limited to: name, address, phone, age, class level, major

--- Best Practices ---
  1. Define directory info as narrowly as possible
  2. Never include SSN or grades as directory info
  3. Process opt-outs before each disclosure, not just annually
  4. Use "limited directory information" — smaller subset for each purpose
  5. When in doubt, get consent — it's safer than assuming directory info
EOF
}

cmd_exceptions() {
    cat << 'EOF'
=== FERPA Exceptions — Disclosure Without Consent ===

FERPA allows disclosure without consent in these situations:

1. School Officials with Legitimate Educational Interest
   Teachers, administrators, counselors, attorneys, auditors
   Board members, contractors performing institutional functions
   Must be specified in annual notification

2. Transfer to Another School
   Records sent to school where student seeks to enroll
   Condition: institution must attempt to notify student
   Must provide copy of records if requested

3. Financial Aid
   Disclosure related to determining eligibility, amount,
   conditions, or enforcement of financial aid terms

4. State and Local Authorities (Juvenile Justice)
   Information shared with juvenile justice system
   Under specific state statutes

5. Accrediting Organizations
   For accreditation-related purposes

6. Compliance with Judicial Order or Subpoena
   Must make reasonable effort to notify student BEFORE disclosure
   Exception: if court order says not to notify (law enforcement subpoena)

7. Health or Safety Emergency
   To appropriate parties to protect health/safety of student or others
   Must be articulable and significant threat
   Strictest standard — not for general safety concerns
   Must consider: severity, need for information, time urgency

8. Directory Information
   Only if properly designated and notification/opt-out procedure followed

9. Victim of Crime of Violence
   Victim can be informed of results of disciplinary proceeding
   Limited to: name of student, violation, sanctions imposed

10. Drug/Alcohol Violations (Under 21)
    Institution may notify parents when student under 21
    violates drug or alcohol laws/policies

11. Sex Offender Registration
    Information provided under sex offender registration programs

12. IRS for Tax Purposes
    Student enrollment and financial data for tax compliance

13. Studies by or for the Institution
    To organizations conducting studies to improve instruction
    Requires: written agreement, no further disclosure, data destruction plan
EOF
}

cmd_technology() {
    cat << 'EOF'
=== FERPA and Technology ===

--- Cloud Services and SaaS ---
  Cloud vendors handling student data must be treated as
  "school officials" under FERPA.

  Required: written agreement with vendor specifying:
    - Vendor performs institutional function
    - Under direct control of institution
    - Only uses data for authorized purposes
    - Cannot re-disclose to third parties
    - Complies with FERPA requirements

  Common services requiring agreements:
    LMS (Canvas, Blackboard, Moodle)
    SIS (Student Information Systems)
    Email (Google Workspace for Education, Microsoft 365)
    Cloud storage (Google Drive, OneDrive)
    Anti-plagiarism (Turnitin)
    Video conferencing (Zoom, Teams)
    Analytics platforms

--- Data Sharing Agreements ---
  Template elements:
    Parties involved
    Specific data elements shared
    Purpose and permitted uses
    Data security requirements (encryption, access controls)
    Prohibition on re-disclosure
    Data retention and destruction schedule
    Breach notification procedures
    Audit rights

--- EdTech Vendor Checklist ---
  Before adopting a new edtech tool:
  [ ] Vendor agreement covers FERPA requirements
  [ ] Data stays in US (or complies with institution policy)
  [ ] Encryption in transit (TLS 1.2+) and at rest
  [ ] Access controls — role-based, least privilege
  [ ] Audit logging of access to student data
  [ ] Data minimization — only necessary data collected
  [ ] Data deletion — process after contract ends
  [ ] Breach notification — vendor must notify institution promptly

--- Student Data in AI/ML ---
  Training ML models on student data raises FERPA issues:
    - Is the training data de-identified? (must be truly anonymous)
    - Can the model output identify individual students?
    - Who has access to the trained model?
    - Is the AI vendor a "school official"?
    - Are students notified about AI use in their education?

  Safe approach:
    - Use aggregate/de-identified data for model training
    - Execute student agreement for AI vendors
    - Clearly communicate AI use in privacy notices
    - Allow students to opt out of AI-driven features
EOF
}

cmd_penalties() {
    cat << 'EOF'
=== FERPA Enforcement & Penalties ===

--- Enforcement Mechanism ---
  FERPA is enforced by the Family Policy Compliance Office (FPCO)
  within the U.S. Department of Education.

  FERPA does NOT provide a private right of action.
  Students CANNOT sue institutions directly under FERPA.
  (Gonzaga v. Doe, 2002 — Supreme Court)

  Students CAN:
    - File complaint with FPCO
    - Sue under state privacy laws
    - Sue under state FERPA-equivalent statutes
    - File with OCR if disability discrimination involved

--- Complaint Process ---
  1. Student/parent files complaint with FPCO
  2. FPCO reviews complaint (may take months)
  3. If violation found → FPCO notifies institution
  4. Institution has opportunity to come into compliance
  5. If institution refuses → hearing process
  6. Ultimate penalty: loss of federal funding

--- The Nuclear Penalty ---
  Loss of federal funding is the only FERPA penalty.
  This has NEVER been imposed.
  However, the threat is effective — institutions take compliance seriously.

  Federal funding at stake:
    Pell Grants, federal student loans, work-study
    Research grants (NIH, NSF, DOE)
    Title I, IDEA funding (K-12)
    Total exposure: millions to billions of dollars

--- Practical Consequences ---
  Even without FERPA lawsuits, institutions face:
    State privacy law liability
    HIPAA violations (if health records mishandled)
    Contract liability (vendor agreements)
    Reputational damage (data breaches make news)
    OCR investigations (disability-related records)
    Accreditation risk (data governance requirements)

--- Data Breach Response ---
  FERPA doesn't have explicit breach notification requirements
  BUT: state breach notification laws apply (all 50 states have them)
  Best practice:
    1. Contain the breach immediately
    2. Assess what records were exposed
    3. Notify affected students per state law (typically 30-60 days)
    4. Notify FPCO if systemic FERPA violation
    5. Document incident and remediation
    6. Review and update security controls
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== FERPA Compliance Checklist ===

--- Annual Requirements ---
  [ ] Annual FERPA rights notification sent to eligible students
  [ ] Directory information policy defined and published
  [ ] Opt-out period for directory information provided
  [ ] Opt-out requests collected and processed
  [ ] School official definition published (who has access)
  [ ] Legitimate educational interest criteria published

--- Records Management ---
  [ ] Education records properly identified and classified
  [ ] Access limited to school officials with legitimate interest
  [ ] Record of each disclosure maintained (except directory info)
  [ ] Disclosure log includes: date, party, legitimate interest
  [ ] Records retention schedule defined and followed
  [ ] Secure destruction process for expired records

--- Consent & Disclosure ---
  [ ] Written consent obtained before non-exempt disclosures
  [ ] Consent includes: records, purpose, recipient, signature, date
  [ ] Students can revoke consent
  [ ] Exception used properly documented in each case
  [ ] Health/safety emergency disclosures documented with rationale

--- Technology & Vendors ---
  [ ] Written agreements with all vendors handling student data
  [ ] Vendor agreements include FERPA-required clauses
  [ ] Vendor access limited to minimum necessary data
  [ ] Vendor data security requirements specified
  [ ] Data destruction clause in vendor contracts
  [ ] Periodic vendor compliance review

--- Training & Awareness ---
  [ ] Staff trained on FERPA basics (annual refresher)
  [ ] Faculty trained on sole possession records rules
  [ ] IT staff trained on data security for student records
  [ ] New employee orientation includes FERPA training
  [ ] Incident response procedures established and tested

--- Data Security ---
  [ ] Student records encrypted in transit and at rest
  [ ] Role-based access controls implemented
  [ ] Strong authentication for systems with student data
  [ ] Audit logs for access to sensitive student records
  [ ] Regular access reviews (remove departed staff promptly)
  [ ] Physical security for paper records (locked cabinets)
  [ ] Data breach response plan documented and tested
EOF
}

show_help() {
    cat << EOF
ferpa v$VERSION — FERPA Compliance Reference

Usage: script.sh <command>

Commands:
  intro        FERPA overview — scope, history, definitions
  rights       Student and parent rights under FERPA
  records      What is (and isn't) an education record
  directory    Directory information disclosure rules
  exceptions   When disclosure is permitted without consent
  technology   FERPA and cloud services, edtech, AI
  penalties    Enforcement, penalties, complaint process
  checklist    FERPA compliance checklist for institutions
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    rights)     cmd_rights ;;
    records)    cmd_records ;;
    directory)  cmd_directory ;;
    exceptions) cmd_exceptions ;;
    technology) cmd_technology ;;
    penalties)  cmd_penalties ;;
    checklist)  cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "ferpa v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
