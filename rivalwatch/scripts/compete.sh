#!/usr/bin/env bash
# compete.sh - 竞品分析工具
# 用法: compete.sh <command> [args...]

set -euo pipefail

CMD="${1:-help}"
shift 2>/dev/null || true

case "$CMD" in
  swot)
    PRODUCT="${1:-}"
    if [ -z "$PRODUCT" ]; then
      echo "错误: 请提供产品名称"
      echo "用法: compete.sh swot \"产品名称\""
      exit 1
    fi
    python3 - "$PRODUCT" << 'PYEOF'
# -*- coding: utf-8 -*-
import sys
from datetime import datetime

product = sys.argv[1]

print("=" * 60)
print("  SWOT 分析报告")
print("=" * 60)
print("")
print("分析对象: {}".format(product))
print("生成时间: {}".format(datetime.now().strftime("%Y-%m-%d %H:%M")))
print("")

sections = [
    {
        "title": "S - 优势 (Strengths)",
        "icon": "+",
        "prompts": [
            "核心竞争力/独特卖点 (USP) 是什么？",
            "技术壁垒或专利优势？",
            "品牌认知度和用户口碑如何？",
            "团队/资源方面有哪些优势？",
            "成本结构或供应链优势？",
            "用户体验/产品设计亮点？"
        ]
    },
    {
        "title": "W - 劣势 (Weaknesses)",
        "icon": "-",
        "prompts": [
            "产品功能有哪些短板？",
            "用户反馈中常见的抱怨？",
            "市场覆盖不足的领域？",
            "资金/人才/资源限制？",
            "技术债务或架构问题？",
            "运营效率低下的环节？"
        ]
    },
    {
        "title": "O - 机会 (Opportunities)",
        "icon": "*",
        "prompts": [
            "市场增长趋势和新兴需求？",
            "竞品的薄弱环节可以切入？",
            "政策法规带来的利好？",
            "新技术/新渠道的机会？",
            "潜在的合作伙伴或并购机会？",
            "国际化/下沉市场的空间？"
        ]
    },
    {
        "title": "T - 威胁 (Threats)",
        "icon": "!",
        "prompts": [
            "主要竞品的动态和威胁？",
            "新进入者的潜在冲击？",
            "替代品或技术颠覆风险？",
            "政策监管风险？",
            "宏观经济环境影响？",
            "用户需求变化趋势？"
        ]
    }
]

for section in sections:
    print("-" * 60)
    print("  {} {}".format(section["icon"], section["title"]))
    print("-" * 60)
    for i, prompt in enumerate(section["prompts"], 1):
        print("  {}. {}".format(i, prompt))
        print("     [待填写]")
        print("")

print("=" * 60)
print("  分析建议")
print("=" * 60)
print("  SO策略: 利用优势抓住机会")
print("  WO策略: 克服劣势利用机会")
print("  ST策略: 利用优势应对威胁")
print("  WT策略: 减少劣势回避威胁")
print("=" * 60)
PYEOF
    ;;
  compare)
    PRODUCT_A="${1:-}"
    PRODUCT_B="${2:-}"
    if [ -z "$PRODUCT_A" ] || [ -z "$PRODUCT_B" ]; then
      echo "错误: 请提供两个产品名称"
      echo "用法: compete.sh compare \"产品A\" \"产品B\""
      exit 1
    fi
    python3 - "$PRODUCT_A" "$PRODUCT_B" << 'PYEOF'
# -*- coding: utf-8 -*-
import sys
from datetime import datetime

product_a = sys.argv[1]
product_b = sys.argv[2]

print("=" * 70)
print("  竞品对比分析报告")
print("=" * 70)
print("")
print("对比产品: {} vs {}".format(product_a, product_b))
print("生成时间: {}".format(datetime.now().strftime("%Y-%m-%d %H:%M")))
print("")

dimensions = [
    {
        "category": "产品基本信息",
        "items": ["产品定位", "目标用户", "上线时间", "团队规模", "融资阶段"]
    },
    {
        "category": "核心功能",
        "items": ["核心功能1", "核心功能2", "核心功能3", "差异化功能", "技术栈"]
    },
    {
        "category": "用户体验",
        "items": ["界面设计", "上手难度", "响应速度", "稳定性", "客户支持"]
    },
    {
        "category": "商业模式",
        "items": ["定价策略", "收费模式", "免费版功能", "付费转化", "客单价"]
    },
    {
        "category": "市场表现",
        "items": ["市场份额", "用户规模", "增长速度", "品牌知名度", "口碑评价"]
    },
    {
        "category": "生态与扩展",
        "items": ["API/开放平台", "第三方集成", "插件生态", "社区活跃度", "开发者支持"]
    }
]

