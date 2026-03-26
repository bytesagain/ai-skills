#!/bin/bash
# Seaborn - Statistical Data Visualization Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              SEABORN REFERENCE                              ║
║          Statistical Data Visualization                     ║
╚══════════════════════════════════════════════════════════════╝

Seaborn is a Python statistical visualization library built on
Matplotlib. It provides a high-level interface for drawing
attractive and informative statistical graphics.

WHY SEABORN:
  High-level     One line of code for complex plots
  Statistical    Built-in aggregation and uncertainty
  Beautiful      Publication-quality default themes
  Pandas-native  Works directly with DataFrames
  Categorical    Excellent categorical data support
  Multi-plot     FacetGrid for subplots by variable

SEABORN vs MATPLOTLIB:
  ┌──────────────┬──────────────┬──────────────┐
  │ Feature      │ Seaborn      │ Matplotlib   │
  ├──────────────┼──────────────┼──────────────┤
  │ Level        │ High         │ Low          │
  │ Defaults     │ Beautiful    │ Basic        │
  │ Statistics   │ Built-in     │ Manual       │
  │ DataFrames   │ Native       │ Manual       │
  │ Customization│ Moderate     │ Full         │
  │ Plot types   │ Statistical  │ Everything   │
  │ Learning     │ Easy         │ Steeper      │
  └──────────────┴──────────────┴──────────────┘

INSTALL:
  pip install seaborn
  import seaborn as sns
  import matplotlib.pyplot as plt
EOF
}

cmd_plots() {
cat << 'EOF'
PLOT TYPES
============

import seaborn as sns
import matplotlib.pyplot as plt

RELATIONAL:
  # Scatter with hue/size/style encoding
  sns.scatterplot(data=df, x="total_bill", y="tip",
                  hue="smoker", size="size", style="time")

  # Line plot with confidence interval
  sns.lineplot(data=df, x="timepoint", y="signal",
               hue="event", style="event", ci=95)

  # relplot: FacetGrid version (subplots by variable)
  sns.relplot(data=df, x="total_bill", y="tip",
              hue="smoker", col="time", row="sex",
              kind="scatter")

DISTRIBUTION:
  # Histogram + KDE
  sns.histplot(data=df, x="total_bill", kde=True, bins=30)

  # KDE only
  sns.kdeplot(data=df, x="total_bill", hue="time", fill=True)

  # ECDF (empirical cumulative distribution)
  sns.ecdfplot(data=df, x="total_bill", hue="time")

  # Rug plot (marginal ticks)
  sns.rugplot(data=df, x="total_bill")

  # displot: FacetGrid version
  sns.displot(data=df, x="total_bill", col="time",
              kde=True, kind="hist")

CATEGORICAL:
  # Bar plot (with confidence intervals!)
  sns.barplot(data=df, x="day", y="total_bill", hue="sex",
              ci=95, estimator=np.mean)

  # Count plot (histogram for categorical)
  sns.countplot(data=df, x="day", hue="smoker")

  # Box plot
  sns.boxplot(data=df, x="day", y="total_bill", hue="smoker")

  # Violin plot (distribution shape)
  sns.violinplot(data=df, x="day", y="total_bill",
                 hue="smoker", split=True, inner="quart")

  # Strip plot (individual points)
  sns.stripplot(data=df, x="day", y="total_bill",
                jitter=True, alpha=0.5)

  # Swarm plot (non-overlapping points)
  sns.swarmplot(data=df, x="day", y="total_bill", hue="sex")

  # Point plot (mean + CI as dots)
  sns.pointplot(data=df, x="day", y="total_bill",
                hue="smoker", dodge=True)

  # catplot: FacetGrid version
  sns.catplot(data=df, x="day", y="total_bill",
              hue="smoker", col="time", kind="violin")

MATRIX:
  # Heatmap (correlation matrix)
  corr = df.select_dtypes("number").corr()
  sns.heatmap(corr, annot=True, fmt=".2f", cmap="coolwarm",
              center=0, square=True)

  # Clustermap (hierarchical clustering)
  sns.clustermap(corr, method="ward", cmap="vlag",
                 annot=True, fmt=".2f")

REGRESSION:
  # Scatter + linear regression + CI
  sns.regplot(data=df, x="total_bill", y="tip", ci=95)

  # lmplot: FacetGrid version
  sns.lmplot(data=df, x="total_bill", y="tip",
             hue="smoker", col="time")

  # Polynomial regression
  sns.regplot(data=df, x="total_bill", y="tip", order=2)

  # Logistic regression
  sns.regplot(data=df, x="total_bill", y="big_tip", logistic=True)

MULTI-VARIABLE:
  # Pair plot (all pairwise relationships)
  sns.pairplot(df, hue="species", diag_kind="kde",
               corner=True, plot_kws={"alpha": 0.6})

  # Joint plot (bivariate + marginals)
  sns.jointplot(data=df, x="total_bill", y="tip",
                hue="smoker", kind="kde")
  # kind: "scatter", "kde", "hist", "hex", "reg"
EOF
}

