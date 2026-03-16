#!/usr/bin/env bash
# Mindmap Generator — create, brainstorm, organize, outline, expand, template
# Usage: bash mindmap.sh <command> [args]

CMD="$1"; shift 2>/dev/null; INPUT="$*"

case "$CMD" in
  create)
    if [[ -z "$INPUT" ]]; then
      cat <<'EOF'
🧠 创建思维导图 (Create Mindmap)

用法: create <主题>

示例:
  create 项目管理
  create 人工智能
  create 健康生活
  create Web开发

输出: Markdown缩进格式的思维导图框架

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
      exit 0
    fi

    cat <<EOF
🧠 思维导图: $INPUT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# $INPUT
## 1. 定义与概述
### 1.1 是什么
#### - 基本定义
#### - 核心概念
### 1.2 为什么重要
#### - 价值和意义
#### - 应用场景
### 1.3 发展历史
#### - 起源
#### - 关键里程碑
## 2. 核心组成
### 2.1 要素一
#### - 子要素 A
#### - 子要素 B
### 2.2 要素二
#### - 子要素 A
#### - 子要素 B
### 2.3 要素三
#### - 子要素 A
#### - 子要素 B
## 3. 方法与实践
### 3.1 常用方法
#### - 方法一
#### - 方法二
### 3.2 最佳实践
#### - 实践一
#### - 实践二
### 3.3 常见误区
#### - 误区一
#### - 误区二
## 4. 工具与资源
### 4.1 常用工具
### 4.2 学习资源
### 4.3 社区/论坛
## 5. 趋势与展望
### 5.1 当前趋势
### 5.2 未来方向
### 5.3 机遇与挑战

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📌 可视化预览:

  $INPUT
  ├── 定义与概述
  │   ├── 是什么
  │   ├── 为什么重要
  │   └── 发展历史
  ├── 核心组成
  │   ├── 要素一
  │   ├── 要素二
  │   └── 要素三
  ├── 方法与实践
  │   ├── 常用方法
  │   ├── 最佳实践
  │   └── 常见误区
  ├── 工具与资源
  │   ├── 常用工具
  │   ├── 学习资源
  │   └── 社区/论坛
  └── 趋势与展望
      ├── 当前趋势
      ├── 未来方向
      └── 机遇与挑战

💡 用 expand 命令可以展开任意节点
💡 用 outline 命令可以转为写作大纲

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
    ;;

  brainstorm)
    if [[ -z "$INPUT" ]]; then
      cat <<'EOF'
💡 头脑风暴 (Brainstorm)

用法: brainstorm <主题/问题>

示例:
  brainstorm 新产品创意
  brainstorm 如何提高用户留存
  brainstorm 团队建设活动

规则:
  - 不批判，只发散
  - 数量优先，越多越好
  - 鼓励疯狂想法
  - 组合和改进

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
      exit 0
    fi

    cat <<EOF
💡 头脑风暴: $INPUT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎯 核心问题: $INPUT

🌈 发散思维 (不评判，尽情发挥)

  $INPUT
  │
  ├── 🔴 方向一: 传统/常规思路
  │   ├── 想法 1.1: ________________
  │   ├── 想法 1.2: ________________
  │   └── 想法 1.3: ________________
  │
  ├── 🟠 方向二: 技术/工具驱动
  │   ├── 想法 2.1: ________________
  │   ├── 想法 2.2: ________________
  │   └── 想法 2.3: ________________
  │
  ├── 🟡 方向三: 用户/体验导向
  │   ├── 想法 3.1: ________________
  │   ├── 想法 3.2: ________________
  │   └── 想法 3.3: ________________
  │
  ├── 🟢 方向四: 跨界/创新思路
  │   ├── 想法 4.1: ________________
  │   ├── 想法 4.2: ________________
  │   └── 想法 4.3: ________________
  │
  └── 🔵 方向五: 疯狂/颠覆性的
      ├── 想法 5.1: ________________
      ├── 想法 5.2: ________________
      └── 想法 5.3: ________________

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎲 随机刺激词 (用来激发新想法):
  $(shuf -e 连接 反转 缩小 放大 组合 替代 简化 极端 跨界 游戏化 自动化 社交 移动 免费 订阅 共享 个性化 即时 2>/dev/null | head -5 | tr '\n' ' ' || echo "连接 反转 缩小 放大 组合")

