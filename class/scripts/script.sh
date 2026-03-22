#!/usr/bin/env bash
# class — Object-Oriented Programming Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Object-Oriented Programming Fundamentals ===

A class is a blueprint for creating objects. An object is an instance
of a class that bundles data (state) and behavior (methods) together.

The Four Pillars of OOP:

  1. Encapsulation:
     Bundle data and methods that operate on it
     Hide internal state, expose controlled interface
     "Tell, don't ask" — objects manage their own state

  2. Abstraction:
     Hide complexity behind a simple interface
     Users interact with WHAT an object does, not HOW
     Example: car.start() — you don't need to know the ignition sequence

  3. Inheritance:
     Create new classes based on existing ones
     Child class inherits parent's properties and methods
     Enables code reuse and hierarchical classification

  4. Polymorphism:
     Same interface, different implementations
     Method overriding: child replaces parent's method
     Method overloading: same name, different parameters
     "One interface, many forms"

Class Anatomy:
  class Animal {
    // Properties (state)
    name: string
    age: number

    // Constructor (initialization)
    constructor(name, age) { ... }

    // Methods (behavior)
    speak() { ... }

    // Static methods (class-level, no instance needed)
    static create(name) { ... }

    // Getter/Setter (controlled access)
    get info() { ... }
    set info(value) { ... }
  }

Object Lifecycle:
  1. Declaration:  Animal a;           // type declared
  2. Instantiation: a = new Animal();  // memory allocated
  3. Initialization: constructor runs  // state set up
  4. Usage:         a.speak();         // methods called
  5. Destruction:   garbage collected  // memory freed
     (or manual: delete/free/close in C++/Rust)
EOF
}

cmd_solid() {
    cat << 'EOF'
=== SOLID Principles ===

S — Single Responsibility Principle (SRP):
  A class should have ONE reason to change
  Bad:  UserService handles auth, email, logging, DB
  Good: AuthService, EmailService, Logger, UserRepository

  Test: describe your class in one sentence without "and"
  "This class handles user authentication." ✓
  "This class handles auth and sends emails and logs." ✗

O — Open/Closed Principle (OCP):
  Open for extension, closed for modification
  Add new behavior WITHOUT changing existing code
  Bad:  if (type == "circle") ... else if (type == "square") ...
  Good: Shape.area() — each shape implements its own area()

  Achieved through: polymorphism, strategy pattern, plugins

L — Liskov Substitution Principle (LSP):
  Objects of parent class should be replaceable by child class
  without breaking the program
  Bad:  Square extends Rectangle (changing width changes height)
  Good: Both Square and Rectangle implement Shape interface

  Rules:
    - Preconditions can't be strengthened in child
    - Postconditions can't be weakened in child
    - Parent's invariants must be preserved
    - Don't throw new exception types parent doesn't

I — Interface Segregation Principle (ISP):
  Don't force clients to depend on methods they don't use
  Bad:  interface Worker { code(); test(); managePeople(); }
  Good: interface Coder { code(); }
        interface Tester { test(); }
        interface Manager { managePeople(); }

  Prefer many small interfaces over one large one
  Classes implement only the interfaces they need

D — Dependency Inversion Principle (DIP):
  High-level modules should not depend on low-level modules
  Both should depend on abstractions
  Bad:  OrderService → MySQLDatabase (concrete dependency)
  Good: OrderService → DatabaseInterface ← MySQLDatabase

  Implemented via: dependency injection, IoC containers
  "Depend on abstractions, not concretions"
EOF
}

