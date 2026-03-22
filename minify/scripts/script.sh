#!/usr/bin/env bash
# minify — Code Minification Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Code Minification ===

Minification removes unnecessary characters from source code without
changing functionality, reducing file size for faster delivery.

What Gets Removed/Changed:
  - Whitespace (spaces, tabs, newlines)
  - Comments (single-line, multi-line, JSDoc)
  - Unnecessary semicolons and brackets
  - Variable names shortened (mangling)
  - Dead code eliminated
  - Constant expressions pre-computed

Performance Impact:
  Typical reduction (JavaScript):
    Original:       100 KB
    Minified:        45 KB (55% reduction)
    Minified + gzip:  15 KB (85% total reduction)

  Why it matters:
    - Faster download (especially mobile/slow networks)
    - Reduced bandwidth costs
    - Faster parsing (fewer characters to process)
    - Smaller cache footprint

Minification vs Compression:
  Minification: transforms code (irreversible without source map)
  Compression: encodes bytes (gzip/brotli, reversible by browser)
  Use BOTH: minify first, then compress for transport
  They're complementary, not alternatives

Minification vs Obfuscation:
  Minification: goal is size reduction, readability loss is side effect
  Obfuscation: goal is making code unreadable, may increase size
  Minifiers mangle names for size; obfuscators transform logic for secrecy

Build Pipeline Position:
  Source → Transpile (TS/Babel) → Bundle (webpack/rollup) → Minify → Output
  Modern tools combine steps: esbuild, SWC do all at once
EOF
}

cmd_javascript() {
    cat << 'EOF'
=== JavaScript Minification Techniques ===

1. Whitespace & Comment Removal:
  Before: function  add( a,  b ) {  // sum
            return  a + b;
          }
  After:  function add(a,b){return a+b}

2. Variable Name Mangling:
  Before: function calculateTotalPrice(items, taxRate) {
            const subtotal = items.reduce((s, i) => s + i.price, 0);
            return subtotal * (1 + taxRate);
          }
  After:  function a(e,t){const n=e.reduce((e,t)=>e+t.price,0);return n*(1+t)}

  Rules:
    - Only local variables/parameters are mangled
    - Global variables preserved (window, document, etc.)
    - Property names NOT mangled by default (would break APIs)
    - Reserved words never used as names
    - Shortest names used for most-referenced variables

3. Dead Code Elimination (DCE):
  Removes code that can never execute:
    if (false) { /* removed */ }
    if (process.env.NODE_ENV === 'production') { /* kept */ }
    const unused = 42; // removed if never referenced

4. Constant Folding:
  Pre-computes constant expressions:
    const x = 2 * 3 * 7;  →  const x = 42;
    "hello" + " " + "world"  →  "hello world"
    !true  →  false

5. Boolean & Comparison Simplification:
    true  → !0     (saves 2 bytes)
    false → !1     (saves 3 bytes)
    if (x !== undefined) → if (x != null)  (catches both)

6. Function Inlining:
  Short functions may be inlined at call sites:
    const double = x => x * 2;
    result = double(5);
  →  result = 5 * 2;   (then constant-folded to: result = 10)

7. Property Access Optimization:
    a["property"]  →  a.property  (saves 2 bytes)
    (only when property name is valid identifier)

8. Sequence Expressions:
  Multiple statements collapsed into comma expressions:
    a = 1; b = 2; c = 3;  →  a=1,b=2,c=3

9. Conditional Simplification:
    if (a) b();           →  a&&b()
    if (a) b(); else c(); →  a?b():c()
    if (!a) return;       →  if(a)  (with remaining code)
EOF
}

