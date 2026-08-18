---
name: shape-task
description: >-
  Produce a brief for an atomic engineering task. Use when size-work hands
  off task-level work, or the user explicitly wants a chore sized without
  a fake user story.
disable-model-invocation: true
---

# Shape task

Produce an **implement-ready brief** for an atomic engineering chore. Not a user story. Not implementation.

**REQUIRED:** Follow [../size-work/levels.md](../size-work/levels.md).

## Hard rules

- Do **not** wrap the chore in a fake As a / I want / so that.
- Do not implement or edit application code in this turn — even if the user said “then start doing it.”
- Do not inflate into a feature or epic.
- Outcomes: follow [../size-work/levels.md](../size-work/levels.md) **Outcomes** — conversation-only unless they named a sink (publish there) or asked for a tracker skill/prompt (hand off after shaping).
- Mixed-turn build request: finish this brief, then **hand back**. They must send a new message to implement.

## Output contract (in order)

1. **Title** — imperative chore name
2. **Goal** — one paragraph
3. **Why** — risk of not doing it / what it unblocks
4. **Done when** — 3–7 concrete checks
5. **Steps sketch** — ordered bullets (no full patch)
6. **Risks** — blast radius, expand-contract needs, missing targets
7. **Close** — hand back; offer implement / writing-plans on a **new** message. If they named a sink, publish per Outcomes; if they want a tracker skill next, hand off.

## If the target does not exist

Say so. Still produce the brief from the description. Do not invent a codebase to edit. Do not implement.

## Failures

- Fake user story
- Editing files in this turn
- Expanding into a feature inventory
