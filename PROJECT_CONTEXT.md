# FPO27 — Football Pack Opening 27
## Complete Project Handoff for Claude Code

---

## 1. PURPOSE

**Football Pack Opening 27 (FPO27)** is a single-file browser-based HTML/JS card collecting game themed around football (soccer). Players open packs to collect player cards, build squads, trade in a market, complete challenges, and participate in seasonal events. It is a solo project now developed with **Claude Code** (previously iterated in Claude.ai conversations).

The game is entirely self-contained in one HTML file (`index.html` / `fpo26.html`) with all JS, CSS, and data inline. It uses `localStorage` for save data and requires no backend or server.

---

## 2. FILE LOCATIONS

| File | Purpose |
|------|---------|
| `/Users/yhazan/Documents/FutTutorialPractice/fpo26.html` | Main game file — **~2 MB** |
| `/Users/yhazan/Documents/FutTutorialPractice/index.html` | Identical copy of fpo26.html (kept in sync) |

> Both files must always be identical. After every edit to `fpo26.html`, copy it to `index.html`.

**Save key:** `fpo26_save` (intentionally kept as `fpo26_` for backward compatibility — do NOT rename)
**Owner Panel code:** `14052022`

---

## 3. TECH STACK & CONSTRAINTS

- **Single HTML file** — all CSS, JS, SVG, and data inline. No external dependencies except Google Fonts loaded via CDN.
- **No build system** — pure vanilla JS, no frameworks, no bundler.
- **localStorage only** — all game state persisted in browser localStorage under `fpo26_*` keys.
- **Mobile-first** — max-width 480px, designed for phone screens.
- **Fonts:** `Bebas Neue` (headers/numbers), `Barlow Condensed` (body), `Barlow` (UI) — loaded from Google Fonts.
- **Anthropic API** — some features (scores, news) call `https://api.anthropic.com/v1/messages` directly from the browser with header `anthropic-dangerous-direct-browser-access: true`. Model: `claude-sonnet-4-6`. **Requires user to have API key set in the game's settings panel.**
- **Syntax check:** Always run `node --check` on the extracted `<script>` block after edits.
- **Standard Claude Code workflow:**
  ```bash
  # 1. Edit fpo26.html directly with Claude Code Edit tool
  # 2. Syntax check — extract <script> block (lines 1072–19385) and check it:
  node -e "require('fs').writeFileSync('/tmp/fpo26_check.js', require('fs').readFileSync('fpo26.html','utf8').match(/<script>([\s\S]*?)<\/script>/)[1])"
  node --check /tmp/fpo26_check.js
  # 3. Sync to index.html
  cp /Users/yhazan/Documents/FutTutorialPractice/fpo26.html /Users/yhazan/Documents/FutTutorialPractice/index.html
  ```

---

## 4. CRITICAL TECHNICAL RULES

1. **Never use apostrophes in JS strings for "Ballon d'Or"** — always write `dOr` or `BdO`
2. **`MIDNIGHT_NIGHTS`, `isMidnightPackActive`, `isHighOddsPackActive`, `isTransferDayActive`, `isMidSeasonDropActive`** must be defined BEFORE `const SHOP_CATS` to avoid hoisting issues
3. **`marketSc` div must be a sibling of `storeSc`**, NOT nested inside it
4. **No duplicate `marketGrid` IDs** — the old trading post used `marketGrid`, renamed to `tradingGrid`
5. **`buildFinalBanner()` must NOT be called from `goTab()`** — causes layout flicker
6. **`mO()` function** normalizes pack odds — always wrap odds objects with it
7. **Save keys** use `fpo26_` prefix even though the game is named FPO27

---

## 5. GAME STRUCTURE

### Core Arrays
- **`P[]`** — All player cards (~3,725 cards). Each card: `{name, club, nation, pos, rating, rarity, collab, celebration, stats:{PAC,SHO,PAS,DRI,DEF,PHY}}`
- **`PKS[]`** — All packs (~96 packs). Each pack: `{id, name, price, sub, cards, guar, odds, od, art, league}`
- **`CT{}`** — Card theme per rarity: `{bg[], border, label, sub, rating, tag, glow}`
- **`RC{}`** — Rarity colors (hex per rarity name)
- **`SPEC[]`** — Special rarities that get unique card rendering
- **`GAME_NEWS[]`** — News feed entries

