#!/usr/bin/env bash
set -euo pipefail

CMD="${1:-help}"
USECASE="${2:-general}"
TEAMSIZE="${3:-small}"

show_help() {
  cat <<'HELP'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📝 Notion Template Generator
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Usage: bash notion.sh <command> [use_case] [team_size]

Commands:
  workspace   工作空间整体规划（页面结构/导航/权限）
  database    数据库设计（属性/视图/关联/公式）
  dashboard   仪表盘布局（指标卡/图表/进度追踪）
  wiki        知识库Wiki结构（分类/标签/搜索优化）
  project     项目管理模板（看板/时间线/Sprint/OKR）
  personal    个人模板（日记/习惯/阅读/财务/目标）

Options:
  use_case    用途 (startup/team/freelance/student/general)
  team_size   团队规模 (solo/small/medium/large)

Examples:
  bash notion.sh workspace startup small
  bash notion.sh database team medium
  bash notion.sh personal student solo

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
HELP
}

cmd_workspace() {
  local usecase="$1" teamsize="$2"
  cat <<EOF
# 🏠 Notion Workspace Blueprint

**Use Case:** ${usecase} | **Team Size:** ${teamsize}

---

## Workspace Structure

\`\`\`
🏠 Home (Dashboard)
├── 📋 Projects
│   ├── 🔥 Active Projects (Database)
│   ├── 📦 Archive
│   └── 📝 Project Templates
├── 📚 Knowledge Base (Wiki)
│   ├── 📖 Getting Started
│   ├── 🔧 Engineering
│   ├── 📊 Marketing
│   ├── 💼 Operations
│   └── ❓ FAQ
├── 📅 Calendar & Planning
│   ├── 🗓️ Team Calendar
│   ├── 🎯 OKRs / Goals
│   └── 📊 Roadmap
├── 👥 Team
│   ├── 📞 Directory
│   ├── 🤝 Meeting Notes (Database)
│   └── 📋 SOPs & Processes
├── 📥 Inbox / Quick Capture
│   └── 🗑️ Process → Archive weekly
└── ⚙️ Settings & Meta
    ├── 🎨 Style Guide
    ├── 📐 Templates
    └── 🔒 Admin
\`\`\`

---

## Page Hierarchy Rules

| Level | Purpose | Max Items | Example |
|-------|---------|-----------|---------|
| L0 | Workspace home | 1 | 🏠 Home |
| L1 | Major areas | 5-7 | 📋 Projects |
| L2 | Categories / DBs | 3-5 per L1 | 🔥 Active |
| L3 | Individual pages | Unlimited | Project X |

> ⚠️ Rule: Never go deeper than L3. Use linked databases instead.

---

## Permission Structure

| Area | Team | Guests | Public |
|------|------|--------|--------|
| Home | Full | — | — |
| Projects | Full | Comment | — |
| Wiki | Full | Read | Optional |
| Team | Full | — | — |
| Meeting Notes | Full | — | — |
| Admin | Admin only | — | — |

---

## Sidebar Organization Tips

1. **Pin** top 5 most-used pages
2. **Favorite** frequently accessed databases
3. Use **divider pages** (blank pages named "───────")
4. Create a **Quick Links** page for bookmarks
5. Use **icons consistently** for visual scanning

---

## Database Connections

\`\`\`
Projects ←──── Tasks (Relation)
    ↕              ↕
Team Members   Time Logs
    ↕
Meeting Notes
\`\`\`

> 💡 Use Relations + Rollups to create powerful cross-database insights.
EOF
}

cmd_database() {
  local usecase="$1" teamsize="$2"
  cat <<EOF
# 🗄️ Notion Database Design

**Use Case:** ${usecase} | **Team Size:** ${teamsize}

---

## Database: Tasks / Projects

### Properties (属性设计)

| Property | Type | Options / Config |
|----------|------|-----------------|
| Task Name | Title | — |
| Status | Select | 📥 Inbox, 🏗️ In Progress, 👀 Review, ✅ Done, ❌ Canceled |
| Priority | Select | 🔴 Urgent, 🟠 High, 🟡 Medium, 🟢 Low |
| Assignee | Person | Multi-select for collaboration |
| Due Date | Date | Include end date + reminder |
| Project | Relation | → Projects database |
| Tags | Multi-select | Feature, Bug, Improvement, Research |
| Effort | Select | XS (1h), S (half-day), M (1d), L (2-3d), XL (1w+) |
| Sprint | Select | Sprint 1, Sprint 2, ... |
| Created | Created time | Auto |
| Updated | Last edited time | Auto |
| Progress | Formula | \`if(prop("Status") == "Done", 100, if(prop("Status") == "In Progress", 50, 0))\` |
| Overdue | Formula | \`if(and(prop("Due Date") < now(), prop("Status") != "Done"), true, false)\` |

---

### Views (视图设计)

| View | Type | Filter | Sort | Group |
|------|------|--------|------|-------|
| 📋 All Tasks | Table | None | Due Date ↑ | Status |
| 🎯 My Tasks | Table | Assignee = Me | Priority ↓ | Status |
| 📌 Kanban | Board | Status ≠ Canceled | Priority ↓ | — |
| 📅 Calendar | Calendar | Has Due Date | — | — |
| 🔥 Overdue | Table | Overdue = true | Due Date ↑ | Priority |
| 📊 By Project | Table | None | Project | Project |

---

## Database: CRM / Contacts

### Properties

| Property | Type | Purpose |
|----------|------|---------|
| Name | Title | Contact name |
| Company | Text | Organization |
| Email | Email | Primary email |
| Phone | Phone | Primary phone |
| Status | Select | Lead, Prospect, Customer, Churned |
| Source | Select | Referral, Website, Event, Cold |
| Deal Value | Number (¥) | Expected revenue |
| Last Contact | Date | Most recent interaction |
| Notes | Relation | → Notes database |
| Next Action | Text | Follow-up reminder |

---

## Notion Formula Cookbook

\`\`\`
// Days until due
dateBetween(prop("Due Date"), now(), "days")

// Status emoji
if(prop("Status") == "Done", "✅",
  if(prop("Status") == "In Progress", "🏗️",
    if(prop("Status") == "Review", "👀", "📥")))

// Progress bar (visual)
slice("██████████", 0, round(prop("Progress") / 10)) +
slice("░░░░░░░░░░", 0, 10 - round(prop("Progress") / 10)) +
" " + format(prop("Progress")) + "%"

// Overdue warning
if(and(not empty(prop("Due Date")),
       prop("Due Date") < now(),
       prop("Status") != "Done"),
   "⚠️ OVERDUE", "")
\`\`\`
EOF
}

cmd_dashboard() {
  local usecase="$1" teamsize="$2"
  cat <<EOF
# 📊 Notion Dashboard Layout

**Use Case:** ${usecase} | **Team Size:** ${teamsize}

---

## Dashboard Structure

\`\`\`
┌─────────────────────────────────────────────┐
│  🏠 Dashboard — {{team_name}}               │
│  Last updated: {{auto_date}}                │
├─────────────────────────────────────────────┤
│                                             │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐    │
│  │ 📋 Tasks  │ │ ✅ Done   │ │ ⚠️ Overdue│   │
│  │   {{n}}   │ │   {{n}}   │ │   {{n}}   │   │
│  │  Active   │ │ This Week │ │  Urgent   │   │
│  └──────────┘ └──────────┘ └──────────┘    │
│                                             │
│  ┌──────────────────┐ ┌──────────────────┐  │
│  │ 🔥 Priority Tasks │ │ 📅 Upcoming      │  │
│  │ (Linked DB View) │ │ (Calendar View)  │  │
│  │                  │ │                  │  │
│  │ [Filtered:       │ │ Next 7 days      │  │
│  │  Priority=High,  │ │                  │  │
│  │  Status≠Done]    │ │                  │  │
│  └──────────────────┘ └──────────────────┘  │
│                                             │
│  ┌──────────────────────────────────────┐   │
│  │ 📌 Active Projects (Board View)      │   │
│  │ [Grouped by Status]                 │   │
│  │                                      │   │
│  │ Planning → In Progress → Review → Done   │
│  └──────────────────────────────────────┘   │
│                                             │
│  ┌──────────────────┐ ┌──────────────────┐  │
│  │ 📝 Recent Notes  │ │ 🔗 Quick Links   │  │
│  │ (Last 5 entries) │ │                  │  │
│  │                  │ │ • Slack          │  │
│  │                  │ │ • GitHub         │  │
│  │                  │ │ • Figma          │  │
│  │                  │ │ • Calendar       │  │
│  └──────────────────┘ └──────────────────┘  │
└─────────────────────────────────────────────┘
\`\`\`

---

## How to Build This Dashboard

### Step 1: Create Metric Cards (Callout Blocks)

Use **Callout blocks** in a 3-column layout:

> 📋 **Active Tasks**
> **{{count}}** tasks in progress

### Step 2: Add Linked Database Views

1. Type \`/linked\` and select "Linked view of database"
2. Choose your Tasks database
3. Apply filters and select view type
4. Resize to fit layout

### Step 3: Use Column Layout

- Drag blocks side by side to create columns
- Notion supports up to 5 columns
- Use **dividers** (\`/divider\`) between sections

---

## Dashboard Templates by Role

| Role | Key Widgets |
|------|------------|
| CEO/Founder | OKRs, Revenue, Team velocity, Roadmap |
| PM | Sprint board, Backlog, Bug count, Timeline |
| Engineer | My tasks, PR status, Deploy log, Docs |
| Marketing | Campaign tracker, Content calendar, Metrics |
| Sales | Pipeline, Deals closing, Revenue forecast |
| Personal | Habits, Goals, Reading list, Journal |
EOF
}

cmd_wiki() {
  local usecase="$1" teamsize="$2"
  cat <<EOF
# 📚 Knowledge Base / Wiki Structure

**Use Case:** ${usecase} | **Team Size:** ${teamsize}

---

## Wiki Architecture

\`\`\`
📚 Knowledge Base
├── 🚀 Getting Started
│   ├── Welcome to {{company}}
│   ├── Tools & Access Setup
│   ├── Team Directory
│   └── FAQ — New Joiners
│
├── 🔧 Engineering
│   ├── Architecture Overview
│   ├── Development Setup
│   ├── Code Standards
│   ├── Deployment Guide
│   ├── API Documentation
│   └── Troubleshooting
│
├── 📊 Product & Design
│   ├── Product Vision & Strategy
│   ├── User Personas
│   ├── Design System
│   └── Feature Specs
│
├── 💼 Operations
│   ├── HR Policies
│   ├── Finance & Reimbursement
│   ├── Office / Remote Guide
│   └── Vendor Management
│
├── 📈 Marketing & Sales
│   ├── Brand Guidelines
│   ├── Content Strategy
│   ├── Sales Playbook
│   └── Case Studies
│
└── 📋 Processes (SOPs)
    ├── Onboarding Checklist
    ├── Incident Response
    ├── Release Process
    └── Meeting Cadences
\`\`\`

---

## Wiki Database Properties

| Property | Type | Purpose |
|----------|------|---------|
| Title | Title | Article name |
| Category | Select | Engineering, Product, Ops, etc. |
| Tags | Multi-select | Searchable keywords |
| Owner | Person | Content maintainer |
| Status | Select | Draft, Published, Needs Update, Archived |
| Last Reviewed | Date | Content freshness tracking |
| Target Audience | Multi-select | All, Engineering, New Hires, Managers |

---

## Content Freshness Rules

| Status | Meaning | Action |
|--------|---------|--------|
| 🟢 Current | Reviewed in last 3 months | No action |
| 🟡 Needs Review | 3-6 months since review | Schedule review |
| 🔴 Stale | 6+ months since review | Urgent update or archive |

---

## Writing Guidelines

1. **Title** — Clear, searchable (verb + noun: "Setting up Docker")
2. **TL;DR** — 2-3 sentence summary at top
3. **Prerequisites** — What reader needs before starting
4. **Steps** — Numbered, with screenshots
5. **FAQ** — Common questions at bottom
6. **Related** — Link to related articles
7. **Owner** — Who to ask for updates
EOF
}

cmd_project() {
  local usecase="$1" teamsize="$2"
  cat <<EOF
# 🎯 Project Management Template

**Use Case:** ${usecase} | **Team Size:** ${teamsize}

---

## Kanban Board Setup

\`\`\`
┌────────────┬────────────┬────────────┬────────────┬────────────┐
│  📥 Backlog │ 🏗️ In Prog │  👀 Review  │  ✅ Done   │  ❌ Cancel  │
├────────────┼────────────┼────────────┼────────────┼────────────┤
│            │            │            │            │            │
│ [Task 5]   │ [Task 3]   │ [Task 1]   │ [Task 0]   │            │
│ [Task 6]   │ [Task 4]   │ [Task 2]   │            │            │
│ [Task 7]   │            │            │            │            │
│            │            │            │            │            │
│ WIP: ∞     │ WIP: 3     │ WIP: 2     │ WIP: ∞     │            │
└────────────┴────────────┴────────────┴────────────┴────────────┘
\`\`\`

---

## Sprint Template

### Sprint {{number}} — {{date_range}}

**Goal:** {{sprint_goal}}

| Category | Count | Story Points |
|----------|-------|-------------|
| 📋 Total | {{n}} | {{sp}} |
| ✅ Done | {{n}} | {{sp}} |
| 🏗️ In Progress | {{n}} | {{sp}} |
| 📥 Remaining | {{n}} | {{sp}} |
| Progress | | {{percent}}% |

---

## OKR Template

### Q{{quarter}} {{year}} OKRs

**Objective 1:** {{objective}}

| Key Result | Target | Current | Progress |
|------------|--------|---------|----------|
| KR 1.1: {{kr}} | {{target}} | {{current}} | {{bar}} {{%}} |
| KR 1.2: {{kr}} | {{target}} | {{current}} | {{bar}} {{%}} |
| KR 1.3: {{kr}} | {{target}} | {{current}} | {{bar}} {{%}} |

---

## Project Charter Template

| Field | Value |
|-------|-------|
| **Project Name** | {{name}} |
| **Owner** | {{owner}} |
| **Stakeholders** | {{stakeholders}} |
| **Start Date** | {{start}} |
| **Target Date** | {{target}} |
| **Status** | 🟢 On Track / 🟡 At Risk / 🔴 Blocked |

### Problem Statement
> {{what problem are we solving?}}

### Success Criteria
1. {{metric_1}}
2. {{metric_2}}
3. {{metric_3}}

### Scope
**In Scope:** {{inclusions}}
**Out of Scope:** {{exclusions}}

### Milestones
| Milestone | Target Date | Status |
|-----------|------------|--------|
| M1: {{name}} | {{date}} | ⬜ |
| M2: {{name}} | {{date}} | ⬜ |
| M3: {{name}} | {{date}} | ⬜ |
| M4: Launch | {{date}} | ⬜ |

### Risks
| Risk | Probability | Impact | Mitigation |
|------|------------|--------|------------|
| {{risk}} | H/M/L | H/M/L | {{mitigation}} |
EOF
}

cmd_personal() {
  local usecase="$1" teamsize="$2"
  cat <<EOF
# 🌟 Personal Notion Templates

---

## 1. Daily Journal 日记模板

### {{date}} — {{day_of_week}}

**Mood:** 😊😐😔😡🤯 (pick one)
**Energy:** ⚡⚡⚡⚡⚡ (1-5)
**Sleep:** {{hours}}h (quality: ⭐⭐⭐)

#### 🌅 Morning Intentions
- Today I will focus on: __________
- Top 3 priorities:
  1. __________
  2. __________
  3. __________

#### 📝 Notes & Reflections
> __________

#### 🌙 Evening Review
- What went well: __________
- What could improve: __________
- Grateful for: __________

---

## 2. Habit Tracker 习惯追踪

| Habit | Mon | Tue | Wed | Thu | Fri | Sat | Sun | Rate |
|-------|-----|-----|-----|-----|-----|-----|-----|------|
| 🏃 Exercise | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | /7 |
| 📚 Read 30min | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | /7 |
| 💧 Water 8 cups | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | /7 |
| 🧘 Meditate | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | /7 |
| 📝 Journal | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | /7 |
| 😴 Sleep by 11 | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | /7 |

---

## 3. Reading List 阅读清单

| Book | Author | Status | Rating | Start | End | Notes |
|------|--------|--------|--------|-------|-----|-------|
| {{title}} | {{author}} | 📖 Reading | — | {{date}} | — | |
| {{title}} | {{author}} | ✅ Done | ⭐⭐⭐⭐ | {{date}} | {{date}} | |
| {{title}} | {{author}} | 📚 To Read | — | — | — | |

### Reading Stats
- 📚 Total books this year: {{count}}
- 📖 Currently reading: {{count}}
- ⭐ Average rating: {{avg}}
- 📄 Pages read: {{count}}

---

## 4. Finance Tracker 财务追踪

### Monthly Budget — {{month}} {{year}}

| Category | Budget | Spent | Remaining | % |
|----------|--------|-------|-----------|---|
| 🏠 Housing | ¥{{}} | ¥{{}} | ¥{{}} | {{}}% |
| 🍽️ Food | ¥{{}} | ¥{{}} | ¥{{}} | {{}}% |
| 🚗 Transport | ¥{{}} | ¥{{}} | ¥{{}} | {{}}% |
| 🛒 Shopping | ¥{{}} | ¥{{}} | ¥{{}} | {{}}% |
| 🎮 Entertainment | ¥{{}} | ¥{{}} | ¥{{}} | {{}}% |
| 📚 Education | ¥{{}} | ¥{{}} | ¥{{}} | {{}}% |
| 💰 Savings | ¥{{}} | ¥{{}} | ¥{{}} | {{}}% |
| **Total** | **¥{{}}** | **¥{{}}** | **¥{{}}** | |

---

## 5. Annual Goals 年度目标

### {{year}} Goals

| Area | Goal | Key Actions | Q1 | Q2 | Q3 | Q4 |
|------|------|-------------|----|----|----|----|
| 💼 Career | {{goal}} | {{actions}} | ⬜ | ⬜ | ⬜ | ⬜ |
| 💪 Health | {{goal}} | {{actions}} | ⬜ | ⬜ | ⬜ | ⬜ |
| 📚 Learning | {{goal}} | {{actions}} | ⬜ | ⬜ | ⬜ | ⬜ |
| 💰 Finance | {{goal}} | {{actions}} | ⬜ | ⬜ | ⬜ | ⬜ |
| 🤝 Relationships | {{goal}} | {{actions}} | ⬜ | ⬜ | ⬜ | ⬜ |
| 🎨 Creative | {{goal}} | {{actions}} | ⬜ | ⬜ | ⬜ | ⬜ |
EOF
}

case "$CMD" in
  workspace) cmd_workspace "$USECASE" "$TEAMSIZE" ;;
  database)  cmd_database "$USECASE" "$TEAMSIZE" ;;
  dashboard) cmd_dashboard "$USECASE" "$TEAMSIZE" ;;
  wiki)      cmd_wiki "$USECASE" "$TEAMSIZE" ;;
  project)   cmd_project "$USECASE" "$TEAMSIZE" ;;
  personal)  cmd_personal "$USECASE" "$TEAMSIZE" ;;
  help|--help|-h) show_help ;;
  *)
    echo "❌ Unknown command: $CMD"
    echo "Run 'bash notion.sh help' for usage."
    exit 1
    ;;
esac
