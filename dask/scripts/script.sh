#!/bin/bash
# Dask - Parallel Computing in Python Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              DASK REFERENCE                                 ║
║          Parallel Computing with Python                     ║
╚══════════════════════════════════════════════════════════════╝

Dask is a parallel computing library that scales Python workflows.
It provides familiar APIs (NumPy, Pandas, scikit-learn) that work
on datasets larger than memory.

KEY COMPONENTS:
  Dask DataFrame    Parallel Pandas (larger-than-RAM)
  Dask Array        Parallel NumPy (chunked N-d arrays)
  Dask Bag          Parallel lists (unstructured data)
  Dask Delayed      Custom task graphs (any Python function)
  Dask ML           Parallel scikit-learn

WHEN TO USE DASK:
  ✓ Dataset doesn't fit in RAM
  ✓ Computation is embarrassingly parallel
  ✓ You already know Pandas/NumPy
  ✓ Need to scale from laptop to cluster
  ✗ Dataset fits comfortably in RAM (just use Pandas)
  ✗ Need real-time streaming (use Flink/Spark Streaming)
  ✗ Need GPU acceleration (use cuDF/RAPIDS)

DASK vs SPARK vs POLARS:
  ┌──────────────┬──────────┬──────────┬──────────┐
  │ Feature      │ Dask     │ Spark    │ Polars   │
  ├──────────────┼──────────┼──────────┼──────────┤
  │ Language     │ Python   │ Scala/Py │ Rust/Py  │
  │ API          │ Pandas   │ Spark DF │ Own API  │
  │ Scale        │ Medium   │ Large    │ Single   │
  │ Single node  │ Great    │ Overhead │ Fastest  │
  │ Learning     │ Easy     │ Medium   │ Easy     │
  │ ML           │ sklearn  │ MLlib    │ Limited  │
  │ Ecosystem    │ Python   │ JVM      │ Rust     │
  └──────────────┴──────────┴──────────┴──────────┘

INSTALL:
  pip install "dask[complete]"
  conda install dask
EOF
}

cmd_dataframe() {
cat << 'EOF'
DASK DATAFRAME
================

Parallel Pandas — same API, works on larger-than-RAM data.

READ DATA:
  import dask.dataframe as dd

  # CSV (can read many files!)
  df = dd.read_csv("data/*.csv")
  df = dd.read_csv("s3://bucket/data/*.csv")

  # Parquet (recommended for large data)
  df = dd.read_parquet("data/")
  df = dd.read_parquet("s3://bucket/data/", engine="pyarrow")

  # From Pandas
  import pandas as pd
  pdf = pd.DataFrame({"x": range(1000000), "y": range(1000000)})
  df = dd.from_pandas(pdf, npartitions=10)

PANDAS-LIKE API:
  # Filter
  result = df[df["amount"] > 100]

  # Group by
  result = df.groupby("category")["amount"].mean()

  # Multiple aggregations
  result = df.groupby("region").agg({"amount": ["sum", "mean", "count"]})

  # Sort (expensive! requires shuffle)
  result = df.sort_values("amount", ascending=False)

  # Join
  result = df1.merge(df2, on="id", how="left")

  # Apply custom function
  result = df["text"].apply(lambda x: x.upper(), meta=("text", "str"))

IMPORTANT: LAZY EVALUATION!
  # Nothing executes until you call .compute()
  result = df.groupby("city")["sales"].sum()  # Builds task graph
  actual_result = result.compute()             # Executes!

  # Other triggers:
  len(df)                  # Triggers compute
  df.head()                # Only computes first partition
  df.to_csv("output/")    # Writes and computes
  df.to_parquet("output/") # Writes and computes

PARTITIONS:
  df.npartitions           # Number of partitions
  df.repartition(20)       # Change partition count
  df.get_partition(0)      # Get specific partition

  # Each partition is a regular Pandas DataFrame
  df.map_partitions(lambda pdf: pdf.assign(new_col=pdf["a"] * 2))

WRITE:
  df.to_csv("output/", single_file=False)  # One file per partition
  df.to_parquet("output/", engine="pyarrow")
  df.compute().to_csv("single_file.csv")   # Collect to memory first
EOF
}

