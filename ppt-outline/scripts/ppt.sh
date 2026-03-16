#!/usr/bin/env bash
# ppt.sh — PPT大纲和演示文稿结构生成器
set -euo pipefail

DATE=$(date '+%Y-%m-%d')

show_help() {
    cat <<'EOF'
PPT大纲生成器 - ppt.sh

用法：
  ppt.sh outline  "主题" [--slides 10]    生成PPT大纲（每页标题+要点）
  ppt.sh pitch    "项目名"                商业路演BP大纲
  ppt.sh report   "汇报主题"              工作汇报PPT大纲
  ppt.sh training "课程主题"              培训课件大纲
  ppt.sh defense  "论文题目"              毕业答辩PPT大纲
  ppt.sh review   "项目名"               项目复盘PPT大纲
  ppt.sh html     "主题" [--style S]      生成HTML演示文稿（浏览器打开）
  ppt.sh help                             显示本帮助

风格（html命令）：dark(默认) | light | tech | minimal

示例：
  ppt.sh outline "AI在医疗的应用" --slides 12
  ppt.sh pitch "智能客服SaaS"
  ppt.sh report "Q4部门总结"
  ppt.sh training "新员工入职"
  ppt.sh html "AI在医疗的应用" --style tech
EOF
}

cmd_outline() {
    local topic="$1"
    shift
    local slides=10
    while [ $# -gt 0 ]; do
        case "$1" in
            --slides) slides="${2:-10}"; shift 2 ;;
            *) shift ;;
        esac
    done
    python3 -c "
import sys

date = '${DATE}'
topic = sys.argv[1]
slides = int(sys.argv[2])

print('=' * 60)
print('PPT 大 纲'.center(60))
print('=' * 60)
print('')
print('主题：{}'.format(topic))
print('页数：{} 页'.format(slides))
print('日期：{}'.format(date))
print('')
print('-' * 60)

# Generate slide structure
default_structure = [
    ('封面', ['标题：{}'.format(topic), '副标题：______', '演讲者：______', '日期：{}'.format(date)]),
    ('目录', ['本次演示包含以下内容：', '（根据实际页数自动生成）']),
    ('背景与现状', ['行业/项目背景', '当前面临的问题/挑战', '数据支撑']),
    ('核心观点/方案', ['核心论点', '关键数据', '逻辑框架']),
    ('详细分析 (一)', ['分析维度1', '数据/图表', '小结']),
    ('详细分析 (二)', ['分析维度2', '案例/证据', '小结']),
    ('详细分析 (三)', ['分析维度3', '对比/趋势', '小结']),
    ('实施方案/路径', ['阶段划分', '时间节点', '资源需求']),
    ('预期效果/收益', ['量化指标', '里程碑', '风险控制']),
    ('总结与展望', ['核心回顾', '下一步计划', '呼吁行动(CTA)']),
]

# Adjust to requested slide count
if slides <= len(default_structure):
    structure = default_structure[:slides]
else:
    structure = list(default_structure)
    for i in range(len(default_structure), slides):
        structure.append(('补充内容 ({})'.format(i - len(default_structure) + 1),
                         ['要点1', '要点2', '要点3']))

for i, (title, points) in enumerate(structure, 1):
    print('')
    print('第 {} 页 | {}'.format(i, title))
    print('~' * 40)
    for p in points:
        print('  - {}'.format(p))

print('')
print('-' * 60)
print('【演讲备注】')
print('  - 总时长建议：{} 分钟（每页约 {} 分钟）'.format(slides * 2, 2))
print('  - 重点页面：第3-4页（核心观点，多花时间）')
print('  - 建议配图：数据页用图表，案例页用照片')
print('=' * 60)
" "$topic" "$slides"
}

cmd_pitch() {
    local project="$1"
    python3 -c "
import sys

date = '${DATE}'
project = sys.argv[1]

print('=' * 60)
print('商 业 路 演 BP 大 纲'.center(60))
print('=' * 60)
print('')
print('项目：{}'.format(project))
print('日期：{}'.format(date))
print('')

slides = [
    ('封面', [
        '项目名称：{}'.format(project),
        'Slogan：一句话说清价值',
        '团队/公司名',
        '融资轮次与金额',
    ]),
    ('痛点与机会', [
        '目标用户是谁？',
        '他们面临什么问题？（具体场景）',
        '现有解决方案的不足',
        '市场机会有多大？',
    ]),
    ('解决方案', [
        '我们的产品/服务是什么',
        '如何解决上述痛点',
        '核心功能展示（截图/Demo）',
        '用户体验亮点',
    ]),
    ('商业模式', [
        '怎么赚钱？',
        '定价策略',
        '收入来源（订阅/交易/广告…）',
        '单位经济模型（LTV / CAC）',
    ]),
    ('市场分析', [
        'TAM / SAM / SOM',
        '市场增长率',
        '目标客群画像',
        '市场趋势',
    ]),
    ('竞争分析', [
        '主要竞争对手（2-4个）',
        '竞争矩阵对比',
        '我们的差异化壁垒',
        '护城河',
    ]),
    ('产品进展 / Traction', [
        '当前阶段（概念/MVP/增长）',
        '关键数据指标',
        '用户/客户/收入数据',
        '里程碑事件',
    ]),
    ('团队介绍', [
        '核心团队成员（3-5人）',
        '各自背景与分工',
        '顾问/投资人',
        '团队优势',
    ]),
    ('财务规划', [
        '收入预测（3年）',
        '成本结构',
        '盈亏平衡点',
        '关键假设',
    ]),
    ('融资方案', [
        '本轮融资金额',
        '估值',
        '资金用途分配',
        '未来融资计划',
    ]),
    ('愿景与路线图', [
        '6个月目标',
        '12个月目标',
        '长期愿景',
        'Call to Action',
    ]),
]

for i, (title, points) in enumerate(slides, 1):
    print('第 {} 页 | {}'.format(i, title))
    print('~' * 40)
    for p in points:
        print('  - {}'.format(p))
    print('')

print('-' * 60)
print('【路演建议】')
print('  - 总时长：10-15分钟（留5分钟Q&A）')
print('  - 前3页定生死：30秒内抓住注意力')
print('  - 数据说话：每页至少一个数据支撑')
print('  - 讲故事：用户案例 > 功能罗列')
print('=' * 60)
" "$project"
}

