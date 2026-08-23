---
name: write-spec
description: >-
  Sharpen one product outcome. Use when specify-work hands off, or the
  user wants an outcome / MVP In / later-features Out before sizing.
  Does not design classes or write a plan.
disable-model-invocation: true
---

# Write spec

Sharpen **one** product outcome. This is not class design. This is not
an implementation plan.

**REQUIRED:** Follow [../specify-work/kinds.md](../specify-work/kinds.md).

## Hard rules

- Emit **Outcome**, **MVP In**, **Later-features Out**, **Open decisions**,
  **Standards** (labels only). Then **stop**.
- Follow [../specify-work/kinds.md](../specify-work/kinds.md). Requirements
  go In or Out. Standards are labels. Classes are not inventory.
- Do not emit classes, providers, **cuts**, Path, or a stacked-PR /
  step list. Cuts are `write-design` after grain.
- Do not invoke `size-work`, `write-design`, or `write-plan`. Announce
  `size-work` as next, then **stop**.
- Do not implement.
- Outcomes: conversation-only unless they named a sink.
- Mixed turn (“spec this then build”): finish **this** document, then
  **hand back**. They must send a new message for design, plan, size,
  or build.
- **Before grain** (or an explicit spec rewrite): if they dumped a
  thought process, **separate** it. Do not grill from scratch. A mixed
  dump that mentions classes is **not** the class-list stop — separate,
  do not abort.
- **After grain:** do not run this leaf on a re-sent mixed dump /
  “spec, design, and plan” unless they explicitly asked to rewrite the
  spec or change In/Out. That turn is `write-design`.

## Output contract (in order)

1. **Outcome** — one sharp user-perceivable result.
2. **MVP In** — requirements that ship in the first cut.
3. **Later-features Out** — requirements that wait (URL-query location,
   multi-day forecast, …).
4. **Open decisions** — spikes (product/API questions). Not class names.
5. **Standards** — labels only (`stacked PRs`, `ISP`, `SOLID`). Do not
   design them.
6. **Close** — announce `size-work` as next. **Stop.** Do not invoke it.

## Separating a dump

**Before grain** (or an explicit spec rewrite): if the message already
mixes MVP, how, classes, and a plan, put the sharp outcome and
In/Out/spikes/labels here. Leave how, providers, ISP seams, and
stacked PRs for later leaves. Do not interview around what they
already said.

**After grain:** do not separate a re-sent dump into a second spec
unless they explicitly asked to rewrite the spec or change In/Out.
That turn is `write-design` (or `write-plan` if plan-only).

## Rationalizations

| Excuse | Reality |
|---|---|
| “They asked for spec, design, and plan together” | **Before grain** this leaf is the spec. **After grain** this is not your turn unless they asked to rewrite In/Out. |
| “Standards are required this turn, so I should design them” | Labels only. |
| “I’ll list the providers so size-work can sequence them” | Classes are not inventory. |
| “Classes appear in the dump, so kinds.md says stop” | Separate. Do not abort. |
| “I’ll keep going — the outcome is already obvious” | Close. Point at `size-work`. Do not invoke it. |
| “Brainstorming would continue into a design doc and writing-plans” | This skill stops. It does not auto-continue. |
| “I’ll write a spec file under docs/ so we can commit it” | Conversation-only unless they named a sink. |

## Failures

- Classes, providers, cuts, or ISP splits in this output
- Standards designed (interfaces, PR lists) instead of labeled
- Path or implementation plan
- Invoking `size-work`, `write-design`, or `write-plan`
- Re-running after grain on a mixed dump without an In/Out rewrite ask
- Aborting because the dump mentioned classes
- Auto-continue because the dump named all three jobs
- Grilling from scratch after a weather-style dump
- Committing a spec file with no named sink
