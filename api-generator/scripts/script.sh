#!/usr/bin/env bash
# api-generator — REST API scaffolding and endpoint generator
set -euo pipefail
VERSION="2.0.0"
DATA_DIR="${APIGEN_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/api-generator}"
mkdir -p "$DATA_DIR/projects"

show_help() {
    cat << EOF
api-generator v$VERSION — REST API scaffolding tool

Usage: api-generator <command> [args]

Scaffold:
  init <name> <framework>      New API project (express/flask/fastapi/gin)
  endpoint <method> <path>     Generate endpoint handler
  crud <resource>              Full CRUD for a resource
  model <name> <fields...>     Data model generator
  middleware <type>            Middleware template (auth/cors/logger/rate-limit)

Documentation:
  openapi <title> <version>    OpenAPI/Swagger spec
  docs <endpoint>              Endpoint documentation
  postman <collection>         Postman collection template

Testing:
  test <endpoint>              Test template for endpoint
  mock <resource>              Mock data generator
  benchmark <url>              Performance test script

Utilities:
  status-codes                 HTTP status code reference
  headers                      Common headers reference
  auth <type>                  Auth implementation (jwt/oauth/apikey/basic)
  validate <schema>            Request validation template
  help                         Show this help
EOF
}

_log() { echo "$(date '+%m-%d %H:%M') $1: $2" >> "$DATA_DIR/history.log"; }

cmd_init() {
    local name="${1:?Usage: api-generator init <name> <framework>}"
    local fw="${2:-express}"
    echo "  ═══ API Project: $name ($fw) ═══"
    case "$fw" in
        express)
            echo "  mkdir $name && cd $name"
            echo "  npm init -y"
            echo "  npm install express cors helmet morgan dotenv"
            echo ""
            echo '  // server.js'
            echo '  const express = require("express");'
            echo '  const cors = require("cors");'
            echo '  const app = express();'
            echo '  app.use(cors());'
            echo '  app.use(express.json());'
            echo '  app.get("/health", (req, res) => res.json({ status: "ok" }));'
            echo '  app.listen(3000, () => console.log("API running on :3000"));' ;;
        flask)
            echo "  mkdir $name && cd $name"
            echo "  pip install flask flask-cors"
            echo ""
            echo '  # app.py'
            echo '  from flask import Flask, jsonify, request'
            echo '  app = Flask(__name__)'
            echo '  @app.route("/health")'
            echo '  def health(): return jsonify(status="ok")'
            echo '  if __name__ == "__main__": app.run(port=3000)' ;;
        fastapi)
            echo "  pip install fastapi uvicorn"
            echo ""
            echo '  # main.py'
            echo '  from fastapi import FastAPI'
            echo '  app = FastAPI(title="'$name'")'
            echo '  @app.get("/health")'
            echo '  def health(): return {"status": "ok"}'
            echo '  # Run: uvicorn main:app --reload' ;;
        *) echo "  Frameworks: express, flask, fastapi, gin" ;;
    esac
    _log "init" "$name ($fw)"
}

cmd_crud() {
    local resource="${1:?Usage: api-generator crud <resource>}"
    local upper=$(echo "${resource:0:1}" | tr 'a-z' 'A-Z')${resource:1}
    echo "  ═══ CRUD Endpoints: $resource ═══"
    echo ""
    printf "  %-8s %-25s %s\n" "METHOD" "PATH" "DESCRIPTION"
    echo "  $(printf '%.0s─' {1..55})"
    printf "  %-8s %-25s %s\n" "GET"    "/${resource}s"          "List all ${resource}s"
    printf "  %-8s %-25s %s\n" "GET"    "/${resource}s/:id"      "Get single ${resource}"
    printf "  %-8s %-25s %s\n" "POST"   "/${resource}s"          "Create ${resource}"
    printf "  %-8s %-25s %s\n" "PUT"    "/${resource}s/:id"      "Update ${resource}"
    printf "  %-8s %-25s %s\n" "DELETE" "/${resource}s/:id"      "Delete ${resource}"
    echo ""
    echo "  Model: { id, ...fields, createdAt, updatedAt }"
    echo "  Responses: 200 OK, 201 Created, 404 Not Found, 422 Validation Error"
    _log "crud" "$resource"
}

cmd_endpoint() {
    local method="${1:?Usage: api-generator endpoint <GET|POST|PUT|DELETE> <path>}"
    local path="${2:?}"
    method=$(echo "$method" | tr 'a-z' 'A-Z')
    echo "  ═══ Endpoint: $method $path ═══"
    echo ""
    echo "  // Express handler"
    echo "  router.$(echo $method | tr 'A-Z' 'a-z')('$path', async (req, res) => {"
    echo "    try {"
    case "$method" in
        GET) echo "      const data = await db.find(req.query);"
             echo "      res.json({ data });" ;;
        POST) echo "      const { body } = req;"
              echo "      const result = await db.create(body);"
              echo "      res.status(201).json(result);" ;;
        PUT) echo "      const result = await db.update(req.params.id, req.body);"
             echo "      if (!result) return res.status(404).json({ error: 'Not found' });"
             echo "      res.json(result);" ;;
        DELETE) echo "      await db.delete(req.params.id);"
                echo "      res.status(204).send();" ;;
    esac
    echo "    } catch (err) {"
    echo "      res.status(500).json({ error: err.message });"
    echo "    }"
    echo "  });"
}