cmd_report() {
    local topic="$1"
    python3 -c "
import sys

date = '${DATE}'
topic = sys.argv[1]

print('=' * 60)
print('工 作 汇 报 PPT 大 纲'.center(60))
print('=' * 60)
print('')
print('汇报主题：{}'.format(topic))
print('日期：{}'.format(date))
print('')

slides = [
    ('封面', [
        '标题：{}'.format(topic),
        '汇报人：______',
        '部门：______',
        '日期：{}'.format(date),
    ]),
    ('目录', [
        '一、工作回顾',
        '二、核心成果',
        '三、问题与挑战',
        '四、下阶段计划',
    ]),
    ('工作概览', [
        '汇报周期：______ 至 ______',
        '主要工作方向',
        '团队概况',
        '资源投入',
    ]),
    ('核心成果 (一)', [
        '成果描述',
        '关键数据指标（同比/环比）',
        '超额/达标/未达标',
        '图表展示',
    ]),
    ('核心成果 (二)', [
        '成果描述',
        '亮点项目/案例',
        '客户/用户反馈',
        '团队贡献',
    ]),
    ('数据分析', [
        'KPI完成情况一览表',
        '趋势图/对比图',
        '关键发现',
        '数据洞察',
    ]),
    ('问题与挑战', [
        '遇到的主要问题（2-3个）',
        '原因分析',
        '已采取的措施',
        '需要的支持',
    ]),
    ('经验与反思', [
        '做得好的方面',
        '需要改进的方面',
        '学到的经验',
        '团队成长',
    ]),
    ('下阶段计划', [
        '目标设定（SMART原则）',
        '重点工作安排',
        '时间节点',
        '资源需求',
    ]),
    ('总结', [
        '一句话总结',
        '请求支持事项',
        '感谢',
        'Q&A',
    ]),
]

for i, (title, points) in enumerate(slides, 1):
    print('第 {} 页 | {}'.format(i, title))
    print('~' * 40)
    for p in points:
        print('  - {}'.format(p))
    print('')

print('-' * 60)
print('【汇报建议】')
print('  - 结论先行：先说结果，再讲过程')
print('  - 数据优先：用数据说话，少用形容词')
print('  - 简洁有力：每页不超过6个要点')
print('  - 时间控制：15-20分钟内完成')
print('=' * 60)
" "$topic"
}

cmd_training() {
    local course="$1"
    python3 -c "
import sys

date = '${DATE}'
course = sys.argv[1]

print('=' * 60)
print('培 训 课 件 大 纲'.center(60))
print('=' * 60)
print('')
print('课程：{}'.format(course))
print('日期：{}'.format(date))
print('')

slides = [
    ('封面', [
        '课程名称：{}'.format(course),
        '讲师：______',
        '时长：______ 小时',
        '日期：{}'.format(date),
    ]),
    ('课程导入', [
        '为什么要学这个？（痛点/场景）',
        '学完你能获得什么？（学习目标）',
        '课程大纲概览',
        '互动规则',
    ]),
    ('基础概念', [
        '核心定义',
        '关键术语解释',
        '历史/背景',
        '为什么重要',
    ]),
    ('核心知识 (一)', [
        '知识点1详解',
        '原理/框架',
        '图解说明',
        '要点小结',
    ]),
    ('核心知识 (二)', [
        '知识点2详解',
        '方法/步骤',
        '注意事项',
        '要点小结',
    ]),
    ('核心知识 (三)', [
        '知识点3详解',
        '进阶内容',
        '常见误区',
        '要点小结',
    ]),
    ('案例分析', [
        '真实案例展示',
        '成功案例 vs 失败案例',
        '关键分析',
        '经验教训',
    ]),
    ('实操练习', [
        '练习题目/任务',
        '操作步骤指引',
        '小组讨论（如适用）',
        '预期产出',
    ]),
    ('常见问题 Q&A', [
        'FAQ 1',
        'FAQ 2',
        'FAQ 3',
        '互动答疑',
    ]),
    ('课程总结', [
        '核心要点回顾（3-5条）',
        '推荐学习资源',
        '课后作业/实践任务',
        '反馈与评价',
    ]),
]

for i, (title, points) in enumerate(slides, 1):
    print('第 {} 页 | {}'.format(i, title))
    print('~' * 40)
    for p in points:
        print('  - {}'.format(p))
    print('')

print('-' * 60)
print('【授课建议】')
print('  - 每20分钟穿插一次互动/提问')
print('  - 理论:案例:练习 = 4:3:3')
print('  - 开头用故事/问题引入，不要直接讲理论')
print('  - 每个知识点用「是什么-为什么-怎么做」结构')
print('  - 结尾留课后任务，巩固学习效果')
print('=' * 60)
" "$course"
}

