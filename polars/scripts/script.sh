#!/bin/bash
# Polars - Lightning-Fast DataFrame Library Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              POLARS REFERENCE                               ║
║          Lightning-Fast DataFrame Library                   ║
╚══════════════════════════════════════════════════════════════╝

Polars is a blazingly fast DataFrame library written in Rust with
Python and Node.js bindings. It's designed to be a faster, more
memory-efficient alternative to Pandas.

KEY FEATURES:
  Speed        10-100x faster than Pandas
  Memory       Uses Apache Arrow columnar format
  Lazy eval    Query optimization before execution
  Parallel     Multi-threaded by default
  Out-of-core  Process data larger than RAM
  Streaming    Stream large files without loading all
  SQL          Query DataFrames with SQL
  Rust-powered Written in Rust, Python bindings

POLARS vs PANDAS:
  ┌──────────────┬──────────┬──────────┐
  │ Feature      │ Polars   │ Pandas   │
  ├──────────────┼──────────┼──────────┤
  │ Speed        │ 10-100x  │ Baseline │
  │ Memory       │ Efficient│ High     │
  │ Multi-thread │ Auto     │ No*      │
  │ Lazy eval    │ Yes      │ No       │
  │ Null handling│ Native   │ NaN/None │
  │ API          │ Expression│Method   │
  │ Ecosystem    │ Growing  │ Largest  │
  │ String type  │ Utf8     │ object   │
  │ Index        │ No index │ Index    │
  └──────────────┴──────────┴──────────┘
  * Pandas 2.0 improved but still mostly single-threaded

INSTALL:
  pip install polars
  pip install polars[all]    # With all optional deps
EOF
}

cmd_basics() {
cat << 'EOF'
BASIC OPERATIONS
==================

import polars as pl

CREATE DATAFRAME:
  df = pl.DataFrame({
      "name": ["Alice", "Bob", "Charlie"],
      "age": [30, 25, 35],
      "city": ["NYC", "LA", "NYC"],
  })

READ FILES:
  df = pl.read_csv("data.csv")
  df = pl.read_parquet("data.parquet")
  df = pl.read_json("data.json")
  df = pl.read_excel("data.xlsx")
  df = pl.read_ipc("data.arrow")

  # Lazy (don't load into memory yet)
  lf = pl.scan_csv("data.csv")
  lf = pl.scan_parquet("data.parquet")
  lf = pl.scan_parquet("data/**/*.parquet")  # Glob!

SELECT & FILTER:
  # Select columns
  df.select("name", "age")
  df.select(pl.col("name"), pl.col("age") + 1)

  # Filter
  df.filter(pl.col("age") > 25)
  df.filter((pl.col("age") > 25) & (pl.col("city") == "NYC"))

  # With expressions
  df.select(
      pl.col("name"),
      pl.col("age").alias("years"),
      (pl.col("age") * 12).alias("months"),
      pl.col("name").str.to_uppercase().alias("NAME"),
  )

MUTATE:
  df.with_columns(
      (pl.col("age") + 1).alias("next_year_age"),
      pl.lit("unknown").alias("status"),
      pl.col("name").str.len_chars().alias("name_length"),
  )

SORT:
  df.sort("age")
  df.sort("age", descending=True)
  df.sort(["city", "age"], descending=[True, False])

GROUP BY:
  df.group_by("city").agg(
      pl.col("age").mean().alias("avg_age"),
      pl.col("age").max().alias("max_age"),
      pl.col("name").count().alias("count"),
      pl.col("name").alias("names"),  # Collect as list
  )

JOIN:
  orders = pl.DataFrame({"user_id": [1, 2, 1], "amount": [100, 200, 50]})
  users = pl.DataFrame({"id": [1, 2], "name": ["Alice", "Bob"]})

  orders.join(users, left_on="user_id", right_on="id", how="left")

WRITE:
  df.write_csv("output.csv")
  df.write_parquet("output.parquet")
  df.write_json("output.json")
EOF
}

cmd_advanced() {
cat << 'EOF'
LAZY EVALUATION & ADVANCED
=============================

LAZY FRAME (query optimization):
  # Build query plan without executing
  result = (
      pl.scan_parquet("sales/*.parquet")
      .filter(pl.col("date") >= "2026-01-01")
      .group_by("product")
      .agg(
          pl.col("amount").sum().alias("total"),
          pl.col("amount").count().alias("orders"),
      )
      .sort("total", descending=True)
      .limit(10)
      .collect()  # Execute here!
  )

  # Benefits:
  # - Predicate pushdown (filter before loading)
  # - Projection pushdown (only load needed columns)
  # - Automatic parallelization
  # - Query plan optimization

  # View query plan
  lf.explain()               # Optimized plan
  lf.explain(optimized=False) # Unoptimized plan

WINDOW FUNCTIONS:
  df.with_columns(
      pl.col("salary").mean().over("department").alias("dept_avg"),
      pl.col("salary").rank().over("department").alias("dept_rank"),
      (pl.col("salary") - pl.col("salary").mean().over("department")).alias("vs_dept_avg"),
  )

EXPRESSIONS:
  # String operations
  pl.col("email").str.contains("@gmail")
  pl.col("name").str.to_lowercase()
  pl.col("name").str.split(" ").list.first()
  pl.col("url").str.extract(r"https?://([^/]+)", 1)

  # Date operations
  pl.col("date").dt.year()
  pl.col("date").dt.month()
  pl.col("date").dt.weekday()
  pl.col("date").dt.strftime("%Y-%m-%d")
  pl.col("ts").dt.truncate("1h")

  # Conditional
  pl.when(pl.col("age") >= 18).then(pl.lit("adult")).otherwise(pl.lit("minor"))

  # Multiple conditions
  pl.when(pl.col("score") >= 90).then(pl.lit("A"))
    .when(pl.col("score") >= 80).then(pl.lit("B"))
    .when(pl.col("score") >= 70).then(pl.lit("C"))
    .otherwise(pl.lit("F"))

  # List operations
  pl.col("tags").list.len()
  pl.col("tags").list.contains("python")
  pl.col("scores").list.mean()

SQL INTERFACE:
  ctx = pl.SQLContext(users=df_users, orders=df_orders)
  result = ctx.execute("""
      SELECT u.name, SUM(o.amount) as total
      FROM users u
      JOIN orders o ON u.id = o.user_id
      GROUP BY u.name
      ORDER BY total DESC
  """).collect()

STREAMING (larger-than-RAM):
  result = (
      pl.scan_csv("huge_file.csv")
      .filter(pl.col("value") > 100)
      .group_by("category")
      .agg(pl.col("value").sum())
      .collect(streaming=True)
  )

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Polars - Lightning-Fast DataFrame Library Reference

Commands:
  intro      Overview, comparison with Pandas
  basics     Create, read, filter, group, join, write
  advanced   Lazy evaluation, window functions, expressions, SQL

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)    cmd_intro ;;
  basics)   cmd_basics ;;
  advanced) cmd_advanced ;;
  help|*)   show_help ;;
esac
