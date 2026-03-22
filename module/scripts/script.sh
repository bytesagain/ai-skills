#!/usr/bin/env bash
# module — Module Systems Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Module Systems ===

Modules organize code into self-contained units with explicit
dependencies and exports. They solve:
  - Namespace pollution (global variable conflicts)
  - Dependency management (what depends on what)
  - Code reuse (share functionality across files/projects)
  - Encapsulation (hide implementation details)

History of JavaScript Modules:
  1995   JavaScript born — no module system, everything global
  2004   Namespacing: var MyApp = { utils: { ... } }
  2007   CommonJS spec drafted (synchronous require/exports)
  2009   Node.js adopts CommonJS
  2011   AMD (Asynchronous Module Definition) for browsers
         RequireJS popular, define(deps, factory) pattern
  2011   UMD (Universal Module Definition) — CJS + AMD + global
  2015   ES Modules standardized in ES2015 (import/export)
  2017   Node.js begins experimental ESM support
  2020   Node.js 14+ stable ESM support
  2023   ESM becomes dominant, CJS still widely used

Module Systems Overview:
  CommonJS (CJS):  require() / module.exports
    Synchronous, dynamic, value copying
    Default in Node.js (.js files without "type": "module")
    
  ES Modules (ESM): import/export
    Asynchronous, static, live bindings
    Standard in browsers, Node.js (.mjs or "type": "module")

  AMD:  define(['dep'], function(dep) { ... })
    Asynchronous, browser-focused, largely obsolete
    
  UMD:  wrapper that works in CJS, AMD, and global contexts
    Still seen in legacy libraries

  SystemJS: dynamic module loader, polyfills ESM for old browsers

Current Best Practice:
  - New projects: use ESM (import/export)
  - Libraries: publish both CJS and ESM (dual packages)
  - Node.js: set "type": "module" in package.json
  - Browsers: <script type="module"> with bundler
EOF
}

cmd_esm() {
    cat << 'EOF'
=== ES Modules (ESM) ===

Named Exports/Imports:
  // utils.js
  export const PI = 3.14159;
  export function add(a, b) { return a + b; }
  export class Vector { ... }

  // main.js
  import { PI, add, Vector } from './utils.js';
  import { add as sum } from './utils.js';  // rename
  import * as utils from './utils.js';      // namespace

Default Export/Import:
  // logger.js
  export default class Logger { ... }
  // or: export default function createLogger() { ... }

  // main.js
  import Logger from './logger.js';
  import MyLogger from './logger.js';  // any name works

  Rule: one default export per module
  Can combine: import Logger, { LogLevel } from './logger.js';

Re-exports:
  export { foo, bar } from './module.js';      // re-export named
  export { default } from './module.js';        // re-export default
  export { foo as default } from './module.js'; // named → default
  export * from './module.js';                  // all named exports
  export * as ns from './module.js';            // namespace re-export

Key Characteristics:
  Static structure: imports/exports determined at parse time
    - Can't use import inside if/else
    - Enables tree shaking and static analysis
    - Import statements are hoisted

  Live bindings: imported value reflects exporter's changes
    // counter.js
    export let count = 0;
    export function increment() { count++; }
    
    // main.js
    import { count, increment } from './counter.js';
    console.log(count);  // 0
    increment();
    console.log(count);  // 1 (live binding!)

  Asynchronous evaluation: modules loaded asynchronously
  Strict mode: ESM is always in strict mode (no "use strict" needed)
  this is undefined: at module top level (not globalThis)

Dynamic Import:
  const module = await import('./heavy-module.js');
  // Returns a module namespace object
  // Works in both ESM and CJS contexts
  // Enables code splitting and lazy loading

Top-Level Await (ES2022):
  // config.js
  const response = await fetch('/config.json');
  export const config = await response.json();
  // Importing modules wait for this to resolve
EOF
}

