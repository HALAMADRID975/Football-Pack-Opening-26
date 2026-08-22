# Security Baseline

Applies to every feature that adds networked/backend capability under the stack defined in
[`multiplayer-roadmap.md`](multiplayer-roadmap.md). These are defaults a `tech-design.md` can assume
without re-justifying; deviate only with an explicit reason written into that design.

## Rules

1. **Validate at the boundary.** Every FastAPI endpoint and every WebSocket message type gets a
   Pydantic model. Never trust a client-supplied value (card ids, prices, coin amounts, opponent ids)
   without server-side validation against real game state.
2. **Auth via Supabase JWT** once a feature needs a real player identity. No custom session/token
   scheme. Anonymous/local-only play (today's default) needs no auth.
3. **Server is the source of truth for anything that changes another player's state.** Trades, coin
   balances, pack odds/results, matchmaking — always computed and validated server-side, never
   accepted as-is from a client message. This is the main anti-cheat mechanism.
4. **Secrets never ship in the client.** Redis URL, Postgres connection string, JWT signing key, and
   (once migrated per the roadmap's Phase 4) the Anthropic API key all live in platform environment
   variables on the backend only. Known current gap: `PROJECT_CONTEXT.md` §3 documents the browser
   calling `api.anthropic.com` directly with a user-supplied key — acceptable for the current
   single-player, no-backend game, but must move server-side before any multiplayer feature reuses
   that AI-call path.
5. **CORS locked to real origins** — the GitHub Pages domain (and any custom domain later), not `*`.
6. **Rate limit** per-player and per-IP using Redis counters (Upstash) on any endpoint that costs
   money (AI calls) or affects fairness (pack opens, trade offers, matchmaking).
7. **`/security-review` is a required gate**, not optional, before `implement-feature` runs for any
   story in Phase 3+ (interactive multiplayer) of the roadmap, or any story that adds a new networked
   endpoint at any phase.

## What this does NOT cover

Client-side game logic that never leaves `localStorage` (current single-player game) — no server
exists to attack yet, so this baseline doesn't apply until a feature actually introduces a network
boundary.
