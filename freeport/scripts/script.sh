#!/usr/bin/env bash
# freeport — Free-Trade Zone Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Free Ports & Foreign-Trade Zones ===

A free port (or foreign-trade zone) is a designated area within a
country where goods can be imported, stored, handled, manufactured,
or re-exported under relaxed customs regulations — often with
deferred, reduced, or eliminated duties and taxes.

History:
  Ancient:   Free ports in Phoenician cities (Tyre, Sidon)
  1547       Livorno declared a free port by Cosimo I de' Medici
  1819       Singapore established as a free port by Raffles
  1934       US Foreign-Trade Zones Act (19 USC 81a-81u)
  1980s      China establishes Special Economic Zones (Shenzhen)
  2000s      Dubai JAFZA becomes world's largest FTZ

Legal Framework (United States):
  Foreign-Trade Zones Act of 1934
  Administered by Foreign-Trade Zones Board (Dept of Commerce)
  Regulated by US Customs & Border Protection (CBP)
  Currently ~195 FTZ projects with ~400+ subzones in the US

Core Principle:
  Goods in an FTZ are legally considered OUTSIDE US customs territory
  for duty purposes, while physically being INSIDE the country.

  This means:
  - No duty until goods enter US commerce
  - No duty at all if goods are re-exported
  - Choice of duty rate (zone vs finished product rate)
  - No ad valorem taxes on goods in zone
EOF
}

cmd_types() {
    cat << 'EOF'
=== Types of Free-Trade Zones ===

Foreign-Trade Zone (FTZ) — United States:
  General Purpose Zone: Public, multi-user facility
  Subzone:  Single-user site (typically a manufacturer)
  Magnet Site: Pre-approved area for multiple operators
  Usage-Driven: Site framework approved for flexible activation

Special Economic Zone (SEZ):
  Broader concept — includes tax holidays, relaxed regulations
  Examples: China's SEZs (Shenzhen, Pudong), India's SEZs
  Often include FTZ benefits PLUS labor/tax incentives

Export Processing Zone (EPZ):
  Focused specifically on manufacturing for export
  Goods must be re-exported — no domestic consumption
  Common in developing countries to attract FDI

Bonded Warehouse:
  Customs-supervised storage for imported goods
  Duty deferred until withdrawal for consumption
  More limited than FTZ — no manufacturing allowed
  Types: general order, private, manipulation, manufacturing

Free Port:
  Entire port or city with free-trade status
  Most permissive — minimal customs intervention
  Examples: Singapore, Hong Kong, Jebel Ali (Dubai)

Comparison:
  Feature          FTZ      SEZ      EPZ      Bonded WH
  Manufacturing    Yes      Yes      Yes      Limited
  Domestic sale    Yes*     Yes      No       Yes*
  Tax incentives   Duty     Full     Export   Duty
  Time limit       None     Varies   None     5 years
  Scope            Site     Region   Site     Building

  * Subject to duties upon entry into commerce
EOF
}

cmd_benefits() {
    cat << 'EOF'
=== FTZ Benefits ===

1. Duty Deferral:
   - No duty paid until goods leave zone for US consumption
   - Cash flow advantage: pay duty at sale, not at import
   - Typical savings: 2-4% of goods value in interest costs
   - Weekly entry: consolidate shipments into one customs entry

2. Duty Elimination:
   - Re-exported goods: 100% duty-free
   - Waste/scrap: no duty on material lost in manufacturing
   - Rejected goods: re-export without ever paying duty
   - Samples/exhibits: bring in, show, ship out — zero duty

3. Inverted Tariff Relief:
   - Component duty rate: 10%
   - Finished product rate: 3%
   - In FTZ: import components, manufacture, elect finished rate
   - Savings: 7% on every unit produced
   - This is the #1 reason manufacturers use FTZ subzones

4. Quota Avoidance:
   - Goods can be admitted to zone regardless of quotas
   - Hold in zone until quota opens, then enter commerce
   - Particularly valuable for textiles, steel, agriculture

5. Logistics Savings:
   - Merchandise Processing Fee (MPF) reduction
   - One weekly entry vs per-shipment entry
   - Zone-to-zone transfers without customs entry
   - Reduced Customs bonds required

6. Tax Benefits:
   - No state/local ad valorem taxes on inventory in zone
   - Tangible personal property tax exemption (varies by state)
   - Typical savings: 1-3% of inventory value annually
EOF
}