# Main dispatch
case "${1:-help}" in
    outline)
        [ $# -lt 2 ] && { echo "用法: ppt.sh outline \"主题\" [--slides 10]"; exit 1; }
        topic="$2"
        shift 2
        cmd_outline "$topic" "$@"
        ;;
    pitch)
        [ $# -lt 2 ] && { echo "用法: ppt.sh pitch \"项目名\""; exit 1; }
        cmd_pitch "$2"
        ;;
    report)
        [ $# -lt 2 ] && { echo "用法: ppt.sh report \"汇报主题\""; exit 1; }
        cmd_report "$2"
        ;;
    training)
        [ $# -lt 2 ] && { echo "用法: ppt.sh training \"课程主题\""; exit 1; }
        cmd_training "$2"
        ;;
    defense)
        [ $# -lt 2 ] && { echo "用法: ppt.sh defense \"论文题目\""; exit 1; }
        export PPT_THESIS="$2"
        export PPT_DATE="$DATE"
        python3 <<'PYEOF'
import os

thesis = os.environ.get('PPT_THESIS', '')
date = os.environ.get('PPT_DATE', '')

print('=' * 60)
print('毕 业 答 辩 PPT 大 纲'.center(60))
print('=' * 60)
print('')
print('论文题目：{}'.format(thesis))
print('答辩日期：{}'.format(date))
print('')

slides = [
    ('封面', [
        '论文题目：{}'.format(thesis),
        '学生姓名：______',
        '学号：______',
        '指导教师：______教授',
        '学院/专业：______',
        '答辩日期：{}'.format(date),
    ]),
    ('目录', [
        '一、研究背景与意义',
        '二、文献综述',
        '三、研究方法与设计',
        '四、数据分析与结果',
        '五、讨论与创新点',
        '六、结论与展望',
    ]),
    ('研究背景与意义', [
        '研究领域的宏观背景',
        '现实问题/痛点是什么',
        '为什么选择这个课题',
        '研究的理论意义',
        '研究的实践价值',
    ]),
    ('文献综述', [
        '国内外研究现状概述',
        '已有研究的主要成果（2-3个关键学者/团队）',
        '现有研究的不足/空白',
        '本研究的切入点',
    ]),
    ('研究问题与假设', [
        '核心研究问题（1-2个）',
        '研究假设（如适用）',
        '研究框架/理论模型',
        '变量定义与关系图',
    ]),
    ('研究方法', [
        '研究方法选择及理由（定性/定量/混合）',
        '数据来源与样本',
        '研究工具/量表/问卷',
        '数据收集过程',
        '分析方法（统计工具/编码方法）',
    ]),
    ('数据分析与结果（一）', [
        '描述性统计/基本分析',
        '图表展示关键数据',
        '结果一：______（与假设H1对应）',
        '数据可视化（图表、对比图）',
    ]),
    ('数据分析与结果（二）', [
        '结果二：______（与假设H2对应）',
        '结果三：______（补充发现）',
        '数据图表（柱状图/折线图/热力图）',
        '显著性检验结果',
    ]),
    ('讨论', [
        '结果与已有研究的对比',
        '意外发现的解释',
        '理论贡献',
        '实践启示',
    ]),
    ('创新点', [
        '创新点一：理论/模型创新',
        '创新点二：方法创新',
        '创新点三：应用/视角创新',
        '（每个创新点用一句话概括+简要说明）',
    ]),
    ('研究局限与展望', [
        '本研究的局限性（2-3点，坦诚但不自贬）',
        '未来研究方向',
        '数据/方法的改进空间',
    ]),
    ('结论', [
        '核心发现总结（3-5条）',
        '回答研究问题',
        '研究贡献概述',
        '一句话总结',
    ]),
    ('致谢', [
        '感谢导师的指导',
        '感谢评审老师',
        '感谢同学/实验室/家人',
        '请各位老师批评指正',
    ]),
    ('参考文献（部分）', [
        '列出10-15篇核心参考文献',
        '按APA/GB/T 7714格式排列',
        '（全部文献见论文正文）',
    ]),
]

for i, (title, points) in enumerate(slides, 1):
    print('第 {} 页 | {}'.format(i, title))
    print('~' * 40)
    for p in points:
        print('  - {}'.format(p))
    print('')

print('-' * 60)
print('【答辩建议】')
print('  - 总时长：15-20分钟陈述 + 5-10分钟提问')
print('  - 前3页决定第一印象：背景要简洁，快速进入核心内容')
print('  - 数据页多用图表，少用表格（评委看不清小字）')
print('  - 创新点是重中之重，一定要讲清楚"新在哪里"')
print('  - 局限性主动提，但同时给出改进方向（表现学术素养）')
print('  - 每页不超过6行文字，字号不小于24pt')
print('  - 准备好常见问题的回答（为什么选这个方法、样本量够不够等）')
print('=' * 60)
PYEOF
        ;;
    review)
        [ $# -lt 2 ] && { echo "用法: ppt.sh review \"项目名\""; exit 1; }
        export PPT_PROJECT="$2"
        export PPT_DATE="$DATE"
        python3 <<'PYEOF'
import os

project = os.environ.get('PPT_PROJECT', '')
date = os.environ.get('PPT_DATE', '')

print('=' * 60)
print('项 目 复 盘 PPT 大 纲'.center(60))
print('=' * 60)
print('')
print('项目：{}'.format(project))
print('复盘日期：{}'.format(date))
print('')

slides = [
    ('封面', [
        '项目名称：{}'.format(project),
        '复盘类型：□项目复盘  □迭代复盘  □年度复盘',
        '复盘负责人：______',
        '日期：{}'.format(date),
    ]),
    ('目录', [
        '一、项目概述',
        '二、目标 vs 结果',
        '三、关键里程碑回顾',
        '四、数据分析',
        '五、经验总结（Keep/Problem/Try）',
        '六、改进计划',
    ]),
    ('项目概述', [
        '项目背景与目标',
        '项目周期：______至______',
        '团队规模：______人',
        '投入资源：______',
    ]),
    ('目标 vs 结果', [
        '| 维度 | 原定目标 | 实际结果 | 达成率 |',
        '|------|---------|---------|--------|',
        '| 目标1 |         |         |   %    |',
        '| 目标2 |         |         |   %    |',
        '| 目标3 |         |         |   %    |',
        '超额完成的部分标绿，未达标的标红',
    ]),
    ('关键里程碑回顾', [
        '里程碑时间线（可视化）',
        '  M1: ______ ✅/❌',
        '  M2: ______ ✅/❌',
        '  M3: ______ ✅/❌',
        '计划 vs 实际的偏差分析',
        '延期/变更的原因',
    ]),
    ('数据分析 — 核心指标', [
        '核心业务数据（用图表展示）',
        '  指标1：______ → ______（变化 ___%）',
        '  指标2：______ → ______（变化 ___%）',
        '趋势图/对比图',
        '数据洞察（为什么涨/跌）',
    ]),
    ('数据分析 — 过程指标', [
        '效率指标：需求交付周期、Bug修复速度等',
        '质量指标：缺陷率、返工率、客户满意度',
        '成本指标：预算 vs 实际支出',
        '与历史项目/行业标准对比',
    ]),
    ('经验总结 — Keep（继续保持）', [
        '做得好的方面（3-5条）',
        '  ✅ ______',
        '  ✅ ______',
        '  ✅ ______',
        '为什么做得好？关键成功因素',
        '如何制度化/标准化这些做法',
    ]),
    ('经验总结 — Problem（问题教训）', [
        '出现的主要问题（3-5条）',
        '  ❌ ______',
        '  ❌ ______',
        '  ❌ ______',
        '根因分析（5 Whys / 鱼骨图）',
        '这些问题造成了什么影响',
    ]),
    ('经验总结 — Try（尝试改进）', [
        '下次项目要尝试的新做法（3-5条）',
        '  🔄 ______',
        '  🔄 ______',
        '  🔄 ______',
        '改进的预期效果',
        '需要的资源/支持',
    ]),
    ('改进行动计划', [
        '| 改进项 | 负责人 | 截止日期 | 验证方式 |',
        '|--------|--------|---------|---------|',
        '| 改进1  |        |         |         |',
        '| 改进2  |        |         |         |',
        '| 改进3  |        |         |         |',
        '每个改进项有明确的Owner和验收标准',
    ]),
    ('总结与致谢', [
        '一句话总结本次项目最大的收获',
        '感谢团队成员的付出',
        '对后续项目的展望',
        'Q&A',
    ]),
]

for i, (title, points) in enumerate(slides, 1):
    print('第 {} 页 | {}'.format(i, title))
    print('~' * 40)
    for p in points:
        print('  - {}'.format(p))
    print('')

print('-' * 60)
print('【复盘建议】')
print('  - 复盘不是追责会，营造安全的讨论氛围')
print('  - 用数据说话，避免主观臆断')
print('  - Keep:Problem:Try 的比例建议 3:4:3')
print('  - 每个Problem必须对应至少一个Try')
print('  - 改进行动项必须有明确的Owner和截止日期')
print('  - 最重要的：复盘的价值在于执行改进，不在于写报告')
print('=' * 60)
PYEOF
        ;;
    html)
        [ $# -lt 2 ] && { echo "用法: ppt.sh html \"主题\" [--style dark|light|tech|minimal]"; exit 1; }
        TOPIC="$2"
        shift 2
        STYLE="dark"
        while [ $# -gt 0 ]; do
            case "$1" in
                --style) STYLE="${2:-dark}"; shift 2 ;;
                dark|light|tech|minimal) STYLE="$1"; shift ;;
                *) shift ;;
            esac
        done
        export _PPT_TOPIC="$TOPIC" _PPT_STYLE="$STYLE" _PPT_DATE="$DATE"
        python3 << 'PYEOF'
