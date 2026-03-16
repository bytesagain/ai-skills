#!/usr/bin/env bash
set -euo pipefail

CMD="${1:-help}"
PROCESS="${2:-general}"
INDUSTRY="${3:-general}"

show_help() {
  cat <<'HELP'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📋 SOP Writer — 标准操作流程生成器
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Usage: bash sop.sh <command> [process] [industry]

Commands:
  create     创建完整SOP文档（目的/范围/职责/步骤/记录）
  flowchart  生成ASCII/Mermaid流程图
  checklist  从SOP提取执行检查清单
  audit      SOP审核评估（完整性/合规性/可执行性）
  template   SOP模板库（按行业/场景）
  train      生成培训材料（测试题/操作手册/快速指南）

Options:
  process    流程名称 (onboarding/deployment/incident/general)
  industry   行业 (tech/manufacturing/healthcare/food/general)

Examples:
  bash sop.sh create onboarding tech
  bash sop.sh flowchart deployment general
  bash sop.sh checklist incident tech

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
HELP
}

cmd_create() {
  local process="$1" industry="$2"
  local today
  today=$(date +%Y-%m-%d)
  cat <<EOF
# 📋 Standard Operating Procedure

## Document Control

| Field | Value |
|-------|-------|
| **SOP Title** | ${process} 标准操作流程 |
| **Document ID** | SOP-$(echo "$process" | tr '[:lower:]' '[:upper:]')-001 |
| **Version** | 1.0 |
| **Effective Date** | ${today} |
| **Review Date** | $(date -d "+1 year" +%Y-%m-%d 2>/dev/null || date -v+1y +%Y-%m-%d 2>/dev/null || echo "Next Year") |
| **Department** | {{department}} |
| **Author** | {{author}} |
| **Approver** | {{approver}} |
| **Industry** | ${industry} |
| **Classification** | Internal / Confidential |

---

## 1. Purpose 目的

本SOP旨在规范 **${process}** 流程，确保：
- 操作标准化、可重复
- 质量一致性
- 合规性要求满足
- 知识传承与培训便利化

---

## 2. Scope 范围

**适用于：**
- {{applicable_teams}} 团队/部门
- {{applicable_scenarios}} 场景

**不适用于：**
- {{exclusions}}

---

## 3. Definitions 术语定义

| 术语 | 定义 |
|------|------|
| {{term_1}} | {{definition_1}} |
| {{term_2}} | {{definition_2}} |

---

## 4. Responsibilities 职责 (RACI)

| 活动 | R (执行) | A (审批) | C (咨询) | I (知会) |
|------|----------|----------|----------|----------|
| 发起流程 | {{role}} | {{role}} | — | — |
| 执行操作 | {{role}} | — | {{role}} | — |
| 审核确认 | — | {{role}} | — | {{role}} |
| 归档记录 | {{role}} | — | — | {{role}} |

---

## 5. Procedure 操作步骤

### 5.1 准备阶段

| 步骤 | 操作 | 负责人 | 标准/注意事项 |
|------|------|--------|---------------|
| 1 | {{action}} | {{role}} | {{criteria}} |
| 2 | {{action}} | {{role}} | {{criteria}} |

### 5.2 执行阶段

| 步骤 | 操作 | 负责人 | 标准/注意事项 |
|------|------|--------|---------------|
| 3 | {{action}} | {{role}} | {{criteria}} |
| 4 | {{action}} | {{role}} | {{criteria}} |
| 5 | {{action}} | {{role}} | {{criteria}} |

### 5.3 验证阶段

| 步骤 | 操作 | 负责人 | 标准/注意事项 |
|------|------|--------|---------------|
| 6 | {{action}} | {{role}} | {{criteria}} |
| 7 | {{action}} | {{role}} | {{criteria}} |

### 5.4 收尾阶段

| 步骤 | 操作 | 负责人 | 标准/注意事项 |
|------|------|--------|---------------|
| 8 | {{action}} | {{role}} | {{criteria}} |

---

## 6. Exception Handling 异常处理

| 异常情况 | 处理方式 | 升级路径 | 时限 |
|----------|----------|----------|------|
| {{exception}} | {{handling}} | {{escalation}} | {{timeline}} |

---

## 7. Records 记录

| 记录名称 | 保存位置 | 保存期限 | 负责人 |
|----------|----------|----------|--------|
| {{record}} | {{location}} | {{retention}} | {{owner}} |

---

## 8. KPIs 关键指标

| 指标 | 目标值 | 计算方式 | 监测频率 |
|------|--------|----------|----------|
| 完成时间 | {{target}} | 从发起到完成 | 每次 |
| 一次通过率 | ≥95% | 无返工次数/总次数 | 每月 |
| 合规率 | 100% | 合规次数/总次数 | 每季 |

---

## 9. References 参考文件

- {{reference_1}}
- {{reference_2}}

---

## 10. Revision History 修订历史

| 版本 | 日期 | 修订内容 | 修订人 |
|------|------|----------|--------|
| 1.0 | ${today} | 初始版本 | {{author}} |

---

> ⚡ 提示：使用 \`bash sop.sh flowchart\` 生成流程图
> 📝 提示：使用 \`bash sop.sh checklist\` 生成执行清单
EOF
}

cmd_flowchart() {
  local process="$1" industry="$2"
  cat <<EOF
# 📊 Flowchart — ${process}

## Mermaid Diagram

\`\`\`mermaid
flowchart TD
    A[🚀 Start: ${process}] --> B{Prerequisite Check}
    B -->|Pass| C[Step 1: Prepare]
    B -->|Fail| B1[Address Prerequisites]
    B1 --> B
    C --> D[Step 2: Execute]
    D --> E{Quality Check}
    E -->|Pass| F[Step 3: Review & Approve]
    E -->|Fail| D1[Rework]
    D1 --> D
    F --> G{Approval}
    G -->|Approved| H[Step 4: Document & Archive]
    G -->|Rejected| F1[Address Feedback]
    F1 --> D
    H --> I[✅ Complete]
\`\`\`

---

## ASCII Flowchart

\`\`\`
    ┌─────────────────┐
    │   🚀 START       │
    └────────┬────────┘
             │
    ┌────────▼────────┐
    │ Prerequisites   │
    │ met?            │──── No ──→ [Fix Issues] ──┐
    └────────┬────────┘                            │
             │ Yes                                 │
    ┌────────▼────────┐                            │
    │ Step 1: Prepare │ ◄─────────────────────────┘
    └────────┬────────┘
             │
    ┌────────▼────────┐
    │ Step 2: Execute │ ◄─────┐
    └────────┬────────┘       │
             │                │
    ┌────────▼────────┐       │
    │ Quality Check   │       │
    │ passed?         │── No ─┘
    └────────┬────────┘
             │ Yes
    ┌────────▼────────┐
    │ Step 3: Review  │
    │ & Approve       │──── Rejected ──→ [Rework] ──┐
    └────────┬────────┘                              │
             │ Approved                              │
    ┌────────▼────────┐                              │
    │ Step 4: Archive │ ◄───────────────────────────┘
    └────────┬────────┘
             │
    ┌────────▼────────┐
    │   ✅ COMPLETE    │
    └─────────────────┘
\`\`\`

---

## Decision Points Summary

| # | Decision | Yes Path | No Path |
|---|----------|----------|---------|
| 1 | Prerequisites met? | Proceed to Step 1 | Fix issues, retry |
| 2 | Quality check passed? | Proceed to Review | Rework, re-execute |
| 3 | Approval granted? | Archive & Complete | Address feedback |

> 💡 Copy the Mermaid code into any Mermaid-compatible tool to render the diagram.
EOF
}

cmd_checklist() {
  local process="$1" industry="$2"
  cat <<EOF
# ✅ Execution Checklist — ${process}

**Process:** ${process} | **Industry:** ${industry}
**Date:** __________ | **Executor:** __________

---

## Pre-Execution (准备阶段)

- [ ] 确认所有前置条件满足
- [ ] 获取必要的权限和审批
- [ ] 准备所需工具/材料/文档
- [ ] 通知相关人员
- [ ] 确认回退方案就绪

## Execution (执行阶段)

- [ ] **Step 1:** __________
  - [ ] 子步骤 1.1
  - [ ] 子步骤 1.2
  - [ ] 验证点 ✓

- [ ] **Step 2:** __________
  - [ ] 子步骤 2.1
  - [ ] 子步骤 2.2
  - [ ] 验证点 ✓

- [ ] **Step 3:** __________
  - [ ] 子步骤 3.1
  - [ ] 子步骤 3.2
  - [ ] 验证点 ✓

## Verification (验证阶段)

- [ ] 功能/质量验证通过
- [ ] 性能/指标符合预期
- [ ] 无异常错误或告警
- [ ] 相关方确认结果

## Post-Execution (收尾阶段)

- [ ] 更新相关文档
- [ ] 记录执行时间和结果
- [ ] 通知利益相关方完成
- [ ] 归档操作记录
- [ ] 总结经验教训 (如有)

---

## Sign-off 签字

| Role | Name | Signature | Date |
|------|------|-----------|------|
| 执行人 | __________ | __________ | __________ |
| 审核人 | __________ | __________ | __________ |
| 批准人 | __________ | __________ | __________ |

---

## Exceptions Log 异常记录

| # | 异常描述 | 处理方式 | 处理人 | 时间 |
|---|----------|----------|--------|------|
| 1 | | | | |
| 2 | | | | |
EOF
}

cmd_audit() {
  local process="$1" industry="$2"
  cat <<EOF
# 🔍 SOP Audit Report — ${process}

**Audit Date:** $(date +%Y-%m-%d)
**Industry:** ${industry}
**Auditor:** __________

---

## Audit Dimensions (评估维度)

### 1. Completeness 完整性 (权重30%)

| Check Item | Status | Score (1-5) | Notes |
|------------|--------|-------------|-------|
| 目的明确 | ⬜ | /5 | |
| 范围界定清晰 | ⬜ | /5 | |
| 职责分配明确(RACI) | ⬜ | /5 | |
| 步骤详细可执行 | ⬜ | /5 | |
| 异常处理覆盖 | ⬜ | /5 | |
| 记录要求明确 | ⬜ | /5 | |
| 参考文件完整 | ⬜ | /5 | |
| 版本控制规范 | ⬜ | /5 | |

### 2. Compliance 合规性 (权重25%)

| Check Item | Status | Score (1-5) | Notes |
|------------|--------|-------------|-------|
| 符合行业标准 | ⬜ | /5 | |
| 满足法规要求 | ⬜ | /5 | |
| 安全规范覆盖 | ⬜ | /5 | |
| 数据保护合规 | ⬜ | /5 | |

### 3. Executability 可执行性 (权重25%)

| Check Item | Status | Score (1-5) | Notes |
|------------|--------|-------------|-------|
| 新员工可独立执行 | ⬜ | /5 | |
| 步骤无歧义 | ⬜ | /5 | |
| 工具/资源可获取 | ⬜ | /5 | |
| 时间估算合理 | ⬜ | /5 | |

### 4. Maintainability 可维护性 (权重20%)

| Check Item | Status | Score (1-5) | Notes |
|------------|--------|-------------|-------|
| 定期审查机制 | ⬜ | /5 | |
| 版本管理规范 | ⬜ | /5 | |
| 变更流程明确 | ⬜ | /5 | |
| 格式统一标准 | ⬜ | /5 | |

---

## Overall Score

| Dimension | Weight | Score | Weighted |
|-----------|--------|-------|----------|
| Completeness | 30% | /5 | |
| Compliance | 25% | /5 | |
| Executability | 25% | /5 | |
| Maintainability | 20% | /5 | |
| **Total** | **100%** | | **/5** |

## Rating Scale

| Score | Rating | Action |
|-------|--------|--------|
| 4.5-5.0 | ⭐ Excellent | Maintain, minor tweaks |
| 3.5-4.4 | ✅ Good | Minor improvements |
| 2.5-3.4 | ⚠️ Fair | Significant revision needed |
| 1.0-2.4 | ❌ Poor | Major rewrite required |

---

## Recommendations 改进建议

1. __________
2. __________
3. __________
EOF
}

cmd_template() {
  local process="$1" industry="$2"
  cat <<EOF
# 📚 SOP Template Library

**Industry:** ${industry}

---

## Available Templates by Category

### 🏢 General Business

| Template | Use Case | Complexity |
|----------|----------|------------|
| Employee Onboarding | 新员工入职流程 | ⭐⭐ |
| Employee Offboarding | 员工离职流程 | ⭐⭐ |
| Purchase Request | 采购申请流程 | ⭐ |
| Travel Reimbursement | 差旅报销 | ⭐ |
| Document Approval | 文件审批流程 | ⭐⭐ |

### 💻 Tech / IT

| Template | Use Case | Complexity |
|----------|----------|------------|
| Code Deployment | 代码发布上线 | ⭐⭐⭐ |
| Incident Response | 故障响应处理 | ⭐⭐⭐ |
| Server Provisioning | 服务器配置 | ⭐⭐ |
| Access Control | 权限管理 | ⭐⭐ |
| Backup & Recovery | 备份与恢复 | ⭐⭐⭐ |

### 🏭 Manufacturing

| Template | Use Case | Complexity |
|----------|----------|------------|
| Quality Inspection | 质量检验 | ⭐⭐ |
| Equipment Maintenance | 设备维护 | ⭐⭐ |
| Material Receipt | 物料验收 | ⭐⭐ |
| Production Changeover | 产线切换 | ⭐⭐⭐ |

### 🏥 Healthcare

| Template | Use Case | Complexity |
|----------|----------|------------|
| Patient Intake | 患者接诊 | ⭐⭐ |
| Medication Administration | 给药流程 | ⭐⭐⭐ |
| Sterilization | 消毒灭菌 | ⭐⭐ |
| Emergency Response | 急救响应 | ⭐⭐⭐ |

---

> 💡 Use \`bash sop.sh create <process> <industry>\` to generate a full SOP from any template.
EOF
}

cmd_train() {
  local process="$1" industry="$2"
  cat <<EOF
# 🎓 Training Materials — ${process}

**Industry:** ${industry}
**Generated:** $(date +%Y-%m-%d)

---

## Quick Reference Card (口袋指南)

### ${process} — 快速指南

\`\`\`
┌─────────────────────────────────────┐
│  📋 ${process} Quick Reference      │
├─────────────────────────────────────┤
│                                     │
│  Step 1: __________                 │
│  Step 2: __________                 │
│  Step 3: __________                 │
│  Step 4: __________                 │
│                                     │
│  ⚠️ Key Reminders:                  │
│  • __________                       │
│  • __________                       │
│                                     │
│  🆘 Emergency Contact:              │
│  • __________                       │
└─────────────────────────────────────┘
\`\`\`

---

## Knowledge Test (培训测验)

### Multiple Choice (单选题)

**Q1.** ${process}的第一步是什么？
- A) __________
- B) __________
- C) __________
- D) __________

**Q2.** 发现异常情况时，应首先？
- A) 自行处理
- B) 记录并上报
- C) 忽略继续操作
- D) 联系外部供应商

**Q3.** 操作记录应保存多长时间？
- A) 1个月
- B) 6个月
- C) 1年
- D) 按公司规定

### True/False (判断题)

**Q4.** ⬜ 所有操作步骤可以根据经验自行调整顺序
**Q5.** ⬜ 异常情况必须记录在案

### Short Answer (简答题)

**Q6.** 请列出${process}的3个关键验证点。

**Q7.** 如果在步骤X遇到Y情况，你会如何处理？

---

## Training Completion Record

| Item | Details |
|------|---------|
| 培训人 | __________ |
| 培训日期 | __________ |
| 培训师 | __________ |
| 考试得分 | ____ / 100 |
| 实操评估 | ⬜ 通过 ⬜ 需复训 |
| 签字 | __________ |
EOF
}

case "$CMD" in
  create)    cmd_create "$PROCESS" "$INDUSTRY" ;;
  flowchart) cmd_flowchart "$PROCESS" "$INDUSTRY" ;;
  checklist) cmd_checklist "$PROCESS" "$INDUSTRY" ;;
  audit)     cmd_audit "$PROCESS" "$INDUSTRY" ;;
  template)  cmd_template "$PROCESS" "$INDUSTRY" ;;
  train)     cmd_train "$PROCESS" "$INDUSTRY" ;;
  help|--help|-h) show_help ;;
  *)
    echo "❌ Unknown command: $CMD"
    echo "Run 'bash sop.sh help' for usage."
    exit 1
    ;;
esac
