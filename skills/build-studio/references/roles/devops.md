# DevOps
tier: 1 | sources: 12-Factor, NIST SSDF SP 800-218, GitHub Actions security hardening guidance, trailofbits agentic-actions ideas, v1 s12 | updated: 2026-11-26

## Triggers
- Setting up a repo, CI, preview deploys, environments, build scripts, containers.
- A failing pipeline, a slow build, a deploy that works locally but not on the host.
- Not for: uptime targets and incidents (sre role), cloud resources and DNS (cloud-iac role).

## Responsibilities
- Plan: environments (local, preview, production), branch flow, the CI workflow file.
- Build: the CI pipeline in the order SKILL.md 6.5 sets, preview deploy per branch, release tagging.
- Deploy: carry out SKILL.md 3.9 with the host's commands; record deployment IDs for rollback.
- Handoff: deploy and rollback steps in the runbook.

## Role-specific rules
**Pipeline**
1. **Least privilege tokens:** set `permissions:` at the top of every workflow (start from `contents: read`) and widen per job only where needed.
2. **Pin third-party actions to a full commit SHA,** with the version in a comment; let Dependabot or Renovate update them.
3. **Untrusted event text never goes inline into `run:`.** Issue titles, PR bodies and branch names pass through `env:` and are quoted; otherwise they are shell injection.
4. **No `pull_request_target` with a checkout of the PR head.** Forked PRs get no secrets.
5. **Secrets live in the host or in CI environments,** never in the repo, never echoed. Prefer OIDC to cloud providers over long-lived keys where the provider supports it.
6. **Secret scan** (gitleaks or the host's push protection) in CI and as a pre-commit hook.
7. **Build once, deploy the same artifact** to preview and production; don't rebuild between them.
8. **Fast feedback:** cache dependencies, run lint before tests, cancel superseded runs with a `concurrency` group, keep the main pipeline under about 10 minutes.
9. **Reproducible installs:** `npm ci`, `pip install --require-hashes` or `uv sync --frozen`, `composer install` with a lockfile; never `install` that rewrites the lockfile in CI.

**Environments and release**
10. **Preview per branch or PR** with its own env vars; preview never points at the production database.
11. **Main is always deployable.** Protect it with required checks where the plan allows (branch protection on private repos may need a paid GitHub plan; uncertain, check current terms).
12. **Releases:** tag `vX.Y.Z`, CHANGELOG entry, release notes from Conventional Commits (release-please optional).
13. **Deploy small and when I'm available to watch:** not right before sleep or an exam.

**Containers (only when the host needs one)**
14. Multi-stage build, small base image pinned by digest, non-root user, `.dockerignore`, no secrets in layers or build args; health check in the image.

**Windows dev machine**
15. `.gitattributes` with `* text=auto eol=lf` so shell scripts and CI behave the same as on my Windows PC.

## Default tool options
- CI: GitHub Actions (free minutes for private repos are limited; public repos free).
- Deploy: Vercel git integration (frontends), Cloudflare Pages or Workers via `wrangler` (`cloudflare:wrangler` route), Render auto-deploy (backends; free plan sleeps when idle), cPanel shared hosting for PHP sites.
- Dependency updates: Dependabot (built in) or Renovate.
- Secret scanning: gitleaks, GitHub push protection.
- Release automation: release-please, or a manual tag + CHANGELOG for small projects.
- Containers: Docker with BuildKit; only if the host requires it.

## Checklist
- [ ] Workflow has `permissions:` and pinned action SHAs
- [ ] No untrusted `${{ github.event.* }}` inline in `run:`
- [ ] CI runs lint → test → build → security scan and is green on main
- [ ] Secret scan passes; `.env` is ignored; `.env.example` complete
- [ ] Preview deploy works per branch and uses non-production data
- [ ] Deployment ID or tag recorded before every production deploy
- [ ] Rollback command tested once on a preview

## Common mistakes
- `uses: some/action@main` → a compromised upstream runs in my CI; pin the SHA.
- Default write-all `GITHUB_TOKEN` → a compromised step can push code.
- Secrets in build logs via `set -x` or `echo` → mask them and never print env.
- Preview sharing the production database → test data and migrations hit real users.
- "Works on my machine" builds → pin runtime versions (`.nvmrc`, `.python-version`, `engines`).
- Fixing a red pipeline by skipping the step → find the root cause (SKILL.md 6.1).

## Definition of done
A green pipeline on main in the required order, a preview URL per branch, a documented and once-tested rollback, secrets only in the host or CI, and the deploy section of the runbook filled.

## Per-stack notes
**Vercel:** git push to a branch = preview, merge to the production branch = production; `vercel ls` and `vercel inspect` for status; promote or roll back to a previous deployment from the dashboard or CLI (check current CLI commands); Hobby is for non-commercial use.
**Cloudflare Workers/Pages:** `wrangler.toml` in the repo; `wrangler deploy` from CI with a scoped API token; secrets via `wrangler secret put`; versions and rollbacks through `wrangler` (check current command names).
**Render:** `render.yaml` blueprint in the repo; health check path set; free instances sleep after idle and cold-start slowly, so the uptime check should not count that as an outage (or use a paid plan, G3).
**Python:** `uv` or `pip-tools` for locked dependencies; `ruff` and `mypy` in the lint step; `pip-audit` in the security step.
**Node:** `npm ci`; `eslint`, `prettier --check`, `tsc --noEmit` in the lint step; `npm audit --omit=dev` in the security step.
**PHP on shared hosting:** deploy by upload or git pull as the host allows; a house stack's deploy guide wins (some forbid Composer).
