#!/usr/bin/env bash
# trait — Trait & Interface Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Traits — Shared Behavior Contracts ===

A trait defines a set of methods that a type must implement (or inherits
default implementations for). Traits enable polymorphism without inheritance.

Trait vs Interface vs Abstract Class:
  ┌─────────────────┬───────────┬───────────┬────────────────┐
  │                 │ Trait     │ Interface │ Abstract Class │
  ├─────────────────┼───────────┼───────────┼────────────────┤
  │ Default methods │ Yes       │ Java 8+   │ Yes            │
  │ State/fields    │ PHP only  │ No        │ Yes            │
  │ Multiple        │ Yes       │ Yes       │ No (usually)   │
  │ Constructors    │ No        │ No        │ Yes            │
  │ Inheritance     │ Horizontal│ Contract  │ Vertical       │
  │ Type identity   │ No        │ Yes*      │ Yes            │
  └─────────────────┴───────────┴───────────┴────────────────┘

Key Insight:
  Inheritance (is-a):   Dog IS an Animal
  Trait (can-do):       Dog CAN Swim, CAN Fetch, CAN Bark
  Interface (has-a):    Dog HAS a Serializable interface

  Traits describe capabilities, not identity.

The Diamond Problem:
  A inherits from B and C, both inherit from D.
  Which D implementation does A get?

  Solution by language:
    Rust:    No inheritance. Traits can't conflict (compiler error).
    PHP:     Explicit conflict resolution with insteadof/as.
    Scala:   Linearization — last trait wins (predictable order).
    Kotlin:  Must override conflicting methods explicitly.
    C++:     Virtual inheritance (complex, error-prone).

History:
  1990  Self language — traits as composable behaviors
  2003  Schärli et al — formal trait model (Smalltalk)
  2004  Scala — traits with linearized mixins
  2012  PHP 5.4 — horizontal reuse traits
  2015  Rust 1.0 — traits as the polymorphism mechanism
  2017  Kotlin — interfaces with default methods (trait-like)

Why Traits Over Inheritance:
  1. Compose capabilities freely (no rigid hierarchy)
  2. Avoid deep inheritance chains (fragile base class problem)
  3. Reuse code across unrelated types
  4. More flexible than single inheritance
  5. Explicit — no hidden behavior from parent classes
EOF
}

cmd_rust() {
    cat << 'EOF'
=== Rust Traits ===

--- Defining a Trait ---
  trait Drawable {
      fn draw(&self);                    // required method
      fn opacity(&self) -> f32 { 1.0 }  // default implementation
  }

--- Implementing a Trait ---
  struct Circle { radius: f64 }

  impl Drawable for Circle {
      fn draw(&self) {
          println!("Drawing circle r={}", self.radius);
      }
      // opacity uses default (1.0) — no need to implement
  }

--- Trait Bounds (Static Dispatch) ---
  fn render(item: &impl Drawable) {
      item.draw();
  }

  // Equivalent verbose form:
  fn render<T: Drawable>(item: &T) {
      item.draw();
  }

  // Multiple bounds:
  fn process<T: Drawable + Clone + Debug>(item: &T) { ... }

  // Where clause (cleaner for complex bounds):
  fn process<T>(item: &T)
  where
      T: Drawable + Clone + Debug,
  { ... }

--- Trait Objects (Dynamic Dispatch) ---
  fn render_any(item: &dyn Drawable) {
      item.draw();  // virtual method call (vtable lookup)
  }

  let shapes: Vec<Box<dyn Drawable>> = vec![
      Box::new(Circle { radius: 5.0 }),
      Box::new(Square { side: 3.0 }),
  ];

  Static vs Dynamic:
    impl Trait  → monomorphized at compile time (faster, bigger binary)
    dyn Trait   → vtable dispatch at runtime (flexible, slight overhead)

--- Supertraits ---
  trait Shape: Drawable + Debug {
      fn area(&self) -> f64;
  }
  // Shape requires both Drawable and Debug to be implemented

--- Associated Types ---
  trait Iterator {
      type Item;                         // associated type
      fn next(&mut self) -> Option<Self::Item>;
  }

  impl Iterator for Counter {
      type Item = u32;
      fn next(&mut self) -> Option<u32> { ... }
  }

--- Derive (Auto-implement) ---
  #[derive(Debug, Clone, PartialEq, Hash)]
  struct Point { x: f64, y: f64 }

--- Blanket Implementations ---
  impl<T: Display> ToString for T {
      fn to_string(&self) -> String {
          format!("{}", self)
      }
  }
  // Any type implementing Display automatically gets ToString

--- Orphan Rule ---
  You can implement a trait for a type only if:
    - You own the trait, OR
    - You own the type
  Can't implement someone else's trait for someone else's type.
  Solution: Newtype pattern — wrap the type in your own struct.
EOF
}

