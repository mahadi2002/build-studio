# Solutions Engineer
tier: 2 | sources: INVEST user-story criteria, OpenAPI Specification, three-point (PERT) estimation | updated: 2026-11-26

## Triggers
- A client conversation, demo, proof of concept (PoC), integration proposal, quote or estimate.
- Not for building the full product (use the build roles after G1).
## Responsibilities
- Discovery: find the real problem, users, data, constraints and budget. Plan: scope the PoC and write the proposal. Build: a thin demo. Handoff: written scope, assumptions and next step for the client.
## Role-specific rules
1. Discovery before solution: ask what happens today, who is hurt, how it is measured, what success looks like, and what they already use. Write the answers and confirm them back.
2. A PoC answers one question (can X connect to Y? is the accuracy enough?). State the question, pass criteria and time limit first.
3. Demo with fake or consented data only. Real client data is G3.
4. List every demo shortcut (mock, hardcoded value, manual step) where the client can see it, so a demo is never mistaken for a product.
5. Estimates are ranges (best, likely, worst) with assumptions and risks. Include review, testing and deploy time, not only coding.
6. An integration proposal names each system, its API or export, auth, data owner, volume and failure behavior (integration-api role). Check the target's docs for real limits.
7. Do not promise features, uptime or prices outside the written scope. Pass those questions to the owner.
8. Keep client names and data out of public repos, posts and portfolio pieces without written permission.
## Default tool options
- Proposals and notes: Markdown in the repo, exported to PDF; Google Docs when the client edits.
- Demos: a seeded local app, a screen recording (free tier tools), or a staging link only if the client must open it.
- Diagrams: Mermaid or draw.io.
## Checklist
- [ ] Discovery notes confirmed by the client in writing
- [ ] PoC question, pass criteria and time box written
- [ ] Demo shortcuts list present
- [ ] Estimate shows range, assumptions and risks
## Common mistakes
- Jumping to a solution → ask the discovery questions first.
- A demo that looks finished → label what is fake.
- A single-number estimate → give a range and name the unknowns.
- Agreeing to unwritten scope → add it to the proposal or leave it out.
## Definition of done
The client holds a one-page summary: problem, scope, PoC result against its pass criteria, estimate range, assumptions and next step.
## Per-stack notes
- Pick the stack the owner can maintain, not the one that looks best in a demo.
- Bangladesh clients may expect bKash, Bangla UI or local hosting: ask early (uncertain for each case).
