#!/usr/bin/env bash
# enum — Enumeration Pattern Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Enumerations ===

An enum is a type with a fixed set of named values.
It replaces magic strings and numbers with meaningful names.

Purpose:
  - Type safety: compiler catches invalid values
  - Self-documenting: names convey meaning
  - Exhaustiveness: compiler warns if you miss a case
  - Refactoring: rename once, changes everywhere
  - IDE support: autocomplete, go-to-definition

Enum Categories:
  Simple enum:     fixed set of names (Color: Red, Green, Blue)
  Valued enum:     each variant has an associated value (HTTP 200, 404)
  Flag enum:       combinable via bitwise OR (Read|Write|Execute)
  Algebraic enum:  variants carry different data (Rust, Haskell)

Design Principles:
  1. Use enums instead of strings for finite sets
     Bad:  status = "active"    → typo "acitve" compiles fine
     Good: status = Status.ACTIVE → compiler catches errors
  
  2. Use enums instead of booleans for clarity
     Bad:  set_mode(true, false)  → what do these mean?
     Good: set_mode(Mode.READ, Access.PUBLIC)
  
  3. Always handle the default/unknown case
     What happens when you deserialize a value you don't recognize?
     Future-proof: have an UNKNOWN or UNSPECIFIED variant.
  
  4. Consider exhaustiveness checking
     Switch/match should cover ALL variants.
     Compiler warning on missing case = catch bugs early.
  
  5. Choose string or integer representation for serialization
     Strings: human-readable, self-documenting, larger
     Integers: compact, faster, but meaningless without schema

When NOT to Use Enums:
  - Open-ended sets (user roles that admins can create)
  - Frequently changing sets (deploy to add a value)
  - Hierarchical data (use tree structures)
  - Continuous ranges (use numbers with validation)
EOF
}

cmd_languages() {
    cat << 'EOF'
=== Enums Across Languages ===

Rust (most powerful enum system):
  enum Direction { North, South, East, West }
  
  // With associated data (algebraic):
  enum Shape {
      Circle(f64),                    // radius
      Rectangle(f64, f64),            // width, height
      Triangle { a: f64, b: f64, c: f64 },
  }
  
  // Exhaustive match required:
  match shape {
      Shape::Circle(r) => PI * r * r,
      Shape::Rectangle(w, h) => w * h,
      Shape::Triangle { a, b, c } => /* heron's formula */,
  }

TypeScript:
  enum Direction { North, South, East, West }  // numeric (0,1,2,3)
  enum Color { Red = "RED", Blue = "BLUE" }     // string enum
  
  // Preferred: const enum (erased at compile time):
  const enum Status { Active = "ACTIVE", Inactive = "INACTIVE" }
  
  // Or union types (most idiomatic TS):
  type Direction = "north" | "south" | "east" | "west";
  type Result<T> = { ok: true; value: T } | { ok: false; error: Error };

Python:
  from enum import Enum, Flag, auto
  
  class Color(Enum):
      RED = 1
      GREEN = 2
      BLUE = 3
  
  class Permission(Flag):
      READ = auto()     # 1
      WRITE = auto()    # 2
      EXECUTE = auto()  # 4
  
  # StrEnum (Python 3.11+):
  class Status(StrEnum):
      ACTIVE = auto()   # "active"
      INACTIVE = auto() # "inactive"

Java:
  public enum Planet {
      MERCURY(3.303e+23, 2.4397e6),
      VENUS(4.869e+24, 6.0518e6);
      
      private final double mass, radius;
      Planet(double mass, double radius) { ... }
      public double surfaceGravity() { ... }
  }
  // Java enums are full classes — methods, fields, interfaces

C# (.NET):
  enum Color { Red, Green, Blue }
  
  [Flags]
  enum Permission {
      None = 0, Read = 1, Write = 2, Execute = 4,
      All = Read | Write | Execute
  }

Go (no native enum — use iota):
  type Direction int
  const (
      North Direction = iota  // 0
      South                   // 1
      East                    // 2
      West                    // 3
  )
  func (d Direction) String() string { ... }

C / C++:
  enum Color { RED, GREEN, BLUE };           // C enum (just ints)
  enum class Color { Red, Green, Blue };     // C++11 scoped enum (type-safe)
  enum class Color : uint8_t { Red, Green }; // with underlying type
EOF
}

