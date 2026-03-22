#!/usr/bin/env bash
# manifest — Shipping Manifest Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Shipping Manifests ===

A shipping manifest is a comprehensive document listing all cargo
carried on a vessel, aircraft, or vehicle for a single voyage/trip.
It is the master inventory of an entire shipment.

Purpose:
  - Customs compliance (legal requirement in most countries)
  - Cargo tracking and accountability
  - Security screening (pre-arrival risk assessment)
  - Terminal operations (loading/unloading planning)
  - Insurance and liability documentation

Document Hierarchy:
  Manifest (vessel-level)
    └── Bill of Lading (shipment-level)
         └── Packing List (package-level)
              └── Commercial Invoice (transaction-level)

  Each level provides increasing detail:
    Manifest: "Container MSKU1234567 on vessel MSC ANNA"
    B/L:      "500 cartons of electronics, shipper → consignee"
    Packing:  "Carton 1: 20× Model A, Carton 2: 15× Model B"
    Invoice:  "Model A @ $50/unit, total $1,000, terms FOB Shanghai"

Legal Requirements:
  US:       24-hour advance manifest rule (ocean)
  EU:       Entry Summary Declaration (ENS) before arrival
  Canada:   Advance Commercial Information (ACI)
  China:    Pre-arrival manifest filing required
  Australia: Integrated Cargo System (ICS) reporting

Key Fields in a Manifest:
  - Vessel/flight/vehicle identification
  - Voyage/trip number
  - Port of loading / Port of discharge
  - Bill of lading numbers
  - Container numbers and seal numbers
  - Cargo description, weight, quantity
  - Shipper and consignee details
  - HS/HTS tariff codes
EOF
}

cmd_bol() {
    cat << 'EOF'
=== Bill of Lading (B/L) ===

The Bill of Lading is the single most important document in shipping.
It serves three functions simultaneously:

  1. Receipt for goods — carrier acknowledges receiving cargo
  2. Contract of carriage — terms of transport
  3. Document of title — holder can claim goods (if negotiable)

Types of Bill of Lading:

  Ocean B/L (OBL):
    Issued by ocean carrier (MSC, Maersk, CMA CGM)
    Master B/L for carrier-to-carrier or direct shipper

  House B/L (HBL):
    Issued by freight forwarder or NVOCC
    Forwarder consolidates multiple HBLs under one Master B/L
    Shipper receives HBL, carrier holds MBL

  Negotiable (Order) B/L:
    "To order" or "To order of shipper"
    Endorsed (signed on back) to transfer ownership
    Required for Letter of Credit transactions
    Original B/L must be presented to collect goods

  Non-Negotiable (Straight) B/L:
    Named consignee — only they can collect
    Commonly used between established partners
    Telex release or sea waybill often substituted

  Switch B/L:
    Second B/L issued to replace original
    Used in intermediary/trading company transactions
    Shows different shipper/consignee than original
    Carrier must surrender original before issuing switch

  Sea Waybill:
    Non-negotiable, not a document of title
    Faster release — no original documents needed
    Consignee identified by name
    Suitable when no LC and trust exists

Required B/L Fields:
  Shipper (name, address)          Consignee (name, address)
  Notify party                     Vessel name & voyage
  Port of loading                  Port of discharge
  Place of receipt                 Place of delivery
  Container number & seal          Package count & type
  Gross weight (kg)                Measurement (CBM)
  Goods description                Freight terms (prepaid/collect)
  Number of original B/Ls          Date of issue
EOF
}

