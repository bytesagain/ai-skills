#!/usr/bin/env bash
# mixin — Mixin Pattern Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Mixin Pattern ===

A mixin is a class or object whose methods are meant to be "mixed into"
other classes, providing reusable behavior without using inheritance.

Core Idea:
  Inheritance: "is-a" relationship (Dog IS-A Animal)
  Mixin:       "has-a" capability (Dog HAS Serializable behavior)
  Composition over inheritance

Why Mixins Exist:
  Single inheritance languages can't share behavior across
  unrelated class hierarchies.
  
  Problem: Bird can fly. Airplane can fly. But Bird IS-A Animal,
  Airplane IS-A Vehicle. Can't share "fly" via inheritance.
  
  Solution: Flyable mixin — mix flight behavior into both.

History:
  1980    Flavors (Lisp) introduces mixins
  1990s   Ruby popularizes via modules (include/extend)
  2000s   Python uses cooperative multiple inheritance
  2010s   JavaScript adopts pattern via Object.assign / class
  2015    Rust formalizes as traits (no state, just behavior)

Mixin vs Related Concepts:
  Mixin:       reusable behavior, may include state
  Trait:       reusable behavior, no state (Rust, Scala)
  Interface:   contract only, no implementation (Java, TypeScript)
  Abstract:    partial implementation, requires subclassing
  Protocol:    structural typing / duck typing (Go, Python)
  Delegation:  forward calls to composed object

Key Benefits:
  - Flat composition (no deep hierarchies)
  - Mix multiple behaviors into one class
  - Easy to add/remove capabilities
  - Behaviors testable in isolation

Key Risks:
  - Name collisions between mixins
  - Implicit dependencies between mixins
  - Ordering-dependent behavior
  - Can become "inheritance in disguise"
EOF
}

cmd_javascript() {
    cat << 'EOF'
=== JavaScript Mixin Patterns ===

Pattern 1: Object.assign (simplest):
  const Serializable = {
    serialize() { return JSON.stringify(this); },
    deserialize(json) { Object.assign(this, JSON.parse(json)); }
  };

  const Timestamped = {
    touch() { this.updatedAt = Date.now(); },
    getAge() { return Date.now() - this.createdAt; }
  };

  class User {
    constructor(name) { this.name = name; this.createdAt = Date.now(); }
  }
  Object.assign(User.prototype, Serializable, Timestamped);

  Pros: simple, no inheritance
  Cons: no super() chain, last-write-wins on conflicts

Pattern 2: Class Expression Mixin (subclass factory):
  const Serializable = (Base) => class extends Base {
    serialize() { return JSON.stringify(this); }
  };

  const Timestamped = (Base) => class extends Base {
    touch() { this.updatedAt = Date.now(); }
  };

  class User extends Serializable(Timestamped(BaseClass)) {
    constructor(name) { super(); this.name = name; }
  }

  Pros: instanceof works, super() chain works
  Cons: creates deep prototype chain, ordering matters

Pattern 3: Symbol-based (avoid name collision):
  const serialize = Symbol('serialize');
  const Serializable = {
    [serialize]() { return JSON.stringify(this); }
  };
  // Access: obj[serialize]()
  // No collision with other mixins

Pattern 4: WeakMap for private mixin state:
  const _state = new WeakMap();
  const Stateful = {
    initState(defaults) { _state.set(this, { ...defaults }); },
    getState(key) { return _state.get(this)?.[key]; },
    setState(key, val) {
      const s = _state.get(this) || {};
      s[key] = val;
      _state.set(this, s);
    }
  };

TypeScript Mixin Pattern:
  type Constructor<T = {}> = new (...args: any[]) => T;

  function Timestamped<TBase extends Constructor>(Base: TBase) {
    return class extends Base {
      createdAt = Date.now();
      touch() { this.updatedAt = Date.now(); }
    };
  }
  // Proper type inference for mixed-in methods
EOF
}

