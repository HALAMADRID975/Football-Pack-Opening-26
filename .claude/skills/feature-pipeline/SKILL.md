---
name: feature-pipeline
description: Run the full FPO27 feature pipeline for a new idea — feature definition, user stories, and tech design (stages 1-3) — then stop for user review of the tech design before implementation planning and building. Use when the user has a new idea and wants it taken from scratch through design in one go. See docs/PIPELINE.md.
---

# Feature Pipeline (orchestrator)

Runs stages 1–3 of the pipeline in `docs/PIPELINE.md` for a new idea, then stops.

## Steps

1. Run `/define-feature` for the idea. If it needed clarifying questions, let those resolve first.
2. Run `/write-stories` against the resulting `feature.md`.
3. Run `/tech-design` against the resulting `stories.md`.
4. **Stop here.** Show the user the tech design summary and ask them to confirm before continuing —
   this is the architecture checkpoint, especially important for anything routed through
   `docs/architecture/multiplayer-roadmap.md`. Do not run `/impl-plan` or `/implement-feature`
   automatically.
5. Only after the user explicitly confirms the tech design, run `/impl-plan` and then, after showing
   the plan, `/implement-feature` if they confirm that too. Each of these is a separate checkpoint —
   don't chain past a stage the user hasn't actually approved.
