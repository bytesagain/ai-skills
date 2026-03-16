#!/usr/bin/env bash
# review.sh - 绩效评估工具
# 用法: review.sh <command> [args...]

set -euo pipefail

CMD="${1:-help}"
shift 2>/dev/null || true

case "$CMD" in
  self)
    POSITION="${1:-}"
    ACHIEVEMENTS="${2:-}"
    if [ -z "$POSITION" ] || [ -z "$ACHIEVEMENTS" ]; then
      echo "错误: 请提供岗位和成果"
      echo "用法: review.sh self \"岗位\" \"成果1,成果2,成果3\""
      exit 1
    fi
    python3 - "$POSITION" "$ACHIEVEMENTS" << 'PYEOF'
# -*- coding: utf-8 -*-
import sys
from datetime import datetime

position = sys.argv[1]
achievements_raw = sys.argv[2]
achievements = [a.strip() for a in achievements_raw.split(",") if a.strip()]

print("=" * 60)
print("  员工自评报告")
print("=" * 60)
print("")
print("岗位: {}".format(position))
print("评估周期: {}".format(datetime.now().strftime("%Y年")))
print("生成时间: {}".format(datetime.now().strftime("%Y-%m-%d %H:%M")))
print("")

print("-" * 60)
print("  一、工作成果回顾")
print("-" * 60)
for i, achievement in enumerate(achievements, 1):
    print("")
    print("  成果 {}: {}".format(i, achievement))
    print("    * 具体做了什么: [详细描述]")
    print("    * 取得的效果/数据: [量化结果]")
    print("    * 对团队/公司的价值: [影响说明]")
print("")

sections = [
    {
        "title": "二、核心能力自评",
        "items": [
            "专业技能:     ★★★★☆  [自评说明]",
            "沟通协作:     ★★★★☆  [自评说明]",
            "问题解决:     ★★★★☆  [自评说明]",
            "学习成长:     ★★★★☆  [自评说明]",
            "责任担当:     ★★★★☆  [自评说明]",
            "创新能力:     ★★★☆☆  [自评说明]"
        ]
    },
    {
        "title": "三、成长与收获",
        "items": [
            "新掌握的技能: [列举]",
            "完成的培训/认证: [列举]",
            "克服的挑战: [描述]",
            "获得的认可: [描述]"
        ]
    },
    {
        "title": "四、不足与改进",
        "items": [
            "不足之处1: [诚实描述]",
            "  改进计划: [具体行动]",
            "不足之处2: [诚实描述]",
            "  改进计划: [具体行动]"
        ]
    },
    {
        "title": "五、下一周期目标",
        "items": [
            "业务目标: [具体可衡量的目标]",
            "能力目标: [想提升的方向]",
            "个人发展: [职业规划]"
        ]
    },
    {
        "title": "六、需要的支持",
        "items": [
            "资源需求: [工具/预算/人力]",
            "培训需求: [课程/导师/轮岗]",
            "其他建议: [对团队/流程的改进建议]"
        ]
    }
]

for section in sections:
    print("-" * 60)
    print("  {}".format(section["title"]))
    print("-" * 60)
    for item in section["items"]:
        print("  {}".format(item))
    print("")

print("=" * 60)
print("  签名: ___________  日期: {}".format(datetime.now().strftime("%Y-%m-%d")))
print("=" * 60)
PYEOF
    ;;
  manager)
    PERFORMANCE="${1:-}"
    if [ -z "$PERFORMANCE" ]; then
      echo "错误: 请提供员工表现描述"
      echo "用法: review.sh manager \"员工表现概述\""
      exit 1
    fi
    python3 - "$PERFORMANCE" << 'PYEOF'
# -*- coding: utf-8 -*-
import sys
from datetime import datetime

performance = sys.argv[1]

print("=" * 60)
print("  主管评估意见")
print("=" * 60)
print("")
print("员工表现概述: {}".format(performance))
print("评估时间: {}".format(datetime.now().strftime("%Y-%m-%d %H:%M")))
print("")

