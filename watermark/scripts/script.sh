#!/usr/bin/env bash
# watermark — Watermarking Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Watermarking Overview ===

A watermark is an identifying pattern embedded in content
(images, documents, audio, video) for ownership, tracking,
or authenticity verification.

TYPES OF WATERMARKS:

  Visible Watermarks:
    Human-eye detectable overlays on content
    Purpose: deter unauthorized use, brand identification
    Examples: stock photo logos, draft stamps, company logos
    Trade-off: effective deterrent but degrades content quality

  Invisible (Digital) Watermarks:
    Hidden in content, undetectable by human eye/ear
    Purpose: tracking, authentication, forensic identification
    Examples: Digimarc, photo fingerprinting, audio watermarks
    Trade-off: doesn't deter (nobody knows it's there) but proves ownership

  Fragile Watermarks:
    Destroyed by any modification to the content
    Purpose: tamper detection (has this been altered?)
    Use: document integrity verification, medical images

  Robust Watermarks:
    Survive modifications (compression, cropping, printing)
    Purpose: persistent ownership marking
    Use: copyright protection, content tracking

HISTORY:
  1282  First paper watermarks in Italy (mold patterns in paper)
  1886  Photography watermarks (visible marks on prints)
  1954  Emil Hembrooke patents music watermarking
  1988  Komatsu & Tominaga publish first digital watermarking paper
  1996  Digimarc founded (commercial digital watermarking)
  2021  C2PA standard launched (Content Authenticity Initiative)
  2023  AI-generated content drives new watermarking urgency

USE CASES:
  Copyright protection     Prove ownership in disputes
  Content tracking         Identify source of leaks
  Broadcast monitoring     Verify ad placements aired
  Forensic analysis        Trace unauthorized distribution
  Authentication           Verify content hasn't been altered
  AI content marking       Label AI-generated images/text
EOF
}

cmd_visible() {
    cat << 'EOF'
=== Visible Watermarks ===

DESIGN PRINCIPLES:

  Opacity:
    Stock photos/previews: 30-50% opacity (clearly visible but shows content)
    Draft documents: 10-20% opacity (readable, clearly marked)
    Branding: 5-15% opacity (subtle, professional)

  Placement:
    Center:       Hardest to crop out, most intrusive
    Diagonal:     Covers most area, traditional stock photo approach
    Corner:       Easy to crop, but least intrusive
    Tiled/Repeated: Very hard to remove, covers entire image
    Best: Tiled at 20-30% opacity for protection with usability

  Size:
    Logo watermark: 10-30% of image width
    Text watermark: span 50-80% of image diagonally
    Tiled: individual marks at 15-20% of image width

  Content:
    Company logo (most common)
    "SAMPLE", "DRAFT", "CONFIDENTIAL" text
    Copyright notice "© 2024 Company Name"
    Username/email (for personalized leak tracking)

  Typography (text watermarks):
    Sans-serif fonts (clean, readable at low opacity)
    All caps for visibility
    Letter spacing increased for readability
    45° diagonal rotation (traditional stock photo)

TAMPER RESISTANCE:
  Easy to remove:    Single small corner logo
  Moderate:          Semi-transparent overlay, center placement
  Hard to remove:    Tiled pattern, complex background interaction
  Very hard:         Varied opacity following image texture

  Making removal harder:
    - Cross important image details (faces, key elements)
    - Vary opacity based on underlying content
    - Use semi-transparent patterns, not solid color
    - Embed at different scales
    - Don't use uniform spacing (harder to automate removal)

TOOLS:
  ImageMagick:  composite -dissolve 30% watermark.png photo.jpg output.jpg
  FFmpeg:       overlay filter for video watermarks
  Photoshop:    Layer with reduced opacity + blending modes
  Canvas API:   Browser-based watermarking (see 'web' command)
EOF
}

