---
name: "event"
version: "1.0.0"
description: "Event-driven architecture reference — event sourcing, pub/sub, CQRS, event buses, and stream processing. Use when designing event systems, implementing pub/sub, or building event-driven microservices."
author: "BytesAgain"
homepage: "https://bytesagain.com"
source: "https://github.com/bytesagain/ai-skills"
tags: [event, event-driven, pub-sub, cqrs, event-sourcing, streaming, devtools]
category: "devtools"
---

# Event — Event-Driven Architecture Reference

Quick-reference skill for event-driven architecture, event sourcing, pub/sub patterns, and stream processing.

## When to Use

- Designing event-driven microservice architectures
- Implementing pub/sub or event bus patterns
- Building event sourcing and CQRS systems
- Choosing between event brokers (Kafka, RabbitMQ, etc.)
- Handling event ordering, idempotency, and exactly-once semantics

## Commands

### `intro`

```bash
scripts/script.sh intro
```

Overview of event-driven architecture — patterns, benefits, and tradeoffs.

### `patterns`

```bash
scripts/script.sh patterns
```

Core patterns — pub/sub, event sourcing, CQRS, saga, choreography.

### `design`

```bash
scripts/script.sh design
```

Event design — naming, schema, versioning, and payload structure.

### `brokers`

```bash
scripts/script.sh brokers
```

Event broker comparison — Kafka, RabbitMQ, NATS, Pulsar, SQS, EventBridge.

### `sourcing`

```bash
scripts/script.sh sourcing
```

Event sourcing deep dive — event store, projections, snapshots.

### `delivery`

```bash
scripts/script.sh delivery
```

Delivery guarantees — at-most-once, at-least-once, exactly-once.

### `stream`

```bash
scripts/script.sh stream
```

Stream processing — windowing, aggregation, and real-time analytics.

### `checklist`

```bash
scripts/script.sh checklist
```

Event-driven architecture checklist.

### `help`

```bash
scripts/script.sh help
```

### `version`

```bash
scripts/script.sh version
```

## Configuration

| Variable | Description |
|----------|-------------|
| `EVENT_DIR` | Data directory (default: ~/.event/) |

---

*Powered by BytesAgain | bytesagain.com | hello@bytesagain.com*
