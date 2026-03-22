#!/usr/bin/env bash
# typedef — Type Definition Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Type Definitions ===

A type definition creates a new name for a type, making code
more readable, maintainable, and sometimes type-safe.

Two Flavors:
  Type Alias:  New name for existing type. Fully interchangeable.
               UserId and u64 can be used interchangeably.

  Newtype:     Distinct type wrapping another. NOT interchangeable.
               UserId(u64) is a DIFFERENT type from u64.

Why Type Definitions Matter:
  1. Readability:
     fn process(u64, u64, u64)           // what are these?
     fn process(UserId, OrderId, Amount)  // clear!

  2. Maintainability:
     typedef uint32_t port_t;
     // Change port_t to uint16_t in ONE place, updates everywhere

  3. Type Safety (newtypes):
     fn transfer(from: AccountId, to: AccountId, amount: Money)
     // Can't accidentally swap from/to with amount

  4. Abstraction:
     Platform-specific types (size_t, ptrdiff_t) hide implementation

  5. Simplification:
     typedef std::unordered_map<std::string, std::vector<int>> LookupTable;
     // Much cleaner than repeating the full type

Alias vs Newtype — When to Use Which:
  Use alias when:
    ✓ Just want a shorter name for a complex type
    ✓ Types should be interchangeable
    ✓ Backward compatibility needed

  Use newtype when:
    ✓ Want to prevent mixing up similar types (two u64 IDs)
    ✓ Need to add methods to a type you don't own
    ✓ Want compiler-enforced domain boundaries
    ✓ Implementing traits for external types (Rust orphan rule)
EOF
}

cmd_clang() {
    cat << 'EOF'
=== C typedef ===

--- Basic Typedef ---
  typedef unsigned long size_t;
  typedef int bool_t;
  typedef char* string_t;

  size_t len = 42;
  bool_t flag = 1;

--- Struct Typedef ---
  // Without typedef:
  struct Point { int x; int y; };
  struct Point p1 = {10, 20};    // must write 'struct' every time

  // With typedef:
  typedef struct {
      int x;
      int y;
  } Point;
  Point p1 = {10, 20};          // no 'struct' keyword needed

  // Named struct + typedef (for self-reference):
  typedef struct Node {
      int value;
      struct Node* next;         // must use 'struct Node' here
  } Node;

--- Function Pointer Typedef ---
  // Without typedef:
  void (*handler)(int, const char*);    // hard to read

  // With typedef:
  typedef void (*Handler)(int, const char*);
  Handler on_error = my_error_handler;

  // Callback typedef:
  typedef int (*Comparator)(const void*, const void*);
  void sort(void* arr, size_t n, size_t size, Comparator cmp);

--- Opaque Type (Information Hiding) ---
  // header.h (public):
  typedef struct Database Database;      // forward declaration only
  Database* db_open(const char* path);
  void db_close(Database* db);

  // database.c (private):
  struct Database {
      FILE* fp;
      int cache_size;
      // implementation hidden from users
  };

--- Platform Types ---
  // stdint.h defines platform-independent types:
  typedef signed char        int8_t;
  typedef unsigned char      uint8_t;
  typedef signed short       int16_t;
  typedef unsigned short     uint16_t;
  typedef signed int         int32_t;
  typedef unsigned int       uint32_t;
  typedef signed long long   int64_t;
  typedef unsigned long long uint64_t;

  // POSIX types:
  typedef long              ssize_t;     // signed size
  typedef unsigned long     size_t;      // unsigned size
  typedef long              ptrdiff_t;   // pointer difference
  typedef int               pid_t;       // process ID

--- Array Typedef ---
  typedef int Matrix4x4[4][4];
  Matrix4x4 transform;
  transform[0][0] = 1;

--- Enum Typedef ---
  typedef enum {
      LOG_DEBUG = 0,
      LOG_INFO  = 1,
      LOG_WARN  = 2,
      LOG_ERROR = 3,
  } LogLevel;
EOF
}