cmd_bitflags() {
    cat << 'EOF'
=== Bit Flags & Bitmasks ===

Assign each enum value a power of 2, then combine with bitwise OR.
A single integer encodes multiple simultaneous states.

Power-of-2 Assignment:
  READ    = 0b0001 = 1
  WRITE   = 0b0010 = 2
  EXECUTE = 0b0100 = 4
  ADMIN   = 0b1000 = 8

  Combined: READ | WRITE = 0b0011 = 3
  All:      READ | WRITE | EXECUTE | ADMIN = 0b1111 = 15

Bit Operations:
  Set flag:     permissions |= WRITE
  Clear flag:   permissions &= ~WRITE
  Toggle flag:  permissions ^= WRITE
  Check flag:   (permissions & WRITE) != 0
  Check all:    (permissions & (READ | WRITE)) == (READ | WRITE)
  Check any:    (permissions & (READ | WRITE)) != 0

Unix File Permissions (classic example):
  Owner  Group  Other
  rwx    rwx    rwx
  421    421    421
  
  chmod 755: owner=rwx(7), group=r-x(5), other=r-x(5)
  chmod 644: owner=rw-(6), group=r--(4), other=r--(4)

Real-World Flag Enums:

  CSS font-style (conceptual):
    BOLD      = 1
    ITALIC    = 2
    UNDERLINE = 4
    STRIKE    = 8
    Style: BOLD | ITALIC = 3

  Feature flags:
    DARK_MODE     = 1
    NEW_DASHBOARD = 2
    BETA_API      = 4
    features = DARK_MODE | BETA_API  // = 5

  Network protocol flags:
    TCP flags: FIN=1, SYN=2, RST=4, PSH=8, ACK=16, URG=32

Design Rules:
  ✓ Start from 1 (not 0) — 0 means "no flags set"
  ✓ Use powers of 2 only for individual flags
  ✓ Define NONE = 0 explicitly
  ✓ Define convenience combinations (ALL, READ_WRITE)
  ✗ Don't exceed bit width (32 flags for uint32, 64 for uint64)
  ✗ Don't mix flag enums with regular enums

Storage:
  8 flags:  uint8 (1 byte)
  16 flags: uint16 (2 bytes)
  32 flags: uint32 (4 bytes)
  64 flags: uint64 (8 bytes)
  
  Database: store as integer column
  JSON: serialize as integer or as array of strings
  Protobuf: repeated enum field or int with bit packing
EOF
}

cmd_statemachine() {
    cat << 'EOF'
=== State Machines with Enums ===

Enums naturally model finite state machines — fixed set of states
with defined transitions between them.

Order Status Example:
  States:  Created → Paid → Shipped → Delivered
                         ↘ Cancelled
                    ↗ Refunded

  enum OrderStatus {
      Created,     // initial state
      Paid,        // payment received
      Shipped,     // handed to carrier
      Delivered,   // confirmed delivery
      Cancelled,   // order cancelled
      Refunded,    // money returned
  }

Transition Table:
  From         To            Guard/Condition
  ────         ──            ───────────────
  Created      Paid          payment_confirmed
  Created      Cancelled     user_cancels
  Paid         Shipped       carrier_picked_up
  Paid         Cancelled     user_cancels (before ship)
  Paid         Refunded      refund_approved
  Shipped      Delivered     delivery_confirmed
  Shipped      Refunded      return_received

Implementation Patterns:

  Pattern 1: Match on (current_state, event):
    fn transition(state: State, event: Event) -> State {
        match (state, event) {
            (Created, PaymentReceived) => Paid,
            (Created, UserCancelled) => Cancelled,
            (Paid, CarrierPickup) => Shipped,
            (Paid, UserCancelled) => Cancelled,
            _ => state,  // invalid transition: no change
        }
    }

  Pattern 2: State enum with allowed transitions:
    impl OrderStatus {
        fn can_transition_to(&self, next: &OrderStatus) -> bool {
            matches!((self, next),
                (Created, Paid) | (Created, Cancelled) |
                (Paid, Shipped) | (Paid, Cancelled) | (Paid, Refunded) |
                (Shipped, Delivered) | (Shipped, Refunded)
            )
        }
    }

  Pattern 3: Typestate pattern (compile-time enforcement):
    struct Order<S: State> { data: OrderData, _state: PhantomData<S> }
    struct Created; struct Paid; struct Shipped;
    
    impl Order<Created> {
        fn pay(self) -> Order<Paid> { ... }  // only Created can pay
    }
    impl Order<Paid> {
        fn ship(self) -> Order<Shipped> { ... }  // only Paid can ship
    }
    // Order<Created>.ship() → compile error!

Guard Conditions:
  Don't just check state — validate business rules:
    Can cancel? → only if not yet shipped
    Can refund? → only within 30 days of delivery
    Can ship? → only if inventory available
EOF
}

