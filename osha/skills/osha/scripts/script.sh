#!/usr/bin/env bash
# osha — OSHA Compliance Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== OSHA — Occupational Safety and Health Administration ===

Mission: Ensure safe and healthful working conditions by setting and
enforcing standards and providing training, outreach, education, and
assistance.

Established: 1970 (Occupational Safety and Health Act, signed by Nixon)
Part of: U.S. Department of Labor
Covers: Most private sector employers and workers in all 50 states

Employer Responsibilities:
  - Provide a workplace free from recognized hazards (General Duty Clause)
  - Comply with all applicable OSHA standards
  - Inform employees about chemical hazards (HazCom/GHS)
  - Provide required PPE at no cost to employees
  - Keep records of injuries and illnesses (if 10+ employees)
  - Post OSHA 300A summary (Feb 1 – Apr 30 annually)
  - Display "Job Safety and Health" poster (OSHA 3165)
  - Not retaliate against employees who report hazards

Employee Rights:
  - File a complaint with OSHA (anonymously if desired)
  - Request an OSHA inspection
  - Access exposure and medical records
  - Refuse dangerous work (if imminent danger, good faith belief)
  - Participate in inspections (employee representative)
  - Receive training in a language they understand
  - Whistleblower protection (Section 11(c))

Penalties (2024 rates, adjusted annually):
  Other-Than-Serious    Up to $16,131 per violation
  Serious               $1,116 – $16,131 per violation
  Willful               $11,162 – $161,323 per violation
  Repeat                $11,162 – $161,323 per violation
  Failure to Abate      $16,131 per day beyond abatement date
EOF
}

cmd_standards() {
    cat << 'EOF'
=== Key OSHA Standards ===

General Industry (29 CFR 1910):
  1910.23   Walking-Working Surfaces (fall protection)
  1910.95   Occupational Noise Exposure (85 dBA TWA)
  1910.132  PPE General Requirements
  1910.134  Respiratory Protection
  1910.146  Permit-Required Confined Spaces
  1910.147  Lockout/Tagout (LOTO)
  1910.178  Powered Industrial Trucks (forklifts)
  1910.212  Machine Guarding
  1910.303  Electrical — General Requirements
  1910.1200 Hazard Communication (HazCom/GHS)

Construction (29 CFR 1926):
  1926.451  Scaffolding
  1926.501  Fall Protection (6-foot trigger)
  1926.502  Fall Protection Systems Criteria
  1926.503  Fall Protection Training
  1926.1052 Stairways
  1926.1053 Ladders
  1926.1101 Asbestos
  1926.62   Lead

General Duty Clause (Section 5(a)(1)):
  "Each employer shall furnish a place of employment which is free
   from recognized hazards that are causing or likely to cause death
   or serious physical harm to employees."
  Used when no specific standard covers the hazard.

Recordkeeping (29 CFR 1904):
  1904.4   Recording criteria
  1904.5   Work-relatedness determination
  1904.7   General recording criteria for cases
  1904.29  Forms (300, 300A, 301)
  1904.32  Annual summary posting
EOF
}

cmd_hazards() {
    cat << 'EOF'
=== Top 10 OSHA Violations (Fiscal Year 2023) ===

 1. Fall Protection — General (1926.501)         7,271 citations
 2. Hazard Communication (1910.1200)             3,213
 3. Ladders (1926.1053)                          2,978
 4. Scaffolding (1926.451)                       2,859
 5. Powered Industrial Trucks (1910.178)         2,561
 6. Lockout/Tagout (1910.147)                    2,554
 7. Respiratory Protection (1910.134)            2,481
 8. Fall Protection — Training (1926.503)        2,112
 9. Eye and Face Protection (1926.102)           2,074
10. Machine Guarding (1910.212)                  1,644

Hazard Categories:
  Physical    Noise, vibration, radiation, temperature extremes
  Chemical    Toxic substances, fumes, dust, solvents
  Biological  Bloodborne pathogens, mold, bacteria
  Ergonomic   Repetitive motion, awkward postures, heavy lifting
  Electrical  Exposed wiring, no GFCI, improper grounding
  Fall        Unguarded edges, ladders, scaffolds, floor openings

Fatal Four (Construction):
  Falls         38.7% of construction fatalities
  Struck-by     9.4%
  Electrocution 7.2%
  Caught-in     5.4%
  These four = 60.7% of all construction worker deaths
EOF
}

