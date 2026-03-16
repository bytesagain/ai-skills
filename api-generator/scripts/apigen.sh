#!/usr/bin/env bash
# API Generator — Powered by BytesAgain
set -euo pipefail

COMMAND="${1:-help}"
ARG="${2:-resource}"
BRAND="Powered by BytesAgain | bytesagain.com | hello@bytesagain.com"

case "$COMMAND" in

rest)
  python3 - "$ARG" << 'PYEOF'
import sys
name = sys.argv[1] if len(sys.argv) > 1 else "resource"
cap = name.capitalize()
print("""// ===== {cap} RESTful API (Express.js) =====

const express = require('express');
const router = express.Router();

// GET /{name}s - List all
router.get('/{name}s', async (req, res) => {{
  try {{
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 20;
    // const items = await {cap}.find().skip((page-1)*limit).limit(limit);
    res.json({{ success: true, data: [], page, limit }});
  }} catch (err) {{
    res.status(500).json({{ success: false, error: err.message }});
  }}
}});

// GET /{name}s/:id - Get by ID
router.get('/{name}s/:id', async (req, res) => {{
  try {{
    // const item = await {cap}.findById(req.params.id);
    res.json({{ success: true, data: {{}} }});
  }} catch (err) {{
    res.status(404).json({{ success: false, error: '{cap} not found' }});
  }}
}});

// POST /{name}s - Create
router.post('/{name}s', async (req, res) => {{
  try {{
    // const item = await {cap}.create(req.body);
    res.status(201).json({{ success: true, data: req.body }});
  }} catch (err) {{
    res.status(400).json({{ success: false, error: err.message }});
  }}
}});

// PUT /{name}s/:id - Update
router.put('/{name}s/:id', async (req, res) => {{
  try {{
    // const item = await {cap}.findByIdAndUpdate(req.params.id, req.body);
    res.json({{ success: true, data: req.body }});
  }} catch (err) {{
    res.status(400).json({{ success: false, error: err.message }});
  }}
}});

// DELETE /{name}s/:id - Delete
router.delete('/{name}s/:id', async (req, res) => {{
  try {{
    // await {cap}.findByIdAndDelete(req.params.id);
    res.status(204).send();
  }} catch (err) {{
    res.status(500).json({{ success: false, error: err.message }});
  }}
}});

module.exports = router;""".format(name=name, cap=cap))
PYEOF
  echo ""
  echo "// $BRAND"
  ;;

graphql)
  python3 - "$ARG" << 'PYEOF'
import sys
name = sys.argv[1] if len(sys.argv) > 1 else "resource"
cap = name.capitalize()
print("""# ===== {cap} GraphQL Schema =====

type {cap} {{
  id: ID!
  name: String!
  description: String
  status: {cap}Status!
  createdAt: DateTime!
  updatedAt: DateTime!
}}

enum {cap}Status {{
  ACTIVE
  INACTIVE
  ARCHIVED
}}

input Create{cap}Input {{
  name: String!
  description: String
  status: {cap}Status = ACTIVE
}}

input Update{cap}Input {{
  name: String
  description: String
  status: {cap}Status
}}

type {cap}Connection {{
  edges: [{cap}Edge!]!
  pageInfo: PageInfo!
  totalCount: Int!
}}

type {cap}Edge {{
  node: {cap}!
  cursor: String!
}}

type Query {{
  {name}(id: ID!): {cap}
  {name}s(first: Int, after: String, filter: {cap}Filter): {cap}Connection!
}}

type Mutation {{
  create{cap}(input: Create{cap}Input!): {cap}!
  update{cap}(id: ID!, input: Update{cap}Input!): {cap}!
  delete{cap}(id: ID!): Boolean!
}}""".format(name=name, cap=cap))
PYEOF
  echo ""
  echo "# $BRAND"
  ;;

swagger)
  python3 - "$ARG" << 'PYEOF'