### Key Functions
- `buildCard(pl, th, sm)` — renders SVG card
- `mkPackSVG(pt, w, h)` — renders pack SVG
- `doOpen()` / `pickCard(pt)` — pack opening logic
- `renderMarket()` — buy tab of market
- `renderListings()` — AI + player listings
- `showTradingPost()` / `completeTrade()` — trading post
- `showScreen(id)` — switches visible screen
- `goTab(tab)` — navigation
- `saveNow()` / `loadSave()` — localStorage persistence
- `applySeasonTheme()` — applies current season colors
- `getSeasonNum()` — returns current season number (1-5)
- `getCurrentTheme()` — returns `SEASON_THEMES[n]`

### Navigation Tabs
`shop` · `collection` · `scores` · `news` · `wc26store` · `store` · `market` · `squad` · `tasks` · `trade` · `draft` · `pick` · `achievements` · `sets` · `tournament` · `leaderboard` · `daily` · `rewards` + Trading Post modal

---

## 6. SEASONS

| Season | Name | Start | Theme |
|--------|------|-------|-------|
| 1 | Summer Vacation | Jun 1 2025 | Blue ocean |
| 2 | Golden Era | Jun 26 2026 | Gold |
| 3 | World Champions | Jul 20 2026 08:00 UTC | Dark gold/brown |
| 4 | The Club Season | Sep 10 2026 | Green |
| 5 | Ballon dOr Season | Oct 11 2026 | Gold |

**Current season: Season 3 (World Champions)** — as of Aug 22 2026

Season boundaries: `const SEASON_BOUNDARIES=[SEASON_LAUNCH,S2_START,S3_START,S4_START,S5_START]`

---

## 7. CARD RARITIES (Complete List)

### Always Available in Market
`bronze` `silver` `gold` `legendary` `flashback` `future_star` `aura` `wasted_potential` `totw` `golden_era` `stadium_anthems` `new_signings` `world_cup` `ucl` `toty_25` `icon_toty` `manager` `club_season` `historic_wc` `rivals` `creator_cup` `wc26_legend` `transfer_market`

### Seasonal/Exclusive (NOT in market)
`wc26_champion` `wc26_finalist` `wc26_tott` `wc26_sf` `wc26_motm` `wc26_spain_final` `wc26_arg_final` `wc26_golden_boot` `wc26_moment` `nations_rising` `historic_wc` `midnight_legend` `midnight_gold` `night_owl` `easter_egg` `wrong_number` `transfer_day` `mid_season` `pots` `pots_time` `duo` `ballon_dor_nom` `club_season` `wc26_qf` `wc26_r16` `wc26_r32` `wc26_host` `wc26_goal` `wc26_totw` `wc26_totw2` `wc26_totw3`

---

## 8. SHOP CATEGORIES

```js
const SHOP_CATS = {
  toty:    ['toty_mega', 'toty25', 'icon_toty', ...],
  world:   ['world_cup', 'ucl'],
  leagues: ['prem', 'laliga', 'bundesliga', 'seriea', ...],
  collab:  ['collab_mega', 'marvel', 'starwars', ...],
  special: ['transfer_market_pack', 'mid_season_pack', 'club_season_pack', 'mega', ...],
  wc26:    ['wc26_mega', 'wc26_moments_pack', 'duo_pack', 'wc26_s3_mega', 'wc26_tott_pack', ...]
}
```

**WC26 tab bypasses ALL time gates** (except `pots_pack`, `mid_season_pack`, `transfer_day_pack`)

---

## 9. TIME-GATED PACKS

| Pack | Active When |
|------|-------------|
| `high_odds_pack` (All In) | 8:00–8:15pm daily, Season 3 |
| `midnight_pack` | 12:00–1:00am on secret nights: Jul 25, Aug 2, Aug 10, Aug 16, Aug 24, Sep 5 |
| `mid_season_pack` | Aug 20–23 2026 |
| `transfer_market_pack` | From Aug 30 2026 |
| `transfer_day_pack` | Aug 31 2026 only |
| `pots_pack` | Oct 1–8 2026 |
| `ucl_final_arsenal`, `ucl_final_psg` | From Mar 1 2027 |

**Hidden always:** `summer_special`, `beach_party`, `new_signings`, `potm`, `potm_jun` and all old WC group/R32/TOTW/MOTM packs

---

## 10. MARKET SYSTEM

Three tabs:
1. **BUY** — Browse all `MARKET_ALLOWED_RARITIES` cards, buy with coins
2. **LISTINGS** — 20 daily AI listings (seeded by date) + player listings. Actions: Buy Now or Hijack
3. **SELL** — List cards from collection at custom or AI-suggested price
4. **MY LISTINGS** — Cancel listed cards

**Hijack mechanic:** Offer % of asking price → success chance = offer/asking×100%. If fail, coins returned.

