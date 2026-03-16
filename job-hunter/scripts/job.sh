#!/usr/bin/env bash
set -euo pipefail

DATA_DIR="$HOME/.job-hunter"
DATA_FILE="$DATA_DIR/applications.json"

ensure_data_dir() {
  mkdir -p "$DATA_DIR"
  if [ ! -f "$DATA_FILE" ]; then
    echo '{"applications":[],"next_id":1}' > "$DATA_FILE"
  fi
}

show_help() {
cat << 'EOF'
╔══════════════════════════════════════════════════╗
║        🎯 Job Hunter — 求职管理助手              ║
╠══════════════════════════════════════════════════╣
║                                                  ║
║  Commands / 命令:                                ║
║                                                  ║
║  resume <name> <position>                        ║
║    → 生成Markdown简历文件 / Generate resume .md  ║
║    → 根据职位智能匹配技能和项目模板              ║
║                                                  ║
║  score <file_path>                               ║
║    → 简历评分 (10维度/100分) / Score resume       ║
║    → 文档长度/量化数据/动词/关键词/结构等        ║
║                                                  ║
║  cover-letter <company> <position>               ║
║    → 生成求职信 / Generate cover letter           ║
║                                                  ║
║  interview <position>                            ║
║    → 面试准备 / Interview prep Q&A               ║
║                                                  ║
║  salary <position> <city>                        ║
║    → 薪资参考 / Salary reference                  ║
║                                                  ║
║  tracker add <company> <position> <status>       ║
║    → 添加求职记录 / Add application               ║
║                                                  ║
║  tracker list                                    ║
║    → 查看记录 / List applications                 ║
║                                                  ║
║  tracker update <id> <new_status>                ║
║    → 更新状态 / Update status                     ║
║                                                  ║
║  elevator-pitch <position>                       ║
║    → 30秒自我介绍 / 30s elevator pitch            ║
║                                                  ║
║  follow-up <company>                             ║
║    → 面试跟进邮件 / Follow-up email templates     ║
║                                                  ║
║  compare <offer1> <offer2>                       ║
║    → Offer对比分析 / Compare two offers           ║
║                                                  ║
║  match "JD文本"                                  ║
║    → JD匹配分析 / Analyze JD skill match          ║
║    → 从JD提取技能要求，对比简历匹配度            ║
║    → 痛点："投了很多没回复，简历和JD不匹配"      ║
║                                                  ║
║  mock "职位" "轮次"                              ║
║    → 模拟面试 / Mock interview Q&A                ║
║    → 轮次: HR轮/技术轮/终面                      ║
║    → 10题+考察点+回答框架+避坑提示               ║
║    → 痛点："面试紧张不知道怎么答"                ║
║                                                  ║
║  help                                            ║
║    → 显示帮助 / Show this help                    ║
║                                                  ║
║  Status options / 状态选项:                       ║
║    待投递/pending, 已投递/applied,                ║
║    面试中/interviewing, 已录用/offered,           ║
║    已拒绝/rejected, 已放弃/withdrawn              ║
║                                                  ║
╚══════════════════════════════════════════════════╝
EOF
}

# ── Python helper ──────────────────────────────────
run_python() {
  python3 -c "$1"
}

