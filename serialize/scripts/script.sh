#!/usr/bin/env bash
# serialize — Data Serialization Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail
VERSION="1.0.0"

cmd_intro() { cat << 'EOF'
=== Data Serialization ===

Serialization converts structured data (objects, records) into a format
that can be stored or transmitted and reconstructed later.

Classification:
  Text-based:   JSON, XML, YAML, TOML, CSV
  Binary:       Protocol Buffers, MessagePack, Avro, CBOR, BSON
  Schema-ful:   Protobuf, Avro, Thrift (schema required)
  Schema-less:  JSON, MessagePack, CBOR (self-describing)

Trade-offs:
                   Human     Schema    Size   Speed  Schema
                   Readable  Required               Evolution
  JSON             ✓         ✗         Large  Med    Manual
  XML              ✓         Optional  Larger Med    XSD
  YAML             ✓         ✗         Large  Slow   Manual
  Protobuf         ✗         ✓         Small  Fast   Excellent
  MessagePack      ✗         ✗         Med    Fast   Manual
  Avro             ✗         ✓         Small  Fast   Excellent
  CBOR             ✗         ✗         Med    Fast   Manual
  FlatBuffers      ✗         ✓         Small  V.Fast Excellent

When to Choose:
  API responses (public): JSON (universal, human-readable)
  Microservices (internal): Protobuf or gRPC (performance + schema)
  Configuration: YAML or TOML (human-editable)
  Big data / streaming: Avro (schema evolution + Kafka)
  Embedded / IoT: CBOR or MessagePack (compact, schema-less)
  Game development: FlatBuffers (zero-copy access)
  Document storage: BSON (MongoDB native)
EOF
}

cmd_json() { cat << 'EOF'
=== JSON (JavaScript Object Notation) ===

RFC 8259. The universal data interchange format.

Types: string, number, boolean, null, array, object
  {"name": "Alice", "age": 30, "active": true, "address": null}
  [1, 2, 3, "four", true, null]

--- Edge Cases ---
  Numbers: no distinction between int and float
    {"value": 1} and {"value": 1.0} may be treated differently
    Large integers (>2^53) lose precision in JavaScript
    Fix: use strings for IDs ("id": "9007199254740993")

  No comments: JSON doesn't support comments
    Workaround: JSON5, JSONC (VS Code), or use YAML

  No trailing commas: {"a": 1, "b": 2,} is INVALID
    Common source of parse errors

  Unicode: JSON is UTF-8 (or UTF-16/32)
    Escaped: \u0041 = "A"
    Emoji: either literal or \uD83D\uDE00 (surrogate pair)

  No binary data: must base64-encode
    {"image": "iVBORw0KGgo..."} — inflates size by 33%

--- NDJSON (Newline-Delimited JSON) ---
  One JSON object per line, newline-separated
  {"id": 1, "name": "Alice"}
  {"id": 2, "name": "Bob"}

  Advantages:
    Streamable (process line by line)
    Appendable (just add a line)
    No need to parse entire file
  Used by: Elasticsearch bulk API, log aggregators

--- JSON Streaming ---
  Problem: 10GB JSON array doesn't fit in memory
  Solutions:
    NDJSON (one object per line)
    JSON Streaming Parser (SAX-style): ijson (Python), oboe.js
    jq streaming: jq --stream
    JSON Lines (.jsonl) format

--- Performance Tips ---
  Parsing: simha/sonic (Rust), simdjson (C++) — 2-5GB/s
  Avoid pretty-printing in production (whitespace = wasted bytes)
  Compress with gzip: typical 5-10× reduction
  For repeated structures: consider binary format
EOF
}

