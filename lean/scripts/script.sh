#!/usr/bin/env bash
# lean — Lean Manufacturing Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Lean Manufacturing ===

Lean is a systematic method for waste minimization within a manufacturing
system without sacrificing productivity. Originated from Toyota Production
System (TPS), developed by Taiichi Ohno and Shigeo Shingo.

Core Philosophy:
  - Maximize customer value
  - Minimize waste (muda, muri, mura)
  - Continuous improvement (kaizen)
  - Respect for people

Two Pillars of TPS:
  1. Just-In-Time (JIT)    Produce only what is needed, when needed
  2. Jidoka (Autonomation)  Stop and fix problems immediately

Key Concepts:
  Muda     Waste — activities that consume resources without value
  Muri     Overburden — pushing people or machines beyond capacity
  Mura     Unevenness — fluctuation in workload causing waste

  Gemba    "The real place" — go to where work happens
  Genchi Genbutsu  "Go and see" — verify facts firsthand
  Hansei   Reflection — honest self-assessment after each cycle

History:
  1930s    Sakichi Toyoda invents automatic loom with Jidoka
  1950s    Taiichi Ohno develops kanban and pull systems
  1988     John Krafcik coins "lean" in MIT study
  1990     "The Machine That Changed the World" published
  2000s    Lean spreads to healthcare, software, services
EOF
}

cmd_wastes() {
    cat << 'EOF'
=== The 8 Wastes of Lean (DOWNTIME) ===

D — Defects
    Products or services that don't meet specifications
    Examples: rework, scrap, warranty claims, inspection costs
    Fix: Poka-yoke (error-proofing), root cause analysis

O — Overproduction
    Making more than the customer needs right now
    THE worst waste — it creates all other wastes
    Fix: Pull systems, kanban, takt time production

W — Waiting
    Idle time between process steps
    Examples: waiting for materials, approvals, machines, information
    Fix: Line balancing, SMED, cross-training

N — Non-utilized Talent
    Not using people's skills, ideas, and creativity
    Examples: micro-management, no suggestion system, siloed roles
    Fix: Kaizen circles, cross-functional teams, empowerment

T — Transportation
    Unnecessary movement of materials or products
    Examples: multiple warehouses, complex routings, distant suppliers
    Fix: Cellular manufacturing, point-of-use storage

I — Inventory
    Excess raw materials, WIP, or finished goods
    Hides problems: defects, long setups, unreliable suppliers
    Fix: JIT delivery, smaller batches, kanban signals

M — Motion
    Unnecessary movement of people
    Examples: searching for tools, walking between stations, bending
    Fix: 5S, ergonomic workplace design, standard work

E — Extra-processing
    Doing more work than the customer requires
    Examples: tighter tolerances than needed, redundant inspections
    Fix: Voice of customer, value analysis, simplification
EOF
}

cmd_fives() {
    cat << 'EOF'
=== 5S Workplace Organization ===

1S — Sort (Seiri)
    Remove everything not needed in the work area
    Red-tag items: if not used in 30 days, remove it
    Questions: Do I need this? How often? How many?

2S — Set in Order (Seiton)
    A place for everything, everything in its place
    Organize by frequency of use:
      - Used every hour → within arm's reach
      - Used daily → in the work area
      - Used weekly → nearby storage
      - Used monthly → remote storage
    Use shadow boards, labels, floor markings

3S — Shine (Seiso)
    Clean the workspace AND inspect during cleaning
    Cleaning = inspection opportunity
    Assign cleaning zones to specific people
    Create cleaning schedules and standards

4S — Standardize (Seiketsu)
    Create visual standards for the first 3S
    Checklists, photos of ideal state, color coding
    Everyone should be able to spot abnormalities
    "If you can't see it, you can't fix it"

5S — Sustain (Shitsuke)
    Build discipline through habit and culture
    Regular audits (weekly 5S walks)
    Management participation (lead by example)
    Celebrate successes, coach gaps
    5S is not a one-time event — it's a daily practice

Benefits:
  - Reduced searching time (typically 50%+ reduction)
  - Fewer safety incidents
  - Improved quality (defects visible immediately)
  - Higher morale (clean, organized workplace)
  - Foundation for all other lean tools
EOF
}

