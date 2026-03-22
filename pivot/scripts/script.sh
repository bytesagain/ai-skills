#!/usr/bin/env bash
# pivot — Data Pivot Operations Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Data Pivot Operations ===

A pivot operation transforms data by rotating rows into columns
(or columns into rows), typically summarizing values in the process.

Long Format (Normalized):
  date        product   sales
  2024-01-01  Widget    100
  2024-01-01  Gadget    150
  2024-01-02  Widget    120
  2024-01-02  Gadget    130

Wide Format (Pivoted):
  date        Widget  Gadget
  2024-01-01  100     150
  2024-01-02  120     130

Terminology:
  Pivot:     long → wide (rows become columns)
  Unpivot:   wide → long (columns become rows)
  Melt:      pandas term for unpivot
  Stack:     multi-level column → multi-level index
  Unstack:   multi-level index → multi-level column
  Crosstab:  frequency/contingency table (special pivot)

When to Pivot:
  - Creating summary reports (sales by region × month)
  - Preparing data for visualization (heatmaps, matrices)
  - Comparing categories side-by-side
  - Spreadsheet-style analysis
  - Feature engineering for ML (entity-attribute-value → flat)

When to Unpivot:
  - Normalizing denormalized data
  - Preparing for statistical analysis (tidy data)
  - Loading into databases (normalized schema)
  - Creating charts that need long format (many plot libraries)
  - Converting questionnaire responses to analyzable format

Tidy Data Principles (Hadley Wickham):
  1. Each variable forms a column
  2. Each observation forms a row
  3. Each type of observational unit forms a table
  
  Tidy data is typically long format
  Most analysis tools prefer tidy/long format
  Pivot tables are for reporting, not storage

Key Decisions:
  Index: which column(s) become row labels
  Columns: which column's values become new column headers
  Values: which column provides the cell values
  Aggregation: how to combine when multiple values map to same cell
EOF
}

cmd_pandas() {
    cat << 'EOF'
=== Pandas Pivot Operations ===

df.pivot() — Simple reshape (no aggregation):
  # Long → Wide
  wide = df.pivot(index='date', columns='product', values='sales')
  
  Requirements:
    - index + columns must be unique (no duplicates)
    - If duplicates exist → ValueError (use pivot_table instead)
  
  Result has columns from unique values in 'product'

df.pivot_table() — With aggregation:
  # Handles duplicates by aggregating
  pt = df.pivot_table(
      index='date',
      columns='product',
      values='sales',
      aggfunc='sum'       # default is 'mean'
  )
  
  aggfunc options:
    'sum', 'mean', 'count', 'min', 'max', 'std', 'median'
    np.sum, np.mean, len
    ['sum', 'mean']       → multi-level columns
    {'sales': 'sum', 'qty': 'mean'}  → different agg per value
  
  Additional parameters:
    margins=True           → add row/column totals (All)
    fill_value=0           → replace NaN with value
    dropna=True            → exclude NaN columns

df.melt() — Wide → Long (unpivot):
  # Wide → Long
  long = df.melt(
      id_vars=['date'],           # columns to keep
      value_vars=['Widget', 'Gadget'],  # columns to unpivot
      var_name='product',         # name for variable column
      value_name='sales'          # name for value column
  )
  
  If value_vars omitted: all non-id_vars columns are melted

pd.crosstab() — Frequency table:
  ct = pd.crosstab(
      index=df['department'],
      columns=df['status'],
      margins=True,
      normalize='index'    # row percentages
  )
  # normalize: 'index', 'columns', 'all', False

df.stack() / df.unstack():
  stack():   column level → index level (wide → long-ish)
  unstack(): index level → column level (long → wide)
  
  # MultiIndex example
  df.set_index(['date', 'product'])['sales'].unstack()
  # Equivalent to pivot with date as index, product as columns
  
  # Specify level:
  df.unstack(level=0)    # unstack first index level
  df.unstack(level='product')  # unstack by name

Common Gotchas:
  - pivot() fails on duplicates → use pivot_table()
  - NaN in pivoted data → use fill_value
  - MultiIndex columns after pivot → df.columns = df.columns.droplevel()
  - Reset index after pivot → df.reset_index()
  - Column names become index name → df.columns.name = None
EOF
}

