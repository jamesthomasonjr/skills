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
  on a stale spec. If the pick is **not** stale and they said
  “plan this,” this is your leaf even when no design is in-thread.
  Do not bounce to `write-design` for “next unfinished” or “no
  design yet.” Follow [../specify-work/kinds.md](../specify-work/kinds.md)
  **After a spike pick**.
- The **unit of work is a stacked PR**: one interface + implementation
  + tests, plus a mock / test impl of that interface for dependents.
- Stacked-PR units follow **this design’s cuts** (job-named). Do
  not substitute a dump’s class names for this design’s names.
  If no design is in-thread, still plan one stacked PR per
  collaborator the sized outcome needs; derive those cuts the
  same way `write-design` would (names the job; named types
  and in-cut error types included).
- Do **not** use a 2–5 minute step list as the contract.
- A spike (open product/API decision) stays a separate `shape-task`.
  List it **first**, with the same **options + impact** as the spec’s
  Open decision — not “pick a vendor/API.” It must not swallow the
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
   is responsible for, using **this design’s cut names**.
   **Existing repo → match the house.** GREEN if the File map
   copies the repo’s existing test root, naming, and FP vs
   OO. RED **only** if the plan invents a second convention
   (colocate on a `tests/` house, or distant `tests/` on a
   colocated house). Example of inventing: `src/<Capability>/Provider/`
   + classes against a `tests/` + function-module house. Do
   **not** fail house-style `tests/` or flat `src` on an
   existing-repo prompt.
   **Greenfield / no house → colocate by cut:** capability
   folder first, port + first impl together, tests beside the
   file they cover. Not a distant `tests/` tree. Not a mandatory
   `domain/` / `ports/` / `adapters/` / `views/` tree. Not a flat
   `src/*.ts` dump. Acceptable greenfield nests (do not require
   one spelling): `src/<Capability>/Provider/`,
   `src/<Capability>/<CapabilityProvider>/`,
   `src/<CapabilityProvider>/`. Existing-repo illustration:
   `lib/geo/…` + `tests/geo/…` — match that house. Same shape
   for each cut on greenfield.

   **Named types** and **in-cut errors:** if In, a cut, or
   this File map names a non-primitive, that name exists as
   a class, type, interface, or enum in the **owning cut**.
   Each cut’s error note includes an in-cut error type (or
   enum), not an `errors/` folder. Greenfield colocate;
   house still wins if the repo already has `errors/`.
   Primitive / array / tuple of primitives do not spawn a
   type.

   Scaffold (`package.json`, `vite.config`, `index.html`) can
   sit at the page cut / composition PR. Before the stacked-PR
   list.
3. **Stacked PRs** — one PR per **cut** from the design: that
   interface + impl + tests + mock/test impl for dependents. Each PR
   **names the files it touches**. Name the GitHub stacked-PR
   workflow as the standard, not as inventory.
4. **Close** — cheap self-review (no TBD; file-map paths match the
   PRs; names match the design cuts; named types and in-cut
   error types sit with the cut on greenfield; house still
   wins if the repo already has `errors/`; colocate by cut
   when greenfield; follow the house when a tree already
   exists), then hand back. Do not implement. Do not resize.

## Rationalizations

| Excuse | Reality |
|---|---|
| “Writing-plans uses 2–5 minute TDD steps” | This leaf’s unit is a stacked PR + File map, not a code novel. |
| “I’ll fold the API spike into the first production PR” | Spike stays a `shape-task`. List it first, with options. |
| “Stacked PRs imply the paths” | Emit a File map with exact paths first. |
| “Spike is ‘which vendor/API’” | Carry options + impact from Open decisions. |
| “They named a vendor and said plan, so proceed” | If the pick would change In/Out or grain, stop. Point at `write-spec` → `size-work`. If it would not, this leaf — even with no design yet. |
| “Vendor settled and they said plan this, but there is no design yet, so write-design” | False when the pick is not stale. User label wins. Derive cuts the same way `write-design` would. |
| “Three providers means this is an epic — I’ll re-size” | Do not change grain. |
| “The dump named a class, so that is PR 1” | Use this design’s cuts. Names are not a fixture list. |
| “src/*.ts is simpler” | Greenfield: fail a flat dump. Existing flat-src house: match it. |
| “Tests live in tests/” | Greenfield: tests sit next to the file. Existing repo: match the house. Do not fail `tests/` when that is the house. |
| “Colocate-by-cut always wins” | Only when there is no house. Colocate on a `tests/` house, or distant `tests/` on a colocated house, is a second convention. |
| “domain/ports/adapters/views is the SOLID tree” | Not the only legal tree. Greenfield: colocate by cut. House: match the house. |
| “Every port folder needs package.json” | Scaffold sits at the page cut / composition PR. |
| “I’ll put all failures in errors/” | Greenfield colocate. House still wins if the repo already has `errors/`. |
| “Named types are implied by the cut” | If the File map names it, it exists in the owning cut. |
| “I’ll add the later-feature so the stack is complete” | Out stays Out. |
| “The plan is obvious, so I’ll start the first PR” | Hand back. New message to implement. |
| “They said spec this then build” | Finish the named leaf. Do not build. |

## Failures

- 2–5 minute step list / code novel as the contract
- Spike swallowed into a production PR
- Spike that only says “pick a vendor/API” (no options / no impact)
- Stacked PRs and no paths
- File map is a flat `src/*.ts` dump with every cut in one directory
  (greenfield / no house)
- File map requires `domain/` / `ports/` / `adapters/` / `views/`
  as the only legal tree (greenfield / no house)
- File map requires a distant `tests/` tree (greenfield / no
  house)
- File map is one dump folder that mixes every cut (mixed-cut
  map)
- File map puts owned error types in `errors/` (greenfield /
  no house, and the house does not already use `errors/`)
- File map names a non-primitive with no class / type /
  interface / enum in the owning cut
- File map omits an in-cut error type (or enum)
- File map invents a second convention on an existing-repo
  prompt (colocate on a `tests/` house, or distant `tests/`
  on a colocated house)
- Planning after a pick that would change In/Out or grain
- Bouncing a non-stale “plan this” to `write-design` because no
  design exists yet
- Grain bump, or Out items added to inventory
- Hard-coded dump class names instead of this design’s cuts
- Class list as size-work children
- Implementing in this turn
- Writing a spec or resizing because the plan surfaced new types
