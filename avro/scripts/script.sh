#!/bin/bash
# Apache Avro - Data Serialization System Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              APACHE AVRO REFERENCE                          ║
║          Schema-Based Data Serialization                    ║
╚══════════════════════════════════════════════════════════════╝

Apache Avro is a data serialization framework that uses JSON-defined
schemas for compact binary encoding. Created by Doug Cutting (Hadoop
creator) for Hadoop ecosystem use cases.

KEY FEATURES:
  Schema-based     Data always has a schema (JSON-defined)
  Compact binary   Smaller than JSON, Protocol Buffers
  Schema evolution Compatible changes without breaking consumers
  Dynamic typing   Schema sent with data (no code generation needed)
  RPC support      Built-in RPC framework
  Language neutral Java, Python, C, C++, C#, Go, Rust, etc.

AVRO vs PROTOBUF vs PARQUET vs JSON:
  ┌──────────────┬──────────┬──────────┬──────────┬──────────┐
  │ Feature      │ Avro     │ Protobuf │ Parquet  │ JSON     │
  ├──────────────┼──────────┼──────────┼──────────┼──────────┤
  │ Format       │ Row      │ Row      │ Column   │ Text     │
  │ Schema       │ JSON     │ .proto   │ Embedded │ None     │
  │ Size         │ Small    │ Smallest │ Smallest*│ Largest  │
  │ Schema evol. │ ✓ Native │ ✓ Good   │ ✓ Good   │ N/A      │
  │ Code gen     │ Optional │ Required │ N/A      │ N/A      │
  │ Human read   │ No       │ No       │ No       │ Yes      │
  │ Splittable   │ ✓        │ ✗        │ ✓        │ ✗        │
  │ Best for     │ Streaming│ APIs     │ Analytics│ Debug    │
  └──────────────┴──────────┴──────────┴──────────┴──────────┘
  * Parquet smallest for analytical workloads due to column compression

WHEN TO USE AVRO:
  ✓ Kafka messages (schema registry)
  ✓ Hadoop/Spark data files
  ✓ Data pipeline serialization
  ✓ Schema evolution is important
  ✓ Language-neutral data exchange
  ✗ Client-server APIs (prefer Protobuf/gRPC)
  ✗ Analytical queries (prefer Parquet)
  ✗ Human-readable configs (prefer JSON/YAML)
EOF
}

cmd_schema() {
cat << 'EOF'
AVRO SCHEMAS
==============

Avro schemas are defined in JSON.

PRIMITIVE TYPES:
  null       No value
  boolean    true/false
  int        32-bit signed integer
  long       64-bit signed integer
  float      32-bit IEEE 754
  double     64-bit IEEE 754
  bytes      Arbitrary bytes
  string     UTF-8 string

COMPLEX TYPES:

  Record (like a struct):
    {
      "type": "record",
      "name": "User",
      "namespace": "com.example",
      "doc": "A user record",
      "fields": [
        {"name": "id", "type": "long"},
        {"name": "username", "type": "string"},
        {"name": "email", "type": ["null", "string"], "default": null},
        {"name": "age", "type": "int", "default": 0},
        {"name": "tags", "type": {"type": "array", "items": "string"}, "default": []},
        {"name": "created_at", "type": {"type": "long", "logicalType": "timestamp-millis"}}
      ]
    }

  Enum:
    {
      "type": "enum",
      "name": "Status",
      "symbols": ["ACTIVE", "INACTIVE", "SUSPENDED"],
      "default": "ACTIVE"
    }

  Array:
    {"type": "array", "items": "string"}
    {"type": "array", "items": {"type": "record", "name": "Address", ...}}

  Map:
    {"type": "map", "values": "string"}
    {"type": "map", "values": "long"}

  Union (nullable/polymorphic):
    ["null", "string"]          → nullable string
    ["null", "int", "string"]   → null, int, or string

  Fixed:
    {"type": "fixed", "name": "MD5", "size": 16}

LOGICAL TYPES:
  date              int (days since epoch)
  time-millis       int (milliseconds since midnight)
  time-micros       long (microseconds since midnight)
  timestamp-millis  long (milliseconds since epoch)
  timestamp-micros  long (microseconds since epoch)
  decimal           bytes/fixed (arbitrary precision)
  uuid              string (UUID format)
  duration          fixed(12) (months, days, millis)

  Example:
    {"name": "order_date", "type": {"type": "int", "logicalType": "date"}}
    {"name": "price", "type": {"type": "bytes", "logicalType": "decimal",
      "precision": 10, "scale": 2}}
EOF
}