cmd_cpp() {
    cat << 'EOF'
=== C++ using Declarations ===

C++11 introduced 'using' as a modern alternative to typedef.

--- Basic Using ---
  using size_t = unsigned long;
  using string = std::string;
  using StringVector = std::vector<std::string>;

  // Equivalent typedef:
  typedef unsigned long size_t;
  typedef std::vector<std::string> StringVector;

--- Template Aliases (using ONLY — typedef can't do this!) ---
  template<typename T>
  using Vec = std::vector<T>;

  template<typename K, typename V>
  using Map = std::unordered_map<K, V>;

  Vec<int> numbers = {1, 2, 3};
  Map<string, int> ages = {{"Alice", 30}};

  // typedef CANNOT create template aliases:
  // template<typename T>
  // typedef std::vector<T> Vec;    // ERROR!

--- Function Type Aliases ---
  // typedef (hard to read):
  typedef void (*Callback)(int, const char*);

  // using (clearer):
  using Callback = void(*)(int, const char*);

  // std::function version:
  using Callback = std::function<void(int, const std::string&)>;

--- Complex Type Simplification ---
  // Before:
  std::unordered_map<std::string, std::vector<std::pair<int, double>>>

  // After:
  using DataPoint = std::pair<int, double>;
  using DataSeries = std::vector<DataPoint>;
  using DataMap = std::unordered_map<std::string, DataSeries>;

--- Using in Class Scope ---
  class Derived : public Base {
      using Base::Base;         // inherit constructors
      using Base::method;       // bring into scope (unhide)
  };

--- Namespace Aliases ---
  namespace fs = std::filesystem;
  fs::path p = "/home/user";

  // Not exactly 'using' but related name shortening

--- Type Traits Using ---
  template<typename T>
  using remove_const_t = typename std::remove_const<T>::type;

  // C++14 added these _t aliases for all type traits:
  std::remove_const_t<const int>        // int
  std::remove_reference_t<int&>         // int
  std::conditional_t<true, int, float>  // int

--- When to Use 'using' vs 'typedef' ---
  Prefer 'using' because:
    ✓ Works with templates (template aliases)
    ✓ Reads left-to-right (more natural)
    ✓ Consistent with other 'using' declarations
    ✓ Modern C++ style

  typedef is fine for:
    ✓ C compatibility
    ✓ Legacy codebases
    ✓ Simple, non-template aliases
EOF
}

cmd_rust() {
    cat << 'EOF'
=== Rust Type Aliases & Newtypes ===

--- Type Alias ---
  type UserId = u64;
  type Result<T> = std::result::Result<T, MyError>;
  type Callback = Box<dyn Fn(i32) -> bool>;

  let id: UserId = 42;
  let n: u64 = id;    // ✓ fully interchangeable — no type safety!

  // Common stdlib aliases:
  type io::Result<T> = Result<T, io::Error>;
  // Saves writing Result<T, io::Error> everywhere

--- Newtype Pattern ---
  struct UserId(u64);       // distinct type wrapping u64
  struct OrderId(u64);      // another distinct type

  let user = UserId(42);
  let order = OrderId(42);
  // user == order  →  compile ERROR! Different types!

  // Access inner value:
  let raw: u64 = user.0;

--- Newtype with Derive ---
  #[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
  struct Meters(f64);

  #[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
  struct Seconds(f64);

  fn speed(distance: Meters, time: Seconds) -> f64 {
      distance.0 / time.0
  }
  // Can't accidentally pass Seconds as Meters!

--- From/Into Conversions ---
  impl From<u64> for UserId {
      fn from(id: u64) -> Self { UserId(id) }
  }

  let id: UserId = 42.into();
  let id = UserId::from(42);

--- Deref for Transparent Access ---
  use std::ops::Deref;

  struct Email(String);

  impl Deref for Email {
      type Target = str;
      fn deref(&self) -> &str { &self.0 }
  }

  let email = Email("alice@example.com".into());
  println!("{}", email.len());     // str methods available!
  println!("{}", email.contains("@"));

--- Add Methods to External Types ---
  // Can't impl Display for Vec<T> (orphan rule)
  // But CAN with newtype:
  struct Wrapper(Vec<String>);

  impl fmt::Display for Wrapper {
      fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
          write!(f, "[{}]", self.0.join(", "))
      }
  }

--- Generic Type Aliases ---
  type Pair<T> = (T, T);
  type StringMap<V> = HashMap<String, V>;

  let coords: Pair<f64> = (1.0, 2.0);
  let ages: StringMap<u32> = HashMap::new();

--- Associated Type Aliases ---
  trait Container {
      type Item;
      fn get(&self, index: usize) -> Option<&Self::Item>;
  }

  impl Container for Vec<String> {
      type Item = String;
      fn get(&self, index: usize) -> Option<&String> {
          self.as_slice().get(index)
      }
  }
EOF
}

