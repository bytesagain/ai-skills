#!/usr/bin/env bash
# deserialize — Deserialization Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Serialization & Deserialization ===

Serialization:   Object in memory → bytes/text (for storage/transmission)
Deserialization: Bytes/text → Object in memory (for processing)

Also called: marshalling/unmarshalling, encoding/decoding,
             pickling/unpickling (Python), freeze/thaw (Perl)

Why It Matters:
  - Network communication (API requests/responses)
  - Persistent storage (databases, files, cache)
  - Inter-process communication (IPC, message queues)
  - Cross-language data exchange (microservices)
  - State persistence (sessions, checkpoints)

Format Categories:
  Text-based:     JSON, XML, YAML, TOML, CSV
  Binary:         Protobuf, MessagePack, Avro, CBOR, FlatBuffers
  Language-native: Python pickle, Java Serializable, PHP serialize
  Schema-required: Protobuf, Avro, Thrift, Cap'n Proto
  Schema-optional: JSON, MessagePack, CBOR, BSON

Key Tradeoffs:
                    Human      Compact   Fast    Schema   Cross-lang
  JSON              ✓✓✓        ✗         ✗       optional ✓✓✓
  Protobuf          ✗          ✓✓✓       ✓✓✓     required ✓✓✓
  MessagePack       ✗          ✓✓        ✓✓      no       ✓✓✓
  Avro              ✗          ✓✓✓       ✓✓      required ✓✓
  FlatBuffers       ✗          ✓✓        ✓✓✓✓    required ✓✓
  XML               ✓✓         ✗✗        ✗✗      optional ✓✓✓
  Pickle            ✗          ✓         ✓✓      no       ✗ (Python only)

Golden Rules:
  1. Never deserialize untrusted data with native serializers (pickle, Java)
  2. Always validate after deserialization (schema, types, ranges)
  3. Use schema-based formats for inter-service communication
  4. JSON for human-facing APIs, binary for internal performance
  5. Version your schemas from day one
EOF
}

cmd_formats() {
    cat << 'EOF'
=== Format Comparison ===

JSON (JavaScript Object Notation):
  Types: string, number, boolean, null, array, object
  Size: verbose (~2-3× of binary)
  Speed: moderate (text parsing overhead)
  Schema: JSON Schema (optional validation)
  Streaming: JSON Lines (NDJSON) for streaming
  Limits: no binary data, no comments, no dates
  Use: REST APIs, config files, human-readable exchange
  Example: {"name": "Alice", "age": 30, "scores": [95, 87]}

Protocol Buffers (Protobuf):
  Types: int32/64, float/double, bool, string, bytes, enums, nested
  Size: 3-10× smaller than JSON
  Speed: 5-100× faster than JSON
  Schema: .proto files (required, compiled)
  Streaming: delimited (length-prefixed messages)
  Use: gRPC, inter-service, high-performance systems
  Example: message Person { string name = 1; int32 age = 2; }

MessagePack:
  "Like JSON but binary" — same types, compact encoding
  Size: 50-70% of JSON
  Speed: 2-5× faster than JSON
  Schema: none (self-describing like JSON)
  Use: Redis, Fluentd, game protocols
  Example: 82 A4 name A5 Alice A3 age 1E (hex)

Apache Avro:
  Schema in JSON, data in compact binary
  Schema sent separately (often via Schema Registry)
  Size: smallest for batch data (no field names in data!)
  Speed: fast, especially for batch processing
  Schema evolution: excellent (Confluent Schema Registry)
  Use: Kafka, Hadoop, data pipelines

FlatBuffers (Google):
  Zero-copy: access data directly from buffer (no parsing!)
  Speed: fastest — no deserialization step at all
  Memory: no allocations, read directly from memory-mapped file
  Use: games, mobile, real-time systems, ML model serving
  Limitation: read-only access pattern, awkward mutation

CBOR (Concise Binary Object Representation):
  RFC 7049/8949 — standardized binary format
  Types: same as JSON + binary data, tags, half-precision float
  Self-describing, no schema needed
  Use: IoT, COSE (crypto), WebAuthn
  Similar to MessagePack but IETF standardized
EOF
}

