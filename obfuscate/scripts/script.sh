#!/usr/bin/env bash
# obfuscate — Code Obfuscation Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Code Obfuscation ===

Obfuscation transforms code to make it difficult to understand
while preserving its functionality. It raises the cost of reverse
engineering without making it impossible.

Goals:
  - Protect intellectual property (algorithms, business logic)
  - Prevent code theft and unauthorized modifications
  - Hide API keys, endpoints, or proprietary protocols
  - Deter casual reverse engineering
  - Increase time/cost for an attacker to understand code

Threat Model:
  Who are you defending against?
    Script kiddies:    simple renaming may suffice
    Competitors:       moderate obfuscation needed
    Skilled attackers: heavy obfuscation, still breakable given time
    Nation-states:     obfuscation alone is insufficient

  Client-side code is inherently exposed
  Obfuscation is a speed bump, not a wall

Obfuscation vs Related Concepts:
  Minification:  reduce size (side effect: less readable)
  Obfuscation:   reduce readability (side effect: larger size)
  Encryption:    mathematically secure transformation (needs key)
  Packing:       compress + wrap in eval (easily unpacked)

  Obfuscation ≠ Security
    Don't rely on obfuscation to protect secrets
    API keys in client code can always be extracted
    Use server-side validation for security-critical logic

Cost-Benefit:
  Benefits:
    - Raises the bar for casual reverse engineering
    - Protects proprietary algorithms (temporarily)
    - Makes automated scraping/copying harder
  
  Costs:
    - Larger file size (2-10x increase typical)
    - Slower execution (10-50% performance hit)
    - Harder to debug your own code
    - Source maps become essential (and sensitive)
    - May break legitimate tools (linters, testing)
    - False sense of security
EOF
}

cmd_techniques() {
    cat << 'EOF'
=== Core Obfuscation Techniques ===

1. Identifier Renaming:
  Replace meaningful names with meaningless ones
  Before: function calculateDiscount(price, membership) { ... }
  After:  function _0x3a2f(a, b) { ... }
  
  Strategies:
    Sequential: a, b, c, ... aa, ab (smallest output)
    Hexadecimal: _0x1a2b, _0x3c4d (looks intimidating)
    Unicode: \u0061, ᐃᐊ (confusing in editors)
    Homoglyph: l vs 1 vs I, O vs 0 (visually similar chars)
    Dictionary: mangled real words for misdirection

2. Dead Code Injection:
  Add code that never executes or affects output
  Purpose: confuse static analysis, waste attacker's time
  
  Patterns:
    Unreachable branches: if (false) { fake_logic(); }
    Unused functions: decoy functions with plausible names
    Variable assignments that are never read
    Complex expressions that evaluate to constants

3. String Encoding:
  Replace string literals with decoded function calls
  Before: console.log("Hello World")
  After:  console[_0x3f2a('0x1')](_0x3f2a('0x2'))
  Where _0x3f2a returns strings from an encoded array
  (See 'strings' command for detailed techniques)

4. Object Key Transformation:
  Before: obj.method()
  After:  obj['\x6d\x65\x74\x68\x6f\x64']()  (hex encoding)
  Or:     obj[atob('bWV0aG9k')]()  (base64)

5. Number Literal Encoding:
  Before: const MAX = 100
  After:  const MAX = (0x4c ^ 0x18) + (0x3 << 0x2)
  Split into arithmetic expressions

6. Comma Expression Abuse:
  Before: a = 1; b = 2; return a + b;
  After:  return a = 1, b = 2, a + b;
  Harder to read, same behavior

7. Template Literal Transformation:
  Before: `Hello ${name}`
  After:  'Hello ' + ('' + name)
  Prevents simple string searching

8. Scope Pollution:
  Move variables to broader scopes
  Makes data flow analysis harder
  Local variables become object properties on shared state
EOF
}