cmd_evolution() {
cat << 'EOF'
SCHEMA EVOLUTION
==================

Schema evolution lets you change schemas over time without breaking
existing data or consumers.

COMPATIBLE CHANGES (safe):
  ✓ Add field with default value
  ✓ Remove field that had a default
  ✓ Change field order
  ✓ Promote int → long → float → double
  ✓ Add enum symbol (with default)
  ✓ Add union member

INCOMPATIBLE CHANGES (will break):
  ✗ Remove field without default
  ✗ Add field without default
  ✗ Change field type (except promotions)
  ✗ Rename field (without alias)
  ✗ Remove enum symbol

COMPATIBILITY TYPES:

  BACKWARD compatible:
    New schema can read old data.
    = adding fields with defaults, removing fields.
    Consumer upgrades first.

  FORWARD compatible:
    Old schema can read new data.
    = removing fields, adding fields with defaults.
    Producer upgrades first.

  FULL compatible:
    Both backward AND forward.
    = only add/remove fields with defaults.
    Safest, recommended for production.

  NONE:
    No compatibility checking.
    Dangerous in production.

EVOLUTION EXAMPLES:

  Version 1 (original):
    {"type": "record", "name": "User", "fields": [
      {"name": "name", "type": "string"},
      {"name": "email", "type": "string"}
    ]}

  Version 2 (BACKWARD: add field with default):
    {"type": "record", "name": "User", "fields": [
      {"name": "name", "type": "string"},
      {"name": "email", "type": "string"},
      {"name": "age", "type": "int", "default": 0}     ← NEW
    ]}

  Version 3 (FULL: add nullable field):
    {"type": "record", "name": "User", "fields": [
      {"name": "name", "type": "string"},
      {"name": "email", "type": "string"},
      {"name": "age", "type": "int", "default": 0},
      {"name": "phone", "type": ["null", "string"], "default": null}  ← NEW
    ]}

FIELD ALIASES:
  To rename a field while maintaining compatibility:
    {"name": "full_name", "type": "string", "aliases": ["name"]}
  Old data with "name" maps to "full_name" in new schema.

SCHEMA REGISTRY (Confluent):
  Central store for Avro schemas with compatibility enforcement.

  Register schema:
    curl -X POST http://schema-registry:8081/subjects/users-value/versions \
      -H "Content-Type: application/vnd.schemaregistry.v1+json" \
      -d '{"schema": "{\"type\":\"record\",...}"}'

  Check compatibility:
    curl -X POST http://schema-registry:8081/compatibility/subjects/users-value/versions/latest \
      -H "Content-Type: application/vnd.schemaregistry.v1+json" \
      -d '{"schema": "{...}"}'

  Set compatibility level:
    curl -X PUT http://schema-registry:8081/config/users-value \
      -H "Content-Type: application/vnd.schemaregistry.v1+json" \
      -d '{"compatibility": "FULL"}'
EOF
}

