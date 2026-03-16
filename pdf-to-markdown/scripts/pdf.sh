#!/usr/bin/env bash
# PDF to Markdown Converter
# Usage: bash pdf.sh <command> [arguments...]
# Commands: convert, table, extract, format, summary, compare

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"

show_help() {
    cat << 'HELPEOF'
PDF to Markdown - PDF文本转Markdown工具

用法: bash pdf.sh <command> [arguments...]

命令:
  convert <text>          将PDF文本转为clean Markdown格式
  table <text>            表格文本转Markdown表格
  extract <text>          提取关键信息（标题、日期、金额、人名）
  format <markdown>       Markdown格式美化和修复
  summary <text>          PDF内容摘要（中英文）
  compare <text1> <text2> 两份文档对比，高亮差异
  help                    显示此帮助信息

示例:
  bash pdf.sh convert "第一章 引言\n本文讨论..."
  bash pdf.sh table "姓名 年龄 城市\n张三 25 北京"
  bash pdf.sh extract "合同编号：2024-001，签订日期：2024年1月1日"
HELPEOF
    echo ""
    echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
}

cmd_convert() {
    local input="${1:-}"
    if [ -z "$input" ]; then
        echo "错误: 请提供PDF文本内容"
        echo "用法: bash pdf.sh convert \"<PDF文本>\""
        return 1
    fi

    python3 << 'PYEOF'
import sys
import re

def convert_pdf_text(text):
    lines = text.split('\n')
    result = []
    prev_empty = False

    for line in lines:
        # Strip trailing whitespace
        line = line.rstrip()

        # Skip page numbers
        if re.match(r'^\s*-?\s*\d+\s*-?\s*$', line):
            continue

        # Skip headers/footers (common patterns)
        if re.match(r'^\s*(Page\s+\d+|第\s*\d+\s*页)', line, re.IGNORECASE):
            continue

        # Detect chapter/section headings
        heading_match = re.match(r'^(第[一二三四五六七八九十百千\d]+[章节篇部分])\s*(.*)', line)
        if heading_match:
            if result and result[-1] != '':
                result.append('')
            result.append('## %s %s' % (heading_match.group(1), heading_match.group(2)))
            result.append('')
            prev_empty = True
            continue

        # Detect numbered headings like "1.1 Title" or "1. Title"
        numbered_match = re.match(r'^(\d+\.(?:\d+\.?)*)\s+(.+)', line)
        if numbered_match:
            num = numbered_match.group(1)
            depth = num.count('.')
            if depth == 0:
                depth = 1
            prefix = '#' * min(depth + 1, 6)
            if result and result[-1] != '':
                result.append('')
            result.append('%s %s %s' % (prefix, num, numbered_match.group(2)))
            result.append('')
            prev_empty = True
            continue

        # Handle bullet points
        bullet_match = re.match(r'^[\s]*[•●■◆▪·]\s*(.*)', line)
        if bullet_match:
            result.append('- %s' % bullet_match.group(1))
            prev_empty = False
            continue

        # Handle numbered lists
        numlist_match = re.match(r'^[\s]*(\d+)[)）.]\s*(.*)', line)
        if numlist_match:
            result.append('%s. %s' % (numlist_match.group(1), numlist_match.group(2)))
            prev_empty = False
            continue

        # Empty line
        if line.strip() == '':
            if not prev_empty:
                result.append('')
                prev_empty = True
            continue

        # Fix broken lines (merge short lines that are part of a paragraph)
        if (result and result[-1] and not prev_empty and
            not result[-1].startswith('#') and
            not result[-1].startswith('-') and
            not result[-1].startswith('>') and
            len(line.strip()) > 0 and
            not line[0].isupper() and
            not re.match(r'^[A-Z\u4e00-\u9fff]', line.strip())):
            result[-1] = result[-1] + line.strip()
            continue

        result.append(line.strip())
        prev_empty = False

    # Clean up multiple blank lines
    output = '\n'.join(result)
    output = re.sub(r'\n{3,}', '\n\n', output)
    return output.strip()

import os
input_text = os.environ.get('PDF_INPUT', '')
if input_text:
    print(convert_pdf_text(input_text))
else:
    print("请通过 PDF_INPUT 环境变量提供文本内容")
PYEOF
}

