#!/usr/bin/env bash
# snapshot — Snapshot Testing Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Snapshot Testing ===

Snapshot testing captures the rendered output of a component, API response,
or data structure and saves it to a file. Future test runs compare current
output against the stored snapshot — any difference fails the test.

Where It Fits in the Testing Pyramid:
  Unit Tests        Test individual functions/logic
  Snapshot Tests    Catch unintended changes in output/structure
  Integration Tests Test module interactions
  E2E Tests         Test full user workflows

Key Properties:
  - Deterministic: same input must always produce same output
  - Human-readable: snapshots should be reviewable in PRs
  - Low-cost: near-zero effort to create, easy to maintain
  - Regression-catching: detects any structural change

What Snapshots Are Good For:
  ✓ UI component rendered output (HTML/JSX trees)
  ✓ API response shapes and structures
  ✓ Serialized configuration objects
  ✓ Error message formatting
  ✓ CLI output verification
  ✓ GraphQL query results

What Snapshots Are NOT Good For:
  ✗ Testing business logic (use unit tests)
  ✗ Highly dynamic output (timestamps, random IDs)
  ✗ Performance verification
  ✗ Visual pixel-level accuracy (use visual regression tools)

Frameworks with Snapshot Support:
  Jest         Built-in toMatchSnapshot / toMatchInlineSnapshot
  Vitest       Compatible Jest-like snapshot API
  Ava          t.snapshot()
  Rust (insta) insta::assert_snapshot!
  Go (cupaloy) cupaloy.SnapshotT(t, result)
  Swift        SnapshotTesting by Point-Free
  Python       snapshottest / syrupy
EOF
}

cmd_workflow() {
    cat << 'EOF'
=== Snapshot Test Lifecycle ===

Phase 1: First Run — Capture
  - Test runs for the first time
  - No existing snapshot file found
  - Framework serializes the output and writes .snap file
  - Test passes (baseline established)
  - Developer commits .snap file alongside test

Phase 2: Subsequent Runs — Compare
  - Test runs again (locally or in CI)
  - Framework serializes current output
  - Compares against stored .snap file
  - If identical → test passes
  - If different → test fails with diff output

Phase 3: Intentional Change — Update
  - Developer makes a deliberate change to component
  - Snapshot test fails (expected)
  - Developer reviews the diff carefully
  - Runs update command: jest --updateSnapshot / jest -u
  - New snapshot is written
  - Developer commits updated .snap file

  ⚠ CRITICAL: Never blindly update snapshots!
    Always review the diff before committing.

File Structure:
  src/
    Button.tsx
    Button.test.tsx
    __snapshots__/
      Button.test.tsx.snap    ← auto-generated

Typical .snap File Content:
  exports[`Button renders correctly 1`] = `
  <button
    className="btn btn-primary"
    onClick={[Function]}
  >
    Click me
  </button>
  `;

Git Workflow:
  1. Write test → run → snapshot created
  2. git add src/__snapshots__/Button.test.tsx.snap
  3. Commit test + snapshot together
  4. PR reviewer checks both test logic AND snapshot content
  5. CI fails if snapshots are outdated
EOF
}

cmd_formats() {
    cat << 'EOF'
=== Snapshot Formats ===

--- File-Based Snapshots ---
  Default in Jest. Stored in __snapshots__/ directory.
  Pros: Keeps test files clean, easy to browse
  Cons: Separate file to review, can get stale

  it('renders header', () => {
    const tree = renderer.create(<Header />).toJSON();
    expect(tree).toMatchSnapshot();
  });

--- Inline Snapshots ---
  Snapshot stored directly in the test file.
  Jest auto-fills the expected value on first run.

  it('renders title', () => {
    expect(getTitle()).toMatchInlineSnapshot(`"Welcome"`);
  });

  Pros: Everything in one place, easier code review
  Cons: Clutters test files for large outputs
  Best for: Small, focused values (strings, numbers, short objects)

--- Property Matchers ---
  Handle dynamic values within snapshots.

  expect(user).toMatchSnapshot({
    id: expect.any(Number),
    createdAt: expect.any(Date),
    name: 'Alice',        // exact match
  });

  The snapshot stores:
    Object {
      "id": Any<Number>,
      "createdAt": Any<Date>,
      "name": "Alice",
    }

--- Custom Serializers ---
  Control how objects are serialized in snapshots.

  // jest.config.js
  snapshotSerializers: ['enzyme-to-json/serializer']

  Built-in serializers handle:
    React elements, HTML strings, plain objects, arrays

  Custom serializer interface:
    {
      test(val) { return val instanceof MyClass; },
      serialize(val, config, indentation, depth, refs, printer) {
        return `MyClass { ${val.name} }`;
      }
    }

--- Snapshot Resolvers ---
  Customize where snapshot files are stored.

  // jest.config.js
  snapshotResolver: './snapshotResolver.js'

  module.exports = {
    resolveSnapshotPath: (testPath) => testPath + '.snap',
    resolveTestPath: (snapPath) => snapPath.replace('.snap', ''),
    testPathForConsistencyCheck: 'some/test.js',
  };
EOF
}

