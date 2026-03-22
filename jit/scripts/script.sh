#!/usr/bin/env bash
# jit — Just-In-Time Production Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Just-In-Time (JIT) Production ===

Just-In-Time is a production strategy that produces only what is needed,
when it is needed, in the quantity needed. Developed as part of the
Toyota Production System by Taiichi Ohno in the 1950s-70s.

Core Idea:
  "Making only what is needed, only when it is needed, only in the
   amount that is needed."

Push vs Pull:
  Push (Traditional/MRP)          Pull (JIT)
  ─────────────────────           ──────────
  Forecast-driven                 Demand-driven
  Large batches                   Small batches / one-piece flow
  High inventory buffers          Minimal inventory
  Long lead times                 Short lead times
  Defects hidden in inventory     Defects exposed immediately

Key Principles:
  1. Eliminate waste (muda) — especially inventory and overproduction
  2. Continuous flow — move parts one at a time between operations
  3. Pull system — downstream processes signal upstream when to produce
  4. Takt time — synchronize production pace with customer demand
  5. Zero defects — quality at the source, stop and fix immediately
  6. Respect for people — empower workers to stop the line

Prerequisites for JIT:
  - Stable, predictable demand (or leveled production)
  - Reliable equipment (TPM — Total Productive Maintenance)
  - Quick changeovers (SMED)
  - Quality at source (Jidoka)
  - Disciplined suppliers
  - Cross-trained workforce
EOF
}

cmd_pillars() {
    cat << 'EOF'
=== JIT Pillars ===

1. CONTINUOUS FLOW (One-Piece Flow)
   Process one unit at a time through all operations without stopping.
   Benefits:
     - Immediate defect detection (only 1 unit at risk)
     - Dramatic lead time reduction
     - Minimal WIP inventory
   Implementation:
     - Arrange equipment in process sequence (cells)
     - U-shaped cells allow flexibility in staffing
     - Eliminate batch-and-queue between operations

2. TAKT TIME SYNCHRONIZATION
   Takt Time = Available Production Time / Customer Demand
   Every workstation completes its task within one takt beat.
   If cycle time > takt → bottleneck, need to rebalance
   If cycle time << takt → over-capacity, reduce resources

3. PULL SYSTEM
   Nothing is produced until the downstream customer signals need.
   Types of pull:
     a. Replenishment pull (supermarket) — replace what was consumed
     b. Sequential pull — produce in sequence of customer orders
     c. Mixed — supermarket for high-volume, sequential for specials
   Signal methods: kanban cards, empty bins, electronic signals

4. ZERO INVENTORY TARGET
   Inventory is waste — it hides problems:
     - Defects (found only when batch is consumed)
     - Machine breakdowns (buffer masks downtime)
     - Long setups (large batches to amortize changeover)
     - Supplier unreliability (safety stock compensates)
   JIT systematically lowers inventory to expose and solve problems.
   Analogy: "Lowering the water level to reveal the rocks"

5. JIDOKA (Built-In Quality)
   Machines and operators detect abnormalities and stop immediately.
   No defective part ever moves to the next process.
   Four steps: Detect → Stop → Fix → Prevent recurrence
EOF
}

cmd_kanban() {
    cat << 'EOF'
=== Kanban Systems ===

Kanban = "signboard" in Japanese. Visual signal to trigger production
or movement of materials.

Types of Kanban:
  Production Kanban — authorizes a process to produce a quantity
  Withdrawal Kanban — authorizes movement from supermarket to process
  Signal Kanban — used for batch processes (e.g., stamping)
  Supplier Kanban — signals external supplier to deliver

Kanban Card Information:
  - Part number and description
  - Quantity per container
  - Supplying process / location
  - Consuming process / location
  - Number of cards in the loop

Kanban Quantity Formula:
  N = (D × L × (1 + S)) / C
  Where:
    N = number of kanban cards
    D = average demand per period
    L = lead time (in same units as D)
    S = safety factor (0.0 to 0.5 typically)
    C = container quantity

Example:
  Demand = 100 units/day, Lead time = 0.5 day
  Safety = 10%, Container = 25 units
  N = (100 × 0.5 × 1.1) / 25 = 2.2 → 3 kanbans

Two-Bin System (simplest kanban):
  - Two containers of parts at point of use
  - Use from Bin A until empty
  - Empty bin = signal to replenish
  - Switch to Bin B while A is refilled

Six Rules of Kanban (Ohno):
  1. Downstream pulls from upstream
  2. Upstream produces only what is withdrawn
  3. No defective parts sent downstream
  4. Number of kanbans should be minimized
  5. Kanban smooths small demand fluctuations
  6. Process must be stabilized and rationalized
EOF
}

