### Story 1: Log every pack opened
As a player, I want every pack I open to be recorded so that I can look back at what I've pulled.

**Priority:** High
**Acceptance Criteria:**
- Given I open a pack via the normal (animated) flow, when the cards are revealed, then a history
  entry is saved with the pack name, each pulled card's name/rarity/rating, and a timestamp.
- Given I open a pack with pack-opening animation turned off (skip-animation path), when the cards
  are revealed, then the same history entry is saved.
- Given a pack open fails and coins are refunded (existing error path in `doOpen()`), when that
  happens, then no history entry is recorded for that failed attempt.

### Story 2: View pack history
As a player, I want to view my past pack openings from Settings so that I can browse what I've
pulled over time.

**Priority:** High
**Acceptance Criteria:**
- Given I open Settings, when I look for it, then there's a "📜 Pack History" control alongside the
  other settings rows.
- Given I tap it, when the modal opens, then entries are listed most-recent-first, each showing pack
  name, a relative time ("just now" / "Xm ago" / "Xh ago" / "Xd ago", matching the existing
  notifications pattern), and the cards pulled (name + rarity).
- Given I have no history yet, when I open the modal, then it shows an empty-state message instead
  of a blank list.

### Story 3: Clear history
As a player, I want to clear my pack history so that I can reset the list if I want to.

**Priority:** Medium
**Acceptance Criteria:**
- Given the history modal is open, when I tap "CLEAR ALL", then all entries are removed from
  `localStorage` and the modal shows the empty state.

### Story 4: Bounded storage
As a player, I want the game to stay fast so that a long play history doesn't bloat local storage.

**Priority:** Medium
**Acceptance Criteria:**
- Given I've opened more than the cap (200 entries) worth of packs, when a new one is logged, then
  the oldest entries beyond the cap are dropped, matching the existing `fpo26_reward_log` capping
  pattern (capped at 50 there; 200 here since pack history is the primary use case for this data,
  vs. reward_log being a secondary log).
