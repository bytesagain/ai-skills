#!/usr/bin/env bash
# translator-doc — 文档翻译助手 (专注文件翻译)
# 与 translator-pro 不同：专注于文件/文档翻译而非单句翻译
# Usage: bash translate.sh <command> [file_or_text]
# Powered by BytesAgain

set -euo pipefail

CMD="${1:-help}"
shift 2>/dev/null || true

case "$CMD" in
  file)
    # Translate a file's content
    FILE="${1:-}"
    TARGET_LANG="${2:-}"

    if [[ -z "$FILE" ]]; then
      echo "用法: bash translate.sh file <文件路径> [目标语言]"
      echo "示例: bash translate.sh file README.md zh"
      echo "      bash translate.sh file doc.txt en"
      exit 1
    fi

    if [[ ! -f "$FILE" ]]; then
      echo "❌ 文件不存在: $FILE"
      exit 1
    fi

    export DOC_FILE="$FILE"
    export DOC_TARGET="${TARGET_LANG:-auto}"

    python3 << 'PYEOF'
import os, sys, re

file_path = os.environ.get("DOC_FILE", "")
target = os.environ.get("DOC_TARGET", "auto")

try:
    with open(file_path, "r", encoding="utf-8") as f:
        content = f.read()
except Exception as e:
    print("❌ 无法读取文件: {}".format(e))
    sys.exit(1)

# Stats
lines = content.split("\n")
words = len(content.split())
chars = len(content)

def has_chinese(s):
    return bool(re.search(r'[\u4e00-\u9fff]', s))

is_zh = has_chinese(content)
src_lang = "zh" if is_zh else "en"
if target == "auto":
    target = "en" if is_zh else "zh"

lang_names = {"zh": "中文", "en": "英文", "ja": "日文", "ko": "韩文"}

print("=" * 60)
print("  📄 文档翻译分析")
print("=" * 60)
print("")
print("  文件: {}".format(file_path))
print("  大小: {} 行 / {} 词 / {} 字符".format(len(lines), words, chars))
print("  源语言: {} ({})".format(lang_names.get(src_lang, src_lang), src_lang))
print("  目标语言: {} ({})".format(lang_names.get(target, target), target))
print("")

# Detect file type
ext = os.path.splitext(file_path)[1].lower()
file_types = {
    ".md": "Markdown", ".txt": "纯文本", ".html": "HTML",
    ".json": "JSON", ".yaml": "YAML", ".yml": "YAML",
    ".py": "Python源码", ".js": "JavaScript源码",
    ".csv": "CSV数据", ".xml": "XML",
}
ftype = file_types.get(ext, "未知")
print("  文件类型: {} ({})".format(ftype, ext or "无扩展名"))
print("")

# Preview first 10 lines
print("  --- 预览 (前10行) ---")
for i, line in enumerate(lines[:10]):
    preview = line[:70] + "..." if len(line) > 70 else line
    print("  {:>3} │ {}".format(i+1, preview))
if len(lines) > 10:
    print("  ... (还有 {} 行)".format(len(lines) - 10))
print("")

# Estimate translation effort
if chars < 500:
    effort = "⭐ 简单 (< 500字符)"
elif chars < 5000:
    effort = "⭐⭐ 中等 (500-5000字符)"
elif chars < 50000:
    effort = "⭐⭐⭐ 较长 (5K-50K字符)"
else:
    effort = "⭐⭐⭐⭐ 大型文档 (> 50K字符)"

print("  翻译工作量: {}".format(effort))
print("")

# Output file suggestion
base = os.path.splitext(file_path)[0]
out_file = "{}.{}{}".format(base, target, ext)
print("  建议输出文件: {}".format(out_file))
print("")

# Markdown-specific analysis
if ext == ".md":
    headers = [l for l in lines if l.startswith("#")]
    links = re.findall(r'\[([^\]]+)\]\(', content)
    code_blocks = len(re.findall(r'```', content)) // 2
    print("  Markdown 结构:")
    print("    标题数: {}".format(len(headers)))
    print("    链接数: {}".format(len(links)))
    print("    代码块: {}".format(code_blocks))
    print("    💡 代码块和链接URL通常不需要翻译")
    print("")

print("  💡 请将文件内容发给AI进行完整翻译。")
print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  wordcount)
    # Word/char count for a file
    FILE="${1:-}"
    if [[ -z "$FILE" || ! -f "$FILE" ]]; then
      echo "用法: bash translate.sh wordcount <文件路径>"
      exit 1
    fi

    export DOC_FILE="$FILE"
    python3 << 'PYEOF'
