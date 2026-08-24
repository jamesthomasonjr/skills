---
name: shape-epic
description: >-
  Use when size-work hands off epic-level work, or the user asks
  to break an epic into features.
disable-model-invocation: true
---

# Shape epic

Announce once: `Using shape-epic to inventory features.`

Turn an epic-scale description into a brief and a **feature inventory**. One level only.

**REQUIRED:** Follow [../size-work/levels.md](../size-work/levels.md)
**HARD-GATE**, **Inventory** and [../size-work/paths.md](../size-work/paths.md).

## Hard rules

- Emit **features** (title + one-liner + order). Do not emit stories, tasks, or specs.
- Do not write implementation plans or file-path task lists.
- Do not implement.
- Follow [../size-work/paths.md](../size-work/paths.md). Emit **Path** after the feature inventory. Do not dispatch agents.
- Outcomes: follow [../size-work/levels.md](../size-work/levels.md) **Outcomes**.
- Mixed-turn build or dispatch request: finish this shape, then **hand back**.

## Output contract (in order)

1. **Title**
2. **Outcome** — 1–2 sentences; what coherent result this epic delivers
3. **Boundaries** — in / out at epic grain
4. **Success signals**
5. **Constraints / dependencies**
6. **Feature inventory** — one child per domain / capability; each: title, one-liner, priority/order. No nested stories. Do not reshuffle this order to match Path. Follow [../size-work/levels.md](../size-work/levels.md) **Inventory**.
7. **Path** — **REQUIRED:** follow [../size-work/paths.md](../size-work/paths.md). Inventory items only. Do not dispatch.
8. **Close** — **Terminal:** ask which feature to shape next (`shape-feature`), or stop. Do not invoke `shape-feature`. If they named a sink, publish per Outcomes; if they want a tracker skill next, hand off. Mixed-turn build or dispatch request: **hand back**.

## Self-review

Agent check. Fix inline. Do not re-emit this list.

1. **Placeholders** — no TBD, TODO, or incomplete sections.
2. **One level** — features only; no stories.
3. **Path** — after the inventory; follows paths.md.
4. **Close** — hands back; does not shape every child feature.
5. **No dispatch** — Parallel or `None` is enough.

## Rationalizations

| Excuse | Reality |
|---|---|
| “Stories are more actionable” | Feature grain first. Stories come after `shape-feature`. |
| “One feature is really the whole epic” | Then reclassify with `size-work`; don’t smuggle stories up. |
| “I’ll draft acceptance tests” | Forbidden at epic grain. |
| “I’ll skip Path until they pick a feature” | Path is part of this shape, after the inventory. |
| “These features can all start; I’ll dispatch” | Write Parallel or `None`. Do not dispatch. |

## Failures

- User stories or Given/When/Then in the inventory
- Spec or plan documents
- Shaping all child features in this turn
- Skipping Path, or putting it before the inventory / under Constraints
- pad-to-N or merge-to-fit-N on inventory
- Dispatching agents
