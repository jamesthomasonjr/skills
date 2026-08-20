---
name: next-work
description: >-
  Router for choosing the next piece of work. Use when the user asks
  what's next, what they should work on, or wants a handoff prompt for
  the next agent. Classifies the path and hands off; does not rank and
  does not write the handoff.
---

# Next work

Classify the ask, cheap-resolve the work set, announce the path, then hand
off. This skill does **not** rank and does **not** write the handoff.

**REQUIRED:** Read [sources.md](sources.md) before resolving.

## Hard rules

- Do not invent work items. Follow [sources.md](sources.md). Empty set →
  exactly `Nothing next.`
- Scoped subdirectory: resolve inside that scope only, including git.
  Parent dirty tree or parent feature-branch delta is not a candidate.
- Do not rank. Do not write Goal / Constraints / Done when / Pointers / Prompt.
- Do not implement, scaffold, or edit application code.
- Mixed turn (“what’s next, then do it” / “handoff then implement”): pass
  the implement request through. The leaf (or leaves) finish pick + handoff,
  then hand back. Do not implement in this turn.
- Out of family (size / shape / review / debug / orient): stop. Point at
  the matching family. Do not read a leaf.
- Read sibling skills from **this file’s directory**, not cwd.

## 1. Cheap resolve

Run [sources.md](sources.md) **before** announcing — except on an
out-of-family stop (do not gather a set just to ignore it).

User-named list wins as the set. Drop sources that do not resolve.
Scoped subdirectory → resolve inside that scope only, including git.
Parent dirty tree / parent feature-branch delta → drop.

Not allowed here: ranking, writing the handoff, implementing, touring
`src/` for chores.

## 2. Classify

Use [sources.md](sources.md) for the set. Explicit user labels win.

| Signal | Path |
|---|---|
| “what’s next” / “what should I work on” / no item named | `prioritize-work`, then `handoff-work` |
| “rank these” / “which of these first” / named list, no handoff ask | `prioritize-work` only |
| “write the handoff” / “prompt for the next agent” / item already chosen | `handoff-work` only |
| Size / shape / break down / how big / charter / inventory / “write the brief” | **Out of family** — `size-work` / `shape-*` |
| Review a change / PR / commit / working tree | **Out of family** — `review-changes` |
| Debug / fix this bug / root cause / something’s broken | **Out of family** — `debug` |
| Onboard / catch me up / what does this file/function do | **Out of family** — `catch-me-up` |
| Empty or unresolvable work set | `Nothing next.` (ask once only when they named a source that missed) |

If two in-family signals both appear, user label wins; if still tied, prefer
prioritize then handoff. If an out-of-family verb is the ask, **stop**.

## 3. Announce and hand off

**Out of family:** one or two sentences, name the matching family, **stop**.
Do not read a leaf. Do not write Next / Why / Handoff.

**Empty / unresolvable:** follow [sources.md](sources.md). Ask once or write
exactly `Nothing next.` and stop. That is the entire output.

Otherwise one line: which path and why (short).

Read **sibling** skill files resolved from **this file’s directory**, not
from cwd. `../prioritize-work/SKILL.md` means “next to this skill.” After
`~/.cursor/skills/<name>` symlink or a plugin copy,
`skills/engineering/next-*/SKILL.md` does not exist.

If a cwd-relative Read misses (user workspace is a different repo), resolve
the sibling from the path you used to open **this** `SKILL.md`, or invoke
the leaf by name.

- [../prioritize-work/SKILL.md](../prioritize-work/SKILL.md)
- [../handoff-work/SKILL.md](../handoff-work/SKILL.md)
- [sources.md](sources.md)

Pass: path (`prioritize-then-handoff` / `prioritize-only` / `handoff-only`),
resolved candidate set, specified item if any, mixed-turn implement request
if any.

Then follow the leaf (or leaves, in order). Do not keep a second ranking or
handoff procedure here.

On `prioritize-then-handoff`: follow `prioritize-work` to get the one next
item, then follow `handoff-work` with that item.

## Red flags

- Inventing a backlog so the answer looks useful
- Treating a parent dirty tree or parent feature-branch as “in flight”
  when the project is a scoped subdirectory
- Ranking in the router
- Writing the handoff in the router
- Implementing because the next item is obvious
- Wrapping `Nothing next.` in Next / Why / Handoff
- Sizing, reviewing, debugging, or orienting in this family
- Reading siblings from cwd / `skills/engineering/...` after symlink
