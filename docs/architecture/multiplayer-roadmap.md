# Multiplayer & Backend Roadmap

## Status: Phase 0 — not started. This document is the target; no backend code exists yet.

FPO27 is currently a single static HTML file (`fpo26.html` / `index.html`), vanilla JS, `localStorage`
only, served from GitHub Pages with no server. This document is the source of truth for the eventual
move to a **secured, realtime multiplayer** backend, so that individual features don't each invent
their own stack. Any `tech-design.md` that needs backend/realtime capability should point here and
delegate the actual design to the `multiplayer-architect` agent instead of picking new tools per feature.

## Constraints (from the project owner)

- **Free** to start — no fixed monthly bill for a hobby-scale player base.
- **Simple** — small surface area a solo developer can operate.
- **Backend language: Python.**
- **Fast store** for realtime state — "some kind of memcache, but free."
- **Scales without a cost cliff** — if the game takes off, cost should grow roughly with usage, not
  jump to an expensive fixed tier the moment free limits are hit.

## Proposed stack

| Concern | Choice | Why |
|---|---|---|
| Backend framework | **Python + FastAPI** | Async-native, built-in WebSocket support (no extra realtime framework needed), Pydantic models give request/message validation for free — directly supports the security baseline. |
| Realtime / fast store | **Upstash Redis** | Serverless Redis with a pay-per-request free tier — no idle cost, no server to manage. Doubles as: cache, pub/sub (to broadcast events across backend instances once there's more than one), room/presence state, rate-limit counters. This is the "memcache but free" piece. |
| Durable data (accounts, collections, trade history) | **Supabase (Postgres)** | Free tier Postgres plus **built-in auth** (email/OAuth, JWT) and row-level security — covers "secured" without hand-rolling an auth system. |
| Hosting for the always-on WebSocket server | **Fly.io free allowance** | Needs to stay warm for live connections. Render's free tier sleeps after 15 minutes idle, which breaks realtime; Fly's free VMs don't sleep. Cost only grows once usage exceeds the free allowance — no cliff. |
| Edge protection | **Cloudflare (free tier)** in front of the API domain | Basic WAF/DDoS protection at no cost. |
| Frontend | Unchanged — still the static `index.html` | A thin optional WebSocket client module gets added only when a feature actually needs it, so single-player/offline mode keeps working exactly as it does today (progressive enhancement, not a rewrite). |

### Why not alternatives
- **Node/JS backend** — would match the frontend language, but the owner explicitly asked for Python.
- **Firebase** — realtime DB + auth in one product, but pricing can jump quickly under load and it's
  not Python-first (Cloud Functions in Python are the workaround layer, not the core model).
- **Render / Railway** for hosting — Render free tier sleeps (breaks realtime); Railway no longer has a
  real free tier (trial credit only, then a fixed monthly floor).
- **Self-hosted Redis/Postgres on a VM** — cheaper at very large scale, but violates "simple" for a
  solo dev; revisit only if Upstash/Supabase usage-based pricing genuinely becomes the expensive option.

## Phased migration

Each phase is delivered as one or more features through the normal pipeline
(`define-feature` → `write-stories` → `tech-design` → `impl-plan` → `implement-feature`), not built
in one big-bang change.

1. **Phase 0 (now):** This roadmap + the pipeline tooling. Game stays single-player, no backend.
2. **Phase 1 — Cloud save:** Stand up FastAPI + Supabase. Players can optionally log in and sync their
   `localStorage` save to the cloud. No realtime yet — this phase exists to validate the
   FastAPI+Supabase path end-to-end with the lowest-risk feature possible.
3. **Phase 2 — Read-mostly realtime:** Add Upstash Redis pub/sub and WebSocket broadcast for shared
   live state players only observe — e.g. a live activity feed during the "All In Pack" window, or a
   shared countdown. Establishes the WebSocket connection/reconnect pattern on the client without any
   player-to-player interaction risk yet.
4. **Phase 3 — Interactive multiplayer:** Real player-to-player features — live trading between real
   accounts, matchmaking, any PvP/co-op concept. All actions validated server-side (never trust the
   client for anything that changes another player's state).
5. **Phase 4 — Hardening:** Load testing, rate-limit tuning under real traffic, moving the currently
   client-side Anthropic API key handling (see `PROJECT_CONTEXT.md` §3 — the browser calls
   `api.anthropic.com` directly with a user-supplied key) fully behind the backend so keys are never
   in the client, and a full `/security-review` pass before the interactive-multiplayer phase ships.

## Ground rules for every future feature that touches this roadmap

- Don't introduce a different backend language, database, or hosting provider per feature — extend
  this stack or explicitly propose changing this document first.
- Every new networked capability updates this file's phase status.
- Any feature in Phase 3+ (player-to-player state changes) must pass `/security-review` before
  `implement-feature` runs.
