#!/usr/bin/env bash
# error — Error Handling & Resilience Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Error Handling Overview ===

Error handling is the practice of anticipating, detecting, and
resolving errors to maintain system reliability and user trust.

Error Categories:

  Operational Errors (expected, recoverable):
    - Network timeout
    - File not found
    - Invalid user input
    - Rate limit exceeded
    - Disk full
    → Handle gracefully, retry or inform user

  Programming Errors (bugs, should not happen):
    - Null pointer dereference
    - Array index out of bounds
    - Type mismatch
    - Assertion failure
    → Fix the code, crash is appropriate

  System Errors (environment failures):
    - Out of memory
    - Stack overflow
    - Hardware failure
    - OS-level errors
    → May not be recoverable at application level

Design Principles:
  1. Fail fast          Detect errors early, don't propagate bad state
  2. Fail loudly        Log errors, alert operators, don't swallow silently
  3. Fail safely        Degrade gracefully, protect user data
  4. Be specific        Use precise error types, not generic "error"
  5. Be actionable      Error messages should suggest what to do
  6. Separate concerns  Different handling for different error types
  7. Don't ignore       Never catch and swallow exceptions silently

Error Handling Approaches by Language:
  Exceptions    Java, Python, C#, JavaScript (try/catch/finally)
  Result Types  Rust (Result<T,E>), Go (value, error), Haskell (Either)
  Error Codes   C (errno), POSIX (return -1), Win32 (GetLastError)
  Monadic       Haskell (Maybe/Either), Scala (Option/Try/Either)
  Panic/Recover Go (panic/recover), Rust (panic!/catch_unwind)

Golden Rule:
  Handle errors at the level that has enough context to do
  something meaningful about them. Don't catch errors just
  to re-throw them without adding value.
EOF
}

cmd_http() {
    cat << 'EOF'
=== HTTP Status Codes ===

1xx Informational:
  100 Continue           Client should continue with request
  101 Switching Protocols Upgrade to WebSocket, HTTP/2
  102 Processing         WebDAV — server is processing (takes long)

2xx Success:
  200 OK                 Standard success response
  201 Created            Resource created (POST, PUT)
  202 Accepted           Request accepted, processing async
  204 No Content         Success, no body (DELETE, PUT)
  206 Partial Content    Range request fulfilled

3xx Redirection:
  301 Moved Permanently  URL changed forever (update bookmarks)
  302 Found              Temporary redirect (historically misused)
  303 See Other          Redirect to GET another resource
  304 Not Modified       Cached version is still valid
  307 Temporary Redirect Preserve method (POST stays POST)
  308 Permanent Redirect Like 301 but preserves method

4xx Client Error:
  400 Bad Request        Malformed syntax, invalid parameters
  401 Unauthorized       Authentication required (misleading name)
  403 Forbidden          Authenticated but not authorized
  404 Not Found          Resource doesn't exist
  405 Method Not Allowed HTTP method not supported for this URL
  408 Request Timeout    Client too slow to send request
  409 Conflict           State conflict (optimistic locking, duplicate)
  410 Gone               Resource permanently removed (unlike 404)
  413 Payload Too Large  Request body exceeds limit
  415 Unsupported Media  Content-Type not accepted
  422 Unprocessable      Syntax OK but semantically invalid
  429 Too Many Requests  Rate limit exceeded (include Retry-After)
  451 Unavailable Legal  Blocked for legal reasons

5xx Server Error:
  500 Internal Error     Generic server error (catch-all)
  501 Not Implemented    Server doesn't support the method
  502 Bad Gateway        Upstream server returned invalid response
  503 Service Unavailable Server overloaded or in maintenance
  504 Gateway Timeout    Upstream server timed out

Common Mistakes:
  ✗ Using 200 for errors (with error in body)
  ✗ Using 500 for client errors (400-level)
  ✗ Using 404 when 403 is appropriate (security vs UX)
  ✗ Using 401 when 403 is correct (auth vs authz)
  ✗ Not including Retry-After with 429/503
  ✗ Using 302 when 307/308 is needed (method preservation)

Retryable Status Codes:
  408   Request Timeout        → Retry immediately
  429   Too Many Requests      → Retry after Retry-After header
  500   Internal Server Error  → Retry with backoff
  502   Bad Gateway            → Retry with backoff
  503   Service Unavailable    → Retry after Retry-After header
  504   Gateway Timeout        → Retry with backoff

Not Retryable:
  400, 401, 403, 404, 405, 409, 413, 415, 422
  (Client must fix the request, not retry as-is)
EOF
}