# ── resume (markdown文件生成) ──────────────────────
cmd_resume() {
  local name="${1:-}" position="${2:-}"
  if [ -z "$name" ] || [ -z "$position" ]; then
    echo "Usage: job.sh resume <name> <position>"
    echo "用法: job.sh resume <姓名> <职位>"
    echo "示例: job.sh resume 张三 前端工程师"
    exit 1
  fi

  export JH_NAME="$name"
  export JH_POSITION="$position"
  python3 << 'PYEOF'
import os, sys, datetime

name = os.environ["JH_NAME"]
position = os.environ["JH_POSITION"]
today = datetime.date.today().strftime("%Y-%m-%d")

# ── 职位→技能/项目智能匹配 ──
skill_map = {
    "frontend": {
        "keywords": ["前端", "frontend", "web", "html", "css", "react", "vue", "angular", "h5", "小程序"],
        "skills": ["React / Vue.js", "TypeScript / JavaScript (ES6+)", "HTML5 / CSS3 / Sass", "Webpack / Vite 构建工具", "Ant Design / Element UI", "RESTful API / GraphQL", "Git / CI/CD", "响应式布局 / 移动端适配"],
        "projects": [
            {
                "name": "企业级中后台管理系统",
                "desc": "基于 React + TypeScript + Ant Design Pro 搭建的企业级后台，涵盖权限管理、数据看板、工单系统等模块",
                "stack": "React, TypeScript, Ant Design Pro, Umi.js, Dva, Echarts",
                "result": "支撑 [X] 个业务线日常运营，页面性能优化后首屏加载时间从 [X]s 降至 [X]s，提升 [XX]%"
            },
            {
                "name": "移动端 H5 营销活动平台",
                "desc": "面向 C 端用户的活动页生成平台，支持拖拽搭建、模板复用、数据埋点",
                "stack": "Vue 3, Vite, Pinia, Vant, Canvas",
                "result": "累计承载 [X] 场营销活动，覆盖用户 [X] 万+，活动页平均转化率提升 [XX]%"
            }
        ],
        "exp": [
            {
                "title": "高级前端工程师",
                "duties": [
                    "主导前端架构设计与技术选型，推动团队从 jQuery 迁移至 React/Vue 技术栈",
                    "搭建前端工程化体系（ESLint + Prettier + Husky + CI），代码质量问题减少 [XX]%",
                    "优化 Webpack 构建流程，打包体积减少 [XX]%，构建速度提升 [XX]%"
                ]
            },
            {
                "title": "前端工程师",
                "duties": [
                    "负责核心业务模块的前端开发与维护，参与需求评审和技术方案设计",
                    "封装 [X]+ 个通用业务组件，提升团队开发效率 [XX]%",
                    "主导前端性能优化，Lighthouse 评分从 [X] 提升至 [X]"
                ]
            }
        ]
    },
    "backend": {
        "keywords": ["后端", "backend", "服务端", "java", "python", "go", "golang", "php", "node", "c++", "server"],
        "skills": ["Java / Spring Boot / Spring Cloud", "Python / Go", "MySQL / PostgreSQL / Redis", "Kafka / RabbitMQ 消息队列", "Docker / Kubernetes / 微服务", "RESTful API / gRPC 设计", "Linux / Shell / Nginx", "分布式系统 / 高可用架构"],
        "projects": [
            {
                "name": "高并发订单处理系统",
                "desc": "基于 Spring Cloud 微服务架构的订单系统，支持秒杀、库存扣减、分布式事务",
                "stack": "Java, Spring Boot, Spring Cloud, Redis, Kafka, MySQL",
                "result": "系统 QPS 从 [X] 提升至 [X]，99.9% 请求响应时间 < [X]ms，订单处理成功率 [XX]%"
            },
            {
                "name": "数据中台 API 网关",
                "desc": "统一的 API 网关服务，集成鉴权、限流、熔断、日志、监控等能力",
                "stack": "Go, gRPC, Redis, Prometheus, Grafana, Docker",
                "result": "承载日均 [X] 亿次 API 调用，可用性达 [XX]%，接入下游 [X]+ 个微服务"
            }
        ],
        "exp": [
            {
                "title": "高级后端工程师",
                "duties": [
                    "主导核心服务架构设计，推动单体应用拆分为 [X] 个微服务，系统可用性提升至 [XX]%",
                    "设计并实现分布式缓存方案，数据库 QPS 降低 [XX]%，平均响应时间减少 [XX]%",
                    "建立代码 Review 和 CI/CD 流程，线上故障率降低 [XX]%"
                ]
            },
            {
                "title": "后端工程师",
                "duties": [
                    "参与核心业务模块开发，编写高质量代码，单元测试覆盖率达 [XX]%",
                    "优化慢 SQL 和数据库索引，关键接口响应时间从 [X]s 降至 [X]ms",
                    "编写技术文档 [X]+ 篇，推动团队知识沉淀"
                ]
            }
        ]
    },
    "product": {
        "keywords": ["产品", "product", "pm", "产品经理", "产品设计"],
        "skills": ["PRD / BRD / MRD 文档撰写", "Axure / Figma / Sketch 原型设计", "用户调研 / 用户画像 / 竞品分析", "数据分析 (SQL / Excel / 神策)", "项目管理 (Jira / Tapd / 飞书)", "A/B 测试 / 增长实验", "商业模式分析 / ROI 评估", "跨部门协调 / 需求管理"],
        "projects": [
            {
                "name": "用户增长体系搭建",
                "desc": "从 0 到 1 搭建用户增长体系，涵盖拉新、激活、留存、变现全链路",
                "stack": "Axure, 神策分析, SQL, A/B 测试平台",
                "result": "新用户次日留存率从 [XX]% 提升至 [XX]%，月活跃用户增长 [XX]%"
            },
            {
                "name": "核心交易流程优化",
                "desc": "重新梳理并优化下单-支付-履约全流程，减少用户操作步骤和流失节点",
                "stack": "Figma, 用户访谈, 漏斗分析, 热力图",
                "result": "下单转化率提升 [XX]%，客诉率降低 [XX]%，GMV 月增 [X] 万"
            }
        ],
        "exp": [
            {
                "title": "高级产品经理",
                "duties": [
                    "主导 [X] 条核心产品线规划，制定产品路线图，季度 OKR 完成率 [XX]%",
                    "推动用户增长策略落地，DAU 从 [X] 万提升至 [X] 万",
                    "组织跨部门需求评审，协调研发、设计、运营团队高效交付"
                ]
            },
            {
                "title": "产品经理",
                "duties": [
                    "负责 [X] 个功能模块的需求分析和原型设计，输出 PRD [X]+ 份",
                    "深度参与用户调研 [X]+ 次，产出用户画像和竞品分析报告",
                    "跟进项目全流程，确保按时上线，项目按时交付率 [XX]%"
                ]
            }
        ]
    },
    "ops": {
        "keywords": ["运营", "operation", "增长", "growth", "内容运营", "活动运营", "用户运营", "社区运营"],
        "skills": ["活动策划 / 活动执行", "数据分析 (Excel / SQL / 神策)", "用户增长 / AARRR 模型", "内容运营 / 社区运营", "ROI 分析 / 预算管理", "新媒体运营 (公众号 / 抖音 / 小红书)", "用户分层 / 精细化运营", "渠道投放 / SEM / 信息流"],
        "projects": [
            {
                "name": "全年营销活动体系",
                "desc": "策划并执行全年 [X]+ 场营销活动，涵盖节日大促、会员日、裂变拉新",
                "stack": "活动策划, 数据分析, 渠道投放, CRM",
                "result": "全年活动带来新用户 [X] 万+，活动 ROI 平均 [X]:1，GMV 贡献占比 [XX]%"
            },
            {
                "name": "用户生命周期运营体系",
                "desc": "建立用户分层模型，针对新用户/活跃/沉默/流失用户制定差异化运营策略",
                "stack": "SQL, 用户画像, Push/短信触达, A/B 测试",
                "result": "用户 30 日留存率提升 [XX]%，召回率提升 [XX]%，LTV 提升 [XX]%"
            }
        ],
        "exp": [
            {
                "title": "高级运营经理",
                "duties": [
                    "主导用户增长策略，通过裂变+内容+渠道组合拳，月均新增用户 [X] 万",
                    "搭建数据看板和运营指标体系，推动数据驱动决策文化",
                    "管理运营团队 [X] 人，制定团队 OKR 和绩效考核方案"
                ]
            },
            {
                "title": "运营专员",
                "duties": [
                    "策划执行线上活动 [X]+ 场，单场活动最高参与用户 [X] 万",
                    "负责公众号 / 社群日常运营，粉丝增长 [XX]%，社群活跃度提升 [XX]%",
                    "输出运营周报和月报，追踪核心指标达成情况"
                ]
            }
        ]
    },
    "design": {
        "keywords": ["设计", "design", "ui", "ux", "视觉", "交互", "美术", "平面"],
        "skills": ["Figma / Sketch / Adobe XD", "Photoshop / Illustrator", "UI 设计 / 视觉规范", "UX 设计 / 交互设计 / 用户旅程", "设计系统 / Design Token", "动效设计 (AE / Lottie / Principle)", "响应式设计 / 多端适配", "设计走查 / 开发协作"],
        "projects": [
            {
                "name": "品牌设计系统搭建",
                "desc": "从 0 到 1 搭建企业级设计系统，统一品牌视觉语言和组件库",
                "stack": "Figma, Design Token, Storybook, 设计规范文档",
                "result": "设计效率提升 [XX]%，UI 一致性问题减少 [XX]%，覆盖 [X]+ 个产品线"
            },
            {
                "name": "核心产品体验升级",
                "desc": "对核心产品进行全面的 UX 审查和视觉升级，优化关键用户流程",
                "stack": "Figma, 用户测试, 热力图分析, A/B 测试",
                "result": "用户满意度 NPS 提升 [X] 分，核心流程完成率提升 [XX]%，设计好评率 [XX]%"
            }
        ],
        "exp": [
            {
                "title": "高级 UI/UX 设计师",
                "duties": [
                    "主导产品视觉体系升级，建立设计规范和组件库，设计交付效率提升 [XX]%",
                    "推动以用户为中心的设计流程，组织可用性测试 [X]+ 次",
                    "与产品和研发团队紧密协作，设计方案一次通过率 [XX]%"
                ]
            },
            {
                "title": "UI 设计师",
                "duties": [
                    "负责 [X]+ 个项目的 UI 设计和视觉规范制定",
                    "输出高保真设计稿和切图标注，与前端协作完成像素级还原",
                    "参与设计评审 [X]+ 次，持续打磨产品视觉品质"
                ]
            }
        ]
    }
}

# 默认（通用）
default_profile = {
    "skills": ["Office 办公软件 (Word / Excel / PPT)", "数据分析与报告撰写", "项目管理与跨部门协调", "沟通表达与团队协作", "快速学习与问题解决", "时间管理与多任务处理"],
    "projects": [
        {
            "name": "业务流程优化项目",
            "desc": "梳理现有业务流程，识别瓶颈和改进点，推动流程标准化",
            "stack": "流程图, 数据分析, 项目管理工具",
            "result": "流程效率提升 [XX]%，人力成本节省 [XX]%"
        },
        {
            "name": "跨部门协作专项",
            "desc": "牵头组织跨部门协作项目，统一工作标准和交付规范",
            "stack": "项目管理, 文档协作, 数据看板",
            "result": "项目按时交付率从 [XX]% 提升至 [XX]%，团队满意度提升 [XX]%"
        }
    ],
    "exp": [
        {
            "title": position,
            "duties": [
                "主导核心业务模块的规划与执行，推动关键指标达成 [XX]%",
                "建立标准化工作流程和文档体系，团队效率提升 [XX]%",
                "跨部门协调资源，确保项目按时高质量交付"
            ]
        },
        {
            "title": position,
            "duties": [
                "参与业务需求分析和方案设计，独立完成 [X]+ 个项目交付",
                "持续优化工作方法，在 [具体方向] 取得 [XX]% 的效率提升",
                "撰写工作文档和复盘报告 [X]+ 篇，沉淀最佳实践"
            ]
        }
    ]
}

# 匹配职位类别
pos_lower = position.lower()
matched = None
for key, profile in skill_map.items():
    for kw in profile["keywords"]:
        if kw in pos_lower:
            matched = profile
            break
    if matched:
        break

if not matched:
    matched = default_profile

skills = matched["skills"]
projects = matched["projects"]
experiences = matched["exp"]

# ── 生成 Markdown ──
lines = []
lines.append("# {name} — {position}".format(name=name, position=position))
lines.append("")
lines.append("> 📅 生成日期: {today}".format(today=today))
lines.append("")

# 个人信息
lines.append("## 📋 个人信息")
lines.append("")
lines.append("| 项目 | 信息 |")
lines.append("|------|------|")
lines.append("| **姓名** | {name} |".format(name=name))
lines.append("| **目标职位** | {position} |".format(position=position))
lines.append("| **邮箱** | your.email@example.com |")
lines.append("| **电话** | +86-1XX-XXXX-XXXX |")
lines.append("| **LinkedIn** | linkedin.com/in/yourprofile |")
lines.append("| **GitHub/作品集** | github.com/yourprofile |")
lines.append("")

# 专业摘要
lines.append("## 🎯 专业摘要")
lines.append("")
lines.append("具备丰富{position}领域实战经验的专业人士，擅长将业务需求转化为高质量的交付成果。".format(position=position))
lines.append("善于团队协作与跨部门沟通，注重数据驱动和结果导向，持续追踪行业前沿技术与方法论。")
lines.append("期望加入一个富有挑战的团队，在{position}方向持续深耕并创造更大价值。".format(position=position))
lines.append("")

# 工作经历
lines.append("## 💼 工作经历")
lines.append("")
lines.append("### {title} | XX科技有限公司".format(title=experiences[0]["title"]))
lines.append("")
lines.append("📆 YYYY.MM - 至今")
lines.append("")
for d in experiences[0]["duties"]:
    lines.append("- {d}".format(d=d))
lines.append("")
lines.append("### {title} | XX信息技术有限公司".format(title=experiences[1]["title"]))
lines.append("")
lines.append("📆 YYYY.MM - YYYY.MM")
lines.append("")
for d in experiences[1]["duties"]:
    lines.append("- {d}".format(d=d))
lines.append("")

# 项目经验
lines.append("## 🚀 项目经验")
lines.append("")
for i, p in enumerate(projects):
    lines.append("### 项目{n}: {name}".format(n=i+1, name=p["name"]))
    lines.append("")
    lines.append("**项目简介:** {desc}".format(desc=p["desc"]))
    lines.append("")
    lines.append("**技术栈:** `{stack}`".format(stack=p["stack"]))
    lines.append("")
    lines.append("**项目成果:** {result}".format(result=p["result"]))
    lines.append("")

# 技能清单
lines.append("## 🛠️ 技能清单")
lines.append("")
for s in skills:
    lines.append("- {s}".format(s=s))
lines.append("")

# 教育背景
lines.append("## 🎓 教育背景")
lines.append("")
lines.append("**XX大学** — XX专业 — 本科/硕士")
lines.append("")
lines.append("📆 YYYY.MM - YYYY.MM")
lines.append("")
lines.append("- GPA: [X.X / 4.0]")
lines.append("- 相关课程: [填写与目标职位相关的课程]")
lines.append("- 荣誉/奖项: [填写获奖情况]")
lines.append("")

# Tips
lines.append("---")
lines.append("")
lines.append("💡 **简历优化小贴士:**")
lines.append("")
lines.append("1. 将 `[X]` `[XX]%` 替换为你的真实数据，量化是简历的灵魂")
lines.append("2. 根据目标公司 JD 调整技能和经历的描述重点")
lines.append("3. 控制在 1-2 页以内，重点突出，避免流水账")
lines.append('4. 多用 **主导/推动/提升/优化** 等强动词，少用"负责"')
lines.append("5. 使用 `job.sh score <文件路径>` 评估你的简历质量！")
lines.append("")

content = "\n".join(lines)

# 写文件
filename = "resume_{name}_{position}.md".format(name=name, position=position)
with open(filename, "w") as f:
    f.write(content)

print("✅ 简历已生成！")
print("")
print("📄 文件: {fn}".format(fn=filename))
print("📏 字数: {n} 字".format(n=len(content)))
print("")
print("📝 下一步:")
print("   1. 用编辑器打开文件，替换 [X] [XX]% 为你的真实数据")
print("   2. 运行 job.sh score \"{fn}\" 评分".format(fn=filename))
print("")
print(content)
PYEOF
}

