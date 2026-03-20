---
name: MockData
description: "Generate realistic fake data — names, emails, addresses — for testing and dev. Use when seeding databases, mocking API responses, creating sample records."
version: "3.0.0"
author: "BytesAgain"
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
tags: ["mock","fake","data","generator","testing","development","faker","sample"]
categories: ["Developer Tools", "Utility"]
---

# MockData — Mock Data Generator

Generate realistic random data for testing, development, and prototyping. Outputs names, emails, phone numbers, addresses, UUIDs, CSV files, and JSON records.

## Commands

| Command | Description |
|---------|-------------|
| `name [count]` | Generate random full names (first + last, from 160+ name pool) |
| `email [count]` | Generate random email addresses (realistic patterns with varied domains) |
| `phone [count]` | Generate random US phone numbers (+1-XXX-XXX-XXXX format) |
| `address [count]` | Generate random US street addresses with city, state, ZIP |
| `uuid [count]` | Generate random UUID v4 values (from /dev/urandom) |
| `csv <rows> <cols>` | Generate CSV with auto-typed columns (id, name, email, phone, city, score) |
| `json [count]` | Generate JSON array of records with id, name, email, phone, age, city |

## Examples

```bash
# Generate 5 random names
mockdata name 5

# Generate 10 email addresses
mockdata email 10

# Generate UUIDs
mockdata uuid 3

# Generate a CSV file with 100 rows and 4 columns
mockdata csv 100 4 > test-data.csv

# Generate JSON records
mockdata json 5 > users.json

# Combine for seeding
mockdata json 50 > seed.json
```

## Data Sources

- **Names:** 80+ first names × 80+ last names (10,000+ combinations)
- **Emails:** Varied patterns — `first.last@`, `firstlast42@`, `flast@` across 10 domains
- **Phones:** Random US format with valid area code ranges
- **Addresses:** 20 street types × 20 cities × 20 states
- **UUIDs:** Generated from `/dev/urandom` with proper v4 formatting

## CSV Column Types

Columns cycle through these types based on position:
1. `id` (sequential)
2. `name` (random full name)
3. `email` (random email)
4. `phone` (random phone)
5. `city` (random city)
6. `score` (random 0-99)

## Notes

- All output goes to stdout — pipe to a file to save
- JSON output is valid JSON (array of objects)
- No external dependencies — uses bash builtins and `/dev/urandom`
