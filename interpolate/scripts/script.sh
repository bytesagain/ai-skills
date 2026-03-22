#!/usr/bin/env bash
# interpolate — Data Interpolation Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Data Interpolation ===

Interpolation estimates unknown values that fall BETWEEN known data points.
Unlike extrapolation (beyond known data), interpolation works within the
range of existing observations.

Key Concepts:
  Interpolation:  Estimate between known points (safer)
  Extrapolation:  Estimate beyond known points (riskier)
  Approximation:  Fit a function near (not through) points
  Regression:     Fit trend to noisy data (not through all points)
  Interpolation:  Pass EXACTLY through every known point

When to Interpolate:
  - Fill gaps in sensor data (missing readings)
  - Resample time series to uniform intervals
  - Upscale images or signals
  - Estimate terrain elevation between survey points
  - Create smooth curves through discrete measurements

Classification:
  By dimension:
    1D: function of one variable (time series, signals)
    2D: function of two variables (surfaces, images)
    3D: function of three variables (volumetric data)
    nD: multivariate (climate models, CFD)

  By method:
    Global: single function fits all points (polynomial)
    Local: different functions for each segment (spline)
    Exact: passes through every data point
    Approximate: minimizes error but may not pass through points

  By continuity:
    C⁰: continuous function (values match)
    C¹: continuous first derivative (smooth)
    C²: continuous second derivative (very smooth, cubic spline)

Trade-offs:
  Simplicity   ←→  Accuracy
  Speed        ←→  Smoothness
  Local control ←→  Global smoothness
  Flexibility  ←→  Stability (Runge's phenomenon)
EOF
}

cmd_linear() {
    cat << 'EOF'
=== Linear Interpolation ===

The simplest and most commonly used method. Connects adjacent points
with straight lines.

Formula:
  Given points (x₀, y₀) and (x₁, y₁), find y at x:

  y = y₀ + (x - x₀) × (y₁ - y₀) / (x₁ - x₀)

  Or equivalently:
  y = y₀ × (1 - t) + y₁ × t    where t = (x - x₀)/(x₁ - x₀)

  t is the interpolation parameter: 0 ≤ t ≤ 1
  t = 0 → y = y₀ (at left point)
  t = 1 → y = y₁ (at right point)
  t = 0.5 → y = midpoint

Example:
  Points: (2, 10) and (6, 30)
  Find y at x = 4:
  t = (4 - 2) / (6 - 2) = 0.5
  y = 10 × (1 - 0.5) + 30 × 0.5 = 20

Properties:
  ✓ Simple, fast, and predictable
  ✓ Monotone-preserving (no overshoot)
  ✓ Good for nearly linear data
  ✗ C⁰ only (corners at data points, not smooth)
  ✗ Poor for curved or oscillating data

Piecewise Linear:
  For multiple points, connect each adjacent pair:
  x₀-x₁: use linear interp
  x₁-x₂: use linear interp
  ...and so on

  Creates a polyline (connect-the-dots)

Lerp (in graphics/animation):
  lerp(a, b, t) = a + t × (b - a)

  Used everywhere:
    Color blending: lerp(red, blue, 0.5) = purple
    Position animation: lerp(start, end, progress)
    Alpha blending: lerp(bg, fg, alpha)

  Smooth variants:
    Smoothstep: t = 3t² - 2t³ (ease in/out)
    Cosine: t = (1 - cos(t × π)) / 2

Common Implementations:
  Python: numpy.interp(x, xp, fp)
  MATLAB: interp1(x, y, xi, 'linear')
  Excel:  FORECAST.LINEAR()
  JS:     function lerp(a, b, t) { return a + t * (b - a); }
EOF
}

