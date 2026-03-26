#!/bin/bash
# Fastify - Fast Node.js Web Framework Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              FASTIFY REFERENCE                              ║
║          Fast and Low Overhead Node.js Framework            ║
╚══════════════════════════════════════════════════════════════╝

Fastify is a web framework for Node.js focused on performance and
developer experience. It's the fastest Node.js framework.

KEY FEATURES:
  Fast           ~77K req/s (vs Express ~16K req/s)
  Schema-based   JSON Schema for validation + serialization
  Plugin system  Encapsulated, composable plugins
  TypeScript     First-class TypeScript support
  Logging        Built-in Pino logger (structured, fast)
  Hooks          Full lifecycle hooks for requests
  Decorators     Extend request, reply, or app

FASTIFY vs EXPRESS vs HONO vs KOA:
  ┌──────────────┬──────────┬──────────┬──────────┬──────────┐
  │ Feature      │ Fastify  │ Express  │ Hono     │ Koa      │
  ├──────────────┼──────────┼──────────┼──────────┼──────────┤
  │ Speed        │ ~77K/s   │ ~16K/s   │ ~100K/s* │ ~25K/s   │
  │ Validation   │ Built-in │ Middleware│ Zod/Vali│ Middleware│
  │ TypeScript   │ Great    │ @types   │ Native   │ @types   │
  │ Plugins      │ Built-in │ Middleware│ Middleware│Middleware│
  │ Logging      │ Pino     │ Morgan   │ Custom   │ Custom   │
  │ Schema       │ JSON Sch │ None     │ Optional │ None     │
  │ Ecosystem    │ Growing  │ Largest  │ Growing  │ Medium   │
  └──────────────┴──────────┴──────────┴──────────┴──────────┘
  * Hono benchmarks vary by runtime

INSTALL:
  npm install fastify
  # With TypeScript
  npm install fastify @fastify/type-provider-typebox
EOF
}

cmd_basics() {
cat << 'EOF'
BASIC USAGE
=============

HELLO WORLD:
  import Fastify from "fastify";
  const app = Fastify({ logger: true });

  app.get("/", async (request, reply) => {
    return { hello: "world" };
  });

  app.listen({ port: 3000 }, (err) => {
    if (err) throw err;
  });

ROUTES:
  // GET
  app.get("/users", async (request, reply) => {
    return db.getUsers();
  });

  // POST with body
  app.post("/users", async (request, reply) => {
    const { name, email } = request.body;
    const user = await db.createUser({ name, email });
    reply.code(201).send(user);
  });

  // URL params
  app.get("/users/:id", async (request, reply) => {
    const { id } = request.params;
    const user = await db.getUser(id);
    if (!user) return reply.code(404).send({ error: "Not found" });
    return user;
  });

  // Query string
  app.get("/search", async (request, reply) => {
    const { q, page = 1, limit = 10 } = request.query;
    return db.search(q, { page, limit });
  });

  // Multiple methods
  app.route({
    method: ["GET", "HEAD"],
    url: "/health",
    handler: async () => ({ status: "ok" }),
  });

SCHEMA VALIDATION:
  app.post("/users", {
    schema: {
      body: {
        type: "object",
        required: ["name", "email"],
        properties: {
          name: { type: "string", minLength: 2 },
          email: { type: "string", format: "email" },
          age: { type: "integer", minimum: 0 },
        },
      },
      response: {
        201: {
          type: "object",
          properties: {
            id: { type: "integer" },
            name: { type: "string" },
            email: { type: "string" },
          },
        },
      },
    },
    handler: async (request, reply) => {
      // request.body is already validated!
      const user = await db.createUser(request.body);
      reply.code(201).send(user);
    },
  });

  // Schema validation is automatic — invalid requests get 400 with details

REPLY:
  reply.code(201).send({ id: 1 });
  reply.header("X-Custom", "value").send(data);
  reply.type("text/html").send("<h1>Hello</h1>");
  reply.redirect("/new-url");
  reply.redirect(301, "/permanent-new-url");
EOF
}

