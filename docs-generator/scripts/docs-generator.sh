#!/usr/bin/env bash
set -euo pipefail

CMD="${1:-help}"
shift 2>/dev/null || true

case "$CMD" in

api)
  TYPE="${1:-rest}"
  RESOURCE="${2:-users}"
  python3 << 'PYEOF'
import sys
api_type = sys.argv[1] if len(sys.argv) > 1 else "rest"
resource = sys.argv[2] if len(sys.argv) > 2 else "users"
singular = resource.rstrip("s")

print("=" * 60)
print("  API Documentation: {} ({})".format(resource, api_type.upper()))
print("=" * 60)
print("")

if api_type == "rest":
    endpoints = [
        ("GET", "/api/{}".format(resource), "List all {}".format(resource), "200: Array of {}".format(resource)),
        ("GET", "/api/{}/{{id}}".format(resource), "Get {} by ID".format(singular), "200: {} object".format(singular.capitalize())),
        ("POST", "/api/{}".format(resource), "Create new {}".format(singular), "201: Created {}".format(singular)),
        ("PUT", "/api/{}/{{id}}".format(resource), "Update {}".format(singular), "200: Updated {}".format(singular)),
        ("DELETE", "/api/{}/{{id}}".format(resource), "Delete {}".format(singular), "204: No content"),
    ]
    print("## {} API".format(resource.capitalize()))
    print("")
    print("Base URL: `https://api.example.com/v1`")
    print("")
    print("### Endpoints")
    print("")
    for method, path, desc, response in endpoints:
        print("#### {} `{}`".format(method, path))
        print("")
        print(desc)
        print("")
        print("**Response:** {}".format(response))
        print("")
        if method == "POST":
            print("**Request Body:**")
            print("```json")
            print("{{")
            print('  "name": "string",')
            print('  "email": "string"')
            print("}}")
            print("```")
            print("")

    print("### Error Responses")
    print("")
    print("| Code | Description |")
    print("|------|-------------|")
    print("| 400 | Bad Request - Invalid parameters |")
    print("| 401 | Unauthorized - Missing/invalid token |")
    print("| 404 | Not Found - Resource doesn't exist |")
    print("| 429 | Too Many Requests - Rate limited |")
    print("| 500 | Internal Server Error |")

elif api_type == "graphql":
    print("## {} GraphQL Schema".format(resource.capitalize()))
    print("")
    print("```graphql")
    print("type {} {{".format(singular.capitalize()))
    print("  id: ID!")
    print("  name: String!")
    print("  email: String!")
    print("  createdAt: DateTime!")
    print("  updatedAt: DateTime!")
    print("}}")
    print("")
    print("type Query {")
    print("  {}: [{}!]!".format(resource, singular.capitalize()))
    print("  {}(id: ID!): {}".format(singular, singular.capitalize()))
    print("}")
    print("")
    print("type Mutation {")
    print("  create{}(input: {}Input!): {}!".format(singular.capitalize(), singular.capitalize(), singular.capitalize()))
    print("  update{}(id: ID!, input: {}Input!): {}!".format(singular.capitalize(), singular.capitalize(), singular.capitalize()))
    print("  delete{}(id: ID!): Boolean!".format(singular.capitalize()))
    print("}")
    print("")
    print("input {}Input {{".format(singular.capitalize()))
    print("  name: String!")
    print("  email: String!")
    print("}")
    print("```")

print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
  ;;

readme)
  NAME="${1:-myproject}"
  DESC="${2:-An awesome project}"
  python3 << 'PYEOF'
import sys
name = sys.argv[1] if len(sys.argv) > 1 else "myproject"
desc = " ".join(sys.argv[2:]) if len(sys.argv) > 2 else "An awesome project"

print("# {}".format(name))
print("")
print("> {}".format(desc))
print("")
print("[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)")
print("")
print("## Features")
print("")
print("- Feature 1")
print("- Feature 2")
print("- Feature 3")
print("")
print("## Installation")
print("")
print("```bash")
print("# npm")
print("npm install {}".format(name))
print("")
print("# pip")
print("pip install {}".format(name))
print("```")
print("")
print("## Quick Start")
print("")
print("```bash")
print("{} --help".format(name))
print("```")
print("")
print("## Usage")
print("")
print("```python")
print("from {} import main".format(name.replace("-", "_")))
print("")
print("result = main()")
print("```")
print("")
print("## Configuration")
print("")
print("| Option | Default | Description |")
print("|--------|---------|-------------|")
print("| `--verbose` | `false` | Enable verbose output |")
print("| `--config` | `~/.{}/config.yml` | Config file path |".format(name))
print("")
print("## Contributing")
print("")
print("See [CONTRIBUTING.md](CONTRIBUTING.md)")
print("")
print("## License")
print("")
print("MIT - see [LICENSE](LICENSE)")
print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
  ;;

