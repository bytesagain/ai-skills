#!/usr/bin/env bash
# plugin — Plugin Architecture Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Plugin Architecture ===

A plugin system allows third-party code to extend an application's
functionality without modifying the application's source code.

Goals of Plugin Architecture:
  - Extensibility: add features without core changes
  - Modularity: keep core small, features optional
  - Customization: users adapt software to their needs
  - Ecosystem: community contributes plugins
  - Separation of concerns: core vs extensions

Core Components:
  Host Application: the main program that loads plugins
  Plugin API: interface the host exposes for plugins
  Plugin Manager: discovers, loads, manages plugin lifecycle
  Plugin: code that uses the API to extend functionality
  Extension Points: specific places where plugins can hook in

Trade-Offs:
  Benefits:
    + Smaller core codebase
    + Faster feature development (parallel, community)
    + Users only install what they need
    + Longer software lifecycle (adaptable)
  
  Costs:
    - Complex architecture (API design, versioning)
    - Security risks (running third-party code)
    - Performance overhead (indirection, isolation)
    - Support burden (plugin compatibility issues)
    - API stability commitment (breaking changes hurt ecosystem)

When to Use Plugins:
  ✓ Core functionality is well-defined and stable
  ✓ Users have diverse, incompatible requirements
  ✓ You want community-driven feature development
  ✓ Application will be long-lived (worth the investment)
  ✓ Clear extension points exist in the architecture

When NOT to Use:
  ✗ Application is small or short-lived
  ✗ All features are core requirements
  ✗ Security constraints prohibit third-party code
  ✗ Team is too small to maintain plugin API stability
  ✗ Simpler alternatives suffice (configuration, scripting)

Plugin vs Related Concepts:
  Plugin:     compiled/interpreted code, deep integration
  Extension:  often synonymous with plugin (VS Code uses this)
  Add-on:     user-facing feature addition (browser extensions)
  Module:     code organization unit (may or may not be pluggable)
  Theme:      visual customization plugin (CSS, templates)
  Widget:     UI-focused plugin (embeddable components)
EOF
}

cmd_patterns() {
    cat << 'EOF'
=== Plugin Design Patterns ===

1. Hook/Event Pattern:
  Host emits events at extension points
  Plugins register listeners for events they care about
  
  // Host
  hooks.emit('beforeSave', document);
  await performSave(document);
  hooks.emit('afterSave', document);
  
  // Plugin
  hooks.on('beforeSave', (doc) => {
    doc.updatedAt = Date.now();
    doc.wordCount = countWords(doc.body);
  });
  
  Pros: simple, decoupled, familiar pattern
  Cons: hard to control execution order, no return values

2. Middleware Pattern:
  Plugins wrap core functionality in layers
  Each plugin calls next() to pass control
  
  // Host creates pipeline
  app.use(authPlugin);
  app.use(loggingPlugin);
  app.use(cachePlugin);
  
  // Plugin
  function authPlugin(context, next) {
    if (!context.user) throw new Error('Unauthorized');
    return next(context);
  }
  
  Pros: composable, ordered, can short-circuit
  Cons: linear only, order-dependent

3. Visitor Pattern:
  Host traverses a structure, plugins process nodes
  
  // Host walks AST
  traverse(ast, pluginVisitors);
  
  // Plugin
  module.exports = {
    visitors: {
      FunctionDeclaration(node) { /* transform */ },
      VariableDeclaration(node) { /* transform */ }
    }
  };
  
  Used by: Babel, ESLint, PostCSS
  Pros: fine-grained, type-safe hooks
  Cons: limited to tree structures

4. Dependency Injection:
  Host provides services, plugin declares dependencies
  
  // Plugin manifest
  { "requires": ["database", "logger", "config"] }
  
  // Plugin
  module.exports = function(database, logger, config) {
    return {
      onUserCreated: (user) => {
        database.audit.log(user);
        logger.info('User created');
      }
    };
  };
  
  Pros: testable, explicit dependencies, loose coupling
  Cons: complex container, harder to understand flow

5. Registry Pattern:
  Plugins register capabilities with a central registry
  Host queries registry when needed
  
  // Plugin registers handler
  registry.register('image/png', PngHandler);
  registry.register('image/jpeg', JpegHandler);
  
  // Host looks up handler
  const handler = registry.get(file.mimeType);
  handler.process(file);
  
  Used by: file type handlers, serializers, view engines

6. Slot/Template Pattern:
  Host defines named slots, plugins fill them
  Common in UI frameworks
  
  <PluginSlot name="sidebar">
    {/* plugins inject components here */}
  </PluginSlot>
  
  Used by: WordPress widgets, Drupal blocks, Figma UI
EOF
}

