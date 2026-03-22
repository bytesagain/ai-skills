#!/usr/bin/env bash
# rfid — RFID Technology Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== RFID — Radio-Frequency Identification ===

RFID uses electromagnetic fields to automatically identify and
track tags attached to objects. Unlike barcodes, RFID does NOT
require line-of-sight — tags can be read through packaging,
pallets, and even walls.

How It Works:
  1. Reader emits radio waves from antenna
  2. Tag antenna receives energy (passive) or responds (active)
  3. Tag's IC modulates signal with stored data
  4. Reader captures reflected/transmitted signal
  5. Reader decodes data and sends to host system

System Components:
  Tag (Transponder):
    - IC chip (stores data, 96-512 bits typical)
    - Antenna (receives energy, transmits data)
    - Substrate (material tag is built on)

  Reader (Interrogator):
    - Transmitter (sends RF energy)
    - Receiver (captures tag response)
    - Controller (manages protocol/timing)
    - Antenna(s) (one or more, various patterns)

  Middleware/Software:
    - Filters and deduplicates reads
    - Maps tag IDs to business data
    - Integrates with WMS, ERP, POS systems

Tag Types:
  Passive:      No battery — powered by reader RF energy
                Range: cm to ~15m (UHF)
                Cost: $0.03-0.50 per tag
                Life: 20+ years (no battery to die)

  Semi-Passive (BAP — Battery-Assisted Passive):
                Battery powers IC, reader provides communication energy
                Range: up to 30m
                Cost: $1-10
                Life: 3-7 years (battery)

  Active:       Battery powers both IC and transmitter
                Range: up to 100-300m
                Cost: $10-100+
                Life: 3-10 years (battery)
                Use: vehicle tracking, large assets, RTLS

RFID vs Barcode:
  Feature        RFID           Barcode
  Line of sight  Not required   Required
  Read speed     100s/second    1 at a time
  Read range     cm to 100m+    cm to 1m
  Data capacity  96-8K bits     ~100 characters
  Read/Write     Both           Read only
  Durability     High           Low (damage=unreadable)
  Cost per tag   $0.03-100      $0.001
  Simultaneous   Yes            No
EOF
}

cmd_frequencies() {
    cat << 'EOF'
=== RFID Frequency Bands ===

Low Frequency (LF): 125-134 kHz
  Range:       1-10 cm (contact to near-field)
  Data rate:   Low (~1 kbps)
  Penetration: Excellent through water, tissue, metal
  Standards:   ISO 11784/85 (animal ID)
  Use cases:   Animal tracking (ear tags, implants)
               Access control (proximity cards)
               Car immobilizer keys
               Laundry tracking (survives wash)
  Pros:        Works near metal/water, mature technology
  Cons:        Very short range, slow read, one tag at a time

High Frequency (HF): 13.56 MHz
  Range:       1 cm - 1 m (typically 10-30 cm)
  Data rate:   Medium (~25 kbps)
  Standards:   ISO 14443 (NFC), ISO 15693 (vicinity)
  NFC:         Near Field Communication (subset of HF RFID)
               Phone-readable, secure payment (Apple Pay, etc.)
  Use cases:   Payment cards (contactless/NFC)
               Library books (ISO 15693)
               Pharmaceutical anti-counterfeiting
               Smart posters / NFC tags
               Access badges (MIFARE, DESFire)
  Pros:        Global frequency, NFC ecosystem, anti-collision
  Cons:        Limited range, moderate cost

Ultra-High Frequency (UHF): 860-960 MHz
  Range:       1-15 m (passive), up to 30m (BAP)
  Data rate:   High (~640 kbps)
  Regional:    EU: 865-868 MHz  |  US: 902-928 MHz  |  China: 920-925 MHz
  Standards:   EPC Gen2 (ISO 18000-63)
  Use cases:   Supply chain / logistics (pallets, cases, items)
               Retail inventory (item-level tagging)
               Warehouse management
               Toll collection
               Race timing
  Pros:        Long range, fast multi-tag read, low cost tags
  Cons:        Degraded by water/metal, regional frequency differences

Microwave: 2.45 GHz / 5.8 GHz
  Range:       1-10 m (passive), 100m+ (active)
  Data rate:   Very high
  Use cases:   Vehicle toll collection (active)
               Real-time location systems (RTLS)
               Industrial automation
  Pros:        Very small antennas, high data rate
  Cons:        Expensive, poor penetration, regulatory limits

Frequency Selection Guide:
  Near metal/water/body?  → LF or HF
  Need NFC/phone?         → HF (13.56 MHz)
  Supply chain/retail?    → UHF (860-960 MHz)
  Long range tracking?    → UHF (passive) or Active (2.45 GHz)
  Animal identification?  → LF (125-134 kHz)
EOF
}

