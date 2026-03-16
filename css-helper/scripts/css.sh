#!/usr/bin/env bash
# CSS Helper — generates real CSS code snippets
# Usage: css.sh <command> [options]

set -euo pipefail

CMD="${1:-help}"; shift 2>/dev/null || true

# Parse flags
DIRECTION="row" JUSTIFY="flex-start" ALIGN="stretch" WRAP="nowrap" GAP="0"
COLS="3" ROWS="" BREAKPOINTS="" MIN_COL="250px"
while [[ $# -gt 0 ]]; do
    case "$1" in
        --direction)  DIRECTION="$2"; shift 2 ;;
        --justify)    JUSTIFY="$2"; shift 2 ;;
        --align)      ALIGN="$2"; shift 2 ;;
        --wrap)       WRAP="$2"; shift 2 ;;
        --gap)        GAP="$2"; shift 2 ;;
        --cols)       COLS="$2"; shift 2 ;;
        --rows)       ROWS="$2"; shift 2 ;;
        --min)        MIN_COL="$2"; shift 2 ;;
        --breakpoints) BREAKPOINTS="yes"; shift ;;
        *) shift ;;
    esac
done

gen_flexbox() {
    cat <<CSS
/* ============================================
   Flexbox 布局
   方向: ${DIRECTION} | 主轴对齐: ${JUSTIFY} | 交叉轴: ${ALIGN}
   ============================================ */

.flex-container {
    display: flex;
    flex-direction: ${DIRECTION};
    justify-content: ${JUSTIFY};
    align-items: ${ALIGN};
    flex-wrap: ${WRAP};
    gap: ${GAP};
}

.flex-item {
    flex: 1;             /* 等分空间 */
    /* flex: 0 0 auto; */  /* 固定大小 */
    /* flex: 1 1 200px; */ /* 弹性 + 最小宽度 */
}

/* ---- 常用 Flexbox 模式 ---- */

/* 水平居中 */
.center-horizontal {
    display: flex;
    justify-content: center;
}

/* 垂直居中 */
.center-vertical {
    display: flex;
    align-items: center;
}

/* 完全居中（水平+垂直） */
.center-both {
    display: flex;
    justify-content: center;
    align-items: center;
}

/* 两端对齐，中间留空 */
.space-between {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

/* 底部对齐导航栏 */
.navbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 1rem;
    height: 60px;
}

/* 卡片列表（自动换行） */
.card-list {
    display: flex;
    flex-wrap: wrap;
    gap: 1rem;
}
.card-list > .card {
    flex: 1 1 300px;   /* 最小 300px，自动填充 */
    max-width: 400px;
}

/* 圣杯布局（header + main + sidebar + footer） */
.holy-grail {
    display: flex;
    flex-direction: column;
    min-height: 100vh;
}
.holy-grail .content {
    display: flex;
    flex: 1;
}
.holy-grail .main {
    flex: 1;
}
.holy-grail .sidebar {
    flex: 0 0 250px;
    order: -1;   /* 侧边栏在左 */
}

/* ---- HTML 示例 ----
<div class="flex-container">
    <div class="flex-item">Item 1</div>
    <div class="flex-item">Item 2</div>
    <div class="flex-item">Item 3</div>
</div>
---- */
CSS
}

gen_grid() {
    cat <<CSS
/* ============================================
   CSS Grid 布局
   列数: ${COLS} | 间距: ${GAP}
   ============================================ */

.grid-container {
    display: grid;
    grid-template-columns: repeat(${COLS}, 1fr);
    gap: ${GAP};
    /* 如果需要行定义 */
    /* grid-template-rows: auto; */
}

.grid-item {
    /* 跨列 */
    /* grid-column: span 2; */
    /* 跨行 */
    /* grid-row: span 2; */
}

/* ---- 自适应网格（推荐！不需要媒体查询）---- */
.grid-auto {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(${MIN_COL}, 1fr));
    gap: ${GAP};
}

/* ---- 命名区域布局 ---- */
.grid-layout {
    display: grid;
    grid-template-columns: 250px 1fr 200px;
    grid-template-rows: auto 1fr auto;
    grid-template-areas:
        "header  header  header"
        "sidebar main   aside"
        "footer  footer  footer";
    gap: ${GAP};
    min-height: 100vh;
}
.grid-layout .header  { grid-area: header; }
.grid-layout .sidebar { grid-area: sidebar; }
.grid-layout .main    { grid-area: main; }
.grid-layout .aside   { grid-area: aside; }
.grid-layout .footer  { grid-area: footer; }