cmd_packing() {
    cat << 'EOF'
=== Packing Lists ===

A packing list details the contents of each package in a shipment.
It bridges the gap between the B/L (shipment level) and the
commercial invoice (transaction level).

Key Information:
  Header:
    - Shipper and consignee (match B/L exactly)
    - Invoice number (cross-reference)
    - B/L number (cross-reference)
    - Date and shipment reference
    - Country of origin

  Per Package:
    - Package number (1 of 50, 2 of 50, etc.)
    - Package type (carton, pallet, crate, drum)
    - Dimensions (L × W × H in cm or inches)
    - Gross weight (package + contents)
    - Net weight (contents only)
    - Tare weight (package only)
    - Contents description with quantity
    - Part/SKU numbers

  Totals:
    - Total packages
    - Total gross weight
    - Total net weight
    - Total cubic measurement (CBM)

Golden Rule: CONSISTENCY
  The following must match across ALL documents:
    Packing list ↔ Commercial invoice ↔ B/L ↔ Customs declaration
  Mismatches trigger customs examinations, delays, penalties

  Common discrepancy triggers:
    - Weight difference >5% between documents
    - Package count mismatch
    - Goods description inconsistency
    - Missing HS codes or wrong codes

Best Practices:
  - List contents by package, not just totals
  - Include package marks/numbers visible on outer packaging
  - Specify both gross and net weights
  - Use same units of measurement consistently
  - Include container/seal numbers if FCL
  - State "SAID TO CONTAIN" to limit carrier liability
  - Language: English (international standard)
EOF
}

cmd_air() {
    cat << 'EOF'
=== Air Cargo Manifests ===

Air Waybill (AWB):
  The air equivalent of a Bill of Lading
  ALWAYS non-negotiable (unlike ocean B/L)
  Governed by: Warsaw Convention / Montreal Convention

  Types:
    MAWB (Master Air Waybill):
      Issued by airline to freight forwarder
      Format: [airline prefix]-[8 digit number]
      Example: 176-12345678 (176 = Emirates)
      Covers entire consolidated shipment

    HAWB (House Air Waybill):
      Issued by forwarder to individual shipper
      Multiple HAWBs under one MAWB
      Forwarder is shipper on MAWB

  AWB Numbering:
    3-digit airline prefix + 8-digit serial
    Last digit = check digit (modulus 7)
    Example: 057-12345675 (057 = Air France)

Key Fields:
  Shipper/Consignee          Airport of departure/arrival
  Flight number/date         Number of pieces
  Gross weight (kg)          Chargeable weight
  Rate class                 Nature of goods
  Declared value             Handling instructions
  Harmonized code            Customs info

e-Freight (IATA):
  Goal: replace paper AWBs with electronic documents
  e-AWB: electronic air waybill (no paper original)
  Adoption: >70% of shipments on major trade lanes
  Benefits: faster processing, fewer errors, cost savings

Advance Filing Requirements:
  US:    ACAS — air cargo advance screening (data at departure)
  EU:    ICS2 Pre-loading advance cargo information (PLACI)
  Filing: before cargo loaded on aircraft at origin
  Data:  shipper, consignee, weight, description, HS code

Dangerous Goods:
  Shipper's Declaration for Dangerous Goods (IATA DGR)
  Required for all dangerous goods by air
  Must reference: UN number, proper shipping name, class, packing group
  Strict quantity limits for passenger vs cargo aircraft
EOF
}

