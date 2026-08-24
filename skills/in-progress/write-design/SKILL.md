---
name: write-design
description: >-
  Design interfaces and first implementations for already-sized work.
  Use when specify-work hands off, or the user asks to design a
  story/feature after grain exists. Derives cuts from the sized
  outcome. Does not resize or write the implementation plan.
disable-model-invocation: true
---

# Write design

Derive **how** the already-sized work fits together. This leaf does
the class-design job. The user does not have to list classes.

**REQUIRED:** Follow [../specify-work/kinds.md](../specify-work/kinds.md).

## Hard rules

- **Requires** grain (a sized inventory). “Design this story/feature
  after grain” still requires grain; it is not a bypass.
- If grain does not exist, **stop** and point at `write-spec` →
  `size-work`. Do not emit What / Steps / Cuts. Same letter as
  `write-plan`. A plain “design this” with no class list still bounces.
- If a just-landed spike pick **would** change Outcome / In / Out or
  grain, **stop**. Point at `write-spec` → `size-work`. Do not design
  on a stale spec. If the pick is **not** stale and they said
  “plan this” (only), this is **not** your leaf — even when no
  design exists yet. Follow [../specify-work/kinds.md](../specify-work/kinds.md)
  **After a spike pick**.
- **Derive** steps and cuts from the sized work. Do not wait for the
  user to list classes. Do not copy a dump’s class list as the design.
- If they *did* dump a class list, treat it as a **hint**, not required
  inventory and not a substitute for deriving cuts from the sized work.
- Follow [../specify-work/kinds.md](../specify-work/kinds.md). Cuts are
  design. They are never size-work inventory. Later-feature seams
  (ISP) are notes, not new children.
- Do not resize. Do not move Out requirements into In. Do not add
  stories, features, or Path.
- Do not write the implementation plan. A plan needs a **new** message.
- Do not implement.
- Outcomes: conversation-only unless they named a sink.
- Mixed turn (“design this then build” / “design then plan”): finish
  **this** document, then **hand back**.

## Output contract (in order)

1. **What** — the sized outcome. Do not change In/Out.
2. **Steps** — what must happen to make What true. No class names
   required here.
3. **Cuts** — one entry per collaborator: interface, first
   implementation, who depends on it, why it is thin or fat, **error
   / failure** states that cut owns, and **how that cut is tested**
   (what is faked vs real). Short notes, not test code, not a plan,
   not stories. Current inventory only. Well-defined SOLID cuts, not
   a grab bag of helpers. Names **the job**: a reader with only the
   file map must know what the cut does. Role + adapter is fine.
   TypeScript-style is fine. Do not use poetry or cute one-word
   names (`Here`, `Place`, `TodayBoard`, `ComposeToday`, `Till`,
   `Gold`). If an existing repo already names the job (functions
   or types), follow those house names. Do not invent a class
   / Provider family against a function-module house. A user
   class list remains a hint. Do not pull Out in to “prove”
   error paths.

   **Named types:** If In, a cut, or the File map names a
   non-primitive collaborator or data type, that name must
   exist as a class, type, interface, or enum in the
   **owning cut**. Language picks the shape (TS type is
   fine for an anemic DTO). Primitive / array / tuple of
   primitives do not spawn a type. Not a new cut unless it
   has interface + first impl + error/test notes. Not the
   name Receipt. Catalog stays out (we never named it).
   Money stays out unless In says more than one currency.

   **In-cut errors:** Each cut’s error note includes an
   in-cut error type (or enum), not an `errors/` folder.
   Greenfield colocate; house still wins if the repo
   already has `errors/`.
4. **Later-feature seams** — how Out work would widen a cut (thin now,
   fat adapter later). Notes, **not** inventory. Do not pull Out into
   inventory to “prove” ISP.
5. **Close** — hand back. Do not write the plan. Do not resize.

Every cut has an interface, a first implementation, an error note
that includes an in-cut error type (or enum), and a test note.
Interface + first impl name the job. Cuts must cover the sized
outcome. If a cut is not split (not thin), write why.

## Rationalizations

| Excuse | Reality |
|---|---|
| “They didn’t list classes, so I cannot design” | Derive cuts from the sized work. |
| “They dumped a class list, so that is the design” | Hint only. Derive from the sized outcome. |
| “Here / Place / TodayBoard is shorter” | Fail cute one-word / poetry names. Name the job. |
| “That dump token is the SOLID name” | Follow the house. Function modules stay functions. |
| “They dumped classes first, so start there” | No grain. Point at `write-spec` → `size-work`. |
| “Design this — no grain, but they didn’t list classes” | Still no grain. Stop. |
| “I’ll add the later-feature so the ISP seam is real” | Seams are notes. Out stays Out. |
| “This should be an epic now that we have three cuts” | Do not resize. Cuts are not children. |
| “I’ll write the stacked-PR plan while the types are fresh” | New message. This leaf is design. |
| “They named a vendor and said design, so proceed” | If the pick would change In/Out or grain, stop. Point at `write-spec` → `size-work`. If they said “plan this” and the pick is not stale, that is `write-plan`. |
| “Vendor settled and they said plan this, but there is no design yet, so write-design” | False when the pick is not stale. User label wins. |
| “Errors wait for the class list / the plan” | The error note includes an in-cut error type (or enum) now. |
| “The note is enough; the type waits for impl” | The note includes the type. |
| “I’ll put all failures in errors/” | Greenfield colocate. House still wins if the repo already has `errors/`. |
| “It’s just a string on the page” | If In names it, it exists in the owning cut. |
| “I’ll invent extra domain types to be complete” | Primitive / array / tuple of primitives do not spawn a type. Catalog stays out. Money stays out unless In says more than one currency. |
| “I’ll pull the later-feature in so the failed-fetch path is real” | Out stays Out. Error notes are not stories. |

## Failures

- Waiting for a class list, or copying a dump’s list as the design
- Designing before grain (plain “design this” or a class dump)
- Cuts without an interface + first impl
- Cute / poetry / one-word cut names that do not name the job
- Inventing class / Provider names against an existing function-module house
- A cut with interface + impl but no error note and no test note
- Error notes that omit an in-cut error type (or enum)
- A name in In / a cut / the File map with no class / type /
  interface / enum in the owning cut
- Error types in an `errors/` folder on greenfield when the
  house does not already use `errors/`
- Designing after a pick that would change In/Out or grain
- Taking a non-stale “plan this” because no design exists yet
- Adding Out items to inventory
- Resizing or writing Path
- Implementation plan or 2–5 minute steps
- Class list treated as size-work inventory
- Implementing