# -*- coding: utf-8 -*-
import os, datetime, re

topic = os.environ.get("_PPT_TOPIC", "Presentation")
style = os.environ.get("_PPT_STYLE", "dark")
date_str = os.environ.get("_PPT_DATE", datetime.date.today().strftime("%Y-%m-%d"))

styles = {
    "dark":    {"bg": "#0d1117", "bg2": "#161b22", "text": "#e6edf3", "accent": "#58a6ff", "accent2": "#3fb950", "border": "#30363d", "muted": "#8b949e", "card": "#0d1117"},
    "light":   {"bg": "#ffffff", "bg2": "#f6f8fa", "text": "#1f2328", "accent": "#0969da", "accent2": "#1a7f37", "border": "#d0d7de", "muted": "#656d76", "card": "#ffffff"},
    "tech":    {"bg": "#0a0a2e", "bg2": "#12123e", "text": "#e0e0ff", "accent": "#00ff88", "accent2": "#00ccff", "border": "#2a2a5e", "muted": "#8888bb", "card": "#0f0f35"},
    "minimal": {"bg": "#fafafa", "bg2": "#f0f0f0", "text": "#222222", "accent": "#e63946", "accent2": "#457b9d", "border": "#dddddd", "muted": "#888888", "card": "#ffffff"},
}

