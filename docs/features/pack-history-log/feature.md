# Pack History Log

## Problem
Players who open packs have no way to look back at what they've opened — once the pull animation
ends, the result is only reflected indirectly (in the collection). There's no record of *which packs*
were opened, *when*, or *what came out of each one*. This is listed as a pending "Nice to Have" in
`PROJECT_CONTEXT.md` §16 ("Pack history log — show every pack ever opened").

## Goals
- Record every pack opened (pack name, cards pulled, timestamp) to `localStorage`.
- Let the player view that history from Settings, most recent first.
- Work entirely client-side, no backend — this is a pure single-player, local-data feature.

## Non-Goals
- No cross-device sync (that's Phase 1 of `docs/architecture/multiplayer-roadmap.md`, not this).
- No editing/deleting individual history entries (a "clear all" is enough, matching the existing
  notifications pattern).
- No change to pack-opening odds, animation, or economy — purely additive logging + a viewer.
- Unbounded history — cap it like the existing `fpo26_reward_log` pattern to avoid bloating
  `localStorage`.

## Success Criteria
- Opening a pack (animated or skip-animation path) appends one entry with pack name, each card's
  name/rarity/rating, and a timestamp.
- A "📜 Pack History" control in Settings opens a modal listing entries most-recent-first with a
  "CLEAR ALL" action.
- No regression to existing pack-opening flow or `node --check` syntax.

## Priority
Low — matches its "Nice to Have" listing in `PROJECT_CONTEXT.md` §16. Chosen for this pipeline dry
run specifically because it needs no external/real-world data (unlike, e.g., August POTM cards, whose
real winners couldn't be reliably confirmed via search at time of writing) and no design ambiguity.

## Context
Existing analogous pattern already in the codebase: `logReward()`/`getRewardLog()`
(`fpo26.html` ~line 6416) log to a capped `fpo26_reward_log` array. `showNotifications()`
(~line 12744) is the closest existing viewer UI — a `.modal-ov` overlay with a scrollable list and a
"CLEAR ALL" button — and is the pattern this feature should reuse rather than building a new modal
style. Pack results are produced in `doOpen()` (~line 6979), specifically the `cardMeta` array built
around line 7034 in the non-animated path (and the equivalent point in the animated path).