cmd_lifecycle() {
    cat << 'EOF'
=== Plugin Lifecycle ===

Phase 1: Discovery
  Find available plugins
  
  Methods:
    File system scan: search known directories for plugin files
      ~/.app/plugins/, /usr/lib/app/plugins/
    Package manager: npm, pip, cargo install
    Registry/marketplace: API call to plugin store
    Configuration: explicit list in config file
    Convention: naming convention (app-plugin-*)
  
  Metadata:
    Plugin manifest (package.json, plugin.json, pyproject.toml)
    Contains: name, version, description, entry point, dependencies

Phase 2: Resolution
  Resolve dependencies and compatibility
  
  Checks:
    - Host version compatibility (semver range)
    - Inter-plugin dependencies
    - Conflicting plugins (mutual exclusion)
    - Required capabilities/permissions
  
  Dependency graph:
    Plugin A requires Plugin B → load B first
    Circular dependencies → error or lazy resolution

Phase 3: Loading
  Load plugin code into memory
  
  Methods:
    Dynamic import: require(path) or import(path)
    Shared library: dlopen(), LoadLibrary()
    Subprocess: spawn isolated process
    WebAssembly: instantiate .wasm module
  
  This phase should NOT execute plugin logic yet
  Just: parse, compile, make available

Phase 4: Initialization
  Plugin sets up its internal state
  
  // Plugin exports activate function
  export function activate(context) {
    context.subscriptions.push(
      commands.register('myCommand', handler),
      events.on('save', onSave)
    );
  }
  
  Host provides: API context, services, configuration
  Plugin provides: event handlers, commands, UI contributions

Phase 5: Active
  Plugin is running and responding to events
  Host tracks: active plugins, registered hooks, resources
  Monitoring: error rates, performance impact

Phase 6: Deactivation
  Clean shutdown
  
  export function deactivate() {
    // Unregister hooks
    // Close connections
    // Flush buffers
    // Release resources
  }
  
  Triggered by: user disable, plugin crash, host shutdown
  Host cleans up: remove hooks, free resources, update state

Phase 7: Unloading
  Remove plugin code from memory
  Particularly important for hot-reloading during development
  In some languages: requires process restart (no unloading)
  Node.js: delete require.cache entries (fragile)
  .NET: use separate AppDomain or AssemblyLoadContext
EOF
}

cmd_hooks() {
    cat << 'EOF'
=== Hook Systems ===

Action Hooks (fire-and-forget):
  Notify plugins that something happened
  Plugins react but don't modify the event
  
  // WordPress-style
  do_action('user_registered', userId, userData);
  
  // Plugin
  add_action('user_registered', function(userId, userData) {
    sendWelcomeEmail(userId);
  });
  
  Multiple handlers run sequentially (or parallel)
  Order controlled by priority parameter

Filter Hooks (transform data):
  Pass data through plugins, each can modify it
  
  // WordPress-style
  title = apply_filters('the_title', rawTitle, postId);
  
  // Plugin
  add_filter('the_title', function(title, postId) {
    return title.toUpperCase();
  });
  
  Chain: each filter receives output of previous filter
  Must return a value (or original passes through unchanged)

Tapable (webpack pattern):
  Named hooks with typed call patterns
  
  Hook Types:
    SyncHook:        synchronous, no return value
    SyncBailHook:    stops when handler returns non-undefined
    SyncWaterfallHook: each handler receives previous return
    AsyncParallelHook: handlers run in parallel
    AsyncSeriesHook:   handlers run in sequence
  
  // Host defines hooks
  this.hooks = {
    compile: new SyncHook(['params']),
    emit: new AsyncSeriesHook(['compilation']),
    done: new AsyncSeriesHook(['stats'])
  };
  
  // Plugin taps into hooks
  compiler.hooks.emit.tapAsync('MyPlugin', (compilation, callback) => {
    // modify compilation
    callback();
  });

Event Emitter Pattern:
  Node.js EventEmitter or browser EventTarget
  
  // Host
  class App extends EventEmitter { ... }
  app.emit('request', req, res);
  
  // Plugin
  app.on('request', (req, res) => { ... });
  app.once('init', () => { ... });  // one-time
  
  Pros: familiar, built-in, simple
  Cons: no type safety, string-based, memory leak risk

Priority and Ordering:
  WordPress: add_action(hook, fn, priority=10)
    Lower number = runs earlier
    Same priority = registration order
  
  VS Code: activation events determine when plugin loads
  webpack: plugin apply() order = configuration order
  
  Best practice:
    Default priority for most plugins
    Early priority for setup/auth
    Late priority for cleanup/logging

Hook Namespacing:
  Prevent collisions in large ecosystems
  
  Patterns:
    'core:beforeSave'         (namespace:event)
    'plugin-name.onActivate'  (plugin.event)
    Symbol-based hooks        (impossible to collide)
  
  Convention: document all hooks in API reference
  Breaking hook changes = semver major version bump
EOF
}

