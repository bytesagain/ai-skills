#!/usr/bin/env bash
# dedupe — Data Deduplication Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Deduplication Overview ===

Deduplication (dedup) is the process of identifying and removing
duplicate copies of data. Critical for data quality, storage
efficiency, and accurate analytics.

Types of Duplication:

  Exact Duplicates      Identical records in every field
  Near-Duplicates       Records that refer to same entity but differ
                        (typos, formatting, missing fields)
  Semantic Duplicates   Different representations of same concept
                        ("USA" vs "United States" vs "US")

Deduplication Levels:
  1. File-level      Identical files on disk (fdupes, rdfind)
  2. Block-level     Identical data blocks within files (ZFS, Btrfs)
  3. Record-level    Duplicate rows in databases/datasets
  4. Field-level     Duplicate values within a column
  5. Entity-level    Records referring to same real-world entity

Strategies:
  Hash-based       Compute hash, group by hash value
  Sort-based       Sort data, compare adjacent records
  Key-based        Define unique key, detect conflicts
  Probabilistic    Bloom filters, sampling (scale trade-off)
  ML-based         Train model to identify duplicates

Common Causes of Duplicates:
  - Multiple data entry points (web form + phone + import)
  - System migrations without dedup
  - Failed idempotency (retry creates second record)
  - Merge/acquisition combining overlapping databases
  - ETL bugs (re-processing same batch)
  - No unique constraint at database level

Impact of Duplicates:
  - Inflated counts and incorrect analytics
  - Wasted storage and compute
  - Multiple mailings to same customer
  - Incorrect inventory counts
  - Failed joins (which duplicate to match?)
  - Regulatory risk (GDPR: can't delete all copies)
EOF
}

cmd_exact() {
    cat << 'EOF'
=== Exact Deduplication ===

Hash-Based Dedup:
  1. Compute hash of each record (or key fields)
  2. Group records by hash
  3. Within each group, keep one (first, latest, or best)

  Common Hash Functions:
    MD5        Fast, 128-bit, sufficient for dedup (not security)
    SHA-1      160-bit, slightly slower
    SHA-256    256-bit, overkill for dedup but available everywhere
    xxHash     Extremely fast, good for large datasets
    CRC32      Fast but higher collision risk

  Python Example:
    import hashlib
    def record_hash(row):
        key = f"{row['email'].lower().strip()}"
        return hashlib.md5(key.encode()).hexdigest()

Key-Based Dedup:
  Define a natural key (or composite key) that uniquely identifies
  an entity:
    Customer:  email OR (first_name + last_name + phone)
    Product:   SKU or UPC
    Order:     order_number + line_number
    Event:     (event_type, timestamp, source_id)

  Normalize keys before comparison:
    - Lowercase all strings
    - Strip whitespace
    - Remove punctuation
    - Standardize formats (phone: +1-555-123-4567)

Sort-Based Dedup:
  1. Sort dataset by dedup key
  2. Scan linearly, compare each record to previous
  3. O(n log n) for sort + O(n) for scan
  4. Memory efficient (only hold 2 records at a time)

  Works well for:
    - Very large files that don't fit in memory
    - Streaming data (sort window + dedup)
    - External sort with merge

Keep Strategy (which duplicate to keep):
  First occurrence     Keep the earliest by insertion order
  Last occurrence      Keep the most recent version
  Most complete        Keep record with fewest null fields
  Highest quality      Score records, keep highest score
  Merge/golden record  Combine best fields from all duplicates
EOF
}

