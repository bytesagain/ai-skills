#!/bin/bash
# Directus - Open Data Platform (Headless CMS) Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              DIRECTUS REFERENCE                             ║
║          Open Data Platform & Headless CMS                  ║
╚══════════════════════════════════════════════════════════════╝

Directus is an open-source headless CMS that wraps any SQL database
with a real-time GraphQL+REST API and an intuitive admin dashboard.

KEY FEATURES:
  Database first  Wraps existing SQL database (doesn't own it)
  REST + GraphQL  Auto-generated APIs from your schema
  Admin panel     No-code data management interface
  Roles & perms   Granular access control per collection/field
  Flows           Visual automation workflows
  File storage    S3, GCS, Azure, local storage
  Realtime        WebSocket subscriptions
  Translations    Built-in i18n support

SUPPORTED DATABASES:
  PostgreSQL, MySQL, MariaDB, SQLite, MS SQL Server,
  OracleDB, CockroachDB

DIRECTUS vs STRAPI vs SANITY:
  ┌──────────────┬──────────┬──────────┬──────────┐
  │ Feature      │ Directus │ Strapi   │ Sanity   │
  ├──────────────┼──────────┼──────────┼──────────┤
  │ DB ownership │ Yours    │ Managed  │ Managed  │
  │ Existing DB  │ Yes      │ No       │ No       │
  │ GraphQL      │ Built-in │ Plugin   │ GROQ     │
  │ Realtime     │ Built-in │ No       │ Built-in │
  │ Flows        │ Built-in │ No       │ No       │
  │ Self-hosted  │ Yes      │ Yes      │ No       │
  │ License      │ GPLv3    │ MIT      │ Propriet.│
  │ TypeScript   │ Full     │ Partial  │ Full     │
  └──────────────┴──────────┴──────────┴──────────┘

INSTALL:
  # Docker (recommended)
  docker run -d -p 8055:8055 \
    -e SECRET="your-secret-key" \
    -e DB_CLIENT="pg" \
    -e DB_HOST="localhost" \
    -e DB_PORT="5432" \
    -e DB_DATABASE="directus" \
    -e DB_USER="postgres" \
    -e DB_PASSWORD="password" \
    -e ADMIN_EMAIL="admin@example.com" \
    -e ADMIN_PASSWORD="password123" \
    directus/directus

  # npm
  npx create-directus-project my-project
  cd my-project && npx directus start
EOF
}

cmd_api() {
cat << 'EOF'
REST & GRAPHQL API
====================

All collections get auto-generated CRUD endpoints.

REST API:
  # List items
  GET /items/articles?limit=10&sort=-date_created
  GET /items/articles?filter[status][_eq]=published
  GET /items/articles?fields=id,title,author.name

  # Get single item
  GET /items/articles/15

  # Create
  POST /items/articles
  { "title": "New Article", "body": "Content...", "status": "draft" }

  # Update
  PATCH /items/articles/15
  { "status": "published" }

  # Delete
  DELETE /items/articles/15

FILTER OPERATORS:
  _eq          Equal
  _neq         Not equal
  _gt          Greater than
  _gte         Greater or equal
  _lt          Less than
  _lte         Less or equal
  _in          In array
  _nin         Not in array
  _null        Is null
  _nnull       Is not null
  _contains    Contains substring
  _ncontains   Not contains
  _starts_with Starts with
  _ends_with   Ends with
  _between     Between two values
  _empty       Is empty
  _nempty      Not empty

  # Nested filters (AND/OR)
  GET /items/articles?filter={"_and":[
    {"status":{"_eq":"published"}},
    {"_or":[
      {"category":{"_eq":"tech"}},
      {"category":{"_eq":"science"}}
    ]}
  ]}

DEEP/RELATIONAL:
  # Get article with author details
  GET /items/articles?fields=*,author.name,author.avatar
  GET /items/articles?fields=*,tags.tags_id.name

  # Filter by relation
  GET /items/articles?filter[author][name][_eq]=Alice

  # Aggregate
  GET /items/articles?aggregate[count]=*
  GET /items/articles?aggregate[avg]=views&groupBy[]=category

GRAPHQL:
  query {
    articles(
      filter: { status: { _eq: "published" } }
      sort: ["-date_created"]
      limit: 10
    ) {
      id
      title
      body
      author {
        name
        avatar { id }
      }
      tags {
        tags_id {
          name
        }
      }
    }
  }

AUTHENTICATION:
  # Login
  POST /auth/login
  { "email": "user@example.com", "password": "pass" }
  → { "data": { "access_token": "...", "refresh_token": "..." } }

  # Use token
  GET /items/articles
  Authorization: Bearer <access_token>

  # Refresh
  POST /auth/refresh
  { "refresh_token": "..." }

  # Static token (API keys)
  GET /items/articles?access_token=your-static-token
EOF
}

cmd_features() {
cat << 'EOF'
ADMIN & FEATURES
==================

COLLECTIONS (Tables):
  Settings → Data Model → Create Collection
  - Define fields, types, relationships
  - Field types: string, text, integer, float, boolean,
    datetime, json, uuid, file, m2o, o2m, m2m, translations

RELATIONSHIPS:
  Many-to-One (M2O):  Article → Author
  One-to-Many (O2M):  Author → Articles
  Many-to-Many (M2M): Articles ↔ Tags (junction table)
  Translations:       Content in multiple languages

ROLES & PERMISSIONS:
  Per collection, per action (CRUD), per field:
  - Public:     Read-only selected collections
  - Editor:     CRUD on content, no settings
  - Admin:      Full access

  Custom permissions:
  - Field-level:  Hide salary field from editors
  - Item-level:   Users can only edit their own items
  - Presets:      Default values per role

FLOWS (Automation):
  Visual workflow builder:
  Trigger → Operations → Result

  Triggers:
  - Event hook (item.create, item.update)
  - Schedule (cron)
  - Webhook
  - Manual

  Operations:
  - Send email/webhook
  - Transform data
  - Run script (JS)
  - Create/update items
  - Conditional logic

  Example: On article publish → send Slack notification

FILES & ASSETS:
  # Upload
  POST /files
  Content-Type: multipart/form-data
  file: <binary>

  # Transform images
  GET /assets/<file-id>?width=200&height=200&fit=cover&quality=80

  Transforms: width, height, fit (cover/contain/inside), quality,
  format (webp/jpg/png), withoutEnlargement

  Storage adapters: local, S3, GCS, Azure Blob, Cloudinary

EXTENSIONS:
  Directus is fully extensible:
  - Interfaces:   Custom input components
  - Displays:     Custom column displays
  - Layouts:      Custom collection views
  - Modules:      Full custom pages
  - Endpoints:    Custom API routes
  - Hooks:        Event listeners
  - Operations:   Custom flow operations

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Directus - Open Data Platform Reference

Commands:
  intro     Overview, comparison, install
  api       REST, GraphQL, filters, auth
  features  Admin, roles, flows, files, extensions

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)    cmd_intro ;;
  api)      cmd_api ;;
  features) cmd_features ;;
  help|*)   show_help ;;
esac
