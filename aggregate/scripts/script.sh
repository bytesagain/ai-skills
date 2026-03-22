#!/usr/bin/env bash
# aggregate — Data Aggregation Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Data Aggregation ===

Aggregation combines multiple values into a single summary value.
The foundation of all analytics, reporting, and business intelligence.

Core Aggregate Functions:
  COUNT(*)      Number of rows
  COUNT(col)    Number of non-NULL values in column
  SUM(col)      Total of numeric values
  AVG(col)      Arithmetic mean
  MIN(col)      Smallest value
  MAX(col)      Largest value
  STDDEV(col)   Standard deviation
  VARIANCE(col) Statistical variance

Aggregation Levels:
  Scalar:    single value from entire table (SELECT COUNT(*) FROM orders)
  Grouped:   one value per group (GROUP BY customer_id)
  Windowed:  value per row with aggregate context (OVER partition)
  Rolled up: multiple grouping levels in one query (ROLLUP)

Aggregation Pipeline (conceptual):
  1. FROM + JOIN     → raw rows
  2. WHERE           → filter rows BEFORE aggregation
  3. GROUP BY        → create groups
  4. Aggregate funcs → compute per group
  5. HAVING          → filter groups AFTER aggregation
  6. SELECT          → choose output columns
  7. ORDER BY        → sort results
  8. LIMIT           → truncate output

Common Mistake:
  WHERE filters rows BEFORE grouping
  HAVING filters groups AFTER aggregation
  WHERE avg(price) > 100   ← WRONG (can't use aggregate in WHERE)
  HAVING avg(price) > 100  ← CORRECT
EOF
}

cmd_groupby() {
    cat << 'EOF'
=== GROUP BY Patterns ===

--- Basic GROUP BY ---
  SELECT category, COUNT(*), SUM(revenue)
  FROM products
  GROUP BY category;

--- Multi-Column GROUP BY ---
  SELECT country, city, COUNT(*)
  FROM customers
  GROUP BY country, city
  ORDER BY country, city;

--- GROUP BY with HAVING ---
  SELECT customer_id, COUNT(*) AS order_count
  FROM orders
  GROUP BY customer_id
  HAVING COUNT(*) > 10;      -- only customers with 10+ orders

--- Filtered Aggregate (FILTER/CASE) ---
  -- PostgreSQL FILTER syntax:
  SELECT
    COUNT(*) AS total,
    COUNT(*) FILTER (WHERE status = 'shipped') AS shipped,
    COUNT(*) FILTER (WHERE status = 'pending') AS pending
  FROM orders;

  -- Universal CASE syntax:
  SELECT
    COUNT(*) AS total,
    SUM(CASE WHEN status = 'shipped' THEN 1 ELSE 0 END) AS shipped,
    SUM(CASE WHEN status = 'pending' THEN 1 ELSE 0 END) AS pending
  FROM orders;

--- GROUP BY with Expression ---
  SELECT DATE_TRUNC('month', created_at) AS month,
         COUNT(*)
  FROM orders
  GROUP BY DATE_TRUNC('month', created_at);

  -- PostgreSQL shortcut:
  GROUP BY 1;  -- group by first SELECT expression

--- Top-N per Group ---
  -- "Top 3 products per category by revenue"
  SELECT * FROM (
    SELECT category, product, revenue,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY revenue DESC) AS rn
    FROM products
  ) ranked
  WHERE rn <= 3;

--- Aggregate with NULL handling ---
  COUNT(*) counts all rows including NULLs
  COUNT(col) skips NULLs
  SUM/AVG/MIN/MAX all ignore NULLs
  COALESCE(SUM(col), 0) → prevents NULL result on empty groups
EOF
}