cmd_vsm() {
    cat << 'EOF'
=== Value Stream Mapping (VSM) ===

Purpose: Visualize the entire flow of materials and information
from raw material to customer delivery.

Step 1: Select Product Family
  - Group products with similar process steps
  - Focus on high-volume or high-value family first

Step 2: Draw Current State Map
  Symbols:
    [Process Box]  Each process step with data box below
    ▼ Inventory    Triangle = inventory between steps
    → Push arrow   Material pushed to next step
    ~~> Info flow   Information flow (orders, schedules)
    ☁ Customer     Customer demand box (top right)
    ☁ Supplier     Supplier box (top left)

  Data Box for each process:
    C/T  = Cycle Time (time to complete one unit)
    C/O  = Changeover Time (setup between products)
    Uptime = % available when needed
    Batch = Batch size
    Operators = Number of people

  Timeline at bottom:
    Value-added time (processing) vs non-value-added (waiting)
    Typical ratio: 5% value-added, 95% waste

Step 3: Identify Waste
  - Where does inventory pile up?
  - Where are the longest wait times?
  - Where do defects originate?
  - Where is overproduction occurring?

Step 4: Design Future State
  - Can processes flow continuously?
  - Where to install pull systems (kanban)?
  - What is the takt time? Are processes balanced to it?
  - Where is the pacemaker process?
  - Can batch sizes be reduced (SMED)?

Step 5: Implementation Plan
  - Break future state into improvement loops
  - Assign kaizen events to each loop
  - Set measurable targets and deadlines
EOF
}

