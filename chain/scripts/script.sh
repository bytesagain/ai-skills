#!/usr/bin/env bash
# chain — Chain Pattern & Pipeline Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Chain Patterns ===

A chain is a sequence of processing elements where the output of one
element feeds into the input of the next. This fundamental pattern
appears everywhere in software — from Unix pipes to blockchain.

Core Variants:

  Chain of Responsibility (GoF):
    Request passes through handlers until one handles it
    Each handler decides: process OR pass to next
    Decouples sender from receiver

  Middleware Pipeline:
    Request flows through ALL middleware in sequence
    Each can modify request/response or short-circuit
    Express.js, Django, ASP.NET Core pattern

  Promise Chain:
    Async operations linked by .then()/.catch()
    Each step transforms the value for the next
    Error propagation through the chain

  Unix Pipeline:
    cmd1 | cmd2 | cmd3
    stdout of one → stdin of next
    The original chain pattern (1973)

  Filter Chain:
    Each filter transforms or filters data
    Java Servlet filters, decorator pattern
    Composable, reorderable processing steps

  Blockchain:
    Each block links to previous via cryptographic hash
    Append-only chain of blocks (immutable ledger)

Why Chains Work:
  - Single Responsibility: each handler does one thing
  - Open/Closed: add new handlers without modifying existing
  - Loose coupling: handlers don't know about each other
  - Composable: mix and match handlers for different needs
  - Testable: test each handler in isolation
EOF
}

cmd_responsibility() {
    cat << 'EOF'
=== Chain of Responsibility (GoF Design Pattern) ===

Intent: Avoid coupling the sender of a request to its receiver by
giving more than one object a chance to handle the request. Chain
the receiving objects and pass the request along until one handles it.

Structure:
  Client → Handler₁ → Handler₂ → Handler₃ → (end)
           ↓           ↓           ↓
         handle?     handle?     handle?

Participants:
  Handler:     Abstract interface with handleRequest() and setNext()
  ConcreteHandler: Implements handling logic, calls next if can't handle
  Client:      Initiates the request to the first handler

Classic Example — Support Escalation:
  Level 1 (FAQ Bot):     Can handle? Yes → respond. No → pass.
  Level 2 (Junior Agent): Can handle? Yes → respond. No → pass.
  Level 3 (Senior Agent): Can handle? Yes → respond. No → pass.
  Level 4 (Manager):      Handles everything remaining.

Pseudocode:
  abstract class Handler {
    next: Handler
    setNext(handler): Handler { next = handler; return handler; }
    handle(request) {
      if (next) return next.handle(request);
      return null;  // end of chain
    }
  }

  class AuthHandler extends Handler {
    handle(request) {
      if (!request.isAuthenticated) return "401 Unauthorized";
      return super.handle(request);  // pass to next
    }
  }

  class RateLimitHandler extends Handler {
    handle(request) {
      if (request.rateLimited) return "429 Too Many Requests";
      return super.handle(request);
    }
  }

  // Build chain:
  auth = new AuthHandler();
  rateLimit = new RateLimitHandler();
  handler = new BusinessLogicHandler();
  auth.setNext(rateLimit).setNext(handler);

  // Use:
  result = auth.handle(request);

When to Use:
  ✓ Multiple objects may handle a request, and handler isn't known a priori
  ✓ You want to issue a request without specifying the receiver
  ✓ The set of handlers should be configurable dynamically
  ✗ Don't use when: every request MUST be handled (add a fallback)
  ✗ Don't use when: chain gets too long (performance concern)
EOF
}

