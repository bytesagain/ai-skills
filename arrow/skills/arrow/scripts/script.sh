#!/usr/bin/env bash
# arrow — Apache Arrow columnar memory format reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail
VERSION="1.0.0"

show_help() {
    cat << 'HELPEOF'
arrow v1.0.0 — Apache Arrow Columnar Memory Format Reference

Usage: arrow <command>

Commands:
  intro         Arrow overview, zero-copy IPC
  format        Record batches, buffers, validity
  python        pyarrow Table, RecordBatch, compute
  flight        Arrow Flight RPC protocol
  dataset       Dataset API, partitioning, filtering
  integration   pandas/spark/duckdb/polars interop
  gandiva       LLVM expression compiler
  ecosystem     Implementations across languages

Powered by BytesAgain | bytesagain.com
HELPEOF
}

cmd_intro() {
    cat << 'EOF'
# Apache Arrow — In-Memory Columnar Format

## What is Arrow?
Apache Arrow is a cross-language development platform for in-memory
columnar data. It specifies a standardized memory format that eliminates
serialization overhead when sharing data between systems.

## Key Innovation: Zero-Copy
Traditional data exchange:
```
System A (pandas) → serialize to CSV/JSON → deserialize → System B (Spark)
                    ~seconds for 1GB                        ~seconds
```

Arrow data exchange:
```
System A (pandas) → shared Arrow memory → System B (Spark)
                    ~zero overhead
```

## Core Features
- **Columnar memory layout**: CPU-cache friendly, SIMD vectorization
- **Zero-copy reads**: Memory-map files, no deserialization
- **Cross-language**: Same memory format in C++/Java/Rust/Python/Go/JS/R
- **Rich type system**: Primitives, nested (struct/list/map), temporal, decimal
- **IPC**: Streaming and file formats for inter-process communication
- **Flight**: High-performance RPC for Arrow data transfer
- **Compute kernels**: Built-in functions (filter, sort, aggregate)

## Architecture
```
Applications:  pandas  Spark  DuckDB  Polars  R  Julia
                  │       │      │       │    │    │
                  └───────┴──────┴───────┴────┴────┘
                              Arrow Memory Format
                              (shared standard)
                  ┌───────┬──────┬───────┬────┬────┐
                  │       │      │       │    │    │
Formats:       Parquet  ORC   CSV    JSON  IPC  Flight
```

## Install
```bash
pip install pyarrow          # Python
install.packages("arrow")   # R
cargo add arrow              # Rust
go get github.com/apache/arrow/go  # Go
```
EOF
}

cmd_format() {
    cat << 'EOF'
# Arrow Memory Format

## Columnar Layout
```
Row-oriented (CSV/JSON):
  Row 0: {id: 1, name: "Alice", age: 30}
  Row 1: {id: 2, name: "Bob",   age: 25}
  Row 2: {id: 3, name: "Carol", age: 35}

Column-oriented (Arrow):
  id:   [1, 2, 3]           ← contiguous int64 buffer
  name: ["Alice","Bob","Carol"] ← offsets + char buffer
  age:  [30, 25, 35]        ← contiguous int64 buffer
```

## Buffer Structure
Each column (Array) has:
1. **Validity bitmap**: 1 bit per value (null tracking)
2. **Data buffer**: Actual values (fixed-width) or offsets + chars (variable)

```
Int64 Array [1, null, 3]:
  Validity:  [1, 0, 1]          (bitmap: 0b101)
  Data:      [1, undefined, 3]  (64 bits each)

String Array ["hi", "bye"]:
  Validity:  [1, 1]
  Offsets:   [0, 2, 5]          (int32)
  Chars:     "hibye"            (UTF-8 bytes)
```

## Record Batch
A collection of equal-length arrays with a schema:
```python
import pyarrow as pa

schema = pa.schema([
    ('id', pa.int64()),
    ('name', pa.string()),
    ('score', pa.float64()),
])

batch = pa.record_batch([
    pa.array([1, 2, 3]),
    pa.array(["a", "b", "c"]),
    pa.array([0.1, 0.2, 0.3]),
], schema=schema)

print(batch.num_rows)     # 3
print(batch.num_columns)  # 3
print(batch.nbytes)       # bytes in memory
```

## Table (Collection of Batches)
```python
table = pa.table({
    'id': [1, 2, 3, 4, 5],
    'name': ['a', 'b', 'c', 'd', 'e'],
})

# Table can span multiple record batches
# Useful for streaming/chunked processing
print(table.num_rows)
print(table.column_names)
print(table.schema)
```

## Type System
| Category | Types |
|----------|-------|
| Integer | int8/16/32/64, uint8/16/32/64 |
| Float | float16/32/64 |
| String | utf8, large_utf8, binary |
| Temporal | date32, timestamp, time32/64, duration |
| Nested | struct, list, large_list, map |
| Other | bool, decimal128, null, dictionary |
EOF
}

