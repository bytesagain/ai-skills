#!/bin/bash
# Drizzle ORM - TypeScript SQL ORM Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              DRIZZLE ORM REFERENCE                          ║
║          TypeScript ORM That Feels Like SQL                 ║
╚══════════════════════════════════════════════════════════════╝

Drizzle is a lightweight TypeScript ORM that lets you write SQL
in TypeScript. It's type-safe, has zero dependencies, and supports
serverless/edge runtimes.

PHILOSOPHY:
  "If you know SQL, you know Drizzle."
  No magic, no complex query builder — just SQL with types.

KEY FEATURES:
  Type-safe      Full TypeScript inference from schema
  SQL-like       API mirrors SQL syntax directly
  Lightweight    ~7KB bundle, zero dependencies
  Migrations     drizzle-kit generate + push
  Edge-ready     Works in Cloudflare Workers, Vercel Edge
  Multi-DB       PostgreSQL, MySQL, SQLite

DRIZZLE vs PRISMA vs TYPEORM:
  ┌──────────────┬──────────┬──────────┬──────────┐
  │ Feature      │ Drizzle  │ Prisma   │ TypeORM  │
  ├──────────────┼──────────┼──────────┼──────────┤
  │ SQL-like API │ Yes      │ No       │ Partial  │
  │ Bundle size  │ ~7KB     │ ~2MB     │ ~500KB   │
  │ Serverless   │ Excellent│ Good*    │ Poor     │
  │ Migrations   │ SQL files│ Own fmt  │ SQL files│
  │ Type safety  │ Inferred │ Generated│ Decorat. │
  │ Raw SQL      │ Seamless │ Template │ Yes      │
  │ Learning     │ Easy     │ Easy     │ Medium   │
  │ Relations    │ Explicit │ Built-in │ Decorat. │
  └──────────────┴──────────┴──────────┴──────────┘
  * Prisma Accelerate/Edge

INSTALL:
  npm install drizzle-orm
  npm install -D drizzle-kit
  # Plus your database driver:
  npm install postgres          # PostgreSQL (postgres.js)
  npm install @libsql/client    # SQLite/Turso
  npm install mysql2             # MySQL
EOF
}

cmd_schema() {
cat << 'EOF'
SCHEMA DEFINITION
===================

POSTGRESQL:
  import { pgTable, serial, text, integer, timestamp,
           boolean, varchar, jsonb, uuid, index } from "drizzle-orm/pg-core";

  export const users = pgTable("users", {
    id: serial("id").primaryKey(),
    name: text("name").notNull(),
    email: varchar("email", { length: 255 }).notNull().unique(),
    age: integer("age"),
    active: boolean("active").default(true),
    metadata: jsonb("metadata"),
    createdAt: timestamp("created_at").defaultNow(),
    updatedAt: timestamp("updated_at").defaultNow(),
  });

  export const posts = pgTable("posts", {
    id: serial("id").primaryKey(),
    title: text("title").notNull(),
    content: text("content"),
    authorId: integer("author_id").references(() => users.id),
    published: boolean("published").default(false),
    createdAt: timestamp("created_at").defaultNow(),
  }, (table) => ({
    authorIdx: index("author_idx").on(table.authorId),
    titleIdx: index("title_idx").on(table.title),
  }));

  export const tags = pgTable("tags", {
    id: serial("id").primaryKey(),
    name: varchar("name", { length: 50 }).notNull().unique(),
  });

  // Many-to-many junction table
  export const postTags = pgTable("post_tags", {
    postId: integer("post_id").references(() => posts.id),
    tagId: integer("tag_id").references(() => tags.id),
  }, (table) => ({
    pk: primaryKey(table.postId, table.tagId),
  }));

SQLITE:
  import { sqliteTable, text, integer } from "drizzle-orm/sqlite-core";

  export const users = sqliteTable("users", {
    id: integer("id").primaryKey({ autoIncrement: true }),
    name: text("name").notNull(),
    email: text("email").unique(),
  });

MYSQL:
  import { mysqlTable, serial, varchar, int } from "drizzle-orm/mysql-core";

  export const users = mysqlTable("users", {
    id: serial("id").primaryKey(),
    name: varchar("name", { length: 255 }).notNull(),
  });

RELATIONS (for query API):
  import { relations } from "drizzle-orm";

  export const usersRelations = relations(users, ({ many }) => ({
    posts: many(posts),
  }));

  export const postsRelations = relations(posts, ({ one, many }) => ({
    author: one(users, { fields: [posts.authorId], references: [users.id] }),
    tags: many(postTags),
  }));
EOF
}

