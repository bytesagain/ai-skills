#!/usr/bin/env bash
# bonded — Bonded Warehouse & Customs Operations Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Bonded Warehousing ===

A bonded warehouse is a secured facility where imported goods can be
stored, manipulated, or manufactured without payment of customs duties
until the goods enter domestic commerce.

Core Concept:
  Goods enter a country → stored in bonded facility → duties DEFERRED
  Duties are only paid when goods are:
    a) Withdrawn for domestic consumption (duty paid)
    b) Re-exported to another country (NO duty paid)
    c) Destroyed under customs supervision (NO duty paid)

Why It Exists:
  - Encourages international trade and distribution
  - Improves importer cash flow (defer duties months or years)
  - Enables re-export without duty cost (transit/transshipment)
  - Allows inspection, sorting, labeling before duty commitment
  - Supports just-in-time inventory for imported goods

Regulatory Framework:
  US:      19 USC §1555-1557, CBP (Customs and Border Protection)
  EU:      Union Customs Code (UCC), Articles 240-242
  China:   General Administration of Customs, bonded zone regulations
  UK:      HMRC customs warehouse authorization (post-Brexit)

Key Terminology:
  Bond:           Financial guarantee (surety) to customs authority
  Entry:          Customs declaration when goods arrive
  Withdrawal:     Removing goods from bonded status
  Manipulation:   Allowed activities (sorting, repacking, labeling)
  Manufacturing:  Transforming goods under bond (stricter rules)
  Duty-free:      No duty owed (re-export, FTA, GSP)
  Duty-paid:      Duties settled, goods enter domestic commerce
  In-bond transit: Moving goods between bonded facilities
EOF
}

cmd_types() {
    cat << 'EOF'
=== Types of Bonded Facilities ===

US CBP Bonded Warehouse Classes:

  Class 1 — Government-owned premises
    Operated by port authority or government
    General storage of any imported merchandise

  Class 2 — Private bonded warehouse
    Owned by an importer for their own goods only
    Cannot store other companies' merchandise
    Common for large importers (retailers, manufacturers)

  Class 3 — Public bonded warehouse
    Available for use by any importer
    Operated by a third-party logistics provider
    Most common type for small/mid importers

  Class 4 — Bonded yard or pen
    Open-air storage for bulk goods
    Used for: lumber, vehicles, heavy machinery, containers

  Class 5 — Bonded bin
    Part of an importer's premises used under bond
    Remaining space is not bonded
    Cost-effective for limited bonded storage needs

  Class 6 — Manufacturing warehouse
    Goods can be manufactured or processed under bond
    Finished products re-exported OR duties paid on inputs
    Can use "inverted tariff" advantage

  Class 7 — Smelting/refining warehouse
    Specifically for metal ores and smelting operations
    Duty on inputs, not on waste/slag

Free Trade Zone (FTZ) — Alternative:
  Designated area within US territory, legally "outside" customs
  Broader activities than bonded warehouses
  Can defer, reduce, or eliminate duties
  Zone-to-zone transfers possible
  More flexible but more complex to set up

  FTZ vs Bonded Warehouse:
    FTZ:     Broader activities, zone status, CBP supervision
    Bonded:  Simpler setup, specific classes, lower operating cost
    Choose FTZ for manufacturing, bonded for storage/distribution
EOF
}

cmd_procedures() {
    cat << 'EOF'
=== Bonded Warehouse Procedures ===

1. Entry (Receiving Goods):
   a) Importer files customs entry (CBP Form 7501 in US)
   b) Entry type: "warehouse entry" (Type 21 in US)
   c) Goods examined by customs if selected
   d) Goods moved to bonded facility under customs control
   e) Warehouse records updated (lot number, location, quantity)
   f) Storage period begins (max 5 years in US, varies elsewhere)

