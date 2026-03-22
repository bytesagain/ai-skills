#!/usr/bin/env bash
# stub — Test Stub Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Test Stubs ===

A stub is a test double that provides canned (pre-programmed) responses
to calls made during a test. Stubs don't verify behavior — they simply
return controlled data so you can test the code that uses them.

Test Double Taxonomy (Gerard Meszaros):
  ┌──────────┬──────────────────────────────────────────────┐
  │ Type     │ Purpose                                      │
  ├──────────┼──────────────────────────────────────────────┤
  │ Dummy    │ Passed but never used. Fills parameter lists │
  │ Stub     │ Returns canned data. No behavior verification│
  │ Spy      │ Records calls. Can verify after the fact     │
  │ Mock     │ Pre-programmed expectations. Verifies calls  │
  │ Fake     │ Working implementation (in-memory DB, etc.)  │
  └──────────┴──────────────────────────────────────────────┘

Stub vs Mock — The Key Difference:
  Stub: "When you call getUser(1), return {name: 'Alice'}"
        Tests STATE — did the code produce correct output?

  Mock: "Verify that getUser was called exactly once with arg 1"
        Tests BEHAVIOR — did the code make the right calls?

  Prefer stubs (state testing) over mocks (behavior testing).
  Stubs are less brittle — they don't break when implementation changes.

When to Use Stubs:
  ✓ External services (APIs, databases, file system)
  ✓ Non-deterministic inputs (time, random, environment)
  ✓ Slow operations (network calls, disk I/O)
  ✓ Error conditions (simulate failures, timeouts)
  ✓ Third-party libraries you don't control

When NOT to Stub:
  ✗ The code under test itself (only stub dependencies)
  ✗ Simple value objects or pure functions
  ✗ Integration tests (use real dependencies)
  ✗ When a fake is simpler (in-memory DB > stubbed queries)

The Testing Pyramid and Stubs:
  Unit tests:        Heavy stubbing (isolate the unit)
  Integration tests: Minimal stubbing (test real interactions)
  E2E tests:         No stubbing (test the real system)
EOF
}

cmd_javascript() {
    cat << 'EOF'
=== JavaScript Stubbing ===

--- Jest: Mock Functions ---
  // Simple stub function
  const getUser = jest.fn().mockReturnValue({ name: 'Alice' });
  const result = processUser(getUser);
  expect(result.greeting).toBe('Hello, Alice');

  // Different return values per call
  const fn = jest.fn()
    .mockReturnValueOnce('first')
    .mockReturnValueOnce('second')
    .mockReturnValue('default');

  // Async stub
  const fetchData = jest.fn().mockResolvedValue({ data: [1, 2, 3] });
  const fetchError = jest.fn().mockRejectedValue(new Error('timeout'));

--- Jest: Module Mocking ---
  // Stub entire module
  jest.mock('./database', () => ({
    query: jest.fn().mockResolvedValue([{ id: 1, name: 'Alice' }]),
    connect: jest.fn().mockResolvedValue(true),
  }));

  // Partial mock (keep some real implementations)
  jest.mock('./utils', () => ({
    ...jest.requireActual('./utils'),
    fetchRemote: jest.fn().mockResolvedValue('stubbed'),
  }));

--- Jest: Timer Stubs ---
  jest.useFakeTimers();
  setTimeout(callback, 1000);
  jest.advanceTimersByTime(1000);
  expect(callback).toHaveBeenCalled();
  jest.useRealTimers();

--- Sinon.js ---
  const stub = sinon.stub(database, 'query');
  stub.withArgs('SELECT * FROM users').resolves([{ id: 1 }]);
  stub.withArgs('SELECT * FROM orders').resolves([]);

  // Stub on specific call number
  stub.onFirstCall().returns('first');
  stub.onSecondCall().returns('second');

  // Restore original
  stub.restore();

  // Stub throw
  stub.throws(new Error('connection lost'));

--- Vitest ---
  import { vi } from 'vitest';
  const fn = vi.fn().mockReturnValue(42);
  vi.mock('./api', () => ({
    fetchUsers: vi.fn().mockResolvedValue([]),
  }));
EOF
}

