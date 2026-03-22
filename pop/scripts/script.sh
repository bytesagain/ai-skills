#!/usr/bin/env bash
# pop — Stack & Queue Operations Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Pop Operations — Stack & Queue Fundamentals ===

Pop: remove and return an element from a collection.
The behavior depends on the data structure.

Stack (LIFO — Last In, First Out):
  Push:  add element to TOP      [A] → [A, B] → [A, B, C]
  Pop:   remove element from TOP [A, B, C] → pop → returns C, stack is [A, B]
  Peek:  look at top without removing

  Real-world analogies:
    Stack of plates: take from top, add to top
    Undo history: most recent action undone first
    Back button: most recent page visited first
    Call stack: most recent function returns first

Queue (FIFO — First In, First Out):
  Enqueue: add to BACK    [A] → [A, B] → [A, B, C]
  Dequeue: remove from FRONT  [A, B, C] → dequeue → returns A, queue is [B, C]
  
  Some languages call dequeue operations "pop" too
  Python: deque.popleft() for FIFO, list.pop() for LIFO

Deque (Double-Ended Queue):
  Push/pop from either end
  Can act as both stack and queue
  Operations: push_front, push_back, pop_front, pop_back

Priority Queue:
  Pop returns highest (or lowest) priority element
  Not LIFO or FIFO — ordered by priority
  Implementation: binary heap, Fibonacci heap
  Operations: insert, pop (extract-min/max), peek

Complexity:
  Operation    Stack    Queue    Priority Queue
  ──────────────────────────────────────────────
  Push/Insert  O(1)     O(1)     O(log n)
  Pop/Remove   O(1)     O(1)     O(log n)
  Peek         O(1)     O(1)     O(1)
  Search       O(n)     O(n)     O(n)

Implementation Strategies:
  Array-based:   simple, cache-friendly, may need resize
  Linked-list:   no resize, more memory (pointers), cache-unfriendly
  Circular buffer: fixed size, O(1) enqueue/dequeue, no resize
  Ring buffer:    same as circular buffer (common in OS/networking)
EOF
}