cmd_python() {
    cat << 'EOF'
# Python — pyarrow

## Arrays
```python
import pyarrow as pa

# Create arrays
arr = pa.array([1, 2, 3, None, 5])
print(arr.type)       # int64
print(arr.null_count)  # 1
print(arr[0].as_py())  # 1

# Typed arrays
f = pa.array([1.1, 2.2], type=pa.float32())
s = pa.array(["hello", "world"])
b = pa.array([True, False, None])
```

## Tables
```python
# Create table
table = pa.table({
    'id': pa.array([1, 2, 3]),
    'name': pa.array(['Alice', 'Bob', 'Carol']),
    'score': pa.array([85.5, 92.0, 78.3]),
})

# Access columns
print(table.column('name'))
print(table['score'])

# Filter
mask = pa.compute.greater(table['score'], 80)
filtered = table.filter(mask)

# Sort
sorted_t = table.sort_by([('score', 'descending')])

# Select columns
subset = table.select(['id', 'name'])

# Add column
table = table.append_column('rank', pa.array([2, 1, 3]))

# Drop column
table = table.drop(['rank'])
```

## Compute Functions
```python
import pyarrow.compute as pc

# Aggregations
pc.sum(table['score'])        # 255.8
pc.mean(table['score'])       # 85.27
pc.min_max(table['score'])    # {'min': 78.3, 'max': 92.0}
pc.count(table['score'])      # 3

# String operations
pc.utf8_upper(table['name'])
pc.utf8_length(table['name'])
pc.match_substring(table['name'], 'li')

# Arithmetic
pc.add(table['score'], 10)
pc.multiply(table['score'], 1.1)

# Filtering
pc.filter(table['name'], pc.greater(table['score'], 80))

# Sorting
pc.sort_indices(table['score'], sort_keys=[('score', 'ascending')])
```

## Pandas Conversion
```python
# Arrow → Pandas
df = table.to_pandas()

# Pandas → Arrow
table = pa.Table.from_pandas(df)

# Zero-copy (when possible)
table = pa.Table.from_pandas(df, preserve_index=False)

# Use Arrow-backed pandas dtypes (less memory)
df = table.to_pandas(types_mapper=pd.ArrowDtype)
```

## I/O
```python
import pyarrow.parquet as pq
import pyarrow.feather as feather
import pyarrow.csv as csv

# Parquet
pq.write_table(table, 'data.parquet')
table = pq.read_table('data.parquet')

# Feather/IPC
feather.write_feather(table, 'data.feather')
table = feather.read_table('data.feather')

# CSV
csv.write_csv(table, 'data.csv')
table = csv.read_csv('data.csv')

# IPC Stream
with pa.ipc.new_file('data.arrow', table.schema) as writer:
    writer.write_table(table)
reader = pa.ipc.open_file('data.arrow')
table = reader.read_all()
```
EOF
}

