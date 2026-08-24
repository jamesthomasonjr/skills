---
name: specify-work
description: >-
  Use when the user wants a spec, design, or implementation plan, or
  dumps a product idea to sharpen before sizing.
---

# Specify work

Announce once: `Using specify-work to classify which document.`

Classify which document they need, announce, then hand off. This skill
does **not** write the spec, design, or plan.

**REQUIRED:** Read [kinds.md](kinds.md) before classifying.

<HARD-GATE>
Follow [kinds.md](kinds.md) **HARD-GATE**. Conversation-only unless
they named a sink. Do not implement. Do not write the spec, design,
or plan in this router. Do not open a second specify leaf. Do not
invoke `size-work`. Named Close on the leaf is the only terminal.
</HARD-GATE>

## Hard rules

- Do not size, write Path, or emit an inventory.
- Do not hand size-work a class list. Follow [kinds.md](kinds.md).
- Mixed turn (“spec this then build”): pass the build request through.
  The leaf finishes, then **hands back**. Do not build.
- Read sibling skills from **this file’s directory**, not cwd.

## 1. Classify

Use [kinds.md](kinds.md). Explicit user labels win when they name
**only one** document, except [kinds.md](kinds.md) **After a spike
pick** when that pick would stale Outcome / In / Out or grain.

| Signal | Leaf |
|---|---|
| “spec this”; product dump; one outcome not yet sharpened; In/Out; foggy idea | `write-spec` |
| Thought-process dump that already mixes outcome + how + classes + plan; **no grain** | `write-spec` — separate; do not emit classes or the plan |
| Same mixed dump or “spec, design, and plan” **after grain** | `write-design` — do not re-run `write-spec` unless they asked to rewrite In/Out or a just-landed spike pick would stale it |
| Spike pick landed; pick **would** change Outcome / In / Out or grain | `write-spec` — even if they said “design” or “plan.” Stop. Point at `size-work`. |
| Spike pick landed; **not** stale; they named only one document | That leaf. “plan this” → `write-plan`. “design this” → `write-design`. Do not override with “next unfinished.” |
| Spike pick landed; **not** stale; mixed ask or just the pick | [kinds.md](kinds.md) **After a spike pick** step 3 (unlabeled table only) |
| “design this”; classes / interfaces / providers; **after grain exists** | `write-design` (unless a just-landed pick would stale In/Out) |
| “plan this”; stacked PRs; implementation sequence; **after grain exists** | `write-plan` (unless a just-landed pick would stale In/Out) |
| Class / provider list as the **first** ask; no sized inventory; no “design this story/feature” after grain | **Stop** — not inventory. Point at `write-spec` → `size-work`. Do not read `write-design`. |
| Size / shape / break down / how big / inventory / Path | **Out of family** — `size-work` / `shape-*`. Stop. |
| Review / debug / what’s next | **Out of family** — matching family. Stop. |

**REQUIRED:** follow [kinds.md](kinds.md) **Compose order** and
**After a spike pick**.

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
- Treating Approaches (stack) as spike options (vendor), or the reverse
- Designing or planning after a pick that would stale In/Out
- Taking `write-design` on a non-stale pick + “plan this” because
  there is no design yet, or because the unlabeled table said so
- Auto-continuing the after-pick loop in one turn
- Invoking `size-work` from this family
- Implementing because the outcome is obvious
- Writing `docs/work/` or committing a spec file without a named sink
