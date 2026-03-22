#!/usr/bin/env bash
# middleware — Middleware Architecture Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Middleware Architecture ===

Middleware is software that sits between a request and a response,
processing, transforming, or intercepting data as it flows through
a pipeline.

Core Concept:
  Client → [MW1] → [MW2] → [MW3] → Handler → Response
  Each middleware can:
    - Modify the request before passing it on
    - Modify the response on the way back
    - Short-circuit the pipeline (reject, redirect, cache hit)
    - Pass control to the next middleware (next())

Origin:
  The term "middleware" originally described software connecting
  distributed systems (1968, NATO conference). In web development,
  it evolved to mean request-processing layers in HTTP servers.

Request Lifecycle:
  1. Request arrives at server
  2. Middleware stack executes in order:
     - Logging middleware records request
     - Auth middleware validates credentials
     - CORS middleware sets headers
     - Body parser middleware decodes payload
     - Rate limiter checks quotas
  3. Route handler processes business logic
  4. Response middleware (compression, headers)
  5. Response sent to client

Key Properties:
  Composability:   combine small, focused middleware
  Reusability:     same middleware across routes/apps
  Separation:      each concern in its own middleware
  Order matters:   execution sequence is critical
  Bidirectional:   can process both request and response

Frameworks Using Middleware:
  Express.js    Linear pipeline (next-based)
  Koa.js        Onion model (async/await)
  Django        Middleware classes (process_request/response)
  ASP.NET Core  Request delegate pipeline
  Laravel       HTTP middleware (handle + $next)
  Gin (Go)      HandlerFunc chain (c.Next())
  Rack (Ruby)   Call-based middleware stack
  WSGI (Python) Application wrapper pattern
EOF
}

cmd_patterns() {
    cat << 'EOF'
=== Middleware Patterns ===

1. Linear Pipeline (Express-style):
  Request flows through middleware in order
  Each calls next() to pass control forward
  Response returns through the same chain in reverse (implicitly)

  app.use(A)    // A runs first
  app.use(B)    // B runs second
  app.use(C)    // C runs third (handler)

  Execution: A-enter → B-enter → C-enter → C-exit → B-exit → A-exit
  (But in Express, "exit" code runs only if explicitly structured)

2. Onion Model (Koa-style):
  Each middleware wraps the next, like layers of an onion
  Code before `await next()` = request phase (inward)
  Code after `await next()` = response phase (outward)

  app.use(async (ctx, next) => {
    // Request phase (outer layer going in)
    console.log('A-before');
    await next();
    // Response phase (outer layer going out)
    console.log('A-after');
  });

  Execution: A-before → B-before → C → B-after → A-after
  Advantage: natural try/catch error handling wraps inner layers

3. Interceptor Pattern:
  Hook into specific lifecycle events
  Common in Angular (HttpInterceptor), Axios, gRPC

  Interceptor has:
    - request handler (modify outgoing request)
    - response handler (modify incoming response)
    - error handler (handle failures)

4. Filter Chain (Java Servlet):
  javax.servlet.Filter with doFilter(req, res, chain)
  chain.doFilter() passes to next filter
  Configured in web.xml or annotations
  Order defined by declaration sequence

5. Decorator/Wrapper Pattern:
  Each middleware wraps the handler function
  handler = withAuth(withLogging(withCORS(baseHandler)))
  Inner-to-outer: CORS → Logging → Auth → baseHandler
  Common in functional programming approaches

6. Pipe and Filter:
  Unix-inspired: each stage transforms data
  Input → [Filter1] → [Filter2] → [Filter3] → Output
  Filters are independent, communicate via streams
  Used in: data processing pipelines, message queues

Choosing a Pattern:
  Web servers:      Pipeline or Onion
  API gateways:     Interceptor chains
  Data processing:  Pipe and Filter
  Microservices:    Sidecar proxy (Envoy, Istio)
EOF
}

