#!/usr/bin/env bash
# chunk — Data Chunking Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Data Chunking ===

Chunking is splitting data into smaller pieces for processing.
Why? Because systems have limits — context windows, network packets,
memory buffers, database rows, attention spans.

Core Tradeoffs:

  Small Chunks                    Large Chunks
  ────────────                    ────────────
  More precise retrieval          More context per result
  Less context per chunk          Fewer chunks to process
  More chunks to store/index      Harder to retrieve precisely
  Lower latency per chunk         Higher latency per chunk
  Risk: losing meaning            Risk: noise dilutes signal

When Chunking Happens:
  Text → LLM:          Context window limits (4K–128K tokens)
  Documents → Vector DB: Embedding models have token limits (512–8K)
  Files → Network:      MTU, upload limits, retry granularity
  Streams → Processing: Buffer sizes, windowing, backpressure
  Data → Database:      Row limits, batch insert sizes

The Goldilocks Problem:
  Too small: "The cat sat on the mat" → lost: who's the cat? which mat?
  Too large: entire chapter → noisy retrieval, slow processing
  Just right: paragraph with context → meaningful, retrievable, processable

Key Principle:
  A chunk should be SELF-CONTAINED enough to be useful on its own.
  If a chunk needs the previous chunk to make sense, it's too small.
  If a chunk contains multiple unrelated topics, it's too large.

Chunking Pipeline:
  1. Pre-process (clean, normalize)
  2. Detect boundaries (structural, semantic, size-based)
  3. Split at boundaries
  4. Add overlap (if needed for context continuity)
  5. Enrich (add metadata: source, position, heading hierarchy)
  6. Validate (check size, completeness)
EOF
}

