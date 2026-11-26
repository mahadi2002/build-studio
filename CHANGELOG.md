# Changelog

All notable changes to this skill. Versions follow [SemVer](https://semver.org/); the version in `.claude-plugin/plugin.json` matches the newest entry here.

## [4.3.0] - 2026-11-27
### Added
- Bundled craft guides in `references/vendor/`: full, unchanged copies of ponytail (all six skills), design-taste-frontend, emil-design-eng, apple-design, animate, review-animations, improve-animations, find-animation-opportunities and animation-vocabulary (18 files, MIT, credited in `references/vendor/LICENSES.md`). An index says when to load each and how they rank against build-studio's own rules.
- Rule 1.2 now carries ponytail's order of preference (not needed → existing code → standard library → native feature → installed dependency → one line → new code) and `ponytail:` shortcut comments.
- Code review (6.3) adds an over-engineering pass and, for UI and motion, the bundled review guides. The frontend and tech-lead roles point to the matching guides.
### Changed
- The lint skips style checks (not link checks) for `references/vendor/`, so the authors' text stays unchanged.

## [4.2.2] - 2026-11-27
### Fixed
- Section 10: the Claude Code update path now releases through the repo (bump the version, push, tag; marketplace installs update themselves) instead of asking for a zip to upload by hand. Uploading a `.skill` stays as the path for uploaded copies only.

## [4.2.1] - 2026-11-27
### Fixed
- README: claude.ai's automatic sync needs the Claude GitHub App to have access to the repository; added how to grant it and how to update by hand.

## [4.2.0] - 2026-11-27
### Added
- The owner profile can come from an installed skill named `build-studio-profile`: a private profile plugin in your own private repo. With claude.ai's automatic marketplace sync it updates claude.ai and Claude Code from one push, so there's no copy to keep in step by hand. It's checked first; the local file and the instructions section still work.

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
