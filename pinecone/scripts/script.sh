#!/bin/bash
# Pinecone - Managed Vector Database Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              PINECONE REFERENCE                             ║
║          Fully Managed Vector Database                      ║
╚══════════════════════════════════════════════════════════════╝

Pinecone is a fully managed vector database — no infrastructure
to manage. Designed for production RAG, search, and recommendations.

WHY PINECONE:
  Fully managed     No servers, no ops
  Serverless        Pay per query, auto-scale
  Fast              Single-digit ms latency
  Hybrid search     Dense + sparse vectors
  Namespaces        Logical partitioning
  Metadata filter   Filter during search

TIERS:
  Starter     Free, 1 index, 100K vectors
  Standard    $0.08/1M reads, 5 indexes
  Enterprise  Dedicated, SLA, HIPAA

INSTALL:
  pip install pinecone
EOF
}

cmd_usage() {
cat << 'EOF'
PYTHON SDK
============

from pinecone import Pinecone, ServerlessSpec

pc = Pinecone(api_key="your-api-key")

# Create serverless index
pc.create_index(
    name="articles",
    dimension=1536,
    metric="cosine",
    spec=ServerlessSpec(cloud="aws", region="us-east-1")
)

# Connect to index
index = pc.Index("articles")

# Upsert vectors
index.upsert(vectors=[
    {"id": "doc1", "values": [0.1, 0.2, ...],
     "metadata": {"title": "AI Guide", "category": "tech"}},
    {"id": "doc2", "values": [0.3, 0.1, ...],
     "metadata": {"title": "ML Basics", "category": "ml"}},
])

# Batch upsert (recommended for large datasets)
from itertools import islice
def chunks(data, size=100):
    it = iter(data)
    for first in it:
        yield [first] + list(islice(it, size - 1))

for batch in chunks(all_vectors, 100):
    index.upsert(vectors=batch)

# Query
results = index.query(
    vector=[0.1, 0.2, ...],
    top_k=10,
    include_metadata=True
)
for match in results.matches:
    print(f"{match.id}: {match.score} - {match.metadata['title']}")

# Query with metadata filter
results = index.query(
    vector=[0.1, 0.2, ...],
    top_k=10,
    filter={"category": {"$eq": "tech"}},
    include_metadata=True
)

# Namespace (logical partition)
index.upsert(vectors=[...], namespace="user-123")
results = index.query(vector=[...], top_k=10, namespace="user-123")

# Fetch by ID
result = index.fetch(ids=["doc1", "doc2"])

# Delete
index.delete(ids=["doc1"])
index.delete(filter={"category": {"$eq": "old"}})
index.delete(delete_all=True, namespace="temp")

# Index stats
stats = index.describe_index_stats()
# {'dimension': 1536, 'total_vector_count': 50000}
EOF
}

cmd_rag() {
cat << 'EOF'
RAG PATTERN & BEST PRACTICES
===============================

RAG WITH OPENAI:
  from pinecone import Pinecone
  from openai import OpenAI

  pc = Pinecone(api_key="pine-key")
  openai = OpenAI(api_key="oai-key")
  index = pc.Index("knowledge-base")

  def ask(question):
      # 1. Embed question
      embedding = openai.embeddings.create(
          model="text-embedding-3-small", input=question
      ).data[0].embedding

      # 2. Search Pinecone
      results = index.query(
          vector=embedding, top_k=5, include_metadata=True
      )

      # 3. Build context
      context = "\n\n".join([
          r.metadata["text"] for r in results.matches
      ])

      # 4. Generate answer
      response = openai.chat.completions.create(
          model="gpt-4",
          messages=[
              {"role": "system", "content":
                  f"Answer based on context:\n{context}"},
              {"role": "user", "content": question}
          ]
      )
      return response.choices[0].message.content

FILTER OPERATORS:
  {"field": {"$eq": "value"}}        # Equal
  {"field": {"$ne": "value"}}        # Not equal
  {"field": {"$gt": 10}}             # Greater than
  {"field": {"$gte": 10}}            # Greater or equal
  {"field": {"$lt": 10}}             # Less than
  {"field": {"$in": ["a", "b"]}}     # In list
  {"field": {"$nin": ["c"]}}         # Not in list
  {"$and": [{...}, {...}]}           # AND
  {"$or": [{...}, {...}]}            # OR

BEST PRACTICES:
  - Use namespaces for multi-tenancy
  - Batch upserts (100 vectors per call)
  - Use metadata filters to narrow search
  - text-embedding-3-small (1536d) for cost efficiency
  - text-embedding-3-large (3072d) for accuracy
  - Monitor query latency via Pinecone console

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Pinecone - Managed Vector Database Reference

Commands:
  intro    Overview, tiers
  usage    Python SDK, CRUD, namespaces
  rag      RAG pattern, filters, best practices

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro) cmd_intro ;;
  usage) cmd_usage ;;
  rag)   cmd_rag ;;
  help|*) show_help ;;
esac
