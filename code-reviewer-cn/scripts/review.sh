#!/usr/bin/env bash
# review.sh — 代码审查工具（真实分析版）
# Usage: bash review.sh <command> <file_or_dir>
# Commands: review, complexity, naming, comments, duplicates, security, all
set -euo pipefail

CMD="${1:-help}"
shift 2>/dev/null || true
TARGET="${1:-}"

# ── 颜色 ──
RED='\033[0;31m'; YEL='\033[0;33m'; GRN='\033[0;32m'; CYN='\033[0;36m'; RST='\033[0m'

die() { echo -e "${RED}❌ $1${RST}" >&2; exit 1; }

# ── 检查文件 ──
check_target() {
  [[ -n "$TARGET" ]] || die "请指定要审查的文件或目录"
  [[ -e "$TARGET" ]] || die "文件不存在: $TARGET"
}

# ── 统计基础信息 ──
file_stats() {
  local f="$1"
  local total_lines blank_lines comment_lines code_lines
  total_lines=$(wc -l < "$f")
  blank_lines=$(grep -c '^[[:space:]]*$' "$f" 2>/dev/null || echo 0)

  # 检测语言
  local ext="${f##*.}"
  local lang="unknown"
  case "$ext" in
    py)    lang="Python"; comment_lines=$(grep -cE '^\s*#' "$f" 2>/dev/null || echo 0) ;;
    js|ts|jsx|tsx) lang="JavaScript/TypeScript"; comment_lines=$(grep -cE '^\s*//' "$f" 2>/dev/null || echo 0) ;;
    java)  lang="Java"; comment_lines=$(grep -cE '^\s*//' "$f" 2>/dev/null || echo 0) ;;
    go)    lang="Go"; comment_lines=$(grep -cE '^\s*//' "$f" 2>/dev/null || echo 0) ;;
    rb)    lang="Ruby"; comment_lines=$(grep -cE '^\s*#' "$f" 2>/dev/null || echo 0) ;;
    sh|bash) lang="Shell"; comment_lines=$(grep -cE '^\s*#' "$f" 2>/dev/null || echo 0) ;;
    rs)    lang="Rust"; comment_lines=$(grep -cE '^\s*//' "$f" 2>/dev/null || echo 0) ;;
    c|h|cpp|hpp) lang="C/C++"; comment_lines=$(grep -cE '^\s*//' "$f" 2>/dev/null || echo 0) ;;
    *)     comment_lines=$(grep -cE '^\s*(#|//)' "$f" 2>/dev/null || echo 0) ;;
  esac

  code_lines=$((total_lines - blank_lines - comment_lines))
  local comment_ratio=0
  if (( code_lines > 0 )); then
    comment_ratio=$(echo "scale=1; $comment_lines * 100 / $code_lines" | bc)
  fi

  echo "LANG=$lang"
  echo "TOTAL=$total_lines"
  echo "CODE=$code_lines"
  echo "BLANK=$blank_lines"
  echo "COMMENTS=$comment_lines"
  echo "COMMENT_RATIO=$comment_ratio"
}

