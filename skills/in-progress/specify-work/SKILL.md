---
name: specify-work
description: >-
  Router for specifying work. Use when the user wants a spec, design, or
  implementation plan, or dumps a product idea to sharpen before sizing.
  Classifies which document they need and hands off; does not write the
  spec, design, or plan.
---

# Specify work

Classify which document they need, announce, then hand off. This skill
does **not** write the spec, design, or plan.

**REQUIRED:** Read [kinds.md](kinds.md) before classifying.

## Hard rules

- Do not implement, scaffold, or edit application code.
- Do not write the spec, design, or plan in the router.
- Do not size, write Path, or emit an inventory.
- Do not hand size-work a class list. Follow [kinds.md](kinds.md).
- Outcomes: conversation-only unless they named a sink.
- Mixed turn (“spec this then build”): pass the build request through.
  The leaf finishes, then **hands back**. Do not build.
- Do not auto-continue to a second specify leaf in this turn.
- Read sibling skills from **this file’s directory**, not cwd.

## 1. Classify

Use [kinds.md](kinds.md). Explicit user labels win.

| Signal | Leaf |
|---|---|
| “spec this”; product dump; one outcome not yet sharpened; In/Out; foggy idea | `write-spec` |
| Thought-process dump that already mixes outcome + how + classes + plan; **no grain** | `write-spec` — separate; do not emit classes or the plan |
| Same mixed dump or “spec, design, and plan” **after grain** | `write-design` — do not re-run `write-spec` unless they asked to rewrite In/Out |
| “design this”; classes / interfaces / providers; **after grain exists** | `write-design` |
| “plan this”; stacked PRs; implementation sequence; **after grain exists** | `write-plan` |
| Class / provider list as the **first** ask; no sized inventory; no “design this story/feature” after grain | **Stop** — not inventory. Point at `write-spec` → `size-work`. Do not read `write-design`. |
| Size / shape / break down / how big / inventory / Path | **Out of family** — `size-work` / `shape-*`. Stop. |
| Review / debug / what’s next | **Out of family** — matching family. Stop. |

Follow [kinds.md](kinds.md) **Compose order**. User label wins when
they name **only one** document.

- **Before grain:** spec+design+plan or a mixed dump → `write-spec`.
  Separate. Do not abort on classes.
- **After grain:** spec+design+plan, a re-sent mixed dump, or
  design+plan → `write-design` first, then **hand back**. Do not
  re-run `write-spec` unless they explicitly asked to rewrite the
  spec or change In/Out. Do not skip to `write-plan`.
- **After grain, spec only** (explicit rewrite / In/Out change) →
  `write-spec`.
- **After grain, plan only** → `write-plan`.
- **After grain, design only** → `write-design`.

## 2. Announce and hand off

**Out of family:** one or two sentences, name the matching family, **stop**.
Do not read a leaf.

**Class list first:** one or two sentences. Point at `write-spec` →
`size-work`. **Stop.** Do not treat providers as inventory.

Otherwise one line: which document and why (short).

Read the **sibling** from this file’s directory (not cwd):

- [../write-spec/SKILL.md](../write-spec/SKILL.md)
- [../write-design/SKILL.md](../write-design/SKILL.md)
- [../write-plan/SKILL.md](../write-plan/SKILL.md)

After a later symlink or plugin copy, `skills/in-progress/...` may not
exist. If a cwd-relative Read misses, resolve the sibling from the path
you used to open **this** `SKILL.md`, or invoke the leaf by name.

Pass: leaf, original dump, named grain/inventory if any, mixed-turn
build request if any.

Then follow that leaf. Do not keep a second specify procedure here.

## Red flags

- Writing the spec, design, or plan in the router
- Auto-continuing because the dump asked for all three
- Aborting `write-spec` because a mixed dump mentioned classes
- Skipping to `write-plan` when they also asked to design after grain
- Re-running `write-spec` after grain because the dump still says “spec this”
- Treating a class list as inventory
- Invoking `size-work` from this family
- Implementing because the outcome is obvious
- Writing `docs/work/` or committing a spec file without a named sink