# ── cover-letter ───────────────────────────────────
cmd_cover_letter() {
  local company="${1:-}" position="${2:-}"
  if [ -z "$company" ] || [ -z "$position" ]; then
    echo "Usage: job.sh cover-letter <company> <position>"
    echo "用法: job.sh cover-letter <公司> <职位>"
    exit 1
  fi

  run_python "
company = '${company}'
position = '${position}'

print('''
=====================================
  COVER LETTER / 求职信
=====================================

尊敬的{company}招聘团队：

  您好！我对贵公司发布的{position}职位非常感兴趣，特此投递简历。

  【为什么选择贵公司 / Why {company}】
  [说明对公司的了解和认同 / Show your knowledge of the company]

  【为什么选择我 / Why Me】
  [展示相关经验和技能 / Highlight relevant experience and skills]

  【我能带来什么 / What I Bring】
  [具体贡献和价值 / Specific contributions and value]

  期待与您进一步沟通的机会。感谢您的时间！

  此致
  敬礼

  [你的姓名 / Your Name]
  [联系方式 / Contact Info]

-------------------------------------

Dear {company} Hiring Team,

  I am writing to express my strong interest in the {position}
  position at {company}.

  【Why {company}】
  [Demonstrate knowledge of the company and alignment with its mission]

  【Why Me】
  [Highlight relevant experience, skills, and achievements]

  【What I Bring】
  [Describe specific value you would add to the team]

  I look forward to the opportunity to discuss how I can contribute
  to your team. Thank you for your time and consideration.

  Sincerely,
  [Your Name]
  [Contact Information]

=====================================
  💡 提示 / Tips:
  - 每封求职信都应针对目标公司定制
    Customize each cover letter for the target company
  - 研究公司文化、产品和最新动态
    Research company culture, products, and recent news
  - 用具体数据支撑你的能力
    Support claims with specific data and examples
=====================================
'''.format(company=company, position=position))
"
}

# ── interview ──────────────────────────────────────
cmd_interview() {
  local position="${1:-}"
  if [ -z "$position" ]; then
    echo "Usage: job.sh interview <position>"
    echo "用法: job.sh interview <职位>"
    exit 1
  fi

  run_python "
position = '${position}'

print('''
=====================================
  INTERVIEW PREP / 面试准备
  职位 / Position: {position}
=====================================

【通用问题 / General Questions】

  Q1: 请做一下自我介绍
      Tell me about yourself.
  A:  用2-3分钟介绍背景、经验、为什么适合该职位。
      Spend 2-3 min on background, experience, and fit.

  Q2: 你为什么想来我们公司？
      Why do you want to work here?
  A:  展示对公司的了解，说明价值观契合。
      Show company knowledge and value alignment.

  Q3: 你的优势和劣势是什么？
      What are your strengths and weaknesses?
  A:  优势举实例；劣势说改进措施。
      Give examples for strengths; show improvement for weaknesses.

  Q4: 描述一个你遇到的挑战以及如何解决的。
      Describe a challenge you faced and how you solved it.
  A:  使用STAR法则(情境-任务-行动-结果)。
      Use STAR method (Situation-Task-Action-Result).

  Q5: 你的职业规划是什么？
      Where do you see yourself in 5 years?
  A:  展示成长意愿，与公司发展方向一致。
      Show growth mindset aligned with company direction.

【{position}专业问题 / Role-Specific Questions】

  Q6: 你在{position}领域有哪些核心技能？
      What are your core skills for {position}?
  A:  列举3-5个核心技能并举例说明。
      List 3-5 core skills with examples.

  Q7: 描述一个你最成功的项目。
      Describe your most successful project.
  A:  项目背景→你的角色→具体贡献→量化成果。
      Context → Role → Contribution → Quantified results.

  Q8: 你如何处理工作中的冲突？
      How do you handle conflicts at work?
  A:  先倾听→找共同点→协商方案→执行跟进。
      Listen → Find common ground → Negotiate → Follow up.

【行为面试 / Behavioral Questions】

  Q9: 你如何管理deadline和多任务？
      How do you manage deadlines and multitasking?
  A:  优先级排序→时间管理工具→及时沟通。
      Prioritize → Time management tools → Communicate proactively.

  Q10: 你犯过的最大错误是什么？从中学到了什么？
       What is the biggest mistake you have made? What did you learn?
  A:   诚实面对→分析原因→改进措施→后续成长。
       Be honest → Analyze cause → Improvements → Growth.

【反问环节 / Questions to Ask Interviewer】

  • 这个职位的日常工作是什么样的？
    What does a typical day look like in this role?
  • 团队目前面临的最大挑战是什么？
    What is the biggest challenge the team is facing?
  • 公司如何支持员工的职业发展？
    How does the company support career development?
  • 接下来的面试流程是怎样的？
    What are the next steps in the interview process?

=====================================
  💡 面试技巧 / Interview Tips:
  - 提前15分钟到达 / Arrive 15 min early
  - 准备好简历复印件 / Bring resume copies
  - 练习STAR法则回答 / Practice STAR answers
  - 对公司做充分调研 / Research the company
  - 准备3-5个反问 / Prepare 3-5 questions to ask
=====================================
'''.format(position=position))
"
}

# ── salary ─────────────────────────────────────────
cmd_salary() {
  local position="${1:-}" city="${2:-}"
  if [ -z "$position" ] || [ -z "$city" ]; then
    echo "Usage: job.sh salary <position> <city>"
    echo "用法: job.sh salary <职位> <城市>"
    exit 1
  fi

  run_python "
import hashlib

position = '${position}'
city = '${city}'

# Deterministic pseudo-salary based on position+city hash
h = hashlib.md5((position + city).encode()).hexdigest()
base = int(h[:4], 16) % 30 + 8  # 8k-38k base
low_k = base
mid_k = int(base * 1.5)
high_k = base * 2 + 5

tier_1_cities = ['北京', '上海', '深圳', '杭州', 'Beijing', 'Shanghai', 'Shenzhen', 'Hangzhou',
                 'San Francisco', 'New York', 'Seattle', 'London', 'Tokyo']
tier_2_cities = ['成都', '武汉', '南京', '广州', '苏州', 'Chengdu', 'Wuhan', 'Nanjing',
                 'Guangzhou', 'Austin', 'Denver', 'Boston']

multiplier = 1.0
tier_label = '三线及其他 / Tier 3+'
for c in tier_1_cities:
    if c.lower() in city.lower():
        multiplier = 1.4
        tier_label = '一线城市 / Tier 1'
        break
else:
    for c in tier_2_cities:
        if c.lower() in city.lower():
            multiplier = 1.15
            tier_label = '二线城市 / Tier 2'
            break

low = int(low_k * multiplier)
mid = int(mid_k * multiplier)
high = int(high_k * multiplier)

print('''
=====================================
  SALARY REFERENCE / 薪资参考
=====================================

  职位 / Position:  {position}
  城市 / City:      {city}
  城市等级 / Tier:  {tier}

  ┌──────────────────────────────────┐
  │  月薪范围 / Monthly Salary (CNY) │
  │                                  │
  │  初级 / Junior:   {low}K - {mid}K        │
  │  中级 / Mid:      {mid}K - {high}K        │
  │  高级 / Senior:   {high}K+               │
  │                                  │
  │  年薪参考 / Annual (x15 months)  │
  │  Junior: {low15}W - {mid15}W             │
  │  Mid:    {mid15}W - {high15}W             │
  │  Senior: {high15}W+                      │
  └──────────────────────────────────┘

=====================================
  💡 谈薪建议 / Negotiation Tips:
  - 了解市场行情再报价
    Research market rates before negotiating
  - 考虑总包：base+奖金+股票+福利
    Consider total comp: base+bonus+equity+benefits
  - 不要先报价，让对方先出
    Let the employer make the first offer
  - 有备选offer可以增加谈判筹码
    Having competing offers strengthens your position
  - 不要只看钱，也看成长空间
    Look beyond salary: growth, learning, work-life balance
=====================================

  ⚠️  以上数据为参考估算，实际薪资取决于公司、经验和谈判。
      Estimates only. Actual salary depends on company, experience, and negotiation.
'''.format(
    position=position,
    city=city,
    tier=tier_label,
    low=low, mid=mid, high=high,
    low15=round(low*15/10, 1),
    mid15=round(mid*15/10, 1),
    high15=round(high*15/10, 1)
))
"
}