# ── 复杂度分析 ──
analyze_complexity() {
  local f="$1"
  echo "## ⚡ 复杂度分析 — $(basename "$f")"
  echo ""

  # 函数/方法检测
  local func_count=0
  local ext="${f##*.}"

  case "$ext" in
    py)
      func_count=$(grep -c '^\s*def ' "$f" 2>/dev/null || echo 0)
      local class_count
      class_count=$(grep -c '^\s*class ' "$f" 2>/dev/null || echo 0)
      echo "- 🔧 函数数量: $func_count"
      echo "- 📦 类数量: $class_count"
      ;;
    js|ts|jsx|tsx)
      func_count=$(grep -cE '(function |=>|^\s*(async\s+)?[a-zA-Z]+\s*\()' "$f" 2>/dev/null || echo 0)
      echo "- 🔧 函数/箭头函数: $func_count"
      ;;
    java|go|rs|c|cpp)
      func_count=$(grep -cE '^\s*(public|private|protected|func|fn)\s' "$f" 2>/dev/null || echo 0)
      echo "- 🔧 函数/方法: $func_count"
      ;;
    sh|bash)
      func_count=$(grep -cE '^\s*[a-zA-Z_]+\s*\(\)' "$f" 2>/dev/null || echo 0)
      echo "- 🔧 函数: $func_count"
      ;;
  esac

  # 圈复杂度估算(通过条件分支计数)
  local branches=0
  branches=$(grep -cE '\b(if|elif|else|for|while|case|catch|except|switch|&&|\|\|)\b' "$f" 2>/dev/null || echo 0)
  local avg_cc=0
  if (( func_count > 0 )); then
    avg_cc=$(echo "scale=1; ($branches + $func_count) / $func_count" | bc)
  fi
  echo "- 🔀 条件分支数: $branches"
  echo "- 📐 平均圈复杂度估算: $avg_cc"
  echo ""

  # 嵌套深度检测
  local max_indent=0
  while IFS= read -r line; do
    local stripped="${line#"${line%%[! ]*}"}"
    local indent_len=$(( ${#line} - ${#stripped} ))
    local indent_level=$((indent_len / 2))
    if (( indent_level > max_indent )); then
      max_indent=$indent_level
    fi
  done < "$f"
  echo "- 📏 最大嵌套深度: $max_indent 层"

  # 评级
  local rating="🟢 良好"
  if (( avg_cc > 10 )); then
    rating="🔴 复杂度过高 — 建议重构"
  elif (( avg_cc > 5 )); then
    rating="🟡 中等 — 可以优化"
  fi
  if (( max_indent > 6 )); then
    rating="🔴 嵌套过深 — 建议提取函数"
  fi
  echo "- 🏷️ 评级: $rating"

  # 长函数检测
  echo ""
  echo "### 长行检测 (>120字符)"
  local long_lines
  long_lines=$(awk 'length > 120 { printf "  行%d: %d字符\n", NR, length }' "$f" 2>/dev/null)
  if [[ -n "$long_lines" ]]; then
    echo "$long_lines" | head -10
    local long_count
    long_count=$(awk 'length > 120' "$f" | wc -l)
    echo "  共 $long_count 行超过120字符"
  else
    echo "  ✅ 无超长行"
  fi
}

# ── 命名检查 ──
check_naming() {
  local f="$1"
  local ext="${f##*.}"
  echo "## 📖 命名规范检查 — $(basename "$f")"
  echo ""

  local issues=0

  # 单字符变量（排除循环变量 i,j,k,x,y）
  echo "### 单字符变量（可能不够描述性）"
  local single_vars
  single_vars=$(grep -noE '\b[a-hm-wz]\b\s*=' "$f" 2>/dev/null | head -10)
  if [[ -n "$single_vars" ]]; then
    echo "$single_vars" | while read -r line; do
      echo "  ⚠️ $line"
      ((issues++)) || true
    done
  else
    echo "  ✅ 无可疑单字符变量"
  fi

  echo ""
  echo "### 命名风格一致性"
  local camel_count snake_count
  camel_count=$(grep -coE '\b[a-z]+[A-Z][a-z]+' "$f" 2>/dev/null || echo 0)
  snake_count=$(grep -coE '\b[a-z]+_[a-z]+' "$f" 2>/dev/null || echo 0)

  echo "  - camelCase 命名: $camel_count 处"
  echo "  - snake_case 命名: $snake_count 处"

  if (( camel_count > 0 && snake_count > 0 )); then
    local dominant=""
    if (( camel_count > snake_count )); then
      dominant="camelCase"
    else
      dominant="snake_case"
    fi
    echo "  ⚠️ 混用了两种命名风格！主要风格: $dominant"
    echo "  建议: 统一为 $dominant"
  else
    echo "  ✅ 命名风格一致"
  fi

  echo ""
  echo "### 全大写常量"
  local consts
  consts=$(grep -coE '\b[A-Z][A-Z_]{2,}\b' "$f" 2>/dev/null || echo 0)
  echo "  - 大写常量: $consts 个"

  echo ""
  echo "### TODO/FIXME/HACK 标记"
  local todos
  todos=$(grep -noEi '(TODO|FIXME|HACK|XXX|WARN):?' "$f" 2>/dev/null || true)
  if [[ -n "$todos" ]]; then
    echo "$todos" | while read -r line; do
      echo "  📌 $line"
    done
  else
    echo "  ✅ 无待处理标记"
  fi
}

# ── 注释率分析 ──
check_comments() {
  local f="$1"
  echo "## 💬 注释分析 — $(basename "$f")"
  echo ""

  eval "$(file_stats "$f")"

  echo "| 指标 | 数值 |"
  echo "|------|------|"
  echo "| 总行数 | $TOTAL |"
  echo "| 代码行 | $CODE |"
  echo "| 空行 | $BLANK |"
  echo "| 注释行 | $COMMENTS |"
  echo "| 注释率 | ${COMMENT_RATIO}% |"
  echo "| 语言 | $LANG |"
  echo ""

  # 注释率评级
  local cr_float
  cr_float=$(echo "$COMMENT_RATIO" | bc)
  if (( $(echo "$cr_float < 5" | bc -l) )); then
    echo "⚠️ 注释率偏低 (<5%)。建议为关键逻辑添加注释。"
  elif (( $(echo "$cr_float > 40" | bc -l) )); then
    echo "⚠️ 注释率偏高 (>40%)。可能存在过度注释或注释掉的代码。"
  else
    echo "✅ 注释率在合理范围 (5-40%)。"
  fi

  # 检查是否有文件头注释
  echo ""
  local first_line
  first_line=$(head -1 "$f")
  if [[ "$first_line" =~ ^[[:space:]]*(#|//) ]]; then
    echo "✅ 文件有头部注释"
  else
    echo "⚠️ 文件缺少头部注释"
  fi
}

# ── 重复代码检测 ──
detect_duplicates() {
  local f="$1"
  echo "## 🔄 重复代码检测 — $(basename "$f")"
  echo ""

  # 检测连续相似行（简化的重复检测）
  local dup_count=0
  local prev_hash="" prev_line_num=0 dup_start=0

  while IFS= read -r line_num_line; do
    local lnum="${line_num_line%%:*}"
    local line="${line_num_line#*:}"
    # 跳过空行和纯注释
    local trimmed
    trimmed=$(echo "$line" | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
    [[ -z "$trimmed" ]] && continue
    [[ "$trimmed" =~ ^(#|//) ]] && continue

    local cur_hash
    cur_hash=$(echo "$trimmed" | md5sum | cut -c1-16)
    if [[ "$cur_hash" == "$prev_hash" && -n "$prev_hash" ]]; then
      ((dup_count++))
      if (( dup_start == 0 )); then
        dup_start=$prev_line_num
      fi
    else
      if (( dup_count > 0 )); then
        echo "  ⚠️ 行 $dup_start-$lnum: 连续 $((dup_count+1)) 行重复"
      fi
      dup_count=0
      dup_start=0
    fi
    prev_hash="$cur_hash"
    prev_line_num="$lnum"
  done < <(nl -ba "$f")

  # 检测相似行模式（哈希去重）
  echo ""
  echo "### 完全重复行"
  local sorted_hashes
  sorted_hashes=$(grep -vE '^\s*$|^\s*(#|//)' "$f" | sed 's/^[[:space:]]*//' | sort | uniq -cd | sort -rn | head -5)

  if [[ -n "$sorted_hashes" ]]; then
    echo "$sorted_hashes" | while read -r count content; do
      echo "  ⚠️ 重复 ${count}次: \`${content:0:60}\`"
    done
  else
    echo "  ✅ 无完全重复行"
  fi
}

# ── 安全检查 ──
check_security() {
  local f="$1"
  echo "## 🔒 安全检查 — $(basename "$f")"
  echo ""

  local issues=0

  # 硬编码密码/密钥
  echo "### 敏感信息泄露"
  local secrets
  secrets=$(grep -niE '(password|passwd|secret|api_key|apikey|token|private_key)\s*=\s*["\x27][^"\x27]+' "$f" 2>/dev/null || true)
  if [[ -n "$secrets" ]]; then
    echo "$secrets" | while read -r line; do
      echo "  🔴 $line"
      ((issues++)) || true
    done
  else
    echo "  ✅ 未发现硬编码密码/密钥"
  fi

  echo ""
  echo "### SQL注入风险"
  local sqli
  sqli=$(grep -niE '(execute|query|cursor\.exec)\s*\(\s*["\x27].*\+|f".*SELECT|f".*INSERT|f".*UPDATE|f".*DELETE' "$f" 2>/dev/null || true)
  if [[ -n "$sqli" ]]; then
    echo "$sqli" | while read -r line; do
      echo "  🔴 $line"
    done
  else
    echo "  ✅ 未发现明显SQL注入风险"
  fi

  echo ""
  echo "### 危险函数调用"
  local danger
  danger=$(grep -niE '\b(eval|exec|system|popen|os\.system|subprocess\.call|shell=True)\b' "$f" 2>/dev/null || true)
  if [[ -n "$danger" ]]; then
    echo "$danger" | while read -r line; do
      echo "  🟡 $line"
    done
  else
    echo "  ✅ 未发现危险函数调用"
  fi

  echo ""
  echo "### 其他安全项"
  # HTTP vs HTTPS
  local http_count
  http_count=$(grep -coE 'http://' "$f" 2>/dev/null || echo 0)
  if (( http_count > 0 )); then
    echo "  ⚠️ 发现 $http_count 处 HTTP (非HTTPS) 链接"
  fi
  # 调试代码
  local debug_count
  debug_count=$(grep -cE '(console\.log|print\(|System\.out\.print|fmt\.Print|debug)' "$f" 2>/dev/null || echo 0)
  if (( debug_count > 0 )); then
    echo "  ⚠️ 发现 $debug_count 处调试输出语句"
  fi
}

# ── 综合审查 ──
full_review() {
  local target="$1"
  local files=()

  if [[ -d "$target" ]]; then
    while IFS= read -r f; do
      files+=("$f")
    done < <(find "$target" -type f \( -name "*.py" -o -name "*.js" -o -name "*.ts" -o -name "*.java" -o -name "*.go" -o -name "*.sh" -o -name "*.rb" -o -name "*.rs" -o -name "*.c" -o -name "*.cpp" \) | head -20)
  else
    files=("$target")
  fi

  local total_score=0 file_count=0

  echo "# 🔍 代码审查报告"
  echo "> 审查时间: $(date '+%Y-%m-%d %H:%M')"
  echo "> 审查范围: $target"
  echo ""

  for f in "${files[@]}"; do
    echo "---"
    echo ""
    eval "$(file_stats "$f")"
    echo "# 📄 $(basename "$f") ($LANG, $TOTAL行)"
    echo ""

    # 评分
    local score=100

    # 注释率扣分
    local cr_int=${COMMENT_RATIO%.*}
    if (( cr_int < 5 )); then
      score=$((score - 10))
    fi

    # 长度扣分
    local long_lines
    long_lines=$(awk 'length > 120' "$f" | wc -l)
    if (( long_lines > 5 )); then
      score=$((score - 10))
    fi

    # 复杂度扣分
    local branches
    branches=$(grep -cE '\b(if|elif|else|for|while|case|catch|except)\b' "$f" 2>/dev/null || echo 0)
    local funcs
    funcs=$(grep -cE '(def |function |func |fn |=>\s*{)' "$f" 2>/dev/null || echo 0)
    if (( funcs > 0 )); then
      local avg_cc=$(( (branches + funcs) / funcs ))
      if (( avg_cc > 10 )); then score=$((score - 20)); fi
    fi

    # 安全扣分
    local sec_issues
    sec_issues=$(grep -cE '(password|secret|api_key)\s*=' "$f" 2>/dev/null || echo 0)
    score=$((score - sec_issues * 15))

    (( score < 0 )) && score=0
    total_score=$((total_score + score))
    ((file_count++))

    local grade_emoji="🟢"
    if (( score < 60 )); then grade_emoji="🔴"
    elif (( score < 80 )); then grade_emoji="🟡"; fi

    echo "**评分: ${grade_emoji} ${score}/100**"
    echo ""

    analyze_complexity "$f"
    echo ""
    check_comments "$f"
    echo ""
    check_naming "$f"
    echo ""
    detect_duplicates "$f"
    echo ""
    check_security "$f"
    echo ""
  done

  if (( file_count > 1 )); then
    local avg_score=$((total_score / file_count))
    echo "---"
    echo ""
    echo "## 📊 总览"
    echo "- 审查文件数: $file_count"
    echo "- 平均评分: $avg_score/100"
  fi
}

# ── 帮助 ──
show_help() {
  cat <<'HELP'
🔍 代码审查工具 — review.sh

用法: bash review.sh <command> <file_or_dir>

命令:
  review <file|dir>    → 综合审查（评分+所有检查）
  complexity <file>    → 复杂度分析（圈复杂度/嵌套/长行）
  naming <file>        → 命名规范检查
  comments <file>      → 注释率分析
  duplicates <file>    → 重复代码检测
  security <file>      → 安全漏洞扫描
  help                 → 显示帮助

示例:
  bash review.sh review ./src/
  bash review.sh complexity app.py
  bash review.sh security server.js
  bash review.sh naming utils.go

💡 真实分析能力:
  - 圈复杂度估算 (分支计数)
  - 嵌套深度检测
  - 命名风格一致性 (camelCase vs snake_case)
  - 注释率计算与评级
  - 重复行检测 (哈希比对)
  - 安全扫描 (SQL注入/硬编码密码/危险函数)
  - 综合评分 (100分制)
HELP
}

case "$CMD" in
  review|all)    check_target; full_review "$TARGET" ;;
  complexity)    check_target; analyze_complexity "$TARGET" ;;
  naming)        check_target; check_naming "$TARGET" ;;
  comments)      check_target; check_comments "$TARGET" ;;
  duplicates)    check_target; detect_duplicates "$TARGET" ;;
  security)      check_target; check_security "$TARGET" ;;
  help|*)        show_help ;;
esac
