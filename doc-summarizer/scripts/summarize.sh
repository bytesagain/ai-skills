#!/usr/bin/env bash
# doc-summarizer — 文档摘要与阅读助手
# Usage: summarize.sh <command> [args...]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PYTHON_SCRIPT="$SCRIPT_DIR/_summarize_core.py"

show_help() {
    cat <<'EOF'
doc-summarizer — 文档摘要与智能总结助手

Usage: summarize.sh <command> [args...]

Commands:
  file <filepath>            读取文件生成摘要（支持 .txt .md .html）
  text "长文本"              对输入文本生成摘要
  url <url>                  抓取网页并生成摘要（用 curl）
  bullets <filepath>         提取要点列表
  keywords <filepath>        提取关键词
  compare <file1> <file2>    对比两个文档的异同
  wordcount <filepath>       字数统计 + 阅读时间估算
  translate "文本" [--to en|cn]  文档翻译摘要（默认中译英/英译中）
  meeting "会议记录"          会议纪要提取（议题/决议/待办）
  email "邮件内容"            邮件要点提取 + 建议回复
  report "长文本"            生成结构化报告
  mindmap "文本"             生成思维导图（ASCII 树形结构）
  fetch <url>                 抓取URL网页→生成摘要文件（summary_域名_日期.md）
  read <filepath>             读取本地文件→生成摘要文件（summary_文件名.md）
  batch <目录路径>            批量摘要 — 遍历目录下所有.txt/.md文件，
                             为每个文件生成摘要，输出汇总报告。
                             痛点："文档太多，一个个看来不及"
  doc-compare <文件1> <文件2>  增强版文档对比 — 字数变化、新增/删除内容、
                             关键词变化分析、相似度评估。
                             痛点："两个版本有什么区别"
  help                       显示本帮助

Examples:
  summarize.sh file ~/notes/meeting.md
  summarize.sh url https://example.com/article
  summarize.sh bullets report.txt
  summarize.sh compare doc1.md doc2.md
  summarize.sh wordcount essay.txt
  summarize.sh translate "Hello world" --to cn
  summarize.sh meeting "今天讨论了Q2计划..."
  summarize.sh email "Hi team, please review..."
  summarize.sh report "本季度销售数据显示..."
  summarize.sh mindmap "人工智能包括机器学习..."
EOF
}

# ── Helpers ──────────────────────────────────────────────

read_file_to_tmp() {
    # Read file content (with HTML stripping if needed) into a temp file
    local filepath="$1"
    local tmpfile="$2"
    if [ ! -f "$filepath" ]; then
        echo "ERROR: File not found: $filepath" >&2
        exit 1
    fi
    local ext="${filepath##*.}"
    ext="$(echo "$ext" | tr '[:upper:]' '[:lower:]')"
    case "$ext" in
        html|htm)
            python3 -c "
import sys, re, html
with open(sys.argv[1], 'r', encoding='utf-8', errors='replace') as f:
    raw = f.read()
raw = re.sub(r'<(script|style)[^>]*>.*?</\\1>', '', raw, flags=re.DOTALL|re.IGNORECASE)
text = re.sub(r'<[^>]+>', ' ', raw)
text = html.unescape(text)
text = re.sub(r'[ \\t]+', ' ', text)
text = re.sub(r'\\n{3,}', '\\n\\n', text)
with open(sys.argv[2], 'w', encoding='utf-8') as out:
    out.write(text.strip())
" "$filepath" "$tmpfile"
            ;;
        *)
            cp "$filepath" "$tmpfile"
            ;;
    esac
}

fetch_url_to_tmp() {
    local url="$1"
    local tmpfile="$2"
    local raw_tmp
    raw_tmp="$(mktemp)"
    curl -sL --max-time 30 -A 'Mozilla/5.0 (compatible; doc-summarizer/1.0)' "$url" > "$raw_tmp" || {
        rm -f "$raw_tmp"
        echo "ERROR: Failed to fetch URL: $url" >&2
        exit 1
    }
    python3 -c "
import sys, re, html
with open(sys.argv[1], 'r', encoding='utf-8', errors='replace') as f:
    raw = f.read()
raw = re.sub(r'<(script|style)[^>]*>.*?</\\1>', '', raw, flags=re.DOTALL|re.IGNORECASE)
text = re.sub(r'<[^>]+>', ' ', raw)
text = html.unescape(text)
text = re.sub(r'[ \\t]+', ' ', text)
text = re.sub(r'\\n{3,}', '\\n\\n', text)
with open(sys.argv[2], 'w', encoding='utf-8') as out:
    out.write(text.strip())
" "$raw_tmp" "$tmpfile"
    rm -f "$raw_tmp"
}

