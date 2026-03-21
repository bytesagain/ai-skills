#!/usr/bin/env bash
# lidar — LiDAR Technology Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== LiDAR — Light Detection and Ranging ===

LiDAR measures distance by illuminating a target with laser light and
measuring the reflection with a sensor. The result is a 3D point cloud
representing the scanned environment.

How It Works:
  1. Laser emits pulse (typically 905nm or 1550nm wavelength)
  2. Pulse reflects off target surface
  3. Sensor detects return pulse
  4. Distance = (speed of light × time of flight) / 2
  5. Combined with angle data → 3D coordinates (x, y, z)

Types of LiDAR:
  Airborne (ALS)      Mounted on aircraft/drone, scans ground below
    - Typical altitude: 500-3000m (aircraft), 50-120m (drone)
    - Point density: 1-100+ pts/m²
    - Used for: topography, forestry, flood mapping

  Terrestrial (TLS)   Tripod-mounted, scans surroundings
    - Range: 1-1000m depending on model
    - Point density: millions of pts/scan
    - Used for: building survey, heritage, forensics

  Mobile (MLS)        Vehicle-mounted, scans while moving
    - Combines LiDAR + IMU + GNSS
    - Used for: road survey, rail inspection, city mapping

  Solid-State         No moving parts, compact, lower cost
    - Used for: autonomous vehicles, robotics
    - Flash LiDAR: entire scene in one pulse

Key Specifications:
  Range            Maximum detection distance (m)
  Points/sec       Measurement rate (100K - 2M+)
  Accuracy         Absolute position error (mm)
  Precision        Repeatability of measurements
  FOV              Field of view (horizontal × vertical)
  Wavelength       905nm (eye-safe concerns) vs 1550nm (eye-safe)
  Returns          Single, dual, or multiple (vegetation penetration)
  Beam divergence  Spot size at distance (mrad)
EOF
}

cmd_formats() {
    cat << 'EOF'
=== Point Cloud File Formats ===

LAS (ASPRS LAS Format):
  Industry standard for airborne LiDAR
  Binary format, versions 1.0-1.4
  Stores: x, y, z, intensity, return number, classification
  Point Record Formats: 0-10 (LAS 1.4 adds waveform, NIR)
  Header contains CRS, bounding box, point count
  Tools: LAStools, PDAL, libLAS

LAZ (Compressed LAS):
  Lossless compression of LAS files
  Typically 7-20× smaller than LAS
  Transparent to most LAS-compatible software
  Created by Martin Isenburg (LAStools)

PCD (Point Cloud Data):
  PCL (Point Cloud Library) native format
  ASCII or binary
  Flexible fields: x y z rgb normal_x normal_y normal_z
  Good for: robotics, computer vision, ROS integration

E57 (ASTM E2807):
  Standard for 3D imaging data exchange
  Supports: point clouds, images, metadata
  Compressed, structured format
  Good for: terrestrial scanning, BIM workflows

PLY (Polygon File Format):
  Stanford format, simple and flexible
  ASCII or binary
  Stores: vertices, faces, colors, normals
  Good for: mesh + point cloud, 3D printing

XYZ / CSV:
  Plain text: x y z [intensity] [r g b]
  Universal compatibility, but large files
  No metadata (CRS, scanner info)
  Good for: quick exchange, debugging

Format Size Comparison (1M points):
  XYZ    ~30 MB (text)
  LAS    ~28 MB (binary)
  LAZ    ~3 MB  (compressed)
  PCD    ~16 MB (binary)
  E57    ~5 MB  (compressed)
EOF
}

cmd_processing() {
    cat << 'EOF'
=== Point Cloud Processing Pipeline ===

1. Import & Quality Check
   - Load raw scan data
   - Check point count, coverage, density
   - Review scanner logs for errors
   - Verify coordinate system

2. Noise Filtering
   Statistical Outlier Removal (SOR):
     For each point, compute mean distance to k neighbors
     Remove if distance > mean + n × stddev
     Typical: k=6, n=1.0
   
   Radius Outlier Removal:
     Remove points with fewer than n neighbors within radius r
     Good for sparse noise

3. Ground Classification
   Progressive Morphological Filter:
     Iteratively opens surface model with increasing window
     Points below surface = ground, above = non-ground
   
   Cloth Simulation Filter (CSF):
     Drape virtual cloth over inverted point cloud
     Cloth resting points = ground classification
   
   ASPRS Classification Codes:
     1  Unclassified       6  Building
     2  Ground             7  Low Point (noise)
     3  Low Vegetation     9  Water
     4  Medium Vegetation  10 Rail
     5  High Vegetation    11 Road Surface

4. Registration (Multi-scan Alignment)
   Coarse: manual targets, GPS coordinates
   Fine: ICP (Iterative Closest Point) algorithm
   Target-based: use spheres or checkerboards for mm accuracy
   Cloud-to-cloud: feature matching (FPFH, SHOT descriptors)

5. Meshing (Surface Reconstruction)
   Delaunay Triangulation: fast, good for terrain
   Poisson Reconstruction: smooth surfaces, watertight
   Ball Pivoting: good for scanned objects
   Alpha Shapes: handles concavities

6. Products
   DEM/DTM    Digital Elevation/Terrain Model (ground only)
   DSM        Digital Surface Model (includes vegetation, buildings)
   Contours   Elevation contour lines
   Cross-sections   Profile cuts through point cloud
   3D Mesh    Textured surface model
   BIM        Building Information Model integration
EOF
}