cmd_languages() {
    cat << 'EOF'
=== Pop Across Programming Languages ===

JavaScript:
  Array.pop()       — remove last element (LIFO), returns element
  Array.shift()     — remove first element (FIFO), returns element
  Array.push(el)    — add to end
  Array.unshift(el) — add to front (O(n) — shifts all elements!)
  
  const stack = [1, 2, 3];
  stack.pop();     // returns 3, stack is [1, 2]
  stack.push(4);   // stack is [1, 2, 4]
  
  Empty array: [].pop() returns undefined (no error)

Python:
  list.pop()        — remove last element (LIFO), O(1)
  list.pop(0)       — remove first element (FIFO), O(n)!
  list.pop(i)       — remove element at index i, O(n)
  
  collections.deque:
    deque.pop()       — remove right (LIFO), O(1)
    deque.popleft()   — remove left (FIFO), O(1)
    deque.append(el)  — add right, O(1)
    deque.appendleft(el) — add left, O(1)
  
  Empty: list.pop() raises IndexError
  heapq: heapq.heappop(heap) — pop smallest element

Java:
  Stack<E>.pop()     — remove top, throws EmptyStackException
  Stack<E>.push(el)  — add to top
  Stack<E>.peek()    — look at top without removing
  
  Deque<E> (preferred over Stack):
    ArrayDeque, LinkedList
    deque.pop()       — remove first (acts as stack)
    deque.poll()      — remove first, returns null if empty
    deque.push(el)    — add to front
    
  Queue<E>:
    queue.poll()      — remove head (FIFO), null if empty
    queue.remove()    — remove head, throws if empty
    queue.offer(el)   — add to tail
  
  PriorityQueue: poll() returns smallest element

C++:
  std::stack<T>:
    stack.pop()    — removes top (VOID — doesn't return value!)
    stack.top()    — access top element (must call before pop)
    stack.push(el) — add to top
    stack.empty()  — check before popping
  
  std::queue<T>:
    queue.pop()    — removes front (VOID)
    queue.front()  — access front
    queue.push(el) — add to back
  
  ⚠ C++ pop() returns void for exception safety!
    If pop returned by value and copy throws → element lost
    Separate top()/pop() prevents this

Rust:
  Vec<T>::pop()     — returns Option<T> (Some(el) or None)
  VecDeque::pop_back() — returns Option<T>
  VecDeque::pop_front() — returns Option<T>
  
  Pattern matching:
    if let Some(value) = stack.pop() { use(value); }
    // No panics on empty — forced to handle None

Go:
  No built-in stack/queue — use slices:
    // Pop from slice (stack)
    el := s[len(s)-1]
    s = s[:len(s)-1]
    
    // Dequeue from slice (queue) — inefficient O(n)
    el := s[0]
    s = s[1:]
    
  container/list: doubly-linked list (efficient deque)
  container/heap: priority queue interface
EOF
}

cmd_expression() {
    cat << 'EOF'
=== Expression Evaluation with Stacks ===

Infix Notation (human-readable):
  3 + 4 × 2 ÷ (1 - 5)
  Requires parentheses for precedence
  Not easy to evaluate directly

Postfix (Reverse Polish Notation — RPN):
  3 4 2 × 1 5 - ÷ +
  No parentheses needed
  Easy to evaluate with a stack

Postfix Evaluation Algorithm:
  For each token left to right:
    If number → push onto stack
    If operator → pop operands, compute, push result
  
  Example: 3 4 2 × 1 5 - ÷ +
  
  Token   Action                Stack
  3       push 3                [3]
  4       push 4                [3, 4]
  2       push 2                [3, 4, 2]
  ×       pop 2,4 → 4×2=8     [3, 8]
  1       push 1                [3, 8, 1]
  5       push 5                [3, 8, 1, 5]
  -       pop 5,1 → 1-5=-4    [3, 8, -4]
  ÷       pop -4,8 → 8÷-4=-2  [3, -2]
  +       pop -2,3 → 3+(-2)=1 [1]
  
  Result: 1 ✓

Shunting-Yard Algorithm (Dijkstra):
  Converts infix → postfix using an operator stack
  
  For each token:
    Number → output immediately
    Function → push to operator stack
    Operator (O1):
      While top of stack (O2) has:
        (higher precedence) OR (equal precedence AND O1 is left-assoc)
        AND O2 is not '(':
          Pop O2 to output
      Push O1 to operator stack
    '(' → push to operator stack
    ')' → pop operators to output until '(' found, discard '('
  
  After all tokens: pop remaining operators to output

  Operator Precedence (math):
    ^  (exponent):     highest, right-associative
    × ÷ (mult, div):  medium, left-associative
    + - (add, sub):    lowest, left-associative

  Example: 3 + 4 × 2 ÷ (1 - 5)
  Output queue:   3 4 2 × 1 5 - ÷ +
  (same as postfix above)

AST Construction from Postfix:
  Same algorithm as evaluation, but build tree nodes instead
  Number → create leaf node, push
  Operator → pop children, create operator node, push
  Final node on stack = AST root

Stack Machine (Virtual Machine):
  Many VMs are stack-based: JVM, CPython, WebAssembly, PostScript
  
  Instructions manipulate stack:
    PUSH 5        → [5]
    PUSH 3        → [5, 3]
    ADD           → [8]     (pop 3,5 → push 5+3)
    PUSH 2        → [8, 2]
    MUL           → [16]    (pop 2,8 → push 8×2)
  
  Simple to implement, easy to compile to
  Register machines are faster but more complex (x86, ARM)
EOF
}

cmd_undo() {
    cat << 'EOF'
=== Undo/Redo Systems ===

Stack-Based Undo:
  Undo stack:    [action1, action2, action3] ← most recent
  Redo stack:    [action4, action5] (after undoing action4, action5)
  
  Perform action: push to undo stack, clear redo stack
  Undo: pop from undo stack, push to redo stack, reverse action
  Redo: pop from redo stack, push to undo stack, re-apply action

Command Pattern:
  Each action is an object with execute() and undo() methods
  
  interface Command {
    execute(): void;    // do the action
    undo(): void;       // reverse the action
    description: string;
  }
  
  class InsertTextCommand {
    constructor(position, text) { ... }
    execute() { document.insert(this.position, this.text); }
    undo() { document.delete(this.position, this.text.length); }
  }
  
  class DeleteTextCommand {
    constructor(position, length) { ... }
    execute() {
      this.deletedText = document.getText(this.position, this.length);
      document.delete(this.position, this.length);
    }
    undo() { document.insert(this.position, this.deletedText); }
  }

Memento Pattern:
  Save complete state snapshots instead of individual commands
  
  Undo stack: [state1, state2, state3]
  Undo: restore previous state snapshot
  
  Pros: simple, handles any state change
  Cons: memory-heavy (full copy per action)
  Optimization: copy-on-write, structural sharing (immutable data)
  
  Redux (React): state history = array of immutable state objects
  Each state is new object, unchanged parts shared via references

Operational Transform (OT):
  For collaborative editing (Google Docs)
  Transform operations against concurrent edits
  
  User A inserts at position 5
  User B deletes at position 3
  A's insert must be adjusted: position 5 → 4 (after B's delete)
  
  More complex than simple undo but handles multiple users

Conflict-free Replicated Data Types (CRDTs):
  Alternative to OT for collaborative editing
  Mathematically guaranteed convergence
  No central server needed
  Used by: Figma, Yjs, Automerge

Practical Undo Considerations:
  Grouping: multiple small edits → one undo step
    Typing "hello" = 5 keystrokes but 1 undo step
    Group by: time threshold (300ms), logical operation
    
  Undo limit: cap stack size (memory management)
    Typical: 100-1000 undo steps
    Discard oldest when limit reached
    
  Persistent undo: survive across sessions
    Save undo history to disk
    Vim: persistent undo feature (set undofile)
    
  Selective undo: undo specific action (not just most recent)
    Much harder — may conflict with subsequent actions
    Usually requires OT-like conflict resolution

  Branch undo: undo tree instead of undo stack
    Each undo creates a branch
    Can navigate full history tree
    Vim: g- and g+ traverse undo tree branches
    Emacs: undo-tree mode
EOF
}