/* ---- 响应式网格 ---- */
@media (max-width: 768px) {
    .grid-container {
        grid-template-columns: 1fr;   /* 单列 */
    }
    .grid-layout {
        grid-template-columns: 1fr;
        grid-template-areas:
            "header"
            "main"
            "sidebar"
            "aside"
            "footer";
    }
}

/* ---- 常用网格模式 ---- */

/* 图片画廊 */
.gallery {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
    gap: 0.5rem;
}
.gallery img {
    width: 100%;
    height: 200px;
    object-fit: cover;
    border-radius: 8px;
}

/* 仪表盘卡片 */
.dashboard {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 1rem;
}
.dashboard .wide  { grid-column: span 2; }
.dashboard .tall  { grid-row: span 2; }
.dashboard .full  { grid-column: 1 / -1; }

/* ---- HTML 示例 ----
<div class="grid-container">
    <div class="grid-item">1</div>
    <div class="grid-item">2</div>
    <div class="grid-item">3</div>
</div>
---- */
CSS
}

gen_reset() {
    cat <<'CSS'
/* ============================================
   Modern CSS Reset
   基于 Andy Bell 和 Josh Comeau 的最佳实践
   ============================================ */

/* 盒模型：border-box 全局 */
*, *::before, *::after {
    box-sizing: border-box;
}

/* 移除默认间距 */
* {
    margin: 0;
    padding: 0;
}

/* 防止字体膨胀 */
html {
    -moz-text-size-adjust: none;
    -webkit-text-size-adjust: none;
    text-size-adjust: none;
}

/* 全高布局基础 */
html, body {
    height: 100%;
}

/* 正文默认样式 */
body {
    line-height: 1.6;
    font-family: system-ui, -apple-system, BlinkMacSystemFont,
                 'Segoe UI', Roboto, 'Helvetica Neue', Arial,
                 'Noto Sans', sans-serif, 'Apple Color Emoji',
                 'Segoe UI Emoji';
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
}

/* 标题行高 */
h1, h2, h3, h4, h5, h6 {
    line-height: 1.2;
    text-wrap: balance;
}

/* 链接样式重置 */
a {
    color: inherit;
    text-decoration: none;
}
a:not([class]) {
    text-decoration-skip-ink: auto;
    color: currentColor;
}

/* 图片 */
img, picture, video, canvas, svg {
    display: block;
    max-width: 100%;
    height: auto;
}

/* 表单元素继承字体 */
input, button, textarea, select {
    font: inherit;
    color: inherit;
}

/* 按钮重置 */
button {
    cursor: pointer;
    border: none;
    background: none;
}

/* 文本区域 */
textarea {
    resize: vertical;
}

/* 列表 */
ul, ol {
    list-style: none;
}

/* 表格 */
table {
    border-collapse: collapse;
    border-spacing: 0;
}

/* 动画偏好 */
@media (prefers-reduced-motion: reduce) {
    *, *::before, *::after {
        animation-duration: 0.01ms !important;
        animation-iteration-count: 1 !important;
        transition-duration: 0.01ms !important;
        scroll-behavior: auto !important;
    }
}

/* ---- 可选的暗色模式基础 ---- */
/*
@media (prefers-color-scheme: dark) {
    :root {
        color-scheme: dark;
    }
}
*/

/* ---- CSS 变量基础（按需修改） ---- */
:root {
    /* 颜色 */
    --color-primary: #3b82f6;
    --color-secondary: #64748b;
    --color-accent: #f59e0b;
    --color-success: #22c55e;
    --color-danger: #ef4444;
    --color-bg: #ffffff;
    --color-text: #1e293b;

    /* 间距 */
    --space-xs: 0.25rem;
    --space-sm: 0.5rem;
    --space-md: 1rem;
    --space-lg: 2rem;
    --space-xl: 4rem;

    /* 字号 */
    --text-xs: 0.75rem;
    --text-sm: 0.875rem;
    --text-base: 1rem;
    --text-lg: 1.125rem;
    --text-xl: 1.25rem;
    --text-2xl: 1.5rem;

    /* 圆角 */
    --radius-sm: 4px;
    --radius-md: 8px;
    --radius-lg: 16px;
    --radius-full: 9999px;

    /* 阴影 */
    --shadow-sm: 0 1px 2px rgba(0,0,0,0.05);
    --shadow-md: 0 4px 6px rgba(0,0,0,0.1);
    --shadow-lg: 0 10px 15px rgba(0,0,0,0.1);
}
CSS
}