cmd_typescript() {
    cat << 'EOF'
=== TypeScript Type Definitions ===

--- Type Alias ---
  type UserId = string;
  type Point = { x: number; y: number };
  type Callback = (error: Error | null, data: unknown) => void;
  type StringOrNumber = string | number;

--- Interface vs Type ---
  // Interface: extendable, declaration merging
  interface User {
    name: string;
    age: number;
  }
  interface User {          // declaration merging!
    email?: string;
  }

  // Type: unions, intersections, mapped types
  type User = {
    name: string;
    age: number;
  };
  // type User = { ... }   // ERROR: can't re-declare

  Rule of thumb:
    Interface for objects that others extend
    Type for unions, intersections, utility types

--- Utility Types ---
  Partial<T>        All properties optional
  Required<T>       All properties required
  Readonly<T>       All properties readonly
  Pick<T, K>        Select subset of properties
  Omit<T, K>        Remove properties
  Record<K, V>      Map keys to values
  Exclude<T, U>     Remove types from union
  Extract<T, U>     Keep types from union
  NonNullable<T>    Remove null and undefined
  ReturnType<T>     Get function return type
  Parameters<T>     Get function parameter types
  Awaited<T>        Unwrap Promise type

  // Examples:
  type CreateUser = Omit<User, 'id'>;
  type UserSummary = Pick<User, 'name' | 'email'>;
  type UserMap = Record<UserId, User>;

--- Mapped Types ---
  type Flags<T> = {
    [K in keyof T]: boolean;
  };

  type UserFlags = Flags<User>;
  // { name: boolean; age: boolean; email: boolean }

--- Template Literal Types ---
  type EventName = `on${Capitalize<string>}`;
  // Matches: "onClick", "onHover", "onSubmit", etc.

  type HttpMethod = 'GET' | 'POST' | 'PUT' | 'DELETE';
  type ApiRoute = `/${string}`;
  type Endpoint = `${HttpMethod} ${ApiRoute}`;
  // "GET /users", "POST /orders", etc.

--- Branded Types (Newtype-like) ---
  type UserId = string & { readonly __brand: unique symbol };
  type OrderId = string & { readonly __brand: unique symbol };

  function userId(id: string): UserId { return id as UserId; }
  function orderId(id: string): OrderId { return id as OrderId; }

  function getUser(id: UserId) { ... }
  getUser(userId("abc"));     // ✓
  getUser(orderId("abc"));    // ✗ Type error!
  getUser("abc");             // ✗ Type error!

--- Conditional Types ---
  type IsString<T> = T extends string ? true : false;
  type A = IsString<"hello">;  // true
  type B = IsString<42>;       // false

  // Infer pattern:
  type UnwrapPromise<T> = T extends Promise<infer U> ? U : T;
  type X = UnwrapPromise<Promise<string>>;  // string
EOF
}

