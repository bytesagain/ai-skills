---
name: "module"
version: "1.0.0"
description: "Module systems reference — CommonJS, ESM, AMD, module resolution, package exports, and bundler interop. Use when understanding or debugging JavaScript/TypeScript module loading, circular dependencies, or package configuration."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [module, esm, commonjs, import, require, bundler, devtools]
category: "devtools"
---

# Module — Module Systems Reference

Quick-reference skill for JavaScript module systems, resolution algorithms, and package configuration.

## When to Use

- Understanding differences between CommonJS and ES Modules
- Debugging module resolution or import errors
- Configuring package.json exports/imports fields
- Handling circular dependencies
- Setting up dual CJS/ESM packages

## Commands

### `intro`

```bash
scripts/script.sh intro
```

Overview of module systems — history, why modules matter, evolution of JS modules.

### `esm`

```bash
scripts/script.sh esm
```

ES Modules — import/export syntax, static analysis, top-level await.

### `commonjs`

```bash
scripts/script.sh commonjs
```

CommonJS — require/module.exports, caching, dynamic loading.

### `resolution`

```bash
scripts/script.sh resolution
```

Module resolution algorithms — Node.js, TypeScript, bundler modes.

### `packagejson`

```bash
scripts/script.sh packagejson
```

Package.json module fields — main, module, exports, imports, type.

### `circular`

```bash
scripts/script.sh circular
```

Circular dependencies — how CJS and ESM handle cycles differently.

### `dual`

```bash
scripts/script.sh dual
```

Dual CJS/ESM packages — publishing libraries that work in both systems.

### `patterns`

```bash
scripts/script.sh patterns
```

Module design patterns — barrel files, re-exports, lazy loading, dynamic imports.

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
| `MODULE_DIR` | Data directory (default: ~/.module/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
