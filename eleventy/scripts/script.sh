#!/bin/bash
# Eleventy (11ty) - Static Site Generator Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              ELEVENTY (11TY) REFERENCE                      ║
║          Simpler Static Site Generator                      ║
╚══════════════════════════════════════════════════════════════╝

Eleventy is a simpler, zero-config static site generator built
with JavaScript. It transforms templates into HTML pages with
minimal overhead — no client-side JavaScript by default.

KEY FEATURES:
  Zero config     Works out of the box
  Template agnostic  11 template languages supported
  No client JS    Zero JavaScript shipped to browser by default
  Data cascade    Flexible data merging from multiple sources
  Fast builds     Incremental builds, minimal overhead
  Plugins         Image optimization, RSS, i18n, etc.

TEMPLATE LANGUAGES:
  Nunjucks (.njk), Markdown (.md), Liquid (.liquid),
  HTML (.html), JavaScript (.11ty.js), Pug, EJS, Handlebars,
  Mustache, Haml, Custom

11TY vs ASTRO vs HUGO vs GATSBY:
  ┌──────────────┬──────────┬──────────┬──────────┬──────────┐
  │ Feature      │ 11ty     │ Astro    │ Hugo     │ Gatsby   │
  ├──────────────┼──────────┼──────────┼──────────┼──────────┤
  │ Language     │ JS       │ JS       │ Go       │ React    │
  │ Client JS    │ None*    │ Islands  │ None     │ React    │
  │ Build speed  │ Fast     │ Fast     │ Fastest  │ Slow     │
  │ Templating   │ 11 langs │ Components│Go tmpl  │ JSX      │
  │ Learning     │ Easy     │ Easy     │ Medium   │ Medium   │
  │ Data         │ Very flex│ Good     │ Good     │ GraphQL  │
  │ Bundle size  │ 0KB*     │ Small    │ 0KB      │ Large    │
  └──────────────┴──────────┴──────────┴──────────┴──────────┘
  * Unless you add client JS yourself

INSTALL:
  npm init -y
  npm install @11ty/eleventy
  npx @11ty/eleventy --serve    # Dev server
  npx @11ty/eleventy            # Build
EOF
}

cmd_templates() {
cat << 'EOF'
TEMPLATES & LAYOUTS
=====================

BASIC PAGE (Nunjucks):
  ---
  title: My Page
  layout: base.njk
  ---
  <h1>{{ title }}</h1>
  <p>This is my content.</p>

LAYOUT (base.njk in _includes/):
  <!DOCTYPE html>
  <html lang="en">
  <head>
    <meta charset="UTF-8">
    <title>{{ title }} | My Site</title>
  </head>
  <body>
    <nav>
      <a href="/">Home</a>
      <a href="/blog/">Blog</a>
      <a href="/about/">About</a>
    </nav>
    <main>
      {{ content | safe }}
    </main>
    <footer>Copyright {{ year }}</footer>
  </body>
  </html>

LAYOUT CHAINING:
  <!-- _includes/post.njk -->
  ---
  layout: base.njk
  ---
  <article>
    <h1>{{ title }}</h1>
    <time>{{ date | dateDisplay }}</time>
    {{ content | safe }}
  </article>

  <!-- blog/my-post.md -->
  ---
  title: My Blog Post
  layout: post.njk
  date: 2026-03-24
  tags: blog
  ---
  Content here in **Markdown**.

MARKDOWN + FRONT MATTER:
  ---
  title: About Me
  description: Learn about me
  layout: base.njk
  eleventyNavigation:
    key: About
    order: 2
  ---
  # About

  I am a **developer**.

  ## Skills
  - JavaScript
  - HTML/CSS

INCLUDES (partials):
  {% include "header.njk" %}
  {% include "sidebar.njk" %}

CONDITIONALS & LOOPS:
  {% if collections.blog.length > 0 %}
    <ul>
    {% for post in collections.blog | reverse %}
      <li>
        <a href="{{ post.url }}">{{ post.data.title }}</a>
        <time>{{ post.date | dateDisplay }}</time>
      </li>
    {% endfor %}
    </ul>
  {% else %}
    <p>No posts yet.</p>
  {% endif %}
EOF
}

