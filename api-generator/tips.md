# API Generator Tips

1. **Swagger first, code second** — Define your API contract with `swagger` before writing `rest` code. Keeps docs and code in sync.
2. **Mock-driven development** — Use `mock` to spin up a fake API so frontend can start work in parallel
3. **Always add auth** — Every public-facing API needs authentication. `auth jwt` is the most common starting point
4. **Rate-limit public APIs** — Prevent abuse with `rate-limit`. Token bucket fits most use cases
5. **Test edge cases** — After generating tests with `test`, add boundary cases: empty values, overlong strings, concurrent requests
6. **Centralize API calls** — Use `client` to generate a unified API layer. No more scattered fetch/axios calls
7. **GraphQL for flexibility** — Use `graphql` schemas to let clients query only what they need, reducing data transfer
8. **Version your specs** — Commit swagger docs to git. API changes should have a paper trail
