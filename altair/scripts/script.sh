#!/bin/bash
# Altair - Declarative Statistical Visualization for Python Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              ALTAIR REFERENCE                               ║
║          Declarative Statistical Visualization              ║
╚══════════════════════════════════════════════════════════════╝

Altair is a declarative statistical visualization library for Python
built on Vega-Lite. Instead of specifying HOW to draw a chart, you
describe WHAT data and mappings you want — Altair figures out the rest.

KEY CONCEPTS:
  Chart        The main visualization object
  Mark         The visual element (point, bar, line, area, etc.)
  Encoding     Map data columns to visual properties (x, y, color, size)
  Data         pandas DataFrame or URL
  Transform    Filter, aggregate, calculate within the spec
  Selection    Interactive filtering and highlighting
  Layering     Combine multiple charts
  Faceting     Split into small multiples

ALTAIR vs MATPLOTLIB vs PLOTLY:
  ┌──────────────┬──────────┬────────────┬──────────┐
  │ Feature      │ Altair   │ Matplotlib │ Plotly   │
  ├──────────────┼──────────┼────────────┼──────────┤
  │ Paradigm     │ Declarative│ Imperative│ Mixed   │
  │ Grammar      │ Vega-Lite│ Custom     │ Custom   │
  │ Interactive  │ Yes      │ Limited    │ Yes      │
  │ Learning     │ Easy     │ Hard       │ Medium   │
  │ Customization│ Medium   │ Maximum    │ High     │
  │ Rendering    │ Browser  │ Static/GUI │ Browser  │
  │ Export       │ HTML/PNG │ PNG/PDF/SVG│ HTML/PNG │
  │ Notebook     │ Great    │ Good       │ Great    │
  │ Big data     │ ~5K rows │ Unlimited  │ ~100K    │
  └──────────────┴──────────┴────────────┴──────────┘

INSTALL:
  pip install altair vega_datasets
  # For saving charts as PNG/SVG:
  pip install altair_saver vl-convert-python
EOF
}

cmd_basics() {
cat << 'EOF'
BASIC CHARTS
==============

SETUP:
  import altair as alt
  import pandas as pd

  # Sample data
  df = pd.DataFrame({
      "x": range(10),
      "y": [2, 7, 4, 8, 5, 9, 3, 6, 1, 10],
      "category": ["A","B","A","B","A","B","A","B","A","B"]
  })

SCATTER PLOT:
  alt.Chart(df).mark_point().encode(
      x="x:Q",        # Q = quantitative
      y="y:Q",
      color="category:N"  # N = nominal
  )

BAR CHART:
  alt.Chart(df).mark_bar().encode(
      x="category:N",
      y="sum(y):Q"
  )

LINE CHART:
  alt.Chart(df).mark_line().encode(
      x="x:Q",
      y="y:Q",
      color="category:N"
  )

AREA CHART:
  alt.Chart(df).mark_area(opacity=0.5).encode(
      x="x:Q",
      y="y:Q",
      color="category:N"
  )

HISTOGRAM:
  alt.Chart(df).mark_bar().encode(
      x=alt.X("y:Q", bin=True),
      y="count()"
  )

HEATMAP:
  alt.Chart(df).mark_rect().encode(
      x="x:O",            # O = ordinal
      y="category:N",
      color="y:Q"
  )

DATA TYPES:
  :Q   Quantitative (numbers: 1, 2.5, 100)
  :N   Nominal (categories: "red", "blue")
  :O   Ordinal (ordered categories: "low", "medium", "high")
  :T   Temporal (dates: "2026-01-01")

ENCODING CHANNELS:
  x, y           Position
  color           Color (fill for area/bar)
  size            Size of marks
  shape           Shape (for points)
  opacity         Transparency
  strokeDash      Line dash pattern
  row, column     Faceting
  tooltip         Hover information
  text            Text labels
  detail          Group without visual encoding
EOF
}

