---
name: impl-plan
description: Turn tech-design.md into an ordered, concrete implementation task list for the FPO27 game, saved to docs/features/<slug>/plan.md — always including the mandatory node --check syntax check and index.html sync steps. Use after /tech-design is approved, before /implement-feature — stage 4 of the feature pipeline (see docs/PIPELINE.md).
---

# Implementation Plan

Turn a tech design into an ordered task list. This is stage 4 of the pipeline described in
`docs/PIPELINE.md`.

## Steps

1. Locate and read `docs/features/<slug>/tech-design.md` (and `feature.md`/`stories.md` for context
   if needed).
2. Write `docs/features/<slug>/plan.md` as an ordered list of concrete tasks, each naming the actual
   file and function/section touched (from the tech design's "Functions touched or added" section).
   Order tasks so earlier ones unblock later ones (e.g. data additions before UI wiring that reads
   them).
3. **Always include, as explicit final steps**, per `PROJECT_CONTEXT.md` §3:
   - Extract and syntax-check the script block:
     ```bash
     node -e "require('fs').writeFileSync('/tmp/fpo26_check.js', require('fs').readFileSync('fpo26.html','utf8').match(/<script>([\s\S]*?)<\/script>/)[1])"
     node --check /tmp/fpo26_check.js
     ```
   - Sync `fpo26.html` → `index.html` (they must stay byte-identical).
   - If the design has a "Backend/multiplayer scope" or "Security considerations" section, include a
     step to run `/security-review` before the syncing/finalizing steps.
4. Format:

   ```markdown
   # Implementation Plan: <Feature Title>

   1. <task> — file: <path>, touches: <function/section>
   2. ...
   N. Syntax-check the extracted <script> block (see command above)
   N+1. Sync fpo26.html to index.html
   ```

5. Tell the user the file path. Do not auto-run `/implement-feature` unless invoked via
   `/feature-pipeline` and the user has already confirmed the tech design.