2. Storage:
   Goods must be:
     - Stored in designated bonded area (physically separated)
     - Accessible for customs inspection at all times
     - Tracked with detailed inventory records
     - Insured (bonded warehouse operator's responsibility)
   Storage period:
     US: 5 years from date of importation
     EU: unlimited (as long as authorized)
     China: 1-2 years (extensions possible)

3. Manipulation (Allowed Activities):
   Without changing tariff classification:
     - Sorting, grading, inspecting
     - Repacking, relabeling, remarking
     - Cleaning, testing
     - Combining/splitting shipments
     - Photographing for marketing
   NOT allowed (without manufacturing license):
     - Assembling, transforming, producing

4. Withdrawal for Domestic Consumption:
   a) File withdrawal entry with customs
   b) Pay applicable duties, taxes, and fees
   c) Duties calculated at rate in effect at WITHDRAWAL date
      (not entry date — this can be advantageous or not)
   d) Goods released from bonded status
   e) Can withdraw partial quantities

5. Re-Export:
   a) File re-export entry
   b) NO duties owed (goods never entered domestic commerce)
   c) Common for transshipment, rejected goods, redistribution
   d) Must exit the country under customs supervision

6. In-Bond Transfer:
   Moving goods between bonded facilities
   Requires in-bond entry (CBP Form 7512 in US)
   Customs seals may be applied to container
   Goods remain under bond throughout transit
EOF
}

cmd_duties() {
    cat << 'EOF'
=== Duty Deferral Mechanisms ===

Duty Suspension:
  Duties are DEFERRED, not eliminated
  Timing: pay only when goods withdraw for consumption
  Benefit: cash flow improvement (sometimes years of deferral)
  Example:
    Import $10M goods at 10% duty = $1M duty
    Store in bonded warehouse → $0 duty now
    Withdraw $2M worth → pay $200K duty
    Re-export $8M worth → $0 duty ever
    Total savings: $800K in duties + interest on $1M deferred

Inverted Tariff Advantage:
  When duty on FINISHED product < duty on COMPONENTS
  In FTZ/Class 6: import components, manufacture, pay lower rate
  Example:
    Component duty: 15%
    Finished product duty: 5%
    Manufacture in bonded facility → pay 5% instead of 15%
    Savings: 10% on component value

Duty Drawback:
  Refund of duties paid on imported goods that are:
    - Re-exported (unused)
    - Used in manufacturing of exported products
    - Substituted with domestic goods of same kind
  Refund: up to 99% of original duties paid
  Filing deadline: 5 years from import date (US)
  Complex paperwork but significant savings

Temporary Import Bond (TIB):
  Goods imported temporarily (exhibitions, repairs, testing)
  Bond posted, no duty paid
  Goods must be re-exported within 1-3 years
  Common for: trade shows, film equipment, racing cars

Free Trade Agreement (FTA) Benefits:
  Goods qualifying under FTA may have reduced/zero duty
  Bonded warehouse allows time to determine FTA eligibility
  Certificate of origin required (proof of FTA qualification)
  Example: USMCA, EU-Japan EPA, RCEP

GSP (Generalized System of Preferences):
  Duty-free treatment for developing country exports
  Bonded storage allows batching shipments for GSP claims
  Programs: US GSP, EU GSP, Japan GSP
EOF
}