cmd_fuzzy() {
    cat << 'EOF'
=== Fuzzy Deduplication ===

String Similarity Measures:

  Levenshtein Distance (Edit Distance):
    Minimum edits (insert, delete, substitute) to transform A → B
    "kitten" → "sitting" = 3 edits
    Normalized: 1 - (distance / max(len(A), len(B)))

  Jaro-Winkler Similarity:
    Best for short strings (names, cities)
    Range: 0.0 (no match) to 1.0 (exact)
    Threshold: > 0.90 usually indicates match
    Gives extra weight to matching prefixes

  Soundex / Metaphone:
    Phonetic encoding (sounds-alike matching)
    "Smith" and "Smythe" → same code
    Good for names, poor for other data

  n-gram / Jaccard Similarity:
    Break strings into n-character chunks
    Similarity = |intersection| / |union|
    "hello" (bigrams): {he, el, ll, lo}
    Robust to character transpositions

  TF-IDF + Cosine Similarity:
    For longer text fields (descriptions, addresses)
    Weight rare terms higher
    Good for detecting paraphrased content

Blocking (Scalability):
  Problem: Comparing every pair = O(n²) — infeasible for large data

  Solution: Only compare records within the same "block":
    Block by first 3 chars of last name + ZIP code
    Block by Soundex code
    Block by year of birth + gender
    Block by domain of email address

  Reduces O(n²) to O(n × avg_block_size)

Record Linkage Pipeline:
  1. Standardize     Clean, normalize, parse fields
  2. Block           Group candidates to reduce comparisons
  3. Compare         Calculate field-level similarity scores
  4. Classify        Match / Non-match / Possible (thresholds)
  5. Cluster         Group all records belonging to same entity
  6. Merge           Create golden record from cluster

Tools:
  dedupe (Python)         ML-based, active learning
  recordlinkage (Python)  Statistical record linkage
  splink (Python/Spark)   Probabilistic linking at scale
  fuzzywuzzy (Python)     Simple fuzzy string matching
  OpenRefine              GUI-based clustering and dedup
  Duke (Java)             Configurable record linkage engine
EOF
}

cmd_files() {
    cat << 'EOF'
=== File-Level Deduplication ===

Finding Duplicate Files:

  fdupes (most popular):
    fdupes -r /path/to/dir          # Find dupes recursively
    fdupes -rd /path/to/dir         # Find and delete (interactive)
    fdupes -rdN /path/to/dir        # Auto-delete, keep first
    fdupes -rS /path/to/dir         # Show sizes
    # Process: size comparison → partial hash → full hash

  jdupes (faster fork of fdupes):
    jdupes -rS /path/to/dir         # Find with sizes
    jdupes -rdN /path/to/dir        # Auto-delete
    jdupes -rL /path/to/dir         # Hard-link duplicates (save space)
    jdupes -rB /path/to/dir         # Use btrfs reflinks

  rdfind (fastest):
    rdfind /path/to/dir             # Find duplicates
    rdfind -deleteduplicates true   # Delete duplicates
    rdfind -makesymlinks true       # Replace with symlinks
    rdfind -makehardlinks true      # Replace with hardlinks

  Using standard tools:
    # Find by MD5 hash
    find . -type f -exec md5sum {} + | sort | uniq -Dw 32

    # Find by size first, then hash (faster)
    find . -type f -printf '%s %p\n' | sort -n | \
      uniq -Dw 15 | awk '{print $2}' | xargs md5sum | \
      sort | uniq -Dw 32

Storage-Level Dedup:

  ZFS Deduplication:
    zfs set dedup=on pool/dataset    # Enable block-level dedup
    zpool get dedup                   # Check status
    zdb -DD pool                      # Dedup statistics
    # Warning: requires ~5GB RAM per TB of data for DDT

  Btrfs Deduplication:
    duperemove -rd /path             # Offline dedup (reflinks)
    bees /path                        # Online dedup daemon

  Backup Tool Dedup:
    borgbackup  Content-defined chunking + dedup
    restic      CDC with rabin fingerprinting
    duplicacy   Variable-size chunk dedup
    zbackup     Global dedup across backups

Inline vs Post-Process:
  Inline       Dedup during write (ZFS) — CPU overhead
  Post-process Dedup after write (duperemove) — batch friendly
  CDC          Content-Defined Chunking — handles shifted data
EOF
}

