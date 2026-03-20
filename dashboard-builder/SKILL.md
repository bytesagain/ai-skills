---
version: "3.3.0"
name: Dashboard Builder
description: "Build and render ASCII dashboards in terminal with bar charts, gauges, tables, and text panels. Use when visualizing metrics or monitoring data."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: [dashboard, terminal, ascii, chart, monitoring]
category: "devtools"
---

# dashboard-builder

Terminal dashboard toolkit — create dashboards with bar charts, gauges, tables, and text panels, all rendered as ASCII art in your terminal.

## Commands

### `create`

Create a new dashboard configuration.

```bash
scripts/script.sh create server-metrics
```

### `add-widget`

Add a widget to a dashboard. Types: bar, gauge, table, text.

```bash
scripts/script.sh add-widget server-metrics bar "Revenue:85,Costs:42,Profit:43"
scripts/script.sh add-widget server-metrics gauge "CPU:72:100"
scripts/script.sh add-widget server-metrics table "Service:Status|API:OK|DB:OK"
scripts/script.sh add-widget server-metrics text "All systems operational"
```

### `render`

Render a dashboard in the terminal with ASCII art charts.

```bash
scripts/script.sh render server-metrics
```

Output includes bordered frames, bar charts with `█░` characters, gauges with percentage and threshold labels, and formatted tables.

### `list`

List all dashboards with widget counts and sizes.

```bash
scripts/script.sh list
```

### `show`

Show the raw JSON configuration of a dashboard.

```bash
scripts/script.sh show server-metrics
```

### `delete`

Delete a dashboard.

```bash
scripts/script.sh delete old-dashboard
```

### `export`

Export a dashboard to JSON, plain text, or HTML.

```bash
scripts/script.sh export server-metrics json
scripts/script.sh export server-metrics html
scripts/script.sh export server-metrics txt
```

### `import`

Import a dashboard from a JSON file.

```bash
scripts/script.sh import backup.json
```

### `demo`

Show a built-in demo dashboard with all widget types rendered.

```bash
scripts/script.sh demo
```

## Examples

```bash
# Full workflow
scripts/script.sh create sales-q4
scripts/script.sh add-widget sales-q4 bar "Jan:120,Feb:95,Mar:140,Apr:180"
scripts/script.sh add-widget sales-q4 gauge "Target:340:500"
scripts/script.sh add-widget sales-q4 table "Region:Revenue:Growth|US:2.4M:12%|EU:1.8M:8%|APAC:900K:22%"
scripts/script.sh add-widget sales-q4 text "Q4 revenue on track"
scripts/script.sh render sales-q4
scripts/script.sh export sales-q4 html
```

## Configuration

| Variable | Required | Description |
|----------|----------|-------------|
| `DASHBOARD_BUILDER_DIR` | No | Data directory (default: `~/.dashboard-builder/`) |

## Data Storage

All dashboards saved in `~/.dashboard-builder/dashboards/` as JSON files.

Each dashboard file contains:
- `name` — Dashboard identifier
- `created` — Creation timestamp
- `widgets` — Array of widget objects with type, data, and ID

Widget data format:
- **bar**: `"Label1:Value1,Label2:Value2,..."` — comma-separated label:value pairs
- **gauge**: `"Label:Current:Max"` — single gauge with threshold detection
- **table**: `"H1:H2|R1C1:R1C2|R2C1:R2C2"` — pipe-separated rows, colon-separated columns
- **text**: `"Any message text"` — displayed in a bordered panel

## Requirements

- bash 4.0+
- Standard Unix tools (grep, sed, wc)

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
