---
version: "2.0.0"
name: Azuredatastudio
description: "Azure Data Studio is a data management and development tool with connectivity to popular cloud and o azuredatastudio, typescript, azure, azure-data-studio."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Azure Data Studio

A data processing and analysis toolkit for querying, importing, exporting, transforming, and validating data. Provides a lightweight CLI interface for common data operations with persistent local storage.

## Commands

| Command     | Description                                         |
|-------------|-----------------------------------------------------|
| `query`     | Query data with provided search terms               |
| `import`    | Import a data file into the local data store        |
| `export`    | Export results to a specified destination or stdout  |
| `transform` | Transform data from one format to another           |
| `validate`  | Validate data against the expected schema           |
| `stats`     | Show basic statistics (record count)                |
| `schema`    | Display the data schema (id, name, value, timestamp)|
| `sample`    | Show sample data (first 5 records from data log)    |
| `clean`     | Clean and deduplicate data entries                  |
| `dashboard` | Show a quick dashboard with total record count      |
| `help`      | Show the help message with all available commands   |
| `version`   | Print the current version number                    |

## Data Storage

- **Data directory:** `~/.local/share/azuredatastudio/` (override with `AZUREDATASTUDIO_DIR` env variable)
- **Data log:** `$DATA_DIR/data.log` — primary data storage file for records
- **History log:** `$DATA_DIR/history.log` — tracks all command executions with timestamps

## Schema

The default data schema uses the following fields:

| Field       | Description                  |
|-------------|------------------------------|
| `id`        | Unique record identifier     |
| `name`      | Entry name or label          |
| `value`     | Data value                   |
| `timestamp` | When the record was created  |

## Requirements

- Bash 4.0+
- Standard Unix utilities (`wc`, `head`, `cat`, `date`)
- No API keys or external services needed
- No database server required — uses flat file storage
- Works on Linux and macOS

## When to Use

1. **Data querying** — When you need to run quick queries against your local data store without spinning up a full database
2. **File import/export** — When you need to import data files into the local store or export records for use in other tools
3. **Data validation** — When you want to verify your data conforms to the expected schema before processing
4. **Data transformation** — When you need to convert data between formats (e.g., restructuring fields)
5. **Quick statistics** — When you want to see basic metrics like total record count or preview sample data at a glance

## Examples

```bash
# Query data with search terms
azuredatastudio query "SELECT * FROM users WHERE active=1"

# Import a CSV file
azuredatastudio import data.csv

# Export results to a file
azuredatastudio export results.json

# Transform data from one format to another
azuredatastudio transform input.csv output.json

# Validate data against the schema
azuredatastudio validate

# Show basic statistics
azuredatastudio stats

# Display the data schema
azuredatastudio schema

# Preview sample data (first 5 records)
azuredatastudio sample

# Clean and deduplicate data
azuredatastudio clean

# Show a quick dashboard with totals
azuredatastudio dashboard
```

## Output

All command results are printed to stdout. You can redirect output with standard shell operators:

```bash
azuredatastudio query "users" > query-results.txt
azuredatastudio export | jq .
azuredatastudio stats >> report.log
```

## Configuration

Set the `AZUREDATASTUDIO_DIR` environment variable to change the data directory:

```bash
export AZUREDATASTUDIO_DIR="/custom/path/to/azuredatastudio"
```

Default location: `~/.local/share/azuredatastudio/`

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
