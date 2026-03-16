---
version: "2.0.0"
name: Agent Ops Framework
description: "Production-grade multi-agent team orchestration framework. Define agent roles, task pipelines, quality gates, and monitoring dashboards. Inspired by Google Vertex AI, Microsoft AutoGen, CrewAI, and Anthropic agent patterns. Features: role-based agent registry, task lifecycle (backlog→assigned→in-progress→review→done→deployed), structured handoffs with context passing, quality gates before promotion, centralized state store (single JSON source of truth), quota/budget management, cron-based monitoring with alerts, rollback capability, and human-in-the-loop approval points. Use when: (1) managing 3+ specialized agents on a project, (2) building CI/CD-style pipelines for content or code, (3) tracking task progress across multiple agents, (4) enforcing quality standards before deployment, (5) monitoring agent performance and output quality, (6) managing rate limits and quotas across accounts. multi-agent orchestration, team management, task pipeline, quality assurance, agent coordination, project management, CI/CD, workflow automation, monitoring, alerting. Triggers on: agent ops framework."
author: BytesAgain
---

# Agent Ops Framework

Production-grade multi-agent team orchestration for OpenClaw projects.

## Why This Framework?

Running multiple agents without structure leads to:
- ❌ Conflicting data (3 different lists say different things)
- ❌ No quality gates (broken skills get published)
- ❌ No accountability (who did what?)
- ❌ No visibility (what's the current status?)

This framework fixes all of that.

## Architecture

```
┌─────────────────────────────────────────────┐
│  👑 ORCHESTRATOR (Main Session)             │
│  - Receives human requests                  │
│  - Makes decisions, delegates tasks          │
│  - Reviews reports, approves promotions      │
│  - NEVER does implementation work           │
├─────────────────────────────────────────────┤
│                                             │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐    │
│  │ 🔨 DEV  │→│ ✅ QA   │→│ 📦 DEPLOY│    │
│  │ Agent   │  │ Agent   │  │ Agent    │    │
│  └─────────┘  └─────────┘  └─────────┘    │
│       ↑                          │          │
│       │    ┌──────────┐          ↓          │
│       └────│ 📊 MON   │←────────┘          │
│            │ Agent    │                     │
│            └──────────┘                     │
│                                             │
│  ┌──────────────────────────────────┐       │
│  │  💾 STATE STORE (state.json)     │       │
│  │  Single source of truth          │       │
│  │  All agents read/write here      │       │
│  └──────────────────────────────────┘       │
└─────────────────────────────────────────────┘
```

## Quick Start

### 1. Initialize Project
```bash
bash scripts/ops.sh init --project "my-project" --state-dir /path/to/state
```

### 2. Register Agents
```bash
bash scripts/ops.sh agent add --name "dev" --role "developer" --desc "Builds features"
bash scripts/ops.sh agent add --name "qa" --role "reviewer" --desc "Tests and validates"
bash scripts/ops.sh agent add --name "deploy" --role "deployer" --desc "Ships to production"
bash scripts/ops.sh agent add --name "monitor" --role "observer" --desc "Tracks metrics"
```

### 3. Create Tasks
```bash
bash scripts/ops.sh task add --id "SKILL-001" --title "Build chart-generator v2" \
  --assign "dev" --priority "high" --pipeline "dev→qa→deploy"
```

### 4. Move Tasks Through Pipeline
```bash
bash scripts/ops.sh task move --id "SKILL-001" --to "in-progress"
bash scripts/ops.sh task move --id "SKILL-001" --to "review" --output "/path/to/deliverable"
bash scripts/ops.sh task move --id "SKILL-001" --to "done" --approved-by "qa"
bash scripts/ops.sh task move --id "SKILL-001" --to "deployed" --deploy-ref "v2.0.0"
```

### 5. Dashboard
```bash
bash scripts/ops.sh dashboard
bash scripts/ops.sh dashboard --format html > report.html
```

### 6. Monitor (Cron)
```bash
bash scripts/ops.sh monitor --check-stale --check-quota --alert-to /tmp/alerts.log
```

## Task Lifecycle

```
BACKLOG → ASSIGNED → IN-PROGRESS → REVIEW → DONE → DEPLOYED
   │          │           │           │        │        │
   │          │           │           ↓        │        │
   │          │           │        REJECTED    │        │
   │          │           │           │        │        │
   │          │           ←───────────┘        │        │
   │          │                                │        │
   └──────────┴────────── CANCELLED ←──────────┘        │
                                                        │
                                              ROLLED-BACK←┘
```

## Quality Gates

Each transition can have gates:

| Transition | Gate | Rule |
|---|---|---|
| in-progress → review | Deliverable exists | File/dir must be present |
| review → done | QA approved | qa agent must sign off |
| done → deployed | Deploy success | Script exit code 0 |
| deployed → rolled-back | Rollback trigger | Manual or alert-based |

## State Store Schema

All state lives in one JSON file (`state.json`):

```json
{
  "project": "bytesagain-skills",
  "created": "2026-03-12T06:00:00Z",
  "agents": {
    "dev": {"role": "developer", "tasks_completed": 20, "last_active": "..."},
    "qa": {"role": "reviewer", "tasks_completed": 15, "last_active": "..."},
    "deploy": {"role": "deployer", "tasks_completed": 10, "last_active": "..."}
  },
  "tasks": {
    "SKILL-001": {
      "title": "Build chart-generator v2",
      "status": "deployed",
      "assigned": "dev",
      "pipeline": ["dev", "qa", "deploy"],
      "priority": "high",
      "history": [
        {"status": "assigned", "at": "...", "by": "orchestrator"},
        {"status": "in-progress", "at": "...", "by": "dev"},
        {"status": "review", "at": "...", "by": "dev", "output": "/skills/chart-generator/"},
        {"status": "done", "at": "...", "by": "qa", "notes": "All checks pass"},
        {"status": "deployed", "at": "...", "by": "deploy", "ref": "v2.0.0"}
      ]
    }
  },
  "quotas": {
    "publish_daily": {"limit": 100, "used": 45, "reset_at": "2026-03-13T00:00:00Z"},
    "api_hourly": {"limit": 60, "used": 12, "reset_at": "2026-03-12T07:00:00Z"}
  },
  "metrics": {
    "last_check": "2026-03-12T05:17:00Z",
    "total_downloads": 7591,
    "skills_online": 152,
    "alerts": []
  }
}
```

## Commands Reference

| Command | Description |
|---------|-------------|
| `add` | Add |
| `list` | List |
| `remove` | Remove |
| `add` | Add |
| `move` | Move |
| `list` | List |
| `cancel` | Cancel |
| `set` | Set |
| `use` | Use |
| `check` | Check |
| `init` | Initialize project state |
| `agent` | Manage agents (add/list/remove) |
| `task` | Manage tasks (add/list/move/cancel) |
| `quota` | Manage quotas (set/use/check) |
| `dashboard` | Show project dashboard |
| `monitor` | Run monitoring checks |
| `report` | Generate project report |
| `history` | View task history |
| `rollback` | Rollback deployed task |

## Integration with OpenClaw

This framework is designed for OpenClaw's sub-agent system:

```
Orchestrator (main session)
├── sessions_spawn(task="dev work", label="dev-agent")
├── sessions_spawn(task="qa review", label="qa-agent")  
└── sessions_spawn(task="deploy", label="deploy-agent")
```

Each spawned agent reads its tasks from `state.json` and updates status on completion.

## Best Practices

1. **Orchestrator never implements** — only decides and delegates
2. **One state file** — no scattered /tmp files
3. **Every transition logged** — full audit trail
4. **Quality gates enforced** — no skipping review
5. **Quotas tracked** — prevent rate limit surprises
6. **Alerts on anomalies** — stale tasks, failed deploys, quota exhaustion
7. **Regular retrospectives** — update process based on data

---
> **Disclaimer**: This skill is an independent, original implementation. It is not affiliated with, endorsed by, or derived from the referenced open-source project. No code was copied. The reference is for context only.
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
