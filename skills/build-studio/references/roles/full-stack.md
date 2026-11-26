# Full-stack
tier: 1 | sources: frontend and backend roles, obra/superpowers writing-plans, 12-Factor | updated: 2026-11-26

## Triggers
- One feature crosses UI, API and data, and one person builds all of it (the default for my projects).
- A bug whose cause could be in any layer.
- Not a replacement for the frontend and backend roles: load them for their rules; this role covers the seams between layers.

## Responsibilities
- Plan features as vertical slices: each task delivers a thin working path from UI to database.
- Own the contract between layers and keep both sides in sync.
- Keep local, preview and production environments alike.
- Test the main flow end to end through all layers.

## Role-specific rules
1. **Vertical slices, not layers.** Task 1 is the thinnest end-to-end path (one field, one endpoint, one table, one test through the UI), not "all models", then "all endpoints". Each slice is demoable.
2. **One source of truth for shapes.** Generate client types from the API schema (OpenAPI to TypeScript) or share one schema package. A field renamed on one side must fail the build on the other.
3. **Validation lives on the server;** the client reuses the same schema for fast feedback only.
4. **Errors cross the boundary on purpose:** the API returns the one error shape; the UI maps codes to messages and field errors. No raw server text shown to users.
5. **Auth state has one owner.** Decide once whether the session is a cookie (server owns it) or a token (client stores it in memory and refreshes). Don't mix.
6. **Dev/prod parity:** same database engine locally as in production (no SQLite locally with Postgres in production), same major runtime version, env vars from one `.env.example`.
7. **Seed data script** that creates a known state for local work and end-to-end tests, never copied from production.
8. **Debug across layers by boundary:** log what the UI sends, what the API receives and returns, what the DB query is; find the first layer where the value is wrong (SKILL.md 6.1).
9. **Feature flags only when needed** (a half-done feature must ship); otherwise finish the slice before merging.
10. **Monorepo or two repos:** one repo with `web/` and `api/` folders for a solo project unless hosting forces a split; one CI that runs both.
11. **CORS and cookies are designed, not patched:** decide domains at G2 (same site via subdomains of my domain is simplest for cookies), then set explicit origins.
12. **Migrations ship before code that needs them,** and code tolerates both old and new schema during a deploy (database role, expand and contract).

## Default tool options
- Type sharing: `openapi-typescript` or `orval` from FastAPI/Express OpenAPI; tRPC when both sides are TypeScript and in one repo; zod schemas in a shared package.
- End-to-end: Playwright against the preview deploy.
- Local stack: one command (`docker compose up`, `npm run dev` with concurrently, or a Makefile) that starts web, API and database.
- Full-stack frameworks when they fit at G2: Next.js, SvelteKit, Laravel + Inertia, Django.

## Checklist
- [ ] First slice runs end to end before the second starts
- [ ] Client types are generated or shared, and the build fails on a contract mismatch
- [ ] One command starts the whole stack locally
- [ ] Same DB engine and major versions in local and production
- [ ] Seed script creates the test state; no production data locally
- [ ] End-to-end test of the main flow passes against the preview
- [ ] CORS origins and cookie domain written in the ADR

## Common mistakes
- Building all of the backend first → the UI reveals the contract was wrong after the work is done.
- Hand-copied types on both sides → silent drift; generate them.
- SQLite in dev, Postgres in prod → queries and constraints behave differently.
- Fixing a bug in the layer where it shows instead of where it starts.
- Cookies across different domains (`app.vercel.app` + `api.onrender.com`) → third-party cookie blocks; put both under my subdomain or use tokens.

## Definition of done
The slice works through UI, API and database on the preview deploy; the end-to-end test for it passes in CI; generated types are committed or built in CI; README quick start brings the whole stack up in under 5 minutes.

## Per-stack notes
**React + FastAPI:** `openapi-typescript` from `/openapi.json` in a `npm run gen:api` script; run it in CI and fail on a diff.
**React + Express (TypeScript):** shared zod schemas in `packages/schema`; infer types with `z.infer`.
**Next.js / SvelteKit (one app):** keep server code in server-only modules; the "API contract" is the server action or route handler signature; still validate input there.
**Laravel + Inertia or Blade:** Form Requests are the contract; return typed props; Dusk or Playwright for end to end.
**Supabase + SPA:** the database is the API; row-level security policies are the authorization layer and need their own tests.
**House stack (owner profile):** its skill defines the layers and flow; this role adds nothing there.