**AI buys:** 30% chance AI buys your listed card within 30s–2.5min during session.

**Prices by rarity:** bronze:50 · silver:200 · gold:500 · legendary:5000 · toty_25:3500 · icon_toty:4000 · flashback:1200 · etc.

---

## 11. POTS (PLAYER OF THE SEASON) SYSTEM

- **Voting:** Jul 20–Oct 1 2026. Candidates: Mbappé, Yamal, Kvaratskhelia, Kane, Olise, Dembélé, Rice, Hakimi
- **Winner:** Announced Oct 1 — detected from vote counts in localStorage
- **Correct voters:** Get 99-rated winner POTS card automatically
- **Wrong voters:** Can complete 5 themed SBC challenges OR open POTS pack (Oct 1–8)
- **POTS Pack odds:** 5% winner (99), 30% nominees (90), 65% Season Time cards
- **Season Time cards:** 91 exclusive `pots_time` cards — ONLY pullable from POTS pack
- **SBC themes:** Different per winner (Mbappé = French + PSG + RM cards, Yamal = Spanish + Barca, etc.)

---

## 12. WC26 RESULTS (LORE)

- **Final:** 🇪🇸 Spain 1-0 Argentina AET — F. Torres 106'
- **3rd place:** England 6-4 France (Saka hat-trick)
- **Golden Ball:** Rodri 🇪🇸
- **Golden Boot:** Mbappé 🇫🇷 (10 goals — all-time WC record)
- **Best Young Player:** Yamal 🇪🇸
- **E. Martínez:** 9.6 Sofascore rating in final (11 saves)

---

## 13. TRANSFER MARKET 2026

101 confirmed summer 2026 transfer cards (`transfer_market` rarity). Key deals:
- Rodri: Man City → Barcelona £76.5M
- B. Silva + I. Konate + M. Cucurella: → Real Madrid
- F. Wirtz: Leverkusen → Liverpool
- A. Isak: Newcastle → Liverpool £125M
- B. Barcola: PSG → Liverpool £143M
- Y. Diomande: RB Leipzig → Real Madrid £107M
- M. Rogers: Aston Villa → Chelsea £117M
- L. Diaz: Liverpool → Bayern Munich
- M. Salah: Liverpool → Trabzonspor
- A. Griezmann: Atletico → LAFC
- S. Tonali: Newcastle → Tottenham £100M
- G. Ramos: PSG → AC Milan £63.7M
- + 89 more

Pack hidden until Aug 30 2026, then permanent.

---

## 14. FOOTBALL NEWS SYSTEM

**`FOOTBALL_NEWS_BATCHES[]`** — Array of 4 batches of 5 real news stories each.
- Clicking UPDATE cycles to next batch (Page 1/4 → 2/4 → etc.)
- Saves current page to `localStorage('fpo27_news_batch')`
- Each batch has real confirmed Aug 2026 news (Community Shield, Super Cup, transfers, season previews)
- **📊 365SCORES button** — direct link to 365scores.com/football
- **Add new batches** by appending to `FOOTBALL_NEWS_BATCHES` array and updating whenever asked

---

## 15. EVENTS CALENDAR (Season 3)

| Date | Event |
|------|-------|
| Jul 20 | Season 3 launched ✅ |
| Jul 25 | Midnight Pack night ✅ |
| Aug 1 | Nations Rising unlocked ✅ |
| Aug 2 | Midnight Pack night ✅ |
| Aug 10 | Midnight Pack + Free Pack Event ✅ |
| Aug 16 | Midnight Pack night ✅ |
| Aug 20–23 | Mid-Season Drop (active now) |
| Aug 24 | Midnight Pack night |
| Aug 30 | Transfer Market Pack unlocks |
| Aug 31 | Transfer Deadline Day pack (1 day only) |
| Sep 5 | Last Midnight Pack of Season 3 |
| Sep 10 | Season 4 launches (auto theme switch) |
| Oct 1 | POTS voting closes + winner announced |
| Oct 1–8 | POTS Pack available |
| Oct 11 | Season 5 (Ballon dOr) launches |
| Oct 26 | Ballon dOr ceremony London |
| Mar 1 2027 | UCL Final packs unlock |

---

## 16. WHAT STILL NEEDS TO BE IMPLEMENTED

