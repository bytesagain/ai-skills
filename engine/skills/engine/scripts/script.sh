#!/usr/bin/env bash
# engine — Rule Engine & Decision Logic Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Rule Engine Overview ===

A rule engine evaluates business rules against data to produce decisions,
separating business logic from application code.

What Is a Rule Engine?
  A software system that executes business rules in a runtime
  production environment. Rules are expressed as condition-action
  pairs: "IF conditions THEN actions."

Why Use a Rule Engine?
  1. Business rules change frequently (no code deployment needed)
  2. Non-developers need to manage rules (business analysts)
  3. Complex interdependent rules (hundreds of conditions)
  4. Audit trail requirements (which rules fired, why)
  5. Consistency across systems (single rule repository)
  6. Regulatory compliance (rules map to regulations)

Types of Rule Engines:

  Production Rule Systems:
    IF-THEN rules with pattern matching
    Forward chaining (data-driven)
    Examples: Drools, CLIPS, Jess

  Decision Table Engines:
    Tabular rule representation
    Easy for business users to understand
    Examples: DMN, Excel-based rules

  Complex Event Processing (CEP):
    Rules over streams of events
    Temporal patterns and windows
    Examples: Esper, Siddhi, Flink CEP

  Policy Engines:
    Access control and authorization rules
    ABAC (Attribute-Based Access Control)
    Examples: OPA, Casbin, Cedar

  Workflow/Orchestration Engines:
    Long-running business processes
    State machines with rule-based transitions
    Examples: Camunda, Temporal, Step Functions

When NOT to Use a Rule Engine:
  ✗ Simple if/else logic (< 10 rules)
  ✗ Rules that never change
  ✗ Performance-critical hot paths (overhead)
  ✗ When rules have no business ownership
  ✗ When a lookup table or config file suffices
EOF
}

cmd_patterns() {
    cat << 'EOF'
=== Rule Engine Patterns ===

Forward Chaining (Data-Driven):
  Process:
    1. Assert facts (data) into working memory
    2. Match rules against facts (pattern matching)
    3. Select rules to fire (conflict resolution)
    4. Execute rule actions (may add/modify facts)
    5. Repeat until no more rules can fire

  Example:
    Fact: customer.age = 25, customer.income = 80000
    Rule 1: IF age < 30 AND income > 50000 THEN tier = "Gold"
    Rule 2: IF tier = "Gold" THEN discount = 15%
    → Rule 1 fires, adds tier=Gold
    → Rule 2 fires, sets discount=15%

  Use when: Starting from data, discovering conclusions

Backward Chaining (Goal-Driven):
  Process:
    1. Start with a goal (what to prove)
    2. Find rules that conclude the goal
    3. Check if rule conditions are satisfied
    4. If not, set sub-goals for unproven conditions
    5. Recursively prove sub-goals

  Example:
    Goal: Can customer get a loan?
    Rule: IF credit_score > 700 AND debt_ratio < 0.4 THEN approve
    Sub-goal 1: What is credit_score? → Look up
    Sub-goal 2: What is debt_ratio? → Calculate

  Use when: Need to prove/disprove a specific conclusion

Rete Algorithm:
  Invented by Charles Forgy (1979)
  Optimization for forward chaining with many rules:
    - Build a network of nodes from rule conditions
    - Alpha nodes test individual conditions
    - Beta nodes test combinations (joins)
    - Token passing through the network
    - Only re-evaluate when facts change (incremental)

  Performance:
    Naive: O(rules × facts^conditions) per cycle
    Rete:  O(changes × affected_rules) per cycle
    Massive improvement for large rule sets with few changes

  Used by: Drools, CLIPS, Jess, OpenRules

Conflict Resolution Strategies:
  When multiple rules match, which fires first?

  Priority/Salience    Explicit rule priority number
  Specificity          More specific rules fire first
  Recency              Rules matching newer facts first
  Refraction           Each rule fires only once per fact set
  Random               Non-deterministic selection

Rule Chaining:
  Rules can trigger other rules by modifying facts
  Advantages: modular, composable logic
  Risks: infinite loops, unintended cascades
  Mitigation: loop detection, max iterations, rule ordering
EOF
}

