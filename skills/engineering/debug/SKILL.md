---
name: debug
description: >-
  Use when the user asks for help fixing, debugging, or finding the root
  cause of an issue; or reports something broken, throwing, failing, or
  regressing and wants it diagnosed.
---

# Debug

Classify the bug, then hand off. This skill does **not** investigate, hypothesise, or fix.

**REQUIRED:** Read [paths.md](paths.md) before classifying.

## Hard rules

- Do not investigate root cause in the router.
- Do not write fixes, add logs, or run “quick checks” that are really Phase 1 of a depth skill.
- Do not own mid-run escalation — that is `debug-root-cause` only.
- Mixed turn (“fix this, then add feature X”): hand off to the depth skill; when debugging finishes, **hand back**. Do not start the unrelated work in this turn.

## 1. Classify

Use [paths.md](paths.md). Explicit user labels win.

| Signal | Path |
|---|---|
| Clear repro / stack / failing test / recent regression / usable evidence | `debug-root-cause` |
| No reliable repro; flaky; perf; “keeps coming back”; guessing without a signal | `debug-feedback-loop` |
| Explicit path label | that path |
| Ambiguous | Prefer `debug-root-cause` |

If wording drifts, [paths.md](paths.md) wins.

## 2. Announce and hand off

One line: which path and why (short).

Read the **sibling** skill from this file’s directory (not cwd):

- [../debug-root-cause/SKILL.md](../debug-root-cause/SKILL.md)
- [../debug-feedback-loop/SKILL.md](../debug-feedback-loop/SKILL.md)
- [paths.md](paths.md)

`../debug-root-cause/SKILL.md` means “next to this skill.” After `~/.cursor/skills/<name>` symlink or a plugin copy, `skills/engineering/debug-*/SKILL.md` does not exist. If a cwd-relative Read misses, resolve the sibling from the path used to open **this** `SKILL.md`, or invoke the depth skill by name.

Pass: chosen path, original symptom / user description, constraints they stated, evidence already provided (logs, stack, repro steps), mixed-turn leftover request if any.

Then follow that depth skill. Do not keep a second debugging procedure here.

## Red flags

- Investigating or fixing inside the router
- Asking the user to choose a path when the table already prefers root-cause for ambiguous cases
- Re-entering the router mid-debug to “re-classify” (escalation is depth-owned)
- Starting unrelated feature work in a mixed turn
