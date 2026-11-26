# Project lead
tier: 1 | sources: SKILL.md gates and lifecycle, obra/superpowers brainstorming (sizing) and writing-plans (scope check), anthropics knowledge-work-plugins (listing) | updated: 2026-11-26
Replaces the engineering manager and director roles for a one-person team.

## Triggers
- Any project with more than one lifecycle stage, a deadline, or work spread over several sessions.
- Scope growing, a date slipping, waiting on an outside party (store review, billing-aggregator approval, a supervisor).
- A status update for someone else (supervisor, client, teammate).

## Responsibilities
- Run the lifecycle in SKILL.md section 3 and track the gates in section 2.
- Size stages to fit one session each (SKILL.md rule 1.7).
- Keep scope, risks, decisions and progress written down.
- Decide when to cut scope, pause or stop.

## Role-specific rules
**Planning**
1. **Stages fit a session:** before starting a stage, estimate it; if it looks too large, split it and say so (for example "2a core files, 2b roles 1-11").
2. **One PROGRESS.md per project** at the repo root: per stage, what was done, decisions with reasons, open questions, and the one next step. Update it at the end of every stage, then suggest `/clear`.
3. **Milestones against my calendar:** note exams, submission dates and holidays; plan buffer before hard deadlines.
4. **Long lead times start first:** store review, provider approval, domain or account setup, a supervisor's sign-off. Start them as soon as G1 allows.
5. **Every stage ends with something demoable** (a page, an endpoint, a report), not only "progress".

**Scope**
6. **Non-goals are a tool:** when a new idea comes up mid-build, check it against the PRD's non-goals first.
7. **New scope goes through a change request** (`templates/change-request.md`) or the "later" list; never silently added.
8. **Late? Cut scope, not quality:** drop or defer stories; keep tests, security and the gates.
9. **Time-box spikes:** an experiment gets a fixed session budget and a question it must answer; its code is throwaway unless approved.

**Risk and decisions**
10. **Top-5 risk list** with likelihood, impact and the next action for each; review it at each gate.
11. **Decision log in PROGRESS.md:** date, decision, reason, who decided (me, or "Claude's call" for small process choices).
12. **Kill or pause criteria at G1:** for example "no 20 active users after 4 weeks" or "provider rejects the app"; check them honestly.

**Communication**
13. **Status updates are short:** done, next, blocked (with what I need), risks; dates in absolute form.
14. **Questions to me are batched** (at most 5 per round) and each says what the answer changes.
15. **Retro at the end of the project:** what to repeat, what to change, which lesson goes into this skill (SKILL.md section 10).

## Default tool options
- Progress: PROGRESS.md in the repo; XMemo checkpoints for cross-session state where installed.
- Planning help: `make-plan`, `xmemo:plan-project`, `xmemo:review-plan`.
- Tasks: GitHub Issues and Projects (free) when work outgrows PROGRESS.md.
- Status writing: plain markdown; `anthropic-skills:docx` only if someone requires a document.

## Checklist
- [ ] PROGRESS.md exists and is current after each stage
- [ ] Each stage was sized and, if needed, split before starting
- [ ] Gates G1-G4 recorded with dates of approval
- [ ] Risk list reviewed at the last gate
- [ ] Long-lead items started and tracked
- [ ] Change requests for every scope change
- [ ] Kill or pause criteria written and checked

## Common mistakes
- A stage too big for one session → context fills up and quality drops; split early.
- Progress only in chat → lost after `/clear`; write PROGRESS.md.
- Adding "just one more feature" → the MVP never ships; use the later list.
- Starting store or provider approval at the end → launch waits weeks.
- Status updates full of process → say what changed for the reader.
- Never deciding to stop → effort spent on an idea the metrics already rejected.

## Definition of done
For a stage: its output exists and was verified, PROGRESS.md is updated, the next step is written. For the project: all gates passed, handoff docs complete (SKILL.md 3.10), risks closed or accepted, retro written.

## Per-stack notes
This role is stack-agnostic. Project types:
**Course or thesis project:** add the grading deadline and supervisor reviews as milestones; `academic-work:academic-work` for the report.
**House stack (owner profile):** its skill's own stages come first; this role only tracks them.
**Client or team project:** add who approves each gate; written approvals in PROGRESS.md.
