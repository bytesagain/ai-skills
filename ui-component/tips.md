# UI Component Tips 🧩

## 设计原则

1. **一致性** — 同一项目使用统一的圆角、间距、配色
2. **可访问性** — 表单加label，按钮有焦点样式，对比度达标
3. **响应式** — 移动端优先，用相对单位(rem/%)
4. **简洁** — 少即是多，不加无意义装饰

## 组件选择指南

| 需求 | 推荐命令 |
|------|----------|
| 用户输入数据 | `form` |
| 展示列表数据 | `table` |
| 展示产品/内容 | `card` |
| 弹出确认/提示 | `modal` |
| 页面导航 | `navbar` |

## 风格说明

- **basic** — 干净简约，适合任何项目
- **modern** — 圆角+阴影+渐变，当代感
- **minimal** — 极简，只有必要元素
- **glassmorphism** — 毛玻璃效果，适合深色背景

## 自定义建议

生成的HTML是起点，可以自由修改：
- 颜色 → 搜索替换CSS变量
- 字体 → 修改font-family
- 间距 → 调整padding/margin
- 动画 → 添加transition/animation

## 浏览器兼容

生成的代码支持所有现代浏览器(Chrome, Firefox, Safari, Edge)。
部分glassmorphism效果需要 `backdrop-filter` 支持。

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