cmd_hierarchy() {
    cat << 'EOF'
=== Hierarchy of Controls ===

Most effective → Least effective:

1. ELIMINATION
   Remove the hazard entirely
   Example: redesign process to eliminate heights
   Best solution — no hazard = no risk

2. SUBSTITUTION
   Replace the hazard with something less dangerous
   Example: use water-based paint instead of solvent-based
   Consider: is the substitute truly less hazardous?

3. ENGINEERING CONTROLS
   Isolate people from the hazard
   Examples:
     - Machine guards and interlocks
     - Ventilation systems (LEV)
     - Noise enclosures
     - Guardrails and fall arrest anchors
     - Circuit breakers and GFCI
   Preferred over admin/PPE because they don't rely on behavior

4. ADMINISTRATIVE CONTROLS
   Change the way people work
   Examples:
     - Job rotation (reduce exposure time)
     - Warning signs and labels
     - Standard operating procedures
     - Training programs
     - Buddy system for confined spaces
   Less reliable — depend on human compliance

5. PPE (Personal Protective Equipment)
   Last resort — protect the individual worker
   Examples:
     - Hard hats, safety glasses, gloves
     - Respirators, hearing protection
     - Fall harness and lanyard
     - Steel-toe boots, face shields
   Limitations: must fit properly, be maintained, and be worn
   Employer must provide at no cost (except safety-toe shoes
   and prescription safety glasses in some cases)
EOF
}

cmd_inspection() {
    cat << 'EOF'
=== OSHA Inspection Process ===

What Triggers an Inspection (priority order):
  1. Imminent danger situations
  2. Fatalities and catastrophes (≥3 hospitalizations)
  3. Worker complaints and referrals
  4. Programmed inspections (targeted industries)
  5. Follow-up inspections

The Inspection Steps:
  1. Credentials
     - OSHA inspector (CSHO) presents credentials
     - Verify: federal photo ID + OSHA badge
     - You CAN verify by calling OSHA area office

  2. Opening Conference
     - Inspector explains reason for visit
     - Request employee representative to participate
     - Ask for scope: full inspection or partial?

  3. Walkaround
     - Inspector examines workplace for hazards
     - May take photos, samples, measurements
     - May interview employees (privately)
     - Employer representative can accompany

  4. Closing Conference
     - Inspector discusses findings
     - Possible violations and citations discussed
     - You will receive citations by mail (not on-site)

Employer Rights During Inspection:
  - Request a warrant (4th Amendment — inspector needs probable cause)
  - Accompany inspector during walkaround
  - Take notes and photos alongside inspector
  - Know the scope and reason for inspection
  - Contest citations within 15 working days

Preparation Checklist:
  [ ] OSHA poster displayed
  [ ] 300A log posted (if in posting period)
  [ ] Safety programs documented and current
  [ ] Training records accessible
  [ ] SDS sheets organized and accessible
  [ ] PPE records (fit tests, assignments)
  [ ] Emergency action plan posted
EOF
}

cmd_records() {
    cat << 'EOF'
=== OSHA Recordkeeping ===

Who Must Keep Records:
  Employers with 11+ employees (at any time during the year)
  Some industries exempt even with 11+ (low-hazard retail, finance)
  ALL employers must report fatalities and severe injuries

The Three Forms:
  OSHA 300  — Log of Work-Related Injuries and Illnesses
    One line per recordable case
    Columns: employee name, date, description, classification
    Keep for 5 years after the year of occurrence

  OSHA 300A — Summary of Work-Related Injuries and Illnesses
    Annual summary of the 300 Log
    Must post Feb 1 – Apr 30 in visible location
    Signed by company executive (certifying accuracy)

  OSHA 301  — Injury and Illness Incident Report
    Detailed report for each recordable case
    Must be completed within 7 calendar days
    Workers' comp first report of injury can substitute

What's Recordable:
  A work-related injury or illness that results in:
    - Death
    - Days away from work
    - Restricted work or job transfer
    - Medical treatment beyond first aid
    - Loss of consciousness
    - Significant injury/illness diagnosed by physician
    - Needlestick or sharps injury (with contamination)
    - Hearing loss (STS of 10 dB avg in either ear)

First Aid (NOT recordable):
  - Bandages, butterfly closures, Steri-Strips
  - Non-prescription meds at nonprescription strength
  - Cleaning and flushing wounds
  - Hot/cold therapy
  - Finger guards, elastic bandages, wraps
  - Drinking fluids for heat stress

Electronic Reporting (since 2017):
  Establishments 250+ employees: submit 300A annually via ITA portal
  Establishments 20-249 in certain industries: submit 300A annually
  Deadline: March 2 each year
EOF
}