# ── tracker ────────────────────────────────────────
cmd_tracker() {
  ensure_data_dir
  local subcmd="${1:-}"
  shift || true

  case "$subcmd" in
    add)
      local company="${1:-}" position="${2:-}" status="${3:-待投递}"
      if [ -z "$company" ] || [ -z "$position" ]; then
        echo "Usage: job.sh tracker add <company> <position> [status]"
        echo "用法: job.sh tracker add <公司> <职位> [状态]"
        exit 1
      fi
      run_python "
import json, datetime

data_file = '${DATA_FILE}'
company = '${company}'
position = '${position}'
status = '${status}'

with open(data_file, 'r') as f:
    data = json.load(f)

app_id = data.get('next_id', 1)
now = datetime.datetime.now().strftime('%Y-%m-%d %H:%M')
entry = {
    'id': app_id,
    'company': company,
    'position': position,
    'status': status,
    'created': now,
    'updated': now
}
data['applications'].append(entry)
data['next_id'] = app_id + 1

with open(data_file, 'w') as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

print('✅ 已添加求职记录 / Application added:')
print('   ID: {}'.format(app_id))
print('   公司 / Company:  {}'.format(company))
print('   职位 / Position: {}'.format(position))
print('   状态 / Status:   {}'.format(status))
print('   时间 / Time:     {}'.format(now))
"
      ;;

    list)
      run_python "
import json

data_file = '${DATA_FILE}'

with open(data_file, 'r') as f:
    data = json.load(f)

apps = data.get('applications', [])

if not apps:
    print('📭 暂无求职记录 / No applications yet.')
    print('   使用 job.sh tracker add 添加记录')
    print('   Use job.sh tracker add to create one')
else:
    print('=====================================')
    print('  📋 求职记录 / Applications ({})'.format(len(apps)))
    print('=====================================')
    print()
    status_emoji = {
        '待投递': '⏳', 'pending': '⏳',
        '已投递': '📤', 'applied': '📤',
        '面试中': '🎤', 'interviewing': '🎤',
        '已录用': '🎉', 'offered': '🎉',
        '已拒绝': '❌', 'rejected': '❌',
        '已放弃': '🚫', 'withdrawn': '🚫',
    }
    for a in apps:
        emoji = status_emoji.get(a.get('status', ''), '📌')
        print('  {emoji} [{id}] {company} — {position}'.format(
            emoji=emoji, id=a['id'], company=a['company'], position=a['position']))
        print('     状态/Status: {status}  |  更新/Updated: {updated}'.format(
            status=a['status'], updated=a.get('updated', a.get('created', '?'))))
        print()
    print('=====================================')
"
      ;;

    update)
      local app_id="${1:-}" new_status="${2:-}"
      if [ -z "$app_id" ] || [ -z "$new_status" ]; then
        echo "Usage: job.sh tracker update <id> <new_status>"
        echo "用法: job.sh tracker update <ID> <新状态>"
        exit 1
      fi
      run_python "
import json, datetime

data_file = '${DATA_FILE}'
app_id = int('${app_id}')
new_status = '${new_status}'

with open(data_file, 'r') as f:
    data = json.load(f)

found = False
for a in data['applications']:
    if a['id'] == app_id:
        old_status = a['status']
        a['status'] = new_status
        a['updated'] = datetime.datetime.now().strftime('%Y-%m-%d %H:%M')
        found = True
        print('✅ 已更新 / Updated:')
        print('   ID: {}'.format(app_id))
        print('   {} → {}'.format(old_status, new_status))
        break

if not found:
    print('❌ 未找到ID为{}的记录 / Application ID {} not found.'.format(app_id, app_id))
else:
    with open(data_file, 'w') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
"
      ;;

    *)
      echo "Usage: job.sh tracker <add|list|update> ..."
      echo "用法: job.sh tracker <add|list|update> ..."
      exit 1
      ;;
  esac
}

# ── elevator-pitch ─────────────────────────────────
cmd_elevator_pitch() {
  local position="${1:-}"
  if [ -z "$position" ]; then
    echo "Usage: job.sh elevator-pitch <position>"
    echo "用法: job.sh elevator-pitch <职位>"
    exit 1
  fi

  run_python "
position = '${position}'

print('''
=====================================
  🎤 ELEVATOR PITCH / 30秒自我介绍
  目标职位 / Target: {position}
=====================================

【中文版】

  您好！我是[姓名]，一名专注于{position}领域的专业人士。

  在过去的[X]年里，我在[核心技能/领域]方面积累了丰富经验。
  我曾在[公司/项目]中，[具体成果，最好有数据]。

  我对{position}这个方向充满热情，特别是在[具体方向]方面。
  我相信我的经验和能力能够为贵公司带来价值。

  期待有机会进一步交流！

-------------------------------------

【English Version】

  Hi! I am [Name], a professional specializing in {position}.

  Over the past [X] years, I have built deep expertise in
  [core skills/domain]. At [Company/Project], I [specific
  achievement, ideally with metrics].

  I am passionate about {position}, especially in [specific area].
  I am confident my experience and skills can add value to your team.

  I would love the chance to discuss this further!

=====================================
  💡 演讲技巧 / Pitch Tips:
  - 控制在30秒内 / Keep it under 30 seconds
  - 先练习到流畅 / Practice until smooth
  - 保持眼神交流 / Maintain eye contact
  - 语速适中，自信 / Moderate pace, confident
  - 根据场合微调 / Adapt to the occasion
  - 结尾留个钩子 / End with a hook
=====================================
'''.format(position=position))
"
}

# ── follow-up ──────────────────────────────────────
cmd_follow_up() {
  local company="${1:-}"
  if [ -z "$company" ]; then
    echo "Usage: job.sh follow-up <company>"
    echo "用法: job.sh follow-up <公司>"
    exit 1
  fi

  export JH_COMPANY="$company"
  python3 << 'PYEOF'
import os, datetime
company = os.environ["JH_COMPANY"]
today = datetime.date.today().strftime("%Y-%m-%d")

print("""
=====================================
  📧 FOLLOW-UP EMAIL / 面试跟进邮件
  公司 / Company: {company}
  日期 / Date: {today}
=====================================

【版本1：面试后24小时内感谢信】

Subject: Thank You — {company} [职位名] Interview Follow-up

Dear [面试官姓名 / Interviewer Name],

Thank you for taking the time to speak with me today about the
[职位名] position at {company}. I truly enjoyed learning more
about the team and the exciting work you are doing.

Our conversation about [具体讨论的话题] reinforced my enthusiasm
for this role. I believe my experience in [相关技能/经验] would
allow me to make a meaningful contribution to your team.

I am very excited about the opportunity to join {company} and
would welcome the chance to discuss next steps. Please do not
hesitate to reach out if you need any additional information.

Thank you again for your time and consideration.

Best regards,
[你的姓名 / Your Name]

-------------------------------------

【中文版】

主题：感谢面试机会 — {company} [职位名]

尊敬的[面试官姓名]，

感谢您今天抽出宝贵时间与我交流{company}的[职位名]机会。

在面试中，我们讨论的[具体话题]让我对这个职位更加向往。
我相信我在[相关领域]的经验能够为团队带来价值。

期待您的回复，如需任何补充材料，请随时告知。

此致
敬礼
[你的姓名]

=====================================

【版本2：面试后1周未收到回复】

Subject: Following Up — {company} [职位名] Application

Dear [HR/面试官],

I hope this message finds you well. I wanted to follow up on my
interview for the [职位名] position on [面试日期].

I remain very interested in this opportunity and would love to
know if there are any updates on the hiring timeline. I am happy
to provide any additional information that might be helpful.

Thank you for your time, and I look forward to hearing from you.

Best regards,
[Your Name]

-------------------------------------

【版本3：面试后2周+未回复（最终跟进）】

Subject: Final Follow-up — {company} [职位名]

Dear [HR],

I wanted to reach out one last time regarding the [职位名]
position. I understand the hiring process can take time,
and I respect your timeline.

I remain enthusiastic about {company} and this role. If the
position has been filled, I would appreciate any feedback
that could help me in future opportunities.

Thank you for considering my application.

Warm regards,
[Your Name]

=====================================
  💡 跟进技巧 / Follow-up Tips:
  - 面试后24h内发感谢信（必做！）
    Send a thank-you within 24 hours (must do!)
  - 1周后未回复再发第二封
    Follow up after 1 week if no response
  - 最多跟进3次，保持专业
    Max 3 follow-ups, stay professional
  - 每封邮件加入新的价值点
    Add new value in each follow-up
  - 同时继续投其他公司，不要死等
    Keep applying elsewhere, don't wait
=====================================
""".format(company=company, today=today))
PYEOF
}