cmd_invisible() {
    cat << 'EOF'
=== Invisible (Digital) Watermarks ===

SPATIAL DOMAIN METHODS:

  LSB (Least Significant Bit):
    Replace least significant bit of pixel values with watermark data
    Example: pixel value 142 (10001110) → 143 (10001111)
    Capacity: 1 bit per channel per pixel (high)
    Robustness: very fragile (destroyed by JPEG compression)
    Use: tamper detection, steganography

  Patch-Based:
    Modify small image patches to encode data
    More robust than single-pixel LSB
    Detectable with statistical analysis

FREQUENCY DOMAIN METHODS:

  DCT (Discrete Cosine Transform):
    Embed watermark in DCT coefficients
    JPEG already uses DCT → naturally compatible
    Mid-frequency coefficients: balance visibility and robustness
    Low-freq modification: robust but visible
    High-freq modification: invisible but fragile

  DWT (Discrete Wavelet Transform):
    Multi-resolution embedding
    Different watermark in each frequency band
    More robust than DCT for geometric attacks
    Used in JPEG 2000 compatible watermarking

  DFT (Discrete Fourier Transform):
    Embed in magnitude of Fourier coefficients
    Rotation-invariant (survives image rotation)
    Good for print-scan attacks

SPREAD SPECTRUM:
  Spread watermark signal across wide frequency range
  Like CDMA in telecommunications
  Very robust: survives compression, noise, filtering
  Low capacity: few bits of information
  Detection requires original or known key

PROPERTIES TO EVALUATE:
  Imperceptibility  How invisible is the watermark?
  Robustness        Survives modifications? (compression, crop, print)
  Capacity          How much data can be embedded?
  Security          Can it be forged or detected without the key?
  Computational cost  How fast to embed/extract?

  Trade-offs:
    More robust → more visible (or lower capacity)
    More capacity → less robust (or more visible)
    More secure → more computational cost

COMMERCIAL SOLUTIONS:
  Digimarc         Industry leader, survives print/scan
  Steg.AI          AI-powered invisible watermarking
  TruePic          Photo/video authenticity verification
  Google SynthID   Watermark for AI-generated images
EOF
}

cmd_web() {
    cat << 'EOF'
=== Web Watermarking ===

CSS OVERLAY WATERMARK:

  .watermarked-container {
    position: relative;
    overflow: hidden;
  }

  .watermark-overlay {
    position: absolute;
    top: 0; left: 0;
    width: 100%; height: 100%;
    pointer-events: none;     /* Don't block clicks */
    z-index: 10;
    background: repeating-linear-gradient(
      -45deg,
      transparent,
      transparent 80px,
      rgba(0,0,0,0.03) 80px,
      rgba(0,0,0,0.03) 81px
    );
  }

  /* Text watermark via pseudo-element */
  .watermark-overlay::after {
    content: attr(data-watermark);
    position: absolute;
    top: 50%; left: 50%;
    transform: translate(-50%, -50%) rotate(-30deg);
    font-size: 48px;
    color: rgba(0, 0, 0, 0.08);
    white-space: nowrap;
    pointer-events: none;
    user-select: none;
  }

CANVAS-BASED WATERMARK:

  function addWatermark(canvas, text) {
    const ctx = canvas.getContext('2d');
    ctx.save();
    ctx.globalAlpha = 0.1;
    ctx.font = '24px Arial';
    ctx.fillStyle = '#000';
    ctx.translate(canvas.width/2, canvas.height/2);
    ctx.rotate(-Math.PI / 6);  // -30 degrees
    ctx.textAlign = 'center';
    // Tile across canvas
    for (let y = -canvas.height; y < canvas.height; y += 80) {
      for (let x = -canvas.width; x < canvas.width; x += 200) {
        ctx.fillText(text, x, y);
      }
    }
    ctx.restore();
  }

DOM MUTATION OBSERVER (anti-removal):

  // Prevent watermark removal via DevTools
  const observer = new MutationObserver((mutations) => {
    for (const mutation of mutations) {
      for (const node of mutation.removedNodes) {
        if (node.classList?.contains('watermark-overlay')) {
          mutation.target.appendChild(node);  // Re-add!
        }
      }
    }
  });
  observer.observe(container, { childList: true, subtree: true });

  ⚠️ Note: Determined users can always bypass client-side watermarks.
  True protection requires server-side watermarking before delivery.

ANTI-SCREENSHOT MEASURES:
  CSS: -webkit-user-select: none; (prevents text selection)
  JS: Disable right-click, block Ctrl+S (annoying, easily bypassed)
  Better: Serve lower resolution, watermarked versions for previews
          Deliver full quality only after purchase/auth

SERVER-SIDE WATERMARKING:
  Process images on the server before serving
  Sharp (Node.js): sharp(image).composite([{input: watermark}])
  Pillow (Python): Image.alpha_composite()
  ImageMagick: convert -composite
  CDN: Cloudinary, imgix have watermark transforms built-in
EOF
}