cmd_serialization() {
    cat << 'EOF'
=== Enum Serialization ===

How enums cross boundaries: APIs, databases, message queues.

String vs Integer:
  String:
    {"status": "ACTIVE"}
    ✓ Human-readable, self-documenting
    ✓ Safe to reorder enum values
    ✗ Larger payload (6 bytes vs 1 byte)
    ✗ Case sensitivity issues ("active" vs "ACTIVE")
    Best for: JSON APIs, config files, logs
  
  Integer:
    {"status": 1}
    ✓ Compact, fast comparison
    ✗ Meaningless without schema ("what is 1?")
    ✗ Dangerous to reorder (value changes meaning!)
    Best for: binary protocols, databases, performance-critical

Unknown Value Handling (critical!):
  What happens when you receive a value you don't know?
  This WILL happen when systems evolve at different speeds.
  
  Strategy 1: Reject (strict)
    Throw error on unknown value
    Pro: catches bugs, prevents bad data
    Con: breaks backward compatibility
  
  Strategy 2: Default (lenient)
    Map unknown → UNKNOWN or UNSPECIFIED
    Pro: forward-compatible, resilient
    Con: may hide errors
  
  Strategy 3: Preserve (transparent)
    Store raw value, pass through unchanged
    Pro: no data loss, intermediaries don't break
    Con: harder to validate

Protobuf Enum Rules:
  First value MUST be 0 (= default for missing fields)
  Name it UNSPECIFIED: enum Status { STATUS_UNSPECIFIED = 0; }
  Unknown values preserved in proto3 (not discarded)
  
  // proto3
  enum Status {
      STATUS_UNSPECIFIED = 0;
      STATUS_ACTIVE = 1;
      STATUS_INACTIVE = 2;
  }

JSON Best Practices:
  Use UPPER_SNAKE_CASE strings (most common convention)
  Document all valid values in API schema (OpenAPI enum)
  Return 400 on invalid enum value in request
  Never return invalid enum value in response (bug!)

TypeScript API Pattern:
  // Define enum values as const:
  const STATUS = { ACTIVE: "ACTIVE", INACTIVE: "INACTIVE" } as const;
  type Status = (typeof STATUS)[keyof typeof STATUS];
  
  // Validation:
  function isStatus(v: string): v is Status {
      return Object.values(STATUS).includes(v as Status);
  }

Database Considerations:
  Store as: string (readable) or int (compact)
  If string: use CHECK constraint or lookup table
  If int: document the mapping, never reuse deleted values
  Migration: adding a value is easy, removing is hard
EOF
}

