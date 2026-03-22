#!/usr/bin/env bash
# flatten — Data Flattening Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Data Flattening ===

Flattening transforms a nested (hierarchical) data structure into a
single-level (flat) structure. The original nesting is encoded in the
keys using a separator — typically a dot (.) or slash (/).

Why Flatten?
  - Relational databases need flat rows — no nested objects
  - CSV/TSV formats require one value per column
  - Full-text search indexes prefer flat documents
  - Log aggregation tools (ELK, Splunk) work better with flat fields
  - Configuration systems often use dot-notation keys

Core Concept:
  Nested:  { "user": { "name": { "first": "Ada" } } }
  Flat:    { "user.name.first": "Ada" }

Terminology:
  Flatten    Convert nested → flat (depth reduction)
  Unflatten  Convert flat → nested (depth restoration)
  Depth      Number of nesting levels to flatten (0 = all)
  Separator  Character(s) joining key segments (default: ".")
  Prefix     Optional string prepended to all flat keys

Flatten vs Normalize:
  Flatten = structural transform (hierarchy → flat)
  Normalize = semantic transform (data redundancy removal)
  They often overlap in ETL pipelines but serve different goals.
EOF
}

cmd_json() {
    cat << 'EOF'
=== JSON Object Flattening ===

Input:
  {
    "server": {
      "host": "10.0.1.5",
      "port": 8080,
      "ssl": {
        "enabled": true,
        "cert": "/etc/ssl/cert.pem"
      }
    },
    "tags": ["web", "prod"]
  }

Dot-Notation Output:
  {
    "server.host": "10.0.1.5",
    "server.port": 8080,
    "server.ssl.enabled": true,
    "server.ssl.cert": "/etc/ssl/cert.pem",
    "tags.0": "web",
    "tags.1": "prod"
  }

Bracket-Notation Output:
  {
    "server[host]": "10.0.1.5",
    "server[port]": 8080,
    "server[ssl][enabled]": true,
    "server[ssl][cert]": "/etc/ssl/cert.pem",
    "tags[0]": "web",
    "tags[1]": "prod"
  }

Separator Options:
  Dot:       server.host          (most common)
  Slash:     server/host          (path-like, URI-style)
  Underscore: server_host         (environment variables)
  Double-underscore: server__host (avoids collision with single _)

Array Handling Strategies:
  Index:    tags.0, tags.1        (preserves order, reversible)
  Bracket:  tags[0], tags[1]      (PHP/form-data style)
  Explode:  tags=web, tags=prod   (query-string style, lossy)
  JSON:     tags="[\"web\",\"prod\"]" (keep as JSON string)

jq Examples:
  # Flatten one level
  jq '[paths(scalars) as $p | {key: ($p | join(".")), value: getpath($p)}] | from_entries'

  # Flatten with custom separator
  jq '[paths(scalars) as $p | {key: ($p | map(tostring) | join("/")), value: getpath($p)}] | from_entries'
EOF
}

cmd_array() {
    cat << 'EOF'
=== Array Flattening ===

Single-Level Flatten:
  Input:   [1, [2, 3], [4, [5, 6]]]
  Flat(1): [1, 2, 3, 4, [5, 6]]      (depth = 1)
  Flat(∞): [1, 2, 3, 4, 5, 6]        (full flatten)

JavaScript:
  arr.flat()          // depth 1
  arr.flat(Infinity)  // full flatten
  arr.flat(2)         // depth 2

Python:
  # No built-in — common patterns:
  # itertools (one level)
  list(itertools.chain.from_iterable(nested))

  # Recursive (full)
  def flatten(lst):
      for item in lst:
          if isinstance(item, list):
              yield from flatten(item)
          else:
              yield item

Depth-Limited Flatten:
  Depth 0: no change
  Depth 1: unwrap one level of nesting
  Depth N: unwrap N levels
  Depth ∞: fully flatten (recursive)

  Input:       [1, [2, [3, [4]]]]
  flat(0):     [1, [2, [3, [4]]]]
  flat(1):     [1, 2, [3, [4]]]
  flat(2):     [1, 2, 3, [4]]
  flat(∞):     [1, 2, 3, 4]

Performance:
  Shallow flat (depth 1):  O(n) — single pass concat
  Deep flat (depth ∞):     O(n) — visits every element once
  Memory: flat always produces a new array (not in-place)

  For very large arrays, use generators/iterators to avoid
  allocating the entire flat result in memory at once.

flatMap (flat + map combined):
  JavaScript: arr.flatMap(x => x > 2 ? [x, x*2] : [])
  Python:     [y for x in arr for y in transform(x)]
  Use case: map each item to 0+ results, then flatten
EOF
}

