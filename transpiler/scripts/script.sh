#!/bin/bash
# Transpiler - Source-to-Source Code Transformation Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              TRANSPILER REFERENCE                           ║
║          Source-to-Source Code Transformation                ║
╚══════════════════════════════════════════════════════════════╝

Transpilers (source-to-source compilers) convert code from one
language or version to another at the same abstraction level.
Unlike compilers (high→low), transpilers stay at the same level.

COMMON TRANSPILERS:
  TypeScript → JavaScript     tsc
  Modern JS → Old JS          Babel, SWC
  JSX → JavaScript            Babel, SWC, esbuild
  Sass/SCSS → CSS             sass, dart-sass
  Less → CSS                  lessc
  PostCSS → CSS               postcss (autoprefixer)
  CoffeeScript → JavaScript   coffee
  Elm → JavaScript             elm
  ClojureScript → JavaScript  cljs
  ReScript → JavaScript       resc
  Dart → JavaScript           dart2js
  Cython → C                  cython
  Haxe → Many targets         haxe

TRANSPILER vs COMPILER:
  Transpiler     Same level (TS→JS, Sass→CSS)
  Compiler       Higher→Lower (C→machine code, Rust→binary)
  Interpreter    Executes directly (Python, Ruby)
  JIT            Compile at runtime (V8, JVM)
EOF
}

cmd_typescript() {
cat << 'EOF'
TYPESCRIPT & SWC
==================

TYPESCRIPT (tsc):
  npm install typescript
  npx tsc --init

  // tsconfig.json
  {
    "compilerOptions": {
      "target": "ES2022",          // Output JS version
      "module": "NodeNext",        // Module system
      "moduleResolution": "NodeNext",
      "lib": ["ES2022", "DOM"],    // Type libraries
      "outDir": "./dist",
      "rootDir": "./src",
      "strict": true,              // Enable all strict checks
      "esModuleInterop": true,
      "skipLibCheck": true,
      "forceConsistentCasingInImports": true,
      "declaration": true,         // Generate .d.ts files
      "declarationMap": true,      // Source maps for .d.ts
      "sourceMap": true,
      "noUnusedLocals": true,
      "noUnusedParameters": true,
      "noFallthroughCasesInSwitch": true,
      "resolveJsonModule": true,
      "isolatedModules": true,     // Required for SWC/esbuild
      "paths": {
        "@/*": ["./src/*"]         // Path aliases
      }
    },
    "include": ["src/**/*"],
    "exclude": ["node_modules", "dist"]
  }

  npx tsc                         # Compile
  npx tsc --watch                  # Watch mode
  npx tsc --noEmit                 # Type check only (use with bundler)

SWC (Rust-based, 20-70x faster than Babel):
  npm install @swc/cli @swc/core

  // .swcrc
  {
    "jsc": {
      "parser": { "syntax": "typescript", "tsx": true },
      "target": "es2022",
      "transform": {
        "react": { "runtime": "automatic" }
      }
    },
    "module": { "type": "es6" },
    "sourceMaps": true
  }

  npx swc src -d dist              # Transpile directory
  npx swc src/index.ts -o dist/index.js

  # SWC as Webpack loader
  // { test: /\.tsx?$/, use: 'swc-loader' }

  # SWC with Jest
  // transform: { "^.+\\.tsx?$": "@swc/jest" }
EOF
}

cmd_css_babel() {
cat << 'EOF'
CSS TRANSPILERS & BABEL
=========================

SASS/SCSS:
  npm install sass

  // styles.scss
  $primary: #3498db;
  $spacing: 8px;

  @mixin flex-center {
    display: flex;
    justify-content: center;
    align-items: center;
  }

  .card {
    background: $primary;
    padding: $spacing * 2;
    @include flex-center;

    &__title {        // BEM: .card__title
      font-size: 1.5rem;
    }
    &:hover {
      background: darken($primary, 10%);
    }
  }

  @use 'variables';   // Import from _variables.scss
  @use 'mixins';

  npx sass src/styles.scss dist/styles.css
  npx sass --watch src:dist

POSTCSS:
  npm install postcss postcss-cli autoprefixer cssnano

  // postcss.config.js
  module.exports = {
    plugins: [
      require('autoprefixer'),      // Add vendor prefixes
      require('cssnano'),           // Minify
      require('postcss-nesting'),   // CSS nesting (Stage 3)
      require('postcss-custom-media'),
    ],
  };

  npx postcss src/*.css -d dist/

TAILWIND (JIT transpiler):
  // Scans HTML/JSX → generates only used CSS classes
  // Not a traditional transpiler but compiles utility classes

BABEL:
  npm install @babel/core @babel/cli @babel/preset-env

  // babel.config.json
  {
    "presets": [
      ["@babel/preset-env", {
        "targets": "> 0.25%, not dead",
        "useBuiltIns": "usage",
        "corejs": 3,
        "modules": false
      }],
      ["@babel/preset-react", { "runtime": "automatic" }],
      "@babel/preset-typescript"
    ],
    "plugins": [
      "@babel/plugin-proposal-decorators",
      ["module-resolver", { "alias": { "@": "./src" } }]
    ]
  }

  npx babel src -d dist            # Transpile
  
  # Note: For new projects, prefer SWC over Babel (much faster)
  # Babel still relevant for: custom plugins, macro ecosystem

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Transpiler - Source-to-Source Transformation Reference

Commands:
  intro       Overview, transpiler types
  typescript  tsc config, SWC setup
  css_babel   Sass/SCSS, PostCSS, Babel

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)      cmd_intro ;;
  typescript) cmd_typescript ;;
  css_babel)  cmd_css_babel ;;
  help|*)     show_help ;;
esac