cmd_express() {
    cat << 'EOF'
=== Express.js Middleware ===

Middleware Types:
  1. Application-level:  app.use(fn) or app.METHOD(path, fn)
  2. Router-level:       router.use(fn)
  3. Error-handling:     app.use((err, req, res, next) => {})
  4. Built-in:           express.json(), express.static()
  5. Third-party:        cors(), helmet(), morgan()

Function Signature:
  (req, res, next) => { ... }
  req:  IncomingMessage + Express additions (params, query, body)
  res:  ServerResponse + Express additions (json, send, status)
  next: function to pass control (next() or next(err))

Execution Rules:
  - Middleware runs in the order it's registered
  - Must call next() or send a response (otherwise request hangs)
  - Calling next(err) skips to error-handling middleware
  - Route-specific middleware only runs for matching routes

Common Ordering (recommended):
  1. Security headers (helmet)
  2. Request ID generation
  3. Logging (morgan)
  4. CORS
  5. Body parsing (express.json)
  6. Cookie/session parsing
  7. Authentication
  8. Rate limiting
  9. Route handlers
  10. 404 handler
  11. Error handler (MUST be last, has 4 params)

Mounting Patterns:
  Global:     app.use(middleware)
  Path:       app.use('/api', middleware)
  Route:      app.get('/users', authMiddleware, handler)
  Router:     const router = express.Router(); router.use(mw)

Gotchas:
  - Error middleware MUST have exactly 4 parameters
  - express.json() must come BEFORE routes that read req.body
  - Static middleware should be early (no auth needed for assets)
  - next() without 'return' continues executing current middleware
  - Async errors need try/catch or express-async-errors package
EOF
}

