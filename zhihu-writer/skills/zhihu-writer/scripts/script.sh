#!/usr/bin/env bash
# zhihu-writer — 知乎内容创作助手
set -euo pipefail
VERSION="2.0.0"
DATA_DIR="${ZHIHU_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/zhihu-writer}"
DRAFTS="$DATA_DIR/drafts"
mkdir -p "$DRAFTS"

show_help() {
    cat << HELP
zhihu-writer v$VERSION — 知乎内容创作助手

用法: zhihu-writer <命令> [参数]

写作:
  answer <question>           回答框架生成（高赞结构）
  article <topic> [style]     文章大纲（深度|科普|故事|盘点）
  hook <topic>                开头金句（5种风格）
  salt <topic>                制造知乎"盐"味（反常识观点）
  ending <style>              结尾模板（总结|互动|金句|系列）

排版:
  format <file>               知乎Markdown排版优化
  section <n>                 生成n段标准段落结构
  quote <text>                生成引用块
  list <items...>             生成有序/无序列表
  hr                          分割线

管理:
  draft save <name>           保存草稿
  draft list                  草稿列表
  draft show <name>           查看草稿
  draft delete <name>         删除草稿
  stats                       写作统计
  tips                        高赞技巧
  help                        帮助

HELP
}

cmd_answer() {
    local q="${1:?用法: zhihu-writer answer <问题>}"
    echo "╔══════════════════════════════════════╗"
    echo "║  知乎回答框架                        ║"
    echo "╠══════════════════════════════════════╣"
    echo "║  问题: $q"
    echo "╚══════════════════════════════════════╝"
    echo ""
    echo "  ┌─ 第一段: 钩子 (2-3行) ─────────────┐"
    echo "  │ 「先说结论：……」                    │"
    echo "  │ 或者用个人经历/反常识观点开头        │"
    echo "  └────────────────────────────────────┘"
    echo ""
    echo "  ┌─ 第二段: 为什么 (3-5行) ───────────┐"
    echo "  │ 解释原因/背景                      │"
    echo "  │ 引用数据或权威来源                  │"
    echo "  └────────────────────────────────────┘"
    echo ""
    echo "  ┌─ 第三段: 怎么做 (核心, 5-10行) ────┐"
    echo "  │ 分点列出（用粗体+编号）             │"
    echo "  │ 每个点: 观点 → 解释 → 例子          │"
    echo "  │ 3-5个要点最佳                      │"
    echo "  └────────────────────────────────────┘"
    echo ""
    echo "  ┌─ 第四段: 个人体验 (2-3行) ─────────┐"
    echo "  │ 「我自己的经验是……」                │"
    echo "  │ 增加真实感和可信度                  │"
    echo "  └────────────────────────────────────┘"
    echo ""
    echo "  ┌─ 结尾: 互动 (1-2行) ──────────────┐"
    echo "  │ 「觉得有用的话，点个赞呗 👍」       │"
    echo "  │ 或提出开放性问题引发评论            │"
    echo "  └────────────────────────────────────┘"
    _log "answer" "$q"
}

cmd_article() {
    local topic="${1:?用法: zhihu-writer article <主题> [风格]}"
    local style="${2:-深度}"
    
    echo "  ═══ 文章大纲: $topic ($style风格) ═══"
    echo ""
    case "$style" in
        深度|deep)
            echo "  标题: 「深度解析：${topic}的本质与未来」"
            echo ""
            echo "  1. 引言 — 为什么现在讨论$topic"
            echo "  2. 背景 — ${topic}的历史脉络"
            echo "  3. 现状 — 当前行业/领域的真实情况"
            echo "  4. 分析 — 核心矛盾与关键因素"
            echo "  5. 观点 — 我的判断（附论据）"
            echo "  6. 展望 — 未来3-5年趋势"
            echo "  7. 参考 — 数据来源"
            ;;
        科普|science)
            echo "  标题: 「一文讲清：${topic}到底是什么？」"
            echo ""
            echo "  1. 一句话定义$topic"
            echo "  2. 类比解释（像XX一样）"
            echo "  3. 核心原理（配图）"
            echo "  4. 3个常见误区"
            echo "  5. 实际应用场景"
            echo "  6. 延伸阅读"
            ;;
        故事|story)
            echo "  标题: 「我与${topic}的那些事」"
            echo ""
            echo "  1. 开场 — 那天发生了什么"
            echo "  2. 困境 — 遇到的问题"
            echo "  3. 转折 — 关键发现"
            echo "  4. 行动 — 具体做了什么"
            echo "  5. 结果 — 最终怎样了"
            echo "  6. 感悟 — 学到的教训"
            ;;
        盘点|list)
            echo "  标题: 「盘点${topic}的10个关键要素」"
            echo ""
            for i in $(seq 1 10); do
                echo "  $i. 要素$i — [一句话概括]"
                echo "     → 为什么重要 + 案例"
            done
            ;;
    esac
    _log "article" "$topic ($style)"
}

cmd_hook() {
    local topic="${1:?用法: zhihu-writer hook <主题>}"
    echo "  ═══ 5种开头金句: $topic ═══"
    echo ""
    echo "  1. 结论先行:"
    echo "     「先说结论：${topic}最重要的是……」"
    echo ""
    echo "  2. 反常识:"
    echo "     「关于${topic}，99%的人都理解错了。」"
    echo ""
    echo "  3. 个人经历:"
    echo "     「作为一个做了N年${topic}的人，我想说……」"
    echo ""
    echo "  4. 数据震撼:"
    echo "     「一组数据告诉你${topic}的真相：……」"
    echo ""
    echo "  5. 提问:"
    echo "     「你有没有想过，为什么${topic}会……？」"
    _log "hook" "$topic"
}

