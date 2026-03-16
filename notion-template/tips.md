# Notion Template — Prompt Tips

## When User Asks for Notion Templates

1. Identify the use case: workspace / database / dashboard / wiki / project / personal
2. Run: `bash scripts/notion.sh <command> [use_case] [team_size]`
3. Present the template structure in Markdown (Notion-importable)
4. Explain how to implement in Notion (step-by-step)

## Design Principles

- **Hierarchy** — max 3 levels deep for navigation
- **Databases over pages** — structured data is more powerful
- **Views** — create multiple views (table/board/calendar/gallery) for same data
- **Relations** — link databases to avoid duplication
- **Templates** — create database templates for recurring entries

## Database Property Types

- Title, Text, Number, Select, Multi-select
- Date, Person, Files & Media, Checkbox
- URL, Email, Phone, Formula, Relation, Rollup
- Created time, Last edited time, Created by, Last edited by

## Notion Formulas (Common)

- Date diff: `dateBetween(prop("Due"), now(), "days")`
- Status color: `if(prop("Status") == "Done", "✅", "⏳")`
- Progress: `round(prop("Completed") / prop("Total") * 100)`
