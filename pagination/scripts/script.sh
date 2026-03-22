#!/usr/bin/env bash
# pagination — Pagination Pattern Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Pagination ===

Pagination divides large result sets into discrete pages to reduce
response size, memory usage, and rendering time.

Core Concepts:
  Page Size     Number of items per page (typical: 10-100)
  Total Count   Total items matching the query
  Page Token    Pointer to the current position in the dataset
  Has Next      Whether more pages exist beyond current

Why Paginate:
  - API responses stay small and fast (< 1MB typical target)
  - Database queries don't scan millions of rows
  - Client memory stays bounded
  - Network transfer is predictable
  - User sees results immediately (progressive loading)

Three Main Strategies:
  1. Offset-based   Simple but slow on deep pages (LIMIT/OFFSET)
  2. Cursor-based   Opaque tokens, stable under mutations
  3. Keyset-based   WHERE-clause seeking, fastest for sorted data

Choosing a Strategy:
  - Random page access needed?        → Offset
  - Real-time feed with mutations?    → Cursor
  - Large dataset, always sequential? → Keyset
  - GraphQL API?                      → Cursor (Relay spec)
  - Simple admin dashboard?           → Offset is fine

Terminology:
  first/last       Number of items from start/end (GraphQL)
  before/after     Cursor tokens for direction (GraphQL)
  page/per_page    Page number and size (REST)
  limit/offset     SQL-style bounds
  next_token       Opaque continuation token (AWS-style)
EOF
}

cmd_offset() {
    cat << 'EOF'
=== Offset-Based Pagination ===

The simplest approach: skip N rows, take M rows.

SQL Pattern:
  SELECT * FROM products
  ORDER BY created_at DESC
  LIMIT 20 OFFSET 40;       -- page 3, 20 items/page

API Request:
  GET /api/products?page=3&per_page=20
  GET /api/products?limit=20&offset=40

Response Envelope:
  {
    "data": [...],
    "meta": {
      "page": 3,
      "per_page": 20,
      "total": 1547,
      "total_pages": 78
    }
  }

Advantages:
  ✓ Simple to implement and understand
  ✓ Random page access (jump to page 50)
  ✓ Can show "Page X of Y" in UI
  ✓ Works with any ORDER BY clause
  ✓ COUNT(*) gives exact total

Disadvantages:
  ✗ O(offset + limit) — database must scan skipped rows
  ✗ Page 10,000 scans 200,000 rows to return 20
  ✗ Inconsistent under concurrent writes:
    - INSERT on page 1 shifts all subsequent pages
    - User sees duplicate items when paging forward
    - DELETE causes items to be skipped
  ✗ COUNT(*) on large tables is expensive

Performance Profile:
  Page 1:      ~2ms   (OFFSET 0)
  Page 100:    ~50ms  (OFFSET 2000)
  Page 10000:  ~5s    (OFFSET 200000)
  Page 100000: ~60s+  (OFFSET 2000000)

When to Use:
  - Total dataset < 100K rows
  - User rarely goes past page 10
  - Random page jumping is required
  - Admin dashboards with modest data
EOF
}

