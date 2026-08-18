---
name: size-work
description: >-
  Router for work sizing. Use when the user describes work to break down,
  size, classify, or plan at initiative/epic/feature/story/task grain, or
  asks what level a body of work is before specifying or building.
---

# Size work

Classify the work, then hand off. This skill does **not** shape charters, inventories, or briefs.

**REQUIRED:** Read [levels.md](levels.md) before classifying.

## Hard rules

- Do not implement, scaffold, or edit application code.
- Do not write a full spec, design doc, or implementation plan.
- Do not invent child lists in the router — that is the shape skill’s job.
- Outcomes follow [levels.md](levels.md) **Outcomes** — stay conversation-only unless they named a sink (publish there) or asked for a tracker skill/prompt (hand off after shaping).
- Mixed turn (“break this down, then build it”): classify, hand off to the shape skill, finish shaping, then **hand back**. Do not build in this turn.

## 1. Classify

Use [levels.md](levels.md). Explicit labels from the user win.

| Signal | Level skill |
|---|---|
| Multi-outcome theme, platform bet, year/quarter, several pillars | `shape-initiative` |
| Coherent multi-capability outcome; “epic” | `shape-epic` |
| One **user-perceivable** capability; “feature”; “add X to the product” | `shape-feature` |
| As a / I want / so that; one journey; “story” | `shape-story` |
| Rename / migrate / wire CI / “add a retry|index|log|guard”; no user-facing value alone | `shape-task` |
| Two adjacent levels both fit | ask once (see below) |

Prefer the **largest** fitting level. Bare “add X” is **not** enough for a feature — only when X is a user-perceivable product capability. Engineering “add …” chores are tasks.

## 2. Ambiguity

Recommend one level in one sentence. Ask once which they mean. **Stop** until they answer — unless they already said “just pick,” then take the larger level and continue.

Do not start shaping while the level is unresolved.

## 3. Announce and hand off

One line: which level and why (short).

Read the **sibling** skill from this file’s directory (not cwd):

- [../shape-initiative/SKILL.md](../shape-initiative/SKILL.md)
- [../shape-epic/SKILL.md](../shape-epic/SKILL.md)
- [../shape-feature/SKILL.md](../shape-feature/SKILL.md)
- [../shape-story/SKILL.md](../shape-story/SKILL.md)
- [../shape-task/SKILL.md](../shape-task/SKILL.md)

Pass: level, original description, constraints they stated, mixed-turn build request if any.

Then follow that shape skill. Do not keep a second shaping procedure here.

## Red flags

- Writing epics *and* features *and* stories in the router
- Opening with a Spec Kit / Superpowers plan template
- Implementing because “the breakdown is obvious”
- Picking feature for every request
- Treating “add a retry/index/log” as a feature because the sentence starts with “add”
- Writing `docs/work/` or creating tracker items without a named sink
