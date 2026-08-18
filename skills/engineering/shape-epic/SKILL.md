---
name: shape-epic
description: >-
  Shape an epic brief and feature inventory. Use when size-work hands off
  epic-level work, or the user explicitly asks to break an epic into features.
disable-model-invocation: true
---

# Shape epic

Turn an epic-scale description into a brief and a **feature inventory**. One level only.

**REQUIRED:** Follow [../size-work/levels.md](../size-work/levels.md).

## Hard rules

- Emit **features** (title + one-liner + order). Do not emit stories, tasks, or specs.
- Do not write implementation plans or file-path task lists.
- Do not implement.
- Outcomes: follow [../size-work/levels.md](../size-work/levels.md) **Outcomes** (conversation default; named sink only; else hand off to tracker skill/prompt).
- Mixed-turn build request: finish this shape, then hand back.

## Output contract (in order)

1. **Title**
2. **Outcome** — what coherent result this epic delivers
3. **Boundaries** — in / out at epic grain
4. **Success signals**
5. **Constraints / dependencies**
6. **Feature inventory** — 3–9 features; each: title, one-liner, priority/order. No nested stories.
7. **Close** — ask which feature to shape next (`shape-feature`), or stop. If they named a sink, publish per Outcomes; if they want a tracker skill next, hand off.

## Rationalizations

| Excuse | Reality |
|---|---|
| “Stories are more actionable” | Feature grain first. Stories come after `shape-feature`. |
| “One feature is really the whole epic” | Then reclassify with `size-work`; don’t smuggle stories up. |
| “I’ll draft acceptance tests” | Forbidden at epic grain. |

## Failures

- User stories or Given/When/Then in the inventory
- Spec or plan documents
- Shaping all child features in this turn