cmd_document() {
    cat << 'EOF'
=== Document Watermarking ===

PDF WATERMARKS:

  Text Watermark (most common):
    "CONFIDENTIAL", "DRAFT", "COPY"
    Diagonal across each page, low opacity
    Tools: Adobe Acrobat, PDFtk, pdf-lib (JS), PyPDF2

  Image Watermark:
    Company logo on each page
    Usually in corner or center, 5-15% opacity
    Can be added during PDF generation or post-processing

  Metadata Watermark:
    Hidden data in PDF metadata fields
    Custom properties with tracking info
    XMP metadata standard
    Easy to strip (not secure alone)

FORENSIC DOCUMENT TRACKING (Canary Trap):
  Distribute slightly different versions to different recipients
  If leaked, the unique version identifies the source

  Methods:
    - Different word choices (synonym substitution)
    - Invisible character variations (zero-width spaces)
    - Micro-typography differences (spacing, kerning)
    - Steganographic dots (yellow dots in color printers)
    - Unique watermark per recipient (name/ID embedded)

  Real-world examples:
    - Tesla leaker caught via unique PDF watermarks
    - Government agencies use per-recipient document variants
    - Movie screeners have invisible audience-specific watermarks

PRINT WATERMARKS:

  Machine Identification Code (MIC):
    Most color laser printers embed tiny yellow dots
    Encode: serial number, date, time
    Nearly invisible to naked eye
    Controversial: used by law enforcement to track documents
    Check: print solid blue page, examine under magnification

  Anti-Counterfeiting:
    Currency watermarks (visible when held to light)
    Security paper with embedded fibers
    Microprinting (text too small to photocopy clearly)
    Holographic elements

EMAIL TRACKING (forensic watermarks):
  Unique identifiers in email content per recipient
  Zero-width characters between words
  Unique link parameters
  Invisible pixel (tracking pixel) with unique URL

DOCUMENT CLASSIFICATION WATERMARKS:
  Classification levels:
    PUBLIC → no watermark needed
    INTERNAL → subtle "Internal Use Only" footer
    CONFIDENTIAL → diagonal watermark + header/footer
    SECRET → prominent watermark + per-page recipient ID
    TOP SECRET → all above + physical handling requirements
EOF
}

cmd_ai() {
    cat << 'EOF'
=== AI Content Watermarking ===

WHY AI WATERMARKING MATTERS:
  AI-generated images are indistinguishable from real photos
  Deepfakes threaten trust in media
  Regulations increasingly require disclosure of AI content
  Provenance tracking needed for accountability

C2PA (Coalition for Content Provenance and Authenticity):
  Standard: Signed metadata attached to content files
  What it records:
    - Who created the content (tool/person)
    - When it was created
    - How it was modified (editing history)
    - Whether AI was used in generation
  
  How it works:
    Content Credentials = cryptographically signed manifest
    Attached to JPEG, PNG, video files as metadata
    Verified via cr.verify tool or online checker
    Tamper-evident: modification invalidates signature

  Supporters: Adobe, Microsoft, Google, OpenAI, BBC, Nikon, Sony

GOOGLE SYNTHID:
  Embeds invisible watermark in AI-generated images
  Survives: compression, cropping, color adjustment
  Used in: Google Imagen, Gemini image generation
  Detection: Google's detector identifies SynthID-marked images

OPENAI DALL-E:
  C2PA metadata in generated images
  Visible metadata tag: "Created with AI"
  Metadata preserved in PNG, stripped in many social platforms

STABLE DIFFUSION:
  No built-in watermarking (open-source model)
  Community tools add watermarks:
    - invisible-watermark Python package
    - C2PA signing via c2patool
    - Custom LoRA watermarks in model output

TEXT WATERMARKING (LLM output):
  Statistical watermark in word choices (Kirchenbauer et al., 2023):
    - LLM biases token selection based on secret key
    - Imperceptible to humans
    - Detectable with statistical test
    - Survives paraphrasing (partially)

  Challenges:
    - Paraphrasing/rewriting can remove watermark
    - Short texts hard to watermark reliably
    - Quality may degrade slightly
    - Open models can be modified to remove watermarking

REGULATORY LANDSCAPE (2024-2025):
  EU AI Act:        AI-generated content must be labeled
  China:            AI content must be watermarked and labeled
  US Executive Order: Developing standards for AI content marking
  California:       Proposed AI transparency requirements
  Platforms:        Meta, Google, X adding "AI Generated" labels
EOF
}

