#!/usr/bin/env bash
# decompress — Archive & Compression Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Decompression Overview ===

Compression reduces data size by finding and eliminating redundancy.
Decompression reverses this process to restore the original data.

Key Concepts:
  Lossless     Original data perfectly reconstructed (text, code, data)
  Lossy        Approximate reconstruction (images, audio, video)
  Ratio        Compressed size / Original size (lower = better)
  Throughput   Speed of compression/decompression (MB/s)

Two Types of Formats:
  1. Compression-only: gzip, bzip2, xz, zstd, lz4, brotli
     - Compress a single stream of bytes
     - No file metadata, no directory structure
  2. Archive + Compression: tar.gz, zip, 7z, rar
     - Bundle multiple files with metadata
     - May include compression

Archive vs Compression:
  tar          Archive only (no compression)
  gzip         Compression only (single file)
  tar.gz       Archive + compression (tar then gzip)
  zip          Archive + compression (integrated)
  7z           Archive + compression (integrated, better ratio)

Historical Timeline:
  1977    LZ77 algorithm (foundation of most compressors)
  1978    LZ78 / LZW
  1992    gzip (GNU zip, based on DEFLATE)
  1996    bzip2 (Burrows-Wheeler transform)
  2001    7z format and LZMA algorithm
  2009    xz (LZMA2, successor to lzma)
  2011    LZ4 (extremely fast, lower ratio)
  2013    Brotli (Google, optimized for web)
  2016    Zstandard (Facebook, best speed/ratio balance)
EOF
}

cmd_formats() {
    cat << 'EOF'
=== Archive Format Comparison ===

tar (Tape Archive):
  Extension: .tar
  Compression: None (just bundles files)
  Preserves: permissions, ownership, symlinks, timestamps
  Streaming: Yes (can pipe, no random access)
  Max file size: Unlimited
  Usage: tar cf archive.tar files/

tar.gz / .tgz:
  Extension: .tar.gz, .tgz
  Compression: gzip (DEFLATE algorithm)
  Speed: Fast decompression (~300 MB/s)
  Ratio: Moderate (~3:1 for text)
  Usage: tar xzf archive.tar.gz

tar.bz2:
  Extension: .tar.bz2, .tbz2
  Compression: bzip2 (BWT + Huffman)
  Speed: Slow decompression (~50 MB/s)
  Ratio: Better than gzip (~4:1 for text)
  Usage: tar xjf archive.tar.bz2

tar.xz:
  Extension: .tar.xz, .txz
  Compression: xz (LZMA2)
  Speed: Slow decompression (~100 MB/s)
  Ratio: Excellent (~5:1 for text)
  Usage: tar xJf archive.tar.xz

tar.zst:
  Extension: .tar.zst
  Compression: Zstandard
  Speed: Very fast decompression (~1000 MB/s)
  Ratio: Good (~3.5:1 for text)
  Usage: tar --zstd -xf archive.tar.zst

zip:
  Extension: .zip
  Compression: DEFLATE (per-file)
  Random access: Yes (can extract single files)
  Cross-platform: Universal support
  Max file: 4GB (zip32), unlimited (zip64)
  Encryption: AES-256 (with -e)
  Usage: unzip archive.zip

7z:
  Extension: .7z
  Compression: LZMA/LZMA2 (best ratio)
  Ratio: ~5-7:1 for text
  Solid archive: Yes (files compressed together)
  Encryption: AES-256
  Usage: 7z x archive.7z

rar:
  Extension: .rar
  Compression: Proprietary
  Features: Recovery records, multi-volume
  Ratio: Similar to 7z
  Usage: unrar x archive.rar
  Note: RAR creation requires paid license
EOF
}