cmd_middleware() {
    cat << 'EOF'
=== Middleware Chains ===

Middleware = functions that have access to request, response, and next().
Unlike CoR, ALL middleware typically runs (not just the first match).

Express.js (Node.js):
  app.use((req, res, next) => {
    console.log('Logger:', req.method, req.url);
    next();  // MUST call next() to continue chain
  });

  app.use((req, res, next) => {
    req.startTime = Date.now();
    next();
  });

  app.get('/api/data', (req, res) => {
    res.json({ data: '...' });  // terminal handler
  });

  Execution order:
    Request → Logger → Timer → Route Handler → Response

  Error middleware (4 arguments):
    app.use((err, req, res, next) => {
      console.error(err);
      res.status(500).json({ error: err.message });
    });

Koa.js (Onion Model):
  app.use(async (ctx, next) => {
    // Before downstream
    const start = Date.now();
    await next();  // call downstream middleware
    // After upstream (response on way back)
    ctx.set('X-Response-Time', `${Date.now() - start}ms`);
  });

  Flow:  → MW1 before → MW2 before → MW3 → MW2 after → MW1 after
  Like layers of an onion — request goes in, response comes out

Django (Python):
  class TimingMiddleware:
    def __init__(self, get_response):
      self.get_response = get_response

    def __call__(self, request):
      start = time.time()
      response = self.get_response(request)  # next middleware
      response['X-Time'] = f'{time.time() - start:.3f}s'
      return response

  MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.middleware.common.CommonMiddleware',
    'myapp.middleware.TimingMiddleware',
  ]

Common Middleware Layers:
  1. Logging / Request ID
  2. CORS headers
  3. Authentication
  4. Authorization / Permissions
  5. Rate limiting
  6. Request parsing (JSON body, cookies)
  7. Validation
  8. Business logic (route handler)
  9. Error handling
  10. Response formatting / compression
EOF
}

cmd_promise() {
    cat << 'EOF'
=== Promise Chains & Async Pipelines ===

Promise Chain Basics:
  fetch('/api/user')
    .then(response => response.json())       // parse JSON
    .then(user => fetch(`/api/posts/${user.id}`))  // fetch posts
    .then(response => response.json())       // parse posts
    .then(posts => console.log(posts))       // use data
    .catch(error => console.error(error));   // handle ANY error

  Key Rules:
    - .then() returns a NEW promise
    - Return value becomes next .then()'s input
    - Return a Promise → chain waits for it to resolve
    - .catch() catches errors from ANY previous step
    - .finally() runs regardless of success/failure

Error Propagation:
  Promise.resolve(1)
    .then(x => x + 1)           // 2
    .then(x => { throw 'oops'; }) // error thrown
    .then(x => x + 1)           // SKIPPED
    .then(x => x + 1)           // SKIPPED
    .catch(e => {                // catches 'oops'
      console.log(e);
      return 0;                  // recovery value
    })
    .then(x => x + 1);          // 1 (chain resumes)

Async/Await (Flattened Chains):
  // Promise chain:
  getUser().then(u => getPosts(u.id)).then(p => render(p));

  // Equivalent async/await:
  const user = await getUser();
  const posts = await getPosts(user.id);
  render(posts);

  // Error handling:
  try {
    const result = await riskyOperation();
  } catch (error) {
    handleError(error);
  }

Functional Pipeline Pattern:
  const pipe = (...fns) => x => fns.reduce((v, f) => f(v), x);

  const processUser = pipe(
    validateInput,
    normalizeEmail,
    hashPassword,
    saveToDatabase,
    sendWelcomeEmail,
  );

  const result = processUser(rawInput);

RxJS Observable Chains:
  of(1, 2, 3, 4, 5).pipe(
    filter(x => x % 2 === 0),
    map(x => x * 10),
    reduce((acc, x) => acc + x, 0),
  ).subscribe(result => console.log(result));  // 60

  Operators are chainable transformations on data streams
  Lazy evaluation — nothing happens until subscribe()
EOF
}

