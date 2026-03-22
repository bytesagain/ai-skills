#!/usr/bin/env bash
# precedent — Legal Precedent Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Legal Precedent ===

Precedent (stare decisis) is the legal principle that courts should
follow decisions of higher courts in similar cases. It is the
foundation of the common law system.

Stare Decisis — "to stand by things decided":
  Horizontal: court follows its own prior decisions
  Vertical:   lower court follows higher court decisions

Purpose of Precedent:
  Consistency:     Similar cases treated similarly
  Predictability:  Parties can anticipate legal outcomes
  Efficiency:      Courts don't relitigate settled questions
  Fairness:        Equal treatment under law
  Stability:       Law doesn't change capriciously
  Legitimacy:      Decisions grounded in reasoned history

Common Law vs Civil Law:
  Common Law (UK, US, Australia, Canada, India):
    Precedent is binding (primary source of law)
    Judges "make law" through case decisions
    Statute + case interpretation = the law

  Civil Law (France, Germany, China, Japan):
    Codes are primary source of law
    Precedent is persuasive but not strictly binding
    Judges apply code provisions, not prior decisions
    Exception: constitutional courts (Germany's BVerfG)

  Mixed Systems:
    Scotland:  Mix of common law and Roman law
    Louisiana: Civil law in private matters, common law in public
    Quebec:    Civil law in private, common law in public/criminal

Key Terminology:
  Ratio decidendi:  The legal principle/reasoning that decided the case
  Obiter dictum:    Comments made "in passing" (not binding)
  Holding:          The court's decision on the legal issue
  Material facts:   Facts essential to the court's reasoning
  Disposition:      What the court ordered (affirmed, reversed, remanded)
  Per curiam:       Decision by the whole court (no individual author)
  En banc:          Full panel of appellate court (not 3-judge panel)
  Certiorari:       Supreme Court's discretionary review
EOF
}

cmd_hierarchy() {
    cat << 'EOF'
=== Court Hierarchy & Binding Authority ===

US Federal Court System:
  Supreme Court of the United States (SCOTUS)
    ↑ Binding on ALL courts in the US
  US Courts of Appeals (13 Circuits)
    ↑ Binding within their circuit
    ↑ Persuasive in other circuits
  US District Courts (94 districts)
    ↑ Trial courts — create record, apply law
    ↑ Not binding on other district courts

  Circuit Map:
    1st:   ME, MA, NH, RI, PR
    2nd:   CT, NY, VT
    3rd:   DE, NJ, PA, VI
    4th:   MD, NC, SC, VA, WV
    5th:   LA, MS, TX
    6th:   KY, MI, OH, TN
    7th:   IL, IN, WI
    8th:   AR, IA, MN, MO, NE, ND, SD
    9th:   AK, AZ, CA, HI, ID, MT, NV, OR, WA, Guam
    10th:  CO, KS, NM, OK, UT, WY
    11th:  AL, FL, GA
    DC:    Washington DC (federal administrative law)
    Fed:   Patent, trade, government contracts (nationwide)

Binding vs Persuasive Authority:
  Binding (must follow):
    - Higher court in same jurisdiction
    - Same court's prior decisions (generally)
    - SCOTUS on federal constitutional/statutory issues

  Persuasive (may consider but not required):
    - Courts in other jurisdictions
    - Lower court decisions
    - Dissenting opinions
    - Foreign court decisions
    - Law review articles / Restatements
    - Dicta from higher courts

State Court Systems:
  State Supreme Court (or Court of Appeals in NY/MD)
    ↑ Binding on all state courts
  Intermediate Appellate Court
    ↑ Binding within its district/division
  Trial Court (Superior, Circuit, District — names vary)
    ↑ Not binding on other trial courts

Federal vs State:
  Federal courts bind on federal law
  State courts bind on state law
  SCOTUS: final arbiter on US Constitution
  State supreme court: final arbiter on state constitution
  Erie Doctrine: federal courts apply state substantive law
EOF
}

