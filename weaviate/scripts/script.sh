#!/bin/bash
# Weaviate - AI-Native Vector Database Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              WEAVIATE REFERENCE                             ║
║          AI-Native Vector Database                          ║
╚══════════════════════════════════════════════════════════════╝

Weaviate is a vector database with built-in ML model integration.
It can vectorize data automatically using modules (OpenAI,
Cohere, HuggingFace) — no need to pre-compute embeddings.

UNIQUE FEATURES:
  Vectorizer modules  Auto-embed text/images on insert
  Hybrid search       Combine vector + keyword (BM25)
  GraphQL API         Schema-aware queries
  Multi-tenancy       Isolated tenant data
  Generative search   RAG built into queries
  RBAC                Role-based access control

INSTALL:
  docker run -d -p 8080:8080 -p 50051:50051 \
    -e QUERY_DEFAULTS_LIMIT=20 \
    -e AUTHENTICATION_ANONYMOUS_ACCESS_ENABLED=true \
    cr.weaviate.io/semitechnologies/weaviate:1.28.0

  pip install weaviate-client
EOF
}

cmd_usage() {
cat << 'EOF'
PYTHON SDK (v4)
=================

import weaviate
from weaviate.classes.config import Configure, Property, DataType

# Connect
client = weaviate.connect_to_local()   # localhost:8080

# Cloud
client = weaviate.connect_to_weaviate_cloud(
    cluster_url="https://xxx.weaviate.network",
    auth_credentials=weaviate.auth.AuthApiKey("your-key")
)

# Create collection with auto-vectorizer
articles = client.collections.create(
    name="Article",
    vectorizer_config=Configure.Vectorizer.text2vec_openai(),
    generative_config=Configure.Generative.openai(),
    properties=[
        Property(name="title", data_type=DataType.TEXT),
        Property(name="content", data_type=DataType.TEXT),
        Property(name="category", data_type=DataType.TEXT),
    ]
)

# Insert (auto-vectorized!)
articles = client.collections.get("Article")
articles.data.insert({
    "title": "AI in 2026",
    "content": "Artificial intelligence has...",
    "category": "tech"
})

# Batch insert
with articles.batch.dynamic() as batch:
    for doc in documents:
        batch.add_object(properties=doc)

# Semantic search (near_text — auto-vectorizes query)
results = articles.query.near_text(
    query="machine learning trends",
    limit=10,
    return_properties=["title", "category"]
)

# Hybrid search (vector + BM25 keyword)
results = articles.query.hybrid(
    query="kubernetes deployment",
    alpha=0.75,  # 0=keyword, 1=vector
    limit=10
)

# BM25 keyword search
results = articles.query.bm25(
    query="docker compose",
    limit=10
)

# Filter
from weaviate.classes.query import Filter
results = articles.query.near_text(
    query="AI tools",
    filters=Filter.by_property("category").equal("tech"),
    limit=10
)

# Generative search (RAG in one query!)
results = articles.generate.near_text(
    query="AI trends",
    single_prompt="Summarize this article: {content}",
    limit=3
)
# Each result has .generated field with LLM response

# Group generative
results = articles.generate.near_text(
    query="AI trends",
    grouped_task="Write a report based on these articles",
    limit=5
)
EOF
}

cmd_advanced() {
cat << 'EOF'
MULTI-TENANCY & GRAPHQL
==========================

MULTI-TENANCY:
  # Create multi-tenant collection
  articles = client.collections.create(
      name="Article",
      multi_tenancy_config=Configure.multi_tenancy(enabled=True),
      vectorizer_config=Configure.Vectorizer.text2vec_openai()
  )

  # Add tenants
  articles.tenants.create([
      weaviate.classes.tenants.Tenant(name="tenant_A"),
      weaviate.classes.tenants.Tenant(name="tenant_B"),
  ])

  # Insert for specific tenant
  tenant_a = articles.with_tenant("tenant_A")
  tenant_a.data.insert({"title": "Private doc"})

GRAPHQL API:
  {
    Get {
      Article(
        nearText: { concepts: ["machine learning"] }
        where: { path: ["category"], operator: Equal, valueText: "tech" }
        limit: 10
      ) {
        title
        content
        _additional { distance certainty }
      }
    }
  }

  # Aggregate
  {
    Aggregate {
      Article {
        meta { count }
        category { topOccurrences { value occurs } }
      }
    }
  }

VECTORIZER MODULES:
  text2vec-openai        OpenAI embeddings
  text2vec-cohere        Cohere embeddings
  text2vec-huggingface   HuggingFace models
  text2vec-transformers  Local transformer model
  multi2vec-clip         Text + image (CLIP)
  img2vec-neural         Image embeddings

BACKUP:
  client.backup.create(
      backup_id="daily-backup",
      backend="filesystem",
      include_collections=["Article"]
  )
  client.backup.restore(
      backup_id="daily-backup",
      backend="filesystem"
  )

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Weaviate - AI-Native Vector Database Reference

Commands:
  intro      Overview, features
  usage      Python v4 SDK, search, RAG
  advanced   Multi-tenancy, GraphQL, modules

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)    cmd_intro ;;
  usage)    cmd_usage ;;
  advanced) cmd_advanced ;;
  help|*)   show_help ;;
esac
