---
name: write-design
description: >-
  Use when specify-work hands off a design, or the user asks to
  design a story or feature after grain exists.
disable-model-invocation: true
---

# Write design

Announce once: `Using write-design to cut the sized work.`

Derive **how** the already-sized work fits together. This leaf does
the class-design job. The user does not have to list classes.

**REQUIRED:** Follow [../specify-work/kinds.md](../specify-work/kinds.md)
**HARD-GATE**, **Class lists**.

## Hard rules

- **Grain-stop:** requires a sized inventory. If grain does not exist,
  **stop** and point at `write-spec` → `size-work`. Do not emit
  What / Steps / Cuts. A plain “design this” with no class list
  still bounces.
- Follow [../specify-work/kinds.md](../specify-work/kinds.md)
  **After a spike pick**.
- **Derive** steps and cuts from the sized work. Do not wait for the
  user to list classes. Do not copy a dump’s class list as the design.
- If they *did* dump a class list, treat it as a **hint**, not required
  inventory and not a substitute for deriving cuts from the sized work.
- Cuts are design. They are never size-work inventory. Later-feature
  seams (ISP) are notes, not new children.
- Do not resize. Do not move Out requirements into In. Do not add
  stories, features, or Path.
- Do not write the implementation plan. Do not implement.
- Mixed turn (“design this then build” / “design then plan”): finish
  **this** document, then **hand back**.

## Output contract (in order)

1. **What** — the sized outcome. Do not change In/Out.
2. **Steps** — what must happen to make What true. No class names
   required here.
3. **Cuts** — one entry per collaborator. Short notes: **what it
   does / how you use it / what it depends on**, plus error /
   failure states and how that cut is tested (faked vs real).
   Current inventory only. **REQUIRED:** follow
   [../specify-work/kinds.md](../specify-work/kinds.md) **Class
   lists** (job names, named types, in-cut errors). Do not pull
   Out in to “prove” error paths.
4. **Later-feature seams** — how Out work would widen a cut (thin now,
   fat adapter later). Notes, **not** inventory.
5. **Close** — **Terminal:** hand back. Do not write the plan. Do not
   resize.

## Self-review

Agent check. Fix inline. Do not re-emit this list in the design.

1. **Placeholders** — no TBD, TODO, or incomplete sections.
2. **In/Out** — not mutated; nothing from Out pulled in.
3. **Cut test** — each cut states what it does / how you use it /
   what it depends on, plus an error note with an in-cut type and
   how it is tested.
4. **Job names** — interface + first impl name the job.
5. **Mentioned types** — a name in In or a cut exists in the
   owning cut. Do not invent extra types. File map is `write-plan`.
6. **Coverage** — cuts cover the sized outcome. If a cut is not
   split (not thin), write why.

## Rationalizations

| Excuse | Reality |
|---|---|
| “They didn’t list classes, so I cannot design” | Derive cuts from the sized work. |
| “They dumped a class list, so that is the design” | Hint only. Derive from the sized outcome. |
| “A one-word name is shorter” | Fail cute one-word / poetry names. Name the job. |
| “They dumped classes first, so start there” | No grain. Point at `write-spec` → `size-work`. |
| “Design this — no grain, but they didn’t list classes” | Still no grain. Stop. |
| “I’ll add the later-feature so the ISP seam is real” | Seams are notes. Out stays Out. |
| “I’ll write the stacked-PR plan while the types are fresh” | New message. This leaf is design. |

## Failures

- Waiting for a class list, or copying a dump’s list as the design
- Designing before grain (plain “design this” or a class dump)
- Cuts without what/how-use/depends, error note, or test note
- Cute / poetry / one-word cut names that do not name the job
- Adding Out items to inventory
- Resizing or writing Path
- Implementation plan or 2–5 minute steps
- Implementing