# ── Commands ─────────────────────────────────────────────

cmd_file() {
    local filepath="${1:-}"
    if [ -z "$filepath" ]; then
        echo "Usage: summarize.sh file <filepath>" >&2
        exit 1
    fi
    local tmpfile
    tmpfile="$(mktemp)"
    read_file_to_tmp "$filepath" "$tmpfile"
    python3 "$PYTHON_SCRIPT" summarize "$tmpfile"
    rm -f "$tmpfile"
}

cmd_text() {
    local text="${1:-}"
    if [ -z "$text" ]; then
        echo "Usage: summarize.sh text \"your text here\"" >&2
        exit 1
    fi
    local tmpfile
    tmpfile="$(mktemp)"
    printf '%s' "$text" > "$tmpfile"
    python3 "$PYTHON_SCRIPT" summarize "$tmpfile"
    rm -f "$tmpfile"
}

cmd_url() {
    local url="${1:-}"
    if [ -z "$url" ]; then
        echo "Usage: summarize.sh url <url>" >&2
        exit 1
    fi
    local tmpfile
    tmpfile="$(mktemp)"
    fetch_url_to_tmp "$url" "$tmpfile"
    python3 "$PYTHON_SCRIPT" summarize "$tmpfile"
    rm -f "$tmpfile"
}

cmd_bullets() {
    local filepath="${1:-}"
    if [ -z "$filepath" ]; then
        echo "Usage: summarize.sh bullets <filepath>" >&2
        exit 1
    fi
    local tmpfile
    tmpfile="$(mktemp)"
    read_file_to_tmp "$filepath" "$tmpfile"
    python3 "$PYTHON_SCRIPT" bullets "$tmpfile"
    rm -f "$tmpfile"
}

cmd_keywords() {
    local filepath="${1:-}"
    if [ -z "$filepath" ]; then
        echo "Usage: summarize.sh keywords <filepath>" >&2
        exit 1
    fi
    local tmpfile
    tmpfile="$(mktemp)"
    read_file_to_tmp "$filepath" "$tmpfile"
    python3 "$PYTHON_SCRIPT" keywords "$tmpfile"
    rm -f "$tmpfile"
}

cmd_compare() {
    local file1="${1:-}"
    local file2="${2:-}"
    if [ -z "$file1" ] || [ -z "$file2" ]; then
        echo "Usage: summarize.sh compare <file1> <file2>" >&2
        exit 1
    fi
    if [ ! -f "$file1" ]; then
        echo "ERROR: File not found: $file1" >&2
        exit 1
    fi
    if [ ! -f "$file2" ]; then
        echo "ERROR: File not found: $file2" >&2
        exit 1
    fi
    local tmp1 tmp2
    tmp1="$(mktemp)"
    tmp2="$(mktemp)"
    read_file_to_tmp "$file1" "$tmp1"
    read_file_to_tmp "$file2" "$tmp2"
    python3 "$PYTHON_SCRIPT" compare "$tmp1" "$tmp2"
    rm -f "$tmp1" "$tmp2"
}

cmd_wordcount() {
    local filepath="${1:-}"
    if [ -z "$filepath" ]; then
        echo "Usage: summarize.sh wordcount <filepath>" >&2
        exit 1
    fi
    local tmpfile
    tmpfile="$(mktemp)"
    read_file_to_tmp "$filepath" "$tmpfile"
    python3 "$PYTHON_SCRIPT" wordcount "$tmpfile"
    rm -f "$tmpfile"
}

# ── New Commands: translate, meeting, email, report, mindmap ──