cmd_python() {
    cat << 'EOF'
=== Python Mixins & MRO ===

Python Mixin Convention:
  - Name ends with "Mixin" (ReadableMixin, SerializableMixin)
  - Should not be instantiated directly
  - Provides methods, not __init__ (usually)
  - Uses cooperative super() calls

Basic Mixin:
  class JsonMixin:
      def to_json(self):
          import json
          return json.dumps(self.__dict__)

      @classmethod
      def from_json(cls, json_str):
          import json
          return cls(**json.loads(json_str))

  class LogMixin:
      def log(self, message):
          print(f"[{self.__class__.__name__}] {message}")

  class User(JsonMixin, LogMixin):
      def __init__(self, name, email):
          self.name = name
          self.email = email

MRO (Method Resolution Order):
  Python uses C3 Linearization:
    class A: pass
    class B(A): pass
    class C(A): pass
    class D(B, C): pass

    D.mro() → [D, B, C, A, object]
    (left-to-right, depth-first, but C3 prevents duplicates)

  Rules:
    - Children come before parents
    - Left parents come before right parents
    - Order is consistent (monotonic)

Cooperative super():
  class SaveMixin:
      def save(self):
          print("SaveMixin.save")
          super().save()  # calls next in MRO

  class ValidateMixin:
      def save(self):
          print("ValidateMixin.save")
          self.validate()
          super().save()  # calls next in MRO

  class LogMixin:
      def save(self):
          print("LogMixin.save")
          super().save()  # calls next in MRO

  class Model:
      def save(self):
          print("Model.save — writing to DB")

  class User(SaveMixin, ValidateMixin, LogMixin, Model):
      pass

  User().save()
  # SaveMixin.save → ValidateMixin.save → LogMixin.save → Model.save
  # super() follows MRO, not parent class!

Django Mixin Examples:
  LoginRequiredMixin     → require authentication
  PermissionRequiredMixin → check permissions
  FormMixin              → form handling
  ListView, DetailView   → composed from multiple mixins

  class UserListView(LoginRequiredMixin, PermissionRequiredMixin, ListView):
      model = User
      permission_required = 'users.view_user'

Common Pitfall:
  If __init__ needs arguments, mixins must use **kwargs:
    class TimestampMixin:
        def __init__(self, **kwargs):
            super().__init__(**kwargs)
            self.created_at = datetime.now()
  This ensures cooperative __init__ works across the MRO chain.
EOF
}

cmd_traits() {
    cat << 'EOF'
=== Trait Systems ===

Rust Traits:
  Define shared behavior (like interfaces with default methods)
  No state — only method signatures and default implementations

  trait Printable {
      fn format(&self) -> String;  // required
      fn print(&self) {            // default implementation
          println!("{}", self.format());
      }
  }

  struct Point { x: f64, y: f64 }

  impl Printable for Point {
      fn format(&self) -> String {
          format!("({}, {})", self.x, self.y)
      }
      // print() uses default implementation
  }

  Trait bounds (generic constraints):
    fn process<T: Printable + Clone>(item: T) { ... }
    // T must implement both Printable and Clone

  Orphan rule: can only implement trait if you own trait OR type
  Prevents conflicting implementations from different crates

Scala Traits:
  Can contain both abstract and concrete methods AND state
  Mixed in with `extends` (first) and `with` (additional)

  trait Greeting {
    val name: String  // abstract (no value)
    def greet(): String = s"Hello, $name"  // concrete
  }

  trait Farewell {
    val name: String
    def bye(): String = s"Goodbye, $name"
  }

  class Person(val name: String) extends Greeting with Farewell

  Linearization: rightmost trait wins on conflict
  Stackable modifications: override + super pattern

PHP Traits:
  Horizontal code reuse (copy-paste by compiler)

  trait Timestampable {
      public $createdAt;
      public function touch() { $this->createdAt = time(); }
  }

  trait SoftDeletable {
      public $deletedAt;
      public function softDelete() { $this->deletedAt = time(); }
  }

  class Post {
      use Timestampable, SoftDeletable;
  }

  Conflict resolution:
    use A, B {
        A::method insteadof B;  // A's version wins
        B::method as aliasMethod;  // B's version renamed
    }

  Visibility override:
    use A { method as protected; }

Kotlin: no explicit traits, uses interfaces with default methods
  interface Clickable {
    fun click()  // abstract
    fun showOff() = println("Clickable!")  // default
  }

Swift Protocols with Extensions:
  protocol Describable {
    var description: String { get }
  }
  extension Describable {
    func describe() { print(description) }  // default impl
  }
  // Protocol-oriented programming: prefer protocols over classes
EOF
}

