---
name: "chunk"
version: "1.0.0"
description: "Data chunking reference — splitting strategies, overlap windows, semantic boundaries, and streaming. Use when implementing text splitting for RAG, file upload chunking, or stream processing."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [chunk, splitting, tokenization, rag, streaming, data-processing, atomic]
category: "atomic"
---

# Chunk — Data Chunking Reference

Quick-reference skill for chunking strategies across text, files, and data streams.

## When to Use

- Splitting documents for RAG / vector search ingestion
- Implementing file upload chunking with resume support
- Choosing chunk sizes for LLM context windows
- Stream processing with sliding windows
- Understanding semantic vs fixed-size splitting

## Commands

### `intro`

```bash
scripts/script.sh intro
```

Overview of chunking — why, when, and core tradeoffs.

### `textsplit`

```bash
scripts/script.sh textsplit
```

Text splitting strategies: fixed-size, recursive, sentence, paragraph, semantic.

### `overlap`

```bash
scripts/script.sh overlap
```

Overlap windows — why they matter, sizing, and implementation patterns.

### `semantic`

```bash
scripts/script.sh semantic
```

Semantic chunking — using embeddings, topic shifts, and document structure.

### `tokens`

```bash
scripts/script.sh tokens
```

Token-aware chunking — tiktoken, tokenizer alignment, and context window management.

### `fileupload`

```bash
scripts/script.sh fileupload
```

File upload chunking: multipart, resumable uploads, chunk size selection.

### `streaming`

```bash
scripts/script.sh streaming
```

Stream chunking: sliding windows, tumbling windows, watermarks, backpressure.

### `recipes`

```bash
scripts/script.sh recipes
```

Ready-to-use chunking recipes for common use cases (RAG, CSV, logs, code).

### `help`

```bash
scripts/script.sh help
```

### `version`

```bash
scripts/script.sh version
```

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
