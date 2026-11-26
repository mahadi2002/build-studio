# Growth
tier: 1 | sources: kostja94 marketing-skills product-launch (listing), PRD success metrics practice, privacy rules in SKILL.md 6.5 | updated: 2026-11-26
Engineering-growth sources were weak (all under 150 installs); most rules here are practice-based and marked where uncertain.

## Triggers
- Measuring whether the product works: analytics, funnels, activation, retention.
- Onboarding changes, referral or sharing features, A/B tests, SEO for growth.
- After launch (SKILL.md 3.11), when deciding what to build next.

## Responsibilities
- G1: success metrics in the PRD with how each is measured.
- Build: an event plan, privacy-safe tracking, a simple dashboard.
- Improve: read the funnel, talk to users, propose the next 1-3 changes with evidence.

## Role-specific rules
**Measure what the PRD promised**
1. **One activation event** per product: the moment a new user gets real value (first routine saved, first quiz finished). Track time to it and the share of sign-ups that reach it.
2. **Retention over sign-ups:** week-1 and week-4 return rate by sign-up cohort tells more than total users.
3. **Event plan before code:** a short table of events (`object_action` names like `quiz_completed`), properties, and which PRD metric each serves. Track only what a decision needs.

**Privacy**
4. **Privacy-first analytics by default:** a cookieless tool, no personal data in event properties (no names, phone numbers, emails, free text).
5. **Consent** before non-essential cookies or cross-site tracking; a cookie banner only when such tracking exists.
6. **The privacy notice lists what is tracked and why** (SKILL.md 6.5). Check the data-protection law that applies to the users (for Bangladesh users, a personal data protection law has been in progress; uncertain, check its current status).

**Experiments**
7. **A/B tests need traffic:** with a few hundred users, a test rarely reaches a clear result. Prefer talking to 5 users, session recordings with consent, or before/after comparisons with a stated time window.
8. **When a test is worth running:** one hypothesis, one primary metric, a sample size estimate before starting, fixed duration, no peeking-and-stopping early.

**Product loops**
9. **Onboarding:** the shortest path to the activation event; defer optional setup; an empty state that shows how to start (frontend role).
10. **Sharing and referral** only where users naturally share (results, schedules, invites); every shared link has a clean preview (Open Graph) and a UTM tag.
11. **Notifications and email:** opt-in, useful, rate-limited, one-click unsubscribe; never bulk messages without my yes (sending is a gated action).
12. **SEO for growth:** pages that answer what the audience searches for; technical SEO is in the web-perf-a11y role.
13. **Talk to users:** a feedback link in the app and a few short conversations per month beat dashboards for small products.

## Default tool options
- Cookieless analytics: Umami (self-host free, or cloud free tier), Plausible (paid; self-host free), Cloudflare Web Analytics (free).
- Product analytics: PostHog free tier (events, funnels, feature flags, session replay with consent; uncertain on current limits).
- Search: Google Search Console (free).
- Error and analytics setup for the owner's apps: `vinktar:setup` route.

## Checklist
- [ ] Activation event and retention metric defined in the PRD
- [ ] Event plan table written; events map to metrics
- [ ] No personal data in events (checked in the analytics tool's live view)
- [ ] Consent and privacy notice match what is tracked
- [ ] Dashboard shows the funnel to activation and week-1 retention
- [ ] Shared links have Open Graph previews and UTM tags

## Common mistakes
- Tracking everything "just in case" → noisy data, privacy risk, no decisions.
- Counting sign-ups as success → users who never return look like growth.
- A/B tests on tiny traffic → random noise read as a win.
- Phone numbers or emails in event properties → personal data in a third-party tool.
- Growth features before the core works → retention stays low anyway.
- Sending marketing messages without opt-in.

## Definition of done
The activation and retention metrics show real numbers on a dashboard, the event plan matches the code, the analytics live view shows no personal data, and the next 1-3 proposed changes each cite a metric or user feedback.

## Per-stack notes
**React SPA:** send page views on route change, not only on first load; load the analytics script after first render.
**Next.js / Astro:** use the tool's official script component or a server-side proxy for cookieless tracking.
**Cloudflare-hosted sites:** Cloudflare Web Analytics needs no code on proxied sites (uncertain: depends on setup).
**Mobile apps:** analytics SDKs must appear in the store privacy forms (mobile role).
**Carrier-billing subscription sites:** subscription and billing metrics come from the gateway's own reports; don't add trackers that break the CSP.
