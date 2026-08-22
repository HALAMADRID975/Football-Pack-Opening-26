---
name: tech-design
description: Turn stories.md into a technical design and architecture doc for the FPO27 game, saved to docs/features/<slug>/tech-design.md — grounded in the existing single-file codebase conventions (PROJECT_CONTEXT.md), and routed through docs/architecture/multiplayer-roadmap.md for anything needing backend/realtime capability. Use after /write-stories, before implementation planning — stage 3 of the feature pipeline (see docs/PIPELINE.md).
---

# Tech Design

Turn stories into a concrete technical design. This is stage 3 of the pipeline described in
`docs/PIPELINE.md` — the main architectural checkpoint before any code gets written.

## Steps

1. Locate and read `docs/features/<slug>/feature.md` and `stories.md`.
2. Read `PROJECT_CONTEXT.md` (all of it, if not already fresh this session) — the design must fit
   existing conventions: core arrays (`P[]`, `PKS[]`, `CT{}`, `RC{}`, `SPEC[]`, `GAME_NEWS[]`), key
   functions (`buildCard`, `mkPackSVG`, `doOpen`/`pickCard`, `renderMarket`, `showScreen`, `goTab`,
   `saveNow`/`loadSave`, `applySeasonTheme`, `getSeasonNum`, `getCurrentTheme`), and the "Critical
   Technical Rules" (§4) and "Known Issues" (§21) sections. Reuse existing functions/data structures
   over inventing parallel ones.
3. **Decide if this feature needs anything beyond the current client-only, `localStorage`-only game:**
   - If every story can be satisfied entirely within the existing single-file client, design it that
     way — don't introduce a backend a feature doesn't need.
   - If any story genuinely needs a backend, shared state across players, or realtime updates: read
     `docs/architecture/multiplayer-roadmap.md`, note which phase it belongs to, and use the
     `multiplayer-architect` agent to produce that part of the design. Do not pick a different
     stack, language, or hosting provider than what the roadmap specifies — if the roadmap seems
     wrong for this feature, say so explicitly and propose amending the roadmap rather than
     diverging silently.
   - If the feature adds any networked endpoint, also read `docs/architecture/security-baseline.md`
     and note in the design that `/security-review` is a required gate before implementation.
4. Write `docs/features/<slug>/tech-design.md`:

   ```markdown
   # Tech Design: <Feature Title>

   ## Summary
   One paragraph — what's being built and the overall approach.

   ## Data model changes
   New/changed entries in P[], PKS[], CT{}, or other core arrays. Show the actual shape.

   ## UI/UX flow
   Which screens/tabs are touched, what's new, referencing existing showScreen/goTab patterns.

   ## Functions touched or added
   Existing functions to modify (with file:line if known) and any new functions, with signatures.

   ## Backend/multiplayer scope (omit this section entirely if not applicable)
   Which roadmap phase this belongs to, what the multiplayer-architect agent designed, links to any
   endpoints/message types.

   ## Security considerations (omit if purely client-side with no new networked surface)
   Reference docs/architecture/security-baseline.md; note the required /security-review gate.

   ## Risks / open questions
   Anything genuinely uncertain that implementation should watch for.
   ```

5. Tell the user the file path and flag anything you routed to the multiplayer roadmap or security
   baseline. This is the natural point for the user to review before implementation — don't
   auto-continue to `/impl-plan` unless invoked via `/feature-pipeline`, and even then stop here for
   confirmation.