💭 SCAMPER 创意法:
  S-替代: 能用什么替代？
  C-组合: 能和什么组合？
  A-调整: 能怎么调整？
  M-放大: 放大会怎样？
  P-另用: 还能用在哪？
  E-消除: 去掉什么会更好？
  R-反转: 反过来会怎样？

💡 下一步: 用 organize 命令整理分类这些想法

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
    ;;

  organize)
    if [[ -z "$INPUT" ]]; then
      cat <<'EOF'
📂 整理分类 (Organize)

用法: organize <想法1>, <想法2>, <想法3>...

示例:
  organize 买菜, 写代码, 读书, 跑步, 做饭, 学英语
  organize 功能A, 功能B, 功能C, 功能D

自动按类别分组整理

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
      exit 0
    fi

    IFS=',' read -ra ITEMS <<< "$INPUT"
    CLEAN=()
    for item in "${ITEMS[@]}"; do
      item=$(echo "$item" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
      [[ -n "$item" ]] && CLEAN+=("$item")
    done

    NUM=${#CLEAN[@]}

    echo "📂 信息整理分类"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "📥 收集到 $NUM 个条目"
    echo ""
    echo "📋 条目列表:"
    for ((i=0; i<NUM; i++)); do
      echo "  $((i+1)). ${CLEAN[$i]}"
    done
    echo ""
    echo "📂 分类模板 (请将条目归类):"
    echo ""
    echo "  整理结果"
    echo "  ├── 📁 类别 A: ________"

    # Distribute items into placeholder categories
    CATS=("类别 A" "类别 B" "类别 C")
    CAT_IDX=0
    for ((i=0; i<NUM; i++)); do
      if ((i > 0 && i % ((NUM / 3 + 1)) == 0 && CAT_IDX < 2)); then
        CAT_IDX=$((CAT_IDX + 1))
        echo "  ├── 📁 ${CATS[$CAT_IDX]}: ________"
      fi
      echo "  │   ├── ${CLEAN[$i]}"
    done

    echo "  └── 📁 其他"
    echo "      └── (未分类的放这里)"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "整理方法:"
    echo "  1. 亲和图法: 把相似的放一起，再给组起名"
    echo "  2. MECE原则: 相互独立，完全穷尽"
    echo "  3. 金字塔: 先结论，再展开"
    echo ""
    echo "💡 让AI帮你分类: 描述分类标准即可"
    echo ""
    echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
    ;;

  outline)
    if [[ -z "$INPUT" ]]; then
      cat <<'EOF'
📝 大纲生成 (Outline)

用法: outline <文章/演讲/报告主题>

示例:
  outline 年终总结报告
  outline 产品发布演讲
  outline 技术博客:微服务架构

输出: 结构化的写作/演讲大纲

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
      exit 0
    fi

    cat <<EOF
📝 大纲: $INPUT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# $INPUT

## 一、开头/引言
### 1.1 背景介绍
  - 为什么要讨论这个话题
  - 当前现状概述
### 1.2 核心观点/目标
  - 本文/演讲的主要论点
  - 预期读者/听众能获得什么
### 1.3 大纲预览
  - 将要覆盖的要点概述

## 二、正文主体

### 2.1 第一部分: _______
#### 2.1.1 要点 A
  - 论据/数据
  - 案例/举例
#### 2.1.2 要点 B
  - 论据/数据
  - 案例/举例
#### 小结

### 2.2 第二部分: _______
#### 2.2.1 要点 A
  - 论据/数据
  - 案例/举例
#### 2.2.2 要点 B
  - 论据/数据
  - 案例/举例
#### 小结

### 2.3 第三部分: _______
#### 2.3.1 要点 A
  - 论据/数据
  - 案例/举例
#### 2.3.2 要点 B
  - 论据/数据
  - 案例/举例
#### 小结

## 三、结尾/总结
### 3.1 要点回顾
  - 重述核心观点
### 3.2 行动号召
  - 希望读者/听众做什么
### 3.3 展望
  - 未来方向

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📌 树状预览:

  $INPUT
  ├── 一、开头/引言
  │   ├── 背景介绍
  │   ├── 核心观点
  │   └── 大纲预览
  ├── 二、正文主体
  │   ├── 第一部分
  │   │   ├── 要点 A (论据+案例)
  │   │   └── 要点 B (论据+案例)
  │   ├── 第二部分
  │   │   ├── 要点 A (论据+案例)
  │   │   └── 要点 B (论据+案例)
  │   └── 第三部分
  │       ├── 要点 A (论据+案例)
  │       └── 要点 B (论据+案例)
  └── 三、结尾/总结
      ├── 要点回顾
      ├── 行动号召
      └── 展望

📊 预计字数: 2000-3000字 | 演讲时长: 15-20分钟

💡 用 expand 命令展开任意章节

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
    ;;

  expand)
    if [[ -z "$INPUT" ]]; then
      cat <<'EOF'
