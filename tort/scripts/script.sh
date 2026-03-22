#!/usr/bin/env bash
# tort — Tort Law Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Tort Law — Overview ===

A tort is a civil wrong (other than breach of contract) that causes
harm to another, for which the law provides a remedy.

Etymology:
  From French "tort" = wrong, from Latin "tortus" = twisted

Purpose of Tort Law:
  - Compensate victims for harm suffered
  - Deter harmful conduct
  - Shift loss from victim to wrongdoer
  - Vindicate individual rights
  - Distribute costs of harmful activities

Three Categories of Torts:

1. Intentional Torts
   Defendant intended the act (or substantially certain of result)
   Examples: battery, assault, false imprisonment, trespass

2. Negligence
   Defendant failed to exercise reasonable care
   Most common tort claim
   Elements: duty, breach, causation, damages

3. Strict Liability
   Defendant liable regardless of fault or intent
   Applies to: abnormally dangerous activities, product defects,
   wild animal ownership

Tort vs Crime:
  Tort               Crime
  Civil wrong         Wrong against society
  Plaintiff sues      State prosecutes
  Money damages       Imprisonment / fines
  Preponderance       Beyond reasonable doubt
  Can be both:        Same act can be a tort AND a crime

Tort vs Contract:
  Tort               Contract
  Duty imposed by law Duty from agreement
  No privity needed   Privity required (generally)
  Broader damages     Limited to contract terms
  Punitive damages    Generally no punitives possible

Sources of Tort Law:
  Common law:       Judge-made law through precedent
  Restatements:     Restatement (Third) of Torts (ALI)
  Statutes:         Workers' comp, no-fault auto, tort reform acts
  Constitutional:   Section 1983 civil rights claims (torts against govt)
EOF
}

cmd_negligence() {
    cat << 'EOF'
=== Negligence ===

Four Elements (plaintiff must prove all):

1. DUTY — Did defendant owe plaintiff a duty of care?
  General rule: Duty to exercise reasonable care to avoid
  foreseeable harm to foreseeable plaintiffs
  
  Special duty rules:
    Landowners:
      Trespasser: No duty (except known trespasser / child attractive nuisance)
      Licensee:   Warn of known hidden dangers
      Invitee:    Inspect and make safe (highest duty)
      Modern trend: Abolish categories, use general reasonableness
    
    Professionals:
      Standard: Skill and care of reasonably competent professional
      Doctors: National or community standard of care
      Lawyers: Competent attorney in that practice area
    
    No duty (general rule):
      No duty to rescue (moral but not legal obligation)
      Exception: Special relationship (parent-child, carrier-passenger)
      Exception: You created the peril
      Exception: Good Samaritan statutes (protect rescuers from liability)

2. BREACH — Did defendant fail to meet the duty?
  Reasonable Person Standard:
    What would a reasonably prudent person do under similar circumstances?
    Objective test (not what THIS person thought was reasonable)
  
  Breach analysis tools:
    Hand Formula (Judge Learned Hand):
      B < P × L → breach exists
      B = Burden of precaution
      P = Probability of harm
      L = Magnitude of loss
    
    Custom:     Industry custom is evidence but not conclusive
    Statute:    Violation of safety statute = negligence per se
    Res Ipsa Loquitur: "The thing speaks for itself"
      Requirements: (1) Accident doesn't normally happen without negligence
                    (2) Instrumentality in defendant's control
                    (3) Plaintiff didn't contribute

3. CAUSATION
  Actual cause (cause-in-fact):
    "But for" the defendant's conduct, harm would not have occurred
    Exception: Substantial factor test (multiple causes)
    Exception: Alternative liability (Summers v. Tice — shift burden)
  
  Proximate cause (legal cause):
    Was the harm a foreseeable result of the breach?
    Palsgraf v. Long Island Railroad (1928): Cardozo limits liability
    to foreseeable plaintiffs and foreseeable types of harm
    Superseding cause: Unforeseeable intervening act breaks chain
    Criminal acts of third parties: Generally superseding unless foreseeable

4. DAMAGES — Did plaintiff suffer actual harm?
  Must prove actual damages (no nominal damages for negligence)
  Types: economic (medical bills, lost wages) + non-economic (pain, suffering)
  See damages command for detailed breakdown
EOF
}