import sys, json
name = sys.argv[1] if len(sys.argv) > 1 else "resource"
cap = name.capitalize()
doc = {
    "openapi": "3.0.3",
    "info": {"title": "{} API".format(cap), "version": "1.0.0", "description": "API for managing {}s".format(name)},
    "paths": {
        "/{}s".format(name): {
            "get": {
                "summary": "List all {}s".format(name),
                "parameters": [
                    {"name": "page", "in": "query", "schema": {"type": "integer", "default": 1}},
                    {"name": "limit", "in": "query", "schema": {"type": "integer", "default": 20}}
                ],
                "responses": {"200": {"description": "Success"}}
            },
            "post": {
                "summary": "Create a {}".format(name),
                "requestBody": {"required": True, "content": {"application/json": {"schema": {"$ref": "#/components/schemas/{}".format(cap)}}}},
                "responses": {"201": {"description": "Created"}}
            }
        },
        "/{}s/{{id}}".format(name): {
            "get": {"summary": "Get {} by ID".format(name), "responses": {"200": {"description": "Success"}, "404": {"description": "Not found"}}},
            "put": {"summary": "Update {}".format(name), "responses": {"200": {"description": "Updated"}}},
            "delete": {"summary": "Delete {}".format(name), "responses": {"204": {"description": "Deleted"}}}
        }
    },
    "components": {
        "schemas": {
            cap: {
                "type": "object",
                "required": ["name"],
                "properties": {
                    "id": {"type": "string", "format": "uuid"},
                    "name": {"type": "string"},
                    "description": {"type": "string"},
                    "createdAt": {"type": "string", "format": "date-time"},
                    "updatedAt": {"type": "string", "format": "date-time"}
                }
            }
        }
    }
}
print(json.dumps(doc, indent=2, ensure_ascii=False))
PYEOF
  echo ""
  echo "// $BRAND"
  ;;

client)
  python3 - "$ARG" << 'PYEOF'
import sys
name = sys.argv[1] if len(sys.argv) > 1 else "resource"
cap = name.capitalize()
print("""# ===== {cap} API Client (Python) =====

import requests

class {cap}Client:
    \"\"\"API client for {cap} resource.\"\"\"

    def __init__(self, base_url, api_key=None):
        self.base_url = base_url.rstrip('/')
        self.session = requests.Session()
        if api_key:
            self.session.headers['Authorization'] = 'Bearer ' + api_key
        self.session.headers['Content-Type'] = 'application/json'

    def list_{name}s(self, page=1, limit=20):
        \"\"\"List all {name}s with pagination.\"\"\"
        resp = self.session.get(
            self.base_url + '/{name}s',
            params={{'page': page, 'limit': limit}}
        )
        resp.raise_for_status()
        return resp.json()

    def get_{name}(self, {name}_id):
        \"\"\"Get a single {name} by ID.\"\"\"
        resp = self.session.get(self.base_url + '/{name}s/' + str({name}_id))
        resp.raise_for_status()
        return resp.json()

    def create_{name}(self, data):
        \"\"\"Create a new {name}.\"\"\"
        resp = self.session.post(self.base_url + '/{name}s', json=data)
        resp.raise_for_status()
        return resp.json()

    def update_{name}(self, {name}_id, data):
        \"\"\"Update an existing {name}.\"\"\"
        resp = self.session.put(
            self.base_url + '/{name}s/' + str({name}_id), json=data
        )
        resp.raise_for_status()
        return resp.json()

    def delete_{name}(self, {name}_id):
        \"\"\"Delete a {name}.\"\"\"
        resp = self.session.delete(self.base_url + '/{name}s/' + str({name}_id))
        resp.raise_for_status()
        return resp.status_code == 204

# Usage:
# client = {cap}Client('https://api.example.com', api_key='your-key')
# items = client.list_{name}s()
# item = client.create_{name}({{'name': 'New {cap}'}})""".format(name=name, cap=cap))
PYEOF
  echo ""
  echo "# $BRAND"
  ;;

