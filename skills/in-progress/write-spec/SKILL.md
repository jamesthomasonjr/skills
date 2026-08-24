---
name: write-spec
description: >-
  Use when specify-work hands off a spec, or the user wants an
  outcome / MVP In / later-features Out before sizing.
disable-model-invocation: true
---

# Write spec

Announce once: `Using write-spec to sharpen one outcome.`

Sharpen **one** product outcome. This is not class design. This is not
an implementation plan.

**REQUIRED:** Follow [../specify-work/kinds.md](../specify-work/kinds.md)
**HARD-GATE**, **Two kinds**, **Approaches**, **Open decisions**.

## Hard rules

- Emit **Outcome**, **MVP In**, **Later-features Out**, **Approaches**,
  **Open decisions**, **Standards** (labels only). Then **Close**.
- Requirements go In or Out. Standards are labels. Classes are not
  inventory.
- Do not emit classes, providers, **cuts**, Path, or a stacked-PR /
  step list. Cuts are `write-design` after grain.
- Do not invoke `size-work`, `write-design`, or `write-plan`.
- Mixed turn (“spec this then build”): finish **this** document, then
  **hand back**.
- If they dumped a thought process, **separate** it. Do not grill from
  scratch. A mixed dump that mentions classes is **not** the class-list
  stop — separate, do not abort.

## Output contract (in order)

1. **Outcome** — 1–2 sentences. One sharp user-perceivable result.
2. **MVP In** — requirements that ship in the first cut.
3. **Later-features Out** — requirements that wait.
4. **Approaches** — 2–3 bullets (stack / architecture) + pick and why.
   Not inventory, cuts, Path, or vendor options. **REQUIRED:** follow
   [../specify-work/kinds.md](../specify-work/kinds.md) **Approaches**.
   Do not grill.
5. **Open decisions** — ladder + options, not a design essay.
   **REQUIRED:** follow [../specify-work/kinds.md](../specify-work/kinds.md)
   **Open decisions**.
6. **Standards** — labels only (`stacked PRs`, `ISP`, `SOLID`). Do not
   design them.
7. **Close** — **Terminal:** point at `size-work`. Do not invoke it.
   Stop.

## Self-review

Agent check. Fix inline. Do not re-emit this list in the spec.

1. **Placeholders** — no TBD, TODO, or incomplete sections.
2. **In/Out** — later-features stay Out; nothing from Out pulled in.
3. **Spike** — each Open-decision spike has real options + impact.
4. **Approaches** — 2–3 bullets + pick; not a vendor bake-off.
5. **Open decisions** — visibility ladder + options, not a design essay.
6. **Outcome** — 1–2 sentences.

## Separating a dump

If the message already mixes MVP, how, classes, and a plan, put the
sharp outcome, In/Out, Approaches (stack / architecture),
spikes-with-options, and labels here. Leave providers, ISP seams, and
stacked PRs for later leaves. Do not interview around what they
already said.

Follow [../specify-work/kinds.md](../specify-work/kinds.md)
**Compose order** when a re-sent dump already has grain.

## Rationalizations

| Excuse | Reality |
|---|---|
| “Standards are required this turn, so I should design them” | Labels only. |
| “I’ll list the providers so size-work can sequence them” | Classes are not inventory. |
| “Classes appear in the dump, so kinds.md says stop” | Separate. Do not abort. |
| “I’ll keep going — the outcome is already obvious” | Close. Point at `size-work`. Do not invoke it. |
| “I’ll write a spec file under docs/ so we can commit it” | Conversation-only unless they named a sink. |
| “The dump didn’t say picking the service is still open” | Infer. Follow kinds.md **Open decisions**. |

## Failures

- Classes, providers, cuts, or ISP splits in this output
- Standards designed (interfaces, PR lists) instead of labeled
- Path or implementation plan
- Invoking `size-work`, `write-design`, or `write-plan`
- Aborting because the dump mentioned classes
- Auto-continue because the dump named all three jobs
- Grilling from scratch after a mixed dump
- Committing a spec file with no named sink
- Approaches missing, or silent on stack while inferring a vendor spike
- Spike that only says “pick a vendor/API” (no options / no impact)
