#!/usr/bin/env bash
# annotate — Annotation Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Annotation ===

Annotation adds metadata, documentation, or labels to code, data,
or content without changing its core functionality.

Types of Annotation:
  Code Annotations    Type hints, decorators, JSDoc, Javadoc
  Data Annotations    ML labels, metadata tags, quality markers
  Text Annotations    Comments, footnotes, marginalia
  Visual Annotations  Bounding boxes, highlights, redlines

Purpose:
  Documentation    Explain intent, usage, contracts
  Type Safety      Catch errors before runtime
  Tooling          Enable IDE autocomplete, linting, generation
  Machine Learning Train models with labeled examples
  Code Archaeology Trace who changed what and when (git blame)

Annotation Density Spectrum:
  Under-annotated: "What does this function do? No idea."
  Well-annotated:  Types, key behaviors, edge cases documented
  Over-annotated:  Every line has a comment restating the obvious
                   x = x + 1  // increment x by 1   ← DON'T

Golden Rule:
  Annotate the WHY, not the WHAT.
  Code shows what happens. Annotations explain why.
EOF
}

cmd_types() {
    cat << 'EOF'
=== Type Annotations ===

--- Python Type Hints (PEP 484+) ---
  def greet(name: str, times: int = 1) -> str:
      return name * times

  # Collections
  from typing import List, Dict, Optional, Tuple, Union
  def process(items: list[str]) -> dict[str, int]: ...  # Python 3.9+
  def find(id: int) -> Optional[User]: ...               # may return None
  def parse(data: str | bytes) -> Result: ...             # Python 3.10+ union

  # Type aliases
  UserId = int
  UserMap = dict[UserId, User]

  # TypeVar (generics)
  from typing import TypeVar, Generic
  T = TypeVar('T')
  def first(items: list[T]) -> T: ...

  # Protocol (structural typing)
  from typing import Protocol
  class Drawable(Protocol):
      def draw(self) -> None: ...

  Tools: mypy, pyright, pytype (static type checkers)

--- TypeScript ---
  function greet(name: string, times: number = 1): string {
    return name.repeat(times);
  }

  interface User {
    id: number;
    name: string;
    email?: string;          // optional
    readonly created: Date;  // immutable
  }

  type Result<T> = { ok: true; data: T } | { ok: false; error: string };

  // Utility types
  Partial<User>       // all fields optional
  Required<User>      // all fields required
  Pick<User, 'id'>    // subset of fields
  Omit<User, 'email'> // exclude fields
  Record<string, number>  // key-value mapping

--- Java Annotations ---
  @Override              Compiler checks method overrides parent
  @Deprecated            Mark as deprecated
  @SuppressWarnings      Suppress compiler warnings
  @FunctionalInterface   Ensure interface has single abstract method
  @Nullable/@NonNull     Null safety (JSR 305, JetBrains, Android)

  // Custom annotations
  @Retention(RetentionPolicy.RUNTIME)
  @Target(ElementType.METHOD)
  public @interface Cached {
      int ttl() default 300;
  }

  // Used by frameworks
  @Autowired        Spring dependency injection
  @GetMapping       Spring web endpoint
  @Entity           JPA/Hibernate ORM entity
  @Test             JUnit test method
EOF
}

