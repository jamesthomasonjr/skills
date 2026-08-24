---
name: shape-task
description: >-
  Use when size-work hands off task-level work, or the user wants a
  chore, known bug, or spike at task grain.
disable-model-invocation: true
---

# Shape task

Announce once: `Using shape-task to brief one chore or spike.`

Produce an **implement-ready or decide-ready brief** for an atomic engineering chore, tech-debt item, **known bug** with a clear locus, or **spike** with one clear question. Not a user story. Not implementation. Not diagnosis of an unknown failure. Not a multi-question research map.

**REQUIRED:** Follow [../size-work/levels.md](../size-work/levels.md)
**HARD-GATE**.

## Hard rules

- Do **not** wrap the chore, bug fix, or spike in a fake As a / I want / so that.
- Do not implement or edit application code in this turn — even if the user said “then start doing it.”
- Do not inflate into a feature or epic.
- If the failure is vague or has no locus, do not shape — send back to `size-work` / diagnosing-triage handoff.
- If research is foggy or multi-question, do not shape — send back to `size-work` / wayfinder-research-grill handoff.
- Spikes produce a **decision**, not a shipped feature. Do not start the real implementation in this turn.
- Outcomes: follow [../size-work/levels.md](../size-work/levels.md) **Outcomes**.
- Mixed-turn build request: finish this brief, then **hand back**. They must send a new message to implement (or to run a prototype skill after a spike brief).

## Output contract — default (chore / known bug)

1. **Title** — imperative chore or fix name
2. **Goal** — one paragraph (for bugs: expected vs actual in one or two sentences)
3. **Why** — risk of not doing it / what it unblocks
4. **Done when** — 3–7 concrete checks (for bugs: include repro gone / regression check)
5. **Steps sketch** — ordered bullets (no full patch)
6. **Risks** — blast radius, expand-contract needs, missing targets
7. **Close** — **Terminal:** hand back; offer implement on a **new** message. Do not offer Superpowers writing-plans. If they named a sink, publish per Outcomes; if they want a tracker skill next, hand off.

## Output contract — spike flavor

Use when the router passed `flavor: spike`, or the description is a spike / single-question investigation (a stated time box is **not** required).

1. **Title** — `Spike: …`
2. **Question** — the single decision or learning this spike must answer
3. **Time box** — hours or days; if the user did not give one, **propose** a default (e.g. half-day or 1 day) and proceed
4. **Why** — which story, feature, or epic this answer unblocks
5. **Done when** — written answer, options considered, and a recommendation (not “code shipped”)
6. **Out of scope** — no production feature work inside the spike
7. **Approach sketch** — how you’ll learn (read code/docs, spike branch, prototype) — bullets only
8. **Close** — **Terminal:** hand back. Follow
   [../specify-work/kinds.md](../specify-work/kinds.md) **After a
   spike pick** for the next named leaf; do not invoke it. Do **not**
   offer Superpowers writing-plans. Do **not** offer “implement the
   feature” as the default close. If they named a sink, publish per
   Outcomes.

## Self-review

Agent check. Fix inline. Do not re-emit this list.

1. **Placeholders** — no TBD, TODO, or incomplete sections.
2. **No fake story** — no As a / I want / so that wrapper.
3. **Spike done-when** — a decision, not shipped production code.
4. **Close** — hands back; does not implement or offer writing-plans.
5. **No Path** — Path is `shape-epic` / `shape-feature` only.

## If the target does not exist

Say so. Still produce the brief from the description. Do not invent a codebase to edit. Do not implement.

## Failures

- Fake user story
- Editing files in this turn
- Expanding into a feature inventory
- Path section (atomic — Path is `shape-epic` / `shape-feature` only)
- Diagnosing an unknown intermittent failure here instead of handing off
- Charting a multi-question research map here instead of handing off
- Treating spike “done when” as shipped production code
- Offering Superpowers writing-plans as the next step
- After a vendor spike, skipping kinds.md **After a spike pick** (or invoking the next leaf)