cmd_salt() {
    local topic="${1:?用法: zhihu-writer salt <主题>}"
    echo "  ═══ 知乎「盐」味观点: $topic ═══"
    echo ""
    echo "  核心: 反常识 + 有理有据"
    echo ""
    echo "  1.「大多数人对${topic}的理解停留在表面。」"
    echo "  2.「${topic}这个领域，入门容易精通难，难在……」"
    echo "  3.「说个可能被喷的观点：${topic}其实……」"
    echo "  4.「利益相关：做${topic}N年。实话说……」"
    echo ""
    echo "  ⚠️ 注意: 有态度但不极端，留讨论空间"
    _log "salt" "$topic"
}

cmd_ending() {
    local style="${1:-总结}"
    echo "  ═══ 结尾模板 ($style) ═══"
    case "$style" in
        总结|summary)
            echo "  「以上就是关于[主题]的[N]个要点。」"
            echo "  「总结一下：①… ②… ③…」"
            echo "  「最后一句话概括：……」"
            ;;
        互动|interact)
            echo "  「你怎么看？欢迎在评论区分享你的想法。」"
            echo "  「觉得有用就点个赞，让更多人看到 👍」"
            echo "  「关注我，后续还会分享更多关于[主题]的内容。」"
            ;;
        金句|quote)
            echo "  「[名人]说过：……这句话放在[主题]上，再合适不过。」"
            ;;
        系列|series)
            echo "  「这是[主题]系列的第N篇。」"
            echo "  「下一篇我们聊：……」"
            echo "  「点关注不迷路 →」"
            ;;
    esac
}

cmd_format() {
    local file="${1:?用法: zhihu-writer format <文件>}"
    [ -f "$file" ] || { echo "找不到: $file"; return 1; }
    echo "  排版建议:"
    local lines=$(wc -l < "$file")
    local chars=$(wc -c < "$file")
    echo "  行数: $lines  字数: $chars"
    echo "  ✓ 段落间空一行"
    echo "  ✓ 重点用**粗体**"
    echo "  ✓ 列表用「1. 2. 3.」"
    echo "  ✓ 引用用 > 块"
    echo "  ✓ 每段不超过5行"
}

cmd_section() {
    local n="${1:-3}"
    for i in $(seq 1 "$n"); do
        echo ""
        echo "## 第${i}部分标题"
        echo ""
        echo "[主要观点一句话]"
        echo ""
        echo "[展开解释2-3句]"
        echo ""
        echo "> 引用/数据/案例"
        echo ""
        echo "---"
    done
}

cmd_draft() {
    local action="${1:-list}"
    case "$action" in
        save)
            local name="${2:?用法: zhihu-writer draft save <名称>}"
            cat > "$DRAFTS/$name.md"
            echo "草稿已保存: $name"
            ;;
        list)
            echo "  草稿列表:"
            ls -1 "$DRAFTS"/*.md 2>/dev/null | while read -r f; do
                printf "  %-20s %s\n" "$(basename "$f" .md)" "$(wc -c < "$f") bytes"
            done || echo "  (空)"
            ;;
        show)
            local name="${2:?}"
            [ -f "$DRAFTS/$name.md" ] && cat "$DRAFTS/$name.md" || echo "找不到: $name"
            ;;
        delete)
            local name="${2:?}"
            [ -f "$DRAFTS/$name.md" ] && { rm "$DRAFTS/$name.md"; echo "已删除: $name"; } || echo "找不到"
            ;;
    esac
}

cmd_tips() {
    echo "  ═══ 知乎高赞技巧 ═══"
    echo "  1. 开头2行决定生死 — 必须有钩子"
    echo "  2. 结论先行 — 别让人猜"
    echo "  3. 排版要松 — 大段文字没人看"
    echo "  4. 配图 — 增加停留时间"
    echo "  5. 有态度 — 但不极端"
    echo "  6. 互动 — 结尾引导评论"
    echo "  7. 黄金发布时间 — 20:00-22:00"
    echo "  8. 回复评论 — 前2小时最关键"
}

cmd_stats() {
    local count=$(ls -1 "$DRAFTS"/*.md 2>/dev/null | wc -l)
    echo "[zhihu-writer] 统计"
    echo "  草稿: $count 篇"
    echo "  历史: $(wc -l < "$DATA_DIR/history.log" 2>/dev/null || echo 0) 次操作"
    echo "  目录: $DATA_DIR"
}

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }

case "${1:-help}" in
    answer)     shift; cmd_answer "$@" ;;
    article)    shift; cmd_article "$@" ;;
    hook)       shift; cmd_hook "$@" ;;
    salt)       shift; cmd_salt "$@" ;;
    ending)     shift; cmd_ending "$@" ;;
    format)     shift; cmd_format "$@" ;;
    section)    shift; cmd_section "$@" ;;
    quote)      shift; echo "> $*" ;;
    list)       shift; local i=1; for item in "$@"; do echo "  $i. $item"; i=$((i+1)); done ;;
    hr)         echo "---" ;;
    draft)      shift; cmd_draft "$@" ;;
    tips)       cmd_tips ;;
    stats)      cmd_stats ;;
    help|-h)    show_help ;;
    version|-v) echo "zhihu-writer v$VERSION" ;;
    *)          echo "未知命令: $1"; show_help; exit 1 ;;
esac
