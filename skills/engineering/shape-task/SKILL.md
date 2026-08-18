---
name: shape-task
description: >-
  Produce a brief for an atomic engineering task, chore, tech-debt item,
  known bug fix, or time-boxed spike/research question. Use when size-work
  hands off task-level work, or the user explicitly wants a chore, bug, or
  spike sized without a fake user story.
disable-model-invocation: true
---

# Shape task

Produce an **implement-ready or decide-ready brief** for an atomic engineering chore, tech-debt item, **known bug** with a clear locus, or **spike** with one clear question. Not a user story. Not implementation. Not diagnosis of an unknown failure. Not a multi-question research map.

**REQUIRED:** Follow [../size-work/levels.md](../size-work/levels.md).

## Hard rules

- Do **not** wrap the chore, bug fix, or spike in a fake As a / I want / so that.
- Do not implement or edit application code in this turn — even if the user said “then start doing it.”
- Do not inflate into a feature or epic.
- If the failure is vague or has no locus, do not shape — send back to `size-work` / diagnosing-triage handoff.
- If research is foggy or multi-question, do not shape — send back to `size-work` / wayfinder-research-grill handoff.
- Spikes produce a **decision**, not a shipped feature. Do not start the real implementation in this turn.
- Outcomes: follow [../size-work/levels.md](../size-work/levels.md) **Outcomes** — conversation-only unless they named a sink (publish there) or asked for a tracker skill/prompt (hand off after shaping).
- Mixed-turn build request: finish this brief, then **hand back**. They must send a new message to implement (or to run a prototype skill after a spike brief).

## Output contract — default (chore / known bug)

1. **Title** — imperative chore or fix name
2. **Goal** — one paragraph (for bugs: expected vs actual in one or two sentences)
3. **Why** — risk of not doing it / what it unblocks
4. **Done when** — 3–7 concrete checks (for bugs: include repro gone / regression check)
5. **Steps sketch** — ordered bullets (no full patch)
6. **Risks** — blast radius, expand-contract needs, missing targets
7. **Close** — hand back; offer implement / writing-plans on a **new** message. If they named a sink, publish per Outcomes; if they want a tracker skill next, hand off.

## Output contract — spike flavor

Use when the router passed `flavor: spike`, or the description is clearly a time-boxed investigation.

1. **Title** — `Spike: …`
2. **Question** — the single decision or learning this spike must answer
3. **Time box** — hours or days
4. **Why** — which story, feature, or epic this answer unblocks
5. **Done when** — written answer, options considered, and a recommendation (not “code shipped”)
6. **Out of scope** — no production feature work inside the spike
7. **Approach sketch** — how you’ll learn (read code/docs, spike branch, prototype) — bullets only
8. **Close** — hand back; next message may run the spike, a prototype skill, or writing-plans. If they named a sink, publish per Outcomes.

## If the target does not exist

Say so. Still produce the brief from the description. Do not invent a codebase to edit. Do not implement.

## Failures

- Fake user story
- Editing files in this turn
- Expanding into a feature inventory
- Diagnosing an unknown intermittent failure here instead of handing off
- Charting a multi-question research map here instead of handing off
- Treating spike “done when” as shipped production code