mock)
  python3 - "$ARG" << 'PYEOF'
import sys
name = sys.argv[1] if len(sys.argv) > 1 else "resource"
cap = name.capitalize()
print("""// ===== {cap} Mock API Server (Express.js) =====

const express = require('express');
const app = express();
app.use(express.json());

// In-memory store
let {name}s = [
  {{ id: 1, name: 'Sample {cap} 1', status: 'active', createdAt: new Date().toISOString() }},
  {{ id: 2, name: 'Sample {cap} 2', status: 'active', createdAt: new Date().toISOString() }},
  {{ id: 3, name: 'Sample {cap} 3', status: 'inactive', createdAt: new Date().toISOString() }},
];
let nextId = 4;

// Simulate network delay
const delay = (ms) => new Promise(resolve => setTimeout(resolve, ms));

app.get('/{name}s', async (req, res) => {{
  await delay(200);
  const page = parseInt(req.query.page) || 1;
  const limit = parseInt(req.query.limit) || 20;
  const start = (page - 1) * limit;
  res.json({{
    success: true,
    data: {name}s.slice(start, start + limit),
    total: {name}s.length,
    page, limit
  }});
}});

app.get('/{name}s/:id', async (req, res) => {{
  await delay(100);
  const item = {name}s.find(x => x.id === parseInt(req.params.id));
  if (!item) return res.status(404).json({{ success: false, error: 'Not found' }});
  res.json({{ success: true, data: item }});
}});

app.post('/{name}s', async (req, res) => {{
  await delay(150);
  const item = {{ id: nextId++, ...req.body, createdAt: new Date().toISOString() }};
  {name}s.push(item);
  res.status(201).json({{ success: true, data: item }});
}});

app.put('/{name}s/:id', async (req, res) => {{
  await delay(150);
  const idx = {name}s.findIndex(x => x.id === parseInt(req.params.id));
  if (idx === -1) return res.status(404).json({{ success: false, error: 'Not found' }});
  {name}s[idx] = {{ ...{name}s[idx], ...req.body }};
  res.json({{ success: true, data: {name}s[idx] }});
}});

app.delete('/{name}s/:id', async (req, res) => {{
  await delay(100);
  {name}s = {name}s.filter(x => x.id !== parseInt(req.params.id));
  res.status(204).send();
}});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log('Mock {cap} API running on port ' + PORT));""".format(name=name, cap=cap))
PYEOF
  echo ""
  echo "// $BRAND"
  ;;

auth)
  python3 - "$ARG" << 'PYEOF'
import sys
auth_type = sys.argv[1] if len(sys.argv) > 1 else "jwt"

if auth_type == "jwt":
    print("""// ===== JWT Authentication (Node.js) =====

const jwt = require('jsonwebtoken');
const SECRET = process.env.JWT_SECRET || 'change-me-in-production';

// Generate token
function generateToken(user) {
  return jwt.sign(
    { id: user.id, email: user.email, role: user.role },
    SECRET,
    { expiresIn: '24h' }
  );
}

// Auth middleware
function authMiddleware(req, res, next) {
  const header = req.headers.authorization;
  if (!header || !header.startsWith('Bearer ')) {
    return res.status(401).json({ error: 'No token provided' });
  }
  try {
    const decoded = jwt.verify(header.split(' ')[1], SECRET);
    req.user = decoded;
    next();
  } catch (err) {
    return res.status(401).json({ error: 'Invalid token' });
  }
}

// Role-based access
function requireRole(...roles) {
  return (req, res, next) => {
    if (!roles.includes(req.user.role)) {
      return res.status(403).json({ error: 'Insufficient permissions' });
    }
    next();
  };
}

module.exports = { generateToken, authMiddleware, requireRole };""")