cmd_coordinate() {
    cat << 'EOF'
=== Coordinate Systems & Georeferencing ===

Geographic Coordinates:
  WGS84 (EPSG:4326)
    Latitude, longitude, ellipsoidal height
    Global reference, used by GPS
    Not suitable for direct distance measurement

Projected Coordinates:
  UTM (Universal Transverse Mercator)
    60 zones, each 6° wide
    Units: meters (Easting, Northing)
    Zone number + hemisphere: e.g., UTM 32N
    Good for: surveys < 6° longitude span

  State Plane (US)
    High accuracy for small areas
    Lambert Conformal Conic or Transverse Mercator
    Units: feet (US survey) or meters

Local Coordinates:
  Arbitrary origin (scanner position or project datum)
  Used for: indoor scanning, small sites
  Transform to global CRS via control points

Georeferencing LiDAR:
  Direct Georeferencing:
    GNSS + IMU + LiDAR integration
    Boresight calibration: align sensor axes to IMU
    Lever arm: measure offset from IMU to LiDAR origin
    Accuracy: 2-10cm horizontal, 3-15cm vertical (airborne)

  Control Points:
    Ground Control Points (GCPs) with known coordinates
    Survey-grade GNSS on targets visible in point cloud
    Minimum 3-4 GCPs, more for larger areas
    Used for: accuracy verification and strip adjustment

  Strip Adjustment (Airborne):
    Correct systematic errors between flight strips
    Overlap: minimum 30% between strips
    Cross-strips: perpendicular flights for calibration

Vertical Datums:
  Ellipsoidal height (HAE): height above WGS84 ellipsoid
  Orthometric height: height above geoid (≈ mean sea level)
  Geoid model: converts between the two (e.g., EGM2008, GEOID18)
  Difference can be 10-100+ meters depending on location
EOF
}

cmd_scanners() {
    cat << 'EOF'
=== LiDAR Scanner Types & Manufacturers ===

Automotive / Robotics:
  Velodyne (now Ouster)
    VLP-16 (Puck): 16 channels, 100m range, 300K pts/s
    Alpha Prime: 128 channels, 245m range, 2.4M pts/s
  
  Ouster
    OS1: 32/64/128 channels, 120m range, digital LiDAR
    OS2: long range (240m), highway autonomy
  
  Livox (DJI subsidiary)
    Mid-70: non-repetitive scan pattern, $599
    HAP: automotive-grade, integrated

  Hesai
    Pandar128: 128 channels, 200m range
    AT128: automotive-grade, ADAS

Terrestrial Scanning:
  FARO
    Focus S/M series: 70-350m range, survey-grade
    Freestyle 2: handheld, SLAM-based
  
  Leica (Hexagon)
    RTC360: 130m range, auto-registration, VIS (visual inertial)
    BLK360: compact, 60m range, entry-level
    P50: 1km range, highest accuracy
  
  Trimble
    X7: auto-calibrating, auto-leveling
    X12: 365m range, scan-to-BIM

  Riegl
    VZ-400i: 800m range, survey-grade
    VZ-2000i: 2.5km range, mining/forestry

Airborne:
  Riegl VQ-780i: airborne, multiple returns, 1.6M pts/s
  Leica ALS80: airborne, up to 1M pts/s
  Velodyne/Hesai: drone-mounted (lightweight)
  DJI Zenmuse L2: integrated drone LiDAR, 5 returns

Mobile Mapping:
  Leica Pegasus TRK: vehicle-mounted, dual scanner
  Trimble MX50: 360° mobile mapping
  NavVis VLX3: indoor mobile mapping, wearable
EOF
}

