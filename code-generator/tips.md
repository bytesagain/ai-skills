# 💡 Code Generator Tips

1. **Be specific in descriptions**: "User registration function with email validation and JWT token return" beats "registration function" every time.

2. **CRUD gives you the full stack**: Use `crud` to generate complete Create/Read/Update/Delete in one shot instead of writing each operation separately.

3. **Tests before code (TDD)**: Generate tests with `test` first, then write the implementation to match — catches edge cases early.

4. **Convert preserves logic**: Language conversion keeps the original logic and comments intact — ideal for polyglot projects.

5. **Boilerplate for fast starts**: New project? Run `boilerplate` for a clean directory structure, then fill in business logic.

6. **Review refactor suggestions first**: Read the `refactor` output to understand optimization directions before changing code.

7. **API follows RESTful conventions**: Generated endpoints use proper HTTP methods, status codes, and resource naming by default.