cmd_backtrack() {
    cat << 'EOF'
=== Backtracking Algorithms ===

Backtracking = DFS + pruning, implemented with stack (explicit or call stack)

General Template:
  function backtrack(state, choices):
    if isGoal(state): recordSolution(state); return
    for choice in choices:
      if isValid(state, choice):
        makeChoice(state, choice)       // push
        backtrack(state, remainingChoices)
        undoChoice(state, choice)       // pop (backtrack!)

N-Queens Problem:
  Place N queens on N×N board so no two attack each other
  
  State: column placement for each row so far
  Choice: which column for current row
  Validation: no same column, no diagonal conflict
  
  backtrack(row, columns):
    if row == N: found solution!
    for col in 0..N-1:
      if noConflict(columns, row, col):
        columns.push(col)       // place queen
        backtrack(row + 1, columns)
        columns.pop()           // remove queen (backtrack)

  N=8: 92 solutions (out of 16,777,216 possible placements)
  Backtracking explores ~15,000 nodes (vs 17M brute force)

Sudoku Solver:
  State: partially filled grid
  Choice: digit 1-9 for empty cell
  Validation: row, column, and 3×3 box constraints
  
  Find empty cell → try each valid digit → recurse → backtrack if stuck
  Stack implicitly maintained by recursion

Maze Solving (DFS with stack):
  Explicit stack approach:
    stack = [(start_x, start_y)]
    visited = set()
    
    while stack not empty:
      x, y = stack.pop()
      if (x, y) is goal: return path
      visited.add((x, y))
      for neighbor in [(x+1,y), (x-1,y), (x,y+1), (x,y-1)]:
        if valid(neighbor) and neighbor not in visited:
          stack.push(neighbor)
  
  DFS uses stack → explores one path deeply before backtracking
  BFS uses queue → explores all paths level by level (shortest path)

Permutation Generation:
  Generate all permutations of [1, 2, 3]:
  
  backtrack(current, remaining):
    if remaining is empty: print current
    for item in remaining:
      current.push(item)
      backtrack(current, remaining - {item})
      current.pop()  // backtrack!
  
  Output: [1,2,3], [1,3,2], [2,1,3], [2,3,1], [3,1,2], [3,2,1]

Subset Sum:
  Find subsets that sum to target
  
  backtrack(index, current_sum, subset):
    if current_sum == target: record subset
    if current_sum > target or index >= n: return (prune!)
    
    subset.push(nums[index])            // include nums[index]
    backtrack(index + 1, current_sum + nums[index], subset)
    subset.pop()                         // exclude nums[index]
    backtrack(index + 1, current_sum, subset)

Key Insight:
  push() = make a choice, explore deeper
  pop()  = undo the choice, try alternatives
  This push/pop symmetry IS backtracking
EOF
}