cmd_python() {
cat << 'EOF'
PYTHON USAGE
==============

INSTALL:
  pip install avro-python3    # Official Apache
  pip install fastavro        # Faster alternative (recommended)

FASTAVRO (recommended):

  Write Avro file:
    import fastavro

    schema = {
        "type": "record",
        "name": "User",
        "fields": [
            {"name": "name", "type": "string"},
            {"name": "age", "type": "int"},
            {"name": "email", "type": ["null", "string"], "default": None},
        ]
    }

    records = [
        {"name": "Alice", "age": 30, "email": "alice@example.com"},
        {"name": "Bob", "age": 25, "email": None},
    ]

    with open("users.avro", "wb") as f:
        fastavro.writer(f, schema, records)

  Read Avro file:
    with open("users.avro", "rb") as f:
        reader = fastavro.reader(f)
        schema = reader.writer_schema
        for record in reader:
            print(record)

  Schema validation:
    from fastavro.validation import validate
    validate({"name": "Alice", "age": 30}, schema)  # Returns None if valid
    validate({"name": "Alice"}, schema)  # Raises ValidationError

KAFKA + AVRO:
  pip install confluent-kafka[avro]

  Producer:
    from confluent_kafka import SerializingProducer
    from confluent_kafka.schema_registry import SchemaRegistryClient
    from confluent_kafka.schema_registry.avro import AvroSerializer

    registry = SchemaRegistryClient({"url": "http://schema-registry:8081"})
    serializer = AvroSerializer(registry, schema_str)

    producer = SerializingProducer({
        "bootstrap.servers": "kafka:9092",
        "value.serializer": serializer,
    })

    producer.produce("users", value={"name": "Alice", "age": 30})
    producer.flush()

  Consumer:
    from confluent_kafka import DeserializingConsumer
    from confluent_kafka.schema_registry.avro import AvroDeserializer

    deserializer = AvroDeserializer(registry)
    consumer = DeserializingConsumer({
        "bootstrap.servers": "kafka:9092",
        "group.id": "my-group",
        "value.deserializer": deserializer,
    })
    consumer.subscribe(["users"])

    msg = consumer.poll(1.0)
    if msg: print(msg.value())

PANDAS INTEGRATION:
    import fastavro
    import pandas as pd

    with open("users.avro", "rb") as f:
        records = list(fastavro.reader(f))
    df = pd.DataFrame(records)

    # Write DataFrame to Avro
    records = df.to_dict("records")
    with open("output.avro", "wb") as f:
        fastavro.writer(f, schema, records)
EOF
}

cmd_tools() {
cat << 'EOF'
TOOLS & ECOSYSTEM
===================

CLI TOOLS:

  avro-tools (Java):
    # Convert JSON to Avro
    java -jar avro-tools.jar fromjson --schema-file user.avsc users.json > users.avro

    # Convert Avro to JSON
    java -jar avro-tools.jar tojson users.avro

    # Get schema from Avro file
    java -jar avro-tools.jar getschema users.avro

    # Generate Java classes from schema
    java -jar avro-tools.jar compile schema user.avsc output/

  avro-cli (Python):
    pip install avro-cli
    avro cat users.avro              # Print records
    avro schema users.avro           # Print schema
    avro count users.avro            # Count records

SPARK + AVRO:
  df = spark.read.format("avro").load("users.avro")
  df.write.format("avro").save("output.avro")

  # With schema registry
  df = spark.read \
    .format("avro") \
    .option("avroSchema", schema_json) \
    .load("users.avro")

FLINK + AVRO:
  # Built-in Avro format for Kafka connectors
  CREATE TABLE users (
    name STRING,
    age INT
  ) WITH (
    'connector' = 'kafka',
    'format' = 'avro-confluent',
    'avro-confluent.schema-registry.url' = 'http://registry:8081'
  );

SCHEMA REGISTRY TOOLS:
  # List subjects
  curl http://schema-registry:8081/subjects

  # Get latest schema
  curl http://schema-registry:8081/subjects/users-value/versions/latest

  # Delete subject
  curl -X DELETE http://schema-registry:8081/subjects/users-value

  # Schema Registry UI
  # Confluent Control Center or open-source alternatives:
  # - schema-registry-ui (Landoop)
  # - AKHQ (formerly KafkaHQ)

BEST PRACTICES:
  1. Always use a Schema Registry in production
  2. Set compatibility to FULL or BACKWARD
  3. Use logical types for dates/timestamps/decimals
  4. Make fields nullable with defaults for evolution
  5. Use fastavro over avro-python3 (10x faster)
  6. Include doc strings in schemas for documentation
  7. Namespace your schemas (com.example.events)

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Apache Avro - Data Serialization Reference

Commands:
  intro      Overview, comparison, use cases
  schema     Schema types, logical types, complex structures
  evolution  Compatibility rules, schema registry
  python     fastavro, Kafka integration, pandas
  tools      CLI, Spark, Flink, best practices

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)     cmd_intro ;;
  schema)    cmd_schema ;;
  evolution) cmd_evolution ;;
  python)    cmd_python ;;
  tools)     cmd_tools ;;
  help|*)    show_help ;;
esac
