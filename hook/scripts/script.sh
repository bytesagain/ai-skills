#!/usr/bin/env bash
# hook — Hooks & Lifecycle Callbacks Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Hooks & Lifecycle Callbacks ===

A hook is a point in a program where custom code can be inserted to
modify behavior without changing the original code. Hooks appear
everywhere in modern development.

Hook Categories:
  1. VCS Hooks        Git pre-commit, commit-msg, pre-push
  2. Framework Hooks  React hooks, Vue lifecycle, Angular lifecycle
  3. Webhooks         HTTP callbacks between services
  4. System Hooks     OS signals, shutdown hooks, init hooks
  5. Plugin Hooks     WordPress actions/filters, webpack plugins
  6. ORM Hooks        Before/after save, validate, destroy

Common Properties of All Hooks:
  - Execute at a defined lifecycle point
  - Can modify behavior or data
  - Can be chained (multiple hooks per event)
  - Can be synchronous or asynchronous
  - Can block/prevent the main action (pre-hooks)
  - Can react to completed actions (post-hooks)

Hook vs Callback vs Event:
  Hook:      Predefined extension point (structured)
  Callback:  Function passed as argument (ad-hoc)
  Event:     Named signal with subscribers (decoupled)

  Hooks are MORE structured than events:
    - Defined by the framework, not by the user
    - Execute at specific lifecycle points
    - Often can modify data (not just observe)
    - Can prevent default behavior

Why Hooks Matter:
  - Enforce quality gates (pre-commit linting)
  - Enable plugin architectures (extensibility)
  - Decouple systems (webhooks between services)
  - Manage component lifecycle (React, Vue)
  - Automate workflows (CI/CD triggers)
EOF
}

cmd_git() {
    cat << 'EOF'
=== Git Hooks ===

Scripts that run automatically at specific points in the Git workflow.
Located in .git/hooks/ (local) or managed by tools like Husky.

--- Client-Side Hooks ---

  pre-commit:
    Runs before commit is created
    Use: lint, format, type-check staged files
    Exit non-zero → commit aborted
    Bypass: git commit --no-verify

    #!/bin/sh
    npm run lint-staged
    npm run typecheck

  prepare-commit-msg:
    Runs after default message, before editor opens
    Use: auto-add ticket number from branch name
    Arguments: $1 = message file, $2 = source, $3 = SHA

    #!/bin/sh
    BRANCH=$(git branch --show-current)
    TICKET=$(echo "$BRANCH" | grep -oP '[A-Z]+-\d+')
    if [ -n "$TICKET" ]; then
      sed -i "1s/^/[$TICKET] /" "$1"
    fi

  commit-msg:
    Runs after user enters message
    Use: enforce conventional commits format
    Exit non-zero → commit aborted

    #!/bin/sh
    MSG=$(cat "$1")
    if ! echo "$MSG" | grep -qE '^(feat|fix|docs|style|refactor|test|chore)(\(.+\))?: .+'; then
      echo "Error: Commit must follow Conventional Commits"
      echo "Format: type(scope): description"
      exit 1
    fi

  pre-push:
    Runs before push to remote
    Use: run full test suite, prevent force-push to main
    Arguments: remote name, URL via stdin

    #!/bin/sh
    protected_branch='main'
    current_branch=$(git branch --show-current)
    if [ "$current_branch" = "$protected_branch" ]; then
      echo "Direct push to main is not allowed"
      exit 1
    fi
    npm test

  post-merge:
    Runs after successful merge
    Use: auto-install dependencies when lockfile changes

    #!/bin/sh
    changed=$(git diff-tree -r --name-only ORIG_HEAD HEAD)
    if echo "$changed" | grep -q 'package-lock.json'; then
      npm ci
    fi

--- Server-Side Hooks ---
  pre-receive:    Validate all refs before accepting push
  update:         Per-ref validation (branch-level control)
  post-receive:   Trigger CI/CD, notify, deploy after push
EOF
}

