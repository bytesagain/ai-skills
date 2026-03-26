#!/bin/bash
# Astro - Content-Focused Web Framework Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              ASTRO REFERENCE                                ║
║          The Web Framework for Content-Driven Sites         ║
╚══════════════════════════════════════════════════════════════╝

Astro is a web framework that delivers zero JavaScript by default.
It renders pages to static HTML and only hydrates interactive
components on demand — called "Islands Architecture."

KEY FEATURES:
  Zero JS default    Static HTML output, JS only where needed
  Islands            Interactive components hydrate independently
  UI agnostic        Use React, Vue, Svelte, Solid, or Preact
  Content Collections  Type-safe Markdown/MDX content management
  SSR + SSG          Static generation or server rendering
  View Transitions   Built-in page transition animations
  Middleware         Request/response pipeline

ISLANDS ARCHITECTURE:
  Traditional SPA:  Entire page = JavaScript
  Astro Islands:    Static HTML + isolated interactive widgets

  ┌──────────────────────────────────────────────┐
  │  Static HTML (zero JS)                       │
  │  ┌──────────┐                                │
  │  │ React    │ ← Island: loads JS only here   │
  │  │ Counter  │                                 │
  │  └──────────┘                                │
  │  More static content...                      │
  │  ┌──────────────┐                            │
  │  │ Vue Carousel │ ← Another island            │
  │  └──────────────┘                            │
  │  Static footer                               │
  └──────────────────────────────────────────────┘

ASTRO vs NEXT.js vs GATSBY:
  ┌──────────────┬──────────┬──────────┬──────────┐
  │ Feature      │ Astro    │ Next.js  │ Gatsby   │
  ├──────────────┼──────────┼──────────┼──────────┤
  │ Default JS   │ Zero     │ React    │ React    │
  │ SSR          │ Optional │ Default  │ Limited  │
  │ SSG          │ Default  │ Optional │ Default  │
  │ UI framework │ Any      │ React    │ React    │
  │ Content      │ Built-in │ MDX pkg  │ GraphQL  │
  │ Performance  │ Fastest  │ Fast     │ Fast     │
  │ Use case     │ Content  │ Apps     │ Content  │
  │ Learning     │ Easy     │ Medium   │ Hard     │
  └──────────────┴──────────┴──────────┴──────────┘
EOF
}

cmd_basics() {
cat << 'EOF'
PROJECT SETUP & BASICS
========================

CREATE PROJECT:
  npm create astro@latest
  # Follow prompts: template, TypeScript, etc.

  # Or with template
  npm create astro@latest -- --template blog
  npm create astro@latest -- --template docs
  npm create astro@latest -- --template portfolio

PROJECT STRUCTURE:
  my-site/
  ├── src/
  │   ├── pages/          # File-based routing
  │   │   ├── index.astro
  │   │   ├── about.astro
  │   │   └── blog/
  │   │       ├── index.astro
  │   │       └── [slug].astro
  │   ├── layouts/        # Page layouts
  │   │   └── Base.astro
  │   ├── components/     # Reusable components
  │   │   ├── Header.astro
  │   │   └── Counter.tsx  # React/Vue/Svelte island
  │   ├── content/        # Content collections
  │   │   ├── config.ts
  │   │   └── blog/
  │   │       ├── post-1.md
  │   │       └── post-2.mdx
  │   └── styles/         # Global styles
  ├── public/             # Static assets
  ├── astro.config.mjs
  └── package.json

ASTRO COMPONENT (.astro):
  ---
  // Component script (runs at build time, server only)
  const title = "Hello Astro";
  const items = await fetch("https://api.example.com/items").then(r => r.json());
  ---

  <!-- Component template (HTML output) -->
  <html>
    <head><title>{title}</title></head>
    <body>
      <h1>{title}</h1>
      <ul>
        {items.map(item => <li>{item.name}</li>)}
      </ul>
    </body>
  </html>

  <style>
    /* Scoped by default! */
    h1 { color: navy; }
  </style>

ROUTING:
  src/pages/index.astro        →  /
  src/pages/about.astro        →  /about
  src/pages/blog/index.astro   →  /blog
  src/pages/blog/[slug].astro  →  /blog/:slug
  src/pages/[...slug].astro    →  catch-all

DYNAMIC ROUTES (SSG):
  ---
  // src/pages/blog/[slug].astro
  export async function getStaticPaths() {
    const posts = await getCollection('blog');
    return posts.map(post => ({
      params: { slug: post.slug },
      props: { post },
    }));
  }
  const { post } = Astro.props;
  ---
  <h1>{post.data.title}</h1>

COMMANDS:
  npm run dev         Start dev server (localhost:4321)
  npm run build       Build for production
  npm run preview     Preview production build
  npx astro add react Add React integration
  npx astro add tailwind  Add Tailwind CSS
EOF
}