cmd_protobuf() { cat << 'EOF'
=== Protocol Buffers (Protobuf) ===

Google's binary serialization format. Schema-required, fast, compact.

--- Schema (.proto file) ---
  syntax = "proto3";

  message User {
    int32 id = 1;           // field number 1
    string name = 2;        // field number 2
    string email = 3;       // field number 3
    repeated string tags = 4;  // repeated = array
    Address address = 5;    // nested message

    enum Status {
      UNKNOWN = 0;
      ACTIVE = 1;
      INACTIVE = 2;
    }
    Status status = 6;
  }

  message Address {
    string street = 1;
    string city = 2;
    string country = 3;
  }

--- Wire Format ---
  Each field encoded as: (field_number << 3 | wire_type) + value

  Wire types:
    0: Varint (int32, int64, bool, enum)
    1: 64-bit (double, fixed64)
    2: Length-delimited (string, bytes, nested messages, repeated)
    5: 32-bit (float, fixed32)

  Varint encoding: variable-length, small numbers = fewer bytes
    1 → 0x01 (1 byte)
    300 → 0xAC 0x02 (2 bytes)
    100000 → 0xA0 0x8D 0x06 (3 bytes)

--- Field Numbers ---
  CRITICAL: field numbers are the wire identity
  Never reuse or change field numbers after deployment
  1-15: one byte on wire (use for common fields)
  16-2047: two bytes
  Reserve deprecated field numbers:
    reserved 3, 7;
    reserved "old_field_name";

--- Schema Evolution ---
  Safe changes:
    ✓ Add new fields (old code ignores unknown fields)
    ✓ Remove fields (old code gets default value)
    ✓ Rename fields (wire format uses numbers, not names)
    ✓ Change int32 ↔ int64 (compatible varint encoding)

  Unsafe changes:
    ✗ Change field number (breaks all existing data)
    ✗ Change field type incompatibly (string → int)
    ✗ Change repeated ↔ non-repeated

--- Code Generation ---
  protoc --python_out=. --grpc_python_out=. user.proto
  protoc --go_out=. --go-grpc_out=. user.proto
  protoc --java_out=. user.proto

  Generates: classes with serialize/deserialize methods
  Languages: C++, Java, Python, Go, C#, Rust, Swift, Dart, JS/TS
EOF
}

cmd_msgpack() { cat << 'EOF'
=== MessagePack ===

Binary JSON alternative. Schema-less, compact, fast.
"It's like JSON. but fast and small."

--- Format ---
  Same types as JSON: null, bool, int, float, string, array, map
  Plus: binary data (no base64 needed!)

  Size comparison (typical):
    JSON:      {"compact":true,"schema":0}  → 27 bytes
    MsgPack:   same data                     → 18 bytes (33% smaller)

--- Type System ---
  nil:        0xC0
  false:      0xC2
  true:       0xC3
  integers:   positive fixint (0-127): single byte!
              negative fixint (-32 to -1): single byte
              uint 8/16/32/64, int 8/16/32/64
  float:      float 32, float 64
  string:     fixstr (0-31 bytes), str 8/16/32
  binary:     bin 8/16/32 (raw bytes, unlike JSON)
  array:      fixarray (0-15), array 16/32
  map:        fixmap (0-15), map 16/32
  extension:  application-defined types (timestamp, etc.)

--- Usage ---
  Python: import msgpack
    packed = msgpack.packb({"key": "value"})
    data = msgpack.unpackb(packed)

  JavaScript: import { encode, decode } from "@msgpack/msgpack"
    const packed = encode({key: "value"})
    const data = decode(packed)

--- When to Use ---
  ✓ Internal service communication (no human readability needed)
  ✓ Caching (Redis values, session storage)
  ✓ WebSocket payloads (smaller than JSON)
  ✓ IoT / embedded (memory-constrained)
  ✓ Binary data included (images, files — no base64 overhead)

  ✗ Public APIs (JSON is universal)
  ✗ Configuration files (humans need to edit)
  ✗ Schema enforcement needed (use Protobuf/Avro)
EOF
}