changelog)
  VER="${1:-1.0.0}"
  SUMMARY="${2:-Initial release}"
  python3 << 'PYEOF'
import sys
from datetime import date
ver = sys.argv[1] if len(sys.argv) > 1 else "1.0.0"
summary = " ".join(sys.argv[2:]) if len(sys.argv) > 2 else "Initial release"
today = date.today().isoformat()

print("# Changelog")
print("")
print("All notable changes to this project will be documented in this file.")
print("")
print("The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),")
print("and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).")
print("")
print("## [{}] - {}".format(ver, today))
print("")
print("### Added")
print("")
print("- {}".format(summary))
print("- New feature description here")
print("")
print("### Changed")
print("")
print("- Updated dependency X to v2.0")
print("- Improved performance of Y")
print("")
print("### Fixed")
print("")
print("- Fixed bug in Z component")
print("- Resolved issue #123")
print("")
print("### Deprecated")
print("")
print("- Old API endpoint `/v1/old` (use `/v2/new` instead)")
print("")
print("## [Unreleased]")
print("")
print("### Added")
print("")
print("- Upcoming feature")
print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
  ;;

contributing)
  PROJECT="${1:-myproject}"
  python3 << 'PYEOF'
import sys
project = sys.argv[1] if len(sys.argv) > 1 else "myproject"

print("# Contributing to {}".format(project))
print("")
print("Thank you for your interest in contributing!")
print("")
print("## Getting Started")
print("")
print("1. Fork the repository")
print("2. Clone your fork: `git clone https://github.com/YOUR_NAME/{}.git`".format(project))
print("3. Create a branch: `git checkout -b feature/your-feature`")
print("4. Install dependencies: `npm install` / `pip install -e '.[dev]'`")
print("")
print("## Development Workflow")
print("")
print("```bash")
print("# Run tests")
print("npm test  # or pytest")
print("")
print("# Run linter")
print("npm run lint  # or flake8")
print("")
print("# Build")
print("npm run build")
print("```")
print("")
print("## Pull Request Process")
print("")
print("1. Update documentation for any changed functionality")
print("2. Add tests for new features")
print("3. Ensure all tests pass")
print("4. Update CHANGELOG.md")
print("5. Request review from maintainers")
print("")
print("## Code Style")
print("")
print("- Follow existing patterns in the codebase")
print("- Use meaningful variable/function names")
print("- Add comments for complex logic")
print("- Keep functions small and focused")
print("")
print("## Reporting Issues")
print("")
print("- Use the issue template")
print("- Include reproduction steps")
print("- Attach error logs if applicable")
print("")
print("## Code of Conduct")
print("")
print("Be respectful. We're all here to build something great together.")
print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
  ;;

architecture)
  PROJECT="${1:-myproject}"
  STYLE="${2:-monolith}"
  python3 << 'PYEOF'
import sys
project = sys.argv[1] if len(sys.argv) > 1 else "myproject"
style = sys.argv[2] if len(sys.argv) > 2 else "monolith"

print("# {} Architecture Document".format(project))
print("")
print("## Overview")
print("")
print("Architecture style: **{}**".format(style.capitalize()))
print("")

if style == "monolith":
    print("## System Structure")
    print("")
    print("```")
    print("{}/".format(project))
    print("+-- src/")
    print("|   +-- controllers/    # Request handlers")
    print("|   +-- services/       # Business logic")
    print("|   +-- models/         # Data models")
    print("|   +-- middleware/     # Middleware")
    print("|   +-- utils/          # Utilities")
    print("+-- tests/")
    print("+-- config/")
    print("+-- docs/")
    print("```")
    print("")
    print("## Data Flow")
    print("")
    print("```")
    print("Request -> Middleware -> Controller -> Service -> Model -> Database")
    print("                                       |")
    print("Response <---- Controller <---- Service")
    print("```")