cmd_windows() {
    cat << 'EOF'
=== Window Functions ===

Window functions compute values across a set of rows related
to the current row WITHOUT collapsing rows (unlike GROUP BY).

Syntax:
  function() OVER (
    PARTITION BY col        -- like GROUP BY but keeps all rows
    ORDER BY col            -- defines order within partition
    ROWS/RANGE frame       -- defines window frame
  )

--- Ranking Functions ---
  ROW_NUMBER()  1, 2, 3, 4, 5      (no ties, always unique)
  RANK()        1, 2, 2, 4, 5      (ties get same rank, gap after)
  DENSE_RANK()  1, 2, 2, 3, 4      (ties get same rank, no gap)
  NTILE(4)      1, 1, 2, 2, 3, 3, 4, 4  (divide into N equal groups)

  SELECT name, score,
         ROW_NUMBER() OVER (ORDER BY score DESC) AS row_num,
         RANK() OVER (ORDER BY score DESC) AS rank,
         DENSE_RANK() OVER (ORDER BY score DESC) AS dense_rank
  FROM students;

--- Offset Functions ---
  LAG(col, n)    Value from n rows BEFORE current row
  LEAD(col, n)   Value from n rows AFTER current row
  FIRST_VALUE()  First value in the window frame
  LAST_VALUE()   Last value in the window frame
  NTH_VALUE(col, n)  Nth value in the frame

  -- Day-over-day change:
  SELECT date, revenue,
         revenue - LAG(revenue, 1) OVER (ORDER BY date) AS daily_change,
         revenue::float / LAG(revenue, 1) OVER (ORDER BY date) AS ratio
  FROM daily_sales;

--- Running Totals ---
  SELECT date, amount,
         SUM(amount) OVER (ORDER BY date) AS running_total
  FROM transactions;

--- Moving Average ---
  SELECT date, price,
         AVG(price) OVER (
           ORDER BY date
           ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
         ) AS moving_avg_7day
  FROM stock_prices;

--- Window Frames ---
  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW    (default with ORDER BY)
  ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING             (centered window)
  ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING     (from here to end)
  RANGE BETWEEN INTERVAL '7 days' PRECEDING AND CURRENT ROW  (time-based)

--- Percentage / Distribution ---
  PERCENT_RANK()    (rank - 1) / (total - 1), range [0, 1]
  CUME_DIST()       cumulative distribution, range (0, 1]
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY col)  -- median (aggregate)
  PERCENTILE_DISC(0.95) WITHIN GROUP (ORDER BY col)  -- 95th percentile
EOF
}

cmd_rollup() {
    cat << 'EOF'
=== ROLLUP, CUBE, and GROUPING SETS ===

Generate multiple levels of aggregation in a single query.

--- ROLLUP ---
  Creates subtotals from left to right, plus grand total.

  SELECT country, city, SUM(revenue)
  FROM sales
  GROUP BY ROLLUP(country, city);

  Result:
    USA      New York     5000    -- city level
    USA      Chicago      3000
    USA      NULL         8000    -- country subtotal
    UK       London       4000
    UK       NULL         4000    -- country subtotal
    NULL     NULL        12000    -- grand total

  ROLLUP(A, B, C) generates:
    (A, B, C), (A, B), (A), ()

--- CUBE ---
  Creates subtotals for ALL combinations.

  SELECT country, category, SUM(revenue)
  FROM sales
  GROUP BY CUBE(country, category);

  CUBE(A, B) generates:
    (A, B), (A), (B), ()

  More combinations than ROLLUP:
    ROLLUP(A, B, C) = 4 grouping levels
    CUBE(A, B, C)   = 8 grouping levels (2^n)

--- GROUPING SETS ---
  Explicitly specify which grouping combinations you want.

  SELECT country, category, year, SUM(revenue)
  FROM sales
  GROUP BY GROUPING SETS (
    (country, category),    -- by country + category
    (country),              -- by country only
    (category),             -- by category only
    ()                      -- grand total
  );

  ROLLUP and CUBE are shortcuts for specific GROUPING SETS.

--- GROUPING() Function ---
  Distinguishes NULL from subtotal rows.

  SELECT
    CASE WHEN GROUPING(country) = 1 THEN 'ALL' ELSE country END AS country,
    CASE WHEN GROUPING(city) = 1 THEN 'ALL' ELSE city END AS city,
    SUM(revenue)
  FROM sales
  GROUP BY ROLLUP(country, city);

  GROUPING(col) returns:
    0 = actual value (may still be NULL in data)
    1 = this is a subtotal/grand total row
EOF
}

cmd_functions() {
    cat << 'EOF'
=== Aggregate Functions Reference ===

--- Standard Functions ---
  COUNT(*)         Count all rows (including NULLs)
  COUNT(col)       Count non-NULL values
  COUNT(DISTINCT col)  Count unique non-NULL values
  SUM(col)         Total (NULL if all NULL)
  AVG(col)         Mean (ignores NULLs)
  MIN(col)         Minimum value
  MAX(col)         Maximum value

--- Statistical Functions ---
  STDDEV(col) / STDDEV_POP(col)    Population standard deviation
  STDDEV_SAMP(col)                  Sample standard deviation
  VARIANCE(col) / VAR_POP(col)     Population variance
  VAR_SAMP(col)                     Sample variance
  CORR(y, x)                        Correlation coefficient (-1 to 1)
  COVAR_POP(y, x)                   Population covariance
  REGR_SLOPE(y, x)                  Linear regression slope

--- Array/String Aggregates ---
  STRING_AGG(col, ', ')             Concatenate with delimiter (PostgreSQL)
  GROUP_CONCAT(col SEPARATOR ', ')  Same in MySQL
  ARRAY_AGG(col)                    Collect into array (PostgreSQL)
  JSON_AGG(col)                     Collect into JSON array (PostgreSQL)
  JSONB_OBJECT_AGG(key, value)      Collect into JSON object

--- Ordered Aggregates ---
  STRING_AGG(name, ', ' ORDER BY name)   Sorted concatenation
  ARRAY_AGG(score ORDER BY score DESC)   Sorted array
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY col)  Median
  MODE() WITHIN GROUP (ORDER BY col)     Most frequent value

