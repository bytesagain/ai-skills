#!/usr/bin/env bash
set -euo pipefail

CMD="${1:-help}"
ROLE="${2:-general}"
HOURS="${3:-8}"

show_help() {
  cat <<'HELP'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📅 Calendar Planner — 日程规划工具
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Usage: bash calplan.sh <command> [role] [hours_per_day]

Commands:
  weekly     生成周计划模板（按角色/优先级/精力）
  monthly    月度计划与目标分解
  block      时间块规划（深度工作/浅层工作/休息）
  meeting    会议安排优化（议程/时长/频率）
  deadline   截止日期倒推计划（里程碑/缓冲/依赖）
  balance    工作生活平衡评估与调整建议

Options:
  role       角色 (developer/manager/designer/founder/student/general)
  hours      每日工作时长 (6/8/10/12)

Examples:
  bash calplan.sh weekly developer 8
  bash calplan.sh block founder 10
  bash calplan.sh balance manager 12

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
HELP
}

cmd_weekly() {
  local role="$1" hours="$2"
  local today
  today=$(date +%Y-%m-%d)
  local weekday
  weekday=$(date +%u)
  # Calculate Monday of current week
  local monday
  monday=$(date -d "$today - $((weekday - 1)) days" +%Y-%m-%d 2>/dev/null || date -v-"$((weekday - 1))"d +%Y-%m-%d 2>/dev/null || echo "$today")
  cat <<EOF
# 📅 Weekly Plan — Week of ${monday}

**Role:** ${role} | **Work Hours:** ${hours}h/day

---

## Weekly Overview

| Day | 🔴 Deep Work | 🟡 Meetings | 🟢 Admin | 🔵 Personal |
|-----|-------------|-------------|---------|-------------|
| Mon | ${hours}h total: | _h | _h | _h | _h |
| Tue | ${hours}h total: | _h | _h | _h | _h |
| Wed | ${hours}h total: | _h | _h | _h | _h |
| Thu | ${hours}h total: | _h | _h | _h | _h |
| Fri | ${hours}h total: | _h | _h | _h | _h |
| Sat | — | — | — | — |
| Sun | — | — | — | — |

---

## Weekly Priorities (Top 3)

| # | Priority | Status | Deadline | Est. Hours |
|---|----------|--------|----------|-----------|
| 1 | __________ | ⬜ Not started | __________ | __h |
| 2 | __________ | ⬜ Not started | __________ | __h |
| 3 | __________ | ⬜ Not started | __________ | __h |

---

## Daily Template — ${role}

### 🌅 Morning Routine (8:00-9:00)
- [ ] Review today's schedule
- [ ] Check urgent messages (15 min max)
- [ ] Set 3 daily priorities

### 🔴 Deep Work Block 1 (9:00-12:00)
\`\`\`
Focus: {{priority_1}}
No Slack/Email/Phone
Pomodoros: 🍅🍅🍅🍅🍅🍅 (6 × 25min)
\`\`\`

### 🍽️ Lunch + Break (12:00-13:00)
- Walk, rest, no screens

### 🟡 Collaboration (13:00-15:00)
- [ ] Meetings / Sync-ups
- [ ] Code reviews / Feedback
- [ ] Pair programming / Mentoring

### 🔴 Deep Work Block 2 (15:00-17:00)
\`\`\`
Focus: {{priority_2}}
Pomodoros: 🍅🍅🍅🍅 (4 × 25min)
\`\`\`

### 🟢 Wind Down (17:00-${hours}:00 adjusted)
- [ ] Reply to non-urgent messages
- [ ] Update task status
- [ ] Plan tomorrow's top 3
- [ ] Clear desk / close tabs

---

## Ideal Week Template (${role})

\`\`\`
     Mon        Tue        Wed        Thu        Fri
  ┌─────────┬─────────┬─────────┬─────────┬─────────┐
  │ 🔴 Deep │ 🔴 Deep │ 🔴 Deep │ 🔴 Deep │ 🟢 Admin│
9 │  Work   │  Work   │  Work   │  Work   │ Planning│
  │         │         │         │         │         │
  ├─────────┼─────────┼─────────┼─────────┼─────────┤
  │ 🔴 Deep │ 🟡 Sync │ 🔴 Deep │ 🟡 Sync │ 🟢 Learn│
11│  Work   │ Meeting │  Work   │ Meeting │   ing   │
  ├─────────┼─────────┼─────────┼─────────┼─────────┤
12│ 🍽️ Lunch│ 🍽️ Lunch│ 🍽️ Lunch│ 🍽️ Lunch│ 🍽️ Lunch│
  ├─────────┼─────────┼─────────┼─────────┼─────────┤
  │ 🟡 1:1s │ 🔴 Deep │ 🟡 Team │ 🔴 Deep │ 🟢 Admin│
14│         │  Work   │ Meeting │  Work   │ Review  │
  ├─────────┼─────────┼─────────┼─────────┼─────────┤
  │ 🔴 Deep │ 🔴 Deep │ 🔴 Deep │ 🔴 Deep │ 🟢 Plan │
16│  Work   │  Work   │  Work   │  Work   │ Next Wk │
  └─────────┴─────────┴─────────┴─────────┴─────────┘
\`\`\`
EOF
}

cmd_monthly() {
  local role="$1" hours="$2"
  local month year
  month=$(date +%B)
  year=$(date +%Y)
  cat <<EOF
# 📆 Monthly Plan — ${month} ${year}

**Role:** ${role}

---

## Monthly Goals (3-5)

| # | Goal | Key Results | Progress |
|---|------|------------|----------|
| 1 | __________ | KR: __________ | ░░░░░░░░░░ 0% |
| 2 | __________ | KR: __________ | ░░░░░░░░░░ 0% |
| 3 | __________ | KR: __________ | ░░░░░░░░░░ 0% |

---

## Week Breakdown

### Week 1: Focus on __________
| Priority | Task | Owner | Status |
|----------|------|-------|--------|
| P0 | __________ | __________ | ⬜ |
| P1 | __________ | __________ | ⬜ |

### Week 2: Focus on __________
| Priority | Task | Owner | Status |
|----------|------|-------|--------|
| P0 | __________ | __________ | ⬜ |
| P1 | __________ | __________ | ⬜ |

### Week 3: Focus on __________
| Priority | Task | Owner | Status |
|----------|------|-------|--------|
| P0 | __________ | __________ | ⬜ |
| P1 | __________ | __________ | ⬜ |

### Week 4: Focus on __________
| Priority | Task | Owner | Status |
|----------|------|-------|--------|
| P0 | __________ | __________ | ⬜ |
| P1 | __________ | __________ | ⬜ |

---

## Key Dates & Deadlines

| Date | Event/Deadline | Owner | Notes |
|------|---------------|-------|-------|
| __________ | __________ | __________ | __________ |

---

## Month-End Review Template

### What went well? 🎉
1. __________
2. __________

### What didn't go well? 😓
1. __________
2. __________

### What will I do differently? 🔄
1. __________
2. __________

### Key Metrics
| Metric | Target | Actual | Delta |
|--------|--------|--------|-------|
| __________ | __________ | __________ | __________ |
EOF
}

cmd_block() {
  local role="$1" hours="$2"
  cat <<EOF
# ⏰ Time Blocking Plan

**Role:** ${role} | **Daily Hours:** ${hours}h

---

## Time Block Categories

| Block Type | Color | Purpose | Best Time |
|------------|-------|---------|-----------|
| 🔴 Deep Work | Red | Complex tasks, creative work | 9-12 AM |
| 🟡 Meetings | Yellow | Sync, 1:1s, collaboration | 1-3 PM |
| 🟢 Admin | Green | Email, Slack, planning | 4-5 PM |
| 🔵 Learning | Blue | Reading, courses, research | Flexible |
| ⚪ Buffer | Gray | Overflow, unexpected tasks | Between blocks |
| 🟣 Personal | Purple | Exercise, meals, breaks | Fixed times |

---

## Recommended Distribution (${hours}h/day)

| Block | Hours | % of Day | Sessions |
|-------|-------|----------|----------|
| 🔴 Deep Work | $(echo "$hours * 40 / 100" | bc 2>/dev/null || echo "3.2")h | 40% | 2 blocks |
| 🟡 Meetings | $(echo "$hours * 20 / 100" | bc 2>/dev/null || echo "1.6")h | 20% | Max 3/day |
| 🟢 Admin | $(echo "$hours * 15 / 100" | bc 2>/dev/null || echo "1.2")h | 15% | 2 sessions |
| 🔵 Learning | $(echo "$hours * 10 / 100" | bc 2>/dev/null || echo "0.8")h | 10% | 1 block |
| ⚪ Buffer | $(echo "$hours * 15 / 100" | bc 2>/dev/null || echo "1.2")h | 15% | Gaps |

---

## Sample Day (Time Blocks)

\`\`\`
08:00 ┌────────────────────┐
      │ 🟣 Morning Routine  │ 30min
08:30 ├────────────────────┤
      │ 🟢 Plan + Triage    │ 30min
09:00 ├────────────────────┤
      │                    │
      │ 🔴 DEEP WORK #1    │ 2.5h
      │ (Most important    │
      │  task of the day)  │
      │                    │
11:30 ├────────────────────┤
      │ ⚪ Buffer           │ 30min
12:00 ├────────────────────┤
      │ 🟣 Lunch + Walk     │ 1h
13:00 ├────────────────────┤
      │ 🟡 Meeting Block    │ 2h
      │ (Stack all mtgs)   │
15:00 ├────────────────────┤
      │ ⚪ Buffer           │ 15min
15:15 ├────────────────────┤
      │ 🔴 DEEP WORK #2    │ 1.5h
      │ (Second priority)  │
16:45 ├────────────────────┤
      │ 🟢 Admin / Email    │ 45min
17:30 ├────────────────────┤
      │ 🔵 Learn / Read     │ 30min
18:00 └────────────────────┘
\`\`\`

---

## Time Blocking Rules

1. **Protect deep work** — treat it like a meeting with yourself
2. **Batch meetings** — group them in one block
3. **Buffer between blocks** — 15min minimum
4. **Process email twice** — not all day (AM + PM)
5. **Theme days** — Mon=strategy, Tue=create, Wed=collaborate...
6. **Start with energy** — hardest work during peak hours
7. **Time box** — if it doesn't fit the block, it waits
EOF
}

cmd_meeting() {
  local role="$1" hours="$2"
  cat <<EOF
# 🤝 Meeting Optimization Guide

**Role:** ${role}

---

## Meeting Types & Optimal Duration

| Meeting Type | Duration | Frequency | Attendees | Format |
|-------------|----------|-----------|-----------|--------|
| Daily standup | 15 min | Daily | Team (≤8) | Async/sync |
| 1:1 | 25 min | Weekly | 2 | Video/walk |
| Team sync | 25 min | Weekly | Team | Video |
| Sprint planning | 50 min | Bi-weekly | Team | In-person |
| Retro | 50 min | Bi-weekly | Team | In-person |
| All-hands | 50 min | Monthly | Everyone | Hybrid |
| Brainstorm | 50 min | As needed | 3-6 | Whiteboard |
| Decision review | 25 min | As needed | Stakeholders | Any |

---

## Meeting Agenda Template

### {{Meeting Name}} — {{Date}} {{Time}}

**Duration:** {{duration}} min
**Facilitator:** {{name}}
**Attendees:** {{names}}
**Goal:** {{what decision or outcome}}

| # | Topic | Owner | Time | Type |
|---|-------|-------|------|------|
| 1 | {{topic}} | {{name}} | {{min}} | ℹ️ Info / 🗳️ Decision / 💬 Discuss |
| 2 | {{topic}} | {{name}} | {{min}} | ℹ️ Info / 🗳️ Decision / 💬 Discuss |
| 3 | {{topic}} | {{name}} | {{min}} | ℹ️ Info / 🗳️ Decision / 💬 Discuss |

**Pre-read:** {{link}}

---

### Action Items

| Action | Owner | Due Date | Status |
|--------|-------|----------|--------|
| {{action}} | {{name}} | {{date}} | ⬜ |

---

## Meeting Reduction Strategies

### The "Should This Be a Meeting?" Test

\`\`\`
Is information flow ONE-WAY?
  └─ Yes → Send an email/doc/Loom video ✉️

Do we need REAL-TIME discussion?
  └─ No → Use async (Slack thread, doc comments) 💬

Are there MORE THAN 7 people?
  └─ Yes → Make it optional or split into groups 👥

Can it be resolved in < 5 minutes?
  └─ Yes → Slack message or quick call 📱

Still need a meeting?
  └─ OK, keep it SHORT and STRUCTURED ✅
\`\`\`

---

## Meeting-Free Time

| Strategy | Implementation |
|----------|---------------|
| No-meeting days | Wednesday = zero meetings |
| Focus mornings | No meetings before 12:00 |
| Meeting hours | Meetings only 13:00-16:00 |
| Core hours | Only schedule in 10:00-15:00 |
| Speedy meetings | Default 25min (not 30) |
EOF
}

cmd_deadline() {
  local role="$1" hours="$2"
  cat <<EOF
# ⏰ Deadline Reverse Planning

**Role:** ${role}

---

## Reverse Planning Template

### Project: {{project_name}}
### Final Deadline: {{deadline_date}}

---

## Milestone Breakdown

\`\`\`
Today                                          Deadline
  │                                              │
  ▼                                              ▼
  ├── M1 ──── M2 ──── M3 ──── M4 ──── Buffer ──┤
  │  Research  Design  Build   Test    20%      │
  │  (15%)    (20%)   (40%)   (20%)   buffer    │
  └─────────────────────────────────────────────┘
\`\`\`

| Milestone | % of Time | Start | End | Deliverable | Status |
|-----------|-----------|-------|-----|-------------|--------|
| M1: Research & Plan | 15% | {{date}} | {{date}} | Spec document | ⬜ |
| M2: Design & Prototype | 20% | {{date}} | {{date}} | Design mockup | ⬜ |
| M3: Build & Develop | 40% | {{date}} | {{date}} | Working version | ⬜ |
| M4: Test & Refine | 20% | {{date}} | {{date}} | Final version | ⬜ |
| Buffer | 5% | {{date}} | {{date}} | — | — |
| 🚀 Deadline | — | — | {{date}} | Delivery | ⬜ |

---

## Buffer Strategy

| Project Duration | Buffer | Reason |
|-----------------|--------|--------|
| 1 week | 1 day (20%) | Short sprints need more buffer |
| 2-4 weeks | 3-5 days (15-20%) | Standard projects |
| 1-3 months | 1-2 weeks (10-15%) | Larger projects |
| 3+ months | 2-4 weeks (10%) | Long-term projects |

---

## Dependency Map

\`\`\`
  Task A (no dependency)
    │
    ▼
  Task B (depends on A)
    │
    ├──▶ Task C (depends on B)
    │
    └──▶ Task D (depends on B)
            │
            ▼
          Task E (depends on C + D)  ← Critical Path!
\`\`\`

| Task | Depends On | Duration | Start | End | Critical? |
|------|-----------|----------|-------|-----|-----------|
| A | — | {{days}} | {{date}} | {{date}} | ⬜ |
| B | A | {{days}} | {{date}} | {{date}} | ⬜ |
| C | B | {{days}} | {{date}} | {{date}} | ⬜ |
| D | B | {{days}} | {{date}} | {{date}} | ⬜ |
| E | C, D | {{days}} | {{date}} | {{date}} | ✅ |

---

## Risk Assessment

| Risk | Probability | Impact | Mitigation | Buffer Added |
|------|------------|--------|------------|-------------|
| Scope creep | High | High | Freeze scope at M2 | +2 days |
| Technical blocker | Medium | High | Spike research at M1 | +1 day |
| Key person unavailable | Low | Medium | Cross-train by M1 | +1 day |
| External dependency delay | Medium | High | Start early, parallelize | +3 days |
EOF
}

cmd_balance() {
  local role="$1" hours="$2"
  cat <<EOF
# ⚖️ Work-Life Balance Assessment

**Role:** ${role} | **Current Work Hours:** ${hours}h/day

---

## Balance Score Card

Rate each area 1-10:

| Life Area | Score (1-10) | Ideal | Gap | Priority |
|-----------|-------------|-------|-----|----------|
| 💼 Career/Work | /10 | /10 | | |
| 💪 Physical Health | /10 | /10 | | |
| 🧠 Mental Health | /10 | /10 | | |
| 👨‍👩‍👧‍👦 Family/Relationships | /10 | /10 | | |
| 🤝 Social/Friends | /10 | /10 | | |
| 📚 Learning/Growth | /10 | /10 | | |
| 🎨 Hobbies/Creative | /10 | /10 | | |
| 💰 Financial | /10 | /10 | | |
| 🧘 Spiritual/Purpose | /10 | /10 | | |

**Overall Balance Score:** ____ / 90

---

## Time Audit (Where Does Time Go?)

### Current Weekly Time Distribution

| Category | Hours/Week | % of 168h | Ideal % | Delta |
|----------|-----------|-----------|---------|-------|
| 😴 Sleep | __h | __% | 33% (56h) | |
| 💼 Work | $((hours * 5))h | $((hours * 5 * 100 / 168))% | 30% (50h) | |
| 🏠 Chores/Errands | __h | __% | 8% (13h) | |
| 👨‍👩‍👧‍👦 Family | __h | __% | 10% (17h) | |
| 💪 Exercise | __h | __% | 4% (7h) | |
| 🤝 Social | __h | __% | 5% (8h) | |
| 📚 Learning | __h | __% | 3% (5h) | |
| 🎮 Leisure | __h | __% | 7% (12h) | |
| **Total** | **168h** | **100%** | **100%** | |

---

## Warning Signs 🚨

### Burnout Indicators (Check any that apply)

- [ ] Working regularly past ${hours} hours
- [ ] Skipping meals or exercise
- [ ] Difficulty sleeping (even when tired)
- [ ] Feeling cynical about work
- [ ] Decreased productivity despite more hours
- [ ] Neglecting relationships
- [ ] No hobbies or personal time
- [ ] Weekend work becoming normal
- [ ] Physical symptoms (headaches, back pain)
- [ ] Can't remember last vacation

**Score:** ___ / 10 checked
- 0-2: 🟢 Healthy
- 3-5: 🟡 At risk — make adjustments
- 6-8: 🔴 Burnout warning — take action now
- 9-10: 🆘 Seek support immediately

---

## Rebalancing Action Plan

### Quick Wins (This Week)

1. Set a hard stop time: __:__ PM
2. Block 1 hour for exercise 3x/week
3. Schedule one social activity
4. Define "no work" zones (bedroom, dinner table)
5. Turn off work notifications after hours

### Medium-Term (This Month)

1. Establish morning & evening routines
2. Create a weekly "personal projects" block
3. Delegate or automate 1 recurring task
4. Plan a weekend getaway or day off

### Long-Term (This Quarter)

1. Negotiate flexible work arrangements
2. Take a real vacation (5+ days)
3. Develop a hobby or skill outside work
4. Build a sustainable weekly rhythm

---

> 💡 "You can do anything, but not everything." — David Allen
EOF
}

case "$CMD" in
  weekly)   cmd_weekly "$ROLE" "$HOURS" ;;
  monthly)  cmd_monthly "$ROLE" "$HOURS" ;;
  block)    cmd_block "$ROLE" "$HOURS" ;;
  meeting)  cmd_meeting "$ROLE" "$HOURS" ;;
  deadline) cmd_deadline "$ROLE" "$HOURS" ;;
  balance)  cmd_balance "$ROLE" "$HOURS" ;;
  help|--help|-h) show_help ;;
  *)
    echo "❌ Unknown command: $CMD"
    echo "Run 'bash calplan.sh help' for usage."
    exit 1
    ;;
esac
