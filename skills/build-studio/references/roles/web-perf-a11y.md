# Web performance and accessibility
tier: 1 | sources: v1 s10, addyosmani/web-quality-skills, WCAG 2.2 | updated: 2026-11-26

## Triggers
- Any public page, a launch, a landing page, an SEO goal, a slow page report.
- An accessibility audit, a WCAG claim, a complaint from a keyboard or screen reader user.
- Not for: backend latency (backend, load-testing roles).

## Responsibilities
- Set budgets at G2 and check them in verify.
- Measure before and after any performance change.
- Run the accessibility pass on every UI change and a full audit before launch (`a11y-audit` route).
- SEO basics on public pages.

## Role-specific rules
**Measure first**
1. From source alone, name likely causes but don't claim a metric fails without a Lighthouse run, PageSpeed Insights or a browser trace. Field data (CrUX, real-user metrics) beats lab data when it exists.
2. **Core Web Vitals at p75:** good is LCP ≤ 2.5 s, INP ≤ 200 ms, CLS ≤ 0.1; poor is LCP > 4 s, INP > 500 ms, CLS > 0.25.

**Fix by metric**
3. **LCP:** hero image in the initial HTML, `fetchpriority="high"`, not lazy-loaded, WebP or AVIF at the displayed size; preload only what a trace shows is discovered late; server response under about 800 ms.
4. **INP:** break up long tasks, keep handlers light, move heavy work off the main thread or after paint; check third-party scripts first.
5. **CLS:** width/height or aspect-ratio on every image and embed; reserve space for late content; `font-display` with matched fallback metrics.

**Budgets and caching**
6. **Starting budgets** (adjust per project): JS < 300 KB compressed, CSS < 100 KB, above-fold images < 500 KB, fonts < 100 KB, page < 1.5 MB. Third-party scripts are a separate line with an owner and a reason.
7. Hashed static assets get `Cache-Control: public, max-age=31536000, immutable`; HTML gets a short or no cache.

**Accessibility (WCAG 2.2 AA)**
8. Contrast ≥ 4.5:1 for normal text, ≥ 3:1 for large text and UI components.
9. Everything works by keyboard; logical focus order; visible focus; no focus traps (modals return focus on close; prefer `<dialog>`).
10. **Focus not obscured (2.4.11):** a sticky header or cookie banner must not cover the focused element.
11. Labels on every input; errors say what is wrong and how to fix it, linked with `aria-describedby`.
12. Alt text on meaningful images, `alt=""` on decorative ones; landmarks (`header`, `nav`, `main`, `footer`); one `h1`; no skipped heading levels.
13. **Target size (2.5.8):** at least 24×24 CSS px for interactive targets (inline text links excepted); aim for 44×44 on touch-first screens.
14. **Dragging (2.5.7):** every drag action has a single-pointer alternative (buttons, a menu).
15. **Consistent help (3.2.6):** help or contact links sit in the same place on every page.
16. **Redundant entry (3.3.7):** don't ask for the same information twice in one flow; prefill or offer to reuse it.
17. **Accessible authentication (3.3.8):** no puzzle or memory test to log in; allow paste and password managers; offer a magic link or OTP as an option.
18. Layout holds at 200% zoom and 320 px width; no auto-playing media without controls; `prefers-reduced-motion` respected.
19. Automated tools catch only part. Also tab through the page, and check with a screen reader (NVDA on Windows) when it matters.

**SEO basics (public pages)**
20. Unique `<title>` (about 50-60 characters) and meta description per page; canonical URL; `robots.txt` that doesn't block CSS/JS; XML sitemap; Open Graph tags; JSON-LD where it fits; important content rendered in HTML (prerender or SSR for SPA landing pages). Block AI crawlers only by deliberate choice, per bot.

## Default tool options
- Lab: Lighthouse in Chrome DevTools, PageSpeed Insights, WebPageTest; `cloudflare:web-perf` for Cloudflare-hosted sites.
- Field: CrUX via PageSpeed Insights; the `web-vitals` library to the analytics tool.
- Bundle: `vite-bundle-visualizer`, `source-map-explorer`, Next.js bundle analyzer.
- Accessibility: axe DevTools, Lighthouse accessibility, `@axe-core/playwright` in CI; `a11y-audit` for a full audit; NVDA for screen reader checks.

## Checklist
- [ ] Lighthouse or PSI run saved for the main public pages (mobile profile)
- [ ] CWV at or under "good" or a written reason and plan
- [ ] Budgets checked against the build output
- [ ] axe in CI shows no serious or critical issues
- [ ] Keyboard pass and 200% zoom pass done
- [ ] Title, description, canonical, sitemap, robots checked on public pages

## Common mistakes
- Lazy-loading the hero image → LCP gets worse.
- Preloading everything → bandwidth fights; preload only what the trace shows late.
- Treating a 100 Lighthouse score as accessible → manual keyboard and screen reader checks still needed.
- `aria-label` on everything → a native element with visible text is better.
- Removing focus outlines for looks → style them instead.
- Using 44×44 as a WCAG minimum in reports → the AA minimum is 24×24; 44 is a recommendation.

## Definition of done
Saved reports (Lighthouse/PSI) for the main public pages with CWV and budget results, axe CI job green, written notes from the keyboard and zoom passes, and SEO tags checked on each public page.

## Per-stack notes
**React/Vite SPA:** prerender landing pages (vite-plugin-ssr/Vike, or a static marketing page) for SEO; route-level code splitting.
**Next.js:** `next/image` with `priority` on the LCP image; `next/font` for fallback metrics; check that client components don't bloat the bundle.
**Astro:** ships zero JS by default; hydrate islands only where needed.
**Vercel:** Speed Insights gives field data on Hobby with limits (uncertain: check the current quota).
**Cloudflare:** Polish and image resizing depend on the plan (uncertain on the free plan); Auto Minify is deprecated, so minify in the build.
**PHP sites:** keep CSS and JS hashed and cached the same way.
