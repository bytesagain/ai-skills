#!/bin/bash
# Apache Airflow - Workflow Orchestration Platform Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              APACHE AIRFLOW REFERENCE                       ║
║          Programmatic Workflow Orchestration                 ║
╚══════════════════════════════════════════════════════════════╝

Apache Airflow is a platform to programmatically author, schedule,
and monitor workflows. Originally created at Airbnb in 2014.

KEY CONCEPTS:
  DAG             Directed Acyclic Graph — a workflow definition
  Task            A unit of work within a DAG
  Operator        Template for a task (BashOperator, PythonOperator, etc.)
  Sensor          Operator that waits for a condition
  Hook            Interface to external systems (DB, API, cloud)
  Connection      Stored credentials for external systems
  Variable        Global key-value config store
  XCom            Cross-communication between tasks
  Pool            Limit concurrent task execution
  Executor        How tasks are run (Local, Celery, Kubernetes)
  Schedule        When/how often a DAG runs (cron or timetable)

ARCHITECTURE:
  ┌────────────┐  ┌────────────┐  ┌────────────┐
  │ Web Server │  │ Scheduler  │  │  Workers   │
  │  (Flask)   │  │ (triggers) │  │ (execute)  │
  └─────┬──────┘  └─────┬──────┘  └─────┬──────┘
        │               │               │
        └───────────┬────┴───────────────┘
                    │
              ┌─────┴─────┐
              │  Metadata  │  PostgreSQL
              │  Database  │  (or MySQL)
              └────────────┘

EXECUTORS:
  SequentialExecutor   One task at a time (dev only)
  LocalExecutor        Parallel on single machine
  CeleryExecutor       Distributed via Celery + Redis/RabbitMQ
  KubernetesExecutor   One pod per task (best isolation)
  CeleryKubernetes     Hybrid of Celery + K8s
EOF
}

cmd_dags() {
cat << 'EOF'
DAG AUTHORING
===============

BASIC DAG (TaskFlow API — recommended):

  from airflow.decorators import dag, task
  from datetime import datetime

  @dag(
      schedule="0 6 * * *",        # Daily at 6 AM
      start_date=datetime(2026, 1, 1),
      catchup=False,
      tags=["etl", "production"],
  )
  def my_etl_pipeline():

      @task()
      def extract():
          import requests
          data = requests.get("https://api.example.com/data").json()
          return data

      @task()
      def transform(raw_data: dict):
          cleaned = [
              {"id": r["id"], "value": r["amount"] * 100}
              for r in raw_data["records"]
          ]
          return cleaned

      @task()
      def load(records: list):
          from airflow.providers.postgres.hooks.postgres import PostgresHook
          hook = PostgresHook("my_postgres")
          hook.insert_rows("target_table", records)

      raw = extract()
      cleaned = transform(raw)
      load(cleaned)

  my_etl_pipeline()

CLASSIC DAG (Operator-based):

  from airflow import DAG
  from airflow.operators.bash import BashOperator
  from airflow.operators.python import PythonOperator
  from datetime import datetime, timedelta

  default_args = {
      "owner": "data-team",
      "retries": 3,
      "retry_delay": timedelta(minutes=5),
      "email_on_failure": True,
      "email": ["team@example.com"],
  }

  with DAG(
      "classic_pipeline",
      default_args=default_args,
      schedule="@daily",
      start_date=datetime(2026, 1, 1),
      catchup=False,
  ) as dag:

      extract = BashOperator(
          task_id="extract",
          bash_command="python /scripts/extract.py",
      )

      transform = PythonOperator(
          task_id="transform",
          python_callable=my_transform_function,
      )

      load = BashOperator(
          task_id="load",
          bash_command="python /scripts/load.py",
      )

      extract >> transform >> load

SCHEDULE PRESETS:
  @once          Run once only
  @hourly        0 * * * *
  @daily         0 0 * * *
  @weekly        0 0 * * 0
  @monthly       0 0 1 * *
  @yearly        0 0 1 1 *
  None           Manual trigger only

TASK DEPENDENCIES:
  a >> b >> c              Linear: a → b → c
  a >> [b, c]              Fan-out: a → b, a → c
  [b, c] >> d              Fan-in: b → d, c → d
  a.set_downstream(b)      Same as a >> b
  cross_downstream([a,b], [c,d])  Cartesian dependencies
EOF
}

