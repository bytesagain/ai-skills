# Docs Generator Tips

1. **Keep docs in sync with code** — Every PR that changes the API should update docs too; use the `api` command to quickly regenerate
2. **README is your storefront** — After running `readme`, make sure the first 3 lines tell readers what it is, how to install it, and how to use it
3. **Use semantic changelog categories** — Added/Changed/Deprecated/Removed/Fixed/Security so users can scan changes at a glance
4. **Keep contributing guides concise** — The `contributing` template covers core essentials; shorter guides get more contributors
5. **Pair architecture docs with diagrams** — Use `architecture` for the text, then add Mermaid or PlantUML diagrams for visual clarity
6. **Build FAQ from real issues** — Collect high-frequency GitHub issues and turn them into FAQ entries to reduce duplicate questions
7. **Level-appropriate tutorials** — Beginner tutorials should assume no prior knowledge; advanced tutorials should skip the basics entirely
