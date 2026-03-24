#!/usr/bin/env bash
# feather — Apache Feather/Arrow IPC format reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail
VERSION="1.0.0"

show_help() {
    cat << 'HELPEOF'
feather v1.0.0 — Apache Feather/Arrow IPC Format Reference

Usage: feather <command>

Commands:
  intro          Feather overview, V1 vs V2
  python         pyarrow.feather read/write
  r-lang         R arrow package integration
  schema         Arrow types, nested types
  vs-parquet     Speed vs compression tradeoffs
  pandas         pd.read_feather, to_feather
  compression    lz4/zstd, uncompressed
  best-practices When to use feather

Powered by BytesAgain | bytesagain.com
HELPEOF
}

cmd_intro() {
    cat << 'EOF'
# Apache Feather / Arrow IPC Format

## What is Feather?
Feather is a fast, lightweight columnar file format for storing DataFrames.
It uses the Apache Arrow IPC format, making reads near-instant because data
is stored in the same format Arrow uses in memory — no deserialization needed.

## History
- V1 (2016): Created by Wes McKinney & Hadley Wickham for Python↔R interop
- V2 (2020): Adopted full Arrow IPC format, added compression
- V2 is the current standard; V1 is legacy

## V1 vs V2
| Feature | Feather V1 | Feather V2 (Arrow IPC) |
|---------|-----------|----------------------|
| Format | Custom | Apache Arrow IPC |
| Compression | None | LZ4, ZSTD |
| Nested types | No | Yes (struct, list, map) |
| Metadata | Limited | Full Arrow metadata |
| Language support | Python, R | All Arrow languages |
| Memory mapping | Yes | Yes |

## Key Properties
- **Extremely fast I/O**: No serialization overhead
- **Memory-mappable**: Read without copying into RAM
- **Cross-language**: Python, R, Julia, Rust, C++, Java
- **Not for long-term storage**: Use Parquet for archival
- **Best for**: Intermediate results, caching, IPC between processes

## File Extension
- `.feather` (V1 or V2)
- `.arrow` (V2/Arrow IPC — same format)
- `.ipc` (Arrow IPC)
EOF
}

cmd_python() {
    cat << 'EOF'
# Python — pyarrow.feather

## Install
```bash
pip install pyarrow
```

## Write Feather
```python
import pyarrow as pa
import pyarrow.feather as feather
import pandas as pd

# From pandas DataFrame
df = pd.DataFrame({
    'id': range(1000000),
    'name': [f'user_{i}' for i in range(1000000)],
    'value': np.random.randn(1000000),
    'ts': pd.date_range('2026-01-01', periods=1000000, freq='s'),
})

# Write V2 (default) with compression
feather.write_feather(df, 'data.feather', compression='zstd')

# Write uncompressed (fastest reads)
feather.write_feather(df, 'data.feather', compression='uncompressed')

# Write with LZ4 (fastest compression)
feather.write_feather(df, 'data.feather', compression='lz4')
```

## Read Feather
```python
# Read entire file
df = feather.read_feather('data.feather')

# Read specific columns only
df = feather.read_feather('data.feather', columns=['id', 'value'])

# Read as Arrow Table (no pandas conversion)
table = feather.read_table('data.feather')
# Work with Arrow table directly, convert when needed:
df = table.to_pandas()

# Memory-mapped read (zero-copy for uncompressed)
df = feather.read_feather('data.feather', memory_map=True)
```

## Benchmarks (1M rows, 5 columns)
```
Format          Write     Read      File Size
CSV             2.1s      1.8s      85 MB
Parquet(snappy) 0.5s      0.3s      22 MB
Feather(zstd)   0.2s      0.1s      28 MB
Feather(none)   0.1s      0.05s     65 MB
```
EOF
}

cmd_r_lang() {
    cat << 'EOF'
# R — arrow Package

## Install
```r
install.packages("arrow")
```

## Write Feather
```r
library(arrow)

# Write data.frame to Feather
df <- data.frame(
  id = 1:1000000,
  name = paste0("user_", 1:1000000),
  value = rnorm(1000000)
)

# Write (V2 with LZ4 by default)
write_feather(df, "data.feather")

# Write uncompressed
write_feather(df, "data.feather", compression = "uncompressed")

# Write with ZSTD
write_feather(df, "data.feather", compression = "zstd")
```

## Read Feather
```r
# Read entire file
df <- read_feather("data.feather")

# Read specific columns
df <- read_feather("data.feather", col_select = c("id", "value"))

# Read as Arrow Table
table <- read_feather("data.feather", as_data_frame = FALSE)
# Work with Arrow, convert when needed:
df <- as.data.frame(table)

# Memory-mapped
df <- read_feather("data.feather", mmap = TRUE)
```

## Python ↔ R Interop
```python
# Python writes
feather.write_feather(df, 'shared_data.feather')
```
```r
# R reads — zero conversion issues
df <- read_feather("shared_data.feather")
```

This was the original motivation for Feather:
seamless DataFrame exchange between Python and R.
EOF
}

