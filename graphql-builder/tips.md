# Tips for graphql-builder

## Quick Start
- Use `schema` for a complete API schema from a domain description
- Use `type` to add individual types with relationships
- Use `resolver` to generate implementation code for types

## Best Practices
- **Nullable by default** — Only use `!` when a field is truly required
- **Input types** — Always use input types for mutations, never reuse output types
- **Pagination** — Use Relay cursor pagination for lists
- **Naming** — Queries: `getX`, `listXs`; Mutations: `createX`, `updateX`, `deleteX`
- **Error handling** — Use union types for result types (Success | Error)
- **N+1 prevention** — Use DataLoader for relationship fields
- **Descriptions** — Document every type and field

## Common Patterns
- `schema --domain "..."` — Quick full schema generation
- `type + resolver` — Build incrementally, type by type
- `pagination --style cursor` — Relay-compliant pagination
- `auth --strategy jwt` — Add auth layer to existing schema

## Schema Design Tips
- Keep types focused — one responsibility per type
- Use interfaces for shared fields (Node, Timestamped)
- Use enums for fixed sets of values
- Prefer specific mutation names over generic CRUD
- Version via schema evolution, not URL versioning

## Performance
- Implement DataLoader for all relationship resolvers
- Use query complexity analysis to prevent abuse
- Set depth limits to prevent deep nesting attacks
- Cache frequently accessed, rarely changing data

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