cmd_controlflow() {
    cat << 'EOF'
=== Control Flow Obfuscation ===

Control Flow Flattening (CFF):
  Transform structured code into a state machine with dispatch loop

  Before:
    function process(x) {
      let result = x * 2;
      if (result > 10) {
        result = result - 5;
      }
      return result + 1;
    }

  After (conceptual):
    function process(x) {
      const flow = '2|0|1|3'.split('|');
      let state = 0, result;
      while (true) {
        switch (flow[state++]) {
          case '0': if (result > 10) { state = 2; continue; } break;
          case '1': return result + 1;
          case '2': result = x * 2; break;
          case '3': result = result - 5; state = 1; continue;
        }
        break;
      }
    }

  Effect: impossible to see program structure at a glance
  Cost: 30-100% performance overhead

Opaque Predicates:
  Conditions that always evaluate to same value but are hard to prove
  
  Mathematical:
    (x * x + x) % 2 === 0  → always true (n²+n is always even)
    (x * (x + 1) * (x + 2)) % 6 === 0  → always true
  
  Pointer-based (harder to analyze statically):
    Create data structures where analysis can't prove value
    Hash table with known collision properties

  Usage: wrap real code in opaque predicates
    if (opaqueTrue) { realCode(); } else { deadCode(); }
    Static analyzers can't remove the dead branch

Dispatcher Pattern:
  Replace direct function calls with dispatcher
  
  Before: doStep1(); doStep2(); doStep3();
  After:  dispatch(0x3a); dispatch(0x7f); dispatch(0x12);
  
  function dispatch(code) {
    const table = { 0x3a: doStep1, 0x7f: doStep2, 0x12: doStep3 };
    table[code]();
  }

  Breaks: call graph analysis, inlining, function tracing

Code Transposition:
  Reorder basic blocks — jump to correct order at runtime
  Functions split into pieces and reassembled
  Makes linear reading impossible

Exception-Based Flow:
  Use try/catch/throw for control flow instead of if/goto
  
  try {
    if (condition) throw new Error('path-a');
    // path B code
  } catch(e) {
    if (e.message === 'path-a') { /* path A code */ }
  }
  
  Confuses decompilers and profilers

Loop Transformations:
  Unroll loops then re-roll differently
  Transform for→while→do-while
  Split loop body across multiple loops
  Add fake loop iterations with no effect
EOF
}

cmd_strings() {
    cat << 'EOF'
=== String Protection Techniques ===

Why Protect Strings?
  Strings are the #1 entry point for reverse engineers
  API endpoints, error messages, variable names → reveal intent
  "findUserByEmail" tells attacker exactly what function does

1. String Array Extraction:
  Move all strings into a single array, reference by index
  
  Before:
    console.log("Hello");
    fetch("/api/users");
  
  After:
    var _0x = ["Hello", "/api/users", "log"];
    console[_0x[2]](_0x[0]);
    fetch(_0x[1]);

2. String Array Rotation:
  Rotate the array by N positions on startup
  Index calculation changes: actual_index = (visible_index + N) % len
  Attacker must run the rotation to know real values

3. Base64 Encoding:
  Before: "Hello World"
  After:  atob("SGVsbG8gV29ybGQ=")
  Easy to reverse but defeats simple grep searches

4. RC4 / XOR Encryption:
  Encrypt strings with a key, decrypt at runtime
  
  function decrypt(encoded, key) {
    // RC4 or XOR decryption
    return decryptedString;
  }
  
  Before: "secret_api_key"
  After:  decrypt("3f2a7b...", 0x4c2f)
  
  Key is still in the code — determined attacker finds it
  But automated tools can't extract strings easily

5. Unicode Escape Sequences:
  "Hello" → "\u0048\u0065\u006c\u006c\u006f"
  Looks intimidating but trivially reversible
  Useful as first layer in multi-layer encoding

6. String Splitting and Concatenation:
  "api/secret" → "a" + "p" + "i" + "/" + "s" + "ecret"
  Or: ["a","p","i","/","s","ecret"].join("")
  Defeats simple string searching

7. Domain-Locking:
  Encrypt strings with domain name as key
  Code only works on authorized domain
  Different domain → wrong decryption → garbage/crash

8. Self-Defending Strings:
  String decryption checks code integrity
  If code is modified (prettified, deobfuscated) → decryption fails
  Checksums over code sections used as decryption keys
  Tamper with code → strings return garbage
EOF
}