cmd_algorithms() {
    cat << 'EOF'
=== Compression Algorithms ===

gzip / DEFLATE:
  Type: LZ77 + Huffman coding
  Levels: 1 (fast) to 9 (best ratio)
  Decompress: ~300 MB/s
  Ratio: ~3:1 (text)
  Use: General purpose, HTTP content encoding
  Tools: gzip, gunzip, zlib, pigz (parallel)

bzip2:
  Type: Burrows-Wheeler Transform + Huffman
  Levels: 1-9 (block size 100K-900K)
  Decompress: ~50 MB/s
  Ratio: ~4:1 (text), great for repetitive data
  Use: Source code distribution
  Tools: bzip2, bunzip2, pbzip2 (parallel)

xz / LZMA2:
  Type: LZ77 + range coding + filters
  Levels: 0-9 (+ extreme: -9e)
  Decompress: ~100 MB/s
  Ratio: ~5:1 (text)
  Use: Software distribution (Linux packages)
  Tools: xz, unxz, pixz (parallel)
  Memory: High (up to 1.5GB for -9)

Zstandard (zstd):
  Type: LZ77 + FSE (Finite State Entropy)
  Levels: 1-19 (+ ultra: 20-22)
  Decompress: ~1000 MB/s (nearly always fast)
  Ratio: ~3.5:1 (text, level 3)
  Use: Best general-purpose choice (2020s)
  Tools: zstd, unzstd
  Features: Dictionary compression, streaming

LZ4:
  Type: LZ77 variant (simplest)
  Levels: 1-12
  Decompress: ~3000 MB/s (fastest)
  Ratio: ~2:1 (text)
  Use: Real-time compression, databases, filesystems
  Tools: lz4, unlz4
  Note: Optimized for speed over ratio

Brotli:
  Type: LZ77 + Huffman + context modeling
  Levels: 0-11
  Decompress: ~400 MB/s
  Ratio: ~4:1 (text), ~20% better than gzip for web
  Use: HTTP content encoding (web assets)
  Tools: brotli, unbrotli
  Note: Built into all modern browsers

Summary (text files, single-threaded):
  Algorithm    Compress    Decompress    Ratio
  lz4          ~500 MB/s   ~3000 MB/s    2.1:1
  zstd -1      ~400 MB/s   ~1000 MB/s    2.9:1
  gzip -6      ~30 MB/s    ~300 MB/s     3.1:1
  zstd -19     ~3 MB/s     ~900 MB/s     4.0:1
  brotli -11   ~1 MB/s     ~400 MB/s     4.2:1
  xz -9        ~2 MB/s     ~100 MB/s     5.0:1
EOF
}

cmd_extract() {
    cat << 'EOF'
=== Extraction Commands ===

tar variants:
  tar xf archive.tar              # Plain tar
  tar xzf archive.tar.gz          # gzip
  tar xjf archive.tar.bz2         # bzip2
  tar xJf archive.tar.xz          # xz
  tar --zstd -xf archive.tar.zst  # zstd
  tar --lz4 -xf archive.tar.lz4   # lz4

  # Extract to specific directory
  tar xzf archive.tar.gz -C /dest/

  # Extract specific files
  tar xzf archive.tar.gz path/to/file.txt

  # List contents without extracting
  tar tzf archive.tar.gz

  # Extract with verbose output
  tar xzvf archive.tar.gz

zip:
  unzip archive.zip                    # Extract all
  unzip archive.zip -d /dest/          # Extract to directory
  unzip -l archive.zip                 # List contents
  unzip archive.zip "*.txt"            # Extract matching files
  unzip -o archive.zip                 # Overwrite without prompt
  unzip -p archive.zip file.txt        # Extract to stdout

7z:
  7z x archive.7z                      # Extract with paths
  7z e archive.7z                      # Extract flat (no paths)
  7z x archive.7z -o/dest/             # Extract to directory
  7z l archive.7z                      # List contents
  7z t archive.7z                      # Test integrity

rar:
  unrar x archive.rar                  # Extract with paths
  unrar e archive.rar                  # Extract flat
  unrar l archive.rar                  # List contents
  unrar t archive.rar                  # Test integrity

Single-file compression:
  gunzip file.gz                       # Decompress (removes .gz)
  gzip -dk file.gz                     # Decompress, keep original
  bunzip2 file.bz2                     # Decompress bzip2
  unxz file.xz                        # Decompress xz
  zstd -d file.zst                     # Decompress zstd
  lz4 -d file.lz4 file                # Decompress lz4
  brotli -d file.br                    # Decompress brotli

  # Decompress to stdout (pipe-friendly)
  zcat file.gz | head
  bzcat file.bz2 | wc -l
  xzcat file.xz | grep pattern
  zstdcat file.zst | awk '{print $1}'

Universal extractor:
  # Auto-detect format
  atool -x archive.any              # requires atool package
  dtrx archive.any                  # intelligent extractor
  unar archive.any                  # macOS/Linux universal
EOF
}