cmd_polynomial() {
    cat << 'EOF'
=== Polynomial Interpolation ===

Fit a polynomial of degree n-1 through n data points.
Unique polynomial exists for any n points (Weierstrass theorem).

--- Lagrange Interpolation ---
  P(x) = Σᵢ yᵢ × Lᵢ(x)

  where Lᵢ(x) = Π(j≠i) (x - xⱼ) / (xᵢ - xⱼ)

  Example (3 points → degree 2 polynomial):
    Points: (1, 1), (2, 4), (3, 9)

    L₀(x) = (x-2)(x-3) / (1-2)(1-3) = (x-2)(x-3) / 2
    L₁(x) = (x-1)(x-3) / (2-1)(2-3) = -(x-1)(x-3)
    L₂(x) = (x-1)(x-2) / (3-1)(3-2) = (x-1)(x-2) / 2

    P(x) = 1×L₀ + 4×L₁ + 9×L₂ = x² (reconstructs f(x) = x²)

--- Newton's Divided Differences ---
  P(x) = f[x₀] + f[x₀,x₁](x-x₀) + f[x₀,x₁,x₂](x-x₀)(x-x₁) + ...

  Divided differences:
    f[xᵢ] = yᵢ
    f[xᵢ,xⱼ] = (f[xⱼ] - f[xᵢ]) / (xⱼ - xᵢ)
    f[xᵢ,xⱼ,xₖ] = (f[xⱼ,xₖ] - f[xᵢ,xⱼ]) / (xₖ - xᵢ)

  Advantage: easy to add new points (incremental)

--- Runge's Phenomenon ---
  HIGH-DEGREE POLYNOMIALS OSCILLATE WILDLY AT EDGES!

  f(x) = 1/(1 + 25x²) on [-1, 1]
  With equally-spaced points:
    5 points → OK approximation
    11 points → oscillation at edges
    21 points → SEVERE oscillation (error grows!)

  Solutions:
    1. Use Chebyshev nodes instead of equidistant:
       xₖ = cos(π(2k+1)/(2n+2)), k = 0,1,...,n
       Cluster points near boundaries

    2. Use piecewise methods (splines) instead

    3. Keep polynomial degree low (≤ 5)

--- Practical Advice ---
  ✓ Use for small number of points (3-5)
  ✓ Chebyshev nodes prevent oscillation
  ✓ Good for theoretical analysis
  ✗ Avoid high-degree (> 7) with equidistant points
  ✗ Adding a point changes the ENTIRE polynomial
  ✗ No local control

  Python: numpy.polyfit(), scipy.interpolate.lagrange()
  MATLAB: polyfit(), polyval()
EOF
}

