#!/usr/bin/env bash
# unwrap — Value Extraction Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Unwrapping ===

Unwrapping extracts the inner value from a wrapper type that may
or may not contain a value (Option, Result, Optional, Maybe).

Why Wrapper Types Exist:
  The "billion dollar mistake" — Tony Hoare on inventing null (1965).
  Null references cause crashes, NPEs, undefined behavior.

  Wrapper types force you to handle the absence case:
    Option<T>  = Some(value) | None
    Result<T,E> = Ok(value) | Err(error)

  You can't accidentally use a value that might not exist.

Safe vs Unsafe Unwrapping:
  Unsafe:    .unwrap()  — panics/crashes if value is absent
  Safe:      .unwrap_or(default)  — returns fallback
  Explicit:  match/if-let  — handle both cases
  Propagate: ? operator — pass absence to caller

  Rule: Use unsafe unwrap ONLY when you've logically proven
        the value must exist, and add a comment explaining why.

Wrapper Types by Language:
  Rust:        Option<T>, Result<T, E>
  Swift:       T? (Optional<T>)
  Kotlin:      T? (nullable type)
  Haskell:     Maybe a, Either e a
  Scala:       Option[T], Either[E, T], Try[T]
  Java:        Optional<T>
  C++:         std::optional<T> (C++17)
  TypeScript:  T | null | undefined
  Python:      Optional[T] (type hint only, not enforced)
  Go:          (T, error) tuple (convention, not type)
  C#:          T? (Nullable<T> or reference null)

The Unwrap Spectrum:
  Most dangerous ← ───────────────── → Safest
  .unwrap()   force!   !!   .get()   match   map/flatMap   ?
  Panics      Crashes  NPE  Maybe    Handle  Transform     Propagate
EOF
}

cmd_rust() {
    cat << 'EOF'
=== Rust Unwrap ===

--- Option<T> Methods ---
  let x: Option<i32> = Some(42);
  let y: Option<i32> = None;

  // UNSAFE: panics on None
  x.unwrap()                     // 42
  y.unwrap()                     // PANIC! "called unwrap on None"

  // With panic message:
  x.expect("value must exist")   // 42
  y.expect("value must exist")   // PANIC with custom message

  // Safe alternatives:
  x.unwrap_or(0)                 // 42 (has value)
  y.unwrap_or(0)                 // 0  (fallback)

  x.unwrap_or_default()          // 42 (has value)
  y.unwrap_or_default()          // 0  (i32::default())

  x.unwrap_or_else(|| expensive_computation())
  // Lazy: only computes fallback if None

--- Result<T, E> Methods ---
  let ok: Result<i32, String> = Ok(42);
  let err: Result<i32, String> = Err("failed".into());

  ok.unwrap()                    // 42
  err.unwrap()                   // PANIC with error message

  ok.unwrap_err()                // PANIC (it's Ok, not Err)
  err.unwrap_err()               // "failed"

  ok.unwrap_or(0)                // 42
  err.unwrap_or(0)               // 0

--- The ? Operator (Propagation) ---
  fn read_config() -> Result<Config, io::Error> {
      let content = fs::read_to_string("config.toml")?;
      // If Err → return Err immediately
      // If Ok → unwrap and continue
      let config = parse_toml(&content)?;
      Ok(config)
  }

  // ? works on Option too (in functions returning Option):
  fn get_name(user: &Option<User>) -> Option<&str> {
      Some(user.as_ref()?.profile.as_ref()?.name.as_str())
  }

--- Pattern Matching (Most Explicit) ---
  match result {
      Ok(value) => println!("Got: {}", value),
      Err(e) => eprintln!("Error: {}", e),
  }

  // if let (when you only care about one variant):
  if let Some(value) = maybe_value {
      println!("Got: {}", value);
  }

  // let-else (Rust 1.65+):
  let Some(value) = maybe_value else {
      return Err("missing value");
  };
  // value is unwrapped here, guaranteed to exist

--- Combinators ---
  option.map(|v| v * 2)          // Some(42) → Some(84), None → None
  option.and_then(|v| lookup(v)) // flatMap: chain fallible operations
  option.filter(|v| v > &10)     // Some(42) → Some(42), Some(5) → None
  option.or(other_option)        // use other if self is None
  option.zip(other)              // Some((a, b)) if both are Some
  option.flatten()               // Some(Some(42)) → Some(42)

--- When .unwrap() is OK ---
  // 1. After explicit check:
  assert!(option.is_some());
  option.unwrap()  // logically safe

  // 2. In tests:
  #[test]
  fn test_parse() {
      let result = parse("42").unwrap();  // panic = test failure
  }

  // 3. Infallible case (you can prove it):
  let n: u32 = "42".parse().unwrap();  // we know "42" is valid
  // Better: add comment explaining WHY it can't fail
EOF
}

