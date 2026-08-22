# Tech Design: Pack History Log

## Summary
Add a capped, `localStorage`-backed log of opened packs, written from both `doOpen()` branches right
after cards are pulled, and a Settings-launched modal viewer reusing the existing
`showNotifications()` modal pattern. Purely client-side — no backend/multiplayer scope, no new
networked surface, so `docs/architecture/security-baseline.md` doesn't apply here.

## Data model changes
New `localStorage` key `fpo26_pack_log`, a JSON array capped at 200 entries (newest first, oldest
dropped past the cap — same shape/approach as the existing `fpo26_reward_log` at `fpo26.html:6416`,
just a higher cap since this is the primary log rather than a secondary one):

```js
{
  packId: string,     // cPack.id
  packName: string,   // cPack.name
  cards: [{name, rarity, rating}],  // one per pulled card
  date: string         // new Date().toISOString()
}
```

No changes to `P[]`, `PKS[]`, or any other core array.

## Functions touched or added

- **New `logPackOpen(pack, cardMeta)`** (place next to `logReward()`, `fpo26.html:6416`): builds the
  entry above from `pack` (the `PKS[]` entry) and `cardMeta` (the `{card,dup,isSpec}[]` array already
  built in both `doOpen()` branches), unshifts it into `fpo26_pack_log`, caps at 200, writes back.
- **New `getPackLog()`**: mirrors `getRewardLog()` (`fpo26.html:6424`) — parses and returns the array,
  `[]` on any error.
- **`doOpen()` (`fpo26.html:6979`)** — two call sites, one per branch, both right after `cardMeta` is
  built and `addCard` has run for each pulled card (so a failed/refunded open, which returns before
  this point, never logs):
  - Non-animated (skip-animation) branch: after line 7035 (`cardMeta.forEach(({card})=>addCard(card))`).
  - Animated branch: after the equivalent `cardMeta` build/`addCard` loop at line 7139.
  Each call: `logPackOpen(cPack, cardMeta);`
- **New `showPackHistory()`** (place near `showNotifications()`, `fpo26.html:12744`): same `.modal-ov`
  structure — header "📜 PACK HISTORY", a "CLEAR ALL" button that does
  `localStorage.removeItem('fpo26_pack_log')` and re-renders the empty state, a scrollable list from
  `getPackLog()` (empty state matches the "No notifications yet" pattern when the array is empty),
  each entry showing pack name, relative time (reuse the same `ago`/`agoStr` calculation as
  `showNotifications()`), and the pulled cards as a compact comma-separated `name (rarity)` list.
  Closable via the same `onclick="this.closest('.modal-ov').remove()"` / backdrop-click pattern.
- **Settings panel markup (`fpo26.html:521` area)** — add one row in the same style as the existing
  "DARK MODE" / "PACK OPENING ANIMATION" rows (`fpo26.html:524-533`), a single button instead of a
  toggle: `<button onclick="showPackHistory()">📜 PACK HISTORY</button>`.

## UI/UX flow
Settings (⚙️, opened via existing `toggleSettings()`) → new "📜 Pack History" row → tap opens the
modal overlay (`showPackHistory()`) → list of past opens, newest first → "CLEAR ALL" or close via the
✕/backdrop pattern already used for notifications. No new tab, no change to `goTab()`/`showScreen()`.

## Risks / open questions
- `cardMeta` in the animated branch (`fpo26.html:7139`) needs to be re-read at implementation time to
  confirm nothing between the build and the reveal mutates it in a way that would make logging early
  (right after build) inconsistent with what's actually shown — implementer should verify by reading
  that branch in full before inserting the call, not just pattern-match the line numbers above (this
  design was written from `grep`/`Read` snapshots, not a full line-by-line trace of that branch).
- 200-entry cap is a judgment call (Story 4) — cheap to change later if it turns out too small/large.
