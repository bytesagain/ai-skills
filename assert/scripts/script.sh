#!/usr/bin/env bash
# assert — Assertion Patterns Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Assertions: Defensive Programming ===

An assertion is a boolean expression that must be true at a specific
point in the program. If false, the program halts immediately with
a diagnostic message.

Purpose:
  - Catch bugs early (fail-fast principle)
  - Document assumptions in executable form
  - Distinguish programmer errors from runtime errors
  - Make implicit assumptions explicit

Assertions vs Exceptions:
  Assertions          Exceptions
  ──────────          ──────────
  Programmer errors   User/environment errors
  Should never fail   Expected to happen sometimes
  Disabled in prod    Always active
  Bug indicators      Flow control
  "This can't happen" "This might happen"

When to Assert:
  ✓ Internal function preconditions
  ✓ Loop invariants
  ✓ Unreachable code paths (default: in switch)
  ✓ Assumptions after complex logic
  ✓ Post-conditions of algorithms

When NOT to Assert:
  ✗ User input validation (use exceptions)
  ✗ File/network errors (use error handling)
  ✗ Security checks (never disable in prod)
  ✗ Side effects inside assert expressions
  ✗ Public API boundary validation

Golden Rule:
  Assertions catch BUGS. Exceptions handle ERRORS.
  A bug is something that should never happen if the code is correct.
  An error is something that can happen even when the code is correct.
EOF
}

cmd_preconditions() {
    cat << 'EOF'
=== Precondition Patterns ===

Preconditions validate that inputs meet requirements BEFORE
the function body executes. They define the function's contract.

Guard Clause Pattern:
  Check → fail early → avoid deep nesting
  
  # Instead of:
  def process(data):
      if data is not None:
          if len(data) > 0:
              if data.is_valid():
                  # actual logic deeply nested
  
  # Use guard clauses:
  def process(data):
      assert data is not None, "data must not be None"
      assert len(data) > 0, "data must not be empty"
      assert data.is_valid(), "data must be valid"
      # actual logic at top level

Common Precondition Categories:

  Nullity:      assert x is not None
  Type:         assert isinstance(x, int)
  Range:        assert 0 <= x <= 100
  Length:        assert len(items) > 0
  State:        assert self._initialized
  Relationship: assert start < end
  Format:       assert re.match(r'^\d{4}-\d{2}', date)

Multiple Parameters:
  def transfer(from_acct, to_acct, amount):
      assert from_acct != to_acct, "cannot transfer to self"
      assert amount > 0, "amount must be positive"
      assert from_acct.balance >= amount, "insufficient funds"

Descriptive Messages:
  # Bad:  assert x > 0
  # Good: assert x > 0, f"expected positive x, got {x}"
  
  Always include the actual value in the message.
  Future-you debugging at 3 AM will thank present-you.

Precondition Levels:
  Cheap    Type checks, null checks      → always on
  Medium   Range checks, state checks    → on in dev/test
  Expensive Collection invariants, deep   → on in test only
            graph validation
EOF
}

cmd_postconditions() {
    cat << 'EOF'
=== Postcondition Patterns ===

Postconditions verify that a function's output satisfies its
contract AFTER execution. They catch logic errors in your own code.

Basic Pattern:
  def sqrt(x):
      assert x >= 0, "precondition: x must be non-negative"
      result = math.sqrt(x)
      assert abs(result * result - x) < 1e-10, "postcondition failed"
      return result

Return Value Contracts:
  def binary_search(arr, target):
      # ... implementation ...
      assert result == -1 or arr[result] == target
      assert result == -1 or (result == 0 or arr[result-1] < target)
      return result

State Transition Postconditions:
  def push(self, item):
      old_size = len(self._stack)
      self._stack.append(item)
      assert len(self._stack) == old_size + 1
      assert self._stack[-1] == item

Sorting Postconditions:
  def sort(items):
      result = _merge_sort(items)
      assert len(result) == len(items), "lost elements"
      assert all(result[i] <= result[i+1] for i in range(len(result)-1))
      assert sorted(items) == result, "permutation check"
      return result

Conservation Postconditions:
  Verify quantities are preserved:
  def redistribute(buckets):
      total_before = sum(buckets)
      # ... redistribution logic ...
      assert sum(buckets) == total_before, "total must be conserved"

Idempotency Postconditions:
  def normalize(text):
      result = _do_normalize(text)
      assert _do_normalize(result) == result, "must be idempotent"
      return result

Postcondition Cost:
  Simple value checks     → nearly free, always use
  Collection properties   → O(n), use in testing
  Full contract verify    → O(n²)+, test-only
EOF
}