s = styles.get(style, styles["dark"])

is_gradient = style == "tech"
bg_css = "background: linear-gradient(135deg, #0a0a2e, #1a1a4e);" if is_gradient else "background: {};".format(s["bg"])

# Build slides content based on topic
slides_data = []

# Slide 1: Cover
slides_data.append({
    "type": "cover",
    "title": topic,
    "subtitle": "Professional Presentation",
    "date": date_str,
})

# Slide 2: Table of Contents
toc_items = ["Background & Context", "Core Analysis", "Key Insights", "Data Overview", "Implementation Strategy", "Summary & Outlook"]
slides_data.append({
    "type": "toc",
    "title": "Contents",
    "items": toc_items,
})

# Slide 3-7: Content slides
content_slides = [
    {
        "title": "Background & Context",
        "point": "Understanding the Current Landscape",
        "items": [
            "Industry trends and driving forces behind {}".format(topic),
            "Key challenges and pain points in the current environment",
            "Opportunities for innovation and strategic growth",
        ],
    },
    {
        "title": "Core Analysis",
        "point": "Deep Dive into Key Factors",
        "items": [
            "Multi-dimensional analysis framework and methodology",
            "Critical success factors and risk assessment",
            "Comparative study with industry benchmarks",
        ],
    },
    {
        "title": "Key Insights",
        "point": "Findings That Matter",
        "items": [
            "Data-driven insights reveal significant patterns",
            "User behavior and market dynamics analysis",
            "Competitive advantages and differentiation strategy",
        ],
    },
    {
        "title": "Implementation Strategy",
        "point": "From Vision to Action",
        "items": [
            "Phased rollout plan with clear milestones",
            "Resource allocation and team structure",
            "Risk mitigation and contingency planning",
        ],
    },
    {
        "title": "Future Outlook",
        "point": "Next Steps and Long-term Vision",
        "items": [
            "Short-term goals: Q1-Q2 execution roadmap",
            "Medium-term targets: scaling and optimization",
            "Long-term vision: sustainable growth model",
        ],
    },
]

for cs in content_slides:
    slides_data.append({"type": "content", **cs})

# Slide 8: Data visualization page
slides_data.append({
    "type": "data",
    "title": "Data Overview",
    "bars": [
        {"label": "Market Share", "value": 78, "color": s["accent"]},
        {"label": "User Growth", "value": 92, "color": s["accent2"]},
        {"label": "Revenue", "value": 65, "color": s["accent"]},
        {"label": "Satisfaction", "value": 88, "color": s["accent2"]},
        {"label": "Efficiency", "value": 71, "color": s["accent"]},
    ],
})

# Slide 9: Summary
slides_data.append({
    "type": "summary",
    "title": "Summary",
    "items": [
        "Comprehensive analysis of {} reveals strong potential".format(topic),
        "Data-backed strategy with clear implementation roadmap",
        "Phased approach minimizes risk while maximizing impact",
        "Cross-functional collaboration drives sustainable results",
        "Next step: Kick off Phase 1 execution immediately",
    ],
})

# Slide 10: Thank you
slides_data.append({
    "type": "thankyou",
    "title": "Thank You",
    "subtitle": "Questions & Discussion",
})

total = len(slides_data)

# Build slide HTML
def build_slide_html(idx, slide):
    display = "flex" if idx == 0 else "none"
    html_parts = []
    html_parts.append('<div class="slide" id="slide-{}" style="display:{};">'.format(idx, display))

    if slide["type"] == "cover":
        html_parts.append('  <div class="cover-content">')
        html_parts.append('    <div class="cover-badge">PRESENTATION</div>')
        html_parts.append('    <h1 class="cover-title">{}</h1>'.format(slide["title"]))
        html_parts.append('    <p class="cover-subtitle">{}</p>'.format(slide["subtitle"]))
        html_parts.append('    <div class="cover-divider"></div>')
        html_parts.append('    <p class="cover-date">{}</p>'.format(slide["date"]))
        html_parts.append('    <p class="cover-hint">Press <kbd>&rarr;</kbd> to start</p>')
        html_parts.append('  </div>')

    elif slide["type"] == "toc":
        html_parts.append('  <h2 class="slide-title">{}</h2>'.format(slide["title"]))
        html_parts.append('  <div class="toc-grid">')
        for i, item in enumerate(slide["items"]):
            html_parts.append('    <div class="toc-item"><span class="toc-num">{:02d}</span><span class="toc-text">{}</span></div>'.format(i + 1, item))
        html_parts.append('  </div>')

    elif slide["type"] == "content":
        html_parts.append('  <h2 class="slide-title">{}</h2>'.format(slide["title"]))
        html_parts.append('  <p class="slide-point">{}</p>'.format(slide["point"]))
        html_parts.append('  <div class="content-items">')
        for i, item in enumerate(slide["items"]):
            html_parts.append('    <div class="content-item"><span class="item-marker">&bull;</span><span>{}</span></div>'.format(item))
        html_parts.append('  </div>')

    elif slide["type"] == "data":
        html_parts.append('  <h2 class="slide-title">{}</h2>'.format(slide["title"]))
        html_parts.append('  <div class="chart-container">')
        for bar in slide["bars"]:
            html_parts.append('    <div class="bar-row">')
            html_parts.append('      <span class="bar-label">{}</span>'.format(bar["label"]))
            html_parts.append('      <div class="bar-track"><div class="bar-fill" style="width:{}%;background:{};">{}</div></div>'.format(bar["value"], bar["color"], "{}%".format(bar["value"])))
            html_parts.append('    </div>')
        html_parts.append('  </div>')

    elif slide["type"] == "summary":
        html_parts.append('  <h2 class="slide-title">{}</h2>'.format(slide["title"]))
        html_parts.append('  <div class="summary-list">')
        for i, item in enumerate(slide["items"]):
            icon = ["&#10003;", "&#9733;", "&#9654;", "&#9670;", "&#10148;"][i % 5]
            html_parts.append('    <div class="summary-item"><span class="summary-icon">{}</span><span>{}</span></div>'.format(icon, item))
        html_parts.append('  </div>')

    elif slide["type"] == "thankyou":
        html_parts.append('  <div class="cover-content">')
        html_parts.append('    <h1 class="thankyou-title">{}</h1>'.format(slide["title"]))
        html_parts.append('    <div class="cover-divider"></div>')
        html_parts.append('    <p class="cover-subtitle">{}</p>'.format(slide["subtitle"]))
        html_parts.append('    <p class="cover-date">{}</p>'.format(topic))
        html_parts.append('  </div>')

    html_parts.append('</div>')
    return "\n".join(html_parts)