cmd_avro() { cat << 'EOF'
=== Apache Avro ===

Row-oriented binary format with schema evolution. The standard for Kafka.

--- Schema (JSON-defined) ---
  {
    "type": "record",
    "name": "User",
    "namespace": "com.example",
    "fields": [
      {"name": "id", "type": "long"},
      {"name": "name", "type": "string"},
      {"name": "email", "type": ["null", "string"], "default": null},
      {"name": "tags", "type": {"type": "array", "items": "string"}}
    ]
  }

  Union type ["null", "string"] = nullable string
  Default values enable forward compatibility

--- Container File (.avro) ---
  Header: magic bytes + schema (JSON) + sync marker
  Data blocks: compressed records + sync marker

  Schema is embedded IN the file — self-describing
  Reader knows how to interpret data without external schema

--- Schema Evolution ---
  Writer schema: what was used to write the data
  Reader schema: what the reader expects
  Avro resolves differences automatically

  Backward compatible (new reader, old writer):
    ✓ Add field with default value
    ✓ Remove field (reader ignores)

  Forward compatible (old reader, new writer):
    ✓ Add field with default (old reader uses default)
    ✓ Remove field (writer stops sending)

  Full compatibility: both backward AND forward
    Achieved by: always adding fields with defaults,
    never removing required fields

--- Kafka Integration ---
  Confluent Schema Registry:
    Central schema repository for Kafka topics
    Producer registers schema, gets schema ID
    Message: [magic byte][schema ID (4 bytes)][Avro payload]
    Consumer fetches schema from registry by ID
    Schema compatibility enforced (reject incompatible changes)

  Why Avro for Kafka:
    Compact binary (smaller messages = higher throughput)
    Schema evolution (producers/consumers evolve independently)
    Schema registry prevents breaking changes
    Row-oriented (natural for streaming records)
EOF
}

cmd_compare() { cat << 'EOF'
=== Format Comparison ===

--- Size (encoding {"name":"Alice","age":30,"scores":[85,92,78]}) ---
  JSON:        52 bytes
  JSON (gzip): 48 bytes (compressed poorly — too small)
  MsgPack:     35 bytes (33% smaller)
  Protobuf:    22 bytes (58% smaller)
  Avro:        18 bytes (65% smaller, schema not included)
  CBOR:        34 bytes (35% smaller)

  Savings scale with data size:
  1,000 records: JSON ~52KB, Protobuf ~22KB, Avro ~18KB

--- Speed (serialization, relative) ---
  FlatBuffers:  1.0× (fastest — zero-copy)
  Cap'n Proto:  1.1×
  Protobuf:     1.5×
  MessagePack:  2.0×
  Avro:         2.5×
  JSON (simdjson): 3.0×
  JSON (stdlib):   5-10×
  XML:          10-20×
  YAML:         20-50× (slowest — complex parsing)

--- Feature Matrix ---
                  Schema  Evolution  Human   Binary  Streaming
  JSON            ✗       Manual     ✓       ✗       NDJSON
  Protobuf        ✓       ✓✓✓        ✗       ✓       ✓
  Avro            ✓       ✓✓✓        ✗       ✓       ✓
  MsgPack         ✗       Manual     ✗       ✓       ✓
  CBOR            ✗       Manual     ✗       ✓       ✓
  FlatBuffers     ✓       ✓✓         ✗       ✓       ✗
  Thrift          ✓       ✓✓         ✗       ✓       ✓
  XML             XSD     Manual     ✓       ✗       SAX
  YAML            ✗       Manual     ✓✓      ✗       ✗

--- Decision Guide ---
  Need human readability?        → JSON (API), YAML/TOML (config)
  Need maximum performance?      → FlatBuffers, Cap'n Proto
  Need schema + evolution?       → Protobuf (general), Avro (Kafka)
  Need compact + schema-less?    → MessagePack, CBOR
  Need RPC framework?            → gRPC (Protobuf), Thrift
  Need cross-language?           → JSON (universal) or Protobuf (wide)
EOF
}

cmd_schema() { cat << 'EOF'
=== Schema Evolution ===

Schema evolution allows producers and consumers to change their
data schemas independently without breaking each other.

--- Compatibility Types ---

  Backward Compatible:
    New schema can read OLD data
    "I can understand what you wrote before"
    Safe to: add optional fields with defaults, remove fields
    Unsafe: add required fields, change types

  Forward Compatible:
    Old schema can read NEW data
    "You can understand what I write now"
    Safe to: remove fields, add optional fields
    Unsafe: add required fields

  Full Compatible:
    Both backward AND forward
    Most restrictive but safest

  None: no compatibility guarantee (break at will)

--- Evolution Best Practices ---

  1. Never remove required fields
  2. Always add fields with default values
  3. Never change field types (add new field instead)
  4. Never reuse field names/numbers for different purposes
  5. Use union types for nullable (["null", "string"])
  6. Document deprecated fields, remove later

--- Versioning Strategies ---

  Schema-Level Version:
    schema v1, v2, v3 — explicit version number
    Clients negotiate which version to use
    Simple but requires coordinated upgrades

  Field-Level Evolution:
    Add/remove fields without version bump
    Reader handles missing/extra fields gracefully
    Protobuf and Avro designed for this

  URL-Level Version (APIs):
    /api/v1/users, /api/v2/users
    Different schemas at different endpoints
    Simple but doubles API surface

--- Migration Patterns ---
  Blue-green: deploy new schema alongside old
  Dual-write: write both old and new format during transition
  Lazy migration: convert old records when they're read
  Batch migration: convert all records at once (downtime)
EOF
}