cmd_advanced() {
cat << 'EOF'
ADVANCED TECHNIQUES
=====================

1. LAYERED CHARTS (overlay multiple):
  base = alt.Chart(df).encode(x="x:Q")

  line = base.mark_line().encode(y="y:Q")
  points = base.mark_point(size=100).encode(y="y:Q", color="category:N")

  chart = line + points  # Layer with +

2. CONCATENATION:
  # Horizontal
  chart1 | chart2

  # Vertical
  chart1 & chart2

  # Or explicitly:
  alt.hconcat(chart1, chart2)
  alt.vconcat(chart1, chart2)

3. FACETING (Small multiples):
  alt.Chart(df).mark_point().encode(
      x="x:Q",
      y="y:Q"
  ).facet(
      column="category:N"    # One chart per category
  )

  # Or use row/column encoding:
  alt.Chart(df).mark_bar().encode(
      x="x:Q",
      y="y:Q",
      row="category:N"
  )

4. INTERACTIVE SELECTION:
  # Click selection
  selection = alt.selection_point()
  alt.Chart(df).mark_point(size=100).encode(
      x="x:Q",
      y="y:Q",
      color=alt.condition(selection, "category:N", alt.value("lightgray"))
  ).add_params(selection)

  # Interval (brush) selection
  brush = alt.selection_interval()
  alt.Chart(df).mark_point().encode(
      x="x:Q",
      y="y:Q",
      color=alt.condition(brush, "category:N", alt.value("lightgray"))
  ).add_params(brush)

  # Linked selections (across charts)
  brush = alt.selection_interval()

  scatter = alt.Chart(df).mark_point().encode(
      x="x:Q", y="y:Q",
      color=alt.condition(brush, "category:N", alt.value("gray"))
  ).add_params(brush)

  bars = alt.Chart(df).mark_bar().encode(
      x="category:N",
      y="count()",
      color="category:N"
  ).transform_filter(brush)

  scatter | bars  # Brush on scatter filters bars

5. TRANSFORMS:
  # Filter
  alt.Chart(df).mark_point().encode(...).transform_filter(
      alt.datum.y > 5
  )

  # Calculate new field
  alt.Chart(df).mark_point().encode(
      x="x:Q", y="y_squared:Q"
  ).transform_calculate(
      y_squared="datum.y * datum.y"
  )

  # Aggregate
  alt.Chart(df).mark_bar().encode(
      x="category:N", y="mean_y:Q"
  ).transform_aggregate(
      mean_y="mean(y)", groupby=["category"]
  )

  # Window (running average)
  alt.Chart(df).mark_line().encode(
      x="x:Q", y="rolling_mean:Q"
  ).transform_window(
      rolling_mean="mean(y)",
      frame=[-2, 2]  # 5-point window
  )
EOF
}

cmd_styling() {
cat << 'EOF'
STYLING & CUSTOMIZATION
=========================

TITLES AND LABELS:
  alt.Chart(df).mark_bar().encode(
      x=alt.X("category:N", title="Product Category"),
      y=alt.Y("sum(y):Q", title="Total Revenue ($)")
  ).properties(
      title="Revenue by Category",
      width=400,
      height=300
  )

  # Multi-line title
  alt.Chart(df).mark_bar().encode(...).properties(
      title=alt.TitleParams(
          text="Revenue Analysis",
          subtitle="Q1 2026 Results",
          fontSize=18,
          subtitleFontSize=14,
          anchor="start"
      )
  )

COLOR SCHEMES:
  # Named schemes
  alt.Chart(df).mark_bar().encode(
      color=alt.Color("category:N", scale=alt.Scale(scheme="dark2"))
  )

  # Built-in schemes:
  # Categorical: category10, category20, dark2, set1, set2, set3, tableau10
  # Sequential:  blues, greens, reds, viridis, plasma, inferno, magma
  # Diverging:   redblue, blueorange, redgrey, spectral

  # Custom colors
  alt.Chart(df).mark_bar().encode(
      color=alt.Color("category:N",
          scale=alt.Scale(domain=["A", "B"], range=["#e45756", "#4c78a8"])
      )
  )

THEMES:
  alt.themes.enable("dark")         # Dark theme
  alt.themes.enable("fivethirtyeight")
  alt.themes.enable("ggplot2")
  alt.themes.enable("quartz")
  alt.themes.enable("urbaninstitute")
  alt.themes.enable("default")      # Reset

  # Custom theme
  def my_theme():
      return {
          "config": {
              "background": "#1a1a2e",
              "title": {"color": "#ffffff"},
              "axis": {
                  "labelColor": "#cccccc",
                  "titleColor": "#ffffff",
                  "gridColor": "#333333"
              },
              "view": {"stroke": "transparent"}
          }
      }
  alt.themes.register("bytesagain", my_theme)
  alt.themes.enable("bytesagain")

TOOLTIP CUSTOMIZATION:
  alt.Chart(df).mark_point(size=100).encode(
      x="x:Q",
      y="y:Q",
      tooltip=[
          alt.Tooltip("x:Q", title="X Value"),
          alt.Tooltip("y:Q", title="Y Value", format=".2f"),
          alt.Tooltip("category:N", title="Group")
      ]
  )

AXIS FORMATTING:
  alt.Chart(df).mark_line().encode(
      x=alt.X("date:T", axis=alt.Axis(format="%b %Y", labelAngle=-45)),
      y=alt.Y("value:Q", axis=alt.Axis(format="$,.0f"))
  )

  # Format strings:
  # .2f     Two decimal places
  # ,.0f    Comma separator, no decimals
  # .1%     Percentage with one decimal
  # $,.2f   Dollar with commas and 2 decimals
  # ~s      SI prefix (K, M, G)
EOF
}