cmd_data() {
cat << 'EOF'
DATA CASCADE
==============

11ty merges data from multiple sources (highest priority first):
  1. Front matter data (in each template)
  2. Template data files (same-name .json/.js)
  3. Directory data files (_data/ in folder)
  4. Global data files (_data/ at root)
  5. Computed data (eleventyComputed)

GLOBAL DATA (_data/):
  // _data/site.json
  {
    "title": "My Site",
    "url": "https://example.com",
    "author": "Alice"
  }

  // Use in templates:
  <title>{{ site.title }}</title>

  // _data/navigation.js (dynamic!)
  module.exports = [
    { label: "Home", url: "/" },
    { label: "Blog", url: "/blog/" },
    { label: "About", url: "/about/" },
  ];

  // _data/posts.js (fetch at build time!)
  const fetch = require("node-fetch");
  module.exports = async function() {
    const res = await fetch("https://api.example.com/posts");
    return res.json();
  };

COLLECTIONS:
  Created automatically from tags in front matter.

  ---
  tags: blog
  ---

  // Access in templates:
  {% for post in collections.blog %}
    <a href="{{ post.url }}">{{ post.data.title }}</a>
  {% endfor %}

  // Custom collection (.eleventy.js):
  eleventyConfig.addCollection("recentPosts", function(collectionApi) {
    return collectionApi.getFilteredByTag("blog")
      .sort((a, b) => b.date - a.date)
      .slice(0, 5);
  });

PAGINATION:
  ---
  pagination:
    data: collections.blog
    size: 10
  permalink: "blog/page-{{ pagination.pageNumber + 1 }}/"
  ---
  {% for post in pagination.items %}
    <article>{{ post.data.title }}</article>
  {% endfor %}

  <!-- Pagination nav -->
  {% if pagination.href.previous %}<a href="{{ pagination.href.previous }}">Previous</a>{% endif %}
  {% if pagination.href.next %}<a href="{{ pagination.href.next }}">Next</a>{% endif %}

COMPUTED DATA:
  ---
  eleventyComputed:
    permalink: "blog/{{ title | slugify }}/"
    description: "Read about {{ title }}"
  ---
EOF
}

cmd_config() {
cat << 'EOF'
CONFIGURATION
===============

.ELEVENTY.JS (or eleventy.config.js):
  module.exports = function(eleventyConfig) {

    // Passthrough copy (static assets)
    eleventyConfig.addPassthroughCopy("css");
    eleventyConfig.addPassthroughCopy("img");
    eleventyConfig.addPassthroughCopy({"src/fonts": "fonts"});

    // Custom filters
    eleventyConfig.addFilter("dateDisplay", (date) => {
      return new Date(date).toLocaleDateString("en-US", {
        year: "numeric", month: "long", day: "numeric"
      });
    });

    eleventyConfig.addFilter("excerpt", (content) => {
      return content.split("\n").slice(0, 3).join("\n");
    });

    // Shortcodes
    eleventyConfig.addShortcode("year", () => `${new Date().getFullYear()}`);

    eleventyConfig.addPairedShortcode("callout", (content, type) => {
      return `<div class="callout callout-${type}">${content}</div>`;
    });

    // Plugins
    eleventyConfig.addPlugin(require("@11ty/eleventy-plugin-rss"));
    eleventyConfig.addPlugin(require("@11ty/eleventy-img"));

    // Watch targets
    eleventyConfig.addWatchTarget("./css/");

    return {
      dir: {
        input: "src",
        output: "_site",
        includes: "_includes",
        layouts: "_layouts",
        data: "_data",
      },
      markdownTemplateEngine: "njk",
      htmlTemplateEngine: "njk",
    };
  };

CLI:
  npx @11ty/eleventy                    # Build
  npx @11ty/eleventy --serve            # Dev server + watch
  npx @11ty/eleventy --serve --port=8080
  npx @11ty/eleventy --input=src --output=dist
  npx @11ty/eleventy --quiet            # Less output
  npx @11ty/eleventy --dryrun           # Show what would build

PROJECT STRUCTURE:
  my-site/
  ├── .eleventy.js          # Config
  ├── src/
  │   ├── _data/            # Global data
  │   │   ├── site.json
  │   │   └── navigation.js
  │   ├── _includes/        # Layouts & partials
  │   │   ├── base.njk
  │   │   └── post.njk
  │   ├── blog/             # Blog posts
  │   │   ├── blog.json     # Directory data
  │   │   ├── first-post.md
  │   │   └── second-post.md
  │   ├── css/              # Styles (passthrough)
  │   ├── index.njk         # Homepage
  │   └── about.md          # About page
  └── _site/                # Output (gitignored)

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Eleventy (11ty) - Static Site Generator Reference

Commands:
  intro      Overview, comparison, template languages
  templates  Layouts, Markdown, includes, loops
  data       Data cascade, collections, pagination
  config     Config file, filters, shortcodes, plugins

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)     cmd_intro ;;
  templates) cmd_templates ;;
  data)      cmd_data ;;
  config)    cmd_config ;;
  help|*)    show_help ;;
esac
