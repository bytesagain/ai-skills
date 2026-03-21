#!/usr/bin/env bash
# statute — Legal Statutes Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Statutes — Overview ===

A statute is a formal written law enacted by a legislative body.
Statutes are the primary source of law in most legal systems.

Definition:
  A statute (from Latin "statutum" — to set up) is a written law
  passed by a legislature at the federal, state, or local level.

Hierarchy of Law (U.S.):
  1. U.S. Constitution          Supreme law of the land
  2. Federal Statutes            Acts of Congress (U.S. Code)
  3. Federal Regulations         Agency rules (Code of Federal Regulations)
  4. State Constitutions         Supreme within state (below federal)
  5. State Statutes              State legislature enactments
  6. State Regulations           State agency rules
  7. Local Ordinances            City/county laws
  8. Common Law                  Judge-made law (case precedent)

Key Distinctions:
  Statute vs Regulation:
    Statute = law passed by legislature
    Regulation = rule created by executive agency to implement statute

  Statute vs Common Law:
    Statute = written, enacted by legislature
    Common Law = unwritten, developed by courts through precedent

  Statute vs Ordinance:
    Statute = state or federal level
    Ordinance = local government (city, county)

Codification:
  Statutes are organized into codes for easy reference
  U.S. Code (USC):     54 titles covering all federal statutory law
  State codes:          Each state has its own code system
  Session laws:         Chronological record of enacted statutes
  Slip laws:            Individual statutes as enacted (Public Law No.)

Effective Date:
  - Upon presidential/gubernatorial signature (default)
  - Specific date stated in the statute
  - After a waiting period (e.g., 90 days)
  - "Emergency" clause: effective immediately
EOF
}

