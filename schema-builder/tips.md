# Schema Builder Tips

1. **Design before SQL** — Sort out fields and relations first with `design`, then generate DDL with `sql`. Saves ALTER headaches
2. **Naming conventions** — Table names: plural lowercase (`users`). Columns: snake_case (`created_at`)
3. **Three mandatory columns** — Every table gets `id`, `created_at`, `updated_at`. Don't bolt them on later
4. **Index WHERE and JOIN columns** — Add indexes on filtered/joined fields. Use `optimize` to catch gaps
5. **Test with seed data** — Run `seed` output through your business logic. It exposes design flaws fast
6. **Always use migrations** — Every schema change goes through `migrate`. Never ALTER production directly
7. **SQL vs NoSQL** — Clear relationships? Use SQL. Flexible nested docs? Use `nosql` for MongoDB schemas
8. **Diff before deploy** — Run `compare` on dev vs prod schemas before release to catch missed changes
