# Build Studio

A Claude skill that takes an idea to a deployed, documented product for a one-person team. It walks the whole lifecycle (intake, idea brief, PRD, architecture, stack choice, plan, test-first build, verify, deploy, handoff, improve) and stops only at four approval gates. Free tiers by default.

- **One playbook** (`SKILL.md`, under 300 lines): lifecycle, gates, global engineering and security rules, role index, routes to other skills.
- **51 role guides** in three tiers: 21 researched Tier 1 roles (frontend, backend, mobile, DevOps, SRE, database, AI/LLM, AppSec, QA, ...), 21 Tier 2 roles from standards, and 9 Tier 3 roles (embedded, firmware, kernel, ...) that start with a scope check.
- **9 templates**: idea brief, PRD, ADR (with stack choice), change request, threat model, test plan, runbook, README, launch post.
- **A lint script** that keeps the skill honest: line limits, role structure, banned filler words, broken links, routed skill names, and safety rules that must never disappear.

## Install

### Claude Code (updates itself)
```
claude plugin marketplace add mahadi2002/build-studio
claude plugin install build-studio@build-studio
```
Then turn on auto-update once: run `/plugin`, open **Marketplaces**, pick **build-studio**, and enable auto-update. Claude Code checks for new versions shortly after a session starts and loads them on the next launch. Manual update any time: `claude plugin update build-studio@build-studio`.

### claude.ai (updates itself)
Go to **Plugins → Add → Add marketplace → Add from a repository**, enter `mahadi2002/build-studio`, keep **Sync automatically** on, and click **Sync**. Then open **Build studio** in the list and click **Add**. claude.ai re-syncs when the repository changes, and the Claude desktop app passes the update to Claude Code on the same machine.

No marketplace option? Download `build-studio.skill` from the [latest release](https://github.com/mahadi2002/build-studio/releases/latest) and upload it under Plugins; uploads don't update themselves.

## Make it yours: the owner profile
The skill reads an optional private profile with your live apps, paid hosting, domain, familiar stacks and any "house stack" (a fixed stack and workflow for a family of projects, usually with its own skill).

- Claude Code: create `~/.claude/build-studio/profile.md`.
- claude.ai: add a section titled **Build-studio owner profile** to Settings → Account → **Instructions for Claude**. This keeps auto-updates working, because the skill itself stays the public version.
- Prefer one private package instead? `python scripts/build_skill.py --profile path/to/profile.md` writes `dist/build-studio-owner.skill` to upload (no auto-update).

Start from [`owner-profile.example.md`](skills/build-studio/references/owner-profile.example.md). Never commit your profile; `.gitignore` already excludes it.

## The four gates
| Gate | When | You approve |
|---|---|---|
| G1 | after the PRD | problem, users, stories, acceptance criteria, non-goals, MVP cut |
| G2 | after architecture | design, stack choice (ADR), monthly cost, free-tier limits |
| G3 | any time | anything that spends money, creates an account or key, or touches real user data |
| G4 | before production | the production deploy, with rollback plan and preview smoke-test results |

Irreversible actions always wait for a yes. Security work is limited to systems you own or have written permission to test.

## How it was checked
- Blind evaluation on 8 scenarios against the previous version (idea to PRD and stack, mid-project stack change, FastAPI + JWT endpoint, bug from a stack trace, PR security review, Vercel deploy with rollback, ESP32 firmware, a fixed-stack project): this version won 6 of 8, judged by a separate model that did not know which reply came from which version.
- Behavior tests for the skill gap check (search only when the skill doesn't cover a task, never install without a yes) and for the Tier 3 low-risk and high-risk paths.

## Develop
```
bash skills/build-studio/scripts/lint.sh        # add LINT_SKIP_ROUTES=1 if the routed skills aren't installed
python scripts/build_skill.py                   # dist/build-studio.skill
```
Releases follow SemVer. To ship: bump `version` in `.claude-plugin/plugin.json`, add a `CHANGELOG.md` entry with the same number, then push a tag `vX.Y.Z`. CI lints, checks that the tag, version and changelog agree, and publishes a GitHub release with the `.skill` file. Auto-updating installs pick up the new version from the version bump.

Issues and pull requests are welcome. Keep rules paraphrased (no copied text), plain words, and run the lint before opening a PR.

## License and credits
MIT for this repository's own text and scripts (see `LICENSE`). Rules are paraphrased from, and credited to: Anthropic skills (Apache-2.0), obra/superpowers and forrestchang/andrej-karpathy-skills (MIT), vercel-labs/agent-skills (MIT), addyosmani/web-quality-skills (MIT), ideas from trailofbits/skills (CC BY-SA 4.0; ideas only, no text copied), OWASP (Top 10:2025, ASVS 5.0, API Security Top 10, Top 10 for LLM Applications), WCAG 2.2, the Twelve-Factor App, Google SRE concepts, Conventional Commits, SemVer and NIST SSDF.