cmd_php() {
    cat << 'EOF'
=== PHP Traits ===

PHP traits provide horizontal code reuse — share methods across
unrelated classes without inheritance.

--- Basic Trait ---
  trait Timestamps {
      public function getCreatedAt(): string {
          return $this->createdAt;
      }
      public function touch(): void {
          $this->updatedAt = date('Y-m-d H:i:s');
      }
  }

  class User {
      use Timestamps;
      private string $createdAt;
      private string $updatedAt;
  }

  class Post {
      use Timestamps;    // same code, no inheritance needed
  }

--- Multiple Traits ---
  trait SoftDelete {
      public function softDelete(): void {
          $this->deletedAt = date('Y-m-d H:i:s');
      }
  }

  class Order {
      use Timestamps, SoftDelete;    // compose multiple traits
  }

--- Conflict Resolution ---
  trait A { public function hello() { echo 'A'; } }
  trait B { public function hello() { echo 'B'; } }

  class MyClass {
      use A, B {
          A::hello insteadof B;    // use A's hello
          B::hello as helloB;      // rename B's hello
      }
  }

--- Visibility Changes ---
  class MyClass {
      use MyTrait {
          secretMethod as protected;  // change visibility
      }
  }

--- Abstract Methods in Traits ---
  trait Validatable {
      abstract protected function rules(): array;

      public function validate(array $data): bool {
          foreach ($this->rules() as $field => $rule) {
              // validation logic
          }
          return true;
      }
  }

  class UserForm {
      use Validatable;
      protected function rules(): array {
          return ['name' => 'required', 'email' => 'email'];
      }
  }

--- Properties in Traits ---
  trait HasUUID {
      private string $uuid;

      public function generateUUID(): void {
          $this->uuid = bin2hex(random_bytes(16));
      }
  }
  // PHP traits CAN have properties (unlike most other languages)

--- Precedence ---
  Current class methods > Trait methods > Inherited methods
  If class defines same method as trait, class wins.

--- Common Laravel Traits ---
  use SoftDeletes;         // soft delete support
  use HasFactory;          // model factories
  use Notifiable;          // notification channels
  use HasApiTokens;        // Sanctum authentication
  use Searchable;          // Scout full-text search
EOF
}