cmd_tools() {
    cat << 'EOF'
=== Lean Tools Reference ===

Poka-Yoke (Error-Proofing):
  Design processes so errors cannot happen
  Types: prevention (make it impossible) vs detection (catch it fast)
  Examples: USB plugs (can't insert wrong), checklists, fixtures

Andon:
  Visual signal system for real-time status
  Green = normal, Yellow = issue, Red = stopped
  Anyone can pull the Andon cord to stop the line
  Manager must respond within defined time (e.g., 1 min)

Heijunka (Production Leveling):
  Smooth out production volume and mix over time
  Instead of: AAAA BBBB CCCC
  Do:         ABCA BCAB CABC
  Reduces inventory, enables smaller batches

Jidoka (Autonomation):
  Automation with a human touch
  Machine detects abnormality → stops automatically
  Separates human work from machine work
  Four steps: Detect → Stop → Fix → Prevent

Takt Time:
  Available production time ÷ Customer demand
  Example: 480 min/day ÷ 240 units = 2 min/unit takt
  Every station must complete work within takt time
  Takt ≠ Cycle Time (takt is demand-driven, CT is actual)

SMED (Single-Minute Exchange of Die):
  Reduce changeover time to under 10 minutes
  Steps:
    1. Separate internal (machine stopped) vs external (while running)
    2. Convert internal to external where possible
    3. Streamline remaining internal steps
    4. Streamline external steps

Standard Work:
  Document the current best practice for each task
  Three elements: takt time, work sequence, standard WIP
  Basis for improvement — you can't improve what isn't standardized
EOF
}

cmd_metrics() {
    cat << 'EOF'
=== Lean Metrics ===

OEE (Overall Equipment Effectiveness):
  OEE = Availability × Performance × Quality
  Availability = Run Time / Planned Production Time
  Performance = (Ideal Cycle Time × Total Count) / Run Time
  Quality = Good Count / Total Count
  World-class OEE: 85%+
  Typical: 60%

Takt Time:
  = Available Time / Customer Demand
  Sets the pace of production
  Example: 27,600 sec/shift ÷ 460 units = 60 sec takt

Cycle Time:
  Time to complete one unit at one station
  Must be ≤ takt time to meet demand
  If CT > takt → bottleneck

Lead Time:
  Total time from order to delivery
  Includes processing, waiting, transport, inspection
  Lead Time = Processing Time + Queue Time

Throughput:
  Units produced per time period
  Throughput = 1 / Bottleneck Cycle Time

First Pass Yield (FPY):
  % of units that pass quality check first time
  FPY = Good units / Total units started
  Rolled FPY = FPY₁ × FPY₂ × ... × FPYₙ

WIP (Work In Process):
  Little's Law: WIP = Throughput × Lead Time
  Less WIP = shorter lead time = faster response
  Target: minimum WIP needed to maintain flow

Inventory Turns:
  = Cost of Goods Sold / Average Inventory
  Higher = leaner (Toyota: 10-15 turns, typical: 4-6)
EOF
}

cmd_examples() {
    cat << 'EOF'
=== Lean Implementation Examples ===

--- Manufacturing Cell Redesign ---
Before: Functional layout (all drills together, all lathes together)
  - Parts travel 1,200 feet between operations
  - Lead time: 14 days, WIP: 2,000 units
  - Batch size: 500

After: U-shaped cell with one-piece flow
  - Parts travel 40 feet
  - Lead time: 2 days, WIP: 50 units
  - Batch size: 1
  - Result: 86% lead time reduction

--- SMED Changeover Reduction ---
Before: Die change takes 4 hours
  Step 1: Separated internal/external → 2.5 hours
  Step 2: Pre-staged tools, quick-release clamps → 45 minutes
  Step 3: Parallel operations with 2 people → 20 minutes
  Step 4: Standardized die heights → 8 minutes
  Result: 97% reduction in changeover time

--- 5S in a Maintenance Shop ---
Before: Technicians spend 25 min/day searching for tools
After 5S:
  - Shadow boards for all common tools
  - Color-coded by tool type
  - Weekly 5S audit scores posted
  - Search time: 3 min/day (88% reduction)
  - Bonus: missing tools spotted same day

--- Kanban in Assembly ---
Before: MRP push system, weekly production schedule
  - Overproduction on fast items, shortages on slow items
After: Two-bin kanban system
  - Bin empty → send kanban card → replenish
  - WIP dropped 60%, delivery performance 85% → 98%
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== Lean Assessment Checklist ===

Workplace Organization (5S):
  [ ] Work areas clean and organized
  [ ] Tools have designated locations (shadow boards)
  [ ] Floor markings define areas and pathways
  [ ] Visual standards posted (photos of ideal state)
  [ ] Regular audit schedule in place

Flow:
  [ ] Products flow through process without backtracking
  [ ] Work stations arranged in process sequence
  [ ] Batch sizes minimized (target: one-piece flow)
  [ ] WIP limits defined and visible
  [ ] Bottleneck process identified and managed

Pull System:
  [ ] Production triggered by customer demand (not forecast)
  [ ] Kanban signals in place between process steps
  [ ] Supermarket inventory at point-of-use
  [ ] Replenishment quantities based on consumption

Standard Work:
  [ ] Standard work documents at each station
  [ ] Takt time calculated and displayed
  [ ] Work sequence defined and followed
  [ ] Standard WIP quantity defined
  [ ] Documents updated when improvements made

Quality at Source:
  [ ] Operators inspect their own work
  [ ] Error-proofing devices in place (poka-yoke)
  [ ] Andon system for signaling problems
  [ ] Stop-and-fix culture (no passing defects forward)
  [ ] Root cause analysis for every defect

Continuous Improvement:
  [ ] Regular kaizen events scheduled
  [ ] Suggestion system active and responsive
  [ ] Metrics visible to all (daily management board)
  [ ] Problems treated as improvement opportunities
  [ ] Management participates in gemba walks
EOF
}

show_help() {
    cat << EOF
lean v$VERSION — Lean Manufacturing Reference

Usage: script.sh <command>

Commands:
  intro        Lean manufacturing origins and philosophy
  wastes       The 8 wastes (DOWNTIME mnemonic)
  fives        5S workplace organization methodology
  vsm          Value Stream Mapping guide
  tools        Lean tools: Poka-Yoke, Andon, Heijunka, SMED
  metrics      Key lean metrics: OEE, takt, cycle time, FPY
  examples     Real-world lean implementation examples
  checklist    Lean maturity assessment checklist
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    wastes)     cmd_wastes ;;
    fives|5s)   cmd_fives ;;
    vsm)        cmd_vsm ;;
    tools)      cmd_tools ;;
    metrics)    cmd_metrics ;;
    examples)   cmd_examples ;;
    checklist)  cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "lean v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
