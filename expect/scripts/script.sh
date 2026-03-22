#!/usr/bin/env bash
# expect — Test Assertion & Expectation Patterns Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Test Expectations & Assertions ===

Expectations are the heart of automated testing — they declare what your
code SHOULD do, and fail loudly when it doesn't.

Three Assertion Styles:
  1. Assert (TDD style)     assert.equal(actual, expected)
  2. Expect (BDD style)     expect(actual).toBe(expected)
  3. Should (BDD chain)     actual.should.equal(expected)

Framework Landscape:
  Jest        expect(x).toBe(y)         — Most popular in JS/TS
  Mocha+Chai  expect(x).to.equal(y)     — Flexible, pluggable
  Vitest      expect(x).toBe(y)         — Jest-compatible, Vite-native
  Jasmine     expect(x).toBe(y)         — Original BDD framework
  pytest      assert x == y             — Pythonic, introspection-based
  RSpec       expect(x).to eq(y)        — Ruby BDD standard
  JUnit 5     assertEquals(expected, x) — Java standard
  Go testing  if got != want { t.Error } — Explicit, no magic

Assertion Philosophy:
  - One logical assertion per test (Single Assert Principle)
  - Test behavior, not implementation
  - Assertions should read like specifications
  - Failure messages should explain WHAT went wrong
  - Prefer specific matchers over generic equality

AAA Pattern (Arrange-Act-Assert):
  // Arrange — set up preconditions
  const cart = new Cart();
  cart.add(item);

  // Act — perform the action
  const total = cart.getTotal();

  // Assert — verify the outcome
  expect(total).toBe(9.99);

GWT Pattern (Given-When-Then):
  Given a cart with one item
  When I calculate the total
  Then it should be 9.99
EOF
}

cmd_matchers() {
    cat << 'EOF'
=== Core Matcher Reference ===

--- Equality Matchers ---
  toBe(value)              Strict equality (===), same reference
  toEqual(value)           Deep equality, different references OK
  toStrictEqual(value)     Deep equality + checks undefined props
  not.toBe(value)          Negation of any matcher

  When to use which:
    toBe       → primitives (numbers, strings, booleans)
    toEqual    → objects, arrays (structure matters, not identity)
    toStrictEqual → objects where undefined keys matter

--- Truthiness Matchers ---
  toBeTruthy()             Any truthy value (not 0, '', null, undefined, false)
  toBeFalsy()              Any falsy value
  toBeNull()               Strictly null
  toBeUndefined()          Strictly undefined
  toBeDefined()            Not undefined
  toBeNaN()                Is NaN

--- Numeric Matchers ---
  toBeGreaterThan(n)       >
  toBeGreaterThanOrEqual(n)  >=
  toBeLessThan(n)          <
  toBeLessThanOrEqual(n)   <=
  toBeCloseTo(n, digits)   Float comparison (avoids 0.1+0.2 issue)
    expect(0.1 + 0.2).toBeCloseTo(0.3)  ✓
    expect(0.1 + 0.2).toBe(0.3)         ✗ (IEEE 754)

--- String Matchers ---
  toMatch(/regex/)         Matches regular expression
  toMatch('substring')     Contains substring
  toContain('substr')      String contains (also works on arrays)
  toHaveLength(n)          String or array length

--- Array Matchers ---
  toContain(item)          Array includes item (toBe equality)
  toContainEqual(item)     Array includes item (toEqual equality)
  toHaveLength(n)          Array length
  expect.arrayContaining([subset])  Array contains all items in subset

--- Object Matchers ---
  toHaveProperty('key')            Has property
  toHaveProperty('key', value)     Has property with value
  toHaveProperty('a.b.c')          Nested property (dot notation)
  toMatchObject({subset})          Object contains subset of properties
  expect.objectContaining({sub})   Partial match in nested context

--- Special Matchers ---
  toBeInstanceOf(Class)    instanceof check
  expect.any(Constructor)  Matches any instance of type
  expect.anything()        Matches anything except null/undefined
  expect.stringContaining(str)     Asymmetric string match
  expect.stringMatching(regexp)    Asymmetric regex match
EOF
}