header = "| {:<16} | {:<18} | {:<18} |".format("对比维度", product_a, product_b)
separator = "|" + "-" * 18 + "|" + "-" * 20 + "|" + "-" * 20 + "|"

for dim in dimensions:
    print("-" * 70)
    print("  {}".format(dim["category"]))
    print("-" * 70)
    print(header)
    print(separator)
    for item in dim["items"]:
        print("| {:<16} | {:<18} | {:<18} |".format(item, "[待填写]", "[待填写]"))
    print("")

print("=" * 70)
print("  综合评估")
print("=" * 70)
print("  {} 优势领域: [待分析]".format(product_a))
print("  {} 优势领域: [待分析]".format(product_b))
print("  关键差异点: [待分析]")
print("  建议策略: [待分析]")
print("=" * 70)
PYEOF
    ;;
  positioning)
    PRODUCT="${1:-}"
    INDUSTRY="${1:-}"
    if [ -z "$PRODUCT" ] || [ -z "$INDUSTRY" ]; then
      echo "错误: 请提供产品名称和行业"
      echo "用法: compete.sh positioning \"产品\" \"行业\""
      exit 1
    fi
    python3 - "$PRODUCT" "$INDUSTRY" << 'PYEOF'
# -*- coding: utf-8 -*-
import sys
from datetime import datetime

product = sys.argv[1]
industry = sys.argv[2]

print("=" * 60)
print("  市场定位分析报告")
print("=" * 60)
print("")
print("产品: {}".format(product))
print("行业: {}".format(industry))
print("生成时间: {}".format(datetime.now().strftime("%Y-%m-%d %H:%M")))
print("")

sections = [
    {
        "title": "一、行业概况",
        "items": [
            "市场规模: [待调研]",
            "增长率: [待调研]",
            "行业生命周期阶段: 导入期 / 成长期 / 成熟期 / 衰退期",
            "主要驱动力: [待分析]",
            "行业壁垒: [待分析]"
        ]
    },
    {
        "title": "二、竞争格局",
        "items": [
            "市场领导者: [待调研]",
            "主要挑战者: [待调研]",
            "细分市场玩家: [待调研]",
            "新进入者: [待调研]",
            "市场集中度 (CR5): [待调研]"
        ]
    },
    {
        "title": "三、目标用户画像",
        "items": [
            "核心用户群: [待定义]",
            "用户痛点: [待调研]",
            "消费能力: [待评估]",
            "决策因素: [待分析]",
            "用户获取渠道: [待规划]"
        ]
    },
    {
        "title": "四、定位策略",
        "items": [
            "价值主张: [待确定]",
            "定价区间: 高端 / 中端 / 低端 / 免费增值",
            "差异化方向: 功能 / 体验 / 价格 / 服务 / 品牌",
            "一句话定位: \"为[目标用户]提供[核心价值]的[产品类型]\"",
            "品牌调性: [待确定]"
        ]
    },
    {
        "title": "五、定位矩阵 (二维定位图)",
        "items": [
            "X轴建议: 价格 (低 ← → 高)",
            "Y轴建议: 功能丰富度 (少 ← → 多)",
            "{}当前位置: [待标注]".format(product),
            "竞品A位置: [待标注]",
            "竞品B位置: [待标注]",
            "目标位置: [待确定]"
        ]
    },
    {
        "title": "六、行动建议",
        "items": [
            "短期 (0-3月): [待规划]",
            "中期 (3-6月): [待规划]",
            "长期 (6-12月): [待规划]"
        ]
    }
]

for section in sections:
    print("-" * 60)
    print("  {}".format(section["title"]))
    print("-" * 60)
    for item in section["items"]:
        print("  * {}".format(item))
    print("")

print("=" * 60)
PYEOF
    ;;
  strategy)
    PRODUCT="${1:-}"
    COMPETITOR="${2:-}"
    if [ -z "$PRODUCT" ] || [ -z "$COMPETITOR" ]; then
      echo "错误: 请提供产品名称和竞品名称"
      echo "用法: compete.sh strategy \"我方产品\" \"竞品\""
      exit 1
    fi
    python3 - "$PRODUCT" "$COMPETITOR" << 'PYEOF'
# -*- coding: utf-8 -*-
import sys
from datetime import datetime

product = sys.argv[1]
competitor = sys.argv[2]

print("=" * 60)
print("  差异化竞争策略报告")
print("=" * 60)
print("")
print("我方产品: {}".format(product))
print("主要竞品: {}".format(competitor))
print("生成时间: {}".format(datetime.now().strftime("%Y-%m-%d %H:%M")))
print("")