cmd_css() {
    cat << 'EOF'
=== CSS Minification Techniques ===

1. Whitespace & Comment Removal:
  Before: .header {
            /* Main header styles */
            margin: 0px;
            padding: 10px 20px;
          }
  After:  .header{margin:0;padding:10px 20px}

2. Shorthand Property Merging:
  Before: margin-top: 10px;
          margin-right: 20px;
          margin-bottom: 10px;
          margin-left: 20px;
  After:  margin:10px 20px

  Shorthand properties:
    margin, padding, border, background, font,
    animation, transition, flex, grid

3. Value Optimization:
  Colors:
    #ffffff → #fff
    #ff0000 → red (named color is shorter)
    rgb(255, 0, 0) → red
    rgba(0,0,0,0.5) → #00000080 (hex with alpha)

  Units:
    0px → 0 (zero needs no unit)
    0.5em → .5em (leading zero removed)
    100.0px → 100px (trailing zero removed)

  Functions:
    calc(100% - 0px) → 100%
    rotateZ(45deg) → rotate(45deg)

4. Selector Deduplication:
  Merge identical selectors:
    .a { color: red }   →   .a, .b { color: red }
    .b { color: red }

  Merge identical declaration blocks:
    .a { color: red; font: bold }
    .a { margin: 0 }
  →  .a { color: red; font: bold; margin: 0 }

5. Duplicate Property Removal:
    .a { color: red; color: blue }  →  .a { color: blue }
    (keeps last declaration, which is what CSS would use)

6. @charset Optimization:
    Remove redundant @charset if UTF-8 (default)
    Only first @charset rule is valid

7. Media Query Merging:
    Combine identical @media rules:
    @media (min-width: 768px) { .a { ... } }
    @media (min-width: 768px) { .b { ... } }
  →  @media (min-width: 768px) { .a { ... } .b { ... } }

8. Unused CSS Removal (PurgeCSS):
    Scan HTML/JS for used selectors
    Remove CSS rules with no matching elements
    Typical reduction: 80-95% for utility frameworks (Tailwind)
    ⚠ Dynamic classes may be falsely removed
EOF
}

