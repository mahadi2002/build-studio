# Developer Experience
tier: 2 | sources: Twelve-Factor App, GitHub docs on template repositories and dev containers, Diataxis documentation framework | updated: 2026-11-26

## Triggers
- Setup scripts, CLI tools, project templates, SDKs, contributor or developer docs, slow local feedback loops.
- Not for end-user docs or the launch site (launch-devrel).
## Responsibilities
- Plan: find the slowest step for a new developer. Build: one-command setup, task runner, templates. Verify: a clean-machine run. Handoff: README quickstart and troubleshooting page.
## Role-specific rules
1. Aim for clone, one command, running app. Time it on a clean checkout and write the time in the README.
2. One task entry point (`make`, `just` or npm scripts) with the same names in every project: setup, dev, test, lint, build.
3. Setup scripts are safe to run twice, print what they do, and stop with a clear fix message. They never delete data or invent secrets.
4. Setup copies `.env.example` (SKILL.md 6.5) and never fills in real keys.
5. Fast feedback: watch mode, hot reload, tests on changed files, local lint in seconds. Slow checks go to CI.
6. A CLI has `--help`, meaningful exit codes, no prompts when flags are given, and errors that name the next step.
7. Docs by need (Diataxis): tutorial, how-to, reference, explanation. Keep a first-run page and a common-errors page.
8. Test templates: CI generates a project from the template and runs its tests.
## Default tool options
- Task runners: `just`, `make`, npm scripts, or PowerShell scripts on Windows.
- Same environment everywhere: dev containers, `mise` or `asdf` for versions, Docker Compose for local databases.
- Docs: Markdown in the repo, MkDocs or Docusaurus on a free static host.
## Checklist
- [ ] Clean-machine setup run done, time recorded
- [ ] Setup script rerun is safe
- [ ] README quickstart copied and pasted, works
- [ ] Template generated and tested in CI
## Common mistakes
- README steps that drifted from reality → run them in CI.
- Hidden global tools → pin versions in the repo.
- Ten manual setup steps → script them or remove them.
- Docs written once and never rerun → check them whenever the setup changes.
## Definition of done
A second person, or a fresh machine or container, goes from clone to passing tests using only the README, within the stated time.
## Per-stack notes
- Windows and WSL: say which shell each script targets; set line endings in `.gitattributes` (uncertain: per-tool quirks).
- Node: `engines` field and a lockfile. Python: `uv` or venv plus a lock file. PHP: Composer scripts.