cmd_security() {
    cat << 'EOF'
=== Deserialization Security ===

Insecure deserialization is OWASP Top 10 (#8 in 2021).
Deserializing untrusted data can lead to Remote Code Execution (RCE).

DANGER: Language-Native Serialization
  These formats can encode ARBITRARY OBJECTS including code:

  Python pickle:
    import pickle
    data = pickle.loads(untrusted_bytes)  # RCE!
    # Attacker crafts pickle that runs: os.system("rm -rf /")
    # The __reduce__ method defines arbitrary code execution

  Java ObjectInputStream:
    ObjectInputStream ois = new ObjectInputStream(untrusted);
    Object obj = ois.readObject();  # RCE!
    # CVE-2015-4852 (WebLogic), CVE-2017-9805 (Struts)
    # Gadget chains: Apache Commons Collections, Spring

  PHP unserialize:
    $obj = unserialize($untrusted);  # RCE!
    # __wakeup(), __destruct() magic methods
    # POP (Property Oriented Programming) chains

  Ruby Marshal:
    obj = Marshal.load(untrusted)  # RCE!
    # CVE-2013-0156 (Rails XML/YAML parameter parsing)

  .NET BinaryFormatter:
    Microsoft deprecated it entirely (too dangerous!)
    Use System.Text.Json or MessagePack instead

Safe Alternatives:
  ✓ JSON (no code execution possible in format)
  ✓ Protobuf (schema-bound, no arbitrary objects)
  ✓ MessagePack (data-only, no code)
  ✓ Avro (schema-bound)
  ✓ FlatBuffers (zero-copy, no execution)

Defense in Depth:
  1. Never use native serialization for untrusted data
  2. Use data-only formats (JSON, Protobuf, MessagePack)
  3. Validate deserialized data against schema
  4. Implement type whitelisting if native format required
  5. Run deserialization in sandboxed environment
  6. Keep libraries updated (gadget chain CVEs)
  7. Monitor for unusual deserialization patterns

JSON Security:
  JSON itself is safe, but parsers can have issues:
  - JSON parsing DoS (deeply nested objects, huge numbers)
  - Duplicate keys: behavior undefined (last wins? first wins?)
  - Large payloads: set size limits
  - Number precision: JSON→float→JSON can lose precision
  - Prototype pollution (JavaScript): {"__proto__": {"isAdmin": true}}
    Prevention: Object.create(null), validated schemas
EOF
}

cmd_schemas() {
    cat << 'EOF'
=== Schema Evolution ===

Real systems change over time. Messages evolve. APIs grow.
Schema evolution = changing the schema without breaking existing data.

Compatibility Types:
  Backward:  new code reads old data ✓
  Forward:   old code reads new data ✓
  Full:      both directions ✓

Protobuf Schema Evolution Rules:
  Safe changes (backward + forward compatible):
    ✓ Add new fields with new field numbers
    ✓ Remove fields (old number becomes reserved)
    ✓ Rename fields (wire format uses numbers, not names)
  
  Unsafe changes:
    ✗ Change field number → data corruption
    ✗ Change field type (int32 → string) → parsing failure
    ✗ Reuse deleted field numbers → data misinterpretation

  Default Values for Missing Fields:
    int32:  0       (not null, not error — just 0!)
    string: ""      (empty string)
    bool:   false
    enum:   first value (must be 0)
    
    Implication: can't distinguish "field set to 0" from "field missing"
    Solution: use wrapper types (google.protobuf.Int32Value) or optional

  Reserved Fields:
    message Person {
      reserved 2, 15, 9 to 11;    // don't reuse these numbers!
      reserved "old_field_name";    // don't reuse these names!
    }

Avro Schema Evolution:
  Uses reader and writer schemas:
    Writer schema: schema used when data was written
    Reader schema: schema used when data is read
    Avro resolves differences automatically
  
  Rules:
    ✓ Add field with default value → backward compatible
    ✓ Remove field with default value → forward compatible
    ✗ Add field without default → breaks backward compatibility
    ✗ Remove field without default → breaks forward compatibility
    ✗ Change field type (some promotions OK: int→long→float→double)

JSON Schema Evolution:
  No built-in evolution mechanism — you manage it:
    Version in URL: /api/v1/users, /api/v2/users
    Version in header: Accept: application/vnd.api+json; version=2
    Version in body: {"version": 2, "data": {...}}
    Additive only: never remove/rename fields (add new ones)

Schema Registry (Confluent):
  Central store for Avro/Protobuf/JSON schemas
  Enforces compatibility at write time
  Schema ID embedded in each Kafka message (5 bytes overhead)
  Tracks schema versions and compatibility chains
EOF
}

cmd_binary() {
    cat << 'EOF'
=== Binary Format Internals ===

Varint Encoding (Protobuf, MessagePack):
  Variable-length integer: small numbers use fewer bytes
  
  MSB (most significant bit) = continuation flag:
    1xxxxxxx → more bytes follow
    0xxxxxxx → this is the last byte
  
  Example: encode 300 (0x012C)
    300 = 0000 0010 0010 1100 (binary)
    Split into 7-bit groups: 0000010 0101100
    Reverse order + set MSB: 1_0101100 0_0000010
    Bytes: AC 02
  
  Size by value:
    0-127:          1 byte
    128-16383:      2 bytes
    16384-2097151:  3 bytes
    vs fixed int32: always 4 bytes

Wire Types (Protobuf):
  0: Varint          int32, int64, uint32, bool, enum
  1: 64-bit          fixed64, sfixed64, double
  2: Length-delimited string, bytes, embedded messages, repeated
  5: 32-bit          fixed32, sfixed32, float
  
  Field key = (field_number << 3) | wire_type
  Example: field 2, type varint → (2 << 3) | 0 = 16 = 0x10

TLV (Tag-Length-Value):
  Common binary encoding pattern:
    Tag:    identifies the field/type
    Length: how many bytes of value follow
    Value:  the actual data
  
  Used in: ASN.1/BER, CBOR, many network protocols
  Advantage: skip unknown fields by reading length

Endianness:
  Big-endian (network byte order):   0x12345678 → 12 34 56 78
  Little-endian (x86, ARM, Protobuf): 0x12345678 → 78 56 34 12
  
  Network protocols: typically big-endian (RFC 1700)
  Protobuf: little-endian for fixed types
  MessagePack: big-endian (network order)
  
  Converting: htonl(), ntohl() (C), struct.pack('>I') (Python)

IEEE 754 Float Encoding:
  float32: 1 sign + 8 exponent + 23 mantissa = 4 bytes
  float64: 1 sign + 11 exponent + 52 mantissa = 8 bytes
  
  NaN, Infinity, -0 are valid — deserializers must handle!
  JSON has no NaN/Infinity — need special handling

String Encoding:
  UTF-8: variable width (1-4 bytes per character)
  Protobuf strings: always UTF-8
  MessagePack: UTF-8 with explicit length prefix
  JSON: UTF-8 or UTF-16 (JavaScript), \uXXXX escapes
  
  BOM (Byte Order Mark): 0xEF BB BF for UTF-8 — avoid!
  Length: byte count, NOT character count (important for CJK)
EOF
}

cmd_languages() {
    cat << 'EOF'
=== Language-Specific Deserialization ===

Python:
  JSON:
    import json
    data = json.loads('{"key": "value"}')  # str → dict
    data = json.load(open('file.json'))    # file → dict
    # Custom: json.loads(s, cls=CustomDecoder)
    # Object hook: json.loads(s, object_hook=lambda d: MyClass(**d))
  
  Protobuf:
    from myproto_pb2 import Person
    person = Person()
    person.ParseFromString(binary_data)
    # Or: person = Person.FromString(binary_data)
  
  MessagePack:
    import msgpack
    data = msgpack.unpackb(binary_data, raw=False)
    # raw=False: decode bytes to str (Python 3)
  
  NEVER use pickle for untrusted data!

JavaScript/TypeScript:
  JSON:
    const data = JSON.parse('{"key": "value"}');
    // Reviver: JSON.parse(str, (key, val) => ...)
    // Date handling: JSON.parse(str, dateReviver)
    // BigInt: loses precision for > Number.MAX_SAFE_INTEGER
  
  Protobuf:
    import { Person } from './person_pb';
    const person = Person.deserializeBinary(uint8array);
    // Or protobufjs: Person.decode(buffer)
  
  Validation:
    import { z } from 'zod';
    const schema = z.object({ name: z.string(), age: z.number() });
    const result = schema.safeParse(JSON.parse(input));
    // { success: true, data: {...} } or { success: false, error: ... }

Java:
  JSON (Jackson):
    ObjectMapper mapper = new ObjectMapper();
    Person p = mapper.readValue(jsonStr, Person.class);
    // Type reference for generics:
    List<Person> list = mapper.readValue(json, 
        new TypeReference<List<Person>>(){});
  
  Protobuf:
    Person person = Person.parseFrom(inputStream);
    // Or: Person.parseFrom(byteArray);
  
  NEVER use ObjectInputStream for untrusted data!
  If you must: use ObjectInputFilter (Java 9+) for whitelisting

Go:
  JSON:
    var p Person
    err := json.Unmarshal([]byte(jsonStr), &p)
    // Streaming: json.NewDecoder(reader).Decode(&p)
    // Strict: decoder.DisallowUnknownFields()
  
  Protobuf:
    p := &pb.Person{}
    err := proto.Unmarshal(data, p)

Rust:
  JSON (serde):
    #[derive(Deserialize)]
    struct Person { name: String, age: u32 }
    let p: Person = serde_json::from_str(&json_str)?;
    // Type-safe at compile time!
  
  Protobuf (prost):
    let person = Person::decode(bytes)?;
EOF
}

cmd_performance() {
    cat << 'EOF'
=== Deserialization Performance ===

Benchmark Order (approximate, smaller = faster):
  FlatBuffers:   ~0 (zero-copy, no deserialization!)
  Cap'n Proto:   ~0 (zero-copy)
  Protobuf:      ~1× baseline
  MessagePack:   ~1.5×
  CBOR:          ~2×
  JSON (simdjson): ~3×
  JSON (standard): ~10-20×
  XML:           ~30-50×
  YAML:          ~50-100×

Size Benchmark (100-field message, bytes):
  FlatBuffers:   ~350 bytes
  Protobuf:      ~200 bytes
  MessagePack:   ~250 bytes
  JSON:          ~500 bytes
  XML:           ~1000 bytes

Optimization Techniques:

  Zero-Copy Deserialization:
    Access fields directly from the buffer without copying
    FlatBuffers: table of offsets → field access is pointer arithmetic
    Cap'n Proto: native format IS the wire format
    serde(borrow): borrow strings from input buffer (Rust)
    
    Benefit: no memory allocation, no copy, instant "parse"
    Limitation: buffer must live as long as the object

  Arena Allocation:
    Pre-allocate a memory pool, all objects share it
    Protobuf arenas: Arena arena; auto* msg = Arena::Create<Msg>(&arena);
    One deallocation for all objects (no GC pressure)
    10-50% faster for complex nested messages

  SIMD-Accelerated Parsing:
    simdjson: parse JSON at 2.5 GB/s using SIMD instructions
    Based on: structural character detection via SIMD
    Stages: 1) find structural chars, 2) validate, 3) parse
    Available: C++, Rust bindings, Node.js

  Streaming Deserialization:
    Don't load entire document into memory
    JSON: SAX-style (event-based), or JSON Lines
    Protobuf: delimited messages (length-prefixed)
    XML: SAX parser, StAX (pull parser)
    
    Memory: O(1) vs O(n) for DOM-style parsing

  Object Pooling:
    Reuse deserialized objects instead of allocating new ones
    Protobuf: msg.Clear(); msg.MergeFrom(input);
    Game engines: pool messages per frame
