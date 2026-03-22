#!/usr/bin/env bash
# struct — Composite Data Type Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Structs — Composite Data Types ===

A struct (structure/record) is a composite data type that groups
related variables under one name, each with its own type.

Origin:
  Introduced in C (1972) by Dennis Ritchie.
  Evolved into records (Pascal), classes (C++), and data classes.

Struct vs Class:
  ┌──────────────┬──────────────────┬──────────────────┐
  │              │ Struct           │ Class            │
  ├──────────────┼──────────────────┼──────────────────┤
  │ Semantics    │ Value type       │ Reference type   │
  │ Default      │ Public members   │ Private members  │
  │ Inheritance  │ No (usually)     │ Yes              │
  │ Heap/Stack   │ Usually stack    │ Usually heap     │
  │ Copy         │ Deep copy        │ Reference copy   │
  │ Identity     │ Compared by value│ Compared by ref  │
  │ Use for      │ Data holders     │ Complex objects  │
  └──────────────┴──────────────────┴──────────────────┘

  Note: In C++, struct and class are identical except default access.
  In C#, Swift, Rust — struct is a true value type.

Value Semantics (Structs):
  Point a = {x: 10, y: 20};
  Point b = a;                    // b is a COPY
  b.x = 99;                      // a.x is still 10

Reference Semantics (Classes):
  Point a = new Point(10, 20);
  Point b = a;                    // b is a REFERENCE to same object
  b.x = 99;                      // a.x is now 99 too!

When to Use Structs:
  ✓ Small data containers (Point, Color, Rectangle)
  ✓ Value types that should be copied, not shared
  ✓ Performance-critical code (stack allocation, cache-friendly)
  ✓ Interop with C libraries (FFI)
  ✓ Message/event payloads
  ✓ Database row representations

When to Use Classes:
  ✓ Complex behavior with inheritance hierarchies
  ✓ Shared mutable state (multiple references needed)
  ✓ Large objects that are expensive to copy
  ✓ Objects with identity (two users with same name ≠ same user)
EOF
}

cmd_clang() {
    cat << 'EOF'
=== C Structs ===

--- Basic Definition ---
  struct Point {
      int x;
      int y;
  };

  struct Point p1 = {10, 20};      // positional init
  struct Point p2 = {.x = 10, .y = 20};  // designated (C99)
  p1.x = 30;                       // field access

--- Typedef ---
  typedef struct {
      float x, y, z;
  } Vec3;

  Vec3 v = {1.0f, 2.0f, 3.0f};    // no 'struct' keyword needed

--- Nested Structs ---
  typedef struct {
      Vec3 position;
      Vec3 velocity;
      float mass;
  } Particle;

  Particle p = {
      .position = {0, 0, 0},
      .velocity = {1, 0, 0},
      .mass = 1.5f
  };

--- Pointers to Structs ---
  void move(Particle *p, float dt) {
      p->position.x += p->velocity.x * dt;  // -> for pointer access
      p->position.y += p->velocity.y * dt;
  }
  // Use . for direct access, -> for pointer access

--- Flexible Array Member (C99) ---
  typedef struct {
      int length;
      char data[];         // flexible array — must be last member
  } Buffer;

  Buffer *b = malloc(sizeof(Buffer) + 100);
  b->length = 100;

--- Bit Fields ---
  struct Flags {
      unsigned int readable  : 1;   // 1 bit
      unsigned int writable  : 1;
      unsigned int executable: 1;
      unsigned int reserved  : 5;   // 5 bits padding
  };
  // sizeof(Flags) = 1 byte (8 bits total, fits in unsigned int)

--- Forward Declaration ---
  struct Node;                     // forward declare
  struct Node {
      int value;
      struct Node *next;           // self-referential
  };

--- Anonymous Structs (C11) ---
  struct {
      union {
          struct { float x, y; };  // anonymous — access directly
          float v[2];
      };
  } point;
  point.x = 1.0f;                 // same as point.v[0]
EOF
}

