#!/usr/bin/env bash
# pad — Data Padding Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Data Padding ===

Padding is the process of adding extra data to a message or data
structure to meet size requirements. It appears everywhere in computing:
cryptography, memory alignment, network protocols, and display formatting.

Why Padding Is Needed:
  Cryptography:  block ciphers require fixed-size blocks (AES = 16 bytes)
  Memory:        CPU requires aligned data (4/8/16-byte boundaries)
  Network:       protocols require fixed-size frames or alignment
  Display:       formatting text to fixed-width columns
  Signal:        FFT requires power-of-2 sample lengths

Categories:
  Deterministic:    padding value is predictable (PKCS#7, zero-pad)
  Random:           padding includes random bytes (ISO 10126)
  Semantic:         padding carries meaning (OAEP includes hash)
  Structural:       padding for alignment (struct packing)
  Cosmetic:         padding for display (printf formatting)

Key Properties of Good Padding:
  Unambiguous:      can distinguish padding from data
  Reversible:       can remove padding correctly
  Secure:           doesn't leak information (no oracle)
  Efficient:        minimal overhead
  Standard:         interoperable across implementations

Common Padding Sizes:
  AES block:        16 bytes
  DES block:        8 bytes
  SHA-256 block:    64 bytes
  Ethernet minimum: 64 bytes (46 bytes payload)
  Memory word:      4 bytes (32-bit) or 8 bytes (64-bit)
  Disk sector:      512 bytes
  Page:             4096 bytes
EOF
}

cmd_crypto() {
    cat << 'EOF'
=== Cryptographic Padding Schemes ===

PKCS#7 (RFC 5652) — Most Common:
  Each padding byte = number of padding bytes added
  Block size: N bytes (1-255)
  
  Plaintext length mod N = remainder
  Padding = N - remainder bytes, each with value (N - remainder)
  If plaintext is already aligned: add full block of padding
  
  Examples (16-byte block / AES):
    "Hello" (5 bytes) → pad 11 bytes: 0B 0B 0B 0B 0B 0B 0B 0B 0B 0B 0B
    15 bytes → pad 1 byte: 01
    16 bytes → pad 16 bytes: 10 10 10 10 ... (full extra block)
  
  Removing: read last byte value N, verify last N bytes all equal N
  If verification fails → padding error (potential oracle!)

PKCS#5:
  Identical to PKCS#7 but specified for 8-byte blocks only (DES)
  In practice, PKCS#5 and PKCS#7 are used interchangeably

ISO 10126 (Withdrawn but still used):
  Random bytes for padding, last byte = padding length
  Example: "Hello" + [random × 10] + 0B
  Advantage: padding doesn't reveal data length patterns
  Disadvantage: non-deterministic (same plaintext → different ciphertext)

ANSI X.923:
  Zero bytes for padding, last byte = padding length
  Example: "Hello" + [00 × 10] + 0B
  Similar to PKCS#7 but uses zeros instead of length-value

Zero Padding (ISO 10118):
  Append zeros until block boundary
  Simple but AMBIGUOUS: can't distinguish padding from trailing zeros
  Not recommended for general use
  Used in: some hash functions, signal processing

Bit Padding (ISO/IEC 9797-1, Method 2):
  Append a 1 bit, then zeros to fill the block
  Byte-level: append 0x80, then 0x00 bytes
  Example: "Hello" → 48 65 6C 6C 6F 80 00 00 00 00 00 00 00 00 00 00
  Used in: SHA family hash functions
  Unambiguous: the 0x80 byte marks start of padding

CTS (Ciphertext Stealing):
  Not really padding — avoids the need for padding entirely
  Steals bytes from previous ciphertext block
  Output size = input size (no expansion)
  More complex to implement, less common
  Used in: Kerberos, some disk encryption

No Padding (CTR/GCM modes):
  Stream cipher modes don't need padding
  AES-CTR, AES-GCM, ChaCha20 operate on arbitrary lengths
  Modern best practice: use authenticated stream modes → no padding needed
EOF
}