cmd_scala() {
    cat << 'EOF'
=== Scala Traits ===

Scala traits are the most powerful trait implementation — supporting
mixins, linearization, and stackable modifications.

--- Basic Trait ---
  trait Greeter {
    def greet(name: String): String     // abstract
    def hello: String = "Hello!"        // default implementation
  }

  class FriendlyGreeter extends Greeter {
    def greet(name: String) = s"Hey $name!"
  }

--- Mixing In Traits ---
  trait Logger {
    def log(msg: String): Unit = println(s"[LOG] $msg")
  }

  trait Timed {
    def timed[T](block: => T): T = {
      val start = System.currentTimeMillis()
      val result = block
      println(s"Took ${System.currentTimeMillis() - start}ms")
      result
    }
  }

  // Mix in at class definition:
  class Service extends Logger with Timed { ... }

  // Mix in at instantiation:
  val svc = new Service with Logger with Timed

--- Linearization ---
  Trait order determines method resolution (last wins).

  trait A { def hello = "A" }
  trait B extends A { override def hello = "B" }
  trait C extends A { override def hello = "C" }

  class D extends B with C
  new D().hello  // "C" — rightmost trait wins

  Linearization of D: D → C → B → A → AnyRef → Any

--- Stackable Modifications ---
  abstract class IntQueue {
    def put(x: Int): Unit
    def get(): Int
  }

  trait Doubling extends IntQueue {
    abstract override def put(x: Int) = super.put(2 * x)
  }

  trait Filtering extends IntQueue {
    abstract override def put(x: Int) =
      if (x >= 0) super.put(x)
  }

  class BasicQueue extends IntQueue { /* real implementation */ }

  // Stack behaviors:
  val q = new BasicQueue with Doubling with Filtering
  q.put(5)    // Filtering passes 5, Doubling makes it 10
  q.put(-1)   // Filtering blocks it

--- Sealed Trait ---
  sealed trait Shape                     // can only be extended in same file
  case class Circle(r: Double) extends Shape
  case class Square(s: Double) extends Shape

  // Compiler warns about missing cases in pattern matching:
  def area(s: Shape) = s match {
    case Circle(r) => math.Pi * r * r
    case Square(s) => s * s
    // If we miss a case, compiler warns
  }

--- Self Types ---
  trait UserRepository {
    def findUser(id: Int): User
  }

  trait UserService { self: UserRepository =>
    // This trait requires UserRepository to be mixed in
    def greet(id: Int) = s"Hello, ${findUser(id).name}"
  }

  // Must combine both:
  class App extends UserService with UserRepository { ... }
EOF
}

cmd_kotlin() {
    cat << 'EOF'
=== Kotlin Interfaces (Trait-like) ===

Kotlin interfaces support default method implementations,
making them functionally equivalent to traits.

--- Interface with Defaults ---
  interface Clickable {
      fun click()                          // abstract
      fun showOff() = println("Clickable") // default
  }

  interface Focusable {
      fun setFocus(b: Boolean) = println("Focus: $b")
      fun showOff() = println("Focusable")
  }

  class Button : Clickable, Focusable {
      override fun click() = println("Clicked!")

      // Must resolve conflict:
      override fun showOff() {
          super<Clickable>.showOff()
          super<Focusable>.showOff()
      }
  }

--- Properties in Interfaces ---
  interface Named {
      val name: String                     // abstract property
      val greeting: String                 // computed (has getter)
          get() = "Hello, $name"
  }

  class User(override val name: String) : Named
  User("Alice").greeting  // "Hello, Alice"

--- Delegation ---
  interface Base {
      fun print()
  }

  class BaseImpl(val x: Int) : Base {
      override fun print() { println(x) }
  }

  // Delegate all Base methods to BaseImpl:
  class Derived(b: Base) : Base by b

  val derived = Derived(BaseImpl(10))
  derived.print()  // 10 — delegated to BaseImpl

  // Override specific methods:
  class Derived(b: Base) : Base by b {
      override fun print() { println("Overridden") }
  }

--- Sealed Interface (Kotlin 1.5+) ---
  sealed interface Error
  class NetworkError(val code: Int) : Error
  class DatabaseError(val msg: String) : Error

  fun handle(e: Error) = when(e) {
      is NetworkError -> "Network: ${e.code}"
      is DatabaseError -> "DB: ${e.msg}"
      // No else needed — compiler knows all subtypes
  }

--- Functional Interfaces (SAM) ---
  fun interface Predicate<T> {
      fun test(value: T): Boolean
  }

  // Lambda conversion:
  val isPositive: Predicate<Int> = Predicate { it > 0 }

--- Kotlin vs Java Interfaces ---
  Kotlin: Can have properties, default methods, no state
  Java 8+: Can have default/static methods, no state
  Kotlin: Can delegate implementation
  Java: Cannot delegate (no 'by' keyword)
  Both: Support multiple interface implementation
EOF
}

