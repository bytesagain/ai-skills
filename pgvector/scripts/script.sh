#!/bin/bash
# pgvector - PostgreSQL Vector Extension Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              PGVECTOR REFERENCE                             ║
║          Vector Search in PostgreSQL                        ║
╚══════════════════════════════════════════════════════════════╝

pgvector adds vector similarity search to PostgreSQL. Keep your
vectors alongside your relational data — no separate database.

WHY PGVECTOR:
  No new infra      Use existing PostgreSQL
  SQL queries       JOIN vectors with relational data
  ACID              Full transaction support
  Mature ecosystem  pgAdmin, pg_dump, replication
  Supabase/Neon     Managed options with pgvector built-in

PGVECTOR vs DEDICATED VECTOR DB:
  ┌──────────────┬──────────────┬──────────────┐
  │ Feature      │ pgvector     │ Milvus/Qdrant│
  ├──────────────┼──────────────┼──────────────┤
  │ Scale        │ ~10M vectors │ Billions     │
  │ Speed        │ Good         │ Excellent    │
  │ SQL JOINs    │ Yes          │ No           │
  │ ACID         │ Yes          │ Partial      │
  │ Ops overhead │ None (PG)    │ New system   │
  │ Best for     │ <10M vectors │ Large-scale  │
  └──────────────┴──────────────┴──────────────┘

INSTALL:
  -- PostgreSQL extension
  CREATE EXTENSION IF NOT EXISTS vector;

  -- Docker
  docker run -p 5432:5432 -e POSTGRES_PASSWORD=secret \
    pgvector/pgvector:pg16
EOF
}

cmd_usage() {
cat << 'EOF'
SQL OPERATIONS
================

CREATE TABLE:
  CREATE TABLE articles (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    content TEXT,
    category TEXT,
    embedding vector(1536),    -- OpenAI dimension
    created_at TIMESTAMPTZ DEFAULT now()
  );

INSERT:
  INSERT INTO articles (title, content, embedding)
  VALUES ('AI Guide', 'Introduction to...', '[0.1, 0.2, ...]');

  -- Batch insert with COPY
  COPY articles (title, embedding)
  FROM '/data/articles.csv' WITH CSV;

SIMILARITY SEARCH:
  -- Cosine distance (most common)
  SELECT id, title, 1 - (embedding <=> $1) AS similarity
  FROM articles
  ORDER BY embedding <=> $1
  LIMIT 10;

  -- L2 distance (Euclidean)
  SELECT id, title
  FROM articles
  ORDER BY embedding <-> $1
  LIMIT 10;

  -- Inner product (for normalized vectors)
  SELECT id, title
  FROM articles
  ORDER BY embedding <#> $1
  LIMIT 10;

  -- With metadata filter (huge advantage over vector DBs!)
  SELECT id, title, 1 - (embedding <=> $1) AS similarity
  FROM articles
  WHERE category = 'tech'
    AND created_at > '2026-01-01'
  ORDER BY embedding <=> $1
  LIMIT 10;

  -- JOIN with other tables
  SELECT a.title, u.name AS author,
         1 - (a.embedding <=> $1) AS similarity
  FROM articles a
  JOIN users u ON a.author_id = u.id
  WHERE a.category = 'tech'
  ORDER BY a.embedding <=> $1
  LIMIT 10;

OPERATORS:
  <->   L2 distance (Euclidean)
  <=>   Cosine distance
  <#>   Negative inner product
EOF
}

cmd_advanced() {
cat << 'EOF'
INDEXES & RAG
===============

INDEXES:
  -- IVFFlat (faster build, good recall)
  CREATE INDEX ON articles
  USING ivfflat (embedding vector_cosine_ops)
  WITH (lists = 100);
  -- Rule of thumb: lists = sqrt(row_count)

  -- HNSW (better recall, more memory)
  CREATE INDEX ON articles
  USING hnsw (embedding vector_cosine_ops)
  WITH (m = 16, ef_construction = 64);

  -- Set probes for IVFFlat (higher = better recall)
  SET ivfflat.probes = 10;

  -- Set ef_search for HNSW
  SET hnsw.ef_search = 40;

PYTHON + PSYCOPG:
  import psycopg2
  from pgvector.psycopg2 import register_vector

  conn = psycopg2.connect("postgresql://localhost/mydb")
  register_vector(conn)

  # Search
  cur = conn.cursor()
  cur.execute("""
      SELECT id, title, 1 - (embedding <=> %s) AS similarity
      FROM articles
      ORDER BY embedding <=> %s
      LIMIT %s
  """, (query_embedding, query_embedding, 10))

SQLALCHEMY:
  from pgvector.sqlalchemy import Vector
  from sqlalchemy import Column, Integer, Text
  from sqlalchemy.orm import declarative_base

  Base = declarative_base()

  class Article(Base):
      __tablename__ = "articles"
      id = Column(Integer, primary_key=True)
      title = Column(Text)
      embedding = Column(Vector(1536))

SUPABASE + PGVECTOR:
  -- Supabase has pgvector built-in
  -- Create function for similarity search
  CREATE OR REPLACE FUNCTION match_articles(
    query_embedding vector(1536),
    match_threshold float,
    match_count int
  ) RETURNS TABLE (id int, title text, similarity float)
  AS $$
    SELECT id, title,
           1 - (embedding <=> query_embedding) AS similarity
    FROM articles
    WHERE 1 - (embedding <=> query_embedding) > match_threshold
    ORDER BY embedding <=> query_embedding
    LIMIT match_count;
  $$ LANGUAGE sql STABLE;

  -- Call from Supabase client
  const { data } = await supabase
    .rpc('match_articles', {
      query_embedding: embedding,
      match_threshold: 0.7,
      match_count: 10
    });

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
pgvector - PostgreSQL Vector Extension Reference

Commands:
  intro      Overview, vs dedicated vector DBs
  usage      SQL operations, search, JOINs
  advanced   Indexes (IVFFlat/HNSW), Python, Supabase

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)    cmd_intro ;;
  usage)    cmd_usage ;;
  advanced) cmd_advanced ;;
  help|*)   show_help ;;
esac
