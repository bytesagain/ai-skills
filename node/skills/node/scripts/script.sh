#!/usr/bin/env bash
# node — Node.js Runtime Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Node.js Runtime ===

Node.js is a JavaScript runtime built on Chrome's V8 engine.
It uses an event-driven, non-blocking I/O model for building
scalable network applications.

Architecture:
  ┌─────────────────────────────┐
  │       Your JavaScript       │
  ├─────────────────────────────┤
  │  Node.js API (fs, http...) │
  ├──────────────┬──────────────┤
  │     V8       │    libuv     │
  │  (JS engine) │  (async I/O) │
  ├──────────────┴──────────────┤
  │   OS (Linux/macOS/Windows)  │
  └─────────────────────────────┘

Key Components:
  V8:      Google's JS engine — compiles JS to machine code
  libuv:   Cross-platform async I/O (event loop, thread pool)
  c-ares:  DNS resolution
  OpenSSL: TLS/SSL cryptography
  zlib:    Compression
  llhttp:  HTTP parser (replaced http_parser in Node 12)

Single-Threaded But Not Single-Process:
  Main thread: runs your JS code + event loop
  Thread pool: 4 threads (default) for blocking I/O
    - File system operations (fs.readFile, etc.)
    - DNS lookups (dns.lookup)
    - Crypto operations (pbkdf2, randomBytes)
    - zlib compression
  Change pool size: UV_THREADPOOL_SIZE=8 (max 1024)

Version History:
  v0.1     2009  Ryan Dahl introduces Node.js
  v4.0     2015  io.js merge, LTS model begins
  v8.0     2017  async/await support, N-API
  v12.0    2019  ES modules support, worker threads
  v16.0    2021  Apple Silicon support, Timers Promises
  v18.0    2022  fetch API, test runner, watch mode
  v20.0    2023  Permission model, stable test runner
  v22.0    2024  require(esm), WebSocket client

LTS Schedule:
  Even-numbered releases get LTS (30 months support)
  Current: active development (6 months)
  Active LTS: production-ready (18 months)
  Maintenance: critical fixes only (12 months)
EOF
}

cmd_eventloop() {
    cat << 'EOF'
=== Event Loop ===

Node.js event loop phases (each iteration = "tick"):

  ┌───────────────────────────┐
  │        timers              │  setTimeout, setInterval callbacks
  ├───────────────────────────┤
  │    pending callbacks       │  I/O callbacks deferred from previous tick
  ├───────────────────────────┤
  │        idle, prepare       │  Internal use only
  ├───────────────────────────┤
  │        poll                │  Retrieve new I/O events, execute callbacks
  ├───────────────────────────┤
  │        check               │  setImmediate callbacks
  ├───────────────────────────┤
  │    close callbacks         │  socket.on('close'), etc.
  └───────────────────────────┘

Between each phase, Node processes:
  1. process.nextTick() queue (highest priority microtask)
  2. Promise microtasks (.then, .catch, .finally)
  3. queueMicrotask() callbacks

Execution Order Example:
  console.log('1 - sync');
  setTimeout(() => console.log('2 - timeout'), 0);
  setImmediate(() => console.log('3 - immediate'));
  Promise.resolve().then(() => console.log('4 - promise'));
  process.nextTick(() => console.log('5 - nextTick'));

  Output:
    1 - sync        (synchronous, runs first)
    5 - nextTick    (nextTick queue, before microtasks)
    4 - promise     (microtask queue)
    2 - timeout     (timers phase — but order with immediate is uncertain here)
    3 - immediate   (check phase)

  Note: setTimeout(fn, 0) vs setImmediate order is non-deterministic
  in the main module. Inside an I/O callback, setImmediate always first.

Poll Phase Details:
  1. If poll queue is not empty → process callbacks
  2. If poll queue is empty:
     a. If setImmediate scheduled → move to check phase
     b. If timers ready → wrap back to timers phase
     c. Otherwise → wait for new I/O events

Common Gotchas:
  - Long-running sync code blocks the event loop entirely
  - process.nextTick() can starve I/O if called recursively
  - Unhandled promise rejections = UnhandledPromiseRejectionWarning
  - Since Node 15: unhandled rejections terminate the process

Monitoring Event Loop:
  // Detect event loop lag
  const start = process.hrtime();
  setImmediate(() => {
    const [s, ns] = process.hrtime(start);
    const lagMs = s * 1000 + ns / 1e6;
    if (lagMs > 100) console.warn(`Event loop lag: ${lagMs}ms`);
  });
EOF
}

