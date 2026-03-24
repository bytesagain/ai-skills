#!/usr/bin/env bash
# orc — Apache ORC columnar format reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail
VERSION="1.0.0"

show_help() {
    cat << 'HELPEOF'
orc v1.0.0 — Apache ORC Columnar Format Reference

Usage: orc <command>

Commands:
  intro         ORC overview, Hive origin
  schema        Types, evolution, nested
  compression   ZLIB/SNAPPY/LZO/ZSTD
  read          orc-tools, cat/meta/scan
  write         Writer API, batch/stripe size
  hive          Hive integration, ACID
  spark         Spark ORC support
  performance   Bloom filters, indexes, stats

Powered by BytesAgain | bytesagain.com
HELPEOF
}

cmd_intro() {
    cat << 'EOF'
# Apache ORC — Optimized Row Columnar

## What is ORC?
ORC (Optimized Row Columnar) is a columnar storage format for Hadoop
workloads. Originally developed at Hortonworks for Apache Hive, it
provides efficient compression and fast reads for analytical queries.

## Key Features
- **Columnar storage**: Only reads needed columns
- **Built-in indexes**: Min/max/sum per stripe and column
- **Predicate pushdown**: Skip irrelevant data blocks
- **ACID support**: Full transactional support in Hive
- **Compression**: ZLIB, Snappy, LZO, ZSTD per-column
- **Type evolution**: Add/remove/reorder columns safely
- **Self-describing**: Schema embedded in file

## File Structure
```
ORC File
├── Header (magic: "ORC")
├── Stripe 1 (default ~64MB)
│   ├── Index Data (min/max/bloom per column)
│   ├── Row Data (columnar, compressed)
│   └── Stripe Footer (encoding, stream info)
├── Stripe 2
│   ├── ...
├── Stripe N
├── File Footer (schema, stripe locations, stats)
└── Postscript (compression, version)
```

## ORC vs Parquet
| Feature | ORC | Parquet |
|---------|-----|---------|
| Origin | Hive (Hortonworks) | Dremel (Cloudera/Twitter) |
| Best for | Hive, Presto | Spark, cross-platform |
| ACID | Yes | No |
| Nested types | Good | Better |
| Predicate pushdown | Excellent | Good |
| Ecosystem | Hadoop-centric | Universal |
| Index | Built-in | External |

## Install orc-tools
```bash
# Java-based CLI tools
wget https://dlcdn.apache.org/orc/orc-1.9.2/orc-tools-1.9.2-uber.jar
alias orc-tools="java -jar orc-tools-1.9.2-uber.jar"
```
EOF
}

cmd_schema() {
    cat << 'EOF'
# ORC Schema & Types

## Primitive Types
| Type | Description | Example |
|------|-------------|---------|
| boolean | true/false | true |
| tinyint | 8-bit integer | 127 |
| smallint | 16-bit integer | 32767 |
| int | 32-bit integer | 2147483647 |
| bigint | 64-bit integer | 9223372036854775807 |
| float | 32-bit IEEE 754 | 3.14 |
| double | 64-bit IEEE 754 | 3.14159265 |
| string | UTF-8 string | "hello" |
| varchar(n) | Variable-length (max n) | "hello" |
| char(n) | Fixed-length | "hello     " |
| binary | Byte array | 0xDEADBEEF |
| timestamp | Date + time (nanosec) | 2026-03-24 10:30:00 |
| date | Date only | 2026-03-24 |
| decimal(p,s) | Arbitrary precision | 123.45 |

## Complex Types
```
struct<name:string, age:int>
map<string, int>
array<string>
uniontype<int, string>
```

## Schema in Hive
```sql
CREATE TABLE events (
  event_id    BIGINT,
  event_time  TIMESTAMP,
  user_id     INT,
  event_type  STRING,
  properties  MAP<STRING, STRING>,
  tags        ARRAY<STRING>,
  location    STRUCT<lat:DOUBLE, lon:DOUBLE, city:STRING>
)
STORED AS ORC;
```

## Type Evolution
ORC supports safe schema evolution:
```
✅ Add columns (at the end)
✅ Remove columns (readers skip missing)
✅ Widen types (int → bigint, float → double)
❌ Rename columns (uses position, not name by default)
❌ Narrow types (bigint → int)
❌ Reorder columns (unless using column names)
```

## Schema by Name
```sql
-- Use column names instead of positions
SET hive.orc.schema.resolution=name;
```
EOF
}

