---
name: review-changes
description: >-
  Router for defect-first code review. Use when the user asks to review
  a change, PR, commit, working tree, or what they just changed. Classifies
  the comparison and hands off; does not review. Read-only.
---

# Review changes

Classify the review target, announce the comparison, then hand off. This skill does **not** review and does **not** write findings.

## Hard rules

- Read-only. No edits, no commits, no pushes, no GitHub review comments.
- Do not apply [gates.md](gates.md). Do not write findings. That is `review-defects`.
- Mixed turn (“review this, then fix it”): pass the fix request through. The leaf finishes the review, then hands back. Do not implement in this turn.
- Out of family (“review this plan / spec / design”): stop. Point at `shape-*` (or a later plan-review skill). Do not read `review-defects`. Do not grill the prose as a design reviewer.
- Empty or unresolvable target: ask once or stop with exactly `Nothing to review.`
- Focus is an optional user-named phrase, not a menu. Do not infer modes.

## 1. Cheap resolve

Run git **before** choosing the comparison when the user named a commit, branch, or working tree — and when they named no target.

Allowed in **one** pass:

- `git status --short` (and `git diff HEAD --name-only` / `git ls-files --others --exclude-standard` when the signal is working tree)
- `git rev-parse --verify` for a named commit or branch
- `git merge-base HEAD <ref>` then `git diff --name-only <merge-base>...HEAD` for branch / PR / default

Not allowed here: reading hunks to judge defects, applying gates, writing findings.

A stored patch the user named (`path/to/foo.diff` against a parent tree) **is** a comparison: that diff file vs the named parent. Resolve by reading the diff’s file list. Do not require a dirty git tree.

| Result | Comparison |
|---|---|
| Uncommitted / working tree / “what I just changed”; status has paths | Working tree vs HEAD (staged, unstaged, untracked) |
| Uncommitted asked, status empty | **empty** — `Nothing to review.` |
| Named commit resolves | That commit vs its parent |
| Named commit missing or root (no parent) | **unresolvable** |
| Named branch / “this PR” / no target; merge-base exists | Merge-base of the comparison ref … HEAD |
| Named diff/patch file against a parent | That patch vs the named parent |
| Ref missing | **unresolvable** |

Default comparison ref: named branch if they named one; else current branch upstream if set; else `main`; else `master`.

User labels win.

## 2. Classify

| Signal | Comparison passed to the leaf |
|---|---|
| Uncommitted / working tree / “what I just changed” | Working tree vs HEAD (staged, unstaged, untracked) |
| Named commit | That commit vs its parent |
| Named branch, “this PR”, or no target | Merge-base of the comparison ref … HEAD |
| Named diff/patch file | That patch vs the named parent |
| Plan / spec / design / charter / brief; no code diff | **Out of family** — stop |
| Empty or unresolvable | ask once, or `Nothing to review.` |

If two signals both appear, user label wins; if still tied, ask once. Stop until they answer unless they already said “just pick,” then prefer working tree when uncommitted changes exist, otherwise merge-base … HEAD.

**Commands to pass:**

- Working tree: `git diff HEAD` plus untracked (`git ls-files --others --exclude-standard`). File list is the union.
- Named commit: `git diff <commit>^ <commit>` (first parent for merges).
- Branch / PR / default: `git diff <merge-base>...HEAD`.
- Named patch: the diff file itself; file list from its hunks.

## 3. Announce and hand off

**Out of family:** one or two sentences, name `shape-*` (or a later plan-review skill), **stop**. Do not read the leaf. Do not write a design critique.

**Empty / unresolvable:** if they can still name a target, ask once and stop. Otherwise write exactly `Nothing to review.` and stop.

Otherwise one line: which comparison and why (short).

Read **sibling** skill files resolved from **this file’s directory**, not from cwd. `../review-defects/SKILL.md` means “next to this skill,” i.e. the `review-defects` folder that sits beside `review-changes`. After `~/.cursor/skills/<name>` symlink or a plugin copy, `skills/engineering/review-*/SKILL.md` does not exist.

If a cwd-relative Read of `../review-defects/SKILL.md` misses (user workspace is a different repo), resolve the sibling from the path you used to open **this** `SKILL.md`, or invoke the leaf by name.

- [../review-defects/SKILL.md](../review-defects/SKILL.md)
- [gates.md](gates.md)

Do **not** restate gates.md. Pass: comparison, comparison command, file list, mixed-turn fix request if any, optional focus phrase if they named one.

Then follow `review-defects`. Do not keep a second review procedure here.

## Red flags

- Writing findings in the router
- Reviewing the whole repo because the target was vague
- Inferring a focus menu
- Implementing because the bug is obvious
- Treating a plan/spec as a code review
- Grilling a design as if this family reviewed prose
