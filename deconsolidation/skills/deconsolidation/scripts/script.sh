#!/usr/bin/env bash
# deconsolidation — Cargo Breakdown & Receiving Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Deconsolidation Overview ===

Deconsolidation is the process of breaking down a consolidated shipment
into its individual components for sorting, inspection, and distribution
to final destinations.

Definition:
  The reverse of consolidation — unpacking a container or groupage
  shipment that was assembled from multiple shippers/consignees into
  individual shipments for last-mile delivery or storage.

Key Terminology:
  Stripping        Unloading a container (also "devanning" or "unstuffing")
  LCL              Less than Container Load — shared container
  FCL              Full Container Load — single consignee
  CFS              Container Freight Station — deconsolidation facility
  Cross-dock       Transfer from inbound to outbound without storage
  Break-bulk       Separating a large shipment into smaller lots
  Receiving        Formal acceptance of goods into warehouse
  Putaway          Moving received goods to storage locations
  Tally            Counting and verifying cargo against manifest

Why Deconsolidation Matters:
  - LCL shipments must be separated for different consignees
  - Import containers need customs clearance by consignee
  - Mixed-SKU pallets need sorting for storage efficiency
  - Retail distribution requires store-level sorting
  - E-commerce fulfillment needs item-level processing

Deconsolidation Points in Supply Chain:
  1. Port CFS — break LCL containers for local consignees
  2. Distribution Center — sort for regional stores
  3. Cross-dock Facility — direct transfer to outbound trucks
  4. Fulfillment Center — break bulk to individual orders
  5. Last-mile Hub — sort for delivery routes
EOF
}

cmd_process() {
    cat << 'EOF'
=== Deconsolidation Process ===

Step 1: Pre-Arrival Planning
  - Receive advance shipping notice (ASN) or manifest
  - Allocate dock doors and staging areas
  - Schedule labor based on container count and cargo type
  - Prepare receiving documents
  - Reserve putaway locations in WMS

Step 2: Container Arrival & Inspection
  - Verify container number against booking
  - Check seal number and integrity
  - Photograph container condition (damage documentation)
  - Note any signs of tampering, water damage, pest evidence
  - Record arrival timestamp

Step 3: Container Opening (Stripping)
  - Open doors carefully (cargo may have shifted)
  - Check for hazardous materials placards
  - Begin unloading from rear to front
  - Unload to staging area, not directly to storage
  - Use appropriate MHE (forklift, pallet jack, conveyor)

Step 4: Sorting & Segregation
  - Sort by consignee / purchase order / destination
  - Separate damaged goods for inspection
  - Segregate temperature-sensitive items
  - Group hazardous materials separately
  - Arrange by priority (expedited orders first)

Step 5: Verification & Counting
  - Tally piece count against manifest/packing list
  - Verify SKU/item numbers
  - Check weights (sample or full weighing)
  - Measure dimensions for storage planning
  - Note discrepancies (over/short/damaged - OS&D)

Step 6: Quality Inspection
  - Visual inspection for damage
  - Sample quality checks per inspection plan
  - Verify labeling and marking
  - Check regulatory compliance (certifications, labels)
  - Quarantine non-conforming goods

Step 7: Documentation & System Update
  - Complete receiving report
  - File OS&D (Over, Short & Damage) claims
  - Update WMS/ERP with received quantities
  - Generate putaway instructions
  - Notify consignees of receipt

Step 8: Dispatch or Putaway
  - Cross-dock items: move directly to outbound staging
  - Storage items: putaway to assigned locations
  - Returns/rejects: route to appropriate area
  - Empty container: schedule return/repositioning
EOF
}

