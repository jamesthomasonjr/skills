---
name: shape-epic
description: >-
  Shape an epic brief and feature inventory. Use when size-work hands off
  epic-level work, or the user explicitly asks to break an epic into features.
disable-model-invocation: true
---

# Shape epic

Turn an epic-scale description into a brief and a **feature inventory**. One level only.

**REQUIRED:** Follow [../size-work/levels.md](../size-work/levels.md) and [../size-work/paths.md](../size-work/paths.md).

## Hard rules

- Emit **features** (title + one-liner + order). Do not emit stories, tasks, or specs.
- Do not write implementation plans or file-path task lists.
- Do not implement.
- Follow [../size-work/paths.md](../size-work/paths.md). Emit **Path** after the feature inventory. Do not dispatch agents.
- Outcomes: follow [../size-work/levels.md](../size-work/levels.md) **Outcomes** — conversation-only unless they named a sink (publish there) or asked for a tracker skill/prompt (hand off after shaping).
- Mixed-turn build or dispatch request: finish this shape, then **hand back**.

## Output contract (in order)

1. **Title**
2. **Outcome** — what coherent result this epic delivers
3. **Boundaries** — in / out at epic grain
4. **Success signals**
5. **Constraints / dependencies**
6. **Feature inventory** — 3–9 features; each: title, one-liner, priority/order. No nested stories. Do not reshuffle this order to match Path.
7. **Path** — follow [../size-work/paths.md](../size-work/paths.md): Critical path (every inventory title that determines done; omit the rest; matching priority is fine when that is the sequence), Parallel (`None` is success), Why coupled (omit if none). Inventory items only. Do not dispatch.
8. **Close** — ask which feature to shape next (`shape-feature`), or stop. If they named a sink, publish per Outcomes; if they want a tracker skill next, hand off. Mixed-turn build or dispatch request: **hand back**.

## Rationalizations

| Excuse | Reality |
|---|---|
| “Stories are more actionable” | Feature grain first. Stories come after `shape-feature`. |
| “One feature is really the whole epic” | Then reclassify with `size-work`; don’t smuggle stories up. |
| “I’ll draft acceptance tests” | Forbidden at epic grain. |
| “I’ll skip Path until they pick a feature” | Path is part of this shape, after the inventory. |
| “These features can all start; I’ll dispatch” | Write Parallel or `None`. Do not dispatch. |
| “I’ll reorder the inventory to match the path” | Priority stays value. Sequence lives under Path. |
| “Every child on the path is a miss” | If every feature determines done, list them. |
| “The path matches priority, so I must reshuffle” | Matching priority is fine when that is the sequence. |

## Failures

- User stories or Given/When/Then in the inventory
- Spec or plan documents
- Shaping all child features in this turn
- Skipping Path, or putting it before the inventory / under Constraints
- Inventing Parallel for a shared migration / type / decision
- Dropping a required feature to avoid listing every child
- Dispatching agents