cmd_tables() {
    cat << 'EOF'
=== Decision Tables ===

A decision table maps conditions to actions in a tabular format.
Easy for business users to read, review, and maintain.

Structure:
  ┌───────────┬──────────┬──────────┬───────────────┐
  │ Condition1│Condition2│Condition3│    Action      │
  ├───────────┼──────────┼──────────┼───────────────┤
  │   Yes     │  High    │  ≤ 30    │ Approve       │
  │   Yes     │  High    │  > 30    │ Review        │
  │   Yes     │  Low     │    -     │ Decline       │
  │   No      │    -     │    -     │ Decline       │
  └───────────┴──────────┴──────────┴───────────────┘
  "-" means "any value" (don't care)

Decision Table Types:

  Limited Entry:
    Conditions have binary values (Yes/No, True/False)
    Simplest form, easy to verify completeness

  Extended Entry:
    Conditions have ranges or enumerated values
    More expressive, common in practice

  Mixed Entry:
    Combination of limited and extended entries

  Hit Policies (DMN standard):
    U  Unique      Exactly one rule matches (error if overlap)
    A  Any         Multiple rules may match, all give same result
    F  First       First matching rule wins (order matters)
    P  Priority    Highest priority matching rule wins
    C  Collect     Collect results from all matching rules
    R  Rule Order  All matching rules, in table order

Completeness Analysis:
  Total combinations = product of all condition values
  Example: 3 conditions with 2, 3, 4 values = 2×3×4 = 24 rows needed
  Check: Are all 24 combinations covered?
  Missing combinations → undefined behavior (bug!)

DMN (Decision Model and Notation):
  OMG standard for decision modeling
  Visual notation for decision requirements
  Standardized decision table format
  FEEL expression language for conditions
  Tools: Camunda, Red Hat Decision Manager

Implementation Approaches:
  1. Spreadsheet-based (Excel/Google Sheets → parse at runtime)
  2. Database-driven (rules in SQL tables)
  3. JSON/YAML configuration files
  4. DMN files (XML standard)
  5. Code-generated from decision tables

Example JSON Decision Table:
  {
    "rules": [
      {"conditions": {"age": "<25", "score": ">700"}, "action": "approve"},
      {"conditions": {"age": "<25", "score": "<=700"}, "action": "review"},
      {"conditions": {"age": ">=25", "score": ">600"}, "action": "approve"},
      {"conditions": {"age": ">=25", "score": "<=600"}, "action": "decline"}
    ]
  }
EOF
}

cmd_dsl() {
    cat << 'EOF'
=== Domain-Specific Languages for Rules ===

A rule DSL makes business rules readable by non-programmers.

Natural Language Style:
  WHEN
    customer.age >= 18
    AND customer.credit_score > 650
    AND order.total < customer.credit_limit
  THEN
    APPROVE order
    SET customer.last_order_date = TODAY

JSON-Based Rules:
  {
    "conditions": {
      "all": [
        {"fact": "age", "operator": "greaterThanInclusive", "value": 18},
        {"fact": "credit_score", "operator": "greaterThan", "value": 650}
      ]
    },
    "event": {
      "type": "approve",
      "params": {"message": "Order approved"}
    }
  }

YAML-Based Rules:
  rules:
    - name: premium_discount
      when:
        all:
          - field: customer.tier
            equals: premium
          - field: order.total
            greaterThan: 100
      then:
        - set: order.discount
          value: 0.20

Rego (Open Policy Agent):
  package authz

  default allow = false

  allow {
    input.user.role == "admin"
  }

  allow {
    input.user.role == "editor"
    input.action == "read"
  }

  allow {
    input.user.role == "editor"
    input.action == "write"
    input.resource.owner == input.user.id
  }

Drools DRL:
  rule "High Value Customer Discount"
    when
      $customer : Customer(totalPurchases > 10000)
      $order : Order(customer == $customer, total > 500)
    then
      $order.setDiscount(0.15);
      update($order);
  end

Expression Languages:
  FEEL (DMN):     if age >= 18 then "adult" else "minor"
  SpEL (Spring):  #customer.age >= 18 and #order.total > 100
  JEXL:           customer.age >= 18 && order.total > 100
  CEL (Google):   customer.age >= 18 && order.total > 100

DSL Design Principles:
  1. Readable by domain experts (not just developers)
  2. Declarative (what, not how)
  3. Composable (combine simple rules into complex)
  4. Testable (each rule independently verifiable)
  5. Versionable (track changes over time)
  6. Validated at parse time (catch errors early)
EOF
}

cmd_tools() {
    cat << 'EOF'
=== Rule Engine Tools ===

Enterprise / JVM:
  Drools (Red Hat):
    Language: Java, DRL, DMN
    Algorithm: Rete / Phreak
    Features: Forward/backward chaining, DMN, CEP
    Use: Complex enterprise rules, financial services
    License: Apache 2.0

  Easy Rules:
    Language: Java
    Lightweight: Annotation or YAML-based rules
    Good for: Simple rule evaluation, microservices
    License: MIT

JavaScript / Node.js:
  json-rules-engine:
    JSON-based rule definition
    Supports rule priorities, conditions, events
    npm: json-rules-engine
    Good for: REST APIs, form validation, pricing

  Nools:
    Rete-based engine for Node.js
    Drools-like DSL
    Forward chaining
    Good for: Complex matching in Node

  RulesJS:
    Lightweight, JSON rules
    Good for: Client-side rule evaluation

Python:
  Durable Rules:
    Rete-based, supports Python/Node/Ruby
    Stateful sessions, forward chaining
    pip: durable-rules

  Business Rules Engine:
    Simple condition-action rules
    pip: business-rules
    Good for: Basic business logic

  PyKnow (experta):
    CLIPS-inspired expert system
    Forward chaining with Rete
    pip: experta

Policy Engines:
  Open Policy Agent (OPA):
    Language: Rego
    Use: Authorization, Kubernetes admission, API policies
    Decoupled from application (sidecar or library)
    CNCF graduated project

  Casbin:
    Multi-language (Go, Java, Node, Python, Rust)
    Models: ACL, RBAC, ABAC, RESTful
    Policy storage: file, database, API

  Cedar (AWS):
    Language: Cedar policy language
    Use: Fine-grained authorization
    Formally verified
    Used by: Amazon Verified Permissions

  Cerbos:
    Language: YAML policies
    Deployment: Container/sidecar
    Use: Application-level authorization

Spreadsheet-Based:
  GoRules:  Visual rule builder, DMN tables, JSON rules
  Corticon: No-code rule modeling, enterprise-grade
  BRMS:     Business Rule Management Systems (IBM, Oracle)
EOF
}

cmd_scoring() {
    cat << 'EOF'
=== Scoring & Ranking Engines ===

Weighted Scoring Model:
  Score = Σ (weight_i × value_i) for each criterion

  Example — Lead Scoring:
    Criterion          Weight   Value Range
    Company size       0.25     1-10
    Budget             0.30     1-10
    Decision authority 0.20     1-10
    Timeline           0.15     1-10
    Engagement         0.10     1-10

    Score = 0.25×8 + 0.30×7 + 0.20×9 + 0.15×6 + 0.10×5
          = 2.0 + 2.1 + 1.8 + 0.9 + 0.5 = 7.3 / 10

Point-Based Systems:
  Rule                              Points
  ─────────────────────────────────────────
  Visited pricing page              +10
  Downloaded whitepaper             +15
  Attended webinar                  +20
  Opened email                      +3
  Clicked email link                +5
  Unsubscribed from list            -25
  No activity in 30 days            -10
  Job title contains "VP/Director"  +15
  Company revenue > $10M            +20

  Threshold Actions:
    0-30    Cold lead → nurture campaign
    31-60   Warm lead → targeted content
    61-80   Hot lead → SDR outreach
    81+     Sales-ready → assign to AE

Risk Scoring:
  Credit Risk:
    Payment history    35%
    Credit utilization 30%
    Credit age         15%
    Credit mix         10%
    New inquiries      10%

  Fraud Risk:
    IP geolocation mismatch          +30
    First-time buyer                 +10
    Order value > 3× average         +20
    Multiple failed payment attempts +25
    Shipping ≠ billing address       +15
    High-risk product category       +10
    Velocity: > 3 orders in 1 hour   +35

Multi-Criteria Decision Analysis (MCDA):
  Methods:
    TOPSIS   Closest to ideal solution
    AHP      Analytic Hierarchy Process (pairwise comparison)
    ELECTRE  Outranking methods
    PROMETHEE Preference ranking

  AHP Process:
    1. Define criteria hierarchy
    2. Pairwise comparison of criteria (1-9 scale)
    3. Calculate priority weights
    4. Check consistency ratio (< 0.1)
    5. Score alternatives against criteria
    6. Calculate weighted scores
    7. Rank alternatives

Normalization Methods:
  Min-Max:    (value - min) / (max - min) → [0, 1]
  Z-Score:    (value - mean) / std_dev → [-∞, +∞]
  Percentile: rank / count → [0, 1]
  Log scale:  log(value) / log(max) → [0, 1]
EOF
}

cmd_testing() {
    cat << 'EOF'
=== Testing Rule Engines ===

Rule Testing Challenges:
  - Combinatorial explosion of condition combinations
  - Rule interactions and cascading effects
  - Order-dependent behavior
  - Temporal rules (time-based conditions)
  - Performance under load with many rules

Testing Approaches:

  1. Unit Testing (per rule):
     - Test each rule in isolation
     - Provide minimal facts to trigger the rule
     - Verify expected action fires
     - Verify rule does NOT fire for non-matching facts

  2. Integration Testing (rule interactions):
     - Test groups of related rules together
     - Verify rule chaining produces correct results
     - Check for unintended rule interactions
     - Test conflict resolution behavior

  3. Boundary Testing:
     - Test at condition boundaries (age = 17, 18, 19)
     - Test null/missing values
     - Test extreme values
     - Test type mismatches

  4. Coverage Analysis:
     - Which rules were triggered during tests?
     - Which condition branches were exercised?
     - Are there unreachable rules (dead rules)?
     - Decision table completeness check

Conflict Detection:
  Overlapping Rules:
    Rule A: IF age > 18 AND income > 50k THEN approve
    Rule B: IF age > 25 AND income > 30k THEN approve
    Overlap: age=30, income=60k → both match

  Contradicting Rules:
    Rule A: IF score > 700 THEN approve
    Rule B: IF debt_ratio > 0.5 THEN decline
    Contradiction: score=750, debt_ratio=0.6 → approve or decline?

  Subsumption:
    Rule A: IF color = "red" THEN stop
    Rule B: IF color = "red" AND size = "large" THEN stop
    Rule B is subsumed by Rule A (never adds value)

  Shadow Rules:
    Higher-priority rule always fires before a lower one
    Lower rule effectively never executes

Testing Patterns:
  Given-When-Then:
    Given: customer.age=25, customer.tier="gold"
    When:  evaluate discount rules
    Then:  discount should be 15%

  Truth Table Testing:
    Enumerate all condition combinations
    Verify each produces expected outcome
    Identify gaps in coverage

  Regression Suite:
    Capture real decisions as test cases
    Re-run after rule changes
    Alert on any behavior changes

  Performance Testing:
    Load test with realistic fact volumes
    Measure: rules/second, latency p99
    Test rule set scaling (100 vs 10,000 rules)
    Memory profiling (Rete network can be large)
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== Rule Engine Implementation Checklist ===

Design:
  [ ] Rules clearly separate from application code
  [ ] Rule language chosen (DSL, JSON, decision tables)
  [ ] Conflict resolution strategy defined
  [ ] Rule versioning and change management planned
  [ ] Performance requirements defined (throughput, latency)
  [ ] Rule authoring workflow designed (who can create/edit)

Rule Authoring:
  [ ] Rules reviewed by domain expert
  [ ] Decision table completeness verified
  [ ] No contradicting rules (or contradiction resolved)
  [ ] No shadowed/unreachable rules
  [ ] Default/fallback case handled
  [ ] Rule priorities/salience assigned where needed

Testing:
  [ ] Unit tests for each rule
  [ ] Integration tests for rule interactions
  [ ] Boundary value tests
  [ ] Negative tests (rule should NOT fire)
  [ ] Performance benchmarks established
  [ ] Regression test suite from production decisions

Deployment:
  [ ] Rules can be updated without code deployment
  [ ] Rule versioning with rollback capability
  [ ] A/B testing capability for rule changes
  [ ] Gradual rollout support (canary deployment)
  [ ] Monitoring for rule engine health

Observability:
  [ ] Logging: which rules fired and why
  [ ] Metrics: rule execution count, latency, error rate
  [ ] Audit trail: who changed which rules when
  [ ] Alerting: rule errors, unexpected patterns
  [ ] Dashboard: rule coverage, hit rates

Governance:
  [ ] Rule ownership assigned (who maintains each rule set)
  [ ] Change approval process defined
  [ ] Documentation for each rule's business purpose
  [ ] Regular review schedule (quarterly rule audit)
  [ ] Retirement process for obsolete rules
  [ ] Compliance mapping (which rules implement which regulations)
EOF
}

show_help() {
    cat << EOF
engine v$VERSION — Rule Engine & Decision Logic Reference

Usage: script.sh <command>

Commands:
  intro      Rule engine overview — types, benefits, when to use
  patterns   Forward/backward chaining, Rete algorithm
  tables     Decision tables — structure, hit policies, DMN
  dsl        Domain-specific languages for rule definition
  tools      Rule engine tools — Drools, OPA, json-rules-engine
  scoring    Scoring engines — weighted rules, MCDA, risk scoring
  testing    Testing rules — coverage, conflicts, regression
  checklist  Rule engine implementation checklist
  help       Show this help
  version    Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)     cmd_intro ;;
    patterns)  cmd_patterns ;;
    tables)    cmd_tables ;;
    dsl)       cmd_dsl ;;
    tools)     cmd_tools ;;
    scoring)   cmd_scoring ;;
    testing)   cmd_testing ;;
    checklist) cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "engine v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