cmd_algorithms() {
    cat << 'EOF'
=== Dedup Algorithms & Data Structures ===

Bloom Filter:
  Purpose: Probabilistic set membership test
  Properties:
    - "Definitely not in set" or "Probably in set"
    - No false negatives, tunable false positive rate
    - Very memory efficient (10 bits per element for 1% FP)
  Use: Pre-filter before expensive exact check
  Size: m = -(n × ln(p)) / (ln2)²
    n = expected elements, p = false positive rate
    1M elements, 1% FP → ~1.2 MB

Counting Bloom Filter:
  Like Bloom filter but supports deletion
  Uses counters instead of single bits
  Typically 4 bits per counter (16x larger than basic)

HyperLogLog:
  Purpose: Estimate number of distinct elements (cardinality)
  Accuracy: ~2% error with 1.5 KB memory
  Use: "How many unique records?" before full dedup
  Not for: identifying WHICH records are duplicates

MinHash (MinWise Hashing):
  Purpose: Estimate Jaccard similarity between sets
  Process:
    1. Apply k hash functions to each set
    2. Keep minimum hash value for each function
    3. Similarity ≈ fraction of matching minimums
  Use: Near-duplicate document detection
  Tool: datasketch Python library

SimHash:
  Purpose: Locality-sensitive hash for near-duplicate detection
  Property: Similar items → similar hash values
  Hamming distance between hashes ≈ dissimilarity
  Use: Web page dedup (Google uses SimHash)
  Efficient: compare 64-bit hashes instead of full documents

Content-Defined Chunking (CDC):
  Purpose: Split data into variable-size chunks for dedup
  Process:
    1. Slide window over data
    2. Hash window contents (Rabin fingerprint)
    3. Split when hash matches pattern (e.g., low 13 bits = 0)
    4. Average chunk size = 2^13 = 8 KB
  Advantage: Insertion/deletion only affects nearby chunks
  Use: Backup systems (borg, restic, duplicacy)

Sorted Neighborhood Method:
  Purpose: Efficient pairwise comparison for record dedup
  Process:
    1. Compute sorting key for each record
    2. Sort records by key
    3. Slide window of size w over sorted records
    4. Compare all pairs within window
  Complexity: O(n × w) instead of O(n²)
  Window size: typically 3-20
EOF
}

cmd_sql() {
    cat << 'EOF'
=== SQL Deduplication Patterns ===

Find Duplicates:
  -- By single column
  SELECT email, COUNT(*) as cnt
  FROM users
  GROUP BY email
  HAVING COUNT(*) > 1;

  -- By multiple columns
  SELECT first_name, last_name, phone, COUNT(*)
  FROM customers
  GROUP BY first_name, last_name, phone
  HAVING COUNT(*) > 1;

Keep One, Delete Rest (ROW_NUMBER):
  -- Mark duplicates, keep the row with lowest id
  WITH ranked AS (
    SELECT *,
      ROW_NUMBER() OVER (
        PARTITION BY email
        ORDER BY id ASC
      ) AS rn
    FROM users
  )
  DELETE FROM users
  WHERE id IN (SELECT id FROM ranked WHERE rn > 1);

  -- Keep most recently updated
  WITH ranked AS (
    SELECT *,
      ROW_NUMBER() OVER (
        PARTITION BY email
        ORDER BY updated_at DESC
      ) AS rn
    FROM users
  )
  DELETE FROM users
  WHERE id IN (SELECT id FROM ranked WHERE rn > 1);

Select Deduplicated View:
  -- Without modifying data
  SELECT DISTINCT ON (email) *
  FROM users
  ORDER BY email, created_at DESC;  -- PostgreSQL

  -- Standard SQL equivalent
  SELECT * FROM (
    SELECT *,
      ROW_NUMBER() OVER (PARTITION BY email ORDER BY created_at DESC) AS rn
    FROM users
  ) t WHERE rn = 1;

Merge Duplicates (Golden Record):
  -- Combine best fields from duplicates
  SELECT
    email,
    MAX(first_name) AS first_name,  -- non-null preference
    MAX(last_name) AS last_name,
    MAX(phone) AS phone,
    MIN(created_at) AS first_seen,
    MAX(updated_at) AS last_seen,
    SUM(order_count) AS total_orders
  FROM customers
  GROUP BY email;

Prevent Future Duplicates:
  -- Add unique constraint
  ALTER TABLE users ADD CONSTRAINT uq_email UNIQUE (email);

  -- Upsert (PostgreSQL)
  INSERT INTO users (email, name)
  VALUES ('a@b.com', 'Alice')
  ON CONFLICT (email) DO UPDATE SET name = EXCLUDED.name;

  -- Upsert (MySQL)
  INSERT INTO users (email, name)
  VALUES ('a@b.com', 'Alice')
  ON DUPLICATE KEY UPDATE name = VALUES(name);
EOF
}

