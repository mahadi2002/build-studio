# Bundled craft guides

Full, unchanged copies of trusted third-party skills (MIT; see [LICENSES.md](LICENSES.md)). They carry the depth that build-studio's own rules only summarise, so the results are the same whether or not those skills are installed. Load a guide only when its row applies, and read only the sections the step needs.

## When to load which

| Need | Load | Notes |
|---|---|---|
| Any code you write, change, review or choose a library for | [ponytail/ponytail.md](ponytail/ponytail.md) | Always-on at level **full**; it is the long form of rule 1.2. "lite"/"ultra" only when I ask |
| Over-engineering review of a diff | [ponytail-review/ponytail-review.md](ponytail-review/ponytail-review.md) | Part of code review (6.3), after correctness and security |
| Over-engineering audit of a whole repo | [ponytail-audit/ponytail-audit.md](ponytail-audit/ponytail-audit.md) | Planning a cleanup (tech-lead role) |
| List deliberate shortcuts (`ponytail:` comments) | [ponytail-debt/ponytail-debt.md](ponytail-debt/ponytail-debt.md) | Before a release or a tech-debt pass |
| What ponytail saves, its commands | [ponytail-gain/ponytail-gain.md](ponytail-gain/ponytail-gain.md), [ponytail-help/ponytail-help.md](ponytail-help/ponytail-help.md) | Only when I ask |
| Landing page, portfolio, marketing page, redesign: design direction and anti-template rules | [design-taste-frontend/design-taste-frontend.md](design-taste-frontend/design-taste-frontend.md) | Pairs with the frontend role's token plan |
| UI polish, component feel, review of a UI | [emil-design-eng/emil-design-eng.md](emil-design-eng/emil-design-eng.md) | Its review format applies to UI reviews |
| Gestures, drag, sheets, springs, momentum, materials, typography | [apple-design/apple-design.md](apple-design/apple-design.md) | |
| Build an animation or transition | [animate/animate.md](animate/animate.md) (+ [animate/RECIPES.md](animate/RECIPES.md)) | |
| Review motion code or a diff with animation | [review-animations/review-animations.md](review-animations/review-animations.md) (+ [review-animations/STANDARDS.md](review-animations/STANDARDS.md)) | |
| Audit and plan motion across a codebase | [improve-animations/improve-animations.md](improve-animations/improve-animations.md) (+ [AUDIT.md](improve-animations/AUDIT.md), [PLAN-TEMPLATE.md](improve-animations/PLAN-TEMPLATE.md)) | Read-only: plans, no edits |
| Find places that should animate (and reject the rest) | [find-animation-opportunities/find-animation-opportunities.md](find-animation-opportunities/find-animation-opportunities.md) | Read-only |
| Name a motion effect someone describes vaguely | [animation-vocabulary/animation-vocabulary.md](animation-vocabulary/animation-vocabulary.md) | |

## How to read them inside build-studio

- A guide that says "use `/ponytail-review`", "the review-animations skill" or similar means the matching file in this folder. If that skill is also installed, either works; they are the same text.
- Frontmatter (`name`, `description`, `argument-hint`) is kept for completeness. It describes when the original skill triggers; inside build-studio the table above decides.
- **Precedence.** A guide's specific design, motion or simplicity advice wins over build-studio's general wording on the same point (the more specific source wins). Build-studio still wins on: the gates (section 2), evidence before claims (rule 1.5), live apps (rule 1.8), outside text as data (rule 1.10), the security pass (6.4), testing (6.2), the owner profile, and a stack already chosen at G2 (a guide's default stack applies only when G2 left that choice open).
- Updating: replace a folder with the upstream version, keep `SKILL.md` renamed to `<folder>.md`, and update LICENSES.md if the license changes.