cmd_translate() {
    local text="${1:-}"
    if [ -z "$text" ]; then
        echo "Usage: summarize.sh translate \"文本\" [--to en|cn]" >&2
        exit 1
    fi
    local target_lang="auto"
    shift
    while [ $# -gt 0 ]; do
        case "$1" in
            --to) target_lang="${2:-auto}"; shift 2 ;;
            *) shift ;;
        esac
    done
    local tmpfile
    tmpfile="$(mktemp)"
    printf '%s' "$text" > "$tmpfile"
    python3 "$PYTHON_SCRIPT" translate "$tmpfile" "$target_lang"
    rm -f "$tmpfile"
}

cmd_meeting() {
    local text="${1:-}"
    if [ -z "$text" ]; then
        echo "Usage: summarize.sh meeting \"会议记录文本\"" >&2
        exit 1
    fi
    local tmpfile
    tmpfile="$(mktemp)"
    printf '%s' "$text" > "$tmpfile"
    python3 "$PYTHON_SCRIPT" meeting "$tmpfile"
    rm -f "$tmpfile"
}

cmd_email() {
    local text="${1:-}"
    if [ -z "$text" ]; then
        echo "Usage: summarize.sh email \"邮件内容\"" >&2
        exit 1
    fi
    local tmpfile
    tmpfile="$(mktemp)"
    printf '%s' "$text" > "$tmpfile"
    python3 "$PYTHON_SCRIPT" email "$tmpfile"
    rm -f "$tmpfile"
}

cmd_report() {
    local text="${1:-}"
    if [ -z "$text" ]; then
        echo "Usage: summarize.sh report \"长文本\"" >&2
        exit 1
    fi
    local tmpfile
    tmpfile="$(mktemp)"
    printf '%s' "$text" > "$tmpfile"
    python3 "$PYTHON_SCRIPT" report "$tmpfile"
    rm -f "$tmpfile"
}

cmd_mindmap() {
    local text="${1:-}"
    if [ -z "$text" ]; then
        echo "Usage: summarize.sh mindmap \"文本\"" >&2
        exit 1
    fi
    local tmpfile
    tmpfile="$(mktemp)"
    printf '%s' "$text" > "$tmpfile"
    python3 "$PYTHON_SCRIPT" mindmap "$tmpfile"
    rm -f "$tmpfile"
}

# ── fetch: URL抓取 + 摘要文件输出 ────────────────────────

