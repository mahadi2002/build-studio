# Cloud security
tier: 1 | sources: OWASP Top 10:2025 (A02 misconfiguration), NIST SSDF, provider security docs (google/skills, aws agent-toolkit listings) | updated: 2026-11-26

## Triggers
- Creating or changing cloud accounts, API tokens, buckets, databases, DNS, CI secrets.
- A leaked key, a public bucket, an unknown login alert, a surprise bill.
- Before G4 on any project, and once per quarter for live apps.

## Responsibilities
- G3: every new account and key gets its security settings at creation time.
- Build: least-privilege tokens, private storage, network limits on databases.
- Verify: an account and resource review before launch.
- Respond: leaked-secret and account-compromise steps in the runbook.

## Role-specific rules
**Accounts (the solo developer's biggest risk)**
1. **MFA on every account** that can change code or infrastructure: GitHub, Cloudflare, Vercel, Render, Supabase, Atlas, the domain registrar, the email account that recovers them. Prefer passkeys or an authenticator app over SMS.
2. **Recovery codes stored offline** (printed or in a password manager), never in the repo or a chat.
3. **Registrar lock and Cloudflare account security on the domain;** losing the domain loses every project.
4. **No root or owner keys in code or CI:** create scoped tokens per project and purpose, with an expiry where the provider allows.

**Secrets**
5. Secrets in the host's secret store or CI environments only; never in client bundles, images or logs.
6. One secret per environment (preview and production differ).
7. Rotation plan: know how to rotate each key without downtime; rotate on any suspected leak, on team change, and yearly.

**Storage and data**
8. **Buckets private by default;** share files with signed, expiring URLs. Public buckets only for truly public assets, in a separate bucket.
9. **Databases not open to the whole internet when avoidable:** IP allowlists or private networking where the host supports them. Where serverless hosts force `0.0.0.0/0` (changing IPs), require TLS, a strong unique password and least-privilege users, and write the accepted risk down.
10. Encryption at rest is usually on by default; confirm it, and encrypt especially sensitive fields in the app (database role).

**Edge and domain**
11. **Email spoofing protection on my domain** even if it sends no mail: SPF `v=spf1 -all` and a DMARC `p=reject` record for non-sending domains; proper SPF, DKIM and DMARC for domains that send.
12. Cloudflare free managed WAF rules and DDoS protection on proxied projects; rate-limiting rules on login and API paths where the plan allows (uncertain: check free-plan rule limits).
13. DNSSEC on when the registrar supports it with Cloudflare.

**Monitoring and response**
14. Login and audit logs on where the provider offers them; alerts for new logins on GitHub and Cloudflare.
15. **Billing alerts** at a low threshold on any account with a card.
16. **Leaked secret response:** revoke and rotate immediately, check the provider's logs for use, then find how it leaked and add a scan that would catch it.

## Default tool options
- Password manager with TOTP and passkeys (Bitwarden free).
- Secret scanning: gitleaks, GitHub push protection, provider leak alerts.
- Cloud posture: provider security dashboards (Cloudflare Security Center, Supabase Security Advisor, GitHub security tab).
- Provider-specific depth: Google Cloud and AWS skills from discovery (notes-discovery.md) only when those clouds are in the stack.

## Checklist
- [ ] MFA on every account in the hosting map, recovery codes stored offline
- [ ] Tokens scoped per project, listed in the runbook with where they're used
- [ ] No secrets in repo history (gitleaks full-history scan)
- [ ] Buckets private unless documented public
- [ ] Database network access limited, or the risk written down
- [ ] SPF and DMARC records on the domain
- [ ] Billing alerts on accounts with a card
- [ ] Leaked-secret steps in the runbook

## Common mistakes
- One all-powerful API token shared by every project → one leak exposes everything.
- MFA on GitHub but not on the email that resets it → the attacker resets via email.
- Public bucket "just for testing" → indexed and scraped.
- Atlas or Supabase open to `0.0.0.0/0` with a weak password → brute-forced.
- Rotating a key without updating every place it's used → outage; keep the usage list.
- No DMARC on a domain → phishing mail sent as my domain.

## Definition of done
The account and resource review checklist is complete and saved in the runbook, the gitleaks full-history scan is clean, and a test rotation of one production secret was done without downtime.

## Per-stack notes
**Cloudflare:** API tokens from templates with zone-scoped permissions; R2 buckets private, public access through a custom domain only for public assets; Zero Trust Access (free tier) to protect admin panels (uncertain: check seat limit).
**Vercel:** environment variables marked sensitive; deployment protection on previews where the plan allows (uncertain on Hobby).
**Supabase:** never ship the service-role key to the client; Security Advisor findings fixed before launch; network restrictions where available.
**MongoDB Atlas:** database users per app with least privilege; network access list; no admin user in the app's connection string.
**GitHub:** fine-grained personal access tokens with repo scope and expiry; secret scanning and push protection on; Dependabot alerts on.
**cPanel:** keep the cPanel login behind MFA; use its IP blocker and firewall settings and record them in the runbook.