cmd_oaep() {
    cat << 'EOF'
=== Asymmetric Padding (RSA) ===

Why RSA Needs Padding:
  Raw/textbook RSA: C = M^e mod n
  Without padding, RSA is deterministic (same M → same C)
  Vulnerable to: chosen plaintext, related message attacks
  Padding adds randomness and structure

PKCS#1 v1.5 (Older, Vulnerable):
  Format: 0x00 || 0x02 || [random non-zero bytes] || 0x00 || message
  
  Random bytes: at least 8 bytes
  Total length = key size (e.g., 256 bytes for RSA-2048)
  Max message = key_bytes - 11 (245 bytes for RSA-2048)
  
  VULNERABILITY: Bleichenbacher's attack (1998)
    Adaptive chosen ciphertext attack
    Server reveals if padding is valid → oracle
    ~1 million queries to decrypt message
    Still affects TLS implementations if not careful

OAEP (Optimal Asymmetric Encryption Padding):
  RSA-OAEP (PKCS#1 v2.x, RFC 8017)
  Uses hash function and mask generation function (MGF1)
  
  Process:
    1. Generate random seed (hash length bytes)
    2. Create data block: hash(label) || padding || 0x01 || message
    3. dbMask = MGF1(seed, db_length)
    4. maskedDB = db XOR dbMask
    5. seedMask = MGF1(maskedDB, seed_length)
    6. maskedSeed = seed XOR seedMask
    7. Encoded: 0x00 || maskedSeed || maskedDB
    
  Security:
    Provably secure in random oracle model
    IND-CCA2 secure (strongest notion)
    Randomized: same plaintext → different ciphertext every time
    
  Max message length:
    key_bytes - 2*hash_bytes - 2
    RSA-2048 with SHA-256: 256 - 64 - 2 = 190 bytes

PSS (Probabilistic Signature Scheme):
  Padding for RSA signatures (not encryption)
  RSA-PSS (PKCS#1 v2.1)
  
  Uses: random salt, hash, MGF1
  Provably secure (better than PKCS#1 v1.5 signatures)
  Required by: TLS 1.3, modern standards
  Salt length: typically = hash length (32 bytes for SHA-256)

Best Practices:
  Encryption: always use RSA-OAEP (never PKCS#1 v1.5)
  Signatures: always use RSA-PSS (never PKCS#1 v1.5)
  Better yet: use ECDSA/Ed25519 for signatures, ECDH for key exchange
  RSA key size: minimum 2048 bits, prefer 4096
EOF
}

cmd_oracle() {
    cat << 'EOF'
=== Padding Oracle Attacks ===

What Is a Padding Oracle?
  A system that reveals whether decrypted ciphertext has valid padding
  Feedback can be: error message, timing difference, HTTP status code
  Even a 1-bit leak (valid/invalid) is enough to decrypt everything

How CBC Padding Oracle Works:
  CBC decryption: P[i] = Dec(C[i]) XOR C[i-1]
  
  Attacker controls C[i-1] (previous ciphertext block)
  By modifying C[i-1], attacker changes decrypted plaintext
  
  To find last byte of P[i]:
    For each guess g (0x00 to 0xFF):
      Modify C[i-1] last byte so decrypted last byte = 0x01 (valid PKCS#7)
      C'[i-1][last] = C[i-1][last] XOR g XOR 0x01
      Send modified ciphertext to server
      If server says "valid padding" → g = real plaintext byte
    
    Then find second-to-last byte:
      Set last byte to decrypt to 0x02 (PKCS#7 for 2 bytes padding)
      Try all 256 values for second-to-last byte
    
  Total queries: 256 × block_size × number_of_blocks
  For AES-CBC: ~4096 queries per block (256 × 16)

Famous Exploits:
  ASP.NET Padding Oracle (2010):
    Custom error pages revealed padding validity
    Could decrypt ViewState, forge authentication tokens
    CVE-2010-3332

  POODLE Attack (2014):
    SSL 3.0 CBC padding not verified properly
    Forced downgrade attack + padding oracle
    Led to SSL 3.0 deprecation

  Lucky Thirteen (2013):
    Timing side-channel in TLS CBC MAC verification
    Different processing time for valid vs invalid padding
    Affected OpenSSL, GnuTLS, NSS

Prevention:
  1. Use authenticated encryption (AES-GCM, ChaCha20-Poly1305)
     No padding needed, tamper detection built in
     
  2. If using CBC: MAC-then-Encrypt → Encrypt-then-MAC
     Verify MAC before attempting decryption
     Invalid MAC → reject (never reach padding check)
     
  3. Constant-time padding verification
     Always check all padding bytes, same execution time
     Don't short-circuit on first invalid byte
     
  4. Generic error messages
     Never distinguish "bad padding" from "bad MAC"
     Return same error for any decryption failure
     
  5. Modern TLS (1.2+) mandates specific countermeasures
     TLS 1.3: removes CBC entirely, only AEAD ciphers
EOF
}

cmd_binary() {
    cat << 'EOF'
=== Binary Alignment Padding ===

CPU Data Alignment:
  CPUs access memory most efficiently at aligned addresses
  Aligned: address is multiple of data size
  
  Type        Size    Aligned at
  ────────────────────────────────
  char         1      any address
  short        2      even addresses (0, 2, 4, ...)
  int          4      multiple of 4 (0, 4, 8, ...)
  long/ptr     8      multiple of 8 (0, 8, 16, ...)
  __m128      16      multiple of 16
  __m256      32      multiple of 32

  Misaligned access:
    x86: works but slower (extra memory transactions)
    ARM: bus error / SIGBUS (strict alignment required)
    MIPS: trap on misaligned access

Struct Padding (C/C++):
  Compiler inserts padding to align members

  struct Example {
    char a;    // offset 0, size 1
    // 3 bytes padding (align int to 4)
    int b;     // offset 4, size 4
    char c;    // offset 8, size 1
    // 7 bytes padding (align double to 8)
    double d;  // offset 16, size 8
  };
  // sizeof = 24 (not 14!)

  Optimization: order members by decreasing size
  struct Optimized {
    double d;  // offset 0, size 8
    int b;     // offset 8, size 4
    char a;    // offset 12, size 1
    char c;    // offset 13, size 1
    // 2 bytes trailing padding (struct alignment = 8)
  };
  // sizeof = 16 (saved 8 bytes!)

  Struct alignment = alignment of largest member
  Trailing padding: round up to struct alignment

Packing Directives:
  #pragma pack(1)    // no padding (max portability risk)
  __attribute__((packed))  // GCC: pack this struct
  
  When to pack:
    - Network protocol headers (exact layout needed)
    - File format structures (match specification)
    - Hardware register maps
  
  Cost: misaligned access penalties, non-portable

Cache Line Padding:
  Cache line: typically 64 bytes
  False sharing: two threads modify variables on same cache line
  Fix: pad to cache line boundary between variables
  
  alignas(64) int counter_thread1;
  alignas(64) int counter_thread2;
  // Each on its own cache line → no false sharing

Page Alignment:
  Memory pages: typically 4096 bytes
  Huge pages: 2 MB or 1 GB
  mmap, DMA buffers often require page alignment
  posix_memalign(ptr, 4096, size)
EOF
}

cmd_network() {
    cat << 'EOF'
=== Network Protocol Padding ===

Ethernet Frame Padding:
  Minimum frame size: 64 bytes (on wire)
  Minimum payload: 46 bytes (after header/FCS)
  Short frames padded with zeros to reach minimum
  
  Example: 20-byte payload
    14 (Ethernet header) + 20 (data) + 26 (padding) + 4 (FCS) = 64
  
  Why minimum size?
    Collision detection in CSMA/CD requires minimum frame duration
    Too short → transmitter finishes before collision detected

IP Header Padding:
  IP options must be padded to 4-byte boundary
  IHL (Internet Header Length) is in 4-byte units
  Padding uses 0x00 (NOP) or End-of-Options (0x00)

TCP Header Padding:
  TCP options must be padded to 4-byte boundary
  Data offset field is in 4-byte units
  NOP (0x01) used for alignment between options
  End-of-Options (0x00) followed by zero padding

TLS Record Padding:
  TLS 1.2 (CBC mode):
    Padding for block cipher alignment
    Padding bytes = padding length repeated
    Similar to PKCS#7 but length in last byte is (length - 1)
    Example: 3 bytes padding → 02 02 02
    Subject to padding oracle attacks!
  
  TLS 1.3:
    Record padding: arbitrary zeros after content
    Content type moved inside encrypted record
    Padding hides true content length (traffic analysis defense)
    Receiver strips trailing zeros to find content type byte

SSH Padding:
  SSH packets padded to block cipher boundary (8 or 16 bytes)
  Minimum 4 bytes of padding
  Padding bytes should be random
  packet_length || padding_length || payload || random_padding || MAC

DNS Message Padding (RFC 7830):
  EDNS(0) padding option
  Pad DNS-over-TLS queries to fixed size (128 or 468 bytes)
  Prevents traffic analysis of DNS queries by length

QUIC Padding:
  PADDING frames (type 0x00): single zero byte each
  Initial packets padded to 1200 bytes minimum
  Prevents amplification attacks
  Also used for path MTU discovery

HTTP/2 PADDING:
  DATA and HEADERS frames can include padding
  Padding length field + padding bytes
  Mitigates length-based traffic analysis
  Rarely used in practice (browser/server support varies)
EOF
}

cmd_string() {
    cat << 'EOF'
=== String Padding Techniques ===

Left Padding (Right-Aligned):
  Pad string on the left to reach target length
  Common use: numeric formatting, fixed-width columns
  
  "42".padStart(5)       → "   42"
  "42".padStart(5, '0')  → "00042"
  "7".padStart(2, '0')   → "07"  (hours, months)

Right Padding (Left-Aligned):
  Pad string on the right to reach target length
  Common use: text columns, labels in tables
  
  "Name".padEnd(20)        → "Name                "
  "Price".padEnd(10, '.')  → "Price....."

Center Padding:
  Pad both sides equally (visual centering)
  
  Python: "Title".center(20)     → "       Title        "
  Python: "Title".center(20, '-') → "-------Title--------"

Zero-Fill (Numeric):
  Pad numbers with leading zeros for fixed width
  
  JavaScript: String(42).padStart(6, '0')  → "000042"
  Python:     f"{42:06d}"                  → "000042"
  C:          printf("%06d", 42)           → "000042"
  SQL:        LPAD(42, 6, '0')             → "000042"

  Common uses:
    Invoice numbers:   INV-000042
    Timestamps:        2024-01-07T09:05:03
    File sequencing:   frame_0001.png
    ZIP/postal codes:  01234

Fixed-Width Record Formatting:
  Mainframe/COBOL legacy systems use fixed-width records
  Each field padded to exact width
  
  Name (20 chars) | Age (3) | Amount (10)
  "John Smith          " | "042" | "0000012345"
  
  Delimiters not needed — field positions are fixed
  Used in: EDI, ACH banking, government data files

Language Implementations:
  JavaScript:
    str.padStart(targetLength, padString)
    str.padEnd(targetLength, padString)
  
  Python:
    str.ljust(width, fillchar)  # right-pad
    str.rjust(width, fillchar)  # left-pad
    str.center(width, fillchar) # center
    str.zfill(width)            # zero-fill
  
  Go:
    fmt.Sprintf("%-20s", str)   # right-pad
    fmt.Sprintf("%20s", str)    # left-pad
    fmt.Sprintf("%06d", num)    # zero-fill
  
  SQL:
    LPAD(str, length, pad_char)
    RPAD(str, length, pad_char)

The left-pad Incident (2016):
  npm package "left-pad" (11 lines of code) was unpublished
  Broke thousands of packages depending on it (including Babel)
  Led to npm policy change: can't unpublish after 24 hours
  Lesson: don't depend on trivial packages; use built-in methods
  JavaScript added padStart/padEnd to String.prototype (ES2017)
EOF
}

cmd_audio() {
    cat << 'EOF'
=== Audio & Signal Padding ===

Zero-Padding for FFT:
  FFT requires input length = power of 2 (radix-2)
  Or: specific lengths for mixed-radix FFT
  
  Pad signal with zeros to next power of 2:
    500 samples → pad to 512 (add 12 zeros)
    1000 samples → pad to 1024 (add 24 zeros)
  
  Effect on spectrum:
    More points in frequency domain (interpolation)
    Does NOT increase frequency resolution (that needs more data)
    Smoother-looking spectrum (reduced picket fence effect)
    
  Common padding ratios:
    2× : double the length (common default)
    4× : smoother spectral display
    8× : very smooth (diminishing returns beyond this)

Overlap-Add / Overlap-Save:
  Convolution via FFT requires padding to prevent circular artifacts
  
  Overlap-Add:
    Each block: pad signal block + filter to combined length
    FFT, multiply, IFFT, overlap and add output blocks
    Padding: signal block (N) + filter (M) - 1 → N+M-1 samples
  
  Overlap-Save:
    Input blocks overlap by M-1 samples
    Discard first M-1 output samples per block (circular artifacts)
    No zero-padding of data needed, but FFT size must accommodate

Sample Rate Conversion:
  Upsampling: insert L-1 zeros between samples (zero-stuffing)
  Then filter to remove imaging artifacts
  Example: 44.1 kHz → 176.4 kHz (4× upsample)
    Insert 3 zeros between each sample
    Low-pass filter at original Nyquist frequency

Audio Buffer Alignment:
  Audio hardware processes in fixed-size buffers
  Common sizes: 64, 128, 256, 512, 1024, 2048, 4096 samples
  Last buffer padded with silence (zeros) if audio is shorter
  
  Latency tradeoff:
    Small buffer: low latency, more CPU overhead, higher chance of glitches
    Large buffer: high latency, less CPU overhead, stable playback

WAV File Padding:
  WAV chunks must be word-aligned (2-byte boundary)
  Odd-length data chunks get 1 byte of zero padding
  The padding byte is NOT included in the chunk size field
  
  RIFF alignment: some implementations require 4-byte alignment
  This is a common source of WAV parsing bugs

Codec Frame Padding:
  MP3: frames are fixed size (1152 samples at specific bitrate)
  AAC: frames are 1024 or 960 samples
  Opus: frames are 2.5, 5, 10, 20, 40, or 60 ms
  
  Last frame: padded with silence to complete the frame
  Encoder may signal "encoder delay" for gapless playback
  Gapless playback: decoder trims padding from first/last frames
EOF
}

show_help() {
    cat << EOF
pad v$VERSION — Data Padding Reference

Usage: script.sh <command>

Commands:
  intro       Padding overview — categories, properties, common sizes
  crypto      Cryptographic padding: PKCS#7, ISO 10126, zero, bit
  oaep        RSA padding: OAEP, PSS, PKCS#1 v1.5 vulnerabilities
  oracle      Padding oracle attacks — CBC exploit, prevention
  binary      Binary alignment: struct padding, cache lines, packing
  network     Network padding: Ethernet, TLS, SSH, DNS, QUIC
  string      String padding: left/right, zero-fill, formatting
  audio       Signal padding: FFT zero-pad, overlap-add, codecs
  help        Show this help
  version     Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)   cmd_intro ;;
    crypto)  cmd_crypto ;;
    oaep)    cmd_oaep ;;
    oracle)  cmd_oracle ;;
    binary)  cmd_binary ;;
    network) cmd_network ;;
    string)  cmd_string ;;
    audio)   cmd_audio ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "pad v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