cmd_compliance() {
    cat << 'EOF'
=== Compliance Requirements ===

Record Keeping:
  Must maintain for 5 years (US) / 3-10 years (varies):
    - Import entries and declarations
    - Warehouse receipts for each lot
    - Withdrawal records
    - Inventory logs (receipts, movements, adjustments)
    - Destruction certificates
    - Transfer documentation
    - Insurance records

  Records must be available for customs audit at any time
  Electronic records accepted if meeting regulatory standards

Bond Requirements:
  Customs Bond: financial guarantee to customs authority
  Types:
    Single-entry bond: covers one shipment
    Continuous bond: covers all entries for 1 year
    Warehouse bond: specific to bonded warehouse operation
  Amount: typically 1-3x estimated annual duties
  Surety: insurance company backs the bond (for a premium)
  Premium: typically 0.5-2% of bond amount per year

Customs Audits:
  Random or risk-based inspections
  Full physical inventory counts (annual or more)
  Document review and reconciliation
  Compliance Assessment: CBP evaluates importer's controls
  C-TPAT membership can reduce audit frequency

  Common Audit Findings:
    - Inventory discrepancies (physical vs records)
    - Late filings or missing documentation
    - Unauthorized manipulation or manufacturing
    - Security deficiencies
    - Expired merchandise (past storage limit)

Penalties for Non-Compliance:
  Minor violations:  Warning, corrective action required
  Record keeping:    $10,000-$100,000+ per violation (US)
  Unauthorized withdrawal: Duty + penalty (up to 4x duty owed)
  Smuggling:         Criminal prosecution, facility closure
  Bond revocation:   Loss of bonded warehouse authorization

Security Requirements:
  Physical: fencing, locks, lighting, alarms, CCTV
  Access control: authorized personnel only
  Inventory control: perpetual inventory system
  Seal integrity: container seals tracked and verified
  C-TPAT / AEO: voluntary programs for trusted operators
EOF
}

cmd_benefits() {
    cat << 'EOF'
=== Business Benefits of Bonded Warehousing ===

Cash Flow Improvement:
  Defer duties until goods are sold or distributed
  Example: $50M annual imports at 8% duty
    Without bonded: pay $4M upfront
    With bonded: pay $4M gradually as goods sell
    Cash flow benefit: $2-3M at any given time
    Interest savings at 5%: $100-150K/year

Re-Export Savings:
  Goods re-exported = ZERO duties ever paid
  Critical for:
    - International distribution hubs
    - Transit/transshipment operations
    - Goods destined for multiple markets
    - Returns to origin country
  Example: import 1000 units, 300 re-exported
    Duty savings: 30% of total potential duty bill

Strategic Inventory Positioning:
  Store goods near destination market without duty commitment
  Respond to demand quickly (goods already in-country)
  Make sell-or-return decisions without duty risk
  Support e-commerce fulfillment from bonded locations

Quality Control Before Commitment:
  Inspect goods before paying duty
  Reject defective goods (re-export, no duty)
  Sort and grade before deciding which market to serve
  Relabel/repack for local market requirements

Market Timing:
  Store goods waiting for:
    - Better market prices (commodities)
    - Quota availability (textile/apparel quotas)
    - Favorable tariff changes
    - Seasonal demand peaks
    - Customer order confirmation

Tax Advantages:
  No duty = no duty in cost basis = lower inventory valuation
  Cash flow improves working capital ratios
  Some jurisdictions: no sales tax on bonded goods
  FTZ-specific: potential property tax exemptions

Supply Chain Resilience:
  Buffer stock without duty cost
  Ability to redirect goods to different markets
  Protection against supply disruptions
  Flexibility in uncertain trade policy environments
EOF
}

