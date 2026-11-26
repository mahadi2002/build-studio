# Platform
tier: 2 | sources: CNCF Platforms White Paper, Team Topologies (platform team), 12-factor app | updated: 2026-11-26

## Triggers
- A second or third app needs the same CI, deploy, secrets or logging setup; a request for a template, a shared action or a "golden path".
- Not for: one app's own pipeline (devops role) or cloud resource setup alone (cloud-iac role).

## Responsibilities
- Architecture: decide what is shared and what each app owns; write the ADR (SKILL.md 3.3).
- Build and handoff: templates, reusable CI workflows, a README per template, a short upgrade note for each release.

## Role-specific rules
1. Build a shared tool only after two real apps need it. One user means keep it inside that app.
2. Treat the platform as a product: name the users (you and your apps), list their pain, and measure time to first deploy.
3. A golden path is the easiest route, not the only route. An app may leave it, with the reason written in its ADR.
4. Version templates and shared workflows with SemVer tags. Apps pin a tag, never `main`.
5. Keep apps independent at runtime. A platform outage must not take a running app down (uncertain: depends on the tool).

## Default tool options
- Templates: GitHub template repos, `cookiecutter` or `copier`; pick `copier` when apps need template updates later.
- Shared CI: GitHub Actions reusable workflows and composite actions (free for public repos, minutes capped on private).
- Self-service infra: Terraform or OpenTofu modules; Backstage only past about 10 services (heavy to run, uncertain).

## Checklist
- [ ] A new app reaches a working preview deploy from the template with no manual edits beyond a name and secrets
- [ ] Each shared piece has a version tag, an owner and a changelog line; pinned by every app that uses it

## Common mistakes
- Building a platform for one app → copy-paste until the second app proves the need.
- Pinning apps to `main` → one template change breaks every app; pin tags.
- A template that hides all config → debugging gets harder; keep outputs readable and documented.
- Skipping upgrade notes → apps stay on old versions and drift.

## Definition of done
A fresh app is created from the template, passes CI and deploys to preview in one sitting, with timings recorded in the README.

## Per-stack notes
- GitHub Actions: `workflow_call` for reusable workflows; secrets pass with `secrets: inherit` only inside one org or user.
- Terraform / OpenTofu: one module per resource type, with outputs and a tested example; state stays remote and locked (cloud-iac role).