cmd_async() {
    cat << 'EOF'
=== Async Expectation Patterns ===

--- Promises (async/await) ---
  test('fetches user', async () => {
    const user = await fetchUser(1);
    expect(user.name).toBe('Alice');
  });

--- Resolves Matcher ---
  test('resolves to user', async () => {
    await expect(fetchUser(1)).resolves.toEqual({
      id: 1,
      name: 'Alice'
    });
  });

--- Rejects Matcher ---
  test('rejects with not found', async () => {
    await expect(fetchUser(999)).rejects.toThrow('Not found');
  });

  test('rejects with specific error', async () => {
    await expect(fetchUser(-1)).rejects.toThrow(
      expect.objectContaining({
        message: 'Invalid ID',
        code: 'INVALID_INPUT'
      })
    );
  });

--- Callback Style (done) ---
  test('calls back with data', (done) => {
    fetchUser(1, (err, user) => {
      try {
        expect(err).toBeNull();
        expect(user.name).toBe('Alice');
        done();
      } catch (error) {
        done(error);
      }
    });
  });

--- Timers and Fake Timers ---
  jest.useFakeTimers();

  test('debounce fires after delay', () => {
    const fn = jest.fn();
    const debounced = debounce(fn, 300);

    debounced();
    expect(fn).not.toHaveBeenCalled();

    jest.advanceTimersByTime(300);
    expect(fn).toHaveBeenCalledTimes(1);
  });

--- Event Emitter ---
  test('emits data event', (done) => {
    const emitter = new DataStream();
    emitter.on('data', (chunk) => {
      expect(chunk).toBe('hello');
      done();
    });
    emitter.start();
  });

Common Pitfall: Forgetting to await/return the promise
  ✗ test('bad', () => {
      expect(asyncFn()).resolves.toBe(42); // no await = no wait
    });
  ✓ test('good', async () => {
      await expect(asyncFn()).resolves.toBe(42);
    });
EOF
}

cmd_custom() {
    cat << 'EOF'
=== Writing Custom Matchers ===

--- Jest Custom Matcher ---
  expect.extend({
    toBeWithinRange(received, floor, ceiling) {
      const pass = received >= floor && received <= ceiling;
      if (pass) {
        return {
          message: () =>
            `expected ${received} not to be within range ${floor}–${ceiling}`,
          pass: true,
        };
      } else {
        return {
          message: () =>
            `expected ${received} to be within range ${floor}–${ceiling}`,
          pass: false,
        };
      }
    },
  });

  test('value in range', () => {
    expect(100).toBeWithinRange(90, 110);
    expect(200).not.toBeWithinRange(90, 110);
  });

--- TypeScript Custom Matcher ---
  declare module 'expect' {
    interface Matchers<R> {
      toBeWithinRange(floor: number, ceiling: number): R;
    }
  }

--- Chai Plugin Pattern ---
  chai.use(function(chai, utils) {
    chai.Assertion.addMethod('color', function(expected) {
      const actual = this._obj.getColor();
      this.assert(
        actual === expected,
        'expected #{this} to be color #{exp} but got #{act}',
        'expected #{this} not to be color #{exp}',
        expected,
        actual
      );
    });
  });

  expect(pixel).to.have.color('red');

--- Custom Matcher Best Practices ---
  1. Return clear failure messages (both pass and fail cases)
  2. Support .not negation properly
  3. Use expect.extend() in setupFilesAfterFramework
  4. Name matchers with 'toBe' or 'toHave' prefix
  5. Include received and expected in messages
  6. Handle edge cases (null, undefined, wrong types)
  7. Add TypeScript declarations for autocompletion
EOF
}