all_slides_html = "\n".join(build_slide_html(i, sd) for i, sd in enumerate(slides_data))

# Build page indicator dots
dots_html = " ".join('<span class="dot{}" onclick="goTo({})"></span>'.format(" active" if i == 0 else "", i) for i in range(total))

html = """<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>{topic} - Presentation</title>
<style>
*,*::before,*::after{{box-sizing:border-box;margin:0;padding:0;}}
html,body{{width:100%;height:100%;overflow:hidden;font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,"Noto Sans SC","PingFang SC","Microsoft YaHei",sans-serif;{bg_css}color:{text};}}
.slide{{position:absolute;top:0;left:0;width:100%;height:100%;{bg_css}display:flex;flex-direction:column;justify-content:center;align-items:center;padding:60px 80px;opacity:1;transition:opacity 0.5s ease;}}
.slide.fade-out{{opacity:0;}}
.slide.fade-in{{opacity:0;}}

/* Cover styles */
.cover-content{{text-align:center;}}
.cover-badge{{display:inline-block;padding:6px 24px;border:1px solid {accent};border-radius:20px;font-size:12px;letter-spacing:4px;color:{accent};margin-bottom:40px;text-transform:uppercase;}}
.cover-title{{font-size:clamp(32px,5vw,64px);font-weight:700;line-height:1.2;margin-bottom:16px;letter-spacing:-1px;}}
.cover-subtitle{{font-size:clamp(16px,2vw,24px);color:{muted};margin-bottom:30px;font-weight:300;}}
.cover-divider{{width:80px;height:3px;background:{accent};margin:0 auto 30px;border-radius:2px;}}
.cover-date{{font-size:14px;color:{muted};}}
.cover-hint{{font-size:13px;color:{muted};margin-top:40px;opacity:0.6;}}
.cover-hint kbd{{display:inline-block;padding:2px 8px;border:1px solid {border};border-radius:4px;font-family:inherit;font-size:12px;}}

/* Slide titles */
.slide-title{{font-size:clamp(28px,3.5vw,48px);font-weight:700;margin-bottom:12px;text-align:left;width:100%;max-width:900px;}}
.slide-point{{font-size:clamp(16px,1.8vw,22px);color:{accent};margin-bottom:36px;text-align:left;width:100%;max-width:900px;font-weight:400;}}

/* TOC */
.toc-grid{{display:grid;grid-template-columns:repeat(auto-fit,minmax(280px,1fr));gap:20px;width:100%;max-width:900px;margin-top:20px;}}
.toc-item{{display:flex;align-items:center;gap:16px;padding:20px 24px;background:{bg2};border:1px solid {border};border-radius:12px;transition:border-color 0.3s;}}
.toc-item:hover{{border-color:{accent};}}
.toc-num{{font-size:28px;font-weight:700;color:{accent};min-width:40px;}}
.toc-text{{font-size:16px;color:{text};}}

/* Content items */
.content-items{{width:100%;max-width:900px;}}
.content-item{{display:flex;align-items:flex-start;gap:16px;padding:20px 24px;margin-bottom:12px;background:{bg2};border-left:3px solid {accent};border-radius:0 10px 10px 0;font-size:clamp(15px,1.5vw,18px);line-height:1.6;}}
.item-marker{{color:{accent};font-size:20px;margin-top:2px;flex-shrink:0;}}

/* Data / Chart */
.chart-container{{width:100%;max-width:900px;margin-top:20px;}}
.bar-row{{display:flex;align-items:center;gap:16px;margin-bottom:20px;}}
.bar-label{{min-width:120px;font-size:15px;color:{muted};text-align:right;}}
.bar-track{{flex:1;height:36px;background:{bg2};border-radius:8px;overflow:hidden;border:1px solid {border};}}
.bar-fill{{height:100%;border-radius:8px;display:flex;align-items:center;justify-content:flex-end;padding-right:12px;font-size:13px;font-weight:600;color:#fff;min-width:40px;transition:width 1s ease;}}

/* Summary */
.summary-list{{width:100%;max-width:900px;}}
.summary-item{{display:flex;align-items:flex-start;gap:16px;padding:18px 24px;margin-bottom:10px;background:{bg2};border-radius:10px;border:1px solid {border};font-size:clamp(14px,1.4vw,17px);line-height:1.6;}}
.summary-icon{{color:{accent};font-size:18px;flex-shrink:0;margin-top:2px;}}

/* Thank you */
.thankyou-title{{font-size:clamp(40px,6vw,80px);font-weight:700;letter-spacing:-2px;}}

/* Navigation */
.nav-area{{position:fixed;top:0;width:80px;height:100%;z-index:100;cursor:pointer;display:flex;align-items:center;justify-content:center;opacity:0;transition:opacity 0.3s;}}
.nav-area:hover{{opacity:1;}}
.nav-prev{{left:0;}}
.nav-next{{right:0;}}
.nav-arrow{{font-size:28px;color:{accent};background:{bg2};border:1px solid {border};border-radius:50%;width:48px;height:48px;display:flex;align-items:center;justify-content:center;}}

/* Page indicator */
.page-indicator{{position:fixed;bottom:24px;left:50%;transform:translateX(-50%);display:flex;gap:8px;z-index:100;}}
.dot{{width:10px;height:10px;border-radius:50%;background:{border};cursor:pointer;transition:all 0.3s;}}
.dot.active{{background:{accent};transform:scale(1.3);}}
.page-num{{position:fixed;bottom:28px;right:32px;font-size:13px;color:{muted};z-index:100;}}

/* Progress bar */
.progress-bar{{position:fixed;top:0;left:0;height:3px;background:{accent};z-index:200;transition:width 0.4s ease;}}
</style>
</head>
<body>

<div class="progress-bar" id="progressBar" style="width:{progress_init}%;"></div>

{slides}

<div class="nav-area nav-prev" onclick="prev()"><div class="nav-arrow">&larr;</div></div>
<div class="nav-area nav-next" onclick="next()"><div class="nav-arrow">&rarr;</div></div>

<div class="page-indicator" id="dots">{dots}</div>
<div class="page-num" id="pageNum">1 / {total}</div>

<script>
var current=0,total={total};
function showSlide(n){{
  if(n<0||n>=total)return;
  var slides=document.querySelectorAll('.slide');
  var oldSlide=slides[current];
  var newSlide=slides[n];
  oldSlide.style.opacity='0';
  setTimeout(function(){{
    oldSlide.style.display='none';
    oldSlide.style.opacity='1';
    newSlide.style.display='flex';
    newSlide.style.opacity='0';
    setTimeout(function(){{newSlide.style.opacity='1';}},30);
  }},300);
  current=n;
  updateIndicators();
}}
function next(){{if(current<total-1)showSlide(current+1);}}
function prev(){{if(current>0)showSlide(current-1);}}
function goTo(n){{showSlide(n);}}
function updateIndicators(){{
  var dots=document.querySelectorAll('.dot');
  for(var i=0;i<dots.length;i++){{dots[i].className=i===current?'dot active':'dot';}}
  document.getElementById('pageNum').textContent=(current+1)+' / '+total;
  document.getElementById('progressBar').style.width=((current+1)/total*100)+'%';
}}
document.addEventListener('keydown',function(e){{
  if(e.key==='ArrowRight'||e.key===' '){{e.preventDefault();next();}}
  else if(e.key==='ArrowLeft'){{e.preventDefault();prev();}}
  else if(e.key==='Home'){{e.preventDefault();showSlide(0);}}
  else if(e.key==='End'){{e.preventDefault();showSlide(total-1);}}
}});
var touchStartX=0;
document.addEventListener('touchstart',function(e){{touchStartX=e.touches[0].clientX;}});
document.addEventListener('touchend',function(e){{
  var dx=e.changedTouches[0].clientX-touchStartX;
  if(dx<-50)next();else if(dx>50)prev();
}});
</script>
</body>
</html>""".format(
    topic=topic,
    bg_css=bg_css,
    text=s["text"],
    accent=s["accent"],
    accent2=s["accent2"],
    bg2=s["bg2"],
    border=s["border"],
    muted=s["muted"],
    card=s["card"],
    slides=all_slides_html,
    dots=dots_html,
    total=total,
    progress_init=round(100.0 / total, 1),
)