cmd_lcl() {
    cat << 'EOF'
=== LCL Deconsolidation ===

LCL (Less than Container Load) shipments combine cargo from multiple
shippers into a single container. Deconsolidation separates them.

How LCL Works:
  Shipper A (500 kg) ─┐
  Shipper B (2 tons)  ─┼── Consolidator ── FCL Container ── CFS ── Decon
  Shipper C (800 kg) ─┘

  CFS = Container Freight Station (where deconsolidation happens)

LCL Deconsolidation Challenges:
  1. Multiple BOLs per container (each consignee = different paperwork)
  2. Mixed cargo types (dry goods + chemicals + fragile)
  3. Different customs classifications per consignee
  4. Varying delivery timelines and priorities
  5. Cargo damage attribution (who caused it?)
  6. Re-palletization may be needed

LCL Documentation:
  Master Bill of Lading (MBL)   Covers entire container
  House Bill of Lading (HBL)    One per consignee/shipment
  Manifest                      Lists all HBLs in container
  Packing List                  Details per HBL
  Commercial Invoice            Per consignee for customs
  Arrival Notice                Sent to each consignee

CFS Operations Flow:
  1. Container arrives at CFS
  2. Verify MBL and seal
  3. Strip container to staging area
  4. Sort cargo by HBL number
  5. Tally each HBL's cargo against packing list
  6. Notify freight forwarder of any discrepancies
  7. Hold cargo pending customs clearance per HBL
  8. Release to consignee upon clearance + payment
  9. Issue delivery order

CFS Charges (typical):
  Stripping fee          Per container ($150-$400)
  Handling fee           Per CBM or per piece
  Storage (free days)    3-5 free days, then per day charge
  Documentation fee      Per HBL
  Customs exam fee       If cargo selected for inspection
  Delivery fee           If CFS arranges last-mile

Best Practices:
  - Pre-alert CFS with manifest before arrival
  - Use unique marks/numbers per HBL for easy sorting
  - Stack heaviest cargo at bottom when consolidating
  - Photograph each HBL's cargo during stripping
  - Resolve discrepancies before consignee pickup
EOF
}

cmd_crossdock() {
    cat << 'EOF'
=== Cross-Docking Operations ===

Cross-docking is receiving inbound shipments and transferring them
directly to outbound without intermediate storage.

Types of Cross-Docking:

  1. Pre-Distributed (Allocation by Supplier)
     - Supplier pre-sorts by store/destination
     - Warehouse just moves from inbound to outbound dock
     - Fastest: minimal handling, no sorting needed
     - Requires supplier compliance with labeling

  2. Post-Distributed (Allocation at Warehouse)
     - Inbound cargo sorted/allocated at cross-dock facility
     - More flexible but slower
     - Common for retail distribution

  3. Consolidated Cross-Dock
     - Multiple inbound shipments combined for outbound
     - Wait for all components before dispatching
     - Used when full truckload is assembled from multiple sources

Cross-Dock Facility Design:
  ┌─────────────────────────────────────────────┐
  │   INBOUND DOCKS (receiving)                 │
  │   ▼  ▼  ▼  ▼  ▼  ▼  ▼  ▼                 │
  │                                             │
  │   ◄── SORTING / STAGING AREA ──►            │
  │       (conveyors, sortation systems)        │
  │                                             │
  │   ▼  ▼  ▼  ▼  ▼  ▼  ▼  ▼                 │
  │   OUTBOUND DOCKS (shipping)                 │
  └─────────────────────────────────────────────┘
  - I-shaped (docks on both sides) or L/T/H shapes
  - Narrow building maximizes dock-to-dock proximity

Timing Requirements:
  Ideal dwell time:    < 24 hours
  Target:              < 2 hours for pre-distributed
  Maximum:             48 hours (beyond this = warehousing)

Products Suited for Cross-Dock:
  ✓ Perishable goods (fresh produce, dairy)
  ✓ Pre-sorted retail shipments (already labeled by store)
  ✓ High-velocity items (fast-moving consumer goods)
  ✓ Just-in-time manufacturing components
  ✓ E-commerce orders consolidated from multiple vendors

Not Suited For:
  ✗ Items requiring quality inspection
  ✗ Products needing repackaging or kitting
  ✗ Slow-moving inventory (better to store)
  ✗ Items with unpredictable demand
EOF
}

