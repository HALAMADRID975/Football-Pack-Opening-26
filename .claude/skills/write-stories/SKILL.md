---
name: write-stories
description: Turn a feature.md definition into concrete user stories with acceptance criteria for the FPO27 game, saved to docs/features/<slug>/stories.md. Use after /define-feature, when a feature's goals are agreed and need breaking into implementable, testable pieces — stage 2 of the feature pipeline (see docs/PIPELINE.md).
---

# Write Stories

Turn a feature definition into user stories. This is stage 2 of the pipeline described in
`docs/PIPELINE.md`.

## Steps

1. Locate `docs/features/<slug>/feature.md` (ask the user for the slug/feature name if ambiguous —
   don't guess which feature folder they mean).
2. Read it fully. If Goals/Non-Goals are unclear or contradictory, ask before proceeding rather than
   inventing scope.
3. Write `docs/features/<slug>/stories.md`. Each story:

   ```markdown
   ### Story N: <short title>
   As a player, I want <capability> so that <benefit>.

   **Priority:** High / Medium / Low
   **Acceptance Criteria:**
   - Given <context>, when <action>, then <outcome>.
   - (one or more Given/When/Then lines — cover the happy path and at least one edge case)
   ```

4. Order stories by priority, highest first. Keep each story small enough to be one coherent
   implementation unit — split anything that bundles two unrelated changes.
5. Every story must trace back to a Goal in `feature.md`; flag (don't silently drop) any Goal that
   didn't get a story, and flag any story that isn't covered by Non-Goals as still in scope.
6. Tell the user the file path and list the story titles. Do not proceed to `/tech-design`
   automatically unless invoked via `/feature-pipeline`.