cmd_applications() {
    cat << 'EOF'
=== LiDAR Applications ===

Autonomous Vehicles:
  Real-time 3D perception of surroundings
  Detect and classify: vehicles, pedestrians, cyclists
  360° coverage at 10-20 Hz update rate
  Complements cameras and radar (sensor fusion)
  Key challenge: adverse weather (rain, fog, dust)

Topographic Surveying:
  Create high-resolution terrain models (DEM/DTM)
  Flood risk mapping and drainage analysis
  Volume calculations (earthwork, stockpiles)
  Corridor mapping (roads, railways, pipelines)
  Accuracy: 2-5cm vertical (with ground control)

Forestry:
  Canopy height models from first/last returns
  Individual tree detection and species classification
  Biomass estimation for carbon accounting
  Under-canopy terrain mapping (unique to LiDAR)
  Forest inventory: stem count, DBH, crown diameter

Architecture & BIM:
  As-built documentation of existing structures
  Scan-to-BIM workflows (point cloud → Revit model)
  Facade surveys and heritage preservation
  Clash detection (existing vs designed)
  Construction progress monitoring

Archaeology:
  Discover hidden structures under vegetation
  Angkor Wat, Maya cities found under jungle canopy
  Non-invasive site documentation
  Micro-topography reveals earthworks invisible on ground

Mining:
  Pit and stockpile volume measurement
  Tunnel profiling and convergence monitoring
  Slope stability analysis
  Drill and blast pattern optimization
  Underground mapping (SLAM-based mobile)

Power & Utilities:
  Transmission line clearance analysis
  Vegetation encroachment detection
  Tower and pole inspection
  Right-of-way mapping
EOF
}

cmd_tools() {
    cat << 'EOF'
=== LiDAR Software Tools ===

Open Source:
  CloudCompare
    GUI point cloud viewer and editor
    Registration, segmentation, distance computation
    Plugins: qCSF (ground filter), qCANUPO (classification)
    Platform: Windows, Mac, Linux
    URL: cloudcompare.org

  PDAL (Point Data Abstraction Library)
    CLI pipeline-based processing
    Filters: outlier, ground, crop, merge, thin
    Writers: LAS, LAZ, GeoTIFF, PostgreSQL
    Example: pdal translate in.las out.laz --filter.outlier
    URL: pdal.io

  PCL (Point Cloud Library)
    C++ library for 3D point cloud processing
    Modules: filters, features, registration, segmentation
    ROS integration for robotics
    URL: pointclouds.org

  LAStools (partially open source)
    las2las, lasinfo, lasground, lasclassify, lasheight
    lasmerge, lassort, lasthin, lasgrid, lascanopy
    Fast, command-line, industry standard
    URL: rapidlasso.de

  QGIS + LiDAR plugins
    View, profile, and analyze point clouds
    Whitebox Tools plugin for terrain analysis
    3D map view for visualization

Commercial:
  Leica Cyclone / CloudWorx    Registration, modeling
  FARO SCENE                   TLS processing
  Trimble RealWorks             Survey-grade processing
  Terrasolid (TerraScan)        Airborne LiDAR classification
  Global Mapper                 GIS + LiDAR analysis
  Pix4D                         Drone photogrammetry + LiDAR
  Autodesk ReCap                Scan-to-design workflow
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== LiDAR Survey Checklist ===

Planning:
  [ ] Define project area and accuracy requirements
  [ ] Choose LiDAR type (airborne/terrestrial/mobile)
  [ ] Plan scan positions or flight lines (30%+ overlap)
  [ ] Identify and mark ground control points
  [ ] Check weather forecast (avoid rain/fog for best results)
  [ ] Obtain permits if flying drone or accessing private land

Field Work:
  [ ] Calibrate scanner (warm-up time, boresight)
  [ ] Set up and survey GCPs with RTK GNSS
  [ ] Place registration targets (spheres/checkerboards)
  [ ] Record scanner position, height, orientation
  [ ] Check scan coverage — no gaps or shadow zones
  [ ] Backup raw data in field (duplicate SD card)

Processing:
  [ ] Import all scans and verify point counts
  [ ] Register/align scans (target-based or cloud-to-cloud)
  [ ] Check registration RMS error (< 5mm for TLS)
  [ ] Apply coordinate transformation to project CRS
  [ ] Filter noise and outliers
  [ ] Classify ground points
  [ ] Generate deliverables (DEM, contours, sections)

Quality Assurance:
  [ ] Compare LiDAR elevations to GCPs (RMSE check)
  [ ] Visual inspection for artifacts and gaps
  [ ] Verify point density meets specification
  [ ] Check classification accuracy (spot-check areas)
  [ ] Document metadata (CRS, datum, accuracy report)
  [ ] Archive raw and processed data with project report
EOF
}

show_help() {
    cat << EOF
lidar v$VERSION — LiDAR Technology Reference

Usage: script.sh <command>

Commands:
  intro        LiDAR fundamentals and key specifications
  formats      Point cloud file formats (LAS, LAZ, PCD, E57)
  processing   Point cloud processing pipeline
  coordinate   Coordinate systems and georeferencing
  scanners     Scanner types and manufacturers
  applications LiDAR use cases across industries
  tools        Software for point cloud processing
  checklist    Survey planning and QA checklist
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)        cmd_intro ;;
    formats)      cmd_formats ;;
    processing)   cmd_processing ;;
    coordinate)   cmd_coordinate ;;
    scanners)     cmd_scanners ;;
    applications) cmd_applications ;;
    tools)        cmd_tools ;;
    checklist)    cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "lidar v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