cmd_fetch() {
    local url="${1:-}"
    if [ -z "$url" ]; then
        echo "Usage: summarize.sh fetch <URL>" >&2
        exit 1
    fi
    export FETCH_URL="$url"
    python3 << 'PYEOF'
# -*- coding: utf-8 -*-
from __future__ import print_function
import os, re, sys, datetime

url = os.environ.get('FETCH_URL', '')

try:
    if sys.version_info[0] >= 3:
        from urllib.request import urlopen, Request
        from urllib.error import URLError
    else:
        from urllib2 import urlopen, Request, URLError
except ImportError:
    print("ERROR: urllib not available", file=sys.stderr)
    sys.exit(1)

# Extract domain for filename
domain_match = re.search(r'://([^/]+)', url)
domain = domain_match.group(1).replace('.', '_') if domain_match else 'unknown'
today = datetime.date.today().strftime('%Y%m%d')

print("Fetching: {}".format(url))

try:
    req = Request(url, headers={
        'User-Agent': 'Mozilla/5.0 (compatible; doc-summarizer/1.0)'
    })
    resp = urlopen(req, timeout=30)
    raw = resp.read()
    # Try utf-8, fallback to latin-1
    try:
        html = raw.decode('utf-8')
    except UnicodeDecodeError:
        html = raw.decode('latin-1', errors='replace')
except Exception as e:
    print("ERROR: Failed to fetch URL: {}".format(e), file=sys.stderr)
    sys.exit(1)

# Extract title
title_match = re.search(r'<title[^>]*>(.*?)</title>', html, re.IGNORECASE | re.DOTALL)
page_title = title_match.group(1).strip() if title_match else 'Untitled'
# Clean HTML entities
try:
    if sys.version_info[0] >= 3:
        import html as html_mod
        page_title = html_mod.unescape(page_title)
except Exception:
    pass

# Remove non-content tags
for tag in ['script', 'style', 'nav', 'header', 'footer', 'aside', 'noscript']:
    html = re.sub(r'<{0}[^>]*>.*?</{0}>'.format(tag), '', html, flags=re.DOTALL | re.IGNORECASE)

# Remove all remaining HTML tags
text = re.sub(r'<[^>]+>', ' ', html)
try:
    if sys.version_info[0] >= 3:
        import html as html_mod
        text = html_mod.unescape(text)
except Exception:
    pass

# Clean whitespace
text = re.sub(r'[ \t]+', ' ', text)
text = re.sub(r'\n{3,}', '\n\n', text)
text = text.strip()

if len(text) < 50:
    print("WARNING: Very little content extracted ({}  chars)".format(len(text)))

# Extract keywords (word frequency)
words = re.findall(r'[\u4e00-\u9fff]+|[a-zA-Z]{3,}', text)
word_freq = {}
stop_words = {'the', 'and', 'for', 'that', 'this', 'with', 'from', 'are', 'was',
              'were', 'has', 'have', 'had', 'been', 'will', 'not', 'but', 'its',
              'can', 'all', 'also', 'more', 'than', 'which', 'when', 'what',
              'about', 'into', 'some', 'other', 'out', 'just', 'any', 'each',
              'only', 'over', 'such', 'after', 'between', 'through', 'very'}
for w in words:
    wl = w.lower()
    if wl not in stop_words and len(wl) > 1:
        word_freq[wl] = word_freq.get(wl, 0) + 1

top_keywords = sorted(word_freq.items(), key=lambda x: -x[1])[:15]
keyword_str = ', '.join([k for k, v in top_keywords])

# Generate summary
sentences = re.split(r'[。！？.!?\n]+', text)
sentences = [s.strip() for s in sentences if len(s.strip()) > 15]

if len(sentences) > 5:
    summary_lines = sentences[:5]
else:
    summary_lines = sentences[:3] if sentences else [text[:300]]
summary_text = '\n'.join(['- ' + s[:200] for s in summary_lines])

# Build output
output_lines = []
output_lines.append('# {}'.format(page_title))
output_lines.append('')
output_lines.append('> Source: {}'.format(url))
output_lines.append('> Date: {}'.format(datetime.date.today().strftime('%Y-%m-%d')))
output_lines.append('')
output_lines.append('## Keywords')
output_lines.append('')
output_lines.append(keyword_str)
output_lines.append('')
output_lines.append('## Summary')
output_lines.append('')
output_lines.append(summary_text)
output_lines.append('')
output_lines.append('## Stats')
output_lines.append('')
output_lines.append('- Total characters: {}'.format(len(text)))
output_lines.append('- Sentences: ~{}'.format(len(sentences)))
output_lines.append('- Top words: {}'.format(', '.join(['{}({})'.format(k,v) for k,v in top_keywords[:8]])))
output_lines.append('')

content = '\n'.join(output_lines)

fname = 'summary_{}_{}.md'.format(domain, today)
with open(fname, 'w', encoding='utf-8') as f:
    f.write(content)

print('')
print(content)
print('---')
print('✅ 摘要已保存: {}'.format(fname))
PYEOF
}

# ── read: 本地文件读取 + 摘要文件输出 ────────────────────

