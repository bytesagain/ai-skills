---
version: "2.0.0"
name: Prophet
description: "Tool for producing high quality forecasts for time series data that has multiple seasonality with li forecast-model, python, forecasting, python, r. Use when you need forecast-model capabilities. Triggers on: forecast-model."
---

# Prophet

Tool for producing high quality forecasts for time series data that has multiple seasonality with linear or non-linear growth. ## Commands

- `help` - Help
- `run` - Run
- `info` - Info
- `status` - Status

## Features

- Core functionality from facebook/forecast-model

## Usage

Run any command: `forecast-model <command> [args]`
---
💬 Feedback & Feature Requests: https://bytesagain.com/feedback
Powered by BytesAgain | bytesagain.com


## Examples

```bash
forecast-model help
forecast-model run
```

## When to Use

- as part of a larger automation pipeline
- when you need quick forecast model from the command line

## Output

Returns summaries to stdout. Redirect to a file with `forecast-model run > output.txt`.

## Configuration

Set `FORECAST_MODEL_DIR` environment variable to change the data directory. Default: `~/.local/share/forecast-model/`