cmd_golang() {
    cat << 'EOF'
=== Go Stubbing ===

Go stubs are built using interfaces — define an interface for the
dependency, then provide a stub implementation for tests.

--- Interface-Based Stubbing ---
  // production code
  type UserStore interface {
      GetUser(id int) (*User, error)
      SaveUser(user *User) error
  }

  type UserService struct {
      store UserStore    // injected dependency
  }

  func (s *UserService) Greet(id int) (string, error) {
      user, err := s.store.GetUser(id)
      if err != nil { return "", err }
      return "Hello, " + user.Name, nil
  }

  // test stub
  type stubUserStore struct {
      users map[int]*User
      err   error
  }

  func (s *stubUserStore) GetUser(id int) (*User, error) {
      if s.err != nil { return nil, s.err }
      return s.users[id], nil
  }

  func (s *stubUserStore) SaveUser(user *User) error {
      return s.err
  }

  // test
  func TestGreet(t *testing.T) {
      store := &stubUserStore{
          users: map[int]*User{1: {Name: "Alice"}},
      }
      svc := &UserService{store: store}
      msg, err := svc.Greet(1)
      if err != nil { t.Fatal(err) }
      if msg != "Hello, Alice" { t.Errorf("got %q", msg) }
  }

--- Function-Based Stubbing ---
  type fetchFunc func(url string) ([]byte, error)

  func process(fetch fetchFunc) error {
      data, err := fetch("https://api.example.com")
      // ...
  }

  // In test:
  stub := func(url string) ([]byte, error) {
      return []byte(`{"ok": true}`), nil
  }
  process(stub)

--- Stubbing Time ---
  // Instead of time.Now() directly:
  type Clock interface {
      Now() time.Time
  }

  type realClock struct{}
  func (realClock) Now() time.Time { return time.Now() }

  type stubClock struct{ fixed time.Time }
  func (c stubClock) Now() time.Time { return c.fixed }

--- httptest (HTTP Stubs) ---
  ts := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
      w.Header().Set("Content-Type", "application/json")
      fmt.Fprintln(w, `{"name": "Alice"}`)
  }))
  defer ts.Close()

  // Use ts.URL as the API endpoint in tests
EOF
}

cmd_python() {
    cat << 'EOF'
=== Python Stubbing ===

--- unittest.mock.patch ---
  from unittest.mock import patch, MagicMock

  # Stub a function
  @patch('myapp.services.get_user')
  def test_greet(mock_get_user):
      mock_get_user.return_value = {'name': 'Alice'}
      result = greet_user(1)
      assert result == 'Hello, Alice'

  # Context manager form
  def test_greet():
      with patch('myapp.services.get_user') as mock:
          mock.return_value = {'name': 'Alice'}
          result = greet_user(1)

--- MagicMock ---
  db = MagicMock()
  db.query.return_value = [{'id': 1, 'name': 'Alice'}]
  db.connect.return_value = True

  # Chained calls
  db.session.query.filter_by.return_value.first.return_value = user

--- side_effect ---
  # Different returns per call
  mock.side_effect = ['first', 'second', 'third']

  # Raise exception
  mock.side_effect = ConnectionError('timeout')

  # Custom logic
  def fake_get(id):
      if id == 1: return {'name': 'Alice'}
      raise ValueError(f'Unknown user {id}')
  mock.side_effect = fake_get

--- Stub Environment ---
  @patch.dict(os.environ, {'API_KEY': 'test-key', 'DEBUG': 'true'})
  def test_config():
      assert os.environ['API_KEY'] == 'test-key'

--- pytest monkeypatch ---
  def test_greet(monkeypatch):
      monkeypatch.setattr('myapp.services.get_user',
                          lambda id: {'name': 'Alice'})
      assert greet_user(1) == 'Hello, Alice'

  # Stub datetime
  import datetime
  def test_today(monkeypatch):
      class FakeDate(datetime.date):
          @classmethod
          def today(cls):
              return cls(2024, 1, 15)
      monkeypatch.setattr(datetime, 'date', FakeDate)

--- spec and autospec ---
  # Ensure stub matches real interface:
  mock = MagicMock(spec=UserService)
  mock.nonexistent_method()  # raises AttributeError!
  # Prevents stubs from accepting wrong method names
EOF
}