cmd_algorithms() {
    cat << 'EOF'
=== Flattening Algorithms ===

1. Recursive (DFS) — Most Common
   function flatten(obj, prefix = "", sep = ".") {
     result = {}
     for (key, value) in obj:
       newKey = prefix ? prefix + sep + key : key
       if isObject(value):
         merge(result, flatten(value, newKey, sep))
       else:
         result[newKey] = value
     return result
   }
   Pros: Simple, readable
   Cons: Stack overflow on deeply nested data (>10K levels)

2. Iterative (Stack-Based)
   function flatten(obj, sep = ".") {
     stack = [(obj, "")]
     result = {}
     while stack not empty:
       (current, prefix) = stack.pop()
       for (key, value) in current:
         newKey = prefix ? prefix + sep + key : key
         if isObject(value):
           stack.push((value, newKey))
         else:
           result[newKey] = value
     return result
   }
   Pros: No stack overflow, handles arbitrary depth
   Cons: Output order may differ from input

3. BFS (Queue-Based)
   Same as iterative but use queue instead of stack
   Pros: Level-order key generation
   Cons: Slightly more memory usage

4. Generator/Streaming
   function* flatEntries(obj, prefix = "") {
     for (key, value) in obj:
       fullKey = prefix ? prefix + "." + key : key
       if isObject(value):
         yield* flatEntries(value, fullKey)
       else:
         yield (fullKey, value)
   }
   Pros: Lazy evaluation, constant memory
   Cons: Single-pass only

Complexity:
  Time:  O(n) where n = total number of leaf values
  Space: O(d) stack depth for recursive, O(n) for result
  All algorithms produce identical output for acyclic data
EOF
}

cmd_languages() {
    cat << 'EOF'
=== Flatten Across Languages ===

JavaScript:
  // Array
  [1,[2,[3]]].flat(Infinity)  // [1,2,3]

  // Object (lodash)
  const flat = require('flat')
  flat({ a: { b: 1 } })  // { 'a.b': 1 }

  // Object (native)
  function flatten(obj, prefix = '', sep = '.') {
    return Object.entries(obj).reduce((acc, [k, v]) => {
      const key = prefix ? `${prefix}${sep}${k}` : k;
      if (typeof v === 'object' && v !== null && !Array.isArray(v))
        Object.assign(acc, flatten(v, key, sep));
      else acc[key] = v;
      return acc;
    }, {});
  }

Python:
  # pip install flatten-dict
  from flatten_dict import flatten
  flatten({'a': {'b': 1}}, reducer='dot')  # {'a.b': 1}

  # pandas (DataFrame)
  pd.json_normalize(nested_dict)  # returns flat DataFrame

Go:
  // No stdlib — manual recursion
  func Flatten(m map[string]interface{}, prefix string) map[string]interface{} {
      result := make(map[string]interface{})
      for k, v := range m {
          key := prefix + "." + k
          if prefix == "" { key = k }
          switch child := v.(type) {
          case map[string]interface{}:
              for ck, cv := range Flatten(child, key) {
                  result[ck] = cv
              }
          default:
              result[key] = v
          }
      }
      return result
  }

Bash (jq):
  echo '{"a":{"b":1}}' | jq '[paths(scalars) as $p |
    {key:($p|map(tostring)|join(".")), value:getpath($p)}] |
    from_entries'
  # {"a.b": 1}

SQL (PostgreSQL):
  -- Flatten JSONB with lateral join
  SELECT key, value
  FROM my_table, jsonb_each_text(data_column);
EOF
}

cmd_edgecases() {
    cat << 'EOF'
=== Flatten Edge Cases ===

Circular References:
  Problem: { a: { b: <ref to root> } } → infinite loop
  Solutions:
    - Track visited objects with a Set/WeakSet
    - Throw error on cycle detection
    - Replace circular ref with "[Circular]" placeholder
    - Set maximum depth limit as safety net

Null / Undefined Values:
  { a: null }   → { "a": null }     (preserve null as leaf)
  { a: undefined } → depends on language:
    JavaScript: omit key (JSON.stringify drops undefined)
    Python: no undefined concept
  Recommendation: preserve null, drop undefined

Empty Objects / Arrays:
  { a: {} }    → ???
  Option 1: omit entirely (no leaf value)
  Option 2: { "a": {} }  (keep as leaf)
  Option 3: { "a": "[empty object]" }
  Common choice: omit (no leaves = no entries)

  { a: [] }   → same options as empty object
  Recommendation: keep empty containers as leaf values

Mixed Types:
  { a: [1, { b: 2 }] }
  → { "a.0": 1, "a.1.b": 2 }     (recursive into array objects)

Key Collisions:
  Input: { "a.b": 1, a: { b: 2 } }
  Both flatten to "a.b" — collision!
  Solutions:
    - Use a separator not present in keys (__ or /)
    - Throw error on collision
    - Last-write-wins (lossy)
    - Namespace: "a\.b" (escaped dot)

Date / Special Objects:
  { date: new Date() } → treat as leaf, don't recurse
  Rule: only recurse into plain objects and arrays
  RegExp, Date, Buffer, Map, Set → keep as leaf values

Very Large Structures:
  >100MB JSON: use streaming flatten (SAX-style parser)
  >10K depth: use iterative algorithm (avoid stack overflow)
  >1M keys: consider partial flatten (depth limit)
EOF
}