cmd_swift() {
    cat << 'EOF'
=== Swift Optionals ===

--- Declaration ---
  var name: String? = "Alice"     // Optional<String>
  var age: Int? = nil              // no value

--- Force Unwrap (!) ---
  let value = name!               // "Alice"
  let crash = age!                // FATAL ERROR: unexpectedly nil

  ⚠ Use force unwrap ONLY when you're certain value exists.
  Prefer safe alternatives below.

--- Optional Binding (if let) ---
  if let name = name {
      print("Hello, \(name)")     // name is String (unwrapped)
  } else {
      print("No name")
  }

  // Multiple bindings:
  if let name = name, let age = age, age > 18 {
      print("\(name) is \(age) years old")
  }

--- Guard Let (Early Return) ---
  func greet(name: String?) -> String {
      guard let name = name else {
          return "Hello, stranger"
      }
      // name is unwrapped for the rest of the function
      return "Hello, \(name)"
  }

--- Optional Chaining (?.) ---
  struct User { var address: Address? }
  struct Address { var city: String? }

  let city = user?.address?.city
  // Type: String? — if any link is nil, result is nil

  // Method chaining:
  let uppercased = user?.address?.city?.uppercased()

--- Nil Coalescing (??) ---
  let displayName = name ?? "Anonymous"
  // Use name if non-nil, otherwise "Anonymous"

  // Chaining:
  let value = primary ?? secondary ?? defaultValue

--- Map and FlatMap ---
  let length = name.map { $0.count }
  // Optional<Int> — Some(5) if name is "Alice", nil if name is nil

  let parsed = string.flatMap { Int($0) }
  // flatMap: avoids Optional<Optional<Int>>

--- Implicitly Unwrapped Optionals (T!) ---
  var label: UILabel!             // declared nil, expected to be set
  label.text = "Hello"            // no ? needed, but crashes if nil

  Use ONLY for:
    - @IBOutlet connections (set by storyboard)
    - Properties initialized in setup but not constructor
  Avoid everywhere else.

--- switch/case Pattern Matching ---
  switch optionalValue {
  case .some(let value):
      print("Value: \(value)")
  case .none:
      print("No value")
  }

  // Or:
  switch optionalValue {
  case let value?:               // shorthand for .some(let value)
      print("Value: \(value)")
  case nil:
      print("No value")
  }
EOF
}

