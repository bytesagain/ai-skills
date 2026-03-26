#!/bin/bash
# Bun - Fast JavaScript Runtime & Toolkit Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              BUN REFERENCE                                  ║
║          All-in-One JavaScript Runtime & Toolkit            ║
╚══════════════════════════════════════════════════════════════╝

Bun is a fast all-in-one JavaScript runtime, bundler, test runner,
and package manager. Built with Zig and JavaScriptCore (Safari's engine),
it's designed as a drop-in replacement for Node.js.

WHAT BUN REPLACES:
  node        → bun (runtime)
  npm/yarn    → bun install (package manager, 10-100x faster)
  npx         → bunx
  webpack     → bun build (bundler)
  jest/vitest → bun test (test runner)
  ts-node     → bun (native TypeScript)
  dotenv      → bun (native .env loading)
  nodemon     → bun --watch

BUN vs NODE vs DENO:
  ┌──────────────┬──────────┬──────────┬──────────┐
  │ Feature      │ Bun      │ Node.js  │ Deno     │
  ├──────────────┼──────────┼──────────┼──────────┤
  │ Engine       │ JSC      │ V8       │ V8       │
  │ TypeScript   │ Native   │ --strip* │ Native   │
  │ Package mgr  │ Built-in │ npm      │ Built-in │
  │ Bundler      │ Built-in │ External │ External │
  │ Test runner  │ Built-in │ Built-in*│ Built-in │
  │ .env         │ Auto     │ --env*   │ Manual   │
  │ Speed        │ Fastest  │ Fast     │ Fast     │
  │ node_modules │ Yes      │ Yes      │ Optional │
  │ npm compat   │ ~95%     │ 100%     │ ~80%     │
  │ Stability    │ Growing  │ Mature   │ Stable   │
  └──────────────┴──────────┴──────────┴──────────┘
  * Node 22+ features

INSTALL:
  curl -fsSL https://bun.sh/install | bash
  # or
  brew install oven-sh/bun/bun
  # or
  npm install -g bun
EOF
}

cmd_runtime() {
cat << 'EOF'
RUNTIME
=========

RUN FILES:
  bun run index.ts                # TypeScript (native!)
  bun run index.js                # JavaScript
  bun run index.jsx               # JSX
  bun run index.tsx               # TSX

  # No tsconfig needed, just works
  // index.ts
  const greeting: string = "Hello from Bun!";
  console.log(greeting);

WATCH MODE:
  bun --watch run index.ts        # Restart on file changes
  bun --hot run server.ts         # Hot reload (preserves state)

SCRIPTS (package.json):
  bun run dev                     # Run "dev" script
  bun run build                   # Run "build" script
  bun dev                         # Shorthand (if no conflict)

BUILT-IN APIs:
  // File I/O (fastest in any JS runtime)
  const file = Bun.file("data.json");
  const text = await file.text();
  const json = await file.json();
  await Bun.write("output.txt", "Hello");
  await Bun.write("image.png", await fetch("https://example.com/img.png"));

  // HTTP Server
  Bun.serve({
    port: 3000,
    fetch(req) {
      const url = new URL(req.url);
      if (url.pathname === "/api") return Response.json({ ok: true });
      return new Response("Hello Bun!");
    },
  });

  // SQLite (built-in, no npm package needed!)
  import { Database } from "bun:sqlite";
  const db = new Database("app.db");
  db.run("CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY, name TEXT)");
  db.run("INSERT INTO users (name) VALUES (?)", ["Alice"]);
  const users = db.query("SELECT * FROM users").all();

  // Password hashing
  const hash = await Bun.password.hash("secret123");
  const match = await Bun.password.verify("secret123", hash);

  // Shell (run commands)
  import { $ } from "bun";
  const result = await $`ls -la`.text();
  await $`echo Hello > output.txt`;

  // Glob
  const glob = new Bun.Glob("**/*.ts");
  for await (const file of glob.scan(".")) console.log(file);

.ENV AUTO-LOADING:
  Bun automatically loads .env, .env.local, .env.production
  No dotenv package needed!
  console.log(process.env.DATABASE_URL);  // Just works
EOF
}

