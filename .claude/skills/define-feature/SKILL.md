---
name: define-feature
description: Turn a raw feature idea or request for the FPO27 game into a written feature definition (problem, goals, non-goals, success criteria, priority) saved to docs/features/<slug>/feature.md. Use when the user proposes a new feature, event, pack, or system and wants it properly scoped before stories/design/implementation — stage 1 of the feature pipeline (see docs/PIPELINE.md).
---

# Define Feature

Turn a raw idea into a scoped feature definition. This is stage 1 of the pipeline described in
`docs/PIPELINE.md`.

## Steps

1. Read `PROJECT_CONTEXT.md` if you haven't already this session — it has the game's current season,
   pending work list (§16), and conventions. Ground the feature in that reality (e.g. don't propose
   something that conflicts with an already-scheduled event date).
2. If the idea is vague (no clear player-facing outcome, or multiple very different interpretations),
   ask 1-3 clarifying questions with `AskUserQuestion` before writing anything. Don't guess at scope
   for anything non-trivial.
3. Derive a kebab-case slug from the feature title (e.g. "August POTM Cards" → `august-potm-cards`).
   Create `docs/features/<slug>/` if it doesn't exist.
4. Write `docs/features/<slug>/feature.md` using this structure:

   ```markdown
   # <Feature Title>

   ## Problem
   What gap or opportunity this addresses, for players specifically (not "the codebase needs X").

   ## Goals
   Bullet list — what this feature must achieve.

   ## Non-Goals
   Bullet list — what's explicitly out of scope, to prevent scope creep in later stages.

   ## Success Criteria
   How you'd know this worked — concrete and player-observable where possible.

   ## Priority
   High / Medium / Low, with one line of reasoning. Cross-reference PROJECT_CONTEXT.md §16 if this
   is already a listed pending item.

   ## Context
   Relevant season/event/date constraints from PROJECT_CONTEXT.md, and anything else stage 2/3 needs
   to know that isn't obvious from the title.
   ```

5. Tell the user the file path and give a one-paragraph summary. Do not proceed to `/write-stories`
   automatically unless invoked via `/feature-pipeline`.
