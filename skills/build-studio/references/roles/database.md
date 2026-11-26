# Database
tier: 1 | sources: v1 s5, PostgreSQL/MySQL/MongoDB docs (knowledge), Supabase RLS docs | updated: 2026-11-26

## Triggers
- Designing tables or collections, adding a field, an index, a migration, a backup.
- A slow query, a duplicate record, a data-integrity bug, connection errors on a serverless host.
- Choosing a database at G2 (with the stack selection).

## Responsibilities
- Architecture: data model with ownership, indexes, retention and personal-data fields (SKILL.md 3.3).
- Build: migrations, constraints, queries, seed script.
- Verify: migration up and down on a copy, query plans for the main queries, restore test.
- Handoff: backup and restore steps in the runbook.

## Role-specific rules
**Model**
1. **Start from the queries:** list the main reads and writes (from the PRD stories) before drawing tables; every filter or sort in that list gets an index.
2. **Constraints in the database,** not only in code: NOT NULL, UNIQUE, foreign keys, CHECK. App checks lose races; constraints don't.
3. **Ownership column on every user-owned row** (`owner_id`), indexed, used in every query (backend role rule 3).
4. **IDs:** bigint identity, or UUID (v7 keeps index order) when IDs are public or generated offline. Authorization still applies either way.
5. **Time in UTC** (`timestamptz` or UTC `DATETIME`); convert to Asia/Dhaka only for display.
6. **Money as integer minor units** (paisa, cents) or `DECIMAL`, never float.
7. **Text encoding:** UTF-8 everywhere; `utf8mb4` on MySQL/MariaDB so Bangla text and emoji store correctly.
8. **Personal data marked** in the schema doc; sensitive fields (health, finance, ID numbers) encrypted at the application layer when the PRD requires it; a real delete path for each user's data.

**Queries**
9. **No N+1:** joins or eager loading for lists; a test that counts queries for each list endpoint.
10. **Transactions** for multi-step writes; a unique constraint or row lock for "only one" rules (one booking per slot, one vote per user).
11. **`EXPLAIN` the main queries** with realistic row counts; composite index order: equality columns first, then range or sort.
12. **Full-text search in the database first** (Postgres `tsvector`, MySQL FULLTEXT, Atlas Search) before adding a search service.

**Migrations and operations**
13. **Versioned migrations only,** never hand-edited schema in production, never edit a migration that has run.
14. **Expand and contract** for renames and drops: add the new column, write both, backfill, switch reads, then drop the old one in a later deploy.
15. **Large backfills in batches,** outside the request path.
16. **Two database users in production when the host allows:** the app user without schema rights, a migration user with them.
17. **Serverless connection limits:** use the provider's pooler URL (Supabase pooler, Neon pooled connection) and reuse one client per process.
18. **Row-level security** on every table reachable from a public key (Supabase), with tests as anonymous, as the owner and as another user.

## Default tool options
- Relational: PostgreSQL (Supabase or Neon free tiers), MySQL/MariaDB (shared cPanel hosting), SQLite or Cloudflare D1 for small single-writer apps.
- Documents: MongoDB Atlas free tier when the data is truly document-shaped.
- Migrations: Alembic (SQLAlchemy), Prisma Migrate, Drizzle Kit, Laravel migrations, Supabase CLI, plain numbered SQL files where no migration tool fits.
- Backups: provider backups plus `pg_dump`/`mysqldump`/`mongodump` on a schedule to off-host storage (R2).

## Checklist
- [ ] Main queries listed, each with its index
- [ ] Constraints for every rule the PRD states as "must" or "only one"
- [ ] Migration runs up (and down or has a written rollback) on a copy
- [ ] `EXPLAIN` saved for the 3 main queries
- [ ] Query-count test on list endpoints
- [ ] RLS policy tests pass (if Supabase)
- [ ] Backup scheduled off-host and one restore tested (SKILL.md 6.5)

## Common mistakes
- Unique rule only in code → duplicates under concurrent requests.
- Float for money → rounding errors in totals.
- Local time stored → wrong times after a server or timezone change.
- `utf8` instead of `utf8mb4` on MySQL → Bangla characters and emoji break.
- Dropping a column in the same deploy that stops using it → errors during the rollout.
- Supabase table with RLS off → anyone with the public key can read it.
- A new connection per request on serverless → "too many connections" under small load.

## Definition of done
Migrations apply cleanly on a fresh database and on a copy of production, constraints and indexes match the model doc, the main queries' plans use their indexes, RLS or ownership tests pass, and a restore from backup has been done once with its time recorded.

## Per-stack notes
**PostgreSQL:** `timestamptz`; `jsonb` only for truly flexible fields, with a GIN index if queried; partial indexes for soft-deleted or status-filtered rows; `pg_trgm` for fuzzy search.
**MySQL / MariaDB:** InnoDB; `utf8mb4_unicode_ci`; strict SQL mode on; know that MariaDB and MySQL differ on some defaults. Match the host's exact MariaDB/MySQL version in local development.
**MongoDB:** `$jsonSchema` validation on collections; an index for each query shape; no unbounded arrays inside documents; multi-document transactions need a replica set (Atlas has one).
**SQLite / D1:** one writer at a time; good for small apps and edge reads; check D1's size and query limits on the free plan.
**ORMs:** Prisma, SQLAlchemy, Drizzle and Eloquent all allow raw queries; use bound parameters there too, and log the generated SQL in development to catch N+1.
