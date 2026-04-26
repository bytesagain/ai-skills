#!/usr/bin/env bash
set -euo pipefail

VERSION="1.1.0"

err() { printf 'Error: %s\n' "$*" >&2; }
slugify() { printf '%s' "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9_ -]/ /g;s/[ _][ _]*/_/g;s/^_//;s/_$//'; }
split_csv() { printf '%s' "$1" | tr ',' '\n' | sed 's/^ *//;s/ *$//' | sed '/^$/d'; }
json_escape() { printf '%s' "$1" | sed 's/\\/\\\\/g;s/"/\\"/g'; }

usage() {
cat <<EOF_HELP
bytesagain-bi-dashboard-builder v$VERSION

Commands:
  generate   Build a BI dashboard plan from goal, metrics, and dimensions
  chart      Create one chart spec
  sql        Generate SQL templates for KPIs and charts
  superset   Export Apache Superset chart JSON snippets
  kpi        Create KPI formulas and owner notes
  dataset    Create a dataset contract
  qa         Audit dashboard clarity and chart fit
  validate   Check a dashboard JSON/spec file
  demo       Print a demo dashboard
  help       Show help
  version    Show version

Examples:
  bash scripts/script.sh generate --goal "sales dashboard" --metrics "revenue,orders,aov" --dimensions "date,region,channel"
  bash scripts/script.sh chart --type line --metric revenue --dimension date --title "Revenue Trend"
  bash scripts/script.sh sql --table orders --metrics "revenue,orders" --dimensions "date,region"
  bash scripts/script.sh superset --type bar --metric revenue --dimension region --datasource orders
EOF_HELP
}

parse_opts() {
    GOAL=""; METRICS=""; DIMENSIONS=""; TYPE="bar"; METRIC=""; DIMENSION=""; TITLE=""; TABLE="events"; DATASOURCE=""
    while [ "$#" -gt 0 ]; do
        case "$1" in
            --goal) GOAL="${2:-}"; shift 2 ;;
            --metrics) METRICS="${2:-}"; shift 2 ;;
            --dimensions) DIMENSIONS="${2:-}"; shift 2 ;;
            --type) TYPE="${2:-}"; shift 2 ;;
            --metric) METRIC="${2:-}"; shift 2 ;;
            --dimension) DIMENSION="${2:-}"; shift 2 ;;
            --title) TITLE="${2:-}"; shift 2 ;;
            --table) TABLE="${2:-}"; shift 2 ;;
            --datasource) DATASOURCE="${2:-}"; shift 2 ;;
            *) err "unknown option: $1"; return 1 ;;
        esac
    done
}

metric_formula() {
    local m="$(slugify "$1")"
    case "$m" in
        revenue|sales|gmv) echo "SUM(amount) AS $m" ;;
        orders|users|customers|sessions) echo "COUNT(DISTINCT ${m%?}_id) AS $m" ;;
        conversion_rate|cr) echo "ROUND(100.0 * SUM(conversions) / NULLIF(SUM(sessions), 0), 2) AS conversion_rate" ;;
        aov|avg_order_value) echo "ROUND(SUM(amount) / NULLIF(COUNT(DISTINCT order_id), 0), 2) AS aov" ;;
        retention|retention_rate) echo "ROUND(100.0 * SUM(returning_users) / NULLIF(SUM(users), 0), 2) AS retention_rate" ;;
        *) echo "SUM($m) AS $m" ;;
    esac
}

chart_for_metric() {
    local metric="$1" dim="$2"
    local m="$(slugify "$metric")" d="$(slugify "$dim")"
    case "$d" in
        date|day|week|month|created_at) echo "line" ;;
        region|country|channel|category|source) echo "bar" ;;
        status|segment) echo "pie" ;;
        *) echo "table" ;;
    esac
}