cmd_training() {
    cat << 'EOF'
=== Required OSHA Training ===

All Industries:
  - Hazard Communication / GHS (1910.1200)
    Chemical hazards, SDS reading, labeling, pictograms
  - Emergency Action Plan (1910.38)
    Evacuation routes, alarm systems, assembly points
  - Fire Prevention Plan (1910.39)
    Fire hazards, proper storage, extinguisher locations
  - PPE (1910.132)
    When required, how to use, limitations, maintenance
  - Bloodborne Pathogens (1910.1030) — if exposure risk
    Universal precautions, cleanup procedures, post-exposure

Manufacturing / Industrial:
  - Lockout/Tagout (1910.147)
    Authorized vs affected employees, procedures, audit
  - Machine Guarding (1910.212)
    Types of guards, bypass prevention, inspection
  - Confined Space Entry (1910.146)
    Permit system, atmospheric testing, rescue plan
  - Forklift Operation (1910.178)
    Formal training + practical evaluation every 3 years
  - Hearing Conservation (1910.95)
    If exposed ≥85 dBA TWA — audiometric testing, HPD fit

Construction:
  - Fall Protection (1926.503)
    Hazard recognition, equipment use, rescue
  - Scaffolding (1926.454)
    Competent person training, inspection
  - Excavation/Trenching (1926.651)
    Soil classification, protective systems
  - Crane Operation (1926.1427)
    Certified operator required

Training Must Be:
  - In a language employees understand
  - Documented (date, topic, trainer, attendees)
  - Repeated when hazards change or new employees join
  - Refreshed periodically (check specific standard)
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== Workplace Safety Assessment Checklist ===

General:
  [ ] OSHA poster (3165) displayed in prominent location
  [ ] Emergency exits marked and unobstructed
  [ ] Emergency action plan documented and communicated
  [ ] First aid kits stocked and accessible
  [ ] Fire extinguishers inspected monthly, serviced annually
  [ ] Eyewash/shower stations tested weekly (if chemicals)

Hazard Communication:
  [ ] Written HazCom program current
  [ ] Safety Data Sheets accessible for all chemicals
  [ ] Chemical containers properly labeled (GHS)
  [ ] Employees trained on chemicals they work with
  [ ] Chemical inventory list maintained

Walking/Working Surfaces:
  [ ] Floors clean, dry, and free of tripping hazards
  [ ] Guardrails on open-sided platforms > 4 feet
  [ ] Ladders inspected and rated for intended use
  [ ] Stairways have handrails

Electrical:
  [ ] No frayed cords or exposed wiring
  [ ] GFCI protection in wet locations
  [ ] Electrical panels accessible (36" clearance)
  [ ] Breakers labeled
  [ ] Junction boxes covered

Machine Safety:
  [ ] Point of operation guards in place
  [ ] Emergency stops accessible and functional
  [ ] LOTO procedures written for each machine
  [ ] LOTO annual audit completed
  [ ] Machine operators trained on specific equipment

PPE:
  [ ] Hazard assessment documented
  [ ] Appropriate PPE provided at no cost
  [ ] Employees trained on proper use
  [ ] Respirator fit testing current (annual)
  [ ] PPE condition inspected regularly

Recordkeeping:
  [ ] OSHA 300 log current
  [ ] 300A summary posted (Feb 1 – Apr 30)
  [ ] Training records maintained
  [ ] Incident investigations completed and documented
  [ ] Records retained for required period (5 years)
EOF
}

show_help() {
    cat << EOF
osha v$VERSION — OSHA Compliance Reference

Usage: script.sh <command>

Commands:
  intro       OSHA overview, employer duties, employee rights
  standards   Key OSHA standards by number (1910/1926)
  hazards     Top 10 violations and hazard categories
  hierarchy   Hierarchy of controls (elimination → PPE)
  inspection  Inspection process and employer rights
  records     Recordkeeping: 300/300A/301 forms
  training    Required training topics by industry
  checklist   Workplace safety assessment checklist
  help        Show this help
  version     Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    standards)  cmd_standards ;;
    hazards)    cmd_hazards ;;
    hierarchy)  cmd_hierarchy ;;
    inspection) cmd_inspection ;;
    records)    cmd_records ;;
    training)   cmd_training ;;
    checklist)  cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "osha v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