cmd_jest() {
    cat << 'EOF'
=== Jest Snapshot API ===

Core Matchers:
  .toMatchSnapshot(propertyMatchers?, hint?)
    Compare against file-based snapshot
    hint: optional name for the snapshot

  .toMatchInlineSnapshot(propertyMatchers?, inlineSnapshot?)
    Compare against inline snapshot in test file

  .toThrowErrorMatchingSnapshot(hint?)
    Snapshot the error message from a thrown error

  .toThrowErrorMatchingInlineSnapshot(inlineSnapshot?)
    Inline version of error snapshot

CLI Commands:
  jest --updateSnapshot       Update all outdated snapshots
  jest -u                     Short form
  jest --ci                   Fail on new snapshots (CI mode)
  jest -u --testPathPattern=Button   Update only Button snapshots

Interactive Mode (jest --watch):
  Press 'u' to update failing snapshots
  Press 'i' to update interactively (one by one)

Snapshot Configuration (jest.config.js):
  snapshotFormat: {
    printBasicPrototype: false,   // cleaner output
    escapeString: true,
  }
  snapshotSerializers: [...]     // custom serializers

Best Practices with Jest:
  1. One assertion per snapshot test
  2. Use descriptive test names (they become snapshot keys)
  3. Keep snapshots small and focused
  4. Use property matchers for dynamic data
  5. Review snapshot diffs in PRs like code changes
  6. Delete obsolete snapshots: jest --ci warns about them
  7. Use toMatchInlineSnapshot for values < 5 lines

Obsolete Snapshot Detection:
  jest --ci automatically fails if snapshots exist
  that no test references anymore.

  To clean up:
    jest -u  (rewrites all snapshot files, removing obsolete ones)
EOF
}

cmd_pitfalls() {
    cat << 'EOF'
=== Snapshot Anti-Patterns ===

1. Mega-Snapshots
   Problem: Snapshot is 500+ lines, nobody reads it
   Fix: Snapshot smaller, focused parts of the component
   Bad:  expect(entirePage).toMatchSnapshot()
   Good: expect(header).toMatchSnapshot()
         expect(navItems).toMatchSnapshot()

2. Blind Updates
   Problem: Developer runs jest -u without reading diffs
   Fix: CI should require snapshot review in PRs
   Rule: Treat snapshot updates like code changes

3. Non-Deterministic Output
   Problem: Timestamps, random IDs, Math.random() in output
   Fix: Use property matchers or mock Date/random
   expect(obj).toMatchSnapshot({
     id: expect.any(String),
     timestamp: expect.any(Number)
   });

4. Testing Implementation Details
   Problem: Snapshot captures internal class names, CSS-in-JS hashes
   Fix: Use shallow rendering, test meaningful output only
   Result: Fewer false positives on refactors

5. Snapshot Fatigue
   Problem: So many snapshot failures that team ignores them
   Fix: Fewer, more focused snapshots
   Rule: If a snapshot fails, it should mean something broke

6. Missing Context
   Problem: Reviewing snapshot diff without understanding intent
   Fix: Use hint parameter for meaningful names
   expect(tree).toMatchSnapshot('logged-in-admin-view')

7. Orphaned Snapshots
   Problem: Test deleted but snapshot file remains
   Fix: Run jest --ci periodically to detect orphans
   Or use jest -u to clean up

8. Coupling to Third-Party Output
   Problem: Snapshot breaks when dependency updates
   Fix: Abstract third-party rendering, snapshot your wrapper
EOF
}

cmd_diffing() {
    cat << 'EOF'
=== Reading Snapshot Diffs ===

Diff Format (Jest):
  - Snapshot    (what was stored)
  + Received    (what test produced now)

  Snapshot:
  - <div className="container">
  -   <h1>Old Title</h1>
  + <div className="container wrapper">
  +   <h1>New Title</h1>
      <p>Content unchanged</p>
    </div>

Structural Changes:
  Added element    + lines appear with no - counterpart
  Removed element  - lines appear with no + counterpart
  Changed value    Both - and + on same logical line
  Moved element    Remove from old position, add at new

Analyzing the Diff — Ask These Questions:
  1. Is this change intentional?
     → Yes: update snapshot, commit with explanation
     → No: you found a regression, fix the code

  2. Is the change structural or cosmetic?
     Structural: new props, changed hierarchy, added/removed nodes
     Cosmetic: whitespace, formatting, className changes

  3. Is the diff too large to review?
     → Your snapshot is probably too big, refactor

  4. Does the change match the PR description?
     → Changing a button label? Expect snapshot diff in button tests only
     → Unexpected diffs elsewhere? Investigate side effects

Common Causes of Unexpected Diffs:
  - Dependency update changed default rendering
  - CSS module hash changed (rebuild artifacts)
  - Date/time not mocked in test environment
  - Platform-specific rendering (CI vs local)
  - Node.js version difference in serialization

Tools for Better Diffs:
  jest-serializer-html    Prettier HTML in snapshots
  enzyme-to-json          Clean React tree serialization
  snapshot-diff           Show diff between two snapshots
EOF
}

