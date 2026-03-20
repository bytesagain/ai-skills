---
version: "2.0.0"
name: job-search-assistant
description: "Streamline job hunting with resume tailoring, cover letters, and tracking. Use when tailoring resumes, writing covers, or tracking job applications."
author: BytesAgain
homepage: https://bytesagain.com
source: https://github.com/bytesagain/ai-skills
---

# Job Search Assistant

A complete job search tracker and career toolkit. Track applications, get resume tips, generate cover letter templates, prepare for interviews, learn salary negotiation tactics, spot red flags in job postings, and plan your weekly job search — all from the terminal.

## Commands

### Track Applications

| Command | Description |
|---------|-------------|
| `job-search-assistant add <company> <role> [status]` | Add a job application (default status: `applied`) |
| `job-search-assistant update <company> <status>` | Update the status of an existing application |
| `job-search-assistant list [status]` | List all applications, optionally filtered by status |
| `job-search-assistant stats` | Show application statistics (total, by status) |

### Career Preparation

| Command | Description |
|---------|-------------|
| `job-search-assistant resume <role>` | Get resume tips (one-page rule, quantify impact, ATS-friendly format) |
| `job-search-assistant cover-letter <company> <role>` | Generate a cover letter template for a specific company and role |
| `job-search-assistant interview <type>` | Interview prep — `behavioral` (STAR method) or `technical` (LeetCode, system design) |
| `job-search-assistant questions <role>` | Get a Glassdoor search suggestion for common interview questions |
| `job-search-assistant negotiate` | Salary negotiation tips (market research, counter-offer strategy, total comp) |

### Research & Planning

| Command | Description |
|---------|-------------|
| `job-search-assistant red-flags` | Common red flags in job postings to watch out for |
| `job-search-assistant weekly-plan` | A structured weekly job search plan (Mon–Fri breakdown) |
| `job-search-assistant help` | Show the built-in help message |
| `job-search-assistant version` | Print the current version |

## Data Storage

Application data is stored in `$DATA_DIR/applications.txt` as pipe-delimited records (`date|company|role|status`). Activity history is logged to `$DATA_DIR/history.log`. The default data directory is `~/.local/share/job-search-assistant/`. Override it by setting the `JOB_DIR` environment variable.

## Requirements

- Bash 4+ with standard Unix utilities (`date`, `wc`, `grep`, `sed`)
- No external dependencies or API keys required
- Works on any Linux/macOS terminal

## When to Use

1. **Starting a job search** — Use `weekly-plan` to structure your week and `add` to begin tracking every application you submit.
2. **Preparing for an interview** — Run `interview behavioral` or `interview technical` to get prep frameworks (STAR method, LeetCode tips, system design advice).
3. **Writing application materials** — Use `resume <role>` for tailoring tips and `cover-letter <company> <role>` for a ready-to-customize template.
4. **Evaluating a job posting** — Run `red-flags` to check a posting against common warning signs like vague descriptions, "we're a family", or no salary range.
5. **Negotiating an offer** — Use `negotiate` for tactics on countering offers, understanding total compensation, and negotiating perks like WFH and PTO.

## Examples

```bash
# Add a new application
job-search-assistant add Google "Software Engineer" applied

# Update status after an interview
job-search-assistant update Google interview

# List all applications with "interview" status
job-search-assistant list interview

# View application statistics
job-search-assistant stats

# Get resume tips
job-search-assistant resume "Backend Developer"

# Generate a cover letter template
job-search-assistant cover-letter Stripe "Product Manager"

# Prepare for a behavioral interview
job-search-assistant interview behavioral

# Get salary negotiation advice
job-search-assistant negotiate

# Check job posting red flags
job-search-assistant red-flags

# Get a weekly search plan
job-search-assistant weekly-plan
```

## How It Works

Job Search Assistant stores all data locally in plain text files. Applications are pipe-delimited for easy parsing. Every command is logged with timestamps so you can track your search activity over time. No data leaves your machine — everything stays in your local data directory.

## Configuration

Set `JOB_DIR` to change the data directory:

```bash
export JOB_DIR=/custom/path
```

Default: `~/.local/share/job-search-assistant/`

---

Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