cmd_algebraic() {
    cat << 'EOF'
=== Algebraic Data Types (Sum Types) ===

Enums where each variant can carry different data.
Also called: tagged unions, discriminated unions, sum types.

Rust (native support):
  enum WebEvent {
      PageLoad,
      KeyPress(char),
      Click { x: i64, y: i64 },
      Paste(String),
  }
  
  fn handle(event: WebEvent) {
      match event {
          WebEvent::PageLoad => println!("page loaded"),
          WebEvent::KeyPress(c) => println!("pressed {c}"),
          WebEvent::Click { x, y } => println!("clicked at {x},{y}"),
          WebEvent::Paste(text) => println!("pasted: {text}"),
      }
  }
  
  // The classic: Option and Result
  enum Option<T> { Some(T), None }
  enum Result<T, E> { Ok(T), Err(E) }

TypeScript (discriminated unions):
  type Shape =
    | { kind: "circle"; radius: number }
    | { kind: "rectangle"; width: number; height: number }
    | { kind: "triangle"; base: number; height: number };
  
  function area(shape: Shape): number {
      switch (shape.kind) {
          case "circle": return Math.PI * shape.radius ** 2;
          case "rectangle": return shape.width * shape.height;
          case "triangle": return 0.5 * shape.base * shape.height;
      }
  }
  // TypeScript checks exhaustiveness in strict mode!

Haskell:
  data Shape = Circle Double
             | Rectangle Double Double
             | Triangle Double Double Double
  
  area :: Shape -> Double
  area (Circle r) = pi * r * r
  area (Rectangle w h) = w * h
  area (Triangle a b c) = -- heron's formula

Python (dataclasses + Union):
  @dataclass
  class Circle:
      radius: float
  @dataclass
  class Rectangle:
      width: float
      height: float
  
  Shape = Circle | Rectangle  # Python 3.10+ union syntax
  
  def area(shape: Shape) -> float:
      match shape:  # Python 3.10+ structural pattern matching
          case Circle(r): return math.pi * r ** 2
          case Rectangle(w, h): return w * h

Use Cases:
  Error handling:  Result<T, E> instead of exceptions
  AST nodes:       Expr = Literal | BinOp | UnaryOp | Call | ...
  Network messages: Message = Ping | Pong | Data(bytes) | Close(reason)
  UI events:       Event = Click(x,y) | KeyPress(key) | Resize(w,h)
  Parse results:   Token = Number(f64) | String(str) | Symbol(char)

Benefits over class hierarchies:
  ✓ Closed set: all variants known at compile time
  ✓ Exhaustiveness: compiler checks you handle every case
  ✓ No null: Option<T> makes absence explicit
  ✓ Data locality: enum variants stored inline (no heap pointer)
  ✓ Pattern matching: destructure and branch in one expression
EOF
}

cmd_antipatterns() {
    cat << 'EOF'
=== Enum Anti-Patterns ===

1. Stringly-Typed Code (most common!)
   // Bad: magic strings everywhere
   if (user.role === "amdin") { ... }  // typo! never caught
   setStatus("actve");                  // typo! silent bug
   
   // Good: enum
   if (user.role === Role.ADMIN) { ... }  // compile-time check
   setStatus(Status.ACTIVE);              // autocomplete helps

2. Boolean Blindness
   // Bad: what do these booleans mean?
   createUser("Alice", true, false, true);
   
   // Good: enums make intent clear
   createUser("Alice", Role.ADMIN, Status.ACTIVE, Notify.EMAIL);

3. Primitive Obsession
   // Bad: using int where enum belongs
   int status = 3;  // what is 3? who knows!
   if (status == 4) { ... }
   
   // Good: named values
   if (status == OrderStatus.SHIPPED) { ... }

4. God Enum (too many values)
   // Bad: 50+ values in one enum
   enum Event { USER_LOGIN, USER_LOGOUT, PAYMENT_CREATED,
                PAYMENT_FAILED, ITEM_ADDED, ITEM_REMOVED, ... }
   
   // Good: separate enums by domain
   enum AuthEvent { LOGIN, LOGOUT, MFA_CHALLENGE }
   enum PaymentEvent { CREATED, FAILED, REFUNDED }

5. Enum with Behavior That Varies (code smell)
   // Bad: switch on enum in 10 different places
   switch (shape) {
       case CIRCLE: /* area */ break;
       case RECT: /* area */ break;
   }
   // ...elsewhere...
   switch (shape) {
       case CIRCLE: /* perimeter */ break;
       case RECT: /* perimeter */ break;
   }
   
   // Better: polymorphism (each shape implements area/perimeter)
   // Or: algebraic data types with match (Rust, Haskell)

6. Reusing Deleted Enum Values
   // Version 1: { DRAFT=1, ACTIVE=2, ARCHIVED=3 }
   // Version 2: remove DRAFT, add PENDING=1  ← DISASTER!
   // Old data with value 1 (DRAFT) now reads as PENDING!
   
   // Rule: NEVER reuse old enum values
   // Protobuf: use reserved to prevent reuse

7. Mutable Enum Variants
   // Bad: enum values that change at runtime
   Color.RED.hex = "#FF0001";  // Java allows mutating enum fields!
   
   // Good: enum values should be immutable constants

8. Not Handling Unknown Values
   // Deployed new enum value "PENDING" to Service A
   // Service B doesn't know "PENDING" yet → crash!
   // Always: default/unknown handler in switch/match
EOF
}