cmd_isolation() {
    cat << 'EOF'
=== Plugin Isolation & Sandboxing ===

Why Isolate Plugins?
  Untrusted code running in your application
  Risks: crash the host, steal data, consume resources
  Isolation limits damage from buggy or malicious plugins

Isolation Levels (least to most isolated):

1. Same Process, Same Context:
  Plugin runs in same thread and memory space
  No isolation — plugin can do anything the host can
  Fast: direct function calls, shared memory
  Used by: webpack, Babel, Express middleware
  Trust: only for trusted/first-party plugins

2. Same Process, Sandboxed Context:
  Restricted execution environment
  
  Node.js vm module:
    const vm = require('vm');
    const sandbox = { console: safeConsole, api: pluginAPI };
    vm.runInNewContext(pluginCode, sandbox, { timeout: 1000 });
    // Plugin can't access require, process, fs
  
  Browser iframe (sandboxed):
    <iframe sandbox="allow-scripts" src="plugin.html">
    CSP headers restrict capabilities
  
  Pros: moderate isolation, still fast
  Cons: escape vulnerabilities, limited resource control

3. Separate Process:
  Plugin runs in child process, communicates via IPC
  
  VS Code Extension Host:
    Main process (UI) ←IPC→ Extension Host process
    Extension crash doesn't crash VS Code
    Can restart extension host without restarting editor
  
  Figma plugins:
    UI in iframe, logic in Web Worker
    Communicate via postMessage
    No direct DOM access from plugin logic
  
  Pros: crash isolation, resource limits, process-level permissions
  Cons: IPC overhead, serialization cost, more complex API

4. WebAssembly Sandbox:
  Plugin compiled to WASM, runs in WASM runtime
  
  Properties:
    Memory isolation: can't access host memory
    No system calls: must go through imported functions
    Deterministic: same input → same output
    Multi-language: plugins written in C, Rust, Go, etc.
  
  WASI (WebAssembly System Interface):
    Capability-based security
    Host grants specific permissions (file access, network)
    Plugin can only do what host explicitly allows
  
  Used by: Envoy proxy (filters), Figma (upcoming), Zed editor
  Frameworks: Extism, wasmtime, wasmer

5. Container/VM Isolation:
  Heaviest isolation — separate OS environment
  
  Docker containers per plugin
  Serverless functions (Lambda) per plugin action
  Full VM per plugin (overkill for most uses)
  
  Pros: strongest isolation, resource limits, any language
  Cons: slow startup, high overhead, complex orchestration

Permission Systems:
  Declare required permissions in plugin manifest:
    "permissions": ["filesystem:read", "network:localhost", "clipboard"]
  
  Host prompts user to grant permissions
  Runtime enforcement: API calls check permissions before executing
  Principle of least privilege: default deny, explicit grant
EOF
}

