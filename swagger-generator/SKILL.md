---
version: "2.0.0"
name: swagger-generator
description: "Error: --title required. Use when you need swagger generator capabilities. Triggers on: swagger generator, title, base-url, version, desc, endpoints."
author: BytesAgain
---

# swagger-generator

Generate complete OpenAPI 3.0/Swagger specification documents from endpoint descriptions. Supports RESTful API documentation with path definitions, request/response schemas, authentication schemes (Bearer JWT, API Key, OAuth2), error responses, pagination, filtering, and example values. Outputs valid YAML or JSON specs that can be rendered by Swagger UI, Redoc, or imported into Postman. Includes model generation, tag grouping, and server configuration.

## Commands

| Command | Description |
|---------|-------------|
| `spec` | Generate a complete OpenAPI spec from API description |
| `endpoint` | Generate a single endpoint definition |
| `model` | Generate a schema/model definition |
| `crud` | Generate CRUD endpoints for a resource |
| `auth` | Generate authentication scheme definitions |
| `error` | Generate standardized error response schemas |
| `server` | Generate server configuration (dev/staging/prod) |
| `tag` | Generate tag definitions for API grouping |
| `merge` | Merge multiple endpoint definitions into one spec |

## Usage

```
# Generate complete API spec
swagger-generator spec --title "My API" --version "1.0.0" --description "REST API for my app"

# Generate CRUD endpoints for a resource
swagger-generator crud --resource User --fields "id:integer,name:string,email:string"

# Generate single endpoint
swagger-generator endpoint --method POST --path "/users" --body "name:string,email:string" --response "User"

# Generate model/schema
swagger-generator model --name Product --fields "id:integer,name:string,price:number,category:string"

# Add authentication
swagger-generator auth --scheme bearer --format jwt

# Generate error responses
swagger-generator error --codes "400,401,403,404,422,500"

# Server configuration
swagger-generator server --envs "dev,staging,production" --base-url "api.example.com"
```

## Examples

### E-commerce API
```
swagger-generator spec --title "E-commerce API" --resources "products,orders,users,categories"
```

### Blog API
```
swagger-generator crud --resource Post --fields "id:integer,title:string,body:string,author_id:integer,status:string"
```

### Microservice API
```
swagger-generator spec --title "Payment Service" --auth bearer --resources "payments,refunds,webhooks"
```

## Features

- **OpenAPI 3.0** — Generates valid OpenAPI 3.0.3 specifications
- **CRUD generation** — Complete REST endpoints for any resource
- **Authentication** — Bearer JWT, API Key, OAuth2 schemes
- **Models** — JSON Schema-based model definitions
- **Error handling** — Standardized error response patterns
- **Pagination** — Cursor and offset pagination parameters
- **Examples** — Request/response example values
- **Tags** — Logical API endpoint grouping

## Keywords

swagger, openapi, api documentation, rest api, api spec, api design, documentation, endpoints, schema, backend
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
