---
name: shape-story
description: >-
  Produce a spec-ready user-story brief. Use when size-work hands off a
  user story (including a user-framed bug fix), or the user wants enough
  context for a future agent to write a spec without writing the spec yet.
disable-model-invocation: true
---

# Shape story

Produce a **spec-ready brief** for one user story. Not a spec. Not an implementation.

**REQUIRED:** Follow [../size-work/levels.md](../size-work/levels.md).

## Hard rules

- Do not write a full Spec Kit `spec.md`, Superpowers design doc, or implementation plan.
- Do not implement or scaffold.
- Do not silently split into tasks; if the story is too large, say so and offer split stories or `shape-task` for pure chores.
- Outcomes: follow [../size-work/levels.md](../size-work/levels.md) **Outcomes** — conversation-only unless they named a sink (publish there) or asked for a tracker skill/prompt (hand off after shaping).
- Mixed-turn build request: finish this brief, then hand back.
- Next is `specify-work` / `write-spec` on **this** story. If they
  arrived because they picked story at a genuine ask-once after a
  write-spec blob, that next is still `write-spec` — not
  `write-design`, not Superpowers. This leaf does not emit a
  feature inventory. `write-design` needs one.

## Output contract (in order)

1. **Title**
2. **User story** — As a / I want / so that
3. **Problem & context** — enough for a stranger agent (what exists, what hurts). Cite real code paths only if you inspected them.
4. **Scope** — in / out
5. **Acceptance sketch** — 3–7 bullets of expected behavior (not a full Given/When/Then suite)
6. **Edge cases to explore later** — bullets
7. **Dependencies / assumptions**
8. **Suggested next step** — name `specify-work` / `write-spec`. Do **not** require Superpowers brainstorming, Spec Kit `/speckit.specify`, or mattpocock `/to-spec`. Do **not** run the specify path in this turn unless the user sends a **new** message asking for it after the brief.
9. **Close** — confirm the brief is enough, or ask one clarifying question if a blocker remains. If they named a sink, publish per Outcomes; if they want a tracker skill next, hand off.

## Thin-brief test

If another agent could not start a spec from this brief alone, add context. If you wrote the full spec, delete the spec sections and leave the sketch.

## Rationalizations

| Excuse | Reality |
|---|---|
| “levels.md said write-design after a write-spec blob” | That is the `shape-feature` close. This leaf points at `write-spec`. |
| “I’ll design now; the story brief is enough inventory” | `write-design` needs a feature inventory. This leaf does not emit one. |

## Failures

- Full functional-requirements catalog or prioritized GWT suites
- Implementation in this turn
- Empty “add the thing” brief with no problem/context/acceptance sketch
- Path section (atomic — Path is `shape-epic` / `shape-feature` only)
- Suggested next names Superpowers brainstorming, Spec Kit, or `/to-spec` instead of `specify-work` / `write-spec`
- Announcing `write-design` after this leaf (including after an ask-once from a write-spec blob)
