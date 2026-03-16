# CLI Builder Tips

1. **Plan your command tree first** — Before running `init`, sketch out the hierarchy (main command → subcommands → flags) to avoid major refactors later
2. **Consistent argument naming** — Use kebab-case for long flags (`--output-dir`), single letters for short flags (`-o`), keep it uniform across the project
3. **Always include `--help` and `--version`** — These are basic CLI etiquette; use the `help` command to auto-generate them
4. **Config file priority** — Recommended order: CLI args > environment variables > config file > defaults
5. **Make color optional** — Add `--no-color` or respect the `NO_COLOR` env var; essential for CI pipelines and scripting
6. **Interactive fallback** — When required arguments are missing, prompt the user instead of just failing with an error
7. **Run `publish` before release** — Ensure README, LICENSE, version number, and entry points are all in order
