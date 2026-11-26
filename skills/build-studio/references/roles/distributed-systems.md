# Distributed Systems
tier: 2 | sources: Designing Data-Intensive Applications (Kleppmann), Raft paper (Ongaro and Ousterhout), AWS Builders Library | updated: 2026-11-26

## Triggers
- More than one service, node, region or queue that must agree on state.
- Words like retry, duplicate message, eventual consistency, leader election, sharding, outbox.
- Not for: one app plus one database. Use the backend and database roles.
## Responsibilities
- Architecture: say why one process is not enough, then draw nodes, messages and what each stores.
- Plan: a failure list (node down, slow, duplicate, reordered, partitioned) with the chosen behavior for each.
## Role-specific rules
1. Default to a modular monolith. A solo project rarely needs microservices. A split needs a written reason (scale, isolation, team boundary) in the G2 ADR.
2. Make every message handler idempotent. Store an idempotency key with the result.
3. Assume at-least-once delivery. Exactly-once is built from at-least-once plus idempotency.
4. Retries use a cap, exponential backoff and jitter. Retry only safe or idempotent calls.
5. Set a timeout on every remote call. A missing timeout is a bug.
6. Write the state change and the outgoing event in one transaction (outbox pattern), then publish.
7. Never order events by wall clocks across machines. Use a version number, sequence or logical clock.
8. Write down per data item: strong or eventual consistency, and what the user sees during the gap.
9. Do not write your own consensus. Use a tested store or library (etcd, a managed database).
10. Add a dead-letter queue and an alert on its depth for every queue.
## Default tool options
- Queue: a database table with row locks for small jobs; Redis streams; RabbitMQ; NATS. Pick the least you need.
- Coordination: database constraints or advisory locks first; etcd when you truly need a lock service.
- Failure testing: toxiproxy, or `docker compose` with containers killed on purpose.
## Checklist
- [ ] ADR states why a monolith is not enough
- [ ] Failure table covers duplicate, reorder, timeout, partition
- [ ] Each handler tested by delivering the same message twice
## Common mistakes
- Retry without idempotency, causing double charges or duplicate rows. Add the key first.
- A distributed lock used as a correctness guarantee. Use fencing tokens or a database constraint.
- Several services sharing one database. Give each table one owner.
## Definition of done
- Test output showing duplicate delivery, a killed node and a slow dependency all end in a correct state.
- Failure table and runbook committed.
## Per-stack notes
- Postgres and MySQL 8: `SELECT ... FOR UPDATE SKIP LOCKED` works as a job queue. MariaDB supports it from 10.6 (older versions don't; guard or check the version).
- Node and Python: use a library for retries and backoff, not hand-written loops.