cmd_schema() {
    cat << 'EOF'
# Arrow Types in Feather

## Primitive Types
| Arrow Type | Python | R |
|-----------|--------|---|
| int8/16/32/64 | int | integer |
| uint8/16/32/64 | int | integer |
| float16/32/64 | float | numeric |
| bool | bool | logical |
| string/utf8 | str | character |
| binary | bytes | raw |
| date32/date64 | datetime.date | Date |
| timestamp | datetime/Timestamp | POSIXct |
| duration | timedelta | difftime |
| decimal128 | Decimal | — |

## Nested Types (V2 only)
```python
import pyarrow as pa

# Struct (named fields)
struct_type = pa.struct([
    ('lat', pa.float64()),
    ('lon', pa.float64()),
    ('city', pa.string()),
])

# List (variable-length array)
list_type = pa.list_(pa.string())

# Map
map_type = pa.map_(pa.string(), pa.int64())

# Create table with nested types
schema = pa.schema([
    ('id', pa.int64()),
    ('location', struct_type),
    ('tags', list_type),
])
```

## Metadata
```python
# Add custom metadata to schema
schema = schema.with_metadata({
    b'author': b'BytesAgain',
    b'version': b'1.0',
})

# Read metadata
table = feather.read_table('data.feather')
print(table.schema.metadata)
```

## Null Handling
- Arrow uses a validity bitmap (1 bit per value)
- Nulls are first-class citizens (not NaN or sentinel values)
- Consistent null handling across all types
EOF
}

cmd_vs_parquet() {
    cat << 'EOF'
# Feather vs Parquet

## Quick Comparison
| Aspect | Feather | Parquet |
|--------|---------|---------|
| Read speed | ⚡ Fastest | Fast |
| Write speed | ⚡ Fastest | Moderate |
| Compression | Good (lz4/zstd) | Best (snappy/gzip/zstd) |
| File size | Larger | Smaller |
| Nested types | Yes (V2) | Yes (native) |
| Predicate pushdown | No | Yes (row groups) |
| Ecosystem | Arrow-native | Universal |
| Partitioning | No | Yes |
| Long-term storage | ❌ No | ✅ Yes |
| Caching/IPC | ✅ Yes | ❌ No |

## When to Use Feather
- Temporary/intermediate data between pipeline steps
- Caching DataFrames to disk for fast reload
- IPC between Python and R (or any Arrow language)
- Interactive data analysis (fast iteration)
- Short-lived data (not archival)

## When to Use Parquet
- Data warehouse / data lake storage
- Long-term archival
- When file size matters (better compression)
- When predicate pushdown is needed (big data queries)
- Cross-platform exchange (widest support)
- Partitioned datasets

## Benchmark (100M rows × 10 columns)
```
                Write      Read       Size
Feather(none)   1.2s       0.5s       8.0 GB
Feather(lz4)    1.8s       0.8s       3.2 GB
Feather(zstd)   3.5s       1.0s       2.1 GB
Parquet(snappy)  5.2s       2.1s       1.8 GB
Parquet(gzip)    12.0s      2.5s       1.2 GB
Parquet(zstd)    6.5s       2.3s       1.3 GB
CSV              45.0s      30.0s      12.0 GB
```

## Rule of Thumb
- **Within a pipeline**: Feather (speed > compression)
- **To disk/lake**: Parquet (compression > speed)
- **Sharing Python↔R**: Feather (native interop)
EOF
}

cmd_pandas() {
    cat << 'EOF'
# Pandas Integration

## Direct Pandas Methods
```python
import pandas as pd

# Write
df.to_feather('data.feather')

# Read
df = pd.read_feather('data.feather')

# Read specific columns
df = pd.read_feather('data.feather', columns=['id', 'value'])
```

## Under the Hood
`pd.read_feather()` and `df.to_feather()` use pyarrow internally.
They're convenience wrappers around `pyarrow.feather`.

## Performance Tips
```python
# 1. Use Arrow string type (less memory than Python objects)
df = pd.read_feather('data.feather', dtype_backend='pyarrow')

# 2. Read only needed columns
df = pd.read_feather('data.feather', columns=['price', 'volume'])

# 3. Memory map for read-only access
import pyarrow.feather as feather
table = feather.read_table('data.feather', memory_map=True)
# Work with Arrow table, convert only what you need
subset = table.select(['price']).to_pandas()
```

## Caching Pattern
```python
import os
import pandas as pd

CACHE = 'processed_data.feather'

if os.path.exists(CACHE):
    df = pd.read_feather(CACHE)   # ~0.05s for 1M rows
else:
    df = expensive_computation()   # ~30s
    df.to_feather(CACHE)           # Cache for next time
```

## Type Mapping
| Pandas | Arrow | Preserved? |
|--------|-------|-----------|
| int64 | int64 | ✅ |
| float64 | double | ✅ |
| bool | bool | ✅ |
| string/object | string | ✅ |
| datetime64 | timestamp | ✅ |
| timedelta64 | duration | ✅ |
| category | dictionary | ✅ |
| Int64 (nullable) | int64 | ✅ |
| object (mixed) | — | ⚠️ May fail |
EOF
}