strategies = [
    {
        "title": "一、竞品分析摘要",
        "items": [
            "竞品核心优势: [待分析]",
            "竞品主要弱点: [待分析]",
            "竞品近期动态: [待调研]",
            "竞品用户评价: [待收集]",
            "竞品定价策略: [待分析]"
        ]
    },
    {
        "title": "二、差异化方向",
        "items": [
            "功能差异化: 竞品没有但用户需要的功能",
            "体验差异化: 更好的 UX/UI 或使用流程",
            "价格差异化: 更灵活的定价或更高性价比",
            "服务差异化: 更好的客户支持或增值服务",
            "品牌差异化: 不同的品牌故事或用户心智",
            "生态差异化: 更丰富的集成或开放平台"
        ]
    },
    {
        "title": "三、攻击策略",
        "items": [
            "侧翼进攻: 在竞品忽视的细分市场发力",
            "正面挑战: 在核心功能上做到更好",
            "迂回包抄: 通过不同渠道或模式获取用户",
            "游击战术: 针对特定场景做深做透"
        ]
    },
    {
        "title": "四、防守策略",
        "items": [
            "构建转换成本: 让用户迁移代价更高",
            "强化网络效应: 用户越多产品价值越大",
            "快速跟进: 竞品新功能的快速响应机制",
            "专利/技术壁垒: 保护核心技术优势"
        ]
    },
    {
        "title": "五、执行路线图",
        "items": [
            "第1阶段 - 调研 (1-2周):",
            "  收集竞品用户反馈和评价",
            "  分析竞品功能和定价",
            "  确定差异化切入点",
            "",
            "第2阶段 - 实施 (2-4周):",
            "  开发差异化功能",
            "  调整定价策略",
            "  准备营销素材",
            "",
            "第3阶段 - 推广 (持续):",
            "  针对性营销活动",
            "  竞品用户转化计划",
            "  持续监控和调整"
        ]
    },
    {
        "title": "六、关键指标 (KPI)",
        "items": [
            "竞品用户转化率: [目标值]",
            "功能差异化覆盖率: [目标值]",
            "用户满意度对比: [目标值]",
            "市场份额变化: [目标值]"
        ]
    }
]

for strategy in strategies:
    print("-" * 60)
    print("  {}".format(strategy["title"]))
    print("-" * 60)
    for item in strategy["items"]:
        if item == "":
            print("")
        else:
            print("  {}".format(item))
    print("")

print("=" * 60)
PYEOF
    ;;
  porter)
    INDUSTRY="${1:?请输入行业名称}"
    export _PORTER_IND="$INDUSTRY"
    python3 << 'PYEOF'
import os
ind = os.environ.get("_PORTER_IND", "")
print("=" * 56)
print("  🔍 波特五力分析 — {}".format(ind))
print("=" * 56)
forces = [
    ("供应商议价能力", "Supplier Power", [
        "供应商集中度: ____（高/中/低）",
        "替代原料可得性: ____",
        "转换成本: ____（高=供应商强势）",
        "🔑 关键问题: 供应商能否轻易涨价？",
    ]),
    ("买方议价能力", "Buyer Power", [
        "买方集中度: ____（大客户占比）",
        "产品差异化程度: ____（低=买方强势）",
        "转换成本: ____（低=买方容易跑）",
        "🔑 关键问题: 客户能否压低你的价格？",
    ]),
    ("新进入者威胁", "Threat of Entry", [
        "资金壁垒: ____（启动资金门槛）",
        "技术壁垒: ____（专利/know-how）",
        "品牌壁垒: ____（品牌忠诚度）",
        "政策壁垒: ____（牌照/许可证）",
        "🔑 关键问题: 新玩家容易进来吗？",
    ]),
    ("替代品威胁", "Substitutes", [
        "替代品数量: ____",
        "替代品性价比: ____",
        "用户转换意愿: ____",
        "🔑 关键问题: 用户会被什么替代方案吸走？",
    ]),
    ("行业竞争强度", "Rivalry", [
        "竞争者数量: ____",
        "行业增长率: ____（低增长=零和博弈）",
        "产品同质化: ____（高=价格战）",
        "退出壁垒: ____（高=拼死不走）",
        "🔑 关键问题: 现有竞争有多激烈？",
    ]),
]
for i, (name, en, items) in enumerate(forces):
    print()
    print("  {}. {} ({})".format(i+1, name, en))
    print("  " + "-" * 48)
    for item in items:
        print("    {}".format(item))
print()
print("  📊 综合评估:")
print("  ┌────────────────┬──────┬──────┬──────┐")
print("  │     力量       │  弱  │  中  │  强  │")
print("  ├────────────────┼──────┼──────┼──────┤")
for name, _, _ in forces:
    print("  │ {:14} │  □   │  □   │  □   │".format(name))
