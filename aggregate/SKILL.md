---
name: "aggregate"
version: "1.0.0"
description: "Data aggregation reference — GROUP BY patterns, window functions, rollups, and materialized aggregates. Use when designing summary queries, building dashboards, or optimizing aggregate performance."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [aggregate, sql, analytics, groupby, window, rollup, data]
category: "atomic"
---

# Aggregate — Data Aggregation Reference

Quick-reference skill for SQL aggregation, window functions, and summary data patterns.

## When to Use

- Writing GROUP BY queries with complex aggregation logic
- Using window functions for running totals, rankings, and moving averages
- Designing materialized views and pre-aggregated tables
- Understanding ROLLUP, CUBE, and GROUPING SETS
- Optimizing aggregate query performance

## Commands

### `intro`

```bash
scripts/script.sh intro
```

Overview of data aggregation — functions, grouping, and aggregate pipelines.

### `groupby`

```bash
scripts/script.sh groupby
```

GROUP BY patterns — basic, multi-column, HAVING, and filtered aggregates.

### `windows`

```bash
scripts/script.sh windows
```

Window functions — ROW_NUMBER, RANK, LAG, LEAD, running totals, moving averages.

### `rollup`

```bash
scripts/script.sh rollup
```

ROLLUP, CUBE, and GROUPING SETS — multi-level summary reports.

### `functions`

```bash
scripts/script.sh functions
```

Aggregate functions — COUNT, SUM, AVG, MIN, MAX, PERCENTILE, ARRAY_AGG, and more.

### `materialized`

```bash
scripts/script.sh materialized
```

Materialized aggregates — pre-computed summaries, refresh strategies, trade-offs.

### `pipelines`

```bash
scripts/script.sh pipelines
```

Aggregation pipelines — MongoDB, Elasticsearch, pandas, and streaming aggregates.

### `performance`

```bash
scripts/script.sh performance
```

Aggregate performance — indexes, partial aggregation, approximate algorithms.

### `help`

```bash
scripts/script.sh help
```

### `version`

```bash
scripts/script.sh version
```

## Configuration

| Variable | Description |
|----------|-------------|
| `AGGREGATE_DIR` | Data directory (default: ~/.aggregate/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