cmd_react() {
    cat << 'EOF'
=== React Hooks ===

Introduced in React 16.8. Let you use state and lifecycle features
in function components (previously required class components).

--- Core Hooks ---

  useState:
    const [count, setCount] = useState(0);
    const [user, setUser] = useState(null);
    setCount(prev => prev + 1);  // functional update

  useEffect:
    // Runs after every render
    useEffect(() => { document.title = `Count: ${count}` });

    // Runs once on mount (empty deps)
    useEffect(() => { fetchData() }, []);

    // Runs when dep changes
    useEffect(() => { fetchUser(id) }, [id]);

    // Cleanup function (unmount / before re-run)
    useEffect(() => {
      const sub = subscribe(id);
      return () => sub.unsubscribe();  // cleanup
    }, [id]);

  useContext:
    const theme = useContext(ThemeContext);

  useRef:
    const inputRef = useRef(null);
    inputRef.current.focus();
    // Also: mutable value that doesn't trigger re-render

  useMemo:
    const sorted = useMemo(() => sortItems(items), [items]);
    // Recalculates only when items change

  useCallback:
    const handleClick = useCallback(() => {
      doSomething(a, b);
    }, [a, b]);
    // Stable reference, prevents child re-renders

  useReducer:
    const [state, dispatch] = useReducer(reducer, initialState);
    dispatch({ type: 'INCREMENT' });

--- Rules of Hooks ---
  1. Only call hooks at the TOP LEVEL
     ✗ if (condition) { useState(...) }
     ✗ for (...) { useEffect(...) }
     ✗ return early before a hook call
     ✓ Call hooks in the same order every render

  2. Only call hooks from React FUNCTIONS
     ✗ Regular JS functions
     ✓ React function components
     ✓ Custom hooks (useXxx)

--- Custom Hooks ---
  function useDebounce(value, delay) {
    const [debounced, setDebounced] = useState(value);
    useEffect(() => {
      const timer = setTimeout(() => setDebounced(value), delay);
      return () => clearTimeout(timer);
    }, [value, delay]);
    return debounced;
  }

  function useFetch(url) {
    const [data, setData] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);
    useEffect(() => {
      let cancelled = false;
      fetch(url)
        .then(r => r.json())
        .then(d => { if (!cancelled) { setData(d); setLoading(false); }})
        .catch(e => { if (!cancelled) { setError(e); setLoading(false); }});
      return () => { cancelled = true; };
    }, [url]);
    return { data, loading, error };
  }

--- Common Mistakes ---
  Missing dependency:  useEffect(() => fn(x), []) // x missing!
  Over-rendering:      New object in deps [] every render
  Stale closure:       setInterval with stale state variable
  Effect vs event:     Use useEffect for sync, not for events
EOF
}

