---
name: write-plan
description: >-
  Sequence stacked-PR units. Use when specify-work hands off, or the
  user asks for an implementation plan after grain exists. Does not
  change grain or implement.
disable-model-invocation: true
---

# Write plan

Sequence **stacked PR** units for already-sized work. This is not a
2–5 minute step list. This is not a spec. This is not class design
from scratch.

**REQUIRED:** Follow [../specify-work/kinds.md](../specify-work/kinds.md).

## Hard rules

- **Requires** grain (a sized inventory). “Plan this story/feature
  after grain” still requires grain; it is not a bypass. If grain
  does not exist, **stop** and point at `write-spec` → `size-work`.
  If a just-landed spike pick **would** change Outcome / In / Out or
  grain, **stop**. Point at `write-spec` → `size-work`. Do not plan
  on a stale spec. Follow [../specify-work/kinds.md](../specify-work/kinds.md)
  **After a spike pick**.
- The **unit of work is a stacked PR**: one interface + implementation
  + tests, plus a mock / test impl of that interface for dependents.
- Stacked-PR units follow **this design’s cuts** (the names
  `write-design` chose). Do not hard-code `LocationProvider` or any
  other dump name. If no design is in-thread, still plan one stacked
  PR per collaborator the sized outcome needs; derive those cuts the
  same way `write-design` would.
- Do **not** use a 2–5 minute Superpowers step list as the contract.
- A spike (open product/API decision) stays a separate `shape-task`.
  List it **first**, with the same **options + impact** as the spec’s
  Open decision — not “pick a weather API.” It must not swallow the
  spike into a production implementation PR. Not Approaches (stack).
- Standards live here as **workflow** (stacked PRs, ISP-narrow
  interfaces for dependents). They do not become inventory children
  and they do not bump grain. Follow
  [../specify-work/kinds.md](../specify-work/kinds.md).
- Do not change grain. Do not add Out requirements to inventory.
- Do not implement.
- Outcomes: conversation-only unless they named a sink.
- Mixed turn (“plan this then build”): finish **this** document, then
  **hand back**. They must send a **new** message to build.

## Output contract (in order)

1. **Spike** — if an open product/API decision exists, list it first as
   a separate `shape-task`. Done-when is a decision, not shipped code.
   Carry **real options** (pros/cons, compare/contrast, In/Out / grain
   / cuts / auth / data / tests impact). Not a one-liner. Not the
   Approaches stack bake-off.
2. **File map** — exact paths to create or modify, and what each file
   is responsible for, using **this design’s cut names** (not dump
   names). Before the stacked-PR list.
3. **Stacked PRs** — one PR per **cut** from the design: that
   interface + impl + tests + mock/test impl for dependents. Each PR
   **names the files it touches**. Name the GitHub stacked-PR
   workflow as the standard, not as inventory.
4. **Close** — cheap self-review (no TBD; file-map paths match the
   PRs; names match the design cuts), then hand back. Do not
   implement. Do not resize.

## Rationalizations

| Excuse | Reality |
|---|---|
| “Writing-plans uses 2–5 minute TDD steps” | This leaf’s unit is a stacked PR + File map, not a code novel. |
| “I’ll fold the API spike into the first production PR” | Spike stays a `shape-task`. List it first, with options. |
| “Stacked PRs imply the paths” | Emit a File map with exact paths first. |
| “Spike is ‘which weather API’” | Carry options + impact from Open decisions. |
| “They named a vendor and said plan, so proceed” | If the pick would change In/Out or grain, stop. Point at `write-spec` → `size-work`. |
| “Three providers means this is an epic — I’ll re-size” | Do not change grain. |
| “The dump said LocationProvider, so that is PR 1” | Use this design’s cuts. Names are not a fixture list. |
| “I’ll add the 10-day slice so the stack is complete” | Out stays Out. |
| “The plan is obvious, so I’ll start the first PR” | Hand back. New message to implement. |
| “They said spec this then build” | Finish the named leaf. Do not build. |

## Failures

- 2–5 minute step list / code novel as the contract
- Spike swallowed into a production PR
- Spike that only says “pick a weather API” (no options / no impact)
- Stacked PRs and no paths
- Planning after a pick that would change In/Out or grain
- Grain bump, or Out items added to inventory
- Hard-coded dump class names instead of this design’s cuts
- Class list as size-work children
- Implementing in this turn
- Writing a spec or resizing because the plan surfaced new types