sections = [
    {
        "title": "一、绩效评级",
        "items": [
            "综合评级: [ ] 卓越 (S)  [ ] 优秀 (A)  [ ] 良好 (B)  [ ] 合格 (C)  [ ] 待改进 (D)",
            "",
            "各维度评分 (1-5分):",
            "  工作质量:   ___/5   [评语]",
            "  工作效率:   ___/5   [评语]",
            "  团队协作:   ___/5   [评语]",
            "  主动性:     ___/5   [评语]",
            "  专业能力:   ___/5   [评语]",
            "  领导力:     ___/5   [评语]"
        ]
    },
    {
        "title": "二、突出表现",
        "items": [
            "1. [描述具体的优秀表现和贡献]",
            "2. [描述具体事例]",
            "3. [描述具体事例]"
        ]
    },
    {
        "title": "三、改进建议",
        "items": [
            "1. [需要改进的方面 + 具体建议]",
            "2. [需要改进的方面 + 具体建议]"
        ]
    },
    {
        "title": "四、发展建议",
        "items": [
            "适合的发展方向: 管理路线 / 专家路线 / 跨部门",
            "建议的培训: [具体培训或学习内容]",
            "建议的项目历练: [可以承担的新挑战]",
            "晋升评估: [ ] 已具备  [ ] 接近  [ ] 需要更多积累"
        ]
    },
    {
        "title": "五、下一周期期望",
        "items": [
            "核心目标: [具体期望达成的目标]",
            "能力提升: [期望提升的方向]",
            "团队贡献: [期望承担的角色]"
        ]
    },
    {
        "title": "六、综合评语",
        "items": [
            "[请撰写200-300字的综合评语，包含:]",
            "  - 对该员工本周期表现的整体评价",
            "  - 最值得肯定的方面",
            "  - 最需要改进的方面",
            "  - 对未来发展的期望和信心"
        ]
    }
]

for section in sections:
    print("-" * 60)
    print("  {}".format(section["title"]))
    print("-" * 60)
    for item in section["items"]:
        print("  {}".format(item))
    print("")

print("=" * 60)
print("  评估人签名: ___________")
print("  日期: {}".format(datetime.now().strftime("%Y-%m-%d")))
print("=" * 60)
PYEOF
    ;;
  kpi)
    KPIS="${1:-}"
    if [ -z "$KPIS" ]; then
      echo "错误: 请提供KPI数据"
      echo "用法: review.sh kpi \"目标1:完成度,目标2:完成度\""
      echo "示例: review.sh kpi \"销售额:95%,新客户:120%,满意度:88%\""
      exit 1
    fi
    python3 - "$KPIS" << 'PYEOF'
# -*- coding: utf-8 -*-
import sys
from datetime import datetime

kpi_raw = sys.argv[1]
kpi_pairs = [k.strip() for k in kpi_raw.split(",") if k.strip()]

kpis = []
for pair in kpi_pairs:
    if ":" in pair:
        parts = pair.split(":", 1)
        kpis.append({"name": parts[0].strip(), "value": parts[1].strip()})
    else:
        kpis.append({"name": pair.strip(), "value": "待评估"})

print("=" * 60)
print("  KPI 绩效报告")
print("=" * 60)
print("")
print("评估周期: {}".format(datetime.now().strftime("%Y年")))
print("生成时间: {}".format(datetime.now().strftime("%Y-%m-%d %H:%M")))
print("")

print("-" * 60)
print("  KPI 完成情况")
print("-" * 60)
print("")

header = "| {:<16} | {:<10} | {:<10} | {:<10} |".format(
    "指标", "完成度", "评级", "说明")
sep = "|" + "-" * 18 + "|" + "-" * 12 + "|" + "-" * 12 + "|" + "-" * 12 + "|"
print(header)
print(sep)

