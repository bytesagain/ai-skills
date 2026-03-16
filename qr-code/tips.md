# QR Code Tips 📱

## 二维码最佳实践

1. **内容越短越好** — 数据越少，二维码越简单，扫描越快
2. **留白边距** — 四周至少留4个模块的空白(quiet zone)
3. **对比度要高** — 深色模块+浅色背景，不要反转
4. **测试扫描** — 生成后用手机实际测试

## WiFi二维码格式

标准格式: `WIFI:T:<加密>;S:<SSID>;P:<密码>;;`
- T = WPA / WEP / nopass
- S = 网络名
- P = 密码

## vCard格式

名片二维码使用vCard 3.0标准，兼容iOS和Android通讯录。

## 容错级别

| 级别 | 恢复能力 | 适用场景 |
|------|----------|----------|
| L (7%) | 低 | 数据量大时 |
| M (15%) | 中 | 一般用途 |
| Q (25%) | 较高 | 可能部分遮挡 |
| H (30%) | 高 | 加Logo时 |

## 常见问题

- **扫不出来？** 检查对比度和大小，最小建议2cm×2cm
- **数据太多？** URL用短链接，文字精简
- **要加Logo？** 用H级容错，Logo不超过总面积30%

## 批量生成

准备一个文本文件，每行一条数据：
```
https://example.com/page1
https://example.com/page2
Hello World
```

然后: `bash scripts/qr.sh batch input.txt output_dir/`

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