cmd_ocean() {
    cat << 'EOF'
=== Ocean Manifests ===

Vessel Manifest:
  Master list of ALL cargo on a vessel for a specific voyage
  Filed by carrier with port authority and customs
  Contains every B/L issued for that voyage leg

  Key Data per Entry:
    B/L number              Container number(s)
    Seal number             Port of loading
    Port of discharge       Shipper name
    Consignee name          Cargo description
    Package count           Gross weight (MT)
    Measurement (CBM)       HS code
    Hazmat class (if any)   Reefer temp (if any)

Container Manifest:
  Cargo details per container:
    Container number:  MSKU 1234567
    Container type:    40' HC (40-foot high cube)
    Tare weight:       3,800 kg
    Max payload:       28,680 kg
    Seal:              CBP seal + carrier seal
    VGM:               Verified Gross Mass (SOLAS requirement)

  VGM (Verified Gross Mass) — mandatory since July 2016:
    Method 1: Weigh packed container on certified scale
    Method 2: Weigh all cargo + dunnage + tare = VGM
    Must be submitted to carrier before vessel loading
    Non-compliant containers: WILL NOT be loaded

ISF 10+2 (Importer Security Filing) — US Requirement:
  Filed 24 hours BEFORE loading at foreign port
  10 data elements from importer:
    1. Seller                    6. Country of origin
    2. Buyer                     7. HS tariff number
    3. Importer of record        8. Container stuffing location
    4. Consignee                 9. Consolidator
    5. Manufacturer             10. Ship-to party

  2 data elements from carrier:
    1. Vessel stow plan
    2. Container status messages

  Penalty for late/inaccurate ISF: $5,000 per violation
  Liquidated damages can reach $10,000 per violation

Stowage Plan (Bay Plan):
  Visual layout of container positions on vessel
  Organized by bay (fore-aft), row (port-starboard), tier (low-high)
  Position format: BBRRTT (bay-row-tier)
  Example: 140282 = Bay 14, Row 02, Tier 82
  Used for: load planning, stability, hazmat segregation
EOF
}

cmd_electronic() {
    cat << 'EOF'
=== Electronic Manifest Systems ===

US — AMS (Automated Manifest System):
  Administered by CBP (Customs & Border Protection)
  Required for: all ocean, air, rail cargo entering US
  Filing deadline: 24 hours before loading (ocean)
  Data: B/L details, container, shipper, consignee, description
  System: transmitted via ABI (Automated Broker Interface)

Canada — ACI (Advance Commercial Information):
  Administered by CBSA
  Required: 24h before loading (ocean), before departure (air)
  Components: cargo data + conveyance data + secondary exam
  System: transmitted via EDI to CBSA

EU — ENS (Entry Summary Declaration):
  Administered by EU member state customs
  Part of Import Control System (ICS/ICS2)
  Filing: 24h before loading at foreign port (ocean)
  Data: similar to US AMS — shipper, consignee, goods, HS code
  Recent: ICS2 adds pre-loading data for air cargo

EDI Formats for Manifests:
  UN/EDIFACT:
    CUSCAR — Customs Cargo Report (manifest)
    IFTMIN — Instruction for Transport
    BAPLIE — Bayplan/Stowage plan
    COPARN — Container pre-announcement
    CODECO — Container gate-in/gate-out

  ANSI X12:
    309 — US Customs Manifest
    310 — Freight Receipt and Invoice
    315 — Status Details (container tracking)
    322 — Terminal Operations Activity

  XML/JSON:
    IATA Cargo-XML (air cargo)
    WCO Data Model (customs worldwide)
    REST APIs increasingly used alongside EDI

Filing Deadlines Summary:
  Document           US        EU        Canada
  Ocean manifest     24h BL    24h BL    24h BL
  Air manifest       4h BD     4h BD     4h BD
  Rail manifest      2h BA     —         —
  Truck manifest     1h BA     1h BA     1h BA
  ISF/ENS            24h BL    24h BL    —

  BL = before loading, BD = before departure, BA = before arrival
EOF
}