cmd_equipment() {
    cat << 'EOF'
=== Deconsolidation Equipment ===

Material Handling Equipment (MHE):

  Forklifts:
    Counterbalance     Standard for palletized cargo
    Reach truck        Narrow aisle, indoor use
    Side-loader        Long/bulky items (pipes, lumber)
    Rough terrain      Outdoor yards, uneven surfaces

  Pallet Jacks:
    Manual             Low-cost, short distances
    Electric (walkie)  Higher throughput, less fatigue
    Rider pallet jack  Long distances within warehouse

  Conveyors:
    Telescoping        Extends into container for unloading
    Roller conveyor    Gravity or powered, flexible sections
    Belt conveyor      Loose items, parcels, irregulars
    Sortation systems  Automated routing to destinations

  Container Unloading:
    Container tilter   Tilts container to slide cargo out
    Vacuum lifter      For heavy cartons/cases
    Cargo slides       Gravity-based unloading ramps
    Clamp trucks       For handling drums, appliances

Dock Equipment:
  Dock levelers       Bridge gap between truck and dock floor
  Dock shelters       Weather protection at dock door
  Dock lights         Illuminate inside trailer/container
  Wheel chocks        Prevent trailer movement during loading
  Vehicle restraints  Mechanical locks for trailer security

Technology:
  WMS                 Warehouse Management System
  RF scanners         Barcode scanning for receiving
  RFID readers        Bulk scanning at dock doors
  Dimensioning sys.   Auto-measure length/width/height/weight
  Camera systems      Document container condition
  Voice picking       Hands-free directed receiving
  Yard management     Track trailer locations and status

Staging Infrastructure:
  Floor marking       Lanes for sorting by destination
  Staging racks       Temporary holding for sorted cargo
  Accumulation tables For loose/small item sorting
  Label printers      Print putaway/routing labels
  Scale (floor)       Verify weights during receiving
EOF
}

cmd_documentation() {
    cat << 'EOF'
=== Deconsolidation Documentation ===

Inbound Documents:

  Bill of Lading (BOL / B/L):
    - Contract of carriage between shipper and carrier
    - Master BOL for full container
    - House BOL for individual LCL shipments
    - Contains: shipper, consignee, cargo description, weight

  Commercial Invoice:
    - Seller's bill to buyer
    - Used for customs valuation
    - Contains: item description, quantity, unit price, total value

  Packing List:
    - Detailed contents of each package
    - Piece count, dimensions, weights
    - Used for verification during deconsolidation

  Manifest:
    - List of all cargo in a container/vehicle
    - Shows HBL numbers, consignees, destinations
    - Used by CFS to plan deconsolidation

Generated During Deconsolidation:

  Receiving Report:
    - Confirms what was actually received
    - Compares to BOL/packing list
    - Records condition, quantity, timestamps

  OS&D Report (Over, Short & Damage):
    - Over: received more than manifested
    - Short: received less than manifested
    - Damage: goods received in damaged condition
    - Must be filed within carrier's claim window

  Tally Sheet:
    - Physical count record during unloading
    - Piece-by-piece or pallet-by-pallet tally
    - Signed by tally clerk and carrier driver

  Exception Report:
    - Wrong items, wrong labels, contamination
    - Temperature deviations (cold chain)
    - Regulatory non-compliance (missing certificates)

  Delivery Order:
    - Authorization for consignee to pick up cargo
    - Issued by freight forwarder after clearance
    - Specifies pickup window and requirements

Discrepancy Handling:
  1. Document discrepancy with photos
  2. Note on receiving report and tally sheet
  3. Notify shipper/forwarder within 24 hours
  4. File OS&D claim with carrier
  5. Segregate affected goods
  6. Determine disposition (accept, return, claim)
EOF
}