cmd_styling() {
cat << 'EOF'
THEMES & CUSTOMIZATION
========================

BUILT-IN THEMES:
  sns.set_theme()                      # Default (darkgrid)
  sns.set_theme(style="whitegrid")     # White background + grid
  sns.set_theme(style="dark")          # Dark background
  sns.set_theme(style="white")         # Clean white
  sns.set_theme(style="ticks")         # Ticks only

  # Context (scaling for different outputs)
  sns.set_theme(context="notebook")    # Default
  sns.set_theme(context="talk")        # Larger for presentations
  sns.set_theme(context="poster")      # Largest
  sns.set_theme(context="paper")       # Smallest for publications

COLOR PALETTES:
  # Qualitative (categorical data)
  sns.color_palette("Set2")
  sns.color_palette("husl", 8)
  sns.color_palette("tab10")

  # Sequential (ordered data)
  sns.color_palette("Blues")
  sns.color_palette("viridis")
  sns.color_palette("rocket")

  # Diverging (centered data)
  sns.color_palette("coolwarm")
  sns.color_palette("vlag")
  sns.color_palette("icefire")

  # Set globally
  sns.set_palette("Set2")

  # Custom
  my_pal = {"Yes": "#ff6b6b", "No": "#4ecdc4"}
  sns.barplot(data=df, x="day", y="tip", hue="smoker", palette=my_pal)

FACETGRID (custom multi-plots):
  g = sns.FacetGrid(df, col="time", row="smoker",
                    height=4, aspect=1.2)
  g.map_dataframe(sns.scatterplot, x="total_bill", y="tip")
  g.add_legend()
  g.set_axis_labels("Bill ($)", "Tip ($)")
  g.set_titles("{col_name} | {row_name}")

FIGURE-LEVEL vs AXES-LEVEL:
  # Axes-level: returns matplotlib Axes
  fig, ax = plt.subplots(figsize=(10, 6))
  sns.histplot(data=df, x="total_bill", ax=ax)
  ax.set_title("My Title")

  # Figure-level: returns FacetGrid (own figure)
  g = sns.displot(data=df, x="total_bill", col="time")
  g.fig.suptitle("My Title", y=1.02)

SAVE:
  plt.savefig("plot.png", dpi=300, bbox_inches="tight")
  plt.savefig("plot.svg")  # Vector for publications

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Seaborn - Statistical Data Visualization Reference

Commands:
  intro    Overview, comparison with matplotlib
  plots    All plot types: relational, distribution, categorical
  styling  Themes, palettes, FacetGrid, save

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)   cmd_intro ;;
  plots)   cmd_plots ;;
  styling) cmd_styling ;;
  help|*)  show_help ;;
esac