cmd_procedures() {
    cat << 'EOF'
=== FTZ Operational Procedures ===

Admission to Zone:
  1. File CBP Form 214 (Application for FTZ Admission)
  2. Specify zone status: Privileged Foreign (PF), Non-Privileged
     Foreign (NPF), or Zone-Restricted (ZR)
  3. CBP officer supervises admission
  4. Goods receive zone lot number for tracking

Status Designations:
  Privileged Foreign (PF):
    Duty rate locked at time of admission
    Use when duty rate is favorable now but may increase
  Non-Privileged Foreign (NPF):
    Duty rate determined at time of entry into US commerce
    Use when manufactured product has lower rate than components
  Zone-Restricted (ZR):
    Must be exported — cannot enter US commerce
    Use for goods with quota restrictions

Manufacturing in Zone:
  - Assemble, process, manufacture freely
  - Foreign + domestic materials can be combined
  - Elect privileged or non-privileged status per input
  - Scrap/waste destroyed in zone = no duty
  - Track inputs via inventory management system

Weekly Entry:
  - Instead of filing per shipment, file once per week
  - CBP Form 3461 (weekly) + CBP Form 7501 (entry summary)
  - Dramatically reduces brokerage costs
  - Estimated savings: $200-500 per eliminated entry

Zone-to-Zone Transfer:
  - Transfer goods between FTZ sites without customs entry
  - Maintain zone status throughout transfer
  - File CBP Form 214 at receiving zone
  - No duty event occurs

Destruction / Waste:
  - Goods may be destroyed in zone under CBP supervision
  - No duty on destroyed/scrapped goods
  - File destruction report with CBP
  - Environmental permits may be required
EOF
}

cmd_customs() {
    cat << 'EOF'
=== FTZ Customs Compliance ===

Record-Keeping Requirements:
  - Zone inventory control and recordkeeping (ICR) system
  - Must account for all goods admitted, manufactured, transferred
  - Retention period: 5 years from date of zone activity
  - Electronic records acceptable (must be retrievable within 48h)

Annual Reconciliation:
  - Physical inventory count at least annually
  - Reconcile physical count with zone records
  - Report discrepancies to CBP
  - Overages: treat as unauthorized admission
  - Shortages: may result in duty liability

CBP Audits:
  Types:
    - Focused Assessment (FA): risk-based, targets specific areas
    - Compliance Review: broader look at zone operations
    - Surprise spot-check: unannounced verification

  Common Audit Findings:
    - Inaccurate zone lot tracking
    - Failure to file weekly entries timely
    - Unauthorized manufacturing activity
    - Missing admission documentation
    - Incorrect status designations

Zone Schedule (Manufacturing):
  - Required for manufacturing/processing in zone
  - Filed with FTZ Board (not CBP)
  - Lists materials, processes, finished products
  - Must be approved BEFORE manufacturing begins
  - Amendment required for new products/processes

Penalties:
  - Unauthorized removal from zone: goods + penalty (up to 4x value)
  - False zone records: criminal prosecution possible
  - Failure to maintain ICR: zone activation can be revoked
  - Late weekly entries: monetary penalty per late entry
EOF
}

