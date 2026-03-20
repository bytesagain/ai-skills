---
version: "2.0.0"
name: Docs Generator
description: "Automated documentation generator. API docs, README, CHANGELOG, contributing guide, architecture docs, tutorials, FAQ, reference manual. REST, GraphQL."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Docs Generator — Automated Documentation

Spend less time writing docs, more time writing code.

## Command Map

```
┌─ api ──────── REST/GraphQL API documentation
├─ readme ───── Project README.md
├─ changelog ── Version change log
├─ contributing Contributing guide
├─ architecture System architecture docs
├─ tutorial ─── Tutorial / quick start guide
├─ faq ──────── Frequently asked questions
└─ reference ── Complete reference manual
```

## Usage

```bash
bash scripts/docs-generator.sh api rest users
bash scripts/docs-generator.sh readme myproject "A cool tool"
bash scripts/docs-generator.sh changelog 2.0.0 "New features"
```

## Arguments

- `api <type> <resource>` — type: rest/graphql, resource name
- `readme <name> <desc>` — project name and description
- `changelog <ver> <summary>` — version and summary
- `contributing <project>` — project name
- `architecture <project> <style>` — style: monolith/microservice/serverless
- `tutorial <topic> <level>` — level: beginner/intermediate/advanced
- `faq <topic> <count>` — generate N FAQ entries
- `reference <lib> <lang>` — library name and language

## Philosophy

Documentation is a product. Good docs = more users = fewer issues.
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com