cmd_unflatten() {
    cat << 'EOF'
=== Unflatten — Reverse Operation ===

Unflatten reconstructs a nested structure from flat key-value pairs.

Input:
  {
    "user.name.first": "Ada",
    "user.name.last": "Lovelace",
    "user.age": 36,
    "tags.0": "math",
    "tags.1": "computing"
  }

Output:
  {
    "user": {
      "name": { "first": "Ada", "last": "Lovelace" },
      "age": 36
    },
    "tags": ["math", "computing"]
  }

Algorithm:
  for each (flatKey, value):
    segments = flatKey.split(separator)
    current = root
    for i, segment in segments[:-1]:
      nextSeg = segments[i+1]
      if nextSeg is numeric:
        current[segment] = current[segment] || []
      else:
        current[segment] = current[segment] || {}
      current = current[segment]
    current[lastSegment] = value

Array Detection:
  Numeric keys → create array: tags.0, tags.1 → ["math","computing"]
  Non-numeric keys → create object: user.name → { name: ... }
  Mixed keys → ambiguous, usually treated as object

Overwrite Protection:
  "a": 1  AND  "a.b": 2
  Cannot unflatten — "a" is both a leaf and a parent
  Solutions: error, skip, or last-write-wins

Libraries:
  JavaScript: flat.unflatten({ "a.b": 1 })
  Python: unflatten_dict.unflatten({ "a.b": 1 }, splitter="dot")

Round-Trip Guarantee:
  unflatten(flatten(obj)) === obj  (if no key collisions)
  flatten(unflatten(flat)) === flat  (if consistent types)
  Always test round-trip with your specific data shape.
EOF
}

cmd_patterns() {
    cat << 'EOF'
=== Real-World Flatten Patterns ===

1. ETL Pipeline — API → Database
   Step 1: Fetch nested JSON from REST API
   Step 2: Flatten to dot-notation keys
   Step 3: Map flat keys to database columns
   Step 4: Insert flat rows into PostgreSQL
   Tool: pandas json_normalize() or custom flatten + bulk INSERT

2. Log Normalization — ELK Stack
   Raw log: { "request": { "headers": { "x-forwarded-for": "..." } } }
   Flattened: { "request.headers.x-forwarded-for": "..." }
   Why: Elasticsearch maps each dot-path to a field
   Kibana can filter/aggregate on any flat field

3. Configuration Merging
   Base:    { db: { host: "localhost", port: 5432 } }
   Override: { db: { host: "prod-db.example.com" } }
   Flatten both → merge flat maps → unflatten
   Result:  { db: { host: "prod-db.example.com", port: 5432 } }
   Simpler than deep-merge algorithms

4. Environment Variables from Config
   Config: { server: { port: 8080, ssl: { cert: "..." } } }
   Flatten with "__" separator + uppercase:
     SERVER__PORT=8080
     SERVER__SSL__CERT=...
   Common in Docker/Kubernetes deployments

5. CSV Export of Nested Data
   API returns: [{ user: { name: "Ada" }, scores: [95, 87] }]
   Flatten each record: { "user.name": "Ada", "scores.0": 95, ... }
   Union all flat keys → CSV header
   Write flat values → CSV rows

6. Diff / Comparison
   Flatten two nested objects → compare flat key-value pairs
   Added:   key in B but not A
   Removed: key in A but not B
   Changed: same key, different value
   Much simpler than recursive deep-diff
EOF
}

show_help() {
    cat << EOF
flatten v$VERSION — Data Flattening Reference

Usage: script.sh <command>

Commands:
  intro        What is flattening, why it matters, terminology
  json         JSON object flattening with dot/bracket notation
  array        Array flattening, depth control, flatMap
  algorithms   Recursive, iterative, streaming algorithms
  languages    Flatten in JS, Python, Go, Bash, SQL
  edgecases    Circular refs, nulls, collisions, large data
  unflatten    Reverse: flat → nested reconstruction
  patterns     ETL, logging, config merge, CSV export patterns
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    json)       cmd_json ;;
    array)      cmd_array ;;
    algorithms) cmd_algorithms ;;
    languages)  cmd_languages ;;
    edgecases)  cmd_edgecases ;;
    unflatten)  cmd_unflatten ;;
    patterns)   cmd_patterns ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "flatten v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