cmd_api() {
    cat << 'EOF'
=== Plugin API Design ===

API Stability:
  Your plugin API is a contract with ecosystem developers
  Breaking changes = angry developers + broken plugins
  
  Versioning strategy:
    Semver: major.minor.patch
    Major: breaking API changes (avoid if possible)
    Minor: new features, backward compatible
    Patch: bug fixes only
    
  Deprecation process:
    1. Mark old API as deprecated (warning, not error)
    2. Provide migration guide and new API
    3. Support deprecated API for ≥1 major version
    4. Remove in next major version

  API evolution techniques:
    Additive: add new methods/hooks (safe)
    Optional parameters: extend existing functions (safe)
    Feature detection: plugins check for API availability
    Capability negotiation: plugin declares required API version

API Surface Design:
  Minimal API:
    Expose least possible surface area
    Each public API becomes a maintenance burden
    "Easy to learn, hard to misuse"
    
  Layered API:
    Core API: essential, stable, everyone uses
    Extended API: advanced, opt-in, may change
    Internal API: host-only, not for plugins
    
  Typed API:
    TypeScript definitions for plugin authors
    @types/plugin-name package
    Auto-complete and compile-time checks
    Document with JSDoc even if not using TypeScript

Configuration:
  Plugin manifest declares configuration schema
  Host provides UI for user to configure plugin
  
  // Plugin manifest
  {
    "configuration": {
      "myPlugin.timeout": {
        "type": "number",
        "default": 5000,
        "description": "Request timeout in milliseconds"
      }
    }
  }
  
  // Plugin reads config
  const timeout = api.getConfig('myPlugin.timeout');

Context Object:
  Single entry point for plugin → host communication
  
  interface PluginContext {
    // Lifecycle
    subscriptions: Disposable[];
    
    // Services
    logger: Logger;
    storage: KeyValueStore;
    config: ConfigReader;
    
    // Extension points
    commands: CommandRegistry;
    hooks: HookRegistry;
    ui: UIContributions;
    
    // Metadata
    pluginPath: string;
    version: string;
  }

Error Handling:
  Plugin errors should never crash the host
  Wrap all plugin calls in try/catch
  Log plugin errors with plugin identifier
  Disable repeatedly crashing plugins
  Provide error reporting to plugin authors
EOF
}

cmd_realworld() {
    cat << 'EOF'
=== Real-World Plugin Systems ===

VS Code Extensions:
  Architecture: main process + extension host process
  Language: TypeScript/JavaScript
  Discovery: VS Code Marketplace
  Isolation: separate Node.js process, UI in webview
  API: vscode namespace (commands, window, workspace)
  Activation: event-based (file type, command, startup)
  Manifest: package.json with contributes section
  ~50,000 extensions in marketplace
  
  Key design decisions:
    - Extensions can't modify editor UI directly
    - Declarative contributions (menus, keybindings, themes)
    - Extension host can be restarted independently
    - Language Server Protocol (LSP) for language features

webpack Plugins:
  Architecture: tapable hooks throughout compilation
  Language: JavaScript
  API: compiler and compilation hooks
  Pattern: apply(compiler) method registers taps
  
  class MyPlugin {
    apply(compiler) {
      compiler.hooks.emit.tap('MyPlugin', (compilation) => {
        // modify output before writing to disk
      });
    }
  }
  
  ~80 built-in hooks across compilation lifecycle
  Plugins can create new hooks (sub-plugins)

WordPress Plugins:
  Architecture: action/filter hook system (event + transform)
  Language: PHP
  Discovery: WordPress.org plugin directory
  Isolation: none (same PHP process)
  API: add_action(), add_filter(), remove_action()
  ~60,000 plugins in directory
  
  Strengths: simple API, huge ecosystem
  Weaknesses: no isolation, security issues common,
              plugin conflicts, performance degradation

Vim/Neovim Plugins:
  Vim: VimScript plugins in ~/.vim/plugin/
  Neovim: Lua plugins, remote plugins (any language via RPC)
  Package managers: vim-plug, packer, lazy.nvim
  
  Neovim innovations:
    - Lua API (fast, familiar language)
    - Tree-sitter integration for syntax
    - LSP built-in (no plugin needed for basics)
    - Remote plugins via msgpack-RPC (any language)

Figma Plugins:
  Architecture: sandbox model (UI iframe + logic worker)
  Language: TypeScript/JavaScript
  API: figma.* namespace (read/write design document)
  Isolation: plugin logic in sandbox, no DOM/network access
  UI: HTML in iframe, communicates via postMessage
  
  Security model:
    - Can't make network requests from plugin logic
    - UI iframe can fetch but can't access figma.* API
    - Must pass messages between logic and UI
    - Storage API for persistent data

Babel Plugins:
  Architecture: visitor pattern over AST
  Plugin receives AST node types to handle
  Returns modified AST
  
  module.exports = function() {
    return {
      visitor: {
        Identifier(path) {
          if (path.node.name === 'foo') {
            path.node.name = 'bar';
          }
        }
      }
    };
  };
  
  Composable: multiple plugins transform in sequence
  Presets: curated collections of plugins
EOF
}

