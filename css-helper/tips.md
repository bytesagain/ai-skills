# CSS Helper Tips 🎨

## Flexbox vs Grid

| 场景 | 推荐 |
|------|------|
| 一维排列(行或列) | Flexbox |
| 二维布局(行+列) | Grid |
| 居中元素 | Flexbox(最简单) |
| 复杂页面布局 | Grid |
| 等高卡片 | 都可以 |

## 动画性能

优先使用 `transform` 和 `opacity`，它们不触发重排(reflow)：
- ✅ `transform: translateX()` 
- ✅ `opacity: 0.5`
- ❌ `width: 100px` (触发重排)
- ❌ `margin-left: 10px` (触发重排)

## 渐变色技巧

1. 至少用2个颜色停靠点
2. 角度推荐: 135deg / 45deg 看起来更自然
3. 文字渐变用 `background-clip: text`
4. 动画渐变用 `background-size: 200%`

## 阴影层次

多层阴影比单层看起来更自然：
```css
box-shadow: 
  0 1px 2px rgba(0,0,0,0.07),
  0 2px 4px rgba(0,0,0,0.07),
  0 4px 8px rgba(0,0,0,0.07);
```

## 响应式断点建议

| 名称 | 宽度 | 设备 |
|------|------|------|
| sm | 640px | 手机横屏 |
| md | 768px | 平板 |
| lg | 1024px | 笔记本 |
| xl | 1280px | 桌面 |
| 2xl | 1536px | 大屏 |

## 常用单位

- `rem` — 相对根字体大小，推荐用于间距和字体
- `%` — 相对父元素，用于宽度
- `vh/vw` — 视口单位，全屏布局
- `px` — 边框、阴影等固定值

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