cmd_cursor() {
    cat << 'EOF'
=== Cursor-Based Pagination ===

Uses opaque tokens to encode position. Client passes token back
to get the next page. Position is stable under inserts/deletes.

How It Works:
  1. Server returns items + cursor for the last item
  2. Cursor encodes enough info to resume (e.g., base64 of ID+timestamp)
  3. Client sends cursor with next request
  4. Server decodes cursor and queries from that point

Cursor Encoding (common approaches):
  Simple:    base64("id:12345")
  Compound:  base64("created_at:2024-01-15T10:30:00Z,id:12345")
  Encrypted: AES(JSON.stringify({id, sort_field, direction}))

GraphQL Relay Specification:
  query {
    products(first: 20, after: "cursor_abc") {
      edges {
        node { id, name, price }
        cursor
      }
      pageInfo {
        hasNextPage
        hasPreviousPage
        startCursor
        endCursor
      }
    }
  }

REST Implementation:
  GET /api/products?limit=20&after=eyJpZCI6MTIzNDV9

  Response:
  {
    "data": [...],
    "cursors": {
      "after": "eyJpZCI6MTIzNjV9",
      "has_next": true
    }
  }

SQL Behind the Cursor:
  -- Decode cursor → {created_at: "2024-01-15", id: 12345}
  SELECT * FROM products
  WHERE (created_at, id) < ('2024-01-15', 12345)
  ORDER BY created_at DESC, id DESC
  LIMIT 20;

Advantages:
  ✓ Consistent results under concurrent writes
  ✓ Performance is O(limit) regardless of position
  ✓ Natural fit for infinite scroll
  ✓ Works well with real-time feeds

Disadvantages:
  ✗ No random page access (can't jump to page 50)
  ✗ Can't show "Page X of Y" without separate COUNT
  ✗ More complex to implement
  ✗ Cursor tokens can be large
  ✗ Backward pagination adds complexity
EOF
}

cmd_keyset() {
    cat << 'EOF'
=== Keyset (Seek) Pagination ===

Uses WHERE clause filtering instead of OFFSET. The fastest strategy
for ordered, sequential traversal of large datasets.

Core Idea:
  Instead of: OFFSET 100000 LIMIT 20
  Do:         WHERE id > 100000 LIMIT 20

  The index can seek directly to the position — no scanning.

Simple Keyset (single column):
  -- First page
  SELECT * FROM events ORDER BY id LIMIT 20;

  -- Next page (last id was 20)
  SELECT * FROM events WHERE id > 20 ORDER BY id LIMIT 20;

Compound Keyset (multiple columns):
  -- Sort by created_at DESC, id DESC
  -- Last row: created_at='2024-01-15', id=500

  SELECT * FROM events
  WHERE (created_at, id) < ('2024-01-15', 500)
  ORDER BY created_at DESC, id DESC
  LIMIT 20;

  -- Equivalent for databases without row-value comparisons:
  SELECT * FROM events
  WHERE created_at < '2024-01-15'
     OR (created_at = '2024-01-15' AND id < 500)
  ORDER BY created_at DESC, id DESC
  LIMIT 20;

Required Index:
  CREATE INDEX idx_events_created_id
  ON events (created_at DESC, id DESC);

Performance Profile:
  Page 1:      ~2ms
  Page 100:    ~2ms    ← same speed!
  Page 10000:  ~2ms    ← still same!
  Page 100000: ~3ms    ← barely changes

Advantages:
  ✓ O(limit) performance regardless of position
  ✓ Perfectly stable under inserts/deletes
  ✓ Index-only scan possible
  ✓ Simplest implementation (just WHERE + ORDER BY)

Disadvantages:
  ✗ No random page access
  ✗ Sort columns must be indexed
  ✗ NULL values in sort columns cause issues
  ✗ Changing sort order requires different WHERE logic
  ✗ Total count still requires separate query

Best For:
  - Event logs, audit trails, time-series data
  - Large tables (millions+ rows)
  - Infinite scroll in chronological feeds
  - Background jobs processing records in order
EOF
}

cmd_compare() {
    cat << 'EOF'
=== Pagination Strategy Comparison ===

                    Offset          Cursor          Keyset
                    ──────          ──────          ──────
Performance:
  Page 1            O(limit)        O(limit)        O(limit)
  Page N            O(N×limit)      O(limit)        O(limit)
  Deep pages        Very slow       Fast            Fast

Features:
  Random access     ✓ Yes           ✗ No            ✗ No
  Page X of Y       ✓ Easy          ✗ Hard          ✗ Hard
  Infinite scroll   ✗ Duplicates    ✓ Perfect       ✓ Perfect
  Stable results    ✗ No            ✓ Yes           ✓ Yes

Implementation:
  Complexity        Simple          Medium          Simple
  Stateless         ✓ Yes           ✓ Yes           ✓ Yes
  Sort flexibility  ✓ Any           ⚠ Needs cursor  ⚠ Needs index

Use Case Matrix:
  Admin dashboard, small data      → Offset
  Social feed, real-time           → Cursor
  Log viewer, time-series          → Keyset
  GraphQL API                      → Cursor (Relay)
  REST API, general purpose        → Cursor or Offset
  Search results                   → Offset (need page jumping)
  Data export / batch processing   → Keyset
  Mobile app, infinite scroll      → Cursor

Database Support:
  PostgreSQL    All three well-supported
  MySQL         All three (row-value comparison since 8.0)
  MongoDB       Cursor (_id based) is natural
  DynamoDB      Cursor only (LastEvaluatedKey)
  Elasticsearch After-search cursor, scroll API
  Redis         Cursor (SCAN command)

Performance Rule of Thumb:
  < 10K total rows     → Offset is fine
  10K - 1M rows        → Cursor or Keyset recommended
  > 1M rows            → Keyset strongly preferred
  > 100M rows          → Keyset mandatory
EOF
}

cmd_pitfalls() {
    cat << 'EOF'
=== Pagination Pitfalls & Edge Cases ===

1. Phantom Reads (Offset)
   Problem: New row inserted on page 1 while user is on page 3
   Effect:  Last item from page 2 appears again on page 3
   Fix:     Use cursor pagination, or snapshot isolation

2. Missing Items (Offset)
   Problem: Row deleted from page 2 while user is on page 2
   Effect:  First item from page 3 is never seen
   Fix:     Cursor/keyset pagination, or timestamp-based filtering

3. Off-by-One Errors
   Problem: page=1 means offset=0 or offset=1?
   Fix:     offset = (page - 1) × per_page, always
   Verify:  page=1 → offset=0, page=2 → offset=per_page

4. COUNT(*) Performance
   Problem: SELECT COUNT(*) FROM big_table is slow (table scan)
   Fixes:
     - Cache count with TTL (show "~1.5M results")
     - Use pg_class.reltuples for estimates (PostgreSQL)
     - Skip total on deep pages ("Showing results 1-20")
     - Use EXPLAIN to get row estimate

5. Cursor Tampering
   Problem: User modifies base64 cursor to access other data
   Fix:     Sign cursors with HMAC, or encrypt them
   Alt:     Validate decoded values against allowed ranges

6. Empty Last Page
   Problem: Exactly divisible total → last page returns empty array
   Fix:     Check has_next based on fetching limit+1 items:
            SELECT ... LIMIT 21;  -- fetch one extra
            has_next = (results.length > 20)
            return results.slice(0, 20)

7. Concurrent Pagination + Filtering
   Problem: Filter results change between page requests
   Fix:     Include filter hash in cursor, reject stale cursors
   Alt:     Snapshot-based pagination (created_before timestamp)

8. Null Sort Values
   Problem: NULLS in ORDER BY column break keyset WHERE clause
   Fix:     Use COALESCE or NULLS LAST/FIRST explicitly
            WHERE (COALESCE(score, 0), id) > (COALESCE(?, 0), ?)
EOF
}

cmd_api() {
    cat << 'EOF'
=== API Pagination Design Patterns ===

--- REST: Link Header (RFC 8288) ---
  HTTP/1.1 200 OK
  Link: <https://api.example.com/items?page=3>; rel="next",
        <https://api.example.com/items?page=1>; rel="prev",
        <https://api.example.com/items?page=50>; rel="last"

  Pro: Clean response body, standard
  Con: Harder to parse in JavaScript

--- REST: Envelope Pattern ---
  {
    "data": [...items...],
    "pagination": {
      "page": 2,
      "per_page": 20,
      "total": 987,
      "total_pages": 50,
      "next": "/api/items?page=3",
      "prev": "/api/items?page=1"
    }
  }

--- REST: Cursor Token ---
  {
    "data": [...items...],
    "next_cursor": "eyJpZCI6MTIzfQ==",
    "has_more": true
  }

  Next request: GET /api/items?cursor=eyJpZCI6MTIzfQ==

--- GraphQL: Relay Connection Spec ---
  type ProductConnection {
    edges: [ProductEdge!]!
    pageInfo: PageInfo!
    totalCount: Int
  }
  type ProductEdge {
    node: Product!
    cursor: String!
  }
  type PageInfo {
    hasNextPage: Boolean!
    hasPreviousPage: Boolean!
    startCursor: String
    endCursor: String
  }

--- Common HTTP Headers ---
  X-Total-Count: 987
  X-Page: 2
  X-Per-Page: 20
  X-Total-Pages: 50

--- Best Practices ---
  1. Always include has_next / hasNextPage (don't rely on empty array)
  2. Default page size: 20, max: 100 (prevent abuse)
  3. Return consistent sort order (add tiebreaker column like ID)
  4. Use HTTPS for cursor tokens (they encode internal state)
  5. Rate-limit aggressive pagination (page > 100 = suspicious)
  6. Document max page size in API docs
  7. Return 400 for invalid cursors, not 500
EOF
}

cmd_sql() {
    cat << 'EOF'
=== SQL Pagination Cookbook ===

--- Offset Pagination ---
  -- Basic
  SELECT id, name, price FROM products
  ORDER BY created_at DESC
  LIMIT 20 OFFSET 60;

  -- With total count (two queries)
  SELECT COUNT(*) FROM products WHERE category = 'electronics';
  SELECT * FROM products WHERE category = 'electronics'
  ORDER BY created_at DESC LIMIT 20 OFFSET 60;

  -- Index needed:
  CREATE INDEX idx_products_category_created
  ON products (category, created_at DESC);

--- Keyset Pagination ---
  -- Forward (next page)
  SELECT id, name, price FROM products
  WHERE (created_at, id) < ($last_created_at, $last_id)
  ORDER BY created_at DESC, id DESC
  LIMIT 20;

  -- Backward (previous page)
  SELECT * FROM (
    SELECT id, name, price FROM products
    WHERE (created_at, id) > ($first_created_at, $first_id)
    ORDER BY created_at ASC, id ASC
    LIMIT 20
  ) sub ORDER BY created_at DESC, id DESC;

  -- Index needed:
  CREATE INDEX idx_products_created_id
  ON products (created_at DESC, id DESC);

--- Fetch-One-Extra Pattern ---
  -- Fetch 21 to determine has_next
  SELECT id, name FROM products
  ORDER BY id LIMIT 21;

  -- In application code:
  -- has_next = len(rows) > 20
  -- return rows[:20]

--- Estimated Count (PostgreSQL) ---
  -- Fast approximate count instead of COUNT(*)
  SELECT reltuples::bigint AS estimate
  FROM pg_class
  WHERE relname = 'products';

  -- Better estimate with EXPLAIN
  CREATE FUNCTION count_estimate(query text) RETURNS bigint AS $$
  DECLARE
    rec record;
  BEGIN
    FOR rec IN EXECUTE 'EXPLAIN ' || query LOOP
      IF rec."QUERY PLAN" ~ 'rows=' THEN
        RETURN (regexp_match(rec."QUERY PLAN", 'rows=(\d+)'))[1]::bigint;
      END IF;
    END LOOP;
    RETURN 0;
  END $$ LANGUAGE plpgsql;

--- Deferred Join (Optimization) ---
  -- Instead of fetching all columns with OFFSET:
  SELECT p.* FROM products p
  INNER JOIN (
    SELECT id FROM products ORDER BY created_at DESC
    LIMIT 20 OFFSET 10000
  ) ids ON p.id = ids.id
  ORDER BY p.created_at DESC;

  -- The subquery does an index-only scan for IDs,
  -- then fetches full rows only for the 20 needed.
EOF
}

show_help() {
    cat << EOF
pagination v$VERSION — Pagination Pattern Reference

Usage: script.sh <command>

Commands:
  intro        Pagination concepts and strategy overview
  offset       Offset-based (LIMIT/OFFSET) pagination
  cursor       Cursor-based pagination and Relay spec
  keyset       Keyset (seek) pagination for large datasets
  compare      Strategy comparison and trade-off matrix
  pitfalls     Common pagination bugs and edge cases
  api          API design patterns for paginated endpoints
  sql          SQL cookbook with optimized query patterns
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    offset)     cmd_offset ;;
    cursor)     cmd_cursor ;;
    keyset)     cmd_keyset ;;
    compare)    cmd_compare ;;
    pitfalls)   cmd_pitfalls ;;
    api)        cmd_api ;;
    sql)        cmd_sql ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "pagination v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