cmd_kotlin() {
    cat << 'EOF'
=== Kotlin Null Safety ===

--- Nullable Types ---
  var name: String = "Alice"      // non-null, always has value
  var age: Int? = null             // nullable

  name = null                      // COMPILE ERROR!
  age = null                       // OK

--- Safe Call (?.) ---
  val length: Int? = name?.length
  // If name is null → null (no crash)
  // If name is "Alice" → 5

  // Chaining:
  val city: String? = user?.address?.city?.uppercase()

--- Elvis Operator (?:) ---
  val displayName = name ?: "Anonymous"
  // Use name if non-null, otherwise "Anonymous"

  // With throw/return:
  val value = input ?: throw IllegalArgumentException("required")
  val user = findUser(id) ?: return null

--- Force Unwrap (!!) ---
  val length: Int = name!!.length
  // Throws NullPointerException if null

  ⚠ Avoid !! in production code. Use safe alternatives.

--- Let (Scoped Null Check) ---
  name?.let { nonNullName ->
      println("Hello, $nonNullName")
      // nonNullName is guaranteed non-null
  }

  // With also, apply, run:
  user?.also { println("Found: ${it.name}") }
  user?.run { "Hello, $name" }  // this = user inside block

--- Smart Casts ---
  if (name != null) {
      println(name.length)       // auto-cast to String (non-null)
  }

  // Works with when:
  when (value) {
      is String -> println(value.length)  // smart-cast to String
      is Int -> println(value + 1)
      null -> println("null")
  }

  // val makes smart casts reliable; var may change between check and use

--- Safe Casts (as?) ---
  val number: Int? = value as? Int
  // null if cast fails, instead of ClassCastException

--- Platform Types (Java Interop) ---
  // Java methods return "platform types" (T!)
  // Kotlin doesn't know if it's nullable
  val result: String = javaMethod()  // may crash at runtime!

  // Always annotate Java return types:
  val result: String? = javaMethod() // safe

--- Collection Null Safety ---
  val list: List<String>   // non-null list of non-null strings
  val list: List<String?>  // non-null list of nullable strings
  val list: List<String>?  // nullable list of non-null strings
  val list: List<String?>? // nullable list of nullable strings

  list?.filterNotNull()    // remove nulls safely
  list.mapNotNull { it.toIntOrNull() }  // transform + filter nulls
EOF
}

cmd_typescript() {
    cat << 'EOF'
=== TypeScript Null Handling ===

--- Optional Chaining (?.) ---
  const city = user?.address?.city;
  // undefined if any link is nullish

  // Method call:
  const upper = user?.getName?.();

  // Array access:
  const first = arr?.[0];

--- Nullish Coalescing (??) ---
  const name = user.name ?? "Anonymous";
  // Only triggers on null/undefined (NOT on "" or 0)

  // vs || (logical OR):
  "" || "default"      // "default" (empty string is falsy!)
  "" ?? "default"      // ""        (?? only checks null/undefined)
  0 || 42              // 42        (0 is falsy!)
  0 ?? 42              // 0         (?? keeps 0)

--- Non-null Assertion (!) ---
  const el = document.getElementById('app')!;
  // Tells compiler: "I know this isn't null"
  // RUNTIME: no check! Can crash if actually null.
  // Use sparingly, prefer type guards.

--- Type Guards ---
  function isString(x: unknown): x is string {
      return typeof x === 'string';
  }

  if (isString(value)) {
      console.log(value.toUpperCase());  // type narrowed to string
  }

  // typeof guard:
  if (typeof x === 'number') { /* x is number */ }

  // instanceof guard:
  if (error instanceof TypeError) { /* error is TypeError */ }

  // truthiness guard:
  if (user) { /* user is non-null */ }

  // in guard:
  if ('name' in obj) { /* obj has name property */ }

--- Strict Null Checks ---
  // tsconfig.json: "strictNullChecks": true
  // With this enabled:
  function greet(name: string | null) {
      console.log(name.length);      // ERROR! name might be null
      console.log(name?.length);     // OK: number | undefined
      if (name) console.log(name.length);  // OK: narrowed
  }

--- satisfies + as const ---
  const config = {
      port: 3000,
      host: null as string | null,
  } as const satisfies Config;

  // Later:
  config.host?.toUpperCase();  // properly typed as nullable

--- Assertion Functions (TS 3.7+) ---
  function assertDefined<T>(val: T | null | undefined): asserts val is T {
      if (val == null) throw new Error('Expected value');
  }

  assertDefined(user);
  // After this line, user is typed as non-null
  console.log(user.name);  // no error
EOF
}