cmd_docstrings() {
    cat << 'EOF'
=== Documentation Annotations ===

--- Python Docstrings ---

  Google style:
    def calculate_tax(income: float, rate: float = 0.25) -> float:
        """Calculate tax owed on income.

        Args:
            income: Annual gross income in USD.
            rate: Tax rate as decimal (default 0.25).

        Returns:
            Tax amount in USD.

        Raises:
            ValueError: If income is negative.

        Examples:
            >>> calculate_tax(100000)
            25000.0
        """

  NumPy style:
    def calculate_tax(income, rate=0.25):
        """
        Calculate tax owed on income.

        Parameters
        ----------
        income : float
            Annual gross income in USD.
        rate : float, optional
            Tax rate as decimal (default 0.25).

        Returns
        -------
        float
            Tax amount in USD.
        """

--- JSDoc ---
  /**
   * Calculate tax owed on income.
   * @param {number} income - Annual gross income in USD
   * @param {number} [rate=0.25] - Tax rate as decimal
   * @returns {number} Tax amount in USD
   * @throws {RangeError} If income is negative
   * @example
   * calculateTax(100000); // 25000
   */
  function calculateTax(income, rate = 0.25) { ... }

  JSDoc types: {string}, {number}, {boolean}, {Object}, {Array<string>}
  Optional: {number} [rate] or {number} [rate=0.25]
  Union: {string|number}
  Nullable: {?string}

--- Javadoc ---
  /**
   * Calculate tax owed on income.
   *
   * @param income annual gross income in USD
   * @param rate   tax rate as decimal
   * @return tax amount in USD
   * @throws IllegalArgumentException if income is negative
   * @since 2.0
   * @see TaxBracket
   */
  public double calculateTax(double income, double rate) { ... }

--- XML Documentation (C#) ---
  /// <summary>
  /// Calculate tax owed on income.
  /// </summary>
  /// <param name="income">Annual gross income in USD.</param>
  /// <param name="rate">Tax rate as decimal.</param>
  /// <returns>Tax amount in USD.</returns>
  /// <exception cref="ArgumentException">If income is negative.</exception>
  public double CalculateTax(double income, double rate = 0.25) { ... }
EOF
}

cmd_decorators() {
    cat << 'EOF'
=== Decorator / Annotation Patterns ===

--- Python Decorators ---
  Decorators wrap functions to modify behavior.

  # Simple decorator
  def log_call(func):
      def wrapper(*args, **kwargs):
          print(f"Calling {func.__name__}")
          result = func(*args, **kwargs)
          print(f"Returned {result}")
          return result
      return wrapper

  @log_call
  def add(a, b):
      return a + b

  # Decorator with arguments
  def retry(times=3):
      def decorator(func):
          @functools.wraps(func)
          def wrapper(*args, **kwargs):
              for attempt in range(times):
                  try:
                      return func(*args, **kwargs)
                  except Exception:
                      if attempt == times - 1:
                          raise
          return wrapper
      return decorator

  @retry(times=5)
  def fetch_data(url): ...

  # Class decorator
  @dataclass
  class Point:
      x: float
      y: float

--- TypeScript Decorators ---
  // Method decorator
  function Log(target: any, key: string, descriptor: PropertyDescriptor) {
    const original = descriptor.value;
    descriptor.value = function(...args: any[]) {
      console.log(`Called ${key} with`, args);
      return original.apply(this, args);
    };
  }

  class Service {
    @Log
    fetchData(id: number) { ... }
  }

  // Common framework decorators
  @Component, @Injectable    (Angular)
  @Entity, @Column           (TypeORM)
  @Get, @Post, @Controller   (NestJS)

--- Java Annotations at Runtime ---
  // Create custom annotation
  @Retention(RetentionPolicy.RUNTIME)
  @Target(ElementType.METHOD)
  public @interface RateLimit {
      int maxCalls() default 100;
      int periodSeconds() default 60;
  }

  // Use it
  @RateLimit(maxCalls = 10, periodSeconds = 30)
  public Response handleRequest() { ... }

  // Read at runtime via reflection
  Method method = cls.getMethod("handleRequest");
  RateLimit limit = method.getAnnotation(RateLimit.class);
  int max = limit.maxCalls(); // 10

--- Common Patterns ---
  @cache / @lru_cache     Memoization
  @retry                  Automatic retry on failure
  @deprecated             Mark as deprecated
  @validate               Input validation
  @authorize              Permission checking
  @transactional          Database transaction wrapping
  @timed / @profile       Performance measurement
  @route / @endpoint      HTTP route registration
EOF
}

cmd_labeling() {
    cat << 'EOF'
=== Data Labeling for Machine Learning ===

--- Annotation Types ---

  Classification:     Assign category to entire sample
    Image: "cat", "dog", "car"
    Text: "positive", "negative", "neutral"

  Object Detection:   Bounding boxes around objects in images
    Format: (class, x_min, y_min, x_max, y_max)
    Metrics: IoU (Intersection over Union) for quality

  Segmentation:       Pixel-level labeling
    Semantic: every pixel gets a class label
    Instance: separate instances of same class distinguished
    Panoptic: semantic + instance combined

  Named Entity Recognition (NER):
    Text spans labeled with entity type
    "Apple released iPhone in Cupertino"
    → [Apple/ORG] released [iPhone/PRODUCT] in [Cupertino/LOCATION]

  Sequence Labeling:  Labels per element in sequence
    POS tagging: "The/DET cat/NOUN sat/VERB"
    IOB format: "B-PER I-PER O B-ORG" (Begin, Inside, Outside)

--- Annotation Formats ---
  COCO JSON:       Object detection standard
  Pascal VOC XML:  Bounding box format
  YOLO TXT:        class center_x center_y width height (normalized)
  CoNLL:           Token-per-line with tab-separated labels
  spaCy JSON:      NER with character offsets

--- Quality Control ---
  Inter-annotator agreement (IAA):
    Cohen's Kappa: agreement adjusted for chance
    κ > 0.8 = excellent, κ > 0.6 = good, κ < 0.4 = poor

  Quality strategies:
    Gold standard: expert-labeled subset to measure accuracy
    Double annotation: two people label same data, resolve conflicts
    Spot checks: random review of annotator work
    Adjudication: senior annotator resolves disagreements

--- Labeling Tools ---
  Label Studio:     Open-source, multi-type annotation platform
  Prodigy:          Active learning annotation (by spaCy team)
  CVAT:             Computer vision annotation tool
  Labelbox:         Enterprise labeling platform
  Amazon SageMaker Ground Truth: AWS managed labeling service
  Scale AI:         Professional labeling workforce

--- Active Learning ---
  Instead of labeling randomly, prioritize uncertain samples:
  1. Train model on labeled data
  2. Predict on unlabeled data
  3. Select samples model is most uncertain about
  4. Label those samples (highest information gain)
  5. Retrain and repeat
  Reduces labeling effort by 50-80%
EOF
}

cmd_git() {
    cat << 'EOF'
=== Git Annotation & Code Archaeology ===

--- git blame ---
  Show who last modified each line of a file:

  git blame src/main.py
  ^a1b2c3d (Alice  2024-01-15  10) def process():
  d4e5f6a7 (Bob    2024-03-20  11)     data = load()
  ^a1b2c3d (Alice  2024-01-15  12)     return transform(data)

  Useful flags:
    git blame -L 10,20 file.py        Lines 10-20 only
    git blame -L '/def process/,+10'  From pattern, 10 lines
    git blame -w                       Ignore whitespace changes
    git blame -M                       Detect moved lines within file
    git blame -C                       Detect moved lines across files
    git blame --since="2024-01-01"     Only changes since date

--- git log archaeology ---
  git log -p -- path/to/file          Full history with diffs
  git log --follow -- old/name.py     Follow renames
  git log -S "function_name"          Find when string was added/removed
  git log -G "regex_pattern"          Find commits matching regex in diff
  git log --all --source -- file      Which branch introduced this file

--- git annotate ---
  Same as git blame (alias)
  git annotate file.py

--- Finding who deleted something ---
  git log -p -S "deleted_function" -- file.py
  Shows the commit where "deleted_function" appeared/disappeared

--- Finding when a bug was introduced ---
  git bisect start
  git bisect bad                    # current commit is broken
  git bisect good v1.0              # this version was working
  # Git checks out middle commit
  # Test it, then:
  git bisect good   # or  git bisect bad
  # Repeat until git finds the exact commit

  Automated:
  git bisect start HEAD v1.0
  git bisect run ./test_script.sh   # script exits 0=good, 1=bad

--- Annotating commits ---
  git notes add -m "This fix also resolves #456"
  git notes show HEAD
  git log --show-notes
  Notes travel separately from commits (not shared by default)
  Push notes: git push origin refs/notes/commits
EOF
}

cmd_standards() {
    cat << 'EOF'
=== Annotation Standards ===

--- OpenAPI / Swagger ---
  paths:
    /users/{id}:
      get:
        summary: Get user by ID
        description: |
          Returns a single user. Requires authentication.
          Returns 404 if user not found.
        parameters:
          - name: id
            in: path
            required: true
            schema:
              type: integer
            description: Unique user identifier
        responses:
          '200':
            description: User found
            content:
              application/json:
                schema:
                  $ref: '#/components/schemas/User'
          '404':
            description: User not found

--- JSON Schema ---
  {
    "type": "object",
    "title": "User",
    "description": "A registered user account",
    "properties": {
      "id": {
        "type": "integer",
        "description": "Unique identifier",
        "minimum": 1
      },
      "email": {
        "type": "string",
        "format": "email",
        "description": "Primary email address"
      }
    },
    "required": ["id", "email"],
    "additionalProperties": false
  }

--- GraphQL Descriptions ---
  """A registered user account."""
  type User {
    "Unique identifier"
    id: ID!

    "Primary email address"
    email: String!

    "Account creation timestamp"
    createdAt: DateTime!

    """
    Full name of the user.
    May be null if not provided during registration.
    """
    name: String
  }

--- YAML/TOML Comments ---
  # YAML uses hash comments
  database:
    host: localhost  # Primary database server
    port: 5432       # Default PostgreSQL port
    # Connection pool settings
    pool_size: 20    # Maximum concurrent connections

  # TOML
  [database]
  host = "localhost"  # Primary database server
  port = 5432         # Default PostgreSQL port
EOF
}

cmd_best() {
    cat << 'EOF'
=== Annotation Best Practices ===

--- What to Annotate ---
  ✓ Public API contracts (parameters, return types, exceptions)
  ✓ Non-obvious behavior ("returns empty list, not None")
  ✓ Business logic reasoning ("IRS requires 90-day holdback period")
  ✓ Performance implications ("O(n²) — don't call with >10K items")
  ✓ Security decisions ("sanitized to prevent XSS")
  ✓ TODOs with context ("TODO(alice): remove after Q2 migration")
  ✓ Workarounds ("works around Chrome bug #12345")
  ✓ Complex algorithms (link to paper or explanation)

--- What NOT to Annotate ---
  ✗ Obvious code: i += 1  // increment i
  ✗ Getter/setter boilerplate: // gets the name
  ✗ Redundant type info: String name; // this is a string
  ✗ Changelog in comments (use git log)
  ✗ Commented-out code (delete it, git remembers)
  ✗ Author names in every file (use git blame)

--- Type Annotation Guidelines ---
  1. Annotate function signatures (params + return)
  2. Skip obvious local variable types (let x = 5)
  3. Annotate empty collections (items: list[str] = [])
  4. Use Optional/null for nullable values explicitly
  5. Prefer specific types over Any/object/unknown
  6. Use generics for reusable code
  7. Run type checker in CI (mypy, tsc --noEmit)

--- Documentation Guidelines ---
  1. First line = one sentence summary (imperative mood)
  2. Describe behavior, not implementation
  3. Document edge cases and error conditions
  4. Include examples for non-obvious usage
  5. Keep docs close to code (docstrings > external docs)
  6. Update docs when code changes (stale docs = worse than none)

--- Maintenance ---
  Stale annotations are worse than no annotations.
  They mislead readers and build distrust.

  Prevention:
    - Type annotations checked by compiler/linter (self-maintaining)
    - Doc tests (Python doctest, Rust doc tests) verify examples
    - Linter rules for TODO format: TODO(owner, date): description
    - Periodic "annotation audit" — review docs for accuracy
    - Code review should check: "Is this comment still true?"
EOF
}

show_help() {
    cat << EOF
annotate v$VERSION — Annotation Reference

Usage: script.sh <command>

Commands:
  intro        Annotation concepts and types overview
  types        Type annotations: Python, TypeScript, Java
  docstrings   Documentation: JSDoc, docstrings, Javadoc
  decorators   Decorator and annotation patterns
  labeling     ML data labeling: types, tools, quality control
  git          Git blame, annotate, and code archaeology
  standards    OpenAPI, JSON Schema, GraphQL annotations
  best         Annotation best practices and anti-patterns
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    types)      cmd_types ;;
    docstrings) cmd_docstrings ;;
    decorators) cmd_decorators ;;
    labeling)   cmd_labeling ;;
    git)        cmd_git ;;
    standards)  cmd_standards ;;
    best)       cmd_best ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "annotate v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
