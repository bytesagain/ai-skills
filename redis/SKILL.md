# redis

Redis command reference and connection testing tool. Browse commands by category, test live connections with redis-cli, and monitor key statistics — all from the terminal. Works offline as a cheatsheet even without a running Redis instance.

## Usage

```
redis cheatsheet [category]
redis test [host] [port]
redis monitor [host] [port]
```

## Commands

- `cheatsheet` — Browse Redis commands by category (string, list, hash, set, zset, key, server, scripting)
- `test` — Test connection to a Redis instance and show basic info
- `monitor` — Show key count, memory usage, and connected clients

## Examples

```bash
redis cheatsheet
redis cheatsheet hash
redis cheatsheet string
redis test
redis test localhost 6379
redis test 192.168.1.10 6380
redis monitor
redis monitor localhost 6379
```

## Requirements

- bash
- redis-cli (optional — cheatsheet works without it)

## When to Use

Use when writing Redis commands and need a quick reference, when debugging Redis connectivity, or when checking instance health and key statistics from the terminal.