cmd_antidebug() {
    cat << 'EOF'
=== Anti-Debugging Techniques ===

1. debugger Statement:
  JavaScript `debugger;` pauses execution if DevTools is open
  
  Infinite debugger loop:
    setInterval(function() { debugger; }, 100);
  
  Attacker can disable: blackbox the file, or override setInterval
  Better: spread debugger statements throughout code
  Even better: use Function('debugger')() to avoid static detection

2. Timing-Based Detection:
  Measure execution time — debugging adds delay
  
  const start = performance.now();
  // some code
  const elapsed = performance.now() - start;
  if (elapsed > 100) {
    // probably being debugged
    selfDestruct();
  }
  
  Also: Date.now() difference, console.time stamps
  Caveat: slow machines trigger false positives

3. Console Detection:
  Detect open DevTools via console side effects
  
  // Object with custom toString — called when DevTools inspects it
  const detector = {
    get toString() {
      // DevTools is open!
      return function() { return ''; };
    }
  };
  console.log('%c', detector);

  // Window size detection
  if (window.outerWidth - window.innerWidth > 200 ||
      window.outerHeight - window.innerHeight > 200) {
    // DevTools likely docked
  }

4. Stack Trace Analysis:
  Inspect call stack for debugging-related frames
  
  function checkStack() {
    try { throw new Error(); } catch(e) {
      if (e.stack.includes('debugger') ||
          e.stack.includes('eval')) {
        // suspicious
      }
    }
  }

5. Code Integrity Checks:
  Function.prototype.toString() reveals source
  If function has been modified → different toString output
  
  function sensitive() { /* original code */ }
  const original = sensitive.toString();
  // Later:
  if (sensitive.toString() !== original) {
    // function was modified!
  }

6. Breakpoint Detection:
  Check if breakpoints modify execution timing
  Monitor for handler function replacement
  Detect if native functions have been overridden:
    if (console.log.toString().includes('[native code]')) { ok; }
    else { /* console.log was replaced */ }

7. Environment Fingerprinting:
  Check for automation tools:
    navigator.webdriver === true → Selenium/Puppeteer
    window.__REACT_DEVTOOLS__ → React DevTools installed
    window.callPhantom → PhantomJS

8. Self-Defending Code:
  Code that crashes or behaves differently when formatted
  Relies on specific whitespace/formatting patterns
  If prettified → changes behavior → prevents analysis
  Often combined with string encryption (code hash = key)
EOF
}

cmd_tools() {
    cat << 'EOF'
=== Obfuscation Tools ===

JavaScript Obfuscator (javascript-obfuscator):
  Open source, most popular, feature-rich
  npm install javascript-obfuscator
  
  Key options:
    compact:                   true/false (single line)
    controlFlowFlattening:     true (state machine transform)
    deadCodeInjection:         true (fake code blocks)
    debugProtection:           true (anti-debugger)
    disableConsoleOutput:      true (disable console.*)
    identifierNamesGenerator:  hexadecimal/mangled/dictionary
    selfDefending:             true (anti-formatting)
    stringArray:               true (extract strings)
    stringArrayEncoding:       ['rc4'] / ['base64']
    stringArrayRotate:         true (rotate string array)
    transformObjectKeys:       true (obfuscate object keys)

  Presets:
    Low:     renaming + string array (fast, smaller output)
    Medium:  + control flow + dead code (balanced)
    High:    + debug protection + self-defending (max protection)

  Performance impact:
    Low:     ~5-10% slower
    Medium:  ~30-50% slower
    High:    ~80-200% slower

JScrambler:
  Commercial, enterprise-grade
  Code locks (domain, date, OS locking)
  Real-time threat monitoring
  Memory protection (anti-memory dump)
  Self-defending transformations
  Starting ~$100/month

Webpack / Rollup Plugins:
  webpack-obfuscator: wraps javascript-obfuscator for webpack
  rollup-plugin-obfuscator: same for rollup
  
  Configure per chunk or per file
  Exclude vendor code (already obfuscated or too large)

Google Closure Compiler (ADVANCED mode):
  Not obfuscation per se, but aggressive optimization
  Renames everything including properties
  Removes dead code, inlines functions
  Requires JSDoc annotations for safety
  Result is highly compact and hard to read

Bytecode Compilation:
  bytenode: compile Node.js to V8 bytecode (.jsc files)
  Not truly secure (bytecode can be decompiled)
  But no source code shipped — harder than text obfuscation
  Only works for Node.js, not browsers

PrePack (Meta):
  Evaluates code at build time, emits simplified result
  Not designed for obfuscation but makes code harder to follow
  Eliminates many abstractions by constant propagation
EOF
}