elif auth_type == "oauth":
    print("""// ===== OAuth 2.0 (Google, Passport.js) =====

const passport = require('passport');
const GoogleStrategy = require('passport-google-oauth20').Strategy;

passport.use(new GoogleStrategy({
    clientID: process.env.GOOGLE_CLIENT_ID,
    clientSecret: process.env.GOOGLE_CLIENT_SECRET,
    callbackURL: '/auth/google/callback'
  },
  async (accessToken, refreshToken, profile, done) => {
    try {
      let user = await User.findOne({ googleId: profile.id });
      if (!user) {
        user = await User.create({
          googleId: profile.id,
          email: profile.emails[0].value,
          name: profile.displayName
        });
      }
      done(null, user);
    } catch (err) {
      done(err, null);
    }
  }
));

// Routes
app.get('/auth/google',
  passport.authenticate('google', { scope: ['profile', 'email'] })
);
app.get('/auth/google/callback',
  passport.authenticate('google'),
  (req, res) => { res.redirect('/dashboard'); }
);""")

elif auth_type == "apikey":
    print("""// ===== API Key Authentication (Node.js) =====

const crypto = require('crypto');

// Generate a new API key
function generateApiKey() {
  return 'sk_' + crypto.randomBytes(32).toString('hex');
}

// Auth middleware
function apiKeyAuth(req, res, next) {
  const key = req.headers['x-api-key'] || req.query.api_key;
  if (!key) {
    return res.status(401).json({ error: 'API key required' });
  }
  // Validate against database:
  // const valid = await ApiKey.findOne({ key, active: true });
  // if (!valid) return res.status(401).json({ error: 'Invalid API key' });
  next();
}

module.exports = { generateApiKey, apiKeyAuth };""")
else:
    print("Supported auth types: jwt, oauth, apikey")
PYEOF
  echo ""
  echo "// $BRAND"
  ;;

rate-limit)
  python3 - "$ARG" << 'PYEOF'
import sys
rl_type = sys.argv[1] if len(sys.argv) > 1 else "token-bucket"

if rl_type == "token-bucket":
    print("""// ===== Token Bucket Rate Limiter (Node.js) =====

class TokenBucket {
  constructor(capacity, refillRate) {
    this.capacity = capacity;      // Max tokens
    this.refillRate = refillRate;   // Tokens per second
    this.tokens = capacity;
    this.lastRefill = Date.now();
  }

  tryConsume(tokens = 1) {
    this._refill();
    if (this.tokens >= tokens) {
      this.tokens -= tokens;
      return true;
    }
    return false;
  }

  _refill() {
    const now = Date.now();
    const elapsed = (now - this.lastRefill) / 1000;
    this.tokens = Math.min(this.capacity, this.tokens + elapsed * this.refillRate);
    this.lastRefill = now;
  }
}

// Express middleware
const buckets = new Map();
function rateLimiter(capacity = 100, refillRate = 10) {
  return (req, res, next) => {
    const key = req.ip;
    if (!buckets.has(key)) buckets.set(key, new TokenBucket(capacity, refillRate));
    if (buckets.get(key).tryConsume()) {
      next();
    } else {
      res.status(429).json({
        error: 'Too many requests',
        retryAfter: Math.ceil(1 / refillRate)
      });
    }
  };
}

module.exports = { TokenBucket, rateLimiter };""")

