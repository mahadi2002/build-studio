# QA / SDET
tier: 1 | sources: v1 s7, obra/superpowers test-driven-development, anthropics webapp-testing, trailofbits property-based and mutation testing (ideas) | updated: 2026-11-26

## Triggers
- A new project's test plan (`templates/test-plan.md`), a new feature or bug fix (test first, SKILL.md 6.2).
- Flaky or slow tests, low confidence before a release, a bug that tests missed.
- Setting up end-to-end tests against previews.

## Responsibilities
- Plan: test levels, tools and commands per stack; coverage by PRD story; likely-to-break inputs mapped to tests.
- Build: test helpers, fixtures, seed data, CI test jobs.
- Verify: the release gate (all tests green on the exact commit, end-to-end on the preview).
- Improve: every escaped bug gets a regression test at the lowest level that catches it.

## Role-specific rules
1. **Test behavior, not implementation:** assert on outputs, responses and visible UI, not on private functions or call counts.
2. **One behavior per test, a name that states it:** `rejects_expired_token`, not `test_auth_3`.
3. **Real dependencies where cheap:** a real test database (container or a throwaway schema), real HTTP through the app; mock only external paid or rate-limited services.
4. **Test data is built, not copied:** factories or a seed script; never production data.
5. **Each test sets up and cleans its own state;** tests pass in any order and in parallel.
6. **End-to-end tests are few and stable:** the PRD's critical flows only, run against the preview deploy in CI.
7. **Flaky test rule:** a flaky test is a bug. Quarantine it within a day (skip with a linked task), find the cause (timing, shared state, order), fix it. Never "retry until green" as the fix.
8. **Wait for state, not time:** wait for an element, a response or network idle; no fixed sleeps.
9. **Coverage is a map, not a goal:** read the uncovered lines of changed code; don't chase a percentage.
10. **Property-based tests** for parsers, validators, money and date math: generate many inputs and check invariants (round-trip, ordering, totals).
11. **Mutation testing** once on core business logic to see whether the tests catch changes (uncertain value for small apps; optional).
12. **Accessibility checks inside end-to-end tests** (axe on each main page) so regressions fail CI.
13. **Bug reports and fixes** follow SKILL.md 6.1; the test that reproduces the bug is written before the fix and stays.

## Default tool options
- Python: pytest + httpx `AsyncClient` for FastAPI; `pytest-asyncio`; Hypothesis for property tests; factory_boy.
- JavaScript/TypeScript: Vitest + Testing Library for components; supertest for Express; fast-check for property tests; MSW to mock external HTTP.
- PHP: PHPUnit or Pest; a house stack may bring its own test tools.
- End-to-end: Playwright (Python or TypeScript, headless Chromium).
- Mutation: mutmut (Python), Stryker (JS/TS).

## Checklist
- [ ] Test plan exists with levels, tools and commands
- [ ] Every PRD story has at least one test; likely-to-break inputs each have one
- [ ] Auth boundary tests exist (SKILL.md 6.2)
- [ ] Tests run in CI on every push; end-to-end against the preview
- [ ] No fixed sleeps; no test depends on another's state
- [ ] No quarantined test older than a week without a task
- [ ] Release run: all green on the exact commit being shipped

## Common mistakes
- Mocking the database → tests pass while real queries fail; use a real test DB.
- Many end-to-end tests for edge cases → slow and flaky; push edge cases down to unit or integration tests.
- `sleep(2)` to wait for the UI → flaky on CI; wait for the element.
- Inspecting the DOM before the page settles → wait for network idle first.
- Shared test accounts across tests → order-dependent failures.
- Writing the test after the fix → it may never have failed; watch it fail first.

## Definition of done
The test plan's commands all pass in CI on the release commit, end-to-end tests pass on the preview, every escaped bug from this cycle has a regression test, and no flaky test is hidden without a task.

## Per-stack notes
**Playwright:** always `wait_for_load_state('networkidle')` (or wait for a specific element) before inspecting a dynamic page; take a screenshot first when exploring; find selectors from the rendered page; prefer `role=` and `text=` selectors; close the browser. For static HTML, read the file to find selectors first.
**FastAPI:** override dependencies (`app.dependency_overrides`) for auth in tests; use a separate test database URL; `httpx.AsyncClient` with the ASGI transport.
**React:** Testing Library queries by role and label; `userEvent` over `fireEvent`; MSW for API responses in component tests.
**Next.js / SvelteKit:** test server code as functions plus a few end-to-end flows; component tests for client pieces.
**Supabase:** test RLS policies with the anon key and two user JWTs against a local Supabase (`supabase start`).
**Cloudflare Workers / Pages:** run API tests inside the Workers runtime with `@cloudflare/vitest-plugin` (`cloudflareTest()` in the Vitest config; the older `@cloudflare/vitest-pool-workers` is deprecated). For D1, read migrations in the config with `readD1Migrations("./migrations")`, pass them as a binding, and call `applyD1Migrations(env.DB, migrations)` in a setup file; each test file gets isolated storage.
**House stack (owner profile):** follow its skill's testing guide and tools.
