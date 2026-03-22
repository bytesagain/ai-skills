#!/usr/bin/env bash
# consolidation — Freight Consolidation Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Freight Consolidation ===

Consolidation combines multiple smaller shipments into a single larger
shipment to reduce per-unit transportation costs.

Core Economics:
  Shipping cost per unit decreases as shipment size increases.
  A full truckload (FTL) costs ~$2/mile regardless of weight.
  Two half-loads shipped separately = 2× the cost.
  Consolidating them into one FTL cuts transport cost by ~50%.

Types of Consolidation:

  Inventory Consolidation
    Hold orders in warehouse until enough volume for full load
    Trade-off: lower freight cost vs longer delivery time

  Vehicle Consolidation
    Combine orders for multiple destinations onto one truck
    Driver makes multiple stops (multi-stop truckload)

  Terminal Consolidation
    Small shipments collected at hub, sorted, re-loaded by destination
    How LTL (Less Than Truckload) carriers operate

  Buyer Consolidation
    Multiple purchase orders from same buyer combined
    Common in retail: weekly order windows

  Pool Distribution
    Full truckload to regional hub, then local delivery
    Combines linehaul efficiency with last-mile reach

Key Metrics:
  Cube utilization     % of vehicle volume used (target: >85%)
  Weight utilization   % of vehicle weight capacity used
  Stop density         Deliveries per route mile
  Consolidation ratio  Orders combined per shipment
  Cost per unit        Total freight ÷ units shipped

Container Sizes (Ocean):
  20' (TEU)   33 CBM, 21,700 kg max payload
  40' (FEU)   67 CBM, 26,500 kg max payload
  40' HC      76 CBM, 26,270 kg max payload

Truck Sizes (North America):
  Sprinter Van    10-12 pallets,  4,500 kg
  Straight Truck  12-16 pallets,  9,000 kg
  53' Trailer     26-30 pallets, 19,500 kg
EOF
}

cmd_lcl() {
    cat << 'EOF'
=== LCL (Less than Container Load) Groupage ===

LCL consolidation combines cargo from multiple shippers into
one ocean container, sharing the cost proportionally.

How It Works:
  1. Shippers deliver cargo to origin CFS (Container Freight Station)
  2. CFS operator groups compatible cargo by destination port
  3. Consolidated container shipped as FCL (Full Container Load)
  4. At destination CFS, container is deconsolidated (de-stuffed)
  5. Each shipper's cargo is held for pickup or delivered

Cost Structure:
  LCL rates quoted per CBM (cubic meter) or per ton (W/M)
  W/M = Whichever is greater: volume weight or actual weight
  1 CBM = 1,000 kg for ocean freight density calculation

  Typical LCL surcharges:
    CFS charge (origin)        $50-100 per shipment
    CFS charge (destination)   $50-100 per shipment
    Documentation fee          $25-50
    Handling/warehousing       $5-15 per CBM

When LCL Makes Sense:
  Volume < 15 CBM  → LCL is usually cheaper
  Volume > 15 CBM  → FCL 20' may be cheaper (get quotes for both)
  Volume > 25 CBM  → FCL 20' almost certainly cheaper

LCL Transit Time:
  Add 3-7 days vs FCL for the same route
    Origin CFS handling    1-3 days (wait for container to fill)
    Destination CFS        1-2 days (deconsolidation + availability)
    Customs clearance      1-2 days (shared container inspection risk)

Consolidator Types:
  NVOCC (Non-Vessel Operating Common Carrier)
    Books FCL space, fills with LCL cargo from multiple shippers
    Issues own house bill of lading (HBL)
    Master bill of lading (MBL) in NVOCC name

  Co-loader
    Consolidates cargo from freight forwarders (not direct shippers)
    Multiple HBLs under one MBL

LCL Restrictions:
  - Hazardous goods: limited or not accepted
  - Temperature-controlled: only if reefer consolidation available
  - Oversized cargo: may not fit standard container
  - High-value: consider insurance, FCL may be safer
EOF
}

