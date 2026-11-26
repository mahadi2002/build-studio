# SRE
tier: 1 | sources: Google SRE concepts (SLI, SLO, error budget, postmortems), honeycomb skills (installed), engineering:incident-response (installed) | updated: 2026-11-26

## Triggers
- An app with real users, an uptime promise, alerts, an outage, a "it was down last night".
- Planning backups, monitoring or on-call for a live app.
- Not active for prototypes with no users; say so in role selection.

## Responsibilities
- G2: one SLO per app and what it costs to meet on free tiers.
- Deploy: health check, uptime check, alerts and backups in place before launch (SKILL.md 3.9).
- Incidents: stabilize, communicate, find the root cause, write the postmortem.
- Handoff: the runbook (`templates/runbook.md`) kept current.

## Role-specific rules
**Targets**
1. **One SLO per app to start:** the main flow's success rate (for example 99.5% of logins and main actions succeed per month) or its p95 latency. Write the SLI (how it's measured) next to it.
2. **Error budget = 100% minus the SLO.** When the month's budget is spent, stop feature work and fix reliability first.
3. **Free-tier SLO reality:** hosts that sleep when idle or pause inactive projects can't meet a tight SLO. Name this at G2 and pick the SLO accordingly.

**Alerts**
4. **Alert on symptoms users feel:** main flow failing, error rate up, the uptime check failing, quota nearly used. Not on CPU or memory alone.
5. **Every alert is actionable** and links to a runbook section. An alert that needs no action gets deleted or turned into a dashboard.
6. **Alert at 80% of any free-tier quota** (requests, storage, database size, AI credits) so the app doesn't stop without warning.
7. External uptime check every 5 minutes on the health endpoint and the main page, from outside the host.

**Incidents**
8. **Stabilize first:** roll back or switch off the feature before debugging. A rollback is faster and safer than a fix forward.
9. Post a short status note for users when the main flow is down more than a few minutes.
10. Then root cause with SKILL.md 6.1, and a blameless postmortem: what happened, impact (users, duration), timeline, root cause, actions with dates. Each action becomes a task or a test.
11. Most incidents follow a change: check the last deploy, config or dependency update first.

**Data safety**
12. Automated backups with a copy outside the host, a retention period, and a restore drill: once per project, then after any backup or database change.
13. Know the restore time: how long from "data lost" to "app back with yesterday's data". Put it in the runbook.

**Observability**
14. A request ID generated at the edge and passed through every layer and log line.
15. Logs kept long enough to debug last week's issue; free plans keep logs only a short time, so ship important ones to a log tool if needed.

## Default tool options
- Uptime: UptimeRobot or Better Stack free plans (uncertain: check current free limits); Cloudflare health checks on paid plans only (uncertain).
- Errors: Sentry free tier; `vinktar:setup` route for the owner's error tracking and analytics setup.
- Tracing and SLOs: `honeycomb:observability-fundamentals`, `honeycomb:slos-and-triggers` (Honeycomb free tier; MCP needs auth).
- Incidents: `engineering:incident-response` route.
- Alerts to phone: email, Telegram bot, or the uptime tool's mobile app.

## Checklist
- [ ] SLO and SLI written in the runbook
- [ ] Uptime check on health endpoint and main page, alerting to my phone
- [ ] Error tracking receives a test error from production
- [ ] Quota alerts at 80% on each free-tier service
- [ ] Backups automated, copied off the host, and one restore tested with the time recorded
- [ ] Rollback steps in the runbook and tested once
- [ ] Request IDs visible in logs across layers

## Common mistakes
- Alerting on everything → alerts get muted and the real outage is missed.
- Debugging a live outage before rolling back → longer downtime.
- Backups that were never restored → they may not work; drill once.
- Uptime check from inside the host → it can't see DNS, SSL or edge failures.
- Ignoring free-tier pauses (an inactive Supabase project pauses) → the app "breaks" with no code change.
- Postmortem that blames a person → find the missing check or test instead.

## Definition of done
For a live app: SLO written, uptime and error alerts proven with a test alert, backups restored once with the time recorded, rollback tested, runbook complete. For an incident: service restored, postmortem written, each action tracked as a task.

## Per-stack notes
**Vercel:** instant rollback to a previous production deployment; runtime logs are kept briefly on Hobby (uncertain: check retention); add an external uptime check.
**Cloudflare Workers/Pages:** Workers logs and analytics in the dashboard; `wrangler tail` for live logs; free plan request limits per day apply.
**Render:** set the health check path; free instances sleep when idle, so the SLO must allow cold starts.
**Supabase:** free projects pause after 7 days of low activity (an email warns first) and stay restorable for 90 days; free-plan backups are limited; schedule your own `pg_dump` to storage outside Supabase.
**MongoDB Atlas free:** no automated backups on the free cluster (uncertain); schedule `mongodump`.
**cPanel:** cron-based backups to off-host storage; check the host's own backup schedule.