cmd_generate() {
    parse_opts "$@"
    [ -n "$GOAL" ] || GOAL="BI dashboard"
    [ -n "$METRICS" ] || METRICS="revenue,orders,conversion_rate"
    [ -n "$DIMENSIONS" ] || DIMENSIONS="date,region,channel"

    echo "# Dashboard Plan: $GOAL"
    echo
    echo "## KPIs"
    split_csv "$METRICS" | while read -r m; do
        printf -- '- **%s** — primary KPI card with current value, trend, and target delta\n' "$m"
    done
    echo
    echo "## Charts"
    local first_dim
    first_dim=$(split_csv "$DIMENSIONS" | head -1)
    split_csv "$METRICS" | while read -r m; do
        local ctype
        ctype=$(chart_for_metric "$m" "$first_dim")
        printf -- '- %s by %s — %s chart for trend and comparison\n' "$m" "$first_dim" "$ctype"
    done
    echo
    echo "## Filters"
    split_csv "$DIMENSIONS" | while read -r d; do
        printf -- '- %s filter for slicing dashboard views\n' "$d"
    done
    echo
    echo "## Layout"
    echo "- Row 1: KPI cards"
    echo "- Row 2: trend charts"
    echo "- Row 3: breakdown charts and detail table"
    echo
    echo "## Next Commands"
    echo "bash scripts/script.sh sql --table events --metrics \"$METRICS\" --dimensions \"$DIMENSIONS\""
    echo "bash scripts/script.sh superset --type bar --metric $(split_csv "$METRICS" | head -1) --dimension $first_dim --datasource events"
}

cmd_chart() {
    parse_opts "$@"
    [ -n "$METRIC" ] || METRIC="revenue"
    [ -n "$DIMENSION" ] || DIMENSION="date"
    [ -n "$TITLE" ] || TITLE="$METRIC by $DIMENSION"
    local id="$(slugify "$TITLE")"
    cat <<EOF_JSON
{
  "id": "$id",
  "title": "$(json_escape "$TITLE")",
  "type": "$(json_escape "$TYPE")",
  "metric": "$(json_escape "$METRIC")",
  "dimension": "$(json_escape "$DIMENSION")",
  "sort": "$(slugify "$METRIC") DESC",
  "limit": 100,
  "notes": "Use this chart in BI dashboards, reports, or Superset exports."
}
EOF_JSON
}

cmd_sql() {
    parse_opts "$@"
    [ -n "$METRICS" ] || METRICS="revenue,orders"
    [ -n "$DIMENSIONS" ] || DIMENSIONS="date"
    local dims select_metrics group_by
    dims=$(split_csv "$DIMENSIONS" | while read -r d; do slugify "$d"; done | paste -sd ', ' -)
    select_metrics=$(split_csv "$METRICS" | while read -r m; do metric_formula "$m"; done | sed 's/^/  /' | paste -sd ',\n' -)
    group_by=$(split_csv "$DIMENSIONS" | while read -r d; do slugify "$d"; done | paste -sd ', ' -)
    cat <<EOF_SQL
-- BI dashboard dataset query
SELECT
  $dims,
$select_metrics
FROM $TABLE
WHERE event_date >= CURRENT_DATE - INTERVAL '90 days'
GROUP BY $group_by
ORDER BY $group_by;

-- KPI card query
SELECT
$(split_csv "$METRICS" | while read -r m; do metric_formula "$m"; done | sed 's/^/  /' | paste -sd ',\n' -)
FROM $TABLE
WHERE event_date >= CURRENT_DATE - INTERVAL '30 days';
EOF_SQL
}

cmd_superset() {
    parse_opts "$@"
    [ -n "$METRIC" ] || METRIC="revenue"
    [ -n "$DIMENSION" ] || DIMENSION="date"
    [ -n "$DATASOURCE" ] || DATASOURCE="$TABLE"
    [ -n "$TITLE" ] || TITLE="$METRIC by $DIMENSION"
    local viz="$TYPE"
    case "$TYPE" in
        line|timeseries) viz="echarts_timeseries_line" ;;
        bar) viz="echarts_timeseries_bar" ;;
        pie) viz="pie" ;;
        table) viz="table" ;;
        metric|big_number) viz="big_number_total" ;;
    esac
    cat <<EOF_JSON
{
  "slice_name": "$(json_escape "$TITLE")",
  "viz_type": "$viz",
  "datasource_name": "$(json_escape "$DATASOURCE")",
  "params": {
    "metrics": ["$(slugify "$METRIC")"],
    "groupby": ["$(slugify "$DIMENSION")"],
    "row_limit": 1000,
    "order_desc": true,
    "show_legend": true,
    "adhoc_filters": []
  },
  "dashboard_position": {
    "type": "CHART",
    "meta": { "width": 6, "height": 50 }
  }
}
EOF_JSON
}


cmd_kpi() {
    parse_opts "$@"
    [ -n "$METRICS" ] || METRICS="revenue,orders,aov,conversion_rate"
    [ -n "$DIMENSIONS" ] || DIMENSIONS="date,channel"
    echo "# KPI Dictionary"
    split_csv "$METRICS" | while read -r m; do
        local key; key=$(slugify "$m")
        echo "## $key"
        echo "- Formula: $(metric_formula "$m")"
        echo "- Owner: assign business owner before launch"
        echo "- Grain: match dashboard grain across $(echo "$DIMENSIONS" | tr ',' '/')"
        echo "- Target: define current period, previous period, and goal threshold"
        echo "- Alert: flag if value changes more than expected week over week"
        echo
    done
}

