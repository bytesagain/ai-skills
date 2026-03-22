#!/usr/bin/env bash
# transpile — Source-to-Source Compilation Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Transpilation ===

Transpilation (source-to-source compilation) transforms code from
one language or version to another at the same abstraction level.

Transpile vs Compile:
  Compile:     High-level → Low-level (C → machine code)
  Transpile:   High-level → High-level (TypeScript → JavaScript)
  Both are compilation — transpiling is a specific type.

Common Transpilation Targets:
  TypeScript     → JavaScript       (type stripping + downleveling)
  JSX/TSX        → JavaScript       (React createElement calls)
  ES2024         → ES5/ES2015       (modern JS → older JS)
  CoffeeScript   → JavaScript       (syntactic sugar removal)
  Sass/SCSS      → CSS              (variables, nesting, mixins)
  Less           → CSS              (similar to Sass)
  Dart           → JavaScript       (Flutter web)
  Kotlin         → JavaScript       (Kotlin/JS)
  Elm            → JavaScript       (functional → imperative)
  ClojureScript  → JavaScript       (Clojure → JS)
  Reason/ReScript→ JavaScript       (ML → JS)

Why Transpile:
  1. Use modern syntax today, support older browsers
  2. Type safety (TypeScript) without runtime overhead
  3. Better developer experience (JSX, decorators, pipeline)
  4. Compile away abstractions (Sass variables → CSS values)
  5. Platform compatibility (one source, multiple targets)

The JavaScript Transpilation Ecosystem:
  2009  CoffeeScript (first major JS transpiler)
  2012  TypeScript 0.8 (Microsoft)
  2014  Babel (6to5, then renamed) — ES6→ES5
  2015  ES2015 standard — major language update
  2020  esbuild (Go-based, 100x faster)
  2020  SWC (Rust-based, 20-70x faster than Babel)
  2022  Turbopack (Rust, Vercel) — uses SWC internally
  2024  Node.js 22 — native TypeScript type stripping

The Cost of Transpilation:
  Build time:     Seconds to minutes (depends on toolchain)
  Bundle size:     Polyfills add weight
  Debugging:       Source maps add complexity
  Maintenance:     Config files, version compatibility
  Correctness:     Edge cases in spec compliance
EOF
}

cmd_babel() {
    cat << 'EOF'
=== Babel ===

Babel is the most widely-used JavaScript transpiler.
Transforms modern JavaScript + JSX to backward-compatible versions.

--- Configuration (babel.config.json) ---
  {
    "presets": [
      ["@babel/preset-env", {
        "targets": "> 0.25%, not dead",
        "useBuiltIns": "usage",
        "corejs": 3
      }],
      "@babel/preset-react",
      "@babel/preset-typescript"
    ],
    "plugins": [
      "@babel/plugin-proposal-decorators",
      "@babel/plugin-transform-runtime"
    ]
  }

--- Presets (Bundles of Plugins) ---
  @babel/preset-env        Smart ES2015+ → target env downleveling
  @babel/preset-react      JSX → React.createElement
  @babel/preset-typescript Type stripping (no type checking)
  @babel/preset-flow       Flow type stripping

--- How preset-env Works ---
  1. Read targets (browserslist query)
  2. Check which features each target supports
  3. Include ONLY the transforms needed
  4. Optionally inject polyfills for missing APIs

  Example: If targeting Chrome 90+, most transforms are skipped.
  If targeting IE 11, nearly everything is transformed.

--- useBuiltIns Options ---
  false:    No polyfills (you handle it)
  "entry":  Replace one import with needed polyfills
  "usage":  Auto-inject polyfills per file (recommended)

--- Key Plugins ---
  @babel/plugin-transform-runtime
    Reuse Babel helper functions (reduces bundle size)
    Avoids polluting global scope with polyfills

  @babel/plugin-proposal-decorators
    Enables @decorator syntax

  @babel/plugin-transform-modules-commonjs
    ESM → CJS (require/module.exports)

--- CLI Usage ---
  npx babel src --out-dir dist              # transpile directory
  npx babel src/app.ts --out-file dist/app.js  # single file
  npx babel --config-file ./babel.config.json

--- Babel Pipeline ---
  Source Code
    → Parse (babylon/parser) → AST
    → Transform (plugins modify AST) → Modified AST
    → Generate (code + source map) → Output
EOF
}