cmd_commonjs() {
    cat << 'EOF'
=== CommonJS (CJS) ===

Basic Syntax:
  // Exporting
  module.exports = { add, subtract };      // object
  module.exports = function createApp() {} // single export
  exports.add = function(a, b) { ... };    // named export shorthand

  // Importing
  const { add, subtract } = require('./math');
  const fs = require('fs');
  const app = require('./app');

exports vs module.exports:
  exports is a shortcut to module.exports
  exports.foo = 'bar'  →  module.exports.foo = 'bar'
  
  BUT: reassigning exports breaks the reference:
    exports = { foo: 'bar' };  // BROKEN — doesn't change module.exports
    module.exports = { foo: 'bar' };  // WORKS

Key Characteristics:
  Synchronous loading: require() blocks until module is loaded
  Dynamic: can require() inside conditionals, loops, functions
    if (env === 'prod') {
      const logger = require('./prod-logger');
    }
  Value copying: imported values are copies, not live bindings
    // counter.js
    let count = 0;
    exports.count = count;
    exports.increment = () => { count++; };
    
    // main.js
    const { count, increment } = require('./counter');
    increment();
    console.log(count);  // still 0! (value was copied)

Module Caching:
  require() caches modules after first load
  Second require('./foo') returns cached exports (no re-execution)
  Cache is per-process: require.cache object
  
  Force reload (not recommended):
    delete require.cache[require.resolve('./module')];

require.resolve():
  Returns full path without loading the module
  require.resolve('express')
  // → '/project/node_modules/express/index.js'
  Useful for checking if module exists (try/catch)

Module Wrapper:
  Node.js wraps every module in a function:
  (function(exports, require, module, __filename, __dirname) {
    // your code here
  });
  This is why __filename and __dirname exist
  This is why top-level variables are module-scoped, not global

JSON Loading:
  const config = require('./config.json');
  // Parsed automatically, returns JavaScript object
  // Works in CJS, not in ESM without import assertion
EOF
}

cmd_resolution() {
    cat << 'EOF'
=== Module Resolution Algorithms ===

Node.js Resolution (CJS):
  require('X') from /home/user/project/src/app.js

  1. Core module? (fs, path, http) → return built-in
  2. Starts with './' or '../' or '/'? → file/directory resolution:
     a. Try exact path: X, X.js, X.json, X.node
     b. Try directory: X/index.js, X/index.json, X/index.node
     c. Check X/package.json "main" field
  3. Bare specifier (no ./ prefix) → node_modules resolution:
     a. /home/user/project/src/node_modules/X
     b. /home/user/project/node_modules/X
     c. /home/user/node_modules/X
     d. /home/node_modules/X
     e. /node_modules/X
     Walk up until found or root reached

Node.js Resolution (ESM):
  import 'X' — stricter than CJS:
  - File extensions REQUIRED: import './foo.js' (not './foo')
  - No index.js auto-resolution
  - No JSON without import assertion
  - No __filename/__dirname (use import.meta.url)
  - Bare specifiers resolved via node_modules + package.json exports

TypeScript Resolution Modes:
  "moduleResolution": "node" (classic Node CJS algorithm)
  "moduleResolution": "node16" / "nodenext" (ESM-aware)
  "moduleResolution": "bundler" (webpack/vite-style, most flexible)

  node16/nodenext:
    - Respects package.json "exports" field
    - Requires file extensions in relative imports
    - Follows ESM vs CJS rules based on file extension

  bundler:
    - No file extension required
    - Reads "exports" field
    - Allows importing .ts files directly
    - Most permissive mode (recommended for bundled apps)

Import Maps (Browsers):
  <script type="importmap">
  {
    "imports": {
      "lodash": "/node_modules/lodash-es/lodash.js",
      "@/": "/src/"
    }
  }
  </script>
  Bare specifiers in browser without bundler!

Path Aliases:
  TypeScript: "paths" in tsconfig.json
    "@/*": ["./src/*"]
  Webpack: resolve.alias
  Vite: resolve.alias
  Jest: moduleNameMapper
  All must be configured consistently!
EOF
}