cmd_html() {
    cat << 'EOF'
=== HTML Minification Techniques ===

1. Whitespace Collapsing:
  Multiple spaces/newlines → single space
  Leading/trailing whitespace in inline elements: collapse
  Whitespace between block elements: remove entirely
  ⚠ Preserve whitespace in <pre>, <code>, <textarea>

2. Comment Removal:
  Remove all HTML comments: <!-- ... -->
  Exception: conditional comments for IE (<!--[if IE]>)
  Exception: SSI includes (<!--# ... -->)
  Exception: license/legal comments (configurable)

3. Attribute Optimization:
  Remove quotes when safe:
    class="header"  →  class=header
    (only when value has no spaces or special chars)
  Remove default values:
    type="text" on <input>         → removable (text is default)
    method="get" on <form>         → removable (get is default)
    type="text/javascript" on <script> → removable (HTML5 default)
  Boolean attributes:
    disabled="disabled"  →  disabled
    checked="checked"    →  checked
    readonly="readonly"  →  readonly

4. Tag Omission (HTML5):
  Optional closing tags that can be safely removed:
    </li>, </dt>, </dd>, </p>, </tr>, </td>, </th>
    </head>, </body>, </html> (yes, these are optional in HTML5)
  ⚠ Risky if CSS/JS relies on DOM structure assumptions

5. Inline CSS/JS Minification:
  Minify contents of <style> tags (CSS minifier)
  Minify contents of <script> tags (JS minifier)
  Remove type attributes for default types

6. URL Optimization:
  Protocol-relative: https://example.com → //example.com
    (deprecated practice, prefer explicit https)
  Remove trailing slashes on void elements
  Simplify data URIs where possible

7. Conditional Processing:
  Remove server-side template comments
  Remove development-only debug elements
  Collapse whitespace-only text nodes

Typical HTML Savings:
  Simple page: 5-15% reduction
  Template-heavy page: 15-25% reduction
  Less impactful than JS/CSS minification
  Still worthwhile for high-traffic sites
EOF
}

cmd_tools() {
    cat << 'EOF'
=== Minification Tools Compared ===

JavaScript Minifiers:

  Terser (successor to UglifyJS):
    Language: JavaScript
    Speed: ~20 MB/s
    Features: full ES2015+ support, mangling, compression
    Ecosystem: webpack default (TerserPlugin)
    Quality: best compression ratio, most options
    Use when: maximum size reduction, complex configurations

  esbuild:
    Language: Go (compiled binary)
    Speed: ~1000 MB/s (50x faster than Terser)
    Features: bundler + minifier + transpiler
    Quality: good compression, slightly larger than Terser (~2-5%)
    Use when: speed matters, development builds, large codebases

  SWC (Speedy Web Compiler):
    Language: Rust (compiled binary)
    Speed: ~700 MB/s (35x faster than Terser)
    Features: transpiler + minifier (swc-minify)
    Quality: comparable to Terser, improving rapidly
    Use when: Rust toolchain, Next.js projects

  Google Closure Compiler:
    Language: Java
    Speed: slow
    Features: ADVANCED mode rewrites entire program
    Quality: best possible compression (but breaks code if not annotated)
    Use when: Google-scale projects with full type annotations

CSS Minifiers:

  cssnano:
    Most popular, PostCSS-based
    Modular presets (default, advanced)
    ~30% reduction on typical CSS
    Use with: PostCSS, webpack

  Lightning CSS (formerly Parcel CSS):
    Written in Rust, extremely fast
    Also handles vendor prefixing, transpiling
    Replaces: autoprefixer + cssnano
    Growing adoption

  clean-css:
    Standalone, no PostCSS dependency
    Good compression, stable, fewer features
    Good for simple build scripts

HTML Minifiers:

  html-minifier-terser:
    Most options and best compression
    Configurable per-feature toggling
    Can minify inline JS/CSS

  htmlnano:
    PostHTML-based, modular
    Safe presets available

Speed Benchmark (approximate, large codebase):
  Tool         Speed      Output Size
  esbuild      50ms       102 KB
  SWC          70ms       101 KB
  Terser       3500ms     98 KB
  Closure      12000ms    95 KB
EOF
}

cmd_sourcemaps() {
    cat << 'EOF'
=== Source Maps ===

What Are Source Maps?
  JSON files that map minified code back to original source
  Enable debugging minified code in browser DevTools
  File extension: .map (e.g., app.min.js.map)

How They Work:
  Minified file has comment pointing to map:
    //# sourceMappingURL=app.min.js.map

  Browser DevTools:
    1. Loads minified JS
    2. Finds sourceMappingURL comment
    3. Fetches the .map file
    4. Shows original source in Sources panel
    5. Maps breakpoints, stack traces to original lines

Source Map Structure (V3):
  {
    "version": 3,
    "file": "app.min.js",
    "sources": ["src/utils.js", "src/app.js"],
    "sourcesContent": ["original source..."],
    "names": ["calculateTotal", "items", "tax"],
    "mappings": "AAAA,SAASA,IACT..."
  }

  mappings: VLQ-encoded segments
    Each segment: [genCol, sourceIdx, origLine, origCol, nameIdx]
    Base64 VLQ encoding for compact representation

Source Map Options:
  Inline source map:
    Embedded in JS file as data URI (base64)
    //# sourceMappingURL=data:application/json;base64,...
    Larger file but no extra HTTP request
    Good for: development only

  External source map:
    Separate .map file
    Minified file references it via comment
    Good for: production (serve maps only to DevTools)

  Hidden source map:
    Generate .map file but NO sourceMappingURL comment
    Upload to error tracking service (Sentry, Bugsnag)
    Users can't access source, but errors are readable
    Good for: production error monitoring

Security Considerations:
  Source maps expose original source code
  Options:
    1. Don't deploy source maps (no debugging)
    2. Restrict access (auth, IP whitelist)
    3. Hidden source maps (error services only)
    4. Strip sensitive comments before mapping

Generating Source Maps:
  Terser:    terser input.js --source-map -o output.min.js
  esbuild:   esbuild input.js --minify --sourcemap
  webpack:   devtool: 'source-map' (many options)
  TypeScript: "sourceMap": true in tsconfig.json
  Sass:       sass --source-map input.scss output.css
EOF
}

cmd_treeshake() {
    cat << 'EOF'
=== Tree Shaking ===

What Is Tree Shaking?
  Dead code elimination for ES modules
  Removes unused exports from bundles
  Name from: "shake the tree, dead leaves fall off"
  Only works with static import/export (ES modules)

How It Works:
  1. Bundler builds dependency graph from imports
  2. Marks which exports are actually imported
  3. Removes unreachable exports and their dependencies
  4. Minifier removes remaining dead code

Requirements:
  - ES module syntax (import/export, NOT require/module.exports)
  - Static analysis possible (no dynamic imports for tree shaking)
  - Side-effect-free modules

Side Effects:
  A module has side effects if importing it changes global state
  Examples of side effects:
    - Modifying global objects (window.x = ...)
    - Polyfills (import 'core-js')
    - CSS imports (import './styles.css')
    - Top-level function calls
    - Modifying prototypes

  package.json "sideEffects" field:
    "sideEffects": false           → all modules are pure (safe to shake)
    "sideEffects": ["*.css"]       → only CSS files have side effects
    "sideEffects": ["./src/polyfills.js"]  → specific files

  If not declared, bundler assumes ALL files may have side effects
  → tree shaking disabled or very conservative

Bundler-Specific Behavior:
  webpack:
    mode: 'production' enables tree shaking
    usedExports: true (marks unused exports)
    concatenateModules: true (scope hoisting for better DCE)
    Terser removes marked dead code

  Rollup:
    Tree shaking on by default
    Best at eliminating unused code
    Designed for libraries (ES module output)

  esbuild:
    Tree shaking on by default
    --tree-shaking=true
    Good but less aggressive than Rollup

Maximizing Tree Shaking:
  Library authors:
    - Use ES module format (not CJS)
    - Set "sideEffects": false in package.json
    - Export individual functions, not big objects
    - Avoid barrel files (index.js re-exporting everything)
    - Provide ESM build ("module" field in package.json)

  App developers:
    - Import specific items: import { map } from 'lodash-es'
    - NOT: import _ from 'lodash' (imports entire library)
    - Use bundle analyzer to find large unused imports
    - Check if dependencies support tree shaking

Common Tree Shaking Failures:
  - CommonJS modules (require/module.exports)
  - Class instances (methods can't be individually eliminated)
  - Object spread with side effects
  - Dynamic property access (obj[variable])
  - eval() or new Function() usage
EOF
}

cmd_pitfalls() {
    cat << 'EOF'
=== Minification Pitfalls ===

1. Name Mangling Breaks Code:
  Problem: minifier renames variable that's referenced by string
  Example:
    function MyController() {}
    app.controller('MyController', MyController);
    // Mangled: function a() {}
    // app.controller('MyController', a);  ← can't find 'a'!

  Fix: Angular's explicit annotation:
    app.controller('MyController', ['$scope', function($scope) {}]);
  Fix: Terser's reserved option:
    { mangle: { reserved: ['MyController'] } }

2. eval() and new Function():
  Minifier can't analyze code inside eval strings
  Variables referenced in eval may be mangled → runtime error
  Terser: use { compress: { evaluate: false } } if using eval

3. Property Mangling Gone Wrong:
  Don't enable property mangling unless you know what you're doing
  API calls, JSON parsing, DOM access all use string property names
  obj.myProp mangled → server/browser doesn't understand

4. Missing Semicolons (ASI Issues):
  JavaScript's Automatic Semicolon Insertion
  Usually fine, but edge cases after minification:
    return        →  return;      (returns undefined!)
    { foo: bar }      (next line consumed unexpectedly)
  Use semicolons or configure linter to catch ASI issues

5. Minified Code Crashes But Source Works:
  Debug approach:
    1. Check source maps (map error to original line)
    2. Bisect: disable compression options one by one
    3. Common culprits: dead code elimination too aggressive,
       side-effect assumptions wrong, scope analysis bug
    4. Test with --compress "passes=1" (reduce optimization)

6. CSS Minification Breaking Styles:
  Unsafe optimizations:
    - Merging rules across @media boundaries
    - Reordering selectors (changes specificity)
    - Removing "duplicate" properties that are fallbacks:
      color: black;            ← fallback for old browsers
      color: color(display-p3 0 0 0);  ← modern
    - Removing !important (may be intentional override)

7. HTML Minification Breaking Layouts:
  Whitespace between inline elements matters:
    <span>Hello</span> <span>World</span>
    vs
    <span>Hello</span><span>World</span>
  These render differently! Space between inline elements is significant.
  Configure: collapseWhitespace with conservativeCollapse

8. Double Minification:
  Don't minify already-minified code
  Wastes build time, can introduce bugs
  Check if dependencies ship pre-minified builds (.min.js)
  Exclude node_modules from minification if they're pre-built
EOF
}

show_help() {
    cat << EOF
minify v$VERSION — Code Minification Reference

Usage: script.sh <command>

Commands:
  intro        Minification overview — why, how, pipeline position
  javascript   JS minification: mangling, DCE, constant folding
  css          CSS minification: shorthand, values, selectors
  html         HTML minification: whitespace, attributes, tags
  tools        Tool comparison: Terser, esbuild, SWC, cssnano
  sourcemaps   Source maps — generation, debugging, security
  treeshake    Tree shaking — dead code elimination for ES modules
  pitfalls     Common minification bugs and debugging strategies
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    javascript) cmd_javascript ;;
    css)        cmd_css ;;
    html)       cmd_html ;;
    tools)      cmd_tools ;;
    sourcemaps) cmd_sourcemaps ;;
    treeshake)  cmd_treeshake ;;
    pitfalls)   cmd_pitfalls ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "minify v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