cmd_compression() {
    cat << 'EOF'
# ORC Compression

## Compression Codecs
| Codec | Ratio | Speed | CPU | Use Case |
|-------|-------|-------|-----|----------|
| NONE | 1x | Fastest | None | Already compressed data |
| ZLIB | Best | Slow | High | Cold storage, archival |
| SNAPPY | Good | Fast | Low | Hot data, interactive queries |
| LZO | Good | Fast | Low | Similar to Snappy |
| ZSTD | Excellent | Medium | Medium | Best balance (recommended) |
| LZ4 | Moderate | Fastest | Lowest | Real-time analytics |

## Set in Hive
```sql
-- Table level
CREATE TABLE events (...)
STORED AS ORC
TBLPROPERTIES ("orc.compress"="ZSTD");

-- Session level
SET hive.exec.orc.compression.strategy=SPEED;    -- or COMPRESSION
SET orc.compress=ZSTD;
```

## Set in Spark
```python
df.write.orc("path", compression="zstd")

# Or in config
spark.conf.set("spark.sql.orc.compression.codec", "zstd")
```

## Compression Details
- Compression is per-stream (each column stream compressed independently)
- Integer columns use Run Length Encoding (RLE) before compression
- String columns use dictionary encoding + RLE
- Boolean columns use bitwise encoding
- Buffer size default: 256KB (tunable)

## Typical Compression Ratios
```
Raw CSV:     1.0x (baseline)
ORC + NONE:  ~3x  (columnar layout alone helps)
ORC + Snappy: ~5x
ORC + ZLIB:  ~8x
ORC + ZSTD:  ~7x  (close to ZLIB, much faster)
```
EOF
}

cmd_read() {
    cat << 'EOF'
# Reading ORC Files

## orc-tools CLI
```bash
# View file metadata
orc-tools meta file.orc

# Output:
# File Version: 0.12 with ORC_14
# Rows: 1000000
# Compression: ZSTD
# Type: struct<id:bigint,name:string,amount:decimal(10,2),ts:timestamp>
# Stripe Statistics / File Statistics...

# Read data (human-readable)
orc-tools data file.orc

# Read first N rows
orc-tools data file.orc | head -100

# Scan (count rows, verify integrity)
orc-tools scan file.orc

# Convert ORC to JSON
orc-tools convert file.orc

# Convert ORC to CSV
orc-tools data file.orc --format csv
```

## Python (pyarrow)
```python
import pyarrow.orc as orc

# Read entire file
table = orc.read_table('file.orc')
df = table.to_pandas()

# Read specific columns
table = orc.read_table('file.orc', columns=['id', 'name'])

# Read with filter (predicate pushdown)
# Note: pyarrow ORC doesn't support pushdown directly
# Use PyHive or PySpark for pushdown
```

## Java API
```java
import org.apache.orc.*;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;

Configuration conf = new Configuration();
Reader reader = OrcFile.createReader(new Path("file.orc"),
    OrcFile.readerOptions(conf));

// Schema
TypeDescription schema = reader.getSchema();

// Statistics
ColumnStatistics[] stats = reader.getStatistics();

// Read rows
RecordReader rows = reader.rows();
VectorizedRowBatch batch = reader.getSchema().createRowBatch();
while (rows.nextBatch(batch)) {
    // Process batch
}
```

## Predicate Pushdown
```sql
-- Hive automatically pushes down predicates
SELECT * FROM events WHERE event_date = '2026-03-24';
-- ORC skips stripes where min(event_date) > '2026-03-24'
--                     or max(event_date) < '2026-03-24'
```
EOF
}