cmd_crossdock() {
    cat << 'EOF'
=== Cross-Docking Operations ===

Cross-docking receives inbound shipments and ships them outbound
with minimal or zero storage time. Product crosses the dock, never
enters inventory.

Types:

  Pre-Distributed Cross-Dock
    Supplier pre-labels each case with destination store
    Cross-dock just sorts and loads onto outbound trucks
    Fastest method, minimal handling
    Used by: Walmart, Amazon FC-to-delivery station

  Post-Distributed Cross-Dock
    Inbound goods received in bulk
    Cross-dock breaks bulk, allocates to destinations based on orders
    More flexible but requires more labor
    Used by: grocery distribution, fashion retail

  Merge-in-Transit
    Components from multiple suppliers meet at cross-dock
    Merged into single customer delivery
    Used by: Dell (monitor from A + PC from B → customer)

Physical Layout:
    ┌──────────────────────────────┐
    │  Inbound dock doors (left)   │
    │  ┌──────────────────────┐   │
    │  │   Sorting area       │   │
    │  │   (staging lanes by  │   │
    │  │    destination)      │   │
    │  └──────────────────────┘   │
    │  Outbound dock doors (right) │
    └──────────────────────────────┘

  I-shape: inbound one side, outbound opposite (simplest)
  L-shape: inbound on two adjacent sides
  T-shape: inbound on one side, outbound on two
  H-shape: two parallel dock buildings

Success Factors:
  Timing     Inbound must arrive within narrow window
  Visibility Real-time ASN (Advance Ship Notice) critical
  Volume     Need enough outbound volume to fill trucks quickly
  IT         WMS with cross-dock planning module
  Layout     Minimal travel distance between dock doors

Performance Metrics:
  Dock-to-dock time    Target: < 2 hours
  Dock utilization     Target: > 80% of door hours used
  Touches              Target: ≤ 2 (unload → sort → load)
  On-time departure    Target: > 95% of outbound trucks
EOF
}

cmd_milkrun() {
    cat << 'EOF'
=== Milk Run Logistics ===

A milk run is a circular pickup/delivery route that visits multiple
locations in a single trip, like a milkman visiting houses on a route.

How It Works:
  Instead of:  5 suppliers each send one small truck → factory
  Milk run:    1 truck visits all 5 suppliers → returns full to factory

  Before (direct):       After (milk run):
  S1 ──→ Factory         S1 → S2 → S3 → S4 → S5
  S2 ──→ Factory                    ↓
  S3 ──→ Factory              → Factory (full load)
  S4 ──→ Factory
  S5 ──→ Factory
  5 trucks, partially loaded     1 truck, fully loaded

Benefits:
  Transport cost     -30% to -50% (fewer trucks, higher utilization)
  Inventory          Lower (smaller, more frequent deliveries)
  Emissions          Fewer truck-miles
  Supplier docks     Less congestion (scheduled windows)
  Quality            Problems caught faster (smaller batches)

Milk Run Design:

  1. Cluster suppliers geographically
     Rule: max 50km radius for urban, 150km for regional
     Same-direction routes (no backtracking)

  2. Set pickup schedule
     Fixed days/times for each supplier
     Example: Mon/Wed/Fri route A, Tue/Thu route B

  3. Calculate vehicle sizing
     Sum of all supplier volumes per run
     Leave 10-15% capacity buffer for variation
     Match truck type to total volume

  4. Define time windows
     Window per supplier: 15-30 minutes
     Total route time: < 8 hours (driver hours regulation)
     Latest arrival at factory: before production start

Toyota's Milk Run System:
  - Trucks leave factory with empty containers
  - Visit suppliers in sequence, swap full for empty containers
  - Return to factory with parts for that day's production
  - 4-6 runs per day, suppliers within 100km radius
  - Achieved 50% transport cost reduction vs direct delivery

Key Success Factors:
  ✓ Reliable supplier readiness (cargo staged on time)
  ✓ Consistent volumes (predictable production schedule)
  ✓ Geographic clustering (suppliers near each other)
  ✓ Standardized packaging (pallets, containers stack efficiently)
  ✓ Good communication (delays cascade through the route)
EOF
}

