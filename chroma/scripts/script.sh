#!/bin/bash
# Chroma - Embedded Vector Database Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              CHROMA REFERENCE                               ║
║          AI-Native Embedding Database                       ║
╚══════════════════════════════════════════════════════════════╝

Chroma is the simplest vector database. Designed for developers
building AI apps — runs embedded (in-process), local server,
or cloud. The SQLite of vector databases.

WHY CHROMA:
  Dead simple     3 lines to get started
  Embedded        Runs in your process (no server)
  Auto-embed      Built-in embedding functions
  Open source     Apache 2.0
  LangChain       First-class integration

CHROMA vs OTHERS:
  Chroma      → Simplest, embedded-first, prototyping
  Qdrant      → Performance-focused, Rust
  Weaviate    → Auto-vectorize, GraphQL
  Milvus      → Billion-scale, GPU
  Pinecone    → Managed, zero-ops
  pgvector    → PostgreSQL extension

INSTALL:
  pip install chromadb
EOF
}

cmd_usage() {
cat << 'EOF'
PYTHON SDK
============

import chromadb

# Embedded (in-memory)
client = chromadb.Client()

# Persistent (saves to disk)
client = chromadb.PersistentClient(path="./chroma_data")

# Client-server mode
client = chromadb.HttpClient(host="localhost", port=8000)

# Create collection
collection = client.create_collection(
    name="articles",
    metadata={"hnsw:space": "cosine"}  # l2, ip, cosine
)

# Or get existing
collection = client.get_or_create_collection("articles")

# Add documents (auto-embedded with default model!)
collection.add(
    ids=["doc1", "doc2", "doc3"],
    documents=[
        "AI is transforming software development",
        "Machine learning requires large datasets",
        "Neural networks are inspired by the brain",
    ],
    metadatas=[
        {"category": "tech", "year": 2026},
        {"category": "ml", "year": 2025},
        {"category": "ml", "year": 2024},
    ]
)

# Add with pre-computed embeddings
collection.add(
    ids=["doc4"],
    embeddings=[[0.1, 0.2, 0.3, ...]],
    documents=["Pre-embedded document"],
    metadatas=[{"category": "tech"}]
)

# Query (auto-embeds query text!)
results = collection.query(
    query_texts=["what is artificial intelligence"],
    n_results=5
)
# results['documents'], results['metadatas'], results['distances']

# Query with filter
results = collection.query(
    query_texts=["AI tools"],
    n_results=5,
    where={"category": "tech"},
    where_document={"$contains": "software"}
)

# Get by ID
docs = collection.get(ids=["doc1", "doc2"])

# Update
collection.update(
    ids=["doc1"],
    documents=["Updated text"],
    metadatas=[{"category": "updated"}]
)

# Delete
collection.delete(ids=["doc1"])
collection.delete(where={"category": "old"})

# Collection info
collection.count()         # Number of documents
collection.peek()          # Preview first 10
client.list_collections()  # All collections
client.delete_collection("articles")
EOF
}

cmd_patterns() {
cat << 'EOF'
EMBEDDING FUNCTIONS & LANGCHAIN
=================================

CUSTOM EMBEDDING FUNCTION:
  from chromadb.utils import embedding_functions

  # OpenAI
  openai_ef = embedding_functions.OpenAIEmbeddingFunction(
      api_key="sk-...",
      model_name="text-embedding-3-small"
  )
  collection = client.create_collection("articles", embedding_function=openai_ef)

  # HuggingFace (local, free)
  hf_ef = embedding_functions.HuggingFaceEmbeddingFunction(
      model_name="all-MiniLM-L6-v2"
  )

  # Cohere
  cohere_ef = embedding_functions.CohereEmbeddingFunction(
      api_key="...", model_name="embed-english-v3.0"
  )

LANGCHAIN INTEGRATION:
  from langchain_chroma import Chroma
  from langchain_openai import OpenAIEmbeddings

  vectorstore = Chroma.from_documents(
      documents=docs,
      embedding=OpenAIEmbeddings(),
      persist_directory="./chroma_langchain"
  )

  # Similarity search
  results = vectorstore.similarity_search("AI trends", k=5)

  # As retriever for RAG
  retriever = vectorstore.as_retriever(search_kwargs={"k": 5})

WHERE OPERATORS:
  {"field": "value"}              # Exact match
  {"field": {"$eq": "value"}}     # Equal
  {"field": {"$ne": "value"}}     # Not equal
  {"field": {"$gt": 10}}          # Greater than
  {"field": {"$in": ["a", "b"]}}  # In list
  {"$and": [{...}, {...}]}        # AND
  {"$or": [{...}, {...}]}         # OR

  # Document content filter
  where_document={"$contains": "keyword"}
  where_document={"$not_contains": "spam"}

SERVER MODE:
  # Run server
  chroma run --host 0.0.0.0 --port 8000 --path ./data

  # Docker
  docker run -p 8000:8000 chromadb/chroma

  # Connect
  client = chromadb.HttpClient(host="chroma-server", port=8000)

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Chroma - Embedded Vector Database Reference

Commands:
  intro      Overview, comparison
  usage      Python SDK, CRUD, queries
  patterns   Embedding functions, LangChain, server

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)    cmd_intro ;;
  usage)    cmd_usage ;;
  patterns) cmd_patterns ;;
  help|*)   show_help ;;
esac