cmd_ci() {
    cat << 'EOF'
=== Snapshots in CI/CD ===

The Golden Rule:
  CI should NEVER update snapshots automatically.
  Snapshot updates are intentional decisions by developers.

Jest CI Mode:
  jest --ci
  - Fails if a new snapshot is created (missing .snap file)
  - Prevents accidental snapshot creation in CI
  - Reports obsolete snapshots as errors

CI Pipeline Setup:
  # .github/workflows/test.yml
  - name: Run tests
    run: npx jest --ci --coverage
    # --ci ensures no new snapshots are silently created

PR Review Checklist for Snapshots:
  [ ] Snapshot diff matches the intended code change
  [ ] No unrelated snapshot changes
  [ ] Snapshot is reasonably sized (< 100 lines ideally)
  [ ] Dynamic values use property matchers
  [ ] New snapshots have descriptive test names

Branch Protection Rules:
  1. Require passing snapshot tests before merge
  2. Require at least one reviewer for snapshot changes
  3. Auto-label PRs that modify .snap files

Preventing Snapshot Pollution:
  - Use .gitattributes to mark .snap files:
    *.snap linguist-generated=true
    (Hides from GitHub diff stats but still reviewable)

  - Pre-commit hook to check for large snapshots:
    find . -name '*.snap' -size +50k -exec echo "Large snapshot: {}" \;

Snapshot Testing in Monorepos:
  - Run snapshot tests only for changed packages
  - jest --changedSince=main --ci
  - Each package maintains its own __snapshots__/
  - Shared snapshot serializers in root config
EOF
}

cmd_strategies() {
    cat << 'EOF'
=== Advanced Snapshot Strategies ===

--- Focused Snapshots ---
  Don't snapshot entire component trees.
  Snapshot specific, meaningful parts:

  // Instead of:
  expect(render(<Dashboard />)).toMatchSnapshot();

  // Do:
  const { getByRole } = render(<Dashboard />);
  expect(getByRole('navigation')).toMatchSnapshot();
  expect(getByRole('main')).toMatchSnapshot();

--- API Response Snapshots ---
  Capture expected API response shapes:

  it('returns user profile', async () => {
    const response = await getUser(1);
    expect(response).toMatchSnapshot({
      id: expect.any(Number),
      lastLogin: expect.any(String),
    });
  });

  Benefits: Catches accidental API contract changes

--- Database State Snapshots ---
  Capture database state after operations:

  it('creates order correctly', async () => {
    await createOrder(orderData);
    const dbState = await getTableSnapshot('orders');
    expect(dbState).toMatchSnapshot({
      rows: expect.arrayContaining([
        expect.objectContaining({ status: 'pending' })
      ])
    });
  });

--- Visual Regression (Beyond Text Snapshots) ---
  Tools: Percy, Chromatic, BackstopJS, Playwright
  - Render component in real browser
  - Take screenshot
  - Compare pixel-by-pixel against baseline
  - Highlight visual differences

--- Snapshot per State ---
  Test components in all meaningful states:

  ['loading', 'error', 'empty', 'populated'].forEach(state => {
    it(`renders ${state} state`, () => {
      expect(render(<List state={state} />)).toMatchSnapshot();
    });
  });

--- Contract Testing with Snapshots ---
  Use snapshots as lightweight API contracts:
  - Producer service snapshots its responses
  - Consumer service snapshots expected request/response shapes
  - Both sides must agree on the snapshot
  - Cheaper alternative to full Pact/contract testing

--- Rust / insta Workflow ---
  cargo insta test           Run tests, collect pending snapshots
  cargo insta review         Interactively accept/reject changes
  cargo insta accept --all   Accept all pending changes
  Files: *.snap (accepted) and *.snap.new (pending review)
EOF
}

show_help() {
    cat << EOF
snapshot v$VERSION — Snapshot Testing Reference

Usage: script.sh <command>

Commands:
  intro        What snapshot testing is and when to use it
  workflow      Snapshot lifecycle: capture, compare, update
  formats      File-based, inline, property matchers, serializers
  jest         Jest snapshot API and configuration
  pitfalls     Common anti-patterns and how to avoid them
  diffing      Reading and interpreting snapshot diffs
  ci           Snapshot testing in CI/CD pipelines
  strategies   Advanced strategies: focused, API, visual, contract
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    workflow)   cmd_workflow ;;
    formats)    cmd_formats ;;
    jest)       cmd_jest ;;
    pitfalls)   cmd_pitfalls ;;
    diffing)    cmd_diffing ;;
    ci)         cmd_ci ;;
    strategies) cmd_strategies ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "snapshot v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