cmd_queries() {
cat << 'EOF'
QUERIES
=========

SETUP:
  import { drizzle } from "drizzle-orm/postgres-js";
  import postgres from "postgres";
  import * as schema from "./schema";

  const client = postgres(process.env.DATABASE_URL!);
  const db = drizzle(client, { schema });

SELECT:
  import { eq, gt, lt, and, or, like, ilike, desc, asc, sql } from "drizzle-orm";

  // All users
  const allUsers = await db.select().from(users);

  // Specific columns
  const names = await db.select({ name: users.name, email: users.email }).from(users);

  // Where clause
  const adults = await db.select().from(users).where(eq(users.active, true));
  const filtered = await db.select().from(users)
    .where(and(gt(users.age, 18), eq(users.active, true)));

  // Like
  const search = await db.select().from(users).where(ilike(users.name, "%alice%"));

  // Order + Limit + Offset
  const page = await db.select().from(users)
    .orderBy(desc(users.createdAt))
    .limit(10).offset(20);

  // Join
  const postsWithAuthors = await db.select({
    title: posts.title,
    authorName: users.name,
  }).from(posts)
    .leftJoin(users, eq(posts.authorId, users.id))
    .where(eq(posts.published, true));

  // Count
  const result = await db.select({ count: sql<number>`count(*)` }).from(users);

INSERT:
  const newUser = await db.insert(users).values({
    name: "Alice", email: "alice@example.com", age: 30,
  }).returning();

  // Bulk insert
  await db.insert(users).values([
    { name: "Alice", email: "alice@example.com" },
    { name: "Bob", email: "bob@example.com" },
  ]);

  // On conflict (upsert)
  await db.insert(users).values({ name: "Alice", email: "alice@example.com" })
    .onConflictDoUpdate({ target: users.email, set: { name: "Alice Updated" } });

UPDATE:
  await db.update(users).set({ active: false }).where(eq(users.id, 1));

DELETE:
  await db.delete(users).where(eq(users.id, 1));

QUERY API (relational):
  // Requires relations defined in schema
  const result = await db.query.users.findMany({
    with: { posts: true },
    where: eq(users.active, true),
    limit: 10,
  });

  const user = await db.query.users.findFirst({
    with: { posts: { with: { tags: true }, where: eq(posts.published, true) } },
    where: eq(users.id, 1),
  });

RAW SQL:
  const result = await db.execute(sql`SELECT * FROM users WHERE age > ${18}`);

TRANSACTIONS:
  await db.transaction(async (tx) => {
    await tx.insert(users).values({ name: "Alice", email: "a@b.com" });
    await tx.insert(posts).values({ title: "First Post", authorId: 1 });
  });
EOF
}

cmd_migrations() {
cat << 'EOF'
MIGRATIONS & CONFIG
=====================

DRIZZLE.CONFIG.TS:
  import { defineConfig } from "drizzle-kit";

  export default defineConfig({
    schema: "./src/schema.ts",
    out: "./drizzle",
    driver: "pg",
    dbCredentials: {
      connectionString: process.env.DATABASE_URL!,
    },
  });

COMMANDS:
  npx drizzle-kit generate    # Generate SQL migration files
  npx drizzle-kit push        # Push schema to DB (no migration files)
  npx drizzle-kit studio      # Visual DB browser (localhost:4983)
  npx drizzle-kit migrate     # Run pending migrations
  npx drizzle-kit introspect  # Generate schema from existing DB

WORKFLOW:
  1. Edit schema.ts
  2. npx drizzle-kit generate     → creates SQL in ./drizzle/
  3. npx drizzle-kit migrate      → applies to database
  4. Commit migration files to git

  # Or for rapid development:
  1. Edit schema.ts
  2. npx drizzle-kit push         → applies directly (no files)

DRIZZLE STUDIO:
  npx drizzle-kit studio
  # Opens visual database browser at https://local.drizzle.studio
  # Browse tables, view data, run queries

EDGE/SERVERLESS SETUP:
  // Cloudflare D1
  import { drizzle } from "drizzle-orm/d1";
  const db = drizzle(env.DB);

  // Turso (LibSQL)
  import { drizzle } from "drizzle-orm/libsql";
  import { createClient } from "@libsql/client";
  const client = createClient({ url: "libsql://...", authToken: "..." });
  const db = drizzle(client);

  // Neon (serverless PostgreSQL)
  import { drizzle } from "drizzle-orm/neon-http";
  import { neon } from "@neondatabase/serverless";
  const sql = neon(process.env.DATABASE_URL!);
  const db = drizzle(sql);

  // PlanetScale
  import { drizzle } from "drizzle-orm/planetscale-serverless";
  import { connect } from "@planetscale/database";
  const db = drizzle(connect({ url: process.env.DATABASE_URL }));

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Drizzle ORM - TypeScript SQL ORM Reference

Commands:
  intro       Overview, comparison, install
  schema      Table definitions, relations, indexes
  queries     Select, insert, update, join, raw SQL
  migrations  drizzle-kit, studio, edge/serverless

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)      cmd_intro ;;
  schema)     cmd_schema ;;
  queries)    cmd_queries ;;
  migrations) cmd_migrations ;;
  help|*)     show_help ;;
esac