cmd_analysis() {
    cat << 'EOF'
=== Case Analysis ===

Breaking Down a Case:

1. Case Name & Citation:
   Brown v. Board of Education, 347 U.S. 483 (1954)
   ↑ Parties    ↑ Volume  ↑ Reporter  ↑ Page  ↑ Year

2. Facts:
   - Who are the parties?
   - What happened? (chronological narrative)
   - What did the lower court decide?
   - Identify MATERIAL facts (those the court relied upon)
   - Ignore background facts (interesting but not decisive)

3. Issue:
   The legal question the court must answer
   Format: "Whether [legal question] when [key facts]"
   Example: "Whether segregation of public schools by race
   violates the Equal Protection Clause of the 14th Amendment"

4. Holding:
   The court's answer to the issue
   "Yes, segregation in public education is inherently unequal
   and violates the Equal Protection Clause."
   This IS the precedent — the binding legal rule

5. Reasoning (Ratio Decidendi):
   WHY the court reached its holding
   The legal logic connecting facts to conclusion
   This is what lower courts must follow
   May include statutory interpretation, policy, prior cases

6. Dicta (Obiter Dictum):
   Statements not necessary to the decision
   Hypothetical scenarios, policy discussions, commentary
   NOT binding but can be influential
   Future courts may elevate dicta to holding

Identifying Ratio vs Dicta:
  Ratio: "Remove this reasoning → holding changes"
  Dicta: "Remove this reasoning → holding unchanged"
  Test: Was this reasoning NECESSARY to resolve the issue?

  Example (simplified):
    Court holds: "Contract void because signed under duress"
    Court also says: "Additionally, the consideration was inadequate"
    Ratio: duress finding (necessary for holding)
    Dicta: consideration comment (holding stands without it)

Concurrences and Dissents:
  Majority opinion:  binding precedent (≥5 of 9 at SCOTUS)
  Concurrence:      agrees with result, different reasoning — NOT binding
  Plurality:        most votes but <majority — limited precedential weight
  Dissent:          disagrees — NOT binding but may signal future direction
  Per curiam:       unanimous, no attributed author
EOF
}

cmd_distinguishing() {
    cat << 'EOF'
=== Distinguishing Precedent ===

Distinguishing = arguing a prior case should NOT apply because
the current case is materially different.

Factual Distinguishing:
  Identify material facts that differ:
    Prior case: contract between two businesses
    Current case: contract between business and consumer
    Argument: consumer protection concerns create different context

  Key: the factual difference must be MATERIAL — it must matter
  to the legal reasoning, not just be a superficial difference

Legal Distinguishing:
  Different legal issue:
    Prior case decided contract formation
    Current case involves contract performance
    Argument: different legal rules apply

  Different statute/provision:
    Prior case interpreted Section 2(a)
    Current case involves Section 2(b)
    Argument: different statutory language, different analysis

Narrow Reading:
  Read the prior holding as narrowly as possible
  "The court in Smith only held that X when Y and Z were present.
  In our case, Z is absent, so Smith does not control."

Broad Reading:
  Your opponent will read the same case broadly
  "Smith established the general principle that X applies in all
  cases involving Y, regardless of Z."
  Courts often must choose between narrow and broad readings

Arguments for Distinguishing:
  1. Material facts differ in legally significant ways
  2. Legal issue is different (even if facts are similar)
  3. Applicable statute/regulation has changed since prior case
  4. Policy considerations have evolved
  5. Technology or social context has changed
  6. Prior case involved different procedural posture

Counter-Arguments (Against Distinguishing):
  1. The differences are superficial, not material
  2. The underlying legal principle is the same
  3. The policy rationale applies equally
  4. Allowing distinction would create inconsistency
  5. The court in the prior case anticipated this scenario

Analogizing (Opposite of Distinguishing):
  Argue current case IS like the prior case
  "Like in Smith, we have a situation where [shared material facts].
  The court in Smith held [holding]. The same reasoning applies here
  because [explain why facts are materially similar]."
EOF
}

