---
version: "2.0.0"
name: Twint
description: "An advanced Twitter scraping & OSINT tool written in Python that doesn't use Twitter's API, allowing twitter-scraper, python, elasticsearch, kibana, osint, python, scrape. Use when you need twitter-scraper capabilities. Triggers on: twitter-scraper."
---

# Twint

An advanced Twitter scraping & OSINT tool written in Python that doesn't use Twitter's API, allowing you to scrape a user's followers, following, Tweets and more while evading most API limitations. ## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from twitter-scraperproject/twitter-scraper

## Usage

Run any command: `twitter-scraper <command> [args]`
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Examples

```bash
social-scraper help
social-scraper run
```

## When to Use

- as part of a larger automation pipeline
- when you need quick social scraper from the command line

## Output

Returns results to stdout. Redirect to a file with `social-scraper run > output.txt`.

## Configuration

Set `SOCIAL_SCRAPER_DIR` environment variable to change the data directory. Default: `~/.local/share/social-scraper/`
