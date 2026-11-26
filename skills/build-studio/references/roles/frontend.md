# Frontend
tier: 1 | sources: v1 s4/s5/s11, vercel-labs react-best-practices, anthropics frontend-design | updated: 2026-11-26

## Triggers
- Any UI that runs in a browser: pages, components, forms, dashboards, landing pages.
- A redesign, a "make it look better", a CSS bug, a client-side performance issue.
- Not for: a mockup that is the deliverable itself (Design artifact type), native mobile UI (mobile role).

## Responsibilities
- Architecture: route map, component tree for the main screens, where state lives (server, URL, local), data-fetch plan.
- Plan: a token plan (below) before the first styled component.
- Build: components, forms, states, client validation that mirrors server validation.
- Verify: the main flow in a real browser at 360px and desktop widths, keyboard only, with a screenshot.
- Hands web performance, accessibility audits and SEO to the web-perf-a11y role on public pages.

## Role-specific rules
**Design**
1. **Ground it in the subject.** Name the product, the audience and the page's main job first. Distinct choices come from the subject's own world, not from a template.
2. **Plan in two passes.** Write a token plan: 4-6 named hex colors, 1-2 typefaces with roles, a layout concept (one sentence plus an ASCII wireframe, alignment stated), 2-3 principles. Then check it: if any part is what you'd produce for any similar page, revise it and say what changed. Only then code.
3. **Avoid generated-page defaults** unless the brief asks: cream + serif + terracotta; near-black + one acid accent; identical rounded cards with the same soft shadow; purple gradients; Inter everywhere; everything centered; ALL-CAPS eyebrow labels; one accented word per headline; "→" on every button; 01/02/03 markers on content that is not a sequence; fade-and-slide-up on every section; hover effects on every card.
4. **Type:** one or two clearly distinct families, a deliberate scale, body lines under about 80 characters.
5. **Restraint:** one memorable element, everything around it quiet. Remove one decoration before shipping. Motion only for one planned moment or as feedback to an action.
6. **Quality floor, always:** works at 360px, visible keyboard focus, `prefers-reduced-motion` respected, contrast passing, every state designed: default, hover, active, disabled, loading, empty, error.
7. **CSS hygiene:** tokens as CSS variables, not repeated raw values; watch selector specificity so section and component rules don't cancel each other (spacing between sections is the usual victim).
8. **Self-critique** from a screenshot: what draws the eye first, can the user finish the main task, reading order, spacing and type consistency, accessibility. Fix the top 3 before showing it.

**Build**
9. **No request waterfalls:** start independent requests together, await where the value is used, stream or suspend slow parts.
10. **Bundle size:** import directly (no barrel files), lazy-load heavy components and routes, load analytics after first render.
11. **Derive state during render** instead of syncing it in effects; interaction logic goes in event handlers.
12. **Server state in a cache library**, not copied into global state. URL holds filters, tabs and pagination so links and Back work.
13. **Forms:** labels on every field, client validation with the same schema as the server, disable submit while pending, keep input on error, show the server's field errors next to the fields.
14. **Storage:** version and keep small anything in localStorage; wrap reads in try/catch; never store tokens there (SKILL.md 6.4).
15. **Modern platform features** (dialog, popover, view transitions, container queries, autofill): check `modern-web-guidance:modern-web-guidance` before writing them.

**Copy**
16. Buttons start with a verb and name the outcome ("Save changes"). The same action keeps its name through the flow ("Publish" → "Published").
17. Errors say what happened and how to fix it, no blame. Empty states say what this is and how to start. Confirm dialogs name the action and the consequence ("Delete 3 routines? This can't be undone." / "Delete routines" / "Keep").
18. Name things the way users do, not the way the system is built. Sentence case.

## Default tool options
- Framework: React + Vite (SPA, dashboards); Next.js or Astro (SEO-heavy public pages); SvelteKit or Vue + Vite when the project or my familiarity says so. Chosen at G2.
- Styling: CSS Modules or Tailwind; component library only if it fits the token plan (`pick-ui-library` for specific widgets).
- Forms and validation: React Hook Form + zod; VeeValidate + zod on Vue; Superforms on SvelteKit.
- Server state: TanStack Query; SWR for simple cases.
- UI exploration: `prototype` for several variants; `impeccable` for critique and polish.

## Checklist
- [ ] Token plan written and checked before styling
- [ ] All 7 states designed for each interactive component
- [ ] Works at 360px and at desktop width (screenshots)
- [ ] Keyboard-only run of the main flow passes; focus is always visible
- [ ] No console errors or warnings on the main pages
- [ ] Bundle report checked; no route over the budget in the web-perf-a11y role
- [ ] Copy reviewed against rules 16-18

## Common mistakes
- Styling before the token plan → the page drifts to template defaults.
- Fetch in a child after the parent's fetch finishes → move both up and start them together.
- `useEffect` to sync derived values → compute during render.
- Only the happy state designed → empty and error states break first in real use.
- Hover-only actions → unusable on touch and keyboard.
- Client-only validation → the server must validate too (SKILL.md 6.4).

## Definition of done
Screenshots at 360px and desktop of the main screens, a keyboard-only pass of the main flow, a clean console, component tests passing, and the main flow tested end to end by the QA/SDET role's command.

## Per-stack notes
**React:** don't define components inside components; primitive values in effect dependencies; functional `setState` for stable callbacks; ternaries, not `&&` on numbers; virtualize long lists or use `content-visibility`; composition over many boolean props; no `dangerouslySetInnerHTML` with user content (sanitize with DOMPurify if unavoidable); error boundaries around route sections.
**Vite:** any `VITE_*` variable ships to the browser and is public.
**Next.js:** keep server-only code in server components or route handlers; `NEXT_PUBLIC_*` is public; check the rendering mode per route (static, dynamic, streaming).
**Vue:** `computed` for derived state, not watchers; `v-html` only with sanitized content.
**Svelte/SvelteKit:** derived stores or `$derived` for computed state; `{@html}` only with sanitized content; load data in `+page.server` when it needs secrets.
**Plain HTML/PHP views:** escape every output with `htmlspecialchars`; a house stack's layout rules win.