cmd_packagejson() {
    cat << 'EOF'
=== Package.json Module Fields ===

"type" Field:
  "type": "module"     → .js files are ESM
  "type": "commonjs"   → .js files are CJS (default)
  Override per-file:
    .mjs always ESM regardless of "type"
    .cjs always CJS regardless of "type"

"main" Field (legacy):
  "main": "./dist/index.js"
  CJS entry point for require('package-name')
  Used by older Node.js and tools

"module" Field (unofficial):
  "module": "./dist/index.mjs"
  ESM entry point — used by bundlers (webpack, rollup)
  NOT used by Node.js (not part of Node spec)

"exports" Field (modern, recommended):
  Conditional exports — replaces "main" and "module"

  Simple:
    "exports": "./dist/index.js"

  Conditional:
    "exports": {
      "import": "./dist/index.mjs",
      "require": "./dist/index.cjs",
      "default": "./dist/index.js"
    }

  Subpath exports:
    "exports": {
      ".": {
        "import": "./dist/index.mjs",
        "require": "./dist/index.cjs"
      },
      "./utils": {
        "import": "./dist/utils.mjs",
        "require": "./dist/utils.cjs"
      },
      "./package.json": "./package.json"
    }

  Condition order matters — first match wins:
    "node", "import", "require", "default"
    "types" (TypeScript), "browser", "development", "production"

  Encapsulation: only exported paths are importable
    import 'pkg/internal/secret'  → ERR_PACKAGE_PATH_NOT_EXPORTED

"imports" Field (private aliases):
  "imports": {
    "#utils": "./src/utils/index.js",
    "#config": {
      "development": "./config/dev.json",
      "production": "./config/prod.json"
    }
  }
  // Usage: import utils from '#utils';
  Must start with # (required prefix)

"types" / "typesVersions":
  "types": "./dist/index.d.ts"
  TypeScript type definitions entry point
  In exports: "types" condition should come FIRST

Priority Order:
  Node.js: "exports" > "main"
  Bundlers: "exports" > "module" > "main"
  TypeScript: "exports" (with "types" condition) > "types" > "main"
EOF
}

cmd_circular() {
    cat << 'EOF'
=== Circular Dependencies ===

What Is a Circular Dependency?
  Module A imports Module B, and Module B imports Module A
  A → B → A (cycle)
  More complex: A → B → C → A

CommonJS Circular Behavior:
  CJS returns a PARTIAL export object during cycles

  // a.js
  console.log('a: start');
  exports.fromA = 'hello';
  const b = require('./b');  // triggers b.js execution
  console.log('a: b.fromB =', b.fromB);
  exports.afterB = 'done';

  // b.js
  console.log('b: start');
  const a = require('./a');  // returns PARTIAL a exports!
  console.log('b: a.fromA =', a.fromA);   // 'hello' ✓
  console.log('b: a.afterB =', a.afterB); // undefined! ✗
  exports.fromB = 'world';

  Execution order:
    a: start
    b: start
    b: a.fromA = hello      (set before require('./b'))
    b: a.afterB = undefined  (not yet set when b runs)
    a: b.fromB = world

ES Module Circular Behavior:
  ESM uses live bindings — variables update across modules

  // a.mjs
  import { fromB } from './b.mjs';
  export let fromA = 'hello';
  console.log('a:', fromB);  // works (live binding)

  // b.mjs
  import { fromA } from './a.mjs';
  export let fromB = 'world';
  console.log('b:', fromA);  // works IF fromA is initialized

  BUT: if accessing before initialization → TDZ error
  let/const in TDZ if accessed before declaration executed

Detection:
  Tools: madge, circular-dependency-plugin (webpack)
  ESLint: import/no-cycle rule
  CLI: npx madge --circular src/

Fixing Circular Dependencies:
  1. Extract shared code into a third module
     A → Shared ← B (no cycle)

  2. Dependency inversion
     A depends on interface, B implements it
     Instead of A → B, both depend on abstraction

  3. Lazy require (CJS only)
     Move require() inside the function that needs it
     function doSomething() {
       const b = require('./b');  // loaded when called, not at startup
     }

  4. Dynamic import (ESM)
     async function doSomething() {
       const { foo } = await import('./b.mjs');
     }

  5. Event-based decoupling
     A emits events, B listens (no direct import of B by A)
EOF
}

