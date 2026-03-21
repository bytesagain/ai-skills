#!/usr/bin/env bash
# kaizen — Continuous Improvement Reference
set -euo pipefail
VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Kaizen (改善) — Continuous Improvement ===

Kaizen means "change for the better" in Japanese.
Core belief: every process can be improved, and everyone
should be involved in making improvements.

Philosophy:
  - Small, incremental improvements every day
  - Respect for people at all levels
  - Go see the actual work (gemba)
  - Use data and facts, not opinions
  - Standardize before improving
  - Eliminate waste (muda), overburden (muri), unevenness (mura)

Types of Kaizen:
  Point Kaizen      Quick fix at a single workstation
    Duration: minutes to hours
    Example: rearrange tools to reduce reaching

  System Kaizen     Improve flow across multiple processes
    Duration: 3-5 day event
    Example: redesign material flow in a department

  Line Kaizen       Improve value stream end-to-end
    Duration: weeks to months
    Example: transform entire production line layout

  Flow Kaizen       Cross-functional value stream improvement
    Duration: months
    Example: order-to-delivery process redesign

Key Principles:
  1. Good processes bring good results
  2. Go see for yourself (genchi genbutsu)
  3. Speak with data, manage by facts
  4. Take action to contain and correct root causes
  5. Work as a team
  6. Kaizen is everybody's business
EOF
}

cmd_event() {
    cat << 'EOF'
=== Kaizen Event (Rapid Improvement) ===

A focused, team-based improvement event, typically 3-5 days.
Also called: kaizen blitz, kaizen workshop, rapid improvement event.

Before the Event (2-4 weeks prior):
  Week -4: Select project, define scope, set targets
  Week -3: Form team (5-8 people, cross-functional)
  Week -2: Collect baseline data, map current process
  Week -1: Prepare supplies, schedule, logistics
  
  Team composition:
    - Process owner (sponsor)
    - Facilitator (lean coach)
    - 3-5 workers from the process
    - 1-2 outsiders (fresh eyes)
    - Support: maintenance, engineering, IT as needed

During the Event:
  Day 1 (Monday): Training + Current State
    AM: Lean/kaizen training, team charter, scope review
    PM: Go to gemba, observe process, collect data
    End: Document current state, confirm problems

  Day 2 (Tuesday): Analyze + Root Cause
    AM: Analyze data, identify waste, fishbone/5 Why
    PM: Brainstorm improvements, prioritize ideas
    End: Select top improvements to implement

  Day 3 (Wednesday): Implement
    AM: Start making changes (move equipment, revise layout)
    PM: Continue implementation, test changes
    End: Trial run of new process

  Day 4 (Thursday): Refine + Test
    AM: Run new process, collect data, adjust
    PM: Write new standard work, create visual controls
    End: Train affected workers

  Day 5 (Friday): Report Out
    AM: Final data collection, before/after comparison
    PM: Present results to management (report out)
    End: Celebrate! Create 30-day follow-up action list

After the Event (30-90 days):
  - Complete remaining action items (30-day list)
  - Monitor metrics weekly
  - Sustain changes (audit at 30, 60, 90 days)
  - Share results organization-wide
  - Recognize team contributions
EOF
}

cmd_pdca() {
    cat << 'EOF'
=== PDCA — Plan-Do-Check-Act ===

Also known as the Deming Cycle or Shewhart Cycle.
The foundation of all continuous improvement.

PLAN:
  Define the problem clearly
  Analyze the current situation (data!)
  Identify root causes
  Develop a plan for improvement
  Set measurable targets
  Define who, what, when, where

  Questions:
    What is the problem?
    What data do we have?
    What is the root cause?
    What will we try?
    How will we measure success?

DO:
  Implement the plan on a small scale (pilot)
  Document what was done and any deviations
  Collect data during implementation
  
  Key: start small! Don't change everything at once.
  A pilot is a safe-to-fail experiment.

CHECK:
  Compare results to targets
  Analyze the data — did it work?
  What worked? What didn't?
  Were there unexpected effects?
  
  Be honest! Negative results are still learning.
  Check = study (some call it PDSA: Plan-Do-Study-Act)

ACT:
  If it worked → standardize and deploy widely
  If it didn't → go back to Plan with new knowledge
  If partially → adjust and run another PDCA cycle
  
  Standardize: update SOPs, train people, set controls
  Then start the next PDCA cycle (it never ends!)

PDCA vs DMAIC:
  PDCA: simple, quick, daily use, everyone can do it
  DMAIC: structured, data-heavy, projects, needs training
  PDCA is the heartbeat of kaizen
  DMAIC is for complex, cross-functional problems
  Use PDCA inside DMAIC (each phase uses Plan-Do-Check-Act)
EOF
}