cmd_errors() {
    cat << 'EOF'
=== Error & Exception Expectations ===

--- toThrow() Basics ---
  expect(() => riskyFn()).toThrow();                    // throws anything
  expect(() => riskyFn()).toThrow('specific message');   // message match
  expect(() => riskyFn()).toThrow(/regex/);              // regex match
  expect(() => riskyFn()).toThrow(CustomError);          // class match

  Important: Wrap in arrow function!
  ✗ expect(riskyFn()).toThrow()     // executes BEFORE expect
  ✓ expect(() => riskyFn()).toThrow() // expect controls execution

--- Error Class Matching ---
  class ValidationError extends Error {
    constructor(field, message) {
      super(message);
      this.field = field;
    }
  }

  expect(() => validate(data)).toThrow(ValidationError);

  // Check error properties
  expect(() => validate(data)).toThrow(
    expect.objectContaining({
      field: 'email',
      message: 'Invalid email format'
    })
  );

--- Async Error Expectations ---
  // With rejects
  await expect(asyncFn()).rejects.toThrow('Network error');
  await expect(asyncFn()).rejects.toThrow(TimeoutError);

  // With try/catch (when you need to inspect the error)
  try {
    await asyncFn();
    fail('Expected error was not thrown');
  } catch (error) {
    expect(error).toBeInstanceOf(CustomError);
    expect(error.code).toBe('TIMEOUT');
    expect(error.retryable).toBe(true);
  }

--- Assertion Count (expect.assertions) ---
  test('catches error in callback', () => {
    expect.assertions(2);  // MUST hit exactly 2 assertions

    try {
      dangerousOp();
    } catch (e) {
      expect(e).toBeInstanceOf(Error);
      expect(e.message).toContain('failed');
    }
  });

  // hasAssertions — at least one assertion ran
  test('error handler is called', () => {
    expect.hasAssertions();
    // ... test code
  });

--- Python (pytest) Error Patterns ---
  with pytest.raises(ValueError) as exc_info:
      parse_int("not a number")
  assert "invalid" in str(exc_info.value)

--- Go Error Patterns ---
  err := doSomething()
  if err == nil {
      t.Fatal("expected error, got nil")
  }
  if !errors.Is(err, ErrNotFound) {
      t.Errorf("expected ErrNotFound, got %v", err)
  }
EOF
}

cmd_snapshots() {
    cat << 'EOF'
=== Snapshot Testing ===

Concept: Capture output once, compare against it on future runs.
Good for: UI components, serialized data, complex objects.

--- Basic Snapshot ---
  test('renders correctly', () => {
    const tree = render(<Button label="Click" />);
    expect(tree).toMatchSnapshot();
  });
  // Creates __snapshots__/Button.test.js.snap

--- Inline Snapshot ---
  test('formats date', () => {
    expect(formatDate(date)).toMatchInlineSnapshot(`"Mar 15, 2024"`);
  });
  // Snapshot lives in the test file itself

--- Snapshot Update ---
  jest --updateSnapshot       # or jest -u
  vitest --update             # Vitest equivalent

  Only update when the change is INTENTIONAL
  Review snapshot diffs in code review

--- Property Matchers ---
  test('user with dynamic fields', () => {
    expect(createUser()).toMatchSnapshot({
      id: expect.any(Number),
      createdAt: expect.any(Date),
      name: 'Alice',
    });
  });

--- Custom Serializers ---
  expect.addSnapshotSerializer({
    test: (val) => val instanceof Money,
    print: (val) => `$${val.amount} ${val.currency}`,
  });

--- Snapshot Best Practices ---
  ✓ Keep snapshots small and focused
  ✓ Use property matchers for dynamic values (IDs, dates)
  ✓ Review snapshot changes in PRs like any other code
  ✓ Use inline snapshots for short outputs
  ✓ Name snapshots descriptively

  ✗ Don't snapshot entire pages (too large, too brittle)
  ✗ Don't blindly update snapshots without reviewing
  ✗ Don't snapshot implementation details
  ✗ Don't use snapshots as a lazy substitute for specific assertions

--- When Snapshots Shine ---
  - React/Vue component trees
  - GraphQL query results
  - CLI output formatting
  - Error message formatting
  - Config file generation
  - API response structures
EOF
}

