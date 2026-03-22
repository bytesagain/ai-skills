#!/usr/bin/env bash
# split — Data Splitting Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Data Splitting ===

Splitting is the process of dividing data into smaller, meaningful parts.
It's one of the most fundamental operations in computing.

Core Concepts:
  Delimiter     Character or pattern that marks boundaries
  Token         Individual piece resulting from a split
  Partition     A subset of the original dataset
  Chunk         A fixed-size segment of data
  Shard         A partition in a distributed system

Common Use Cases:
  String processing   Parse CSV, split paths, tokenize text
  File management     Break large files into uploadable chunks
  Machine learning    Divide data into train/validation/test sets
  Databases           Partition tables across servers (sharding)
  Distributed systems Load balancing across nodes

Split Properties:
  Exhaustive    Every element belongs to exactly one partition
  Disjoint      No element appears in multiple partitions
  Balanced      Partitions are approximately equal in size
  Deterministic Same input always produces same split

Key Decisions:
  1. What to split on? (delimiter, size, predicate, hash)
  2. How many parts? (fixed count vs. dynamic)
  3. Keep or discard the delimiter?
  4. Handle edge cases? (empty tokens, trailing delimiters)
  5. Preserve order? (ordered vs. unordered partitions)
EOF
}

cmd_string() {
    cat << 'EOF'
=== String Splitting Techniques ===

By Delimiter:
  Input:  "apple,banana,cherry"
  Split:  delimiter = ","
  Result: ["apple", "banana", "cherry"]
  
  Considerations:
    - Single char vs multi-char delimiter
    - Consecutive delimiters: "a,,b" → ["a","","b"] or ["a","b"]?
    - Leading/trailing: ",a,b," → ["","a","b",""] ?
    - Escaped delimiters: "a\,b,c" → ["a,b","c"]

By Regex Pattern:
  Input:  "one1two22three333four"
  Split:  pattern = \d+
  Result: ["one", "two", "three", "four"]
  
  Common patterns:
    \s+         Split on whitespace (any amount)
    [,;\t]      Split on comma, semicolon, or tab
    (?<=\.)     Split after period (lookahead)
    \r?\n       Split on newlines (cross-platform)

Fixed Width:
  Input:  "JOHNDOE   19850315NYC"
  Fields: name[10] + date[8] + city[3]
  Result: ["JOHNDOE   ", "19850315", "NYC"]
  Used in: COBOL records, fixed-width data files, mainframe output

Tokenization (NLP):
  Word tokenization:  "Don't stop" → ["Don't", "stop"] or ["Do", "n't", "stop"]
  Sentence splitting: Uses rules for ".", "!", "?" with abbreviation handling
  Subword (BPE):      "unhappiness" → ["un", "happi", "ness"]
  
  Challenges:
    - Abbreviations: "Dr. Smith" (not a sentence boundary)
    - Contractions: "can't" → "can" + "not" or "can't"?
    - Hyphenated words: "well-known" → 1 or 2 tokens?
    - URLs, emails: contain delimiters but shouldn't split

CSV Parsing (RFC 4180):
  Fields separated by commas
  Quoted fields can contain commas: "Smith, John",42
  Escaped quotes: "He said ""hello"""
  Newlines in quoted fields are literal
  Never split CSV by simple comma — use a proper parser
EOF
}