cmd_flight() {
    cat << 'EOF'
# Arrow Flight — High-Performance Data RPC

## What is Flight?
Arrow Flight is a RPC framework for high-performance data transfer
built on gRPC. It transfers Arrow record batches with zero serialization
overhead — data stays in Arrow format end-to-end.

## Architecture
```
Client                        Server
  │                              │
  ├── GetFlightInfo() ────────→  │  "What data do you have?"
  │                              │
  ├── DoGet(ticket) ──────────→  │  "Give me this dataset"
  │  ←── RecordBatch stream ──   │   (Arrow format, zero-copy)
  │                              │
  ├── DoPut(stream) ──────────→  │  "Here's data to store"
  │   ── RecordBatch stream ──→  │
  │                              │
  ├── DoAction(action) ───────→  │  "Run this command"
  │                              │
  └── ListFlights() ──────────→  │  "List available datasets"
```

## Server Example
```python
import pyarrow.flight as flight

class MyFlightServer(flight.FlightServerBase):
    def __init__(self):
        super().__init__("grpc://0.0.0.0:8815")
        self.tables = {}

    def do_put(self, context, descriptor, reader, writer):
        key = descriptor.path[0].decode()
        self.tables[key] = reader.read_all()

    def do_get(self, context, ticket):
        key = ticket.ticket.decode()
        table = self.tables[key]
        return flight.RecordBatchStream(table)

    def list_flights(self, context, criteria):
        for key, table in self.tables.items():
            descriptor = flight.FlightDescriptor.for_path(key)
            info = flight.FlightInfo(
                table.schema, descriptor, [], table.num_rows, -1)
            yield info

server = MyFlightServer()
server.serve()
```

## Client Example
```python
client = flight.connect("grpc://localhost:8815")

# Upload data
table = pa.table({'x': [1, 2, 3]})
descriptor = flight.FlightDescriptor.for_path("my_data")
writer, _ = client.do_put(descriptor, table.schema)
writer.write_table(table)
writer.close()

# Download data
ticket = flight.Ticket(b"my_data")
reader = client.do_get(ticket)
result = reader.read_all()
```

## Performance
- **10-100x faster** than REST/JSON for large datasets
- Zero serialization (Arrow format on wire = Arrow format in memory)
- Parallel streams for multi-partition datasets
- Built-in authentication and encryption (TLS)

## Use Cases
- Database query results (DuckDB, Dremio, InfluxDB use Flight)
- Distributed ML feature serving
- Real-time analytics pipelines
- Cross-language data transfer
EOF
}

cmd_dataset() {
    cat << 'EOF'
# Dataset API — Large-Scale Data Access

## What is the Dataset API?
The Dataset API provides uniform access to large, potentially multi-file
datasets. It handles partitioning, predicate pushdown, and column projection
across Parquet, ORC, CSV, and IPC files.

## Read Dataset
```python
import pyarrow.dataset as ds

# Single file
dataset = ds.dataset('data.parquet')

# Directory of files
dataset = ds.dataset('data/', format='parquet')

# Partitioned directory
# data/year=2025/month=01/part-0.parquet
# data/year=2025/month=02/part-0.parquet
dataset = ds.dataset('data/', format='parquet', partitioning='hive')

# Multiple formats
dataset = ds.dataset([
    ds.dataset('parquet_files/', format='parquet'),
    ds.dataset('csv_files/', format='csv'),
])
```

## Filter (Predicate Pushdown)
```python
# Filter pushes down to file reader (skips irrelevant row groups)
table = dataset.to_table(
    filter=(ds.field('year') == 2026) & (ds.field('amount') > 100),
    columns=['id', 'name', 'amount']
)

# Scanner for fine-grained control
scanner = dataset.scanner(
    filter=ds.field('status') == 'active',
    columns=['id', 'name'],
    batch_size=10000,
)
for batch in scanner.to_batches():
    process(batch)
```

## Write Partitioned Dataset
```python
import pyarrow.dataset as ds

ds.write_dataset(
    table,
    'output/',
    format='parquet',
    partitioning=ds.partitioning(
        pa.schema([('year', pa.int32()), ('month', pa.int32())]),
        flavor='hive',
    ),
    existing_data_behavior='overwrite_or_ignore',
)
```

## Partitioning Schemes
```python
# Hive-style: data/year=2026/month=03/
hive = ds.HivePartitioning(schema)

# Directory-style: data/2026/03/
dir_part = ds.DirectoryPartitioning(schema)

# Custom
ds.partitioning(
    field_names=['date', 'region'],
    flavor='hive',
)
```
EOF
}