cmd_global() {
    cat << 'EOF'
=== Major Global Free Ports ===

Singapore:
  Status: Entire country is virtually a free port
  Duties: Zero tariff on 99.9% of goods (except alcohol, tobacco, vehicles)
  Key zones: Jurong Port, Changi Airport Free Trade Zone
  Advantage: Strategic location, world-class port infrastructure
  Throughput: ~37 million TEUs/year

Hong Kong:
  Status: Free port since 1841
  Duties: Zero tariff on all goods (excise on alcohol, tobacco, fuel)
  Key feature: No customs tariff, no VAT/GST
  Advantage: Gateway to China, financial hub
  Throughput: ~18 million TEUs/year

Dubai — JAFZA (Jebel Ali Free Zone):
  Established: 1985
  Companies: 8,000+ from 100+ countries
  Benefits: 0% corporate tax, 0% personal income tax, 100% repatriation
  Key feature: Adjacent to Jebel Ali Port (world's largest man-made harbor)
  Throughput: ~15 million TEUs/year

Shannon, Ireland:
  Established: 1959 (world's first modern free-trade zone)
  Originally for transatlantic aviation refueling
  Today: 170+ companies, aviation, tech, manufacturing
  Model copied worldwide

Hamburg, Germany (Freihafen):
  Historical free port since 1888
  Special customs area within EU
  Changed: 2013 — most of free port status removed
  Remaining: small bonded warehouse areas

Shenzhen, China (SEZ):
  Established: 1980 as China's first SEZ
  Transformed from fishing village to tech megacity
  GDP: >$400 billion (larger than many countries)
  Model for China's economic liberalization
EOF
}

cmd_costs() {
    cat << 'EOF'
=== FTZ Cost-Benefit Analysis ===

Activation Costs:
  FTZ Board application fee:        $3,200 (general purpose)
  Subzone application fee:           $6,500
  Legal/consulting fees:             $20,000-100,000
  CBP activation (officer time):     $5,000-15,000/year
  Zone operator bond:                $50,000-100,000
  IT system (inventory/tracking):    $15,000-200,000
  Total first-year:                  $100,000-400,000

Ongoing Annual Costs:
  Zone operator annual fee:          $5,000-20,000
  Customs brokerage (reduced):       $10,000-50,000
  CBP supervision charges:           $5,000-15,000
  System maintenance:                $5,000-20,000
  Compliance staff:                  $50,000-80,000 (partial FTE)
  Total annual:                      $75,000-185,000

Break-Even Calculation:
  Duty deferral savings = Avg inventory value × Duty rate × Interest rate
  Example: $50M inventory × 5% duty × 4% interest = $100,000/year

  Inverted tariff savings = Units × (Component rate - Product rate) × Value
  Example: 100,000 units × 7% difference × $50/unit = $350,000/year

  MPF savings = Eliminated entries × $25-500 per entry
  Example: 500 eliminated entries × $150 avg = $75,000/year

  Tax savings = Zone inventory × Ad valorem rate
  Example: $20M inventory × 1.5% = $300,000/year

Rules of Thumb:
  - FTZ viable if annual imports > $5 million
  - Strong case if duty rate > 3% and significant re-exports
  - Manufacturing subzone viable if inverted tariff > 2%
  - Warehouse FTZ viable if inventory turnover < 4x/year
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== FTZ Readiness Checklist ===

Site Evaluation:
  [ ] Proximity to port of entry (within 60 miles or 90 min)
  [ ] Adequate security (fencing, cameras, access control)
  [ ] Separated zone area from non-zone operations
  [ ] Loading dock access for CBP inspection
  [ ] Office space for CBP personnel (if required)

Application & Activation:
  [ ] Identify FTZ grantee (port authority or authorized org)
  [ ] Determine zone type: general purpose or subzone
  [ ] Prepare FTZ Board application with economic justification
  [ ] Engage licensed customs broker
  [ ] File CBP activation request
  [ ] Obtain zone operator bond

Inventory Control System:
  [ ] Lot tracking from admission to disposition
  [ ] Status designation recording (PF, NPF, ZR)
  [ ] Manufacturing BOM tracking (if applicable)
  [ ] Weekly entry generation capability
  [ ] Audit trail for all zone transactions
  [ ] Automated reconciliation reporting

Compliance Program:
  [ ] Written FTZ procedures manual
  [ ] Staff trained on zone regulations
  [ ] Internal audit schedule (quarterly recommended)
  [ ] CBP relationship established (port director)
  [ ] Recordkeeping retention policy (5-year minimum)
  [ ] Annual physical inventory planned

Operations:
  [ ] Admission procedures documented
  [ ] Zone-restricted area clearly marked
  [ ] CBP notification procedures in place
  [ ] Entry/exit logging for all goods
  [ ] Waste/scrap destruction procedures
  [ ] Emergency procedures (fire, flood, breach)
EOF
}

show_help() {
    cat << EOF
freeport v$VERSION — Free-Trade Zone Reference

Usage: script.sh <command>

Commands:
  intro        Free ports and FTZ overview, history, legal framework
  types        FTZ, SEZ, EPZ, bonded warehouse comparisons
  benefits     Duty deferral, inverted tariffs, tax savings
  procedures   Admission, manufacturing, weekly entry, transfers
  customs      Compliance, audits, recordkeeping, penalties
  global       Major global free ports and trade zones
  costs        Cost-benefit analysis and break-even calculations
  checklist    FTZ readiness and activation checklist
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    types)      cmd_types ;;
    benefits)   cmd_benefits ;;
    procedures) cmd_procedures ;;
    customs)    cmd_customs ;;
    global)     cmd_global ;;
    costs)      cmd_costs ;;
    checklist)  cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "freeport v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