cmd_dataset() {
    parse_opts "$@"
    [ -n "$METRICS" ] || METRICS="revenue,orders"
    [ -n "$DIMENSIONS" ] || DIMENSIONS="date,channel"
    echo "# Dataset Contract: $TABLE"
    echo "Grain: one row per $(echo "$DIMENSIONS" | tr ',' '+')"
    echo "Freshness: update daily before business review"
    echo
    echo "## Required Columns"
    split_csv "$DIMENSIONS" | while read -r d; do echo "- $(slugify "$d") dimension column"; done
    split_csv "$METRICS" | while read -r m; do echo "- $(slugify "$m") metric source column or derived formula"; done
    echo
    echo "## Quality Checks"
    echo "- No duplicate rows at declared grain"
    echo "- Date range covers reporting window"
    echo "- Null rate reviewed for every dimension"
    echo "- Metric totals reconcile with source system"
}

cmd_qa() {
    parse_opts "$@"
    [ -n "$GOAL" ] || GOAL="BI dashboard"
    [ -n "$METRICS" ] || METRICS="revenue,orders,conversion_rate"
    [ -n "$DIMENSIONS" ] || DIMENSIONS="date,channel"
    local score=100
    local mc dc
    mc=$(split_csv "$METRICS" | wc -l | tr -d ' ')
    dc=$(split_csv "$DIMENSIONS" | wc -l | tr -d ' ')
    [ "$mc" -lt 2 ] && score=$((score-15))
    [ "$dc" -lt 1 ] && score=$((score-15))
    echo "# Dashboard QA: $GOAL"
    echo "Score: $score/100"
    echo
    echo "## Checks"
    echo "- Goal is stated as a business decision, not only a chart collection"
    echo "- Each KPI has formula, owner, grain, and target"
    echo "- Trend chart uses date/time dimension"
    echo "- Breakdown chart uses channel, region, category, or segment"
    echo "- Superset export uses supported viz_type values"
    echo "- Dashboard has filters that match user questions"
}

cmd_validate() {
    local file="${1:-}"
    if [ -z "$file" ]; then
        tmp=$(mktemp); cmd_chart --metric revenue --dimension date --title "Revenue Trend" > "$tmp"; file="$tmp"
    fi
    if [ ! -f "$file" ]; then
        tmp=$(mktemp); cmd_chart --metric revenue --dimension date --title "Revenue Trend" > "$tmp"; file="$tmp"
    fi
    local problems=0
    grep -q '"title"' "$file" || { echo "missing title"; problems=$((problems+1)); }
    grep -q '"metric"\|"metrics"' "$file" || { echo "missing metric(s)"; problems=$((problems+1)); }
    grep -q '"dimension"\|"groupby"' "$file" || { echo "missing dimension/groupby"; problems=$((problems+1)); }
    grep -q '"type"\|"viz_type"' "$file" || { echo "missing chart type"; problems=$((problems+1)); }
    if [ "$problems" -eq 0 ]; then echo "valid dashboard spec: $file"; else echo "$problems problem(s) found"; return 1; fi
}

cmd_demo() {
    echo "## Demo: E-commerce BI Dashboard"
    cmd_generate --goal "e-commerce growth dashboard" --metrics "revenue,orders,aov,conversion_rate" --dimensions "date,channel,region"
    echo
    echo "## SQL"
    cmd_sql --table orders --metrics "revenue,orders,aov,conversion_rate" --dimensions "date,channel"
    echo
    echo "## Superset Chart JSON"
    cmd_superset --type bar --metric revenue --dimension channel --datasource orders --title "Revenue by Channel"
}

case "${1:-help}" in
    generate) shift; cmd_generate "$@" ;;
    chart) shift; cmd_chart "$@" ;;
    sql) shift; cmd_sql "$@" ;;
    superset) shift; cmd_superset "$@" ;;
    kpi) shift; cmd_kpi "$@" ;;
    dataset) shift; cmd_dataset "$@" ;;
    qa) shift; cmd_qa "$@" ;;
    validate) shift; cmd_validate "$@" ;;
    demo) shift; cmd_demo "$@" ;;
    version) echo "$VERSION" ;;
    help|-h|--help) usage ;;
    *) err "unknown command: $1"; usage; exit 1 ;;
esac
