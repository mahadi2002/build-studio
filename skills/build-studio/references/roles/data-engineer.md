# Data engineer
tier: 2 | sources: Fundamentals of Data Engineering (Reis, Housley), dbt best practices docs, Great Expectations docs | updated: 2026-11-26

## Triggers
- ETL or ELT jobs, batch or streaming pipelines, scrapers feeding a store, data quality checks, orchestration, a warehouse or lake.
- Not for: schema and indexes of one app database (database role) or dashboards alone (data skills in SKILL.md section 8).

## Responsibilities
- Architecture: sources, destination, load pattern (full or incremental), schedule, freshness target, data contract.
- Build and verify: idempotent jobs, quality checks, tests on small fixtures. Handoff: lineage notes, backfill steps, alert owner.

## Role-specific rules
1. Write the contract first: columns, types, keys, allowed nulls, freshness, and the source owner.
2. Make every job idempotent: rerunning the same window gives the same result (upsert by key or replace a partition).
3. Load incrementally with a watermark or change column; keep a tested full-refresh path for backfills.
4. Land raw data unchanged, then clean in a second step, so a bad transform can be replayed.
5. Put checks in the pipeline: row counts, null and uniqueness on keys, accepted values, freshness. A failed check stops the load.
6. Handle late and duplicate events; for streams, use event time and state the lateness window. Store timestamps in UTC.
7. Scraping or loading real personal data is G3; check the source terms, and mask or drop personal fields before storage.

## Default tool options
- Small scale: Python scripts with cron or GitHub Actions; DuckDB or SQLite for local analytics.
- Transform and test: dbt Core (free); `pandas` or Polars for in-memory work.
- Orchestration: Prefect or Dagster open source; Airflow when the host already runs it. Streaming: Redpanda or Kafka only when volume demands it (uncertain at this scale).

## Checklist
- [ ] Rerunning one day twice leaves identical row counts; a backfill was run on a copy
- [ ] Quality checks fail the run on bad fixtures; alerts reach a named place

## Common mistakes
- Append-only loads on retry → duplicates; upsert or replace partitions.
- Fixing data in place with no raw copy → keep the raw layer.
- Choosing streaming when hourly batch meets the freshness target → start with batch.

## Definition of done
The pipeline ran on a schedule in a test environment, quality checks and an idempotency rerun passed, and a runbook lists failure steps.

## Per-stack notes
- dbt: tests (`unique`, `not_null`, `accepted_values`) on every model key; `incremental` models need a unique key.
- Postgres or MySQL targets: load with batch inserts or `COPY` or `LOAD DATA`; Parquet files plus DuckDB suit cheap analytics.