cmd_spline() {
    cat << 'EOF'
=== Spline Interpolation ===

Piecewise polynomial interpolation — different polynomial for each interval,
joined smoothly at the data points (knots).

--- Cubic Spline (Most Popular) ---
  Piecewise cubic polynomials: Sᵢ(x) = aᵢ + bᵢ(x-xᵢ) + cᵢ(x-xᵢ)² + dᵢ(x-xᵢ)³

  Conditions (for n+1 points, n intervals):
    Interpolation:   Sᵢ(xᵢ) = yᵢ for all i          (n+1 equations)
    Continuity:      Sᵢ(xᵢ₊₁) = Sᵢ₊₁(xᵢ₊₁)        (n-1 equations)
    Smooth 1st deriv: S'ᵢ(xᵢ₊₁) = S'ᵢ₊₁(xᵢ₊₁)     (n-1 equations)
    Smooth 2nd deriv: S''ᵢ(xᵢ₊₁) = S''ᵢ₊₁(xᵢ₊₁)   (n-1 equations)
    Need 2 more → boundary conditions

  Boundary Conditions:
    Natural:      S''(x₀) = S''(xₙ) = 0 (second derivative = 0)
    Clamped:      S'(x₀) = f'₀, S'(xₙ) = f'ₙ (specify slopes)
    Not-a-knot:   S'''continuous at x₁ and xₙ₋₁
    Periodic:     S(x₀) = S(xₙ), S'(x₀) = S'(xₙ), S''(x₀) = S''(xₙ)

  Properties:
    C² continuous (smooth second derivative)
    Minimizes total curvature (∫S''² dx)
    No Runge's phenomenon
    Local control (changing one point affects nearby segments only)

--- B-Splines ---
  Defined by basis functions, not point-to-point
  Control points (not necessarily interpolation points)
  B-spline of order k: Cᵏ⁻² continuity
  NURBS (Non-Uniform Rational B-Splines): used in CAD

--- Hermite Spline ---
  Specifies both VALUE and DERIVATIVE at each point
  C¹ continuous (smooth first derivative)
  Used in animation (tangent handles)
  Catmull-Rom: automatic tangents from neighboring points

--- Akima Spline ---
  Less oscillation than cubic spline
  Uses local slopes (not global system)
  Good for data with abrupt changes
  Not as smooth as natural cubic (only C¹)

--- Implementations ---
  Python:
    scipy.interpolate.CubicSpline(x, y)
    scipy.interpolate.UnivariateSpline(x, y)
    scipy.interpolate.BSpline

  MATLAB:
    spline(x, y, xi)
    csaps(x, y)  % smoothing spline

  R:
    splinefun(x, y, method="natural")

  JavaScript:
    d3.curveNatural, d3.curveCatmullRom
EOF
}

cmd_spatial() {
    cat << 'EOF'
=== Spatial Interpolation ===

Estimate values at unmeasured locations from scattered spatial observations.
Used in: weather mapping, terrain modeling, pollution analysis, GIS.

--- Inverse Distance Weighting (IDW) ---
  z(x) = Σ wᵢ × zᵢ / Σ wᵢ    where wᵢ = 1/dᵢᵖ

  p = power parameter (typically 2)
  Higher p → more weight to nearest points
  Lower p → more smoothing (more influence from distant points)

  Properties:
    ✓ Simple, fast, intuitive
    ✓ Exact interpolator (passes through known points)
    ✗ Bull's eye effect (circular patterns around points)
    ✗ No uncertainty estimation
    ✗ Cannot extrapolate trends

--- Kriging (Geostatistics) ---
  Optimal interpolation based on spatial correlation structure.
  Best Linear Unbiased Estimator (BLUE).

  Steps:
    1. Compute experimental variogram
       γ(h) = (1/2N) Σ [z(xᵢ) - z(xᵢ+h)]²
       Measures spatial auto-correlation as function of distance h

    2. Fit theoretical variogram model:
       Spherical, Exponential, Gaussian, Matérn

       Parameters:
         Nugget (c₀):  Variance at distance 0 (noise/micro-scale)
         Sill (c₀+c):  Total variance (variance at large distance)
         Range (a):     Distance where correlation becomes negligible

    3. Solve kriging system for weights

  Types:
    Ordinary Kriging:    Assumes constant unknown mean
    Simple Kriging:      Known constant mean
    Universal Kriging:   Models trend + residual
    Indicator Kriging:   Binary threshold values

  Properties:
    ✓ Optimal (minimum variance estimator)
    ✓ Provides uncertainty estimates (kriging variance!)
    ✓ Accounts for spatial correlation structure
    ✗ Computationally intensive (O(n³) matrix inversion)
    ✗ Requires variogram modeling (subjective choice)

--- Natural Neighbor ---
  Based on Voronoi tessellation
  Weight = stolen area when new point inserted
  Smooth, local, no parameters to tune
  C¹ continuous everywhere except at data points

--- Triangulation (TIN) ---
  Delaunay triangulation → linear interpolation within triangles
  Exact at data points, piecewise linear between
  Good for terrain modeling
  Fast, no smoothing assumptions

--- Comparison ---
  Method        Smooth  Uncertainty  Speed    Parameters
  IDW           Medium  No          Fast     Power p
  Kriging       High    Yes         Slow     Variogram model
  Nat. Neighbor High    No          Medium   None
  TIN           Low     No          Fast     None
  Spline        High    No          Medium   Smoothing factor
EOF
}

cmd_timeseries() {
    cat << 'EOF'
=== Time Series Interpolation ===

Filling gaps and aligning time series data.

--- Common Scenarios ---
  1. Missing sensor readings (dropped packets, downtime)
  2. Irregular timestamps → regular intervals (resampling)
  3. Aligning multiple time series to common timestamps
  4. Upsampling (1 Hz → 10 Hz) or downsampling (1 min → 5 min)

--- Pandas Methods ---
  # Forward fill (last observation carried forward)
  df['value'].fillna(method='ffill')

  # Backward fill
  df['value'].fillna(method='bfill')

  # Linear interpolation
  df['value'].interpolate(method='linear')

  # Time-weighted linear interpolation
  df['value'].interpolate(method='time')

  # Spline interpolation
  df['value'].interpolate(method='spline', order=3)

  # Polynomial interpolation
  df['value'].interpolate(method='polynomial', order=2)

  # Resampling to regular intervals
  df.resample('1h').mean()          # Downsampling (aggregate)
  df.resample('1min').interpolate() # Upsampling (interpolate)

--- Method Selection for Time Series ---

  Forward Fill (ffill):
    Best for: step-function data (settings, categories)
    Example: thermostat setting, device state (on/off)
    Assumes: value stays the same until changed

  Linear:
    Best for: smoothly varying quantities
    Example: temperature, pressure, stock prices
    Assumes: change is gradual and uniform

  Spline:
    Best for: smooth, periodic data
    Example: seasonal patterns, physiological signals
    Assumes: underlying function is smooth

  Seasonal Decomposition:
    Best for: data with strong seasonality
    Decompose → fill gap in trend/seasonal/residual separately
    More accurate for long gaps in periodic data

--- Gap Size Limits ---
  Small gaps (< 5% of data): most methods work fine
  Medium gaps (5-20%): prefer linear or ffill
  Large gaps (> 20%): consider if interpolation is appropriate
  Rule: limit=N parameter in pandas prevents filling large gaps

  df['value'].interpolate(method='linear', limit=5)
  # Only fills gaps up to 5 consecutive missing values

--- Alignment ---
  # Align two time series to common index
  df1, df2 = df1.align(df2, join='outer')
  df1 = df1.interpolate(method='time')
  df2 = df2.interpolate(method='time')

  # Or use merge_asof for nearest-time matching
  pd.merge_asof(df1, df2, on='timestamp', tolerance=pd.Timedelta('1min'))
EOF
}

cmd_multidim() {
    cat << 'EOF'
=== Multi-Dimensional Interpolation ===

--- Bilinear Interpolation (2D) ---
  For regular grid: find value at (x, y) from four surrounding points

  Q₁₁ ────── Q₂₁        Known corner values:
   |    (x,y)  |         Q₁₁ = f(x₁, y₁)
   |     *     |         Q₂₁ = f(x₂, y₁)
  Q₁₂ ────── Q₂₂        Q₁₂ = f(x₁, y₂)
                          Q₂₂ = f(x₂, y₂)

  Step 1: Interpolate in x-direction:
    R₁ = lerp(Q₁₁, Q₂₁, tx)   where tx = (x-x₁)/(x₂-x₁)
    R₂ = lerp(Q₁₂, Q₂₂, tx)

  Step 2: Interpolate in y-direction:
    P = lerp(R₁, R₂, ty)       where ty = (y-y₁)/(y₂-y₁)

  Used for: image scaling, texture mapping, digital elevation models
  C⁰ continuous (may have visible grid artifacts)

--- Bicubic Interpolation (2D) ---
  Uses 4×4 = 16 surrounding points
  Fits cubic polynomial in both directions
  C¹ continuous (smoother than bilinear)
  Standard for: image resizing, photo editing

  Higher quality than bilinear but 4× more computation
  Implementations: Photoshop "Bicubic", OpenCV INTER_CUBIC

--- Trilinear Interpolation (3D) ---
  Extension of bilinear to 3 dimensions
  Uses 8 corner points of a cube (voxel)
  Three stages of linear interpolation

  Used for: volumetric data, 3D textures, medical imaging (CT/MRI)

--- Scattered Data (Irregular Points) ---
  Not on a regular grid → need special methods

  scipy.interpolate.griddata(points, values, grid, method='cubic')
    method='nearest'   Nearest neighbor (fast, blocky)
    method='linear'    Delaunay triangulation + linear
    method='cubic'     Delaunay + Clough-Tocher (smooth)

  RBF (Radial Basis Functions):
    scipy.interpolate.Rbf(x, y, z)
    Kernels: multiquadric, gaussian, linear, cubic
    Good for scattered data, works in any dimension
    Can be slow for large datasets

--- Tensor Product (n-D regular grid) ---
  scipy.interpolate.RegularGridInterpolator
    Supports: linear, nearest, slinear, cubic, quintic
    For 3D+ regular grid data
    Efficient: O(2ⁿ) per evaluation (n = dimensions)

--- Image Interpolation Comparison ---
  Nearest neighbor:  Fastest, pixelated (good for pixel art)
  Bilinear:         Smooth, slight blur
  Bicubic:          Sharpest, slight ringing artifacts
  Lanczos:          Best quality, slowest, windowed sinc
EOF
}

cmd_choosing() {
    cat << 'EOF'
=== Choosing the Right Interpolation Method ===

--- Decision Tree ---

  Is data on a regular grid?
  ├── Yes → How many dimensions?
  │   ├── 1D → Linear, Cubic Spline, or Akima
  │   ├── 2D → Bilinear or Bicubic
  │   └── 3D+ → Trilinear or RegularGridInterpolator
  └── No (scattered) → What domain?
      ├── Spatial/GIS → Kriging or IDW
      ├── General → RBF or griddata(cubic)
      └── Few points → Delaunay + linear

  Is data smooth or noisy?
  ├── Smooth → Cubic spline or polynomial
  └── Noisy → Smoothing spline, LOWESS, or filter first

  Are sharp transitions present?
  ├── Yes → Linear or Akima (avoid cubic overshoot)
  └── No → Cubic spline (smoother)

  Do you need uncertainty estimates?
  ├── Yes → Kriging (provides variance)
  └── No → Any method

--- Method Properties Summary ---

  Method          Smooth  Speed   Accuracy  Complexity
  Nearest         ✗       ★★★★★  ★         ★
  Linear          △       ★★★★   ★★        ★
  Polynomial      ★★★     ★★★    ★★★       ★★
  Cubic Spline    ★★★★    ★★★    ★★★★      ★★
  Akima           ★★★     ★★★    ★★★       ★★
  Kriging         ★★★★    ★       ★★★★★    ★★★★
  IDW             ★★      ★★★★   ★★★       ★
  RBF             ★★★★    ★★     ★★★★      ★★★
  B-Spline        ★★★★★   ★★★    ★★★★      ★★★

--- Common Mistakes ---
  1. Using polynomial for too many points (Runge's!)
  2. Interpolating noisy data (amplifies noise)
     → Use smoothing/regression instead
  3. Extrapolating with interpolation methods
     → Unpredictable outside data range
  4. Ignoring gaps too large to interpolate
     → Set limits on gap filling
  5. Using cubic when data has jumps
     → Cubic overshoot near discontinuities
  6. Using IDW when data has directional trends
     → Kriging captures anisotropy better

--- Library Quick Reference ---
  Python: scipy.interpolate (CubicSpline, griddata, Rbf, interp1d)
  R: approxfun(), splinefun(), gstat (kriging)
  MATLAB: interp1(), interp2(), griddata(), scatteredInterpolant()
  Julia: Interpolations.jl
  C++: Boost.Math, ALGLIB, Eigen
EOF
}

show_help() {
    cat << EOF
interpolate v$VERSION — Data Interpolation Reference

Usage: script.sh <command>

Commands:
  intro        Interpolation overview and key concepts
  linear       Linear interpolation and lerp
  polynomial   Lagrange, Newton, and Runge's phenomenon
  spline       Cubic splines, B-splines, and Hermite splines
  spatial      IDW, kriging, and natural neighbor methods
  timeseries   Time series gap filling and resampling
  multidim     Bilinear, bicubic, and trilinear interpolation
  choosing     Method selection decision guide
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    linear)     cmd_linear ;;
    polynomial) cmd_polynomial ;;
    spline)     cmd_spline ;;
    spatial)    cmd_spatial ;;
    timeseries) cmd_timeseries ;;
    multidim)   cmd_multidim ;;
    choosing)   cmd_choosing ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "interpolate v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