cmd_plugins() {
cat << 'EOF'
PLUGINS & HOOKS
=================

PLUGIN PATTERN:
  // plugins/database.js
  import fp from "fastify-plugin";

  async function dbPlugin(fastify, options) {
    const db = await connectToDatabase(options.connectionString);
    fastify.decorate("db", db);

    fastify.addHook("onClose", async () => {
      await db.close();
    });
  }

  export default fp(dbPlugin);

  // app.js
  app.register(import("./plugins/database.js"), {
    connectionString: process.env.DATABASE_URL,
  });

  // Now available everywhere:
  app.get("/users", async (request, reply) => {
    return app.db.query("SELECT * FROM users");
  });

ENCAPSULATION:
  // Plugins are encapsulated by default
  app.register(async (instance) => {
    // This decorator is only available inside this scope
    instance.decorate("secret", "hidden");

    instance.get("/private", async () => {
      return { secret: instance.secret };
    });
  }, { prefix: "/api/v1" });

  // app.secret → undefined (not visible outside)

LIFECYCLE HOOKS:
  onRequest      → Before routing
  preParsing     → Before body parsing
  preValidation  → Before schema validation
  preHandler     → Before handler (auth goes here)
  preSerialization → Before response serialization
  onSend         → Before sending response
  onResponse     → After response sent (logging)
  onError        → On error

  app.addHook("preHandler", async (request, reply) => {
    const token = request.headers.authorization?.replace("Bearer ", "");
    if (!token) return reply.code(401).send({ error: "Unauthorized" });
    request.user = await verifyToken(token);
  });

DECORATORS:
  // App-level
  app.decorate("utility", { hash, verify });

  // Request-level
  app.decorateRequest("user", null);

  // Reply-level
  app.decorateReply("sendError", function(code, message) {
    this.code(code).send({ error: message });
  });

POPULAR PLUGINS:
  @fastify/cors          CORS support
  @fastify/helmet        Security headers
  @fastify/rate-limit    Rate limiting
  @fastify/jwt           JWT authentication
  @fastify/cookie        Cookie parsing
  @fastify/session       Session management
  @fastify/multipart     File uploads
  @fastify/static        Static file serving
  @fastify/swagger       OpenAPI documentation
  @fastify/websocket     WebSocket support

  app.register(import("@fastify/cors"), { origin: true });
  app.register(import("@fastify/helmet"));
  app.register(import("@fastify/rate-limit"), { max: 100, timeWindow: "1 minute" });
EOF
}

cmd_advanced() {
cat << 'EOF'
ADVANCED PATTERNS
===================

TYPESCRIPT:
  import Fastify, { FastifyRequest, FastifyReply } from "fastify";
  import { Type, Static } from "@sinclair/typebox";

  const UserSchema = Type.Object({
    name: Type.String({ minLength: 2 }),
    email: Type.String({ format: "email" }),
  });

  type UserType = Static<typeof UserSchema>;

  app.post<{ Body: UserType }>("/users", {
    schema: { body: UserSchema },
    handler: async (request, reply) => {
      // request.body is fully typed as UserType
      const { name, email } = request.body;
    },
  });

ERROR HANDLING:
  // Custom error handler
  app.setErrorHandler((error, request, reply) => {
    request.log.error(error);
    if (error.validation) {
      return reply.code(422).send({ error: "Validation failed", details: error.validation });
    }
    reply.code(error.statusCode || 500).send({
      error: error.message || "Internal Server Error",
    });
  });

  // 404 handler
  app.setNotFoundHandler((request, reply) => {
    reply.code(404).send({ error: "Route not found" });
  });

TESTING:
  import { test } from "node:test";
  import { build } from "./app.js";

  test("GET / returns hello", async (t) => {
    const app = build();
    const response = await app.inject({
      method: "GET",
      url: "/",
    });
    assert.strictEqual(response.statusCode, 200);
    assert.deepStrictEqual(response.json(), { hello: "world" });
  });

  // No need for a running server — inject() simulates requests

LOGGING (Pino):
  const app = Fastify({
    logger: {
      level: "info",
      transport: {
        target: "pino-pretty",  // Dev only
      },
    },
  });

  // In handlers:
  request.log.info("Processing request");
  request.log.error({ err }, "Something failed");

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Fastify - Fast Node.js Web Framework Reference

Commands:
  intro      Overview, comparison, benchmarks
  basics     Routes, schema validation, replies
  plugins    Plugin system, hooks, decorators
  advanced   TypeScript, errors, testing, logging

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)    cmd_intro ;;
  basics)   cmd_basics ;;
  plugins)  cmd_plugins ;;
  advanced) cmd_advanced ;;
  help|*)   show_help ;;
esac
