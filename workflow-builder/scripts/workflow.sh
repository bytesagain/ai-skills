#!/usr/bin/env bash
set -euo pipefail

CMD="${1:-help}"
PROCESS="${2:-general}"
COMPLEXITY="${3:-medium}"

show_help() {
  cat <<'HELP'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ⚙️ Workflow Builder — 工作流设计工具
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Usage: bash workflow.sh <command> [process] [complexity]

Commands:
  design       设计工作流（输入/输出/角色/步骤/条件）
  automate     生成自动化方案（触发器/动作/工具推荐）
  optimize     分析并优化现有流程（瓶颈/冗余/并行化）
  document     工作流文档化（Markdown/Mermaid/BPMN描述）
  approval     设计审批流程（多级审批/条件分支/超时处理）
  integration  系统集成方案（API/Webhook/Zapier/n8n）

Options:
  process      流程名称 (order/support/deploy/hire/general)
  complexity   复杂度 (simple/medium/complex)

Examples:
  bash workflow.sh design order medium
  bash workflow.sh automate support simple
  bash workflow.sh approval hire complex

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
HELP
}

cmd_design() {
  local process="$1" complexity="$2"
  cat <<EOF
# ⚙️ Workflow Design — ${process}

**Complexity:** ${complexity}
**Created:** $(date +%Y-%m-%d)

---

## Workflow Overview

| Attribute | Value |
|-----------|-------|
| **Name** | ${process} Workflow |
| **Owner** | {{workflow_owner}} |
| **Trigger** | {{trigger_event}} |
| **Frequency** | {{frequency}} |
| **SLA** | {{target_completion_time}} |
| **Priority** | {{priority_level}} |

---

## Inputs & Outputs

### Inputs (触发条件 & 输入)
| # | Input | Source | Format | Required |
|---|-------|--------|--------|----------|
| 1 | {{input}} | {{source}} | {{format}} | ✅ |
| 2 | {{input}} | {{source}} | {{format}} | ⬜ |

### Outputs (产出 & 交付)
| # | Output | Destination | Format |
|---|--------|-------------|--------|
| 1 | {{output}} | {{destination}} | {{format}} |
| 2 | {{output}} | {{destination}} | {{format}} |

---

## Roles & Responsibilities

| Role | Responsibilities | Backup |
|------|-----------------|--------|
| Initiator (发起人) | 提交请求，提供信息 | {{backup}} |
| Processor (处理人) | 执行核心操作 | {{backup}} |
| Approver (审批人) | 审核并批准 | {{backup}} |
| Notified (知会人) | 接收通知 | — |

---

## Workflow Steps

\`\`\`mermaid
flowchart TD
    T[🔔 Trigger: {{event}}] --> V{Validate Input}
    V -->|Valid| S1[Step 1: {{action}}]
    V -->|Invalid| R[Return to Initiator]
    R --> T
    S1 --> S2[Step 2: {{action}}]
    S2 --> D{Decision Point}
    D -->|Path A| S3A[Step 3A: {{action}}]
    D -->|Path B| S3B[Step 3B: {{action}}]
    S3A --> S4[Step 4: Review]
    S3B --> S4
    S4 --> A{Approval}
    A -->|Approved| S5[Step 5: Execute]
    A -->|Rejected| S2
    S5 --> N[📧 Notify Stakeholders]
    N --> E[✅ Complete]
\`\`\`

---

## Step Details

| Step | Action | Actor | Duration | Tools | Error Handling |
|------|--------|-------|----------|-------|----------------|
| 1 | {{action}} | {{role}} | {{time}} | {{tool}} | {{fallback}} |
| 2 | {{action}} | {{role}} | {{time}} | {{tool}} | {{fallback}} |
| 3 | {{action}} | {{role}} | {{time}} | {{tool}} | {{fallback}} |
| 4 | {{action}} | {{role}} | {{time}} | {{tool}} | {{fallback}} |
| 5 | {{action}} | {{role}} | {{time}} | {{tool}} | {{fallback}} |

---

## Business Rules

| # | Rule | Condition | Action |
|---|------|-----------|--------|
| 1 | {{rule}} | {{condition}} | {{action}} |
| 2 | {{rule}} | {{condition}} | {{action}} |
| 3 | {{rule}} | {{condition}} | {{action}} |

---

## SLA & Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| 总处理时间 | {{target}} | 从触发到完成 |
| 审批时间 | {{target}} | 从提交到审批 |
| 首次通过率 | ≥{{target}}% | 无返工次数 |
| 满意度评分 | ≥{{target}} | NPS/CSAT |
EOF
}

cmd_automate() {
  local process="$1" complexity="$2"
  cat <<EOF
# 🤖 Automation Plan — ${process}

**Complexity:** ${complexity}

---

## Automation Opportunity Assessment

| Current Step | Manual Effort | Automation Potential | Priority |
|-------------|---------------|---------------------|----------|
| {{step_1}} | {{hours}}/week | 🟢 High | P0 |
| {{step_2}} | {{hours}}/week | 🟡 Medium | P1 |
| {{step_3}} | {{hours}}/week | 🔴 Low | P2 |

---

## Automation Architecture

\`\`\`
┌──────────┐     ┌──────────┐     ┌──────────┐
│ Trigger  │────▶│ Process  │────▶│ Action   │
│          │     │          │     │          │
│ • Form   │     │ • Filter │     │ • Notify │
│ • Email  │     │ • Route  │     │ • Update │
│ • API    │     │ • Transform    │ • Create │
│ • Schedule│    │ • Validate│     │ • Send   │
└──────────┘     └──────────┘     └──────────┘
      │                │                │
      ▼                ▼                ▼
┌──────────────────────────────────────────┐
│          Error Handling & Logging         │
└──────────────────────────────────────────┘
\`\`\`

---

## Tool Recommendations

### No-Code / Low-Code

| Tool | Best For | Pricing | Complexity |
|------|----------|---------|------------|
| Zapier | Simple integrations | From \$0 | ⭐ |
| Make (Integromat) | Complex flows | From \$0 | ⭐⭐ |
| n8n | Self-hosted, flexible | Free (OSS) | ⭐⭐⭐ |
| Power Automate | Microsoft ecosystem | Included in M365 | ⭐⭐ |

### Code-Based

| Tool | Best For | Language |
|------|----------|----------|
| GitHub Actions | CI/CD, dev workflows | YAML |
| AWS Step Functions | Cloud orchestration | JSON/YAML |
| Apache Airflow | Data pipelines | Python |
| Temporal | Complex business logic | Go/Java/TS |

---

## Automation Recipe: ${process}

### Trigger
\`\`\`yaml
trigger:
  type: {{webhook|schedule|event}}
  source: {{source}}
  conditions:
    - field: {{field}}
      operator: {{equals|contains|gt}}
      value: {{value}}
\`\`\`

### Actions
\`\`\`yaml
actions:
  - name: validate_input
    type: filter
    conditions: [...]

  - name: process_data
    type: transform
    mapping:
      output_field: "{{expression}}"

  - name: notify
    type: email|slack|webhook
    to: "{{recipient}}"
    template: "{{template_id}}"

  - name: update_record
    type: api_call
    method: PATCH
    url: "{{api_endpoint}}"
    body: { status: "completed" }
\`\`\`

---

## ROI Estimate

| Metric | Before | After | Savings |
|--------|--------|-------|---------|
| Time per execution | {{hours}} | {{minutes}} | {{saved}} |
| Executions/month | {{count}} | {{count}} | — |
| Monthly hours saved | — | — | {{total_saved}} |
| Error rate | {{rate}}% | <{{rate}}% | {{reduction}} |
| Setup cost (one-time) | — | {{cost}} | — |
| Payback period | — | — | {{months}} months |
EOF
}

cmd_optimize() {
  local process="$1" complexity="$2"
  cat <<EOF
# 🔧 Workflow Optimization — ${process}

---

## Current State Analysis

### Process Map (As-Is)
\`\`\`
[Start] → [Step 1] → [Wait ⏳] → [Step 2] → [Review] → [Wait ⏳] → [Step 3] → [End]
           ↑                                      │
           └──────── Rework Loop ◄────────────────┘
\`\`\`

### Pain Points Identified

| # | Issue | Impact | Category |
|---|-------|--------|----------|
| 1 | ⏳ Waiting time between steps | Delays completion by {{time}} | Bottleneck |
| 2 | 🔄 Rework loops due to unclear requirements | {{percent}}% rework rate | Quality |
| 3 | 📧 Manual notifications / handoffs | {{hours}} hours/week | Automation |
| 4 | 📋 Redundant approval steps | Extra {{time}} per request | Simplification |
| 5 | 🔀 Inconsistent routing | {{percent}}% misrouted | Standardization |

---

## Optimization Strategies

### 1. 🎯 Eliminate (消除)
- Remove redundant approval steps
- Eliminate unnecessary handoffs
- Cut non-value-adding documentation

### 2. ⚡ Parallelize (并行化)
- Run independent steps simultaneously
- Split sequential reviews into parallel tracks
- Batch similar operations

### 3. 🤖 Automate (自动化)
- Auto-route based on rules
- Auto-notify on status changes
- Auto-validate inputs at submission

### 4. 📏 Standardize (标准化)
- Create templates for common scenarios
- Define clear criteria for decision points
- Establish SLAs for each step

---

## Optimized Flow (To-Be)

\`\`\`
[Start] → [Auto-Validate] → [Step 1 + Step 2 (parallel)] → [Auto-Review] → [End]
\`\`\`

### Improvement Metrics

| Metric | Before | After | Improvement |
|--------|--------|-------|-------------|
| Cycle time | {{before}} | {{after}} | -{{percent}}% |
| Steps | {{count}} | {{count}} | -{{removed}} |
| Handoffs | {{count}} | {{count}} | -{{removed}} |
| Error rate | {{rate}}% | {{rate}}% | -{{reduced}}% |
| Cost per execution | ¥{{cost}} | ¥{{cost}} | -{{saved}} |
EOF
}

cmd_document() {
  local process="$1" complexity="$2"
  cat <<EOF
# 📄 Workflow Documentation — ${process}

**Version:** 1.0 | **Date:** $(date +%Y-%m-%d)

---

## 1. Process Overview

**Name:** ${process}
**Owner:** {{owner}}
**Description:** {{description}}
**Trigger:** {{trigger}}
**End State:** {{end_state}}

---

## 2. Process Flow (Mermaid)

\`\`\`mermaid
flowchart LR
    A[Trigger] --> B[Step 1]
    B --> C{Decision}
    C -->|Yes| D[Step 2A]
    C -->|No| E[Step 2B]
    D --> F[Step 3]
    E --> F
    F --> G[Complete]
\`\`\`

---

## 3. Swimlane Diagram

\`\`\`
Initiator  │  Processor  │  Approver   │  System
───────────┼─────────────┼────────────┼──────────
  Submit   │             │            │
  ─────────┼──▶ Process  │            │
           │  ───────────┼──▶ Review  │
           │             │  ──────────┼──▶ Record
           │             │    Approve │
           │             │  ──────────┼──▶ Notify
───────────┼─────────────┼────────────┼──────────
\`\`\`

---

## 4. Data Flow

| From | To | Data | Method | Frequency |
|------|----|------|--------|-----------|
| {{source}} | {{dest}} | {{data}} | {{method}} | {{freq}} |

---

## 5. Exception Handling

| Exception | Detection | Resolution | Escalation |
|-----------|-----------|------------|------------|
| {{exception}} | {{how_detected}} | {{resolution}} | {{who_to_escalate}} |

---

## 6. Change Log

| Version | Date | Change | Author |
|---------|------|--------|--------|
| 1.0 | $(date +%Y-%m-%d) | Initial documentation | {{author}} |
EOF
}

cmd_approval() {
  local process="$1" complexity="$2"
  cat <<EOF
# ✅ Approval Workflow — ${process}

**Complexity:** ${complexity}

---

## Approval Matrix

### By Amount / Impact

| Tier | Condition | Approvers | SLA |
|------|-----------|-----------|-----|
| Tier 1 | ¥0 - ¥5,000 | 直属经理 | 4h |
| Tier 2 | ¥5,001 - ¥50,000 | 部门总监 | 24h |
| Tier 3 | ¥50,001 - ¥200,000 | VP + 财务总监 | 48h |
| Tier 4 | ¥200,000+ | CEO | 72h |

---

## Approval Flow

\`\`\`mermaid
flowchart TD
    S[📝 Submit Request] --> V{Auto Validate}
    V -->|Invalid| R[Return + Error Message]
    V -->|Valid| T{Determine Tier}
    T -->|Tier 1| A1[Manager Approval]
    T -->|Tier 2| A2[Director Approval]
    T -->|Tier 3| A3[VP + CFO Parallel]
    T -->|Tier 4| A4[CEO Approval]
    A1 --> C{Decision}
    A2 --> C
    A3 --> C
    A4 --> C
    C -->|Approved ✅| E[Execute]
    C -->|Rejected ❌| F[Notify + Reason]
    C -->|Timeout ⏰| ESC[Auto-Escalate]
    ESC --> C
    E --> N[📧 Notify All Parties]
    F --> N
\`\`\`

---

## Timeout & Escalation Rules

| Level | Timeout | Escalation Target | Auto-Action |
|-------|---------|-------------------|-------------|
| Level 1 | 4 hours | Approver's manager | Reminder email |
| Level 2 | 24 hours | Department head | Push notification |
| Level 3 | 48 hours | VP level | Auto-approve (if <Tier 2) |

---

## Delegation Rules

| Scenario | Rule |
|----------|------|
| Approver on leave | Auto-delegate to backup approver |
| Approver unavailable 48h+ | Escalate to next level |
| Urgent request | Allow skip-level with justification |
| Conflict of interest | Route to alternate approver |

---

## Notification Template

| Event | Recipients | Channel | Template |
|-------|-----------|---------|----------|
| New request | Approver | Email + IM | "New {{type}} pending your approval" |
| Approved | Requester + Team | Email | "Your {{type}} has been approved" |
| Rejected | Requester | Email | "Your {{type}} was not approved: {{reason}}" |
| Reminder | Approver | IM | "Pending approval: {{type}} from {{requester}}" |
| Escalated | Next-level approver | Email + IM | "Escalated: {{type}} needs attention" |
EOF
}

cmd_integration() {
  local process="$1" complexity="$2"
  cat <<EOF
# 🔗 Integration Plan — ${process}

**Complexity:** ${complexity}

---

## Integration Architecture

\`\`\`
┌─────────┐    API/Webhook    ┌─────────┐    API/Webhook    ┌─────────┐
│ System A │◄────────────────▶│ Middleware│◄────────────────▶│ System B │
│          │                  │ (n8n/    │                  │          │
│ CRM      │    Events        │  Zapier) │    Events        │ ERP      │
│ Notion   │◄────────────────▶│          │◄────────────────▶│ DB       │
│ Slack    │                  │          │                  │ Email    │
└─────────┘                  └─────────┘                  └─────────┘
\`\`\`

---

## Integration Patterns

### 1. Webhook (Event-Driven)

\`\`\`json
{
  "endpoint": "https://your-app.com/webhooks/${process}",
  "method": "POST",
  "headers": {
    "Content-Type": "application/json",
    "X-Webhook-Secret": "{{secret}}"
  },
  "payload": {
    "event": "{{event_type}}",
    "data": { "id": "{{id}}", "status": "{{status}}" },
    "timestamp": "{{iso_datetime}}"
  },
  "retry": { "max_attempts": 3, "backoff": "exponential" }
}
\`\`\`

### 2. REST API

\`\`\`bash
# Create
curl -X POST https://api.example.com/${process} \\
  -H "Authorization: Bearer {{token}}" \\
  -H "Content-Type: application/json" \\
  -d '{"name": "{{name}}", "status": "new"}'

# Read
curl https://api.example.com/${process}/{{id}} \\
  -H "Authorization: Bearer {{token}}"

# Update
curl -X PATCH https://api.example.com/${process}/{{id}} \\
  -H "Authorization: Bearer {{token}}" \\
  -d '{"status": "completed"}'
\`\`\`

### 3. n8n Workflow (Self-Hosted)

\`\`\`json
{
  "nodes": [
    { "type": "webhook", "name": "Trigger" },
    { "type": "if", "name": "Route" },
    { "type": "httpRequest", "name": "API Call" },
    { "type": "slack", "name": "Notify" }
  ]
}
\`\`\`

---

## Common Integration Recipes

| From | To | Trigger | Action |
|------|----|---------|--------|
| Form/CRM | Slack | New submission | Send notification |
| Email | Database | New email | Parse & store |
| Database | Email | Status change | Send update |
| Calendar | Slack | Event reminder | Post in channel |
| GitHub | Jira/Notion | PR merged | Update task status |
| Stripe | CRM + Email | Payment received | Update record + receipt |

---

## Security Checklist

- [ ] API keys stored in environment variables (never hardcoded)
- [ ] Webhook signatures verified
- [ ] HTTPS only for all endpoints
- [ ] Rate limiting configured
- [ ] Error logging with alerts
- [ ] Secrets rotated periodically
- [ ] IP allowlisting where possible
EOF
}

case "$CMD" in
  design)      cmd_design "$PROCESS" "$COMPLEXITY" ;;
  automate)    cmd_automate "$PROCESS" "$COMPLEXITY" ;;
  optimize)    cmd_optimize "$PROCESS" "$COMPLEXITY" ;;
  document)    cmd_document "$PROCESS" "$COMPLEXITY" ;;
  approval)    cmd_approval "$PROCESS" "$COMPLEXITY" ;;
  integration) cmd_integration "$PROCESS" "$COMPLEXITY" ;;
  help|--help|-h) show_help ;;
  *)
    echo "❌ Unknown command: $CMD"
    echo "Run 'bash workflow.sh help' for usage."
    exit 1
    ;;
esac
