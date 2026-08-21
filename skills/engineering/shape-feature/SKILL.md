---
name: shape-feature
description: >-
  Shape a feature brief and user-story inventory. Use when size-work hands
  off feature-level work, or the user explicitly asks to break a feature
  into user stories for later specs.
disable-model-invocation: true
---

# Shape feature

Turn a feature-scale description into a brief and a **user-story inventory**. One level only.

**REQUIRED:** Follow [../size-work/levels.md](../size-work/levels.md) and [../size-work/paths.md](../size-work/paths.md).

## Hard rules

- Emit **user stories** only in the inventory. Each child must be an As a / I want / so that one-liner (or equivalent user-value statement).
- Do not emit admin/platform chores as bare tasks in the inventory. If a chore has no user value, note it under Constraints as a dependency — or leave it for `shape-task` after stories exist.
- Do not write a full spec, Given/When/Then catalog, or implementation plan.
- Do not implement.
- Follow [../size-work/paths.md](../size-work/paths.md). Emit **Path** after the user-story inventory. Do not dispatch agents.
- Outcomes: follow [../size-work/levels.md](../size-work/levels.md) **Outcomes** — conversation-only unless they named a sink (publish there) or asked for a tracker skill/prompt (hand off after shaping).
- Mixed-turn build or dispatch request: finish this shape, then **hand back**.

## Output contract (in order)

1. **Title**
2. **Problem** — who hurts and why (2–4 sentences)
3. **Outcome** — what “shipped” means for users
4. **Boundaries** — in / out
5. **Constraints** — dependencies and non-user-facing chores that must not appear as inventory children (or “None”)
6. **User-story inventory** — 3–9 stories; each: short title + As a / I want / so that + priority. No acceptance scenarios yet. Do not reshuffle this order to match Path.
7. **Path** — follow [../size-work/paths.md](../size-work/paths.md): Critical path, Parallel (`None` is success), Why coupled (omit if none). Inventory items only. Do not dispatch.
8. **Open questions** — decisions a later spec must settle (bullets)
9. **Close** — ask which story to deepen with `shape-story`, or stop. If they named a sink, publish per Outcomes; if they want a tracker skill next, hand off. Mixed-turn build or dispatch request: **hand back**.

## Rationalizations

| Excuse | Reality |
|---|---|
| “Server-side validation isn’t a story” | Fold into a shopper/admin story’s later spec, or list it under **Constraints** — don’t list raw tasks as children. |
| “They asked to break into work” | Children are stories. Specs come later per story. |
| “Acceptance scenarios help” | Belong in `shape-story` / real specify — not here. |
| “I’ll skip Path until they pick a story” | Path is part of this shape, after the inventory. |
| “These stories can all start; I’ll dispatch” | Write Parallel or `None`. Do not dispatch. |
| “I’ll put the path after Close” | Path comes after the inventory, before Open questions. |
| “These don’t share a file, so they’re parallel” | Shared contract or open decision still fails. `None` if nothing else passes. |

## Failures

- Task-shaped children without user-value statements
- Full Spec Kit sections or design docs
- Expanding every story into a brief in this turn
- Skipping Path, or putting it before the inventory / after Open questions
- Inventing Parallel for a shared contract / file / open decision
- Dispatching agents
