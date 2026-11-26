# Integration and API
tier: 1 | sources: OWASP API Security Top 10 2023, addyosmani api-and-interface-design (listing), gateway mock/real pattern | updated: 2026-11-26

## Triggers
- Calling a third-party API: payments, SMS/OTP, email, maps, AI providers, carrier billing, OAuth providers.
- Receiving webhooks, syncing with another system, publishing my own public API.
- Contract tests between my frontend and backend, or with a partner.

## Responsibilities
- G2/G3: which providers, their free tiers, sandbox availability, keys needed (G3).
- Build: one client module per provider, error handling, retries, webhooks, mocks.
- Verify: contract tests, sandbox end-to-end runs, failure-mode tests.
- Handoff: provider list, keys and where they live, rate limits, support contacts in the runbook.

## Role-specific rules
1. **One wrapper module per provider** (`gateway`, `client`), with my own types in and out. The rest of the app never sees the provider's SDK or raw responses, so the provider can be swapped or mocked.
2. **Mock and real behind the same interface,** chosen by config: a mock for local and tests, the real client in preview (sandbox keys) and production.
3. **Sandbox first:** build and test against the provider's sandbox or test mode; production keys only at G4 and only in the host's secrets.
4. **Timeouts on every call,** and a clear user-facing message when the provider is down.
5. **Retries only for safe calls** (GET, or calls with an idempotency key), with exponential backoff and jitter, and a small maximum.
6. **Respect rate limits:** read `429` and `Retry-After`; queue or throttle bursts; know the free-tier quota and alert near it (sre role).
7. **Idempotency keys** on create and charge calls so retries never double-charge or double-send.
8. **Validate provider responses** against a schema too; providers change fields, return `null`, or send errors with a 200 status.
9. **Webhooks:** verify signatures, reject stale timestamps, deduplicate by event ID, process in a job, and reconcile periodically by polling, because webhooks get lost.
10. **Record what was sent and received** (minus secrets and personal data) with a request ID, so a dispute or bug can be traced.
11. **Pin API versions** where the provider offers them; watch their changelog or deprecation emails, and note sunset dates in the runbook.
12. **Least-privilege keys:** restricted or scoped keys per environment; separate keys for preview and production.
13. **My own public API:** OpenAPI as the source of truth, versioned paths or headers, consistent errors (backend role), auth on every endpoint, and object-level checks on every ID (OWASP API1).
14. **Docs differ from reality sometimes:** when live behavior contradicts the docs, record the observed behavior and its evidence in the project notes.

## Default tool options
- HTTP clients: `httpx` (Python), `fetch`/`ky` or `undici` (Node); provider SDKs only inside the wrapper.
- Mocks: MSW (JS), `respx` (Python httpx), recorded fixtures (VCR.py, Polly.js) for complex responses.
- Contract tests: Schemathesis (property tests from OpenAPI), Pact for consumer-driven contracts between separate teams (rarely needed solo).
- Webhook testing: the provider's CLI or dashboard replay; a tunnel (Cloudflare Tunnel) for local endpoints.

## Checklist
- [ ] Wrapper module per provider with mock and real implementations
- [ ] Sandbox keys in preview, production keys only in production secrets
- [ ] Timeouts, bounded retries and idempotency keys in place
- [ ] Tests for provider down, timeout, 429, malformed response
- [ ] Webhook signature, replay and duplicate tests
- [ ] Reconciliation job or a written reason why it isn't needed
- [ ] Provider limits, versions and contacts in the runbook

## Common mistakes
- SDK calls scattered across the codebase → impossible to mock or switch providers.
- Retrying a charge without an idempotency key → the user pays twice.
- Trusting webhook data without a signature check → anyone can fake a "payment succeeded".
- Assuming webhooks always arrive → orders stuck in "pending"; reconcile.
- Testing only with the mock → the real API's auth, formats and limits differ; run the sandbox flow before G4.
- Production keys in preview → test actions charge real money or message real users.

## Definition of done
The mock-based tests and a sandbox end-to-end run of each integration pass, failure-mode tests pass, webhooks are verified and deduplicated, and the runbook lists each provider's keys location, limits, version and status page.

## Per-stack notes
**FastAPI / Python:** `httpx.AsyncClient` with `timeout=` set; `tenacity` for bounded retries; Pydantic models for provider responses.
**Node:** `AbortSignal.timeout()` with `fetch`; `p-retry` for bounded retries; zod for provider responses.
**Cloudflare Workers:** outbound `fetch` has subrequest limits per request on the free plan (uncertain: check current limit); push slow integrations to Queues.
**Stripe-like payment providers:** use their idempotency headers and webhook signature helpers; treat the webhook as the source of truth, not the redirect.
**Carrier billing (SDP aggregators):** live API behavior often differs from public docs (paths, required app codes, masked subscriber IDs); test against the sandbox, record each quirk, and let a house stack's skill win.