cmd_streaming() {
    cat << 'EOF'
=== Streaming Decompression ===

Pipe-Based Extraction:
  # Decompress and process without temp files
  curl -sL https://example.com/data.tar.gz | tar xz -C /dest/

  # Download and extract specific file
  curl -sL url/archive.tar.gz | tar xzO path/to/file.txt

  # Decompress, filter, recompress
  zcat input.gz | grep "ERROR" | gzip > errors.gz

  # Process compressed log files
  zcat access.log.gz | awk '{print $1}' | sort | uniq -c | sort -rn

Network Transfer with Compression:
  # Send directory over network (tar + compression + ssh)
  tar czf - /data/ | ssh user@host 'tar xzf - -C /dest/'

  # With progress bar
  tar cf - /data/ | pv | ssh user@host 'tar xf - -C /dest/'

  # With zstd (faster than gzip)
  tar cf - /data/ | zstd | ssh user@host 'zstd -d | tar xf - -C /dest/'

  # Parallel compression over network
  tar cf - /data/ | pigz -p4 | ssh user@host 'pigz -d | tar xf - -C /dest/'

Multi-Stream Processing:
  # Process multiple compressed files as one stream
  zcat *.gz | sort -u > combined.txt

  # Parallel decompression of multiple files
  parallel 'zcat {} > {.}' ::: *.gz

  # Decompress and split
  zcat huge.csv.gz | split -l 1000000 - chunk_

Compressed File Operations (without full extraction):
  # Search inside compressed files
  zgrep "pattern" file.gz
  bzgrep "pattern" file.bz2
  xzgrep "pattern" file.xz

  # View compressed file contents
  zless file.gz
  bzless file.bz2
  xzless file.xz

  # Compare compressed files
  zdiff file1.gz file2.gz
EOF
}

cmd_recovery() {
    cat << 'EOF'
=== Archive Recovery ===

Detecting Corruption:
  # Test archive integrity
  gzip -t file.gz                    # Returns 0 if OK
  bzip2 -t file.bz2
  xz -t file.xz
  7z t archive.7z
  unzip -t archive.zip
  unrar t archive.rar

  # Check file type / magic bytes
  file archive.unknown
  xxd archive.unknown | head -5

gzip Recovery:
  # gzip stores data in blocks — partial recovery possible
  # If file is truncated, try extracting what's available
  gzip -d < corrupt.gz > recovered.data 2>/dev/null || true

  # Use gzrecover for damaged gzip files
  gzrecover corrupt.gz
  # Outputs: corrupt.gz.recovered

bzip2 Recovery:
  # bzip2recover splits into recoverable blocks
  bzip2recover corrupt.bz2
  # Outputs: rec00001corrupt.bz2, rec00002corrupt.bz2, ...
  # Try decompressing each recovered block:
  for f in rec*corrupt.bz2; do bzip2 -d "$f" 2>/dev/null || true; done

zip Recovery:
  # zip -FF tries to fix structure
  zip -FF corrupt.zip --out fixed.zip
  # Then try extracting
  unzip fixed.zip

  # jar (same format as zip) can also help
  jar xf corrupt.zip 2>/dev/null || true

7z Recovery:
  # 7z can sometimes extract from damaged archives
  7z x -y damaged.7z
  # Try different extraction modes
  7z e damaged.7z    # Flat extract, may recover more

RAR Recovery:
  # RAR supports recovery records (if created with -rr)
  unrar r corrupt.rar
  # Repair and extract
  rar r corrupt.rar

tar Recovery:
  # tar is a linear format — can recover everything before corruption
  tar xf corrupt.tar 2>/dev/null || true
  # List what's in there
  tar tf corrupt.tar 2>/dev/null

Prevention:
  - Always verify after creation: tar tzf, unzip -t, 7z t
  - Create checksums: sha256sum archive > archive.sha256
  - Use PAR2 parity files for critical archives
  - RAR recovery records (-rr5 adds 5% recovery data)
  - Store multiple copies on different media
EOF
}

