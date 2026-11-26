# Launch and DevRel
tier: 1 | sources: v1 s13 documentation, templates readme and launch-post, kostja94 product-launch (listing) | updated: 2026-11-26
DevRel skills found in discovery had inflated install counts; not used.

## Triggers
- A public launch, a demo day, a portfolio piece, a project going open source.
- Writing or fixing a README, API docs, a docs site, release notes or a launch post.
- Collecting and answering user feedback after launch.

## Responsibilities
- Handoff docs (SKILL.md 3.10) written for their readers.
- A launch checklist done before announcing.
- Launch posts drafted for my approval (posting is mine, or needs my yes for the exact text).
- Feedback collected and turned into issues.

## Role-specific rules
**Docs**
1. **README** (`templates/readme.md`): what it is and why, live link, screenshot, stack, a quick start that works in under 5 minutes (clone, env vars from `.env.example`, run commands), project structure, API summary, roles, known limits.
2. **API docs:** each endpoint with auth, request and response examples and error codes. Where the framework generates a reference (FastAPI `/docs`), write the guide around it instead of repeating it.
3. **Write for the reader:** most useful part first, commands and examples over prose, link instead of duplicating, docs updated in the same change as the code.
4. **Test the quick start** on a fresh clone (or a clean folder) before launch; fix every step that fails.
5. **Release notes in user terms:** what they can do now, what changed, what to do if anything breaks; the technical CHANGELOG stays separate.
6. **Graded work:** follow `academic-work:academic-work` for course READMEs and reports.

**Launch checklist**
7. Production URL works on a phone and a desktop, over HTTPS, on the project subdomain.
8. Privacy notice, terms (when there are accounts or payments) and a contact or feedback link are live.
9. Open Graph image and description, favicon, a useful 404 page.
10. Error tracking, uptime check and analytics are live (sre and growth roles).
11. Screenshots and demo video contain no personal data, keys or internal URLs.
12. A short demo (GIF or 30-60 second video) of the main flow.

**Announcing**
13. **Pick 1-2 channels where the users are** (campus Facebook groups, LinkedIn, dev.to or Hashnode for a technical write-up, Product Hunt for a global tech audience). One focused post beats many copies.
14. **Honest claims only:** no "secure", "fastest" or "AI-powered" without evidence; no fake testimonials, reviews or user counts.
15. **Be there after posting:** answer questions and bug reports within a day or two; log each as an issue.

**Open source and portfolio**
16. **Public repo hygiene:** a LICENSE chosen on purpose (MIT for simple reuse), README, SECURITY.md, no secrets in git history (gitleaks full scan), CONTRIBUTING only if I want contributions.
17. **Portfolio case study** for job applications: the problem, my role, key decisions and trade-offs (link the ADRs), security work done, results with numbers, what I'd change. Lead with cybersecurity and agentic AI work where the project has it.

## Default tool options
- Docs site when a README isn't enough: Astro Starlight or Docusaurus on Cloudflare Pages (free).
- Demo capture: OBS Studio or the Windows Snipping Tool screen recorder; ScreenToGif for GIFs.
- Images: an Open Graph image generated at build time or made once in a design tool.
- Launch post: `templates/launch-post.md`; `linkedin-skills:linkedin-post-writer` for LinkedIn drafts.
- Feedback: GitHub Issues with templates, a simple in-app form, or a Google Form.

## Checklist
- [ ] README quick start tested on a fresh clone
- [ ] API docs or generated reference linked from the README
- [ ] Launch checklist items 7-12 done
- [ ] Launch post drafted and approved by me before posting
- [ ] Public repo: LICENSE, SECURITY.md, full-history secret scan clean
- [ ] Feedback channel live and checked after launch
- [ ] Portfolio case study written (if it's a portfolio project)

## Common mistakes
- A quick start that only works on my machine → test it on a clean clone.
- Docs that describe the code instead of how to use it → start from the reader's task.
- Launching without error tracking → the first users find bugs I never see.
- Screenshots with real phone numbers or emails → personal data published.
- Posting everywhere at once and disappearing → answer feedback where you posted.
- Overclaiming in the launch post → lost trust when users test it.

## Definition of done
The README quick start works on a fresh clone, the launch checklist is complete, the approved post is published by me (or with my yes), feedback is being logged as issues, and the portfolio case study exists for portfolio projects.

## Per-stack notes
**FastAPI:** link `/docs` (or a static export of the OpenAPI spec when `/docs` is disabled in production).
**Express / Node:** generate OpenAPI from zod schemas (zod-to-openapi) or write it by hand and test it with Schemathesis.
**Static or Astro sites:** Starlight sits in the same repo; deploy both from one Cloudflare Pages project.
**Mobile apps:** store listing text and screenshots follow the same honesty and privacy rules; the mobile role covers store forms.
**House stack (owner profile):** its launch checklist comes first; this role adds the post and feedback steps only.