cmd_pipeline() {
    cat << 'EOF'
=== Unix Pipeline Philosophy ===

The Original Chain: Unix Pipes (1973)
  Doug McIlroy at Bell Labs: "Write programs that do one thing
  and do it well. Write programs to work together."

  cat file.txt | grep "error" | sort | uniq -c | sort -rn | head

  Each command:
    1. Reads from stdin
    2. Processes data
    3. Writes to stdout
    4. The | connects stdout → stdin

Pipeline Components:
  Source:     Produces data (cat, find, curl, echo)
  Filter:    Transforms data (grep, sed, awk, sort, uniq)
  Sink:      Consumes data (wc, tee, head, > file)

Classic Pipelines:
  # Count words per file, sorted
  find . -name "*.txt" | xargs wc -w | sort -rn

  # Extract, transform, load
  curl -s api.example.com/data | jq '.items[]' | tee raw.json | \
    jq '{id, name}' > processed.json

  # Log analysis
  tail -f /var/log/nginx/access.log | \
    awk '{print $1}' | sort | uniq -c | sort -rn | head -20

  # Find large files
  du -sh * | sort -rh | head -10

Pipeline vs Sequence:
  Pipeline:   cmd1 | cmd2 | cmd3  (concurrent, streaming)
  Sequence:   cmd1 && cmd2 && cmd3  (sequential, stop on error)
  Parallel:   cmd1 & cmd2 & wait   (concurrent, independent)

Named Pipes (FIFOs):
  mkfifo /tmp/mypipe
  producer > /tmp/mypipe &    # write to pipe
  consumer < /tmp/mypipe      # read from pipe
  Persistent pipe in filesystem, multiple processes can connect

Process Substitution:
  diff <(cmd1) <(cmd2)
  Treats command output as a file
  Example: diff <(sort file1) <(sort file2)

Performance:
  Pipes are buffered (64KB default on Linux)
  Processes run concurrently (true parallelism)
  Streaming: memory usage = O(buffer) regardless of data size
  10GB file processed with constant memory via pipeline
EOF
}

cmd_filter() {
    cat << 'EOF'
=== Filter Chains ===

Filter Pattern:
  Data → [Filter₁] → [Filter₂] → [Filter₃] → Processed Data
  Each filter can: transform, validate, enrich, or remove data

Java Servlet Filters:
  public class AuthFilter implements Filter {
    public void doFilter(Request req, Response res, FilterChain chain) {
      if (isAuthenticated(req)) {
        chain.doFilter(req, res);  // pass to next filter
      } else {
        res.sendError(401);        // short-circuit
      }
    }
  }

  <!-- web.xml ordering matters! -->
  <filter-mapping>
    <filter-name>LogFilter</filter-name>
    <url-pattern>/*</url-pattern>
  </filter-mapping>
  <filter-mapping>
    <filter-name>AuthFilter</filter-name>
    <url-pattern>/api/*</url-pattern>
  </filter-mapping>

Interceptor Pattern:
  Similar to filters but with more lifecycle hooks
  Spring: HandlerInterceptor
    preHandle()    → before controller
    postHandle()   → after controller, before view
    afterCompletion() → after everything

  AxiosInterceptors:
    axios.interceptors.request.use(config => {
      config.headers.Authorization = `Bearer ${token}`;
      return config;
    });
    axios.interceptors.response.use(
      response => response,
      error => { if (error.response.status === 401) refresh(); }
    );

Decorator Chain:
  Python decorators stack as a chain:
    @log_request          # 3rd: outermost
    @authenticate         # 2nd: check auth
    @rate_limit(100)      # 1st: check rate
    def handle_request():
      pass

  Execution: rate_limit → authenticate → log_request → handle_request
  Return:    handle_request → log_request → authenticate → rate_limit

Pipe & Filter Architecture:
  Architectural pattern for data processing systems
  Components:
    Pipe: connector between filters (queue, stream, channel)
    Filter: processing unit (stateless preferred)
  Examples:
    - Compiler: Lexer → Parser → Optimizer → Code Generator
    - ETL: Extract → Transform → Load
    - Image processing: Read → Resize → Sharpen → Compress → Save
    - Audio: Input → EQ → Reverb → Compressor → Output
EOF
}

cmd_blockchain() {
    cat << 'EOF'
=== Blockchain — Hash Chain Fundamentals ===

What Is a Blockchain?
  A chain of blocks where each block contains:
    1. Data (transactions, records, any information)
    2. Hash of this block (fingerprint)
    3. Hash of the previous block (the "chain" link)
    4. Timestamp
    5. Nonce (for proof-of-work)

Block Structure:
  ┌────────────────────────────┐
  │ Block #42                  │
  │ Timestamp: 2024-01-15      │
  │ Previous Hash: 0a3f...     │ ← links to Block #41
  │ Data: [transactions...]    │
  │ Nonce: 74829               │
  │ Hash: 00007b2c...          │ ← includes all above
  └────────────────────────────┘
           ↓ (previous hash link)
  ┌────────────────────────────┐
  │ Block #41                  │
  │ Previous Hash: 9c1e...     │ ← links to Block #40
  │ ...                        │
  └────────────────────────────┘

Hash Chain Property:
  Changing ANY data in block #41 changes its hash
  → Block #42's "previous hash" no longer matches
  → Block #42's hash changes too
  → Cascade invalidates ALL subsequent blocks
  → Tampering is immediately detectable

Consensus Mechanisms:
  Proof of Work (PoW):
    Miners find nonce such that hash starts with N zeros
    Difficulty adjusts to maintain ~10 min/block (Bitcoin)
    Energy-intensive but battle-tested

  Proof of Stake (PoS):
    Validators stake cryptocurrency as collateral
    Selected to create blocks based on stake amount
    Slashing: lose stake if you act maliciously
    Energy-efficient (Ethereum since 2022)

  Other: DPoS, PBFT, Raft (permissioned chains)

Key Properties:
  Immutable:        Once written, blocks can't be changed
  Distributed:      Many copies across network (no single point)
  Transparent:      Anyone can verify the chain
  Pseudonymous:     Addresses, not names
  Append-only:      New blocks added, old ones never removed

Use Cases Beyond Crypto:
  Supply chain tracking (provenance)
  Digital identity and credentials
  Voting systems (auditability)
  Healthcare records (patient-controlled)
  Smart contracts (self-executing agreements)
EOF
}

cmd_examples() {
    cat << 'EOF'
=== Chain Pattern Implementation Examples ===

--- JavaScript: Simple Middleware Chain ---
class MiddlewareChain {
  constructor() { this.stack = []; }
  use(fn) { this.stack.push(fn); return this; }
  execute(context) {
    let index = 0;
    const next = () => {
      if (index < this.stack.length) {
        this.stack[index++](context, next);
      }
    };
    next();
  }
}

const chain = new MiddlewareChain();
chain.use((ctx, next) => { ctx.log = []; ctx.log.push('A'); next(); });
chain.use((ctx, next) => { ctx.log.push('B'); next(); });
chain.use((ctx, next) => { ctx.log.push('C'); /* no next = stop */ });
chain.execute({});  // ctx.log = ['A', 'B', 'C']