cmd_takt() {
    cat << 'EOF'
=== Takt Time & Line Balancing ===

TAKT TIME CALCULATION:
  Takt = Available Time / Customer Demand

  Example:
    Shift: 8 hours = 480 minutes
    Breaks: 2 × 10 min = 20 minutes
    Available: 460 minutes = 27,600 seconds
    Demand: 460 units/shift
    Takt = 27,600 / 460 = 60 seconds per unit

IMPORTANT DISTINCTIONS:
  Takt Time    = pace set by customer demand (external)
  Cycle Time   = actual time to complete one unit (internal)
  Lead Time    = total time from order to delivery (end-to-end)

  CT must be ≤ Takt for the line to meet demand
  Planned CT = Takt × OEE factor (e.g., 60 × 0.85 = 51 sec target)

LINE BALANCING:
  Goal: distribute work equally across stations to match takt

  Steps:
    1. List all work elements and their times
    2. Determine takt time
    3. Calculate minimum stations: Σ element times / takt
    4. Assign elements to stations (keep each ≤ takt)
    5. Balance efficiency = Σ element times / (stations × takt)

  Example:
    Total work content: 240 seconds
    Takt: 60 seconds
    Min stations: 240 / 60 = 4 stations
    Assign tasks so each station is close to 60 sec
    Balance efficiency = 240 / (4 × 60) = 100% (ideal)

  Common issues:
    - Indivisible elements > takt → need parallel stations
    - Precedence constraints limit assignment flexibility
    - Cycle-to-cycle variation → need buffer capacity
EOF
}

cmd_leveling() {
    cat << 'EOF'
=== Heijunka (Production Leveling) ===

Problem without leveling:
  Customer orders fluctuate → production swings wildly
  Mon: 100A, 0B, 0C
  Tue: 0A, 200B, 0C
  Wed: 0A, 0B, 150C
  → Equipment overloaded one day, idle the next
  → Inventory surges for some products, shortages for others

Heijunka Solution:
  Level both VOLUME and MIX across the day.

  Instead of:  AAAA AAAA BBBB BBBB CCCC
  Produce:     ABCA BCAB CABC ABCA BCAB

Two levels of leveling:
  Level 1 — Volume leveling: smooth total daily output
  Level 2 — Mix leveling: produce every product every day (EPEI=1)

EPEI (Every Product Every Interval):
  How often you can produce every part number
  EPEI = 1 day → produce every part daily (ideal for JIT)
  EPEI = 5 days → produce each part once a week (poor)
  Reducing EPEI requires fast changeovers (SMED)

Heijunka Box:
  Physical scheduling device — grid of time slots and products
  Columns = time intervals (e.g., every 10 minutes)
  Rows = product types
  Kanban cards placed in slots = production sequence

  | Time  |  A  |  B  |  C  |
  |-------|-----|-----|-----|
  | 8:00  | [k] |     |     |
  | 8:10  |     | [k] |     |
  | 8:20  | [k] |     |     |
  | 8:30  |     |     | [k] |

Benefits of Leveling:
  - Stable demand on upstream processes and suppliers
  - Smaller finished goods inventory
  - More predictable resource needs
  - Better customer responsiveness
EOF
}

cmd_suppliers() {
    cat << 'EOF'
=== JIT Supplier Relationships ===

Traditional vs JIT Supplier Model:
  Traditional                     JIT
  ───────────                     ───
  Many suppliers per part         Few (often single source)
  Lowest price wins               Total cost focus
  Large infrequent deliveries     Small frequent deliveries
  Incoming inspection             Certified quality at source
  Adversarial negotiation         Long-term partnership
  Short-term contracts            Multi-year agreements

JIT Delivery Strategies:

  Milk Run:
    One truck picks up from multiple suppliers in a circuit.
    Supplier A → B → C → Factory → repeat
    Benefits: full truckloads despite small quantities per supplier

  Cross-Dock:
    Suppliers deliver to consolidation point
    Parts sorted and shipped to factory same day
    No warehousing — just transfer between trucks

  Supplier Parks:
    Suppliers locate facilities adjacent to the assembly plant
    Delivery frequency: multiple times per day or per hour
    Example: Toyota Georgetown has supplier park across the street

Requirements for JIT Suppliers:
  1. Consistent quality (Cpk > 1.33, certified process)
  2. On-time delivery (>99%)
  3. Flexibility in volume (±20% without lead time change)
  4. Small lot capability
  5. Transparent communication (share forecasts, problems)
  6. Continuous improvement commitment

JIT Supply Chain Risks:
  - Single source dependency → mitigate with dual sourcing for critical parts
  - Transportation disruptions → safety stock for long-distance suppliers
  - Natural disasters → regional diversification
  - Quality escapes → containment plans, rapid response agreements
EOF
}