cmd_process() {
    cat << 'EOF'
=== How a Bill Becomes Law (U.S. Federal) ===

Step 1: Introduction
  - Any member of Congress can introduce a bill
  - House bills: H.R. ### (e.g., H.R. 1234)
  - Senate bills: S. ### (e.g., S. 567)
  - Revenue bills must originate in the House (Art. I, §7)
  - Bill is assigned a number and referred to committee

Step 2: Committee Action
  - Referred to relevant committee (e.g., Judiciary, Finance)
  - Committee may hold hearings (expert testimony)
  - Markup session: committee debates and amends the bill
  - Vote to report the bill to the full chamber
  - If no action → bill "dies in committee" (most bills)
  - Subcommittee may handle specialized review first

Step 3: Floor Debate and Vote
  House:
    - Rules Committee sets debate terms (time, amendments)
    - Debate, amend, vote
    - Simple majority to pass (218 of 435)
  Senate:
    - Unanimous consent or cloture (60 votes to end debate)
    - Filibuster can block vote indefinitely
    - Amendments may be unlimited
    - Simple majority to pass (51 of 100)

Step 4: Other Chamber
  - Bill goes to the other chamber
  - Entire process repeats (committee, debate, vote)
  - May pass as-is or with amendments
  - If amended → conference committee to reconcile

Step 5: Conference Committee
  - Members from both chambers negotiate differences
  - Produce conference report (compromise bill)
  - Both chambers vote on identical version
  - No further amendments allowed

Step 6: Presidential Action
  - Sign into law → becomes Public Law (P.L. ###-###)
  - Veto → return to Congress (2/3 override in each chamber)
  - Pocket veto → Congress adjourns within 10 days, bill dies
  - Take no action → becomes law after 10 days (if Congress in session)

Statistics:
  Each Congress: ~10,000-15,000 bills introduced
  Typically: 2-5% become law
  117th Congress (2021-22): ~400 laws enacted
EOF
}

cmd_structure() {
    cat << 'EOF'
=== Anatomy of a Statute ===

Organizational Hierarchy (U.S. Code):
  Title         Broad subject area (e.g., Title 18 — Crimes)
    Subtitle      Major division within title
      Chapter       Grouping of related sections
        Subchapter    Subdivision of a chapter
          Part          Division within subchapter
            Section (§)   The basic unit of statutory law
              Subsection    (a), (b), (c)...
                Paragraph     (1), (2), (3)...
                  Subparagraph  (A), (B), (C)...
                    Clause        (i), (ii), (iii)...
                      Subclause     (I), (II), (III)...

Example: 18 U.S.C. § 1030(a)(2)(C)
  Title 18:       Crimes and Criminal Procedure
  Section 1030:   Fraud and Related Activity (Computer Fraud)
  Subsection (a): Whoever... (the prohibition)
  Paragraph (2):  Intentionally accesses a computer
  Subparagraph (C): Information from any protected computer

Components of a Statute:
  Title/Name       Official title (e.g., "Clean Air Act")
  Short Title      Commonly used name, often Section 1
  Preamble         Purpose and findings (non-binding but interpretive)
  Definitions      Section defining key terms (critical for interpretation)
  Operative Text   The actual rules, prohibitions, requirements
  Exceptions       Carve-outs and safe harbors
  Penalties        Consequences for violation
  Effective Date   When the law takes effect
  Severability     If one provision invalid, others survive
  Sunset Clause    Automatic expiration date (if included)

Drafting Conventions:
  "Shall"     Mandatory (must do)
  "May"       Permissive (allowed to do)
  "And"       All items required (conjunctive)
  "Or"        Any one item sufficient (disjunctive)
  "Includes"  Non-exhaustive list (and other similar things)
  "Means"     Exhaustive definition (only these things)
  "Person"    Often includes corporations and other entities
  "Notwithstanding"  Overrides conflicting provisions
EOF
}

cmd_interpretation() {
    cat << 'EOF'
=== Statutory Interpretation ===

Schools of Interpretation:

Textualism:
  Focus on the plain meaning of the text
  "The law is what Congress enacted, not what it intended"
  Champion: Justice Antonin Scalia
  Tools: Dictionaries, ordinary meaning, grammar
  Rule: If text is clear, inquiry ends there

Purposivism:
  Focus on the purpose and policy behind the statute
  "What problem was Congress trying to solve?"
  Champion: Justice Stephen Breyer
  Tools: Legislative history, committee reports, floor debates

Intentionalism:
  Focus on what the legislature actually intended
  Tools: Legislative history, sponsor statements
  Criticism: "Collective intent" is a fiction

Canons of Construction:

Textual Canons:
  Plain Meaning Rule     Words given ordinary meaning unless defined
  Whole Act Rule         Read statute as coherent whole
  Consistent Usage       Same word = same meaning throughout
  Noscitur a Sociis      Words known by their companions
                         "guns, rifles, and other weapons" → weapons context
  Ejusdem Generis        General term limited by specific terms
                         "cars, trucks, and other vehicles" → motor vehicles
  Expressio Unius        Express mention of one = exclusion of others
                         "cats and dogs" excludes birds
  Rule Against Surplusage  Every word has meaning; no redundancy
  Last Antecedent Rule   Modifier applies to nearest term

Substantive Canons:
  Rule of Lenity         Ambiguous criminal statutes construed in
                         favor of the defendant
  Presumption Against    Avoid interpreting to make statute
    Unconstitutionality    unconstitutional
  Charming Betsy Canon   Interpret to avoid violating international law
  Clear Statement Rule   Congress must be clear to: abrogate sovereign
                         immunity, preempt state law, apply retroactively
  Deference to Agencies  Chevron deference (if statute ambiguous,
                         defer to reasonable agency interpretation)

Legislative History:
  Most reliable:  Committee reports
  Moderate:       Floor debate statements by sponsors
  Least reliable: Statements by individual members
  Rejected:       Textualists largely reject all legislative history
EOF
}

cmd_types() {
    cat << 'EOF'
=== Types of Statutes ===

By Subject Matter:
  Criminal Statutes
    Define crimes and punishments
    Must be strictly construed (rule of lenity)
    Require mens rea (criminal intent) unless strict liability
    Examples: 18 U.S.C. § 1341 (mail fraud), § 1962 (RICO)

  Civil Statutes
    Govern relationships between private parties
    Broadly construed to effectuate purpose
    Examples: Contract law, property law, family law

  Procedural Statutes
    Govern court processes and litigation
    Rules of civil/criminal procedure
    Statutes of limitations, filing requirements
    Examples: 28 U.S.C. § 1332 (diversity jurisdiction)

  Remedial Statutes
    Designed to correct a societal problem
    Broadly construed to achieve remedial purpose
    Examples: Civil Rights Act, ADA, consumer protection

By Function:
  Enabling Statutes
    Create agencies and grant them power
    Example: Federal Trade Commission Act (created FTC)

  Appropriations Statutes
    Authorize government spending
    Must be renewed annually

  Revenue Statutes
    Impose taxes (Internal Revenue Code — Title 26)
    Must originate in the House of Representatives

  Regulatory Statutes
    Set standards for industries
    Often delegate rulemaking to agencies
    Examples: Clean Air Act, Securities Act

By Duration:
  Permanent Statutes    Remain in effect until repealed
  Temporary Statutes    Include sunset clause (automatic expiration)
  Session Laws          Record of all laws enacted in a session

By Scope:
  General Statutes      Apply to all persons/entities
  Special Statutes      Apply to specific groups or situations
  Private Statutes      Apply to named individuals (rare today)
  Local Statutes        Apply only to specific geographic areas

Conflicts Between Statutes:
  Later in time prevails (later Congress can override earlier)
  Specific prevails over general
  Federal preempts state (Supremacy Clause)
  Constitutional provisions prevail over all statutes
EOF
}

cmd_citation() {
    cat << 'EOF'
=== Citing Statutes ===

Bluebook Format (Standard Legal Citation):

Federal Statutes (U.S. Code):
  [Title] U.S.C. § [Section] ([Year])
  42 U.S.C. § 1983 (2018)
  15 U.S.C. §§ 1-7 (2018)          (range of sections)

Session Laws (Statutes at Large):
  [Name], Pub. L. No. [Congress]-[Number], [Volume] Stat. [Page] ([Year])
  Sarbanes-Oxley Act of 2002, Pub. L. No. 107-204, 116 Stat. 745 (2002)

State Statutes:
  [State abbreviation] [Code name] § [Section] ([Year])
  Cal. Penal Code § 187 (West 2020)
  N.Y. Gen. Bus. Law § 349 (McKinney 2019)
  Tex. Bus. & Com. Code Ann. § 17.46 (West 2021)

Common Code Abbreviations:
  U.S.C.        United States Code
  C.F.R.        Code of Federal Regulations
  Fed. Reg.     Federal Register
  Stat.         Statutes at Large
  P.L. / Pub.L. Public Law

Short Citation Forms:
  First citation:  42 U.S.C. § 1983 (2018)
  Subsequent:      § 1983
  Id.:             Id. § 1984 (if immediately following)

Digital Citation:
  Many courts now accept hyperlinks
  Official sources: uscode.house.gov, congress.gov
  Include permanent URL where available

ALWD Guide Format:
  Similar to Bluebook but more accessible
  [Title] U.S.C. § [Section] ([Year])
  Same for most statutory citations

Practical Tips:
  1. Always cite the official code, not session laws
  2. Include year of the code edition cited
  3. Use § for section (not "Section" or "Sec.")
  4. Use §§ for multiple sections
  5. Pin cite to specific subsection when possible
  6. Check if statute has been amended since cited edition
EOF
}

cmd_examples() {
    cat << 'EOF'
=== Notable U.S. Statutes ===

Civil Rights Act of 1964 (Pub. L. 88-352)
  Prohibited discrimination based on race, color, religion,
  sex, or national origin
  Title VII: Employment discrimination
  Title II: Public accommodations
  Enforced by: EEOC
  Impact: Foundation of anti-discrimination law

Clean Air Act (42 U.S.C. § 7401 et seq.)
  First enacted 1963, major amendments 1970, 1990
  Regulates air emissions from stationary and mobile sources
  Established National Ambient Air Quality Standards (NAAQS)
  Created emissions trading (cap-and-trade) for SO2
  Administered by: EPA

Americans with Disabilities Act (42 U.S.C. § 12101)
  Enacted 1990, amended 2008 (ADAAA)
  Prohibits discrimination against people with disabilities
  Title I: Employment (15+ employees)
  Title II: Government services
  Title III: Public accommodations
  Requires "reasonable accommodations"

Sherman Antitrust Act (15 U.S.C. §§ 1-7)
  Enacted 1890 — oldest U.S. antitrust statute
  § 1: Prohibits contracts in restraint of trade
  § 2: Prohibits monopolization and attempts to monopolize
  Criminal penalties: up to $100M (corporations), 10 years
  Enforced by: DOJ Antitrust Division

Internal Revenue Code (26 U.S.C.)
  Comprehensive federal tax law
  ~3.4 million words (one of the longest statutes)
  Amended nearly every year
  Administered by: IRS
  Major revisions: 1954, 1986, 2017 (TCJA)

PATRIOT Act (Pub. L. 107-56, 2001)
  Post-9/11 anti-terrorism legislation
  Expanded surveillance and search powers
  National Security Letters (NSLs)
  Controversial: civil liberties vs security debate
  Parts expired/modified by USA Freedom Act (2015)
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== Statutory Research Checklist ===

Finding the Statute:
  [ ] Identify the relevant jurisdiction (federal, state, local)
  [ ] Search official code (U.S. Code, state code)
  [ ] Verify you have the current version
  [ ] Check for recent amendments
  [ ] Note the effective date

Reading the Statute:
  [ ] Read the definitions section first
  [ ] Identify the operative language (shall, may, must)
  [ ] Note all exceptions and exemptions
  [ ] Read related sections cross-referenced
  [ ] Check for sunset clauses or expiration dates

Interpreting the Statute:
  [ ] Apply plain meaning first
  [ ] Check if key terms are defined in the statute
  [ ] Look for relevant case law interpreting the statute
  [ ] Review legislative history if text is ambiguous
  [ ] Consider applicable canons of construction
  [ ] Check for agency regulations implementing the statute

Validating the Statute:
  [ ] Confirm the statute is still in force (not repealed)
  [ ] Check for constitutional challenges
  [ ] Verify no preemption by federal law (for state statutes)
  [ ] Look for conflicting statutes
  [ ] Shepardize/KeyCite for subsequent history

Applying the Statute:
  [ ] Identify all elements required by the statute
  [ ] Match facts to each statutory element
  [ ] Consider burden of proof requirements
  [ ] Check statute of limitations
  [ ] Identify available remedies and penalties
  [ ] Consider administrative exhaustion requirements

Documentation:
  [ ] Proper citation format (Bluebook/ALWD)
  [ ] Pin cite to specific section/subsection
  [ ] Note edition year of code cited
  [ ] Record search terms and databases used
EOF
}

show_help() {
    cat << EOF
statute v$VERSION — Legal Statutes Reference

Usage: script.sh <command>

Commands:
  intro          Statutes overview — definition, hierarchy, codification
  process        How a bill becomes law
  structure      Anatomy of a statute — sections, subsections
  interpretation Statutory interpretation — canons of construction
  types          Types of statutes — criminal, civil, remedial
  citation       How to cite statutes (Bluebook, ALWD)
  examples       Notable U.S. statutes and their impact
  checklist      Statutory research checklist
  help           Show this help
  version        Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)          cmd_intro ;;
    process)        cmd_process ;;
    structure)      cmd_structure ;;
    interpretation) cmd_interpretation ;;
    types)          cmd_types ;;
    citation)       cmd_citation ;;
    examples)       cmd_examples ;;
    checklist)      cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "statute v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
