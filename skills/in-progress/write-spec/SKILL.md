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

- Emit **Outcome**, **MVP In**, **Later-features Out**, **Approaches**,
  **Open decisions**, **Standards** (labels only). Then **stop**.
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
  spec or change In/Out, **or** a just-landed spike pick would change
  Outcome / In / Out or grain (kinds.md **After a spike pick**).
  Otherwise that turn is `write-design`.

## Output contract (in order)

1. **Outcome** — one sharp user-perceivable result.
2. **MVP In** — requirements that ship in the first cut.
3. **Later-features Out** — requirements that wait.
4. **Approaches** — 2–3 **build** alternatives (stack / architecture:
   language, bundler, test runner, page vs framework), trade-offs,
   recommended pick and why. When the dump did not settle a stack,
   the pick includes how we build. Not inventory. Not cuts. Not
   Path. Not vendor options (those are Open decisions). Follow
   [../specify-work/kinds.md](../specify-work/kinds.md) **Approaches**.
   Do not grill.
5. **Open decisions** — infer unanswered external or product
   choices from the **outcome / MVP In**. Do not require the dump
   to name them. Do not wait for cuts. Follow the visibility
   ladder in [../specify-work/kinds.md](../specify-work/kinds.md)
   (`spike` > explained > silent) **without a cut prerequisite**.
   If making the outcome true would use an external vendor/API
   with no vendor in the dump, that is a **spike** unless demoted
   to an explained pick (name the default and why a later spike
   would not change those future cuts). A spike lists **real
   options** (at least two) with short pros/cons, compare/contrast,
   and whether each would change MVP In/Out, grain, later cuts,
   auth, data shape, or tests — not “pick a vendor/API.” A stack
   pick from Approaches is usually **explained** here; it does
   not replace the vendor spike. “Cuts” here means the later
   design would change, not that cuts exist now. Never silent on
   an external vendor/API. Not class names.
6. **Standards** — labels only (`stacked PRs`, `ISP`, `SOLID`). Do not
   design them.
7. **Close** — announce `size-work` as next. **Stop.** Do not invoke it.

## Separating a dump

**Before grain** (or an explicit spec rewrite): if the message already
mixes MVP, how, classes, and a plan, put the sharp outcome,
In/Out, Approaches (stack / architecture), spikes-with-options,
and labels here. Leave providers, ISP seams, and stacked PRs for
later leaves. Do not interview around what they already said.

**After grain:** do not separate a re-sent dump into a second spec
unless they explicitly asked to rewrite the spec or change In/Out,
or a just-landed spike pick would stale Outcome / In / Out or grain.
Otherwise that turn is `write-design` (or `write-plan` if plan-only).

## Rationalizations

| Excuse | Reality |
|---|---|
| “They asked for spec, design, and plan together” | **Before grain** this leaf is the spec. **After grain** this is not your turn unless they asked to rewrite In/Out or a pick would stale it. |
| “Standards are required this turn, so I should design them” | Labels only. |
| “I’ll list the providers so size-work can sequence them” | Classes are not inventory. |
| “Classes appear in the dump, so kinds.md says stop” | Separate. Do not abort. |
| “I’ll keep going — the outcome is already obvious” | Close. Point at `size-work`. Do not invoke it. |
| “Brainstorming would continue into a design doc and writing-plans” | This skill stops. It does not auto-continue. |
| “I’ll write a spec file under docs/ so we can commit it” | Conversation-only unless they named a sink. |
| “The dump didn’t say picking the service is still open” | Infer. External vendor/API with no vendor named is a spike unless demoted. |
| “I’ll stay silent on the vendor/API” | Never silent on an external vendor/API. |
| “No cuts yet, so the ladder does not apply” | False. Infer from the outcome. |
| “Approaches already named a vendor, so the spike can be a one-liner” | Approaches ≠ spike options. List vendor options with impact. |
| “I’ll skip Approaches; the stack is implied by the vendor spike” | Silent on stack while inferring a vendor spike is a failure. |
| “I’ll pick a vendor in Approaches and stay silent in Open decisions” | Naming a vendor in Approaches is not a ladder demote. |

## Failures

- Classes, providers, cuts, or ISP splits in this output
- Standards designed (interfaces, PR lists) instead of labeled
- Path or implementation plan
- Invoking `size-work`, `write-design`, or `write-plan`
- Re-running after grain on a mixed dump without an In/Out rewrite ask
  or a stale-spec spike pick
- Aborting because the dump mentioned classes
- Auto-continue because the dump named all three jobs
- Grilling from scratch after a mixed dump
- Committing a spec file with no named sink
- Omitting an inferred external/API spike because the dump did not name it as open
- Omitting an inferred external spike because cuts do not exist yet
- Silent on an external vendor/API
- Spike that only says “pick a vendor/API” (no options / no impact)
- Approaches missing, or silent on stack while inferring a vendor spike
- Approaches swallows the vendor into a silent / default-without-ladder pick
- Auto-continue into design or plan because Approaches picked a stack
