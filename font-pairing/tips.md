# Font Pairing Tips 🔤

## 字体搭配原则

1. **对比** — 标题和正文用不同类型(如衬线+无衬线)
2. **层次** — 最多3种字体：标题、正文、强调
3. **一致性** — 同一项目保持字体统一
4. **可读性优先** — 正文用易读字体，装饰字体只用于标题

## 经典搭配公式

| 标题 | 正文 | 风格 |
|------|------|------|
| Playfair Display | Source Sans Pro | 优雅 |
| Montserrat | Merriweather | 现代 |
| Roboto | Roboto Slab | 科技 |
| Lora | Open Sans | 经典 |

## 中文字体推荐

### Web端
- **思源黑体** (Noto Sans SC) — 免费，Google Fonts直接用
- **思源宋体** (Noto Serif SC) — 适合长文阅读
- **系统默认** — 最快，`"PingFang SC", "Microsoft YaHei", sans-serif`

### 注意
- 中文字体文件很大(几MB)，优先用系统字体
- 需要Web字体时用font-display: swap避免闪烁
- 繁简体用不同字体文件

## 字体大小建议

| 元素 | 大小 | 行高 |
|------|------|------|
| H1 | 2-3rem | 1.2 |
| H2 | 1.5-2rem | 1.3 |
| 正文 | 1rem (16px) | 1.5-1.6 |
| 小字 | 0.875rem | 1.4 |
| 中文正文 | 16-18px | 1.8-2.0 |

## 性能优化

1. 只加载需要的字重(400, 700)
2. 使用 `font-display: swap`
3. 预加载关键字体 `<link rel="preload">`
4. 中文字体考虑子集化(subset)

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