cmd_tags() {
    cat << 'EOF'
=== RFID Tag Types & Form Factors ===

Passive UHF Tags (Most Common):

  Inlay (Wet/Dry):
    Thin, flexible — IC + antenna on substrate
    Wet inlay: has adhesive backing
    Dry inlay: no adhesive (for converting into labels)
    Size: typically 25×25mm to 100×15mm
    Cost: $0.03-0.15 in volume
    Use: item-level tagging, labels, tickets

  Label/Smart Label:
    Inlay laminated into paper/plastic label
    Printable surface for barcode + human-readable text
    Dual technology: RFID + barcode on same label
    Cost: $0.05-0.30

  Hard Tag:
    Rugged enclosure (ABS plastic, epoxy, ceramic)
    Survives extreme environments (heat, impact, chemicals)
    Mount: screw, rivet, adhesive, cable tie
    Cost: $1-20
    Use: asset tracking, IT equipment, tools, containers

  On-Metal Tag:
    Special design with spacer/ferrite layer
    Works directly on metal surfaces (standard tags don't!)
    Types: ceramic patch, foam spacer, flex-metal mount
    Cost: $1-15
    Use: metal containers, vehicles, equipment

  Laundry Tag:
    Encapsulated in silicone or fabric pouch
    Survives 200+ wash/dry cycles at 85°C
    Autoclave-resistant versions for healthcare
    Cost: $0.50-2.00

NFC Tags (HF):
  NTAG213:  144 bytes user memory, most common for NFC
  NTAG215:  504 bytes (Nintendo Amiibo format)
  NTAG216:  888 bytes
  MIFARE Classic: 1K/4K memory, access control
  MIFARE DESFire: AES encryption, transit/payment
  Cost: $0.10-1.00

Tag Selection Criteria:
  1. What surface? (metal, plastic, cardboard, skin)
  2. Read range needed? (contact to 15m)
  3. Environment? (temperature, moisture, chemicals)
  4. Memory size? (96 bits EPC standard, up to 8KB)
  5. Read/write needs? (read-only vs rewritable)
  6. Volume and budget? (per-tag cost at quantity)
  7. Form factor? (label, hard tag, embedded)
  8. Standards? (EPC Gen2, NFC, ISO)

Tag Memory Structure (EPC Gen2):
  Reserved:   Kill password (32 bits) + Access password (32 bits)
  EPC:        Electronic Product Code (96-496 bits)
  TID:        Tag Identifier (unique IC serial, read-only)
  User:       Optional user data (varies: 0-512+ bits)
EOF
}

cmd_standards() {
    cat << 'EOF'
=== RFID Standards ===

EPC Gen2 (EPCglobal UHF Class 1 Gen 2):
  Full name: ISO 18000-63
  The dominant standard for supply chain RFID
  Key features:
    - Anti-collision: can read 1,000+ tags/second
    - Dense reader mode: multiple readers without interference
    - 96-bit EPC number (expandable to 496)
    - Session management (4 sessions for inventory flags)
    - Kill command (permanently disable tag)
    - Lock command (protect memory from overwrite)

EPC Number Structure:
  Header | Filter | Partition | Company Prefix | Item Ref | Serial
  Example SGTIN-96 (serialized product):
    Header:        8 bits
    Filter:        3 bits (case, pallet, unit)
    Partition:     3 bits (defines prefix/item split)
    Company Prefix: 20-40 bits (GS1 assigned)
    Item Ref:      4-24 bits (product identifier)
    Serial:        38 bits (unique serial number)

  SGTIN-96 URI example:
    urn:epc:tag:sgtin-96:3.0614141.812345.6789

EPC Tag Data Standard (TDS):
  SGTIN:   Serialized Global Trade Item Number (products)
  SSCC:    Serial Shipping Container Code (pallets/cases)
  GRAI:    Global Returnable Asset Identifier (reusable assets)
  GIAI:    Global Individual Asset Identifier (fixed assets)
  SGLN:    Serialized Global Location Number (locations)
  GSRN:    Global Service Relation Number (relationships)

ISO Standards:
  ISO 14443:    NFC Type A/B (contactless smart cards, payment)
  ISO 15693:    Vicinity cards (library, access — longer range HF)
  ISO 18000-2:  LF RFID (below 135 kHz)
  ISO 18000-3:  HF RFID (13.56 MHz)
  ISO 18000-63: UHF RFID (860-960 MHz) = EPC Gen2
  ISO 11784/85: Animal identification (LF)
  ISO 17363-67: Supply chain RFID data encoding

GS1 & EPCIS:
  GS1: global standards body for barcodes and RFID
  EPCIS: EPC Information Services
    Captures WHAT, WHERE, WHEN, WHY of RFID events
    Event types: Object, Aggregation, Transaction, Transformation
    Data sharing across supply chain partners
    XML or JSON-LD format
    Enables track-and-trace from factory to consumer
EOF
}

cmd_readers() {
    cat << 'EOF'
=== RFID Readers & Antennas ===

Reader Types:

  Fixed Reader:
    Permanently mounted (dock door, conveyor, portal)
    1-8 antenna ports
    High power: 30-33 dBm (1-2 watts EIRP)
    Connectivity: Ethernet, WiFi, serial
    Examples: Zebra FX9600, Impinj R700, Alien ALR-F800
    Cost: $1,000-5,000

  Handheld Reader:
    Portable gun-style or sled (phone attachment)
    Built-in antenna, battery operated
    Power: 20-30 dBm
    Range: 1-10m depending on tag
    Examples: Zebra MC3330R, Chainway C72
    Cost: $1,000-3,000

  Integrated Reader:
    Reader + antenna in single enclosure
    Simple installation (one device)
    Lower power but sufficient for many applications
    Cost: $500-2,000

  USB Desktop Reader:
    Connect to PC for encoding/reading tags
    Short range (10-30 cm)
    Used for: tag programming, registration, POS
    Cost: $200-800

Antenna Types:
  Circular Polarized:
    Reads tags in any orientation
    ~3 dB loss vs linear (shorter range)
    Best for: portals, conveyors (random tag orientation)

  Linear Polarized:
    Higher gain, longer range
    Tag must be oriented within ~45° of antenna polarization
    Best for: controlled tag orientation (labels on boxes)

  Near-Field:
    Very short range (<10 cm)
    Precise read zone — reads only what you intend
    Best for: point-of-sale, item encoding, serialization

Antenna Specifications:
  Gain:         6-12 dBi (higher = more focused, longer range)
  Beamwidth:    30-70° (narrower = more directional)
  VSWR:         <1.5:1 (impedance matching quality)
  Polarization: Circular or Linear
  Size:         Larger antenna = higher gain = longer range

Read Zone Design:
  Portal (dock door):
    2-4 antennas surrounding door opening
    Circular polarized for random pallet/case orientation
    Stagger antennas to minimize blind spots
    Test with actual tagged goods before deployment

  Conveyor:
    Antenna above, below, or both sides
    Trigger: photoeye or motion sensor starts read cycle
    Speed: 200-600 ft/min typical conveyor speed
    Ensure tag exposure time > 100ms

  Shelf/Cabinet:
    Near-field antennas on each shelf
    Low power to avoid reading adjacent shelves
    Multiplexer to cycle through antenna positions

Power Regulations:
  US (FCC):     4W EIRP max (36 dBm)
  EU (ETSI):    2W ERP max (33 dBm), listen-before-talk
  China (MIIT): 2W EIRP (33 dBm)
  Indoor vs outdoor regulations may differ
EOF
}

cmd_applications() {
    cat << 'EOF'
=== RFID Applications ===

Retail Inventory:
  Item-level tagging: each garment/product gets UHF RFID tag
  Benefits:
    - Inventory accuracy: 65% → 98%+ (industry data)
    - Count entire store in 2 hours vs 2 days (barcode)
    - Real-time stock visibility (omnichannel fulfillment)
    - Automated replenishment triggers
    - Loss prevention (EAS + RFID combined)
  ROI: 2-8% sales increase from inventory accuracy
  Adoption: Walmart, Zara, Uniqlo, Nike, Decathlon mandates

Warehouse / Distribution:
  Pallet and case-level tracking through supply chain
  Receiving: read all pallets passing through dock door
  Put-away: verify correct location
  Picking: confirm correct items picked
  Shipping: automated manifest verification
  Benefits: 25-30% labor savings in receiving, near-zero ship errors

Asset Tracking:
  IT assets: laptops, servers, monitors (hard tags)
  Manufacturing: tools, fixtures, molds, dies
  Healthcare: wheelchairs, pumps, ventilators
  Benefits: locate assets in real-time, automate audits
  Typical: 15-30% reduction in asset loss/replacement

Healthcare:
  Patient wristbands: ID verification for medication/procedures
  Specimen tracking: blood samples, pathology
  Equipment tracking: RTLS for infusion pumps, beds
  Pharmaceutical: anti-counterfeiting (serialized drug packages)
  Surgical instruments: autoclave-safe tags for sterilization tracking

Access Control:
  HF/NFC badges: office access, secure areas
  Vehicle tags: parking, toll collection (E-ZPass)
  Ski passes: UHF wristbands for lift access
  Events: NFC wristbands for concerts, festivals (+ payment)

Supply Chain Compliance:
  Walmart:     Item-level RFID mandate (apparel → expanding)
  US DoD:      MIL-STD-129 RFID marking on shipments
  FDA DSCSA:   Drug serialization (indirect RFID impact)
  EU MDR:      Medical device UDI (RFID-compatible)
EOF
}

cmd_challenges() {
    cat << 'EOF'
=== RFID Challenges ===

Metal Interference:
  Problem: metal reflects RF energy, detunes tag antenna
  Result:  tag on metal surface → no read or very short range
  Solution: on-metal tags (spacer + ferrite absorber)
  Alternative: mount tag on standoff away from metal surface
  Cost impact: on-metal tags 3-10× more expensive

Liquid Interference:
  Problem: water absorbs UHF energy (resonant frequency)
  Result:  tags on liquid containers → reduced range
  Solution: tag placement away from liquid surface
  Solution: use HF or LF (less affected by water)
  Test: read range with actual product (not empty containers)

Tag Collision:
  Problem: many tags responding simultaneously
  Solution: anti-collision protocols (EPC Gen2 uses Q algorithm)
  Capacity: 1,000+ tags/second with modern readers
  Dense environments may need session management tuning
  Dense reader mode prevents reader-to-reader interference

Read Reliability:
  Problem: not 100% read rate in real-world conditions
  Causes: orientation, distance, interference, tag quality
  Target: >99.5% read rate for automated processes
  Mitigation: multiple antennas, redundant read points
  Testing: test with ACTUAL products in ACTUAL environment
  Never trust lab results alone — always field test

Privacy Concerns:
  Problem: tags can be read without owner's knowledge
  Retail: tags should be killed or deactivated at point of sale
  EPC Gen2: kill command permanently disables tag
  Regulation: US states have RFID privacy laws (varies)
  EU GDPR: RFID data linked to individuals = personal data

Cost Analysis:
  Component          UHF (per unit)    Deployment
  Passive label      $0.05-0.15        Per item
  Hard tag           $2-15             Per asset
  Fixed reader       $1,500-5,000      Per read point
  Antenna            $200-500          Per antenna
  Handheld reader    $1,500-3,000      Per worker
  Software/middleware $10,000-100,000+ Per site
  Installation       $5,000-50,000     Per site

  Break-even analysis:
    Labor savings from automated counting/tracking
    + Inventory accuracy improvement (reduced lost sales)
    + Theft reduction
    − Tag cost × volume
    − Infrastructure cost
    Typical retail ROI: 12-18 months

Environmental Factors:
  Temperature:  Standard tags: -20°C to 65°C
                High-temp tags: up to 250°C (autoclave, industrial)
  Humidity:     Condensation can affect adhesive and antenna
  UV exposure:  Degrades label face stock (not typically the IC)
  Chemicals:    Solvent exposure can damage tag components
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== RFID Implementation Checklist ===

Requirements Definition:
  [ ] What objects will be tagged? (items, cases, pallets, assets)
  [ ] Required read range defined
  [ ] Read rate target established (reads/second)
  [ ] Environmental conditions documented (temp, moisture, metal)
  [ ] Integration requirements with existing systems (WMS, ERP, POS)
  [ ] ROI / business case approved

Tag Selection:
  [ ] Surface material evaluated (metal, plastic, cardboard, fabric)
  [ ] Form factor chosen (label, hard tag, laundry, on-metal)
  [ ] Memory requirements defined (EPC only vs user memory)
  [ ] Tag samples tested on actual products
  [ ] Read range verified with chosen reader/antenna
  [ ] Encoding scheme defined (SGTIN, SSCC, GRAI, custom)
  [ ] Tag placement location standardized

Infrastructure:
  [ ] Reader type selected (fixed, handheld, integrated)
  [ ] Antenna type and quantity determined per read point
  [ ] Read zones designed and diagrammed
  [ ] Network connectivity planned (Ethernet, WiFi)
  [ ] Power requirements calculated
  [ ] Cable routing planned (antenna cables, network)
  [ ] Reader software/firmware version confirmed

Software:
  [ ] Middleware selected for event filtering/routing
  [ ] Integration with WMS/ERP/POS designed
  [ ] EPCIS event capture planned (if supply chain)
  [ ] Data storage and retention policy defined
  [ ] Dashboard/reporting requirements specified

Testing:
  [ ] Lab testing completed with tag samples
  [ ] Pilot site identified for field test
  [ ] Read rate benchmark established (>99.5% target)
  [ ] Interference testing completed (metal, liquid, other RF)
  [ ] Stress testing (maximum tag density, conveyor speed)
  [ ] User acceptance testing with operations team

Deployment:
  [ ] Installation schedule and downtime planned
  [ ] Staff trained on new processes
  [ ] Standard operating procedures documented
  [ ] Support escalation path defined
  [ ] Tag ordering/supply chain established
  [ ] Rollback plan documented (if issues arise)
EOF
}

show_help() {
    cat << EOF
rfid v$VERSION — RFID Technology Reference

Usage: script.sh <command>

Commands:
  intro          RFID overview, components, passive vs active
  frequencies    LF, HF, UHF, microwave — ranges and use cases
  tags           Tag types, form factors, memory structure
  standards      EPC Gen2, ISO 18000, NFC, GS1/EPCIS
  readers        Fixed, handheld, antennas, power regulations
  applications   Retail, warehouse, healthcare, access control
  challenges     Metal/liquid issues, collision, privacy, cost
  checklist      RFID implementation planning checklist
  help           Show this help
  version        Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)        cmd_intro ;;
    frequencies)  cmd_frequencies ;;
    tags)         cmd_tags ;;
    standards)    cmd_standards ;;
    readers)      cmd_readers ;;
    applications) cmd_applications ;;
    challenges)   cmd_challenges ;;
    checklist)    cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "rfid v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
