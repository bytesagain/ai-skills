#!/usr/bin/env bash
# CSV Data Analyzer — csv-analyzer skill
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

CMD="$1"
shift 2>/dev/null
INPUT="$*"

case "$CMD" in
  analyze)
    if [ -f "$INPUT" ]; then
      python3 << 'PYEOF'
import csv, os, sys

fp = sys.argv[1] if len(sys.argv) > 1 else os.environ.get("CSV_FILE","")
if not fp or not os.path.isfile(fp):
    print("Usage: analyze <file.csv>")
    sys.exit(1)

with open(fp, "r") as f:
    reader = csv.reader(f)
    headers = next(reader, [])
    rows = list(reader)

print("=" * 56)
print("  CSV Data Analysis Report")
print("=" * 56)
print("")
print("  File: {}".format(os.path.basename(fp)))
print("  Rows: {}".format(len(rows)))
print("  Columns: {}".format(len(headers)))
print("")
print("  {:<20} {:<10} {:<10} {:<10}".format("Column", "Type", "Non-empty", "Unique"))
print("  " + "-" * 50)

for i, h in enumerate(headers):
    vals = [r[i] for r in rows if i < len(r) and r[i].strip()]
    non_empty = len(vals)
    unique = len(set(vals))
    # Detect type
    is_num = True
    for v in vals[:20]:
        try:
            float(v.replace(",",""))
        except:
            is_num = False
            break
    dtype = "number" if is_num and vals else "text"
    print("  {:<20} {:<10} {:<10} {:<10}".format(h[:20], dtype, non_empty, unique))

    if is_num and vals:
        nums = [float(v.replace(",","")) for v in vals]
        print("    min={:.2f}  max={:.2f}  avg={:.2f}  sum={:.2f}".format(
            min(nums), max(nums), sum(nums)/len(nums), sum(nums)))

print("")
print("  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
    else
      cat << 'PROMPT'
You are a data analyst. The user will paste CSV data. Analyze it and provide:

1. 📊 Overview: row count, column count, data types
2. 📈 Statistics: for numeric columns (min, max, mean, median, std)
3. 🔍 Data Quality: missing values, duplicates, outliers
4. 💡 Insights: patterns, trends, anomalies
5. 🎯 Recommendations: what analysis to do next

Format with clear sections. Use Chinese.

CSV data:
PROMPT
      echo "$INPUT"
    fi
    ;;

  chart)
    cat << 'PROMPT'
You are a data visualization expert. Generate an SVG chart from the provided data.

Output a complete, valid SVG file wrapped in ```svg markers. The chart should:
1. Have proper axes with labels (Chinese)
2. Include a title
3. Use professional colors (#58a6ff, #3fb950, #f0883e, #f85149, #a371f7)
4. Be 600x400 pixels
5. Include data labels on each bar/point/slice

Chart types: bar (柱状图), pie (饼图), line (折线图)

After the SVG, explain the data insights in Chinese.

Data and chart type:
PROMPT
    echo "$INPUT"
    ;;

  filter)
    cat << 'PROMPT'
You are a data processing expert. Filter the CSV data based on the user's condition.

Output:
1. The filtered CSV data (ready to save)
2. Summary: X out of Y rows matched
3. If the condition is ambiguous, list possible interpretations

Use Chinese for explanations. Output filtered data between ``` markers.

Data and filter condition:
PROMPT
    echo "$INPUT"
    ;;

  merge)
    cat << 'PROMPT'
You are a data processing expert. Merge two CSV datasets.

Provide:
1. The merged CSV data (ready to save)
2. Merge type used (INNER/LEFT/RIGHT/FULL)
3. Match statistics: matched rows, unmatched rows
4. Data quality notes (duplicates, missing keys)

Output merged data between ``` markers. Use Chinese for explanations.

Merge request:
PROMPT
    echo "$INPUT"
    ;;

  clean)
    cat << 'PROMPT'
You are a data cleaning expert. Clean the CSV data:

Perform these checks and fixes:
1. 去重 — Remove duplicate rows (report how many)
2. 去空 — Remove empty rows
3. 修剪 — Trim whitespace from all cells
4. 日期标准化 — Standardize date formats to YYYY-MM-DD
5. 数字标准化 — Remove currency symbols, fix comma decimals
6. 编码修复 — Fix common encoding issues
7. 一致性 — Standardize categories (e.g., "男"/"male"/"M" → "男")

Output the cleaned CSV between ``` markers.
Show a summary of all changes made. Use Chinese.

CSV data to clean:
PROMPT
    echo "$INPUT"
    ;;

  convert)
    cat << 'PROMPT'
You are a data format conversion expert. Convert the CSV data to the requested format.

Supported formats:
- json — JSON array of objects
- markdown — Markdown table
- html — HTML table with styling
- sql — SQL INSERT statements

Output the converted data between appropriate ``` markers.
Use Chinese for explanations.

CSV data and target format:
PROMPT
    echo "$INPUT"
    ;;

  report)
    cat << 'PROMPT'
You are a senior data analyst. Generate a comprehensive HTML analysis report from the CSV data.

The HTML report must include:
1. 📊 Executive Summary (1 paragraph)
2. 📋 Data Overview table (rows, columns, types, completeness)
3. 📈 Statistical Analysis (for numeric columns)
4. 📉 Inline SVG charts (at least 2: one bar chart, one trend/pie)
5. 🔍 Key Findings (bullet points)
6. 💡 Recommendations (actionable insights)
7. Professional styling (dark theme: bg #0d1117, text #c9d1d9, accent #58a6ff)

Output the complete HTML between ``` markers. The file should be self-contained and openable in a browser.

Footer: Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

Use Chinese throughout.

CSV data:
PROMPT
    echo "$INPUT"
    ;;

  *)
    cat << 'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📊 CSV Data Analyzer — 使用指南
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  analyze [file.csv]          数据统计摘要
  chart [数据] [类型]          生成SVG图表(bar/pie/line)
  filter [数据] [条件]         按条件筛选
  merge [文件1] [文件2] [key]  合并两个CSV
  clean [数据]                数据清洗(去重/修剪/标准化)
  convert [数据] [格式]        格式转换(json/markdown/html/sql)
  report [数据]               生成HTML分析报告

  示例:
    analyze sales.csv
    chart 月份,销售额\n1月,100\n2月,150 bar
    clean 导入的原始数据
    convert 数据 json
    report 年度销售数据

  支持直接粘贴CSV数据或指定文件路径。

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
    ;;
esac
