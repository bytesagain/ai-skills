---
version: "2.0.0"
name: qr-code
description: "QR码SVG生成(纯Python算法生成真实二维码)、WiFi连接码、名片码、URL码、批量生成、设计建议。QR code SVG generator with WiFi, vCard, URL, batch generation, design tips. Use when you need qr code capabilities. Triggers on: qr code."
---
# qr-code

QR码SVG生成(纯Python算法生成真实二维码)、WiFi连接码、名片码、URL码、批量生成、设计建议。QR code SVG generator with WiFi, vCard, URL, batch generation, design tips.

## 常见问题

**Q: 这个工具适合谁用？**
A: 任何需要qr-code的人，无论是个人还是企业用户。

**Q: 输出格式是什么？**
A: 主要输出Markdown格式，方便复制和编辑。

## 命令列表

| 命令 | 功能 |
|------|------|
| `generate` | generate |
| `wifi` | wifi |
| `vcard` | vcard |
| `url` | url |
| `batch` | batch |
| `design` | design |


## 专业建议

- 内容越短越好** — 数据越少，二维码越简单，扫描越快
- 留白边距** — 四周至少留4个模块的空白(quiet zone)
- 对比度要高** — 深色模块+浅色背景，不要反转
- 测试扫描** — 生成后用手机实际测试
- 标准格式: `WIFI:T:<加密>;S:<SSID>;P:<密码>;;`

---
*qr-code by BytesAgain*
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Commands

| Command | Description |
|---------|-------------|
| `qr-code help` | Show usage info |
| `qr-code run` | Run main task |

## Examples

```bash
qr-code help
qr-code run
```
