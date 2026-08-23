---
name: write-design
description: >-
  Design interfaces and providers. Use when specify-work hands off, or
  the user asks to design a story/feature after grain exists. Does not
  resize or write the implementation plan.
disable-model-invocation: true
---

# Write design

Design **how** the already-sized work fits together. This is the
class-design skill.

**REQUIRED:** Follow [../specify-work/kinds.md](../specify-work/kinds.md).

## Hard rules

- **Requires** a sized inventory, or an explicit “design this
  story/feature” after grain exists.
- If they dump classes **before** sizing, **stop**. Point at
  `write-spec` → `size-work`. Do not treat the list as inventory.
- Follow [../specify-work/kinds.md](../specify-work/kinds.md). Later-feature
  seams (ISP) are design notes, not new inventory children.
- Do not resize. Do not move Out requirements into In. Do not add
  stories, features, or Path.
- Do not write the implementation plan. A plan needs a **new** message.
- Do not implement.
- Outcomes: conversation-only unless they named a sink.
- Mixed turn (“design this then build” / “design then plan”): finish
  **this** document, then **hand back**.

## Output contract (in order)

1. **What** — the sized outcome. Do not change In/Out.
2. **How** — interfaces / providers for the **current** inventory only.
3. **Later-feature seams** — ISP notes (narrow interfaces now; fat
   adapter later). Design notes, **not** inventory.
4. **Close** — hand back. Do not write the plan. Do not resize.

## Rationalizations

| Excuse | Reality |
|---|---|
| “They dumped classes first, so start there” | No grain. Point at `write-spec` → `size-work`. |
| “I’ll add the 10-day story so the ISP seam is real” | Seams are notes. Out stays Out. |
| “This should be an epic now that we have three providers” | Do not resize. Providers are not children. |
| “I’ll write the stacked-PR plan while the types are fresh” | New message. This leaf is design. |
| “DateProvider might be unnecessary, so I’ll drop the story” | Grain is already set. Note it; do not resize. |

## Failures

- Designing before grain (except the stop + pointer)
- Adding Out items (multi-day, URL-query) to inventory
- Resizing or writing Path
- Implementation plan or 2–5 minute steps
- Class list treated as size-work inventory
- Implementing
