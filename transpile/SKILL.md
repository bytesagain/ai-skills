---
name: "transpile"
version: "1.0.0"
description: "Transpilation reference — source-to-source compilation from TypeScript, JSX, CoffeeScript, Sass, and more. Use when understanding transpiler toolchains, configuring Babel/SWC/esbuild, or debugging source map issues."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [transpile, babel, typescript, swc, esbuild, source-maps, compiler]
category: "devtools"
---

# Transpile — Source-to-Source Compilation Reference

Quick-reference skill for transpilation — converting code from one language/version to another while preserving semantics.

## When to Use

- Configuring Babel, SWC, or esbuild for a project
- Understanding TypeScript → JavaScript compilation
- Debugging source map issues
- Comparing transpiler performance and features
- Setting up CSS preprocessing (Sass → CSS, PostCSS)

## Commands

### `intro`

```bash
scripts/script.sh intro
```

What transpilation is, transpile vs compile, common transpilation targets.

### `babel`

```bash
scripts/script.sh babel
```

Babel — presets, plugins, configuration, polyfills, and browserslist.

### `typescript`

```bash
scripts/script.sh typescript
```

TypeScript transpilation — tsc, type stripping, declaration files, tsconfig.

### `swc`

```bash
scripts/script.sh swc
```

SWC and esbuild — Rust/Go-based transpilers, speed benchmarks, migration.

### `sourcemaps`

```bash
scripts/script.sh sourcemaps
```

Source maps — how they work, debugging, inline vs external, VLQ encoding.

### `css`

```bash
scripts/script.sh css
```

CSS transpilation — Sass, Less, PostCSS, CSS Modules, Tailwind compilation.

### `targets`

```bash
scripts/script.sh targets
```

Target environments: browserslist, Node.js versions, ESM vs CJS output.

### `comparison`

```bash
scripts/script.sh comparison
```

Transpiler comparison: Babel vs SWC vs esbuild vs tsc — features, speed, trade-offs.

### `help`

```bash
scripts/script.sh help
```

### `version`

```bash
scripts/script.sh version
```

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
