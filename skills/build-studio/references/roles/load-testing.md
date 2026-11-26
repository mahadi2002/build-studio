# Load testing
tier: 1 | sources: grafana/skills k6 (listing), Grafana k6 docs (knowledge), SRE concepts | updated: 2026-11-26
Only one credible public skill was found; rules below 0.8 confidence are marked.

## Triggers
- A known traffic event (a launch, a campus announcement, results day), a latency target in the PRD, an SLO.
- Slowness under real use, a free-tier quota question ("how many users can this host handle?").
- Not for: page load speed in the browser (web-perf-a11y role).

## Responsibilities
- G2: expected and peak load numbers from the PRD; whether the free tier can carry them.
- Plan: scenarios, targets and the environment to test.
- Run: tests, server-side measurements, a short report.
- Feed results into capacity notes in the runbook and into the SLO.

## Role-specific rules
1. **Start from a number:** expected users, requests per user per minute, peak multiplier (for example 5x on results day). No target, no load test.
2. **Targets as thresholds:** p95 latency (for example under 500 ms) and error rate (for example under 1%) for the main flow; the test fails if they're crossed.
3. **Test my own preview or staging, never production** without my yes and a plan to stop. Never test someone else's service.
4. **Read the host's terms first:** some free tiers forbid or limit load tests, and tests burn quotas (requests, function time, database reads). This can be a G3 item when it risks a bill or a ban (uncertain: check each host's terms).
5. **Realistic scenarios:** the real mix of actions (mostly reads, some writes), think time between steps, test users and data seeded in advance, unique values where the app checks for duplicates.
6. **Scenario types, smallest first:** smoke (1-2 users, checks the script works) → load (expected traffic) → stress (step up until it breaks) → spike (sudden jump) → soak (expected traffic for an hour, finds leaks). Run only what the PRD needs.
7. **Measure the server too:** database CPU and connections, function duration, cache hit rate, error logs during the test. Client numbers alone don't show the bottleneck.
8. **Change one thing at a time** between runs and record each run's result.
9. **Run the load generator from outside the host's network** and from a machine that isn't itself the bottleneck (check its CPU).
10. **Cold starts count:** on hosts that sleep when idle, measure the first request separately and decide whether the SLO covers it.
11. **Find the knee:** in a stress run, note the load where p95 or errors start rising sharply. State safe capacity well below it (about 70% is a common rule of thumb, uncertain) and write both numbers in the runbook.
12. **Re-test after fixes and before each traffic event,** with the same script, so results compare.

## Default tool options
- k6 (free, scripts in JavaScript, thresholds built in); Grafana Cloud k6 free tier for small cloud runs (uncertain: check current free limits).
- Locust (Python) when the team or test logic is Python.
- autocannon or `hey` for a quick single-endpoint check.
- Server metrics: the host's dashboard, database metrics, `honeycomb:*` routes if tracing is set up.

## Checklist
- [ ] Target numbers and thresholds written, from the PRD or SLO
- [ ] Host terms checked; quota impact estimated; my yes if it risks cost
- [ ] Test runs against preview or staging with seeded test data
- [ ] Smoke run passes before larger runs
- [ ] Server metrics captured during each run
- [ ] Report: scenario, numbers, bottleneck found, fix, re-run result

## Common mistakes
- Hammering one endpoint with no think time → unrealistic results.
- Testing production on a free tier → quota gone or account flagged.
- Reading only client latency → the cause (database connections, cold starts) stays hidden.
- Load generator on a weak laptop over home Wi-Fi → you measure the laptop.
- Many changes between runs → you don't know which one helped.
- Unique constraints hit by duplicate test data → errors that aren't real failures.

## Definition of done
A saved report shows the thresholds met at the target load on the preview (or the bottleneck found, fixed and re-tested), server-side metrics for the run, and the safe capacity written in the runbook.

## Per-stack notes
**k6:** `scenarios` with `ramping-vus` or `constant-arrival-rate`; `thresholds` for `http_req_duration{p(95)}` and `http_req_failed`; `check()` on responses; data from `SharedArray`.
**Serverless (Vercel, Cloudflare Workers):** watch function duration and invocation quotas; database connections are the usual limit, so use the pooler (database role).
**Render free:** expect cold starts after idle; warm up before measuring steady state.
**Supabase / Atlas free:** connection and request limits are low; test the pooler URL, not the direct one.
**cPanel shared hosting:** shared hosting has per-account process and CPU limits; test gently, off-peak, and only with my yes (uncertain: limits depend on the host plan).