cmd_performance() {
    cat << 'EOF'
=== Decompression Performance ===

Benchmark Reference (1GB text file, single core):

Algorithm      Compress    Decompress    Ratio    Notes
─────────────────────────────────────────────────────────
lz4 -1         680 MB/s    4200 MB/s     2.1:1    Fastest overall
lz4 -9         100 MB/s    4100 MB/s     2.4:1    Better ratio, still fast
zstd -1        510 MB/s    1400 MB/s     2.9:1    Great balance
zstd -3        300 MB/s    1200 MB/s     3.2:1    Default level
zstd -19       3 MB/s      1100 MB/s     4.0:1    Max practical ratio
gzip -1        100 MB/s    400 MB/s      2.8:1    Fast gzip
gzip -6        30 MB/s     350 MB/s      3.2:1    Default gzip
gzip -9        10 MB/s     340 MB/s      3.3:1    Diminishing returns
pigz -6        200 MB/s    1200 MB/s     3.2:1    Parallel gzip (8 cores)
brotli -1      380 MB/s    450 MB/s      2.9:1    Fast brotli
brotli -11     1 MB/s      400 MB/s      4.3:1    Best web ratio
bzip2 -9       15 MB/s     45 MB/s       4.1:1    Slow but good ratio
pbzip2 -9      100 MB/s    300 MB/s      4.1:1    Parallel bzip2
xz -1          15 MB/s     120 MB/s      3.8:1    Fast xz
xz -6          3 MB/s      100 MB/s      5.0:1    Default xz
xz -9e         1 MB/s      95 MB/s       5.2:1    Extreme mode

Memory Usage (decompression):
  lz4        ~64 KB
  zstd       ~128 KB (adjustable)
  gzip       ~32 KB
  brotli     ~400 KB
  bzip2      ~3.5 MB
  xz         ~65 MB (can go to 1.5GB for -9)

Parallel Tools:
  pigz       Parallel gzip (uses all cores)
  pbzip2     Parallel bzip2
  pixz       Parallel xz
  pzstd      Parallel zstd
  plzip      Parallel lzip

Recommendations:
  General purpose:  zstd (best speed/ratio balance)
  Maximum speed:    lz4 (databases, caching)
  Maximum ratio:    xz or 7z (archival, distribution)
  Web assets:       brotli (20% smaller than gzip)
  Compatibility:    gzip (universally supported)
  Large archives:   zstd --long (better for large windows)
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== Decompression Safety Checklist ===

Before Extracting:
  [ ] Verify file type matches extension (file archive.tar.gz)
  [ ] Check archive integrity (tar -tf, unzip -t, 7z t)
  [ ] Verify checksum if provided (sha256sum -c archive.sha256)
  [ ] Check available disk space (may expand 5-10x)
  [ ] Extract to a dedicated directory, not current dir

Zip Bomb Detection:
  [ ] Check compression ratio (>100:1 is suspicious)
  [ ] Check reported uncompressed size before extracting
      unzip -l archive.zip | tail -1  (total size)
  [ ] Use limits: ulimit -f 1048576 (limit file size to 1GB)
  [ ] Nested archives: check for .zip inside .zip

Path Traversal Protection:
  [ ] Check for "../" in archive paths
      tar -tzf archive.tar.gz | grep '\.\.'
      unzip -l archive.zip | grep '\.\.'
  [ ] Use --strip-components with tar to flatten paths
  [ ] Extract to isolated directory, then move needed files
  [ ] Modern tar (GNU 2.0+) blocks absolute paths by default

Symlink Attacks:
  [ ] Check for symlinks pointing outside extraction dir
      tar -tzf archive.tar.gz | grep ^l
  [ ] Use --no-same-permissions on untrusted archives
  [ ] Don't extract untrusted archives as root

Post-Extraction:
  [ ] Verify file count matches expected
  [ ] Check extracted file permissions (no setuid surprises)
  [ ] Scan for executable files in unexpected locations
  [ ] Validate extracted data format/content

Best Practices:
  [ ] Always extract untrusted archives in sandbox/container
  [ ] Use bsdtar over GNU tar for untrusted archives (safer defaults)
  [ ] Set extraction size limits (--totals, ulimit)
  [ ] Log extraction operations for audit trail
  [ ] Delete archives after verified extraction to save space
EOF
}

show_help() {
    cat << EOF
decompress v$VERSION — Archive & Compression Reference

Usage: script.sh <command>

Commands:
  intro        Compression/decompression overview and terminology
  formats      Archive format comparison — tar, zip, 7z, rar
  algorithms   Compression algorithms — gzip, zstd, lz4, brotli, xz
  extract      Extraction commands for every common format
  streaming    Streaming decompression — pipes and network transfers
  recovery     Recovering data from corrupted archives
  performance  Speed vs ratio benchmarks by algorithm
  checklist    Decompression safety — zip bombs, path traversal
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)       cmd_intro ;;
    formats)     cmd_formats ;;
    algorithms)  cmd_algorithms ;;
    extract)     cmd_extract ;;
    streaming)   cmd_streaming ;;
    recovery)    cmd_recovery ;;
    performance) cmd_performance ;;
    checklist)   cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "decompress v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
