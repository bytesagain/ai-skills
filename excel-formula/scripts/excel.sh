#!/usr/bin/env bash
# Excel Formula Helper — excel-formula skill
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com

CMD="$1"
shift 2>/dev/null
INPUT="$*"

case "$CMD" in
  formula)
    cat << 'PROMPT'
You are an Excel formula expert. The user describes what they want in Chinese or English.

Generate the Excel formula with:
1. The formula itself (highlighted)
2. Step-by-step explanation of each function used
3. A practical example with sample data
4. Common pitfalls and notes
5. If applicable, provide both Excel and Google Sheets versions

Format output clearly with sections. Use Chinese for explanations.

User request:
PROMPT
    echo "$INPUT"
    ;;

  explain)
    cat << 'PROMPT'
You are an Excel formula expert. Explain this formula in detail:

1. Overall purpose (one sentence)
2. Break down each function/component
3. Data flow: how data moves through nested functions
4. Example: show with sample data what the result would be
5. Common modifications users might want

Use Chinese for explanations. Format clearly.

Formula to explain:
PROMPT
    echo "$INPUT"
    ;;

  error)
    cat << 'PROMPT'
You are an Excel troubleshooting expert. Diagnose this Excel error:

1. Error type and meaning
2. Top 5 most common causes of this error
3. Step-by-step debugging process
4. Fix for each cause (with formula examples)
5. Prevention tips

Common errors reference:
- #REF! — 引用无效
- #VALUE! — 值类型错误
- #N/A — 找不到匹配
- #NAME? — 函数名错误
- #DIV/0! — 除以零
- #NULL! — 交集为空
- ##### — 列宽不够

Use Chinese. Be specific and practical.

Error info:
PROMPT
    echo "$INPUT"
    ;;

  convert)
    cat << 'PROMPT'
You are a spreadsheet compatibility expert. Convert this formula between platforms:

Provide:
1. Original formula analysis
2. Excel version
3. Google Sheets version
4. WPS version (if different)
5. Key differences between platforms
6. Compatibility notes and warnings

Use Chinese for explanations.

Formula/request:
PROMPT
    echo "$INPUT"
    ;;

  template)
    cat << 'PROMPT'
You are an Excel template designer. Generate a ready-to-use CSV template for the requested scenario.

Output a complete CSV file content that the user can save directly. Include:
1. Headers with Chinese labels
2. Sample data rows (5-10 rows)
3. A "公式行" showing formulas to add after import
4. Instructions as comments

Common templates:
- 考勤表 (attendance)
- 工资条 (payroll)
- 库存表 (inventory)
- 销售报表 (sales report)
- 预算表 (budget)
- 项目进度 (project tracker)

Output the CSV content between ``` markers. Then explain how to use it.
Use Chinese.

Requested template:
PROMPT
    echo "$INPUT"
    ;;

  shortcut)
    cat << 'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ⌨️  Excel 快捷键速查表
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 基础操作
  Ctrl+C/V/X      复制/粘贴/剪切
  Ctrl+Z/Y        撤销/重做
  Ctrl+S          保存
  Ctrl+N          新建工作簿
  Ctrl+F/H        查找/替换
  Ctrl+A          全选

📊 数据编辑
  F2              编辑单元格
  Ctrl+Enter      填充选区
  Ctrl+D          向下填充
  Ctrl+R          向右填充
  Ctrl+;          插入当前日期
  Ctrl+Shift+;    插入当前时间
  Alt+=           自动求和
  Ctrl+`          显示/隐藏公式

🔀 导航
  Ctrl+Home       回到A1
  Ctrl+End        到最后单元格
  Ctrl+方向键      跳到数据边界
  Ctrl+PgUp/PgDn  切换工作表
  Ctrl+G/F5       定位

📐 格式化
  Ctrl+1          设置单元格格式
  Ctrl+B/I/U      加粗/斜体/下划线
  Ctrl+Shift+!    数字格式(千分位)
  Ctrl+Shift+$    货币格式
  Ctrl+Shift+%    百分比格式
  Alt+Enter       单元格内换行

📋 行列操作
  Ctrl+Shift++    插入行/列
  Ctrl+-          删除行/列
  Ctrl+9/0        隐藏行/列
  Ctrl+Shift+9/0  显示行/列

🔍 高级
  Ctrl+Shift+L    自动筛选
  Alt+D+S         排序
  F4              绝对引用切换($)
  Ctrl+[          追踪引用
  F9              计算所有工作表

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
    ;;

  pivot)
    cat << 'PROMPT'
You are an Excel PivotTable expert. Based on the user's data description, provide:

1. Recommended PivotTable layout:
   - 行 (Rows): which fields
   - 列 (Columns): which fields
   - 值 (Values): which calculations (SUM/COUNT/AVERAGE)
   - 筛选 (Filters): which fields

2. Step-by-step creation guide (with screenshots description)
3. Recommended calculated fields
4. Suggested PivotChart type
5. Common analysis angles for this data
6. Tips for refreshing and maintaining

Use Chinese. Be specific to the user's data.

Data description:
PROMPT
    echo "$INPUT"
    ;;

  *)
    cat << 'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📊 Excel Formula Helper — 使用指南
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  formula [描述]     根据描述生成Excel公式
  explain [公式]     解释公式含义
  error [错误信息]    诊断Excel错误+修复方案
  convert [公式]     跨平台转换(Excel/Sheets/WPS)
  template [场景]    生成CSV场景模板
  shortcut          快捷键速查表
  pivot [数据描述]    数据透视表配置建议

  示例:
    formula 查找员工姓名对应的工资
    explain =VLOOKUP(A2,Sheet2!A:C,3,FALSE)
    error #N/A
    template 考勤表
    pivot 销售数据按月份和区域汇总

  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
EOF
    ;;
esac