cmd_cli() {
    cat << 'EOF'
=== Command-Line Dedup Tools ===

sort + uniq (classic):
  # Remove exact duplicate lines
  sort file.txt | uniq > deduped.txt

  # Show duplicate lines only
  sort file.txt | uniq -d

  # Count occurrences
  sort file.txt | uniq -c | sort -rn

  # Case-insensitive dedup
  sort -f file.txt | uniq -i > deduped.txt

awk (preserve order):
  # Dedup preserving original order (first occurrence)
  awk '!seen[$0]++' file.txt > deduped.txt

  # Dedup by specific field (field 2)
  awk -F',' '!seen[$2]++' data.csv > deduped.csv

  # Dedup by multiple fields
  awk -F',' '!seen[$1","$3]++' data.csv > deduped.csv

  # Dedup case-insensitive
  awk '!seen[tolower($0)]++' file.txt > deduped.txt

sed (adjacent duplicates only):
  # Remove consecutive duplicate lines (like uniq without sort)
  sed '$!N; /^\(.*\)\n\1$/!P; D' file.txt

Python one-liners:
  # Dedup preserving order
  python3 -c "
  import sys; seen=set()
  [sys.stdout.write(l) for l in sys.stdin if l not in seen and not seen.add(l)]
  " < input.txt > output.txt

  # Dedup CSV by column
  python3 -c "
  import csv, sys; seen=set(); r=csv.reader(sys.stdin); w=csv.writer(sys.stdout)
  [w.writerow(row) for row in r if row[1] not in seen and not seen.add(row[1])]
  " < input.csv > output.csv

csvkit:
  # Dedup CSV
  csvsort -c email input.csv | csvcut -c 1-5 | uniq > deduped.csv

Miller (mlr):
  # Dedup CSV by field
  mlr --csv uniq -f email input.csv > deduped.csv

  # Dedup keeping last occurrence
  mlr --csv group-by email then tail -n 1 input.csv > deduped.csv

datamash:
  # Count duplicates by column 1
  datamash -s -g 1 count 1 < input.tsv
  # -s = sort, -g 1 = group by column 1

Stream Dedup (large files):
  # Using sort with temporary files (handles files > RAM)
  sort -T /tmp -S 2G file.txt | uniq > deduped.txt

  # Using LC_ALL=C for faster sorting
  LC_ALL=C sort file.txt | uniq > deduped.txt
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== Deduplication Quality Checklist ===

Planning:
  [ ] Define what constitutes a "duplicate" (exact vs fuzzy)
  [ ] Identify dedup key fields
  [ ] Determine "keep" strategy (first, latest, most complete, merge)
  [ ] Estimate duplicate rate (sample 1000 records)
  [ ] Back up data before deduplication
  [ ] Test on subset before running on full dataset

Key Normalization:
  [ ] Lowercase all string keys
  [ ] Trim whitespace (leading, trailing, multiple internal spaces)
  [ ] Remove punctuation where appropriate
  [ ] Standardize formats (dates, phones, addresses)
  [ ] Handle encoding issues (UTF-8, accents, special chars)
  [ ] Map synonyms if needed ("St." → "Street")

Execution:
  [ ] Run dedup on staging/copy first
  [ ] Log all duplicates found (before deletion)
  [ ] Track which record was kept and why
  [ ] Handle foreign key references (update related tables)
  [ ] Process in batches for large datasets

Validation:
  [ ] Record count: before - duplicates_removed = after
  [ ] No false positives (legitimate distinct records deleted)
  [ ] Spot-check merged/golden records for quality
  [ ] Run dedup again on result (should find zero duplicates)
  [ ] Verify downstream reports/dashboards still accurate
  [ ] Check referential integrity (no orphaned records)

Prevention:
  [ ] Add unique constraints to database
  [ ] Implement upsert logic in data pipelines
  [ ] Normalize data at ingestion (not after)
  [ ] Set up duplicate detection alerts
  [ ] Schedule periodic dedup runs
  [ ] Document dedup rules for team knowledge

Monitoring:
  [ ] Track duplicate rate over time (should decrease)
  [ ] Alert on sudden spikes in duplicate creation
  [ ] Review dedup rules quarterly
  [ ] Monitor data source quality
EOF
}

show_help() {
    cat << EOF
dedupe v$VERSION — Data Deduplication Reference

Usage: script.sh <command>

Commands:
  intro        Dedup overview — types, strategies, causes
  exact        Exact dedup — hash-based, key-based, sort-based
  fuzzy        Fuzzy dedup — similarity measures, blocking, linkage
  files        File-level dedup — fdupes, jdupes, storage dedup
  algorithms   Algorithms — bloom filters, MinHash, SimHash, CDC
  sql          SQL dedup patterns — ROW_NUMBER, upsert, golden record
  cli          Command-line dedup — sort, uniq, awk, streaming
  checklist    Dedup quality checklist and validation
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    exact)      cmd_exact ;;
    fuzzy)      cmd_fuzzy ;;
    files)      cmd_files ;;
    algorithms) cmd_algorithms ;;
    sql)        cmd_sql ;;
    cli)        cmd_cli ;;
    checklist)  cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "dedupe v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
