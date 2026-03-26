#!/bin/bash
# Plotly - Interactive Visualization Library Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              PLOTLY REFERENCE                               ║
║          Interactive Web-Based Visualization                ║
╚══════════════════════════════════════════════════════════════╝

Plotly is a Python library for creating interactive, publication-
quality graphs that render in the browser using JavaScript.

KEY FEATURES:
  Interactive    Zoom, pan, hover tooltips, click events
  Web-based      Renders as HTML/JS (works in Jupyter/browsers)
  Express API    One-line chart creation (plotly.express)
  Graph Objects  Full control (plotly.graph_objects)
  3D/Maps        3D scatter, surface plots, Mapbox maps
  Animation      Animated transitions between frames
  Dash           Build full web dashboards (separate lib)

PLOTLY vs MATPLOTLIB:
  ┌──────────────┬──────────┬──────────┐
  │ Feature      │ Plotly   │ Matplotlib│
  ├──────────────┼──────────┼──────────┤
  │ Interactivity│ Native   │ Limited  │
  │ Output       │ HTML/JS  │ Image    │
  │ 3D plots     │ Excellent│ Basic    │
  │ Maps         │ Mapbox   │ Basemap  │
  │ Customization│ High     │ Highest  │
  │ Jupyter      │ Inline   │ Inline   │
  │ Sharing      │ HTML file│ Image    │
  └──────────────┴──────────┴──────────┘

INSTALL:
  pip install plotly
  pip install plotly kaleido   # + static export
EOF
}

cmd_express() {
cat << 'EOF'
PLOTLY EXPRESS (Quick Charts)
===============================

import plotly.express as px

SCATTER:
  fig = px.scatter(df, x="gdp", y="life_exp",
                   color="continent", size="pop",
                   hover_name="country",
                   log_x=True, size_max=60,
                   title="GDP vs Life Expectancy")
  fig.show()

LINE:
  fig = px.line(df, x="date", y="price",
                color="symbol", title="Stock Prices")

BAR:
  fig = px.bar(df, x="nation", y="medals",
               color="type", barmode="group",
               text_auto=True)  # Values on bars

  # Horizontal
  fig = px.bar(df, x="medals", y="nation",
               orientation="h", color="type")

HISTOGRAM:
  fig = px.histogram(df, x="total_bill",
                     color="sex", marginal="box",
                     nbins=30, opacity=0.7)

BOX / VIOLIN:
  fig = px.box(df, x="day", y="total_bill",
               color="smoker", notched=True)

  fig = px.violin(df, x="day", y="total_bill",
                  color="sex", box=True, points="all")

PIE / SUNBURST / TREEMAP:
  fig = px.pie(df, values="pop", names="country",
               title="Population by Country")

  fig = px.sunburst(df, path=["continent", "country"],
                    values="pop", color="life_exp")

  fig = px.treemap(df, path=["continent", "country"],
                   values="pop")

HEATMAP:
  fig = px.imshow(corr_matrix, text_auto=".2f",
                  color_continuous_scale="RdBu_r",
                  aspect="auto")

MAP:
  fig = px.scatter_geo(df, lat="lat", lon="lon",
                       color="continent", size="pop",
                       hover_name="country",
                       projection="natural earth")

  fig = px.choropleth(df, locations="iso_alpha",
                      color="gdp", hover_name="country",
                      color_continuous_scale="Viridis")

  # Mapbox (detailed street maps)
  fig = px.scatter_mapbox(df, lat="lat", lon="lon",
                          color="type", size="magnitude",
                          mapbox_style="carto-positron",
                          zoom=3)

3D:
  fig = px.scatter_3d(df, x="x", y="y", z="z",
                      color="species", symbol="species")

ANIMATION:
  fig = px.scatter(df, x="gdp", y="life_exp",
                   animation_frame="year",
                   animation_group="country",
                   size="pop", color="continent",
                   hover_name="country",
                   range_x=[100, 100000],
                   range_y=[25, 90])
EOF
}

cmd_advanced() {
cat << 'EOF'
GRAPH OBJECTS & CUSTOMIZATION
================================

import plotly.graph_objects as go
from plotly.subplots import make_subplots

GRAPH OBJECTS (full control):
  fig = go.Figure()
  fig.add_trace(go.Scatter(
      x=df["date"], y=df["price"],
      mode="lines+markers",
      name="Price",
      line=dict(color="blue", width=2),
      marker=dict(size=6),
  ))
  fig.add_trace(go.Bar(
      x=df["date"], y=df["volume"],
      name="Volume", yaxis="y2",
      marker_color="rgba(255,0,0,0.3)",
  ))
  fig.update_layout(
      title="Stock Dashboard",
      yaxis=dict(title="Price ($)"),
      yaxis2=dict(title="Volume", overlaying="y", side="right"),
      template="plotly_dark",
      hovermode="x unified",
  )

SUBPLOTS:
  fig = make_subplots(
      rows=2, cols=2,
      subplot_titles=("Price", "Volume", "Returns", "Correlation"),
      specs=[[{"type": "xy"}, {"type": "xy"}],
             [{"type": "xy"}, {"type": "heatmap"}]],
  )
  fig.add_trace(go.Scatter(x=x, y=y1), row=1, col=1)
  fig.add_trace(go.Bar(x=x, y=y2), row=1, col=2)
  fig.update_layout(height=800, showlegend=False)

CANDLESTICK (financial):
  fig = go.Figure(data=go.Candlestick(
      x=df["date"],
      open=df["open"], high=df["high"],
      low=df["low"], close=df["close"],
  ))
  fig.update_layout(xaxis_rangeslider_visible=False)

TEMPLATES:
  "plotly"             Default
  "plotly_dark"        Dark theme
  "plotly_white"       Clean white
  "ggplot2"            R-style
  "seaborn"            Seaborn-style
  "simple_white"       Minimal

EXPORT:
  fig.write_html("chart.html")           # Interactive HTML
  fig.write_image("chart.png", scale=2)  # Static (needs kaleido)
  fig.write_image("chart.pdf")           # Vector PDF
  fig.write_image("chart.svg")           # Vector SVG
  fig.to_json()                          # JSON string

  # In Jupyter
  fig.show()
  fig.show(renderer="browser")  # Open in browser

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Plotly - Interactive Visualization Reference

Commands:
  intro     Overview, comparison
  express   Quick charts: scatter, bar, map, 3D, animation
  advanced  Graph Objects, subplots, candlestick, export

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)    cmd_intro ;;
  express)  cmd_express ;;
  advanced) cmd_advanced ;;
  help|*)   show_help ;;
esac
