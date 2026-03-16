#!/usr/bin/env bash
set -euo pipefail

CMD="${1:-help}"
INDUSTRY="${2:-general}"
TONE="${3:-professional}"

show_help() {
  cat <<'HELP'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📧 Email Template Generator
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Usage: bash emailtpl.sh <command> [industry] [tone]

Commands:
  welcome        欢迎邮件模板（新用户注册、订阅确认）
  newsletter     Newsletter邮件模板（周报、月报、产品更新）
  transactional  事务邮件模板（订单确认、密码重置、通知）
  cold           冷启动邮件模板（商务合作、销售外联）
  followup       跟进邮件模板（面试跟进、合作跟进、催回复）
  collection     催款邮件模板（友好提醒→正式催款→最终通知）

Options:
  industry   行业 (tech/ecommerce/saas/education/general)
  tone       语气 (professional/friendly/urgent/casual)

Examples:
  bash emailtpl.sh welcome tech friendly
  bash emailtpl.sh cold saas professional
  bash emailtpl.sh collection general urgent

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
HELP
}

cmd_welcome() {
  local industry="$1" tone="$2"
  cat <<EOF
# 📧 Welcome Email Template

**Industry:** ${industry} | **Tone:** ${tone}

---

## Subject Line Options (A/B Test)

1. 🎉 欢迎加入{{company_name}}！开启你的旅程
2. Welcome to {{company_name}} — Here's What's Next
3. 你的账号已就绪 — 3步开始使用{{product_name}}
4. {{name}}，欢迎！一份专属新手指南等你查收
5. 🚀 Ready to go? Your {{company_name}} account is live

---

## Email Body (HTML Structure)

\`\`\`
┌─────────────────────────────────────┐
│  [Logo]                             │
│  ─────────────────────────────────  │
│                                     │
│  Hi {{first_name}},                 │
│                                     │
│  Welcome to {{company_name}}! 🎉    │
│                                     │
│  We're thrilled to have you.        │
│  Here's how to get started:         │
│                                     │
│  ┌─────────────────────────────┐    │
│  │ Step 1: Complete Profile    │    │
│  │ Step 2: Explore Features    │    │
│  │ Step 3: Connect Your Team   │    │
│  └─────────────────────────────┘    │
│                                     │
│  ┌───────────────────────┐          │
│  │   [Get Started Now]   │  ← CTA  │
│  └───────────────────────┘          │
│                                     │
│  Need help? Reply to this email     │
│  or visit our Help Center.          │
│                                     │
│  ─────────────────────────────────  │
│  {{company_name}}                   │
│  [Social Icons]                     │
│  Unsubscribe | Privacy Policy       │
│  {{company_address}}                │
└─────────────────────────────────────┘
\`\`\`

---

## Plain Text Version

\`\`\`
Hi {{first_name}},

Welcome to {{company_name}}!

We're excited to have you on board. Here's how to get started:

1. Complete your profile: {{profile_url}}
2. Explore key features: {{features_url}}
3. Join our community: {{community_url}}

Questions? Just reply to this email.

Best,
The {{company_name}} Team
\`\`\`

---

## Welcome Email Series (Drip)

| Day | Email | Purpose |
|-----|-------|---------|
| 0 | Welcome + Quick Start | First impression, activate |
| 1 | Feature Highlight #1 | Show core value |
| 3 | Success Story / Case Study | Social proof |
| 5 | Feature Highlight #2 | Deepen engagement |
| 7 | Check-in + Offer | Convert / retain |

---

## Personalization Variables

| Variable | Description | Example |
|----------|-------------|---------|
| \`{{first_name}}\` | 用户名 | Kelly |
| \`{{company_name}}\` | 公司名 | BytesAgain |
| \`{{product_name}}\` | 产品名 | OpenClaw |
| \`{{signup_date}}\` | 注册日期 | 2026-03-10 |
| \`{{profile_url}}\` | 个人设置链接 | https://... |

---

## Compliance Checklist

- [ ] Unsubscribe link present
- [ ] Physical address included (CAN-SPAM)
- [ ] Reply-to address is monitored
- [ ] Mobile-responsive design tested
- [ ] Plain text version available
- [ ] Preheader text optimized
- [ ] SPF/DKIM/DMARC configured
EOF
}

cmd_newsletter() {
  local industry="$1" tone="$2"
  cat <<EOF
# 📰 Newsletter Email Template

**Industry:** ${industry} | **Tone:** ${tone}

---

## Subject Line Formulas

1. 📬 {{company_name}} Weekly: {{main_topic}} + More
2. This Week in {{industry}}: {{number}} Things You Should Know
3. {{month}} Roundup — What We Shipped & What's Next
4. 🔥 Trending: {{topic}} | {{company_name}} Newsletter #{{issue}}
5. {{first_name}}, here's your {{frequency}} update

---

## Newsletter Structure

\`\`\`
┌─────────────────────────────────────┐
│  [Logo] | Newsletter #{{issue}}     │
│  {{date}}                           │
│  ─────────────────────────────────  │
│                                     │
│  📌 HERO STORY                      │
│  ┌─────────────────────────────┐    │
│  │  [Feature Image]            │    │
│  │  Headline of Main Story     │    │
│  │  2-3 sentence summary...    │    │
│  │  [Read More →]              │    │
│  └─────────────────────────────┘    │
│                                     │
│  📋 THIS WEEK'S HIGHLIGHTS          │
│  ├─ Story 1: Brief + Link          │
│  ├─ Story 2: Brief + Link          │
│  └─ Story 3: Brief + Link          │
│                                     │
│  💡 TIP OF THE WEEK                 │
│  Quick actionable advice...         │
│                                     │
│  📊 BY THE NUMBERS                  │
│  Interesting stat or metric         │
│                                     │
│  ─────────────────────────────────  │
│  [Social] | [Unsubscribe]           │
└─────────────────────────────────────┘
\`\`\`

---

## Content Sections Menu (Pick 3-5)

| Section | Icon | Use When |
|---------|------|----------|
| Hero Story | 📌 | Always — lead with strongest content |
| Product Updates | 🚀 | New features, releases |
| Industry News | 📰 | Curated relevant news |
| Tips & Tricks | 💡 | Actionable how-to content |
| Community Spotlight | 🌟 | User stories, testimonials |
| Upcoming Events | 📅 | Webinars, meetups, launches |
| Team Update | 👥 | Hiring, milestones, culture |
| Data/Stats | 📊 | Interesting numbers |
| Resource of the Week | 📚 | Tools, articles, templates |
| Poll/Survey | 📊 | Engagement + feedback |

---

## Sending Best Practices

| Factor | Recommendation |
|--------|----------------|
| Frequency | Weekly or bi-weekly (consistency > frequency) |
| Send Day | Tuesday–Thursday perform best |
| Send Time | 10:00 AM local time |
| Length | 200-500 words (scannable) |
| Images | 3-5 max, with alt text |
| CTA | 1 primary + max 2 secondary |
EOF
}

cmd_transactional() {
  local industry="$1" tone="$2"
  cat <<EOF
# 🔔 Transactional Email Templates

**Industry:** ${industry} | **Tone:** ${tone}

---

## Template Collection

### 1. Order Confirmation 📦

**Subject:** ✅ 订单确认 — 订单号 #{{order_id}}

\`\`\`
Hi {{first_name}},

感谢你的订购！以下是你的订单详情：

━━━━━━━━━━━━━━━━━━━━━━━
订单号: #{{order_id}}
日期: {{order_date}}
━━━━━━━━━━━━━━━━━━━━━━━

商品:
{{#items}}
  • {{item_name}} × {{quantity}}    ¥{{price}}
{{/items}}

━━━━━━━━━━━━━━━━━━━━━━━
小计:                     ¥{{subtotal}}
运费:                     ¥{{shipping}}
总计:                     ¥{{total}}
━━━━━━━━━━━━━━━━━━━━━━━

配送地址: {{shipping_address}}
预计送达: {{estimated_delivery}}

[查看订单详情]

如有问题，请联系我们: {{support_email}}
\`\`\`

---

### 2. Password Reset 🔐

**Subject:** 重置你的{{company_name}}密码

\`\`\`
Hi {{first_name}},

我们收到了你的密码重置请求。

点击下方按钮重置密码（链接30分钟内有效）：

[重置密码] → {{reset_url}}

如果不是你本人操作，请忽略此邮件。
你的密码不会发生变化。

安全提示:
• 我们绝不会通过邮件要求你提供密码
• 使用至少12位包含大小写和数字的密码
• 开启两步验证增强账户安全
\`\`\`

---

### 3. Shipping Notification 🚚

**Subject:** 📦 你的包裹已发出！运单号: {{tracking_number}}

\`\`\`
Hi {{first_name}},

好消息！你的订单 #{{order_id}} 已经发货。

快递公司: {{carrier}}
运单号: {{tracking_number}}
预计送达: {{eta}}

[📍 追踪包裹]
\`\`\`

---

### 4. Invoice / Receipt 🧾

**Subject:** 发票/收据 — {{company_name}} #{{invoice_id}}

### 5. Account Notification ⚠️

**Subject:** 安全提醒 — 你的账号在新设备登录

---

## Transactional Email Checklist

- [ ] 不包含营销内容（CAN-SPAM合规）
- [ ] 即时发送（延迟<30秒）
- [ ] 包含所有必要交易信息
- [ ] 明确的下一步操作指引
- [ ] 提供客服联系方式
- [ ] 纯文本后备版本
- [ ] 安全链接（HTTPS）
- [ ] 回复地址可接收回复
EOF
}

cmd_cold() {
  local industry="$1" tone="$2"
  cat <<EOF
# 🎯 Cold Email Templates

**Industry:** ${industry} | **Tone:** ${tone}

---

## Cold Email Framework: AIDA

| Element | Purpose | Length |
|---------|---------|--------|
| **A**ttention | Subject line + first line hook | 1 line |
| **I**nterest | Relevant pain point / insight | 2-3 lines |
| **D**esire | Your solution + proof | 2-3 lines |
| **A**ction | Clear, low-friction CTA | 1 line |

---

## Template 1: Pain Point Approach

**Subject:** {{company}} 的 {{pain_point}} — 一个想法

\`\`\`
Hi {{first_name}},

注意到 {{company}} 正在 {{observation}}（比如：扩展海外市场 / 招聘工程师 / 上线新产品）。

很多 {{industry}} 公司在这个阶段会遇到 {{pain_point}}，
我们帮助 {{similar_company}} 在 {{timeframe}} 内解决了这个问题，
{{specific_result}}（如：转化率提升37%）。

如果你有15分钟，我可以分享一些适合 {{company}} 的具体方案。
这周三或周四下午方便吗？

{{signature}}
\`\`\`

---

## Template 2: Mutual Connection

**Subject:** {{mutual_connection}} 推荐我联系你

## Template 3: Value-First (No Ask)

**Subject:** 关于 {{company}} 的 {{topic}} — 一些数据

## Template 4: Breakup Email (Final Follow-up)

**Subject:** 该关闭这个对话了吗？

---

## Cold Email Rules

| Rule | Details |
|------|---------|
| 长度 | 50-125 words (越短越好) |
| Subject | 3-5 words, lowercase, no emoji |
| CTA | 一个CTA，一个问题 |
| Personalization | 至少2个个性化元素 |
| Follow-up | 3-5封序列，间隔3-5天 |
| Timing | 周二-周四 8-10AM |

---

## Follow-up Sequence

| # | Day | Approach | Subject |
|---|-----|----------|---------|
| 1 | 0 | Initial outreach | 独立 subject |
| 2 | +3 | Add value (resource/insight) | Re: 原 subject |
| 3 | +6 | Social proof / case study | Re: 原 subject |
| 4 | +10 | Different angle | 新 subject |
| 5 | +15 | Breakup email | 该关闭了吗？ |

---

## Deliverability Checklist

- [ ] 使用自定义域名邮箱（非Gmail）
- [ ] 配置 SPF + DKIM + DMARC
- [ ] 域名预热 2-4 weeks
- [ ] 每日发送量 <50 (新域名)
- [ ] 不使用短链接（触发垃圾邮件过滤）
- [ ] 不使用图片或附件（首封邮件）
- [ ] 避免垃圾邮件关键词（免费/紧急/限时）
EOF
}

cmd_followup() {
  local industry="$1" tone="$2"
  cat <<EOF
# 🔄 Follow-up Email Templates

**Industry:** ${industry} | **Tone:** ${tone}

---

## Template 1: Meeting Follow-up

**Subject:** 感谢今天的交流 — 下一步行动

\`\`\`
Hi {{first_name}},

感谢今天的会面！以下是我们讨论的要点：

📋 会议摘要:
• {{point_1}}
• {{point_2}}
• {{point_3}}

✅ 后续行动:
• [你] {{your_action}} — 预计 {{date_1}}
• [对方] {{their_action}} — 预计 {{date_2}}

下次同步时间: {{next_meeting_date}}

如有任何补充，随时告知。

{{signature}}
\`\`\`

---

## Template 2: Interview Follow-up (24h内)

**Subject:** 感谢面试机会 — {{position}} 职位

\`\`\`
{{interviewer_name}} 您好，

感谢今天的面试。和您交流关于 {{topic}} 非常愉快。

面试中您提到的 {{specific_point}}，
让我对这个角色有了更深的理解。
我相信我在 {{your_strength}} 方面的经验
能为团队带来价值。

期待后续消息。如需任何补充材料，请随时告知。

{{signature}}
\`\`\`

---

## Template 3: Proposal Follow-up

**Subject:** Re: {{project_name}} 方案 — 有什么我能补充的？

---

## Template 4: Gentle Reminder

**Subject:** 温馨提醒: {{topic}}

---

## Follow-up Timing Guide

| Scenario | Wait Time | Max Attempts |
|----------|-----------|--------------|
| 面试后 | 24h | 2 |
| 方案发送后 | 2-3 days | 3 |
| 合作洽谈 | 3-5 days | 4 |
| 冷邮件 | 3-5 days | 5 |
| 客户回复 | 1-2 days | 3 |
| 内部审批 | 1 day | 2 |

---

## Tone Escalation

1. **Friendly** — "想确认一下您是否收到了..."
2. **Professional** — "跟进一下上次的讨论..."
3. **Direct** — "希望能在本周内收到回复..."
4. **Final** — "如果没有回音，我将..."
EOF
}

cmd_collection() {
  local industry="$1" tone="$2"
  cat <<EOF
# 💰 Collection Email Templates

**Industry:** ${industry} | **Tone:** ${tone}

---

## Collection Email Sequence (由友好到正式)

### Level 1: Friendly Reminder (逾期1-7天)

**Subject:** 温馨提醒 — 发票 #{{invoice_id}} 已到期

\`\`\`
{{company_name}} 您好，

这是一封友好提醒，以下发票已于 {{due_date}} 到期：

  发票号: #{{invoice_id}}
  金额:  ¥{{amount}}
  到期日: {{due_date}}
  逾期:  {{days_overdue}} 天

如果已付款，请忽略此邮件。
如需查看发票详情或有疑问，请点击: {{invoice_url}}

付款方式:
• 银行转账: {{bank_details}}
• 在线支付: {{payment_url}}

谢谢！
{{signature}}
\`\`\`

---

### Level 2: Formal Notice (逾期7-30天)

**Subject:** 逾期通知 — 发票 #{{invoice_id}} 已逾期{{days}}天

\`\`\`
{{contact_name}} 您好，

我们注意到以下发票仍未结清：

  发票号: #{{invoice_id}}
  金额:  ¥{{amount}}
  到期日: {{due_date}}
  逾期:  {{days_overdue}} 天

我们此前已发送过友好提醒。
请在收到此邮件后 7个工作日内 安排付款。

如有付款困难或对账单有异议，
请及时与我们联系协商解决方案。

{{signature}}
\`\`\`

---

### Level 3: Final Notice (逾期30-60天)

**Subject:** ⚠️ 最终付款通知 — 发票 #{{invoice_id}}

---

### Level 4: Escalation Warning (逾期60+天)

**Subject:** 重要通知 — 即将采取进一步措施

---

## Collection Timeline

| Day | Action | Tone |
|-----|--------|------|
| -7 | 到期前提醒 | 友好 |
| 0 | 到期日提醒 | 友好 |
| +7 | 首次逾期提醒 | 友好 |
| +14 | 正式通知 | 专业 |
| +30 | 最终通知 | 严肃 |
| +45 | 电话沟通 | 严肃 |
| +60 | 升级警告 | 正式法律语气 |
| +90 | 法律途径 | 正式 |

---

## Best Practices

- 始终保持专业和尊重
- 记录所有沟通（时间、方式、内容）
- 提供便捷的付款方式
- 开放协商分期付款
- 了解当地法律法规
- 区分"不愿付"和"不能付"
EOF
}

case "$CMD" in
  welcome)       cmd_welcome "$INDUSTRY" "$TONE" ;;
  newsletter)    cmd_newsletter "$INDUSTRY" "$TONE" ;;
  transactional) cmd_transactional "$INDUSTRY" "$TONE" ;;
  cold)          cmd_cold "$INDUSTRY" "$TONE" ;;
  followup)      cmd_followup "$INDUSTRY" "$TONE" ;;
  collection)    cmd_collection "$INDUSTRY" "$TONE" ;;
  help|--help|-h) show_help ;;
  *)
    echo "❌ Unknown command: $CMD"
    echo "Run 'bash emailtpl.sh help' for usage."
    exit 1
    ;;
esac
