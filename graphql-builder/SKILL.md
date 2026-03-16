---
version: "2.0.0"
name: graphql-builder
description: "Error: --type required. Use when you need graphql builder capabilities. Triggers on: graphql builder, type, entity, fields, relations, lang."
author: BytesAgain
---

# graphql-builder

Generate complete GraphQL schemas, type definitions, resolvers, queries, mutations, and subscriptions from natural language descriptions. Supports custom scalars, enums, interfaces, unions, input types, pagination (Relay-style cursor and offset), authentication directives, field validation, N+1 query prevention with DataLoader patterns, and subscription setup. Outputs production-ready schema files with proper documentation and examples.

## Commands

| Command | Description |
|---------|-------------|
| `schema` | Generate a complete GraphQL schema from description |
| `type` | Generate type definitions with fields and relations |
| `resolver` | Generate resolver functions (Query/Mutation/Field) |
| `query` | Generate query operations with variables |
| `mutation` | Generate mutation operations with input types |
| `subscription` | Generate subscription definitions |
| `enum` | Generate enum type definitions |
| `interface` | Generate interface and implementing types |
| `pagination` | Add Relay-style cursor pagination |
| `auth` | Add authentication/authorization directives |

## Usage

```
# Generate complete schema for a blog API
graphql-builder schema --domain "blog with users, posts, comments, tags"

# Generate type definitions
graphql-builder type --name User --fields "id:ID!,name:String!,email:String!,posts:[Post!]!"

# Generate resolvers for a type
graphql-builder resolver --type User --operations "getUser,listUsers,createUser,updateUser"

# Generate query with pagination
graphql-builder query --name listPosts --pagination cursor --filters "status,author"

# Generate mutation with validation
graphql-builder mutation --name createPost --input "title:String!,body:String!,tags:[String!]"

# Generate subscription
graphql-builder subscription --name onPostCreated --type Post

# Add authentication directives
graphql-builder auth --strategy jwt --roles "admin,editor,viewer"
```

## Examples

### E-commerce Schema
```
graphql-builder schema --domain "e-commerce with products, categories, orders, users, reviews, cart"
```

### Social Media Schema
```
graphql-builder schema --domain "social media with users, posts, comments, likes, follows, messages"
```

### SaaS Schema
```
graphql-builder schema --domain "SaaS with organizations, users, projects, tasks, billing"
```

## Features

- **Full schema generation** — Types, queries, mutations, subscriptions
- **Relay pagination** — Cursor-based connection types
- **Authentication** — JWT/session-based auth directives
- **Validation** — Input validation with custom directives
- **DataLoader** — N+1 prevention patterns
- **Documentation** — Inline descriptions and examples
- **Resolvers** — Complete resolver implementations

## Keywords

graphql, schema, api, query, mutation, subscription, resolver, type system, api design, backend
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