cmd_typescript() {
    cat << 'EOF'
=== TypeScript Transpilation ===

TypeScript compilation has two jobs:
  1. Type checking (semantic analysis)
  2. Transpilation (emit JavaScript)

--- tsc (TypeScript Compiler) ---
  tsc                          # compile project (uses tsconfig.json)
  tsc --noEmit                 # type check only, no output
  tsc --watch                  # watch mode
  tsc --build                  # project references build
  tsc --declaration            # emit .d.ts files
  tsc --sourceMap              # emit source maps

--- tsconfig.json (Key Options) ---
  {
    "compilerOptions": {
      "target": "ES2022",         // output JS version
      "module": "ESNext",         // module system
      "moduleResolution": "bundler", // how to find modules
      "strict": true,             // all strict checks
      "outDir": "./dist",         // output directory
      "rootDir": "./src",         // input directory
      "declaration": true,        // emit .d.ts
      "sourceMap": true,          // emit .js.map
      "esModuleInterop": true,    // CJS/ESM interop
      "skipLibCheck": true,       // skip .d.ts checking (faster)
      "jsx": "react-jsx",        // JSX transform mode
    },
    "include": ["src/**/*"],
    "exclude": ["node_modules", "dist"]
  }

--- Target Options ---
  ES5       IE11 support (maximum downleveling)
  ES2015    Classes, arrow functions, let/const
  ES2017    async/await
  ES2020    Optional chaining, nullish coalescing
  ES2022    Top-level await, class fields, .at()
  ESNext    Latest features (no downleveling)

--- Type Stripping (No Type Checking) ---
  Modern approach: use SWC/esbuild for fast transpilation,
  run tsc --noEmit separately for type checking.

  // vite.config.ts
  // Vite uses esbuild for TS transpilation
  // Run tsc --noEmit in CI for type safety

  // Node.js 22+ (experimental):
  node --experimental-strip-types app.ts
  // Strips types at load time, no build step!

--- Declaration Files (.d.ts) ---
  Type information for libraries.
  Generated by tsc --declaration.
  Published to npm for TypeScript consumers.

  // package.json
  {
    "types": "./dist/index.d.ts",
    "main": "./dist/index.js"
  }

--- Isolated Declarations (TS 5.5+) ---
  --isolatedDeclarations
  Enforces that .d.ts files can be generated without type inference.
  Enables faster .d.ts emit by tools other than tsc.
EOF
}