cmd_patterns() {
    cat << 'EOF'
=== Design Patterns with Traits ===

--- Extension Trait ---
  Add methods to existing types without modifying them.

  // Rust
  trait StringExt {
      fn is_blank(&self) -> bool;
  }

  impl StringExt for str {
      fn is_blank(&self) -> bool {
          self.trim().is_empty()
      }
  }
  "  ".is_blank()  // true

--- Marker Trait ---
  Trait with no methods — tags types with a capability.

  // Rust
  trait Send {}       // type can be sent across threads
  trait Sync {}       // type can be shared across threads
  trait Copy {}       // type can be bitwise copied
  trait Sized {}      // type has known size at compile time

  // Used for compile-time checks:
  fn spawn<T: Send + 'static>(task: T) { ... }

--- Sealed Trait (ADT) ---
  Restrict implementations to a closed set.

  // Rust (convention — no language-level sealed)
  mod shapes {
      pub trait Shape { fn area(&self) -> f64; }
      pub struct Circle { pub r: f64 }
      pub struct Square { pub s: f64 }
      impl Shape for Circle { fn area(&self) -> f64 { PI * self.r * self.r } }
      impl Shape for Square { fn area(&self) -> f64 { self.s * self.s } }
  }

  // Scala
  sealed trait Shape
  // Kotlin
  sealed interface Shape

--- Strategy Pattern via Traits ---
  trait Compressor {
      fn compress(&self, data: &[u8]) -> Vec<u8>;
  }

  struct GzipCompressor;
  struct LzmaCompressor;

  impl Compressor for GzipCompressor { ... }
  impl Compressor for LzmaCompressor { ... }

  fn save(data: &[u8], compressor: &dyn Compressor) {
      let compressed = compressor.compress(data);
      // ...
  }

--- Mixin Pattern (PHP/Scala) ---
  Compose behaviors from multiple traits:

  trait Cacheable   { /* caching logic */ }
  trait Loggable    { /* logging logic */ }
  trait Retryable   { /* retry logic */ }

  class ApiClient {
      use Cacheable, Loggable, Retryable;
  }
  // ApiClient gains all three behaviors without deep inheritance

--- Newtype + Trait (Rust) ---
  struct Meters(f64);
  struct Kilometers(f64);

  trait Convertible<T> {
      fn convert(&self) -> T;
  }

  impl Convertible<Kilometers> for Meters {
      fn convert(&self) -> Kilometers {
          Kilometers(self.0 / 1000.0)
      }
  }
EOF
}

cmd_generics() {
    cat << 'EOF'
=== Traits and Generics ===

--- Trait Bounds ---
  // Only accept types that implement Display
  fn print_it<T: Display>(val: T) {
      println!("{}", val);
  }

  // Multiple bounds
  fn process<T: Clone + Debug + Serialize>(val: T) { ... }

  // Where clause (cleaner)
  fn process<T>(val: T)
  where
      T: Clone + Debug + Serialize
  { ... }

--- Associated Types vs Type Parameters ---
  // Associated type — one implementation per type
  trait Iterator {
      type Item;
      fn next(&mut self) -> Option<Self::Item>;
  }
  // Vec<i32>'s iterator always yields i32 — no ambiguity

  // Type parameter — multiple implementations possible
  trait From<T> {
      fn from(val: T) -> Self;
  }
  // String can implement From<&str>, From<Vec<u8>>, From<i32>...

  Rule of thumb:
    One natural implementation → associated type
    Multiple possible implementations → type parameter

--- Generic Impl Blocks ---
  impl<T: Display> Wrapper<T> {
      fn show(&self) {
          println!("{}", self.0);
      }
  }
  // show() only available when T: Display

--- Conditional Trait Implementation ---
  impl<T: Debug> Display for Vec<T> {
      // Vec<T> implements Display only if T implements Debug
  }

--- Higher-Ranked Trait Bounds (HRTB) ---
  fn apply<F>(f: F)
  where
      F: for<'a> Fn(&'a str) -> &'a str
  {
      let s = String::from("hello");
      let result = f(&s);
  }
  // "for<'a>" means: F works for ANY lifetime 'a

