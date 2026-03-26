#!/bin/bash
# Matplotlib - Python Plotting Library Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              MATPLOTLIB REFERENCE                           ║
║          The Foundation of Python Visualization             ║
╚══════════════════════════════════════════════════════════════╝

Matplotlib is the most widely used Python plotting library.
It's the foundation that Seaborn, Pandas plotting, and many
other libraries are built on.

ANATOMY OF A FIGURE:
  Figure          The top-level container (the "canvas")
  ├── Axes        A single plot area (most work happens here)
  │   ├── XAxis   Horizontal axis with ticks and labels
  │   ├── YAxis   Vertical axis with ticks and labels
  │   ├── Title   Plot title
  │   └── Legend  Legend
  ├── Axes        Second subplot
  └── Suptitle    Overall figure title

TWO INTERFACES:
  pyplot (plt)    Quick scripts, MATLAB-like
  OO (fig, ax)    Production code, full control (recommended)

INSTALL:
  pip install matplotlib
  conda install matplotlib
EOF
}

cmd_plots() {
cat << 'EOF'
COMMON PLOTS
===============

import matplotlib.pyplot as plt
import numpy as np

LINE PLOT:
  x = np.linspace(0, 10, 100)
  fig, ax = plt.subplots()
  ax.plot(x, np.sin(x), label="sin", color="blue", linewidth=2)
  ax.plot(x, np.cos(x), label="cos", color="red", linestyle="--")
  ax.set_xlabel("X")
  ax.set_ylabel("Y")
  ax.set_title("Trigonometric Functions")
  ax.legend()
  plt.savefig("trig.png", dpi=150, bbox_inches="tight")

SCATTER:
  fig, ax = plt.subplots()
  ax.scatter(x, y, c=colors, s=sizes, alpha=0.6, cmap="viridis")
  plt.colorbar(ax.collections[0], label="Value")

BAR CHART:
  categories = ["A", "B", "C", "D"]
  values = [23, 45, 56, 78]
  fig, ax = plt.subplots()
  bars = ax.bar(categories, values, color=["#2196F3", "#4CAF50", "#FF9800", "#F44336"])
  ax.bar_label(bars)  # Add value labels on bars

  # Horizontal
  ax.barh(categories, values)

  # Grouped
  x = np.arange(len(categories))
  ax.bar(x - 0.2, values1, 0.4, label="2025")
  ax.bar(x + 0.2, values2, 0.4, label="2026")
  ax.set_xticks(x, categories)

HISTOGRAM:
  fig, ax = plt.subplots()
  ax.hist(data, bins=30, edgecolor="black", alpha=0.7)
  ax.axvline(np.mean(data), color="red", linestyle="--", label=f"Mean: {np.mean(data):.1f}")

PIE:
  fig, ax = plt.subplots()
  ax.pie(sizes, labels=labels, autopct="%1.1f%%", startangle=90,
         colors=["#66b3ff", "#99ff99", "#ffcc99", "#ff9999"])

HEATMAP:
  fig, ax = plt.subplots(figsize=(10, 8))
  im = ax.imshow(data, cmap="YlOrRd", aspect="auto")
  plt.colorbar(im)
  ax.set_xticks(range(len(cols)), cols, rotation=45)
  ax.set_yticks(range(len(rows)), rows)

BOX PLOT:
  fig, ax = plt.subplots()
  ax.boxplot([data1, data2, data3], labels=["A", "B", "C"])

VIOLIN:
  ax.violinplot([data1, data2], positions=[1, 2], showmeans=True)

ERROR BARS:
  ax.errorbar(x, y, yerr=errors, fmt="o-", capsize=5)

FILL BETWEEN:
  ax.fill_between(x, y - std, y + std, alpha=0.3)
  ax.plot(x, y)
EOF
}

cmd_layout() {
cat << 'EOF'
LAYOUT & STYLING
==================

SUBPLOTS:
  # 2x2 grid
  fig, axes = plt.subplots(2, 2, figsize=(12, 8))
  axes[0, 0].plot(x, y1)
  axes[0, 0].set_title("Plot 1")
  axes[0, 1].scatter(x, y2)
  axes[1, 0].bar(categories, values)
  axes[1, 1].hist(data)
  fig.suptitle("Dashboard")
  fig.tight_layout()

  # Unequal sizes
  fig = plt.figure(figsize=(12, 6))
  ax1 = fig.add_subplot(121)     # Left half
  ax2 = fig.add_subplot(222)     # Top-right quarter
  ax3 = fig.add_subplot(224)     # Bottom-right quarter

  # GridSpec for complex layouts
  from matplotlib.gridspec import GridSpec
  fig = plt.figure(figsize=(12, 8))
  gs = GridSpec(3, 3)
  ax_main = fig.add_subplot(gs[0:2, 0:2])   # Large top-left
  ax_right = fig.add_subplot(gs[0:2, 2])     # Right column
  ax_bottom = fig.add_subplot(gs[2, :])      # Full bottom row

STYLING:
  # Built-in styles
  plt.style.use("seaborn-v0_8-darkgrid")
  plt.style.use("ggplot")
  plt.style.use("dark_background")
  plt.style.use("fivethirtyeight")

  # Custom rcParams
  plt.rcParams.update({
      "font.size": 12,
      "font.family": "sans-serif",
      "axes.grid": True,
      "grid.alpha": 0.3,
      "figure.figsize": (10, 6),
      "figure.dpi": 100,
  })

AXES FORMATTING:
  ax.set_xlim(0, 100)
  ax.set_ylim(-1, 1)
  ax.set_xticks([0, 25, 50, 75, 100])
  ax.set_xticklabels(["0%", "25%", "50%", "75%", "100%"])
  ax.tick_params(axis="x", rotation=45)

  # Log scale
  ax.set_yscale("log")
  ax.set_xscale("log")

  # Date axis
  import matplotlib.dates as mdates
  ax.xaxis.set_major_formatter(mdates.DateFormatter("%Y-%m"))
  ax.xaxis.set_major_locator(mdates.MonthLocator())

  # Currency/number formatting
  from matplotlib.ticker import FuncFormatter
  ax.yaxis.set_major_formatter(FuncFormatter(lambda x, p: f"${x:,.0f}"))

ANNOTATIONS:
  ax.annotate("Peak", xy=(x_peak, y_peak), xytext=(x_peak+1, y_peak+0.5),
              arrowprops=dict(arrowstyle="->", color="red"),
              fontsize=12, color="red")
  ax.text(0.95, 0.95, "n=1000", transform=ax.transAxes,
          ha="right", va="top", fontsize=10)

SAVE:
  plt.savefig("plot.png", dpi=300, bbox_inches="tight", transparent=True)
  plt.savefig("plot.pdf")      # Vector
  plt.savefig("plot.svg")      # Vector

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Matplotlib - Python Plotting Library Reference

Commands:
  intro    Overview, figure anatomy, interfaces
  plots    Line, scatter, bar, histogram, heatmap, box
  layout   Subplots, GridSpec, styling, annotations, save

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)  cmd_intro ;;
  plots)  cmd_plots ;;
  layout) cmd_layout ;;
  help|*) show_help ;;
esac