gen_responsive() {
    cat <<'CSS'
/* ============================================
   响应式媒体查询模板
   移动优先 (Mobile-First) 策略
   ============================================ */

/* ---- 断点定义（CSS 变量不支持媒体查询，仅做参考）----
   xs:  < 576px   (手机竖屏)
   sm:  ≥ 576px   (手机横屏)
   md:  ≥ 768px   (平板)
   lg:  ≥ 992px   (笔记本)
   xl:  ≥ 1200px  (桌面)
   2xl: ≥ 1400px  (大屏)
   ---- */

/* ---- 基础样式（手机，无媒体查询）---- */
.container {
    width: 100%;
    padding: 0 1rem;
    margin: 0 auto;
}

.grid {
    display: grid;
    grid-template-columns: 1fr;
    gap: 1rem;
}

.hide-mobile { display: none; }
.hide-desktop { display: block; }

/* ---- 小手机横屏 ≥ 576px ---- */
@media (min-width: 576px) {
    .container { max-width: 540px; }
    .grid { grid-template-columns: repeat(2, 1fr); }
}

/* ---- 平板 ≥ 768px ---- */
@media (min-width: 768px) {
    .container { max-width: 720px; }
    .grid { grid-template-columns: repeat(2, 1fr); }

    .hide-mobile { display: block; }

    /* 平板导航 */
    .nav-mobile { display: none; }
    .nav-desktop { display: flex; }
}

/* ---- 笔记本 ≥ 992px ---- */
@media (min-width: 992px) {
    .container { max-width: 960px; }
    .grid { grid-template-columns: repeat(3, 1fr); }
}

/* ---- 桌面 ≥ 1200px ---- */
@media (min-width: 1200px) {
    .container { max-width: 1140px; }
    .grid { grid-template-columns: repeat(4, 1fr); }

    .hide-desktop { display: none; }
}

/* ---- 大屏 ≥ 1400px ---- */
@media (min-width: 1400px) {
    .container { max-width: 1320px; }
}

/* ---- 实用响应式工具类 ---- */

/* 流体字号 */
.fluid-text {
    font-size: clamp(1rem, 2.5vw, 2rem);
}

/* 流体间距 */
.fluid-space {
    padding: clamp(1rem, 5vw, 3rem);
}

/* 最大宽度容器 */
.max-content {
    width: min(90%, 1200px);
    margin-inline: auto;
}

/* 响应式图片 */
.responsive-img {
    width: 100%;
    height: auto;
    object-fit: cover;
}

/* 响应式视频 */
.responsive-video {
    position: relative;
    padding-bottom: 56.25%;  /* 16:9 */
    height: 0;
    overflow: hidden;
}
.responsive-video iframe,
.responsive-video video {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
}

/* ---- 暗色模式 ---- */
@media (prefers-color-scheme: dark) {
    :root {
        --color-bg: #0f172a;
        --color-text: #e2e8f0;
    }
}

/* ---- 打印样式 ---- */
@media print {
    body { font-size: 12pt; color: #000; background: #fff; }
    nav, footer, .no-print { display: none !important; }
    a { text-decoration: underline; }
    a[href]::after { content: " (" attr(href) ")"; font-size: 0.8em; }
}
CSS
}

case "$CMD" in
    flexbox|flex)
        gen_flexbox ;;
    grid)
        gen_grid ;;
    reset)
        gen_reset ;;
    responsive|rwd)
        gen_responsive ;;
    *)
        cat <<'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  🎨 CSS Helper — 使用指南
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  命令                说明
  ──────────────────────────────────────────
  flexbox             Flexbox 布局代码
    --direction ROW     方向 (row|column)
    --justify VAL       主轴对齐 (center|space-between|...)
    --align VAL         交叉轴对齐 (center|stretch|...)
    --wrap VAL          换行 (nowrap|wrap)
    --gap SIZE          间距 (如 1rem, 20px)

  grid                Grid 网格布局
    --cols NUM          列数 (默认: 3)
    --gap SIZE          间距 (默认: 1rem)
    --min SIZE          自适应最小列宽 (默认: 250px)

  reset               现代 CSS Reset 模板

  responsive          响应式媒体查询模板
                      (含断点、流体字号、暗色模式、打印)

  示例:
    css.sh flexbox --direction row --justify center --gap 1rem
    css.sh grid --cols 4 --gap 20px
    css.sh reset
    css.sh responsive
EOF
        ;;
esac
