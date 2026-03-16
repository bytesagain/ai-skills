#!/usr/bin/env bash
set -euo pipefail

CMD="${1:-help}"
STAGE="${2:-general}"
INDUSTRY="${3:-tech}"

show_help() {
  cat <<'HELP'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  🚀 Startup Tools — 创业工具包
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Usage: bash startup.sh <command> [stage] [industry]

Commands:
  checklist   创业阶段检查清单（想法→验证→发布→规模化）
  register    公司注册指南（类型选择/流程/费用/材料）
  mvp         MVP规划（核心功能/技术选型/时间线/预算）
  fundraise   融资准备（BP/财务模型/估值/投资人清单）
  legal       法律合规（合同/知识产权/隐私/劳动法）
  growth      增长策略（获客渠道/留存/变现/数据指标）

Options:
  stage      阶段 (idea/validation/mvp/launch/growth/scale)
  industry   行业 (tech/ecommerce/saas/education/health/general)

Examples:
  bash startup.sh checklist idea tech
  bash startup.sh register general tech
  bash startup.sh mvp validation saas
  bash startup.sh fundraise growth tech

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
HELP
}

cmd_checklist() {
  local stage="$1" industry="$2"
  cat <<EOF
# 🚀 Startup Checklist

**Stage:** ${stage} | **Industry:** ${industry}

---

## Stage 1: 💡 Idea (想法阶段)

- [ ] **Problem validation**
  - [ ] 明确定义要解决的问题
  - [ ] 与 20+ 潜在用户深度访谈
  - [ ] 确认这是一个 "止痛药" 而非 "维生素" 问题
  - [ ] 评估市场规模 (TAM/SAM/SOM)

- [ ] **Solution hypothesis**
  - [ ] 描述你的解决方案 (一句话)
  - [ ] 列出 3-5 个假设需要验证
  - [ ] 竞品分析 (至少 5 个竞争对手)
  - [ ] 差异化价值主张 (Why you? Why now?)

- [ ] **Founder readiness**
  - [ ] 联合创始人对齐 (分工/股权/退出机制)
  - [ ] 个人财务跑道评估 (至少 12 个月)
  - [ ] 行业经验或领域知识

---

## Stage 2: ✅ Validation (验证阶段)

- [ ] **Market validation**
  - [ ] 着陆页 + 注册表 (测量转化率)
  - [ ] 预售 / 众筹测试付费意愿
  - [ ] 至少 100 个目标用户反馈
  - [ ] Letter of Intent (LOI) from potential customers

- [ ] **Prototype**
  - [ ] 纸面原型 / Wireframe
  - [ ] 可点击原型 (Figma/Sketch)
  - [ ] 用户测试 (5-10 人)
  - [ ] 根据反馈迭代

---

## Stage 3: 🛠️ MVP (最小可行产品)

- [ ] **Build**
  - [ ] 确定核心功能 (3个以内)
  - [ ] 技术选型
  - [ ] 开发 MVP (4-8 weeks)
  - [ ] 基础分析和监控

- [ ] **Launch**
  - [ ] Beta 测试 (50-100 用户)
  - [ ] 收集反馈和指标
  - [ ] 公开发布
  - [ ] 首批付费用户

---

## Stage 4: 📈 Growth (增长阶段)

- [ ] **Product-Market Fit**
  - [ ] Sean Ellis Test: >40% 用户说 "非常失望" 如果不能用
  - [ ] 留存曲线趋平
  - [ ] 自然增长出现
  - [ ] 用户推荐 (NPS >= 50)

- [ ] **Scale**
  - [ ] 确定可规模化获客渠道
  - [ ] 单位经济模型健康 (LTV > 3x CAC)
  - [ ] 团队扩张计划
  - [ ] 流程和文档化

---

## Stage 5: 🏢 Scale (规模化)

- [ ] **Operations**
  - [ ] 标准化流程 (SOP)
  - [ ] 关键岗位招聘
  - [ ] 文化和价值观落地
  - [ ] 合规和法务完善

- [ ] **Finance**
  - [ ] 融资或盈利路径明确
  - [ ] 财务模型和预测
  - [ ] 审计和税务合规
  - [ ] 期权池管理
EOF
}

