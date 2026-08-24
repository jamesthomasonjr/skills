---
name: write-plan
description: >-
  Use when specify-work hands off a plan, or the user asks for an
  implementation plan after grain exists.
disable-model-invocation: true
---

# Write plan

Announce once: `Using write-plan to sequence stacked PRs.`

Sequence **stacked PR** units for already-sized work. This is not a
2–5 minute step list. This is not a spec. This is not class design
from scratch.

**REQUIRED:** Follow [../specify-work/kinds.md](../specify-work/kinds.md)
**HARD-GATE**, **File map**, **Open decisions**.

## Hard rules

- **Grain-stop:** requires a sized inventory. If grain does not exist,
  **stop** and point at `write-spec` → `size-work`.
- Follow [../specify-work/kinds.md](../specify-work/kinds.md)
  **After a spike pick**.
- The **unit of work is a stacked PR**: one interface + implementation
  + tests, plus a mock / test impl of that interface for dependents.
- Stacked-PR units follow **this design’s cuts** (job-named). If no
  design is in-thread, derive those cuts the same way `write-design`
  would. Follow [../specify-work/kinds.md](../specify-work/kinds.md)
  **Class lists**.
- Do **not** use a 2–5 minute step list as the contract.
- A spike stays a separate `shape-task`. List it **first**, with
  options + impact. Follow
  [../specify-work/kinds.md](../specify-work/kinds.md) **Open
  decisions**.
- Standards live here as **workflow**. They do not become inventory
  children and they do not bump grain.
- Do not change grain. Do not add Out requirements to inventory.
- Do not implement.
- Mixed turn (“plan this then build”): finish **this** document, then
  **hand back**.

## Output contract (in order)

1. **Spike** — if an open product/API decision exists, list it first
   as a separate `shape-task` with options + impact. Done-when is a
   decision, not shipped code. **REQUIRED:** follow
   [../specify-work/kinds.md](../specify-work/kinds.md) **Open
   decisions**.
2. **File map** — exact paths to create or modify, and what each file
   is responsible for. **REQUIRED:** follow
   [../specify-work/kinds.md](../specify-work/kinds.md) **File map**.
   House still wins; an unwieldy house file the plan already touches
   may split.
3. **Stacked PRs** — one PR per **cut** from the design: that
   interface + impl + tests + mock/test impl for dependents. Each PR
   **names the files it touches**.
4. **Close** — **Terminal:** hand back. Do not implement. Do not
   resize.

## Self-review

Agent check. Fix inline. Do not re-emit this list in the plan.

1. **Placeholders** — no TBD, TODO, or incomplete sections.
2. **File map** — exact paths match the stacked PRs and the house.
3. **House split** — an unwieldy house file already being touched
   may split; do not invent a second convention or split untouched
   files.
4. **Spike** — listed first with options + impact, not a one-liner.
5. **Names** — PR files and types match this design’s cuts; mentioned
   types and in-cut errors sit with the owning cut.
6. **In/Out** — nothing from Out pulled in; grain unchanged.

## Rationalizations

| Excuse | Reality |
|---|---|
| “Writing-plans uses 2–5 minute TDD steps” | This leaf’s unit is a stacked PR + File map, not a code novel. |
| “I’ll fold the API spike into the first production PR” | Spike stays a `shape-task`. List it first, with options. |
| “Stacked PRs imply the paths” | Emit a File map with exact paths first. |
| “I’ll start splitting files I’m not touching” | House wins. Split only an unwieldy file this plan already touches. |
| “The dump named a class, so that is PR 1” | Use this design’s cuts. |
| “The plan is obvious, so I’ll start the first PR” | Hand back. New message to implement. |

## Failures

- 2–5 minute step list / code novel as the contract
- Spike swallowed into a production PR
- Spike that only says “pick a vendor/API” (no options / no impact)
- Stacked PRs and no paths
- Planning before grain
- Grain bump, or Out items added to inventory
- Implementing in this turn