--- Scala Type Classes ---
  trait Ordering[T] {
    def compare(a: T, b: T): Int
  }

  implicit val intOrd: Ordering[Int] = (a, b) => a - b

  def sort[T](list: List[T])(implicit ord: Ordering[T]): List[T] = {
    list.sortWith((a, b) => ord.compare(a, b) < 0)
  }

  sort(List(3, 1, 2))  // implicit intOrd used automatically

--- Haskell Type Classes ---
  class Eq a where
    (==) :: a -> a -> Bool

  instance Eq Bool where
    True  == True  = True
    False == False = True
    _     == _     = False

  -- Haskell type classes are the origin of traits/interfaces
  -- Rust's trait system is heavily inspired by Haskell
EOF
}

cmd_comparison() {
    cat << 'EOF'
=== Trait Features Across Languages ===

┌────────────────┬───────┬───────┬───────┬────────┬───────┬─────────┐
│ Feature        │ Rust  │ PHP   │ Scala │ Kotlin │ Swift │ Haskell │
├────────────────┼───────┼───────┼───────┼────────┼───────┼─────────┤
│ Name           │ trait │ trait │ trait │ interf │ proto │ class   │
│ Default methods│ Yes   │ Yes   │ Yes   │ Yes    │ Ext   │ Yes     │
│ Abstract methods│ Yes  │ Yes   │ Yes   │ Yes    │ Yes   │ Yes     │
│ Properties     │ No    │ Yes   │ Yes   │ Yes    │ Yes   │ No      │
│ Multiple       │ Yes   │ Yes   │ Yes   │ Yes    │ Yes   │ Yes     │
│ Conflict res.  │ Error │Manual │ Linear│ Manual │ N/A   │ N/A     │
│ Static dispatch│ Yes   │ N/A   │ Yes   │ Yes    │ Yes   │ Yes     │
│ Dynamic dispatch│ dyn  │ Always│ Yes   │ Yes    │ Yes   │ Existnt │
│ Associated types│ Yes  │ No    │ Yes   │ No     │ Yes   │ Yes     │
│ Sealed         │ Conv  │ No    │ Yes   │ Yes    │ No    │ No      │
│ Delegation     │ No    │ No    │ No    │ by     │ No    │ newtype │
│ Orphan rule    │ Yes   │ No    │ No    │ No     │ No    │ Yes     │
│ Coherence      │ Yes   │ N/A   │ No    │ N/A    │ No    │ Global  │
└────────────────┴───────┴───────┴───────┴────────┴───────┴─────────┘

Terminology Mapping:
  Rust:     trait
  PHP:      trait
  Scala:    trait
  Kotlin:   interface (with default methods)
  Swift:    protocol (with extensions)
  Haskell:  type class
  Go:       interface (implicit, no defaults)
  Java:     interface (with default methods since Java 8)
  C++:      concepts (C++20) + abstract classes
  Python:   ABC (Abstract Base Class) + protocols
  TypeScript: interface (structural typing)

Choosing the Right Abstraction:
  Need shared behavior, no state → trait/interface
  Need shared state + behavior → abstract class (if available)
  Need horizontal reuse across unrelated types → trait
  Need compile-time polymorphism → trait bounds (Rust/Haskell)
  Need runtime polymorphism → trait objects/existentials
  Need closed set of variants → sealed trait/enum
EOF
}

show_help() {
    cat << EOF
trait v$VERSION — Trait & Interface Reference

Usage: script.sh <command>

Commands:
  intro        Traits overview, trait vs interface vs abstract class
  rust         Rust traits: impl, bounds, dyn, derives, orphan rule
  php          PHP traits: horizontal reuse, conflict resolution
  scala        Scala traits: mixins, linearization, stackable mods
  kotlin       Kotlin interfaces: defaults, delegation, sealed
  patterns     Design patterns: extension, marker, sealed, strategy
  generics     Trait bounds, associated types, type classes
  comparison   Trait features across Rust, PHP, Scala, Kotlin, Swift
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    rust)       cmd_rust ;;
    php)        cmd_php ;;
    scala)      cmd_scala ;;
    kotlin)     cmd_kotlin ;;
    patterns)   cmd_patterns ;;
    generics)   cmd_generics ;;
    comparison) cmd_comparison ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "trait v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