cmd_attacks() {
    cat << 'EOF'
=== Watermark Attacks & Countermeasures ===

REMOVAL ATTACKS:

  Cropping:
    Cut out the watermarked area
    Countermeasure: tile watermark across entire content
    Countermeasure: embed in every region independently

  Filtering/Blurring:
    Apply blur, median filter, or noise to destroy watermark
    Countermeasure: embed in robust frequency bands
    Countermeasure: use robust spread-spectrum methods

  JPEG Compression:
    Recompress at lower quality → destroys fragile watermarks
    Countermeasure: embed in DCT coefficients that survive compression
    Countermeasure: test robustness at quality 50-70%

  Screenshot/Re-digitization:
    Screenshot the content → new, clean image
    Countermeasure: visible watermarks (survive re-capture)
    Countermeasure: frequency-domain watermarks in perceptual space

  AI Inpainting:
    Use AI to detect and remove visible watermarks
    Tools: Stable Diffusion inpainting, DALL-E edit, Photoshop AI fill
    Countermeasure: non-uniform watermarks that are hard to detect
    Countermeasure: combine visible + invisible watermarks

  Format Conversion:
    Convert between formats to strip metadata
    PNG → JPEG → WebP → PNG (metadata lost)
    Countermeasure: embed in pixel data, not just metadata
    Countermeasure: use C2PA with re-signing on each conversion

GEOMETRIC ATTACKS:
  Rotation, scaling, translation, shearing
  Countermeasure: DFT-domain embedding (rotation invariant)
  Countermeasure: template-based synchronization marks

COLLUSION ATTACKS:
  Multiple users compare their uniquely watermarked copies
  Average/difference reveals watermark pattern
  With enough copies, watermark can be estimated and removed
  Countermeasure: collusion-resistant codes (Tardos codes)
  Countermeasure: "fingerprinting" codes designed for N-user security

PROTOCOL ATTACKS:
  Claim the watermark was added after creation (ambiguity)
  Countermeasure: timestamp the watermark with trusted third party
  Countermeasure: register watermark with copyright authority
  Countermeasure: use blockchain timestamping

ATTACK RESISTANCE TESTING:
  Test your watermark against:
    [ ] JPEG compression at quality 30, 50, 70
    [ ] Cropping 10%, 25%, 50% of image
    [ ] Scaling to 50% and back to 100%
    [ ] Rotation by 5°, 15°, 45°, 90°
    [ ] Gaussian blur (σ = 1.0, 2.0)
    [ ] Additive noise (SNR 20dB, 30dB)
    [ ] Print-scan cycle
    [ ] Screenshot and re-upload
    [ ] Format conversion round-trip
    [ ] AI inpainting attempt
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== Watermark Implementation Checklist ===

VISIBLE WATERMARK (for content protection):
  [ ] Opacity appropriate for use case (10-50%)
  [ ] Placement crosses important content areas
  [ ] Tiled or repeated for crop resistance
  [ ] Text is readable at display size
  [ ] Consistent style across all content
  [ ] Automated application (not manual per-image)
  [ ] Original un-watermarked version stored securely
  [ ] Watermark doesn't make content unusable for preview

INVISIBLE WATERMARK (for tracking/authentication):
  [ ] Imperceptible to human eye/ear (quality check)
  [ ] Robust against expected attacks (compression, crop)
  [ ] Sufficient capacity for tracking ID
  [ ] Extraction doesn't require original image
  [ ] Key management for embedding/detection
  [ ] False positive rate measured and acceptable
  [ ] Performance tested at scale (batch processing)

WEB WATERMARK (for web applications):
  [ ] Works with CSS (overlay approach)
  [ ] pointer-events: none (doesn't block interaction)
  [ ] user-select: none (can't select watermark text)
  [ ] Responsive (scales with container)
  [ ] Server-side backup (client-side is bypassable)
  [ ] MutationObserver for anti-removal (optional)
  [ ] Performance acceptable (no layout thrashing)
  [ ] Works in print stylesheet

AI CONTENT:
  [ ] C2PA metadata attached to generated content
  [ ] Invisible watermark embedded in pixels
  [ ] Disclosure label in UI ("Generated with AI")
  [ ] Metadata survives format conversion (or is re-applied)
  [ ] Detection tool available for verification
  [ ] Compliance with applicable regulations (EU, China)

LEGAL & PROCESS:
  [ ] Copyright notice in watermark text
  [ ] Watermark policy documented
  [ ] Original content stored with timestamp proof
  [ ] Registration with copyright authority (if applicable)
  [ ] Take-down process for watermark removal violations
  [ ] Staff trained on watermark application procedures
EOF
}

show_help() {
    cat << EOF
watermark v$VERSION — Watermarking Reference

Usage: script.sh <command>

Commands:
  intro      Watermarking overview — types, purposes, history
  visible    Visible watermarks — design, placement, tamper resistance
  invisible  Invisible watermarks — DCT, DWT, LSB, spread spectrum
  web        Web watermarking — CSS overlay, canvas, anti-removal
  document   Document watermarks — PDF, print, forensic tracking
  ai         AI content watermarking — C2PA, SynthID, regulations
  attacks    Watermark attacks — removal, distortion, countermeasures
  checklist  Watermark implementation checklist
  help       Show this help
  version    Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)     cmd_intro ;;
    visible)   cmd_visible ;;
    invisible) cmd_invisible ;;
    web)       cmd_web ;;
    document)  cmd_document ;;
    ai)        cmd_ai ;;
    attacks)   cmd_attacks ;;
    checklist) cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "watermark v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