cmd_overruling() {
    cat << 'EOF'
=== Overruling & Modifying Precedent ===

Overruling:
  A court explicitly states that a prior decision is no longer good law.
  Only the same court or a higher court can overrule.
  Lower courts CANNOT overrule higher court decisions.

Famous Overrulings:
  Brown v. Board (1954) overruled Plessy v. Ferguson (1896)
    "Separate but equal" → inherently unequal
  Lawrence v. Texas (2003) overruled Bowers v. Hardwick (1986)
    Sodomy laws unconstitutional
  Citizens United (2010) overruled Austin v. Michigan Chamber (1990)
    Corporate political speech
  Dobbs v. Jackson (2022) overruled Roe v. Wade (1973)
    Right to abortion no longer constitutional

When Courts Overrule:
  1. Prior reasoning was demonstrably wrong
  2. Facts/understanding have fundamentally changed
  3. Prior rule is unworkable in practice
  4. Related legal principles have evolved (erosion)
  5. Reliance interests are outweighed by correction

Other Modifications:

  Limiting:
    Court narrows but doesn't eliminate prior holding
    "Smith applies only to X situations, not Y"
    Prior case still valid but with reduced scope

  Harmonizing:
    Court reconciles apparently conflicting precedents
    "Smith and Jones can be read consistently if..."
    Both precedents survive

  Erosion:
    Gradual weakening through distinguishing and limiting
    Court avoids overruling but shrinks the precedent
    Eventually: "distinguished into oblivion"

  Abrogation by Statute:
    Legislature passes law that changes the rule
    Precedent no longer applies because statute supersedes
    Court decisions interpreting the old law become moot
    Example: Congress passing legislation to override court interpretation

Prospective vs Retroactive Overruling:
  Generally: overruling applies retroactively to pending cases
  Exception: some courts apply new rule prospectively only
    (to avoid unfairness to those who relied on old rule)
  Criminal law: new constitutional rules often retroactive
    (Teague v. Lane framework for when retroactivity applies)

Stare Decisis Factors (SCOTUS):
  1. Quality of reasoning in prior decision
  2. Workability of the rule
  3. Consistency with related doctrines
  4. Reliance interests (have people organized their lives around it?)
  5. Changed factual or legal context
EOF
}

cmd_research() {
    cat << 'EOF'
=== Case Law Research ===

Citation Formats:
  Federal:
    SCOTUS:     Brown v. Board, 347 U.S. 483 (1954)
    Circuit:    Smith v. Jones, 500 F.3d 200 (2d Cir. 2007)
    District:   Doe v. Roe, 300 F. Supp. 3d 150 (S.D.N.Y. 2020)

  State:
    Official:   People v. Smith, 50 Cal.4th 200 (2010)
    Regional:   Smith v. State, 300 S.W.3d 100 (Tex. 2009)

  Bluebook format (standard legal citation style):
    Party v. Party, Vol. Reporter Page (Court Year)

Validating Precedent (Is It Still Good Law?):

  Shepard's Citations (LexisNexis):
    Green:   Followed / affirmed
    Yellow:  Caution (questioned, limited, criticized)
    Red:     Overruled or reversed (NO LONGER GOOD LAW)
    Orange:  Negative treatment by other courts

  KeyCite (Westlaw):
    Green:   Positive treatment
    Yellow:  Some negative treatment
    Red:     No longer good law
    Blue H:  History available

  ALWAYS Shepardize/KeyCite before citing a case.
  Citing overruled precedent = credibility destruction.

Research Databases:
  Westlaw:       Premier US case law database
  LexisNexis:    Comprehensive legal research
  Google Scholar: Free case law search (limited annotation)
  Fastcase:      Free via many bar associations
  Casetext:      AI-assisted legal research (CoCounsel)
  CourtListener: Free, open-source case law (RECAP project)

Research Strategy:
  1. Start with secondary sources (treatises, law reviews)
  2. Identify key cases from secondary sources
  3. Use headnotes/key numbers to find related cases
  4. Read foundational cases in full
  5. Shepardize/KeyCite every case you plan to cite
  6. Check for recent developments (last 6 months)
  7. Build a case chart: case → holding → relevance to your issue

Legal Databases (International):
  UK:         BAILII (free), Westlaw UK, LexisNexis UK
  Canada:     CanLII (free), Westlaw Canada
  Australia:  AustLII (free), Jade
  EU:         CURIA (ECJ), EUR-Lex
  India:      Indian Kanoon (free), SCC Online
EOF
}