for kpi in kpis:
    value = kpi["value"]
    rating = "[待评]"
    try:
        num = float(value.replace("%", ""))
        if num >= 120:
            rating = "卓越 S"
        elif num >= 100:
            rating = "优秀 A"
        elif num >= 80:
            rating = "良好 B"
        elif num >= 60:
            rating = "合格 C"
        else:
            rating = "待改进 D"
    except (ValueError, AttributeError):
        pass
    print("| {:<16} | {:<10} | {:<10} | {:<10} |".format(
        kpi["name"], value, rating, "[待填写]"))

print("")

total_count = len(kpis)
completed = 0
for kpi in kpis:
    try:
        num = float(kpi["value"].replace("%", ""))
        if num >= 80:
            completed += 1
    except (ValueError, AttributeError):
        pass

print("-" * 60)
print("  统计摘要")
print("-" * 60)
print("  KPI总数: {}".format(total_count))
print("  达标数量 (>=80%): {}".format(completed))
print("  达标率: {:.0f}%".format(completed * 100.0 / total_count if total_count > 0 else 0))
print("")

print("-" * 60)
print("  分析与改进")
print("-" * 60)
print("  表现最佳指标: [自动/手动分析]")
print("  需改进指标: [自动/手动分析]")
print("  改进计划: [待制定]")
print("  资源需求: [待确定]")
print("")

print("=" * 60)
PYEOF
    ;;
  promotion)
    POSITION="${1:-}"
    YEARS="${2:-}"
    ACHIEVEMENTS="${3:-}"
    if [ -z "$POSITION" ] || [ -z "$YEARS" ] || [ -z "$ACHIEVEMENTS" ]; then
      echo "错误: 请提供完整参数"
      echo "用法: review.sh promotion \"岗位\" \"年限\" \"主要成果\""
      echo "示例: review.sh promotion \"高级工程师\" \"3\" \"系统重构,带团队5人,专利2项\""
      exit 1
    fi
    python3 - "$POSITION" "$YEARS" "$ACHIEVEMENTS" << 'PYEOF'
# -*- coding: utf-8 -*-
import sys
from datetime import datetime

position = sys.argv[1]
years = sys.argv[2]
achievements_raw = sys.argv[3]
achievements = [a.strip() for a in achievements_raw.split(",") if a.strip()]

print("=" * 60)
print("  晋升述职报告")
print("=" * 60)
print("")
print("申请人岗位: {}".format(position))
print("在岗年限: {}年".format(years))
print("报告日期: {}".format(datetime.now().strftime("%Y-%m-%d")))
print("")

print("-" * 60)
print("  一、个人简介")
print("-" * 60)
print("  现任岗位: {}".format(position))
print("  入职时间/在岗年限: {}年".format(years))
print("  申请晋升至: [目标岗位]")
print("  所属部门: [部门名称]")
print("")

print("-" * 60)
print("  二、核心业绩")
print("-" * 60)
for i, achievement in enumerate(achievements, 1):
    print("")
    print("  业绩 {}: {}".format(i, achievement))
    print("    背景: [项目/任务背景]")
    print("    行动: [具体做了什么]")
    print("    结果: [量化成果]")
    print("    影响: [对团队/公司的价值]")
print("")

sections = [
    {
        "title": "三、能力证明",
        "items": [
            "专业能力:",
            "  * [技术深度/业务理解的具体体现]",
            "  * [解决复杂问题的案例]",
            "",
            "领导力/影响力:",
            "  * [带团队/指导新人的经历]",
            "  * [跨部门协作推动的项目]",
            "",
            "创新贡献:",
            "  * [提出的创新方案或优化]",
            "  * [获得的专利/奖项/认可]"
        ]
    },
    {
        "title": "四、成长轨迹",
        "items": [
            "关键里程碑:",
            "  第1年: [主要成长和突破]",
            "  第2年: [承担更大责任]",
            "  第{}年: [当前水平]".format(years),
            "",
            "能力提升:",
            "  * 从[初始水平]到[当前水平]",
            "  * 完成的培训/认证: [列举]"
        ]
    },
    {
        "title": "五、晋升后规划",
        "items": [
            "短期目标 (3个月): [具体计划]",
            "中期目标 (6个月): [具体计划]",
            "长期目标 (1年): [具体计划]",
            "",
            "对团队的贡献计划:",
            "  * [人才培养]",
            "  * [流程优化]",
            "  * [技术/业务突破]"
        ]
    },
    {
        "title": "六、同事/上级评价",
        "items": [
            "上级评语: [待填写]",
            "同事评价: [待收集]",
            "跨部门反馈: [待收集]"
        ]
    }
]