cmd_textsplit() {
    cat << 'EOF'
=== Text Splitting Strategies ===

1. Fixed-Size (Character Count):
   Split every N characters, regardless of content.
   chunk_size=1000, overlap=200
   
   Pros: simple, predictable size, fast
   Cons: breaks words, sentences, paragraphs, meaning
   Use: when you don't care about semantics (raw data)

2. Recursive Character Splitting (LangChain default):
   Try splitting by: ["\n\n", "\n", ". ", " ", ""]
   Use largest separator that keeps chunks under limit.
   
   Algorithm:
     Split by "\n\n" (paragraphs) → if chunk too big:
       Split by "\n" (lines) → if still too big:
         Split by ". " (sentences) → if still too big:
           Split by " " (words) → last resort: characters
   
   Pros: respects document structure, good general purpose
   Cons: not truly semantic, separator-dependent

3. Sentence Splitting:
   Split on sentence boundaries (NLP tokenizer: spaCy, NLTK).
   Group N sentences per chunk.
   
   Pros: linguistically coherent, natural boundaries
   Cons: sentence length varies wildly, need NLP library
   Use: prose, articles, documentation

4. Paragraph Splitting:
   Split on double newlines or paragraph markers.
   Merge short paragraphs, split long ones.
   
   Pros: author-intended boundaries, often topic-aligned
   Cons: paragraph sizes vary hugely (1 sentence to 1 page)

5. Markdown / HTML Structural:
   Split on headings (## / <h2>), preserving hierarchy.
   Each section becomes a chunk, with heading as metadata.
   
   Pros: leverages document structure, heading = topic
   Cons: section sizes vary, need parser
   Tools: MarkdownHeaderTextSplitter (LangChain)

6. Code Splitting:
   Split on function/class boundaries (AST-aware).
   Languages: Python (def/class), JS (function/const), etc.
   
   Pros: each chunk is a complete code unit
   Cons: needs language-specific parser
   Tools: RecursiveCharacterTextSplitter with language param
EOF
}

cmd_overlap() {
    cat << 'EOF'
=== Overlap Windows ===

Why Overlap?
  Fixed splits cut through context. Overlap ensures that
  information at chunk boundaries appears in both chunks.

  Without overlap:
    Chunk 1: "The patient was prescribed metformin"
    Chunk 2: "200mg twice daily for diabetes management"
    → Query "metformin dosage" might miss the connection

  With 20% overlap:
    Chunk 1: "The patient was prescribed metformin 200mg"
    Chunk 2: "metformin 200mg twice daily for diabetes management"
    → Both chunks contain the full context

Sizing Guidelines:
  Text/RAG:    10-20% of chunk size (100-200 chars for 1000-char chunks)
  Token-based: 50-100 tokens overlap for 500-token chunks
  Code:        0 overlap (use complete function boundaries instead)
  
  Rule of thumb: overlap ≥ 1 full sentence

Implementation Pattern:
  chunks = []
  start = 0
  while start < len(text):
      end = start + chunk_size
      chunk = text[start:end]
      
      # Find clean break point near end
      break_point = chunk.rfind('\n', -overlap_size)
      if break_point == -1:
          break_point = chunk.rfind('. ', -overlap_size)
      
      chunks.append(chunk[:break_point])
      start = start + break_point - overlap_size  # overlap!

Deduplication:
  Overlap creates duplicate content in your index.
  Solutions:
    - Deduplicate at retrieval (by position metadata)
    - Score penalty for adjacent chunks
    - Merge overlapping results before feeding to LLM

When NOT to Overlap:
  ✗ Structured data (CSV, JSON) — overlap corrupts records
  ✗ Code — use AST boundaries instead
  ✗ Fixed records — database rows, log entries
  ✗ When chunks are already semantically complete
EOF
}

cmd_semantic() {
    cat << 'EOF'
=== Semantic Chunking ===

Split based on MEANING, not character count.
Use embedding similarity to detect topic shifts.

Embedding-Based Approach:
  1. Split text into sentences
  2. Compute embeddings for each sentence
  3. Compare consecutive sentence embeddings (cosine similarity)
  4. Detect drops in similarity → topic boundary
  5. Group sentences between boundaries into chunks

  Similarity threshold: 0.7–0.85 (tune per domain)
  
  Sentence embeddings: [0.92, 0.88, 0.91, 0.35, 0.87, 0.90, 0.40, ...]
                                              ↑ topic shift!         ↑ another!

Sliding Window Variant:
  Compare average embedding of window A vs window B:
    Window A: sentences [i-2, i-1, i]
    Window B: sentences [i+1, i+2, i+3]
  Larger windows → smoother, fewer false positives

Document Structure Signals:
  Heading changes:   strongest signal (author-defined topics)
  Paragraph breaks:  moderate signal
  List items:        keep lists together
  Code blocks:       keep complete (never split mid-code)
  Tables:            keep complete
  Blockquotes:       keep complete

Agentic Chunking (LLM-based):
  Use an LLM to decide chunk boundaries:
  "Read this text and identify where topic changes occur."
  
  Pros: best quality, understands nuance
  Cons: expensive, slow, non-deterministic
  Use: high-value documents where quality matters

Proposition-Based Chunking:
  Convert text into atomic propositions (facts):
  "Albert Einstein developed the theory of relativity in 1905
   while working at a patent office in Bern, Switzerland."
  →
  Proposition 1: "Albert Einstein developed the theory of relativity"
  Proposition 2: "The theory of relativity was developed in 1905"
  Proposition 3: "Einstein worked at a patent office"
  Proposition 4: "The patent office was in Bern, Switzerland"
  
  Each proposition is independently searchable.
  Expensive but very precise retrieval.

Parent-Child Chunking:
  Store small chunks for retrieval, large chunks for context.
  Retrieve: small chunk matches query
  Return: parent (large chunk) to LLM for full context
  Best of both worlds: precise search + rich context
EOF
}

cmd_tokens() {
    cat << 'EOF'
=== Token-Aware Chunking ===

LLMs and embedding models count TOKENS, not characters.
Chunk sizes should be measured in tokens.

Token ≠ Word ≠ Character:
  "Hello world" → 2 tokens
  "tokenization" → 3 tokens (token + ization, or similar)
  "你好世界" → 2-4 tokens (varies by tokenizer)
  "https://example.com/path" → 5-10 tokens (URLs are expensive!)

Common Tokenizers:
  GPT-4/3.5:     cl100k_base (tiktoken)
  GPT-4o:        o200k_base (tiktoken)
  Claude:        ~similar to cl100k_base
  Llama 2/3:     SentencePiece (BPE)
  
  Rule of thumb (English): 1 token ≈ 4 characters ≈ 0.75 words

Embedding Model Token Limits:
  text-embedding-ada-002:  8,191 tokens
  text-embedding-3-small:  8,191 tokens
  text-embedding-3-large:  8,191 tokens
  Cohere embed-v3:         512 tokens
  BGE / E5:                512 tokens (most open models)
  Jina v2:                 8,192 tokens

Chunk Size Recommendations for RAG:
  Embedding model limit 512 tokens:
    Chunk: 256-400 tokens, overlap: 50-100 tokens
  
  Embedding model limit 8K tokens:
    Chunk: 512-1024 tokens, overlap: 100-200 tokens
    (larger chunks possible but may reduce precision)
  
  For Q&A: smaller chunks (200-400 tokens) work best
  For summarization: larger chunks (500-1500 tokens) better

Counting Tokens in Code:
  Python (tiktoken):
    import tiktoken
    enc = tiktoken.encoding_for_model("gpt-4")
    tokens = enc.encode(text)
    len(tokens)  # token count
  
  JavaScript:
    import { encoding_for_model } from "tiktoken";
    const enc = encoding_for_model("gpt-4");
    enc.encode(text).length;

Token-Aware Splitting:
  1. Encode entire text to tokens
  2. Split token array at chunk_size boundaries
  3. Decode each chunk back to text
  4. Adjust: don't split mid-word (find word boundary)
  
  Better: split by sentences, accumulate until token limit
EOF
}

cmd_fileupload() {
    cat << 'EOF'
=== File Upload Chunking ===

Split files for reliable network transfer with resume capability.

Chunk Size Selection:
  Network          Recommended Chunk    Why
  ───────          ─────────────────    ───
  Mobile 3G        256 KB - 1 MB        High latency, drops
  Mobile 4G/5G     1 - 5 MB             Moderate reliability
  WiFi/Broadband   5 - 10 MB            Fast, stable
  Server-to-Server 10 - 50 MB           Low latency, high bandwidth
  
  Rule: chunk_size ≈ bandwidth × acceptable_retry_time
  If 10 Mbps and 3s max retry: 10 × 3 / 8 ≈ 3.75 MB

Resumable Upload Protocol (tus):
  1. POST /upload → get upload URL
  2. HEAD /upload/{id} → get current offset
  3. PATCH /upload/{id} offset=0, chunk1 data
  4. PATCH /upload/{id} offset=chunk1_size, chunk2 data
  ...repeat until complete
  
  Headers:
    Upload-Offset: current byte position
    Upload-Length: total file size
    Content-Type: application/offset+octet-stream

Multipart Upload (S3-style):
  1. InitiateMultipartUpload → get uploadId
  2. UploadPart (partNumber=1, body=chunk1) → get ETag
  3. UploadPart (partNumber=2, body=chunk2) → get ETag
  ...
  N. CompleteMultipartUpload (uploadId, [parts]) → done
  
  S3 constraints:
    Part size: 5 MB minimum (except last part)
    Max parts: 10,000
    Max file: 5 TB
    Recommended: 100 MB parts for large files

Integrity Verification:
  Per-chunk: MD5/SHA-256 hash sent with each chunk
  Server verifies before acknowledging
  Final: full-file hash verification after assembly
  
  Content-MD5 header (base64 encoded)
  x-amz-checksum-sha256 (AWS S3)

Error Handling:
  Retry with exponential backoff: 1s, 2s, 4s, 8s, 16s
  Max retries per chunk: 3-5
  On permanent failure: skip, log, continue (user decides)
  Parallel uploads: 3-6 concurrent chunks (S3 supports this)
EOF
}

cmd_streaming() {
    cat << 'EOF'
=== Stream Chunking ===

Processing infinite or very large data streams in bounded windows.

Tumbling Window:
  Non-overlapping, fixed-size windows.
  |──chunk1──|──chunk2──|──chunk3──|
  
  Time-based: every 5 minutes
  Count-based: every 1000 events
  Size-based: every 1 MB
  
  Pros: simple, no duplicates, predictable
  Cons: events at boundaries may be split

Sliding Window:
  Overlapping windows that advance by a step.
  |──────window1──────|
       |──────window2──────|
            |──────window3──────|
  
  Window: 10 minutes, Step: 1 minute
  → each event appears in 10 windows
  
  Pros: smooth aggregation, no boundary effects
  Cons: higher compute (each event processed multiple times)

Session Window:
  Dynamically sized based on activity gaps.
  |──events──| gap |──events──| gap |──events──|
  |─session1─|     |─session2─|     |─session3─|
  
  Gap timeout: e.g., 30 minutes of inactivity → new session
  Pros: natural grouping of user activity
  Cons: unbounded session size possible

Watermarks (Late Data Handling):
  "I believe all data up to time T has arrived"
  Watermark = max(event_time) - allowed_lateness
  
  Events before watermark: process normally
  Events after watermark: late → side output or drop
  
  Allowed lateness: trade completeness vs latency
  0 lateness: fast but may miss data
  5 min lateness: slower but more complete

Backpressure:
  When consumer is slower than producer:
    Drop:     newest or oldest events (lossy)
    Buffer:   bounded queue, block producer when full
    Sample:   keep every Nth event
    Throttle: slow down producer to consumer rate
  
  TCP: built-in backpressure (window size)
  Kafka: consumer lag monitoring
  Reactive Streams: request(n) pull-based

Chunk Serialization for Streams:
  Length-prefixed: [4 bytes length][payload]
  Delimiter-based: payload\n payload\n (newline-delimited JSON)
  Framed: WebSocket frames, HTTP/2 frames
  Protobuf: varint length prefix + message bytes
EOF
}

cmd_recipes() {
    cat << 'EOF'
=== Chunking Recipes ===

Recipe 1: RAG Document Ingestion
  Chunk size: 512 tokens
  Overlap: 100 tokens
  Strategy: recursive character splitting
  Separators: ["\n## ", "\n### ", "\n\n", "\n", ". "]
  Metadata: source_file, page_number, heading_hierarchy
  Post-process: skip chunks < 50 tokens (likely noise)

Recipe 2: Code Repository Indexing
  Strategy: AST-based splitting
  Boundaries: function, class, method definitions
  Max chunk: 1500 tokens (function + docstring)
  Overlap: 0 (complete units)
  Metadata: file_path, language, function_name, class_name
  Include: imports + function (resolve references)

Recipe 3: CSV / Tabular Data
  Strategy: row-based with header preservation
  Chunk size: 100-500 rows per chunk
  Overlap: 0 (rows are independent records)
  MUST include: column headers in every chunk
  Format: header_row + data_rows

Recipe 4: Log File Processing
  Strategy: line-based with timestamp awareness
  Chunk size: 1000 lines or 5 minutes of logs
  Overlap: 0 (log entries are independent)
  Keep multi-line entries together (stack traces!)
  Pattern: timestamp starts new entry

Recipe 5: Chat / Conversation History
  Strategy: message-count with speaker turns
  Chunk size: 10-20 messages (or token limit)
  Overlap: 2-4 messages (maintain conversation flow)
  Never split mid-message
  Include: speaker labels in every chunk

Recipe 6: PDF Documents
  Pre-process: extract text with layout awareness
  Strategy: page-based then paragraph splitting
  Chunk size: 300-500 tokens
  Handle: headers/footers (remove), tables (keep whole)
  Metadata: page_number, section_title
  Tools: PyMuPDF, pdfplumber, Unstructured

Recipe 7: Large JSON Processing
  Strategy: top-level array element splitting
  Each array item = one chunk (if small enough)
  Large nested objects: split by first-level keys
  Stream parse: ijson (Python), stream-json (JS)
  Never split mid-object!
EOF
}

show_help() {
    cat << EOF
chunk v$VERSION — Data Chunking Reference

Usage: script.sh <command>

Commands:
  intro       Why and when to chunk data
  textsplit   Text splitting strategies (fixed, recursive, semantic)
  overlap     Overlap windows — sizing and implementation
  semantic    Semantic chunking with embeddings and structure
  tokens      Token-aware chunking for LLMs and embeddings
  fileupload  Resumable file upload chunking
  streaming   Stream windows: tumbling, sliding, session
  recipes     Ready-to-use recipes for RAG, code, CSV, logs
  help        Show this help
  version     Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)      cmd_intro ;;
    textsplit)  cmd_textsplit ;;
    overlap)    cmd_overlap ;;
    semantic)   cmd_semantic ;;
    tokens)     cmd_tokens ;;
    fileupload) cmd_fileupload ;;
    streaming)  cmd_streaming ;;
    recipes)    cmd_recipes ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "chunk v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