cmd_packages() {
cat << 'EOF'
PACKAGE MANAGER
=================

Bun's package manager is 10-100x faster than npm.

COMMANDS:
  bun init                        # Create new project
  bun install                     # Install all dependencies
  bun add express                 # Add dependency
  bun add -d typescript           # Add dev dependency
  bun add -g serve                # Add global package
  bun remove express              # Remove dependency
  bun update                      # Update all
  bun update express              # Update specific
  bunx create-react-app my-app    # npx equivalent
  bun pm ls                       # List installed packages
  bun pm cache rm                 # Clear cache

SPEED COMPARISON:
  npm install (cold):    ~30 seconds
  yarn install (cold):   ~15 seconds
  pnpm install (cold):   ~10 seconds
  bun install (cold):    ~1-3 seconds

WHY SO FAST:
  - Written in Zig (native speed)
  - Global module cache (~/.bun/install/cache/)
  - Hardlinks instead of copies
  - Parallel downloads
  - Optimized resolution algorithm

BUN.LOCKB:
  Binary lockfile (not human-readable).
  Faster to parse than JSON lockfiles.
  Commit it to version control.

  # Convert to yarn.lock for readability
  bun install --yarn

WORKSPACES:
  // package.json
  {
    "workspaces": ["packages/*"]
  }

  bun install  # Installs all workspace deps
  bun run --filter=@myorg/web dev  # Run in specific workspace

COMPATIBILITY:
  - Reads package.json, package-lock.json, yarn.lock
  - Supports npm registry
  - Supports private registries
  - Supports .npmrc

  // bunfig.toml (Bun-specific config)
  [install]
  registry = "https://registry.npmjs.org/"

  [install.scopes]
  "@myorg" = { token = "$NPM_TOKEN", url = "https://npm.myorg.com/" }
EOF
}

cmd_bundler() {
cat << 'EOF'
BUNDLER & BUILD
=================

BASIC BUNDLING:
  bun build ./src/index.ts --outdir ./dist
  bun build ./src/index.ts --outfile ./dist/bundle.js

OPTIONS:
  bun build ./src/index.ts \
    --outdir ./dist \
    --minify \                    # Minify output
    --sourcemap=external \        # Source maps
    --target=browser \            # browser | bun | node
    --splitting \                 # Code splitting
    --entry-naming [name].[hash].js  # Hash filenames

PROGRAMMATIC:
  const result = await Bun.build({
    entrypoints: ["./src/index.ts"],
    outdir: "./dist",
    minify: true,
    sourcemap: "external",
    target: "browser",
    splitting: true,
    plugins: [myPlugin],
  });

  if (!result.success) {
    for (const msg of result.logs) console.error(msg);
  }

PLUGINS:
  import { plugin } from "bun";

  plugin({
    name: "yaml-loader",
    setup(build) {
      build.onLoad({ filter: /\.yaml$/ }, async (args) => {
        const text = await Bun.file(args.path).text();
        const yaml = require("js-yaml").load(text);
        return { contents: `export default ${JSON.stringify(yaml)}`, loader: "js" };
      });
    },
  });
EOF
}

cmd_testing() {
cat << 'EOF'
TEST RUNNER
=============

BASIC TEST:
  // math.test.ts
  import { describe, test, expect, beforeAll, afterEach, mock } from "bun:test";

  describe("math", () => {
    test("addition", () => {
      expect(2 + 2).toBe(4);
    });

    test("async", async () => {
      const res = await fetch("https://api.example.com/data");
      expect(res.ok).toBe(true);
    });

    test("throws", () => {
      expect(() => { throw new Error("boom"); }).toThrow("boom");
    });
  });

RUN TESTS:
  bun test                        # Run all *.test.{ts,js} files
  bun test math.test.ts           # Run specific file
  bun test --watch                # Watch mode
  bun test --timeout 10000        # 10s timeout
  bun test --bail                 # Stop on first failure
  bun test --coverage             # Code coverage

MATCHERS:
  expect(x).toBe(y)              // Strict equality
  expect(x).toEqual(y)           // Deep equality
  expect(x).toBeTruthy()
  expect(x).toBeFalsy()
  expect(x).toBeNull()
  expect(x).toContain("sub")
  expect(arr).toHaveLength(3)
  expect(fn).toHaveBeenCalled()
  expect(fn).toHaveBeenCalledWith(arg)
  expect(x).toMatchSnapshot()

MOCKING:
  import { mock, spyOn } from "bun:test";

  // Mock function
  const fn = mock(() => 42);
  fn(); fn();
  expect(fn).toHaveBeenCalledTimes(2);

  // Mock module
  mock.module("./database", () => ({
    query: mock(() => [{ id: 1, name: "Alice" }]),
  }));

  // Spy on object method
  const obj = { greet: () => "hello" };
  const spy = spyOn(obj, "greet").mockReturnValue("mocked");

LIFECYCLE:
  beforeAll(() => { /* setup once */ });
  afterAll(() => { /* cleanup once */ });
  beforeEach(() => { /* setup per test */ });
  afterEach(() => { /* cleanup per test */ });

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Bun - JavaScript Runtime & Toolkit Reference

Commands:
  intro      Overview, comparison, installation
  runtime    APIs, file I/O, HTTP server, SQLite, shell
  packages   Package manager, workspaces, speed
  bundler    Build, minify, plugins, code splitting
  testing    Test runner, matchers, mocking, coverage

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)    cmd_intro ;;
  runtime)  cmd_runtime ;;
  packages) cmd_packages ;;
  bundler)  cmd_bundler ;;
  testing)  cmd_testing ;;
  help|*)   show_help ;;
esac
