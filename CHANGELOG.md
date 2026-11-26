# Changelog

All notable changes to this skill. Versions follow [SemVer](https://semver.org/); the version in `.claude-plugin/plugin.json` matches the newest entry here.

## [4.1.0] - 2026-11-27
### Changed
- License is now **Apache-2.0** (was MIT). See `LICENSE` and `NOTICE`. Copies obtained under 4.0.2 or earlier keep the MIT License.
- The `.skill` package now includes `LICENSE` and `NOTICE`.

## [4.0.2] - 2026-11-26
### Changed
- Owner profile can also come from a "build-studio owner profile" section in the user's instructions or memory, so claude.ai users keep auto-updates (no local file there).
- README: claude.ai install now follows the repo as a marketplace with automatic sync; uploading the `.skill` is the fallback.

## [4.0.1] - 2026-11-26
Lessons from the first real project built with the skill.
### Fixed
- QA/SDET role: Cloudflare Workers and Pages tests use `@cloudflare/vitest-plugin`; the older `@cloudflare/vitest-pool-workers` is deprecated. Added how to apply D1 migrations in tests.
- DevOps role: npm 11+ blocks install scripts by default; approve only the packages the stack needs and review `allowScripts`. Check a CI step's own exit code instead of piping it.

## [4.0.0] - 2026-11-26
First public release.
### Added
- Full lifecycle with four approval gates (G1 PRD, G2 architecture + stack + cost, G3 money, accounts or real data, G4 production).
- Stack selection per project with a comparison table and ADR, and a change-request process for mid-project stack changes.
- 51 role guides in three tiers, with per-stack notes; Tier 3 roles start with a scope check, and low-risk hardware work gets compile-ready code labeled "not tested on hardware".
- Skill gap check: searches for an existing skill only when a step isn't covered; reads candidates as reference; installs only after a yes.
- Owner profile: optional private file for live apps, paid hosting, domain and house stacks.
- Nine templates and a lint script with safety-rule sentinels.
### Changed
- Security rules cite OWASP Top 10:2025; accessibility rules use WCAG 2.2 AA.

## Earlier versions
- 3.x: skill gap check added (private).
- 2.x: rewrite from a single playbook into lifecycle, gates and role files (private).
- 1.x: single playbook with a fixed default stack (private).