cmd_http() {
    cat << 'EOF'
=== Stubbing HTTP Calls ===

--- MSW (Mock Service Worker — Browser + Node) ---
  import { http, HttpResponse } from 'msw'
  import { setupServer } from 'msw/node'

  const server = setupServer(
    http.get('/api/users/:id', ({ params }) => {
      return HttpResponse.json({ id: params.id, name: 'Alice' })
    }),
    http.post('/api/login', async ({ request }) => {
      const body = await request.json()
      if (body.password === 'wrong') {
        return HttpResponse.json({ error: 'Invalid' }, { status: 401 })
      }
      return HttpResponse.json({ token: 'abc123' })
    }),
  )

  beforeAll(() => server.listen())
  afterEach(() => server.resetHandlers())
  afterAll(() => server.close())

  // Override for specific test:
  server.use(
    http.get('/api/users/:id', () => {
      return HttpResponse.json(null, { status: 500 })
    })
  )

--- nock (Node.js) ---
  const nock = require('nock')

  nock('https://api.example.com')
    .get('/users/1')
    .reply(200, { name: 'Alice' })
    .get('/users/2')
    .reply(404, { error: 'Not found' })

  // Verify all stubs were called
  nock.isDone()  // true if all interceptors were used

--- Go httptest ---
  ts := httptest.NewServer(http.HandlerFunc(
    func(w http.ResponseWriter, r *http.Request) {
      switch r.URL.Path {
      case "/users/1":
        json.NewEncoder(w).Encode(User{Name: "Alice"})
      default:
        http.NotFound(w, r)
      }
    },
  ))
  // Use ts.URL in your client

--- Python responses ---
  import responses

  @responses.activate
  def test_api():
      responses.add(
          responses.GET,
          'https://api.example.com/users/1',
          json={'name': 'Alice'},
          status=200
      )
      result = fetch_user(1)
      assert result['name'] == 'Alice'

--- WireMock (Java/JVM) ---
  stubFor(get(urlEqualTo("/api/users/1"))
    .willReturn(aResponse()
      .withStatus(200)
      .withHeader("Content-Type", "application/json")
      .withBody("{\"name\": \"Alice\"}")));
EOF
}

cmd_design() {
    cat << 'EOF'
=== Designing for Stubability ===

--- Dependency Injection ---
  BAD: Hard-coded dependency (untestable)
    class OrderService {
      process(order) {
        const result = Stripe.charge(order.amount);  // direct call
      }
    }

  GOOD: Injected dependency (stubable)
    class OrderService {
      constructor(paymentGateway) {        // injected
        this.payment = paymentGateway;
      }
      process(order) {
        const result = this.payment.charge(order.amount);
      }
    }

    // Production:
    new OrderService(new StripeGateway())

    // Test:
    new OrderService({ charge: () => ({ success: true }) })

--- Ports and Adapters (Hexagonal Architecture) ---
  Port:    Interface defining what the app needs
  Adapter: Implementation of the port (real or stub)

  // Port (interface)
  interface NotificationPort {
    send(to: string, message: string): Promise<void>
  }

  // Real adapter
  class EmailAdapter implements NotificationPort { ... }

  // Stub adapter
  class StubNotifier implements NotificationPort {
    sent: Array<{to: string, message: string}> = []
    async send(to, message) { this.sent.push({to, message}) }
  }

--- Function Parameters Over Global State ---
  BAD:  function getPrice() { return CONFIG.basePrice * TAX_RATE; }
  GOOD: function getPrice(basePrice, taxRate) { return basePrice * taxRate; }

--- Seams for Stubbing ---
  A seam is a place where you can alter behavior without editing code.
  Types of seams:
    Object seam:     Override via polymorphism (most common)
    Function seam:   Pass function as parameter
    Module seam:     Replace module import (jest.mock)
    Environment seam: Switch behavior via env vars/config

--- Interface Segregation ---
  DON'T: One massive interface with 20 methods → huge stubs

  DO: Small, focused interfaces → tiny stubs
    type Reader interface { Read(id int) (Data, error) }
    type Writer interface { Write(data Data) error }
    // Stub only what you need for each test
EOF
}