cmd_operators() {
cat << 'EOF'
OPERATORS REFERENCE
=====================

CORE OPERATORS:

  BashOperator:
    BashOperator(task_id="run_script", bash_command="echo hello")
    BashOperator(task_id="etl", bash_command="/opt/scripts/etl.sh {{ ds }}")

  PythonOperator:
    PythonOperator(task_id="process", python_callable=my_function, op_args=[42])

  BranchPythonOperator:
    def choose_branch(**context):
        if context["ds_nodash"] > "20260101":
            return "new_path"
        return "old_path"
    BranchPythonOperator(task_id="branch", python_callable=choose_branch)

  EmptyOperator (formerly DummyOperator):
    EmptyOperator(task_id="join")  # Just a join point

  TriggerDagRunOperator:
    TriggerDagRunOperator(task_id="trigger_child", trigger_dag_id="child_dag")

  ShortCircuitOperator:
    # Skips downstream tasks if returns False
    ShortCircuitOperator(task_id="check", python_callable=lambda: check_condition())

CLOUD OPERATORS:

  AWS:
    S3CopyObjectOperator      Copy files in S3
    GlueJobOperator            Run AWS Glue jobs
    EmrAddStepsOperator        Submit EMR steps
    RedshiftSQLOperator        Run Redshift queries
    LambdaInvokeFunctionOp     Invoke Lambda

  GCP:
    BigQueryInsertJobOperator  Run BigQuery jobs
    GCSToBigQueryOperator      Load GCS → BigQuery
    DataflowStartFlexTemplate  Run Dataflow
    CloudRunExecuteJobOperator Run Cloud Run jobs

  Azure:
    AzureDataFactoryRunPipeline  Trigger ADF pipeline
    AzureBlobStorageUpload       Upload to Blob Storage

DATABASE OPERATORS:
  PostgresOperator     Run SQL on PostgreSQL
  MySqlOperator        Run SQL on MySQL
  MsSqlOperator        Run SQL on SQL Server
  SnowflakeOperator    Run SQL on Snowflake
  SqliteOperator       Run SQL on SQLite

SENSORS (wait for condition):
  FileSensor           Wait for file to appear
  S3KeySensor          Wait for S3 object
  ExternalTaskSensor   Wait for task in another DAG
  HttpSensor           Poll HTTP endpoint
  SqlSensor            Wait for SQL query to return rows
  DateTimeSensor       Wait until specific datetime

  Example:
    FileSensor(
        task_id="wait_for_file",
        filepath="/data/input/{{ ds }}.csv",
        poke_interval=60,      # Check every 60 seconds
        timeout=3600,          # Give up after 1 hour
        mode="reschedule",     # Free worker slot while waiting
    )

TRANSFERS:
  S3ToRedshiftOperator
  GCSToBigQueryOperator
  PostgresToGCSOperator
  MySQLToGCSOperator
EOF
}