cmd_inheritance() {
    cat << 'EOF'
=== Inheritance vs Composition ===

Inheritance ("is-a" relationship):
  class Dog extends Animal { }  // Dog IS-A Animal
  Pros:
    - Code reuse (inherit parent methods)
    - Polymorphism (treat Dog as Animal)
    - Natural hierarchy (taxonomy)
  Cons:
    - Tight coupling (changes to parent break children)
    - Fragile base class problem
    - Deep hierarchies become unmaintainable
    - Diamond problem (multiple inheritance conflicts)

Composition ("has-a" relationship):
  class Car {
    engine: Engine          // Car HAS-A Engine
    transmission: Transmission
  }
  Pros:
    - Loose coupling (swap components freely)
    - More flexible (change behavior at runtime)
    - Easier to test (mock individual components)
    - Avoids fragile base class problem
  Cons:
    - More boilerplate (delegation code)
    - No built-in polymorphism (need interfaces)

"Favor composition over inheritance" — Gang of Four

When to Use Inheritance:
  ✓ True is-a relationship (Dog is-a Animal)
  ✓ Shared behavior that rarely changes
  ✓ Framework requires it (Android Activity, React Component)
  ✓ Less than 3 levels deep

When to Use Composition:
  ✓ "has-a" or "uses-a" relationship
  ✓ Behavior needs to change at runtime
  ✓ Multiple "kinds" of behavior needed (can't multi-inherit)
  ✓ When in doubt — default to composition

Diamond Problem:
  class A { method() }
  class B extends A { method() }
  class C extends A { method() }
  class D extends B, C { method() → which one? }

  Solutions:
    Java:    No multiple inheritance (use interfaces)
    Python:  MRO (Method Resolution Order) — C3 linearization
    C++:     Virtual inheritance
    Rust:    Traits (no inheritance at all)

Mixins:
  Reusable behavior without full inheritance
  Python: class Dog(Animal, Serializable, Loggable): pass
  Ruby:   include Comparable, Enumerable
  TS:     applyMixins(Dog, [Serializable, Loggable])
  Benefit: compose behaviors from multiple sources
EOF
}

cmd_patterns() {
    cat << 'EOF'
=== Essential Design Patterns ===

Factory Pattern:
  Create objects without specifying exact class
  class VehicleFactory {
    create(type) {
      if (type == 'car') return new Car();
      if (type == 'truck') return new Truck();
    }
  }
  Use when: object creation is complex, type determined at runtime

Strategy Pattern:
  Define a family of algorithms, make them interchangeable
  class Sorter {
    constructor(strategy) { this.strategy = strategy; }
    sort(data) { return this.strategy.sort(data); }
  }
  sorter = new Sorter(new QuickSort());  // or MergeSort, etc.
  Use when: multiple algorithms for same task, switchable at runtime

Observer Pattern:
  One-to-many dependency: when subject changes, all observers notified
  class EventEmitter {
    on(event, callback) { this.listeners[event].push(callback); }
    emit(event, data) { this.listeners[event].forEach(cb => cb(data)); }
  }
  Use when: event systems, pub/sub, reactive UI updates

Singleton Pattern:
  Ensure only ONE instance of a class exists
  class Database {
    static instance;
    static getInstance() {
      if (!this.instance) this.instance = new Database();
      return this.instance;
    }
  }
  Use sparingly: often a code smell (global state)
  Better alternatives: dependency injection, module-level instances

Builder Pattern:
  Construct complex objects step by step
  const user = new UserBuilder()
    .setName('Alice')
    .setAge(30)
    .setEmail('alice@example.com')
    .build();
  Use when: many optional parameters, complex construction sequence

Decorator Pattern:
  Add behavior to objects dynamically
  const logger = new LoggingDecorator(new FileWriter());
  logger.write(data);  // logs + writes
  Use when: extending behavior without subclassing

Adapter Pattern:
  Convert one interface to another
  class XMLToJSONAdapter {
    constructor(xmlService) { this.xmlService = xmlService; }
    getJSON() { return xmlToJson(this.xmlService.getXML()); }
  }
  Use when: integrating incompatible interfaces
EOF
}

cmd_access() {
    cat << 'EOF'
=== Access Modifiers & Encapsulation ===

Purpose: Control visibility of class members
Principle: expose as little as possible (least privilege)

Java:
  public:     Accessible from anywhere
  protected:  Same package + subclasses
  (default):  Same package only (package-private)
  private:    Same class only

Python:
  public:     name (no prefix)           # accessible anywhere
  protected:  _name (single underscore)  # convention only, not enforced
  private:    __name (double underscore) # name mangling (_Class__name)

  Python philosophy: "We're all consenting adults"
  Conventions are respected, not enforced

TypeScript:
  public:     Default, accessible anywhere
  protected:  Class and subclasses
  private:    Class only (compile-time enforcement)
  #field:     True private (runtime, ES2022 private class fields)

C++:
  public:     Accessible from anywhere
  protected:  Class, subclasses, and friends
  private:    Class and friends only
  friend:     Grants access to specific functions/classes

Encapsulation Best Practices:
  1. Make fields private by default
  2. Expose through getters/setters only when needed
  3. Validate in setters (enforce invariants)
  4. Return defensive copies of mutable objects
  5. Make classes final/sealed if not designed for inheritance

  Example:
    class BankAccount {
      private balance: number;

      deposit(amount: number) {
        if (amount <= 0) throw new Error('Invalid amount');
        this.balance += amount;
      }

      getBalance(): number {
        return this.balance;  // read-only access
      }
      // No setBalance() — can't set arbitrary balance
    }

Property Accessors (Getters/Setters):
  Advantage over public fields:
    - Validation logic
    - Computed/derived values
    - Lazy initialization
    - Logging/debugging
    - Future-proof (add logic without changing interface)
EOF
}

cmd_abstract() {
    cat << 'EOF'
=== Abstract Classes, Interfaces, and Protocols ===

Abstract Class:
  Can't be instantiated directly — must be subclassed
  Can have both implemented and abstract methods
  Provides common base behavior + contract

  Java:
    abstract class Shape {
      abstract double area();           // must implement
      String describe() { return "Shape"; } // shared implementation
    }

  Python:
    from abc import ABC, abstractmethod
    class Shape(ABC):
      @abstractmethod
      def area(self): pass
      def describe(self): return "Shape"

Interface:
  Pure contract — NO implementation (traditionally)
  Classes can implement multiple interfaces (vs single inheritance)

  Java:
    interface Drawable { void draw(); }
    interface Resizable { void resize(double factor); }
    class Circle implements Drawable, Resizable { ... }

  TypeScript:
    interface Serializable {
      serialize(): string;
      deserialize(data: string): void;
    }

  Java 8+: interfaces can have default methods (partial implementation)
    interface Collection {
      default boolean isEmpty() { return size() == 0; }
      int size();  // abstract
    }

Protocol (Python 3.8+):
  Structural typing — "duck typing" with type checker support
  No explicit implementation needed — just match the shape

    class Drawable(Protocol):
      def draw(self) -> None: ...

    class Circle:  # NOT explicitly implementing Drawable
      def draw(self) -> None: print("O")

    def render(item: Drawable): item.draw()
    render(Circle())  # Works! Circle matches Drawable protocol

Traits (Rust):
  Like interfaces but can include default implementations
  No inheritance — composition of behaviors

    trait Speak {
      fn speak(&self) -> String;
      fn greet(&self) -> String {  // default implementation
        format!("Hello! {}", self.speak())
      }
    }

    struct Dog;
    impl Speak for Dog {
      fn speak(&self) -> String { "Woof!".to_string() }
    }

When to Use What:
  Abstract class:  Shared code + contract (single inheritance OK)
  Interface:       Pure contract, multiple implementations
  Protocol/Trait:  Structural typing, behavior composition
  Mixin:           Reusable behavior snippets
EOF
}

cmd_pitfalls() {
    cat << 'EOF'
=== Common OOP Pitfalls ===

God Class (Blob):
  One class that does everything
  Signs: 1000+ lines, dozens of methods, "Manager" or "Utils" in name
  Fix: split by responsibility (SRP), extract collaborators
  Test: if you can't describe it in one sentence, it's too big

Deep Inheritance Hierarchies:
  Animal → Mammal → Domestic → Pet → Dog → GoldenRetriever
  Problems: fragile, hard to understand, hard to change base
  Rule: max 3 levels deep
  Fix: flatten hierarchy, use composition, use interfaces

Inheritance for Code Reuse Only:
  Using inheritance just to reuse methods (not a true "is-a")
  Example: Stack extends ArrayList (Stack is NOT a kind of List)
  Fix: use composition (Stack HAS-A List internally)

Over-Engineering:
  AbstractSingletonProxyFactoryBean (actual Spring class name)
  Signs: more interfaces than classes, patterns for patterns' sake
  Rule: YAGNI — You Aren't Gonna Need It
  Add abstraction when you need it, not "just in case"

Anemic Domain Model:
  Classes with only getters/setters, no behavior
  Business logic lives in separate "service" classes
  Essentially procedural code disguised as OOP
  Fix: put behavior where the data is (rich domain model)

Violating Liskov (LSP):
  Square extends Rectangle but breaks setWidth/setHeight contracts
  ReadOnlyList extends List but throws on add()
  Fix: if substitution breaks, they shouldn't inherit

Feature Envy:
  Method that uses more data from another class than its own
  Example: calculateTax(order) uses order.items, order.total, order.tax...
  Fix: move the method to where the data lives

Primitive Obsession:
  Using primitives instead of small objects
  Bad: email as String, money as double, phone as String
  Good: Email class (with validation), Money class (with currency)
  Fix: wrap primitives in value objects with validation

Circular Dependencies:
  Class A depends on B, B depends on A
  Causes: tight coupling, compilation issues, testing nightmares
  Fix: extract shared interface, use dependency injection, mediator
EOF
}

cmd_comparison() {
    cat << 'EOF'
=== OOP Across Languages ===

Java:
  Pure OOP — everything is a class (except primitives)
  Single inheritance + multiple interfaces
  Strong type system, checked exceptions
  Access: public, protected, package-private, private
  Abstract classes and interfaces (with default methods since Java 8)
  Keywords: class, extends, implements, abstract, final, static

Python:
  Multi-paradigm — OOP optional but well-supported
  Multiple inheritance with MRO (C3 linearization)
  Duck typing — "if it quacks like a duck..."
  Access: convention-based (_protected, __private name mangling)
  Protocols for structural typing (3.8+)
  Keywords: class, (base), @abstractmethod, @property, @staticmethod

TypeScript:
  Structural type system (not nominal like Java)
  Single inheritance + multiple interfaces
  Access: public, protected, private, #private (ES2022)
  Supports abstract classes and interfaces
  Generics with constraints
  Keywords: class, extends, implements, abstract, readonly

Go:
  NO classes, NO inheritance
  Structs + methods + interfaces
  Implicit interface satisfaction (structural typing)
  Composition via embedding (not inheritance)
  type Dog struct { Animal }  // embeds Animal's fields/methods
  Philosophy: simplicity over hierarchy

Rust:
  NO classes, NO inheritance
  Structs + impl blocks + traits
  Composition only — no inheritance tree
  Trait objects for dynamic dispatch (dyn Trait)
  Ownership system replaces garbage collection
  impl Speak for Dog { ... }  // implement trait for struct

Comparison Table:
  Feature          Java    Python  TypeScript  Go      Rust
  Classes          Yes     Yes     Yes         No      No
  Inheritance      Single  Multiple Single     Embed   No
  Interfaces       Yes     Protocol Yes        Yes     Traits
  Access Control   Strong  Weak    Medium      None    Pub/priv
  Generics         Yes     Yes     Yes         Yes     Yes
  Null Safety      No*     No      Strict mode No*     Yes
  GC               Yes     Yes     JS engine   Yes     No (ownership)

  * Java: Optional<T>, Go: nil checks
EOF
}

show_help() {
    cat << EOF
class v$VERSION — Object-Oriented Programming Reference

Usage: script.sh <command>

Commands:
  intro        OOP fundamentals — four pillars, class anatomy
  solid        SOLID principles — SRP, OCP, LSP, ISP, DIP
  inheritance  Inheritance vs composition, diamond problem, mixins
  patterns     Design patterns — Factory, Strategy, Observer, Builder
  access       Access modifiers and encapsulation across languages
  abstract     Abstract classes, interfaces, protocols, traits
  pitfalls     Common OOP mistakes and how to fix them
  comparison   OOP in Java, Python, TypeScript, Go, Rust
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)       cmd_intro ;;
    solid)       cmd_solid ;;
    inheritance) cmd_inheritance ;;
    patterns)    cmd_patterns ;;
    access)      cmd_access ;;
    abstract)    cmd_abstract ;;
    pitfalls)    cmd_pitfalls ;;
    comparison)  cmd_comparison ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "class v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
