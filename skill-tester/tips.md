# Skill Tester Tips

1. **Run `validate` first** — Always start with structure validation before anything else; a missing SKILL.md means everything else will fail
2. **Lint early, lint often** — Run `lint` after every SKILL.md edit; catching frontmatter issues early saves debugging time later
3. **Watch your file sizes** — Use `size` to stay under limits; large files slow down skill loading and may be rejected on publish
4. **Audit dependencies** — `deps` catches external commands your scripts rely on; document them or add fallback checks
5. **Benchmark before publishing** — `benchmark` reveals slow scripts; aim for under 2 seconds for common commands
6. **Use `compare` for consistency** — When maintaining multiple skills, compare them to ensure consistent structure and quality levels
7. **Generate a report before release** — `report` gives you a single scorecard; aim for all-green before publishing
8. **Dry-run catches surprises** — `dry-run` simulates the full publish flow; always run it before the real thing