cmd_file() {
    cat << 'EOF'
=== File Splitting Methods ===

By Size (bytes):
  split -b 100M largefile.bin part_
  Result: part_aa (100M), part_ab (100M), part_ac (remainder)
  Use: Upload limits, media chunking, backup tapes

By Lines:
  split -l 10000 data.csv chunk_
  Result: chunk_aa (10K lines), chunk_ab (10K lines), ...
  Use: Parallel processing, batch imports

By Pattern (context-aware):
  csplit access.log '/^2024-01/' '{*}'
  Result: Split at each line matching pattern
  Use: Split logs by date, split XML by record boundary

By Record Count:
  awk 'NR%1000==1{file="chunk_"++i".csv"} {print > file}' data.csv
  Use: Database batch inserts, API bulk operations

Round-Robin (distribute evenly):
  awk '{print > ("shard_" NR%4 ".txt")}' input.txt
  Result: 4 files with interleaved lines
  Use: Load balancing, parallel worker distribution

Preserving Headers:
  # Split CSV keeping header in each chunk
  head -1 data.csv > header.txt
  tail -n +2 data.csv | split -l 10000 - chunk_
  for f in chunk_*; do cat header.txt "$f" > "h_$f"; done
  Critical for: CSV/TSV files processed independently

Common Tools:
  split      GNU coreutils — split by size or lines
  csplit     Context-aware split by pattern
  awk        Flexible splitting with custom logic
  zipsplit   Split zip archives
  tar        Split with: tar cf - dir | split -b 1G - archive_
  ffmpeg     Split video: ffmpeg -ss 00:05:00 -t 00:10:00

Reassembly:
  cat part_* > reassembled.bin
  Verify: md5sum original.bin reassembled.bin
EOF
}

cmd_dataset() {
    cat << 'EOF'
=== ML Dataset Splitting ===

Standard Split (Train/Validation/Test):
  Train       60-80%  Model learns from this data
  Validation  10-20%  Tune hyperparameters, prevent overfitting
  Test        10-20%  Final evaluation (touch only once!)

  Rule: NEVER use test data during training or tuning
  Test set = your "exam" — looking at answers invalidates it

Random Split:
  Simple random sampling
  sklearn: train_test_split(X, y, test_size=0.2, random_state=42)
  Pros: Simple, unbiased for large datasets
  Cons: May not preserve class distribution

Stratified Split:
  Maintains class proportions in each subset
  Critical when: Imbalanced classes (e.g., 95% negative, 5% positive)
  sklearn: train_test_split(X, y, stratify=y, test_size=0.2)
  Example:
    Full data:  90% cat, 10% dog
    Train set:  90% cat, 10% dog  ✓ (preserved)
    Test set:   90% cat, 10% dog  ✓ (preserved)

K-Fold Cross-Validation:
  Split data into K equal folds (typically K=5 or 10)
  Train on K-1 folds, validate on remaining fold
  Repeat K times, each fold serving as validation once
  Report: mean ± std of metric across folds
  
  Variants:
    Stratified K-Fold     Preserve class distribution
    Repeated K-Fold       Run K-Fold multiple times
    Leave-One-Out (LOO)   K = number of samples (expensive)
    Group K-Fold          Keep groups together (e.g., same patient)

Time-Series Split:
  NEVER shuffle time series data!
  Train on past, validate/test on future
  Walk-forward validation:
    Fold 1: Train [1-100],    Test [101-120]
    Fold 2: Train [1-120],    Test [121-140]
    Fold 3: Train [1-140],    Test [141-160]
  Expanding window vs sliding window

Group-Aware Split:
  Keep related samples together
  Example: Multiple images from same patient
  All images from one patient in same split
  Prevents data leakage through correlated samples

Data Leakage Red Flags:
  - Normalizing before splitting (fit scaler on ALL data)
  - Feature selection using full dataset
  - Duplicate samples across splits
  - Temporal data shuffled randomly
  - Target encoding using test data statistics
EOF
}

