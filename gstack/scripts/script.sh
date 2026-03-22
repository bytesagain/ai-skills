#!/usr/bin/env bash
# gstack — AI-Assisted Development Workflow Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== AI-Assisted Development Workflow ===

Modern development with AI coding assistants requires structure,
review discipline, and clear quality gates to be effective.

Core Philosophy:
  - AI writes code; humans review, approve, and own it
  - Structure your workflow to catch AI mistakes early
  - Maintain context files so AI understands your codebase
  - Decompose tasks into small, reviewable units
  - Trust but verify — AI is confident even when wrong

Workflow Structure:
  1. PLAN        Define scope and constraints
  2. CONTEXT     Load project docs, standards, examples
  3. IMPLEMENT   AI generates code with human guidance
  4. REVIEW      Human reviews every change
  5. TEST        Automated tests + manual verification
  6. AUDIT       Systematic quality pass
  7. RELEASE     Version, changelog, deploy

Key Principles:
  Small Changes:    One feature/fix per session
  Clear Scope:      Define what's in/out before starting
  Context Window:   Keep relevant files loaded
  Review Everything: Never blindly accept AI output
  Test First:       Write tests before or alongside implementation
  Document Why:     AI can write code; capture the reasoning

Tool Landscape:
  Claude Code    Agentic coding with file/terminal access
  Cursor         AI-native IDE with inline generation
  GitHub Copilot Inline completions and chat
  Aider          Terminal-based AI pair programming
  Continue       Open-source VS Code AI assistant

The "10x Developer" Reality:
  AI doesn't make you 10x faster at everything
  It makes: boilerplate 100x faster, novel logic 2x faster
  It breaks: when requirements are ambiguous or domain-specific
  Net: 2-5x productivity IF you maintain quality discipline
EOF
}