elif style == "microservice":
    print("## Services")
    print("")
    print("```")
    print("API Gateway")
    print("  +-- Auth Service          (JWT, OAuth)")
    print("  +-- User Service          (CRUD, profiles)")
    print("  +-- Notification Service  (email, push)")
    print("  +-- Payment Service       (billing)")
    print("```")
    print("")
    print("## Communication")
    print("")
    print("- Sync: REST/gRPC between services")
    print("- Async: Message queue (RabbitMQ/Kafka)")
    print("- Service discovery: Consul/K8s DNS")

elif style == "serverless":
    print("## Functions")
    print("")
    print("```")
    print("API Gateway -> Lambda/Cloud Function")
    print("  +-- GET  /api/items  -> listItems()")
    print("  +-- POST /api/items  -> createItem()")
    print("  +-- Events           -> processQueue()")
    print("```")
    print("")
    print("## Infrastructure")
    print("")
    print("- Compute: AWS Lambda / Cloud Functions")
    print("- Storage: DynamoDB / Firestore")
    print("- Queue: SQS / Pub/Sub")
    print("- CDN: CloudFront / Cloud CDN")

print("")
print("## Key Decisions")
print("")
print("| Decision | Choice | Rationale |")
print("|----------|--------|-----------|")
print("| Language | TBD | Team expertise |")
print("| Database | TBD | Data model fit |")
print("| Hosting | TBD | Scale requirements |")
print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
  ;;

tutorial)
  TOPIC="${1:-getting-started}"
  LEVEL="${2:-beginner}"
  python3 << 'PYEOF'
import sys
topic = sys.argv[1] if len(sys.argv) > 1 else "getting-started"
level = sys.argv[2] if len(sys.argv) > 2 else "beginner"

print("# Tutorial: {}".format(topic.replace("-", " ").title()))
print("")
print("**Level:** {}".format(level.capitalize()))
if level == "beginner":
    print("**Prerequisites:** None")
    print("**Time:** 15 minutes")
elif level == "intermediate":
    print("**Prerequisites:** Basic knowledge required")
    print("**Time:** 30 minutes")
else:
    print("**Prerequisites:** Intermediate experience")
    print("**Time:** 45 minutes")
print("")
print("---")
print("")
print("## What You'll Learn")
print("")
print("- Concept 1: [describe]")
print("- Concept 2: [describe]")
print("- Concept 3: [describe]")
print("")
print("## Step 1: Setup")
print("")
print("```bash")
print("# Install dependencies")
print("npm install  # or pip install")
print("```")
print("")
print("## Step 2: Basic Usage")
print("")
print("```python")
print("# Your first example")
print("result = do_something()")
print("print(result)")
print("```")
print("")
print("## Step 3: Advanced Example")
print("")
print("```python")
print("# Building on Step 2")
print("advanced_result = do_more(result)")
print("```")
print("")
print("## Common Mistakes")
print("")
print("- Mistake 1: [what and how to fix]")
print("- Mistake 2: [what and how to fix]")
print("")
print("## Next Steps")
print("")
print("- [ ] Try modifying the example")
print("- [ ] Read the API reference")
print("- [ ] Build your own project")
print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
  ;;

faq)
  TOPIC="${1:-api}"
  COUNT="${2:-5}"
  python3 << 'PYEOF'
import sys
topic = sys.argv[1] if len(sys.argv) > 1 else "api"
count = int(sys.argv[2]) if len(sys.argv) > 2 else 5

faqs = {
    "api": [
        ("How do I authenticate?", "Use Bearer token in the Authorization header: `Authorization: Bearer <token>`"),
        ("What's the rate limit?", "100 requests/minute per API key. Check `X-RateLimit-Remaining` header."),
        ("How do I handle pagination?", "Use `?page=1&limit=20`. Response includes `total`, `page`, `pages`."),
        ("What format is the response?", "All responses are JSON with `{data, error, meta}` structure."),
        ("How do I report a bug?", "Open an issue on GitHub with reproduction steps and error logs."),
        ("Is there a sandbox environment?", "Yes: `https://sandbox.api.example.com`. Use test API keys."),
        ("How do I get an API key?", "Register at dashboard.example.com, go to Settings > API Keys."),
        ("What SDKs are available?", "Official SDKs for Python, Node.js, Go, and Ruby."),
    ],
    "general": [
        ("How do I install?", "See the Installation section in README.md."),
        ("What platforms are supported?", "Linux, macOS, Windows. Docker also available."),
        ("Is it free?", "Open source under MIT license. Free for all use."),
        ("How do I contribute?", "See CONTRIBUTING.md for guidelines."),
        ("Where do I get help?", "GitHub Issues, Discord community, or Stack Overflow tag."),
    ],
}

