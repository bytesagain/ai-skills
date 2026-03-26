#!/bin/bash
# Faust - Python Stream Processing Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              FAUST REFERENCE                                ║
║          Python Stream Processing with Kafka                ║
╚══════════════════════════════════════════════════════════════╝

Faust is a Python stream processing library, porting ideas from
Kafka Streams to Python. It lets you process streaming data using
async/await with a clean Pythonic API.

KEY FEATURES:
  Kafka-based      Consumes/produces Kafka topics
  Async/await      Built on asyncio
  Tables           Distributed key-value stores (like KTable)
  Windows          Tumbling and hopping time windows
  Agents           Concurrent stream processors
  Web views        Built-in web server (aiohttp)
  Exactly-once     Transactional processing support

USE CASES:
  Event processing    User clicks, IoT sensor data
  Real-time ETL       Transform and route data streams
  Aggregation         Running counts, sums, averages
  Monitoring          Alert on patterns in event streams
  CQRS/Event sourcing Materialized views from events

INSTALL:
  pip install faust-streaming    # Community fork (maintained)
  # Original: pip install faust (archived by Robinhood)
EOF
}

cmd_agents() {
cat << 'EOF'
AGENTS & TOPICS
=================

BASIC APP:
  import faust

  app = faust.App(
      "myapp",
      broker="kafka://localhost:9092",
      store="rocksdb://",
      value_serializer="json",
  )

  # Define a topic with a model
  class Order(faust.Record):
      order_id: str
      user_id: str
      amount: float
      product: str

  orders_topic = app.topic("orders", value_type=Order)

AGENT (stream processor):
  @app.agent(orders_topic)
  async def process_orders(orders):
      async for order in orders:
          print(f"Processing order {order.order_id}: ${order.amount}")
          if order.amount > 1000:
              await high_value_topic.send(value=order)

  # Run: faust -A myapp worker -l info

MULTIPLE AGENTS:
  @app.agent(orders_topic)
  async def count_orders(orders):
      async for order in orders.group_by(Order.user_id):
          user_orders[order.user_id] += 1

  @app.agent(orders_topic)
  async def total_revenue(orders):
      async for order in orders:
          revenue_table[order.product] += order.amount

PRODUCING:
  @app.timer(interval=1.0)
  async def produce_events():
      await orders_topic.send(value=Order(
          order_id="123", user_id="alice", amount=99.99, product="widget"
      ))

  # Or from a web view
  @app.page("/api/order")
  async def create_order(web, request):
      data = await request.json()
      order = Order(**data)
      await orders_topic.send(value=order)
      return web.json({"status": "ok"})

GROUP BY:
  @app.agent(orders_topic)
  async def by_user(orders):
      async for order in orders.group_by(Order.user_id):
          # All orders for same user go to same worker
          process(order)

FILTERING:
  @app.agent(orders_topic)
  async def big_orders(orders):
      async for order in orders.filter(lambda o: o.amount > 100):
          await big_orders_topic.send(value=order)
EOF
}

cmd_tables() {
cat << 'EOF'
TABLES & WINDOWS
==================

TABLES (distributed state):
  # Like a distributed dictionary backed by Kafka changelog
  order_count = app.Table("order_count", default=int)
  revenue = app.Table("revenue", default=float)

  @app.agent(orders_topic)
  async def track_stats(orders):
      async for order in orders:
          order_count[order.user_id] += 1
          revenue[order.product] += order.amount

  # Tables are queryable via web views
  @app.page("/api/stats/{user_id}")
  async def user_stats(web, request, user_id):
      count = order_count[user_id]
      return web.json({"user": user_id, "orders": count})

WINDOWED TABLES:
  # Tumbling window (non-overlapping fixed intervals)
  hourly_revenue = app.Table(
      "hourly_revenue",
      default=float,
  ).tumbling(3600)  # 1 hour windows

  @app.agent(orders_topic)
  async def hourly_stats(orders):
      async for order in orders:
          hourly_revenue[order.product] += order.amount

  # Access current window
  current = hourly_revenue["widget"].current()
  # Access specific window
  value = hourly_revenue["widget"].value()

  # Hopping window (overlapping)
  sliding_avg = app.Table(
      "sliding_avg",
      default=float,
  ).hopping(size=300, step=60)  # 5-min window, 1-min hop

MODELS:
  class User(faust.Record):
      user_id: str
      name: str
      email: str
      active: bool = True

  class Event(faust.Record):
      event_id: str
      timestamp: float
      user: User             # Nested model
      metadata: dict = {}
      tags: list = []

  # Serialization is automatic (JSON by default)
  # Also supports Avro, Protobuf via codecs

CHANNELS (internal topics):
  # For inter-agent communication without Kafka
  alerts = app.channel()

  @app.agent(orders_topic)
  async def detect_fraud(orders):
      async for order in orders:
          if order.amount > 10000:
              await alerts.send(value=f"Large order: {order.order_id}")

  @app.agent(alerts)
  async def handle_alerts(alerts):
      async for alert in alerts:
          send_notification(alert)
EOF
}

cmd_deploy() {
cat << 'EOF'
DEPLOYMENT & OPERATIONS
=========================

CLI:
  faust -A myapp worker -l info          # Start worker
  faust -A myapp worker -l info -p 6066  # Custom web port
  faust -A myapp worker --without-web    # No web server
  faust -A myapp model list              # List models
  faust -A myapp agents                  # List agents

APP CONFIGURATION:
  app = faust.App(
      "myapp",
      broker="kafka://kafka1:9092;kafka2:9092",
      store="rocksdb://",
      topic_replication_factor=3,
      topic_partitions=8,
      processing_guarantee="exactly_once",
      broker_credentials=faust.SASLCredentials(
          username="user", password="pass",
          mechanism="PLAIN",
      ),
      web_host="0.0.0.0",
      web_port=6066,
  )

SCALING:
  # Start multiple workers (each gets subset of partitions)
  faust -A myapp worker -l info  # Worker 1
  faust -A myapp worker -l info  # Worker 2
  faust -A myapp worker -l info  # Worker 3

  # Partitions are automatically rebalanced across workers
  # More partitions = more parallelism (set topic_partitions)

DOCKER:
  FROM python:3.12-slim
  WORKDIR /app
  COPY requirements.txt .
  RUN pip install -r requirements.txt
  COPY . .
  CMD ["faust", "-A", "myapp", "worker", "-l", "info"]

MONITORING:
  # Built-in web endpoints
  GET /                    # App info
  GET /stats               # Worker stats
  GET /tables              # Table info
  GET /table/{name}/{key}  # Query table
  GET /graph               # DAG visualization
  GET /health              # Health check

  # Prometheus metrics (with faust-prometheus)
  pip install faust-prometheus

  # Datadog/StatsD
  app = faust.App("myapp", monitor=faust.Monitor())

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Faust - Python Stream Processing Reference

Commands:
  intro    Overview, features, use cases
  agents   Agents, topics, producing, filtering
  tables   Distributed tables, windows, models
  deploy   CLI, scaling, Docker, monitoring

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)  cmd_intro ;;
  agents) cmd_agents ;;
  tables) cmd_tables ;;
  deploy) cmd_deploy ;;
  help|*) show_help ;;
esac