cmd_modules() {
    cat << 'EOF'
=== Module Systems ===

CommonJS (CJS) — Original Node.js Module System:
  // Export
  module.exports = { hello: () => 'world' };
  module.exports.hello = () => 'world';
  exports.hello = () => 'world';  // shorthand

  // Import
  const { hello } = require('./module');
  const fs = require('fs');

  Resolution order:
    1. Core modules (fs, path, http — always win)
    2. File: ./module → ./module.js → ./module.json → ./module.node
    3. Directory: ./module/package.json "main" → ./module/index.js
    4. node_modules: walk up directory tree

ES Modules (ESM) — Modern Standard:
  // Export
  export const hello = () => 'world';
  export default function() { return 'world'; }

  // Import
  import { hello } from './module.js';
  import fs from 'node:fs';
  import data from './data.json' with { type: 'json' };

  Enable ESM:
    Option 1: Use .mjs file extension
    Option 2: Set "type": "module" in package.json
    Option 3: --input-type=module flag

CJS vs ESM:
  Feature          CJS                  ESM
  Syntax           require/module.exports  import/export
  Loading          Synchronous          Asynchronous
  Top-level await  No                   Yes
  __dirname        Available            Use import.meta.dirname (Node 21+)
  __filename       Available            Use import.meta.filename
  JSON import      require('./data.json') import with assertion
  Dynamic          require(expr)        import(expr) (returns Promise)
  Circular deps    Partial exports      Live bindings

package.json Module Fields:
  "main":     CJS entry point (legacy)
  "module":   ESM entry point (bundlers)
  "exports":  Modern — conditional exports (Node 12+)
    {
      "exports": {
        ".": {
          "import": "./dist/esm/index.js",
          "require": "./dist/cjs/index.js",
          "types": "./dist/types/index.d.ts"
        },
        "./utils": "./dist/utils.js"
      }
    }
  "type": "module"     — .js files treated as ESM
  "type": "commonjs"   — .js files treated as CJS (default)

Node 22+ require(esm):
  Can now require() ES modules (if they have no top-level await)
  Reduces dual-package burden significantly
EOF
}

cmd_npm() {
    cat << 'EOF'
=== npm Workflows ===

Essential Commands:
  npm init -y               Create package.json
  npm install               Install all dependencies
  npm install express       Add production dependency
  npm install -D jest       Add dev dependency
  npm uninstall express     Remove dependency
  npm update                Update within semver ranges
  npm outdated              Show outdated packages
  npm ls                    Dependency tree
  npm ls --depth=0          Top-level only

Lockfile (package-lock.json):
  - Pin exact versions for reproducible installs
  - Always commit to version control
  - npm ci: clean install from lockfile (CI/CD preferred)
  - npm install: updates lockfile if package.json changed

Semver in package.json:
  "express": "4.18.2"     Exact version
  "express": "^4.18.2"    Compatible (>=4.18.2 <5.0.0) — default
  "express": "~4.18.2"    Patch-level (>=4.18.2 <4.19.0)
  "express": ">=4.0.0"    Range
  "express": "*"          Any version (dangerous!)

Scripts:
  "scripts": {
    "start": "node server.js",       # npm start
    "dev": "node --watch server.js", # npm run dev
    "test": "jest",                  # npm test
    "build": "tsc",                  # npm run build
    "pretest": "npm run lint",       # runs before test
    "postbuild": "cp -r assets dist" # runs after build
  }
  Pre/post hooks: prepublish, pretest, postinstall, etc.

Security:
  npm audit                 Check for vulnerabilities
  npm audit fix             Auto-fix compatible updates
  npm audit fix --force     Fix with breaking changes (careful!)
  npm audit signatures      Verify package provenance

Workspaces (Monorepo):
  package.json:
    { "workspaces": ["packages/*"] }

  npm install              Install all workspace deps
  npm run build -w pkg-a   Run script in specific workspace
  npm run build --workspaces  Run in all workspaces

Publishing:
  npm login                 Authenticate to registry
  npm publish               Publish package
  npm publish --access public  Scoped package as public
  npm version patch|minor|major  Bump version + git tag
  npm deprecate pkg@"<1.0" "Use v1+"  Deprecate old versions

npx — Execute Packages:
  npx create-react-app my-app    Run without global install
  npx -p typescript tsc          Use specific package
  npx node@18 --version          Use specific Node version
EOF
}

