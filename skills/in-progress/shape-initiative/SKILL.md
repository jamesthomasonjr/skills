---
name: shape-initiative
description: >-
  Use when size-work hands off initiative-level work, or the user
  asks to break a program or multi-quarter theme into epics.
disable-model-invocation: true
---

# Shape initiative

Announce once: `Using shape-initiative to inventory epics.`

Turn an initiative-scale description into a charter and an **epic inventory**. One level only.

**REQUIRED:** Follow [../size-work/levels.md](../size-work/levels.md)
**HARD-GATE**, **Inventory**.

## Hard rules

- Emit **epics** (title + one-liner + order). Do not emit features, stories, tasks, or specs.
- Do not write H1/H2/H3 delivery plans, staffing models, or implementation plans.
- Do not implement.
- Outcomes: follow [../size-work/levels.md](../size-work/levels.md) **Outcomes**.
- Mixed-turn build request: finish this shape, then hand back.

## Output contract (in order)

1. **Title** — working name
2. **Outcome** — 2–4 sentences, why this initiative exists
3. **Boundaries** — in scope / out of scope at initiative grain
4. **Success signals** — measurable outcomes, not implementation
5. **Constraints** — known dependencies, bets, non-negotiables
6. **Epic inventory** — one child per outcome / pillar; each: title, one-liner, priority/order. No nested features. Follow [../size-work/levels.md](../size-work/levels.md) **Inventory**.
7. **Close** — **Terminal:** ask which epic to shape next (`shape-epic`), or stop. Do not invoke `shape-epic`. If they named a sink, publish per Outcomes; if they want a tracker skill next, hand off.

## Self-review

Agent check. Fix inline. Do not re-emit this list.

1. **Placeholders** — no TBD, TODO, or incomplete sections.
2. **One level** — epics only; no features or stories.
3. **Inventory** — journeys / domains; no pad-to-N or merge-to-fit-N.
4. **Close** — hands back; does not shape the next epic.

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
- pad-to-N or merge-to-fit-N on inventory
- Cascading into shaping every epic in this turn
