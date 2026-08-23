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
- Inventory band is **3–9**. Five is in band. Do not fail five as over-split. Do not collapse to one story to satisfy a “one user-story child” rule.
- Do not list class, provider, or interface names as children (`LocationProvider`, `WeatherSource`, …). Those are `write-design` cuts after grain.
- Do not bump this feature to an epic because SOLID, ISP, stacked PRs, or “three cuts.”
- An open vendor / API decision stays a separate `shape-task` (spike) — note it under Constraints or Open questions. Do not swallow it as a production story.
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
7. **Path** — follow [../size-work/paths.md](../size-work/paths.md): Critical path (every inventory title that determines done, in dependency order; omit only titles that do not determine done; no count floor or cap; matching priority is fine when that is the sequence). If five user-perceivable stories all determine done, list those five titles. Do not pad-to-one or drop-to-one. Parallel (`None` if they share a vendor/API contract or one page). Why coupled (omit if none). Inventory items only. Out stays off the path. Do not dispatch.
8. **Open questions** — decisions a later spec must settle (bullets)
9. **Close** — if they arrived from a `write-spec` blob (outcome already sharpened), announce `write-design` as next (then `write-plan`) and **stop**. Do not invoke them. Do not hand off to Superpowers brainstorming or writing-plans. Otherwise ask which story to deepen with `shape-story`, or stop. If they named a sink, publish per Outcomes; if they want a tracker skill next, hand off. Mixed-turn build or dispatch request: **hand back**.

## Rationalizations

| Excuse | Reality |
|---|---|
| “Server-side validation isn’t a story” | Fold into a shopper/admin story’s later spec, or list it under **Constraints** — don’t list raw tasks as children. |
| “They asked to break into work” | Children are stories. Specs come later per story. |
| “Acceptance scenarios help” | Belong in `shape-story` / `write-spec` — not here. |
| “Five stories is over-split; Skill Craft wanted one child” | 3–9 is the band. Five is in band. |
| “SOLID / three cuts means this is an epic” | Labels and later cuts do not bump grain. Stay `shape-feature`. |
| “I’ll add LocationProvider so the inventory is real” | Class / provider names are not stories. |
| “The weather API is a story” | Separate `shape-task` spike. Decision brief, not a production story. |
| “I’ll skip Path until they pick a story” | Path is part of this shape, after the inventory. |
| “These stories can all start; I’ll dispatch” | Write Parallel or `None`. Do not dispatch. |
| “I’ll put the path after Close” | Path comes after the inventory, before Open questions. |
| “These don’t share a file, so they’re parallel” | Shared contract or open decision still fails. `None` if nothing else passes. |
| “Every child on the path is a miss” | If every story determines done, list them. |
| “I'll add a second so the path is at least two” | One determining story is a one-item path. Do not pad. |
| “The parked card was one story / Parallel None, so Path is one title” | Parallel `None` is the coupling. If five determine done, list five. |
| “I'll add a dummy so the path is one” | pad-to-one is a fail. |
| “I'll keep one title so it matches the old card” | drop-to-one is a fail. |
| “The path matches priority, so I must reshuffle” | Matching priority is fine when that is the sequence. |

## Failures

- Task-shaped children without user-value statements
- Class / provider / interface name as a story
- Epic because SOLID, ISP, stacked PRs, or a later cut count
- Failing a 3–9 / five-story inventory as over-split
- Weather API (or any open vendor/API) swallowed as a production story
- Full Spec Kit sections or design docs
- Expanding every story into a brief in this turn
- Handing off to Superpowers brainstorming or writing-plans after a write-spec blob
- Skipping Path, or putting it before the inventory / after Open questions
- Inventing Parallel for a shared contract / file / open decision
- Dropping a required story to avoid listing every child, or to fit a count cap
- Padding the path with a non-determining story to reach a minimum count
- pad-to-one or drop-to-one so Critical path is one title
- Weather Path of one title / Parallel None because the old parked card said so
- Dispatching agents