cmd_register() {
  local stage="$1" industry="$2"
  cat <<EOF
# 🏢 Company Registration Guide (China)

**Industry:** ${industry}

---

## Company Type Selection

| Type | Best For | Liability | Minimum Capital | Tax Rate |
|------|----------|-----------|----------------|----------|
| 有限责任公司 (LLC) | 大多数创业公司 | 有限 (出资额) | 认缴制,无最低 | 25% (小微5%) |
| 股份有限公司 | 计划上市 | 有限 (持股额) | 500万 | 25% |
| 个体工商户 | 个人小生意 | 无限 | 无 | 核定/查账 |
| 合伙企业 | 投资基金/律所 | 有限/无限 | 无 | 穿透征税 |
| 个人独资企业 | 一人经营 | 无限 | 无 | 个人所得税 |

> 推荐: 大多数互联网创业选择 **有限责任公司**

---

## Registration Process (有限责任公司)

### Step 1: 准备材料

| 材料 | 说明 | 注意事项 |
|------|------|----------|
| 公司名称 | 3-5 个备选 | "地区+字号+行业+公司" |
| 注册地址 | 商用地址证明 | 可用虚拟地址/孵化器 |
| 经营范围 | 参考同行 | 第一项决定主行业 |
| 法人身份证 | 原件 + 复印件 | 法人不能在黑名单 |
| 股东信息 | 身份证 + 持股比例 | 建议奇数股东 |
| 注册资本 | 认缴金额 | 建议 10-100 万 |
| 公司章程 | 可用模板 | 工商局有标准版 |

### Step 2: 注册流程

\`\`\`
名称预核准 (1-3天)
    |
    v
提交工商材料 (网上+现场)
    |
    v
领取营业执照 (3-5工作日)
    |
    v
刻章 (公章/财务章/法人章/发票章) (1天)
    |
    v
银行开户 (基本户) (1-2周)
    |
    v
税务登记 + 核税种 (1-2天)
    |
    v
社保/公积金开户 (1天)
    |
    v
可以正常运营
\`\`\`

### Step 3: 费用估算

| 项目 | 费用 | 备注 |
|------|------|------|
| 工商注册 | 0 (自助) / 500-2000 (代办) | 代办省时 |
| 刻章 | 200-500 | 4枚章 |
| 银行开户 | 0-500 | 部分银行免费 |
| 注册地址 | 0-5000/年 | 虚拟地址 |
| 代理记账 | 200-500/月 | 小规模纳税人 |
| **首年预算** | **约 5000-15000** | |

---

## Post-Registration Checklist

- [ ] 营业执照领取
- [ ] 四枚印章刻制
- [ ] 银行基本户开设
- [ ] 税务登记完成
- [ ] 税种核定
- [ ] 发票申领
- [ ] 社保公积金开户
- [ ] 商标注册申请
- [ ] 域名注册
- [ ] ICP备案 (如有网站)
EOF
}

cmd_mvp() {
  local stage="$1" industry="$2"
  cat <<EOF
# 🛠️ MVP Planning Guide

**Stage:** ${stage} | **Industry:** ${industry}

---

## MVP Definition Canvas

| Field | Answer |
|-------|--------|
| **Problem** | {{one sentence}} |
| **Solution** | {{one sentence}} |
| **Target User** | {{who exactly}} |
| **Core Metric** | {{one number to track}} |
| **Success Criteria** | {{what proves it works}} |
| **Timeline** | {{weeks}} |
| **Budget** | {{amount}} |

---

## Feature Prioritization (MoSCoW)

| Priority | Feature | Effort | Impact | Include in MVP? |
|----------|---------|--------|--------|----------------|
| Must | {{feature}} | S/M/L | H | Yes |
| Must | {{feature}} | S/M/L | H | Yes |
| Must | {{feature}} | S/M/L | H | Yes |
| Should | {{feature}} | S/M/L | M | V2 |
| Could | {{feature}} | S/M/L | L | Later |
| Won't | {{feature}} | S/M/L | L | Not now |

> Rule: MVP = Max 3 core features. If you can't cut it, it's not minimum.

---

## Tech Stack Recommendations

### For Speed (Ship in 2-4 weeks)

| Component | Recommended | Alternative |
|-----------|-------------|-------------|
| Frontend | Next.js / Nuxt | Vue + Vite |
| Backend | Supabase / Firebase | Node + Express |
| Database | PostgreSQL (Supabase) | SQLite |
| Auth | Supabase Auth / Clerk | Auth0 |
| Hosting | Vercel / Railway | AWS Lightsail |
| Payments | Stripe / WeChat Pay | Paddle |
| Analytics | Mixpanel / PostHog | Google Analytics |
| Monitoring | Sentry | LogRocket |

### No-Code Options (Ship in 1-2 weeks)

| Tool | Best For | Price |
|------|----------|-------|
| Bubble | Web apps | From free |
| Webflow | Websites + CMS | From free |
| Airtable | Databases + workflows | From free |
| Zapier | Integrations | From free |
| Notion | Internal tools | From free |
| Retool | Admin panels | From free |

---

## MVP Timeline (8-Week Sprint)

| Week | Focus | Deliverable |
|------|-------|-------------|
| 1 | Research + Design | User stories + wireframes |
| 2 | Design + Setup | Hi-fi mockup + dev environment |
| 3-4 | Core Feature 1 | Working feature #1 |
| 5 | Core Feature 2 | Working feature #2 |
| 6 | Core Feature 3 | Working feature #3 |
| 7 | Testing + Polish | Bug fixes + UX polish |
| 8 | Launch | Beta release |

---

## MVP Budget Template

| Category | DIY Cost | Outsource Cost |
|----------|----------|----------------|
| Design (UI/UX) | 0 (Figma free) | 5,000-20,000 |
| Development | 0 (you build) | 20,000-100,000 |
| Hosting (year 1) | 0-2,000 | Same |
| Domain | 50-500 | Same |
| Analytics tools | 0 | Same |
| Marketing (launch) | 0-5,000 | 5,000-20,000 |
| **Total** | **50-7,500** | **30,000-140,000** |
EOF
}

cmd_fundraise() {
  local stage="$1" industry="$2"
  cat <<EOF
# 💰 Fundraising Guide

**Stage:** ${stage} | **Industry:** ${industry}

---

## Funding Rounds (China Market)

| Round | Amount (RMB) | Valuation | Stage | What You Need |
|-------|-------------|-----------|-------|---------------|
| 种子轮 | 50-200万 | 500-2000万 | Idea/Prototype | Team + Vision |
| 天使轮 | 200-1000万 | 2000万-1亿 | MVP/Early Users | Product + Traction |
| Pre-A | 500-2000万 | 5000万-2亿 | PMF signals | Growth metrics |
| A轮 | 2000万-1亿 | 2-10亿 | PMF confirmed | Unit economics |
| B轮 | 1-5亿 | 10-50亿 | Scaling | Revenue + team |
| C轮+ | 5亿+ | 50亿+ | Market leader | Profitability path |

---

## Pitch Deck Structure (10-12 Slides)

| # | Slide | Content | Time |
|---|-------|---------|------|
| 1 | 封面 | Company name + one-liner | 15s |
| 2 | 问题 | 痛点 (用数据+故事) | 1min |
| 3 | 解决方案 | 你的产品如何解决 | 1min |
| 4 | 产品 | Demo/截图/核心功能 | 2min |
| 5 | 市场规模 | TAM/SAM/SOM | 1min |
| 6 | 商业模式 | 如何赚钱 | 1min |
| 7 | Traction | 关键指标和增长曲线 | 1min |
| 8 | 竞争 | 竞争格局和壁垒 | 1min |
| 9 | 团队 | 核心团队背景 | 1min |
| 10 | 财务预测 | 3年财务计划 | 1min |
| 11 | 融资需求 | 本轮融资金额和用途 | 30s |
| 12 | 联系方式 | 谢谢 + 联系信息 | 15s |

---

## Valuation Methods

### 1. 对标法 (Comparable)
\`\`\`
估值 = 同类公司估值中位数 x 调整系数
调整系数 = (你的增速 / 对标增速) x (你的规模 / 对标规模)
\`\`\`

### 2. Revenue Multiple (收入倍数)
\`\`\`
Pre-revenue: 500万 - 2000万 (看团队和赛道)
有收入: ARR x 10-30x (SaaS)
        GMV x 0.5-2x (电商)
        Revenue x 5-15x (一般互联网)
\`\`\`

### 3. 500 Startups Rule (种子轮)
\`\`\`
基础: 500万
+ 有原型: +100-200万
+ 有收入: +100-500万
+ 有增长: +200-500万
+ 明星团队: +200-500万
\`\`\`

---

## Financial Model Template

| Metric | Y1 | Y2 | Y3 |
|--------|-----|-----|-----|
| 用户数 | {{}} | {{}} | {{}} |
| 付费用户 | {{}} | {{}} | {{}} |
| ARPU (元/月) | {{}} | {{}} | {{}} |
| MRR (万) | {{}} | {{}} | {{}} |
| ARR (万) | {{}} | {{}} | {{}} |
| 运营成本 (万) | {{}} | {{}} | {{}} |
| 人员成本 (万) | {{}} | {{}} | {{}} |
| 毛利率 | __% | __% | __% |
| 净利润 (万) | {{}} | {{}} | {{}} |
| 现金余额 (万) | {{}} | {{}} | {{}} |
| Runway (月) | {{}} | {{}} | {{}} |

---

## Fundraising Checklist

- [ ] Pitch deck (10-12 slides)
- [ ] 财务模型 (3年预测)
- [ ] 一页纸摘要 (Executive Summary)
- [ ] 数据室 (Data Room) 准备
- [ ] 目标投资人列表 (50+)
- [ ] 投资人介绍渠道梳理
- [ ] 练习 Pitch (至少 20 次)
- [ ] Term Sheet 模板了解
- [ ] 律师（FA可选）确定
EOF
}

cmd_legal() {
  local stage="$1" industry="$2"
  cat <<EOF
# ⚖️ Legal & Compliance Guide

**Stage:** ${stage} | **Industry:** ${industry}

---

## Legal Checklist by Stage

### Pre-Launch

- [ ] 公司注册完成
- [ ] 股权协议签署（创始人协议）
- [ ] 商标申请提交
- [ ] 域名注册
- [ ] 用户协议和隐私政策
- [ ] ICP备案（如有网站/App）

### Post-Launch

- [ ] 员工劳动合同
- [ ] 保密协议 (NDA)
- [ ] 竞业限制协议
- [ ] 知识产权归属协议
- [ ] 供应商/合作伙伴合同
- [ ] 数据合规（个人信息保护法）

### Fundraising

- [ ] Term Sheet 审核
- [ ] 投资协议
- [ ] 股东协议修订
- [ ] 公司章程修订
- [ ] 尽职调查准备

---

## 创始人协议核心条款

| 条款 | 重要性 | 建议 |
|------|--------|------|
| 股权比例 | 极高 | 技能+资源+时间综合评估 |
| 期权池 | 极高 | 预留 10-20% |
| 成熟期 (Vesting) | 极高 | 4年, 1年cliff |
| 退出机制 | 极高 | Good/Bad Leaver 条款 |
| 全职承诺 | 高 | 明确全职时间节点 |
| 竞业禁止 | 高 | 离开后 1-2 年 |
| 知识产权归属 | 极高 | 所有 IP 归公司 |
| 决策机制 | 高 | 投票权/一票否决权 |

---

## Key Laws & Regulations (China)

| Law | Applies To | Key Requirements |
|-----|-----------|-----------------|
| 公司法 | 所有公司 | 注册/治理/股东权利 |
| 劳动合同法 | 有员工的公司 | 合同/工时/社保 |
| 个人信息保护法 (PIPL) | 处理个人信息 | 告知同意/最小必要 |
| 网络安全法 | 网络运营者 | 等保/数据本地化 |
| 电子商务法 | 电商平台 | 消费者权益/公示 |
| 反不正当竞争法 | 所有企业 | 商业秘密/虚假宣传 |
| 广告法 | 有广告的公司 | 极限词/证据支撑 |

---

## 知识产权保护

| IP Type | 申请渠道 | 费用 | 时间 | 保护期 |
|---------|----------|------|------|--------|
| 商标 | 国家知识产权局 | 300/类 | 9-12月 | 10年(可续) |
| 专利(发明) | 国家知识产权局 | 3,000+ | 18-36月 | 20年 |
| 专利(实用新型) | 国家知识产权局 | 1,000+ | 6-12月 | 10年 |
| 软件著作权 | 版权保护中心 | 300 | 1-2月 | 50年 |
| 域名 | 域名注册商 | 50-500/年 | 即时 | 按年续费 |

> 创业第一天就申请商标！先到先得。
EOF
}

cmd_growth() {
  local stage="$1" industry="$2"
  cat <<EOF
# 📈 Growth Strategy Guide

**Stage:** ${stage} | **Industry:** ${industry}

---

## Growth Framework: AARRR

\`\`\`
Acquisition (获客)     -- 用户从哪来?
    |
    v
Activation (激活)      -- 首次 "Aha!" 体验
    |
    v
Retention (留存)       -- 用户持续回来
    |
    v
Revenue (变现)         -- 用户付费
    |
    v
Referral (推荐)        -- 用户推荐新用户
\`\`\`

---

## Acquisition Channels (获客渠道)

### Free Channels (免费)

| Channel | Effort | Time to ROI | Best For |
|---------|--------|-------------|----------|
| SEO / 内容营销 | High | 3-6 months | SaaS, B2B |
| 社交媒体 (自然流量) | Medium | 1-3 months | B2C, D2C |
| 社区运营 (知乎/V2EX) | Medium | 2-4 months | Tech, B2B |
| 口碑/推荐 | Low | Ongoing | All |
| Product Hunt / 少数派 | Low | 1 day | Tech products |
| 合作/Cross-promotion | Medium | 1-2 months | All |

### Paid Channels (付费)

| Channel | CAC Range | Best For | Min Budget |
|---------|-----------|----------|------------|
| 微信广告 | 5-50 | B2C, 本地生意 | 5,000/月 |
| 抖音/巨量引擎 | 3-30 | B2C, 电商 | 5,000/月 |
| 百度SEM | 10-100 | B2B, 高客单价 | 3,000/月 |
| Google Ads | 1-50 USD | 出海, B2B | 1,000 USD/月 |
| KOL/KOC | 500-50,000 | B2C, 新品 | 10,000/月 |

---

## Key Metrics by Stage

### Early Stage (0-1000 users)

| Metric | Target | How to Measure |
|--------|--------|----------------|
| DAU/MAU | >20% | Analytics |
| D1 Retention | >40% | Cohort analysis |
| D7 Retention | >20% | Cohort analysis |
| D30 Retention | >10% | Cohort analysis |
| NPS | >50 | Survey |
| Activation Rate | >60% | Funnel |

### Growth Stage (1000+ users)

| Metric | Target | How to Measure |
|--------|--------|----------------|
| MRR Growth | >15%/month | Revenue tracking |
| CAC Payback | <12 months | CAC / monthly margin |
| LTV/CAC | >3 | Cohort LTV / CAC |
| Churn Rate | <5%/month | Cancellations / total |
| Viral Coefficient | >0.5 | Invites x conversion |

---

## Growth Experiment Template

### Hypothesis
> If we {{change}}, then {{metric}} will {{improve by X%}},
> because {{reasoning}}.

### Experiment

| Field | Value |
|-------|-------|
| Name | {{experiment_name}} |
| Metric | {{primary_metric}} |
| Audience | {{who}} |
| Duration | {{days/weeks}} |
| Sample Size | {{needed for significance}} |
| Expected Impact | +{{X}}% |

### Results

| Variant | Users | Conversions | Rate | Confidence |
|---------|-------|-------------|------|------------|
| Control | {{n}} | {{n}} | {{%}} | -- |
| Test | {{n}} | {{n}} | {{%}} | {{%}} |

### Decision: Ship / Kill / Iterate

---

## North Star Metric Examples

| Type | North Star | Why |
|------|-----------|-----|
| SaaS | Weekly Active Users | Engagement = retention |
| Marketplace | Transactions completed | Core value exchange |
| E-commerce | Purchases per buyer | Revenue driver |
| Social | Daily active users | Network effects |
| Content | Content consumed (min) | Engagement depth |
| Fintech | Assets under management | Trust + stickiness |
EOF
}

case "$CMD" in
  checklist) cmd_checklist "$STAGE" "$INDUSTRY" ;;
  register)  cmd_register "$STAGE" "$INDUSTRY" ;;
  mvp)       cmd_mvp "$STAGE" "$INDUSTRY" ;;
  fundraise) cmd_fundraise "$STAGE" "$INDUSTRY" ;;
  legal)     cmd_legal "$STAGE" "$INDUSTRY" ;;
  growth)    cmd_growth "$STAGE" "$INDUSTRY" ;;
  help|--help|-h) show_help ;;
  *)
    echo "❌ Unknown command: $CMD"
    echo "Run 'bash startup.sh help' for usage."
    exit 1
    ;;
esac