cmd_streams() {
    cat << 'EOF'
=== Streams API ===

Streams process data piece-by-piece without loading everything
into memory. Essential for large files, network data, and pipelines.

Four Stream Types:
  Readable:   Data source (fs.createReadStream, http request)
  Writable:   Data sink (fs.createWriteStream, http response)
  Transform:  Read + modify + write (zlib.createGzip, crypto)
  Duplex:     Independent read + write (net.Socket, WebSocket)

Basic Usage:
  const { createReadStream, createWriteStream } = require('fs');
  const { pipeline } = require('stream/promises');
  const { createGzip } = require('zlib');

  // Pipe: read → gzip → write
  await pipeline(
    createReadStream('input.txt'),
    createGzip(),
    createWriteStream('output.txt.gz')
  );

  // Always use pipeline() — handles errors and cleanup
  // NEVER use .pipe() in production (no error handling)

Readable Stream Events:
  'data'       Chunk received (flowing mode)
  'end'        No more data
  'error'      Error occurred
  'readable'   Data available to read (paused mode)
  'close'      Stream and resources closed

Writable Stream Events:
  'drain'      Buffer emptied, safe to write again
  'finish'     All data flushed
  'error'      Error occurred
  'close'      Stream closed

Backpressure:
  Problem: producer faster than consumer → memory overflow
  Solution: writable.write() returns false when buffer full
  Then wait for 'drain' event before writing more

  // Manual backpressure handling
  function writeData(stream, data) {
    if (!stream.write(data)) {
      await once(stream, 'drain');
    }
  }
  // pipeline() handles this automatically!

Object Mode:
  Default: streams process Buffer/string chunks
  Object mode: streams process any JS object
  new Transform({
    objectMode: true,
    transform(obj, enc, cb) {
      cb(null, { ...obj, processed: true });
    }
  });

  Common in: database query results, JSON processing

Web Streams (Node 18+):
  Node now supports WHATWG Web Streams API
  ReadableStream, WritableStream, TransformStream
  Compatible with fetch(), Blob, File API
  Conversion: Readable.toWeb(nodeStream)
EOF
}

cmd_debugging() {
    cat << 'EOF'
=== Debugging Node.js ===

Inspector / Chrome DevTools:
  node --inspect server.js           Start with inspector
  node --inspect-brk server.js       Break on first line
  node --inspect=0.0.0.0:9229        Remote debugging

  Open: chrome://inspect in Chrome
  Click "Open dedicated DevTools for Node"
  Features: breakpoints, step through, watch, call stack

Debugger Statement:
  // Add in code — pauses when inspector attached
  debugger;
  // Will be ignored if no debugger is connected

Console Methods (beyond console.log):
  console.log(obj)          Standard output
  console.error(err)        Standard error (stderr)
  console.table([...])      Tabular display
  console.time('label')     Start timer
  console.timeEnd('label')  End timer (prints duration)
  console.trace('label')    Print stack trace
  console.dir(obj, {depth: null})  Full object inspection
  console.count('label')    Increment counter

Heap Snapshots (Memory Leaks):
  node --inspect server.js
  Chrome DevTools → Memory tab → Take Heap Snapshot
  Compare two snapshots to find growing objects

  Or programmatic:
  node --heapsnapshot-signal=SIGUSR2 server.js
  kill -USR2 <pid>  // writes .heapsnapshot file

  Common leak sources:
    - Growing arrays/maps (cache without eviction)
    - Event listeners not removed
    - Closures retaining large objects
    - Global variables accumulating data

CPU Profiling:
  node --prof server.js             Generate V8 log
  node --prof-process isolate-*.log  Human-readable output

  Or Chrome DevTools → Performance → Record

  // Programmatic
  const { Session } = require('inspector');
  const session = new Session();
  session.connect();
  session.post('Profiler.enable');
  session.post('Profiler.start');
  // ... run code ...
  session.post('Profiler.stop', (err, { profile }) => {
    fs.writeFileSync('profile.cpuprofile', JSON.stringify(profile));
  });

Diagnostic Reports (Node 12+):
  node --report-on-fatalerror server.js
  process.report.writeReport()
  Generates JSON: heap stats, native stack, libuv handles, env vars

Common Debug Environment Variables:
  NODE_DEBUG=http,net          Debug core modules
  NODE_OPTIONS='--inspect'     Always enable inspector
  UV_THREADPOOL_SIZE=8         Increase libuv thread pool
EOF
}