cmd_diamond() {
    cat << 'EOF'
=== The Diamond Problem ===

What Is It?
  Class D inherits from B and C, both inherit from A
  If A defines method m(), B and C override it differently
  Which version does D get?

      A (m)
     / \
    B   C
  (m) (m)
     \ /
      D
      ?

Resolution by Language:

  C++: explicit disambiguation required
    class D : public B, public C {
      void m() { B::m(); }  // or C::m() — programmer decides
    };
    // Can also use virtual inheritance to share single A instance

  Python: C3 Linearization (MRO)
    class D(B, C): pass
    D.mro() → [D, B, C, A, object]
    D().m() calls B.m() (leftmost parent wins)
    super().m() follows MRO chain: B → C → A

  Ruby: last include wins
    class D
      include B  # mixed in first
      include C  # mixed in second — C's methods take precedence
    end
    Method lookup: D → C → B → ... (reverse include order)

  Scala: rightmost trait wins + linearization
    class D extends A with B with C
    Linearization: D → C → B → A
    C's method takes precedence (rightmost)

  Rust: no diamond problem by design
    Traits have no state, methods disambiguated:
    <D as TraitB>::method(d)  // explicitly choose trait

  JavaScript: no native multiple inheritance
    Class expression mixins create linear chain (no diamond)
    Object.assign: last source wins (like Python dict merge)

Best Practices:
  1. Avoid deep mixin hierarchies (keep it flat)
  2. Use explicit method resolution when available
  3. Prefer composition over mixin chains
  4. Name mixin methods descriptively to avoid collisions
  5. Document expected MRO behavior
  6. Test with multiple mixin orderings
EOF
}

cmd_functional() {
    cat << 'EOF'
=== Functional Mixins ===

Concept:
  Functions that take an object and return an enhanced object
  No classes, no prototypes — pure function composition

Basic Functional Mixin (JavaScript):
  const withLogging = (obj) => ({
    ...obj,
    log(msg) { console.log(`[${obj.name}] ${msg}`); }
  });

  const withTimestamp = (obj) => ({
    ...obj,
    createdAt: Date.now(),
    getAge() { return Date.now() - this.createdAt; }
  });

  const createUser = (name) =>
    withTimestamp(withLogging({ name }));

  const user = createUser('Alice');
  user.log('hello');    // [Alice] hello
  user.getAge();        // milliseconds since creation

Pipe/Compose Pattern:
  const pipe = (...fns) => (x) => fns.reduce((v, f) => f(v), x);

  const createEntity = pipe(
    withId,
    withTimestamp,
    withLogging,
    withValidation
  );

  const user = createEntity({ name: 'Bob', type: 'user' });

Stampit (library for functional mixins):
  const Timestamped = stampit({
    init() { this.createdAt = Date.now(); },
    methods: {
      getAge() { return Date.now() - this.createdAt; }
    }
  });

  const Serializable = stampit({
    methods: {
      serialize() { return JSON.stringify(this); }
    }
  });

  const Entity = stampit(Timestamped, Serializable, {
    props: { type: 'entity' }
  });

  const entity = Entity({ name: 'test' });

Factory Function Pattern:
  function createWithAbilities(...mixins) {
    return function factory(initialState) {
      const instance = { ...initialState };
      for (const mixin of mixins) {
        Object.assign(instance, mixin(instance));
      }
      return instance;
    };
  }

  const createPlayer = createWithAbilities(
    withHealth,
    withPosition,
    withInventory,
    withCombat
  );

Advantages over class mixins:
  - No inheritance, no prototype chain
  - No `this` binding issues
  - Easy to test (pure functions)
  - No diamond problem
  - Works with any object shape

Disadvantages:
  - No instanceof checks
  - Object spread creates copies (memory)
  - No private state via closures (unless using factory closures)
  - Less IDE support (no class-based autocomplete)
EOF
}

