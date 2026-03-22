---
name: "minify"
version: "1.0.0"
description: "Code minification reference — JavaScript/CSS/HTML minification techniques, AST transformations, dead code elimination, and bundle optimization. Use when reducing frontend asset sizes or understanding minifier behavior."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [minify, minification, javascript, css, html, optimization, devtools]
category: "devtools"
---

# Minify — Code Minification Reference

Quick-reference skill for code minification techniques, AST transformations, and bundle size optimization strategies.

## When to Use

- Understanding how JavaScript/CSS/HTML minification works
- Choosing between minification tools (Terser, esbuild, SWC)
- Debugging minified code issues
- Optimizing bundle size for production
- Understanding mangling, dead code elimination, and tree shaking

## Commands

### `intro`

```bash
scripts/script.sh intro
```

Overview of minification — why, what, how, and impact on performance.

### `javascript`

```bash
scripts/script.sh javascript
```

JavaScript minification techniques — mangling, compression, dead code elimination.

### `css`

```bash
scripts/script.sh css
```

CSS minification — shorthand merging, selector deduplication, unused rule removal.

### `html`

```bash
scripts/script.sh html
```

HTML minification — whitespace, attribute, comment removal strategies.

### `tools`

```bash
scripts/script.sh tools
```

Minification tools compared: Terser, esbuild, SWC, cssnano, html-minifier.

### `sourcemaps`

```bash
scripts/script.sh sourcemaps
```

Source maps — how they work, generation, debugging with minified code.

### `treeshake`

```bash
scripts/script.sh treeshake
```

Tree shaking — dead code elimination, side effects, module analysis.

### `pitfalls`

```bash
scripts/script.sh pitfalls
```

Common minification pitfalls and debugging strategies.

### `help`

```bash
scripts/script.sh help
```

### `version`

```bash
scripts/script.sh version
```

## Configuration

| Variable | Description |
|----------|-------------|
| `MINIFY_DIR` | Data directory (default: ~/.minify/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