print("  └────────────────┴──────┴──────┴──────┘")
print()
print("  💡 策略建议: 在五力中找到你最有优势的位置")
print("  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;
  matrix)
    P1="${1:?请输入产品1}"
    P2="${2:?请输入产品2}"
    export _MATRIX_P1="$P1"
    export _MATRIX_P2="$P2"
    python3 << 'PYEOF'
import os
p1 = os.environ.get("_MATRIX_P1", "A")
p2 = os.environ.get("_MATRIX_P2", "B")
dims = [
    ("核心功能", "产品最主要解决的问题"),
    ("价格策略", "定价模式和价格区间"),
    ("目标用户", "核心用户画像"),
    ("技术优势", "技术壁垒和独特性"),
    ("用户体验", "易用性和满意度"),
    ("市场份额", "市场占有率估算"),
    ("品牌认知", "用户心智占有"),
    ("生态系统", "合作伙伴和集成"),
    ("增长速度", "用户/收入增长趋势"),
    ("售后服务", "客服和支持体系"),
]
print("=" * 60)
print("  📊 功能对比矩阵: {} vs {}".format(p1, p2))
print("=" * 60)
print()
print("  {:12} │ {:16} │ {:16}".format("维度", p1[:16], p2[:16]))
print("  " + "─" * 12 + "┼" + "─" * 18 + "┼" + "─" * 18)
for dim, desc in dims:
    print("  {:12} │ {:16} │ {:16}".format(dim, "____", "____"))
print()
print("  📝 差异化建议:")
print("    1. 找到对手弱、你强的维度 → 这是你的差异化卖点")
print("    2. 对手强你也强的维度 → 持续投入保持优势")
print("    3. 对手强你弱的维度 → 评估是否值得追赶")
print("    4. 双方都弱的维度 → 潜在蓝海机会")
print()
print("  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;
  moat)
    COMPANY="${1:?请输入公司或产品名称}"
    export _MOAT_CO="$COMPANY"
    python3 << 'PYEOF'
import os
co = os.environ.get("_MOAT_CO", "")
print("=" * 56)
print("  🏰 护城河分析 — {}".format(co))
print("=" * 56)
moats = [
    ("品牌护城河", "Brand", [
        "品牌知名度: ____（1-10分）",
        "品牌溢价能力: 能比竞品贵____%",
        "用户心智: 提到____品类首先想到____",
        "品牌故事: ____",
        "💡 强品牌=定价权+获客成本低",
    ]),
    ("技术护城河", "Technology", [
        "核心专利数量: ____",
        "技术领先周期: ____年",
        "研发投入占比: ____%",
        "技术团队规模: ____人",
        "💡 技术壁垒=竞争者追赶需要时间+资金",
    ]),
    ("网络效应", "Network Effect", [
        "用户规模: ____",
        "用户增长是否带来价值提升: ____",
        "双边市场: ____（如平台连接买卖双方）",
        "💡 用户越多→产品越好→吸引更多用户",
    ]),
    ("成本优势", "Cost Advantage", [
        "规模效应: ____（产量越大成本越低）",
        "独特资源: ____（专属渠道/原料/位置）",
        "运营效率: ____（自动化/流程优势）",
        "💡 同样的产品你能做到更便宜",
    ]),
    ("转换成本", "Switching Cost", [
        "数据迁移难度: ____",
        "学习成本: ____（用户已花时间学会）",
        "生态绑定: ____（关联产品/配件/插件）",
        "合同锁定: ____（年费/长期合约）",
        "💡 用户想走但走不掉=最稳的护城河",
    ]),
]
for i, (name, en, items) in enumerate(moats):
    print()
    print("  {}. {} ({})".format(i+1, name, en))
    print("  " + "-" * 48)
    for item in items:
        print("    {}".format(item))
print()
print("  🎯 护城河强度评估:")
for name, _, _ in moats:
    print("    {} [□无 □弱 □中 □强]".format(name))
print()
print("  ⚠️ 本分析为商业研究参考，不构成投资建议")
print("  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;
  help|*)
    cat << 'EOF'
============================================================
  竞品分析工具
============================================================

用法: compete.sh <命令> [参数...]

命令:
  swot "产品"                    SWOT分析模板
  compare "产品A" "产品B"        竞品对比表
  positioning "产品" "行业"      市场定位分析
  strategy "产品" "竞品"         差异化竞争策略
  help                           显示本帮助信息

示例:
  compete.sh swot "飞书"
  compete.sh compare "钉钉" "企业微信"
  compete.sh positioning "Notion" "协作办公"
  compete.sh strategy "Figma" "Sketch"

============================================================
EOF
    ;;
esac

echo ""
echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