cmd_patterns() {
    cat << 'EOF'
=== Error Handling Patterns ===

Try/Catch (Exception-Based):
  try {
    result = riskyOperation();
  } catch (SpecificError e) {
    handleSpecific(e);        // Handle known error type
  } catch (Error e) {
    handleGeneric(e);         // Catch-all
  } finally {
    cleanup();                // Always runs
  }

  Best practices:
  - Catch specific exceptions, not generic Exception
  - Don't use exceptions for control flow
  - Always clean up resources (finally/using/defer)
  - Add context when re-throwing

Result Type (Rust/Go style):
  // Rust
  fn read_file(path: &str) -> Result<String, io::Error> {
      let content = fs::read_to_string(path)?;  // ? propagates error
      Ok(content)
  }

  // Go
  func readFile(path string) (string, error) {
      data, err := os.ReadFile(path)
      if err != nil {
          return "", fmt.Errorf("read %s: %w", path, err)
      }
      return string(data), nil
  }

  Advantages:
  - Explicit error handling (can't ignore without effort)
  - No hidden control flow jumps
  - Composable with map/flatMap/andThen

Error Boundaries (React pattern):
  Catch rendering errors in a subtree
  Display fallback UI instead of crashing whole app
  Log errors for debugging
  Applicable pattern: isolate failure to smallest component

Null Object Pattern:
  Instead of null/error, return a safe default
  EmptyList instead of null
  NullLogger that silently discards
  Use when: missing data is acceptable, not exceptional

Sentinel Values:
  Special return values indicating error
  -1, null, "", EOF, NaN
  Danger: easy to forget to check
  Better: use Option/Maybe types

Error Wrapping/Chaining:
  Add context at each level without losing original error:
  "failed to process order: failed to charge payment:
   connection refused: dial tcp 10.0.0.1:443"

  Python:  raise NewError("context") from original_error
  Go:      fmt.Errorf("context: %w", err)
  Rust:    .context("context") (with anyhow)
  Java:    new CustomException("context", cause)

Dead Letter Queue:
  For async/event processing:
  1. Process message
  2. If error, retry N times
  3. After N failures, move to dead letter queue
  4. Alert operators to review DLQ
  5. Fix and replay, or discard
EOF
}

cmd_retry() {
    cat << 'EOF'
=== Retry Strategies ===

Basic Retry:
  attempts = 0
  while attempts < max_retries:
      try: return operation()
      except RetryableError: attempts += 1
  raise MaxRetriesExceeded

Exponential Backoff:
  wait = base_delay × 2^attempt
  Attempt 1: 1s
  Attempt 2: 2s
  Attempt 3: 4s
  Attempt 4: 8s
  Attempt 5: 16s
  Cap at max_delay (e.g., 60s)

Exponential Backoff + Jitter:
  Jitter prevents "thundering herd" when many clients retry simultaneously

  Full Jitter:
    wait = random(0, base_delay × 2^attempt)

  Equal Jitter:
    half = (base_delay × 2^attempt) / 2
    wait = half + random(0, half)

  Decorrelated Jitter (AWS recommended):
    wait = random(base_delay, previous_wait × 3)
    Capped at max_delay

Circuit Breaker:
  States:
    CLOSED    Normal operation, requests pass through
    OPEN      Too many failures, fast-fail all requests
    HALF-OPEN Allow one test request to check recovery

  Transitions:
    CLOSED → OPEN       When failure count exceeds threshold
    OPEN → HALF-OPEN    After timeout period expires
    HALF-OPEN → CLOSED  If test request succeeds
    HALF-OPEN → OPEN    If test request fails

  Parameters:
    failure_threshold    Failures before opening (e.g., 5)
    success_threshold    Successes to close (e.g., 3)
    timeout             Time before half-open (e.g., 30s)
    window              Time window for counting failures

Retry Budget:
  Limit total retries across all clients:
  "No more than 10% of requests should be retries"
  Prevents retry storms from overwhelming servers

Idempotency:
  Critical for safe retries:
  - GET, PUT, DELETE are naturally idempotent
  - POST needs idempotency key
  - Use: Idempotency-Key header
  - Server deduplicates by key

What NOT to Retry:
  - Authentication failures (401, 403)
  - Validation errors (400, 422)
  - Not found (404)
  - Request too large (413)
  - Business logic errors
  → These won't succeed on retry
EOF
}

cmd_logging() {
    cat << 'EOF'
=== Error Logging Best Practices ===

Severity Levels:
  TRACE    Finest-grained, enter/exit methods
  DEBUG    Detailed diagnostic information
  INFO     Notable events (request handled, job completed)
  WARN     Unexpected but recoverable (deprecated API used)
  ERROR    Error requiring attention (request failed, exception)
  FATAL    System cannot continue (startup failure, OOM)

What to Log on Error:
  1. Timestamp (ISO 8601 with timezone)
  2. Severity level
  3. Error message (human-readable)
  4. Error code (machine-readable)
  5. Stack trace (for unexpected errors)
  6. Request context (request ID, user ID, endpoint)
  7. Input that caused the error (sanitized)
  8. Service/component name
  9. Host/instance identifier
  10. Correlation ID (for distributed tracing)

Structured Logging Format:
  {
    "timestamp": "2024-01-15T10:30:45.123Z",
    "level": "ERROR",
    "message": "Payment processing failed",
    "error_code": "PAY_001",
    "error_class": "PaymentGatewayTimeout",
    "request_id": "req_abc123",
    "user_id": "usr_456",
    "service": "payment-service",
    "host": "pay-prod-01",
    "trace_id": "trace_789",
    "context": {
      "amount": 99.99,
      "currency": "USD",
      "gateway": "stripe",
      "retry_count": 2
    },
    "stack_trace": "..."
  }

What NOT to Log:
  ✗ Passwords or API keys
  ✗ Credit card numbers (PCI DSS violation)
  ✗ Social security numbers
  ✗ Full request bodies with PII
  ✗ Session tokens
  ✗ Health information (HIPAA)
  → Mask sensitive data: "card": "****1234"

Log Aggregation Stack:
  ELK:     Elasticsearch + Logstash + Kibana
  EFK:     Elasticsearch + Fluentd + Kibana
  Loki:    Grafana Loki + Promtail + Grafana
  Cloud:   CloudWatch, Cloud Logging, Azure Monitor
  SaaS:    Datadog, Splunk, New Relic, Sentry

Alerting Rules:
  - Error rate > 1% of requests → Page on-call
  - 5xx spike > 3× baseline → Alert
  - Specific error code appears → Notify team
  - Error budget consumed > 50% → Warning
  - New error type never seen before → Alert
EOF
}

cmd_messages() {
    cat << 'EOF'
=== Error Message Design ===

User-Facing Error Messages:

  Good:
  ✓ "Unable to save your changes. Please check your internet
     connection and try again."
  ✓ "This email address is already registered. Try signing in
     or use a different email."
  ✓ "File must be smaller than 10 MB. Your file is 15 MB."

  Bad:
  ✗ "Error 500: Internal Server Error"
  ✗ "NullReferenceException in OrderService.cs line 42"
  ✗ "Something went wrong"
  ✗ "Error"

  Principles:
  1. Say what happened (clearly, briefly)
  2. Say what to do about it (actionable next step)
  3. Use human language (no technical jargon)
  4. Be specific (not "something went wrong")
  5. Don't blame the user ("Invalid input" → "Please enter a valid email")
  6. Don't expose internals (stack traces, SQL errors)

Developer-Facing Error Messages:

  Good:
  ✓ "Connection to PostgreSQL at db.prod:5432 timed out after 30s
     (attempt 3/3). Check network connectivity and pg_hba.conf."
  ✓ "Cannot deserialize field 'created_at': expected ISO 8601
     format, got '01/15/2024'. Source: line 42 of users.json"

  Include:
  - Technical detail (host, port, timeout value)
  - Context (which operation, which data)
  - Suggestion (what to check, common fixes)

Error Code System:
  Format: DOMAIN_NUMBER or DOMAIN-CATEGORY-NUMBER

  Examples:
    AUTH_001   Invalid credentials
    AUTH_002   Token expired
    AUTH_003   Insufficient permissions
    PAY_001    Payment gateway timeout
    PAY_002    Card declined
    PAY_003    Currency not supported
    VAL_001    Required field missing
    VAL_002    Format validation failed

  Benefits:
  - Machine-parseable (automated handling)
  - Documentation reference (error code → help page)
  - i18n friendly (translate by code, not string)
  - Searchable (unique identifier in logs)

API Error Response Format (RFC 7807 — Problem Details):
  {
    "type": "https://api.example.com/errors/insufficient-funds",
    "title": "Insufficient Funds",
    "status": 422,
    "detail": "Account balance is $10.00, but transfer requires $25.00",
    "instance": "/transfers/txn_abc123",
    "balance": 10.00,
    "required": 25.00
  }
EOF
}

cmd_debug() {
    cat << 'EOF'
=== Debugging Techniques ===

Root Cause Analysis (5 Whys):
  Problem: Users can't log in
  Why 1: Authentication service returns 500
  Why 2: Database connection pool exhausted
  Why 3: Queries taking >30s instead of <100ms
  Why 4: Missing index on users.email column
  Why 5: Migration script didn't run in production
  Root cause: Deployment checklist missing migration step

Bisection (Git Bisect):
  git bisect start
  git bisect bad HEAD              # Current version is broken
  git bisect good v1.2.0           # This version was working
  # Git checks out middle commit
  # Test, then: git bisect good/bad
  # Repeat until single commit identified
  git bisect reset

Binary Search Debugging:
  1. Remove half the code/config/data
  2. Does the problem persist?
  3. Yes → problem in remaining half
  4. No → problem in removed half
  5. Repeat until isolated

Rubber Duck Debugging:
  Explain the problem step by step to someone (or a duck)
  The act of articulating often reveals the error
  "The code reads the file, then... wait, it doesn't close the handle"

Distributed Tracing:
  Tools: Jaeger, Zipkin, AWS X-Ray, OpenTelemetry
  
  Trace → Spans → Service calls
  Request-A → Service-B (50ms) → DB-Query (200ms) → Service-C (30ms)
  
  Identify:
  - Which service is slow?
  - Where did the error originate?
  - What's the full request path?

Core Dump Analysis:
  # Enable core dumps
  ulimit -c unlimited

  # Analyze with gdb
  gdb ./program core
  (gdb) bt    # Backtrace
  (gdb) info locals
  (gdb) print variable

Memory Debugging:
  Valgrind:   valgrind --leak-check=full ./program
  ASAN:       gcc -fsanitize=address program.c
  heaptrack:  heaptrack ./program && heaptrack_print output

Systematic Approach:
  1. Reproduce (can you make it happen reliably?)
  2. Isolate (what's the minimal case?)
  3. Identify (what's the root cause?)
  4. Fix (change the least amount possible)
  5. Verify (does the fix work? no regressions?)
  6. Prevent (add test, monitoring, or guard)

Common Debugging Anti-Patterns:
  ✗ Changing things randomly until it works
  ✗ Assuming you know the cause without evidence
  ✗ Debugging production without reproduction
  ✗ Not reading the actual error message
  ✗ Not checking logs before guessing
  ✗ Fixing the symptom instead of the cause
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== Error Handling Checklist ===

Input Validation:
  [ ] Validate all user inputs at boundary
  [ ] Return specific validation error messages
  [ ] Sanitize inputs (prevent injection)
  [ ] Handle missing/null values explicitly
  [ ] Validate content types and encoding

Error Response Design:
  [ ] Consistent error format across all endpoints
  [ ] Appropriate HTTP status codes
  [ ] Error codes for machine parsing
  [ ] User-friendly messages (no stack traces to users)
  [ ] Include request ID for correlation

Exception Handling:
  [ ] Catch specific exceptions (not generic Exception)
  [ ] Don't swallow exceptions silently
  [ ] Add context when re-throwing
  [ ] Clean up resources in finally/defer/using
  [ ] Handle async/promise rejections

Resilience:
  [ ] Retry logic with exponential backoff + jitter
  [ ] Circuit breakers on external dependencies
  [ ] Timeouts on all external calls (connect + read)
  [ ] Fallback values/behavior for non-critical features
  [ ] Graceful degradation under load
  [ ] Bulkhead pattern (isolate failures)

Logging & Monitoring:
  [ ] Structured logging with severity levels
  [ ] All errors logged with context (request ID, user, input)
  [ ] No sensitive data in logs (mask PII, secrets)
  [ ] Error rate monitoring with alerting
  [ ] Error budget tracking (SLO/SLI)
  [ ] Distributed tracing for cross-service debugging

Data Protection:
  [ ] Transaction rollback on error (database consistency)
  [ ] Idempotency keys for retryable operations
  [ ] Dead letter queue for async processing failures
  [ ] Data validation before write (not just on read)
  [ ] Backup/checkpoint before destructive operations

User Experience:
  [ ] Clear error messages with actionable guidance
  [ ] Loading states during retries (not frozen UI)
  [ ] Offline handling (queue actions, sync later)
  [ ] Error boundary components (don't crash whole app)
  [ ] Support contact info for unresolvable errors

Ops & On-Call:
  [ ] Runbook for common errors
  [ ] Error classification (actionable vs noise)
  [ ] Escalation paths defined
  [ ] Post-incident review process
  [ ] Error trending dashboards
EOF
}

show_help() {
    cat << EOF
error v$VERSION — Error Handling & Resilience Reference

Usage: script.sh <command>

Commands:
  intro      Error handling overview — types, principles, approaches
  http       HTTP status codes — complete reference
  patterns   Error handling patterns — try/catch, Result, boundaries
  retry      Retry strategies — backoff, jitter, circuit breakers
  logging    Error logging — structured logging, severity, aggregation
  messages   Error message design — user-facing, codes, RFC 7807
  debug      Debugging techniques — 5 whys, bisect, tracing
  checklist  Error handling checklist for production apps
  help       Show this help
  version    Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)     cmd_intro ;;
    http)      cmd_http ;;
    patterns)  cmd_patterns ;;
    retry)     cmd_retry ;;
    logging)   cmd_logging ;;
    messages)  cmd_messages ;;
    debug)     cmd_debug ;;
    checklist) cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "error v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