# ── compare ────────────────────────────────────────
cmd_compare() {
  local offer1="${1:-}" offer2="${2:-}"
  if [ -z "$offer1" ] || [ -z "$offer2" ]; then
    echo "Usage: job.sh compare <offer1_company> <offer2_company>"
    echo "用法: job.sh compare <公司1> <公司2>"
    exit 1
  fi

  export JH_OFFER1="$offer1"
  export JH_OFFER2="$offer2"
  python3 << 'PYEOF'
import os
offer1 = os.environ["JH_OFFER1"]
offer2 = os.environ["JH_OFFER2"]

print("""
=====================================
  ⚖️  OFFER COMPARISON / OFFER对比
  {o1}  vs  {o2}
=====================================

  请根据实际情况填写以下对比表：

  ┌─────────────────┬──────────────────┬──────────────────┐
  │  对比维度        │  {o1:<16s}│  {o2:<16s}│
  ├─────────────────┼──────────────────┼──────────────────┤
  │  💰 Base薪资     │  ___K/月         │  ___K/月         │
  │  🎁 年终奖       │  ___个月         │  ___个月         │
  │  📈 股票/期权    │  ___             │  ___             │
  │  💵 年薪总包     │  ___W            │  ___W            │
  ├─────────────────┼──────────────────┼──────────────────┤
  │  🏥 五险一金     │  全额/最低       │  全额/最低       │
  │  🏖️ 年假天数     │  ___天           │  ___天           │
  │  🍱 餐补/交通    │  ___             │  ___             │
  │  🏠 租房补贴     │  ___             │  ___             │
  │  📚 学习预算     │  ___             │  ___             │
  ├─────────────────┼──────────────────┼──────────────────┤
  │  🚀 晋升空间     │  快/中/慢        │  快/中/慢        │
  │  📖 技术成长     │  高/中/低        │  高/中/低        │
  │  👥 团队规模     │  ___人           │  ___人           │
  │  🏢 公司阶段     │  创业/成长/成熟  │  创业/成长/成熟  │
  │  📊 行业前景     │  好/一般/差      │  好/一般/差      │
  ├─────────────────┼──────────────────┼──────────────────┤
  │  🕐 工作强度     │  955/996/大小周  │  955/996/大小周  │
  │  🚇 通勤时间     │  ___分钟         │  ___分钟         │
  │  🏠 远程办公     │  支持/不支持     │  支持/不支持     │
  │  🌍 办公环境     │  好/一般/差      │  好/一般/差      │
  └─────────────────┴──────────────────┴──────────────────┘

=====================================
  📊 评分建议（满分10分）
=====================================

  建议按以下权重打分：

  | 维度           | 权重  | {o1:<8s} | {o2:<8s} |
  |----------------|-------|----------|----------|
  | 薪资总包       | 30%   | __/10    | __/10    |
  | 成长空间       | 25%   | __/10    | __/10    |
  | 工作生活平衡   | 20%   | __/10    | __/10    |
  | 公司前景       | 15%   | __/10    | __/10    |
  | 福利待遇       | 10%   | __/10    | __/10    |
  | 加权总分       | 100%  | __       | __       |

=====================================
  💡 决策建议 / Decision Tips:
  - 薪资差距 < 15% 时，优先看成长空间
    When salary gap < 15%, prioritize growth
  - 第一份工作选平台，跳槽选薪资和Title
    First job: platform; Later: salary & title
  - 考虑3年后的自己更需要什么
    Think about what you need in 3 years
  - 大公司学规范，小公司学能力
    Big co: learn process; Small co: learn skills
  - 有期权/股票的offer要评估变现概率
    Evaluate equity liquidity probability
  - 问问在职员工的真实感受
    Ask current employees about real experience
=====================================
""".format(o1=offer1, o2=offer2))
PYEOF
}