for section in sections:
    print("-" * 60)
    print("  {}".format(section["title"]))
    print("-" * 60)
    for item in section["items"]:
        if item == "":
            print("")
        else:
            print("  {}".format(item))
    print("")

print("=" * 60)
print("  申请人: ___________")
print("  日期: {}".format(datetime.now().strftime("%Y-%m-%d")))
print("  推荐人签名: ___________")
print("=" * 60)
PYEOF
    ;;
  goal)
    GOALS="${1:-}"
    if [ -z "$GOALS" ]; then
      echo "错误: 请提供目标描述"
      echo "用法: review.sh goal \"目标1,目标2,目标3\""
      exit 1
    fi
    python3 - "$GOALS" << 'PYEOF'
# -*- coding: utf-8 -*-
import sys
from datetime import datetime

goals_raw = sys.argv[1]
goals = [g.strip() for g in goals_raw.split(",") if g.strip()]

print("=" * 60)
print("  SMART 目标设定 & OKR 转化")
print("=" * 60)
print("")
print("  生成时间: {}".format(datetime.now().strftime("%Y-%m-%d %H:%M")))
print("  评估周期: {}".format(datetime.now().strftime("%Y年Q{q}").format(
    q=(datetime.now().month - 1) // 3 + 1)))
print("")

print("-" * 60)
print("  一、原始目标 → SMART 目标转化")
print("-" * 60)
print("")
print("  SMART = Specific(具体) + Measurable(可衡量) +")
print("          Achievable(可达成) + Relevant(相关性) + Time-bound(有时限)")
print("")

for i, goal in enumerate(goals, 1):
    print("  ── 目标 {} ──".format(i))
    print("")
    print("  原始描述: {}".format(goal))
    print("")
    print("  SMART 转化:")
    print("    S 具体化:   [把「{}」拆解为具体可执行的动作]".format(goal))
    print("    M 可衡量:   [设定量化指标，如：提升XX%/完成X个/达到X分]")
    print("    A 可达成:   [评估资源和能力是否支持，难度适中]")
    print("    R 相关性:   [与团队/公司目标的关联：支撑XX战略目标]")
    print("    T 有时限:   [设定截止日期：YYYY-MM-DD]")
    print("")
    print("  转化后写法示例:")
    print("    \"在{q}季度末前，通过[具体方法]，将[指标]从[当前值]提升至[目标值]\"".format(
        q=(datetime.now().month - 1) // 3 + 2 if (datetime.now().month - 1) // 3 + 2 <= 4 else 1))
    print("")

print("-" * 60)
print("  二、OKR 格式输出")
print("-" * 60)
print("")
print("  O (Objective 目标): [基于以上目标，提炼一个振奋人心的大目标]")
print("")

for i, goal in enumerate(goals, 1):
    print("  KR{} (Key Result 关键结果):".format(i))
    print("    描述: {}".format(goal))
    print("    衡量标准: [具体数字或交付物]")
    print("    当前进度: 0%")
    print("    信心指数: [1-10, 建议5-7为宜]")
    print("")

print("-" * 60)
print("  三、自评写法模板")
print("-" * 60)
print("")
print("  在绩效评估中，这样描述你的目标更专业：")
print("")
print("  ❌ 不好的写法：")
print("    「下季度继续努力工作，提升业绩」")
print("    「加强学习，提高能力」")
print("    「做好本职工作」")
print("")
print("  ✅ 好的写法：")
print("    「Q{q}目标：通过优化推荐算法，将用户7日留存率从45%提升至55%，".format(
    q=(datetime.now().month - 1) // 3 + 2 if (datetime.now().month - 1) // 3 + 2 <= 4 else 1))
print("     预计影响DAU增长15%。已完成技术调研，计划分3个迭代实施。」")
print("")

print("-" * 60)
print("  四、目标跟踪模板")
print("-" * 60)
print("")
print("  | 目标 | 关键指标 | 基线值 | 目标值 | 当前值 | 进度 |")
print("  |------|---------|--------|--------|--------|------|")
for i, goal in enumerate(goals, 1):
    print("  | {} | [指标] | [基线] | [目标] | [当前] | 0% |".format(goal[:10]))
print("")
print("  💡 建议每2周更新一次进度，季度末做总复盘")

print("")
print("=" * 60)
PYEOF
    ;;
  feedback)
    TARGET="${1:-}"
    SITUATION="${2:-}"
    if [ -z "$TARGET" ] || [ -z "$SITUATION" ]; then
      echo "错误: 请提供反馈对象和情况"
      echo "用法: review.sh feedback \"对象\" \"情况描述\""
      echo "对象: 同事 / 下属 / 上级 / 跨部门"
      exit 1
    fi
    python3 - "$TARGET" "$SITUATION" << 'PYEOF'
# -*- coding: utf-8 -*-
import sys
from datetime import datetime

target = sys.argv[1]
situation = sys.argv[2]

# 反馈对象类型
target_types = {
    "同事": {
        "tone": "平等、协作",
        "focus": "合作中的贡献和配合",
        "prefix": "在与{}的合作中",
    },
    "下属": {
        "tone": "鼓励为主、指导为辅",
        "focus": "工作表现和成长",
        "prefix": "作为{}的上级",
    },
    "上级": {
        "tone": "尊重、建设性",
        "focus": "管理方式和团队支持",
        "prefix": "在{}的带领下",
    },
    "跨部门": {
        "tone": "客观、专业",
        "focus": "跨部门协作效率",
        "prefix": "在与{}的跨部门合作中",
    },
}

# 匹配对象类型
matched_type = None
for key in target_types:
    if key in target:
        matched_type = key
        break
if not matched_type:
    matched_type = "同事"

info = target_types[matched_type]

print("=" * 60)
print("  360度反馈撰写助手")
print("=" * 60)
print("")
print("  反馈对象: {} (类型: {})".format(target, matched_type))
print("  反馈情况: {}".format(situation))
print("  建议语气: {}".format(info["tone"]))
print("  关注重点: {}".format(info["focus"]))
print("  日期: {}".format(datetime.now().strftime("%Y-%m-%d")))
print("")

print("-" * 60)
print("  一、反馈原则（SBI模型）")
print("-" * 60)
print("")
print("  S (Situation) — 具体情境：在什么时候/什么项目中")
print("  B (Behavior)  — 具体行为：TA做了什么（客观描述）")
print("  I (Impact)    — 产生影响：这个行为带来了什么影响")
print("")

print("-" * 60)
print("  二、正面反馈模板")
print("-" * 60)
print("")
print("  模板1（通用肯定）:")
print("    \"在[项目/场景]中，[对象]表现出了[具体行为]，")
print("     这对团队[具体影响]起到了重要作用。\"")
print("")
print("  模板2（基于你提供的情况）:")
print("    \"{}，[对象]{}。".format(info["prefix"].format(target), situation))
print("     这种表现值得肯定，对[团队/项目]产生了积极的影响。\"")
print("")
print("  模板3（能力认可）:")
print("    \"[对象]在[专业领域]展现了扎实的功底，尤其在[具体方面]")
print("     表现突出。TA的[具体能力]对团队的贡献有目共睹。\"")
print("")

print("-" * 60)
print("  三、建设性反馈模板")
print("-" * 60)
print("")
print("  模板1（三明治法 — 肯定+建议+期望）:")
print("    \"[对象]在[方面]做得很好，值得肯定。")
print("     如果在[需改进的方面]能够[具体建议]，相信会更加出色。")
print("     期待看到TA在这方面的成长。\"")
print("")
print("  模板2（SBI + 建议）:")
print("    \"在[具体场景]中，[对象][具体行为]，导致了[影响]。")
print("     建议后续可以尝试[具体改进方法]，")
print("     这样能更好地[期望效果]。\"")
print("")
print("  模板3（基于你提供的情况）:")
print("    \"在合作过程中，注意到{}。".format(situation))
print("     建议[对象]可以在[具体方面]做出调整，")
print("     例如[具体的改进行动]。相信这会带来明显的提升。\"")
print("")

print("-" * 60)
print("  四、不同对象的措辞要点")
print("-" * 60)
print("")

tips_map = {
    "同事": [
        "✅ 强调合作中的互补和共同成果",
        "✅ 用\"我们\"代替\"你\"，减少指责感",
        "✅ 基于具体事实，避免主观判断",
        "❌ 不要评价TA的性格或态度",
        "❌ 不要和其他同事做比较",
    ],
    "下属": [
        "✅ 先肯定成绩，再提改进建议",
        "✅ 给出具体的行动建议，不要只说\"要改进\"",
        "✅ 关注成长和发展方向",
        "❌ 不要只说缺点，比例建议7:3（优:劣）",
        "❌ 不要用模糊的评语如\"态度不好\"",
    ],
    "上级": [
        "✅ 以建设性建议为主，而非批评",
        "✅ 用\"如果能...会更好\"的句式",
        "✅ 肯定领导在团队管理上的贡献",
        "❌ 不要直接指责管理方式",
        "❌ 不要情绪化表达",
    ],
    "跨部门": [
        "✅ 聚焦于协作流程和效率",
        "✅ 肯定对方的专业能力和配合",
        "✅ 建议性地提出沟通改进方案",
        "❌ 不要指责对方部门的问题",
        "❌ 不要上升到部门对立",
    ],
}

tips = tips_map.get(matched_type, tips_map["同事"])
for tip in tips:
    print("  {}".format(tip))
print("")

print("-" * 60)
print("  五、常用反馈词汇")
print("-" * 60)
print("")
print("  正面词汇：")
print("    积极主动、责任心强、善于沟通、执行力强、")
print("    学习能力突出、创新思维、抗压能力好、细致严谨、")
print("    有大局观、乐于分享、带动团队氛围")
print("")
print("  建设性词汇（替代负面表达）：")
print("    \"粗心\" → \"建议加强细节关注\"")
print("    \"效率低\" → \"可以优化时间分配和任务优先级\"")
print("    \"不沟通\" → \"建议增加主动同步信息的频率\"")
print("    \"固执\" → \"建议更多倾听不同视角\"")
print("    \"能力不行\" → \"在XX领域仍有提升空间\"")
print("")

print("=" * 60)
PYEOF
    ;;
  help|*)
    cat << 'EOF'
============================================================
  绩效评估工具
============================================================

用法: review.sh <命令> [参数...]

命令:
  self "岗位" "成果1,成果2"              员工自评报告
  manager "员工表现描述"                  主管评估意见
  kpi "目标1:完成度,目标2:完成度"         KPI绩效报告
  promotion "岗位" "年限" "成果"          晋升述职报告
  goal "下季度目标"                       SMART目标设定/OKR
  feedback "对象" "情况"                  360反馈撰写
  help                                    显示本帮助信息

示例:
  review.sh self "产品经理" "上线新功能,DAU增长30%,获最佳团队奖"
  review.sh manager "工作积极主动,完成多个重要项目"
  review.sh kpi "销售额:95%,新客户:120%,满意度:88%"
  review.sh promotion "高级工程师" "3" "系统重构,带团队5人,专利2项"
  review.sh goal "提升用户留存率,优化推荐算法,带新人"
  review.sh feedback "同事" "项目合作中沟通积极,但deadline意识需加强"

============================================================
EOF
    ;;
esac

echo ""
echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