cmd_savings() {
    cat << 'EOF'
=== Consolidation Economics ===

--- Cost Comparison: LTL vs Consolidated FTL ---

Scenario: 5 shipments, each 5 pallets, same origin → same destination

  LTL (each shipped separately):
    5 × $800 per shipment = $4,000 total
    5 × separate pickup/delivery
    Transit: 3-5 days each

  Consolidated FTL (all 25 pallets on one truck):
    1 × $2,200 per truck = $2,200 total
    1 pickup, 1 delivery
    Transit: 1-2 days
    Savings: $1,800 (45%)

--- Weight Break Analysis ---

LTL carriers use weight breaks — price drops at thresholds:
  Minimum charge:     500 lbs    $45/cwt
  1,000 lb break:   1,000 lbs    $35/cwt
  2,000 lb break:   2,000 lbs    $28/cwt
  5,000 lb break:   5,000 lbs    $22/cwt
  10,000 lb break: 10,000 lbs    $18/cwt
  20,000 lb break: 20,000 lbs    $15/cwt

  A 1,800 lb shipment at $35/cwt = $630
  A 2,000 lb shipment at $28/cwt = $560
  Declaring 2,000 lbs is CHEAPER despite more weight!
  Always check the next weight break.

--- Break-Even: LCL vs FCL (Ocean) ---

  LCL rate: $65/CBM
  FCL 20' rate: $1,800 all-in
  FCL capacity: 33 CBM usable

  Break-even: $1,800 ÷ $65 = 27.7 CBM
  Below 27 CBM → LCL cheaper
  Above 28 CBM → FCL cheaper
  Factor in CFS charges: real break-even often ~20 CBM

--- Zone Skip Savings ---

  Direct parcel: Ship from warehouse → each customer
  Zone skip: Consolidate parcels by region → trailer to regional hub
             → inject into local postal/carrier network

  Example (1,000 parcels/day to Zone 8):
    Direct ship:  1,000 × $12.50 = $12,500
    Zone skip:    Trailer to Zone 8 hub: $1,500
                  Local delivery: 1,000 × $6.00 = $6,000
                  Total: $7,500
    Savings: $5,000/day (40%)

--- Consolidation ROI Formula ---

  Savings = (Direct_Cost - Consolidated_Cost) - Holding_Cost
  Where:
    Direct_Cost = sum of individual shipment costs
    Consolidated_Cost = fewer, fuller shipments
    Holding_Cost = warehouse cost for holding orders while consolidating
  If Savings > 0, consolidation is worthwhile
EOF
}

cmd_methods() {
    cat << 'EOF'
=== Consolidation Methods ===

--- Zone Skipping ---
  Bypass intermediate carrier sort facilities by trucking directly
  to a destination zone, then injecting into local delivery network.

  Flow: Shipper → Sort by zone → FTL to zone hub → Local carrier
  Works with: USPS (DDU/SCF injection), UPS, FedEx SmartPost
  Best for: high-volume parcel shippers (500+ parcels/day/zone)
  Savings: 20-40% vs standard parcel rates

--- Pool Distribution ---
  Ship full truckload to a pool point near destination cluster,
  then use local carriers for last-mile delivery.

  Flow: Shipper → FTL to pool point → LTL/local delivery
  Pool points: carrier terminals, 3PL cross-docks, shared warehouses
  Best for: national distribution to sparse regions
  Savings: 25-35% vs direct LTL to each customer

--- Merge-in-Transit ---
  Components from different origins converge at a merge point,
  are combined into a single delivery to the customer.

  Flow: Supplier A → ┐
        Supplier B → ├→ Merge Point → Customer
        Supplier C → ┘

  Requirements:
    - Precise timing coordination
    - Real-time visibility into all shipments
    - Fallback plan if one shipment is late
  Best for: multi-component orders (furniture, electronics, industrial)

--- Buyer Consolidation ---
  Retail buyer groups multiple purchase orders into one shipment.

  Example: Retailer places 5 POs this week to same supplier
  Instead of 5 separate shipments → supplier ships once
  Uses order windows: "All orders by Wednesday ship Friday"

--- Multi-Stop Truckload (MSTL) ---
  Single truck makes 2-4 deliveries on a route.
  Cheaper than FTL to each, faster than LTL network.

  Pricing: FTL rate + stop charges ($50-150 per stop)
  Constraints:
    - Each stop adds 1-2 hours
    - Driver hours limit total stops
    - Unloading sequence must match route order

--- Collaborative Consolidation ---
  Non-competing companies share truck space on same lanes.
  Company A ships Mon/Wed (half truck), Company B ships Tue/Thu (half truck)
  Combined: daily full trucks at lower cost for both.
  Platforms: Convoy, Transfix, Flexport, collaborative TMS
EOF
}

