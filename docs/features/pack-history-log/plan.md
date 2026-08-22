# Implementation Plan: Pack History Log

1. Add `logPackOpen(pack, cardMeta)` and `getPackLog()` next to `logReward()`/`getRewardLog()` —
   file: `fpo26.html`, touches: new functions near line 6416-6424.
2. Call `logPackOpen(cPack, cardMeta)` in the non-animated `doOpen()` branch — file: `fpo26.html`,
   touches: `doOpen()`, right after the `cardMeta.forEach(({card})=>addCard(card))` line (~7035).
3. Read the animated `doOpen()` branch in full (per tech-design's risk note), then call
   `logPackOpen(cPack, cardMeta)` at the equivalent point — file: `fpo26.html`, touches: `doOpen()`,
   near the second `cardMeta` build (~7139).
4. Add `showPackHistory()` next to `showNotifications()` — file: `fpo26.html`, touches: new function
   near line 12744, reusing the `.modal-ov` pattern.
5. Add the "📜 PACK HISTORY" row to the settings panel markup — file: `fpo26.html`, touches: the
   settings rows block near line 521-533.
6. Extract and syntax-check the script block:
   ```bash
   node -e "require('fs').writeFileSync('/tmp/fpo26_check.js', require('fs').readFileSync('fpo26.html','utf8').match(/<script>([\s\S]*?)<\/script>/)[1])"
   node --check /tmp/fpo26_check.js
   ```
7. Sync `fpo26.html` → `index.html` (byte-identical).

No `/security-review` gate needed — no networked endpoint or backend/multiplayer scope in this
feature (tech-design.md has no "Backend/multiplayer scope" or "Security considerations" section).