cmd_dual() {
    cat << 'EOF'
=== Dual CJS/ESM Packages ===

Why Dual Publish?
  Some consumers use require(), others use import
  Libraries need to work in both contexts
  During CJS → ESM transition period (2020s)

Strategy 1: Conditional Exports (Recommended)
  package.json:
    {
      "name": "my-lib",
      "type": "module",
      "exports": {
        ".": {
          "types": "./dist/index.d.ts",
          "import": "./dist/index.mjs",
          "require": "./dist/index.cjs"
        }
      }
    }

  Build both formats from same source:
    tsup, unbuild, pkgroll, rollup — all support dual output

Strategy 2: ESM Wrapper
  Ship CJS as main, provide thin ESM wrapper

  // index.cjs (real implementation)
  module.exports = { add, subtract };

  // index.mjs (wrapper)
  import pkg from './index.cjs';
  export const { add, subtract } = pkg;

  Pros: no code duplication, single source
  Cons: named exports must be listed explicitly

The Dual Package Hazard:
  If both CJS and ESM versions are loaded in same process:
  - Two copies of the module state exist
  - Singletons break (instanceof fails across copies)
  - State is not shared between CJS and ESM instances

  Mitigation:
    - Use stateless exports when possible
    - Package "exports" usually prevents dual loading
    - Document: "use import OR require, not both"

File Extension Strategy:
  Option A: "type": "module", use .cjs for CJS files
  Option B: "type": "commonjs", use .mjs for ESM files
  Option C: always use explicit extensions (.cjs, .mjs)

TypeScript Configuration:
  tsconfig for ESM: "module": "ES2020", "moduleResolution": "node16"
  tsconfig for CJS: "module": "commonjs", "moduleResolution": "node"
  Or use tsup/unbuild which handle this automatically

Testing Both Formats:
  Test CJS: node -e "const lib = require('./dist/index.cjs'); ..."
  Test ESM: node -e "import('./dist/index.mjs').then(lib => ...)"
  Use both in CI to catch format-specific bugs

Popular Dual-Build Tools:
  tsup:     zero-config TypeScript bundler (recommended)
  unbuild:  used by unjs/nuxt ecosystem
  pkgroll:  rollup wrapper for packages
  rollup:   flexible, more config needed
  esbuild:  fast, manual config for dual output
EOF
}

cmd_patterns() {
    cat << 'EOF'
=== Module Design Patterns ===

Barrel Files (Re-export Index):
  // src/components/index.js
  export { Button } from './Button';
  export { Modal } from './Modal';
  export { Input } from './Input';

  // Consumer:
  import { Button, Modal } from './components';

  Pros: clean import paths, organized API
  Cons: can defeat tree shaking (import everything, shake nothing)
  Tip: use with bundlers that handle barrel file optimization

Lazy Loading (Dynamic Import):
  // Load module only when needed
  button.onclick = async () => {
    const { Chart } = await import('./Chart.js');
    const chart = new Chart(data);
  };

  React.lazy:
    const LazyComponent = React.lazy(() => import('./HeavyComponent'));
  
  Vue async components:
    defineAsyncComponent(() => import('./HeavyComponent.vue'))

  Route-based code splitting:
    const routes = {
      '/dashboard': () => import('./pages/Dashboard'),
      '/settings': () => import('./pages/Settings'),
    };

Singleton Module Pattern:
  // ESM: module-level state is singleton by default
  let instance;
  export function getInstance() {
    if (!instance) instance = createExpensiveObject();
    return instance;
  }
  // Same instance returned to all importers

Factory Module:
  // Export factory function, not instance
  export function createDatabase(config) {
    return { query: ..., close: ... };
  }
  // Each consumer gets own instance

Adapter/Facade Module:
  // Wrap complex/unstable dependency behind stable API
  // src/http.js
  import axios from 'axios';
  export function get(url) { return axios.get(url).then(r => r.data); }
  export function post(url, data) { return axios.post(url, data).then(r => r.data); }
  // If you switch from axios to fetch, only this file changes

Namespace Module:
  // Group related utilities under namespace export
  export * as math from './math';
  export * as string from './string';
  export * as date from './date';
  // import { math, string } from './utils';
  // math.add(1, 2);

Plugin Module Pattern:
  // Core exports a register function
  export function registerPlugin(plugin) {
    plugins.push(plugin);
    plugin.init(coreAPI);
  }
  // Plugins export install function
  export function install(api) { ... }

Configuration Module:
  // Merge defaults with environment
  const defaults = { port: 3000, debug: false };
  const env = { port: process.env.PORT };
  export const config = { ...defaults, ...env };
  // Importers get resolved configuration
EOF
}

show_help() {
    cat << EOF
module v$VERSION — Module Systems Reference

Usage: script.sh <command>

Commands:
  intro        Module systems overview — history, CJS vs ESM
  esm          ES Modules — import/export, live bindings, dynamic import
  commonjs     CommonJS — require/exports, caching, wrapper
  resolution   Module resolution algorithms (Node, TS, bundler)
  packagejson  Package.json fields: main, module, exports, imports
  circular     Circular dependencies — behavior and fixes
  dual         Dual CJS/ESM packages — publishing for both
  patterns     Module design patterns — barrel, lazy, singleton, adapter
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)       cmd_intro ;;
    esm)         cmd_esm ;;
    commonjs)    cmd_commonjs ;;
    resolution)  cmd_resolution ;;
    packagejson) cmd_packagejson ;;
    circular)    cmd_circular ;;
    dual)        cmd_dual ;;
    patterns)    cmd_patterns ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "module v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