import os, re

file_path = os.environ.get("DOC_FILE", "")
with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()

lines = content.split("\n")
# Count Chinese characters
zh_chars = len(re.findall(r'[\u4e00-\u9fff]', content))
# Count English words
en_words = len(re.findall(r'[a-zA-Z]+', content))
total_chars = len(content)
non_space = len(content.replace(" ", "").replace("\n", "").replace("\t", ""))

print("=" * 50)
print("  📊 文档字数统计")
print("=" * 50)
print("")
print("  文件: {}".format(file_path))
print("  总行数:     {}".format(len(lines)))
print("  总字符数:   {}".format(total_chars))
print("  非空字符:   {}".format(non_space))
print("  中文字数:   {}".format(zh_chars))
print("  英文单词:   {}".format(en_words))
print("")

# Estimate translation cost (rough)
if zh_chars > 0:
    # Chinese: ~1000 chars per page
    pages = zh_chars / 1000
    print("  约 {:.1f} 页 (按千字/页)".format(pages))
elif en_words > 0:
    # English: ~250 words per page
    pages = en_words / 250
    print("  约 {:.1f} 页 (按250词/页)".format(pages))

print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  diff)
    # Compare original and translated files
    FILE1="${1:-}"
    FILE2="${2:-}"

    if [[ -z "$FILE1" || -z "$FILE2" ]]; then
      echo "用法: bash translate.sh diff <原文文件> <译文文件>"
      echo "对比两个文件的行数、字数差异"
      exit 1
    fi

    if [[ ! -f "$FILE1" ]]; then
      echo "❌ 文件不存在: $FILE1"
      exit 1
    fi
    if [[ ! -f "$FILE2" ]]; then
      echo "❌ 文件不存在: $FILE2"
      exit 1
    fi

    export DOC_FILE1="$FILE1"
    export DOC_FILE2="$FILE2"

    python3 << 'PYEOF'
import os, re

f1 = os.environ.get("DOC_FILE1", "")
f2 = os.environ.get("DOC_FILE2", "")

with open(f1, "r", encoding="utf-8") as f:
    c1 = f.read()
with open(f2, "r", encoding="utf-8") as f:
    c2 = f.read()

l1 = len(c1.split("\n"))
l2 = len(c2.split("\n"))
w1 = len(c1.split())
w2 = len(c2.split())
ch1 = len(c1)
ch2 = len(c2)

print("=" * 60)
print("  📝 翻译对比")
print("=" * 60)
print("")
print("  {:>20}  {:>10}  {:>10}".format("", "原文", "译文"))
print("  " + "-" * 44)
print("  {:>20}  {:>10}  {:>10}".format("文件", os.path.basename(f1), os.path.basename(f2)))
print("  {:>20}  {:>10}  {:>10}".format("行数", str(l1), str(l2)))
print("  {:>20}  {:>10}  {:>10}".format("单词/字数", str(w1), str(w2)))
print("  {:>20}  {:>10}  {:>10}".format("字符数", str(ch1), str(ch2)))
print("")

ratio = ch2 / ch1 if ch1 > 0 else 0
print("  字符比率: {:.2f}x (译文/原文)".format(ratio))
if ratio > 1.5:
    print("  💡 译文显著长于原文 — 中→英翻译通常如此")
elif ratio < 0.7:
    print("  💡 译文显著短于原文 — 英→中翻译通常如此")
else:
    print("  💡 长度相近")

print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    ;;

  help|--help|-h|"")
    cat << 'HELP'
╔══════════════════════════════════════════════╗
║    📄 Doc Translator — 文档翻译助手          ║
╠══════════════════════════════════════════════╣
║                                              ║
║  Commands:                                   ║
║    file       分析文件并准备翻译              ║
║    wordcount  文件字数/页数统计               ║
║    diff       对比原文和译文差异              ║
║    help       显示此帮助菜单                  ║
║                                              ║
║  Usage:                                      ║
║    bash translate.sh file <path> [lang]       ║
║    bash translate.sh wordcount <path>         ║
║    bash translate.sh diff <orig> <trans>      ║
║                                              ║
║  与 translator-pro 的区别:                    ║
║    translator-pro  → 短句/短语翻译            ║
║    translator-doc  → 文件分析/文档翻译工作流   ║
║                                              ║
╚══════════════════════════════════════════════╝
  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
HELP
    ;;

  *)
    echo "❌ Unknown command: $CMD"
    echo "Run 'bash translate.sh help' for usage."
    exit 1
    ;;
esac