cmd_swc() {
    cat << 'EOF'
=== SWC & esbuild — Fast Transpilers ===

--- SWC (Speedy Web Compiler) ---
  Written in Rust. Drop-in Babel replacement (mostly).

  Speed: 20-70x faster than Babel
  Supports: TypeScript, JSX, ES2015+ downleveling
  Used by: Next.js, Parcel 2, Deno, Turbopack

  Install: npm install -D @swc/core @swc/cli

  CLI:
    npx swc src -d dist                 # transpile directory
    npx swc src/app.ts -o dist/app.js   # single file

  Config (.swcrc):
    {
      "jsc": {
        "parser": { "syntax": "typescript", "tsx": true },
        "target": "es2020",
        "transform": { "react": { "runtime": "automatic" } }
      },
      "module": { "type": "es6" }
    }

--- esbuild ---
  Written in Go. Bundler + transpiler.

  Speed: 100x faster than Webpack+Babel
  Supports: TypeScript, JSX, CSS, code splitting
  Used by: Vite (dev server), Snowpack, tsup

  Install: npm install -D esbuild

  CLI:
    npx esbuild src/app.ts --bundle --outfile=dist/app.js
    npx esbuild src/app.ts --format=esm --target=es2020
    npx esbuild src/**/*.ts --outdir=dist --sourcemap

  API:
    const esbuild = require('esbuild');
    await esbuild.build({
      entryPoints: ['src/app.ts'],
      bundle: true,
      outfile: 'dist/app.js',
      target: ['es2020'],
      format: 'esm',
      sourcemap: true,
    });

--- Speed Benchmarks (10,000 files) ---
  Babel:     ~45s
  tsc:       ~25s
  SWC:       ~1.5s
  esbuild:   ~0.5s

  Why so fast:
    Babel/tsc: Single-threaded JavaScript
    SWC:       Multi-threaded Rust, efficient memory layout
    esbuild:   Multi-threaded Go, parallel AST processing

--- Limitations ---
  SWC:
    - Some Babel plugins have no SWC equivalent
    - Plugin ecosystem smaller than Babel
    - Config format differs from Babel

  esbuild:
    - No type checking (use tsc --noEmit separately)
    - Limited CSS modules support
    - No HMR (used with Vite which adds HMR)
    - Some edge cases in CommonJS handling
EOF
}

cmd_sourcemaps() {
    cat << 'EOF'
=== Source Maps ===

Source maps connect transpiled/minified code back to original source,
enabling debugging in browser DevTools with original code.

How It Works:
  1. Transpiler generates output.js + output.js.map
  2. output.js has comment: //# sourceMappingURL=output.js.map
  3. Browser DevTools load the .map file
  4. Debugger shows ORIGINAL source, not transpiled output
  5. Breakpoints, stack traces reference original files

Source Map Format (JSON):
  {
    "version": 3,
    "file": "output.js",
    "sourceRoot": "",
    "sources": ["input.ts"],
    "sourcesContent": ["original source..."],
    "names": ["myFunction", "result"],
    "mappings": "AAAA,SAAS,UAAU..."
  }

Mappings (VLQ Encoded):
  Base64 VLQ (Variable Length Quantity) encoding
  Each segment maps: generated col → source file, source line, source col, name
  Semicolons separate generated lines
  Commas separate segments within a line

  Example: AAAA = generated col 0, source 0, source line 0, source col 0

Types:
  External:    Separate .map file (production-friendly)
  Inline:      Embedded in JS as data URI (dev-friendly)
                //# sourceMappingURL=data:application/json;base64,...
  Hidden:      .map exists but no sourceMappingURL comment
               (upload to error tracking, not served to users)

Generating Source Maps:
  Babel:       { "sourceMaps": true }  or  --source-maps
  TypeScript:  { "sourceMap": true }   in tsconfig.json
  esbuild:     --sourcemap  or  --sourcemap=inline
  Webpack:     devtool: 'source-map'  (many options)
  Vite:        build.sourcemap: true

Webpack devtool Options:
  'source-map'            Full, separate file (best quality, slowest)
  'cheap-module-source-map' Line-level, with module mapping
  'eval-source-map'       Fast rebuild, inline (good for dev)
  'hidden-source-map'     No reference in bundle (upload to Sentry)
  false                   No source maps

Security Considerations:
  - Don't serve source maps in production (exposes source code)
  - Upload to error tracking (Sentry, Datadog) as hidden maps
  - Or restrict .map files via server config (nginx deny rule)
  - Source maps with sourcesContent include full original code
EOF
}