# Clean filename
safe_name = re.sub(r'[^\w\u4e00-\u9fff-]', '_', topic)
filename = safe_name + "_presentation.html"
with open(filename, "w", encoding="utf-8") as f:
    f.write(html)

print("")
print("=" * 50)
print("  Presentation Generated Successfully!")
print("=" * 50)
print("")
print("  File : {}".format(filename))
print("  Topic: {}".format(topic))
print("  Style: {}".format(style))
print("  Slides: {} pages".format(total))
print("")
print("  Open in browser to present")
print("  Keyboard: <- -> to navigate")
print("  Touch: swipe left/right")
print("")
PYEOF
        ;;
    quick)
        TOPIC="${2:?请输入演示主题（一句话描述）}"
        export _PPT_TOPIC="$TOPIC"
        python3 << 'PYEOF'
import os, datetime, re, math

topic = os.environ.get("_PPT_TOPIC", "Presentation")
date = datetime.datetime.now().strftime("%Y-%m-%d")

# Auto-detect scenario
scenarios = {
    "work": ["汇报","总结","进展","完成","工作","项目","季度","月度","年度","Q1","Q2","Q3","Q4"],
    "product": ["产品","功能","发布","上线","特性","介绍","展示","demo"],
    "pitch": ["融资","投资","商业","计划","创业","方案","竞标","BP"],
    "edu": ["培训","学习","教程","课程","分享","教学","讲座"],
}
scene = "work"
for k, words in scenarios.items():
    for w in words:
        if w in topic:
            scene = k
            break