cmd_golang() {
    cat << 'EOF'
=== Go Structs ===

--- Basic Definition ---
  type Point struct {
      X int
      Y int
  }

  p := Point{X: 10, Y: 20}       // named fields
  p := Point{10, 20}              // positional (fragile, avoid)
  var p Point                     // zero value: {0, 0}

--- Exported vs Unexported ---
  type User struct {
      Name  string    // exported (uppercase) — accessible outside package
      Email string    // exported
      age   int       // unexported (lowercase) — package-private
  }

--- Methods (Value Receiver) ---
  func (p Point) Distance() float64 {
      return math.Sqrt(float64(p.X*p.X + p.Y*p.Y))
  }
  // Cannot modify p — receives a copy

--- Methods (Pointer Receiver) ---
  func (p *Point) Translate(dx, dy int) {
      p.X += dx
      p.Y += dy
  }
  // Modifies the original struct

  Rule of thumb: If any method needs pointer receiver, make ALL methods
  use pointer receiver (consistency for interface satisfaction).

--- Embedding (Composition) ---
  type Animal struct {
      Name string
  }
  func (a Animal) Speak() string { return a.Name + " speaks" }

  type Dog struct {
      Animal           // embedded — Dog "inherits" Animal's fields and methods
      Breed string
  }

  d := Dog{Animal: Animal{Name: "Rex"}, Breed: "Labrador"}
  d.Name               // "Rex" — promoted field
  d.Speak()            // "Rex speaks" — promoted method

--- Struct Tags ---
  type User struct {
      Name  string `json:"name" db:"user_name" validate:"required"`
      Email string `json:"email,omitempty" db:"email"`
      Age   int    `json:"-"`  // skip in JSON
  }

  // Read tags via reflection:
  field, _ := reflect.TypeOf(User{}).FieldByName("Name")
  tag := field.Tag.Get("json")  // "name"

--- Constructor Pattern ---
  func NewUser(name, email string) *User {
      return &User{
          Name:  name,
          Email: email,
      }
  }
  // Go has no constructors — use New* functions by convention

--- Struct Comparison ---
  All fields must be comparable (no slices, maps, functions)
  p1 := Point{1, 2}
  p2 := Point{1, 2}
  fmt.Println(p1 == p2)  // true

  // Structs with uncomparable fields → use reflect.DeepEqual
EOF
}

cmd_rust() {
    cat << 'EOF'
=== Rust Structs ===

--- Named Struct ---
  struct Point {
      x: f64,
      y: f64,
  }

  let p = Point { x: 1.0, y: 2.0 };
  let q = Point { x: 3.0, ..p };     // struct update syntax (y from p)

--- Tuple Struct ---
  struct Color(u8, u8, u8);
  let red = Color(255, 0, 0);
  println!("{}", red.0);               // access by index

  // Newtype pattern (single-field tuple struct):
  struct Meters(f64);
  struct Seconds(f64);
  // Type-safe — can't mix Meters and Seconds accidentally

--- Unit Struct ---
  struct Marker;                       // zero-sized type
  // Used for trait implementations, phantom types, type-level markers

--- impl Block (Methods) ---
  impl Point {
      // Associated function (like static method)
      fn new(x: f64, y: f64) -> Self {
          Point { x, y }
      }

      // Method (borrows self immutably)
      fn distance(&self) -> f64 {
          (self.x.powi(2) + self.y.powi(2)).sqrt()
      }

      // Method (borrows self mutably)
      fn translate(&mut self, dx: f64, dy: f64) {
          self.x += dx;
          self.y += dy;
      }

      // Method (consumes self)
      fn into_tuple(self) -> (f64, f64) {
          (self.x, self.y)
      }
  }

--- Derive Macros ---
  #[derive(Debug, Clone, PartialEq, Eq, Hash)]
  struct User {
      name: String,
      age: u32,
  }

  Common derives:
    Debug       Enable {:?} formatting
    Clone       Enable .clone()
    Copy        Implicit copy (small types only)
    PartialEq   Enable == comparison
    Eq          Full equality (if PartialEq + no NaN)
    Hash        Enable use as HashMap key
    Default     Enable Default::default()
    Serialize   serde serialization
    Deserialize serde deserialization

--- Visibility ---
  pub struct Config {
      pub name: String,           // public field
      pub(crate) internal: bool,  // crate-private
      secret: String,             // private (default)
  }

--- Lifetime Annotations ---
  struct Excerpt<'a> {
      text: &'a str,    // borrows data — must not outlive source
  }