cmd_auth() {
    cat << 'EOF'
=== Authentication Middleware Patterns ===

JWT (JSON Web Token) Middleware:
  Flow:
    1. Client sends: Authorization: Bearer <token>
    2. Middleware extracts token from header
    3. Verify signature (HMAC-SHA256 or RSA)
    4. Check expiration (exp claim)
    5. Attach decoded payload to request (req.user)
    6. Call next() or reject with 401

  JWT Structure:
    Header.Payload.Signature (base64url encoded)
    Header:  { "alg": "HS256", "typ": "JWT" }
    Payload: { "sub": "user123", "role": "admin", "exp": 1699999999 }
    Signature: HMAC-SHA256(header + "." + payload, secret)

  Security Considerations:
    - Never store sensitive data in payload (it's base64, not encrypted)
    - Use short expiration (15 min) + refresh tokens
    - Validate issuer (iss) and audience (aud) claims
    - Use RS256 for microservices (public key verification)
    - Blacklist revoked tokens (Redis set of jti)

Session-Based Auth Middleware:
  Flow:
    1. Client sends session cookie (connect.sid)
    2. Middleware looks up session in store (Redis, DB)
    3. Deserializes user from session data
    4. Attaches user to request
    5. On response, updates session if modified

  Session Stores:
    In-memory:  development only (lost on restart)
    Redis:      fast, TTL support, clusterable
    Database:   persistent, slower, good for audit
    File:       simple, single-server only

API Key Middleware:
  Extraction: header (X-API-Key), query param, or bearer token
  Validation: hash lookup in database
  Considerations: rate limit per key, scope restrictions

Role-Based Access Control (RBAC):
  Middleware chain: authenticate → authorize
  authorize('admin', 'editor') checks req.user.role
  Return 403 Forbidden if role insufficient
  Keep authorization separate from authentication

  Permission Model:
    Role → Permissions mapping
    admin:  ['read', 'write', 'delete', 'manage']
    editor: ['read', 'write']
    viewer: ['read']
    Check: requiredPerms.every(p => userPerms.includes(p))

OAuth 2.0 Middleware:
  Validates access tokens (opaque or JWT)
  May call token introspection endpoint
  Scope validation: required scopes vs token scopes
  Passport.js strategies for social login (Google, GitHub, etc.)
EOF
}

cmd_errors() {
    cat << 'EOF'
=== Error Handling Middleware ===

Centralized Error Handler Pattern:
  All errors funnel to a single error middleware
  Benefits: consistent error format, logging, no duplication

  Error Classification:
    Operational errors: expected failures (validation, auth, not found)
      → Return appropriate HTTP status + message
    Programming errors: bugs (null reference, type errors)
      → Log, return 500, alert developers

  HTTP Error Status Mapping:
    400 Bad Request       Invalid input, malformed JSON
    401 Unauthorized      Missing or invalid credentials
    403 Forbidden         Valid credentials, insufficient permissions
    404 Not Found         Resource doesn't exist
    409 Conflict          Duplicate resource, version conflict
    422 Unprocessable     Validation errors (semantic)
    429 Too Many Requests Rate limit exceeded
    500 Internal Error    Unexpected server error
    502 Bad Gateway       Upstream service failure
    503 Service Unavail   Maintenance, overloaded

  Error Response Format (JSON API style):
    {
      "error": {
        "status": 422,
        "code": "VALIDATION_ERROR",
        "message": "Email format is invalid",
        "details": [
          { "field": "email", "message": "Must be valid email" }
        ],
        "requestId": "req-abc123"
      }
    }

Async Error Handling:
  Problem: Express doesn't catch rejected promises by default

  Solution 1: wrap every handler
    const asyncHandler = (fn) => (req, res, next) =>
      Promise.resolve(fn(req, res, next)).catch(next);

  Solution 2: express-async-errors package
    require('express-async-errors');  // monkey-patches Express

  Solution 3: Express 5.x (native async support)

Error Propagation:
  Route/middleware calls next(error) → skips to error middleware
  Error middleware: (err, req, res, next) with 4 params
  Multiple error middleware: chain with next(err)

  Recommended stack:
    1. Validation error handler (format field errors)
    2. Auth error handler (401/403 specifics)
    3. Database error handler (duplicate key, connection)
    4. Catch-all error handler (log + 500)

Production Considerations:
  - Never expose stack traces to clients
  - Log full error details server-side
  - Include request ID for correlation
  - Monitor error rates and alert on spikes
  - Graceful shutdown on unhandled rejections
EOF
}

cmd_cors() {
    cat << 'EOF'
=== CORS Middleware ===

What is CORS?
  Cross-Origin Resource Sharing: browser security mechanism
  Blocks requests from different origins by default
  Origin = protocol + host + port (https://api.example.com:443)
  Server must explicitly allow cross-origin requests via headers

Key Headers:
  Response headers (server → browser):
    Access-Control-Allow-Origin:      allowed origin(s)
    Access-Control-Allow-Methods:     allowed HTTP methods
    Access-Control-Allow-Headers:     allowed request headers
    Access-Control-Allow-Credentials: allow cookies/auth
    Access-Control-Max-Age:           preflight cache (seconds)
    Access-Control-Expose-Headers:    headers readable by JS

  Request headers (browser → server, preflight):
    Origin:                           requesting origin
    Access-Control-Request-Method:    intended method
    Access-Control-Request-Headers:   intended custom headers

Simple Requests (no preflight):
  Method: GET, HEAD, or POST
  Headers: only Accept, Accept-Language, Content-Language,
           Content-Type (only form/text/multipart)
  No ReadableStream body

Preflight Requests:
  Browser sends OPTIONS request BEFORE the actual request
  Triggered by: PUT/DELETE/PATCH, custom headers, JSON content-type
  Server must respond to OPTIONS with CORS headers
  Browser caches preflight result (Max-Age)

Common Configurations:
  Allow single origin:
    Access-Control-Allow-Origin: https://app.example.com

  Allow multiple origins (dynamic):
    Check request Origin header against whitelist
    Set Allow-Origin to the matched origin (not *)
    Vary: Origin header must be set

  Allow all origins:
    Access-Control-Allow-Origin: *
    Cannot use with credentials (browser blocks)

  With credentials (cookies, auth headers):
    Access-Control-Allow-Credentials: true
    Access-Control-Allow-Origin: specific origin (not *)
    Client must set: credentials: 'include' (fetch)

Common Mistakes:
  - Setting Allow-Origin: * with credentials → browser error
  - Forgetting to handle OPTIONS preflight → 405 error
  - Missing Vary: Origin with dynamic origins → caching bugs
  - Not exposing custom headers → JS can't read them
  - CORS doesn't protect server (it's browser-enforced only)
  - API-to-API calls bypass CORS entirely (no browser involved)
EOF
}

cmd_performance() {
    cat << 'EOF'
=== Performance Middleware ===

Response Compression:
  Gzip: ~70-80% size reduction for text content
  Brotli: ~15-20% better than gzip, slower compression
  When to compress:
    - Text responses > 1KB (HTML, JSON, CSS, JS)
    - Skip for images, video (already compressed)
    - Skip for very small responses (overhead > savings)
  Content-Encoding: gzip / br
  Accept-Encoding: client declares support

HTTP Caching Headers:
  Cache-Control: public, max-age=31536000    (static assets)
  Cache-Control: private, no-cache           (user-specific)
  Cache-Control: no-store                    (sensitive data)
  ETag: "hash-of-content"                    (conditional request)
  Last-Modified: date                        (time-based validation)
  304 Not Modified: content unchanged, skip body

  Middleware strategy:
    Static assets: immutable, long max-age, hashed filenames
    API responses: no-cache + ETag (revalidate each time)
    Private data: private, no-store

Rate Limiting:
  Algorithms:
    Fixed window:    simple counter per time window
    Sliding window:  weighted average of current + previous window
    Token bucket:    refill tokens at fixed rate, consume per request
    Leaky bucket:    process at fixed rate, queue excess

  Headers (RFC 6585 / draft-ietf-httpapi-ratelimit-headers):
    RateLimit-Limit:     max requests per window
    RateLimit-Remaining: requests left
    RateLimit-Reset:     seconds until window resets
    Retry-After:         seconds to wait (on 429)

  Storage: in-memory (single server), Redis (distributed)
  Strategies: per-IP, per-user, per-API-key, per-endpoint

Request Timeout:
  Set maximum time for request processing
  Prevents slow requests from consuming resources
  Typical: 30s for API, 120s for uploads, 5s for health checks
  Return 408 Request Timeout or 504 Gateway Timeout

Request Body Limits:
  Prevent large payload attacks (DoS)
  express.json({ limit: '100kb' })
  File uploads: separate limit (e.g., 10MB)
  Return 413 Payload Too Large

Response Time Tracking:
  Measure and log processing time
  X-Response-Time header for debugging
  Feed into monitoring (Prometheus, DataDog)
  Alert on p95/p99 latency exceeding thresholds
EOF
}

cmd_testing() {
    cat << 'EOF'
=== Testing Middleware ===

Unit Testing (Isolated):
  Mock req, res, and next objects
  Verify middleware behavior independently

  Minimal mock objects:
    const req = { headers: {}, params: {}, query: {}, body: {} };
    const res = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn().mockReturnThis(),
      set: jest.fn().mockReturnThis(),
    };
    const next = jest.fn();

  Test patterns:
    1. Calls next() for valid requests
    2. Sends error response for invalid requests
    3. Modifies req/res correctly
    4. Handles edge cases (missing headers, malformed data)

  Example test structure:
    test('auth middleware rejects missing token', () => {
      authMiddleware(req, res, next);
      expect(res.status).toHaveBeenCalledWith(401);
      expect(next).not.toHaveBeenCalled();
    });

Integration Testing (with supertest):
  Test full middleware stack with real HTTP
  const request = require('supertest');
  const app = require('./app');

  test('POST /api/users requires auth', async () => {
    const res = await request(app)
      .post('/api/users')
      .send({ name: 'test' });
    expect(res.status).toBe(401);
  });

  test('POST /api/users with valid token succeeds', async () => {
    const res = await request(app)
      .post('/api/users')
      .set('Authorization', 'Bearer valid-token')
      .send({ name: 'test' });
    expect(res.status).toBe(201);
  });

Testing Middleware Order:
  Create test that verifies middleware execution sequence
  Use spy/mock that records call order
  Verify: logging runs before auth runs before handler

  const callOrder = [];
  app.use((req, res, next) => { callOrder.push('logger'); next(); });
  app.use((req, res, next) => { callOrder.push('auth'); next(); });
  // After request: expect(callOrder).toEqual(['logger', 'auth']);

Common Test Scenarios:
  - Missing/invalid/expired auth tokens
  - Request body validation failures
  - Rate limit exceeded
  - CORS preflight and actual requests
  - Error propagation through middleware chain
  - Async middleware timeout
  - Large request body rejection
  - Concurrent request handling
EOF
}

show_help() {
    cat << EOF
middleware v$VERSION — Middleware Architecture Reference

Usage: script.sh <command>

Commands:
  intro        Middleware concept — history, lifecycle, frameworks
  patterns     Design patterns: pipeline, onion, interceptor
  express      Express.js middleware types and ordering
  auth         Authentication middleware: JWT, session, RBAC
  errors       Error handling middleware patterns
  cors         CORS middleware and configuration
  performance  Compression, caching, rate limiting
  testing      Testing middleware in isolation and integration
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)       cmd_intro ;;
    patterns)    cmd_patterns ;;
    express)     cmd_express ;;
    auth)        cmd_auth ;;
    errors)      cmd_errors ;;
    cors)        cmd_cors ;;
    performance) cmd_performance ;;
    testing)     cmd_testing ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "middleware v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
