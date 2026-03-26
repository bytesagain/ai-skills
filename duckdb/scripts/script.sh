#!/bin/bash
# DuckDB - In-Process Analytical Database Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              DUCKDB REFERENCE                               ║
║          In-Process Analytical SQL Database                  ║
╚══════════════════════════════════════════════════════════════╝

DuckDB is an in-process SQL OLAP database. Think "SQLite for
analytics" — no server, no setup, just import and query.

KEY FEATURES:
  In-process     Runs inside your application (no server)
  Columnar       Column-oriented storage for fast analytics
  SQL            Full SQL with window functions, CTEs, etc.
  File formats   Query CSV, Parquet, JSON directly (no import!)
  Zero-copy      Read Pandas DataFrames without copying
  Parallel       Automatic multi-threaded query execution
  Portable       Single file database, runs everywhere

DUCKDB vs SQLITE vs POLARS vs SPARK:
  ┌──────────────┬──────────┬──────────┬──────────┬──────────┐
  │ Feature      │ DuckDB   │ SQLite   │ Polars   │ Spark    │
  ├──────────────┼──────────┼──────────┼──────────┼──────────┤
  │ Model        │ Column   │ Row      │ Column   │ Column   │
  │ Language     │ SQL      │ SQL      │ Python   │ SQL/Py   │
  │ OLAP         │ Yes      │ No       │ Yes      │ Yes      │
  │ Server       │ No       │ No       │ No       │ Yes      │
  │ File query   │ Native   │ No       │ Native   │ Yes      │
  │ Parallel     │ Auto     │ No       │ Auto     │ Cluster  │
  │ Memory       │ Out-of-core│ In-mem │ Out-of-core│ Cluster│
  └──────────────┴──────────┴──────────┴──────────┴──────────┘

INSTALL:
  pip install duckdb
  brew install duckdb        # CLI
  # Or just download the binary — zero dependencies
EOF
}

cmd_queries() {
cat << 'EOF'
SQL QUERIES
=============

CLI:
  duckdb                           # In-memory
  duckdb mydata.duckdb             # Persistent file

QUERY FILES DIRECTLY:
  -- CSV (no import needed!)
  SELECT * FROM 'data.csv' LIMIT 10;
  SELECT * FROM 'data/*.csv';          -- Glob multiple files
  SELECT * FROM 'https://example.com/data.csv';  -- Remote!

  -- Parquet
  SELECT * FROM 'data.parquet';
  SELECT * FROM 'data/**/*.parquet';   -- Recursive glob
  SELECT * FROM read_parquet('s3://bucket/data/*.parquet');

  -- JSON
  SELECT * FROM 'data.json';
  SELECT * FROM read_json_auto('data.ndjson');

  -- Excel
  SELECT * FROM st_read('data.xlsx');

ANALYTICS:
  -- Window functions
  SELECT name, department, salary,
      RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dept_rank,
      salary - AVG(salary) OVER (PARTITION BY department) AS vs_avg
  FROM employees;

  -- Pivoting
  PIVOT sales ON product USING SUM(amount) GROUP BY month;

  -- Unpivot
  UNPIVOT monthly_data ON jan, feb, mar INTO NAME month VALUE amount;

  -- QUALIFY (filter after window)
  SELECT * FROM employees
  QUALIFY ROW_NUMBER() OVER (PARTITION BY dept ORDER BY salary DESC) <= 3;

  -- SAMPLE
  SELECT * FROM big_table USING SAMPLE 10%;
  SELECT * FROM big_table USING SAMPLE 1000 ROWS;

  -- ASOF JOIN (time-series)
  SELECT t.*, p.price
  FROM trades t ASOF JOIN prices p ON t.ticker = p.ticker AND t.ts >= p.ts;

  -- EXCLUDE/REPLACE in SELECT
  SELECT * EXCLUDE (id, created_at) FROM users;
  SELECT * REPLACE (UPPER(name) AS name) FROM users;

  -- LIST aggregation
  SELECT department, LIST(name) AS members FROM employees GROUP BY department;

  -- STRING_AGG
  SELECT department, STRING_AGG(name, ', ' ORDER BY name) FROM employees GROUP BY department;

CREATE TABLE:
  CREATE TABLE users AS SELECT * FROM 'users.csv';
  CREATE TABLE events AS SELECT * FROM 'events.parquet';

EXPORT:
  COPY (SELECT * FROM analysis) TO 'output.parquet' (FORMAT PARQUET);
  COPY (SELECT * FROM analysis) TO 'output.csv' (HEADER, DELIMITER ',');
  COPY (SELECT * FROM analysis) TO 'output.json';
EOF
}

cmd_python() {
cat << 'EOF'
PYTHON INTEGRATION
====================

BASIC:
  import duckdb

  # In-memory
  con = duckdb.connect()

  # Persistent
  con = duckdb.connect("mydata.duckdb")

  # Query
  result = con.sql("SELECT 42 AS answer").fetchall()
  # [(42,)]

  df = con.sql("SELECT * FROM 'data.csv' LIMIT 10").df()
  # Returns Pandas DataFrame

QUERY PANDAS DIRECTLY:
  import pandas as pd
  df = pd.DataFrame({"name": ["Alice", "Bob"], "age": [30, 25]})

  # Query the DataFrame with SQL!
  result = duckdb.sql("SELECT * FROM df WHERE age > 27").df()

  # Join DataFrames
  orders = pd.DataFrame({"user_id": [1, 2], "amount": [99, 150]})
  users = pd.DataFrame({"id": [1, 2], "name": ["Alice", "Bob"]})
  result = duckdb.sql("""
      SELECT u.name, o.amount
      FROM orders o JOIN users u ON o.user_id = u.id
  """).df()

POLARS INTEGRATION:
  import polars as pl
  df = pl.DataFrame({"x": [1, 2, 3], "y": [10, 20, 30]})
  result = duckdb.sql("SELECT * FROM df WHERE x > 1").pl()

ARROW:
  # Zero-copy with Apache Arrow
  arrow_table = con.sql("SELECT * FROM 'data.parquet'").arrow()
  # Returns PyArrow Table (no copying!)

PARAMETERIZED QUERIES:
  con.execute("SELECT * FROM users WHERE age > ?", [25])
  con.execute("SELECT * FROM users WHERE name = $1", ["Alice"])

RELATION API (lazy):
  rel = con.sql("SELECT * FROM 'data.csv'")
  rel = rel.filter("age > 25")
  rel = rel.project("name, age")
  rel = rel.order("age DESC")
  rel = rel.limit(10)
  result = rel.df()  # Executes here

EXTENSIONS:
  con.install_extension("httpfs")    # HTTP/S3 file access
  con.load_extension("httpfs")
  con.install_extension("spatial")   # GIS/spatial queries
  con.install_extension("json")      # JSON functions
  con.install_extension("icu")       # Unicode collation
  con.install_extension("fts")       # Full-text search
  con.install_extension("excel")     # Excel file support

  # S3 access
  con.sql("SET s3_region='us-east-1'")
  con.sql("SET s3_access_key_id='...'")
  con.sql("SELECT * FROM read_parquet('s3://bucket/data.parquet')")

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
DuckDB - In-Process Analytical Database Reference

Commands:
  intro    Overview, comparison, install
  queries  SQL, file queries, window functions, ASOF joins
  python   Pandas/Polars integration, Arrow, extensions

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)   cmd_intro ;;
  queries) cmd_queries ;;
  python)  cmd_python ;;
  help|*)  show_help ;;
esac