cmd_webhook() {
    cat << 'EOF'
=== Webhooks ===

HTTP callbacks that notify external systems when events occur.
"Don't call us, we'll call you" — push-based integration.

--- Design Principles ---
  1. POST request to subscriber's URL
  2. JSON payload describing the event
  3. Signature header for verification
  4. Retry on failure with backoff
  5. Idempotent handling on receiver

--- Webhook Payload ---
  {
    "id": "evt_abc123",
    "type": "order.completed",
    "created": "2024-03-15T10:30:00Z",
    "data": {
      "order_id": "ord_456",
      "total": 99.99,
      "currency": "USD"
    }
  }

  Include:
    Event ID (for deduplication)
    Event type (for routing)
    Timestamp (for ordering)
    Relevant data (or resource ID to fetch)

--- Delivery ---
  HTTP POST to registered URL
  Content-Type: application/json
  Timeout: 5-30 seconds (don't block sender)
  Expected response: 2xx = success, anything else = retry

  Retry strategy:
    Exponential backoff: 1min, 5min, 30min, 2h, 12h
    Max retries: 5-10 attempts
    After max: mark as failed, notify admin
    Dead letter queue for failed deliveries

--- Receiver Implementation ---
  1. Verify signature FIRST
  2. Respond 200 immediately (before processing)
  3. Process asynchronously (queue the work)
  4. Handle duplicates (idempotent by event ID)
  5. Log everything (for debugging)

  // Express example
  app.post('/webhooks', (req, res) => {
    verifySignature(req);        // Step 1
    res.status(200).send('OK');  // Step 2
    queue.push(req.body);        // Step 3
  });

--- Common Webhook Providers ---
  GitHub:     push, PR, issue, release events
  Stripe:     payment, subscription, invoice events
  Twilio:     SMS received, call status events
  Slack:      message, reaction, slash command events
  Shopify:    order, product, customer events

--- Testing Webhooks ---
  ngrok:         Expose localhost to internet
  webhook.site:  Inspect payloads online
  RequestBin:    Capture and inspect requests
  Stripe CLI:    stripe listen --forward-to localhost:3000
EOF
}

cmd_lifecycle() {
    cat << 'EOF'
=== Framework Lifecycle Hooks ===

--- Vue 3 (Composition API) ---
  import { onMounted, onUpdated, onUnmounted } from 'vue';

  onBeforeMount()     Before DOM is created
  onMounted()         After DOM is created (fetch data here)
  onBeforeUpdate()    Before re-render
  onUpdated()         After re-render
  onBeforeUnmount()   Before component is destroyed (cleanup)
  onUnmounted()       After component is destroyed

  // Equivalent of React useEffect
  onMounted(() => {
    const timer = setInterval(tick, 1000);
    onUnmounted(() => clearInterval(timer));
  });

--- Angular ---
  ngOnInit()          After first ngOnChanges (init logic)
  ngOnChanges()       When input properties change
  ngDoCheck()         Custom change detection
  ngAfterViewInit()   After view is initialized
  ngOnDestroy()       Cleanup (unsubscribe, timers)

--- Kubernetes Pod Lifecycle ---
  postStart:    Runs after container starts (not guaranteed before ENTRYPOINT)
  preStop:      Runs before container is terminated
    Use: drain connections, save state, notify peers

  lifecycle:
    postStart:
      exec:
        command: ["/bin/sh", "-c", "register-service"]
    preStop:
      exec:
        command: ["/bin/sh", "-c", "deregister && sleep 10"]

  terminationGracePeriodSeconds: 30

--- Systemd Service Hooks ---
  ExecStartPre=    Before main process starts
  ExecStartPost=   After main process starts
  ExecStop=        Custom stop command
  ExecStopPost=    After service stops (cleanup)
  ExecReload=      On systemctl reload

--- Database ORM Hooks ---
  Sequelize:     beforeCreate, afterCreate, beforeUpdate, etc.
  Mongoose:      pre('save'), post('save'), pre('remove')
  TypeORM:       @BeforeInsert(), @AfterInsert(), @BeforeUpdate()
  SQLAlchemy:    before_insert, after_insert (event listeners)

  Common use cases:
    before_save:  Hash password, validate, set timestamps
    after_save:   Send notification, update cache, audit log
    before_delete: Check dependencies, soft-delete instead
EOF
}

cmd_tools() {
    cat << 'EOF'
=== Hook Management Tools ===

--- Husky (JavaScript/Node.js) ---
  Most popular Git hooks manager for JS projects

  Setup:
    npx husky init

  Add hook:
    echo "npm test" > .husky/pre-commit
    echo "npx commitlint --edit \$1" > .husky/commit-msg

  .husky/
  ├── pre-commit      Run linting + tests
  ├── commit-msg      Validate commit message
  └── pre-push        Run full test suite

--- lint-staged ---
  Run linters only on staged files (fast!)

  package.json:
    "lint-staged": {
      "*.{ts,tsx}": ["eslint --fix", "prettier --write"],
      "*.css": ["stylelint --fix"],
      "*.md": ["prettier --write"]
    }

  .husky/pre-commit:
    npx lint-staged

--- lefthook ---
  Fast, polyglot Git hooks manager (Go binary)
  Works with any language (not just Node.js)

  lefthook.yml:
    pre-commit:
      parallel: true
      commands:
        lint:
          run: npm run lint -- {staged_files}
          glob: "*.{ts,tsx}"
        test:
          run: npm test
        format:
          run: prettier --write {staged_files}

  Install: lefthook install

--- pre-commit (Python) ---
  Language-agnostic hook management

  .pre-commit-config.yaml:
    repos:
      - repo: https://github.com/pre-commit/pre-commit-hooks
        rev: v4.5.0
        hooks:
          - id: trailing-whitespace
          - id: end-of-file-fixer
          - id: check-yaml
      - repo: https://github.com/psf/black
        rev: 24.1.0
        hooks:
          - id: black

  Install: pre-commit install
  Run all: pre-commit run --all-files

--- Comparison ---
  Husky:        Best for JS/TS projects, simple setup
  lint-staged:  Pair with Husky for staged-only linting
  lefthook:     Polyglot, fast, parallel execution
  pre-commit:   Largest ecosystem, language-agnostic
  simple-git-hooks: Minimal alternative to Husky
EOF
}

cmd_patterns() {
    cat << 'EOF'
=== Hook Design Patterns ===

--- Plugin System (WordPress-style) ---
  Register hooks at named extension points:

  // Hook registry
  const hooks = {};
  function addFilter(name, fn, priority = 10) {
    hooks[name] = hooks[name] || [];
    hooks[name].push({ fn, priority });
    hooks[name].sort((a, b) => a.priority - b.priority);
  }
  function applyFilters(name, value, ...args) {
    return (hooks[name] || []).reduce(
      (val, hook) => hook.fn(val, ...args), value
    );
  }

  // Plugin registers
  addFilter('format_price', (price) => `$${price.toFixed(2)}`);

  // Core calls
  const display = applyFilters('format_price', 19.99);

--- Middleware Chain (Express/Koa-style) ---
  Each middleware can modify request/response or short-circuit:

  function compose(middleware) {
    return function(context) {
      let index = 0;
      function next() {
        const fn = middleware[index++];
        if (!fn) return;
        return fn(context, next);
      }
      return next();
    };
  }

  // Usage:
  app.use(authMiddleware);    // Hook: check auth
  app.use(rateLimiter);       // Hook: limit requests
  app.use(requestLogger);     // Hook: log request

--- Event Emitter (Observer) ---
  Decouple event producers from consumers:

  const emitter = new EventEmitter();
  emitter.on('user:created', sendWelcomeEmail);
  emitter.on('user:created', initializeDefaults);
  emitter.on('user:created', trackAnalytics);
  emitter.emit('user:created', { user });

--- Aspect-Oriented (Decorator) ---
  function withLogging(fn) {
    return function(...args) {
      console.log(`Calling ${fn.name} with`, args);
      const result = fn.apply(this, args);
      console.log(`${fn.name} returned`, result);
      return result;
    };
  }

  const save = withLogging(originalSave);

--- Tap/Pipeline ---
  value
    .pipe(validate)    // hook: validation
    .pipe(transform)   // hook: transformation
    .pipe(persist)     // hook: storage
    .pipe(notify);     // hook: notification
EOF
}

cmd_security() {
    cat << 'EOF'
=== Hook Security ===

--- Webhook Signature Verification ---

  HMAC-SHA256 (most common):
    Sender signs payload with shared secret
    Receiver verifies signature before processing

    // GitHub webhook verification
    const crypto = require('crypto');
    function verifyGitHub(payload, signature, secret) {
      const expected = 'sha256=' +
        crypto.createHmac('sha256', secret)
          .update(payload)
          .digest('hex');
      return crypto.timingSafeEqual(
        Buffer.from(signature),
        Buffer.from(expected)
      );
    }

  Stripe verification:
    const event = stripe.webhooks.constructEvent(
      body, sig_header, endpoint_secret
    );
    // Throws if signature invalid

--- Replay Prevention ---
  Problem: Attacker captures and resends valid webhook
  Solutions:
    1. Timestamp in header → reject if too old (> 5 minutes)
    2. Event ID → track processed IDs, skip duplicates
    3. Nonce → one-time token prevents replay

  // Timestamp check
  const timestamp = req.headers['x-webhook-timestamp'];
  const age = Date.now() - new Date(timestamp).getTime();
  if (age > 300000) throw new Error('Webhook too old');

--- Git Hook Security ---
  .git/hooks are NOT committed → can be modified locally
  Use committed hook configs (Husky, lefthook) for enforcement
  --no-verify bypasses client hooks → server hooks are authoritative
  Never store secrets in hook scripts
  Validate hook source (don't run arbitrary downloaded hooks)

--- Webhook Endpoint Security ---
  HTTPS only (never accept webhooks over HTTP)
  Rate limit webhook endpoint
  Validate Content-Type header
  Limit payload size (prevent DoS)
  Process async (don't hold connection open)
  Don't expose internal errors in response
  IP allowlisting (GitHub, Stripe publish their IPs)
  Separate webhook endpoint from main API

--- Common Vulnerabilities ---
  1. Missing signature verification → accept forged events
  2. Timing attack on string comparison → use timingSafeEqual
  3. SSRF via webhook URL → validate target URLs
  4. Deserialization attacks → sanitize payload before parsing
  5. Webhook loops → A notifies B, B notifies A → infinite loop
     Fix: loop detection header, max depth, circuit breaker
EOF
}

show_help() {
    cat << EOF
hook v$VERSION — Hooks & Lifecycle Callbacks Reference

Usage: script.sh <command>

Commands:
  intro        What hooks are and where they appear
  git          Git hooks: pre-commit, commit-msg, pre-push
  react        React hooks: useState, useEffect, custom hooks
  webhook      Webhook design, delivery, and integration
  lifecycle    Framework lifecycle hooks (Vue, Angular, K8s)
  tools        Hook management: Husky, lefthook, lint-staged
  patterns     Hook design patterns: plugins, middleware, events
  security     Webhook verification and hook security
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)     cmd_intro ;;
    git)       cmd_git ;;
    react)     cmd_react ;;
    webhook)   cmd_webhook ;;
    lifecycle) cmd_lifecycle ;;
    tools)     cmd_tools ;;
    patterns)  cmd_patterns ;;
    security)  cmd_security ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "hook v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