cmd_array() {
cat << 'EOF'
DASK ARRAY & DELAYED
=======================

DASK ARRAY (Parallel NumPy):
  import dask.array as da
  import numpy as np

  # Create from NumPy
  x = da.from_array(np.random.random((10000, 10000)), chunks=(1000, 1000))

  # Operations (same as NumPy)
  result = x.mean(axis=0)
  result = x.T @ x
  result = da.linalg.svd(x)

  # Compute
  actual = result.compute()

  # Random arrays
  x = da.random.random((10000, 10000), chunks=(1000, 1000))
  x = da.zeros((10000, 10000), chunks=(1000, 1000))
  x = da.ones_like(x)

  # File I/O
  da.to_zarr(x, "output.zarr")
  x = da.from_zarr("output.zarr")
  da.to_hdf5("output.h5", "/data", x)

  # Rechunk
  x = x.rechunk((500, 2000))  # Change chunk sizes

DASK DELAYED (Custom Parallelism):
  from dask import delayed, compute

  @delayed
  def load(filename):
      return pd.read_csv(filename)

  @delayed
  def process(df):
      return df[df["value"] > 0].groupby("key").sum()

  @delayed
  def combine(results):
      return pd.concat(results)

  # Build task graph
  files = ["data1.csv", "data2.csv", "data3.csv"]
  loaded = [load(f) for f in files]
  processed = [process(df) for df in loaded]
  result = combine(processed)

  # Execute
  final = result.compute()

  # Visualize task graph
  result.visualize(filename="graph.png")

DASK BAG (Parallel Lists):
  import dask.bag as db

  # From files
  b = db.read_text("logs/*.log")

  # Process
  result = (b
    .map(json.loads)
    .filter(lambda x: x["status"] == 200)
    .map(lambda x: x["url"])
    .frequencies()
    .topk(10, key=lambda x: x[1])
    .compute())

  # From Python objects
  b = db.from_sequence(range(1000), npartitions=10)
  result = b.map(expensive_function).compute()
EOF
}

cmd_distributed() {
cat << 'EOF'
DISTRIBUTED COMPUTING
========================

LOCAL CLUSTER:
  from dask.distributed import Client, LocalCluster

  # Automatic (uses all cores)
  client = Client()

  # Custom
  cluster = LocalCluster(n_workers=4, threads_per_worker=2, memory_limit="4GB")
  client = Client(cluster)

  print(client.dashboard_link)  # http://localhost:8787

REMOTE CLUSTER:
  # Connect to existing scheduler
  client = Client("tcp://scheduler-ip:8786")

  # SSH cluster
  from dask.distributed import SSHCluster
  cluster = SSHCluster(
      ["localhost", "worker1", "worker2"],
      connect_options={"username": "admin"},
      worker_options={"nthreads": 4}
  )
  client = Client(cluster)

KUBERNETES:
  from dask_kubernetes import KubeCluster
  cluster = KubeCluster()
  cluster.scale(10)  # 10 workers
  client = Client(cluster)

DASHBOARD (http://localhost:8787):
  Shows real-time:
  - Task stream (what's executing)
  - Worker memory usage
  - CPU utilization
  - Task graph progress
  - Profile (flame graph)

BEST PRACTICES:
  1. Use Parquet, not CSV (columnar, faster, smaller)
  2. Set partition size to ~100MB-1GB
  3. Avoid full shuffles (sort, complex joins)
  4. Use .persist() for reused DataFrames
  5. Profile with client.profile() before scaling
  6. Start local, scale to cluster

  # Persist in memory (for reused data)
  df = df.persist()  # Triggers compute, keeps in worker memory

  # Progress bar
  from dask.diagnostics import ProgressBar
  with ProgressBar():
      result = df.compute()

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Dask - Parallel Computing in Python Reference

Commands:
  intro         Overview, comparison, use cases
  dataframe     Parallel Pandas API, partitions
  array         Dask Array, Delayed, Bag
  distributed   Clusters, dashboard, scaling

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)       cmd_intro ;;
  dataframe)   cmd_dataframe ;;
  array)       cmd_array ;;
  distributed) cmd_distributed ;;
  help|*)      show_help ;;
esac
