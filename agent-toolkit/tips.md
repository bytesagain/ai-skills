# Agent Toolkit — Tips

1. **Scaffold first** — Always start with a clean project structure. It prevents spaghetti organization later.

2. **Version your prompts** — System prompts evolve. Keep them in version control alongside your code.

3. **Validate tool schemas** — Malformed JSON schemas cause silent failures. Always validate before deploying.

4. **Keep chains simple** — Start with linear workflows before adding branching. Complexity should be earned.

5. **Debug systematically** — Use debug mode to trace exact input/output at each chain step before guessing.

6. **Monitor from day one** — Don't add monitoring as an afterthought. Set it up during development.

7. **Use the deploy checklist** — Skipping pre-launch checks is how agents break in production.

8. **Config over hardcode** — Put tunable parameters in config files, not buried in code.