### High Priority
1. **GitHub auto-deploy** — owner wants to push `index.html` to GitHub Pages automatically. Need to set up a GitHub Action or script in the Owner Panel that commits and pushes on demand.
2. **Ballon dOr 2026 nominees** — ceremony Oct 26 London. Waiting for official announcement. When confirmed, add nominee cards (`ballon_dor_nom` rarity, already has theme defined) and BdO nominee pack.
3. **August POTM cards** — same format as July POTM (5 leagues: PL, La Liga, Bundesliga, Serie A, Ligue 1). Should be out now (Aug 2026).
4. **Season 4 content** — Sep 10: more Club Season cards, TOTW for new season, league packs.

### Medium Priority
5. **Golden Era legends** — Ronaldinho, Zidane, Rivaldo, R9 (Ronaldo Nazário), Cantona, Figo — announced but never built
6. **More news batches** — add new batch whenever real football results available
7. **Transfer Deadline Day** cards updated with any last-minute Aug 31 deals
8. **Duo cards** — 8 built, could expand

### Nice to Have
9. **Squad Builder improvements** — currently exists but could be enhanced
10. **Pack history log** — show every pack ever opened
11. **Card showcase** — screenshot best card

---

## 17. OWNER PANEL

Access: Settings → enter code `14052022`

Features:
- Grant coins
- Grant cards
- 🆘 RESCUE ALL CARDS button — adds every card in P[] to collection
- Add to collection
- Reset data

---

## 18. COMPENSATION EVENT

A one-time popup fires 2 seconds after game load if `fpo27_allin_comp_claimed` not in localStorage:
- Explains All In Pack bug
- Gives free All In Pack opening
- Sets `fpo27_allin_comp_claimed` in localStorage after claim

---

## 19. DESIGN SYSTEM

**Season 3 colors (current):**
- Background: `#060400` → `#0e0a00` → `#181200` → `#201800`
- Accent: `#ffd700` (gold)
- Header: `rgba(10,8,0,.95)`
- Body class: `s3`

**Card SVG:** Built by `buildCard(pl, th, sm)` — uses rarity theme from `CT{}`. Cards are ~116×154px SVG with gradient background, player name, rating, position, stats bars, rarity tag.

**Pack SVG:** Built by `mkPackSVG(pt, w, h)` — animated shimmer effect, uses pack `art` object for colors.

**Font sizes:** Bebas Neue for all headers/numbers/buttons, Barlow Condensed for card names, Barlow for body text.

---

## 20. EXACT NEXT STEPS FOR CLAUDE CODE

1. **Set up GitHub Pages deployment:**
   - Create repo `fpo27` on GitHub
   - Add a GitHub Action `.github/workflows/deploy.yml` that deploys `index.html` to Pages on push to main
   - Add a "Push to GitHub" button to Owner Panel that uses the GitHub API to commit `index.html`

2. **Add August POTM cards:**
   - Search real Aug 2026 POTM winners for PL, La Liga, Bundesliga, Serie A, Ligue 1
   - Add 5 cards with `rarity:'potm'`, rating 93-97
   - Add `potm_aug` pack (same format as `potm_jul`)

3. **Update news batch 5** with real GW1 results when available (PL starts Aug 22)

4. **When Ballon dOr nominees announced:**
   - Add `ballon_dor_nom` rarity cards (theme already defined)
   - Add BdO nominee pack gated until Oct 11
   - Update Season 5 theme

5. **Standard Claude Code workflow reminder:**
   ```bash
   # Edit fpo26.html directly (Claude Code Edit tool handles this)
   # Syntax check:
   node -e "require('fs').writeFileSync('/tmp/fpo26_check.js', require('fs').readFileSync('fpo26.html','utf8').match(/<script>([\s\S]*?)<\/script>/)[1])"
   node --check /tmp/fpo26_check.js
   # Sync:
   cp /Users/yhazan/Documents/FutTutorialPractice/fpo26.html /Users/yhazan/Documents/FutTutorialPractice/index.html
   ```

---

## 21. KNOWN ISSUES / WATCH OUT FOR

- **`buildFinalBanner()` in `goTab()`** — must never be called there, causes layout flicker
- **Apostrophes in JS strings** — d'Or must be written as dOr everywhere in JS
- **`marketSc` nesting** — must be sibling of `storeSc`, not child
- **Duplicate `marketGrid` ID** — old trading post uses `tradingGrid` now
- **Season theme `%2` bug** — `getCurrentTheme()` must NOT use modulo, must use direct index
- **`MIDNIGHT_NIGHTS` hoisting** — must be defined before `SHOP_CATS`
- **Transfer market cards** — always verify player's current club before adding (many wrong clubs were caught and fixed)
- **Ballon dOr nominees** — do NOT invent nominees, wait for official announcement
- **File size** — already ~1.93MB. Be mindful of how much more can be added before browsers struggle.