cmd_compression() {
    cat << 'EOF'
# Feather Compression

## Available Codecs (V2 only)
| Codec | Speed | Ratio | CPU | Default? |
|-------|-------|-------|-----|----------|
| uncompressed | Fastest R/W | 1x | None | No |
| lz4 | Very fast | ~2-3x | Low | Yes (pyarrow) |
| zstd | Fast | ~3-5x | Medium | No |

V1 Feather has NO compression support.

## Usage
```python
import pyarrow.feather as feather

# LZ4 (default, fastest compression)
feather.write_feather(df, 'data.feather', compression='lz4')

# ZSTD (better ratio, slightly slower)
feather.write_feather(df, 'data.feather', compression='zstd')

# ZSTD with compression level
feather.write_feather(df, 'data.feather',
    compression='zstd', compression_level=3)
# Levels 1-22; default ~3; higher = smaller but slower

# Uncompressed (fastest reads, largest files)
feather.write_feather(df, 'data.feather', compression='uncompressed')
```

## When to Use Each
```
Uncompressed:
  - Memory-mapped reads (zero-copy)
  - SSD with fast I/O
  - Small datasets where speed > size
  - Real-time applications

LZ4 (default):
  - General purpose
  - Good balance of speed and size
  - Network transfer (smaller than uncompressed)
  - Most interactive analysis

ZSTD:
  - When file size matters more than write speed
  - Slower storage (HDD, network drives)
  - Caching large datasets
  - Still much faster than Parquet
```

## Compression Ratio by Data Type
```
Integers (sequential):  10-100x compression
Floats (random):        1.5-2x compression
Strings (repetitive):   5-20x compression
Strings (unique):       1.2-1.5x compression
Booleans:               8x compression (bit-packing)
Timestamps:             5-10x compression
```
EOF
}

cmd_best_practices() {
    cat << 'EOF'
# Feather Best Practices

## DO Use Feather For:
1. **Pipeline intermediates**: Step A writes, Step B reads
2. **Notebook caching**: Cache expensive computations
3. **Python↔R exchange**: Native interop, no conversion bugs
4. **Local development**: Fast iteration on data
5. **Testing**: Quick fixture loading

## DON'T Use Feather For:
1. Long-term storage (use Parquet)
2. Data warehousing (use Parquet + partitioning)
3. Version-controlled data (binary diff = useless)
4. Cross-platform exchange with non-Arrow tools (use CSV/Parquet)
5. Append-only logging (not designed for append)

## File Size Guidelines
```
< 100MB:   Feather uncompressed (instant reads)
100MB-1GB: Feather + LZ4 (fast reads, reasonable size)
1GB-10GB:  Feather + ZSTD (need compression)
> 10GB:    Parquet + partitioning (Feather too large)
```

## Pipeline Pattern
```python
# ETL Pipeline with Feather caching
def pipeline():
    # Stage 1: Extract
    raw = extract_from_api()
    raw.to_feather('cache/01_raw.feather')

    # Stage 2: Transform
    clean = transform(raw)
    clean.to_feather('cache/02_clean.feather')

    # Stage 3: Feature engineering
    features = engineer_features(clean)
    features.to_feather('cache/03_features.feather')

    # Stage 4: Final output (Parquet for storage)
    features.to_parquet('output/final.parquet', compression='zstd')
```

## Don't Forget
- Feather files are NOT human-readable (binary)
- No built-in encryption (use filesystem-level)
- No append support (must rewrite entire file)
- Schema must be known at write time
- V1 files should be migrated to V2
EOF
}

case "${1:-help}" in
    intro)          cmd_intro ;;
    python)         cmd_python ;;
    r-lang)         cmd_r_lang ;;
    schema)         cmd_schema ;;
    vs-parquet)     cmd_vs_parquet ;;
    pandas)         cmd_pandas ;;
    compression)    cmd_compression ;;
    best-practices) cmd_best_practices ;;
    help|-h)        show_help ;;
    version|-v)     echo "feather v$VERSION" ;;
    *)              echo "Unknown: $1"; show_help ;;
esac