cmd_antipatterns() {
    cat << 'EOF'
=== Stubbing Anti-Patterns ===

1. Over-Mocking
   Problem: Stubbing every dependency, testing nothing real
   Sign: Test passes with ANY implementation (stub returns are ignored)
   Fix: Only stub boundaries (I/O, network, time)
   Rule: If you're stubbing more than 3 things, your unit is too big

2. Testing Implementation Details
   Problem: Stub verifies internal method calls, not outcomes
   BAD:  expect(db.query).toHaveBeenCalledWith("SELECT * FROM users")
   GOOD: expect(result.users).toHaveLength(3)
   Fix: Test observable behavior, not how it's achieved

3. Fragile Stubs
   Problem: Stub breaks when implementation changes (not just API)
   Sign: Changing a private method breaks 50 tests
   Fix: Stub at the public interface boundary only

4. God Stub
   Problem: One giant stub object shared across all tests
   Fix: Create minimal stubs per test case
   Each test should declare what it needs

5. Stub-and-Forget
   Problem: Stub never updated when real dependency changes
   Fix: Use typed stubs (TypeScript) or spec mocks (Python autospec)
   The stub should fail if the interface changes

6. Stubbing What You Own
   Problem: Stubbing your own code instead of restructuring it
   Fix: If you need to stub your own code, refactor it
   Extract the part that needs stubbing into a dependency

7. Assert on Stub (Circular Testing)
   Problem: Testing that the stub returns what you told it to return
   BAD:  mock.mockReturnValue(42); expect(mock()).toBe(42);
   This tests mock framework, not your code!
   Fix: Test the CODE that uses the stub

8. Reality Drift
   Problem: Stub behavior diverges from real dependency
   Fix: Contract tests, integration tests as safety net
   Run periodic tests against real dependencies
EOF
}

cmd_advanced() {
    cat << 'EOF'
=== Advanced Stubbing Techniques ===

--- Partial Stubs ---
  Keep real behavior, override specific methods:

  // Jest
  const realModule = jest.requireActual('./database');
  jest.mock('./database', () => ({
    ...realModule,
    dangerousOperation: jest.fn().mockReturnValue('safe'),
  }));

  // Sinon
  const stub = sinon.stub(obj, 'method');
  // Other methods on obj still work normally

  // Python
  @patch.object(MyClass, 'external_call', return_value='stubbed')
  def test(mock_call):
      obj = MyClass()  # all other methods are real

--- Stateful Stubs ---
  let callCount = 0;
  const stub = jest.fn(() => {
    callCount++;
    if (callCount <= 3) return { status: 'pending' };
    return { status: 'complete' };
  });
  // Simulates polling behavior

--- Conditional Stubs ---
  // Sinon
  stub.withArgs(1).returns('one');
  stub.withArgs(2).returns('two');
  stub.returns('default');

  // Jest (manual)
  const stub = jest.fn((id) => {
    const data = { 1: 'one', 2: 'two' };
    return data[id] || 'default';
  });

--- Delayed Stubs (Simulate Latency) ---
  const slowStub = jest.fn(
    () => new Promise(resolve =>
      setTimeout(() => resolve('data'), 100)
    )
  );

--- Stub Sequences ---
  const stub = jest.fn()
    .mockRejectedValueOnce(new Error('retry'))
    .mockRejectedValueOnce(new Error('retry'))
    .mockResolvedValue('success');
  // Simulates: fail, fail, succeed (test retry logic)

--- Recording Stubs (Spy + Stub Hybrid) ---
  class RecordingStore {
    calls = [];
    data = {};

    get(key) {
      this.calls.push(['get', key]);
      return this.data[key];
    }

    set(key, value) {
      this.calls.push(['set', key, value]);
      this.data[key] = value;
    }
  }
  // Acts as both stub (returns data) and spy (records calls)

--- Factory Stubs ---
  function createUserStub(overrides = {}) {
    return {
      id: 1,
      name: 'Test User',
      email: 'test@example.com',
      role: 'user',
      ...overrides,
    };
  }

  // Usage:
  const admin = createUserStub({ role: 'admin', name: 'Admin' });
  const guest = createUserStub({ role: 'guest' });
EOF
}

show_help() {
    cat << EOF
stub v$VERSION — Test Stub Reference

Usage: script.sh <command>

Commands:
  intro        Test double taxonomy, stub vs mock vs fake
  javascript   JS stubbing with Jest, Sinon, Vitest
  golang       Go interface-based stubs and httptest
  python       Python stubs with mock, patch, monkeypatch
  http         Stubbing HTTP: MSW, nock, httptest, responses
  design       Designing for stubability: DI, ports & adapters
  antipatterns Over-mocking, fragile stubs, reality drift
  advanced     Partial, stateful, conditional, sequence stubs
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)        cmd_intro ;;
    javascript|js) cmd_javascript ;;
    golang|go)    cmd_golang ;;
    python)       cmd_python ;;
    http)         cmd_http ;;
    design)       cmd_design ;;
    antipatterns) cmd_antipatterns ;;
    advanced)     cmd_advanced ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "stub v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