cmd_database() {
    cat << 'EOF'
=== Database Partitioning ===

Horizontal Partitioning (Sharding):
  Split rows across multiple tables/servers
  Each partition has same schema, different data
  
  Range Partitioning:
    Partition by value range
    Example: orders_2023, orders_2024 (by date)
    Example: users_A_M, users_N_Z (by name)
    Pros: Simple, range queries efficient
    Cons: Hotspots if data distribution uneven

  Hash Partitioning:
    partition = hash(key) % num_partitions
    Example: user_id % 4 → partition 0-3
    Pros: Even distribution, no hotspots
    Cons: Range queries must hit all partitions

  List Partitioning:
    Explicit mapping of values to partitions
    Example: region IN ('US','CA') → partition_americas
             region IN ('UK','DE') → partition_europe
    Pros: Logical grouping, query routing
    Cons: Manual maintenance

Vertical Partitioning:
  Split columns across tables
  Keep frequently-accessed columns together
  Example:
    users_core: id, name, email (hot data)
    users_profile: id, bio, avatar, preferences (cold data)
  Pros: Reduce I/O, different storage tiers
  Cons: Joins required for full record

Composite Partitioning:
  Combine strategies
  Example: Range-hash → range by date, then hash within range
  Used by large-scale systems (billions of rows)

Partition Key Selection:
  Good keys:
    - High cardinality (many distinct values)
    - Even distribution
    - Commonly used in WHERE clauses
    - Stable (doesn't change frequently)
  Bad keys:
    - Low cardinality (e.g., boolean)
    - Skewed distribution (90% in one value)
    - Rarely filtered on

Partition Pruning:
  Query optimizer skips irrelevant partitions
  SELECT * FROM orders WHERE date = '2024-01-15'
  → Only scans the 2024-01 partition
  Critical for performance with large tables
EOF
}

cmd_strategies() {
    cat << 'EOF'
=== Distributed Splitting Strategies ===

Consistent Hashing:
  Problem: hash(key) % N fails when N changes (massive reshuffling)
  Solution: Map both keys and nodes to a hash ring
  
  How it works:
    1. Hash each node to position on ring (0 to 2^32)
    2. Hash each key to position on ring
    3. Key belongs to first node clockwise from its position
  
  Adding a node: Only keys between new node and predecessor move
  Removing a node: Only its keys move to next node
  Impact: ~1/N keys move (vs all keys with modular hashing)
  
  Virtual nodes:
    Each physical node gets multiple positions on ring
    Improves balance (100-200 virtual nodes per physical)
    Used by: Cassandra, DynamoDB, Riak

Rendezvous Hashing (Highest Random Weight):
  For each key, compute weight for every node
  weight = hash(key + node_id)
  Key goes to node with highest weight
  Adding/removing node: only that node's keys affected
  Simpler than consistent hashing, same benefits

Range-Based Sharding:
  Divide key space into contiguous ranges
  Example: A-H → shard1, I-P → shard2, Q-Z → shard3
  Supports range queries within a shard
  Challenge: Requires rebalancing as data grows
  Used by: HBase, Google Bigtable, CockroachDB

Directory-Based Sharding:
  Lookup table maps each key to its shard
  Maximum flexibility (arbitrary placement)
  Bottleneck: Lookup service becomes single point of failure
  Must cache directory for performance

Rebalancing Strategies:
  Fixed partitions:   Create more partitions than nodes (e.g., 1000)
                      Assign multiple partitions per node
                      Move whole partitions when rebalancing
  Dynamic splitting:  Split hot partitions when they grow too large
                      Merge cold partitions
  Proportional:       Number of partitions proportional to data size
EOF
}

cmd_examples() {
    cat << 'EOF'
=== Practical Split Examples ===

--- Bash ---
# Split string by delimiter
IFS=',' read -ra PARTS <<< "a,b,c"
echo "${PARTS[0]}"  # a

# Split path
filepath="/home/user/docs/file.txt"
dir="${filepath%/*}"       # /home/user/docs
file="${filepath##*/}"     # file.txt
ext="${file##*.}"          # txt
name="${file%.*}"          # file

--- Python ---
# Basic split
"a,b,c".split(",")        # ['a', 'b', 'c']
"a,b,c".split(",", 1)     # ['a', 'b,c'] (maxsplit=1)

# Regex split
import re
re.split(r'\s+', "hello   world")  # ['hello', 'world']

# Partition (split into 3: before, sep, after)
"user@domain.com".partition("@")   # ('user', '@', 'domain.com')

--- JavaScript ---
"a,b,c".split(",")        // ['a', 'b', 'c']
"a,b,c".split(",", 2)     // ['a', 'b'] (limit=2)

// Destructuring
const [first, ...rest] = "a,b,c".split(",")
// first='a', rest=['b','c']

--- SQL ---
-- PostgreSQL: string_to_array
SELECT unnest(string_to_array('a,b,c', ','));

-- MySQL: SUBSTRING_INDEX
SELECT SUBSTRING_INDEX('a,b,c', ',', 1);  -- 'a'
SELECT SUBSTRING_INDEX('a,b,c', ',', -1); -- 'c'

--- Large File Processing ---
# Split 10GB CSV for parallel processing
split -l 100000 --additional-suffix=.csv bigdata.csv chunk_
# Process chunks in parallel
ls chunk_*.csv | parallel -j4 python process.py {}
# Combine results
cat results_chunk_*.csv > final_results.csv
EOF
}

cmd_pitfalls() {
    cat << 'EOF'
=== Split Pitfalls and Best Practices ===

Pitfall 1: Empty Tokens
  "a,,b".split(",") → ["a", "", "b"]   (3 elements, not 2!)
  Fix: Filter empty strings, or use split with limit
  Be explicit about whether empty tokens are meaningful

Pitfall 2: Trailing Delimiters
  "a,b,c,".split(",") → ["a", "b", "c", ""]  (4 elements!)
  Python: "a,b,c,".split(",") → ['a', 'b', 'c', '']
  Ruby: "a,b,c,".split(",") → ["a", "b", "c"]  (different!)
  Know your language's behavior

Pitfall 3: Splitting CSVs by Comma
  WRONG:  line.split(",")
  Breaks: '"Smith, John",42,"New York, NY"'
  RIGHT:  Use csv module/library
  CSV has quoting rules that simple split ignores

Pitfall 4: Unicode Issues
  Some characters look like one char but are multiple code points
  Emoji: 👨‍👩‍👧‍👦 is actually 7 code points joined by ZWJ
  Split by character ≠ split by grapheme cluster
  Use Unicode-aware libraries for text splitting

Pitfall 5: Data Leakage in ML Splits
  WRONG:  Normalize → Split (scaler sees test data)
  RIGHT:  Split → Normalize train → Apply to test
  WRONG:  Augment → Split (augmented copies in both sets)
  RIGHT:  Split → Augment train only

Pitfall 6: Unbalanced Partitions
  Hash partitioning with low-cardinality keys
  Example: country_code has 200 values, but 40% is "US"
  Fix: Composite key, sub-sharding for hot keys

Best Practices:
  1. Always handle edge cases: empty input, no delimiter, all delimiters
  2. Set random seeds for reproducible splits (random_state=42)
  3. Validate split proportions match expectations
  4. Log split statistics (size, distribution, hash)
  5. Test with boundary cases: single element, maximum size
  6. Document your splitting strategy for reproducibility
  7. Use streaming/lazy splits for data larger than memory
EOF
}

show_help() {
    cat << EOF
split v$VERSION — Data Splitting Reference

Usage: script.sh <command>

Commands:
  intro        Splitting concepts and terminology
  string       String splitting — delimiters, regex, tokenization
  file         File splitting — by size, lines, patterns
  dataset      ML splits — train/val/test, k-fold, stratified
  database     Database partitioning — hash, range, list
  strategies   Distributed splitting — consistent hashing, sharding
  examples     Practical split examples across languages
  pitfalls     Common pitfalls and best practices
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    string)     cmd_string ;;
    file)       cmd_file ;;
    dataset)    cmd_dataset ;;
    database)   cmd_database ;;
    strategies) cmd_strategies ;;
    examples)   cmd_examples ;;
    pitfalls)   cmd_pitfalls ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "split v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