elif rl_type == "sliding-window":
    print("""// ===== Sliding Window Rate Limiter (Node.js) =====

class SlidingWindowLimiter {
  constructor(windowMs, maxRequests) {
    this.windowMs = windowMs;
    this.maxRequests = maxRequests;
    this.requests = new Map();
  }

  tryConsume(key) {
    const now = Date.now();
    const windowStart = now - this.windowMs;

    if (!this.requests.has(key)) this.requests.set(key, []);
    const timestamps = this.requests.get(key).filter(t => t > windowStart);
    this.requests.set(key, timestamps);

    if (timestamps.length >= this.maxRequests) return false;
    timestamps.push(now);
    return true;
  }

  remaining(key) {
    const now = Date.now();
    const windowStart = now - this.windowMs;
    const timestamps = (this.requests.get(key) || []).filter(t => t > windowStart);
    return Math.max(0, this.maxRequests - timestamps.length);
  }
}

// Express middleware: 100 requests per minute
function slidingWindowLimiter(windowMs = 60000, maxRequests = 100) {
  const limiter = new SlidingWindowLimiter(windowMs, maxRequests);
  return (req, res, next) => {
    const key = req.ip;
    if (limiter.tryConsume(key)) {
      res.set('X-RateLimit-Remaining', limiter.remaining(key));
      next();
    } else {
      res.status(429).json({ error: 'Rate limit exceeded' });
    }
  };
}

module.exports = { SlidingWindowLimiter, slidingWindowLimiter };""")
else:
    print("Supported types: token-bucket, sliding-window")
PYEOF
  echo ""
  echo "// $BRAND"
  ;;

test)
  python3 - "$ARG" << 'PYEOF'
import sys
name = sys.argv[1] if len(sys.argv) > 1 else "resource"
cap = name.capitalize()
print("""// ===== {cap} API Test Suite (Jest + Supertest) =====

const request = require('supertest');
const app = require('../app');

describe('{cap} API', () => {{
  let created{cap}Id;

  describe('POST /{name}s', () => {{
    it('should create a new {name}', async () => {{
      const res = await request(app)
        .post('/{name}s')
        .send({{ name: 'Test {cap}', description: 'A test {name}' }})
        .expect(201);
      expect(res.body.success).toBe(true);
      expect(res.body.data.name).toBe('Test {cap}');
      created{cap}Id = res.body.data.id;
    }});

    it('should reject invalid data', async () => {{
      await request(app)
        .post('/{name}s')
        .send({{}})
        .expect(400);
    }});
  }});

  describe('GET /{name}s', () => {{
    it('should list {name}s with pagination', async () => {{
      const res = await request(app)
        .get('/{name}s?page=1&limit=10')
        .expect(200);
      expect(res.body.success).toBe(true);
      expect(Array.isArray(res.body.data)).toBe(true);
    }});
  }});

  describe('GET /{name}s/:id', () => {{
    it('should get a single {name}', async () => {{
      const res = await request(app)
        .get('/{name}s/' + created{cap}Id)
        .expect(200);
      expect(res.body.data.id).toBe(created{cap}Id);
    }});

    it('should return 404 for non-existent ID', async () => {{
      await request(app)
        .get('/{name}s/99999')
        .expect(404);
    }});
  }});

  describe('PUT /{name}s/:id', () => {{
    it('should update a {name}', async () => {{
      const res = await request(app)
        .put('/{name}s/' + created{cap}Id)
        .send({{ name: 'Updated {cap}' }})
        .expect(200);
      expect(res.body.data.name).toBe('Updated {cap}');
    }});
  }});

  describe('DELETE /{name}s/:id', () => {{
    it('should delete a {name}', async () => {{
      await request(app)
        .delete('/{name}s/' + created{cap}Id)
        .expect(204);
    }});
  }});
}});""".format(name=name, cap=cap))
PYEOF
  echo ""
  echo "// $BRAND"
  ;;

help|*)
  cat << 'HELPEOF'
╔══════════════════════════════════════════════════╗
║           ⚡ API Generator                       ║
╠══════════════════════════════════════════════════╣
║  rest       <name>  — RESTful CRUD endpoints     ║
║  graphql    <name>  — GraphQL Schema             ║
║  swagger    <name>  — OpenAPI 3.0 spec           ║
║  client     <name>  — API client code            ║
║  mock       <name>  — Mock API server            ║
║  auth       <type>  — Auth (jwt/oauth/apikey)    ║
║  rate-limit <type>  — Rate limiter               ║
║  test       <name>  — API test suite             ║
╚══════════════════════════════════════════════════╝
HELPEOF
  echo "$BRAND"
  ;;

esac
