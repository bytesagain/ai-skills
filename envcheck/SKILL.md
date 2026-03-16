---
name: EnvCheck
description: "Environment variable manager and .env file toolkit. List environment variables, search by name or value, validate .env files for common issues, compare environments, check for required variables, and safely export variables. Developer-essential env management."
version: "2.0.0"
author: "BytesAgain"
tags: ["env","environment","dotenv","config","variables","developer","devops","twelve-factor"]
categories: ["Developer Tools", "Utility"]
---
# EnvCheck
Manage environment variables and .env files like a pro.
## Commands
- `list [filter]` — List env vars (optional grep filter)
- `get <name>` — Get specific variable
- `check <file>` — Validate .env file
- `diff <file1> <file2>` — Compare two .env files
- `required <file> <var1,var2,...>` — Check required vars exist
- `export <file>` — Show export commands for .env file
## Usage Examples
```bash
envcheck list PATH
envcheck get HOME
envcheck check .env
envcheck required .env "DB_HOST,DB_PORT,API_KEY"
```
---
Powered by BytesAgain | bytesagain.com

---
*Powered by BytesAgain | bytesagain.com*
*Feedback & Feature Requests: https://bytesagain.com/feedback*