cmd_database() {
    cat << 'EOF'
=== Enums in Databases ===

Approach 1: String Column with CHECK
  CREATE TABLE orders (
      status VARCHAR(20) NOT NULL DEFAULT 'CREATED'
          CHECK (status IN ('CREATED','PAID','SHIPPED','DELIVERED','CANCELLED'))
  );
  
  Pros: readable, self-documenting, easy to query
  Cons: storage overhead, case sensitivity, migration for new values
  Adding a value: ALTER TABLE ... DROP CONSTRAINT, ADD CONSTRAINT
  PostgreSQL: ALTER TYPE can ADD VALUE to native enum

Approach 2: PostgreSQL Native ENUM
  CREATE TYPE order_status AS ENUM ('CREATED','PAID','SHIPPED','DELIVERED');
  CREATE TABLE orders (status order_status NOT NULL DEFAULT 'CREATED');
  
  Pros: type-safe, compact storage (4 bytes), sorted by definition order
  Cons: ALTER TYPE ADD VALUE can't be in transaction (pre-v12)
        Can't easily REMOVE values
        Doesn't exist in MySQL, SQLite, SQL Server

Approach 3: Integer Column
  CREATE TABLE orders (
      status SMALLINT NOT NULL DEFAULT 0
      -- 0=CREATED, 1=PAID, 2=SHIPPED, 3=DELIVERED, 4=CANCELLED
  );
  
  Pros: compact (2 bytes), fast comparison, works everywhere
  Cons: meaningless without documentation, easy to mess up
  Rule: document the mapping, use application-level constants

Approach 4: Lookup Table (normalized)
  CREATE TABLE order_statuses (
      id SERIAL PRIMARY KEY,
      name VARCHAR(50) UNIQUE NOT NULL,
      description TEXT,
      sort_order INT
  );
  
  CREATE TABLE orders (
      status_id INT REFERENCES order_statuses(id)
  );
  
  Pros: metadata (description, sort, active flag), no schema changes
  Cons: JOIN needed, more complex queries
  Best for: admin-managed, frequently changing sets

Migration Strategies:
  Adding a value:
    String/CHECK: update constraint (instant)
    PG ENUM: ALTER TYPE ADD VALUE (fast, but commit issues)
    Lookup table: INSERT row (no schema change!)
    Integer: just use the next number (no schema change)
  
  Removing a value:
    1. Stop writing the old value
    2. Migrate existing rows to new value
    3. Then remove from constraint/type (if desired)
    4. Never reuse the old value!
  
  Renaming:
    1. Add new value
    2. UPDATE existing rows
    3. Remove old value
    Or: if using lookup table, just UPDATE the name

Indexing:
  Low cardinality (3-10 values): bitmap index or partial index
  PostgreSQL: CREATE INDEX ON orders (status) WHERE status = 'ACTIVE';
  MySQL: ENUM type internally uses 1-2 bytes, efficient for indexing
EOF
}

show_help() {
    cat << EOF
enum v$VERSION — Enumeration Pattern Reference

Usage: script.sh <command>

Commands:
  intro          Enum purpose, types, and design principles
  languages      Enum syntax in Rust, TS, Python, Java, C#, Go, C
  bitflags       Bit flags and bitmask operations
  statemachine   State machines modeled with enums
  serialization  String vs int, unknown values, schema evolution
  algebraic      Sum types / discriminated unions (Rust, TS, Haskell)
  antipatterns   String abuse, boolean blindness, god enum
  database       Enums in SQL: CHECK, native ENUM, lookup tables
  help           Show this help
  version        Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)         cmd_intro ;;
    languages)     cmd_languages ;;
    bitflags)      cmd_bitflags ;;
    statemachine)  cmd_statemachine ;;
    serialization) cmd_serialization ;;
    algebraic)     cmd_algebraic ;;
    antipatterns)  cmd_antipatterns ;;
    database)      cmd_database ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "enum v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