cmd_discrepancies() {
    cat << 'EOF'
=== Manifest Discrepancies ===

Common Discrepancy Types:

  Short (Short-Landed):
    Manifest says 50 cartons, only 45 received
    Carrier must file a short-landing report
    Consignee files claim against carrier
    Customs: duty paid only on received quantity

  Over (Over-Landed):
    More cargo received than manifested
    Customs treats as unauthorized import → hold
    Carrier must amend manifest within 24-48 hours
    Potential penalty if not corrected promptly

  Misdeclared:
    Description on manifest doesn't match actual goods
    Most serious — implies evasion or smuggling
    Customs examination triggered
    Penalty: seizure + fines up to 4× duty value

  Wrong Weight:
    Declared weight vs actual weight discrepancy
    Tolerance: typically ±5% before investigation
    VGM violations (ocean): container not loaded
    Air cargo: weight directly affects charges

Amendment Procedures:

  US CBP:
    File Post-Summary Adjustment (PSA)
    Or Voluntary Self-Disclosure for errors
    Correction within 60 days: reduced penalty
    Use ACE Portal for electronic amendments

  Ocean Carrier:
    Contact carrier documentation department
    Request B/L amendment (amendment fee: $50-200)
    Before vessel departure: usually free correction
    After departure: amendment fee + potential customs issue

  Air Carrier:
    Contact airline cargo operations
    File corrective AWB or amendment message
    IATA Cargo-IMP format for corrections

Prevention:
  1. Verify packing list against physical count BEFORE stuffing
  2. Cross-check B/L data with commercial invoice
  3. Use standardized HS codes (6-digit minimum)
  4. Photo-document container loading sequence
  5. Record seal numbers at point of stuffing
  6. Verify VGM before submission
  7. Use EDI validation to catch format errors
  8. Implement pre-shipment audit workflow
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== Manifest Preparation Checklist ===

Document Consistency:
  [ ] Shipper name/address identical across all documents
  [ ] Consignee name/address identical across all documents
  [ ] Package count matches: packing list = invoice = B/L
  [ ] Total gross weight matches (±1% tolerance)
  [ ] Goods description consistent (same terminology)
  [ ] HS/HTS codes present and correct (6+ digits)
  [ ] Country of origin stated correctly
  [ ] Incoterms consistent (FOB, CIF, etc.)

Bill of Lading:
  [ ] Correct B/L type (negotiable vs non-negotiable)
  [ ] Container number(s) and seal number(s) listed
  [ ] Vessel name and voyage number correct
  [ ] Port of loading and discharge correct
  [ ] Freight terms stated (prepaid or collect)
  [ ] Number of originals stated (typically 3/3)
  [ ] "Shipped on board" notation with date
  [ ] Clean B/L (no claused notations)

Electronic Filing:
  [ ] ISF 10+2 filed 24h before loading (US-bound)
  [ ] AMS/ACI/ENS data transmitted
  [ ] Confirmed acceptance (no reject messages)
  [ ] HS codes validated against tariff schedule
  [ ] Dangerous goods declarations filed (if applicable)
  [ ] AES/EEI filed for exports (if required)

Container/Cargo:
  [ ] VGM calculated and submitted (ocean FCL)
  [ ] Container condition report completed
  [ ] Seal numbers recorded and communicated
  [ ] Reefer settings confirmed (if temperature-controlled)
  [ ] Hazmat placard/labels applied (if applicable)
  [ ] Photos of loading taken for evidence

Compliance:
  [ ] Denied party screening completed (shipper + consignee)
  [ ] Export license obtained (if controlled goods)
  [ ] Certificate of origin prepared (if preferential tariff)
  [ ] Insurance certificate in hand
  [ ] Letter of Credit terms satisfied (if LC transaction)
  [ ] Fumigation/phytosanitary certificate (if required)
EOF
}

show_help() {
    cat << EOF
manifest v$VERSION — Shipping Manifest Reference

Usage: script.sh <command>

Commands:
  intro          Manifest overview, hierarchy, legal requirements
  bol            Bill of Lading types, fields, negotiability
  packing        Packing list format, consistency rules
  air            Air cargo AWB, MAWB/HAWB, e-freight
  ocean          Ocean manifests, VGM, ISF 10+2, stowage plans
  electronic     AMS, ACI, ENS, EDI formats, filing deadlines
  discrepancies  Shorts, overs, misdeclarations, amendments
  checklist      Manifest preparation and compliance checklist
  help           Show this help
  version        Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)          cmd_intro ;;
    bol)            cmd_bol ;;
    packing)        cmd_packing ;;
    air)            cmd_air ;;
    ocean)          cmd_ocean ;;
    electronic)     cmd_electronic ;;
    discrepancies)  cmd_discrepancies ;;
    checklist)      cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "manifest v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