cmd_realworld() {
    cat << 'EOF'
=== Real-World Mixin Examples ===

Serializable Mixin:
  Purpose: convert object to/from JSON, XML, YAML
  Methods: serialize(), deserialize(), toJSON(), fromJSON()
  Used in: ORMs, API clients, configuration objects
  Concerns: handle circular references, date serialization,
            BigInt, undefined vs null

Comparable Mixin:
  Purpose: enable ordering and comparison operations
  Methods: compareTo(), equals(), lessThan(), greaterThan()
  Used in: sorted collections, search algorithms
  Example: implement compareTo(), get <, >, <=, >= for free
  
  Python: __lt__, __le__, __gt__, __ge__, __eq__
  @functools.total_ordering — implement __eq__ + __lt__, get rest free

Observable (EventEmitter) Mixin:
  Purpose: publish-subscribe pattern
  Methods: on(), off(), emit(), once()
  Used in: UI frameworks, state management, game engines
  
  Implementation core:
    _listeners = new Map()
    on(event, fn)   → add to listeners[event]
    off(event, fn)  → remove from listeners[event]
    emit(event, data) → call all listeners[event] with data

Validatable Mixin:
  Purpose: validate object state before operations
  Methods: validate(), isValid(), getErrors()
  Used in: form models, API request/response objects, ORMs
  Pattern: define validation rules, check() method runs them all

Cacheable Mixin:
  Purpose: memoize expensive method results
  Methods: cached(), invalidateCache(), getCacheKey()
  Used in: API clients, computed properties, database queries
  Pattern: WeakMap or Map keyed by arguments, TTL expiration

Loggable Mixin:
  Purpose: structured logging with context
  Methods: log(), warn(), error(), withContext()
  Used in: services, middleware, background jobs
  Pattern: automatically include class name, timestamp, request ID

Cloneable Mixin:
  Purpose: create deep or shallow copies
  Methods: clone(), deepClone(), copyWith()
  Used in: immutable state patterns, undo/redo systems
  Concerns: circular references, prototype preservation

Persistable Mixin (ActiveRecord-style):
  Purpose: save/load objects from storage
  Methods: save(), reload(), destroy(), isDirty()
  Used in: ORMs (Ruby on Rails, Django)
  Pattern: track changed fields, generate SQL/queries
EOF
}

cmd_antipatterns() {
    cat << 'EOF'
=== Mixin Anti-Patterns ===

1. God Mixin:
  A mixin that does too many things
  If your mixin has 20+ methods, split it into focused mixins
  Each mixin should have a single, clear responsibility

2. Implicit Dependencies:
  Mixin A requires methods from Mixin B but doesn't declare it
    class WithSave:
        def save(self):
            self.validate()  # Where does validate() come from?!
  Fix: document requirements, use abstract methods, or check existence

3. State Pollution:
  Mixin adds many properties to the host object
  Properties may collide with host or other mixins
  Fix: namespace mixin state (this._serializableConfig = {})

4. Order-Dependent Mixins:
  Behavior changes based on mixin application order
    Mixin A and B both define method m()
    class X extends A(B(Base))  vs  class X extends B(A(Base))
    These do different things! Fragile.
  Fix: avoid method name overlap, document ordering requirements

5. Mixin Chain Too Deep:
  class X extends A(B(C(D(E(F(Base))))))
  You've recreated deep inheritance with extra steps
  Fix: flatten composition, use object composition instead

6. Using Mixins for Code Organization:
  Splitting a class into mixins just to make files smaller
  If the behaviors are tightly coupled, they should stay together
  Mixins should be independently reusable, not class fragments

7. Mixin Instead of Utility Function:
  If the behavior doesn't need `this` context, use a plain function
  Don't: mixin with formatDate() method
  Do:    import { formatDate } from 'utils'

When NOT to Use Mixins:
  - Simple helper functions (use utility modules)
  - Tightly coupled behaviors (use a single class)
  - Clear is-a relationships (use inheritance)
  - Only one class needs the behavior (just add the method)
  - Language has better alternatives (Rust traits, Go interfaces)
  - Team finds them confusing (simplicity > cleverness)

Prefer Instead:
  - Composition: inject dependencies
  - Delegation: forward to composed objects
  - Higher-order functions: wrap behavior
  - Decorators: @decorator pattern (Python, TypeScript)
EOF
}

show_help() {
    cat << EOF
mixin v$VERSION — Mixin Pattern Reference

Usage: script.sh <command>

Commands:
  intro        Mixin concept — definition, history, composition vs inheritance
  javascript   JS mixins: Object.assign, class expressions, Symbol-based
  python       Python mixins and MRO — cooperative super() chain
  traits       Trait systems: Rust, Scala, PHP, Swift protocols
  diamond      Diamond problem and resolution strategies
  functional   Functional mixins — compose, pipe, stampit
  realworld    Real-world examples: Serializable, Observable, etc.
  antipatterns Mixin anti-patterns and when to avoid mixins
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)        cmd_intro ;;
    javascript)   cmd_javascript ;;
    python)       cmd_python ;;
    traits)       cmd_traits ;;
    diamond)      cmd_diamond ;;
    functional)   cmd_functional ;;
    realworld)    cmd_realworld ;;
    antipatterns) cmd_antipatterns ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "mixin v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
