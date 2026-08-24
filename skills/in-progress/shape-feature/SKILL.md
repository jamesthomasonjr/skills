---
name: shape-feature
description: >-
  Use when size-work hands off feature-level work, or the user
  asks to break a feature into user stories.
disable-model-invocation: true
---

# Shape feature

Announce once: `Using shape-feature to inventory user stories.`

Turn a feature-scale description into a brief and a **user-story inventory**. One level only.

**REQUIRED:** Follow [../size-work/levels.md](../size-work/levels.md)
**HARD-GATE**, **Inventory**, **After a write-spec blob** and
[../size-work/paths.md](../size-work/paths.md).

## Hard rules

- Emit **user stories** only in the inventory. Each child must be an As a / I want / so that one-liner (or equivalent user-value statement).
- Inventory **follows journeys / domains**. **REQUIRED:** follow
  [../size-work/levels.md](../size-work/levels.md) **Inventory**.
  A mid-size list is fine (five OK). Do not fail five as over-split.
  Do not pad-to-N or merge-to-fit-N. Do not collapse to one story
  to satisfy a “one user-story child” rule.
- Do not list class, provider, or interface names as children. Those are `write-design` cuts after grain.
- Do not bump this feature to an epic because SOLID, ISP, stacked PRs, or “three cuts.”
- An open vendor / API decision stays a separate `shape-task` (spike) — note it under Constraints or Open questions. Do not swallow it as a production story.
- Do not emit admin/platform chores as bare tasks in the inventory. If a chore has no user value, note it under Constraints as a dependency — or leave it for `shape-task` after stories exist.
- Do not write a full spec, Given/When/Then catalog, or implementation plan.
- Do not implement.
- Follow [../size-work/paths.md](../size-work/paths.md). Emit **Path** after the user-story inventory. Do not dispatch agents.
- Outcomes: follow [../size-work/levels.md](../size-work/levels.md) **Outcomes**.
- Mixed-turn build or dispatch request: finish this shape, then **hand back**.

## Output contract (in order)

1. **Title**
2. **Problem** — who hurts and why (2–4 sentences)
3. **Outcome** — 1–2 sentences; what “shipped” means for users
4. **Boundaries** — in / out
5. **Constraints** — dependencies and non-user-facing chores that must not appear as inventory children (or “None”)
6. **User-story inventory** — one child per journey / domain; each: short title + As a / I want / so that + priority. No acceptance scenarios yet. Do not reshuffle this order to match Path.
7. **Path** — **REQUIRED:** follow [../size-work/paths.md](../size-work/paths.md). Inventory items only. Out stays off the path. Do not dispatch.
8. **Open questions** — decisions a later spec must settle (bullets)
9. **Close** — **Terminal:** after a write-spec blob, announce `write-design` as next (then `write-plan`) and **stop**. Do not invoke them. Do not hand off to Superpowers brainstorming or writing-plans. Otherwise ask which story to deepen with `shape-story`, or stop. If they named a sink, publish per Outcomes; if they want a tracker skill next, hand off. Mixed-turn build or dispatch request: **hand back**.

## Self-review

Agent check. Fix inline. Do not re-emit this list.

1. **Placeholders** — no TBD, TODO, or incomplete sections.
2. **Stories** — journeys / domains; mid-size list is fine (five OK). No pad-to-N or merge-to-fit-N. No class / provider names.
3. **Spike** — open vendor / API is a `shape-task`, not a production story.
4. **In/Out** — Out stays out of inventory and off the path.
5. **Path** — after the inventory; follows paths.md.
6. **Close** — after a write-spec blob, announce `write-design` and
   stop; otherwise ask which story to deepen. Do not invoke
   `write-design` or Superpowers.

## Rationalizations

| Excuse | Reality |
|---|---|
| “Server-side validation isn’t a story” | Fold into a shopper/admin story’s later spec, or list it under **Constraints** — don’t list raw tasks as children. |
| “They asked to break into work” | Children are stories. Specs come later per story. |
| “Acceptance scenarios help” | Belong in `shape-story` / `write-spec` — not here. |
| “Five stories is over-split; a reviewer / old Path wanted one child” | Mid-size is fine. Five is OK. Do not merge-to-fit-N. |
| “SOLID / three cuts means this is an epic” | Labels and later cuts do not bump grain. Stay `shape-feature`. |
| “I’ll add a class / provider name so the inventory is real” | Class / provider names are not stories. |
| “The vendor / API is a story” | Separate `shape-task` spike. Decision brief, not a production story. |
| “These stories can all start; I’ll dispatch” | Write Parallel or `None`. Do not dispatch. |

## Failures

- Task-shaped children without user-value statements
- Class / provider / interface name as a story
- Epic because SOLID, ISP, stacked PRs, or a later cut count
- Failing a mid-size / five-story inventory as over-split
- pad-to-N or merge-to-fit-N on inventory
- Open vendor/API swallowed as a production story
- Full Spec Kit sections or design docs
- Expanding every story into a brief in this turn
- Handing off to Superpowers brainstorming or writing-plans after a write-spec blob
- Skipping Path, or putting it before the inventory / after Open questions
- Dispatching agents