cmd_read() {
    local filepath="${1:-}"
    if [ -z "$filepath" ]; then
        echo "Usage: summarize.sh read <filepath>" >&2
        exit 1
    fi
    if [ ! -f "$filepath" ]; then
        echo "ERROR: File not found: $filepath" >&2
        exit 1
    fi
    export READ_FILEPATH="$filepath"
    python3 << 'PYEOF'
# -*- coding: utf-8 -*-
from __future__ import print_function
import os, re, sys, datetime

filepath = os.environ.get('READ_FILEPATH', '')
basename = os.path.basename(filepath)
name_no_ext = os.path.splitext(basename)[0]

try:
    with open(filepath, 'r', encoding='utf-8', errors='replace') as f:
        text = f.read()
except Exception as e:
    print("ERROR: Cannot read file: {}".format(e), file=sys.stderr)
    sys.exit(1)

# Stats
lines = text.split('\n')
line_count = len(lines)
char_count = len(text)
paragraphs = [p.strip() for p in text.split('\n\n') if p.strip()]
para_count = len(paragraphs)

# Word count (Chinese chars + English words)
cn_chars = len(re.findall(r'[\u4e00-\u9fff]', text))
en_words = len(re.findall(r'[a-zA-Z]+', text))
word_count = cn_chars + en_words

# Keywords (word frequency)
words = re.findall(r'[\u4e00-\u9fff]{2,}|[a-zA-Z]{3,}', text)
word_freq = {}
stop_words = {'the', 'and', 'for', 'that', 'this', 'with', 'from', 'are', 'was',
              'were', 'has', 'have', 'had', 'been', 'will', 'not', 'but', 'its',
              'can', 'all', 'also', 'more', 'than', 'which', 'when', 'what',
              'about', 'into', 'some', 'other', 'out', 'just', 'any', 'each'}
for w in words:
    wl = w.lower()
    if wl not in stop_words and len(wl) > 1:
        word_freq[wl] = word_freq.get(wl, 0) + 1

top_keywords = sorted(word_freq.items(), key=lambda x: -x[1])[:15]
keyword_str = ', '.join(['{} ({})'.format(k, v) for k, v in top_keywords])

# Extract key sentences
sentences = re.split(r'[。！？.!?\n]+', text)
sentences = [s.strip() for s in sentences if len(s.strip()) > 10]

# Score sentences by keyword density
keyword_set = set([k for k, v in top_keywords[:10]])
scored = []
for s in sentences:
    score = sum(1 for kw in keyword_set if kw in s.lower())
    scored.append((score, s))
scored.sort(key=lambda x: -x[0])
summary_sentences = [s for _, s in scored[:5]]

summary_text = '\n'.join(['- ' + s[:200] for s in summary_sentences])

# Build output
output_lines = []
output_lines.append('# Summary: {}'.format(basename))
output_lines.append('')
output_lines.append('> Generated: {}'.format(datetime.date.today().strftime('%Y-%m-%d')))
output_lines.append('')
output_lines.append('## File Stats')
output_lines.append('')
output_lines.append('| Metric | Value |')
output_lines.append('|--------|-------|')
output_lines.append('| Characters | {} |'.format(char_count))
output_lines.append('| Lines | {} |'.format(line_count))
output_lines.append('| Paragraphs | {} |'.format(para_count))
output_lines.append('| Words (CN+EN) | {} |'.format(word_count))
output_lines.append('| Est. Read Time | ~{} min |'.format(max(1, word_count // 300)))
output_lines.append('')
output_lines.append('## Keywords')
output_lines.append('')
output_lines.append(keyword_str)
output_lines.append('')
output_lines.append('## Key Points')
output_lines.append('')
output_lines.append(summary_text)
output_lines.append('')

content = '\n'.join(output_lines)

fname = 'summary_{}.md'.format(re.sub(r'[^\w\u4e00-\u9fff-]', '_', name_no_ext).strip('_') or 'file')
with open(fname, 'w', encoding='utf-8') as f:
    f.write(content)

print('')
print(content)
print('---')
print('✅ 摘要已保存: {}'.format(fname))
PYEOF
}

# ── batch: 批量摘要 ──────────────────────────────────

cmd_batch() {
    local dirpath="${1:-}"
    if [ -z "$dirpath" ]; then
        echo "Usage: summarize.sh batch <目录路径>" >&2
        echo "示例: summarize.sh batch ~/documents/" >&2
        exit 1
    fi
    if [ ! -d "$dirpath" ]; then
        echo "ERROR: Directory not found: $dirpath" >&2
        exit 1
    fi
    export BATCH_DIR="$dirpath"
    python3 << 'PYEOF'
# -*- coding: utf-8 -*-
from __future__ import print_function
import os, re, sys, datetime

dirpath = os.environ.get('BATCH_DIR', '')
today = datetime.date.today().strftime('%Y-%m-%d')
today_compact = datetime.date.today().strftime('%Y%m%d')

# Find all .txt and .md files
target_exts = ('.txt', '.md', '.markdown')
files = []
for fname in sorted(os.listdir(dirpath)):
    fpath = os.path.join(dirpath, fname)
    if os.path.isfile(fpath):
        ext = os.path.splitext(fname)[1].lower()
        if ext in target_exts:
            files.append(fpath)

if not files:
    print("❌ 目录中没有找到 .txt / .md 文件: {}".format(dirpath))
    sys.exit(1)

print("")
print("=" * 56)
print("  📚 批量文档摘要 / Batch Summary")
print("=" * 56)
print("")
print("  📂 目录: {}".format(dirpath))
print("  📄 文件数: {}".format(len(files)))
print("  📅 日期: {}".format(today))
print("")

# Stop words
stop_words = {'the', 'and', 'for', 'that', 'this', 'with', 'from', 'are', 'was',
              'were', 'has', 'have', 'had', 'been', 'will', 'not', 'but', 'its',
              'can', 'all', 'also', 'more', 'than', 'which', 'when', 'what',
              'about', 'into', 'some', 'other', 'out', 'just', 'any', 'each',
              'only', 'over', 'such', 'after', 'between', 'through', 'very',
              'that', 'these', 'those', 'there', 'their', 'then', 'them'}

report_lines = []
report_lines.append("# 批量摘要报告 / Batch Summary Report")
report_lines.append("")
report_lines.append("> 目录: {}".format(dirpath))
report_lines.append("> 生成日期: {}".format(today))
report_lines.append("> 文件数: {}".format(len(files)))
report_lines.append("")
report_lines.append("## 文件列表")
report_lines.append("")
report_lines.append("| # | 文件名 | 字数 | 预计阅读 |")
report_lines.append("|---|--------|------|----------|")

file_summaries = []

for idx, fpath in enumerate(files, 1):
    fname = os.path.basename(fpath)
    try:
        with open(fpath, 'r', encoding='utf-8', errors='replace') as f:
            text = f.read()
    except Exception as e:
        print("  ⚠️ 无法读取: {} ({})".format(fname, e))
        continue

    # Word count
    cn_chars = len(re.findall(r'[\u4e00-\u9fff]', text))
    en_words = len(re.findall(r'[a-zA-Z]+', text))
    word_count = cn_chars + en_words
    read_min = max(1, word_count // 300)

    # Keywords
    words = re.findall(r'[\u4e00-\u9fff]{2,}|[a-zA-Z]{3,}', text)
    word_freq = {}
    for w in words:
        wl = w.lower()
        if wl not in stop_words and len(wl) > 1:
            word_freq[wl] = word_freq.get(wl, 0) + 1
    top_kw = sorted(word_freq.items(), key=lambda x: -x[1])[:8]
    kw_str = ", ".join([k for k, v in top_kw])

    # Key sentences
    sentences = re.split(r'[。！？.!?\n]+', text)
    sentences = [s.strip() for s in sentences if len(s.strip()) > 10]
    kw_set = set([k for k, v in top_kw[:5]])
    scored = []
    for s in sentences:
        score = sum(1 for kw in kw_set if kw in s.lower())
        scored.append((score, s))
    scored.sort(key=lambda x: -x[0])
    summary_sents = [s for _, s in scored[:3]]

    report_lines.append("| {i} | {f} | {w} | ~{r}分钟 |".format(
        i=idx, f=fname, w=word_count, r=read_min))

    file_summaries.append({
        "idx": idx,
        "name": fname,
        "words": word_count,
        "keywords": kw_str,
        "summary": summary_sents
    })

    print("  [{i}/{t}] ✅ {f} ({w}字)".format(i=idx, t=len(files), f=fname, w=word_count))

report_lines.append("")

for fs in file_summaries:
    report_lines.append("---")
    report_lines.append("")
    report_lines.append("## {i}. {n}".format(i=fs["idx"], n=fs["name"]))
    report_lines.append("")
    report_lines.append("**字数:** {} | **关键词:** {}".format(fs["words"], fs["keywords"]))
    report_lines.append("")
    report_lines.append("**摘要:**")
    report_lines.append("")
    for s in fs["summary"]:
        report_lines.append("- {}".format(s[:200]))
    report_lines.append("")

content = "\n".join(report_lines)

output_fname = "batch_summary_{}.md".format(today_compact)
with open(output_fname, 'w', encoding='utf-8') as f:
    f.write(content)

print("")
print("=" * 56)
print("  ✅ 批量摘要完成！")
print("  📄 报告文件: {}".format(output_fname))
print("  📊 共处理 {} 个文件".format(len(file_summaries)))
print("=" * 56)
print("")
print(content)
PYEOF
}

# ── doc-compare: 增强版文档对比 ──────────────────────

cmd_doc_compare() {
    local file1="${1:-}" file2="${2:-}"
    if [ -z "$file1" ] || [ -z "$file2" ]; then
        echo "Usage: summarize.sh doc-compare <文件1> <文件2>" >&2
        exit 1
    fi
    if [ ! -f "$file1" ]; then
        echo "ERROR: File not found: $file1" >&2
        exit 1
    fi
    if [ ! -f "$file2" ]; then
        echo "ERROR: File not found: $file2" >&2
        exit 1
    fi
    export DC_FILE1="$file1"
    export DC_FILE2="$file2"
    python3 << 'PYEOF'
# -*- coding: utf-8 -*-
from __future__ import print_function
import os, re, sys, datetime

file1 = os.environ.get('DC_FILE1', '')
file2 = os.environ.get('DC_FILE2', '')
today = datetime.date.today().strftime('%Y-%m-%d')

try:
    with open(file1, 'r', encoding='utf-8', errors='replace') as f:
        text1 = f.read()
    with open(file2, 'r', encoding='utf-8', errors='replace') as f:
        text2 = f.read()
except Exception as e:
    print("ERROR: Cannot read file: {}".format(e), file=sys.stderr)
    sys.exit(1)

name1 = os.path.basename(file1)
name2 = os.path.basename(file2)

# Stats
def get_stats(text):
    cn_chars = len(re.findall(r'[\u4e00-\u9fff]', text))
    en_words = len(re.findall(r'[a-zA-Z]+', text))
    lines = len(text.split('\n'))
    chars = len(text)
    return {"chars": chars, "words": cn_chars + en_words, "lines": lines}

s1 = get_stats(text1)
s2 = get_stats(text2)

# Keywords for each
stop_words = {'the', 'and', 'for', 'that', 'this', 'with', 'from', 'are', 'was',
              'were', 'has', 'have', 'had', 'been', 'will', 'not', 'but', 'its',
              'can', 'all', 'also', 'more', 'than', 'which', 'when', 'what',
              'about', 'into', 'some', 'other', 'out', 'just', 'any', 'each'}

def get_keywords(text, top_n=15):
    words = re.findall(r'[\u4e00-\u9fff]{2,}|[a-zA-Z]{3,}', text)
    freq = {}
    for w in words:
        wl = w.lower()
        if wl not in stop_words and len(wl) > 1:
            freq[wl] = freq.get(wl, 0) + 1
    return sorted(freq.items(), key=lambda x: -x[1])[:top_n]

kw1 = get_keywords(text1)
kw2 = get_keywords(text2)
kw1_set = set([k for k, v in kw1])
kw2_set = set([k for k, v in kw2])

common_kw = kw1_set & kw2_set
only_in_1 = kw1_set - kw2_set
only_in_2 = kw2_set - kw1_set

# Line-level diff
lines1 = set(text1.split('\n'))
lines2 = set(text2.split('\n'))

added_lines = lines2 - lines1
removed_lines = lines1 - lines2

print("")
print("=" * 56)
print("  📊 文档对比报告 / Document Comparison")
print("=" * 56)
print("")
print("  📄 文件1: {}".format(name1))
print("  📄 文件2: {}".format(name2))
print("  📅 日期: {}".format(today))
print("")

print("  " + "-" * 50)
print("  📏 基础数据对比:")
print("  " + "-" * 50)
print("")
print("  {m:<14s} {n1:<20s} {n2:<20s}".format(m="指标", n1=name1[:18], n2=name2[:18]))
print("  {:<14s} {:<20s} {:<20s}".format("-" * 12, "-" * 18, "-" * 18))
print("  {m:<14s} {v1:<20s} {v2:<20s}".format(
    m="字符数", v1=str(s1["chars"]), v2=str(s2["chars"])))
print("  {m:<14s} {v1:<20s} {v2:<20s}".format(
    m="词数", v1=str(s1["words"]), v2=str(s2["words"])))
print("  {m:<14s} {v1:<20s} {v2:<20s}".format(
    m="行数", v1=str(s1["lines"]), v2=str(s2["lines"])))

char_diff = s2["chars"] - s1["chars"]
char_pct = round(char_diff * 100.0 / s1["chars"], 1) if s1["chars"] > 0 else 0
print("")
print("  📈 变化: {d:+d} 字符 ({p:+.1f}%)".format(d=char_diff, p=char_pct))
print("")

print("  " + "-" * 50)
print("  🔑 关键词变化分析:")
print("  " + "-" * 50)
print("")

if common_kw:
    print("  🟢 共同关键词 ({n}个):".format(n=len(common_kw)))
    print("    " + ", ".join(sorted(common_kw)[:10]))
    print("")

if only_in_1:
    print("  🔴 仅在 {n} 中出现 ({c}个):".format(n=name1, c=len(only_in_1)))
    print("    " + ", ".join(sorted(only_in_1)[:10]))
    print("")

if only_in_2:
    print("  🟡 仅在 {n} 中出现 ({c}个):".format(n=name2, c=len(only_in_2)))
    print("    " + ", ".join(sorted(only_in_2)[:10]))
    print("")

print("  " + "-" * 50)
print("  📝 内容变化:")
print("  " + "-" * 50)
print("")

# Show sample of added/removed lines (non-empty, meaningful)
added_meaningful = [l.strip() for l in added_lines if len(l.strip()) > 10]
removed_meaningful = [l.strip() for l in removed_lines if len(l.strip()) > 10]

print("  ➕ 新增内容 ({n} 行):".format(n=len(added_meaningful)))
for line in added_meaningful[:8]:
    print("    + {}".format(line[:80]))
if len(added_meaningful) > 8:
    print("    ... 还有 {} 行".format(len(added_meaningful) - 8))
print("")

print("  ➖ 删除内容 ({n} 行):".format(n=len(removed_meaningful)))
for line in removed_meaningful[:8]:
    print("    - {}".format(line[:80]))
if len(removed_meaningful) > 8:
    print("    ... 还有 {} 行".format(len(removed_meaningful) - 8))
print("")

# Similarity score
all_kw = kw1_set | kw2_set
if all_kw:
    similarity = round(len(common_kw) * 100.0 / len(all_kw), 1)
else:
    similarity = 0

print("  " + "-" * 50)
print("  📊 相似度评估:")
print("  " + "-" * 50)
print("")
bar_len = 20
filled = int(similarity * bar_len / 100)
bar = "█" * filled + "░" * (bar_len - filled)
print("  关键词相似度: [{bar}] {s}%".format(bar=bar, s=similarity))
print("")

if similarity >= 80:
    print("  📋 结论: 两个文档高度相似，可能是小幅修改/润色")
elif similarity >= 50:
    print("  📋 结论: 两个文档有一定相似性，存在较多内容调整")
elif similarity >= 20:
    print("  📋 结论: 两个文档差异较大，可能是重写或不同版本")
else:
    print("  📋 结论: 两个文档几乎完全不同")
print("")
print("=" * 56)
PYEOF
}

# ── Dispatch ─────────────────────────────────────────────

COMMAND="${1:-help}"
shift || true

case "$COMMAND" in
    file)      cmd_file "$@" ;;
    text)      cmd_text "$@" ;;
    url)       cmd_url "$@" ;;
    bullets)   cmd_bullets "$@" ;;
    keywords)  cmd_keywords "$@" ;;
    compare)   cmd_compare "$@" ;;
    wordcount) cmd_wordcount "$@" ;;
    translate) cmd_translate "$@" ;;
    meeting)   cmd_meeting "$@" ;;
    email)     cmd_email "$@" ;;
    report)    cmd_report "$@" ;;
    mindmap)   cmd_mindmap "$@" ;;
    fetch)     cmd_fetch "$@" ;;
    read)      cmd_read "$@" ;;
    batch)     cmd_batch "$@" ;;
    doc-compare) cmd_doc_compare "$@" ;;
    help|-h|--help) show_help ;;
    *)
        echo "Unknown command: $COMMAND" >&2
        echo "Run 'summarize.sh help' for usage." >&2
        exit 1
        ;;
esac
echo ""
echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