cmd_functional() {
    cat << 'EOF'
=== Monadic Unwrapping ===

--- The Monad Pattern ---
  A monad wraps a value and provides:
    map:     Transform the inner value (if present)
    flatMap: Transform and flatten (avoid nesting)
    fold:    Extract with handler for each case

  Think of it as a "value in a box":
    Some(42).map(x => x * 2)     → Some(84)
    None.map(x => x * 2)         → None  (skip, stay None)

--- map (Transform Without Unwrapping) ---
  Rust:     option.map(|x| x * 2)
  Swift:    optional.map { $0 * 2 }
  Kotlin:   nullable?.let { it * 2 }
  Scala:    option.map(_ * 2)
  Haskell:  fmap (*2) maybeValue
  Java:     optional.map(x -> x * 2)

  map applies the function only if value is present.
  Result is still wrapped: Option<T> → Option<U>

--- flatMap/andThen (Chain Fallible Operations) ---
  Rust:     option.and_then(|x| lookup(x))
  Swift:    optional.flatMap { lookup($0) }
  Scala:    option.flatMap(lookup)
  Haskell:  maybeValue >>= lookup
  Java:     optional.flatMap(x -> lookup(x))

  Prevents nesting: Option<Option<T>> → Option<T>

  // Without flatMap:
  let result = map(option, lookup);  // Some(Some("value")) — nested!
  // With flatMap:
  let result = flatMap(option, lookup);  // Some("value") — flat!

--- fold/match (Extract with Both Handlers) ---
  Rust:
    match option {
        Some(v) => format!("Got {}", v),
        None => "Nothing".to_string(),
    }

  Scala:
    option.fold("Nothing")(v => s"Got $v")

  Kotlin:
    value?.let { "Got $it" } ?: "Nothing"

  Haskell:
    maybe "Nothing" (\v -> "Got " ++ show v) maybeValue

--- For-Comprehension (Chaining Multiple) ---
  Scala:
    for {
      user  <- findUser(id)
      addr  <- user.address
      city  <- addr.city
    } yield city.toUpperCase
    // If any step returns None, whole thing is None

  Rust:
    let city = find_user(id)
        .and_then(|u| u.address)
        .and_then(|a| a.city)
        .map(|c| c.to_uppercase());

  Haskell:
    do
      user <- findUser id
      addr <- address user
      city <- city addr
      return (toUpper city)

--- Result Chaining ---
  fn process() -> Result<Output, Error> {
      let data = fetch()?          // unwrap or return Err
          .validate()?              // chain of fallible operations
          .transform()?
          .save()?;
      Ok(data)
  }

  Each ? is an implicit unwrap-or-propagate.
  The "happy path" reads like straight-line code.
EOF
}

cmd_antipatterns() {
    cat << 'EOF'
=== Unwrap Anti-Patterns ===

1. Bare unwrap() in Production
   Problem: Panics crash the application
   BAD:   let value = map.get("key").unwrap();
   GOOD:  let value = map.get("key").unwrap_or(&default);
   BEST:  let value = map.get("key").context("key not found")?;

2. Force Unwrap After Null Check (Redundant)
   BAD:
     if (value != null) {
         doSomething(value!!);    // !! is redundant after null check
     }
   GOOD:
     value?.let { doSomething(it) }
   Or:
     if (value != null) {
         doSomething(value);      // smart cast handles it
     }

3. Swallowed Errors
   BAD:
     let result = operation().unwrap_or_default();
     // Error silently becomes default — you'll never know it failed
   GOOD:
     let result = operation().map_err(|e| {
         log::warn!("operation failed: {}", e);
         e
     }).unwrap_or_default();

4. Pyramid of Doom
   BAD:
     if let Some(a) = get_a() {
         if let Some(b) = get_b(a) {
             if let Some(c) = get_c(b) {
                 process(c);
             }
         }
     }
   GOOD:
     let c = get_a()
         .and_then(get_b)
         .and_then(get_c);
     if let Some(c) = c { process(c); }

5. try! Everywhere (Rust Legacy)
   try! macro is deprecated. Use ? operator instead.
   BAD:   let val = try!(operation());
   GOOD:  let val = operation()?;

6. Optional.get() Without isPresent() (Java)
   BAD:   String name = optional.get();  // NoSuchElementException
   GOOD:  String name = optional.orElse("default");

7. Using Exceptions for Flow Control
   BAD:
     try { return map.get(key).unwrap(); }
     catch { return default; }
   GOOD:
     return map.get(key).unwrap_or(default);

8. Ignoring Result<> (Rust)
   BAD:   fs::remove_file("temp.txt");  // Result ignored!
   GOOD:  fs::remove_file("temp.txt")?; // propagate
   OR:    let _ = fs::remove_file("temp.txt"); // explicitly ignore
EOF
}