--- Generic Structs ---
  struct Pair<T> {
      first: T,
      second: T,
  }

  impl<T: std::fmt::Display> Pair<T> {
      fn show(&self) {
          println!("({}, {})", self.first, self.second);
      }
  }
EOF
}

cmd_memory() {
    cat << 'EOF'
=== Struct Memory Layout ===

--- Alignment Rules ---
  Each type has an alignment requirement (must start at multiple of N bytes):
    char/u8:      1-byte aligned
    short/u16:    2-byte aligned
    int/u32:      4-byte aligned
    long/u64:     8-byte aligned
    pointer:      4 or 8-byte aligned (32/64-bit)
    float:        4-byte aligned
    double/f64:   8-byte aligned

--- Padding Example ---
  struct Bad {           // 24 bytes (with padding)
      char a;            // offset 0,  1 byte
                         // 7 bytes padding
      double b;          // offset 8,  8 bytes
      char c;            // offset 16, 1 byte
                         // 3 bytes padding
      int d;             // offset 20, 4 bytes
  };

  struct Good {          // 16 bytes (reordered!)
      double b;          // offset 0,  8 bytes
      int d;             // offset 8,  4 bytes
      char a;            // offset 12, 1 byte
      char c;            // offset 13, 1 byte
                         // 2 bytes padding
  };

  Rule: Order fields largest-to-smallest alignment for minimal padding.

--- Packing (Override Alignment) ---
  C/C++:
    #pragma pack(1)
    struct Packed { ... };    // no padding, but slower access
    #pragma pack()

    __attribute__((packed))   // GCC/Clang

  Rust:
    #[repr(packed)]           // may cause unaligned access
    #[repr(C)]                // C-compatible layout (stable ABI)

--- sizeof vs Actual Data ---
  struct Example {
      int a;       // 4 bytes
      char b;      // 1 byte
  };
  // sizeof = 8 (4 + 1 + 3 padding)
  // actual data = 5 bytes
  // wasted = 3 bytes (37.5% waste!)

--- Cache-Friendly Structs ---
  CPU cache line: typically 64 bytes
  Hot/cold splitting:
    struct PlayerHot {      // frequently accessed fields
        float x, y, z;     // position
        float health;
    };                      // 16 bytes — fits in cache line

    struct PlayerCold {     // rarely accessed
        char name[64];
        int score;
        time_t lastLogin;
    };

  Array of Structs (AoS) vs Struct of Arrays (SoA):
    AoS: Player players[1000];           // each player contiguous
    SoA: float x[1000], y[1000], ...;    // each field contiguous

    SoA is better for SIMD and when processing one field across many items.
    AoS is better when processing all fields of one item.

--- Zero-Sized Types (ZST) ---
  Rust unit struct:  struct Marker;       // sizeof = 0
  Go empty struct:   struct{}{}           // sizeof = 0
  Used for: sets (map[K]struct{}), type markers, signals
EOF
}

