---
name: implement-feature
description: Execute a plan.md for the FPO27 game by delegating to the game-implementer agent — edits fpo26.html, runs the syntax check, syncs index.html, and reports what changed. Use after an implementation plan exists and is ready to build — stage 5 (final) of the feature pipeline (see docs/PIPELINE.md).
---

# Implement Feature

Execute an implementation plan. This is stage 5 of the pipeline described in `docs/PIPELINE.md`.

## Steps

1. Locate and read `docs/features/<slug>/plan.md`. If it doesn't exist, tell the user to run
   `/impl-plan` first rather than improvising a plan here.
2. If `tech-design.md` for this feature has a "Backend/multiplayer scope" or "Security
   considerations" section and no evidence a `/security-review` has been run yet, run it now before
   proceeding, per `docs/architecture/security-baseline.md`.
3. Delegate the actual implementation to the `game-implementer` agent, giving it:
   - The full contents (or path) of `plan.md` and `tech-design.md`.
   - An explicit instruction to follow the plan's tasks in order, then run the syntax check and
     `index.html` sync as the final steps, and report exactly what it changed (files, functions,
     lines).
4. When the agent reports back, relay a concise summary to the user: what was implemented, that the
   syntax check passed, and that `index.html` is in sync. Do not commit — commits happen only when
   the user explicitly asks, consistent with this project's workflow.
5. If the agent hit a blocker (ambiguous plan step, conflicting existing code), surface that to the
   user rather than having the agent guess past it.
