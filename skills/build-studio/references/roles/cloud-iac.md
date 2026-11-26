# Cloud and infrastructure as code
tier: 1 | sources: 12-Factor, Cloudflare and Vercel DNS docs (knowledge, check current), wshobson terraform-module-library (listing) | updated: 2026-11-26

## Triggers
- Creating cloud resources: hosting projects, databases, buckets, queues, DNS records, API tokens.
- A new subdomain on my Cloudflare domain, an SSL or DNS problem, moving hosts.
- More than one environment or resources that would be painful to recreate by hand.

## Responsibilities
- G2: hosting map (which service runs what, in which region), free-tier limits, monthly cost.
- G3: every new account, paid resource or API key, before it is created.
- Build: config files in the repo that recreate the setup; DNS records for the project subdomain.
- Handoff: resource list and settings in the runbook.

## Role-specific rules
1. **Everything reproducible.** Host config lives in the repo (`vercel.json`, `wrangler.toml`, `render.yaml`, Supabase `config.toml`, Terraform). A setting only clickable in a dashboard gets written down in the runbook.
2. **IaC when it pays:** Terraform or OpenTofu when there are two or more environments, several resources, or a rebuild would take more than an hour. A single Vercel or Cloudflare project usually needs only its config file.
3. **One subdomain per project** on my Cloudflare domain, named after the project; record each DNS record's target and purpose in the runbook.
4. **Proxy or DNS-only is decided per project at G2,** from what the project needs, and recorded in the ADR. Proxy (orange cloud, Cloudflare SSL) when the project needs Cloudflare's WAF, rate limiting, bot protection, caching or origin hiding. DNS-only (grey cloud, host-issued certificate) when the host runs its own edge and advises against proxying (Vercel's docs recommend DNS-only, and its Bot Protection does not work behind a proxy) and none of those needs apply. Proxying a Vercel project anyway means following Vercel's guidance for it and testing SSL and caching on the preview.
5. **SSL mode Full (strict)** when the origin has a valid certificate. Never Flexible: it sends traffic to the origin unencrypted and causes redirect loops.
6. **DNS changes on a live domain wait for my yes** (SKILL.md section 2); lower the TTL before a planned move, and note the old record so it can be restored.
7. **Scoped API tokens only:** a Cloudflare token limited to one zone and DNS edit (or one Workers project), never the Global API Key; same idea on every provider.
8. **Region near users:** for users in Bangladesh pick the closest region a free tier offers (often Singapore or Mumbai) instead of the US default, and note the latency trade-off when only US regions are free.
9. **Terraform state holds secrets:** never commit it; keep it local and backed up, or in an encrypted remote backend. Review `plan` before `apply`; `apply` on production waits for my yes.
10. **Pin provider and tool versions** (Terraform providers, wrangler, Vercel CLI in CI).
11. **Naming:** `<project>-<env>-<resource>` so preview and production are never confused.
12. **Accounts with a card attached get a budget alert** at a low threshold the day they are created (G3).
13. **Clean up:** delete unused previews, buckets, tokens and DNS records; keep the runbook list current.

## Default tool options
- Config as code: `wrangler.toml` (Cloudflare), `vercel.json` (Vercel), `render.yaml` (Render), Supabase CLI `config.toml` + migrations.
- IaC: OpenTofu or Terraform with the Cloudflare provider for DNS and Workers settings; Pulumi when TypeScript is preferred.
- Cloudflare work: `cloudflare:cloudflare` and `cloudflare:wrangler` routes (Cloudflare MCP needs auth; wrangler works with `wrangler login`).
- Storage: Cloudflare R2 (no egress fees), Supabase Storage.

## Checklist
- [ ] Hosting map, regions and free-tier limits in the ADR
- [ ] New accounts and keys approved at G3
- [ ] Config files committed; dashboard-only settings in the runbook
- [ ] DNS record for the project subdomain documented, proxy choice recorded
- [ ] SSL mode Full (strict) or host-issued certificate verified with `curl -I https://...`
- [ ] API tokens scoped and stored in the host or CI secrets
- [ ] Budget alert set on any account with a card

## Common mistakes
- Flexible SSL "because it worked" → plaintext to the origin and redirect loops.
- Proxying a host that manages its own edge and certificates → certificate errors or broken caching.
- Global API Key in CI → full account takeover if leaked.
- Terraform state in git → secrets in history forever.
- Preview resources left running → quota used up or a surprise bill.
- Clicking settings without writing them down → the setup can't be rebuilt.

## Definition of done
The project subdomain resolves over HTTPS with a valid certificate (checked with `curl -I` and a browser), every resource is in config files or the runbook, tokens are scoped, and a fresh environment could be recreated from the repo plus the runbook.

## Per-stack notes
**Cloudflare:** Pages for static and full-stack frameworks, Workers for APIs and edge logic, R2 for files, D1 for small SQL, KV for config and cache; secrets with `wrangler secret put`; check the free plan's daily request limits.
**Vercel:** add the domain in the project, then a CNAME from my subdomain to the target Vercel shows; environment variables per environment (Development, Preview, Production); Hobby is non-commercial.
**Render:** blueprint in `render.yaml`; custom domain via CNAME; free web services sleep when idle.
**Supabase:** one project per environment if the free tier allows (check the current project limit); migrations through the CLI, not the dashboard.
**AWS / GCP / Azure:** free tiers need a card and some expire after 12 months (G3); use only when a service is not available on the free hosts above.
**cPanel shared hosting:** no IaC; record DNS, SSL and firewall settings in the runbook (a house stack's deploy guide wins).