🔍 展开细化 (Expand)

用法: expand <要展开的节点/主题>

示例:
  expand 用户增长策略
  expand 微服务架构
  expand 数据安全

将一个节点展开为更详细的子节点

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
      exit 0
    fi

    cat <<EOF
🔍 节点展开: $INPUT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  $INPUT
  │
  ├── 📌 定义
  │   ├── 概念解释
  │   ├── 关键术语
  │   └── 与相关概念的区别
  │
  ├── 🎯 目标/目的
  │   ├── 短期目标
  │   ├── 长期目标
  │   └── 衡量标准 (KPI)
  │
  ├── 📋 关键要素
  │   ├── 要素 1: ________
  │   │   ├── 详细说明
  │   │   └── 注意事项
  │   ├── 要素 2: ________
  │   │   ├── 详细说明
  │   │   └── 注意事项
  │   └── 要素 3: ________
  │       ├── 详细说明
  │       └── 注意事项
  │
  ├── 🔧 实施步骤
  │   ├── Step 1: ________
  │   ├── Step 2: ________
  │   ├── Step 3: ________
  │   └── Step 4: ________
  │
  ├── ⚠️ 常见问题
  │   ├── 问题 1 → 解决方案
  │   ├── 问题 2 → 解决方案
  │   └── 问题 3 → 解决方案
  │
  ├── 📊 案例/参考
  │   ├── 成功案例
  │   ├── 失败教训
  │   └── 行业标杆
  │
  └── 🔗 相关主题
      ├── 相关主题 A
      ├── 相关主题 B
      └── 推荐阅读

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💡 可以继续 expand 任意子节点

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
    ;;

  template)
    TMPL=$(echo "$INPUT" | tr '[:upper:]' '[:lower:]' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

    case "$TMPL" in
      swot)
        cat <<'EOF'
📊 SWOT 分析思维导图

  SWOT 分析
  ├── 💪 Strengths (优势)
  │   ├── 内部优势 1
  │   ├── 内部优势 2
  │   └── 内部优势 3
  ├── 😰 Weaknesses (劣势)
  │   ├── 内部劣势 1
  │   ├── 内部劣势 2
  │   └── 内部劣势 3
  ├── 🌟 Opportunities (机会)
  │   ├── 外部机会 1
  │   ├── 外部机会 2
  │   └── 外部机会 3
  └── ⚡ Threats (威胁)
      ├── 外部威胁 1
      ├── 外部威胁 2
      └── 外部威胁 3

交叉策略:
  ├── SO策略 (优势+机会) → 进攻
  ├── WO策略 (劣势+机会) → 改进
  ├── ST策略 (优势+威胁) → 防御
  └── WT策略 (劣势+威胁) → 撤退

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
        ;;

      okr)
        cat <<'EOF'
🎯 OKR 目标管理思维导图

  OKR 季度目标
  │
  ├── 🎯 目标 O1: ________
  │   ├── 📊 KR1.1: ________ (当前: __%)
  │   ├── 📊 KR1.2: ________ (当前: __%)
  │   └── 📊 KR1.3: ________ (当前: __%)
  │
  ├── 🎯 目标 O2: ________
  │   ├── 📊 KR2.1: ________ (当前: __%)
  │   ├── 📊 KR2.2: ________ (当前: __%)
  │   └── 📊 KR2.3: ________ (当前: __%)
  │
  └── 🎯 目标 O3: ________
      ├── 📊 KR3.1: ________ (当前: __%)
      ├── 📊 KR3.2: ________ (当前: __%)
      └── 📊 KR3.3: ________ (当前: __%)

OKR 原则:
  O — 鼓舞人心、定性描述
  KR — 可衡量、有截止时间
  进度: 0.7 = 理想完成度

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
        ;;

      5w1h)
        cat <<'EOF'
