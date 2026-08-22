# Feature Pipeline

A repeatable path from idea to implemented code, as five Claude Code skills. Each stage reads the
previous stage's output and writes one file into `docs/features/<slug>/`, where `<slug>` is the
kebab-case feature title (e.g. `august-potm-cards`).

| # | Skill | Reads | Writes |
|---|---|---|---|
| 1 | `/define-feature` | a raw idea/request | `docs/features/<slug>/feature.md` |
| 2 | `/write-stories` | `feature.md` | `docs/features/<slug>/stories.md` |
| 3 | `/tech-design` | `feature.md`, `stories.md` | `docs/features/<slug>/tech-design.md` |
| 4 | `/impl-plan` | `tech-design.md` | `docs/features/<slug>/plan.md` |
| 5 | `/implement-feature` | `plan.md` | edits to `fpo26.html` / `index.html` |

`/feature-pipeline` runs stages 1–3 end to end for a new idea and then stops for your review of
`tech-design.md` before continuing — that's the review checkpoint where architecture decisions
(especially anything touching multiplayer) should get caught before code gets written.

## When to use which entry point

- **New idea, unsure of scope:** start with `/feature-pipeline`.
- **You already know exactly what to build and it's small:** skip straight to `/impl-plan` or just
  ask normally — the pipeline is for anything with real design surface, not typo fixes.
- **A story needs backend/realtime capability:** `/tech-design` will route it through
  `docs/architecture/multiplayer-roadmap.md` and the `multiplayer-architect` agent instead of
  inventing a one-off backend design.
- **A feature adds any networked endpoint:** `/tech-design` must reference
  `docs/architecture/security-baseline.md`, and `/security-review` is a required gate before
  `/implement-feature` runs.

## Conventions

- One folder per feature under `docs/features/`, named by kebab-case slug of the feature title.
- Files within a feature folder are always named `feature.md`, `stories.md`, `tech-design.md`,
  `plan.md` — never renamed, so later stages can find them predictably.
- `/implement-feature` delegates the actual code edits to the `game-implementer` agent, which
  enforces the game's non-negotiable rules (see `PROJECT_CONTEXT.md` §4/§21) and the mandatory
  syntax-check + `index.html` sync workflow.
- Nothing in this pipeline commits to git automatically — commits happen only when you ask, same as
  the rest of this project's workflow.