# ── score (简历评分) ───────────────────────────────
cmd_score() {
  local filepath="${1:-}"
  if [ -z "$filepath" ]; then
    echo "Usage: job.sh score <resume_file_path>"
    echo "用法: job.sh score <简历文件路径>"
    echo "示例: job.sh score resume_张三_前端工程师.md"
    exit 1
  fi
  if [ ! -f "$filepath" ]; then
    echo "❌ 文件不存在 / File not found: $filepath"
    exit 1
  fi

  export JH_SCORE_FILE="$filepath"
  python3 << 'PYEOF'
import os, re, sys

filepath = os.environ["JH_SCORE_FILE"]

try:
    with open(filepath, "r") as f:
        content = f.read()
except Exception as e:
    print("❌ 无法读取文件: {e}".format(e=e))
    sys.exit(1)

# ── 10 维度评分 ──
scores = []
suggestions = []

# 1. 文档长度 (600-1200 字最佳)
char_count = len(content)
if char_count < 300:
    s1 = 3
    sug1 = "简历过短({n}字)，建议补充到600-1200字，增加项目细节和量化数据".format(n=char_count)
elif char_count < 600:
    s1 = 6
    sug1 = "简历偏短({n}字)，建议适当扩充工作经历和项目描述".format(n=char_count)
elif char_count <= 1200:
    s1 = 10
    sug1 = "文档长度适中({n}字)，非常好！".format(n=char_count)
elif char_count <= 1800:
    s1 = 8
    sug1 = "简历偏长({n}字)，建议精简到1200字以内，突出重点".format(n=char_count)
else:
    s1 = 5
    sug1 = "简历过长({n}字)，建议大幅精简，保留核心内容".format(n=char_count)
scores.append(("文档长度", s1))
suggestions.append(sug1)

# 2. 量化数据 (数字和百分比)
numbers = re.findall(r'\d+[%％]|\d+\.\d+|\b\d{2,}\b', content)
pct_count = len([n for n in numbers if '%' in n or '％' in n])
num_count = len(numbers)
if num_count >= 15:
    s2 = 10
    sug2 = "数据量化充分(找到{n}处数据)，很好！".format(n=num_count)
elif num_count >= 8:
    s2 = 7
    sug2 = "有一定量化数据({n}处)，建议在每段工作经历中都加入具体数字".format(n=num_count)
elif num_count >= 3:
    s2 = 5
    sug2 = "量化数据较少({n}处)，建议多用数字描述成果(提升XX%、节省XX小时)".format(n=num_count)
else:
    s2 = 2
    sug2 = "几乎没有量化数据，这是简历大忌！每个成果都应有数字支撑"
scores.append(("量化数据", s2))
suggestions.append(sug2)

# 3. 动词使用
weak_verbs = ["负责", "参加", "完成", "做了", "进行"]
strong_verbs = ["主导", "推动", "提升", "优化", "搭建", "设计", "带领", "攻克",
                "实现", "构建", "落地", "打造", "驱动", "重构", "策划", "引领"]
weak_count = sum(content.count(v) for v in weak_verbs)
strong_count = sum(content.count(v) for v in strong_verbs)
if strong_count >= 8 and weak_count <= 2:
    s3 = 10
    sug3 = "动词使用出色！强动词{s}个，弱动词仅{w}个".format(s=strong_count, w=weak_count)
elif strong_count >= 5:
    s3 = 7
    sug3 = "动词还不错(强{s}/弱{w})，建议把\"负责\"替换为\"主导/推动\"".format(s=strong_count, w=weak_count)
elif strong_count >= 2:
    s3 = 5
    sug3 = "强动词较少({s}个)，弱动词较多({w}个)，建议用更有力的表达".format(s=strong_count, w=weak_count)
else:
    s3 = 3
    sug3 = "动词太弱！避免\"负责/参加\"，改用\"主导/推动/提升/优化/搭建\""
scores.append(("动词使用", s3))
suggestions.append(sug3)

# 4. 技能关键词密度
tech_keywords = ["react", "vue", "java", "python", "go", "sql", "redis", "docker",
                 "kubernetes", "spring", "typescript", "javascript", "css", "html",
                 "figma", "sketch", "axure", "git", "linux", "api", "微服务",
                 "分布式", "机器学习", "深度学习", "数据分析", "项目管理",
                 "agile", "scrum", "ci/cd", "webpack", "node", "aws", "k8s",
                 "prd", "roi", "seo", "sem", "a/b"]
content_lower = content.lower()
found_keywords = [kw for kw in tech_keywords if kw in content_lower]
kw_count = len(found_keywords)
if kw_count >= 10:
    s4 = 10
    sug4 = "技能关键词丰富({n}个)，ATS友好度高！".format(n=kw_count)
elif kw_count >= 6:
    s4 = 7
    sug4 = "关键词数量可以({n}个)，建议增加更多与目标职位匹配的技术词".format(n=kw_count)
elif kw_count >= 3:
    s4 = 5
    sug4 = "关键词较少({n}个)，建议参照目标JD补充对应技能词".format(n=kw_count)
else:
    s4 = 2
    sug4 = "关键词严重不足({n}个)，简历可能无法通过ATS筛选系统".format(n=kw_count)
scores.append(("技能关键词", s4))
suggestions.append(sug4)

# 5. 结构完整性 (摘要/经历/技能/教育)
sections = {
    "摘要": ["摘要", "简介", "summary", "profile", "about"],
    "工作经历": ["工作经历", "经历", "experience", "work"],
    "技能": ["技能", "skill", "技术栈", "core skill"],
    "教育": ["教育", "education", "学历", "大学", "university"]
}
found_sections = []
for sec_name, keywords in sections.items():
    for kw in keywords:
        if kw in content_lower:
            found_sections.append(sec_name)
            break
sec_count = len(found_sections)
if sec_count >= 4:
    s5 = 10
    sug5 = "结构完整！包含: {s}".format(s="、".join(found_sections))
elif sec_count >= 3:
    s5 = 7
    missing = [s for s in sections if s not in found_sections]
    sug5 = "结构基本完整，缺少: {m}".format(m="、".join(missing))
elif sec_count >= 2:
    s5 = 5
    missing = [s for s in sections if s not in found_sections]
    sug5 = "结构不完整，缺少: {m}".format(m="、".join(missing))
else:
    s5 = 2
    sug5 = "简历结构严重缺失，至少需要：专业摘要、工作经历、技能清单、教育背景"
scores.append(("结构完整性", s5))
suggestions.append(sug5)

# 6. 项目经验
project_kws = ["项目", "project", "系统", "平台", "工具"]
has_project = any(kw in content_lower for kw in project_kws)
project_sections = len(re.findall(r'(?:###?\s*项目|project)', content_lower))
if project_sections >= 2:
    s6 = 10
    sug6 = "项目经验充分({n}个项目描述)，很好！".format(n=project_sections)
elif project_sections >= 1 or has_project:
    s6 = 6
    sug6 = "项目描述偏少，建议补充到2个以上，包含技术栈和成果"
else:
    s6 = 2
    sug6 = "没有找到项目经验描述，这是简历的重要加分项！"
scores.append(("项目经验", s6))
suggestions.append(sug6)

# 7. 成果导向 (STAR法则)
star_keywords = ["情境", "任务", "行动", "结果", "背景", "挑战", "方案", "成果",
                 "提升", "降低", "增长", "减少", "实现", "达成", "完成率",
                 "situation", "task", "action", "result", "achieve", "improve"]
star_count = sum(1 for kw in star_keywords if kw in content_lower)
if star_count >= 8:
    s7 = 10
    sug7 = "成果导向明显({n}处STAR相关表述)，逻辑清晰！".format(n=star_count)
elif star_count >= 5:
    s7 = 7
    sug7 = "有一定成果描述({n}处)，建议每段经历都用STAR法则组织".format(n=star_count)
elif star_count >= 2:
    s7 = 4
    sug7 = "成果导向不够突出，建议用「背景→行动→结果」结构改写工作经历"
else:
    s7 = 2
    sug7 = "缺少成果描述！每段经历应包含：做了什么→怎么做的→取得什么结果"
scores.append(("成果导向", s7))
suggestions.append(sug7)

# 8. 排版规范 (markdown格式)
has_headers = bool(re.search(r'^#{1,3}\s', content, re.MULTILINE))
has_lists = bool(re.search(r'^[-*]\s', content, re.MULTILINE))
has_bold = '**' in content
has_table = '|' in content and '---' in content
has_blank_lines = '\n\n' in content
format_score_count = sum([has_headers, has_lists, has_bold, has_table, has_blank_lines])
if format_score_count >= 4:
    s8 = 10
    sug8 = "Markdown排版规范，格式整洁！"
elif format_score_count >= 3:
    s8 = 7
    sug8 = "排版基本OK，建议加入表格或加粗来突出重点信息"
elif format_score_count >= 2:
    s8 = 5
    sug8 = "排版较简单，建议使用标题(##)、列表(-)、加粗(**)增强可读性"
else:
    s8 = 2
    sug8 = "排版混乱或过于简单，建议用Markdown标准格式重新组织"
scores.append(("排版规范", s8))
suggestions.append(sug8)

# 9. 联系方式完整性
contact_patterns = {
    "邮箱": [r'[\w\.-]+@[\w\.-]+\.\w+', r'邮箱', r'email'],
    "电话": [r'1[3-9]\d{9}', r'\+86', r'电话', r'phone'],
    "社交": [r'github', r'linkedin', r'作品集', r'portfolio', r'blog']
}
found_contacts = []
for name_c, patterns in contact_patterns.items():
    for pat in patterns:
        if re.search(pat, content_lower):
            found_contacts.append(name_c)
            break
contact_count = len(found_contacts)
if contact_count >= 3:
    s9 = 10
    sug9 = "联系方式完整(含{c})，方便HR联系！".format(c="、".join(found_contacts))
elif contact_count >= 2:
    s9 = 7
    sug9 = "联系方式基本OK，建议补充 GitHub/LinkedIn 等专业社交链接"
elif contact_count >= 1:
    s9 = 4
    sug9 = "联系方式不全(仅有{c})，至少包含邮箱+电话+一个社交链接".format(c="、".join(found_contacts))
else:
    s9 = 1
    sug9 = "没有找到联系方式！这会导致HR无法联系你"
scores.append(("联系方式", s9))
suggestions.append(sug9)

# 10. 个性化程度
template_markers = ["[填写", "[X]", "[XX]", "YYYY", "your.email@example.com",
                    "yourprofile", "XX科技", "XX信息", "XX大学", "XX专业"]
template_count = sum(content.count(m) for m in template_markers)
unique_markers = [r'我(?:曾|在)', r'热爱', r'擅长', r'专注于']
unique_count = sum(1 for pat in unique_markers if re.search(pat, content))
if template_count == 0 and unique_count >= 2:
    s10 = 10
    sug10 = "内容个性化程度高，看起来是真实的个人简历！"
elif template_count <= 3:
    s10 = 7
    sug10 = "基本个性化，还有{n}处模板占位符未替换".format(n=template_count)
elif template_count <= 8:
    s10 = 4
    sug10 = "有{n}处模板占位符未替换，请用真实信息填充[X]/[XX%]等".format(n=template_count)
else:
    s10 = 2
    sug10 = "大量模板占位符({n}处)未替换，请务必填入个人真实数据！".format(n=template_count)
scores.append(("个性化程度", s10))
suggestions.append(sug10)

# ── 汇总输出 ──
total = sum(s for _, s in scores)
if total >= 90:
    grade = "S"
    grade_desc = "🏆 卓越 — 可以直接投递！"
elif total >= 75:
    grade = "A"
    grade_desc = "🌟 优秀 — 稍加润色即可投递"
elif total >= 60:
    grade = "B"
    grade_desc = "👍 良好 — 需要针对性优化"
elif total >= 45:
    grade = "C"
    grade_desc = "⚠️ 一般 — 需要较多改进"
else:
    grade = "D"
    grade_desc = "❌ 较弱 — 建议大幅重写"

print("")
print("=" * 52)
print("  📊 简历评分报告 / Resume Score Report")
print("=" * 52)
print("")
print("  📄 文件: {fp}".format(fp=filepath))
print("  📏 字数: {n}".format(n=char_count))
print("")
print("  {bar}".format(bar="─" * 48))
print("  {dim:<16s} {score:<8s} {sug}".format(dim="评分维度", score="得分", sug="评价"))
print("  {bar}".format(bar="─" * 48))
for i in range(10):
    dim_name = scores[i][0]
    dim_score = scores[i][1]
    bar = "█" * dim_score + "░" * (10 - dim_score)
    print("  {dim:<14s} {bar} {s}/10".format(dim=dim_name, bar=bar, s=dim_score))
    print("    💬 {sug}".format(sug=suggestions[i]))
    print("")

print("  {bar}".format(bar="═" * 48))
print("  📊 总分: {total} / 100".format(total=total))
print("  🏅 等级: {grade} — {desc}".format(grade=grade, desc=grade_desc))
print("  {bar}".format(bar="═" * 48))
print("")

# 给出Top3改进建议
indexed = sorted(enumerate(scores), key=lambda x: x[1][1])
top3 = indexed[:3]
print("  🔧 优先改进 Top 3:")
print("")
for rank, (idx, (dim_name, dim_score)) in enumerate(top3):
    print("    {r}. [{dim}] {sug}".format(r=rank+1, dim=dim_name, sug=suggestions[idx]))
print("")
print("=" * 52)
PYEOF
}

