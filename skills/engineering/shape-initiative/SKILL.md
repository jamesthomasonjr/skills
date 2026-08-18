---
name: shape-initiative
description: >-
  Shape an initiative charter and epic inventory. Use when size-work hands
  off initiative-level work, or the user explicitly asks to break a program
  or multi-quarter theme into epics.
disable-model-invocation: true
---

# Shape initiative

Turn an initiative-scale description into a charter and an **epic inventory**. One level only.

**REQUIRED:** Follow [../size-work/levels.md](../size-work/levels.md).

## Hard rules

- Emit **epics** (title + one-liner + order). Do not emit features, stories, tasks, or specs.
- Do not write H1/H2/H3 delivery plans, staffing models, or implementation plans.
- Do not implement.
- Outcomes: follow [../size-work/levels.md](../size-work/levels.md) **Outcomes** (conversation default; named sink only; else hand off to tracker skill/prompt).
- Mixed-turn build request: finish this shape, then hand back.

## Output contract (in order)

1. **Title** — working name
2. **Outcome** — 2–4 sentences, why this initiative exists
3. **Boundaries** — in scope / out of scope at initiative grain
4. **Success signals** — measurable outcomes, not implementation
5. **Constraints** — known dependencies, bets, non-negotiables
6. **Epic inventory** — 3–9 epics; each: title, one-liner, priority/order. No nested features.
7. **Close** — ask which epic to shape next (`shape-epic`), or stop. If they named a sink, publish per Outcomes; if they want a tracker skill next, hand off.

## Rationalizations

| Excuse | Reality |
|---|---|
| “Pillars are clearer than epics” | This family’s child grain is epics. Rename pillars to epics. |
| “They need a year plan” | Sequencing epics by priority is enough. No horizon narrative. |
| “I’ll add a few example stories” | Skipping levels. Stop at epics. |
| “A thin spec per pillar helps” | Specs are out of band. Inventory only. |

## Failures

- Features or stories in the inventory
- Full spec or design doc
- Cascading into shaping every epic in this turn
