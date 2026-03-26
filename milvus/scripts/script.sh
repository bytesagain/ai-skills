#!/bin/bash
# Milvus - Vector Database Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              MILVUS REFERENCE                               ║
║          Open-Source Vector Database for AI                  ║
╚══════════════════════════════════════════════════════════════╝

Milvus is a purpose-built vector database for similarity search
at scale. Used for RAG, recommendation, image search, and
anomaly detection. Handles billions of vectors.

VECTOR DB COMPARISON:
  ┌──────────────┬──────────┬──────────┬──────────┬──────────┐
  │ Feature      │ Milvus   │ Qdrant   │ Weaviate │ Pinecone │
  ├──────────────┼──────────┼──────────┼──────────┼──────────┤
  │ Open source  │ Yes      │ Yes      │ Yes      │ No       │
  │ Scale        │ Billions │ Millions │ Millions │ Billions │
  │ Hosting      │ Zilliz   │ Cloud    │ Cloud    │ Managed  │
  │ Filtering    │ Advanced │ Good     │ GraphQL  │ Metadata │
  │ GPU support  │ Yes      │ No       │ No       │ No       │
  │ Multi-vector │ Yes      │ Yes      │ Yes      │ No       │
  │ Best for     │ Large AI │ Mid-size │ Hybrid   │ Managed  │
  └──────────────┴──────────┴──────────┴──────────┴──────────┘

INSTALL:
  # Docker
  docker compose up -d   # milvus-standalone

  # Python client
  pip install pymilvus

  # Lite (embedded, no server)
  pip install "pymilvus[model]"
  from pymilvus import MilvusClient
  client = MilvusClient("milvus_demo.db")  # Local file
EOF
}

cmd_usage() {
cat << 'EOF'
PYTHON SDK
============

CONNECT:
  from pymilvus import MilvusClient
  client = MilvusClient(uri="http://localhost:19530")

  # Or Zilliz Cloud
  client = MilvusClient(
      uri="https://xxx.zillizcloud.com",
      token="your-api-key"
  )

CREATE COLLECTION:
  from pymilvus import CollectionSchema, FieldSchema, DataType

  fields = [
      FieldSchema("id", DataType.INT64, is_primary=True, auto_id=True),
      FieldSchema("text", DataType.VARCHAR, max_length=1000),
      FieldSchema("embedding", DataType.FLOAT_VECTOR, dim=1536),
      FieldSchema("category", DataType.VARCHAR, max_length=100),
  ]
  schema = CollectionSchema(fields)
  client.create_collection("articles", schema=schema)

  # Quick create (auto schema)
  client.create_collection("articles", dimension=1536)

INSERT:
  data = [
      {"text": "AI is transforming...", "embedding": [0.1, 0.2, ...], "category": "tech"},
      {"text": "Machine learning...", "embedding": [0.3, 0.1, ...], "category": "ml"},
  ]
  client.insert("articles", data)

SEARCH:
  # Basic similarity search
  results = client.search(
      collection_name="articles",
      data=[[0.1, 0.2, ...]],  # query vector
      limit=10,
      output_fields=["text", "category"]
  )

  # With metadata filter
  results = client.search(
      collection_name="articles",
      data=[query_embedding],
      limit=10,
      filter='category == "tech"',
      output_fields=["text", "category"]
  )

  # Range search
  results = client.search(
      collection_name="articles",
      data=[query_embedding],
      limit=10,
      search_params={"metric_type": "L2", "params": {"range_filter": 0.5}}
  )

DELETE:
  client.delete("articles", filter='category == "old"')
  client.drop_collection("articles")
EOF
}

cmd_rag() {
cat << 'EOF'
RAG PATTERN & INDEXES
=======================

RAG (Retrieval Augmented Generation):
  from pymilvus import MilvusClient
  from openai import OpenAI

  milvus = MilvusClient(uri="http://localhost:19530")
  openai = OpenAI()

  # 1. Embed query
  query = "How does Kubernetes networking work?"
  response = openai.embeddings.create(
      model="text-embedding-3-small",
      input=query
  )
  query_vec = response.data[0].embedding

  # 2. Search Milvus
  results = milvus.search(
      collection_name="docs",
      data=[query_vec],
      limit=5,
      output_fields=["text", "source"]
  )

  # 3. Build context
  context = "\n".join([r["entity"]["text"] for r in results[0]])

  # 4. Generate answer
  response = openai.chat.completions.create(
      model="gpt-4",
      messages=[
          {"role": "system", "content": f"Answer using this context:\n{context}"},
          {"role": "user", "content": query}
      ]
  )

INDEX TYPES:
  IVF_FLAT     Inverted file + exact search (balanced)
  IVF_SQ8      IVF + scalar quantization (less memory)
  IVF_PQ       IVF + product quantization (smallest)
  HNSW         Graph-based (fastest query, more memory)
  FLAT         Brute force (100% recall, slowest)
  GPU_IVF_FLAT GPU-accelerated IVF
  SCANN        Google's ScaNN algorithm

  # Create index
  index_params = client.prepare_index_params()
  index_params.add_index(
      field_name="embedding",
      index_type="HNSW",
      metric_type="COSINE",
      params={"M": 16, "efConstruction": 256}
  )
  client.create_index("articles", index_params)

DISTANCE METRICS:
  L2        Euclidean distance (lower = more similar)
  IP        Inner product (higher = more similar)
  COSINE    Cosine similarity (higher = more similar)

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Milvus - Vector Database Reference

Commands:
  intro    Overview, comparison
  usage    Python SDK, CRUD, search
  rag      RAG pattern, indexes, metrics

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro) cmd_intro ;;
  usage) cmd_usage ;;
  rag)   cmd_rag ;;
  help|*) show_help ;;
esac
