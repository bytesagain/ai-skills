#!/bin/bash
# Bokeh - Interactive Visualization for the Web Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              BOKEH REFERENCE                                ║
║          Interactive Visualization for the Web              ║
╚══════════════════════════════════════════════════════════════╝

Bokeh is a Python library for creating interactive visualizations
for modern web browsers. It produces elegant, concise graphics
with high-performance interactivity over large datasets.

KEY FEATURES:
  Interactive      Pan, zoom, hover, select, link
  Web-native       Renders in browser (HTML + JS)
  Streaming        Real-time data updates
  Server           Python callbacks via Bokeh Server
  Large data       Handles millions of points efficiently
  Widgets          Sliders, buttons, dropdowns, tables
  Layouts          Grid, tabs, column, row arrangements

BOKEH vs PLOTLY vs ALTAIR:
  ┌──────────────┬──────────┬──────────┬──────────┐
  │ Feature      │ Bokeh    │ Plotly   │ Altair   │
  ├──────────────┼──────────┼──────────┼──────────┤
  │ Interactivity│ Custom   │ Built-in │ Vega     │
  │ Server apps  │ Built-in │ Dash     │ ✗        │
  │ Streaming    │ Native   │ Limited  │ ✗        │
  │ Large data   │ Excellent│ Good     │ ~5K rows │
  │ Learning     │ Medium   │ Easy     │ Easy     │
  │ Customization│ Maximum  │ High     │ Medium   │
  │ Dashboards   │ Built-in │ Dash app │ Panel    │
  │ Export       │ HTML/PNG │ HTML/PNG │ HTML/PNG │
  └──────────────┴──────────┴──────────┴──────────┘

INSTALL:
  pip install bokeh
  conda install bokeh
EOF
}

cmd_basics() {
cat << 'EOF'
BASIC PLOTTING
================

SETUP:
  from bokeh.plotting import figure, show, output_file, output_notebook
  from bokeh.io import curdoc

  # Output to HTML file
  output_file("chart.html")

  # Or output to Jupyter notebook
  output_notebook()

LINE CHART:
  p = figure(title="Line Chart", x_axis_label="X", y_axis_label="Y",
             width=800, height=400)
  p.line([1, 2, 3, 4, 5], [2, 5, 4, 6, 7], line_width=2, color="navy")
  show(p)

SCATTER PLOT:
  p = figure(title="Scatter", width=600, height=400)
  p.circle([1, 2, 3, 4], [4, 7, 1, 6], size=15, color="firebrick", alpha=0.5)
  show(p)

BAR CHART:
  from bokeh.transform import factor_cmap
  fruits = ["Apples", "Oranges", "Pears", "Bananas"]
  values = [40, 25, 50, 10]

  p = figure(x_range=fruits, height=400, title="Fruit Sales")
  p.vbar(x=fruits, top=values, width=0.8,
         color=factor_cmap("x", palette=["#e84d60","#c9d9d3","#718dbf","#ddb7b1"],
                           factors=fruits))
  show(p)

MULTI-LINE:
  from bokeh.models import Legend
  p = figure(width=800, height=400)
  l1 = p.line([1,2,3,4], [1,4,9,16], color="blue", line_width=2)
  l2 = p.line([1,2,3,4], [2,5,10,17], color="red", line_width=2)
  legend = Legend(items=[("Square", [l1]), ("Square+1", [l2])])
  p.add_layout(legend)
  show(p)

AREA CHART:
  from bokeh.models import ColumnDataSource
  import numpy as np
  x = np.linspace(0, 4*np.pi, 100)
  p = figure(width=800, height=300)
  p.varea(x=x, y1=np.sin(x), y2=0, fill_alpha=0.3, fill_color="navy")
  p.line(x, np.sin(x), color="navy", line_width=2)
  show(p)

HOVER TOOLTIPS:
  from bokeh.models import HoverTool
  p = figure(width=600, height=400)
  p.circle([1,2,3,4], [4,7,1,6], size=20, color="navy")
  p.add_tools(HoverTool(tooltips=[
      ("Index", "$index"),
      ("(x,y)", "($x, $y)"),
      ("Value", "@y{0.00}"),
  ]))
  show(p)
EOF
}