cmd_barriers() {
    cat << 'EOF'
=== JIT Implementation Barriers & Countermeasures ===

Barrier 1: Unreliable Equipment
  Symptom: Machines break down, causing line stoppages
  Countermeasure: Total Productive Maintenance (TPM)
    - Autonomous maintenance by operators
    - Planned preventive maintenance schedules
    - Target: OEE > 85%, zero breakdowns

Barrier 2: Long Changeover Times
  Symptom: Large batches to amortize setup costs
  Countermeasure: SMED (Single-Minute Exchange of Die)
    - Separate internal vs external setup
    - Convert internal to external
    - Streamline all steps → target < 10 minutes

Barrier 3: Poor Quality
  Symptom: Defects require rework, scrap, and buffer stock
  Countermeasure: Jidoka + Poka-Yoke
    - Build quality in at the source
    - Error-proof processes
    - Stop and fix immediately, never pass defects

Barrier 4: Unstable Demand
  Symptom: Wild swings in customer orders
  Countermeasure: Heijunka (production leveling)
    - Level volume and mix
    - Use finished goods buffer (supermarket) to absorb variation
    - Negotiate stable order patterns with customers

Barrier 5: Supplier Unreliability
  Symptom: Late deliveries, quality issues from vendors
  Countermeasure: Supplier development program
    - Reduce supplier base, build partnerships
    - Help suppliers implement their own lean/JIT
    - Certify supplier quality, eliminate incoming inspection

Barrier 6: Cultural Resistance
  Symptom: "We've always done it this way"
  Countermeasure: Leadership commitment + quick wins
    - Start with a pilot cell/line
    - Show measurable results (lead time, inventory, quality)
    - Train everyone in lean fundamentals
    - Celebrate successes publicly

Barrier 7: Lack of Cross-Training
  Symptom: Operators can only run one machine/process
  Countermeasure: Skills matrix + rotation plan
    - Map skills needed vs skills available
    - Systematic training and rotation
    - Target: every operator qualified on 3+ stations
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== JIT Readiness Checklist ===

Equipment Reliability:
  [ ] OEE tracked for all critical equipment
  [ ] Preventive maintenance schedules in place
  [ ] Autonomous maintenance practiced by operators
  [ ] Breakdown frequency < 1 per week per machine
  [ ] Spare parts strategy defined (critical spares stocked)

Changeover Capability:
  [ ] Changeover times measured and recorded
  [ ] SMED projects completed on bottleneck equipment
  [ ] Target changeover times set (< 10 minutes)
  [ ] Changeover procedures standardized and documented
  [ ] Operators trained on quick changeover techniques

Quality Systems:
  [ ] Process capability studies done (Cpk > 1.33)
  [ ] Error-proofing (poka-yoke) devices installed
  [ ] Operators empowered to stop line for defects
  [ ] Root cause analysis practiced for every defect
  [ ] Scrap and rework rates below target

Pull System Readiness:
  [ ] Takt time calculated for each product family
  [ ] Kanban quantities determined (formula-based)
  [ ] Supermarket locations defined
  [ ] Visual signals designed (cards, bins, electronic)
  [ ] Pull system rules documented and trained

Supplier Readiness:
  [ ] Key suppliers identified and evaluated
  [ ] Delivery frequency increased (weekly → daily)
  [ ] Supplier quality certified (no incoming inspection)
  [ ] Communication systems established (EDI, kanban)
  [ ] Contingency plans for supply disruptions

Workforce Readiness:
  [ ] Cross-training matrix shows multi-skill coverage
  [ ] Standard work documented for all operations
  [ ] Team leaders trained in lean/JIT principles
  [ ] Problem-solving skills taught (A3, 5-Why, fishbone)
  [ ] Suggestion system active for improvement ideas
EOF
}

show_help() {
    cat << EOF
jit v$VERSION — Just-In-Time Production Reference

Usage: script.sh <command>

Commands:
  intro        JIT origins, push vs pull, core principles
  pillars      Foundational pillars: flow, takt, pull, zero inventory
  kanban       Kanban card systems, sizing formulas, rules
  takt         Takt time calculation and line balancing
  leveling     Heijunka production leveling and mix smoothing
  suppliers    JIT supplier relationships and delivery strategies
  barriers     Implementation barriers and countermeasures
  checklist    JIT readiness assessment checklist
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    pillars)    cmd_pillars ;;
    kanban)     cmd_kanban ;;
    takt)       cmd_takt ;;
    leveling)   cmd_leveling ;;
    suppliers)  cmd_suppliers ;;
    barriers)   cmd_barriers ;;
    checklist)  cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "jit v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
