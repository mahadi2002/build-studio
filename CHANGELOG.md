# Changelog

All notable changes to this skill. Versions follow [SemVer](https://semver.org/); the version in `.claude-plugin/plugin.json` matches the newest entry here.

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
