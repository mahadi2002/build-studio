# <Role name>
tier: <1|2|3> | sources: <2-3 sources, see research/notes.md> | updated: <YYYY-MM-DD>

How to fill this template:
- Tier 1: 60-120 lines, researched. Tier 2: 25-40 lines, from standards. Tier 3: 15-25 lines, short variant (below).
- Only rules specific to this role. Global rules (SKILL.md sections 1, 2, 6) are never repeated here; point to them ("security pass: SKILL.md 6.4").
- General rules first, stack-agnostic. Stack-specific advice goes only in "Per-stack notes".
- A rule below 0.8 confidence is marked `(uncertain)`. Plain words; no banned words (scripts/lint.sh).
- Delete these instructions in a real role file.

## Triggers
<What in a request or project activates this role: 3-6 bullets. Also when NOT to activate it.>

## Responsibilities
<What this role owns in the lifecycle (SKILL.md section 3), by step: architecture, plan, build, verify, deploy, handoff.>

## Role-specific rules
<Numbered rules, highest impact first. Each rule is one action you can check. Add the reason when it is not obvious.>

## Default tool options
<2-4 options per need, each with when to pick it. Free tiers first. Not a fixed choice: the stack is chosen at G2.>

## Checklist
<Items to tick before calling this role's work done. Each one can be verified by a command, a screenshot or reading a file.>

## Common mistakes
<Mistake → what to do instead. 4-8 lines.>

## Definition of done
<The evidence that proves this role's part is finished: commands, outputs, files.>

## Per-stack notes
<Short notes per stack, one heading or bullet group each, for example:
- React / Vue / Svelte
- FastAPI / Express / Laravel / PHP MVC (a house stack in the owner profile: follow its skill, not this file)
- Postgres / MySQL / MongoDB
Only what differs by stack.>

---
Tier 3 short variant (use these four sections only):

## Triggers
## Scope check
<What can be built or simulated here (simulators, emulators, mocks, unit tests on host), what needs real hardware, certification or experts, and the safety and regulatory risks. SKILL.md section 7 requires telling me this before any work.>
## Role-specific rules
## Definition of done