cmd_strategies() {
    cat << 'EOF'
=== Safe Unwrapping Strategies ===

--- Strategy 1: Provide Defaults ---
  Rust:   value.unwrap_or(0)
  Swift:  value ?? 0
  Kotlin: value ?: 0
  TS:     value ?? 0

  Use when: a sensible default exists.
  Best for: display values, configuration, non-critical data.

--- Strategy 2: Early Return ---
  Rust:
    let value = option?;           // return None early
    let value = result?;           // return Err early

  Swift:
    guard let value = optional else { return }

  Go:
    val, err := operation()
    if err != nil { return err }

  Use when: function should fail fast if value is missing.

--- Strategy 3: Map/Transform ---
  let greeting = name.map(|n| format!("Hello, {}", n));
  // Keep the value wrapped, transform inside
  // Defer unwrapping to the last possible moment

  Use when: you can keep working with the wrapped value.

--- Strategy 4: Validate at Boundaries ---
  Parse and validate data at system boundaries.
  After validation, use non-optional types internally.

  // At the API boundary:
  fn parse_request(json: Value) -> Result<ValidRequest, Error> {
      let name = json["name"].as_str()
          .ok_or(Error::MissingField("name"))?;
      let age = json["age"].as_u64()
          .ok_or(Error::MissingField("age"))?;
      Ok(ValidRequest { name: name.into(), age })
  }
  // Inside the system: ValidRequest has guaranteed fields

--- Strategy 5: Provide Context ---
  Rust (anyhow):
    let file = fs::read_to_string(path)
        .with_context(|| format!("failed to read {}", path))?;

  Better error messages > bare unwrap panics.

--- Strategy 6: Builder Pattern ---
  Collect optional values, validate all at once:

  struct UserBuilder {
      name: Option<String>,
      email: Option<String>,
  }

  impl UserBuilder {
      fn build(self) -> Result<User, Vec<&str>> {
          let mut errors = vec![];
          if self.name.is_none() { errors.push("name required"); }
          if self.email.is_none() { errors.push("email required"); }
          if !errors.is_empty() { return Err(errors); }
          Ok(User {
              name: self.name.unwrap(),   // safe: checked above
              email: self.email.unwrap(),
          })
      }
  }

--- Strategy 7: Type-State Pattern ---
  Use the type system to make unwrapping unnecessary:
  struct Unvalidated;
  struct Validated;
  struct Form<State> { data: String, _s: PhantomData<State> }

  // Only validated forms can be submitted:
  impl Form<Validated> {
      fn submit(&self) { /* guaranteed valid */ }
  }
EOF
}

show_help() {
    cat << EOF
unwrap v$VERSION — Value Extraction Reference

Usage: script.sh <command>

Commands:
  intro        What unwrapping is, wrapper types by language
  rust         Rust Option/Result: unwrap, expect, ?, combinators
  swift        Swift optionals: if-let, guard-let, ?, ??
  kotlin       Kotlin null safety: ?., !!, let, Elvis, smart casts
  typescript   TS: optional chaining, ??, type guards, assertions
  functional   Monadic unwrap: map, flatMap, fold, for-comprehension
  antipatterns Bare unwrap, swallowed errors, pyramid of doom
  strategies   Safe unwrapping: defaults, early return, validation
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)        cmd_intro ;;
    rust)         cmd_rust ;;
    swift)        cmd_swift ;;
    kotlin)       cmd_kotlin ;;
    typescript|ts) cmd_typescript ;;
    functional)   cmd_functional ;;
    antipatterns) cmd_antipatterns ;;
    strategies)   cmd_strategies ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "unwrap v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
