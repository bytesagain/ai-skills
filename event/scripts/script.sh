#!/usr/bin/env bash
# event — Event-Driven Architecture Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="1.0.0"

cmd_intro() {
    cat << 'EOF'
=== Event-Driven Architecture Overview ===

Event-Driven Architecture (EDA) is a software design pattern where
the flow of the program is determined by events — significant changes
in state that the system needs to know about.

Core Concepts:
  Event       An immutable record of something that happened
              "OrderPlaced", "UserRegistered", "PaymentReceived"
  Producer    Component that creates/emits events
  Consumer    Component that receives and processes events
  Broker      Middleware that routes events (Kafka, RabbitMQ)
  Topic       Named channel for a category of events
  Subscription Binding between consumer and topic

Event vs Command vs Query:
  Event     Past tense, fact, immutable    "OrderWasPlaced"
  Command   Imperative, request, may fail  "PlaceOrder"
  Query     Request for data, no mutation  "GetOrderStatus"

Benefits:
  ✓ Loose coupling (producers don't know consumers)
  ✓ Scalability (consumers scale independently)
  ✓ Extensibility (add consumers without changing producers)
  ✓ Resilience (async processing, buffering)
  ✓ Audit trail (events are a log of everything)
  ✓ Real-time reactions

Tradeoffs:
  ✗ Eventual consistency (not immediately consistent)
  ✗ Debugging complexity (distributed, async)
  ✗ Event ordering challenges
  ✗ Schema evolution management
  ✗ Idempotency requirements
  ✗ Monitoring and observability overhead

When to Use EDA:
  ✓ Multiple systems need to react to the same action
  ✓ Real-time processing requirements
  ✓ Need to decouple microservices
  ✓ Audit trail / compliance requirements
  ✓ Systems that process at different speeds

When NOT to Use:
  ✗ Simple CRUD applications
  ✗ Strong consistency required (banking transactions)
  ✗ Synchronous response needed
  ✗ Small team / simple architecture
EOF
}

cmd_patterns() {
    cat << 'EOF'
=== Event-Driven Patterns ===

1. Publish/Subscribe (Pub/Sub):
   Producer → Topic → [Consumer A, Consumer B, Consumer C]
   - One-to-many communication
   - Consumers subscribe to topics of interest
   - New consumers can be added without changing producers
   - Use: notifications, fan-out, broadcasting

2. Event Sourcing:
   Store all state changes as a sequence of events
   Current state = replay all events from the beginning
   Events: OrderCreated → ItemAdded → ItemAdded → OrderSubmitted
   State:  {items: [A, B], status: "submitted"}
   Use: audit trails, temporal queries, undo capability

3. CQRS (Command Query Responsibility Segregation):
   Separate models for reading and writing:
   Write Side: Command → Event → Event Store
   Read Side:  Event → Projection → Read Database
   Use: different optimization for reads vs writes

4. Saga Pattern:
   Coordinate distributed transactions across services:

   Choreography (event-based):
     OrderService → OrderCreated → PaymentService
     PaymentService → PaymentProcessed → InventoryService
     InventoryService → ItemReserved → ShippingService
     (Each service reacts to events and emits events)

   Orchestration (command-based):
     SagaOrchestrator sends commands to each service
     Manages compensating transactions on failure
     More control, single point of coordination

5. Event Notification:
   Light events that signal something happened
   Consumer queries source for full data if needed
   {type: "OrderPlaced", orderId: "123"}
   Use: when event payload would be too large

6. Event-Carried State Transfer:
   Events contain all data consumer needs
   No need to call back to source
   {type: "OrderPlaced", order: {id, items, total, customer}}
   Use: when consumer needs autonomy, offline capability

7. Dead Letter Queue (DLQ):
   Failed events → DLQ for manual review
   Prevents poison messages from blocking processing
   Alert operators when DLQ grows
EOF
}

cmd_design() {
    cat << 'EOF'
=== Event Design ===

Event Naming:
  Format: <Entity><PastTenseVerb>
  ✓ OrderPlaced, PaymentReceived, UserRegistered
  ✓ InventoryAdjusted, ShipmentDelivered
  ✗ PlaceOrder (command, not event)
  ✗ OrderEvent (too vague)
  ✗ order_data (not descriptive)

Event Schema:
  {
    "eventId": "evt_abc123",         // Unique ID (UUID)
    "eventType": "OrderPlaced",      // Event type name
    "version": 1,                    // Schema version
    "timestamp": "2024-01-15T10:30:45.123Z",  // ISO 8601
    "source": "order-service",       // Producing service
    "correlationId": "req_xyz789",   // Request correlation
    "causationId": "evt_prev456",    // What caused this event
    "data": {                        // Event-specific payload
      "orderId": "ord_123",
      "customerId": "cust_456",
      "items": [...],
      "totalAmount": 99.99,
      "currency": "USD"
    },
    "metadata": {                    // Non-business data
      "userId": "usr_789",
      "traceId": "trace_abc",
      "environment": "production"
    }
  }

Schema Evolution Strategies:
  1. Backward Compatible (safest):
     - Add new optional fields
     - Never remove fields
     - Never change field types
     - Old consumers handle new events fine

  2. Schema Registry:
     - Central registry of event schemas (Confluent, Apicurio)
     - Validate events against schema before publishing
     - Enforce compatibility rules
     - Track schema versions

  3. Versioned Events:
     - OrderPlaced.v1, OrderPlaced.v2
     - Consumers subscribe to specific version
     - Upcasting: transform old events to new format
     - Downcasting: transform new events for old consumers

  4. Consumer-Driven Contracts:
     - Consumers declare what fields they need
     - Producer ensures those fields are present
     - Extra fields ignored by consumers

Event Size Guidelines:
  Small (< 1 KB)    Notifications, signals
  Medium (1-10 KB)  Entity state changes (most events)
  Large (10-100 KB) Batch operations, full document
  Too large (> 1 MB) Use claim check pattern (store data externally)

Claim Check Pattern:
  For large payloads:
  1. Store large data in blob storage (S3, GCS)
  2. Event contains reference: {dataUrl: "s3://bucket/key"}
  3. Consumer fetches data from storage
  4. Keeps events small and broker efficient
EOF
}

cmd_brokers() {
    cat << 'EOF'
=== Event Broker Comparison ===

Apache Kafka:
  Type: Distributed log / streaming platform
  Delivery: At-least-once (exactly-once with transactions)
  Ordering: Per-partition ordering guaranteed
  Retention: Configurable (time or size based, or forever)
  Throughput: Very high (millions msg/sec per cluster)
  Consumer model: Pull-based, consumer groups
  Use: High-throughput streaming, event sourcing, log aggregation
  Ecosystem: Kafka Streams, ksqlDB, Kafka Connect

RabbitMQ:
  Type: Message broker (AMQP)
  Delivery: At-least-once (with confirms)
  Ordering: Per-queue FIFO
  Retention: Messages deleted after consumption
  Throughput: Moderate (tens of thousands msg/sec)
  Consumer model: Push-based, acknowledgments
  Patterns: Direct, topic, fanout, headers exchanges
  Use: Task queues, RPC, traditional messaging

NATS:
  Type: Cloud-native messaging
  Delivery: At-most-once (Core), at-least-once (JetStream)
  Ordering: Per-subject (JetStream)
  Throughput: Very high, low latency
  Footprint: Lightweight (single binary, <20MB)
  Use: Microservices, IoT, edge computing
  Modes: Pub/Sub, Request/Reply, Queue Groups

Apache Pulsar:
  Type: Distributed messaging + streaming
  Delivery: At-least-once, effectively-once
  Ordering: Per-partition
  Retention: Tiered storage (hot + cold)
  Features: Multi-tenancy, geo-replication native
  Use: Multi-tenant platforms, hybrid cloud

AWS Services:
  SQS          Queue service, at-least-once, auto-scaling
  SNS          Pub/sub notifications, push to SQS/Lambda/HTTP
  EventBridge  Event bus, rules-based routing, schema registry
  Kinesis      Real-time streaming (Kafka-like)
  MSK          Managed Kafka

Choosing a Broker:
  Need replay?          → Kafka, Pulsar
  Simple queuing?       → RabbitMQ, SQS
  Lowest latency?       → NATS
  Serverless?           → EventBridge, SQS + Lambda
  Multi-tenant?         → Pulsar
  Already on AWS?       → SQS + SNS or EventBridge
  Team expertise?       → Use what you know
EOF
}

cmd_sourcing() {
    cat << 'EOF'
=== Event Sourcing Deep Dive ===

Core Idea:
  Instead of storing current state, store all state changes (events).
  Current state is derived by replaying events.

Traditional:     UPDATE orders SET status='shipped' WHERE id=123
Event Sourcing:  APPEND {type: "OrderShipped", orderId: 123, timestamp: ...}

Event Store:
  Append-only log of events, organized by aggregate/stream.

  Stream: order-123
    Event 1: OrderCreated {customer: "Alice", items: [...]}
    Event 2: ItemAdded {item: "Widget", qty: 2}
    Event 3: PaymentReceived {amount: 49.98}
    Event 4: OrderShipped {carrier: "FedEx", tracking: "..."}

  Operations:
    Append(streamId, events, expectedVersion)  // Optimistic concurrency
    Read(streamId) → [events]                  // Load all events
    Read(streamId, fromVersion) → [events]     // Load from version N

Event Store Implementations:
  EventStoreDB    Purpose-built, Greg Young's creation
  PostgreSQL      Using events table + optimistic locking
  DynamoDB        Event table with stream ID + version
  Kafka           Topic per aggregate type
  Marten          .NET library on PostgreSQL

Projections (Read Models):
  Events → Projection → Read Database

  Example Projection:
    OrderCreated → INSERT INTO order_summary (id, customer, total)
    ItemAdded    → UPDATE order_summary SET total = total + amount
    OrderShipped → UPDATE order_summary SET status = 'shipped'

  Types:
    Live:     Process events in real-time
    Catch-up: Replay from beginning, then switch to live
    One-time: Build report by replaying specific events

Snapshots:
  Problem: Replaying 10,000 events is slow
  Solution: Periodically save aggregate state as a snapshot
    Snapshot at event 9000: {state: {...}}
    Load snapshot, then replay events 9001-10000
    Only for performance — events remain source of truth

  When to snapshot:
    Every N events (e.g., every 100)
    When load time exceeds threshold
    On aggregate version milestones

Temporal Queries:
  "What was the order state at 3pm yesterday?"
  → Replay events up to that timestamp
  Impossible with traditional CRUD (state was overwritten)

Pitfalls:
  ✗ Schema evolution is harder (old events live forever)
  ✗ Event store can grow very large
  ✗ Debugging requires understanding event sequence
  ✗ Not suitable for all domains (simple CRUD overkill)
  ✗ Projections can fall behind or break
  ✗ Eventual consistency between write and read models
EOF
}

cmd_delivery() {
    cat << 'EOF'
=== Delivery Guarantees ===

At-Most-Once:
  Fire and forget. Message may be lost, never duplicated.
  Implementation: Send without waiting for acknowledgment.
  Use: Metrics, telemetry, non-critical notifications
  Trade-off: Fastest, but unreliable

At-Least-Once:
  Message is delivered one or more times. May be duplicated.
  Implementation: Retry until acknowledged, consumer deduplicates.
  Use: Most business events (with idempotent consumers)
  Trade-off: Reliable but requires idempotency handling

Exactly-Once:
  Message is delivered exactly one time. No loss, no duplicates.
  Implementation: Extremely difficult in distributed systems.
  Reality: Usually "effectively once" via idempotency + dedup.

Achieving Effectively-Once:

  Idempotent Consumers:
    Processing the same event multiple times produces same result.
    Techniques:
    - Deduplicate by event ID (track processed IDs)
    - Use database upserts (INSERT ON CONFLICT)
    - Design operations to be naturally idempotent

  Transactional Outbox Pattern:
    Problem: How to atomically update DB AND publish event?
    Solution:
    1. Write event to outbox table in same DB transaction
    2. Separate process reads outbox and publishes to broker
    3. Mark outbox entry as published
    
    Guarantees: If DB commit succeeds, event WILL be published
    No dual-write problem

  Change Data Capture (CDC):
    Capture database changes as events:
    DB commit → CDC (Debezium) → Kafka → Consumers
    No need for outbox table
    Works with existing databases retroactively

Ordering Guarantees:
  Global ordering:  All consumers see events in same order (expensive)
  Partition ordering: Events with same key are ordered (Kafka default)
  No ordering:      Events may arrive in any order (cheapest)

  Handling Out-of-Order:
    - Include sequence number in events
    - Use vector clocks for causal ordering
    - Buffer and reorder at consumer
    - Design for commutative operations (CRDTs)

Consumer Groups:
  Multiple instances of same consumer share the workload
  Each event processed by exactly one instance in the group
  Rebalancing on instance add/remove
  Enables horizontal scaling of consumption
EOF
}

cmd_stream() {
    cat << 'EOF'
=== Stream Processing ===

What Is Stream Processing?
  Continuous processing of unbounded data as it arrives.
  Contrast with batch: process bounded dataset all at once.

  Batch:    ████████ → Process → Result (hourly/daily)
  Stream:   ─→─→─→─ → Process → ─→─→─→ (continuous)

Windowing:
  Group events into time-based or count-based windows.

  Tumbling Window (fixed, non-overlapping):
    |─── 5 min ───|─── 5 min ───|─── 5 min ───|
    Count events in each window independently

  Sliding Window (overlapping):
    |─── 5 min ───|
       |─── 5 min ───|
          |─── 5 min ───|
    Re-evaluate every slide interval

  Session Window (gap-based):
    |──activity──|   gap   |──activity──|   gap   |──activity──|
    Group by inactivity gap (e.g., 30 min idle = new session)

  Hopping Window:
    Window size: 10 min, hop: 5 min
    |────── 10 min ──────|
         |────── 10 min ──────|
              |────── 10 min ──────|

Stream Processing Operations:
  Filter     Select events matching criteria
  Map        Transform each event
  FlatMap    Transform one event to zero or more events
  Aggregate  Accumulate (count, sum, avg) over window
  Join       Combine two streams (by key, within time window)
  GroupBy    Partition stream by key for parallel processing

Time Semantics:
  Event Time       When the event actually occurred
  Processing Time  When the system processes the event
  Ingestion Time   When the event enters the system

  Watermarks:
    Track progress of event time
    "All events with timestamp < watermark have arrived"
    Allow handling late events (wait for stragglers)
    Late arrivals: discard, process with side output, or update

Stream Processing Frameworks:
  Apache Flink      True streaming, advanced windowing, exactly-once
  Kafka Streams     Library (not cluster), tightly coupled with Kafka
  Apache Spark      Micro-batch streaming (Structured Streaming)
  Apache Beam       Unified API (runs on Flink, Spark, Dataflow)
  AWS Kinesis       Managed streaming on AWS
  ksqlDB            SQL on Kafka streams

Use Cases:
  - Real-time fraud detection
  - Clickstream analytics
  - IoT sensor monitoring
  - Live dashboards
  - Anomaly detection
  - Log analysis and alerting
  - Real-time recommendations
EOF
}

cmd_checklist() {
    cat << 'EOF'
=== Event-Driven Architecture Checklist ===

Event Design:
  [ ] Events named in past tense (EntityAction)
  [ ] Event schema documented with all fields
  [ ] Schema versioning strategy chosen
  [ ] Event IDs are unique (UUIDs)
  [ ] Timestamps in ISO 8601 UTC
  [ ] Correlation IDs for request tracing
  [ ] Event payload size < 1 MB (use claim check if larger)

Infrastructure:
  [ ] Event broker selected and deployed
  [ ] Topics/queues created with appropriate configuration
  [ ] Partitioning strategy defined (key selection)
  [ ] Retention policy configured
  [ ] Dead Letter Queue configured
  [ ] Monitoring and alerting on broker health

Producers:
  [ ] Events published atomically with state changes
  [ ] Outbox pattern or CDC if needed
  [ ] Schema validation before publishing
  [ ] Error handling for publish failures
  [ ] Batch publishing for throughput (if applicable)

Consumers:
  [ ] Consumers are idempotent
  [ ] Consumer groups configured for scaling
  [ ] Error handling with retry and DLQ
  [ ] Backpressure handling (consumer lag monitoring)
  [ ] Graceful shutdown (finish processing before exit)
  [ ] Consumer offset management strategy

Data Consistency:
  [ ] Eventual consistency acceptable for this use case
  [ ] Saga pattern for distributed transactions
  [ ] Compensating transactions defined for failures
  [ ] Ordering requirements met (partition key strategy)
  [ ] Idempotency keys for exactly-once semantics

Observability:
  [ ] Distributed tracing across services
  [ ] Consumer lag monitoring and alerting
  [ ] Event throughput metrics
  [ ] Error rate per consumer
  [ ] End-to-end latency tracking
  [ ] DLQ monitoring with alerts

Operations:
  [ ] Runbook for consumer failures
  [ ] Replay capability for reprocessing events
  [ ] Schema migration plan
  [ ] Capacity planning (event volume projections)
  [ ] Disaster recovery plan (broker replication)
  [ ] Performance testing under peak load
EOF
}

show_help() {
    cat << EOF
event v$VERSION — Event-Driven Architecture Reference

Usage: script.sh <command>

Commands:
  intro      Event-driven overview — concepts, benefits, tradeoffs
  patterns   Core patterns — pub/sub, sourcing, CQRS, saga
  design     Event design — naming, schema, versioning
  brokers    Broker comparison — Kafka, RabbitMQ, NATS, Pulsar
  sourcing   Event sourcing — event stores, projections, snapshots
  delivery   Delivery guarantees — at-most/least/exactly-once
  stream     Stream processing — windowing, aggregation, frameworks
  checklist  Event-driven architecture checklist
  help       Show this help
  version    Show version

Powered by BytesAgain | bytesagain.com
EOF
}

CMD="${1:-help}"

case "$CMD" in
    intro)     cmd_intro ;;
    patterns)  cmd_patterns ;;
    design)    cmd_design ;;
    brokers)   cmd_brokers ;;
    sourcing)  cmd_sourcing ;;
    delivery)  cmd_delivery ;;
    stream)    cmd_stream ;;
    checklist) cmd_checklist ;;
    help|--help|-h) show_help ;;
    version|--version|-v) echo "event v$VERSION — Powered by BytesAgain" ;;
    *) echo "Unknown: $CMD"; echo "Run: script.sh help"; exit 1 ;;
esac