cmd_global() {
    cat << 'EOF'
=== Global Bonded Warehouse Systems ===

United States:
  Authority: CBP (Customs and Border Protection)
  Types: 7 classes + Foreign Trade Zones (FTZ)
  Storage limit: 5 years
  Bond: continuous surety bond required
  Key program: C-TPAT (trusted trader)
  FTZ count: 194 zones, 500+ subzones

European Union:
  Authority: National customs (under Union Customs Code)
  Types: Public (Type I, II, III) and Private
  Storage limit: unlimited (while authorized)
  Authorization: AEO (Authorized Economic Operator) helps
  Key feature: goods can move between EU bonded warehouses
  Customs warehousing, inward processing, end-use relief

China:
  Authority: General Administration of Customs (GACC)
  Types:
    - Bonded warehouses (storage)
    - Bonded logistics centers (Type A: single enterprise, Type B: multiple)
    - Comprehensive bonded zones (CBZ) — highest level
    - Free Trade Zones (Shanghai, Hainan, etc.)
  Storage limit: 1-2 years (extendable)
  Key feature: cross-border e-commerce bonded zones
  Growth: 150+ comprehensive bonded zones nationwide

United Kingdom (Post-Brexit):
  Authority: HMRC
  Types: customs warehouse, free zone
  Authorization: customs warehouse keeper license
  Freeports: East Midlands, Teesside, Thames, etc. (8 designated)
  Key change: separate from EU customs territory since 2021
  Northern Ireland: dual EU/UK regime (Windsor Framework)

Singapore:
  Authority: Singapore Customs
  Types: Licensed warehouse, Free Trade Zone
  FTZs: Changi, Jurong Port, Keppel Distripark
  Storage: generally unlimited in FTZ
  Strength: Asia-Pacific transshipment hub

Comparison:
  Country    Setup Cost    Flexibility    Storage Limit    Complexity
  US         Medium-High   High (FTZ)     5 years          High
  EU         Medium        High           Unlimited        High
  China      Medium        Growing        1-2 years        Medium
  UK         Medium        Medium         Varies           Medium
  Singapore  Low           High           Unlimited (FTZ)  Low
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== Bonded Warehouse Checklist ===

Setup Phase:
  [ ] Determine facility type (public, private, FTZ)
  [ ] Assess volume, value, and duty rates of imported goods
  [ ] Calculate ROI: duty deferral savings vs operating costs
  [ ] Apply for customs authorization / license
  [ ] Obtain surety bond (contact customs broker or surety)
  [ ] Set up physical security (fencing, CCTV, access control)
  [ ] Designate bonded area (separate from non-bonded storage)
  [ ] Implement inventory management system (customs-compliant)
  [ ] Train staff on bonded warehouse procedures
  [ ] Establish relationship with licensed customs broker

Operational Checklist:
  [ ] File warehouse entry for each incoming shipment
  [ ] Record lot numbers, quantities, values, tariff codes
  [ ] Maintain perpetual inventory (real-time or daily updates)
  [ ] Track storage time limits (set alerts before expiry)
  [ ] Process withdrawals with proper customs entries
  [ ] File re-export entries for outbound international shipments
  [ ] Conduct monthly inventory reconciliation
  [ ] Maintain 5-year record retention policy

Annual Compliance:
  [ ] Annual physical inventory count
  [ ] Reconcile physical vs system inventory
  [ ] Renew customs bonds and authorizations
  [ ] Review and update standard operating procedures
  [ ] Staff refresher training on compliance
  [ ] Internal audit of bonded operations
  [ ] Update insurance coverage
  [ ] Review duty rates for tariff changes

Red Flags (Immediate Action):
  ⚠ Inventory discrepancy > 1%
  ⚠ Missing or broken customs seals
  ⚠ Goods approaching storage time limit
  ⚠ Unauthorized personnel in bonded area
  ⚠ Missing documentation for any lot
  ⚠ Late filing of entries or withdrawals
  ⚠ Bond approaching expiration without renewal
EOF
}

show_help() {
    cat << EOF
bonded v$VERSION — Bonded Warehouse & Customs Operations Reference

Usage: script.sh <command>

Commands:
  intro        Bonded warehousing overview and regulatory framework
  types        Facility types — public, private, FTZ, manufacturing
  procedures   Entry, storage, withdrawal, re-export procedures
  duties       Duty deferral — suspension, drawback, inverted tariffs
  compliance   Record keeping, bonds, audits, penalties
  benefits     Business benefits — cash flow, re-export, strategy
  global       US, EU, China, UK, Singapore systems compared
  checklist    Setup and operations checklists
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)       cmd_intro ;;
    types)       cmd_types ;;
    procedures)  cmd_procedures ;;
    duties)      cmd_duties ;;
    compliance)  cmd_compliance ;;
    benefits)    cmd_benefits ;;
    global)      cmd_global ;;
    checklist)   cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "bonded v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