cmd_custom() { cat << 'EOF'
=== Custom Serialization ===

Sometimes you need a custom binary protocol for performance,
space, or domain-specific requirements.

--- TLV (Type-Length-Value) ---
  Common pattern for extensible binary protocols.

  [Type: 1-2 bytes][Length: 1-4 bytes][Value: Length bytes]

  Example:
    01 00 05 48 65 6C 6C 6F    Type=1, Length=5, Value="Hello"
    02 00 04 00 00 00 2A        Type=2, Length=4, Value=42

  Advantages: extensible, parsers skip unknown types
  Used by: TLS, RADIUS, DIAMETER, many network protocols

--- Fixed-Size Records ---
  Each record is exactly N bytes, fields at fixed offsets.

  struct Record {
    uint32_t id;        // offset 0, 4 bytes
    char name[32];      // offset 4, 32 bytes
    float score;        // offset 36, 4 bytes
  };  // total: 40 bytes per record

  Advantages: O(1) random access, memory-mapped I/O
  Disadvantages: wasted space for short strings, fixed size limits

--- Varint Encoding ---
  Variable-length integer encoding (used by Protobuf, LEB128).
  Small numbers use fewer bytes.

  Encoding (unsigned):
    Each byte: 7 data bits + 1 continuation bit
    Continuation bit = 1: more bytes follow
    Continuation bit = 0: last byte

    1     → 0x01 (1 byte)
    127   → 0x7F (1 byte)
    128   → 0x80 0x01 (2 bytes)
    300   → 0xAC 0x02 (2 bytes)
    16384 → 0x80 0x80 0x01 (3 bytes)

--- Zero-Copy Techniques ---
  Avoid copying data during deserialization.

  FlatBuffers / Cap'n Proto:
    Data is accessed directly in the serialized buffer
    No parsing step — just cast pointer to struct
    Fastest possible "deserialization" (no deserialization!)

  Memory-mapped files:
    mmap() a file directly into memory
    OS handles paging, no explicit I/O
    Works with fixed-size records

  Arena allocation:
    Allocate all deserialized objects in contiguous memory
    Single free() to release everything
    Cache-friendly, reduces allocation overhead

--- Compression ---
  Apply after serialization for maximum benefit:
    gzip:     good ratio, moderate speed, universal
    zstd:     best ratio/speed balance, dictionary support
    lz4:      fastest compression, moderate ratio
    snappy:   fast decompression, used by Hadoop/Cassandra

  Columnar compression (Parquet, ORC):
    Store values column-by-column instead of row-by-row
    Same-type values compress better (run-length, dictionary)
    10-100× compression ratios on repetitive data
EOF
}

show_help() { cat << EOF
serialize v$VERSION — Data Serialization Reference

Usage: script.sh <command>

Commands:
  intro        Serialization overview and format classification
  json         JSON spec details, edge cases, streaming
  protobuf     Protocol Buffers schema, wire format, evolution
  msgpack      MessagePack binary JSON alternative
  avro         Apache Avro: schema, containers, Kafka integration
  compare      Format comparison: size, speed, features
  schema       Schema evolution and compatibility strategies
  custom       Custom protocols: TLV, varint, zero-copy
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"
case "$CMD" in
    intro) cmd_intro ;; json) cmd_json ;; protobuf) cmd_protobuf ;;
    msgpack) cmd_msgpack ;; avro) cmd_avro ;; compare) cmd_compare ;;
    schema) cmd_schema ;; custom) cmd_custom ;;
    help|--help|-h) show_help ;; version|--version|-v) echo "serialize v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