colors = {"bg":"#0d1117","text":"#e6edf3","accent":"#58a6ff","card":"#161b22"}

slides_html = []
# Slide 1: Cover
slides_html.append('<div class="slide active"><h1>{}</h1><p style="color:{};font-size:1.2em">{}</p><p style="margin-top:40px;opacity:0.5">{}</p></div>'.format(topic, colors["accent"], {"work":"Work Report","product":"Product Launch","pitch":"Business Pitch","edu":"Training Session"}.get(scene,"Presentation"), date))

# Slide 2: Agenda
items = {"work":["Goals & Progress","Key Achievements","Challenges","Next Steps"],
         "product":["Background","Core Features","Demo","Roadmap"],
         "pitch":["Problem","Solution","Market","Ask"],
         "edu":["Objectives","Core Concepts","Practice","Summary"]}
agenda = items.get(scene, items["work"])
agenda_html = "".join(["<li>{}</li>".format(a) for a in agenda])
slides_html.append('<div class="slide"><h2>Agenda</h2><ol style="font-size:1.3em;line-height:2.2">{}</ol></div>'.format(agenda_html))

# Slides 3-6: Content
for i, title in enumerate(agenda):
    points = ["Key point {} for {}".format(j+1, title) for j in range(3)]
    pts = "".join(["<li>{}</li>".format(p) for p in points])
    slides_html.append('<div class="slide"><h2>{}</h2><ul style="font-size:1.1em;line-height:2">{}</ul></div>'.format(title, pts))

# Slide 7: Data
slides_html.append('<div class="slide"><h2>Key Metrics</h2><div style="display:flex;gap:20px;justify-content:center;flex-wrap:wrap"><div style="background:{bg};padding:20px 30px;border-radius:12px;text-align:center"><div style="font-size:2em;color:{accent}">85%</div><div>Target</div></div><div style="background:{bg};padding:20px 30px;border-radius:12px;text-align:center"><div style="font-size:2em;color:{accent}">+23%</div><div>Growth</div></div><div style="background:{bg};padding:20px 30px;border-radius:12px;text-align:center"><div style="font-size:2em;color:{accent}">4.8/5</div><div>Rating</div></div></div></div>'.format(bg=colors["card"], accent=colors["accent"]))

# Slide 8: Thank you
slides_html.append('<div class="slide"><h1>Thank You</h1><p style="font-size:1.3em;opacity:0.7">{}</p><p style="margin-top:40px;color:{}">bytesagain.com</p></div>'.format(topic, colors["accent"]))

all_slides = "\n".join(slides_html)
html = """<!DOCTYPE html>
<html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>{title}</title><style>
*{{margin:0;padding:0;box-sizing:border-box}}
body{{background:{bg};color:{text};font-family:-apple-system,sans-serif;overflow:hidden}}
.slide{{display:none;width:100vw;height:100vh;padding:8vh 10vw;flex-direction:column;justify-content:center}}
.slide.active{{display:flex}}
h1{{font-size:clamp(2em,5vw,3.5em);margin-bottom:20px}}
h2{{font-size:clamp(1.5em,3.5vw,2.5em);color:{accent};margin-bottom:30px}}
ul,ol{{padding-left:30px}} li{{margin:8px 0}}
.nav{{position:fixed;bottom:20px;width:100%;text-align:center;opacity:0.5}}
.dots span{{display:inline-block;width:10px;height:10px;border-radius:50%;background:#555;margin:0 4px}}
.dots span.active{{background:{accent}}}
</style></head><body>
{slides}
<div class="nav"><div class="dots">{dots}</div></div>
<script>
var i=0,s=document.querySelectorAll('.slide'),d=document.querySelectorAll('.dots span');
function go(n){{if(n>=0&&n<s.length){{s[i].classList.remove('active');d[i].classList.remove('active');i=n;s[i].classList.add('active');d[i].classList.add('active')}}}}
document.addEventListener('keydown',function(e){{if(e.key==='ArrowRight'||e.key===' ')go(i+1);if(e.key==='ArrowLeft')go(i-1)}});
var tx=0;document.addEventListener('touchstart',function(e){{tx=e.touches[0].clientX}});
document.addEventListener('touchend',function(e){{var dx=e.changedTouches[0].clientX-tx;if(dx<-50)go(i+1);if(dx>50)go(i-1)}});
</script></body></html>""".format(
    title=topic, bg=colors["bg"], text=colors["text"], accent=colors["accent"],
    slides=all_slides,
    dots="".join(['<span{}></span>'.format(' class="active"' if j==0 else "") for j in range(len(slides_html))])
)

fn = topic.replace(" ","_").replace("/","_") + "_quick.html"
with open(fn, "w") as f:
    f.write(html)
print("=" * 50)
print("  Quick Presentation Generated!")
print("=" * 50)
print()
print("  File : {}".format(fn))
print("  Topic: {}".format(topic))
print("  Slides: {} pages".format(len(slides_html)))
print("  Scene: {}".format(scene))
print()
print("  Open in browser to present")
print("  <- -> to navigate")
print()
print("  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "未知命令: $1"
        show_help
        exit 1
        ;;
esac