cmd_planning() {
    cat << 'EOF'
=== Consolidation Planning ===

--- Order Windows ---
  Define cutoff times for orders to be included in consolidated shipment.

  Example schedule:
    Monday 12:00 PM    → Cutoff for Wednesday shipment
    Wednesday 12:00 PM → Cutoff for Friday shipment
    Friday 12:00 PM    → Cutoff for Monday shipment

  Window sizing:
    Shorter windows (daily)  → faster delivery, less consolidation
    Longer windows (weekly)  → better consolidation, slower delivery
    Balance: 2-3 day windows give good consolidation without long delays

--- Weight/Volume Optimization ---

  Step 1: Sort pending orders by destination zone
  Step 2: For each zone, sum weight and cube
  Step 3: Compare against vehicle capacities:

    If weight > 10,000 lbs OR cube > 1,000 ft³ → Book FTL
    If weight > 5,000 lbs  → Use 5,000 lb LTL break
    If weight > 2,000 lbs  → Use 2,000 lb LTL break
    If weight < 2,000 lbs  → Ship as standard LTL or hold for next window

  Step 4: Check if FTL price < sum of individual LTL prices
  Step 5: Verify delivery windows still met

--- Pallet Optimization ---

  Standard pallet: 48" × 40" (North America)
  Truck floor: 8 pallets wide × 3 deep per row = 24 floor positions (53' trailer)
  Double-stacked: up to 48 pallets if weight and product allow

  Loading priority:
    1. Heaviest pallets on bottom, near axles
    2. Same-destination pallets together (for multi-stop)
    3. Last delivery loaded first (LIFO sequence)
    4. Fill vertical space — air is wasted money

--- TMS Consolidation Logic ---

  Good TMS (Transportation Management System) features:
    Auto-consolidation engine:
      Groups orders by: destination zone, service level, ship date
      Evaluates: FTL vs LTL vs parcel for each group
      Considers: weight breaks, min charges, stop-off fees

    What-if simulation:
      "If I hold these orders 1 more day, can I fill a truck?"
      Shows cost of holding vs cost of partial shipment

    Dynamic routing:
      Re-optimizes as new orders arrive
      Alerts when consolidation opportunity exists
      Integrates carrier rate tables for real-time comparison
EOF
}

cmd_risks() {
    cat << 'EOF'
=== Consolidation Risks & Mitigation ===

1. Delivery Delays
   Risk: Holding orders for consolidation delays individual shipments
   Impact: Customer dissatisfaction, SLA violations, penalty fees
   Mitigation:
     - Set maximum hold time (e.g., never exceed 48 hours)
     - Priority/expedite orders bypass consolidation
     - Communicate expected delivery windows to customers
     - Track consolidation hold time as a KPI

2. Damage from Mixed Cargo
   Risk: Different products in same container may be incompatible
   Examples: heavy items crush light ones, chemicals near food
   Mitigation:
     - Cargo compatibility matrix (what can ship together)
     - Proper blocking and bracing between shipments
     - Clear labeling with handling instructions
     - Insurance per shipper within consolidated load

3. Customs Complications (International)
   Risk: Consolidated container with goods from multiple shippers
   Issues:
     - One shipper's goods held → entire container detained
     - Different HS codes, different duty rates
     - Fumigation or inspection delays all cargo
   Mitigation:
     - Use separate commercial invoices per shipper
     - CFS bond for partial release where available
     - Avoid mixing regulated goods (food, chemicals, restricted items)
     - Factor customs risk into LCL transit time estimates

4. Liability Allocation
   Risk: Damage discovered at deconsolidation — who is responsible?
   Issues: Carrier vs CFS vs shipper vs consignee
   Mitigation:
     - Photo documentation at origin CFS before loading
     - Tally sheets signed by each party at each handoff
     - Cargo insurance per shipper (not just per container)
     - Clear terms in consolidation agreement

5. Capacity Mismatch
   Risk: Not enough volume to fill consolidated load efficiently
   Results in: paying for partial truck = worse than LTL
   Mitigation:
     - Minimum volume threshold to trigger consolidation
     - Collaborative shipping with non-competing partners
     - Flexible cutoff windows that adapt to volume
     - Fallback to LTL if threshold not met by cutoff

6. Complexity Overhead
   Risk: Consolidation planning requires TMS, staff, processes
   Small shipper impact: cost of planning > savings from consolidation
   Mitigation:
     - Use 3PL consolidation services (they do the planning)
     - Start simple: consolidate same-destination, same-day orders only
     - Automate with TMS rules, don't rely on manual decisions
     - Break-even analysis: savings must exceed planning cost
EOF
}

show_help() {
    cat << EOF
consolidation v$VERSION — Freight Consolidation Reference

Usage: script.sh <command>

Commands:
  intro        Freight consolidation concepts and economics
  lcl          LCL ocean freight groupage operations
  crossdock    Cross-docking receive-sort-ship operations
  milkrun      Milk run supplier pickup routes
  savings      Cost calculations and break-even analysis
  methods      Zone-skip, pool distribution, merge-in-transit
  planning     Order windows, weight breaks, TMS logic
  risks        Consolidation risks and mitigation strategies
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    lcl)        cmd_lcl ;;
    crossdock)  cmd_crossdock ;;
    milkrun)    cmd_milkrun ;;
    savings)    cmd_savings ;;
    methods)    cmd_methods ;;
    planning)   cmd_planning ;;
    risks)      cmd_risks ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "consolidation v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