cmd_metrics() {
    cat << 'EOF'
=== Deconsolidation Metrics ===

Speed Metrics:
  Container Dwell Time
    = Time from arrival to empty container departure
    Target: < 4 hours (standard cargo)
    Benchmark: < 2 hours (cross-dock)

  Unload Rate
    = Pieces (or pallets) per hour
    Palletized: 20-30 pallets/hour (with forklift)
    Floor-loaded: 200-500 cartons/hour (2-person team)
    Mixed: varies widely by cargo type

  Dock-to-Stock Time
    = Time from unloading to system receipt + putaway
    Target: < 24 hours
    Best-in-class: < 4 hours

  Door Utilization
    = Hours door is in use / Available hours
    Target: 70-85%
    Over 90% = insufficient capacity

Accuracy Metrics:
  Receiving Accuracy
    = Correctly received lines / Total lines
    Target: 99.5%+
    Measures: quantity, SKU, condition accuracy

  OS&D Rate
    = Shipments with discrepancies / Total shipments
    Target: < 2%
    Track by type: over, short, damage separately

  Putaway Accuracy
    = Items putaway to correct location / Total items
    Target: 99.9%

Productivity Metrics:
  Labor Productivity
    = Units processed / Labor hours
    Track per function: unloading, sorting, putaway

  Equipment Utilization
    = MHE active hours / Available hours
    Target: 75-85%
    Include: forklifts, pallet jacks, conveyors

  Throughput
    = Total units processed per shift/day
    Normalize by: container count, pallet count, or piece count

Cost Metrics:
  Cost per Container Stripped
    = Total decon labor + equipment / Containers processed
    Benchmark: $150-$500 per 40' container

  Cost per Unit Received
    = Total receiving cost / Units received
    Track trend over time for efficiency gains

  Damage Rate (cost)
    = Value of damaged goods / Total value received
    Target: < 0.1%
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== Deconsolidation Operations Checklist ===

Pre-Arrival:
  [ ] ASN or manifest received and reviewed
  [ ] Dock door assigned and scheduled
  [ ] Labor scheduled (unloaders, tally, forklift)
  [ ] Staging area cleared and marked
  [ ] Equipment ready (forklift charged, scanners paired)
  [ ] WMS prepared with expected receipts

Container Arrival:
  [ ] Container number verified against booking
  [ ] Seal number checked and recorded
  [ ] Container exterior condition photographed
  [ ] Temperature recorded (if reefer/cold chain)
  [ ] Fumigation certificate checked (if applicable)
  [ ] Container positioned at dock door

Stripping:
  [ ] Doors opened carefully (shifted cargo risk)
  [ ] Interior condition inspected (water, odor, pests)
  [ ] Cargo unloaded systematically (rear to front)
  [ ] Each item/pallet scanned and tallied
  [ ] Cargo sorted to designated staging lanes
  [ ] Damaged items segregated and photographed

Verification:
  [ ] Piece count matches manifest
  [ ] SKUs verified against purchase orders
  [ ] Weights checked (sample or full)
  [ ] Labels readable and correct
  [ ] OS&D documented if discrepancies found
  [ ] Quality inspection completed per plan

Documentation:
  [ ] Receiving report completed
  [ ] OS&D filed within required timeframe
  [ ] Tally sheet signed by all parties
  [ ] WMS/ERP updated with received quantities
  [ ] Photos uploaded to document management system

Post-Deconsolidation:
  [ ] Cargo dispatched or putaway completed
  [ ] Empty container released for return
  [ ] Dock area cleaned for next container
  [ ] Metrics recorded (time, count, accuracy)
  [ ] Consignees notified of availability
  [ ] Claims initiated for damages (if any)
EOF
}

show_help() {
    cat << EOF
deconsolidation v$VERSION — Cargo Breakdown & Receiving Reference

Usage: script.sh <command>

Commands:
  intro          Deconsolidation overview and terminology
  process        Step-by-step deconsolidation process
  lcl            LCL shipment deconsolidation guide
  crossdock      Cross-docking operations
  equipment      Equipment and infrastructure reference
  documentation  Documentation flow and discrepancy handling
  metrics        Key performance metrics for operations
  checklist      Deconsolidation operations checklist
  help           Show this help
  version        Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)         cmd_intro ;;
    process)       cmd_process ;;
    lcl)           cmd_lcl ;;
    crossdock)     cmd_crossdock ;;
    equipment)     cmd_equipment ;;
    documentation) cmd_documentation ;;
    metrics)       cmd_metrics ;;
    checklist)     cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "deconsolidation v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