❓ 5W1H 分析思维导图

  5W1H 分析
  │
  ├── ❓ What (什么)
  │   ├── 是什么？
  │   ├── 做什么？
  │   └── 目标是什么？
  │
  ├── ❓ Why (为什么)
  │   ├── 为什么要做？
  │   ├── 原因是什么？
  │   └── 目的是什么？
  │
  ├── ❓ Who (谁)
  │   ├── 谁负责？
  │   ├── 谁参与？
  │   └── 谁受影响？
  │
  ├── ❓ When (何时)
  │   ├── 什么时候开始？
  │   ├── 什么时候结束？
  │   └── 有哪些里程碑？
  │
  ├── ❓ Where (哪里)
  │   ├── 在哪里执行？
  │   ├── 影响范围？
  │   └── 资源在哪里？
  │
  └── ❓ How (如何)
      ├── 怎么做？
      ├── 方法/流程？
      ├── 需要什么资源？
      └── 如何衡量成功？

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
        ;;

      project)
        cat <<'EOF'
📋 项目规划思维导图

  项目: ________
  │
  ├── 📋 项目概述
  │   ├── 项目背景
  │   ├── 目标与范围
  │   └── 成功标准
  │
  ├── 👥 团队与角色
  │   ├── 项目经理
  │   ├── 开发团队
  │   ├── 设计团队
  │   └── 利益相关者
  │
  ├── 📅 时间线
  │   ├── Phase 1: 启动 (Week 1-2)
  │   ├── Phase 2: 开发 (Week 3-8)
  │   ├── Phase 3: 测试 (Week 9-10)
  │   └── Phase 4: 上线 (Week 11-12)
  │
  ├── 💰 资源与预算
  │   ├── 人力成本
  │   ├── 工具/服务
  │   └── 应急预算 (10-20%)
  │
  ├── ⚠️ 风险管理
  │   ├── 技术风险
  │   ├── 进度风险
  │   └── 应对方案
  │
  └── 📊 度量与汇报
      ├── KPI 指标
      ├── 汇报频率
      └── 验收标准

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
        ;;

      study)
        cat <<'EOF'
📚 学习笔记思维导图

  学习主题: ________
  │
  ├── 📖 基础概念
  │   ├── 定义
  │   ├── 核心原理
  │   └── 关键术语
  │
  ├── 📝 知识要点
  │   ├── 要点 1
  │   │   ├── 解释
  │   │   └── 例子
  │   ├── 要点 2
  │   │   ├── 解释
  │   │   └── 例子
  │   └── 要点 3
  │       ├── 解释
  │       └── 例子
  │
  ├── 🔗 关联知识
  │   ├── 前置知识
  │   ├── 相关主题
  │   └── 延伸阅读
  │
  ├── 💡 个人理解
  │   ├── 用自己的话解释
  │   ├── 类比/比喻
  │   └── 疑问
  │
  └── ✅ 练习与检验
      ├── 练习题
      ├── 实际应用
      └── 教给别人

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
        ;;

      *)
        cat <<'EOF'
📚 思维导图模板库

可用模板:
  swot     — SWOT 分析 (优势/劣势/机会/威胁)
  okr      — OKR 目标管理 (目标与关键结果)
  5w1h     — 5W1H 分析 (What/Why/Who/When/Where/How)
  project  — 项目规划 (概述/团队/时间线/预算/风险)
  study    — 学习笔记 (概念/要点/关联/理解/练习)

用法: template <模板名>
示例: template swot

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
        ;;
    esac
    ;;

  *)
    cat <<'EOF'
🧠 思维导图生成工具 (Mindmap Generator)

用法: bash mindmap.sh <command> [args]

命令:
  create      根据主题生成思维导图
  brainstorm  头脑风暴发散
  organize    整理分类信息
  outline     文章/演讲/报告大纲
  expand      展开细化某个节点
  template    常用模板 (swot/okr/5w1h/project/study)

示例:
  bash mindmap.sh create 项目管理
  bash mindmap.sh brainstorm 新产品创意
  bash mindmap.sh organize 想法1, 想法2, 想法3
  bash mindmap.sh outline 年终总结报告
  bash mindmap.sh expand 用户增长策略
  bash mindmap.sh template swot

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
    ;;
esac