cmd_table() {
    local input="${1:-}"
    if [ -z "$input" ]; then
        echo "错误: 请提供表格文本"
        echo "用法: bash pdf.sh table \"<表格文本>\""
        return 1
    fi

    python3 << 'PYEOF'
import sys
import re
import os

def parse_table(text):
    lines = [l.strip() for l in text.strip().split('\n') if l.strip()]
    if not lines:
        return "没有检测到表格数据"

    # Try to detect separator: tab, multiple spaces, pipe, comma
    separators = ['\t', '|', ',']
    best_sep = None
    best_consistency = 0

    for sep in separators:
        counts = [l.count(sep) for l in lines]
        if counts[0] > 0:
            consistency = sum(1 for c in counts if c == counts[0])
            if consistency > best_consistency:
                best_consistency = consistency
                best_sep = sep

    # If no clear separator, try multiple spaces
    if best_sep is None or best_consistency < len(lines) * 0.5:
        best_sep = r'\s{2,}'
        rows = [re.split(best_sep, l) for l in lines]
    else:
        rows = [l.split(best_sep) for l in lines]

    # Clean cells
    rows = [[cell.strip() for cell in row] for row in rows]

    # Normalize column count
    max_cols = max(len(row) for row in rows)
    for row in rows:
        while len(row) < max_cols:
            row.append('')

    # Generate markdown table
    result = []

    # Header
    header = '| ' + ' | '.join(rows[0]) + ' |'
    result.append(header)

    # Separator
    sep_line = '|' + '|'.join([' --- ' for _ in range(max_cols)]) + '|'
    result.append(sep_line)

    # Data rows
    for row in rows[1:]:
        data_line = '| ' + ' | '.join(row) + ' |'
        result.append(data_line)

    return '\n'.join(result)

input_text = os.environ.get('PDF_INPUT', '')
if input_text:
    print(parse_table(input_text))
else:
    print("请通过 PDF_INPUT 环境变量提供表格文本")
PYEOF
}

cmd_extract() {
    local input="${1:-}"
    if [ -z "$input" ]; then
        echo "错误: 请提供文本内容"
        echo "用法: bash pdf.sh extract \"<文本内容>\""
        return 1
    fi

    python3 << 'PYEOF'
import re
import os

def extract_info(text):
    results = {
        'titles': [],
        'dates': [],
        'amounts': [],
        'names': [],
        'emails': [],
        'phones': [],
        'urls': [],
        'ids': []
    }

    # Extract titles (Chinese chapter/section headers)
    titles = re.findall(r'(第[一二三四五六七八九十百千\d]+[章节篇部分]\s*[^\n]*)', text)
    results['titles'].extend(titles)

    # Numbered titles
    numbered = re.findall(r'(\d+\.(?:\d+\.?)*\s+[^\n]+)', text)
    results['titles'].extend(numbered)

    # Extract dates
    date_patterns = [
        r'\d{4}[-/年]\d{1,2}[-/月]\d{1,2}[日号]?',
        r'\d{4}\.\d{1,2}\.\d{1,2}',
        r'\d{1,2}/\d{1,2}/\d{4}',
        r'\d{4}年\d{1,2}月',
    ]
    for pattern in date_patterns:
        dates = re.findall(pattern, text)
        results['dates'].extend(dates)

    # Extract amounts (Chinese yuan and general currency)
    amount_patterns = [
        r'[￥¥]\s*[\d,]+\.?\d*',
        r'\$\s*[\d,]+\.?\d*',
        r'[\d,]+\.?\d*\s*[元万亿美元]',
        r'USD\s*[\d,]+\.?\d*',
        r'RMB\s*[\d,]+\.?\d*',
    ]
    for pattern in amount_patterns:
        amounts = re.findall(pattern, text)
        results['amounts'].extend(amounts)

    # Extract Chinese names (2-4 character patterns after common prefixes)
    name_patterns = [
        r'(?:签[字名]|负责人|经办人|甲方|乙方|联系人|姓名|申请人|审批人|法[人定]代表)[：:]\s*([\u4e00-\u9fff]{2,4})',
    ]
    for pattern in name_patterns:
        names = re.findall(pattern, text)
        results['names'].extend(names)

    # Extract emails
    emails = re.findall(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}', text)
    results['emails'].extend(emails)

    # Extract phone numbers
    phones = re.findall(r'(?:1[3-9]\d{9}|\d{3,4}[-\s]?\d{7,8}|\+86\s*1[3-9]\d{9})', text)
    results['phones'].extend(phones)

    # Extract URLs
    urls = re.findall(r'https?://[^\s<>"{}|\\^`\[\]]+', text)
    results['urls'].extend(urls)

    # Extract IDs/numbers
    id_patterns = [
        r'(?:编号|合同号|订单号|发票号|ID|No\.?)[：:]\s*([A-Za-z0-9-]+)',
    ]
    for pattern in id_patterns:
        ids = re.findall(pattern, text)
        results['ids'].extend(ids)

    # Format output
    output = []
    output.append('# 提取结果\n')

    labels = {
        'titles': '📑 标题',
        'dates': '📅 日期',
        'amounts': '💰 金额',
        'names': '👤 人名',
        'emails': '📧 邮箱',
        'phones': '📱 电话',
        'urls': '🔗 链接',
        'ids': '🔢 编号'
    }

    found_any = False
    for key, label in labels.items():
        items = list(set(results[key]))
        if items:
            found_any = True
            output.append('## %s\n' % label)
            for item in items:
                output.append('- %s' % item.strip())
            output.append('')

    if not found_any:
        output.append('未检测到明确的关键信息。请确认文本内容是否包含日期、金额、人名等。')

    return '\n'.join(output)

input_text = os.environ.get('PDF_INPUT', '')
if input_text:
    print(extract_info(input_text))
else:
    print("请通过 PDF_INPUT 环境变量提供文本内容")
PYEOF
}

