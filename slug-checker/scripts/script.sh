#!/usr/bin/env bash
# slug-checker — URL Slug Design Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail
VERSION="1.0.0"

cmd_intro() { cat << 'EOF'
=== URL Slugs ===

A slug is a URL-friendly identifier derived from a human-readable title.
It appears in the path portion of a URL.

Example:
  Title: "10 Tips for Better CSS Grid Layout!"
  Slug:  "10-tips-for-better-css-grid-layout"
  URL:   https://blog.example.com/posts/10-tips-for-better-css-grid-layout

Why Slugs Matter:
  SEO:          Search engines use URL words for ranking signals
  Readability:  Users can understand what the page is about
  Shareability: Clean URLs look trustworthy and are easier to share
  Persistence:  Good slugs outlive the content (cool URIs don't change)

Anatomy of a Good Slug:
  ✓ Lowercase letters, numbers, and hyphens only
  ✓ Words separated by hyphens (not underscores)
  ✓ No special characters, spaces, or encoded entities
  ✓ 3-5 words (concise but descriptive)
  ✓ Contains primary keyword
  ✓ No trailing slashes (unless site convention)

Bad Slugs:
  ✗ /posts/12345                    (opaque, no keywords)
  ✗ /posts/This%20Is%20My%20Post  (encoded spaces)
  ✗ /posts/this_is_my_post         (underscores, not hyphens)
  ✗ /posts/10-amazingly-incredible-awesome-tips-for-absolutely-best (too long)
  ✗ /posts/post                    (too generic)

Slug vs ID:
  Use BOTH: /posts/42/better-css-grid or /posts/better-css-grid
  ID guarantees uniqueness, slug provides SEO and readability
  If slug changes (title edited), redirect old slug → new slug
EOF
}

cmd_rules() { cat << 'EOF'
=== Slug Generation Rules ===

--- Allowed Characters ---
  Lowercase letters:    a-z
  Digits:              0-9
  Hyphens:             - (word separator)

  That's it. Nothing else.

--- Transformation Steps ---
  1. Lowercase:           "Hello World" → "hello world"
  2. Transliterate:       "café" → "cafe", "über" → "uber"
  3. Remove special chars: "hello & world!" → "hello  world"
  4. Replace spaces:      "hello  world" → "hello--world"
  5. Collapse hyphens:    "hello--world" → "hello-world"
  6. Trim hyphens:        "-hello-world-" → "hello-world"
  7. Truncate:            Limit to ~60-80 characters
  8. Validate:            Must not be empty or a reserved word

--- Separator Choice ---
  Hyphens (-):  SEO best practice, Google treats as word separator
  Underscores (_): Google treats as word JOINER (not separator)
    "web_design" → Google sees "webdesign" (one word)
    "web-design" → Google sees "web design" (two words)

  Matt Cutts (Google, 2011): "Use hyphens in URLs, not underscores"
  This advice still holds.

--- Length ---
  Recommended: 3-5 words, 30-60 characters
  Maximum: ~2,000 characters (browser limit)
  Practical max: ~75 characters (truncated in search results)
  Google: first 60 characters of URL carry most weight

--- Case ---
  Always lowercase. URLs are case-sensitive:
    /Posts/Hello-World and /posts/hello-world are different URLs
  Normalize to lowercase to avoid duplicates
  Redirect uppercase variants to lowercase

--- Stop Words ---
  Optional: remove common words (a, an, the, is, at, of, in, on)
  "a-guide-to-the-best-css-practices"
  → "guide-best-css-practices" (shorter, same keywords)
  Be careful: "the-who" needs "the"; context matters
  Many modern systems keep stop words (simplicity > optimization)
EOF
}

cmd_generation() { cat << 'EOF'
=== Slug Generation Algorithms ===

--- Basic Algorithm ---

  function slugify(text):
    text = text.toLowerCase()
    text = transliterate(text)           // ñ→n, ü→u, 日→ri
    text = text.replace(/[^a-z0-9]+/g, '-')  // non-alphanumeric → hyphen
    text = text.replace(/^-+|-+$/g, '')      // trim leading/trailing hyphens
    text = text.replace(/-{2,}/g, '-')        // collapse multiple hyphens
    if (text.length > 75) text = text.substring(0, 75).replace(/-[^-]*$/, '')
    return text

--- Language Implementations ---

  Python (python-slugify):
    from slugify import slugify
    slugify("Hello World! Über Cool")  # "hello-world-uber-cool"

  JavaScript (slugify):
    import slugify from 'slugify'
    slugify('Hello World! Über Cool', {lower: true})

  Ruby (parameterize):
    "Hello World!".parameterize  # "hello-world"

  PHP:
    Str::slug('Hello World!')  # "hello-world" (Laravel)

--- Transliteration ---
  Convert non-ASCII to ASCII approximation:
    ñ → n     ü → u      ø → o      ß → ss
    å → a     æ → ae     ð → d      þ → th
    中文 → zhong-wen (Pinyin)
    日本語 → nihongo (Romaji)
    한국어 → hangugeo (Romanization)
    Ελληνικά → ellinika (Greeklish)

  Libraries:
    Python: unidecode, text-unidecode
    JS: transliteration, speakingurl
    Ruby: babosa, stringex

--- Deduplication ---
  Multiple items may generate same slug:
    "Hello World" → "hello-world"
    "Hello, World!" → "hello-world"

  Strategies:
    Append counter: "hello-world", "hello-world-2", "hello-world-3"
    Append random: "hello-world-a3f2" (hash suffix)
    Append ID: "hello-world-42" (database ID)
    Append date: "2024-01-hello-world"

  Database check:
    SELECT slug FROM posts WHERE slug LIKE 'hello-world%'
    Find highest counter, increment
    Race condition: use INSERT ... ON CONFLICT or transaction
EOF
}

cmd_seo() { cat << 'EOF'
=== SEO Best Practices for Slugs ===

--- Keyword Placement ---
  Primary keyword should appear in the slug.
  /best-running-shoes-2024 ← contains target keyword
  /article-37 ← no SEO value

  Front-load keywords:
    GOOD: /css-grid-complete-guide
    LESS: /complete-beginners-guide-to-css-grid-layout

--- URL Structure and Hierarchy ---
  Flat: /css-grid-guide
    Simplest, works for blogs
    Google doesn't penalize deep URLs, but shorter = better CTR

  Hierarchical: /tutorials/css/grid-guide
    Shows content organization
    Each segment should be meaningful
    Breadcrumbs often mirror this structure

  Date-based: /2024/01/css-grid-guide
    Good for news, bad for evergreen content
    "2024" in URL may reduce clicks in 2025+

--- Canonical URLs ---
  If content accessible at multiple URLs, set canonical:
    <link rel="canonical" href="https://example.com/css-grid-guide" />
  Prevents duplicate content penalties
  All variations point to one authoritative URL

--- Redirects When Slugs Change ---
  If slug changes (title edited):
    301 Redirect: /old-slug → /new-slug (permanent)
    Passes ~90% of SEO value to new URL
    NEVER break old URLs without redirect

  Store slug history:
    slug_redirects table: old_slug → current_slug
    Check redirects before 404

--- URL Parameters ---
  Clean: /products/running-shoes?color=black&size=10
  Dirty: /products?category=shoes&type=running&color=black&size=10

  Parameters are fine for filters/sorting
  Core content should be in the path, not parameters
  Use canonical URLs to prevent parameter-based duplicates

--- HTTPS ---
  Google confirms HTTPS as a ranking signal
  Always use HTTPS
  Redirect HTTP → HTTPS with 301
EOF
}

cmd_i18n() { cat << 'EOF'
=== Internationalized Slugs ===

--- Approach 1: Transliterate Everything ---
  Convert all non-ASCII to ASCII approximation
  "日本語ガイド" → "nihongo-gaido"
  "Ελληνικά" → "ellinika"

  Pro: works everywhere, safe for all systems
  Con: loses original language, may look wrong to native speakers

--- Approach 2: Allow Unicode in Slugs (IRIs) ---
  Keep original script in URL (IRI — Internationalized Resource Identifier)
  /posts/日本語ガイド
  /posts/ελληνικά

  Pro: natural for non-Latin readers, better local SEO
  Con: some systems can't handle Unicode URLs, copy-paste may encode

  Technical: IRI (RFC 3987) allows Unicode
  Browsers display Unicode URLs natively
  But sharing may result in: /%E6%97%A5%E6%9C%AC... (percent-encoded)

--- Approach 3: Hybrid ---
  Use transliterated slug but allow Unicode display name:
    Slug: /nihongo-gaido
    Title: 日本語ガイド

  Or: include both ID and slug:
    /posts/42/日本語ガイド (Unicode for display, ID for lookup)

--- Punycode ---
  Domain names use Punycode for non-ASCII:
    münchen.de → xn--mnchen-3ya.de
  Path segments: percent-encoding (RFC 3986)
    /münchen → /m%C3%BCnchen

--- Chinese/Japanese/Korean (CJK) ---
  No word boundaries in CJK text
  Need word segmentation before slugifying:
    "这是一个示例" → "zhe-shi-yi-ge-shi-li" (pinyin)
    Or keep as-is: /这是一个示例
  Libraries: jieba (Chinese), MeCab (Japanese), KoNLPy (Korean)

--- Right-to-Left (RTL) ---
  Arabic/Hebrew text in URLs:
    Browsers handle display correctly
    Encoded form: standard percent-encoding
    Consider: transliterated slug may be clearer in mixed contexts
    /مقال-عن-التصميم vs /maqal-an-al-tasmim
EOF
}

cmd_uniqueness() { cat << 'EOF'
=== Slug Uniqueness Strategies ===

--- Counter Suffix ---
  "hello-world"
  "hello-world-2"
  "hello-world-3"

  Implementation:
    SELECT slug FROM posts WHERE slug ~ '^hello-world(-\d+)?$'
    ORDER BY slug DESC LIMIT 1;
    → Parse highest counter, increment

  Pro: deterministic, readable, simple
  Con: race conditions (two posts at same time)
  Fix: INSERT ... ON CONFLICT DO UPDATE or unique constraint + retry

--- Hash Suffix ---
  "hello-world-a3f2b1"

  hash = sha256(title + timestamp)[:6]
  slug = slugify(title) + "-" + hash

  Pro: virtually no collisions
  Con: less readable, hash looks random

--- ID Prefix/Suffix ---
  "42-hello-world" or "hello-world-42"

  Use database auto-increment ID
  Lookup by ID (slug is cosmetic)

  Pro: always unique, simple lookup
  Con: exposes item count, ID visible in URL

--- Composite Slug ---
  Include disambiguating context:
    /posts/2024/01/hello-world     (date + slug)
    /users/alice/posts/hello-world (user + slug)
    /categories/tech/hello-world   (category + slug)

  Uniqueness only required within scope (date, user, category)
  Pro: allows same slug in different scopes
  Con: longer URLs, more complex routing

--- Nanoid / Short UUID ---
  "hello-world-V1StGXR8_Z5j"

  Use nanoid or short UUID for guaranteed uniqueness
  Pro: globally unique without database check
  Con: ugly suffix, longer URL

--- Database Constraint ---
  CREATE UNIQUE INDEX idx_posts_slug ON posts(slug);

  On conflict:
    Option A: append "-2", retry, append "-3", retry...
    Option B: generate new slug entirely
    Option C: fail and tell user to pick different title

  Always have a unique constraint as safety net,
  even if application logic tries to prevent duplicates.
EOF
}

cmd_frameworks() { cat << 'EOF'
=== Slug Handling in Frameworks ===

--- Django ---
  from django.utils.text import slugify
  slugify("Hello World!")  # "hello-world"

  Model with slug:
    class Post(models.Model):
        title = models.CharField(max_length=200)
        slug = models.SlugField(unique=True)

        def save(self, *args, **kwargs):
            if not self.slug:
                self.slug = slugify(self.title)
            super().save(*args, **kwargs)

  URL: path('posts/<slug:slug>/', views.post_detail)

--- Rails ---
  # Gemfile: gem 'friendly_id'
  class Post < ApplicationRecord
    extend FriendlyId
    friendly_id :title, use: :slugged
  end

  Post.friendly.find("hello-world")  # lookup by slug
  # FriendlyId handles: generation, uniqueness, history

--- Next.js ---
  // pages/posts/[slug].tsx
  export async function getStaticPaths() {
    const posts = await getPosts();
    return {
      paths: posts.map(p => ({ params: { slug: p.slug } })),
      fallback: false
    };
  }

--- WordPress ---
  Slugs = "post name" in permalink settings
  Settings → Permalinks → /%postname%/
  WordPress auto-generates from title on save
  Auto-deduplicates: post-name, post-name-2, post-name-3
  Stored in wp_posts.post_name column

--- Laravel ---
  use Illuminate\Support\Str;
  $slug = Str::slug('Hello World!');  // "hello-world"

  // Model with slug (using spatie/laravel-sluggable):
  use Spatie\Sluggable\HasSlug;
  class Post extends Model {
      use HasSlug;
      public function getSlugOptions(): SlugOptions {
          return SlugOptions::create()
              ->generateSlugsFrom('title')
              ->saveSlugsTo('slug');
      }
  }
EOF
}

cmd_validation() { cat << 'EOF'
=== Slug Validation ===

--- Regex Patterns ---

  Basic validation:
    ^[a-z0-9]+(?:-[a-z0-9]+)*$

    Matches: "hello-world", "css-grid-2024", "a"
    Rejects: "-hello", "hello-", "hello--world", "Hello", "hello_world"

  Relaxed (allow numbers at start):
    ^[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$

    Matches: "42-tips", "a", "hello-world"
    Rejects: "-start", "end-", "--double"

  With length limit:
    ^[a-z0-9](?:[a-z0-9-]{0,73}[a-z0-9])?$
    (2-75 characters total)

--- Reserved Words ---
  Slugs that conflict with routes or have special meaning:

  System routes:
    admin, api, auth, login, logout, register, signup
    settings, profile, account, dashboard, search
    feed, rss, sitemap, robots, favicon, manifest

  Special values:
    new, create, edit, delete, update
    null, undefined, true, false, none
    index, default, page, error, 404, 500

  URL-sensitive:
    . (dot), .. (parent), ~ (tilde)
    wp-admin, wp-login, .well-known, .git

  Implementation:
    RESERVED = {"admin", "api", "auth", "login", ...}
    if slug in RESERVED:
        slug = slug + "-1"  # or reject with error

--- Edge Cases ---
  Empty input: "" → require non-empty slug
  Only special chars: "!!!" → "" → invalid, need fallback
  Only numbers: "12345" → valid but ambiguous with IDs
  Very long: truncate at word boundary, not mid-word
  Unicode-only: "日本語" → transliterate or reject
  HTML entities: "&amp;hello" → strip entities before slugifying
  Multiple spaces: "hello    world" → "hello-world" (not "hello----world")
  Leading/trailing spaces: "  hello  " → "hello"

--- Testing Slug Generation ---
  Test cases every slugify function should handle:
    "Hello World"                → "hello-world"
    "Hello, World!"              → "hello-world"
    "  spaces  everywhere  "     → "spaces-everywhere"
    "UPPERCASE"                  → "uppercase"
    "café résumé"               → "cafe-resume"
    "hello---world"              → "hello-world"
    "  "                         → "" (invalid!)
    "admin"                      → "admin-1" (reserved!)
    "Hello World Hello World ×5" → truncated appropriately
    "日本語テスト"                → "nihongo-tesuto" or "日本語テスト"
EOF
}

show_help() { cat << EOF
slug-checker v$VERSION — URL Slug Design Reference

Usage: script.sh <command>

Commands:
  intro        What slugs are and why they matter
  rules        Slug generation rules: characters, separators, length
  generation   Algorithms, transliteration, deduplication
  seo          SEO best practices for URLs and slugs
  i18n         Internationalized slugs: Unicode, CJK, RTL
  uniqueness   Uniqueness strategies: counters, hashes, composite
  frameworks   Slug handling in Django, Rails, Next.js, WordPress
  validation   Regex patterns, reserved words, edge cases
  help         Show this help
  version      Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"
case "$CMD" in
    intro) cmd_intro ;; rules) cmd_rules ;; generation) cmd_generation ;;
    seo) cmd_seo ;; i18n) cmd_i18n ;; uniqueness) cmd_uniqueness ;;
    frameworks) cmd_frameworks ;; validation) cmd_validation ;;
    help|--help|-h) show_help ;; version|--version|-v) echo "slug-checker v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