cmd_islands() {
cat << 'EOF'
FRAMEWORK ISLANDS & HYDRATION
================================

ADD A UI FRAMEWORK:
  npx astro add react     # React
  npx astro add vue       # Vue
  npx astro add svelte    # Svelte
  npx astro add solid     # SolidJS
  npx astro add preact    # Preact
  npx astro add lit       # Lit

USE FRAMEWORK COMPONENTS:
  ---
  import Counter from '../components/Counter.tsx';
  import Carousel from '../components/Carousel.vue';
  ---

  <h1>Static heading (zero JS)</h1>

  <!-- Interactive React component -->
  <Counter client:load />

  <!-- Vue component, hydrates when visible -->
  <Carousel client:visible />

  <!-- Static render, no JS shipped -->
  <Counter />

HYDRATION DIRECTIVES:
  client:load        Hydrate immediately on page load
  client:idle        Hydrate when browser is idle (requestIdleCallback)
  client:visible     Hydrate when component scrolls into view
  client:media="(max-width: 768px)"  Hydrate on media query match
  client:only="react"  Client-side only (no SSR), specify framework
  (none)             No hydration — rendered as static HTML

CHOOSING THE RIGHT DIRECTIVE:
  ┌─────────────────┬────────────────────────────────────┐
  │ Directive       │ Best for                           │
  ├─────────────────┼────────────────────────────────────┤
  │ client:load     │ Critical interactive UI (nav, auth)│
  │ client:idle     │ Below-fold interactive widgets     │
  │ client:visible  │ Lazy components (carousel, charts) │
  │ client:media    │ Mobile-only or desktop-only UI     │
  │ client:only     │ Browser-only APIs (localStorage)   │
  │ (no directive)  │ Static content, no interaction     │
  └─────────────────┴────────────────────────────────────┘

MIX FRAMEWORKS:
  ---
  import ReactCounter from '../components/Counter.tsx';
  import VueWidget from '../components/Widget.vue';
  import SvelteForm from '../components/Form.svelte';
  ---

  <ReactCounter client:load />
  <VueWidget client:visible />
  <SvelteForm client:idle />

  Each island loads only its framework's runtime.
  Unused frameworks = zero cost.
EOF
}