cmd_patterns() {
    cat << 'EOF'
=== Assertion Patterns & Anti-Patterns ===

--- GOOD Patterns ---

Single Assertion Principle:
  Each test verifies one logical concept
  ✓ test('adds item to cart', () => {
      cart.add(item);
      expect(cart.items).toContain(item);
    });

Descriptive Test Names:
  ✓ 'returns empty array when no results found'
  ✗ 'test case 3'

Specific Matchers:
  ✓ expect(list).toHaveLength(3)
  ✗ expect(list.length === 3).toBe(true)   // useless error msg

  ✓ expect(name).toMatch(/^[A-Z]/)
  ✗ expect(name[0] === name[0].toUpperCase()).toBe(true)

Arrange-Act-Assert Separation:
  ✓ Clear visual separation of setup, action, verification

--- ANTI-Patterns ---

Boolean Trap:
  ✗ expect(isValid(email)).toBe(true)
    // Failure: "Expected false to be true" — unhelpful!
  ✓ expect(isValid(email)).toBeTruthy()
    // Or better: test the actual validation result

Multiple Unrelated Assertions:
  ✗ test('user tests', () => {
      expect(createUser()).toBeDefined();
      expect(deleteUser(1)).toBe(true);
      expect(listUsers()).toHaveLength(0);
    });
  // If first fails, rest never run

Testing Implementation:
  ✗ expect(component.state.count).toBe(1)   // internal state
  ✓ expect(screen.getByText('Count: 1'))     // behavior

Assertion Roulette:
  ✗ Multiple assertions without messages — which one failed?
  ✓ describe blocks or separate tests for each assertion

Flaky Time-Dependent Tests:
  ✗ expect(getTimestamp()).toBe(Date.now())   // race condition
  ✓ expect(getTimestamp()).toBeCloseTo(Date.now(), -2)

--- Test Structure Patterns ---
  describe('Calculator', () => {
    describe('add', () => {
      it('returns sum of two positive numbers', ...);
      it('handles negative numbers', ...);
      it('returns 0 for empty input', ...);
    });
    describe('divide', () => {
      it('returns quotient', ...);
      it('throws on division by zero', ...);
    });
  });
EOF
}

cmd_debug() {
    cat << 'EOF'
=== Debugging Failing Expectations ===

--- Reading Diff Output ---
  Expected: "hello world"
  Received: "hello  world"
            --------^ double space

  - Expected  (red / minus)
  + Received  (green / plus)

  Object diff:
    Object {
  -   "name": "Alice",     ← expected
  +   "name": "alice",     ← got (case mismatch)
      "age": 30,
    }

--- Common Matcher Mistakes ---

  1. toBe vs toEqual for objects
     expect({a:1}).toBe({a:1})      // FAILS (different references)
     expect({a:1}).toEqual({a:1})   // PASSES

  2. Floating point
     expect(0.1 + 0.2).toBe(0.3)         // FAILS (IEEE 754)
     expect(0.1 + 0.2).toBeCloseTo(0.3)  // PASSES

  3. Async without await
     expect(promise).resolves.toBe(x)      // silently passes
     await expect(promise).resolves.toBe(x) // actually checks

  4. toThrow without wrapper
     expect(fn()).toThrow()      // fn() runs before expect!
     expect(() => fn()).toThrow() // correct

  5. Array order matters
     expect([3,1,2]).toEqual([1,2,3])  // FAILS
     expect([3,1,2]).toEqual(expect.arrayContaining([1,2,3])) // PASSES

  6. Undefined vs missing
     toEqual ignores undefined properties
     toStrictEqual checks them
     {a: 1, b: undefined} toEqual {a: 1}  → PASSES
     {a: 1, b: undefined} toStrictEqual {a: 1}  → FAILS

--- Debugging Strategies ---
  1. Add console.log before assertion to see actual value
  2. Use .toMatchObject() for partial matching first
  3. Break complex assertions into smaller ones
  4. Check if test setup (beforeEach) ran correctly
  5. Run single test: jest --testNamePattern='test name'
  6. Use jest --verbose for full output
  7. Check for shared mutable state between tests

--- Jest Debug Flags ---
  --verbose           Show individual test results
  --bail              Stop on first failure
  --detectOpenHandles Show hanging async operations
  --forceExit         Force exit after tests
  --no-cache          Clear transform cache
EOF
}

show_help() {
    cat << EOF
expect v$VERSION — Test Assertion & Expectation Patterns Reference

Usage: script.sh <command>

Commands:
  intro        Assertion philosophy and framework overview
  matchers     Core matcher reference (equality, truthiness, etc.)
  async        Async expectation patterns (promises, callbacks)
  custom       Writing custom matchers
  errors       Error and exception expectations
  snapshots    Snapshot testing guide
  patterns     Assertion best practices and anti-patterns
  debug        Debugging failing expectations
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    matchers)   cmd_matchers ;;
    async)      cmd_async ;;
    custom)     cmd_custom ;;
    errors)     cmd_errors ;;
    snapshots)  cmd_snapshots ;;
    patterns)   cmd_patterns ;;
    debug)      cmd_debug ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "expect v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
