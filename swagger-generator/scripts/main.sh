#!/usr/bin/env bash
# Swagger/OpenAPI Generator — Create API documentation from descriptions
# Usage: bash main.sh --title <title> --base-url <url> --endpoints <file|inline> [options]
set -euo pipefail

TITLE=""
BASE_URL="http://localhost:3000"
VERSION="1.0.0"
DESCRIPTION=""
ENDPOINTS=""
AUTH_TYPE="bearer"
OUTPUT=""
FORMAT="yaml"

show_help() {
    cat << 'HELPEOF'
Swagger/OpenAPI Generator — Create API documentation specs

Usage: bash main.sh --title <title> [options]

Options:
  --title <title>      API title (required)
  --base-url <url>     Base URL (default: http://localhost:3000)
  --version <ver>      API version (default: 1.0.0)
  --desc <desc>        API description
  --endpoints <spec>   Endpoint definitions (see format below)
  --auth <type>        Auth type: bearer, apikey, basic, oauth2, none
  --format <fmt>       Output format: yaml, json
  --output <file>      Output file
  --help               Show this help

Endpoint Format (semicolon-separated):
  "METHOD /path:summary:tag"
  
Examples:
  bash main.sh --title "Pet Store API" --endpoints "GET /pets:List pets:Pets;POST /pets:Create pet:Pets;GET /pets/{id}:Get pet:Pets;DELETE /pets/{id}:Delete pet:Pets"
  bash main.sh --title "Auth API" --auth bearer --endpoints "POST /auth/login:Login:Auth;POST /auth/register:Register:Auth;GET /auth/me:Current user:Auth"
  bash main.sh --title "E-commerce" --base-url "https://api.shop.com" --format json

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
HELPEOF
}

while [ $# -gt 0 ]; do
    case "$1" in
        --title) TITLE="$2"; shift 2;;
        --base-url) BASE_URL="$2"; shift 2;;
        --version) VERSION="$2"; shift 2;;
        --desc) DESCRIPTION="$2"; shift 2;;
        --endpoints) ENDPOINTS="$2"; shift 2;;
        --auth) AUTH_TYPE="$2"; shift 2;;
        --format) FORMAT="$2"; shift 2;;
        --output) OUTPUT="$2"; shift 2;;
        --help|-h) show_help; exit 0;;
        *) shift;;
    esac
done

[ -z "$TITLE" ] && { echo "Error: --title required"; show_help; exit 1; }