EOF
}

cmd_migration() {
    cat << 'EOF'
=== Data Migration Patterns ===

Envelope Pattern:
  Wrap data with metadata including version:
  {
    "version": 2,
    "type": "UserCreated",
    "timestamp": "2024-03-15T10:30:00Z",
    "data": { ... version 2 payload ... }
  }
  
  Consumer reads version → selects appropriate deserializer
  Each version has its own schema/handler

Dual-Write / Dual-Read:
  Phase 1: Write in old format only (existing behavior)
  Phase 2: Write in BOTH old and new format
  Phase 3: Read from new format (fall back to old)
  Phase 4: Stop writing old format
  Phase 5: Migrate old data, remove old format code
  
  Safe but slow — each phase gets validated before next

Schema Registry Pattern (Kafka):
  1. Producer registers schema → gets schema ID
  2. Message = [magic byte][schema ID (4 bytes)][payload]
  3. Consumer reads schema ID → fetches schema from registry
  4. Deserialize using correct schema version
  
  Compatibility enforcement:
    BACKWARD:  consumer evolved first
    FORWARD:   producer evolved first
    FULL:      either order safe

Polyglot Persistence:
  Different services use different formats:
    Service A: Protobuf (internal, high performance)
    Service B: JSON (REST API, external consumers)
    Service C: Avro (Kafka events, data pipeline)
  
  Translation layer at boundaries:
    API Gateway:  JSON ↔ Protobuf
    Kafka Connect: Avro ↔ JSON (sinks)
    CDC:          Database binlog → Avro events

Version Migration Strategies:
  Lazy migration:
    Convert on read — only migrate when accessed
    Gradual, no downtime, but old data lingers
  
  Eager migration:
    Batch job converts all data to new format
    Fast complete, but needs downtime or dual-read
  
  Event sourcing:
    Events are immutable — never migrate!
    Add "upcast" transformers for old event versions
    Projection rebuilds handle format changes

Cross-Format Translation Tools:
  protoc + json_format: Protobuf ↔ JSON
  avro-tools: Avro ↔ JSON
  jq: JSON transformation
  yq: YAML ↔ JSON ↔ XML
  buf: Protobuf schema management + breaking change detection
EOF
}

show_help() {
    cat << EOF
deserialize v$VERSION — Deserialization Reference

Usage: script.sh <command>

Commands:
  intro       Serialization concepts, formats, golden rules
  formats     JSON, Protobuf, MessagePack, Avro, FlatBuffers
  security    RCE risks, safe patterns, CVE examples
  schemas     Schema evolution, compatibility, versioning
  binary      Wire types, varint, endianness, TLV encoding
  languages   Python, JavaScript, Java, Go, Rust patterns
  performance Zero-copy, SIMD, streaming, benchmarks
  migration   Envelope pattern, dual-write, schema registry
  help        Show this help
  version     Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)       cmd_intro ;;
    formats)     cmd_formats ;;
    security)    cmd_security ;;
    schemas)     cmd_schemas ;;
    binary)      cmd_binary ;;
    languages)   cmd_languages ;;
    performance) cmd_performance ;;
    migration)   cmd_migration ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "deserialize v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