cmd_integration() {
    cat << 'EOF'
# Arrow Integration with Other Tools

## Pandas
```python
import pyarrow as pa
import pandas as pd

# Pandas → Arrow (zero-copy when possible)
table = pa.Table.from_pandas(df)

# Arrow → Pandas
df = table.to_pandas()

# Arrow-backed pandas (2.0+, less memory)
df = table.to_pandas(types_mapper=pd.ArrowDtype)
```

## DuckDB
```python
import duckdb

# DuckDB reads Arrow tables directly (zero-copy)
table = pa.table({'x': [1, 2, 3], 'y': ['a', 'b', 'c']})

result = duckdb.sql("SELECT * FROM table WHERE x > 1")
arrow_result = result.arrow()  # Returns Arrow table

# DuckDB + Arrow + Parquet
result = duckdb.sql("""
    SELECT year, SUM(amount)
    FROM read_parquet('data/*.parquet')
    GROUP BY year
""").arrow()
```

## Polars
```python
import polars as pl

# Polars uses Arrow internally
df = pl.DataFrame({'x': [1, 2, 3]})
arrow_table = df.to_arrow()

# Arrow → Polars
df = pl.from_arrow(arrow_table)
```

## Spark
```python
# PySpark ↔ Arrow (for UDFs and toPandas)
spark.conf.set("spark.sql.execution.arrow.pyspark.enabled", "true")

# Fast toPandas (uses Arrow transfer)
df = spark_df.toPandas()  # Uses Arrow behind the scenes

# Arrow-based UDF
@pandas_udf("double")
def multiply(s: pd.Series) -> pd.Series:
    return s * 2

spark_df.select(multiply(col("value")))
```

## R
```r
library(arrow)

# Read Arrow IPC file
table <- read_ipc_file("data.arrow")
df <- as.data.frame(table)

# Write
write_ipc_file(table, "output.arrow")

# Shared with Python (same format, no conversion)
```

## Rust
```rust
use arrow::array::*;
use arrow::datatypes::*;
use arrow::record_batch::RecordBatch;

let id = Int64Array::from(vec![1, 2, 3]);
let name = StringArray::from(vec!["a", "b", "c"]);

let schema = Schema::new(vec![
    Field::new("id", DataType::Int64, false),
    Field::new("name", DataType::Utf8, false),
]);

let batch = RecordBatch::try_new(
    Arc::new(schema), vec![Arc::new(id), Arc::new(name)]
)?;
```
EOF
}

