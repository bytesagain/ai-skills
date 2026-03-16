#!/usr/bin/env bash
# invoice-generator — 发票生成器
# Commands: create, template, calculate, recurring, receipt, export

CMD="$1"; shift 2>/dev/null; INPUT="$*"

case "$CMD" in
  create)
    # 解析输入
    CLIENT=$(echo "$INPUT" | grep -oP '客户:\K[^ ]+' 2>/dev/null || echo "示例客户")
    PROJECT=$(echo "$INPUT" | grep -oP '项目:\K[^ ]+' 2>/dev/null || echo "项目服务")
    AMOUNT=$(echo "$INPUT" | grep -oP '金额:\K[0-9.]+' 2>/dev/null || echo "10000")
    TAX_RATE=$(echo "$INPUT" | grep -oP '税率:\K[0-9.]+' 2>/dev/null || echo "6")
    
    INV_NO="INV-$(date +%Y%m%d)-$(printf '%03d' $((RANDOM % 999 + 1)))"
    INV_DATE=$(date +%Y-%m-%d)
    
    TAX_AMOUNT=$(python3 -c "a={0};r={1};print('{2:.2f}'.format(a*r/100))" "$AMOUNT" "$TAX_RATE" 2>/dev/null || echo "0")
    TOTAL=$(python3 -c "a={0};r={1};print('{2:.2f}'.format(a*(1+r/100)))" "$AMOUNT" "$TAX_RATE" 2>/dev/null || echo "0")
    
    # 修正python格式
    TAX_AMOUNT=$(python3 -c "
a=float('${AMOUNT}')
r=float('${TAX_RATE}')
print('{:.2f}'.format(a*r/100))
" 2>/dev/null || echo "0")
    TOTAL=$(python3 -c "
a=float('${AMOUNT}')
r=float('${TAX_RATE}')
print('{:.2f}'.format(a*(1+r/100)))
" 2>/dev/null || echo "0")

    cat <<HTMLEOF
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<title>发票 ${INV_NO}</title>
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  body { font-family: 'PingFang SC', 'Microsoft YaHei', sans-serif; padding: 40px; background: #f5f5f5; }
  .invoice { max-width: 800px; margin: 0 auto; background: #fff; padding: 50px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
  .header { display: flex; justify-content: space-between; border-bottom: 3px solid #2c3e50; padding-bottom: 20px; margin-bottom: 30px; }
  .header h1 { color: #2c3e50; font-size: 28px; }
  .header .inv-info { text-align: right; color: #666; }
  .parties { display: flex; justify-content: space-between; margin-bottom: 30px; }
  .party { width: 45%; }
  .party h3 { color: #2c3e50; margin-bottom: 10px; border-bottom: 1px solid #eee; padding-bottom: 5px; }
  .party p { color: #555; line-height: 1.8; }
  table { width: 100%; border-collapse: collapse; margin: 20px 0; }
  th { background: #2c3e50; color: #fff; padding: 12px 15px; text-align: left; }
  td { padding: 12px 15px; border-bottom: 1px solid #eee; }
  .amount-col { text-align: right; }
  .totals { margin-top: 20px; text-align: right; }
  .totals table { width: 300px; margin-left: auto; }
  .totals td { border: none; padding: 8px 15px; }
  .totals .grand-total { font-size: 20px; font-weight: bold; color: #2c3e50; border-top: 2px solid #2c3e50; }
  .footer { margin-top: 40px; padding-top: 20px; border-top: 1px solid #eee; color: #999; font-size: 12px; text-align: center; }
  @media print { body { padding: 0; background: #fff; } .invoice { box-shadow: none; } }
</style>
</head>
<body>
<div class="invoice">
  <div class="header">
    <div>
      <h1>发 票</h1>
      <p style="color:#666;margin-top:5px;">INVOICE</p>
    </div>
    <div class="inv-info">
      <p><strong>发票编号:</strong> ${INV_NO}</p>
      <p><strong>开票日期:</strong> ${INV_DATE}</p>
      <p><strong>付款期限:</strong> $(date -d "+30 days" +%Y-%m-%d 2>/dev/null || date +%Y-%m-%d)</p>
    </div>
  </div>
  <div class="parties">
    <div class="party">
      <h3>开票方</h3>
      <p>（请填写您的公司信息）</p>
      <p>地址：</p>
      <p>电话：</p>
      <p>税号：</p>
    </div>
    <div class="party">
      <h3>客户</h3>
      <p><strong>${CLIENT}</strong></p>
      <p>地址：</p>
      <p>电话：</p>
      <p>税号：</p>
    </div>
  </div>
  <table>
    <thead>
      <tr><th>项目描述</th><th>数量</th><th>单价</th><th class="amount-col">金额</th></tr>
    </thead>
    <tbody>
      <tr><td>${PROJECT}</td><td>1</td><td>¥${AMOUNT}</td><td class="amount-col">¥${AMOUNT}</td></tr>
    </tbody>
  </table>
  <div class="totals">
    <table>
      <tr><td>小计:</td><td class="amount-col">¥${AMOUNT}</td></tr>
      <tr><td>税率:</td><td class="amount-col">${TAX_RATE}%</td></tr>
      <tr><td>税额:</td><td class="amount-col">¥${TAX_AMOUNT}</td></tr>
      <tr class="grand-total"><td>合计:</td><td class="amount-col">¥${TOTAL}</td></tr>
    </table>
  </div>
  <div class="footer">
    <p>感谢您的惠顾 | Thank you for your business</p>
  </div>
</div>
</body>
</html>
HTMLEOF
    echo ""
    echo "---"
    echo "✅ HTML发票已生成 | 发票号: ${INV_NO}"
    echo "📋 客户: ${CLIENT} | 项目: ${PROJECT}"
    echo "💰 金额: ¥${AMOUNT} + 税(${TAX_RATE}%) = ¥${TOTAL}"
    echo "💡 将上面的HTML保存为 .html 文件，用浏览器打开即可打印"
    ;;

  template)
    TMPL=$(echo "$INPUT" | tr '[:upper:]' '[:lower:]')
    case "$TMPL" in
      minimal)
        echo "📄 极简模板 (Minimal)"
        echo "========================"
        echo ""
        echo "特点: 简洁清爽，适合自由职业者和小型项目"
        echo ""
        echo "┌─────────────────────────────────┐"
        echo "│  INVOICE                        │"
        echo "│  ─────────────────────          │"
        echo "│  From: [你的名字]                │"
        echo "│  To:   [客户名称]                │"
        echo "│  Date: [日期]                    │"
        echo "│                                 │"
        echo "│  [项目]          ¥[金额]         │"
        echo "│  ─────────────────────          │"
        echo "│  Total:          ¥[合计]         │"
        echo "└─────────────────────────────────┘"
        echo ""
        echo "💡 使用: bash scripts/invoice.sh create \"客户:XX 项目:XX 金额:XX\""
        ;;
      detailed)
        echo "📄 详细模板 (Detailed)"
        echo "========================"
        echo ""
        echo "特点: 完整商业发票，含税务信息、银行账户、付款条款"
        echo ""
        echo "包含字段:"
        echo "  • 开票方完整信息（公司名/地址/税号/银行账户）"
        echo "  • 客户完整信息"
        echo "  • 多行项目明细"
        echo "  • 税率计算（增值税/服务税）"
        echo "  • 付款条款与银行信息"
        echo "  • 备注栏"
        echo ""
        echo "💡 适合: 企业对企业(B2B)正式发票"
        ;;
      *)
        echo "📄 发票模板库"
        echo "========================"
        echo ""
        echo "可用模板:"
        echo ""
        echo "  1. standard  — 标准模板（默认）"
        echo "     适合大多数场景，包含基本开票信息"
        echo ""
        echo "  2. minimal   — 极简模板"
        echo "     适合自由职业者、小型项目"
        echo ""
        echo "  3. detailed  — 详细模板"
        echo "     适合B2B企业正式发票，含完整税务信息"
        echo ""
        echo "💡 查看详情: bash scripts/invoice.sh template [模板名]"
        ;;
    esac
    ;;

  calculate)
    AMOUNT=$(echo "$INPUT" | grep -oP '金额:\K[0-9.]+' 2>/dev/null || echo "")
    TAX_RATE=$(echo "$INPUT" | grep -oP '税率:\K[0-9.]+' 2>/dev/null || echo "")
    DISCOUNT=$(echo "$INPUT" | grep -oP '折扣:\K[0-9.]+' 2>/dev/null || echo "0")

    if [ -z "$AMOUNT" ] || [ -z "$TAX_RATE" ]; then
      echo "🧮 发票金额计算器"
      echo "========================"
      echo ""
      echo "用法: bash scripts/invoice.sh calculate \"金额:10000 税率:13 折扣:5\""
      echo ""
      echo "参数:"
      echo "  金额:   不含税金额（必填）"
      echo "  税率:   税率百分比（必填）"
      echo "  折扣:   折扣百分比（可选，默认0）"
      echo ""
      echo "常用税率参考:"
      echo "  13% — 增值税一般纳税人（货物、加工修理）"
      echo "   9% — 交通运输、建筑、基础电信"
      echo "   6% — 现代服务业、金融、生活服务"
      echo "   3% — 小规模纳税人"
      echo "   0% — 出口货物"
    else
      python3 -c "
amount = float('${AMOUNT}')
rate = float('${TAX_RATE}')
discount = float('${DISCOUNT}')
disc_amount = amount * discount / 100
after_disc = amount - disc_amount
tax = after_disc * rate / 100
total = after_disc + tax
print('')
print('🧮 金额计算明细')
print('========================')
print('')
print('  原始金额:    ¥{:.2f}'.format(amount))
if discount > 0:
    print('  折扣({:.0f}%):    -¥{:.2f}'.format(discount, disc_amount))
    print('  折后金额:    ¥{:.2f}'.format(after_disc))
print('  税率:        {:.0f}%'.format(rate))
print('  税额:        ¥{:.2f}'.format(tax))
print('  ─────────────────')
print('  合计(含税):  ¥{:.2f}'.format(total))
print('')
print('  不含税单价:  ¥{:.2f}'.format(after_disc))
print('  价税合计:    ¥{:.2f}'.format(total))
"
    fi
    ;;

  recurring)
    CLIENT=$(echo "$INPUT" | grep -oP '客户:\K[^ ]+' 2>/dev/null || echo "")
    MONTHLY=$(echo "$INPUT" | grep -oP '月费:\K[0-9.]+' 2>/dev/null || echo "")
    CYCLE=$(echo "$INPUT" | grep -oP '周期:\K[^ ]+' 2>/dev/null || echo "monthly")
    PERIODS=$(echo "$INPUT" | grep -oP '期数:\K[0-9]+' 2>/dev/null || echo "12")

    if [ -z "$CLIENT" ] || [ -z "$MONTHLY" ]; then
      echo "🔄 定期账单生成器"
      echo "========================"
      echo ""
      echo "用法: bash scripts/invoice.sh recurring \"客户:XX 月费:8000 周期:monthly 期数:12\""
      echo ""
      echo "参数:"
      echo "  客户:   客户名称（必填）"
      echo "  月费:   每期金额（必填）"
      echo "  周期:   monthly/quarterly/yearly（默认monthly）"
      echo "  期数:   账单期数（默认12）"
    else
      python3 -c "
client = '${CLIENT}'
amount = float('${MONTHLY}')
cycle = '${CYCLE}'
periods = int('${PERIODS}')
total = amount * periods

cycle_cn = {'monthly': '月', 'quarterly': '季', 'yearly': '年'}.get(cycle, '月')

print('')
print('🔄 定期账单计划')
print('========================')
print('')
print('  客户:     {}'.format(client))
print('  每期金额: ¥{:.2f}'.format(amount))
print('  周期:     每{}'.format(cycle_cn))
print('  期数:     {}期'.format(periods))
print('  总金额:   ¥{:.2f}'.format(total))
print('')
print('  账单明细:')
print('  ─────────────────────────────')
print('  {:>4s}  {:>12s}  {:>12s}'.format('期数', '金额', '累计'))
print('  ─────────────────────────────')
for i in range(1, min(periods+1, 13)):
    cum = amount * i
    print('  {:>4d}  ¥{:>10.2f}  ¥{:>10.2f}'.format(i, amount, cum))
if periods > 12:
    print('  ...   (共{}期)'.format(periods))
print('  ─────────────────────────────')
print('  合计: ¥{:.2f}'.format(total))
"
    fi
    ;;

  receipt)
    INV_ID=$(echo "$INPUT" | grep -oP '发票号:\K[^ ]+' 2>/dev/null || echo "INV-$(date +%Y%m%d)-001")
    AMOUNT=$(echo "$INPUT" | grep -oP '金额:\K[0-9.]+' 2>/dev/null || echo "10000")
    PAY_METHOD=$(echo "$INPUT" | grep -oP '付款方式:\K[^ ]+' 2>/dev/null || echo "银行转账")
    RCPT_NO="RCPT-$(date +%Y%m%d)-$(printf '%03d' $((RANDOM % 999 + 1)))"
    RCPT_DATE=$(date +%Y-%m-%d)

    cat <<HTMLEOF
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<title>收据 ${RCPT_NO}</title>
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  body { font-family: 'PingFang SC', 'Microsoft YaHei', sans-serif; padding: 40px; background: #f0f0f0; }
  .receipt { max-width: 500px; margin: 0 auto; background: #fff; padding: 40px; border: 2px dashed #2ecc71; }
  h1 { text-align: center; color: #2ecc71; margin-bottom: 5px; }
  .subtitle { text-align: center; color: #999; margin-bottom: 25px; }
  .stamp { text-align: center; margin: 20px 0; }
  .stamp span { display: inline-block; border: 3px solid #2ecc71; color: #2ecc71; padding: 5px 20px; border-radius: 5px; font-size: 24px; font-weight: bold; transform: rotate(-5deg); }
  .details { margin: 20px 0; }
  .details .row { display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px dotted #ddd; }
  .details .row .label { color: #666; }
  .details .row .value { font-weight: bold; }
  .amount-big { text-align: center; font-size: 32px; color: #2c3e50; margin: 20px 0; }
  .footer { text-align: center; color: #999; font-size: 12px; margin-top: 25px; padding-top: 15px; border-top: 1px solid #eee; }
</style>
</head>
<body>
<div class="receipt">
  <h1>收 据</h1>
  <p class="subtitle">PAYMENT RECEIPT</p>
  <div class="stamp"><span>已付款 PAID</span></div>
  <div class="amount-big">¥${AMOUNT}</div>
  <div class="details">
    <div class="row"><span class="label">收据编号</span><span class="value">${RCPT_NO}</span></div>
    <div class="row"><span class="label">对应发票</span><span class="value">${INV_ID}</span></div>
    <div class="row"><span class="label">付款日期</span><span class="value">${RCPT_DATE}</span></div>
    <div class="row"><span class="label">付款方式</span><span class="value">${PAY_METHOD}</span></div>
    <div class="row"><span class="label">付款金额</span><span class="value">¥${AMOUNT}</span></div>
  </div>
  <div class="footer">
    <p>此收据确认上述款项已收讫</p>
    <p>This receipt confirms payment has been received</p>
  </div>
</div>
</body>
</html>
HTMLEOF
    echo ""
    echo "---"
    echo "✅ 收据已生成 | 编号: ${RCPT_NO}"
    echo "📋 对应发票: ${INV_ID} | 金额: ¥${AMOUNT}"
    echo "💳 付款方式: ${PAY_METHOD}"
    ;;

  export)
    FMT=$(echo "$INPUT" | tr '[:upper:]' '[:lower:]')
    echo "📤 发票导出指南"
    echo "========================"
    echo ""
    case "$FMT" in
      pdf)
        echo "📄 导出为 PDF"
        echo ""
        echo "方法1: 浏览器打印"
        echo "  1. 将HTML发票保存为 .html 文件"
        echo "  2. 用浏览器打开"
        echo "  3. Ctrl+P (Mac: Cmd+P)"
        echo "  4. 选择「另存为PDF」"
        echo ""
        echo "方法2: 命令行 (需安装 wkhtmltopdf)"
        echo "  wkhtmltopdf invoice.html invoice.pdf"
        echo ""
        echo "方法3: 使用 Chrome headless"
        echo "  google-chrome --headless --print-to-pdf=invoice.pdf invoice.html"
        ;;
      csv)
        echo "📊 导出为 CSV"
        echo ""
        echo "适合批量导入Excel/财务系统"
        echo ""
        echo "CSV格式示例:"
        echo "  发票号,日期,客户,项目,金额,税率,税额,合计"
        echo "  INV-20240101-001,2024-01-01,客户A,服务,10000,6,600,10600"
        ;;
      json)
        echo "📋 导出为 JSON"
        echo ""
        echo "适合API对接和系统集成"
        echo ""
        echo "JSON格式示例:"
        echo '  {'
        echo '    "invoice_no": "INV-20240101-001",'
        echo '    "date": "2024-01-01",'
        echo '    "client": "客户A",'
        echo '    "items": [{"desc": "服务", "amount": 10000}],'
        echo '    "tax_rate": 6,'
        echo '    "total": 10600'
        echo '  }'
        ;;
      *)
        echo "支持的导出格式:"
        echo ""
        echo "  pdf  — 适合打印和正式存档"
        echo "  csv  — 适合Excel/财务系统导入"
        echo "  json — 适合API对接和系统集成"
        echo ""
        echo "💡 查看详情: bash scripts/invoice.sh export [pdf|csv|json]"
        ;;
    esac
    ;;

  *)
    echo "🧾 Invoice Generator — 发票生成器"
    echo "==========================================="
    echo ""
    echo "用法: bash scripts/invoice.sh <command> [input]"
    echo ""
    echo "Commands:"
    echo "  create     生成HTML发票"
    echo "  template   查看发票模板库"
    echo "  calculate  金额计算(含税/折扣)"
    echo "  recurring  定期账单计划"
    echo "  receipt    生成付款收据(HTML)"
    echo "  export     导出格式指引(PDF/CSV/JSON)"
    echo ""
    echo "示例:"
    echo "  bash scripts/invoice.sh create \"客户:张三 项目:设计 金额:5000 税率:6\""
    echo "  bash scripts/invoice.sh calculate \"金额:10000 税率:13 折扣:5\""
    echo ""
    echo "  Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
    ;;
esac
