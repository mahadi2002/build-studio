# AppSec
tier: 1 | sources: OWASP Top 10:2025, OWASP ASVS 5.0, trailofbits/skills ideas (paraphrased), NIST SSDF | updated: 2026-11-26

## Triggers
- Auth, sessions, roles, file upload, payments, user-generated content, admin panels, webhooks.
- A PR or repo security review, a dependency alert, a reported vulnerability.
- Before G4 on any app with accounts or personal data.
- SKILL.md 6.4 is the baseline every feature gets; this role adds the deeper work.

## Responsibilities
- Architecture: the threat model (`templates/threat-model.md`) and the ASVS level.
- Build: secure defaults in auth, access control, upload and output handling.
- Verify: security tests, SAST and dependency scans, a review of HIGH-risk changes.
- Respond: triage reported issues, fix, add a regression test, note it in the CHANGELOG.

## Role-specific rules
**Planning**
1. **ASVS level at G2:** Level 1 for every public app; Level 2 when the app holds personal, payment or health data. Pick the relevant ASVS chapters as the security checklist for the project.
2. **Threat model before build,** at least STRIDE over the trust boundaries, and each real threat mapped to a test or a check.
3. **Secure use is the easy use:** design APIs and config so the default is safe (deny by default, short token lifetimes, uploads private by default). Reject dangerous config combinations at startup.

**Authentication**
4. **Passwords:** a minimum length (NIST 800-63B rev. 4, final 2025: at least 15 when a password is the only factor, at least 8 with a second factor), allow long passphrases and paste, check against a breached-password list, no composition rules, no forced periodic rotation.
5. **Offer MFA** (TOTP or passkeys) for admin accounts at minimum; recovery codes shown once.
6. **Sessions:** new session ID at login and privilege change; idle and absolute timeouts; logout revokes server-side.
7. **OTP:** short expiry, few attempts, rate-limited per phone and per IP, codes compared in constant time, never logged.

**Access and data**
8. **Deny by default:** every route needs an explicit rule; tests for anonymous, wrong user and wrong role on every protected endpoint.
9. **Uploads:** check type by content (magic bytes), not by extension; size limit; random server-side names; serve from a separate domain or with `Content-Disposition: attachment`; scan or strip active content (SVG, HTML) before display.
10. **Output by context:** HTML-escape for HTML, URL-encode for URLs, parameterize for SQL; never build HTML or SQL with string joins.
11. **Fail closed** in every security check (SKILL.md 6.4); test the error path, not only the success path.

**Review and findings**
12. **Depth by size:** small repo, read everything near the change; medium, follow one hop of callers; large, only critical paths. State what was not covered.
13. **Escalate on sight:** removed checks, code removed in a "security" or "CVE" commit, new outbound calls with no validation, risky changes with many callers.
14. **Prove before reporting:** trace input to sink; argue against the finding once; models tend to over-rate severity. Mark findings you couldn't confirm as "unconfirmed".
15. **Tool results are partial:** "no findings" from a scanner means "none of the patterns it knows"; say which tools ran and on what.
16. **Severity** from impact and ease: critical (default use is exploitable), high (easy misuse or one step to exploit), medium, low. Use CVSS only when an external report needs it.

**Response**
17. `SECURITY.md` with a contact for public repos; acknowledge reports, fix, credit the reporter if they want.
18. A leaked secret is rotated first, then investigated; removing it from git history does not un-leak it.

## Default tool options
- SAST: Semgrep (community rules, free), CodeQL (free for public repos on GitHub).
- Secrets: gitleaks, GitHub push protection.
- Dependencies: `npm audit`, `pip-audit`, `composer audit`, Dependabot alerts, OSV-Scanner.
- DAST on my own preview only: OWASP ZAP baseline scan.
- Reviews: `security-reviewer` route for a full review; `ship-gate` route right before G4.

## Checklist
- [ ] Threat model written; each threat has a test or check
- [ ] ASVS level and chapters chosen at G2
- [ ] Auth boundary tests (anonymous, wrong user, wrong role) on every protected route
- [ ] Upload tests: wrong type, oversize, SVG with script
- [ ] SAST, secret scan and dependency audit in CI, results read
- [ ] No HIGH or critical open finding at G4, or a written accepted-risk note I approved
- [ ] SECURITY.md (public repos)

## Common mistakes
- Trusting a scanner's clean result → it only covers what it checks; review HIGH-risk code by hand.
- Reporting pattern matches as vulnerabilities → trace the data first.
- Checking file extension only → a renamed HTML or SVG runs script.
- Long-lived JWTs with no revocation → a stolen token works for weeks.
- Security tests only for the happy path → the error path is where checks fail open.
- Deleting a leaked key from git without rotating it.

## Definition of done
Threat model and checklist done, security tests passing in CI, scanners run with results read and triaged, no open HIGH or critical finding (or an approved accepted-risk note), and the `ship-gate` check passed before G4.

## Per-stack notes
**FastAPI:** `OAuth2PasswordBearer` or cookie sessions via a tested library; `passlib`/`argon2-cffi` or `bcrypt`; Pydantic strict types on IDs.
**Express:** `helmet`, `express-rate-limit`, `csurf` replacements (the `csurf` package is deprecated; use a maintained CSRF library or SameSite=strict cookies plus an origin check).
**Laravel:** built-in CSRF, `Hash::make`, Policies, `throttle` middleware; never disable CSRF for convenience.
**Next.js:** server actions still need auth and input checks; middleware auth is not enough by itself.
**Supabase:** RLS is the access control; test policies with anon and another user's JWT.
**House stack (owner profile):** its own security rules apply on top of these.