cmd_gandiva() {
    cat << 'EOF'
# Gandiva — LLVM Expression Compiler

## What is Gandiva?
Gandiva compiles Arrow compute expressions to native machine code
using LLVM. It provides 10-100x speedup over interpreted evaluation
for filter and project operations.

## How It Works
```
Expression: (score > 80) AND (status = 'active')
    │
    ▼ Gandiva compiles to
    │
LLVM IR → Native Machine Code (x86/ARM)
    │
    ▼ Executes directly on
    │
Arrow Record Batches (columnar, SIMD-friendly)
```

## Python Usage
```python
import pyarrow.gandiva as gandiva

# Create schema
schema = pa.schema([
    ('score', pa.float64()),
    ('name', pa.string()),
    ('active', pa.bool_()),
])

# Build filter expression
builder = gandiva.TreeExprBuilder()
score_field = builder.make_field(schema.field('score'))
threshold = builder.make_literal(80.0, pa.float64())
condition = builder.make_function("greater_than",
    [score_field, threshold], pa.bool_())

# Compile filter
filter_ = gandiva.make_filter(schema, condition)

# Apply to record batch
batch = pa.record_batch(...)
result = filter_.evaluate(batch.num_rows, batch)
# result contains indices where condition is true
```

## Supported Operations
| Category | Operations |
|----------|-----------|
| Comparison | =, !=, <, >, <=, >= |
| Arithmetic | +, -, *, /, % |
| Logical | AND, OR, NOT |
| String | like, length, upper, lower, substr |
| Temporal | extract(year/month/day), timestampdiff |
| Math | abs, ceil, floor, round, power, log |
| Null | isnull, isnotnull, nvl, if_null |
| Cast | cast(expr, type) |

## When to Use
- Large batch processing (>100K rows)
- Complex filter expressions
- Repeated evaluation on same schema
- CPU-bound workloads where vectorization matters
- NOT for small datasets (compilation overhead)
EOF
}

cmd_ecosystem() {
    cat << 'EOF'
# Arrow Ecosystem

## Language Implementations
| Language | Library | Maturity |
|----------|---------|----------|
| C++ | libarrow | Reference impl |
| Java | arrow-java | Production |
| Rust | arrow-rs | Production |
| Python | pyarrow (C++ bindings) | Production |
| Go | arrow/go | Production |
| JavaScript | arrow-js | Stable |
| R | arrow (C++ bindings) | Production |
| Julia | Arrow.jl | Stable |
| C# | Apache.Arrow | Stable |
| Ruby | red-arrow | Beta |
| MATLAB | arrow (C++ bindings) | Beta |

## Projects Using Arrow
| Project | How |
|---------|-----|
| pandas | Arrow backend for dtypes (2.0+) |
| Polars | Built entirely on Arrow |
| DuckDB | Native Arrow integration |
| Spark | Arrow for pandas UDFs, toPandas |
| Dremio | Arrow Flight for queries |
| InfluxDB IOx | Arrow + Flight for time-series |
| DataFusion | Arrow-native query engine |
| Ballista | Distributed SQL on Arrow |
| Velox | Meta's Arrow-compatible engine |
| ADBC | Arrow Database Connectivity |

## ADBC (Arrow Database Connectivity)
```python
import adbc_driver_postgresql.dbapi

# Connect to PostgreSQL
conn = adbc_driver_postgresql.dbapi.connect(
    "postgresql://user:pass@localhost/mydb"
)
cursor = conn.cursor()
cursor.execute("SELECT * FROM users")

# Results come as Arrow tables (zero-copy from DB)
table = cursor.fetch_arrow_table()
```

ADBC is the Arrow-native successor to JDBC/ODBC.
Supported databases: PostgreSQL, SQLite, Snowflake, Flight SQL.

## Key Specifications
| Spec | Purpose |
|------|---------|
| Columnar Format | Memory layout |
| IPC Format | File and streaming serialization |
| Flight | RPC data transfer |
| Flight SQL | SQL queries over Flight |
| ADBC | Database connectivity |
| C Data Interface | Zero-copy across FFI |
| C Stream Interface | Streaming across FFI |
EOF
}

case "${1:-help}" in
    intro)       cmd_intro ;;
    format)      cmd_format ;;
    python)      cmd_python ;;
    flight)      cmd_flight ;;
    dataset)     cmd_dataset ;;
    integration) cmd_integration ;;
    gandiva)     cmd_gandiva ;;
    ecosystem)   cmd_ecosystem ;;
    help|-h)     show_help ;;
    version|-v)  echo "arrow v$VERSION" ;;
    *)           echo "Unknown: $1"; show_help ;;
esac