cmd_css() {
    cat << 'EOF'
=== CSS Transpilation ===

--- Sass/SCSS ---
  Most popular CSS preprocessor.

  Features transpiled away:
    $color: #3498db;            → hardcoded value
    .parent { .child { } }     → .parent .child { }
    @mixin btn($bg) { }        → inlined properties
    @include btn(red);          → expanded mixin
    @extend .base;              → merged selectors
    #{$var}-class               → interpolated string

  Tools:
    sass (Dart Sass):   sass src/style.scss dist/style.css
    node-sass:          Deprecated (use Dart Sass)
    sass-loader:        Webpack integration

--- Less ---
  Similar to Sass, JavaScript-based.

  @color: #3498db;             → variables
  .parent { .child { } }       → nesting
  .mixin() { }                  → mixins
  lessc src/style.less dist/style.css

--- PostCSS ---
  NOT a preprocessor — it's a CSS AST transformer.
  Plugin-based: each plugin does one transformation.

  Key plugins:
    autoprefixer       Add vendor prefixes (-webkit, -moz)
    postcss-preset-env Use future CSS syntax today
    postcss-nesting    CSS nesting (now native in CSS!)
    cssnano           Minify CSS
    postcss-import    Inline @import statements
    tailwindcss       Generate utility CSS from config

  postcss.config.js:
    module.exports = {
      plugins: [
        'postcss-import',
        'tailwindcss',
        'autoprefixer',
        'cssnano',
      ]
    };

--- CSS Modules ---
  Scope CSS class names to components (avoid global conflicts).

  /* Button.module.css */
  .primary { background: blue; }

  Transpiles to:
  .Button_primary_a1b2c { background: blue; }

  Unique hash per file → no naming conflicts.

--- Tailwind CSS Compilation ---
  Scans source files for class usage → generates minimal CSS.

  Full Tailwind: ~3.5 MB
  After purge: ~5-10 KB (only used classes)

  tailwindcss -i src/input.css -o dist/output.css --minify

--- Native CSS Evolution ---
  Many transpiled features are now native CSS:
    Custom properties:  var(--color)          ✓ All browsers
    Nesting:            .parent { .child {} }  ✓ Chrome 112+, FF 117+
    :has() selector:    .parent:has(.child)    ✓ Chrome 105+
    Container queries:  @container (min-width) ✓ Chrome 105+
    Color functions:    oklch(), color-mix()    ✓ Chrome 111+
EOF
}

cmd_targets() {
    cat << 'EOF'
=== Target Environments ===

--- Browserslist ---
  Standard for declaring browser support across tools.
  Used by: Babel, PostCSS/Autoprefixer, ESLint, Vite, etc.

  Config (.browserslistrc or package.json):
    > 0.5%                    Browsers with > 0.5% global usage
    last 2 versions           Last 2 major versions
    not dead                  Exclude discontinued browsers
    not ie 11                 Exclude IE 11 specifically
    Firefox ESR               Firefox Extended Support Release
    maintained node versions  Currently supported Node.js

  Common presets:
    "> 0.5%, last 2 versions, not dead"        (reasonable default)
    "defaults"                                  (equivalent to above)
    "> 0.25%, not dead"                         (wider support)
    "last 1 chrome version"                     (dev/testing only)

  Check what your query covers:
    npx browserslist "> 0.5%, last 2 versions, not dead"

--- Node.js Targets ---
  Node 16: ES2021 features + CommonJS
  Node 18: ES2022 + native fetch + test runner
  Node 20: ES2023 + stable test runner
  Node 22: ES2024 + experimental TS stripping

  tsconfig.json targets for Node:
    Node 18 → "target": "ES2022", "module": "Node16"
    Node 20 → "target": "ES2023", "module": "NodeNext"

--- Module Output Formats ---
  ESM (ES Modules):
    import { foo } from './bar.js'
    export const baz = 42
    Static analysis, tree-shaking, native browser support

  CJS (CommonJS):
    const { foo } = require('./bar')
    module.exports = { baz: 42 }
    Node.js traditional format, synchronous loading

  UMD (Universal Module Definition):
    Works in CJS, AMD, and browser globals
    Fallback for library distribution
    Being phased out in favor of ESM

  IIFE (Immediately Invoked Function Expression):
    (function() { /* code */ })()
    Browser scripts, no module system needed

--- Dual Package Shipping ---
  Package supports both ESM and CJS consumers:

  // package.json
  {
    "type": "module",
    "main": "./dist/index.cjs",      // CJS entry
    "module": "./dist/index.mjs",    // ESM entry (bundlers)
    "exports": {
      ".": {
        "import": "./dist/index.mjs",
        "require": "./dist/index.cjs"
      }
    }
  }
EOF
}