cmd_patterns() {
    cat << 'EOF'
=== Struct Design Patterns ===

--- Builder Pattern ---
  struct ServerConfig {
      host: String,
      port: u16,
      workers: usize,
      tls: bool,
  }

  struct ServerConfigBuilder { /* same fields as Option<T> */ }

  impl ServerConfigBuilder {
      fn new() -> Self { /* defaults */ }
      fn host(mut self, h: &str) -> Self { self.host = Some(h.into()); self }
      fn port(mut self, p: u16) -> Self { self.port = Some(p); self }
      fn build(self) -> Result<ServerConfig, &'static str> { /* validate */ }
  }

  let config = ServerConfigBuilder::new()
      .host("0.0.0.0")
      .port(8080)
      .build()?;

--- Newtype Pattern ---
  Wrap a primitive type to give it domain meaning:

  type UserId = u64;        // type alias — NOT type-safe
  struct UserId(u64);       // newtype — IS type-safe

  fn get_user(id: UserId) { }
  get_user(UserId(42));     // must wrap explicitly
  get_user(42);             // compile error!

  Use for: IDs, measurements, validated strings, domain types

--- Phantom Type Pattern ---
  use std::marker::PhantomData;

  struct Locked;
  struct Unlocked;

  struct Door<State> {
      _state: PhantomData<State>,
  }

  impl Door<Locked> {
      fn unlock(self) -> Door<Unlocked> { Door { _state: PhantomData } }
  }
  impl Door<Unlocked> {
      fn lock(self) -> Door<Locked> { Door { _state: PhantomData } }
      fn open(&self) { /* only unlocked doors can open */ }
  }

--- Opaque Struct (C) ---
  // header.h — public
  typedef struct Database Database;    // forward declare only
  Database *db_open(const char *path);
  void db_close(Database *db);

  // implementation.c — private
  struct Database {
      FILE *fp;
      int ref_count;
      // internals hidden from users
  };

--- Struct Inheritance via Embedding (Go) ---
  type Base struct { ID int; Created time.Time }
  type User struct { Base; Name string }
  type Post struct { Base; Title string; Body string }
  // Both User and Post have ID and Created fields

--- Data Transfer Object (DTO) ---
  Minimal struct for crossing boundaries (API, DB, IPC):
  type UserDTO struct {
      Name  string `json:"name"`
      Email string `json:"email"`
  }
  // No methods, no behavior — pure data carrier
EOF
}

cmd_serialization() {
    cat << 'EOF'
=== Struct Serialization ===

--- JSON ---
  Go:
    type User struct {
        Name string `json:"name"`
        Age  int    `json:"age,omitempty"`
    }
    data, _ := json.Marshal(user)
    json.Unmarshal(data, &user)

  Rust (serde):
    #[derive(Serialize, Deserialize)]
    struct User {
        name: String,
        #[serde(skip_serializing_if = "Option::is_none")]
        age: Option<u32>,
    }

  Python (dataclasses):
    @dataclass
    class User:
        name: str
        age: int = 0

    import json
    json.dumps(asdict(user))

--- Binary Serialization ---
  MessagePack: Compact binary JSON-like format (~30% smaller)
  CBOR:        Concise Binary Object Representation (IETF standard)
  Bincode:     Rust-specific, extremely fast
  FlatBuffers: Zero-copy, schema-based (Google)

--- Protocol Buffers ---
  message User {
      string name = 1;
      int32 age = 2;
      repeated string tags = 3;
  }
  // Generates struct + serialize/deserialize in target language
  // Compact binary, schema evolution, language-neutral

--- Zero-Copy Deserialization ---
  Parse data without copying it — borrow directly from buffer.

  Rust serde:
    #[derive(Deserialize)]
    struct Log<'a> {
        #[serde(borrow)]
        message: &'a str,          // points into original buffer
        level: u8,
    }

  Cap'n Proto / FlatBuffers:
    Read fields directly from serialized buffer
    No parse step — just pointer arithmetic
    10-100x faster than JSON parsing

--- Database Mapping ---
  Go (sqlx):
    type User struct {
        ID    int    `db:"id"`
        Name  string `db:"name"`
        Email string `db:"email"`
    }
    sqlx.Get(db, &user, "SELECT * FROM users WHERE id=$1", 1)

  Rust (sqlx):
    #[derive(sqlx::FromRow)]
    struct User {
        id: i32,
        name: String,
        email: String,
    }
