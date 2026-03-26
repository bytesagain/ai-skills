#!/bin/bash
# Qdrant - Vector Search Engine Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              QDRANT REFERENCE                               ║
║          High-Performance Vector Search Engine              ║
╚══════════════════════════════════════════════════════════════╝

Qdrant (quadrant) is a vector similarity search engine written
in Rust. Focused on performance, filtering, and ease of use.

WHY QDRANT:
  Rust-powered      Memory-safe, fast, efficient
  Rich filtering    Payload filters during search
  Multi-vector      Named vectors per point
  Snapshots         Point-in-time backups
  REST + gRPC       Both APIs available
  Quantization      Scalar/product/binary for compression

INSTALL:
  docker run -p 6333:6333 -p 6334:6334 qdrant/qdrant
  pip install qdrant-client
  # Dashboard: http://localhost:6333/dashboard
EOF
}

cmd_usage() {
cat << 'EOF'
PYTHON SDK
============

from qdrant_client import QdrantClient
from qdrant_client.models import Distance, VectorParams, PointStruct

client = QdrantClient(url="http://localhost:6333")

# Create collection
client.create_collection(
    collection_name="articles",
    vectors_config=VectorParams(size=1536, distance=Distance.COSINE)
)

# Multi-vector collection
client.create_collection(
    collection_name="products",
    vectors_config={
        "text": VectorParams(size=1536, distance=Distance.COSINE),
        "image": VectorParams(size=512, distance=Distance.COSINE),
    }
)

# Upsert points
client.upsert(
    collection_name="articles",
    points=[
        PointStruct(id=1, vector=[0.1, 0.2, ...],
            payload={"title": "AI Guide", "category": "tech", "year": 2026}),
        PointStruct(id=2, vector=[0.3, 0.1, ...],
            payload={"title": "ML Basics", "category": "ml", "year": 2025}),
    ]
)

# Search
results = client.search(
    collection_name="articles",
    query_vector=[0.1, 0.2, ...],
    limit=10
)

# Search with filter
from qdrant_client.models import Filter, FieldCondition, MatchValue, Range

results = client.search(
    collection_name="articles",
    query_vector=[0.1, 0.2, ...],
    query_filter=Filter(
        must=[
            FieldCondition(key="category", match=MatchValue(value="tech")),
            FieldCondition(key="year", range=Range(gte=2025)),
        ]
    ),
    limit=10
)

# Recommendation (find similar to positive, dissimilar to negative)
results = client.recommend(
    collection_name="articles",
    positive=[1, 3],     # Point IDs to find similar to
    negative=[5],        # Point IDs to avoid
    limit=10
)

# Scroll (iterate all)
records, next_offset = client.scroll(
    collection_name="articles",
    limit=100,
    with_payload=True,
    with_vectors=False
)

# Delete
client.delete(collection_name="articles", points_selector=[1, 2, 3])
EOF
}

cmd_advanced() {
cat << 'EOF'
QUANTIZATION & CLUSTERING
============================

QUANTIZATION (reduce memory):
  # Scalar quantization (4x compression)
  client.update_collection(
      collection_name="articles",
      quantization_config=models.ScalarQuantization(
          scalar=models.ScalarQuantizationConfig(
              type=models.ScalarType.INT8,
              always_ram=True
          )
      )
  )

  # Binary quantization (32x compression, best for OpenAI embeddings)
  client.update_collection(
      collection_name="articles",
      quantization_config=models.BinaryQuantization(
          binary=models.BinaryQuantizationConfig(always_ram=True)
      )
  )

SNAPSHOTS:
  # Create snapshot
  client.create_snapshot(collection_name="articles")

  # List snapshots
  client.list_snapshots(collection_name="articles")

  # Restore
  client.recover_snapshot("articles", "/path/to/snapshot.snapshot")

REST API:
  # Search via HTTP
  curl -X POST http://localhost:6333/collections/articles/points/search \
    -H "Content-Type: application/json" \
    -d '{"vector":[0.1,0.2,...],"limit":10,
         "filter":{"must":[{"key":"category","match":{"value":"tech"}}]}}'

  # Get collection info
  curl http://localhost:6333/collections/articles

  # Health check
  curl http://localhost:6333/healthz

CLUSTERING (distributed):
  # Qdrant supports distributed mode
  # Sharding + replication for HA
  # Configure via YAML:
  cluster:
    enabled: true
    p2p:
      port: 6335

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Qdrant - Vector Search Engine Reference

Commands:
  intro      Overview, features
  usage      Python SDK, search, filters, recommend
  advanced   Quantization, snapshots, REST API

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)    cmd_intro ;;
  usage)    cmd_usage ;;
  advanced) cmd_advanced ;;
  help|*)   show_help ;;
esac
