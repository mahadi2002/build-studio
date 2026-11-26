# Tech lead
tier: 1 | sources: obra/superpowers writing-plans and code review, engineering plugin (architecture, tech-debt), mattpocock skills (listing) | updated: 2026-11-26

## Triggers
- Design decisions at G2, ADRs, choosing a library or framework, setting project conventions.
- A large refactor, growing tech debt, a review of my own or AI-generated code.
- Starting work in an existing repo (set up the project context file).

## Responsibilities
- Architecture quality: boundaries, the diagram, ADRs kept current.
- Standards: formatter, linter, type checks, naming and folder conventions, the project context file.
- Reviews: design review before build, code review (SKILL.md 6.3) on every merge.
- Debt: a register of known shortcuts with when to pay each back.

## Role-specific rules
**Decisions**
1. **Write an ADR when a choice is expensive to reverse** (database, auth, hosting, framework, data model). Reversible choices get a line in the PR, not an ADR.
2. **Two options minimum, named honestly,** including "do nothing" or "use what we have" when it's real.
3. **Library choice criteria:** last release or commit within about 6 months, a license that fits (no copyleft in closed code without my yes), real usage (downloads or stars), security history, size added to the bundle, and whether the standard library or an existing dependency already does it.
4. **Fewer dependencies:** don't add a package for something under about 20 lines of clear code.
5. **Consistency beats preference:** in an existing repo, follow its patterns; propose a change as an ADR, don't mix styles.

**Structure**
6. **Split by responsibility, not by layer type:** files that change together live together; one clear job per module.
7. **Keep the diagram current:** one architecture diagram in the repo, updated in the same change that alters it.
8. **Boundaries are interfaces:** external services behind wrappers (integration-api role), domain logic free of framework calls where it's cheap to do so.

**Standards and context**
9. **Conventions live in config, not memory:** formatter and linter configs, `.editorconfig`, type-check settings committed; CI enforces them.
10. **A project context file** (`CLAUDE.md` or `AGENTS.md`) with the run, test and build commands, conventions, and known gotchas, kept short and updated when something bites twice.
11. **AI-written code gets the same review as mine:** read every changed line, run the tests, check for invented APIs and copied patterns that don't fit.

**Refactors and debt**
12. **Refactor only with tests around the code first;** behavior stays the same, one refactor per commit, separate from feature changes.
13. **Debt register:** each shortcut with what it costs now, what triggers paying it back (for example "before 100 users" or "before adding payments"), and a rough size.
14. **Budget for cleanup:** after each stage, one small cleanup task from the register when it touches code I'm already changing.
15. **Simplicity check before merge:** could this be done with less code, fewer files or no new dependency? If yes, do that.

**Self-review (solo)**
16. **Review my own PR with fresh eyes:** read the diff in the PR view, not the editor, ideally after a break; use the review order in SKILL.md 6.3.

## Default tool options
- Architecture and system design: `engineering:architecture`, `engineering:system-design` routes.
- Debt planning: `engineering:tech-debt` route.
- Code review: `engineering:code-review` route, or `security-reviewer` for security depth.
- Diagrams: Mermaid in markdown (renders on GitHub), ASCII for quick sketches.
- Over-engineering check: `ponytail-review` (diff) or `ponytail-audit` (repo).

## Checklist
- [ ] ADRs for every hard-to-reverse choice, with options and consequences
- [ ] Formatter, linter and type-check configs committed and enforced in CI
- [ ] Architecture diagram matches the code
- [ ] Project context file exists with commands and gotchas
- [ ] New dependencies checked against the criteria in rule 3
- [ ] Debt register updated this stage
- [ ] Self-review done on the PR view before merge

## Common mistakes
- Picking a framework because it's popular → write the needs first (SKILL.md section 4).
- A package for a one-line helper → supply-chain risk for no gain.
- Big-bang rewrites → refactor in small, tested steps.
- Mixing a refactor with a feature in one commit → hard to review and to revert.
- Debt with no trigger → it never gets paid, or gets paid at the worst time.
- Trusting AI-written code because tests passed → check for invented APIs and missing edge cases.

## Definition of done
ADRs, diagram and context file match the code; CI enforces the standards; the debt register is current; the stage's PRs passed review with the SKILL.md 6.3 output recorded.

## Per-stack notes
**TypeScript:** `strict: true`; ESLint + Prettier (or Biome); path aliases kept few; `tsc --noEmit` in CI.
**Python:** Ruff for lint and format; mypy or pyright on new code; `pyproject.toml` as the single config file.
**PHP:** PHP-CS-Fixer or Pint, PHPStan; `php-best-practices` route. A house stack's conventions win.
**Monorepos:** one lint and format config at the root; workspace tool (pnpm workspaces, uv workspaces) only when there are two or more packages.