cmd_connections() {
cat << 'EOF'
CONNECTIONS, VARIABLES & XCOMS
================================

CONNECTIONS:
  Store external system credentials securely.

  UI: Admin → Connections → Add
  CLI: airflow connections add 'my_postgres' \
         --conn-type 'postgres' \
         --conn-host 'db.example.com' \
         --conn-port 5432 \
         --conn-schema 'production' \
         --conn-login 'airflow' \
         --conn-password 'secret'

  Environment variable:
    AIRFLOW_CONN_MY_POSTGRES='postgresql://airflow:secret@db.example.com:5432/production'

  Connection URI format:
    <conn_type>://<login>:<password>@<host>:<port>/<schema>?param=value

  Using in code:
    from airflow.hooks.base import BaseHook
    conn = BaseHook.get_connection("my_postgres")
    print(conn.host, conn.port, conn.login)

VARIABLES:
  Global key-value configuration store.

  UI: Admin → Variables
  CLI: airflow variables set my_key "my_value"
       airflow variables get my_key

  In DAG:
    from airflow.models import Variable
    api_key = Variable.get("api_key")
    config = Variable.get("config", deserialize_json=True)

  Jinja template:
    bash_command="echo {{ var.value.my_key }}"
    bash_command="echo {{ var.json.config.setting }}"

  Performance tip:
    Variables are fetched from DB each time. Cache in top-level:
    API_KEY = Variable.get("api_key")  # Once at DAG parse time

XCOMS (Cross-Communication):
  Pass data between tasks.

  TaskFlow (automatic):
    @task()
    def extract():
        return {"count": 42}  # Automatically pushed to XCom

    @task()
    def process(data):        # Automatically pulled from XCom
        print(data["count"])

  Classic (manual):
    def push_function(**context):
        context["ti"].xcom_push(key="result", value=42)

    def pull_function(**context):
        value = context["ti"].xcom_pull(task_ids="push_task", key="result")

  XCom limitations:
    - Default backend stores in metadata DB (PostgreSQL)
    - Max size: depends on DB (PostgreSQL ~1GB, but don't)
    - For large data: use S3/GCS paths, not data itself
    - Custom XCom backend: store in S3, Redis, etc.

TEMPLATE VARIABLES:
  {{ ds }}                  Execution date (YYYY-MM-DD)
  {{ ds_nodash }}           Execution date (YYYYMMDD)
  {{ ts }}                  Execution timestamp (ISO)
  {{ data_interval_start }} Start of data interval
  {{ data_interval_end }}   End of data interval
  {{ run_id }}              DAG run ID
  {{ dag.dag_id }}          DAG ID
  {{ task.task_id }}        Task ID
  {{ params.my_param }}     User-defined parameters
  {{ macros.ds_add(ds, 7) }} Date arithmetic
EOF
}

cmd_deploy() {
cat << 'EOF'
DEPLOYMENT & CONFIGURATION
=============================

INSTALLATION:

  pip:
    pip install apache-airflow
    pip install apache-airflow[postgres,celery,redis,aws,gcp]

  Docker Compose:
    curl -LfO 'https://airflow.apache.org/docs/apache-airflow/stable/docker-compose.yaml'
    docker compose up airflow-init    # Initialize DB
    docker compose up -d              # Start all services

  Helm (Kubernetes):
    helm repo add apache-airflow https://airflow.apache.org
    helm install airflow apache-airflow/airflow \
      --namespace airflow \
      --create-namespace

AIRFLOW.CFG KEY SETTINGS:

  [core]
  dags_folder = /opt/airflow/dags
  executor = CeleryExecutor           # or KubernetesExecutor
  load_examples = False
  default_timezone = UTC
  parallelism = 32                     # Max concurrent tasks
  max_active_tasks_per_dag = 16
  max_active_runs_per_dag = 4

  [database]
  sql_alchemy_conn = postgresql+psycopg2://airflow:password@postgres:5432/airflow

  [webserver]
  web_server_port = 8080
  rbac = True
  session_lifetime_minutes = 43200

  [scheduler]
  min_file_process_interval = 30       # How often to scan DAG files
  dag_dir_list_interval = 300          # How often to scan for new DAGs
  parsing_processes = 4

  [celery]
  broker_url = redis://redis:6379/0
  result_backend = db+postgresql://airflow:password@postgres:5432/airflow
  worker_concurrency = 16

ENVIRONMENT VARIABLES:
  All config can be set via env vars:
    AIRFLOW__CORE__EXECUTOR=CeleryExecutor
    AIRFLOW__DATABASE__SQL_ALCHEMY_CONN=postgresql+psycopg2://...
    AIRFLOW__WEBSERVER__RBAC=True

  Pattern: AIRFLOW__<SECTION>__<KEY>=<VALUE>

DAG DEPLOYMENT STRATEGIES:

  Git-sync sidecar (K8s):
    Mount a git repo as DAGs folder, auto-pull on interval.
    Best for: Kubernetes deployments.

  CI/CD pipeline:
    Build Docker image with DAGs baked in.
    Best for: immutable deployments.

  Shared filesystem:
    NFS/EFS mount for DAGs folder.
    Best for: simple multi-worker setups.

  S3/GCS sync:
    Sync DAGs from object storage.
    Best for: managed Airflow (MWAA, Cloud Composer).
EOF
}

cmd_testing() {
cat << 'EOF'
TESTING & DEBUGGING
=====================

DAG VALIDATION:
  # Check DAGs for syntax errors
  python -c "from my_dag import *"

  # List all DAGs
  airflow dags list

  # Test specific DAG
  airflow dags test my_dag 2026-01-01

  # Test specific task
  airflow tasks test my_dag my_task 2026-01-01

  # Render templates (see what Jinja produces)
  airflow tasks render my_dag my_task 2026-01-01

UNIT TESTING:
  import pytest
  from airflow.models import DagBag

  def test_dag_loaded():
      dagbag = DagBag()
      assert "my_dag" in dagbag.dags
      assert dagbag.import_errors == {}

  def test_dag_structure():
      dagbag = DagBag()
      dag = dagbag.get_dag("my_dag")
      assert len(dag.tasks) == 3
      assert dag.schedule_interval == "@daily"

  def test_task_dependencies():
      dagbag = DagBag()
      dag = dagbag.get_dag("my_dag")
      extract = dag.get_task("extract")
      transform = dag.get_task("transform")
      assert transform.task_id in [t.task_id for t in extract.downstream_list]

INTEGRATION TESTING:
  from airflow.models import DagBag, TaskInstance
  from airflow.utils.state import State

  def test_extract_task():
      dagbag = DagBag()
      dag = dagbag.get_dag("my_dag")
      ti = TaskInstance(task=dag.get_task("extract"), run_id="test")
      ti.run(ignore_ti_state=True)
      assert ti.state == State.SUCCESS
      result = ti.xcom_pull(key="return_value")
      assert len(result) > 0

DEBUGGING TIPS:
  1. Check scheduler logs: airflow scheduler logs
  2. Check task logs: UI → DAG → Task Instance → Logs
  3. Task not running?
     - Check pool slots: Admin → Pools
     - Check max_active_tasks_per_dag
     - Check parallelism setting
     - Check worker availability
  4. DAG not appearing?
     - Check dags_folder path
     - Check for Python import errors
     - Check min_file_process_interval
     - Run: airflow dags list-import-errors

COMMON CLI COMMANDS:
  airflow dags list                    List all DAGs
  airflow dags trigger my_dag          Trigger a DAG run
  airflow dags pause my_dag            Pause a DAG
  airflow dags unpause my_dag          Unpause a DAG
  airflow tasks list my_dag            List tasks in DAG
  airflow tasks test my_dag task 2026-01-01  Test a task
  airflow tasks clear my_dag -s 2026-01-01  Clear task states
  airflow jobs check                   Check job health
  airflow db check                     Check DB connection
  airflow db upgrade                   Run DB migrations
  airflow users create --username admin --password admin \
    --firstname Admin --lastname User --role Admin --email admin@example.com
EOF
}

cmd_patterns() {
cat << 'EOF'
COMMON DAG PATTERNS
=====================

1. ETL PIPELINE
   extract >> transform >> load >> validate

2. PARALLEL EXTRACTION + MERGE
   [extract_api, extract_db, extract_s3] >> merge >> load

3. BRANCHING
   check_condition >> [path_a, path_b] >> join
   Use BranchPythonOperator to choose path dynamically.

4. DYNAMIC TASK MAPPING (Airflow 2.3+)
   @task()
   def get_files():
       return ["file1.csv", "file2.csv", "file3.csv"]

   @task()
   def process_file(filename):
       print(f"Processing {filename}")

   files = get_files()
   process_file.expand(filename=files)  # Creates 3 parallel tasks

5. TASK GROUP (sub-DAG replacement)
   from airflow.utils.task_group import TaskGroup

   with TaskGroup("extract_group") as extract:
       extract_users = PythonOperator(...)
       extract_orders = PythonOperator(...)

   with TaskGroup("load_group") as load:
       load_users = PythonOperator(...)
       load_orders = PythonOperator(...)

   extract >> transform >> load

6. DATA-AWARE SCHEDULING (Datasets, Airflow 2.4+)
   # Producer DAG
   from airflow.datasets import Dataset
   orders_dataset = Dataset("s3://bucket/orders/")

   @dag(schedule="@daily")
   def producer():
       @task(outlets=[orders_dataset])
       def produce():
           # Write to S3
           pass

   # Consumer DAG (triggers when dataset updates)
   @dag(schedule=[orders_dataset])
   def consumer():
       @task()
       def consume():
           # Read from S3
           pass

7. RETRY WITH EXPONENTIAL BACKOFF
   default_args = {
       "retries": 5,
       "retry_delay": timedelta(minutes=1),
       "retry_exponential_backoff": True,
       "max_retry_delay": timedelta(hours=1),
   }

8. SLA & ALERTING
   @dag(sla_miss_callback=sla_alert_function)
   def my_dag():
       @task(sla=timedelta(hours=2))
       def critical_task():
           pass

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Apache Airflow - Workflow Orchestration Reference

Commands:
  intro         Platform overview, architecture, executors
  dags          DAG authoring (TaskFlow + classic), scheduling
  operators     Core, cloud, database operators and sensors
  connections   Connections, variables, XComs, templates
  deploy        Installation, configuration, deployment strategies
  testing       Validation, unit testing, debugging, CLI
  patterns      ETL, branching, dynamic tasks, datasets

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)       cmd_intro ;;
  dags)        cmd_dags ;;
  operators)   cmd_operators ;;
  connections) cmd_connections ;;
  deploy)      cmd_deploy ;;
  testing)     cmd_testing ;;
  patterns)    cmd_patterns ;;
  help|*)      show_help ;;
esac
