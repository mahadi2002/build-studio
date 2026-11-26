# Backend
tier: 1 | sources: v1 s5, addyosmani api-and-interface-design (listing), OWASP API Security Top 10 2023 | updated: 2026-11-26

## Triggers
- An API, server-rendered app, auth, background jobs, webhooks in, scheduled tasks, file handling.
- A slow or failing endpoint, a data-integrity bug, a new integration on the server side.
- Not for: schema and migration design alone (database role), third-party API client details (integration-api role).

## Responsibilities
- Architecture: the API contract (SKILL.md 3.3), auth model, roles, where each rule is enforced, job and queue needs.
- Build: endpoints, validation, authorization, error handling, jobs, rate limits.
- Verify: integration tests through the HTTP layer against a real test database.
- Handoff: API reference (generated where the framework can), env vars, the health endpoint.

## Role-specific rules
1. **Contract first.** Write the request and response shapes and error codes before the handler. Generate OpenAPI where the framework can; the frontend codes against it.
2. **Schemas at the edge.** Every request body, query and path parameter goes through a schema; every response goes through a response schema. Never return raw database rows or documents (strip password hashes and internal fields).
3. **Authorization in one place per route,** as a dependency or middleware, plus ownership inside the query (`WHERE id = ? AND owner_id = ?`), never "fetch then check". Admin routes get their own role check, not a hidden URL.
4. **One error shape** across the API, for example `{ "detail": "...", "code": "..." }`, with correct status codes: 400 bad input, 401 not logged in, 403 not allowed, 404 not found (also for another user's object), 409 conflict, 422 validation, 429 rate limited.
5. **Lists are bounded:** pagination with a maximum page size on every list endpoint; cursor pagination for feeds and large tables.
6. **Idempotency for anything that creates or charges:** an idempotency key or a unique constraint so a retried request does not create a second order, payment or message.
7. **Timeouts on every outbound call,** with retries only for safe (idempotent) calls, using backoff. A slow third party must not hang a request thread.
8. **Slow work leaves the request:** email, image processing, AI calls over a few seconds and exports go to a job or queue, with status the client can poll.
9. **Webhooks in:** verify the signature, reject old timestamps, store the event ID and ignore repeats, answer 2xx fast and process in a job.
10. **Rate limits** per user and per IP on login, sign-up, reset, OTP, AI endpoints and anything that costs money.
11. **Versioning:** additive changes only on a live API; a breaking change gets a new version path or field, and the old one stays until clients move.
12. **Async stays async:** no blocking calls (sync DB driver, `time.sleep`, CPU-heavy work) inside async handlers.
13. **Health endpoint** checks the database and critical dependencies and returns quickly; no secrets in its output.

## Default tool options
- Python: FastAPI + Pydantic (APIs, AI features); Django when an admin panel and ORM save real time.
- Node: Express or Fastify + zod; Hono on Cloudflare Workers.
- PHP: Laravel for most PHP projects; a hand-rolled MVC only when a house stack requires it.
- Jobs: platform cron (Vercel, Cloudflare Cron Triggers, cPanel cron); a queue (Cloudflare Queues, Redis-based) only when cron is not enough.
- Auth: the framework's tested library or a provider (Supabase Auth, Auth0 via `auth0:auth0`); never hand-rolled crypto.

## Checklist
- [ ] Every endpoint in the contract has a request schema, response schema, auth rule and test
- [ ] Ownership tests: another user's ID returns 403 or 404
- [ ] Pagination limit enforced; a request for 10,000 items is capped
- [ ] Rate limits on auth, OTP, AI and paid endpoints, with a test
- [ ] Outbound calls have timeouts
- [ ] Error responses use the one shape; no stack traces in production mode
- [ ] Health endpoint returns the right status when the DB is down

## Common mistakes
- Checking ownership after fetching → the object leaks through timing or error messages; filter in the query.
- Mass assignment (`Model(**request.json)`) → whitelist fields per role.
- Returning the ORM object → passwords and internal flags reach the client.
- Retrying a non-idempotent POST → duplicate orders or charges.
- Doing slow work inline → request timeouts on serverless hosts.
- Trusting the frontend's role check → every rule is enforced on the server.

## Definition of done
Integration tests for every endpoint pass in CI, including auth boundary tests; the generated API reference matches the contract; the health endpoint is wired to the uptime check; no open finding from the AppSec role at HIGH.

## Per-stack notes
**FastAPI:** Pydantic models for every request and response (`response_model`); dependencies for `get_current_user` and role checks; async drivers (Motor, asyncpg, SQLAlchemy async); tests with pytest + httpx `AsyncClient`; `/docs` is the reference, so write the guide around it; disable `/docs` in production if the API is private.
**Express/Fastify:** validate with zod or the framework's schema; central error middleware for the one error shape; `helmet` for headers; never `app.use(cors())` with no options.
**Hono on Workers:** no Node APIs unless the compatibility flag is on; secrets via `wrangler secret`; keep CPU time per request small.
**Laravel:** Form Requests for validation, Policies for authorization, API Resources for responses; `$fillable` on every model; queues for slow work.
**PHP MVC (hand-rolled):** prepared statements only; CSRF token on every state-changing form; a house stack's own skill wins.
**Supabase as backend:** row-level security on every exposed table (database role); the service key stays on the server.