cmd_gemba() {
    cat << 'EOF'
=== Gemba Walk ===

Gemba (現場) = "the real place" — where work actually happens.
A gemba walk is a structured visit to observe processes firsthand.

Purpose:
  - See the actual work, not reports about work
  - Build relationships with frontline workers
  - Identify waste and improvement opportunities
  - Show respect by being present

How to Do a Gemba Walk:
  1. Go to the workplace (not a conference room)
  2. Observe the actual process (watch, don't assume)
  3. Ask questions with curiosity (not judgment)
  4. Listen to the people who do the work
  5. Take notes on what you see
  6. Follow up on issues found

Questions to Ask:
  "Can you walk me through what you're doing?"
  "What makes this task difficult?"
  "What would you change if you could?"
  "How do you know if you're doing it right?"
  "What wastes your time?"
  "What tools or information are you missing?"

What to Look For (8 Wastes):
  - Waiting (people standing idle, queues building)
  - Motion (reaching, bending, walking far)
  - Transportation (materials moving unnecessary distances)
  - Overprocessing (doing more than customer needs)
  - Inventory (excess WIP, piled-up materials)
  - Defects (rework stations, scrap bins)
  - Overproduction (making ahead of demand)
  - Unused talent (people doing tasks below their skill)

Rules for Leaders:
  DO: Listen, ask open questions, show respect
  DO: Take action on what you learn
  DO: Go regularly (not just once)
  DON'T: Criticize or blame workers
  DON'T: Give orders or "fix" things on the spot
  DON'T: Treat it as an audit or inspection
  
  "If you want to know, go to gemba."
  — Taiichi Ohno
EOF
}

cmd_a3() {
    cat << 'EOF'
=== A3 Problem Solving ===

A structured problem-solving report on one A3-sized sheet of paper
(11×17 inches / 297×420mm). Forces concise, visual thinking.

Left Side (Problem Understanding):
┌─────────────────────────────────┐
│ 1. TITLE / THEME               │
│    Clear problem statement      │
├─────────────────────────────────┤
│ 2. BACKGROUND / CONTEXT        │
│    Why is this important?       │
│    Business impact, customer    │
│    impact, strategic alignment  │
├─────────────────────────────────┤
│ 3. CURRENT CONDITION            │
│    Data, process map, metrics   │
│    What is happening now?       │
│    Use visuals: charts, maps    │
├─────────────────────────────────┤
│ 4. ROOT CAUSE ANALYSIS          │
│    5 Why, fishbone, data        │
│    Why is the gap occurring?    │
└─────────────────────────────────┘

Right Side (Solution & Follow-up):
┌─────────────────────────────────┐
│ 5. TARGET CONDITION             │
│    What should it look like?    │
│    Specific, measurable target  │
├─────────────────────────────────┤
│ 6. COUNTERMEASURES              │
│    What actions will we take?   │
│    Who, what, when for each     │
├─────────────────────────────────┤
│ 7. IMPLEMENTATION PLAN          │
│    Timeline, milestones         │
│    Gantt chart or action list   │
├─────────────────────────────────┤
│ 8. FOLLOW-UP / RESULTS          │
│    How will we check success?   │
│    Actual vs target metrics     │
│    Next steps / new PDCA cycle  │
└─────────────────────────────────┘

A3 Thinking Process:
  - Tell the story logically (left to right, top to bottom)
  - Use data and visuals, not paragraphs of text
  - Iterate: draft → discuss → revise → discuss → finalize
  - The conversation IS the value (not just the paper)
  - Mentor asks questions, doesn't give answers
EOF
}

cmd_daily() {
    cat << 'EOF'
=== Daily Kaizen ===

Daily kaizen = small improvements made by everyone, every day.
Not events or projects — habits and culture.

Suggestion System (Kaizen Teian):
  - Simple form: What? Why? How? (one-liner OK)
  - Goal: quantity over quality (build the habit)
  - Implement quickly (80% within 1 week)
  - Recognize ALL suggestions (even small ones)
  - Toyota target: 10+ suggestions per employee per year
  - Track: submitted → reviewed → implemented → recognized

Daily Huddle / Stand-up:
  Duration: 5-15 minutes, at the workplace
  Agenda:
    1. Yesterday: any problems? resolved?
    2. Today: plan, priorities, concerns
    3. Improvements: any ideas? any completed?
    4. Safety: any near-misses or hazards?
  Visual board: metrics, action items, improvement ideas

Visual Management Board:
  ┌──────────┬──────────┬──────────┐
  │ SAFETY   │ QUALITY  │ DELIVERY │
  │ Days     │ Defect   │ On-time  │
  │ without  │ rate     │ %        │
  │ incident │          │          │
  ├──────────┼──────────┼──────────┤
  │ COST     │ PEOPLE   │ KAIZEN   │
  │ OEE /    │ Training │ Ideas    │
  │ Scrap    │ Attendance│ thisweek│
  └──────────┴──────────┴──────────┘

  Red/green indicators for at-a-glance status
  Updated daily by the team

Before/After Photos:
  Take a photo before ANY change
  Take a photo after
  Post side-by-side on the improvement board
  Powerful motivator and evidence of progress

One-Point Lesson (OPL):
  Single-page training document
  Topic: one specific skill, tip, or fix
  Format: diagram + 3-5 bullet points
  Written by workers, for workers
  Posted at the workstation where it applies
EOF
}

cmd_examples() {
    cat << 'EOF'
=== Kaizen Examples ===

--- 5S Kaizen: Tool Storage ---
Before: Technicians search 10 min/day for tools
Kaizen: Shadow board + color coding + labeled bins
After:  Search time < 1 min/day
Investment: $200 in boards and labels
Savings: 9 min/day × 250 days × $30/hr = $1,125/year per tech

--- Setup Time Reduction ---
Before: Machine changeover takes 45 minutes
Kaizen event (3 days):
  Day 1: Filmed changeover, separated internal/external
  Day 2: Moved external tasks before shutdown, built preset jigs
  Day 3: Practiced new sequence, created standard work
After:  Changeover in 12 minutes (73% reduction)
Result: 2 extra production runs per day

--- Walking Distance Reduction ---
Before: Operator walks 2.3 km per shift
Kaizen: Rearranged workstation layout (U-shape cell)
         Moved parts bins to point of use
         Added gravity feed for incoming components
After:  Walking distance 400m per shift (83% reduction)
Bonus:  Cycle time reduced 15% due to less motion waste

--- Quality Improvement (Daily Kaizen) ---
Suggestion: "Label on Part B always peels off during assembly"
Root cause: label adhesive doesn't stick to oily surface
Fix: Added cleaning wipe step before labeling (poka-yoke)
Result: Label defects dropped from 5/day to 0
Time to implement: 30 minutes

--- Office Kaizen: Report Generation ---
Before: Monthly report takes 8 hours (copy-paste from 6 systems)
Kaizen: Built Excel macro to pull data automatically
After:  Report takes 45 minutes (90% reduction)
Bonus:  Fewer copy-paste errors (quality improvement too)
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== Kaizen Event Checklist ===

Pre-Event (2-4 weeks before):
  [ ] Problem/opportunity clearly defined
  [ ] Scope boundaries set (in/out)
  [ ] Measurable targets established
  [ ] Team selected (5-8 people, cross-functional)
  [ ] Team members' schedules cleared for event duration
  [ ] Baseline data collected (current performance)
  [ ] Current state process map drafted
  [ ] Supplies prepared (sticky notes, markers, flip charts)
  [ ] Room reserved, meals/snacks arranged
  [ ] Management support confirmed (sponsor)

During Event:
  [ ] Team charter reviewed and agreed
  [ ] Current state observed at gemba (not from reports)
  [ ] Data analyzed and root causes identified
  [ ] Ideas brainstormed (quantity before quality)
  [ ] Solutions prioritized (impact vs effort)
  [ ] Changes implemented (not just planned)
  [ ] New process tested and adjusted
  [ ] Standard work documented for new process
  [ ] Before/after data compared
  [ ] Results presented to management (report out)

Post-Event (30-90 days):
  [ ] 30-day action items assigned with owners and dates
  [ ] Weekly follow-up on open action items
  [ ] Metrics tracked weekly (sustaining gains?)
  [ ] 30-day audit completed
  [ ] 60-day audit completed
  [ ] 90-day audit completed
  [ ] Results shared with broader organization
  [ ] Team recognized for contributions
  [ ] Lessons learned captured
  [ ] Next kaizen opportunity identified
EOF
}

show_help() {
    cat << EOF
kaizen v$VERSION — Continuous Improvement Reference

Usage: script.sh <command>

Commands:
  intro      Kaizen philosophy, types, and principles
  event      Kaizen event planning and execution guide
  pdca       Plan-Do-Check-Act improvement cycle
  gemba      Gemba walk — observation at the workplace
  a3         A3 problem solving report format
  daily      Daily kaizen — suggestions, huddles, visual mgmt
  examples   Real-world kaizen examples and results
  checklist  Kaizen event preparation and follow-up checklist
  help       Show this help
  version    Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    event)      cmd_event ;;
    pdca)       cmd_pdca ;;
    gemba)      cmd_gemba ;;
    a3)         cmd_a3 ;;
    daily)      cmd_daily ;;
    examples)   cmd_examples ;;
    checklist)  cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "kaizen v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