cmd_data() {
cat << 'EOF'
DATA SOURCES & TRANSFORMS
============================

COLUMNDATASOURCE:
  The core data container — enables linked selections and streaming.

  from bokeh.models import ColumnDataSource
  import pandas as pd

  # From dict
  source = ColumnDataSource(data={
      "x": [1, 2, 3, 4, 5],
      "y": [2, 5, 4, 6, 7],
      "label": ["A", "B", "C", "D", "E"],
      "size": [10, 20, 15, 25, 12],
  })

  p = figure()
  p.circle("x", "y", size="size", source=source)

  # From DataFrame
  df = pd.DataFrame({"x": range(10), "y": range(10)})
  source = ColumnDataSource(df)

  # Update data (for streaming/interactivity)
  source.data = {"x": new_x, "y": new_y}

  # Stream new data
  source.stream({"x": [6], "y": [8]}, rollover=100)

  # Patch (update specific values)
  source.patch({"y": [(2, 99)]})  # Set index 2 to 99

COLOR MAPPING:
  from bokeh.transform import linear_cmap, log_cmap, factor_cmap
  from bokeh.palettes import Viridis256, Category10

  # Continuous color mapping
  mapper = linear_cmap("y", palette=Viridis256, low=0, high=10)
  p.circle("x", "y", color=mapper, source=source)

  # Categorical color mapping
  mapper = factor_cmap("category", palette=Category10[3],
                       factors=["A", "B", "C"])

PALETTES:
  from bokeh.palettes import (
      Viridis256, Plasma256, Inferno256, Magma256,  # Sequential
      RdBu, Spectral, RdYlGn,                       # Diverging
      Category10, Category20, Set1, Set3,            # Categorical
      Turbo256, Cividis256,                          # Perceptual
  )

DATETIME AXES:
  import pandas as pd
  dates = pd.date_range("2026-01-01", periods=100, freq="D")

  p = figure(x_axis_type="datetime", width=800, height=300)
  p.line(dates, values)
  p.xaxis.axis_label = "Date"
EOF
}

cmd_server() {
cat << 'EOF'
BOKEH SERVER (Interactive Apps)
=================================

Bokeh Server enables Python callbacks for interactive dashboards.

BASIC SERVER APP:
  # myapp.py
  from bokeh.plotting import figure, curdoc
  from bokeh.models import Slider, Column
  from bokeh.layouts import column
  import numpy as np

  # Create plot
  x = np.linspace(0, 10, 500)
  source = ColumnDataSource(data={"x": x, "y": np.sin(x)})

  p = figure(height=400, width=800)
  p.line("x", "y", source=source)

  # Create widget
  freq = Slider(start=0.1, end=10, value=1, step=0.1, title="Frequency")

  # Python callback
  def update(attr, old, new):
      source.data = {"x": x, "y": np.sin(freq.value * x)}

  freq.on_change("value", update)

  # Layout
  curdoc().add_root(column(freq, p))
  curdoc().title = "Sine Wave"

  # Run: bokeh serve myapp.py
  # Open: http://localhost:5006/myapp

DIRECTORY APP:
  myapp/
  ├── main.py           # Entry point
  ├── static/           # CSS, JS, images
  │   └── style.css
  ├── templates/         # Jinja2 templates
  │   └── index.html
  └── theme.yaml        # Styling theme

DEPLOYMENT:
  # Development
  bokeh serve myapp.py --show

  # Production (behind nginx)
  bokeh serve myapp.py --port 5006 --address 0.0.0.0 \
    --allow-websocket-origin=example.com

  # Multiple apps
  bokeh serve app1.py app2/ --port 5006

  # With SSL
  bokeh serve myapp.py --ssl-certfile cert.pem --ssl-keyfile key.pem

  # Nginx reverse proxy:
  location /myapp/ {
      proxy_pass http://localhost:5006;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection "upgrade";
      proxy_http_version 1.1;
  }

WIDGETS:
  from bokeh.models import (
      Slider, RangeSlider,
      TextInput, TextAreaInput,
      Select, MultiSelect,
      Button, Toggle,
      CheckboxGroup, RadioGroup,
      DatePicker, DateRangeSlider,
      Spinner, ColorPicker,
      DataTable, TableColumn,
  )

  # Button callback
  button = Button(label="Click Me", button_type="success")
  def click_handler():
      print("Clicked!")
  button.on_click(click_handler)

STREAMING (Real-time):
  from bokeh.driving import count
  import random

  source = ColumnDataSource(data={"x": [], "y": []})
  p = figure(width=800, height=300)
  p.line("x", "y", source=source)

  @count()
  def update(step):
      source.stream({"x": [step], "y": [random.random()]}, rollover=200)

  curdoc().add_periodic_callback(update, 100)  # Every 100ms
  curdoc().add_root(p)

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Bokeh - Interactive Visualization Reference

Commands:
  intro     Overview, comparison, features
  basics    Line, scatter, bar, hover tooltips
  data      ColumnDataSource, colors, palettes, datetime
  server    Bokeh Server apps, widgets, streaming, deployment

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)  cmd_intro ;;
  basics) cmd_basics ;;
  data)   cmd_data ;;
  server) cmd_server ;;
  help|*) show_help ;;
esac