cmd_recipes() {
cat << 'EOF'
PRACTICAL RECIPES
===================

1. TIME SERIES WITH TREND LINE:
  import altair as alt
  from vega_datasets import data
  stocks = data.stocks()

  base = alt.Chart(stocks.query("symbol == 'GOOG'")).encode(
      x="date:T"
  )
  line = base.mark_line().encode(y="price:Q")
  trend = base.mark_line(color="red", strokeDash=[5,3]).encode(
      y="mean(price):Q"
  ).transform_window(
      mean_price="mean(price)",
      frame=[-30, 30]
  )
  line + trend

2. GROUPED BAR CHART:
  alt.Chart(df).mark_bar().encode(
      x="month:O",
      y="value:Q",
      color="category:N",
      xOffset="category:N"    # Groups side by side
  )

3. CORRELATION MATRIX:
  import numpy as np
  corr = df.corr().stack().reset_index()
  corr.columns = ["var1", "var2", "correlation"]

  alt.Chart(corr).mark_rect().encode(
      x="var1:N",
      y="var2:N",
      color=alt.Color("correlation:Q",
          scale=alt.Scale(scheme="redblue", domain=[-1, 1]))
  ).properties(width=300, height=300)

4. MAP VISUALIZATION:
  from vega_datasets import data
  counties = alt.topo_feature(data.us_10m.url, "counties")

  alt.Chart(counties).mark_geoshape().encode(
      color="rate:Q"
  ).transform_lookup(
      lookup="id",
      from_=alt.LookupData(unemployment_data, "id", ["rate"])
  ).project("albersUsa")

5. DASHBOARD (Multiple linked charts):
  brush = alt.selection_interval()

  scatter = alt.Chart(df).mark_point().encode(
      x="x:Q", y="y:Q",
      color=alt.condition(brush, "category:N", alt.value("gray"))
  ).add_params(brush).properties(width=300, height=200)

  hist = alt.Chart(df).mark_bar().encode(
      x=alt.X("y:Q", bin=True),
      y="count()"
  ).transform_filter(brush).properties(width=300, height=100)

  bar = alt.Chart(df).mark_bar().encode(
      x="category:N", y="count()",
      color="category:N"
  ).transform_filter(brush).properties(width=300, height=100)

  scatter & (hist | bar)

6. SAVE AND EXPORT:
  chart.save("chart.html")          # Interactive HTML
  chart.save("chart.png")           # Static PNG (needs vl-convert)
  chart.save("chart.svg")           # Vector SVG
  chart.save("chart.pdf")           # PDF
  chart.to_json()                   # Vega-Lite JSON spec
  chart.to_dict()                   # Python dict
EOF
}

cmd_performance() {
cat << 'EOF'
PERFORMANCE & LARGE DATA
===========================

DATA LIMITS:
  Altair embeds data in the chart spec (JSON).
  Default limit: 5,000 rows.

  Workaround for larger data:
  # Disable row limit (careful with browser memory!)
  alt.data_transformers.disable_max_rows()

  # Better: use URL data source
  chart = alt.Chart("https://example.com/data.csv").mark_point().encode(...)

  # Or: pre-aggregate data before charting
  summary = df.groupby("category").agg({"value": "mean"}).reset_index()
  alt.Chart(summary).mark_bar().encode(...)

OPTIMIZATION STRATEGIES:

  1. Pre-aggregate: Don't send raw data if you're aggregating anyway
     # Bad: send 1M rows, aggregate in Vega-Lite
     alt.Chart(big_df).mark_bar().encode(x="cat:N", y="mean(val):Q")

     # Good: aggregate in pandas first
     summary = big_df.groupby("cat")["val"].mean().reset_index()
     alt.Chart(summary).mark_bar().encode(x="cat:N", y="val:Q")

  2. Sample data for exploration
     alt.Chart(big_df.sample(5000)).mark_point().encode(...)

  3. Use binning for distributions
     alt.Chart(big_df).mark_bar().encode(
         x=alt.X("value:Q", bin=alt.Bin(maxbins=50)),
         y="count()"
     )

  4. Use data URL for shared/static data
     alt.Chart("data/processed.csv").mark_line().encode(...)

RENDERING BACKENDS:
  # Jupyter Notebook (default)
  alt.renderers.enable("default")

  # JupyterLab
  alt.renderers.enable("mimetype")

  # VS Code
  # Works automatically with ms-toolsai.jupyter extension

  # Streamlit
  st.altair_chart(chart, use_container_width=True)

  # HTML file
  chart.save("dashboard.html")

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Altair - Declarative Statistical Visualization Reference

Commands:
  intro        Overview, comparison, installation
  basics       Charts, marks, encodings, data types
  advanced     Layers, facets, selections, transforms
  styling      Themes, colors, tooltips, axis formatting
  recipes      Time series, maps, dashboards, export
  performance  Large data strategies, rendering backends

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)       cmd_intro ;;
  basics)      cmd_basics ;;
  advanced)    cmd_advanced ;;
  styling)     cmd_styling ;;
  recipes)     cmd_recipes ;;
  performance) cmd_performance ;;
  help|*)      show_help ;;
esac