cmd_golang() {
    cat << 'EOF'
=== Go Type Definitions ===

Go has TWO mechanisms: type definition and type alias.

--- Type Definition (New Type) ---
  type Celsius float64
  type Fahrenheit float64

  var temp Celsius = 100.0
  // var f Fahrenheit = temp   // ERROR: different types!
  var f Fahrenheit = Fahrenheit(temp)  // explicit conversion required

  // Can add methods:
  func (c Celsius) ToFahrenheit() Fahrenheit {
      return Fahrenheit(c*9/5 + 32)
  }

--- Type Alias (Same Type) ---
  type MyString = string    // note the = sign

  var s MyString = "hello"
  var t string = s          // ✓ interchangeable — same type

  // CANNOT add methods to alias:
  // func (s MyString) Upper() string { }  // ERROR

--- Key Difference ---
  type NewType OldType      // NEW type, can have methods, not assignable
  type AliasType = OldType  // SAME type, no new methods, fully compatible

  When to use which:
    type definition: domain types (UserId, Money, Temperature)
    type alias:      migrations, cross-package compatibility

--- Struct Type Definition ---
  type User struct {
      ID    int
      Name  string
      Email string
  }

--- Interface Type Definition ---
  type Reader interface {
      Read(p []byte) (n int, err error)
  }

  type ReadCloser interface {
      Reader                // embedding
      Close() error
  }

--- Function Type Definition ---
  type HandlerFunc func(http.ResponseWriter, *http.Request)

  func (f HandlerFunc) ServeHTTP(w http.ResponseWriter, r *http.Request) {
      f(w, r)
  }
  // net/http uses this pattern: function type with methods!

--- Enum Pattern (iota) ---
  type Weekday int

  const (
      Sunday Weekday = iota   // 0
      Monday                  // 1
      Tuesday                 // 2
      Wednesday               // 3
      Thursday                // 4
      Friday                  // 5
      Saturday                // 6
  )

  func (d Weekday) String() string {
      names := [...]string{"Sunday", "Monday", "Tuesday",
          "Wednesday", "Thursday", "Friday", "Saturday"}
      return names[d]
  }

--- Generic Type Definition (Go 1.18+) ---
  type Set[T comparable] map[T]struct{}

  func NewSet[T comparable]() Set[T] {
      return make(Set[T])
  }

  func (s Set[T]) Add(val T) {
      s[val] = struct{}{}
  }

  func (s Set[T]) Contains(val T) bool {
      _, ok := s[val]
      return ok
  }
EOF
}

cmd_patterns() {
    cat << 'EOF'
=== Type Definition Patterns ===

--- Branded Types (TypeScript) ---
  Simulate newtypes using intersection with unique symbol:

  declare const brand: unique symbol;
  type Brand<T, B> = T & { [brand]: B };

  type USD = Brand<number, 'USD'>;
  type EUR = Brand<number, 'EUR'>;

  function usd(amount: number): USD { return amount as USD; }
  function eur(amount: number): EUR { return amount as EUR; }

  function addUSD(a: USD, b: USD): USD { return (a + b) as USD; }
  addUSD(usd(10), usd(20));   // ✓
  addUSD(usd(10), eur(20));   // ✗ Type error!

--- Phantom Types (Rust) ---
  use std::marker::PhantomData;

  struct Validated;
  struct Unvalidated;

  struct Email<State> {
      address: String,
      _state: PhantomData<State>,
  }

  impl Email<Unvalidated> {
      fn new(addr: String) -> Self {
          Email { address: addr, _state: PhantomData }
      }
      fn validate(self) -> Result<Email<Validated>, Error> {
          if self.address.contains('@') {
              Ok(Email { address: self.address, _state: PhantomData })
          } else {
              Err(Error::InvalidEmail)
          }
      }
  }

  impl Email<Validated> {
      fn send(&self, body: &str) { /* only validated emails can send */ }
  }

--- Discriminated Unions (TypeScript) ---
  type Shape =
      | { kind: 'circle'; radius: number }
      | { kind: 'rectangle'; width: number; height: number }
      | { kind: 'triangle'; base: number; height: number };

  function area(shape: Shape): number {
      switch (shape.kind) {
          case 'circle':    return Math.PI * shape.radius ** 2;
          case 'rectangle': return shape.width * shape.height;
          case 'triangle':  return 0.5 * shape.base * shape.height;
      }
  }

--- Opaque Types ---
  Hide internal representation, expose only operations.

  // Module boundary hides implementation:
  // Haskell: newtype Password = Password ByteString (constructor not exported)
  // Rust: pub struct ApiKey(String);  (field is private)
  // TypeScript: branded type with constructor function

--- Result Type Pattern ---
  // Rust:
  type Result<T> = std::result::Result<T, MyError>;

  // TypeScript:
  type Result<T, E = Error> =
      | { ok: true; value: T }
      | { ok: false; error: E };

  // Go:
  type Result[T any] struct {
      Value T
      Err   error
  }

--- Unit/Measure Types ---
  // Prevent unit confusion (Mars Climate Orbiter, 1999):
  type Meters = number & { readonly __unit: 'meters' };
  type Feet = number & { readonly __unit: 'feet' };

  function feetToMeters(f: Feet): Meters {
      return (f * 0.3048) as Meters;
  }
  // Can't accidentally pass Feet where Meters expected!
EOF
}