cmd_prompting() {
    cat << 'EOF'
=== Structured Prompting Patterns ===

--- Task Decomposition ---
  Break large features into discrete, testable steps:

  BAD:  "Build a user authentication system"
  GOOD: Step 1: Create user model with email/password_hash
        Step 2: Implement bcrypt password hashing utility
        Step 3: Add login endpoint with JWT generation
        Step 4: Add middleware for JWT validation
        Step 5: Add rate limiting on login attempts

--- Context Loading ---
  Before starting, provide:
    - Relevant source files
    - Project conventions (naming, patterns)
    - Example of desired style
    - Test file structure
    - Dependencies and versions

  "Before implementing, read these files:
   - src/models/base.ts (our model pattern)
   - src/middleware/auth.ts (existing auth)
   - package.json (dependencies)
   Then implement the new UserRole model following the same pattern."

--- Constraint Specification ---
  Explicitly state what NOT to do:

  "Requirements:
   - Use existing database connection (don't create new one)
   - Follow the repository pattern in src/repos/
   - Use Zod for validation (not Joi)
   - Error handling must use our AppError class
   - No console.log in production code"

--- Output Format Control ---
  "Provide:
   1. The implementation (full file, not snippets)
   2. Corresponding test file
   3. Any migration needed
   4. Updated type declarations"

--- Iterative Refinement ---
  Session 1: "Implement the happy path"
  Session 2: "Add error handling for: invalid input, not found, duplicate"
  Session 3: "Add input validation and rate limiting"
  Session 4: "Write comprehensive tests"

  Each session is reviewable and revertible.

--- Anti-Patterns ---
  ✗ "Make it work" (too vague)
  ✗ "Fix all the bugs" (unbounded scope)
  ✗ "Refactor everything" (no clear success criteria)
  ✗ Long prompt with 20 requirements (context overload)
  ✗ No examples of desired style (inconsistent output)
EOF
}

cmd_review() {
    cat << 'EOF'
=== Code Review Gates ===

Every piece of AI-generated code must pass human review.

--- Review Checklist ---

  Correctness:
  [ ] Does it actually solve the stated problem?
  [ ] Are edge cases handled (null, empty, boundary)?
  [ ] Are error paths correct (not just happy path)?
  [ ] Does it match existing behavior (no regressions)?

  Security:
  [ ] No hardcoded secrets or credentials
  [ ] Input validation present and correct
  [ ] SQL/NoSQL injection protected
  [ ] Authentication/authorization enforced
  [ ] No unsafe deserialization

  Performance:
  [ ] No N+1 queries or unnecessary DB calls
  [ ] Appropriate indexing for new queries
  [ ] No memory leaks (event listeners, closures)
  [ ] No blocking operations in async context

  Style & Consistency:
  [ ] Follows project naming conventions
  [ ] Uses existing patterns (not reinventing)
  [ ] Imports from correct modules
  [ ] No dead code or commented-out blocks

  Tests:
  [ ] Tests actually test the new code
  [ ] Tests cover error paths, not just happy path
  [ ] Tests are deterministic (no flaky timing)
  [ ] Test naming is descriptive

--- Common AI Code Mistakes ---
  1. Hallucinated APIs: calls methods that don't exist
  2. Wrong import paths: makes up module locations
  3. Outdated patterns: uses deprecated APIs
  4. Over-engineering: adds unnecessary abstractions
  5. Incomplete error handling: catches but doesn't handle
  6. Missing null checks: assumes data always exists
  7. Wrong library version: uses v3 API with v2 installed
  8. Inconsistent naming: mixes conventions within project

--- Review Severity Levels ---
  BLOCKER:   Security issue, data loss risk, crash
  CRITICAL:  Logic error, missing error handling
  MAJOR:     Performance issue, maintainability concern
  MINOR:     Style inconsistency, naming convention
  NIT:       Cosmetic, personal preference
EOF
}

cmd_release() {
    cat << 'EOF'
=== Release Management ===

--- Version Strategy ---
  Semantic Versioning: MAJOR.MINOR.PATCH
    MAJOR: Breaking changes (API incompatible)
    MINOR: New features (backward compatible)
    PATCH: Bug fixes (backward compatible)

  Pre-release: 1.2.0-beta.1, 1.2.0-rc.1
  Build metadata: 1.2.0+build.123

--- Changelog Generation ---
  Conventional Commits → automated changelog:
    feat:     → Features section
    fix:      → Bug Fixes section
    perf:     → Performance section
    docs:     → Documentation section
    refactor: → Code Refactoring section
    BREAKING CHANGE: → Breaking Changes (triggers MAJOR)

  Format (Keep a Changelog):
    ## [1.2.0] - 2024-03-15
    ### Added
    - User role-based access control (#123)
    ### Fixed
    - Login rate limiter race condition (#456)
    ### Changed
    - Upgraded bcrypt from v5 to v6

--- Deployment Gates ---

  Pre-deployment checklist:
  [ ] All tests pass (unit, integration, e2e)
  [ ] Linting passes with zero warnings
  [ ] Type checking passes (TypeScript strict)
  [ ] Security audit clean (npm audit, cargo audit)
  [ ] Bundle size within budget
  [ ] Changelog updated
  [ ] Version bumped in package.json/Cargo.toml
  [ ] Migration scripts tested
  [ ] Rollback plan documented

  Deployment strategy:
    Staging first → smoke test → production
    Canary deployment: 5% → 25% → 50% → 100%
    Feature flags for gradual rollout
    Automated rollback on error rate spike

--- Release Cadence ---
  Continuous: Deploy every merged PR (with gates)
  Weekly: Batch features, release Tuesdays
  Sprint: Release at end of each sprint
  Monthly: Larger releases with more QA

--- Hotfix Process ---
  1. Branch from production tag
  2. Minimal fix only (no feature work)
  3. Cherry-pick to main after production deploy
  4. Bump PATCH version
  5. Post-mortem: why wasn't this caught?
EOF
}

cmd_qa() {
    cat << 'EOF'
=== QA Audit Passes ===

Systematic quality checks across the codebase.

--- Security Audit ---
  Run: npm audit, cargo audit, pip audit
  Check: OWASP Top 10 for web applications
  Review: authentication flows, authorization checks
  Verify: secrets not in code (git-secrets, gitleaks)
  Test: input validation on all external inputs
  Check: dependency licenses (license-checker)

--- Performance Audit ---
  Profile: identify hot paths (flame graphs)
  Database: check query plans, missing indexes
  Bundle: analyze bundle size (webpack-bundle-analyzer)
  Memory: check for leaks (Chrome DevTools)
  Load test: verify under expected traffic
  Lighthouse: web performance audit (Core Web Vitals)

--- Dependency Audit ---
  Outdated: npm outdated, cargo outdated
  Unused: depcheck, cargo-udeps
  Duplicate: check for multiple versions of same package
  License: verify compatibility with your license
  Maintenance: check if dependencies are maintained
  Size: large dependencies with small usage?

--- Code Quality Audit ---
  Complexity: flag functions with McCabe > 15
  Duplication: detect copy-paste (jscpd, cargo-duplicates)
  Dead code: unused exports, unreachable branches
  TODO/FIXME: review and resolve or ticket
  Console.log: remove debugging statements
  Type coverage: check for 'any' types (TypeScript)

--- Test Quality Audit ---
  Coverage: identify untested critical paths
  Mutation testing: verify tests actually catch bugs
  Flaky tests: identify and fix non-deterministic tests
  Test performance: slow tests that block CI
  Test isolation: ensure tests don't depend on each other

--- Accessibility Audit ---
  axe-core: automated a11y testing
  Keyboard navigation: tab through all interactive elements
  Screen reader: test with VoiceOver/NVDA
  Color contrast: WCAG AA compliance (4.5:1 ratio)
  Alt text: all images and icons labeled

--- Audit Frequency ---
  Every PR:     Linting, tests, type check
  Weekly:       Dependency updates, security scan
  Monthly:      Performance audit, dead code cleanup
  Quarterly:    Full security review, accessibility audit
  Annually:     Architecture review, tech debt assessment
EOF
}

cmd_standards() {
    cat << 'EOF'
=== Coding Standards for AI-Generated Code ===

--- Naming Conventions (be explicit) ---
  Document your conventions so AI follows them:

  Files:
    Components: PascalCase.tsx (UserProfile.tsx)
    Utilities: camelCase.ts (formatDate.ts)
    Types: PascalCase.types.ts
    Tests: *.test.ts or *.spec.ts

  Variables:
    Boolean: isActive, hasPermission, canEdit (prefix)
    Arrays: users (plural), userList
    Callbacks: onSubmit, handleClick
    Constants: MAX_RETRIES, DEFAULT_TIMEOUT

  Functions:
    Getters: getUser, fetchOrders
    Setters: setStatus, updateProfile
    Boolean: isValid, hasAccess, canModify
    Handlers: handleSubmit, onClickSave
    Transforms: parseJSON, formatCurrency

--- Error Handling Pattern ---
  // Define error types
  class AppError extends Error {
    constructor(message, code, statusCode) { ... }
  }

  // Throw specific errors
  throw new AppError('User not found', 'NOT_FOUND', 404);

  // Catch and wrap external errors
  try { ... }
  catch (err) { throw AppError.from(err); }

  // Never swallow errors silently
  ✗ catch (err) { }
  ✓ catch (err) { logger.error(err); throw err; }

--- File Organization ---
  src/
  ├── models/        Data models and schemas
  ├── services/      Business logic
  ├── controllers/   Request handlers
  ├── middleware/     Express/Koa middleware
  ├── utils/         Pure utility functions
  ├── types/         TypeScript type definitions
  └── __tests__/     Test files (mirror src structure)

--- AI-Specific Standards ---
  1. AI must use existing utilities, not recreate them
  2. AI must follow the project's import style
  3. AI must not add dependencies without asking
  4. AI-generated code gets the same review as human code
  5. Comments explain WHY, not WHAT (AI tends to over-comment)
  6. No "smart" one-liners when clear code would do
  7. Prefer explicit over clever
EOF
}

cmd_context() {
    cat << 'EOF'
=== Context Management ===

AI coding assistants perform dramatically better with project context.

--- CLAUDE.md / AGENTS.md ---
  Project root file that loads into AI context automatically.

  Include:
    ## Project Overview
    Brief description, tech stack, architecture

    ## Conventions
    Naming, file structure, import rules

    ## Key Files
    - src/config.ts — all environment variables
    - src/db.ts — database connection (don't create another)

    ## Commands
    - Build: npm run build
    - Test: npm test
    - Lint: npm run lint

    ## Don'ts
    - Don't use console.log (use logger)
    - Don't add new dependencies without asking
    - Don't modify migration files after they've run

--- .cursorrules / .copilot-instructions.md ---
  IDE-specific context files:
    - Cursor uses .cursorrules
    - Copilot uses .copilot-instructions.md
    - Same purpose: persistent project context

--- Architecture Decision Records (ADR) ---
  docs/adr/
  ├── 001-use-postgresql.md
  ├── 002-jwt-auth-strategy.md
  └── 003-event-driven-architecture.md

  AI can reference ADRs to understand WHY decisions were made

--- Context Window Strategy ---
  Limited context window → be strategic:
    1. Load project doc (CLAUDE.md) — always
    2. Load relevant source files — targeted
    3. Load example of desired pattern — guide style
    4. Load relevant test files — ensure test style matches
    5. Don't load everything — too much noise hurts quality

--- Keeping Context Fresh ---
  Update CLAUDE.md when:
    - New conventions are established
    - Common mistakes are repeated
    - New team members (AI or human) join
    - Architecture changes significantly

  Version control your context files — they're as important as code
EOF
}

cmd_pitfalls() {
    cat << 'EOF'
=== Common Pitfalls in AI-Assisted Development ===

--- 1. Accepting Without Reading ---
  Problem: AI generates plausible code that doesn't actually work
  Fix: Read every line. Test every path. Question every assumption.
  Rule: If you can't explain what the code does, don't merge it.

--- 2. Context Drift ---
  Problem: Long sessions → AI forgets earlier decisions
  Fix: Start new sessions for new tasks
  Fix: Summarize decisions in context files
  Fix: Re-load key context periodically

--- 3. Hallucinated Dependencies ---
  Problem: AI imports packages that don't exist or uses wrong versions
  Fix: Verify every import, check package.json, run builds
  Common: Made-up npm packages, wrong Go module paths

--- 4. Premature Abstraction ---
  Problem: AI loves creating interfaces, factories, strategies
  Fix: YAGNI — start concrete, abstract when needed
  Rule: Three instances before abstracting

--- 5. Copy-Paste Propagation ---
  Problem: AI copies patterns without understanding context
  Fix: Ask "why this pattern?" before accepting
  Example: Error handling copied but wrong error type

--- 6. Test Theater ---
  Problem: Tests that pass but don't test anything meaningful
  Example: Testing that a mock returns what you told it to return
  Fix: Mutation testing, review test assertions carefully
  Rule: If the test can't fail, it's not a test

--- 7. Security Blind Spots ---
  Problem: AI doesn't always think about security
  Common: Missing auth checks, SQL injection, XSS
  Fix: Explicit security review step in every PR
  Rule: Security is never "assumed" — it's verified

--- 8. Documentation Decay ---
  Problem: Code changes but docs/comments don't update
  Fix: Update docs in the same commit as code changes
  Fix: Automated doc generation where possible

--- 9. Scope Creep in Sessions ---
  Problem: "While we're at it..." leads to sprawling changes
  Fix: One task per session, strict scope boundaries
  Rule: If it's not in the original ask, it's a new task

--- 10. Over-Reliance ---
  Problem: Losing the ability to write code without AI
  Fix: Understand every line the AI writes
  Fix: Regularly code without AI assistance
  Rule: You should be able to maintain what the AI wrote
EOF
}

show_help() {
    cat << EOF
gstack v$VERSION — AI-Assisted Development Workflow Reference

Usage: script.sh <command>

Commands:
  intro        AI-assisted development philosophy and workflow
  prompting    Structured prompting patterns for AI coding
  review       Code review gates and checklists
  release      Release management and deployment gates
  qa           QA audit passes (security, performance, deps)
  standards    Coding standards for AI-generated code
  context      Context management (CLAUDE.md, ADR, etc.)
  pitfalls     Common pitfalls and how to avoid them
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    prompting)  cmd_prompting ;;
    review)     cmd_review ;;
    release)    cmd_release ;;
    qa)         cmd_qa ;;
    standards)  cmd_standards ;;
    context)    cmd_context ;;
    pitfalls)   cmd_pitfalls ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "gstack v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
