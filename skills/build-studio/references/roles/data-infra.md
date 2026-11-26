# Data Infra
tier: 2 | sources: Apache Parquet format docs, Apache Iceberg spec, DuckDB docs | updated: 2026-11-26
## Triggers
- Warehouse, data lake, columnar files, large CSV or log analysis, storage or query cost questions.
- Not for app databases and migrations (database role) or pipelines and ETL jobs (data-engineer role).
## Responsibilities
- Architecture: where data lives, its format, who queries it, monthly storage and scan cost.
- Build: layout (partitions, file sizes), table format, query engine, access rules.
- Verify: query cost and latency at realistic volume; one restore test from the raw layer.
## Role-specific rules
1. **Estimate before storing:** rows per day, bytes per row, retention. Put the monthly storage and scan cost in the G2 doc.
2. **Keep raw data immutable;** derive cleaned tables from it so reprocessing needs no re-collection.
3. **Columnar format for analytics** (compressed Parquet). CSV and JSON only at the edges.
4. **Partition by the column most queries filter on** (usually date). Never by a high-cardinality column; many tiny files slow every engine.
5. **Aim for lake files of roughly 128 MB to 1 GB** and compact small files on a schedule (uncertain; depends on engine).
6. **Select only needed columns;** no `SELECT *` on wide tables in a pay-per-scan engine.
7. **Dry-run the scan size** before a query on a pay-per-scan warehouse. Set a per-query and monthly byte cap.
8. **Use a table format** (Iceberg or Delta) only for updates, deletes or time travel. Append-only data can stay plain Parquet.
9. **Personal data stays out of the lake** unless needed; restrict by role and column. Real user data is gate G3 (SKILL.md 2).
## Default tool options
- Local or small data: DuckDB over Parquet files (free, no server).
- Object storage: Cloudflare R2 (free tier, no egress fee), Backblaze B2, Supabase Storage for small files.
- Warehouse: BigQuery free tier (monthly scan quota, dry runs). Creating a project or enabling billing is G3.
- Lake query: DuckDB or Trino; Iceberg tables when updates are needed.
## Checklist
- [ ] Volume, retention and cost estimate written
- [ ] Raw layer separate and read-only
- [ ] Partition column and file sizes checked from a listing
- [ ] Largest query run, scan size recorded
- [ ] Access rules and personal-data columns documented
## Common mistakes
- Millions of small files → batch writes, then compact.
- Partitioning by user ID → partition by date, filter users inside.
- Full scans in dashboards → pre-aggregate into summary tables.
- Treating a lake as a database → use the database role for transactions.
## Definition of done
Estimated cost matches a measured run, the layout is documented, a sample query returns correct results with its scan size recorded, and a restore from raw data was tested once.
## Per-stack notes
- DuckDB: write with `COPY ... TO 'x.parquet' (FORMAT parquet, PARTITION_BY (dt))`; reads R2 or S3 paths through httpfs.
- BigQuery: partitioned and clustered tables cut scans; check the current free quota (uncertain).
