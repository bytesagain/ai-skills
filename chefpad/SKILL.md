---
version: "2.0.0"
name: cooking-recipe
description: "Make a recipe by giving some ingredients. Use when you need cooking recipe capabilities. Triggers on: cooking recipe."
author: BytesAgain
---

A ClawdHub skill for managing recipes and grocery lists via cooking-recipe.

## Data routing + security disclosure (mandatory)

- Shared backend/API target: `[configured-endpoint]
- Auth and recipe/grocery API traffic goes to configured `CONVEX_URL`.
- Shared backend usage is blocked unless `ALLOW_DEFAULT_BACKEND=true`.
- Never claim local-only processing when backend calls are involved.

## Use when / don't use when (routing guardrails)

Use when:
- User asks to add/list/search/show/delete cooking-recipe recipes.
- User asks to create/view/update cooking-recipe grocery lists.
- User asks to authenticate for cooking-recipe commands.

Do NOT use when:
- User asks for general meal ideas (no cooking-recipe action requested).
- User asks for health/nutrition analysis outside stored cooking-recipe data.
- User asks to manage Apple Reminders/Notes/other systems.

## Setup

1. Install:
   ```bash
   clawdhub install cooking-recipe
   ```

2. Configure environment:
   ```bash
   cp .env.example .env
   ```

3. Environment variables:
   - `CONVEX_URL` (**required**, recommended self-hosted backend)
   - `ALLOW_DEFAULT_BACKEND=true` (only if intentionally using shared backend)
   - OAuth provider creds:
     - GitHub (required): `AUTH_GITHUB_ID`, `AUTH_GITHUB_SECRET`, `GITHUB_CALLBACK_URL`
     - Google (optional): `AUTH_GOOGLE_ID`, `AUTH_GOOGLE_SECRET`, `GOOGLE_CALLBACK_URL`
     - Apple (optional): `AUTH_APPLE_ID`, `AUTH_APPLE_SECRET`, `APPLE_CALLBACK_URL`
   - `CLAWDBOT_URL` (required, bot callback host)

## Commands

- `cooking-recipe login`
- `cooking-recipe logout`
- `cooking-recipe add <url>`
- `cooking-recipe list`
- `cooking-recipe search <term>`
- `cooking-recipe show <id>`
- `cooking-recipe delete <id>`
- `cooking-recipe lists`
- `cooking-recipe list-show <id>`
- `cooking-recipe list-create <name>`
- `cooking-recipe list-add <listId> <recipeId>`
- `cooking-recipe help`

## Output templates

Use response formatting templates from `references/output-templates.md`.

## Security checklist before replying

- If command failed due to auth/config, provide exact next step.
- If backend is relevant, keep disclosure truthful (shared default vs override).
- Never expose secrets/tokens in output.
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