cmd_comparison() {
    cat << 'EOF'
=== Type Definition Across Languages ===

┌──────────────┬──────────┬──────────┬──────────┬──────────┬──────────┐
│ Feature      │ C        │ C++      │ Rust     │ Go       │ TS       │
├──────────────┼──────────┼──────────┼──────────┼──────────┼──────────┤
│ Alias keyword│ typedef  │ using    │ type     │ type =   │ type     │
│ New type     │ N/A      │ N/A      │ struct() │ type     │ Brand    │
│ Template/Gen │ No       │ Yes      │ Yes      │ Yes(1.18)│ Yes      │
│ Methods      │ No       │ No(alias)│ impl     │ Yes      │ N/A      │
│ Interchangeable│ Yes    │ Yes      │ alias:Yes│ alias:Yes│ Yes      │
│              │          │          │ new:No   │ new:No   │          │
│ Type safety  │ None     │ None     │ Newtype  │ New type │ Branded  │
│ Visibility   │ N/A      │ N/A      │ pub      │ Capital  │ export   │
│ Inference    │ No       │ auto     │ Yes      │ :=       │ Yes      │
└──────────────┴──────────┴──────────┴──────────┴──────────┴──────────┘

Other Languages:
  Haskell:    type (alias), newtype (zero-cost wrapper), data (ADT)
  Swift:      typealias (alias only)
  Kotlin:     typealias (alias only, no newtype)
  Python:     TypeAlias (3.10+), NewType (typing module)
  Scala:      type (alias), opaque type (Scala 3 newtype)
  OCaml:      type (both alias and new types)
  Zig:        const alias, no typedef keyword

Python Example:
  from typing import NewType, TypeAlias

  # Alias (interchangeable):
  Vector: TypeAlias = list[float]

  # NewType (type-safe):
  UserId = NewType('UserId', int)
  user_id = UserId(42)
  # int operations return int, not UserId (limited safety)

Haskell Example:
  type String = [Char]                  -- alias
  newtype Age = Age Int deriving (Show) -- zero-cost wrapper
  data Color = Red | Green | Blue       -- algebraic data type

  -- newtype is zero-cost: same runtime representation as Int
  -- but compiler treats Age and Int as different types

Best Practices:
  1. Use aliases for readability of complex types
  2. Use newtypes for domain types that shouldn't be confused
  3. Add From/Into conversions for ergonomic newtype usage
  4. Document why a type alias/newtype exists
  5. Prefer newtype over alias when type safety matters
EOF
}

show_help() {
    cat << EOF
typedef v$VERSION — Type Definition Reference

Usage: script.sh <command>

Commands:
  intro        Type aliases vs newtypes, why type definitions matter
  clang        C typedef: structs, function pointers, opaque types
  cpp          C++ using: template aliases, vs typedef
  rust         Rust type alias and newtype pattern
  typescript   TS types: utility types, mapped, branded, conditional
  golang       Go type definition vs alias, methods, generics
  patterns     Branded, phantom, opaque, discriminated unions
  comparison   Type features across C, C++, Rust, Go, TS, Haskell
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)       cmd_intro ;;
    clang|c)     cmd_clang ;;
    cpp)         cmd_cpp ;;
    rust)        cmd_rust ;;
    typescript|ts) cmd_typescript ;;
    golang|go)   cmd_golang ;;
    patterns)    cmd_patterns ;;
    comparison)  cmd_comparison ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "typedef v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