--- Boolean Aggregates ---
  BOOL_AND(col)    True if ALL are true (PostgreSQL)
  BOOL_OR(col)     True if ANY is true
  EVERY(col)       Same as BOOL_AND (SQL standard)

--- Approximate Aggregates (for big data) ---
  APPROX_COUNT_DISTINCT(col)     HyperLogLog-based (BigQuery, Presto)
  APPROX_PERCENTILE(col, 0.95)  Approximate percentile
  HLL_COUNT.INIT(col)            HyperLogLog sketch (BigQuery)
  Benefits: O(1) memory instead of O(n), 1-2% error margin
  Use when: exact answers not needed, data is huge (billions of rows)
EOF
}

cmd_materialized() {
    cat << 'EOF'
=== Materialized Aggregates ===

Pre-compute and store aggregate results for fast query performance.

--- Materialized Views ---
  CREATE MATERIALIZED VIEW monthly_sales AS
  SELECT DATE_TRUNC('month', order_date) AS month,
         category,
         COUNT(*) AS order_count,
         SUM(total) AS revenue
  FROM orders
  GROUP BY 1, 2;

  -- Query the materialized view (fast, pre-computed)
  SELECT * FROM monthly_sales WHERE month = '2024-01-01';

  -- Refresh when source data changes
  REFRESH MATERIALIZED VIEW monthly_sales;
  REFRESH MATERIALIZED VIEW CONCURRENTLY monthly_sales;  -- non-blocking

--- Summary Tables ---
  Manually maintained aggregate tables for dashboards.

  CREATE TABLE daily_metrics (
    date DATE PRIMARY KEY,
    total_orders INT,
    total_revenue DECIMAL,
    unique_customers INT,
    avg_order_value DECIMAL,
    updated_at TIMESTAMP DEFAULT NOW()
  );

  -- Incremental update (run nightly)
  INSERT INTO daily_metrics (date, total_orders, total_revenue, ...)
  SELECT order_date, COUNT(*), SUM(total), ...
  FROM orders
  WHERE order_date = CURRENT_DATE - 1
  ON CONFLICT (date) DO UPDATE SET
    total_orders = EXCLUDED.total_orders,
    total_revenue = EXCLUDED.total_revenue,
    updated_at = NOW();

--- Refresh Strategies ---
  Full refresh:       Drop and rebuild (simple, slow)
  Incremental:        Append new data only (fast, complex)
  Lambda architecture: batch (daily full) + speed (streaming incremental)
  Trigger-based:      Update aggregate on each INSERT/UPDATE (real-time, overhead)

--- Trade-Offs ---
  Freshness vs Speed:
    Materialized view → stale until refreshed, but queries are instant
    Live aggregate → always fresh, but query may be slow

  Storage vs Compute:
    Summary table → uses disk space, saves CPU on reads
    Live query → no extra storage, uses CPU on every read

  Granularity:
    Hourly summaries → 24× fewer rows than raw data
    Daily summaries → 1,440× fewer rows
    Monthly summaries → 43,200× fewer rows
    Store at finest granularity you'll ever need to query
EOF
}

