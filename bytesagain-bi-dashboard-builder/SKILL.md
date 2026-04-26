---
name: "BytesAgain BI Dashboard Builder"
description: "Build BI dashboard specs, chart plans, SQL queries, and Apache Superset chart JSON. Use when creating dashboards, BI reports, KPI charts, or visualization layouts."
version: "1.1.0"
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: ["bi", "dashboard", "chart", "data", "sql", "superset", "visualization"]
category: "data"
---

# BytesAgain BI Dashboard Builder

Build BI dashboard specs from natural language, CSV headers, JSON metrics, or KPI lists. Outputs dashboard plans, SQL query templates, chart definitions, Apache Superset-compatible chart JSON snippets, KPI dictionaries, and dashboard QA reports.

## Commands

### generate
Create a dashboard plan with KPIs, charts, filters, and layout.
```bash
bash scripts/script.sh generate --goal "sales dashboard" --metrics "revenue,orders,aov" --dimensions "date,region,channel"
```

### chart
Create a single chart spec for bar, line, pie, table, metric, or time-series visualization.
```bash
bash scripts/script.sh chart --type line --metric revenue --dimension date --title "Revenue Trend"
```

### sql
Generate SQL templates for chart datasets and KPI cards.
```bash
bash scripts/script.sh sql --table orders --metrics "revenue,orders" --dimensions "date,region"
```

### superset
Export Apache Superset chart JSON snippets from a chart spec.
```bash
bash scripts/script.sh superset --type bar --metric revenue --dimension region --datasource "orders"
```


### kpi
Create KPI formulas, target hints, and owner notes for a BI dashboard.
```bash
bash scripts/script.sh kpi --metrics "revenue,orders,aov,conversion_rate" --dimensions "date,channel"
```

### dataset
Create a dataset contract with columns, grain, freshness, and quality checks.
```bash
bash scripts/script.sh dataset --table orders --metrics "revenue,orders" --dimensions "date,channel,region"
```

### qa
Audit a dashboard plan for business clarity, chart fit, and missing data definitions.
```bash
bash scripts/script.sh qa --goal "ecommerce growth dashboard" --metrics "revenue,orders,aov" --dimensions "date,channel"
```

### validate
Check a dashboard spec for missing metrics, dimensions, filters, and chart titles.
```bash
bash scripts/script.sh validate dashboard.json
```

### demo
Print a demo e-commerce BI dashboard with SQL and chart JSON.
```bash
bash scripts/script.sh demo
```

## Input Formats

- Natural language goal: `--goal "growth dashboard"`
- Metric list: `--metrics "revenue,orders,conversion_rate"`
- Dimension list: `--dimensions "date,region,channel"`
- JSON spec file for validation

## Output

- Markdown dashboard plan
- SQL query templates
- JSON chart specs
- Apache Superset chart JSON snippets

## Setup

| Variable | Required | Description |
|----------|----------|-------------|
| None | No | Runs with bash and standard Unix tools only |

## Notes

Use generic names for slugs and assets. Apache Superset output is supported as an export format, but this skill is a general BI dashboard builder.

## Feedback

https://bytesagain.com/feedback/

Powered by BytesAgain | bytesagain.com