cmd_wasm() {
    cat << 'EOF'
=== WebAssembly as Obfuscation ===

Why WebAssembly?
  Wasm is a binary instruction format — not readable text
  Compiled from C/C++/Rust — no JavaScript source exposed
  Move sensitive algorithms to Wasm module

How It Works:
  1. Write sensitive logic in C/C++ or Rust
  2. Compile to .wasm binary
  3. Load from JavaScript: WebAssembly.instantiate(bytes)
  4. Call Wasm functions from JS

  Example flow:
    // license-check.c → license-check.wasm
    // JavaScript:
    const wasmModule = await WebAssembly.instantiate(bytes);
    const isValid = wasmModule.exports.checkLicense(key);

Protection Level:
  Binary format: no variable names, no structure
  Decompilation: possible but produces low-level code
  Tools: wasm-decompile, wasm2c (produce unreadable output)
  Much harder than JavaScript deobfuscation

  BUT:
    - Function exports are named (can be obfuscated)
    - Linear memory is inspectable (runtime dump)
    - Wasm debugging supported in Chrome DevTools
    - Determined attacker can still reverse engineer

Wasm Obfuscation Techniques:
  Control flow flattening in source language (before compile)
  Opaque predicates in C/C++
  Custom memory encryption/decryption
  Anti-debugging: detect Wasm debugging breakpoints
  Code virtualization: custom bytecode interpreter in Wasm

Tools:
  Emscripten: C/C++ → Wasm (most mature)
  wasm-pack / wasm-bindgen: Rust → Wasm
  AssemblyScript: TypeScript-like → Wasm
  Aspect: commercial Wasm obfuscation

Practical Considerations:
  Wasm ↔ JS boundary has overhead (type conversions)
  Strings must be passed via shared memory
  Not suitable for DOM-heavy code (DOM access goes through JS)
  Best for: crypto, validation, algorithms, license checks
  Not for: UI logic, DOM manipulation, API calls

Combined Strategy:
  Sensitive algorithms → Wasm (binary protection)
  Application logic → JS with obfuscation
  API keys / secrets → server-side (never in client code!)
  Configuration → server-provided, runtime-only
EOF
}

cmd_limits() {
    cat << 'EOF'
=== Limitations of Code Obfuscation ===

Fundamental Truth:
  If a machine can execute it, a human can reverse engineer it.
  Obfuscation increases cost and time, it does not prevent it.
  Given enough motivation, any obfuscated code can be understood.

What Obfuscation CANNOT Protect:
  1. API Keys / Secrets
     Client-side → always extractable (network tab, memory dump)
     Solution: server-side proxy, environment variables

  2. Network Protocols
     Traffic is visible regardless of code obfuscation
     Solution: TLS, server-side validation, API authentication

  3. Business Logic Outcomes
     Users can observe inputs and outputs (black-box analysis)
     Solution: server-side computation

  4. DOM Interactions
     Browser exposes all DOM operations via DevTools
     Solution: cannot hide, design accordingly

Attacker Toolbox:
  - Browser DevTools (breakpoints, network, memory)
  - Prettier / beautifiers (undo formatting obfuscation)
  - AST-based deobfuscators (reverse transformations)
  - Dynamic analysis (run code, observe behavior)
  - Symbolic execution (automated path exploration)
  - Memory dump (extract decrypted strings at runtime)
  - Proxy/interceptor (modify code before execution)

Tools that defeat obfuscation:
  de4js:             online JS deobfuscator
  synchrony:         auto-deobfuscate javascript-obfuscator output
  AST Explorer:      analyze and transform AST
  deobfuscate.io:    automated pattern recognition
  Overrides/Tampermonkey: replace obfuscated code at runtime

Cost-Benefit Analysis:
  Obfuscation makes sense when:
    ✓ Protecting proprietary algorithms (competitive advantage)
    ✓ Raising the bar against casual copying
    ✓ Complying with IP licensing requirements
    ✓ Making automated scraping harder
    ✓ Combined with server-side security measures

  Obfuscation is NOT worth it when:
    ✗ It's your only security measure
    ✗ Performance degradation is unacceptable
    ✗ Debug/support costs exceed protection value
    ✗ The code isn't actually valuable to steal
    ✗ Open source would be more beneficial (community, trust)

Legal Considerations:
  DMCA: circumventing technological protection measures may be illegal
  But: obfuscation alone may not qualify as "effective protection"
  License terms matter more than technical measures
  Consult legal counsel for IP protection strategy

Best Practice:
  Server-side logic for security-critical operations
  + Obfuscation for client-side IP protection
  + Legal agreements (ToS, licenses, NDA)
  + Monitoring for unauthorized use
  = Defense in depth
EOF
}

show_help() {
    cat << EOF
obfuscate v$VERSION — Code Obfuscation Reference

Usage: script.sh <command>

Commands:
  intro        Obfuscation overview — goals, threat model, tradeoffs
  techniques   Core techniques: renaming, dead code, encoding
  controlflow  Control flow flattening, opaque predicates, dispatch
  strings      String protection: encoding, encryption, rotation
  antidebug    Anti-debugging: debugger traps, timing, detection
  tools        Tools: javascript-obfuscator, JScrambler, Closure
  wasm         WebAssembly as code protection strategy
  limits       Limitations and cost-benefit analysis
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)       cmd_intro ;;
    techniques)  cmd_techniques ;;
    controlflow) cmd_controlflow ;;
    strings)     cmd_strings ;;
    antidebug)   cmd_antidebug ;;
    tools)       cmd_tools ;;
    wasm)        cmd_wasm ;;
    limits)      cmd_limits ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "obfuscate v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