cmd_performance() {
    cat << 'EOF'
=== Node.js Performance ===

Cluster Module (Multi-Process):
  const cluster = require('cluster');
  const os = require('os');

  if (cluster.isPrimary) {
    const cpus = os.cpus().length;
    for (let i = 0; i < cpus; i++) cluster.fork();
    cluster.on('exit', (worker) => {
      console.log(`Worker ${worker.process.pid} died`);
      cluster.fork(); // restart
    });
  } else {
    // Worker: run your server
    require('./server.js');
  }

  Benefits: utilize all CPU cores, process isolation
  Alternative: pm2 start server.js -i max (easier)

Worker Threads (CPU-Intensive Tasks):
  const { Worker, isMainThread, parentPort } = require('worker_threads');

  if (isMainThread) {
    const worker = new Worker('./heavy-task.js', { workerData: input });
    worker.on('message', result => console.log(result));
    worker.on('error', err => console.error(err));
  } else {
    // Worker: do heavy computation
    const result = heavyComputation(workerData);
    parentPort.postMessage(result);
  }

  Use for: image processing, crypto, parsing, ML inference
  Don't use for: I/O (event loop handles I/O efficiently)

Memory Management:
  Default heap: ~1.7GB (64-bit), ~512MB (32-bit)
  Increase: node --max-old-space-size=4096 server.js
  Monitor: process.memoryUsage()
    rss:          Total memory allocated (resident set)
    heapTotal:    V8 heap allocated
    heapUsed:     V8 heap used
    external:     C++ objects bound to JS
    arrayBuffers: ArrayBuffer + SharedArrayBuffer

  Tips:
    - Stream large files (don't load into memory)
    - Use Buffer.allocUnsafe() for performance (skip zero-fill)
    - Set cache size limits (LRU eviction)
    - Avoid global variables holding large data

Benchmarking:
  // Built-in (Node 19+)
  const { performance, PerformanceObserver } = require('perf_hooks');

  performance.mark('start');
  // ... operation ...
  performance.mark('end');
  performance.measure('operation', 'start', 'end');

  // Autocannon (HTTP benchmarking)
  npx autocannon -c 100 -d 10 http://localhost:3000

  // 0x (flame graph)
  npx 0x server.js
  // Generate flamegraph.html for CPU profiling

Production Checklist:
  - NODE_ENV=production (disables dev features, enables optimizations)
  - Use cluster or pm2 for multi-core
  - Enable compression (gzip/brotli)
  - Use reverse proxy (nginx) for static files + SSL
  - Set --max-old-space-size appropriately
  - Monitor event loop lag (>100ms = problem)
  - Implement graceful shutdown (SIGTERM handler)
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== Node.js Production Checklist ===

Security:
  [ ] NODE_ENV=production set
  [ ] npm audit clean (no critical/high vulnerabilities)
  [ ] Helmet.js for HTTP security headers
  [ ] Rate limiting on APIs
  [ ] Input validation (joi, zod, or express-validator)
  [ ] No secrets in code (use environment variables)
  [ ] HTTPS enabled (TLS 1.2+ minimum)
  [ ] Dependencies pinned (package-lock.json committed)

Performance:
  [ ] Cluster mode or pm2 for multi-core utilization
  [ ] Compression enabled (gzip/brotli middleware)
  [ ] Static files served by nginx (not Node)
  [ ] Connection pooling for databases
  [ ] Caching strategy implemented (Redis, in-memory LRU)
  [ ] Large file operations use streams (not readFileSync)
  [ ] --max-old-space-size set for available memory

Reliability:
  [ ] Graceful shutdown handler (SIGTERM, SIGINT)
  [ ] Health check endpoint (/health or /readiness)
  [ ] Uncaught exception handler (log + exit)
  [ ] Unhandled rejection handler (log + exit)
  [ ] Process manager (pm2, systemd, Docker restart policy)
  [ ] Zero-downtime restarts configured

Logging & Monitoring:
  [ ] Structured logging (pino or winston, not console.log)
  [ ] Log levels configured (error, warn, info, debug)
  [ ] Request logging with correlation IDs
  [ ] Error tracking (Sentry, Datadog, etc.)
  [ ] APM agent installed (New Relic, Datadog, Elastic)
  [ ] Event loop lag monitoring
  [ ] Memory usage monitoring (RSS, heap)
  [ ] Alerting configured for anomalies

Operations:
  [ ] Docker health check configured
  [ ] .dockerignore excludes node_modules, .git
  [ ] Multi-stage Docker build (builder + production)
  [ ] npm ci used in CI/CD (not npm install)
  [ ] Node.js LTS version (even-numbered)
  [ ] Automated dependency updates (Dependabot/Renovate)
  [ ] Backup/restore procedures documented
  [ ] Runbook for common incidents
EOF
}

show_help() {
    cat << EOF
node v$VERSION — Node.js Runtime Reference

Usage: script.sh <command>

Commands:
  intro        Node.js architecture, V8, libuv, history
  eventloop    Event loop phases, microtasks, nextTick
  modules      CommonJS vs ESM, resolution, package.json
  npm          Install, audit, scripts, workspaces, publishing
  streams      Readable, writable, transform, backpressure
  debugging    Inspector, heap snapshots, CPU profiling
  performance  Cluster, worker threads, memory, benchmarking
  checklist    Production readiness checklist
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)       cmd_intro ;;
    eventloop)   cmd_eventloop ;;
    modules)     cmd_modules ;;
    npm)         cmd_npm ;;
    streams)     cmd_streams ;;
    debugging)   cmd_debugging ;;
    performance) cmd_performance ;;
    checklist)   cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "node v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