items = faqs.get(topic, faqs["general"])[:count]

print("# FAQ - {}".format(topic.capitalize()))
print("")
for i, (q, a) in enumerate(items, 1):
    print("### {}. {}".format(i, q))
    print("")
    print(a)
    print("")

print("---")
print("*Didn't find your answer? Open an issue on GitHub.*")
print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
  ;;

reference)
  LIB="${1:-mylib}"
  LANG="${2:-python}"
  python3 << 'PYEOF'
import sys
lib = sys.argv[1] if len(sys.argv) > 1 else "mylib"
lang = sys.argv[2] if len(sys.argv) > 2 else "python"

print("# {} Reference Manual".format(lib))
print("")
print("Complete API reference for {}.".format(lib))
print("")

if lang == "python":
    print("## Module: `{}`".format(lib))
    print("")
    print("### Classes")
    print("")
    print("#### `{}.Client`".format(lib))
    print("")
    print("Main client class for interacting with the service.")
    print("")
    print("```python")
    print("client = {}.Client(api_key='xxx')".format(lib))
    print("```")
    print("")
    print("**Parameters:**")
    print("| Name | Type | Default | Description |")
    print("|------|------|---------|-------------|")
    print("| `api_key` | `str` | Required | API authentication key |")
    print("| `timeout` | `int` | `30` | Request timeout in seconds |")
    print("| `retry` | `bool` | `True` | Enable auto-retry |")
    print("")
    print("**Methods:**")
    print("")
    print("##### `client.get(resource, **params)`")
    print("")
    print("Fetch a resource.")
    print("")
    print("```python")
    print("result = client.get('users', limit=10)")
    print("```")
    print("")
    print("##### `client.create(resource, data)`")
    print("")
    print("Create a new resource.")
    print("")
    print("```python")
    print("user = client.create('users', {'name': 'Alice'})")
    print("```")

elif lang == "javascript":
    print("## Module: `{}`".format(lib))
    print("")
    print("### `new {}Client(options)`".format(lib.capitalize()))
    print("")
    print("```javascript")
    print("const client = new {}Client({{".format(lib.capitalize()))
    print("  apiKey: 'xxx',")
    print("  timeout: 30000,")
    print("});")
    print("```")
    print("")
    print("**Options:**")
    print("| Name | Type | Default | Description |")
    print("|------|------|---------|-------------|")
    print("| `apiKey` | `string` | Required | API key |")
    print("| `timeout` | `number` | `30000` | Timeout (ms) |")

print("")
print("### Constants")
print("")
print("| Name | Value | Description |")
print("|------|-------|-------------|")
print("| `VERSION` | `'1.0.0'` | Library version |")
print("| `DEFAULT_TIMEOUT` | `30` | Default timeout |")
print("")
print("### Exceptions")
print("")
print("| Name | Description |")
print("|------|-------------|")
print("| `AuthError` | Invalid API key |")
print("| `NotFoundError` | Resource not found |")
print("| `RateLimitError` | Rate limit exceeded |")
print("")
print("Powered by BytesAgain | bytesagain.com | hello@bytesagain.com")
PYEOF
  ;;

*)
  echo "Docs Generator - Automated Documentation"
  echo ""
  echo "Usage: bash docs-generator.sh <command> [args]"
  echo ""
  echo "Commands:"
  echo "  api <type> <resource>          API documentation (rest/graphql)"
  echo "  readme <name> <desc>           README.md template"
  echo "  changelog <version> <summary>  CHANGELOG entry"
  echo "  contributing <project>         Contributing guide"
  echo "  architecture <project> <style> Architecture doc"
  echo "  tutorial <topic> <level>       Tutorial document"
  echo "  faq <topic> <count>            FAQ generation"
  echo "  reference <lib> <lang>         Reference manual"
  echo ""
  echo "Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"
  ;;

esac