cmd_invariants() {
    cat << 'EOF'
=== Invariants ===

An invariant is a condition that remains true throughout a scope.
Three types: class invariants, loop invariants, data invariants.

Class Invariants:
  Properties that must hold for every instance at every observable point.
  Check after construction and after every public method.

  class BankAccount:
      def _check_invariants(self):
          assert self.balance >= 0, "balance cannot be negative"
          assert self.owner is not None, "must have owner"
          assert len(self.transactions) >= 0
      
      def __init__(self, owner, initial):
          self.owner = owner
          self.balance = initial
          self.transactions = []
          self._check_invariants()
      
      def withdraw(self, amount):
          assert amount > 0             # precondition
          assert amount <= self.balance  # precondition
          self.balance -= amount
          self.transactions.append(-amount)
          self._check_invariants()       # invariant check

Loop Invariants:
  Conditions that hold before and after every iteration.
  Critical for proving loop correctness.

  # Binary search loop invariant:
  # arr[lo] <= target <= arr[hi]  (if target exists)
  def binary_search(arr, target):
      lo, hi = 0, len(arr) - 1
      while lo <= hi:
          assert lo >= 0 and hi < len(arr)  # bounds invariant
          mid = (lo + hi) // 2
          if arr[mid] == target: return mid
          elif arr[mid] < target: lo = mid + 1
          else: hi = mid - 1
      return -1

Data Structure Invariants:
  BST:    left.val < node.val < right.val for all nodes
  Heap:   parent.val <= child.val for all parent-child pairs
  RBTree: black-height equal on all paths, no red-red pairs
  Queue:  head <= tail, size = tail - head

Invariant Verification Timing:
  Always: after construction, after public mutations
  Debug:  after every internal mutation
  Never:  during mutation (state may be temporarily invalid)
EOF
}

cmd_languages() {
    cat << 'EOF'
=== Assertions Across Languages ===

Python:
  assert condition, "message"
  assert x > 0, f"expected positive, got {x}"
  # Disabled with: python -O (optimized mode)
  # __debug__ is False when optimized
  # NEVER use for input validation — can be disabled!

Java:
  assert condition : "message";
  assert index >= 0 : "Index: " + index;
  // Disabled by default! Enable: java -ea (enable assertions)
  // -ea:com.mypackage...  enable for specific package
  // Use Objects.requireNonNull() for production null checks

C / C++:
  #include <assert.h>
  assert(ptr != NULL);
  assert(size > 0 && "size must be positive");
  // Disabled with: #define NDEBUG (before include)
  // static_assert(sizeof(int) == 4, "need 32-bit int");  // compile-time!

JavaScript / TypeScript:
  console.assert(x > 0, "x must be positive");  // doesn't throw!
  // Node.js:
  const assert = require('assert');
  assert.strictEqual(a, b);
  assert.deepStrictEqual(obj1, obj2);
  // TypeScript: asserts keyword
  function assertString(val: any): asserts val is string {
    if (typeof val !== "string") throw new Error("not string");
  }

Rust:
  assert!(condition, "message with {}", value);
  assert_eq!(a, b, "a and b must be equal");
  assert_ne!(a, b);
  debug_assert!(condition);  // only in debug builds
  // assert! panics in both debug and release
  // debug_assert! only panics in debug builds

Go:
  // No built-in assert! By design.
  // Use explicit if + panic or testing.T
  if x <= 0 {
      panic(fmt.Sprintf("expected positive, got %d", x))
  }
  // In tests:
  if got != want {
      t.Errorf("got %v, want %v", got, want)
  }

Swift:
  assert(x > 0, "must be positive")       // debug only
  precondition(x > 0, "must be positive")  // debug AND release
  fatalError("unreachable")                // always crashes
EOF
}

cmd_contracts() {
    cat << 'EOF'
=== Design by Contract ===

Formalized by Bertrand Meyer (Eiffel language, 1986).
Every function has a contract: preconditions, postconditions,
and class invariants.

The Contract Metaphor:
  Supplier (callee):  "If you meet my preconditions,
                       I guarantee my postconditions."
  Client (caller):    "I'll meet your preconditions,
                       and I expect your postconditions."

  Like a legal contract — obligations and benefits for both sides.

Eiffel Syntax (the original):
  deposit (amount: REAL)
    require            -- preconditions
      positive: amount > 0
      account_open: is_open
    do
      balance := balance + amount
    ensure             -- postconditions
      increased: balance = old balance + amount
      still_open: is_open
    end

  class BANK_ACCOUNT
    invariant
      non_negative: balance >= 0
      consistent: transactions.count >= 0
    end

Liskov Substitution & Contracts:
  Subclass contracts must be compatible with parent:
    Preconditions:   may be WEAKER (accept more)
    Postconditions:  may be STRONGER (guarantee more)
    Invariants:      must be MAINTAINED
  
  Violation = broken substitutability

Modern Contract Libraries:
  Python:  icontract, deal, dpcontracts
  Java:    Cofoja, valid4j, Bean Validation (@NotNull, @Min)
  C++:     Boost.Contract, C++20 [[expects]], [[ensures]]
  C#:      Code Contracts (System.Diagnostics.Contracts)
  Kotlin:  require(), check(), requireNotNull()

Kotlin Built-in Contracts:
  fun process(name: String, age: Int) {
      require(name.isNotBlank()) { "name required" }  // IllegalArgument
      require(age >= 0) { "age must be non-negative" } // IllegalArgument
      check(isInitialized) { "not initialized" }       // IllegalState
  }

Contract Strength Levels:
  Level 1: Preconditions only (most common)
  Level 2: Pre + postconditions (recommended)
  Level 3: Pre + post + invariants (full DbC)
  Level 4: + formal verification (research/safety-critical)
EOF
}

