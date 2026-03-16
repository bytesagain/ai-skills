# Tips for swagger-generator

## Quick Start
- Use `spec` for a complete API specification from a description
- Use `crud` to quickly generate all endpoints for a resource
- Use `model` to define reusable schema components

## Best Practices
- **Version your API** — Include version in the spec and optionally in paths
- **Use tags** — Group related endpoints for better documentation
- **Define models** — Use `$ref` to reference reusable schemas
- **Include examples** — Add example values for all request/response bodies
- **Error responses** — Define consistent error formats across all endpoints
- **Authentication** — Document all auth methods used by the API
- **Descriptions** — Write clear, actionable descriptions for every endpoint

## Common Patterns
- `spec --title "My API"` — Start with a full spec skeleton
- `crud --resource X` — Generate 5 endpoints (list, get, create, update, delete)
- `auth --scheme bearer` — Add JWT authentication
- `error --codes "400,401,404,500"` — Standard error responses
- `model --name X` — Define reusable data models

## OpenAPI Tips
- Use `oneOf`/`anyOf` for polymorphic responses
- Use `$ref` extensively to avoid duplication
- Define pagination as reusable parameter components
- Use `operationId` for code generation compatibility
- Include `contact` and `license` info in the spec

## Validation
- Use the Swagger Editor to validate generated specs
- Test with Postman import to verify compatibility
- Run `swagger-cli validate` for automated checking

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