cmd_write() {
    cat << 'EOF'
# Writing ORC Files

## Python (pyarrow)
```python
import pyarrow as pa
import pyarrow.orc as orc

# Create schema
schema = pa.schema([
    ('id', pa.int64()),
    ('name', pa.string()),
    ('amount', pa.decimal128(10, 2)),
    ('created_at', pa.timestamp('ms')),
])

# Create data
table = pa.table({
    'id': [1, 2, 3],
    'name': ['Alice', 'Bob', 'Charlie'],
    'amount': [pa.scalar(100.50).cast(pa.decimal128(10,2)),
               pa.scalar(200.75).cast(pa.decimal128(10,2)),
               pa.scalar(300.00).cast(pa.decimal128(10,2))],
    'created_at': [1711267200000, 1711353600000, 1711440000000],
}, schema=schema)

# Write ORC
orc.write_table(table, 'output.orc', compression='zstd')
```

## Java API
```java
TypeDescription schema = TypeDescription.createStruct()
    .addField("id", TypeDescription.createLong())
    .addField("name", TypeDescription.createString())
    .addField("amount", TypeDescription.createDecimal());

Writer writer = OrcFile.createWriter(new Path("output.orc"),
    OrcFile.writerOptions(conf)
        .setSchema(schema)
        .compress(CompressionKind.ZSTD)
        .stripeSize(64 * 1024 * 1024)     // 64MB stripes
        .bufferSize(256 * 1024)            // 256KB compression buffer
        .rowIndexStride(10000));            // Index every 10K rows

VectorizedRowBatch batch = schema.createRowBatch();
// ... fill batch ...
writer.addRowBatch(batch);
writer.close();
```

## Writer Tuning
| Parameter | Default | Description |
|-----------|---------|-------------|
| stripe.size | 64MB | Rows per stripe |
| buffer.size | 256KB | Compression buffer |
| row.index.stride | 10000 | Rows per index entry |
| compression | ZLIB | Compression codec |
| bloom.filter.columns | none | Columns with bloom filters |

## Spark Write
```python
df.write \
  .mode("overwrite") \
  .option("compression", "zstd") \
  .option("orc.stripe.size", 67108864) \
  .orc("hdfs:///data/events/")
```
EOF
}

cmd_hive() {
    cat << 'EOF'
# ORC in Apache Hive

## Create ORC Table
```sql
CREATE TABLE events (
  event_id    BIGINT,
  user_id     INT,
  event_type  STRING,
  properties  MAP<STRING, STRING>,
  amount      DECIMAL(10,2)
)
PARTITIONED BY (event_date STRING)
STORED AS ORC
TBLPROPERTIES (
  "orc.compress" = "ZSTD",
  "orc.stripe.size" = "67108864",
  "orc.create.index" = "true",
  "orc.bloom.filter.columns" = "user_id,event_type"
);
```

## ACID Transactions
```sql
-- Enable ACID
SET hive.support.concurrency = true;
SET hive.txn.manager = org.apache.hadoop.hive.ql.lockmgr.DbTxnManager;

-- Create transactional table
CREATE TABLE accounts (
  account_id INT,
  balance    DECIMAL(10,2)
)
STORED AS ORC
TBLPROPERTIES ("transactional"="true");

-- INSERT/UPDATE/DELETE
INSERT INTO accounts VALUES (1, 1000.00);
UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
DELETE FROM accounts WHERE balance = 0;

-- MERGE (upsert)
MERGE INTO target USING source ON target.id = source.id
WHEN MATCHED THEN UPDATE SET amount = source.amount
WHEN NOT MATCHED THEN INSERT VALUES (source.id, source.amount);
```

## Compaction
```sql
-- ACID tables accumulate delta files
-- Minor compaction: merge deltas
ALTER TABLE accounts COMPACT 'minor';

-- Major compaction: rewrite all base + deltas
ALTER TABLE accounts COMPACT 'major';

-- Check compaction status
SHOW COMPACTIONS;
```

## ORC Table Properties
| Property | Default | Description |
|----------|---------|-------------|
| orc.compress | ZLIB | Compression codec |
| orc.stripe.size | 67108864 | Stripe size bytes |
| orc.row.index.stride | 10000 | Index stride |
| orc.create.index | true | Create indexes |
| orc.bloom.filter.columns | "" | Bloom filter columns |
| orc.bloom.filter.fpp | 0.05 | False positive rate |
EOF
}