cmd_pipelines() {
    cat << 'EOF'
=== Aggregation Pipelines ===

--- MongoDB Aggregation Pipeline ---
  db.orders.aggregate([
    { $match: { status: "completed" } },
    { $group: {
        _id: { year: { $year: "$date" }, month: { $month: "$date" } },
        total: { $sum: "$amount" },
        count: { $sum: 1 },
        avg: { $avg: "$amount" }
    }},
    { $sort: { "_id.year": -1, "_id.month": -1 } },
    { $limit: 12 }
  ]);

  Pipeline stages: $match, $group, $sort, $project, $unwind,
    $lookup (join), $facet (parallel pipelines), $bucket

--- Elasticsearch Aggregations ---
  GET /orders/_search
  {
    "size": 0,
    "aggs": {
      "monthly_revenue": {
        "date_histogram": { "field": "date", "calendar_interval": "month" },
        "aggs": {
          "total_revenue": { "sum": { "field": "amount" } },
          "avg_order": { "avg": { "field": "amount" } }
        }
      }
    }
  }

  Types: metric (sum, avg, max), bucket (terms, histogram, range),
         pipeline (derivative, moving_avg, cumulative_sum)

--- pandas Aggregation ---
  # GroupBy + aggregate
  df.groupby('category').agg(
    total_revenue=('revenue', 'sum'),
    order_count=('order_id', 'count'),
    avg_price=('price', 'mean')
  )

  # Pivot table (multi-dimensional aggregation)
  pd.pivot_table(df, values='revenue',
    index='category', columns='region',
    aggfunc='sum', margins=True)

  # Rolling/window aggregates
  df['ma7'] = df['price'].rolling(window=7).mean()

--- Streaming Aggregation ---
  Aggregate over unbounded data streams:

  Tumbling windows:   fixed-size, non-overlapping time windows
    [0-5min] [5-10min] [10-15min]

  Sliding windows:    fixed-size, overlapping windows
    [0-5min] [1-6min] [2-7min]

  Session windows:    gap-based, variable size
    Activity burst → window closes after gap of inactivity

  Tools: Apache Flink, Kafka Streams, Apache Beam, Spark Streaming
  Watermarks handle late-arriving data
EOF
}

cmd_performance() {
    cat << 'EOF'
=== Aggregate Performance ===

--- Index Strategies ---

  Covering index for GROUP BY:
    CREATE INDEX idx_orders_category_total
    ON orders (category, total);

    SELECT category, SUM(total) FROM orders GROUP BY category;
    → Index-only scan, no table access needed

  Partial index for filtered aggregates:
    CREATE INDEX idx_active_orders ON orders (customer_id)
    WHERE status = 'active';

  BRIN index for time-series aggregation (PostgreSQL):
    CREATE INDEX idx_orders_date ON orders USING BRIN(created_at);
    Excellent for: SUM/COUNT where created_at BETWEEN ...

--- Query Optimization ---

  Pre-filter before aggregation:
    SLOW:  SELECT ... GROUP BY ... HAVING SUM(x) > 100
    FAST:  Add WHERE clause to reduce rows BEFORE grouping

  Avoid SELECT * in aggregation queries:
    Only select columns you need — reduces I/O

  Use materialized CTEs sparingly:
    PostgreSQL CTEs are optimization barriers (before v12)
    Consider subqueries instead for better plan optimization

--- Approximate Algorithms ---

  HyperLogLog (count distinct):
    Standard COUNT(DISTINCT) requires O(n) memory
    HLL uses O(1) memory (~12KB), 0.81% typical error
    Used by: Redis PFCOUNT, BigQuery APPROX_COUNT_DISTINCT

  Count-Min Sketch (frequency estimation):
    "How many times did X appear?" without storing all values
    Used by: stream processing, network monitoring

  t-digest (percentiles):
    Approximate percentiles with O(1) memory
    Accurate at extremes (99th, 99.9th percentile)
    Used by: Elasticsearch percentile aggregation

  Reservoir Sampling:
    Maintain a random sample of fixed size from a stream
    Compute aggregates on the sample
    Good for: AVG, STDDEV, MEDIAN estimates

--- Parallel Aggregation ---
  Most aggregates are decomposable:
    SUM: sum partial sums
    COUNT: sum partial counts
    MIN/MAX: min/max of partials
    AVG: need (sum, count) pairs then divide

  Non-decomposable:
    MEDIAN: cannot merge partial medians
    COUNT DISTINCT: need HLL or full merge
    PERCENTILE: need t-digest or full sort
EOF
}

show_help() {
    cat << EOF
aggregate v$VERSION — Data Aggregation Reference

Usage: script.sh <command>

Commands:
  intro        Aggregation concepts and pipeline overview
  groupby      GROUP BY patterns, HAVING, filtered aggregates
  windows      Window functions: ranking, running totals, moving avg
  rollup       ROLLUP, CUBE, and GROUPING SETS
  functions    Aggregate functions reference (all types)
  materialized Materialized views and summary tables
  pipelines    MongoDB, Elasticsearch, pandas, streaming aggregation
  performance  Indexes, optimization, approximate algorithms
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)        cmd_intro ;;
    groupby)      cmd_groupby ;;
    windows)      cmd_windows ;;
    rollup)       cmd_rollup ;;
    functions)    cmd_functions ;;
    materialized) cmd_materialized ;;
    pipelines)    cmd_pipelines ;;
    performance)  cmd_performance ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "aggregate v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