EOF
}

cmd_comparison() {
    cat << 'EOF'
=== Struct Features Across Languages ===

┌───────────────┬───────┬──────┬──────┬───────┬──────────┬────────┐
│ Feature       │ C     │ Go   │ Rust │ Swift │ TypeScript│ Python │
├───────────────┼───────┼──────┼──────┼───────┼──────────┼────────┤
│ Keyword       │struct │struct│struct│struct │interface*│@data   │
│ Value type    │ Yes   │ Yes  │ Yes  │ Yes   │ N/A      │ Ref    │
│ Methods       │ No    │ Yes  │ Yes  │ Yes   │ N/A      │ Yes    │
│ Inheritance   │ No    │ Embed│ No   │ Proto │ Extends  │ Yes    │
│ Generics      │ No    │ Yes  │ Yes  │ Yes   │ Yes      │ Yes    │
│ Default values│ No    │ Zero │ No   │ Yes   │ Optional │ Yes    │
│ Visibility    │ N/A   │ Case │ pub  │ Access│ N/A      │ _conv  │
│ Destructuring │ No    │ No   │ Yes  │ No    │ Yes      │ No     │
│ Memory control│ Full  │ GC   │ Full │ ARC   │ GC/V8   │ GC     │
│ Null fields   │ No    │ Zero │ Option│ Opt  │ ?/undef  │ None   │
│ Tags/Attrs    │ No    │ Tags │ Attrs│ Attrs │ Decorat* │ Decorat│
│ Mutable       │ Yes   │ Yes  │ mut  │ var   │ Yes      │ frozen*│
└───────────────┴───────┴──────┴──────┴───────┴──────────┴────────┘

* TypeScript uses interfaces/types for struct-like shapes
* Python uses @dataclass or NamedTuple
* frozen=True in @dataclass for immutability

Language-Specific Equivalents:
  C:          struct Point { int x; int y; };
  Go:         type Point struct { X, Y int }
  Rust:       struct Point { x: i32, y: i32 }
  Swift:      struct Point { var x: Int; var y: Int }
  TypeScript: interface Point { x: number; y: number }
  Python:     @dataclass class Point: x: int; y: int
  Kotlin:     data class Point(val x: Int, val y: Int)
  C#:         record struct Point(int X, int Y);  // C# 10
  Elixir:     defstruct [:x, :y]
  Zig:        const Point = struct { x: i32, y: i32 };

Choosing Between Struct and Class:
  Use struct when:
    - Data is small (< 64 bytes typically)
    - Value semantics desired (copy, not share)
    - No inheritance needed
    - Performance-critical (stack allocation)

  Use class when:
    - Object has complex behavior
    - Shared references needed
    - Inheritance hierarchy exists
    - Object is large or resource-managing
EOF
}

show_help() {
    cat << EOF
struct v$VERSION — Composite Data Type Reference

Usage: script.sh <command>

Commands:
  intro        Struct fundamentals, struct vs class, value semantics
  clang        C structs: typedef, nested, bit fields, flexible arrays
  golang       Go structs: methods, embedding, tags, constructors
  rust         Rust structs: named, tuple, unit, impl, derives
  memory       Memory layout: alignment, padding, cache optimization
  patterns     Design patterns: builder, newtype, phantom, opaque
  serialization JSON, binary, protobuf, zero-copy deserialization
  comparison   Struct features across C, Go, Rust, Swift, TS, Python
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)         cmd_intro ;;
    clang|c)       cmd_clang ;;
    golang|go)     cmd_golang ;;
    rust)          cmd_rust ;;
    memory)        cmd_memory ;;
    patterns)      cmd_patterns ;;
    serialization) cmd_serialization ;;
    comparison)    cmd_comparison ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "struct v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