# ── match (JD匹配分析) ─────────────────────────────
cmd_match() {
  local jd_text="${1:-}"
  if [ -z "$jd_text" ]; then
    echo "Usage: job.sh match \"职位描述文本\""
    echo "用法: job.sh match \"JD内容或关键技能\""
    echo "示例: job.sh match \"熟悉React/Vue，3年以上前端经验，熟悉TypeScript\""
    exit 1
  fi

  export JH_JD_TEXT="$jd_text"
  python3 << 'PYEOF'
import os, re, sys

jd_text = os.environ["JH_JD_TEXT"]

# ── Extract skills from JD ──
skill_categories = {
    "编程语言": ["python", "java", "javascript", "typescript", "go", "golang", "c++", "c#",
                 "php", "ruby", "rust", "swift", "kotlin", "scala", "r语言", "matlab"],
    "前端框架": ["react", "vue", "angular", "next.js", "nuxt", "svelte", "jquery",
                 "html", "css", "sass", "less", "webpack", "vite", "小程序"],
    "后端框架": ["spring", "spring boot", "django", "flask", "express", "fastapi",
                 "gin", "nest.js", "rails", "laravel"],
    "数据库": ["mysql", "postgresql", "mongodb", "redis", "elasticsearch", "oracle",
              "sql server", "sqlite", "neo4j", "hbase"],
    "云与DevOps": ["docker", "kubernetes", "k8s", "aws", "gcp", "azure", "ci/cd",
                   "jenkins", "github actions", "terraform", "nginx", "linux"],
    "数据与AI": ["机器学习", "深度学习", "pytorch", "tensorflow", "pandas", "spark",
                 "hadoop", "flink", "数据分析", "数据挖掘", "nlp", "cv"],
    "设计工具": ["figma", "sketch", "axure", "photoshop", "illustrator", "xd",
                "principle", "after effects", "ae", "blender"],
    "产品与运营": ["prd", "brd", "竞品分析", "用户调研", "数据分析", "ab测试", "a/b测试",
                  "项目管理", "scrum", "agile", "jira", "okr"],
    "软实力": ["沟通", "团队协作", "领导力", "抗压", "自驱", "学习能力",
              "跨部门", "演讲", "写作", "英语", "日语"]
}

jd_lower = jd_text.lower()

required_skills = []
bonus_skills = []
soft_skills = []

for category, skills in skill_categories.items():
    for skill in skills:
        if skill.lower() in jd_lower:
            if category == "软实力":
                soft_skills.append(skill)
            else:
                required_skills.append("{s} ({c})".format(s=skill, c=category))

# Experience level
exp_match = re.search(r'(\d+)\s*[年年]', jd_text)
exp_years = exp_match.group(1) if exp_match else "未明确"

# Education
edu_keywords = {"本科": "本科", "硕士": "硕士", "博士": "博士", "大专": "大专",
                "bachelor": "本科", "master": "硕士", "phd": "博士"}
edu_req = "未明确"
for kw, label in edu_keywords.items():
    if kw in jd_lower:
        edu_req = label
        break

print("")
print("=" * 56)
print("  🎯 JD 匹配分析 / Job Description Analysis")
print("=" * 56)
print("")
print("  📄 JD摘要:")
print("  " + jd_text[:200] + ("..." if len(jd_text) > 200 else ""))
print("")

print("  " + "-" * 50)
print("  📋 从JD中提取的要求:")
print("  " + "-" * 50)
print("")
print("  📅 经验要求: {y}年".format(y=exp_years))
print("  🎓 学历要求: {e}".format(e=edu_req))
print("")

if required_skills:
    print("  🔧 必要技能 ({n}项):".format(n=len(required_skills)))
    for s in required_skills:
        print("    • " + s)
else:
    print("  🔧 必要技能: 未从JD中识别到明确技能要求")
print("")

if soft_skills:
    print("  🤝 软实力要求:")
    for s in soft_skills:
        print("    • " + s)
    print("")

# Check for resume
resume_path = os.path.expanduser("~/.job-hunter/my-resume.md")
has_resume = os.path.isfile(resume_path)

if has_resume:
    with open(resume_path, "r", encoding="utf-8", errors="replace") as f:
        resume_text = f.read().lower()

    print("  " + "-" * 50)
    print("  📊 简历匹配度分析 (vs ~/.job-hunter/my-resume.md)")
    print("  " + "-" * 50)
    print("")

    matched = []
    missing = []
    for category, skills in skill_categories.items():
        for skill in skills:
            if skill.lower() in jd_lower:
                if skill.lower() in resume_text:
                    matched.append(skill)
                else:
                    missing.append("{s} ({c})".format(s=skill, c=category))

    total = len(matched) + len(missing)
    match_rate = int(len(matched) * 100 / total) if total > 0 else 0

    bar_len = 20
    filled = int(match_rate * bar_len / 100)
    bar = "█" * filled + "░" * (bar_len - filled)
    print("  匹配度: [{bar}] {r}%".format(bar=bar, r=match_rate))
    print("")

    if matched:
        print("  ✅ 匹配的技能 ({n}项):".format(n=len(matched)))
        for s in matched:
            print("    • " + s)
        print("")

    if missing:
        print("  ❌ 缺失的技能 ({n}项):".format(n=len(missing)))
        for s in missing:
            print("    • " + s)
        print("")

    if match_rate >= 80:
        print("  📈 评估: 匹配度很高！建议直接投递，面试时重点展示匹配技能")
    elif match_rate >= 60:
        print("  📈 评估: 匹配度不错，建议在简历中补充缺失技能的相关经验")
    elif match_rate >= 40:
        print("  📈 评估: 匹配度一般，建议针对性学习缺失技能后再投递")
    else:
        print("  📈 评估: 匹配度较低，建议重新评估是否适合该岗位")
else:
    print("  💡 提示: 未找到简历文件 (~/.job-hunter/my-resume.md)")
    print("     创建该文件后可自动对比匹配度！")
    print("     运行 job.sh resume \"姓名\" \"职位\" 生成简历模板")

print("")
print("  " + "-" * 50)
print("  🔧 简历定制化修改建议:")
print("  " + "-" * 50)
print("")
print("  1. 在简历标题/摘要中直接使用JD中的关键词")
print("  2. 工作经历描述对齐JD要求，用STAR法则")
print("  3. 项目经验优先展示与JD最相关的项目")
print("  4. 技能清单顺序按JD要求的优先级排列")
print("  5. 缺失的技能如有相关经验，用近义词表达")
print("  6. 每投一个岗位就微调一版简历（别一份打天下！）")
print("")
print("=" * 56)
PYEOF
}

