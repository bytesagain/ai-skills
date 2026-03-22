#!/usr/bin/env bash
# kanban — Kanban System Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Kanban System ===

Kanban (看板) is a visual workflow management method that uses signals
to control the flow of work. Originally developed at Toyota by Taiichi
Ohno in the 1950s for just-in-time manufacturing.

Core Idea:
  "Stop starting, start finishing."
  Work is PULLED when capacity is available, not PUSHED by schedule.

Four Foundational Principles:
  1. Start with what you do now (no big-bang change)
  2. Agree to pursue incremental change
  3. Respect current roles and responsibilities
  4. Encourage leadership at all levels

Types of Kanban:
  Production Kanban  Signals to produce more items
  Withdrawal Kanban  Signals to move items from upstream
  Signal Kanban      Triggers batch production at a threshold
  Express Kanban     Emergency replenishment for stockouts

Manufacturing vs Software:
  Manufacturing: physical cards, bins, fixed routes
  Software: digital boards (Jira, Trello), flexible workflows
  Same principle: visualize → limit WIP → optimize flow
EOF
}

cmd_board() {
    cat << 'EOF'
=== Kanban Board Design ===

Basic Columns:
  Backlog → Ready → In Progress → Review → Done

Advanced Columns:
  Backlog → Analysis → Dev [Doing|Done] → Test [Doing|Done] → Deploy → Done
  Split columns (Doing/Done) make handoffs visible

Swimlanes (horizontal rows):
  - By priority: Expedite (top), Standard, Low
  - By team: Frontend, Backend, DevOps
  - By customer: Client A, Client B, Internal
  - By type: Feature, Bug, Tech Debt

Card Design:
  ┌──────────────────────┐
  │ [TYPE] #123          │  ← ticket ID + type tag
  │ Fix login timeout    │  ← title
  │ Assigned: Alex       │  ← owner
  │ Class: Standard      │  ← service class
  │ Blocked: ⚠️          │  ← blocker flag
  │ Age: 3 days          │  ← days in column
  └──────────────────────┘

Card Colors:
  Blue = Feature   Red = Bug   Yellow = Tech Debt
  Purple = Expedite   Green = Improvement

Physical vs Digital:
  Physical: sticky notes on whiteboard, immediate visibility
  Digital: history, metrics, remote access, integrations
  Hybrid: physical board + digital mirror for metrics
EOF
}

cmd_wip() {
    cat << 'EOF'
=== WIP Limits ===

What: Maximum number of items allowed in a column or workflow stage.

Why WIP Limits Matter:
  - Too much WIP → context switching → slower everything
  - Little's Law: Lead Time = WIP / Throughput
  - Reduce WIP → reduce lead time (mathematically guaranteed)
  - Makes bottlenecks visible immediately

How to Set Initial WIP Limits:
  Method 1: Count current work
    - Count items currently in progress
    - Set limit at current level, then gradually reduce
  
  Method 2: People-based
    - WIP limit = number of people × 1.5
    - Example: 4 developers → WIP limit of 6

  Method 3: Start low
    - Set limit at 1 per person
    - Increase only if people are idle (not just uncomfortable)

Adjusting WIP Limits:
  Too high → work piles up, long lead times, no urgency
  Too low → people idle, blocked frequently
  Right → steady flow, manageable multitasking, predictable delivery

  Reduce WIP when:
    - Lead time is too long
    - Quality is suffering
    - Too much context switching

  Increase WIP when:
    - People are frequently idle with nothing to pull
    - Handoff delays dominate (split columns help too)

The Rule:
  "If the column is at WIP limit, you cannot pull new work in."
  Options: help finish something, fix a blocker, pair with someone
EOF
}

cmd_metrics() {
    cat << 'EOF'
=== Kanban Flow Metrics ===

Lead Time:
  Time from request to delivery (customer perspective)
  Measure: date done − date entered backlog
  Target: predictable, not necessarily fast
  Use percentiles: "85% of items done in ≤ 12 days"

Cycle Time:
  Time from work started to work finished
  Measure: date done − date entered "In Progress"
  Shorter cycle time = faster feedback loop

Throughput:
  Number of items completed per time period
  Example: 15 items/week
  Track weekly for trend analysis

Cumulative Flow Diagram (CFD):
  X-axis: time, Y-axis: items count
  Bands for each column (Done, Review, In Progress, etc.)
  
  Reading the CFD:
    - Band width = WIP in that stage
    - Horizontal distance = lead time
    - Slope of Done line = throughput
    - Bands widening = bottleneck forming
    - Flat Done line = nothing finishing

Aging WIP:
  How long items have been in progress
  Flag items exceeding 85th percentile cycle time
  Old items → investigate blockers, split, or kill

Flow Efficiency:
  = Active Work Time / Total Lead Time × 100%
  Typical: 15% (85% of time is waiting!)
  World-class: 40%+
  Improvement: reduce handoffs, co-locate teams
EOF
}

cmd_signals() {
    cat << 'EOF'
=== Kanban Pull Signals ===

Card-Based (Traditional):
  Physical card attached to container/bin
  When container emptied → send card upstream → trigger production
  Card quantity = calculated from demand + lead time + safety stock
  Formula: N = (D × L × (1 + S)) / C
    N = number of kanbans
    D = daily demand
    L = lead time (days)
    S = safety factor (0.1-0.5)
    C = container quantity

Two-Bin System:
  Two containers of same part at point of use
  Use from Bin A → when empty, switch to Bin B
  Send Bin A for refill → visual and simple
  Best for: small, inexpensive, high-usage parts

Electronic Kanban (e-Kanban):
  ERP/MES system tracks consumption automatically
  Barcode scan triggers replenishment signal
  Advantages: no lost cards, real-time data, multi-site
  Disadvantage: less visual than physical

Software Kanban Pull:
  Column WIP limit IS the pull signal
  "I finished → I pull next item from Ready column"
  Ready column running low → signal to refine more items
  Replenishment meeting: regular cadence to fill Ready column

Supermarket Model:
  Fixed buffer of standard items between processes
  Downstream takes what it needs → upstream refills gap
  Like a grocery store: shelf space = kanban quantity
  Overflow = overproduction (make it visible!)
EOF
}