cmd_spark() {
    cat << 'EOF'
# ORC in Apache Spark

## Read ORC
```python
# Read ORC file
df = spark.read.orc("hdfs:///data/events/")

# Read with schema
from pyspark.sql.types import *
schema = StructType([
    StructField("id", LongType()),
    StructField("name", StringType()),
    StructField("amount", DecimalType(10, 2)),
])
df = spark.read.schema(schema).orc("path/to/orc/")

# Read with predicate pushdown (automatic)
df = spark.read.orc("events/").filter("event_date = '2026-03-24'")
# Spark pushes filter to ORC reader → skips irrelevant stripes
```

## Write ORC
```python
# Write ORC
df.write.orc("output/", mode="overwrite")

# With partitioning
df.write.partitionBy("year", "month").orc("output/")

# With options
df.write \
  .option("compression", "zstd") \
  .option("orc.stripe.size", 67108864) \
  .option("orc.bloom.filter.columns", "user_id") \
  .mode("overwrite") \
  .orc("output/")
```

## Spark SQL
```sql
-- Create temp view from ORC
CREATE TEMPORARY VIEW events USING orc OPTIONS (path "hdfs:///data/events/");

-- Query
SELECT event_type, COUNT(*) FROM events
WHERE event_date >= '2026-03-01'
GROUP BY event_type;

-- Save as ORC
CREATE TABLE events_orc USING ORC
PARTITIONED BY (event_date)
AS SELECT * FROM events;
```

## Schema Merge
```python
# Read ORC files with different schemas
df = spark.read.option("mergeSchema", "true").orc("path/")
```

## Performance Config
```python
spark.conf.set("spark.sql.orc.filterPushdown", "true")    # Default true
spark.conf.set("spark.sql.orc.enableVectorizedReader", "true")
spark.conf.set("spark.sql.hive.convertMetastoreOrc", "true")
```
EOF
}

cmd_performance() {
    cat << 'EOF'
# ORC Performance

## Bloom Filters
Probabilistic data structure that quickly tells if a value is NOT in a column.
```sql
-- Add bloom filter on high-cardinality columns
CREATE TABLE events (...)
STORED AS ORC
TBLPROPERTIES (
  "orc.bloom.filter.columns" = "user_id,session_id",
  "orc.bloom.filter.fpp" = "0.01"   -- 1% false positive rate
);
```

When to use:
- High cardinality columns (user_id, session_id)
- Columns frequently used in WHERE equality filters
- NOT for range queries or low cardinality

## Built-in Indexes
ORC automatically stores per-stripe and per-row-group:
- **Min/Max**: Skip stripes where value out of range
- **Sum/Count**: Aggregate without reading data
- **Has null**: Skip null checks

```sql
-- Example: WHERE amount > 1000
-- ORC checks: if max(amount) in stripe < 1000 → skip entire stripe
```

## File Statistics
```bash
orc-tools meta file.orc
# Shows per-column statistics:
# Column 0 (id): min=1, max=1000000, hasNull=false
# Column 1 (name): min="Aaron", max="Zara"
# Column 2 (amount): min=0.01, max=99999.99, sum=45678901.23
```

## Stripe Sizing
```
Small stripes (16MB):
  + Faster predicate pushdown (more stripes to skip)
  - More overhead (more footers/indexes)
  - Less compression efficiency

Large stripes (256MB):
  + Better compression ratio
  + Less overhead
  - Less granular predicate pushdown
  - More memory for read

Recommended: 64MB (default) for most workloads
```

## Vectorized Reading
ORC supports vectorized (batch) reading — processes 1024 rows at a time
instead of row-by-row. This enables:
- CPU cache efficiency
- SIMD operations
- 10-100x faster than row-at-a-time

## Tips
1. Partition by date/region for coarse filtering
2. Sort data by frequently-filtered columns before writing
3. Use bloom filters on equality-filtered columns
4. Use ZSTD for best compression/speed balance
5. Keep stripe size at 64MB unless you have reason to change
6. Enable vectorized reader in your engine
EOF
}

case "${1:-help}" in
    intro)       cmd_intro ;;
    schema)      cmd_schema ;;
    compression) cmd_compression ;;
    read)        cmd_read ;;
    write)       cmd_write ;;
    hive)        cmd_hive ;;
    spark)       cmd_spark ;;
    performance) cmd_performance ;;
    help|-h)     show_help ;;
    version|-v)  echo "orc v$VERSION" ;;
    *)           echo "Unknown: $1"; show_help ;;
esac