cmd_testing() {
    cat << 'EOF'
=== Testing Plugin Systems ===

Testing the Plugin (as plugin author):

  Unit Testing:
    Test plugin logic in isolation
    Mock the host API (context object, services)
    
    const mockContext = {
      hooks: { on: jest.fn() },
      logger: { info: jest.fn() },
      config: { get: jest.fn().mockReturnValue(5000) }
    };
    
    plugin.activate(mockContext);
    expect(mockContext.hooks.on).toHaveBeenCalledWith('save', expect.any(Function));

  Integration Testing:
    Test plugin with real (or minimal) host
    VS Code: @vscode/test-electron runs tests in VS Code instance
    webpack: create minimal webpack config with plugin
    
    const webpack = require('webpack');
    const config = { plugins: [new MyPlugin()] };
    webpack(config, (err, stats) => {
      expect(stats.compilation.assets['output.js']).toBeDefined();
    });

  Compatibility Testing:
    Test against multiple host versions
    CI matrix: test plugin with host v1.0, v1.1, v1.2
    Catch breaking changes early

Testing the Host (as host developer):

  Plugin API Contract Tests:
    Define test suite that verifies API contract
    Run against each API version
    "Can a plugin register a command?"
    "Does hook receive correct arguments?"
    "Does error handling contain plugin crashes?"
    
  Mock Plugin Testing:
    Create test plugins that exercise API edges
    Crashing plugin: ensures host survives
    Slow plugin: ensures timeout works
    Greedy plugin: ensures resource limits work
    Malicious plugin: ensures sandboxing works

  Performance Testing:
    Measure: startup time with 0, 10, 50, 100 plugins
    Measure: hook execution overhead per plugin count
    Measure: memory usage per plugin
    Set performance budgets: "startup < 2s with 50 plugins"

  Compatibility Matrix:
    Host Version × Plugin Version grid
    Automated: CI runs all combinations
    Badge: "works with host v2.x and v3.x"

  Snapshot Testing:
    Record plugin API surface (TypeScript declarations)
    Compare against previous version
    Any difference = intentional change or regression
    Tools: api-extractor (Microsoft), ts-morph

End-to-End Testing:
  Full system: host + real plugins + user scenarios
  Selenium/Playwright for UI-based plugin systems
  User stories: "install plugin → configure → use feature → uninstall"
  Regression suite: real plugins from ecosystem as test subjects

Common Test Scenarios:
  - Plugin installation and activation
  - Plugin configuration changes
  - Multiple plugins interacting (hook ordering)
  - Plugin error handling (crash recovery)
  - Plugin uninstallation (cleanup verification)
  - Hot reload of plugin during development
  - Plugin with missing dependencies
  - Concurrent plugin operations
EOF
}

show_help() {
    cat << EOF
plugin v$VERSION — Plugin Architecture Reference

Usage: script.sh <command>

Commands:
  intro       Plugin architecture — goals, trade-offs, components
  patterns    Design patterns: hooks, middleware, visitor, DI, registry
  lifecycle   Plugin lifecycle: discovery → loading → activation
  hooks       Hook systems: actions, filters, tapable, events
  isolation   Sandboxing: process, WASM, container, permissions
  api         API design: stability, versioning, typed contracts
  realworld   Real-world: VS Code, webpack, WordPress, Vim, Figma
  testing     Testing plugin systems and plugins
  help        Show this help
  version     Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)     cmd_intro ;;
    patterns)  cmd_patterns ;;
    lifecycle) cmd_lifecycle ;;
    hooks)     cmd_hooks ;;
    isolation) cmd_isolation ;;
    api)       cmd_api ;;
    realworld) cmd_realworld ;;
    testing)   cmd_testing ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "plugin v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