cmd_intentional() {
    cat << 'EOF'
=== Intentional Torts ===

Assault:
  Elements:
    1. Intentional act
    2. Creating reasonable apprehension
    3. Of imminent harmful or offensive contact
  Notes:
    - Words alone generally insufficient (need overt act)
    - Plaintiff must be aware of the threat
    - Future threats not actionable ("I'll get you tomorrow")
    - Conditional threats may qualify ("If you weren't my friend...")

Battery:
  Elements:
    1. Intentional act
    2. Causing harmful or offensive contact
    3. With plaintiff's person (or something closely connected)
  Notes:
    - Contact need not be direct (e.g., poisoning food)
    - Plaintiff need not be aware (e.g., surgery while unconscious)
    - Extends to clothing, items held, car being driven
    - "Offensive" = would offend reasonable sense of dignity

False Imprisonment:
  Elements:
    1. Intentional act
    2. Confining plaintiff within boundaries
    3. Plaintiff aware of confinement (or harmed by it)
    4. No reasonable means of escape
  Notes:
    - Boundaries can be physical, threats, or invalid legal authority
    - Shopkeeper's privilege: reasonable detention for investigation
    - Moral pressure alone insufficient
    - Must be total confinement (not just blocking one direction)

Intentional Infliction of Emotional Distress (IIED):
  Elements:
    1. Intentional or reckless conduct
    2. That is extreme and outrageous
    3. Causing severe emotional distress
  Notes:
    - "Outrageous" = beyond all bounds of decency, atrocious
    - Mere insults generally insufficient
    - Sensitivity: heightened duty to known-vulnerable plaintiffs
    - Physical manifestation not required in most jurisdictions

Trespass to Land:
  Elements:
    1. Intentional physical invasion
    2. Of plaintiff's land
  Notes:
    - Intent: Only need to intend the entry (not know it's trespass)
    - Includes: walking on, throwing objects onto, causing particles
    - Above and below: Airspace (reasonable), subsurface (minerals)
    - Nominal damages available (no actual harm needed)

Trespass to Chattels:
  Intentional interference with personal property
  Must cause actual damage or deprivation of use
  Remedy: Cost of repair or loss of use

Conversion:
  Intentional exercise of dominion over personal property
  So serious it warrants payment of full value
  Remedy: Full value of the property (forced sale)
  Distinguish from trespass to chattels by severity

Defamation (Libel and Slander):
  Elements:
    1. False statement of fact
    2. Published to a third party
    3. Regarding the plaintiff
    4. Causing damage to reputation
  Public figures: Must prove actual malice (NY Times v. Sullivan)
  Libel = written; Slander = spoken
  Slander per se: certain categories presumed damages
EOF
}

cmd_strict() {
    cat << 'EOF'
=== Strict Liability ===

Strict liability imposes liability WITHOUT requiring proof
of fault, intent, or negligence. Policy: some activities
are so inherently dangerous that those who engage in them
should bear the costs of harm.

Products Liability:
  Three theories for defective product claims:
  
  1. Manufacturing Defect
     Product departs from intended design
     Example: Bottle with a crack, car with missing bolt
     Test: Does product conform to manufacturer's own specs?
     Strict liability: Plaintiff need not prove negligence

  2. Design Defect
     All products of that design are unreasonably dangerous
     Two tests:
       Consumer Expectations: Product more dangerous than
         ordinary consumer would expect
       Risk-Utility (Barker): Risks outweigh benefits
         Factors: usefulness, safety, alternative designs,
         ability to eliminate risk, user awareness, manufacturer feasibility
     Example: Car fuel tank placed in crush zone

  3. Failure to Warn (Marketing Defect)
     Inadequate warnings or instructions
     Must warn of risks that are:
       - Known or reasonably knowable
       - Not obvious to ordinary user
     Learned intermediary doctrine: For prescription drugs,
       warning to physician may suffice
     Example: Drug without side effect warning

  Who can be liable (product liability chain):
    Manufacturer → Distributor → Retailer → (all strictly liable)
    Commercial sellers: strictly liable
    Casual sellers: not strictly liable (garage sale)

Abnormally Dangerous Activities:
  Restatement factors:
    (a) High degree of risk of harm
    (b) Gravity of potential harm is great
    (c) Cannot be eliminated by reasonable care
    (d) Not a matter of common usage
    (e) Inappropriate for the location
    (f) Value to community doesn't outweigh risks
  
  Classic examples:
    - Blasting/explosives
    - Storing large quantities of flammable materials
    - Crop dusting with toxic chemicals
    - Keeping wild animals
    - Nuclear power plant operations
  
  NOT abnormally dangerous:
    - Driving a car (common usage)
    - Owning domestic animals (unless known dangerous propensity)
    - Construction (with reasonable care)

Animals:
  Wild animals: Strict liability for any harm
  Domestic animals: Strict liability only if owner knew of
    dangerous propensity ("one bite rule")
  Dog bite statutes: Many states impose strict liability
    regardless of prior knowledge

Defenses to Strict Liability:
  Assumption of risk: Knowingly encountering the danger
  Product misuse: Unforeseeable misuse by plaintiff
  Comparative fault: Some jurisdictions reduce recovery
  Statute of repose: Time limit from manufacture date
  Government contractor defense: Spec'd by government
EOF
}

cmd_damages() {
    cat << 'EOF'
=== Tort Damages ===

Compensatory Damages (make plaintiff whole):

  Economic Damages (Special Damages):
    Medical expenses (past and future)
    Lost wages and earning capacity
    Property damage and repair costs
    Household services plaintiff can no longer perform
    Rehabilitation and therapy costs
    Future care costs (life care plan)
    
    Calculation: Typically precise dollar amounts
    Evidence: Bills, receipts, expert testimony
    Future damages: Reduced to present value

  Non-Economic Damages (General Damages):
    Pain and suffering
    Emotional distress
    Loss of enjoyment of life
    Loss of consortium (spouse's claim)
    Disfigurement and disability
    
    Calculation: No formula — jury discretion
    Methods: Per diem ($ per day of suffering), multiplier
    Caps: Many states cap non-economic damages
      Medical malpractice caps: $250K-$750K (varies by state)

Punitive Damages (Exemplary):
  Purpose: Punish egregious conduct, deter future behavior
  Standard: Willful, malicious, fraudulent, or reckless conduct
  NOT available for ordinary negligence
  
  Constitutional limits (BMW v. Gore, State Farm v. Campbell):
    - Single-digit ratio to compensatory damages (guideline)
    - Consider: reprehensibility, ratio, comparable sanctions
    - Must have fair notice of potential punishment
  
  Some states: Cap punitives (e.g., 3× compensatory or $500K)
  Some states: Share with state (split-recovery statutes)

Nominal Damages:
  Token amount ($1) recognizing a right was violated
  Available for: Intentional torts, trespass to land
  NOT available for: Negligence (must prove actual damages)

Collateral Source Rule:
  Plaintiff's recovery not reduced by payments from other sources
  Insurance payments, employer benefits don't offset damages
  Modern trend: Some states have modified or abolished this rule

Mitigation:
  Plaintiff must take reasonable steps to minimize damages
  Example: Seek medical treatment, not aggravate injury
  Failure to mitigate reduces recovery

Wrongful Death:
  Statutory claim by survivors for death caused by tort
  Damages: Lost financial support, funeral costs, loss of companionship
  Survival Action: Decedent's own claims survive death
  Statute of limitations: Varies by state (1-3 years)
EOF
}

cmd_defenses() {
    cat << 'EOF'
=== Tort Defenses ===

Contributory Negligence:
  Plaintiff's own negligence bars recovery entirely
  Harsh rule: Even 1% plaintiff fault = $0 recovery
  Still used: Alabama, DC, Maryland, North Carolina, Virginia
  Last clear chance doctrine: Exception if defendant had last
    opportunity to avoid the harm

Comparative Fault (Modern Majority):
  Pure Comparative (13 states):
    Plaintiff's recovery reduced by percentage of fault
    Even 99% at fault → recovers 1% of damages
    Examples: California, New York, Florida
  
  Modified Comparative — 50% Bar (10 states):
    Plaintiff recovers if fault ≤ 50%
    At 51% fault → barred entirely
  
  Modified Comparative — 51% Bar (23 states):
    Plaintiff recovers if fault < 51%
    At 50% → still recovers; at 51% → barred

Assumption of Risk:
  Express:  Signed waiver/release
    Generally enforced unless: public interest, gross negligence,
    ambiguous language, or unequal bargaining power
  
  Implied Primary: Plaintiff knew of and voluntarily encountered risk
    inherent in the activity
    Example: Baseball spectator hit by foul ball
    Effect: No duty owed (complete defense)
  
  Implied Secondary: Plaintiff knew of specific risk created by
    defendant's negligence and proceeded anyway
    Effect: May be merged into comparative fault

Consent:
  Complete defense to intentional torts
  Express consent: Written or verbal permission
  Implied consent: Conduct or circumstances
  Medical consent: Informed consent doctrine
  Scope: Consent to one act ≠ consent to all acts
  Cannot consent to: Criminal acts (in some jurisdictions)

Privilege/Justification:
  Self-defense: Reasonable force to prevent imminent harm
  Defense of others: Same privilege as person being defended
  Defense of property: Reasonable non-deadly force
  Necessity: Interfere with property to prevent greater harm
    Private necessity: Must pay for actual damages
    Public necessity: No liability (community benefit)
  Authority of law: Lawful arrest, court orders

Immunities:
  Sovereign immunity: Government (waived by FTCA, state tort claims acts)
  Charitable immunity: Largely abolished
  Spousal immunity: Largely abolished
  Parent-child immunity: Limited in most states
  Judicial/legislative immunity: Absolute for official acts

Statutes of Limitations:
  Personal injury:    1-3 years (varies by state)
  Property damage:    2-6 years
  Medical malpractice: 1-3 years
  Discovery rule:     Clock starts when injury discovered
  Tolling:           Minors, incapacity, defendant concealment
EOF
}

cmd_examples() {
    cat << 'EOF'
=== Landmark Tort Cases ===

Palsgraf v. Long Island Railroad (1928)
  Facts: Railroad employee pushed passenger; package of fireworks
    fell, exploded, shock knocked scale onto distant plaintiff
  Held: No liability — plaintiff was unforeseeable
  Rule: Duty is owed only to foreseeable plaintiffs
  Significance: Defines proximate cause through foreseeability

Donoghue v. Stevenson (1932) — UK
  Facts: Snail found in ginger beer bottle; consumer became ill
  Held: Manufacturer owes duty to ultimate consumer
  Rule: "Neighbor principle" — must take reasonable care for
    persons closely and directly affected by your acts
  Significance: Foundation of modern negligence law

MacPherson v. Buick Motor Co. (1916)
  Facts: Defective wheel collapsed; buyer injured
  Held: Manufacturer liable to consumer despite no direct contract
  Rule: Abolished privity requirement for negligence
  Significance: Paved way for modern products liability

Liebeck v. McDonald's (1994) — "Hot Coffee Case"
  Facts: 79-year-old spilled 180°F coffee, third-degree burns
  Held: McDonald's knew of 700+ burn complaints, served unreasonably hot
  Damages: $160K compensatory + $2.7M punitive (reduced to $480K)
  Significance: Often misunderstood — highlights real negligence analysis

Rylands v. Fletcher (1868) — UK
  Facts: Water from defendant's reservoir escaped and flooded
    plaintiff's coal mine through abandoned shafts
  Held: Strict liability for non-natural use of land
  Rule: One who brings dangerous things onto land is strictly
    liable if they escape and cause harm
  Significance: Foundation of strict liability doctrine

BMW v. Gore (1996)
  Facts: BMW sold repainted car as new; $4K actual harm
  Jury: $4M punitive damages
  Supreme Court: Reversed — 1000:1 ratio "grossly excessive"
  Rule: Due process limits on punitive damages
  Factors: Reprehensibility, ratio, comparable penalties

Escola v. Coca-Cola Bottling (1944)
  Facts: Bottle exploded in waitress's hand
  Concurrence (Traynor): Argued for strict products liability
  Significance: Seeds of Restatement (Second) § 402A
  → Greenman v. Yuba Power (1963): Strict products liability adopted
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== Tort Claim Analysis Checklist ===

Threshold Questions:
  [ ] Identify the type of tort (intentional, negligence, strict)
  [ ] Determine applicable jurisdiction and law
  [ ] Check statute of limitations (when did injury occur?)
  [ ] Identify all potential defendants
  [ ] Identify all potential plaintiffs (including derivative claims)

Negligence Analysis:
  [ ] Duty: Did defendant owe a duty to plaintiff?
  [ ] Duty: What standard of care applies?
  [ ] Breach: Did defendant's conduct fall below the standard?
  [ ] Breach: Is there evidence of negligence per se?
  [ ] Causation: But-for cause established?
  [ ] Causation: Proximate cause (foreseeable harm)?
  [ ] Causation: Any superseding causes?
  [ ] Damages: Actual harm proved?

Intentional Tort Analysis:
  [ ] Identify specific intentional tort (battery, assault, etc.)
  [ ] Intent element satisfied (purpose or substantial certainty)?
  [ ] All elements of the specific tort proven?
  [ ] Transferred intent applicable?
  [ ] Consent defense available?

Strict Liability Analysis:
  [ ] Product defect: manufacturing, design, or warning?
  [ ] Was defendant a commercial seller?
  [ ] Was product unreasonably dangerous?
  [ ] Abnormally dangerous activity factors evaluated?

Damages Assessment:
  [ ] Economic damages calculated (medical, lost wages)
  [ ] Non-economic damages estimated (pain, suffering)
  [ ] Future damages projected (life care plan, lost earning capacity)
  [ ] Punitive damages warranted? (egregious conduct)
  [ ] Collateral sources identified
  [ ] Mitigation duty assessed

Defenses:
  [ ] Comparative/contributory negligence evaluated
  [ ] Assumption of risk (express or implied)?
  [ ] Any applicable immunities (sovereign, etc.)?
  [ ] Statute of limitations/repose check
  [ ] Any preemption by federal law?
  [ ] Product misuse or alteration?
EOF
}

show_help() {
    cat << EOF
tort v$VERSION — Tort Law Reference

Usage: script.sh <command>

Commands:
  intro        Tort law overview — categories, purpose, sources
  negligence   Negligence — duty, breach, causation, damages
  intentional  Intentional torts — assault, battery, IIED, trespass
  strict       Strict liability — products, dangerous activities
  damages      Damages — compensatory, punitive, nominal
  defenses     Defenses — comparative fault, assumption of risk
  examples     Landmark tort cases
  checklist    Tort claim analysis checklist
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)       cmd_intro ;;
    negligence)  cmd_negligence ;;
    intentional) cmd_intentional ;;
    strict)      cmd_strict ;;
    damages)     cmd_damages ;;
    defenses)    cmd_defenses ;;
    examples)    cmd_examples ;;
    checklist)   cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "tort v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
