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

**REQUIRED:** Follow [../size-work/levels.md](../size-work/levels.md).

## Hard rules

- Emit **user stories** only in the inventory. Each child must be an As a / I want / so that one-liner (or equivalent user-value statement).
- Do not emit admin/platform chores as bare tasks in the inventory. If a chore has no user value, note it under Constraints as a dependency — or leave it for `shape-task` after stories exist.
- Do not write a full spec, Given/When/Then catalog, or implementation plan.
- Do not implement.
- Mixed-turn build request: finish this shape, then hand back.

## Output contract (in order)

1. **Title**
2. **Problem** — who hurts and why (2–4 sentences)
3. **Outcome** — what “shipped” means for users
4. **Boundaries** — in / out
5. **Constraints** — dependencies and non-user-facing chores that must not appear as inventory children (or “None”)
6. **User-story inventory** — 3–9 stories; each: short title + As a / I want / so that + priority. No acceptance scenarios yet.
7. **Open questions** — decisions a later spec must settle (bullets)
8. **Close** — ask which story to deepen with `shape-story`, or stop

## Rationalizations

| Excuse | Reality |
|---|---|
| “Server-side validation isn’t a story” | Fold into a shopper/admin story’s later spec, or list it under **Constraints** — don’t list raw tasks as children. |
| “They asked to break into work” | Children are stories. Specs come later per story. |
| “Acceptance scenarios help” | Belong in `shape-story` / real specify — not here. |

## Failures

- Task-shaped children without user-value statements
- Full Spec Kit sections or design docs
- Expanding every story into a brief in this turn
