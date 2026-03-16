#!/usr/bin/env bash
# pay.sh — 支付集成工具（支付宝/微信支付）
# Usage: bash pay.sh <command> [args...]
# Commands: qrcode, bill, reconcile, refund, webhook, config, test
# Powered by BytesAgain | bytesagain.com

set -euo pipefail

CMD="${1:-help}"
shift 2>/dev/null || true
INPUT="$*"

show_help() {
  cat <<'HELP'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  💰 支付集成工具 — 支付宝 & 微信支付
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  qrcode   <金额> [描述]     生成收款码链接/HTML
  bill     [月份]            生成账单分析模板
  reconcile [日期]           生成对账报告
  refund   <订单号> <金额>   退款流程模板
  webhook                    回调处理代码模板
  config   <平台>            配置检查清单
  test                       支付测试清单

  示例:
    bash pay.sh qrcode 99.99 "商品购买"
    bash pay.sh bill 2024-03
    bash pay.sh reconcile 2024-03-15
    bash pay.sh config alipay
    bash pay.sh webhook

  Powered by BytesAgain | bytesagain.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
HELP
}

# 生成收款码
cmd_qrcode() {
  local amount="${1:-0}"
  local desc="${2:-商品购买}"
  local order_id
  order_id="PAY$(date +%Y%m%d%H%M%S)$(( RANDOM % 10000 ))"

  cat <<EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  💳 收款码生成
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  订单号: ${order_id}
  金额:   ¥${amount}
  描述:   ${desc}
  时间:   $(date '+%Y-%m-%d %H:%M:%S')

  📱 支付宝收款链接:
  alipays://platformapi/startapp?appId=20000067&url=https://qr.alipay.com/fkx${order_id}

  📱 微信收款链接:
  wxp://f2f0${order_id}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📄 收款页面 HTML (保存为 pay.html 即可使用):

EOF

  cat <<'HTMLEOF'
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>收款页面</title>
<style>
* { margin: 0; padding: 0; box-sizing: border-box; }
body { font-family: -apple-system, sans-serif; background: #f5f5f5; display: flex; justify-content: center; align-items: center; min-height: 100vh; }
.card { background: white; border-radius: 16px; padding: 40px; box-shadow: 0 4px 20px rgba(0,0,0,0.1); text-align: center; max-width: 400px; width: 90%; }
.amount { font-size: 48px; font-weight: bold; color: #333; margin: 20px 0; }
.amount::before { content: "¥"; font-size: 24px; vertical-align: top; margin-right: 4px; }
.desc { color: #666; margin-bottom: 30px; }
.qr-placeholder { width: 200px; height: 200px; margin: 0 auto 20px; background: #f0f0f0; display: flex; align-items: center; justify-content: center; border-radius: 8px; font-size: 14px; color: #999; border: 2px dashed #ddd; }
.btn-group { display: flex; gap: 12px; justify-content: center; margin-top: 20px; }
.btn { padding: 12px 32px; border: none; border-radius: 8px; font-size: 16px; cursor: pointer; font-weight: 600; }
.btn-alipay { background: #1677ff; color: white; }
.btn-wechat { background: #07c160; color: white; }
.order-info { margin-top: 20px; font-size: 12px; color: #999; }
</style>
</head>
<body>
<div class="card">
  <h2>收款</h2>
HTMLEOF
  echo "  <div class=\"amount\">${amount}</div>"
  echo "  <div class=\"desc\">${desc}</div>"
  cat <<'HTMLEOF2'
  <div class="qr-placeholder">
    📱 扫码支付<br>
    (接入API后显示二维码)
  </div>
  <div class="btn-group">
    <button class="btn btn-alipay" onclick="payAlipay()">支付宝支付</button>
    <button class="btn btn-wechat" onclick="payWechat()">微信支付</button>
  </div>
  <div class="order-info">
HTMLEOF2
  echo "    订单号: ${order_id}<br>"
  echo "    创建时间: $(date '+%Y-%m-%d %H:%M:%S')"
  cat <<'HTMLEOF3'
  </div>
</div>
<script>
function payAlipay() {
  // 替换为真实支付宝SDK调用
  alert('接入支付宝SDK后可用');
}
function payWechat() {
  // 替换为真实微信支付SDK调用
  alert('接入微信支付SDK后可用');
}
</script>
</body>
</html>
HTMLEOF3
}

# 账单分析模板
cmd_bill() {
  local month="${1:-$(date '+%Y-%m')}"

  cat <<EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  📊 ${month} 月度账单分析报告
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  📈 收入汇总
  ┌──────────────────┬──────────────┬──────────┐
  │ 支付渠道         │ 交易笔数     │ 金额(¥)  │
  ├──────────────────┼──────────────┼──────────┤
  │ 支付宝           │ ___          │ ___      │
  │ 微信支付         │ ___          │ ___      │
  │ 银行卡           │ ___          │ ___      │
  │ 其他             │ ___          │ ___      │
  ├──────────────────┼──────────────┼──────────┤
  │ 合计             │ ___          │ ___      │
  └──────────────────┴──────────────┴──────────┘

  📉 支出汇总
  ┌──────────────────┬──────────────┬──────────┐
  │ 分类             │ 笔数         │ 金额(¥)  │
  ├──────────────────┼──────────────┼──────────┤
  │ 退款             │ ___          │ ___      │
  │ 手续费           │ ___          │ ___      │
  │ 提现             │ ___          │ ___      │
  ├──────────────────┼──────────────┼──────────┤
  │ 合计             │ ___          │ ___      │
  └──────────────────┴──────────────┴──────────┘

  📊 关键指标
  ┌──────────────────────────────────────────────┐
  │ 日均交易额:        ¥___                      │
  │ 笔均金额:          ¥___                      │
  │ 退款率:            ___%                      │
  │ 手续费率:          ___%                      │
  │ 支付宝占比:        ___%                      │
  │ 微信支付占比:      ___%                      │
  │ 峰值交易日:        ___日 (¥___)              │
  │ 低谷交易日:        ___日 (¥___)              │
  └──────────────────────────────────────────────┘

  📅 每日交易趋势 (柱状图)
  31 │
  28 │
  25 │
  22 │  ▓
  19 │  ▓
  16 │  ▓ ▓
  13 │  ▓ ▓   ▓
  10 │  ▓ ▓ ▓ ▓ ▓
   7 │  ▓ ▓ ▓ ▓ ▓ ▓
   4 │▓ ▓ ▓ ▓ ▓ ▓ ▓
   1 │▓ ▓ ▓ ▓ ▓ ▓ ▓
     └──────────────── (周)
      一 二 三 四 五 六 日

  💡 分析建议
  1. [根据数据填写退款率分析]
  2. [手续费优化建议]
  3. [渠道分布建议]
  4. [峰谷时段运营建议]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  报告生成时间: $(date '+%Y-%m-%d %H:%M:%S')
EOF
}

# 对账报告
cmd_reconcile() {
  local date_str="${1:-$(date '+%Y-%m-%d')}"

  cat <<EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  🔍 对账报告 — ${date_str}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  📋 对账概况
  ┌──────────────────────┬──────────┬──────────┬──────────┐
  │ 项目                 │ 系统记录 │ 渠道记录 │ 差异     │
  ├──────────────────────┼──────────┼──────────┼──────────┤
  │ 支付宝-交易笔数      │ ___      │ ___      │ ___      │
  │ 支付宝-交易金额      │ ¥___     │ ¥___     │ ¥___     │
  │ 微信支付-交易笔数    │ ___      │ ___      │ ___      │
  │ 微信支付-交易金额    │ ¥___     │ ¥___     │ ¥___     │
  │ 退款笔数             │ ___      │ ___      │ ___      │
  │ 退款金额             │ ¥___     │ ¥___     │ ¥___     │
  ├──────────────────────┼──────────┼──────────┼──────────┤
  │ 合计                 │ ¥___     │ ¥___     │ ¥___     │
  └──────────────────────┴──────────┴──────────┴──────────┘

  ⚠️ 差异明细
  ┌──────────────┬──────────┬──────────────────┬──────────┐
  │ 订单号       │ 金额     │ 差异类型         │ 状态     │
  ├──────────────┼──────────┼──────────────────┼──────────┤
  │ (示例)       │ ¥___     │ 单边账(系统多)   │ 待处理   │
  │ (示例)       │ ¥___     │ 金额不一致       │ 待处理   │
  │ (示例)       │ ¥___     │ 单边账(渠道多)   │ 待处理   │
  └──────────────┴──────────┴──────────────────┴──────────┘

  📊 对账结果:
    ✅ 完全一致:    ___ 笔
    ⚠️ 金额差异:    ___ 笔
    ❌ 系统多:      ___ 笔  (我方有，渠道无)
    ❌ 渠道多:      ___ 笔  (渠道有，我方无)

  🔄 处理建议:
  1. 单边账(系统多): 检查是否发送失败/超时，确认渠道侧状态
  2. 单边账(渠道多): 检查回调是否丢失，补偿处理
  3. 金额不一致: 核对优惠/手续费计算，人工确认

  📝 对账SQL参考:
  -- 系统交易记录
  SELECT order_id, amount, status, channel, created_at
  FROM payment_orders
  WHERE DATE(created_at) = '${date_str}'
    AND status IN ('paid', 'refunded');

  -- 与渠道账单对比
  SELECT s.order_id, s.amount AS sys_amount, c.amount AS channel_amount,
         CASE WHEN c.order_id IS NULL THEN '系统多'
              WHEN s.order_id IS NULL THEN '渠道多'
              WHEN s.amount != c.amount THEN '金额不一致'
              ELSE '一致' END AS diff_type
  FROM payment_orders s
  FULL OUTER JOIN channel_bills c ON s.order_id = c.order_id
  WHERE DATE(s.created_at) = '${date_str}'
     OR DATE(c.trade_time) = '${date_str}';

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  生成时间: $(date '+%Y-%m-%d %H:%M:%S')
EOF
}

# 退款流程
cmd_refund() {
  local order_id="${1:-ORDER_ID}"
  local amount="${2:-0}"

  cat <<EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  🔄 退款处理流程
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  订单号:   ${order_id}
  退款金额: ¥${amount}
  申请时间: $(date '+%Y-%m-%d %H:%M:%S')

  📋 退款检查清单:
  [ ] 1. 确认订单存在且已支付
  [ ] 2. 确认退款金额 ≤ 已支付金额
  [ ] 3. 确认未超过退款时限 (一般90天)
  [ ] 4. 检查是否重复退款
  [ ] 5. 确认退款原因

  💻 退款代码模板:

  # 支付宝退款
  import json, urllib.request

  refund_data = {
      "out_trade_no": "${order_id}",
      "refund_amount": "${amount}",
      "out_request_no": "REFUND_$(date +%s)",
      "refund_reason": "用户申请退款"
  }

  # 微信退款
  refund_data_wx = {
      "out_trade_no": "${order_id}",
      "out_refund_no": "REFUND_$(date +%s)",
      "total_fee": int(float("${amount}") * 100),
      "refund_fee": int(float("${amount}") * 100),
      "refund_desc": "用户申请退款"
  }

  ⚠️ 注意事项:
  • 微信退款需要证书 (apiclient_cert.pem, apiclient_key.pem)
  • 支付宝退款无需证书，但需签名
  • 退款到账时间: 支付宝即时 / 微信1-3个工作日
  • 部分退款: 累计退款金额不得超过原交易金额
  • 退款后会触发退款回调通知

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
}

# Webhook回调模板
cmd_webhook() {
  cat <<'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  🔗 支付回调 (Webhook) 处理模板
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  📌 支付宝异步通知 (Python Flask):

```python
from flask import Flask, request
import hashlib

app = Flask(__name__)

@app.route('/api/pay/alipay/notify', methods=['POST'])
def alipay_notify():
    """支付宝异步通知"""
    data = request.form.to_dict()

    # 1. 验签 (必须！防止伪造)
    sign = data.pop('sign', '')
    sign_type = data.pop('sign_type', 'RSA2')
    if not verify_alipay_sign(data, sign):
        return 'fail'

    # 2. 检查通知状态
    trade_status = data.get('trade_status')
    if trade_status not in ('TRADE_SUCCESS', 'TRADE_FINISHED'):
        return 'success'  # 非终态，不处理

    # 3. 业务处理
    out_trade_no = data.get('out_trade_no')  # 商户订单号
    trade_no = data.get('trade_no')          # 支付宝交易号
    total_amount = data.get('total_amount')  # 交易金额

    # 4. 幂等检查 (防重复通知)
    if is_order_processed(out_trade_no):
        return 'success'

    # 5. 更新订单状态
    update_order(out_trade_no, 'paid', trade_no=trade_no)

    return 'success'  # 必须返回'success'，否则支付宝会重试
```

  📌 微信支付回调 (Python Flask):

```python
@app.route('/api/pay/wechat/notify', methods=['POST'])
def wechat_notify():
    """微信支付回调"""
    xml_data = request.data

    # 1. 解析XML
    data = parse_wechat_xml(xml_data)

    # 2. 验签
    sign = data.pop('sign', '')
    if not verify_wechat_sign(data, sign):
        return make_wechat_response('FAIL', '签名验证失败')

    # 3. 检查支付结果
    if data.get('result_code') != 'SUCCESS':
        return make_wechat_response('SUCCESS', 'OK')

    # 4. 业务处理
    out_trade_no = data.get('out_trade_no')
    transaction_id = data.get('transaction_id')
    total_fee = int(data.get('total_fee', 0))  # 单位：分

    # 5. 金额校验
    order = get_order(out_trade_no)
    if order.amount_cents != total_fee:
        return make_wechat_response('FAIL', '金额不一致')

    # 6. 幂等处理
    if order.status == 'paid':
        return make_wechat_response('SUCCESS', 'OK')

    update_order(out_trade_no, 'paid', transaction_id=transaction_id)
    return make_wechat_response('SUCCESS', 'OK')

def make_wechat_response(code, msg):
    return f'<xml><return_code>{code}</return_code><return_msg>{msg}</return_msg></xml>'
```

  ⚠️ 回调处理要点:
  1. 验签第一！不验签 = 裸奔
  2. 幂等处理！回调可能重复发送
  3. 先返回success，再做异步业务处理
  4. 金额校验！防止金额篡改
  5. 记录原始通知日志，便于排查
  6. 超时重试: 支付宝25h内8次 / 微信24h内多次

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
}

# 配置检查
cmd_config() {
  local platform="${1:-all}"

  cat <<'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ⚙️ 支付配置检查清单
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  if [[ "$platform" == "alipay" || "$platform" == "all" ]]; then
    cat <<'EOF'

  📱 支付宝配置:
  [ ] APP_ID (应用ID)
  [ ] 应用私钥 (RSA2)
  [ ] 支付宝公钥 (用于验签)
  [ ] 异步通知URL (notify_url)
  [ ] 同步跳转URL (return_url)
  [ ] 签名类型: RSA2 (推荐)
  [ ] 环境: 沙箱/生产
  [ ] 授权回调地址 (如需)
  [ ] 接口加签方式: 公钥/证书

  🔐 支付宝安全配置:
  [ ] IP白名单设置
  [ ] 接口权限申请
  [ ] 密钥定期轮换
  [ ] 敏感信息加密存储
EOF
  fi

  if [[ "$platform" == "wechat" || "$platform" == "all" ]]; then
    cat <<'EOF'

  💬 微信支付配置:
  [ ] 商户号 (mch_id)
  [ ] API密钥 (api_key)
  [ ] AppID (公众号/小程序)
  [ ] AppSecret
  [ ] 证书文件 (apiclient_cert.pem)
  [ ] 证书密钥 (apiclient_key.pem)
  [ ] 回调URL (notify_url)
  [ ] v3密钥 (如用v3接口)

  🔐 微信安全配置:
  [ ] 证书序列号
  [ ] 平台证书自动更新
  [ ] API密钥定期更换
  [ ] 退款证书权限
EOF
  fi

  cat <<'EOF'

  🌐 通用检查:
  [ ] HTTPS证书有效
  [ ] 回调URL可公网访问
  [ ] 防火墙放行支付渠道IP
  [ ] 订单号全局唯一策略
  [ ] 金额用整数(分)存储
  [ ] 超时自动关单机制
  [ ] 对账定时任务
  [ ] 异常告警机制

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
}

# 测试清单
cmd_test() {
  cat <<'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  🧪 支付测试检查清单
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ✅ 正常流程测试:
  [ ] 支付宝扫码支付 - 成功
  [ ] 微信扫码支付 - 成功
  [ ] H5支付 - 成功
  [ ] 小程序支付 - 成功
  [ ] APP支付 - 成功
  [ ] 不同金额 (0.01 / 1.00 / 999.99)
  [ ] 最大金额边界测试

  ❌ 异常流程测试:
  [ ] 支付超时 → 订单自动关闭
  [ ] 用户取消支付 → 正确处理
  [ ] 网络断开后恢复 → 状态同步
  [ ] 重复支付 → 幂等处理
  [ ] 金额为0 → 拒绝
  [ ] 负数金额 → 拒绝
  [ ] 订单不存在 → 友好提示

  🔄 退款测试:
  [ ] 全额退款 → 成功
  [ ] 部分退款 → 成功
  [ ] 重复退款 → 幂等
  [ ] 超额退款 → 拒绝
  [ ] 超时退款 (>90天) → 拒绝

  🔔 回调测试:
  [ ] 正常回调 → 正确处理
  [ ] 重复回调 → 幂等处理
  [ ] 伪造回调 → 验签拒绝
  [ ] 回调超时 → 重试机制
  [ ] 回调顺序错乱 → 状态机处理

  📊 性能测试:
  [ ] 并发下单 (10/50/100 QPS)
  [ ] 数据库锁竞争
  [ ] 回调处理延迟 < 3s

  🔐 安全测试:
  [ ] 签名验证
  [ ] 金额篡改检测
  [ ] SQL注入防护
  [ ] XSS防护
  [ ] CSRF防护

  📱 沙箱账号:
  支付宝沙箱: https://open.alipay.com/develop/sandbox
  微信沙箱: https://pay.weixin.qq.com/wiki/doc/api/tools/sp_coupon.php

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  生成时间: $(date '+%Y-%m-%d %H:%M:%S')
EOF
}

case "$CMD" in
  qrcode)
    cmd_qrcode $INPUT
    ;;
  bill)
    cmd_bill $INPUT
    ;;
  reconcile)
    cmd_reconcile $INPUT
    ;;
  refund)
    cmd_refund $INPUT
    ;;
  webhook)
    cmd_webhook
    ;;
  config)
    cmd_config $INPUT
    ;;
  test)
    cmd_test
    ;;
  *)
    show_help
    ;;
esac
