---
name: "lidar"
version: "1.0.0"
description: "LiDAR technology reference — point cloud processing, scan types, coordinate systems, and applications. Use when working with LiDAR data, configuring scanners, or processing 3D point clouds."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [lidar, point-cloud, 3d-scanning, remote-sensing, industrial]
category: "industrial"
---

# LiDAR — Light Detection and Ranging Reference

Quick-reference skill for LiDAR technology, point cloud data processing, scanner configuration, and mapping applications.

## When to Use

- Processing point cloud data (LAS/LAZ/PCD formats)
- Configuring LiDAR scanners for survey or mapping
- Understanding scan patterns and coordinate systems
- Filtering, classifying, or visualizing point cloud data
- Choosing between airborne, terrestrial, and mobile LiDAR

## Commands

### `intro`

```bash
scripts/script.sh intro
```

LiDAR fundamentals — how it works, types of systems, key specifications.

### `formats`

```bash
scripts/script.sh formats
```

Point cloud file formats: LAS, LAZ, PCD, E57, PLY, XYZ.

### `processing`

```bash
scripts/script.sh processing
```

Point cloud processing pipeline — filtering, registration, classification, meshing.

### `coordinate`

```bash
scripts/script.sh coordinate
```

Coordinate systems and georeferencing — WGS84, UTM, local, IMU/GNSS integration.

### `scanners`

```bash
scripts/script.sh scanners
```

LiDAR scanner types and major manufacturers — Velodyne, SICK, Leica, FARO, Ouster.

### `applications`

```bash
scripts/script.sh applications
```

LiDAR applications: autonomous vehicles, surveying, forestry, archaeology, BIM.

### `tools`

```bash
scripts/script.sh tools
```

Software tools for point cloud processing — CloudCompare, PDAL, PCL, LAStools, QGIS.

### `checklist`

```bash
scripts/script.sh checklist
```

LiDAR survey planning and quality assurance checklist.

### `help`

```bash
scripts/script.sh help
```

### `version`

```bash
scripts/script.sh version
```

## Configuration

| Variable | Description |
|----------|-------------|
| `LIDAR_DIR` | Data directory (default: ~/.lidar/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