cmd_content() {
cat << 'EOF'
CONTENT COLLECTIONS
=====================

Type-safe content management for Markdown, MDX, YAML, JSON.

DEFINE COLLECTION:
  // src/content/config.ts
  import { defineCollection, z } from 'astro:content';

  const blog = defineCollection({
    type: 'content',  // Markdown/MDX
    schema: z.object({
      title: z.string(),
      description: z.string(),
      pubDate: z.date(),
      tags: z.array(z.string()).default([]),
      draft: z.boolean().default(false),
      image: z.string().optional(),
    }),
  });

  const authors = defineCollection({
    type: 'data',  // JSON/YAML
    schema: z.object({
      name: z.string(),
      bio: z.string(),
      avatar: z.string(),
    }),
  });

  export const collections = { blog, authors };

CONTENT FILES:
  // src/content/blog/hello-world.md
  ---
  title: "Hello World"
  description: "My first blog post"
  pubDate: 2026-03-24
  tags: ["intro", "astro"]
  ---

  # Hello World

  This is my first blog post written in **Markdown**.

QUERY COLLECTIONS:
  ---
  import { getCollection, getEntry } from 'astro:content';

  // Get all published posts
  const posts = await getCollection('blog', ({ data }) => !data.draft);

  // Sort by date
  posts.sort((a, b) => b.data.pubDate.valueOf() - a.data.pubDate.valueOf());

  // Get single entry
  const post = await getEntry('blog', 'hello-world');
  ---

RENDER CONTENT:
  ---
  const post = await getEntry('blog', Astro.params.slug);
  const { Content } = await post.render();
  ---

  <article>
    <h1>{post.data.title}</h1>
    <time>{post.data.pubDate.toLocaleDateString()}</time>
    <Content />  <!-- Rendered Markdown/MDX -->
  </article>

MDX SUPPORT:
  npx astro add mdx

  // src/content/blog/interactive-post.mdx
  ---
  title: "Interactive Post"
  ---
  import Counter from '../../components/Counter.tsx';

  # This post has a counter

  <Counter client:visible />

  Regular **markdown** works too.
EOF
}

cmd_deploy() {
cat << 'EOF'
DEPLOYMENT & SSR
==================

STATIC (DEFAULT):
  npm run build
  # Output in dist/ — deploy to any static host

  Hosts:         Netlify, Vercel, Cloudflare Pages, GitHub Pages, S3

  # Vercel
  npx astro add vercel
  # Auto-detected, just push to Git

  # Netlify
  npx astro add netlify
  # Or: netlify.toml
  [build]
    command = "npm run build"
    publish = "dist"

  # GitHub Pages
  # astro.config.mjs
  export default defineConfig({
    site: 'https://username.github.io',
    base: '/repo-name',
  });

SERVER-SIDE RENDERING (SSR):
  // astro.config.mjs
  import { defineConfig } from 'astro/config';
  import node from '@astrojs/node';

  export default defineConfig({
    output: 'server',      // or 'hybrid' (SSR + static pages)
    adapter: node({
      mode: 'standalone'   // or 'middleware'
    }),
  });

  SSR Adapters:
    @astrojs/node          Node.js server
    @astrojs/vercel        Vercel Functions
    @astrojs/netlify       Netlify Functions
    @astrojs/cloudflare    Cloudflare Workers
    @astrojs/deno          Deno Deploy

HYBRID RENDERING:
  // astro.config.mjs
  output: 'hybrid'    // Static by default, opt-in to SSR

  // Static page (default in hybrid)
  ---
  // src/pages/about.astro — pre-rendered at build
  ---

  // Server-rendered page
  ---
  // src/pages/dashboard.astro
  export const prerender = false;  // Opt this page into SSR
  ---

MIDDLEWARE:
  // src/middleware.ts
  import { defineMiddleware } from 'astro:middleware';

  export const onRequest = defineMiddleware(async (context, next) => {
    const auth = context.request.headers.get('authorization');
    if (context.url.pathname.startsWith('/admin') && !auth) {
      return context.redirect('/login');
    }
    return next();
  });

VIEW TRANSITIONS:
  ---
  import { ViewTransitions } from 'astro:transitions';
  ---
  <head>
    <ViewTransitions />
  </head>

  <!-- Elements animate between pages -->
  <h1 transition:name="title">{title}</h1>
  <img transition:name="hero" src={image} />

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Astro - Content-Focused Web Framework Reference

Commands:
  intro     Islands architecture, zero JS, framework comparison
  basics    Project setup, routing, components, commands
  islands   Framework integration, hydration directives
  content   Content collections, Markdown/MDX, type-safe queries
  deploy    Static hosting, SSR adapters, hybrid rendering

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)   cmd_intro ;;
  basics)  cmd_basics ;;
  islands) cmd_islands ;;
  content) cmd_content ;;
  deploy)  cmd_deploy ;;
  help|*)  show_help ;;
esac
