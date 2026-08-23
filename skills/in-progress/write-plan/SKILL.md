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

- **Requires** grain (sized inventory, or an explicit “plan this
  story/feature” after grain exists). If grain does not exist, **stop**
  and point at `write-spec` → `size-work`.
- The **unit of work is a stacked PR**: one interface + implementation
  + tests, plus a mock / test impl of that interface for dependents.
- Do **not** use a 2–5 minute Superpowers step list as the contract.
- A spike (open product/API decision) stays a separate `shape-task`.
  The plan may list it **first**. It must not swallow the spike into a
  production implementation PR.
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
2. **Stacked PRs** — one PR per interface: interface + impl + tests +
   mock/test impl for dependents. Name the GitHub stacked-PR workflow
   as the standard, not as inventory.
3. **Close** — hand back. Do not implement. Do not resize.

## Rationalizations

| Excuse | Reality |
|---|---|
| “Writing-plans uses 2–5 minute TDD steps” | This leaf’s unit is a stacked PR. |
| “I’ll fold the API spike into the first production PR” | Spike stays a `shape-task`. List it first. |
| “Three providers means this is an epic — I’ll re-size” | Do not change grain. |
| “I’ll add the 10-day slice so the stack is complete” | Out stays Out. |
| “The plan is obvious, so I’ll start the first PR” | Hand back. New message to implement. |
| “They said spec this then build” | Finish the named leaf. Do not build. |

## Failures

- 2–5 minute step list as the contract
- Spike swallowed into a production PR
- Grain bump, or Out items added to inventory
- Class list as size-work children
- Implementing in this turn
- Writing a spec or resizing because the plan surfaced new types