cmd_callstack() {
    cat << 'EOF'
=== Call Stack Mechanics ===

What Is the Call Stack?
  Region of memory that tracks function calls
  Each function call pushes a STACK FRAME
  When function returns, frame is popped

Stack Frame Contents:
  Return address:   where to resume after function returns
  Local variables:  function's own variables
  Parameters:       arguments passed to function
  Saved registers:  CPU registers that must be preserved
  Frame pointer:    reference to previous frame (rbp on x86)
  
  Layout (x86-64, growing downward):
    High addresses
    ┌─────────────────┐
    │ Parameters       │ (if more than 6, rest on stack)
    │ Return address   │ (pushed by CALL instruction)
    │ Saved rbp        │ (previous frame pointer)
    │ Local variable 1 │
    │ Local variable 2 │
    │ Saved registers  │
    └─────────────────┘
    Low addresses (stack grows down)

Function Call Sequence:
  1. Caller pushes arguments (or places in registers)
  2. CALL instruction pushes return address, jumps to function
  3. Callee pushes old frame pointer (rbp), sets new frame pointer
  4. Callee allocates space for local variables (subtract from rsp)
  5. Function body executes
  6. Callee restores frame pointer, deallocates locals
  7. RET instruction pops return address, jumps back to caller
  8. Caller cleans up arguments (if caller-cleanup convention)

Stack Overflow:
  Stack has limited size (default: 1-8 MB per thread)
  Too many nested calls → stack overflow
  
  Common causes:
    Infinite recursion: function calls itself with no base case
    Deep recursion: large input on recursive algorithm
    Large stack frames: huge local arrays
  
  Detection:
    Guard page at stack bottom → SIGSEGV / StackOverflowError
    
  Prevention:
    Convert recursion to iteration (with explicit stack)
    Increase stack size: ulimit -s (Linux), /STACK (Windows)
    Tail call optimization (see below)

Tail Call Optimization (TCO):
  If last action of function is calling another function:
    Reuse current stack frame instead of creating new one
    Converts recursion to loop (O(1) stack space)
  
  // Tail-recursive (can be optimized)
  function factorial(n, acc = 1) {
    if (n <= 1) return acc;
    return factorial(n - 1, n * acc);  // tail call
  }
  
  // NOT tail-recursive (multiplication after recursive call)
  function factorial(n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);  // not tail call
  }
  
  Language support:
    Scheme: required by spec
    Scala: @tailrec annotation (compiler checks)
    ES2015: spec includes TCO, only Safari implements it
    Python: no TCO (Guido's design decision)
    C/C++: compiler may optimize (not guaranteed)
    Rust: not guaranteed (use iteration instead)

Coroutines and Stackless Execution:
  Coroutines suspend/resume without full stack
  async/await: compiler transforms into state machine
  Each suspension point saves state to heap object (not stack)
  Enables millions of concurrent tasks on single thread
  Go goroutines: lightweight, dynamically-sized stacks (~2KB initial)
EOF
}

cmd_concurrent() {
    cat << 'EOF'
=== Concurrent Stacks & Queues ===

Thread-Safe Stack (Lock-Based):
  Wrap standard stack with mutex
  
  class ThreadSafeStack<T> {
    private stack: T[] = [];
    private mutex = new Mutex();
    
    push(item: T) {
      this.mutex.lock();
      this.stack.push(item);
      this.mutex.unlock();
    }
    
    pop(): T | undefined {
      this.mutex.lock();
      const item = this.stack.pop();
      this.mutex.unlock();
      return item;
    }
  }
  
  Simple but: mutex contention limits scalability

Lock-Free Stack (Treiber Stack):
  Uses Compare-And-Swap (CAS) atomic operation
  
  push(node):
    loop:
      node.next = head        // read current head
      if CAS(&head, node.next, node):  // try to swap
        return                 // success
      // CAS failed → another thread changed head, retry
  
  pop():
    loop:
      old_head = head
      if old_head == null: return null
      new_head = old_head.next
      if CAS(&head, old_head, new_head):
        return old_head.value  // success
      // CAS failed → retry
  
  ABA Problem:
    Thread 1 reads head = A
    Thread 2 pops A, pops B, pushes A back
    Thread 1's CAS succeeds (head is still A) but B is gone!
    Solution: tagged pointers (version counter), hazard pointers

Concurrent Queue (Michael-Scott Queue):
  Lock-free queue using CAS on head and tail pointers
  Sentinel node separates head from tail operations
  Enqueue and dequeue can proceed concurrently
  
  Used in: Java ConcurrentLinkedQueue

Work-Stealing Deque:
  Each thread has its own deque (double-ended queue)
  Thread pushes/pops work from its own end (LIFO, cache-friendly)
  When idle, thread steals from other thread's opposite end (FIFO)
  
  Benefits:
    - Locality: thread works on its own recent tasks
    - Load balancing: idle threads steal work
    - Low contention: stealing is rare
  
  Used by:
    Java ForkJoinPool
    Tokio (Rust async runtime)
    Go scheduler (goroutine stealing)
    Intel TBB (Threading Building Blocks)

Multi-Producer Multi-Consumer (MPMC) Queue:
  Multiple threads enqueue and dequeue concurrently
  
  Implementations:
    crossbeam (Rust): lock-free MPMC bounded/unbounded
    LMAX Disruptor (Java): ring buffer, extreme throughput
    boost::lockfree::queue (C++): lock-free MPMC
    
  Disruptor pattern:
    Pre-allocated ring buffer (no GC)
    Sequence barriers for ordering
    ~25 million ops/sec per producer

Channel-Based (CSP style):
  Channels combine queue with synchronization
  Go channels: ch := make(chan int, bufferSize)
  Rust mpsc: std::sync::mpsc::channel()
  
  Bounded: blocks producer when full (backpressure)
  Unbounded: grows without limit (memory risk)
  Zero-capacity (rendezvous): sender blocks until receiver ready
EOF
}