generate_spec() {
    python3 << PYEOF
import json, sys

title = "$TITLE"
base_url = "$BASE_URL"
version = "$VERSION"
description = "$DESCRIPTION" or "{} API Documentation".format(title)
endpoints_str = "$ENDPOINTS"
auth_type = "$AUTH_TYPE"
fmt = "$FORMAT"

# Parse endpoints
endpoints = []
if endpoints_str:
    for ep in endpoints_str.split(";"):
        ep = ep.strip()
        if not ep:
            continue
        parts = ep.split(":")
        method_path = parts[0].strip()
        summary = parts[1].strip() if len(parts) > 1 else ""
        tag = parts[2].strip() if len(parts) > 2 else "Default"
        
        mp = method_path.split(" ", 1)
        method = mp[0].lower()
        path = mp[1] if len(mp) > 1 else "/"
        
        endpoints.append({
            "method": method,
            "path": path,
            "summary": summary,
            "tag": tag
        })

# Default CRUD if no endpoints
if not endpoints:
    endpoints = [
        {"method": "get", "path": "/items", "summary": "List items", "tag": "Items"},
        {"method": "post", "path": "/items", "summary": "Create item", "tag": "Items"},
        {"method": "get", "path": "/items/{id}", "summary": "Get item by ID", "tag": "Items"},
        {"method": "put", "path": "/items/{id}", "summary": "Update item", "tag": "Items"},
        {"method": "delete", "path": "/items/{id}", "summary": "Delete item", "tag": "Items"},
    ]

# Build spec
spec = {
    "openapi": "3.0.3",
    "info": {
        "title": title,
        "version": version,
        "description": description,
        "contact": {
            "name": "BytesAgain",
            "url": "https://bytesagain.com",
            "email": "hello@bytesagain.com"
        }
    },
    "servers": [
        {"url": base_url, "description": "Main server"}
    ]
}

# Security schemes
if auth_type != "none":
    schemes = {
        "bearer": {
            "BearerAuth": {
                "type": "http",
                "scheme": "bearer",
                "bearerFormat": "JWT"
            }
        },
        "apikey": {
            "ApiKeyAuth": {
                "type": "apiKey",
                "in": "header",
                "name": "X-API-Key"
            }
        },
        "basic": {
            "BasicAuth": {
                "type": "http",
                "scheme": "basic"
            }
        },
        "oauth2": {
            "OAuth2": {
                "type": "oauth2",
                "flows": {
                    "authorizationCode": {
                        "authorizationUrl": base_url + "/oauth/authorize",
                        "tokenUrl": base_url + "/oauth/token",
                        "scopes": {"read": "Read access", "write": "Write access"}
                    }
                }
            }
        }
    }
    spec["components"] = {"securitySchemes": schemes.get(auth_type, schemes["bearer"])}
    scheme_name = list(spec["components"]["securitySchemes"].keys())[0]
    spec["security"] = [{scheme_name: []}]

# Build paths
paths = {}
tags_set = set()

for ep in endpoints:
    path = ep["path"]
    method = ep["method"]
    summary = ep["summary"]
    tag = ep["tag"]
    tags_set.add(tag)
    
    if path not in paths:
        paths[path] = {}
    
    operation = {
        "tags": [tag],
        "summary": summary,
        "operationId": summary.lower().replace(" ", "_"),
        "responses": {
            "200": {
                "description": "Successful response",
                "content": {
                    "application/json": {
                        "schema": {"type": "object"}
                    }
                }
            }
        }
    }
    
    # Add path parameters
    if "{" in path:
        params = []
        import re
        for match in re.finditer(r'\{(\w+)\}', path):
            params.append({
                "name": match.group(1),
                "in": "path",
                "required": True,
                "schema": {"type": "string"}
            })
        operation["parameters"] = params
    
    # Add request body for POST/PUT/PATCH
    if method in ("post", "put", "patch"):
        operation["requestBody"] = {
            "required": True,
            "content": {
                "application/json": {
                    "schema": {"type": "object"}
                }
            }
        }
    
    # Add query params for GET lists
    if method == "get" and "{" not in path:
        operation["parameters"] = [
            {"name": "page", "in": "query", "schema": {"type": "integer", "default": 1}},
            {"name": "limit", "in": "query", "schema": {"type": "integer", "default": 20}},
            {"name": "search", "in": "query", "schema": {"type": "string"}}
        ]
    
    # Error responses
    if method in ("post", "put", "patch"):
        operation["responses"]["400"] = {"description": "Bad request"}
    if "{" in path:
        operation["responses"]["404"] = {"description": "Not found"}
    operation["responses"]["500"] = {"description": "Internal server error"}
    
    paths[path][method] = operation

spec["paths"] = paths
spec["tags"] = [{"name": t} for t in sorted(tags_set)]

# Output
if fmt == "json":
    print(json.dumps(spec, indent=2))
else:
    # Simple YAML output without pyyaml dependency
    def to_yaml(obj, indent=0):
        prefix = "  " * indent
        if isinstance(obj, dict):
            if not obj:
                return "{}"
            lines = []
            for k, v in obj.items():
                if isinstance(v, (dict, list)):
                    lines.append("{}{}:".format(prefix, k))
                    lines.append(to_yaml(v, indent + 1))
                else:
                    val = json.dumps(v) if isinstance(v, (bool, type(None))) else str(v)
                    if isinstance(v, str) and (":" in v or "#" in v or v.startswith("{")):
                        val = '"{}"'.format(v.replace('"', '\\"'))
                    lines.append("{}{}: {}".format(prefix, k, val))
            return "\n".join(lines)
        elif isinstance(obj, list):
            if not obj:
                return "{}[]".format(prefix)
            lines = []
            for item in obj:
                if isinstance(item, dict):
                    first = True
                    for k, v in item.items():
                        if first:
                            if isinstance(v, (dict, list)):
                                lines.append("{}- {}:".format(prefix, k))
                                lines.append(to_yaml(v, indent + 2))
                            else:
                                val = json.dumps(v) if isinstance(v, (bool, type(None))) else str(v)
                                lines.append("{}- {}: {}".format(prefix, k, val))
                            first = False
                        else:
                            if isinstance(v, (dict, list)):
                                lines.append("{}  {}:".format(prefix, k))
                                lines.append(to_yaml(v, indent + 2))
                            else:
                                val = json.dumps(v) if isinstance(v, (bool, type(None))) else str(v)
                                lines.append("{}  {}: {}".format(prefix, k, val))
                else:
                    val = json.dumps(item) if isinstance(item, (bool, type(None))) else str(item)
                    lines.append("{}- {}".format(prefix, val))
            return "\n".join(lines)
        else:
            return "{}{}".format(prefix, obj)
    
    print("# OpenAPI Specification")
    print("# Generated by BytesAgain Swagger Generator")
    print("")
    print(to_yaml(spec))

print("")
print("# ---")
print("# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
}

if [ -n "$OUTPUT" ]; then
    generate_spec > "$OUTPUT"
    echo "Saved to $OUTPUT"
else
    generate_spec
fi