# ── mock (模拟面试) ────────────────────────────────
cmd_mock() {
  local position="${1:-}" round="${2:-}"
  if [ -z "$position" ] || [ -z "$round" ]; then
    echo "Usage: job.sh mock \"职位\" \"轮次\""
    echo "用法: job.sh mock \"前端工程师\" \"技术轮\""
    echo "轮次选项: HR轮 / 技术轮 / 终面"
    echo "Rounds: HR / Technical / Final"
    exit 1
  fi

  export JH_MOCK_POS="$position"
  export JH_MOCK_ROUND="$round"
  python3 << 'PYEOF'
import os

position = os.environ["JH_MOCK_POS"]
round_type = os.environ["JH_MOCK_ROUND"]

round_lower = round_type.lower()

# Determine round type
is_hr = any(k in round_lower for k in ["hr", "人事", "hr轮"])
is_final = any(k in round_lower for k in ["终面", "终审", "final", "boss", "总监"])
is_tech = not is_hr and not is_final  # default to tech

if is_hr:
    round_label = "HR轮 / 人事面"
    questions = [
        {
            "q": "请做一下自我介绍",
            "focus": "表达能力、逻辑性、与岗位的匹配度",
            "framework": "3段式：我是谁(1句) → 我做过什么(2-3句核心经历) → 我为什么来(1句动机)",
            "trap": "避免复述简历！HR已经看过了。重点说简历上看不到的：你的思考、动机、和这个岗位的缘分"
        },
        {
            "q": "你为什么从上一家公司离职？",
            "focus": "稳定性、职业规划、是否有负面情绪",
            "framework": "正面表述：感谢上家 → 个人成长需要 → 贵公司更匹配",
            "trap": "绝不说前公司坏话！即使真的很差，也要包装成「寻求更大发展空间」"
        },
        {
            "q": "你对薪资有什么期望？",
            "focus": "自我定位、市场认知、谈判能力",
            "framework": "先了解对方预算范围 → 给出合理区间(±15%) → 强调更看重发展",
            "trap": "不要先报底价！说「我相信贵公司有合理的薪资体系，我期望XX-XX范围」"
        },
        {
            "q": "你的优缺点是什么？",
            "focus": "自我认知、坦诚度",
            "framework": "优点：与岗位直接相关的(举例证明) | 缺点：真实但不致命 + 改进措施",
            "trap": "「我最大的缺点是太认真」这种废话HR听过一万遍了，说个真实的小缺点更加分"
        },
        {
            "q": "你的职业规划是什么？",
            "focus": "稳定性、成长意愿、目标清晰度",
            "framework": "短期(1年): 胜任岗位 → 中期(3年): 成为专家/带团队 → 长期: 与公司共成长",
            "trap": "别说「我想创业」或「3年后我要当CTO」，HR会觉得你待不久"
        },
        {
            "q": "你如何看待加班？",
            "focus": "工作态度、价值观",
            "framework": "效率优先 → 必要时愿意 → 但不应该是常态",
            "trap": "别说「我喜欢加班」也别说「我拒绝加班」，要体现你是理性成熟的"
        },
        {
            "q": "你有什么问题想问我们？",
            "focus": "对公司的兴趣、思考深度",
            "framework": "问团队文化 / 项目方向 / 成长路径（体现你的认真）",
            "trap": "别问「几点下班」「加班多不多」，显得你只关心摸鱼"
        },
        {
            "q": "描述一次你遇到的最大挫折",
            "focus": "抗压能力、复盘能力、成长型思维",
            "framework": "STAR法则：情境 → 挑战 → 你的行动 → 结果和收获",
            "trap": "别选太私人的挫折。选工作相关的，重点讲你怎么克服和学到了什么"
        },
        {
            "q": "你如何处理工作中的冲突？",
            "focus": "情商、沟通能力、团队协作",
            "framework": "先倾听 → 理解对方立场 → 找共同目标 → 协商方案",
            "trap": "别举你吵架赢了的例子。要展示「解决问题」而不是「赢得争论」"
        },
        {
            "q": "你还在面试其他公司吗？",
            "focus": "求职状态、对本公司的诚意",
            "framework": "坦诚：有在看，但贵公司是优先选择 → 说出具体原因",
            "trap": "说「只面了你们一家」HR不信。说「有几个在进行，但最看好贵公司因为XXX」更真实"
        },
    ]
elif is_final:
    round_label = "终面 / Boss面"
    questions = [
        {
            "q": "你能给我们团队带来什么独特价值？",
            "focus": "自我定位、差异化竞争力",
            "framework": "我的独特组合：技能A + 经验B + 视角C → 产生1+1>2的效果",
            "trap": "别泛泛说「我很努力」。要具体到你做过什么别人没做过的事"
        },
        {
            "q": "你怎么看待我们这个行业的未来？",
            "focus": "行业认知、战略思维、是否做过功课",
            "framework": "趋势判断 → 机会在哪 → 挑战是什么 → 你的角色",
            "trap": "面试前一定要研究行业！说不出来等于告诉老板你没做准备"
        },
        {
            "q": "如果你入职，前90天会怎么做？",
            "focus": "落地能力、计划性、主动性",
            "framework": "第1月: 了解业务+融入团队 → 第2月: 发现问题+提出方案 → 第3月: 产出成果",
            "trap": "别说「大干一场」。新人最重要的是先了解再行动，体现谦虚和系统性"
        },
        {
            "q": "你做过的最有影响力的一件事是什么？",
            "focus": "判断力、执行力、成果思维",
            "framework": "选一个真正有数据支撑的案例，用STAR法讲得精彩",
            "trap": "「影响力」不一定是大事。关键是你主动做了什么，改变了什么"
        },
        {
            "q": "你有什么想问我的？（老板亲自问）",
            "focus": "战略眼光、与老板的match程度",
            "framework": "问公司战略方向 / 最大挑战 / 对这个角色的期望",
            "trap": "这是展示你思考深度的黄金机会！别浪费在问琐碎的事上"
        },
        {
            "q": "如果团队里有人不配合你的工作怎么办？",
            "focus": "领导力、冲突解决、向上管理",
            "framework": "先了解原因 → 私下沟通 → 寻求共识 → 必要时上升",
            "trap": "别说「找领导告状」，体现你有独立解决问题的能力"
        },
        {
            "q": "你最近在学什么新东西？",
            "focus": "学习能力、好奇心、自驱力",
            "framework": "说一个具体的：在学什么 → 为什么学 → 学到什么程度了",
            "trap": "说不出来就尴尬了。面试前准备一个真实在学的东西"
        },
        {
            "q": "你理想的工作环境是什么样的？",
            "focus": "文化匹配度、价值观",
            "framework": "提前了解公司文化 → 用对方的语言描述你的理想 → 自然匹配",
            "trap": "别说「不加班、钱多、离家近」，要说「开放、协作、有挑战的环境」"
        },
        {
            "q": "你如何定义成功？",
            "focus": "价值观、格局、内驱力",
            "framework": "个人成长 + 团队贡献 + 持续创造价值",
            "trap": "别太功利也别太佛系。体现你是有追求但脚踏实地的人"
        },
        {
            "q": "为什么我应该选你而不是其他候选人？",
            "focus": "自信心、总结能力、临场发挥",
            "framework": "3个核心理由 → 每个理由有事例支撑 → 表达加入的强烈意愿",
            "trap": "别贬低其他候选人。只说你的优势，让面试官自己判断"
        },
    ]
else:
    round_label = "技术轮 / 专业面"
    questions = [
        {
            "q": "请介绍一个你主导的技术项目",
            "focus": "技术深度、项目管理、系统设计能力",
            "framework": "背景 → 技术选型(为什么选) → 核心挑战 → 你的方案 → 量化成果",
            "trap": "别只说「我负责了XX」。要展示你的思考过程和技术决策"
        },
        {
            "q": "你遇到过最难的技术问题是什么？怎么解决的？",
            "focus": "问题分析能力、解决问题的方法论",
            "framework": "问题描述 → 排查过程 → 解决方案 → 复盘改进",
            "trap": "选一个真正有技术含量的问题。别说「配置文件写错了」这种"
        },
        {
            "q": "说说你对{pos}领域技术栈的理解".format(pos=position),
            "focus": "技术广度、是否持续学习",
            "framework": "当前主流技术 → 各自优劣 → 你的偏好和原因 → 未来趋势",
            "trap": "别只会一种技术。至少了解2-3种替代方案的优劣"
        },
        {
            "q": "如何保证代码/产出质量？",
            "focus": "工程化思维、质量意识",
            "framework": "代码规范 → Code Review → 测试策略 → CI/CD → 监控告警",
            "trap": "别说「我写的代码没bug」。要展示系统性的质量保障方法"
        },
        {
            "q": "你如何学习新技术？",
            "focus": "学习能力、自驱力",
            "framework": "信息源(官方文档/社区) → 实践方式(项目/demo) → 沉淀分享",
            "trap": "「我看视频教程」太普通了。说你读源码、写blog、贡献开源更加分"
        },
        {
            "q": "描述一次你优化性能/效率的经历",
            "focus": "性能意识、数据驱动",
            "framework": "优化前数据 → 瓶颈分析 → 优化方案 → 优化后数据(XX%提升)",
            "trap": "必须有数据！「优化了一下，变快了」没有说服力"
        },
        {
            "q": "你在团队协作中是什么角色？",
            "focus": "团队合作、沟通能力",
            "framework": "你的定位 → 具体例子 → 协作产出的结果",
            "trap": "别说「我是执行者/领导者」。用具体例子展示你如何推动事情发生"
        },
        {
            "q": "如果让你重新设计你做过的某个项目，你会怎么改？",
            "focus": "反思能力、技术成长、架构思维",
            "framework": "当时的局限 → 现在的认知 → 具体改进方案 → 预期收益",
            "trap": "这道题考的是反思能力。说「我觉得当时做得很完美」等于0分"
        },
        {
            "q": "你怎么看待技术债务？",
            "focus": "工程成熟度、平衡思维",
            "framework": "技术债不可避免 → 关键是管理(记录/评估/优先级) → 定期偿还",
            "trap": "别说「我从不留技术债」或「技术债无所谓」。要展示平衡业务与质量的能力"
        },
        {
            "q": "你有什么技术上的问题想问我们？",
            "focus": "技术热情、思考深度",
            "framework": "问技术架构 / 技术挑战 / 团队技术文化 / 技术规划",
            "trap": "这是了解团队的好机会！问得好可以加分。别问「你们用什么IDE」"
        },
    ]

print("")
print("=" * 56)
print("  🎤 模拟面试 / Mock Interview")
print("=" * 56)
print("")
print("  📌 职位: {pos}".format(pos=position))
print("  📌 轮次: {r}".format(r=round_label))
print("")

for i, q in enumerate(questions, 1):
    print("  ─── Q{n} / 第{n}题 ───".format(n=i))
    print("")
    print("  ❓ {q}".format(q=q["q"]))
    print("")
    print("  🎯 考察点: {f}".format(f=q["focus"]))
    print("")
    print("  📝 回答框架: {fw}".format(fw=q["framework"]))
    print("")
    print("  ⚠️ 避坑提示: {t}".format(t=q["trap"]))
    print("")

print("  " + "=" * 50)
print("  💡 面试通用技巧:")
print("")
print("  • 每个回答控制在2-3分钟")
print("  • 用STAR法则组织回答(情境→任务→行动→结果)")
print("  • 准备3-5个精彩案例，反复打磨")
print("  • 对着镜子/录视频练习，纠正小动作")
print("  • 面试前一天做1次完整模拟")
print("  • 每个问题回答完问一句「我这样回答可以吗？」")
print("=" * 56)
PYEOF
}

# ── main dispatch ──────────────────────────────────
main() {
  local cmd="${1:-help}"
  shift || true

  case "$cmd" in
    resume)          cmd_resume "$@" ;;
    score)           cmd_score "$@" ;;
    cover-letter)    cmd_cover_letter "$@" ;;
    interview)       cmd_interview "$@" ;;
    salary)          cmd_salary "$@" ;;
    tracker)         cmd_tracker "$@" ;;
    elevator-pitch)  cmd_elevator_pitch "$@" ;;
    follow-up)       cmd_follow_up "$@" ;;
    compare)         cmd_compare "$@" ;;
    help|--help|-h)  show_help ;;
    match)           cmd_match "$@" ;;
    mock)            cmd_mock "$@" ;;
    *)
      echo "❌ 未知命令 / Unknown command: $cmd"
      echo ""
      show_help
      exit 1
      ;;
  esac
}

main "$@"
echo ""
echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