cmd_applications() {
    cat << 'EOF'
=== Stack Applications ===

Bracket Matching / Balanced Parentheses:
  Input: "{[()]}"
  Algorithm:
    For each char:
      '(', '[', '{' → push onto stack
      ')', ']', '}' → pop, check if matches
    End: stack must be empty
  
  Examples:
    "{[()]}"   → valid ✓
    "{[(])}"   → invalid ✗ (mismatch)
    "{[()]})"  → invalid ✗ (extra closing)
    "{[()]"    → invalid ✗ (unclosed)
  
  Extensions: HTML tag matching, XML validation

Browser History (Back/Forward):
  Back stack:    [page1, page2, page3] ← current
  Forward stack: [page4, page5]
  
  Navigate to new page: push to back stack, clear forward
  Back button: pop from back stack, push to forward stack
  Forward button: pop from forward stack, push to back stack

Memory Allocation (Stack vs Heap):
  Stack allocation:
    Local variables, function parameters
    Automatic: allocated on call, freed on return
    O(1): just move stack pointer
    Size known at compile time
    Limited size (1-8 MB typical)
    
  Heap allocation:
    Dynamic data (malloc/new/Box)
    Manual or GC-managed lifetime
    O(varies): allocator complexity
    Size determined at runtime
    Limited by available RAM

Virtual Machine Execution:
  JVM bytecode is stack-based:
    iconst_5        // push 5
    iconst_3        // push 3
    iadd            // pop 3,5 → push 8
    istore_1        // pop 8, store in local var 1
  
  Python VM (CPython): also stack-based bytecode
  WebAssembly: stack machine with structured control flow
  Lua: register-based VM (faster, more complex)

Depth-First Search (Graph):
  Explicit stack replaces recursion:
    stack = [start]
    visited = set()
    while stack:
      node = stack.pop()
      if node in visited: continue
      visited.add(node)
      process(node)
      for neighbor in graph[node]:
        if neighbor not in visited:
          stack.push(neighbor)

Function Call Convention:
  C calling convention (cdecl):
    Arguments pushed right-to-left
    Caller cleans up stack
    Return value in EAX/RAX
    
  System V AMD64 ABI (Linux/macOS):
    First 6 integer args in registers: rdi, rsi, rdx, rcx, r8, r9
    First 8 float args in xmm0-xmm7
    Remaining args on stack
    Return value in rax (integer) or xmm0 (float)

Monotonic Stack:
  Stack that maintains increasing or decreasing order
  
  Next Greater Element problem:
    Input:  [4, 5, 2, 10, 8]
    Output: [5, 10, 10, -1, -1]
    
  Algorithm: iterate right-to-left, maintain decreasing stack
    Pop elements smaller than current (they found their answer)
    Push current element
  
  Applications: stock span, histogram area, temperature days
  Time complexity: O(n) — each element pushed and popped at most once
EOF
}

show_help() {
    cat << EOF
pop v$VERSION — Stack & Queue Operations Reference

Usage: script.sh <command>

Commands:
  intro        Stack/queue fundamentals — LIFO, FIFO, deque
  languages    Pop behavior: JavaScript, Python, Java, C++, Rust, Go
  expression   Expression evaluation: postfix, shunting-yard, AST
  undo         Undo/redo: command pattern, memento, OT, CRDTs
  backtrack    Backtracking: N-Queens, Sudoku, permutations, DFS
  callstack    Call stack: frames, overflow, tail call optimization
  concurrent   Concurrent: lock-free stacks, work-stealing, channels
  applications Stack apps: brackets, browser history, VM, monotonic
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)        cmd_intro ;;
    languages)    cmd_languages ;;
    expression)   cmd_expression ;;
    undo)         cmd_undo ;;
    backtrack)    cmd_backtrack ;;
    callstack)    cmd_callstack ;;
    concurrent)   cmd_concurrent ;;
    applications) cmd_applications ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "pop v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