cmd_comparison() {
    cat << 'EOF'
=== Transpiler Comparison ===

┌──────────────┬───────────┬───────────┬───────────┬──────────┐
│              │ Babel     │ tsc       │ SWC       │ esbuild  │
├──────────────┼───────────┼───────────┼───────────┼──────────┤
│ Language     │ JavaScript│ TypeScript│ Rust      │ Go       │
│ Speed        │ 1x (base)│ 1.5-2x    │ 20-70x   │ 50-100x  │
│ Type check   │ No       │ Yes       │ No        │ No       │
│ JSX          │ Yes      │ Yes       │ Yes       │ Yes      │
│ TypeScript   │ Strip    │ Full      │ Strip     │ Strip    │
│ Decorators   │ Yes      │ Yes       │ Yes       │ Limited  │
│ Plugins      │ 1000+    │ Transform │ Growing   │ Limited  │
│ Source maps  │ Yes      │ Yes       │ Yes       │ Yes      │
│ Minify       │ w/Terser │ No        │ Yes       │ Yes      │
│ Bundle       │ No       │ No        │ w/webpack │ Yes      │
│ CSS          │ No       │ No        │ No        │ Basic    │
│ Tree-shake   │ No       │ No        │ No        │ Yes      │
│ Config       │ Complex  │ Moderate  │ Simple    │ Simple   │
│ Maturity     │ 2014     │ 2012      │ 2019      │ 2020     │
└──────────────┴───────────┴───────────┴───────────┴──────────┘

Recommended Combinations:
  1. Vite (dev) + esbuild (dev transpile) + Rollup (prod build)
     Best for: Modern web apps, fast development

  2. Next.js → SWC (built-in, replaces Babel)
     Best for: React apps, SSR, full-stack

  3. tsc --noEmit (type check) + esbuild (transpile)
     Best for: Libraries, type-safe builds

  4. Babel (when you need specific plugins)
     Best for: Legacy projects, custom transforms

  5. tsup (uses esbuild) for library publishing
     Best for: npm packages, dual CJS/ESM output

When to Use Which:
  Need max compatibility  → Babel (most plugins, battle-tested)
  Need type checking      → tsc (only option for full checking)
  Need speed              → esbuild or SWC
  Need SSR/Next.js        → SWC (built-in)
  Need library publish    → tsup (esbuild) + tsc --emitDeclarationOnly
  Need custom AST plugin  → Babel (richest plugin API)
EOF
}

show_help() {
    cat << EOF
transpile v$VERSION — Source-to-Source Compilation Reference

Usage: script.sh <command>

Commands:
  intro        What transpilation is, ecosystem overview
  babel        Babel presets, plugins, polyfills, browserslist
  typescript   tsc options, tsconfig, type stripping, declarations
  swc          SWC and esbuild: Rust/Go speed, configuration
  sourcemaps   Source maps: format, debugging, security
  css          CSS transpilation: Sass, PostCSS, CSS Modules
  targets      Target environments: browserslist, Node, ESM/CJS
  comparison   Babel vs SWC vs esbuild vs tsc comparison
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    babel)      cmd_babel ;;
    typescript) cmd_typescript ;;
    swc)        cmd_swc ;;
    sourcemaps) cmd_sourcemaps ;;
    css)        cmd_css ;;
    targets)    cmd_targets ;;
    comparison) cmd_comparison ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "transpile v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