cmd_writing() {
    cat << 'EOF'
=== Using Precedent in Legal Writing ===

IRAC Method:
  Issue:        State the legal question
  Rule:         State the relevant legal rule (from precedent)
  Application:  Apply the rule to your facts
  Conclusion:   State the result

  Example:
  Issue: Whether the defendant's email constitutes a valid offer.
  Rule: Under Smith v. Corp (2015), "an offer must manifest a present
        intention to be bound and contain sufficiently definite terms."
  Application: Here, defendant's email stated "I will sell you the
        widget for $100, delivery by Friday." This manifests present
        intention ("I will") and contains definite terms (item, price,
        date). Unlike in Jones v. LLC where the court found the
        communication "merely invited further negotiation," defendant's
        email leaves nothing to negotiate.
  Conclusion: The email constitutes a valid offer under Smith.

Case Synthesis:
  Combine multiple cases into a unified legal rule:
    "Courts consistently hold that [general principle]. In Smith,
    the court found X because [reasoning]. Similarly, in Jones,
    the court held Y based on [reasoning]. Together, these cases
    establish that [synthesized rule]."

  Rule synthesis > string citation
  Show how cases relate to each other, not just list them

Signal Words (Bluebook signals):
  [no signal]:  Direct support for stated proposition
  See:          Cited authority supports but doesn't directly state
  See also:     Additional authority supporting the point
  Cf.:          Analogous support (different context, same logic)
  Compare...with: Highlight contrast between authorities
  But see:      Authority contradicts the stated proposition
  See generally: Background or general support

Parenthetical Explanations:
  Use parentheticals to explain how cited cases support your argument:
  Smith v. Jones, 500 F.3d 200 (2d Cir. 2007)
    (holding that email constitutes valid offer when terms definite).
  Keep parentheticals brief (one sentence) and relevant.

Do's and Don'ts:
  DO: Quote key language from the holding
  DO: Explain how facts compare to your case
  DO: Use recent, on-point cases from binding courts
  DO: Acknowledge and distinguish unfavorable precedent
  DON'T: Cite overruled or questioned cases
  DON'T: String cite without explanation
  DON'T: Mischaracterize a holding (judges will check)
  DON'T: Rely solely on dicta without acknowledging it
  DON'T: Ignore adverse authority (ethical obligation to disclose)
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== Case Law Analysis Checklist ===

Case Identification:
  [ ] Full case name and citation recorded
  [ ] Court identified (which level, which jurisdiction)
  [ ] Date of decision noted
  [ ] Majority, concurrence, and dissent authors noted
  [ ] Procedural history understood (how did it get to this court?)

Case Analysis:
  [ ] Material facts identified and listed
  [ ] Legal issue(s) stated precisely
  [ ] Holding identified (the binding rule)
  [ ] Ratio decidendi separated from obiter dicta
  [ ] Reasoning mapped (how did the court get from facts to holding?)
  [ ] Policy considerations noted
  [ ] Statutory provisions cited identified

Validation:
  [ ] Case Shepardized / KeyCited
  [ ] Treatment history reviewed (followed, distinguished, overruled?)
  [ ] Still good law confirmed
  [ ] Subsequent legislation checked (has statute been amended?)
  [ ] Recent cases citing this case reviewed

Application to Your Case:
  [ ] Binding or persuasive authority determined
  [ ] Material facts compared to your case
  [ ] Factual similarities identified (for analogizing)
  [ ] Factual differences identified (for distinguishing)
  [ ] Holding applied to your facts
  [ ] Counter-arguments anticipated
  [ ] Adverse authority identified and addressed

Writing Integration:
  [ ] Case introduced with context (not dropped in cold)
  [ ] Key quote from holding included
  [ ] Facts compared explicitly to your case
  [ ] Parenthetical explanation provided for string cites
  [ ] Proper Bluebook citation format used
  [ ] Pin cite to specific page (not just first page)
  [ ] Signal word appropriate (see, cf., but see)
EOF
}

show_help() {
    cat << EOF
precedent v$VERSION — Legal Precedent Reference

Usage: script.sh <command>

Commands:
  intro          Stare decisis, common law, purpose
  hierarchy      Court hierarchy, binding vs persuasive authority
  analysis       Ratio decidendi, obiter dicta, case breakdown
  distinguishing Factual/legal distinctions, narrow/broad readings
  overruling     When and how courts reverse precedent
  research       Citations, Shepardizing, databases, strategy
  writing        IRAC, synthesis, signal words, parentheticals
  checklist      Case analysis and application checklist
  help           Show this help
  version        Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)          cmd_intro ;;
    hierarchy)      cmd_hierarchy ;;
    analysis)       cmd_analysis ;;
    distinguishing) cmd_distinguishing ;;
    overruling)     cmd_overruling ;;
    research)       cmd_research ;;
    writing)        cmd_writing ;;
    checklist)      cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "precedent v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