cmd_model() {
    local name="${1:?Usage: api-generator model <name> <field:type ...>}"
    shift
    echo "  ═══ Model: $name ═══"
    echo ""
    echo "  // Schema"
    echo "  {"
    echo "    \"id\": \"string (uuid)\","
    for field in "$@"; do
        IFS=':' read -r fname ftype <<< "$field"
        echo "    \"$fname\": \"${ftype:-string}\","
    done
    echo "    \"createdAt\": \"datetime\","
    echo "    \"updatedAt\": \"datetime\""
    echo "  }"
}

cmd_middleware() {
    local type="${1:-auth}"
    echo "  ═══ Middleware: $type ═══"
    case "$type" in
        auth) echo '  function auth(req, res, next) {'
              echo '    const token = req.headers.authorization?.split(" ")[1];'
              echo '    if (!token) return res.status(401).json({ error: "No token" });'
              echo '    try { req.user = jwt.verify(token, SECRET); next(); }'
              echo '    catch { res.status(401).json({ error: "Invalid token" }); }'
              echo '  }' ;;
        cors) echo '  app.use(cors({ origin: ["http://localhost:3000"], credentials: true }));' ;;
        logger) echo '  app.use((req, res, next) => {'
                echo '    console.log(`${req.method} ${req.path} ${Date.now()}`);'
                echo '    next();'
                echo '  });' ;;
        rate-limit) echo '  // npm install express-rate-limit'
                    echo '  const limit = rateLimit({ windowMs: 15*60*1000, max: 100 });'
                    echo '  app.use("/api/", limit);' ;;
        *) echo "  Types: auth, cors, logger, rate-limit" ;;
    esac
}

cmd_auth() {
    local type="${1:-jwt}"
    echo "  ═══ Auth: $type ═══"
    case "$type" in
        jwt) echo "  // npm install jsonwebtoken"
             echo "  const token = jwt.sign({ userId }, SECRET, { expiresIn: '24h' });"
             echo "  const decoded = jwt.verify(token, SECRET);" ;;
        apikey) echo "  // Header: X-API-Key: your-key"
                echo "  if (req.headers['x-api-key'] !== VALID_KEY) return res.status(403).end();" ;;
        *) echo "  Types: jwt, oauth, apikey, basic" ;;
    esac
}

cmd_status_codes() {
    echo "  ═══ HTTP Status Codes ═══"
    echo "  2xx Success:"
    echo "    200 OK              — Request succeeded"
    echo "    201 Created         — Resource created"
    echo "    204 No Content      — Deleted successfully"
    echo "  4xx Client Error:"
    echo "    400 Bad Request     — Invalid input"
    echo "    401 Unauthorized    — Auth required"
    echo "    403 Forbidden       — No permission"
    echo "    404 Not Found       — Resource missing"
    echo "    409 Conflict        — Duplicate"
    echo "    422 Unprocessable   — Validation failed"
    echo "    429 Too Many        — Rate limited"
    echo "  5xx Server Error:"
    echo "    500 Internal        — Server broke"
    echo "    502 Bad Gateway     — Upstream error"
    echo "    503 Unavailable     — Server overloaded"
}

cmd_openapi() {
    local title="${1:-My API}"
    local ver="${2:-1.0.0}"
    echo "  openapi: '3.0.3'"
    echo "  info:"
    echo "    title: $title"
    echo "    version: $ver"
    echo "  servers:"
    echo "    - url: http://localhost:3000/api"
    echo "  paths:"
    echo "    /health:"
    echo "      get:"
    echo "        summary: Health check"
    echo "        responses:"
    echo "          '200':"
    echo "            description: OK"
}

case "${1:-help}" in
    init)          shift; cmd_init "$@" ;;
    endpoint)      shift; cmd_endpoint "$@" ;;
    crud)          shift; cmd_crud "$@" ;;
    model)         shift; cmd_model "$@" ;;
    middleware)    shift; cmd_middleware "$@" ;;
    openapi)       shift; cmd_openapi "$@" ;;
    docs)          shift; echo "  Endpoint docs for $1: Method, Path, Params, Body, Response" ;;
    postman)       shift; echo "  Postman collection: import openapi spec or use Postman UI" ;;
    # External URL removed for security: test)          shift; echo "  curl -X GET http://localhost:3000$1 -H 'Content-Type: application/json'" ;;
    mock)          shift; echo "  Mock ${1}: { id: 1, name: 'Test $1', created: '$(date -I)' }" ;;
    benchmark)     shift; echo "  ab -n 1000 -c 10 $1" ;;
    status-codes)  cmd_status_codes ;;
    headers)       echo "  Content-Type | Authorization | Accept | Cache-Control | X-Request-ID" ;;
    auth)          shift; cmd_auth "$@" ;;
    validate)      shift; echo "  Validate: check required fields, types, ranges before DB write" ;;
    help|-h)       show_help ;;
    version|-v)    echo "api-generator v$VERSION" ;;
    *)             echo "Unknown: $1"; show_help; exit 1 ;;
esac