--- Python: Functional Pipeline ---
from functools import reduce

def pipeline(*funcs):
    return lambda x: reduce(lambda v, f: f(v), funcs, x)

process = pipeline(
    str.strip,
    str.lower,
    lambda s: s.replace(' ', '_'),
    lambda s: f'processed_{s}',
)
print(process('  Hello World  '))  # 'processed_hello_world'

--- Go: Handler Chain ---
type Handler func(req string) string
type Middleware func(Handler) Handler

func logging(next Handler) Handler {
    return func(req string) string {
        fmt.Println("Log:", req)
        return next(req)
    }
}

func auth(next Handler) Handler {
    return func(req string) string {
        if req == "" { return "unauthorized" }
        return next(req)
    }
}

// Compose: chain = logging(auth(handler))
func chain(h Handler, mws ...Middleware) Handler {
    for i := len(mws) - 1; i >= 0; i-- {
        h = mws[i](h)
    }
    return h
}

--- Bash: Pipe Chain ---
# Data processing pipeline
generate_data() { seq 1 1000; }
filter_odds() { awk '$1 % 2 == 1'; }
square() { awk '{print $1 * $1}'; }
top_ten() { sort -rn | head -10; }

generate_data | filter_odds | square | top_ten
EOF
}

show_help() {
    cat << EOF
chain v$VERSION — Chain Pattern & Pipeline Reference

Usage: script.sh <command>

Commands:
  intro          Chain patterns overview and variants
  responsibility Chain of Responsibility design pattern
  middleware     Middleware chains — Express, Koa, Django
  promise        Promise chains and async pipelines
  pipeline       Unix pipeline philosophy and patterns
  filter         Filter chains, interceptors, decorators
  blockchain     Blockchain hash chain fundamentals
  examples       Implementation examples across languages
  help           Show this help
  version        Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)          cmd_intro ;;
    responsibility) cmd_responsibility ;;
    middleware)     cmd_middleware ;;
    promise)        cmd_promise ;;
    pipeline)       cmd_pipeline ;;
    filter)         cmd_filter ;;
    blockchain)     cmd_blockchain ;;
    examples)       cmd_examples ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "chain v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