cmd_practices() {
    cat << 'EOF'
=== Core Kanban Practices ===

1. Visualize the Workflow
   - Make all work visible on a board
   - Include all types: features, bugs, maintenance
   - Show blocked items explicitly (flag/sticker)
   - Invisible work = unmanaged work

2. Limit Work in Progress
   - Set explicit WIP limits per column
   - "Stop starting, start finishing"
   - Creates pull system automatically
   - Makes bottlenecks painfully obvious

3. Manage Flow
   - Focus on smooth, predictable flow
   - Monitor: lead time, throughput, WIP age
   - Identify and address blockers immediately
   - Flow > utilization (idle hands OK, idle work not OK)

4. Make Policies Explicit
   - Definition of Ready: what must be true to start
   - Definition of Done: what must be true to finish
   - Pull criteria: how to choose next item
   - WIP limit violations: what happens when exceeded
   - Write policies ON the board

5. Implement Feedback Loops
   - Daily standup: walk the board right-to-left
   - Replenishment meeting: what enters the system
   - Delivery planning: what leaves the system
   - Service delivery review: monthly metrics review
   - Risk review: what could disrupt flow

6. Improve Collaboratively, Evolve Experimentally
   - Small, safe-to-fail experiments
   - Measure before and after
   - No blame culture — system problems, not people problems
   - Retrospectives focused on flow, not feelings
EOF
}

cmd_examples() {
    cat << 'EOF'
=== Kanban Implementation Examples ===

--- Software Team (6 developers) ---
Board: Backlog | Ready [3] | Dev [4] | Code Review [2] | QA [2] | Done
WIP total: 11 items max

Before kanban:
  Lead time: 18 days avg, range 3-45 days
  Throughput: 8 items/week
  Bugs in production: 5/week

After 3 months:
  Lead time: 7 days avg, range 2-12 days
  Throughput: 12 items/week (+50%)
  Bugs in production: 1/week (-80%)
  Key: WIP limit forced pairing on complex items

--- Manufacturing (Auto Parts) ---
Two-bin kanban for 200 component types
  Before: weekly MRP batch ordering
    - 15 stockouts/month
    - $2.4M average inventory
  After: two-bin pull system
    - 1 stockout/month (-93%)
    - $900K average inventory (-62%)
    - Bin sizing: 3-day supply + 1-day safety

--- IT Operations ---
Board: Request | Triage [3] | Working [5] | Verify [2] | Closed
Swimlanes: Incidents | Changes | Problems

  Before: ticket queue with no visibility
    - Average resolution: 12 days
    - 40% of tickets "lost" in queue
  After: kanban board with daily standup
    - Average resolution: 4 days
    - 0% lost tickets
    - Aging policy: anything > 5 days gets escalated
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== Kanban Health Checklist ===

Board Design:
  [ ] All work types represented on the board
  [ ] Columns match actual workflow stages
  [ ] WIP limits posted for each column
  [ ] Blocked items visually flagged
  [ ] Board updated at least daily

WIP Management:
  [ ] WIP limits respected (not routinely violated)
  [ ] Team knows what to do when at WIP limit
  [ ] No hidden work outside the board
  [ ] WIP limits reviewed and adjusted periodically

Flow:
  [ ] Lead time tracked and trending down (or stable)
  [ ] Throughput measured weekly
  [ ] Blockers identified and resolved within 24 hours
  [ ] No items aging beyond 2× average cycle time
  [ ] CFD reviewed at least monthly

Policies:
  [ ] Definition of Ready written and visible
  [ ] Definition of Done written and visible
  [ ] Pull priority rules documented
  [ ] Escalation policy for aging items
  [ ] WIP violation response defined

Cadences:
  [ ] Daily standup at the board (walk right to left)
  [ ] Replenishment meeting scheduled regularly
  [ ] Delivery review with stakeholders
  [ ] Monthly metrics review with improvement actions

Culture:
  [ ] Team pulls work (not assigned by manager)
  [ ] "Help finish" before "start new" mentality
  [ ] Problems discussed without blame
  [ ] Experiments tried and measured
  [ ] Improvements documented and shared
EOF
}

show_help() {
    cat << EOF
kanban v$VERSION — Kanban System Reference

Usage: script.sh <command>

Commands:
  intro      Kanban origins, principles, and pull system basics
  board      Board design patterns, columns, swimlanes, cards
  wip        WIP limits — setting, adjusting, enforcing
  metrics    Flow metrics: lead time, throughput, CFD
  signals    Pull signals: card, bin, electronic, software
  practices  Six core kanban practices
  examples   Implementation examples (software, mfg, IT)
  checklist  Kanban health assessment checklist
  help       Show this help
  version    Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    board)      cmd_board ;;
    wip)        cmd_wip ;;
    metrics)    cmd_metrics ;;
    signals)    cmd_signals ;;
    practices)  cmd_practices ;;
    examples)   cmd_examples ;;
    checklist)  cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "kanban v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