cmd_sql() {
    cat << 'EOF'
=== SQL PIVOT/UNPIVOT ===

SQL Server PIVOT:
  SELECT date_col, [Widget], [Gadget]
  FROM (
      SELECT date_col, product, sales
      FROM sales_data
  ) AS src
  PIVOT (
      SUM(sales)
      FOR product IN ([Widget], [Gadget])
  ) AS pvt;
  
  Notes:
    - Column values must be known in advance (hardcoded)
    - Dynamic PIVOT requires dynamic SQL
    - Aggregation function required

SQL Server UNPIVOT:
  SELECT date_col, product, sales
  FROM (
      SELECT date_col, Widget, Gadget
      FROM wide_table
  ) AS src
  UNPIVOT (
      sales FOR product IN (Widget, Gadget)
  ) AS unpvt;

PostgreSQL — crosstab() (tablefunc extension):
  CREATE EXTENSION IF NOT EXISTS tablefunc;
  
  SELECT * FROM crosstab(
    'SELECT date_col, product, sales
     FROM sales_data
     ORDER BY 1, 2',
    'SELECT DISTINCT product FROM sales_data ORDER BY 1'
  ) AS ct(
    date_col DATE,
    "Widget" INT,
    "Gadget" INT
  );
  
  Alternative — CASE/FILTER approach (no extension):
  SELECT
    date_col,
    SUM(sales) FILTER (WHERE product = 'Widget') AS widget_sales,
    SUM(sales) FILTER (WHERE product = 'Gadget') AS gadget_sales
  FROM sales_data
  GROUP BY date_col;

MySQL (no native PIVOT):
  SELECT
    date_col,
    SUM(CASE WHEN product = 'Widget' THEN sales ELSE 0 END) AS Widget,
    SUM(CASE WHEN product = 'Gadget' THEN sales ELSE 0 END) AS Gadget
  FROM sales_data
  GROUP BY date_col;
  
  Dynamic pivot in MySQL requires prepared statements:
  SET @sql = NULL;
  SELECT GROUP_CONCAT(DISTINCT
    CONCAT('SUM(CASE WHEN product = ''', product,
           ''' THEN sales ELSE 0 END) AS `', product, '`'))
  INTO @sql FROM sales_data;
  SET @sql = CONCAT('SELECT date_col, ', @sql, ' FROM sales_data GROUP BY date_col');
  PREPARE stmt FROM @sql;
  EXECUTE stmt;

UNPIVOT without UNPIVOT keyword:
  -- Works in any SQL database
  SELECT date_col, 'Widget' AS product, Widget AS sales FROM wide_table
  UNION ALL
  SELECT date_col, 'Gadget' AS product, Gadget AS sales FROM wide_table;
  
  -- Or using LATERAL / CROSS APPLY:
  SELECT w.date_col, u.product, u.sales
  FROM wide_table w
  CROSS JOIN LATERAL (
    VALUES ('Widget', w.widget), ('Gadget', w.gadget)
  ) AS u(product, sales);
EOF
}

cmd_spreadsheet() {
    cat << 'EOF'
=== Spreadsheet Pivot Tables ===

Excel Pivot Table:
  Create:
    1. Select data range (including headers)
    2. Insert → PivotTable
    3. Choose destination (new/existing worksheet)
    4. Drag fields to areas:
       Rows:    category fields (dates, regions, products)
       Columns: secondary category (for cross-tabulation)
       Values:  numeric fields (sum, count, average)
       Filters: overall filters (year, department)

  Field settings:
    Right-click value → "Value Field Settings"
    Change: Sum, Count, Average, Min, Max, Product, StdDev
    Show as: % of column/row total, difference from, running total

  Grouping:
    Date fields: group by month, quarter, year
    Numeric fields: group into ranges (0-10, 10-20, ...)
    Right-click field → Group

  Calculated fields:
    Analyze tab → Fields, Items & Sets → Calculated Field
    Example: Profit = Revenue - Cost
    Limited: can only use sum of other fields

  Slicers (visual filters):
    Insert → Slicer → select field(s)
    Click buttons to filter pivot table interactively
    Timeline slicer: specialized for date filtering

  Refresh:
    Pivot tables don't auto-update when source changes
    Right-click → Refresh (or Analyze → Refresh All)
    Or: set to refresh on file open

Google Sheets Pivot Table:
  Insert → Pivot table
  Similar to Excel but with formula alternative:
  
  =QUERY() function (powerful alternative):
    =QUERY(data, "SELECT A, SUM(C) GROUP BY A PIVOT B")
    Produces pivot table using SQL-like syntax
    Auto-updates when data changes
    
  Example:
    Data in A1:C100 (date, product, sales)
    =QUERY(A1:C100, "SELECT A, SUM(C) GROUP BY A PIVOT B", 1)

Tips:
  - Always ensure source data has headers
  - No blank rows or columns in source data
  - Use Tables/Named Ranges as source (auto-expand)
  - Date columns should be actual dates, not text
  - Clear existing pivot before restructuring (avoids confusion)
  - Multiple value fields: shown as rows or columns (Layout)

Power Pivot (Excel):
  Data model supports multiple tables with relationships
  DAX formulas for complex calculations
  Handles millions of rows (regular pivot: ~1M limit)
  CALCULATE, SUMX, RELATED, DATEADD functions
EOF
}

cmd_crosstab() {
    cat << 'EOF'
=== Cross-Tabulation (Crosstab) ===

What Is a Crosstab?
  A table showing frequency distribution of two (or more) variables
  Also called: contingency table, two-way table

Simple Frequency Crosstab:
  Input:
    gender   preference
    M        Tea
    F        Coffee
    M        Coffee
    F        Tea
    F        Coffee
    M        Tea

  Crosstab:
              Coffee  Tea   Total
    Female      2      1      3
    Male        1      2      3
    Total       3      3      6

  Shows: how two categorical variables relate to each other

Normalized Crosstab:
  Row-normalized (% within each row):
              Coffee  Tea    Total
    Female    66.7%   33.3%  100%
    Male      33.3%   66.7%  100%

  Column-normalized (% within each column):
              Coffee  Tea
    Female    66.7%   33.3%
    Male      33.3%   66.7%
    Total     100%    100%

  Overall-normalized (% of grand total):
              Coffee  Tea
    Female    33.3%   16.7%
    Male      16.7%   33.3%

Chi-Square Test of Independence:
  Tests whether two categorical variables are independent
  
  H₀: variables are independent (no relationship)
  H₁: variables are associated (dependent)
  
  χ² = Σ (observed - expected)² / expected
  Expected = (row_total × col_total) / grand_total
  
  Degrees of freedom = (rows - 1) × (cols - 1)
  p-value < 0.05 → reject H₀ → variables are associated
  
  Python:
    from scipy.stats import chi2_contingency
    chi2, p, dof, expected = chi2_contingency(crosstab_matrix)

Cramér's V (Effect Size):
  Measures strength of association (0 to 1)
  V = sqrt(χ² / (n × min(r-1, c-1)))
  0.1 = weak, 0.3 = moderate, 0.5 = strong

Multi-Way Crosstabs:
  Three or more variables
  Example: gender × preference × age_group
  Creates layered/stacked tables
  Pandas: pd.crosstab([df.gender, df.age], df.preference)

Applications:
  Market research: demographics × purchase behavior
  Medical: treatment × outcome (clinical trials)
  Education: teaching method × pass/fail rate
  Quality: machine × defect type
  Social science: survey response analysis
EOF
}

cmd_reshape() {
    cat << 'EOF'
=== Data Reshaping Patterns ===

Long to Wide (Pivot):
  When: each entity-attribute pair is a row
  
  Entity-Attribute-Value (EAV) table:
    user_id  attribute   value
    1        name        Alice
    1        email       alice@x.com
    1        age         30
    2        name        Bob
    2        email       bob@x.com
  
  Pivoted (wide):
    user_id  name   email         age
    1        Alice  alice@x.com   30
    2        Bob    bob@x.com     NULL

  Use case: config tables, dynamic schemas, form data

Wide to Long (Unpivot/Melt):
  When: related measurements are in separate columns
  
  Wide (survey responses):
    student  math_score  science_score  english_score
    Alice    85          90             78
    Bob      92          88             95
  
  Long (melted):
    student  subject   score
    Alice    math      85
    Alice    science   90
    Alice    english   78
    Bob      math      92
    Bob      science   88
    Bob      english   95

  Use case: analysis, visualization, normalization

Time Series Reshaping:
  Wide format (one column per metric):
    date        temperature  humidity  pressure
    2024-01-01  22.5         65       1013
    2024-01-02  23.1         60       1011
  
  Long format (for time series databases):
    date        metric       value
    2024-01-01  temperature  22.5
    2024-01-01  humidity     65
    2024-01-01  pressure     1013

  InfluxDB, Prometheus prefer long format (one metric per row)
  Spreadsheets/dashboards prefer wide format

Multi-Level Reshape:
  Multiple value columns pivoted simultaneously
  
  Input:
    date   product  sales  quantity
    Jan    A        100    10
    Jan    B        150    15
    Feb    A        120    12
  
  Pivot (values=['sales', 'quantity']):
    date   A_sales  A_qty  B_sales  B_qty
    Jan    100      10     150      15
    Feb    120      12     NaN      NaN

Normalization Levels:
  1NF: atomic values (no arrays or nested structures)
  2NF: no partial dependencies (fully dependent on primary key)
  3NF: no transitive dependencies
  
  Wide format often violates 1NF (repeating groups in columns)
  Long format is typically 1NF-3NF compliant
  Pivot = denormalize for analysis
  Unpivot = normalize for storage
EOF
}

cmd_aggregation() {
    cat << 'EOF'
=== Aggregation Functions in Pivots ===

Standard Aggregations:
  Function    Description              When to Use
  ──────────────────────────────────────────────────────────
  sum         Total of values          Revenue, quantities, counts
  mean/avg    Average value            Scores, ratings, metrics
  count       Number of records        Frequencies, occurrences
  min         Minimum value            Earliest date, lowest price
  max         Maximum value            Latest date, highest score
  median      Middle value             Robust central tendency
  std         Standard deviation       Variability, quality control
  var         Variance                 Statistical analysis
  first/last  First/last occurrence    Sampling, time series
  nunique     Count of unique values   Cardinality, distinct items

Multiple Aggregations:
  Pandas:
    df.pivot_table(
        index='region',
        columns='product',
        values='sales',
        aggfunc=['sum', 'mean', 'count']
    )
    # Creates multi-level columns: (sum, Widget), (mean, Widget), ...

  SQL:
    SELECT region,
           SUM(CASE WHEN product='A' THEN sales END) AS A_total,
           AVG(CASE WHEN product='A' THEN sales END) AS A_avg,
           COUNT(CASE WHEN product='A' THEN 1 END) AS A_count
    FROM data GROUP BY region;

Different Aggregation per Column:
  Pandas:
    df.pivot_table(
        index='region',
        aggfunc={'sales': 'sum', 'rating': 'mean', 'orders': 'count'}
    )

Custom Aggregation Functions:
  Pandas:
    def percentile_95(x):
        return x.quantile(0.95)
    
    df.pivot_table(
        index='date',
        values='response_time',
        aggfunc=percentile_95
    )

  Named aggregation (modern pandas):
    df.groupby('region').agg(
        total_sales=('sales', 'sum'),
        avg_rating=('rating', 'mean'),
        top_sale=('sales', 'max'),
        p95_time=('response_time', lambda x: x.quantile(0.95))
    )

Weighted Aggregations:
  Weighted average: Σ(value × weight) / Σ(weight)
  
  Pandas:
    def weighted_avg(group):
        return np.average(group['price'], weights=group['quantity'])
    df.groupby('product').apply(weighted_avg)

Running Aggregations in Pivots:
  Running sum: cumulative total across rows/columns
  Year-over-year: compare to same period previous year
  Moving average: smoothed trend within pivot
  
  Excel: Show Value As → Running Total In
  Pandas: pivot_result.cumsum(axis=0)

Handling Missing Values:
  fill_value=0: replace NaN with zero (sum, count)
  fill_value=None: keep NaN (mean, std — zeros would distort)
  dropna=True: exclude NaN from aggregation
  Interpolation: fill gaps with estimated values
EOF
}

cmd_visualization() {
    cat << 'EOF'
=== Visualizing Pivoted Data ===

Heatmaps:
  Perfect for 2D pivoted data (rows × columns → color)
  
  Pandas + Seaborn:
    import seaborn as sns
    pivot = df.pivot_table(index='month', columns='product', values='sales')
    sns.heatmap(pivot, annot=True, fmt='.0f', cmap='YlOrRd')
  
  Color scales:
    Sequential: YlOrRd, Blues, Viridis (magnitude)
    Diverging: RdBu, coolwarm (deviation from center)
    Categorical: Set1, Paired (distinct groups)
  
  Best for: correlation matrices, time × category, geographic grids

Stacked Bar Charts:
  Pivoted data → stacked bars showing composition
  
  pivot.plot(kind='bar', stacked=True)
  
  Shows: total magnitude + composition per category
  Limit to 5-7 categories (more → too many colors)
  Alternative: 100% stacked bar (proportion, not absolute)

Grouped Bar Charts:
  Side-by-side bars for comparison
  
  pivot.plot(kind='bar', stacked=False)
  
  Better than stacked for comparing individual categories
  Gets crowded with many groups × categories

Line Charts from Pivots:
  Time-series pivoted data → multi-line chart
  
  pivot.plot(kind='line')
  
  Each column becomes a line
  Best for: trends over time by category

Small Multiples (Faceted Charts):
  Separate chart per category (from pivoted data)
  
  Matplotlib:
    fig, axes = plt.subplots(2, 3, figsize=(15, 10))
    for i, col in enumerate(pivot.columns):
        ax = axes.flat[i]
        pivot[col].plot(ax=ax, title=col)
  
  Better than one busy chart when many categories

Treemaps:
  Hierarchical pivoted data → nested rectangles
  Area = magnitude, color = metric
  Good for: budget allocation, market share, disk usage

Pivot → Dashboard Pattern:
  1. Prepare pivot tables (one per metric)
  2. Create filters/slicers for dimensions
  3. Wire filters to all pivots
  4. Choose chart type per metric:
     KPI cards:     single aggregated numbers (total, avg)
     Trend lines:   time-series metrics
     Heatmaps:      two-dimensional comparisons
     Bar charts:    categorical comparisons
     Pie/donut:     composition (limit to ≤5 slices)

  Tools: Excel dashboards, Tableau, Power BI, Grafana
  Code: Plotly Dash, Streamlit (Python), Observable (JS)

Anti-Patterns:
  - 3D charts (distorted, hard to read)
  - Pie charts with too many slices
  - Missing labels or legends
  - Inconsistent color mapping across charts
  - Sorting alphabetically instead of by value
EOF
}

show_help() {
    cat << EOF
pivot v$VERSION — Data Pivot Operations Reference

Usage: script.sh <command>

Commands:
  intro         Pivot overview — long vs wide, terminology
  pandas        Pandas: pivot, pivot_table, melt, stack/unstack
  sql           SQL PIVOT/UNPIVOT across database engines
  spreadsheet   Excel/Google Sheets pivot table construction
  crosstab      Cross-tabulation, contingency tables, chi-square
  reshape       Data reshaping patterns and normalization
  aggregation   Aggregation functions: sum, mean, custom, weighted
  visualization Heatmaps, stacked charts, dashboards from pivots
  help          Show this help
  version       Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)         cmd_intro ;;
    pandas)        cmd_pandas ;;
    sql)           cmd_sql ;;
    spreadsheet)   cmd_spreadsheet ;;
    crosstab)      cmd_crosstab ;;
    reshape)       cmd_reshape ;;
    aggregation)   cmd_aggregation ;;
    visualization) cmd_visualization ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "pivot v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