cmd_antipatterns() {
    cat << 'EOF'
=== Assertion Anti-Patterns ===

1. Side Effects in Assertions
   # DANGEROUS — behavior changes when assertions disabled!
   assert users.pop() is not None     # modifies list!
   assert file.read() != ""           # advances file pointer!
   assert db.delete(id) == True        # deletes data!
   
   # Correct: separate the action from the check
   user = users.pop()
   assert user is not None

2. Catching AssertionError
   # WRONG — defeats the purpose
   try:
       assert x > 0
   except AssertionError:
       x = 1  # silently "fixing" a bug
   
   # If you need to handle it, use an exception:
   if x <= 0:
       raise ValueError("x must be positive")

3. Assertions for User Input
   # WRONG — can be disabled in production!
   assert len(password) >= 8, "password too short"
   assert email.contains("@"), "invalid email"
   
   # Correct: use validation + exceptions
   if len(password) < 8:
       raise ValidationError("password too short")

4. Assertions for Security
   # CATASTROPHIC — attacker runs with -O flag
   assert user.is_admin(), "unauthorized"
   assert token.is_valid(), "bad token"
   
   # Correct: always-on checks
   if not user.is_admin():
       raise PermissionError("unauthorized")

5. Empty Assert Messages
   assert x > 0           # what failed? why? what was x?
   assert x > 0, f"x must be positive, got {x}"  # much better

6. Asserting on Mutable Default State
   assert cache == {}     # brittle, depends on test order
   
7. Over-Asserting (assertion clutter)
   def add(a, b):
       assert isinstance(a, (int, float))
       assert isinstance(b, (int, float))
       result = a + b
       assert isinstance(result, (int, float))
       assert result == a + b  # tautology!
       return result

8. Asserting Implementation, Not Contract
   # Bad: testing HOW, not WHAT
   assert self._internal_list[3] == x
   # Good: testing the contract
   assert x in self  # behavior, not implementation
EOF
}

cmd_strategies() {
    cat << 'EOF'
=== Assertion Strategies ===

Unit Test Assertions:
  Use the testing framework's assertion methods — richer messages.
  
  Python unittest:
    assertEqual(a, b)
    assertRaises(TypeError, func, arg)
    assertAlmostEqual(a, b, places=5)
    assertIn(item, collection)
    assertIsInstance(obj, cls)
  
  Python pytest:
    assert a == b              # plain assert, pytest rewrites for info
    with pytest.raises(ValueError, match="positive"):
        func(-1)
  
  Java JUnit:
    assertEquals(expected, actual);
    assertThrows(Exception.class, () -> func());
    assertAll("group", () -> assertEquals(...), () -> assertTrue(...));
  
  JavaScript Jest:
    expect(value).toBe(expected);
    expect(func).toThrow(/message/);
    expect(array).toContain(item);
    expect(obj).toMatchObject(partial);

Production Code Strategy:
  Layer 1 — Always on:
    - Null checks at public API boundaries
    - Security & authorization checks
    - Data integrity checks
    Use: if/throw, require(), Objects.requireNonNull()
  
  Layer 2 — Debug/staging:
    - Internal state consistency
    - Algorithm correctness
    - Performance assumptions
    Use: assert, debug_assert!(), assert with -ea
  
  Layer 3 — Test only:
    - Expensive invariant verification
    - Exhaustive property checks
    - Fuzzing & property-based testing
    Use: test frameworks, hypothesis, QuickCheck

Library vs Application:
  Libraries: strict preconditions (fail loud on misuse)
  Applications: graceful degradation (recover when possible)
  APIs: validation errors with structured responses (400, 422)

Assertion Density Guidelines:
  Safety-critical code:  1 assert per 5-10 lines
  Business logic:        1 assert per 20-30 lines
  Utility code:          preconditions only
  Glue/UI code:          minimal (input validation instead)
EOF
}

show_help() {
    cat << EOF
assert v$VERSION — Assertion Patterns Reference

Usage: script.sh <command>

Commands:
  intro          Assertion philosophy and when to use
  preconditions  Input validation and guard clauses
  postconditions Output verification and return contracts
  invariants     Class, loop, and data invariants
  languages      Assert syntax in Python, Java, C, JS, Rust, Go
  contracts      Design-by-contract methodology
  antipatterns   Common assertion mistakes to avoid
  strategies     Assertion approaches for tests, prod, libraries
  help           Show this help
  version        Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)          cmd_intro ;;
    preconditions)  cmd_preconditions ;;
    postconditions) cmd_postconditions ;;
    invariants)     cmd_invariants ;;
    languages|langs) cmd_languages ;;
    contracts|dbc)  cmd_contracts ;;
    antipatterns)   cmd_antipatterns ;;
    strategies)     cmd_strategies ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "assert v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