cmd_format() {
    local input="${1:-}"
    if [ -z "$input" ]; then
        echo "错误: 请提供Markdown内容"
        echo "用法: bash pdf.sh format \"<Markdown内容>\""
        return 1
    fi

    python3 << 'PYEOF'
import re
import os

def format_markdown(text):
    lines = text.split('\n')
    result = []
    in_code_block = False

    for line in lines:
        # Track code blocks
        if line.strip().startswith('```'):
            in_code_block = not in_code_block
            result.append(line)
            continue

        if in_code_block:
            result.append(line)
            continue

        # Fix heading spacing: ensure space after #
        heading_match = re.match(r'^(#{1,6})([^ #\n])', line)
        if heading_match:
            line = '%s %s' % (heading_match.group(1), line[len(heading_match.group(1)):])

        # Fix heading levels (no jump from # to ###)
        # Just normalize trailing hashes
        line = re.sub(r'^(#{1,6}\s+.*?)\s*#+\s*$', r'\1', line)

        # Fix list formatting: normalize bullets
        line = re.sub(r'^(\s*)[*+]\s', r'\1- ', line)

        # Fix list indentation (use 2 spaces)
        list_match = re.match(r'^(\s+)([-*+]|\d+\.)\s', line)
        if list_match:
            indent = list_match.group(1)
            # Normalize to multiples of 2
            normalized = '  ' * (len(indent) // 2 or 1)
            line = normalized + line.lstrip()

        # Fix emphasis: ensure no space inside bold/italic markers
        line = re.sub(r'\*\*\s+', '**', line)
        line = re.sub(r'\s+\*\*', '**', line)

        # Fix trailing whitespace
        line = line.rstrip()

        result.append(line)

    output = '\n'.join(result)

    # Ensure blank line before headings
    output = re.sub(r'([^\n])\n(#{1,6}\s)', r'\1\n\n\2', output)

    # Ensure blank line after headings
    output = re.sub(r'(#{1,6}\s+[^\n]+)\n([^\n#])', r'\1\n\n\2', output)

    # Remove triple+ blank lines
    output = re.sub(r'\n{3,}', '\n\n', output)

    return output.strip()

input_text = os.environ.get('PDF_INPUT', '')
if input_text:
    print(format_markdown(input_text))
else:
    print("请通过 PDF_INPUT 环境变量提供Markdown内容")
PYEOF
}

cmd_summary() {
    local input="${1:-}"
    if [ -z "$input" ]; then
        echo "错误: 请提供文本内容"
        echo "用法: bash pdf.sh summary \"<PDF文本内容>\""
        return 1
    fi

    python3 << 'PYEOF'
import re
import os

def summarize(text):
    # Split into sections
    sections = re.split(r'\n(?=#{1,3}\s|第[一二三四五六七八九十\d]+[章节]|\d+\.\s)', text)

    output = []
    output.append('# 文档摘要 / Document Summary\n')

    total_chars = len(text)
    total_lines = len(text.split('\n'))
    output.append('**文档统计:** %d 字符, %d 行\n' % (total_chars, total_lines))

    if len(sections) <= 1:
        # No clear sections, provide overall summary info
        sentences = re.split(r'[。！？.!?]', text)
        sentences = [s.strip() for s in sentences if len(s.strip()) > 10]

        output.append('## 主要内容 / Main Content\n')
        if sentences:
            # Show first few sentences as key points
            for i, s in enumerate(sentences[:5]):
                output.append('%d. %s' % (i + 1, s))
        output.append('')
        output.append('> 提示: 文档没有明确的章节划分，以上为前几个要点。')
        output.append('> Tip: No clear sections detected. Above are the first key points.')
    else:
        for i, section in enumerate(sections):
            if not section.strip():
                continue
            lines = section.strip().split('\n')
            title = lines[0].strip().lstrip('#').strip()
            if not title:
                title = '第 %d 部分' % (i + 1)

            # Get first meaningful sentences
            content = ' '.join(lines[1:])
            sentences = re.split(r'[。！？.!?]', content)
            sentences = [s.strip() for s in sentences if len(s.strip()) > 5]

            output.append('## %s\n' % title)
            if sentences:
                summary_text = '。'.join(sentences[:2]) + '。'
                output.append(summary_text)
            else:
                output.append('(内容较短，无需摘要)')
            output.append('')

    return '\n'.join(output)

input_text = os.environ.get('PDF_INPUT', '')
if input_text:
    print(summarize(input_text))
else:
    print("请通过 PDF_INPUT 环境变量提供文本内容")
PYEOF
}

cmd_compare() {
    local text1="${1:-}"
    local text2="${2:-}"
    if [ -z "$text1" ] || [ -z "$text2" ]; then
        echo "错误: 请提供两份文本"
        echo "用法: bash pdf.sh compare \"<文本1>\" \"<文本2>\""
        return 1
    fi

    python3 << 'PYEOF'
import os
import difflib

def compare_docs(text1, text2):
    lines1 = text1.strip().split('\n')
    lines2 = text2.strip().split('\n')

    output = []
    output.append('# 文档对比结果 / Document Comparison\n')

    # Statistics
    output.append('| 指标 | 文档1 | 文档2 |')
    output.append('|------|-------|-------|')
    output.append('| 行数 | %d | %d |' % (len(lines1), len(lines2)))
    output.append('| 字符数 | %d | %d |' % (len(text1), len(text2)))
    output.append('')

    # Compute diff
    differ = difflib.unified_diff(lines1, lines2, lineterm='',
                                   fromfile='文档1', tofile='文档2', n=2)
    diff_lines = list(differ)

    if not diff_lines:
        output.append('✅ **两份文档完全相同！**')
    else:
        added = sum(1 for l in diff_lines if l.startswith('+') and not l.startswith('+++'))
        removed = sum(1 for l in diff_lines if l.startswith('-') and not l.startswith('---'))

        output.append('## 差异统计\n')
        output.append('- 🟢 新增行: %d' % added)
        output.append('- 🔴 删除行: %d' % removed)
        output.append('')

        output.append('## 详细差异\n')
        output.append('```diff')
        for line in diff_lines:
            output.append(line)
        output.append('```')

    # Similarity ratio
    ratio = difflib.SequenceMatcher(None, text1, text2).ratio()
    output.append('')
    output.append('**相似度:** %.1f%%' % (ratio * 100))

    return '\n'.join(output)

text1 = os.environ.get('PDF_INPUT', '')
text2 = os.environ.get('PDF_INPUT2', '')
if text1 and text2:
    print(compare_docs(text1, text2))
else:
    print("请通过 PDF_INPUT 和 PDF_INPUT2 环境变量提供两份文本")
PYEOF
}

# Main dispatcher
case "${1:-help}" in
    convert)
        shift
        export PDF_INPUT="${*}"
        cmd_convert "$@"
        ;;
    table)
        shift
        export PDF_INPUT="${*}"
        cmd_table "$@"
        ;;
    extract)
        shift
        export PDF_INPUT="${*}"
        cmd_extract "$@"
        ;;
    format)
        shift
        export PDF_INPUT="${*}"
        cmd_format "$@"
        ;;
    summary)
        shift
        export PDF_INPUT="${*}"
        cmd_summary "$@"
        ;;
    compare)
        shift
        if [ "$#" -ge 2 ]; then
            export PDF_INPUT="$1"
            export PDF_INPUT2="$2"
        else
            export PDF_INPUT="${1:-}"
            export PDF_INPUT2=""
        fi
        cmd_compare "$@"
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "未知命令: $1"
        echo "运行 'bash pdf.sh help' 查看帮助"
        exit 1
        ;;
esac

echo ""
echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
