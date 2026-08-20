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
- `git rev-parse --verify` for named commits/branches (then assign as `<tip>` or `<base>` — a named ref is **not** automatically `<tip>`)
- `git symbolic-ref refs/remotes/origin/HEAD` or `git rev-parse --verify` of `origin/main`, then `main`, then `master` when `<base>` is still unset
- `git merge-base <tip> <base>` then `git diff --name-only <merge-base>...<tip>` for branch / PR / no-target

Not allowed here: reading hunks to judge defects, applying gates, writing findings. Do **not** use a branch’s own `@{upstream}` as `<base>` when that upstream is the same branch.

A stored patch the user named (`path/to/foo.diff` against a parent tree) **is** a comparison: that diff file vs the named parent. Resolve by reading the diff’s file list. Do not require a dirty git tree.

`<tip>` and `<base>` (branch / PR / no-target only). Assign **`<base>` before `<tip>`**:

- A named default/integration ref (`origin/main`, `main`, `origin/HEAD`, `master`, `origin/master`) is **`<base>`**, never `<tip>`.
- “against X” / “into X” / “compared to X” / “vs X” assigns X as **`<base>`**.
- **`<tip>`** — a named *non-base* branch (the feature/PR subject); else HEAD when HEAD is that feature/PR branch. “Review this PR” with no extra ref: `<tip>` = current PR branch, `<base>` = default.
- Two named refs (“review A into B”, “review A against B”): the one after against/into/vs, or the default-looking one, is `<base>`; the other is `<tip>`. Do not set both to `main`.
- Only named ref is a default branch and HEAD is a feature/PR branch: `<tip>` = HEAD, `<base>` = that default. Do **not** stop with `Nothing to review.`
- Unset `<base>`: `origin/HEAD`, else `origin/main`, else `main`, else `master`. Never the tip’s self-upstream.
- Naming a feature/PR branch while checked out on `main` still uses that **non-base** ref as `<tip>`.
- “this PR” while HEAD is already the default branch and they named no feature ref: **unresolvable** — ask once.

| Result | Comparison |
|---|---|
| Uncommitted / working tree / “what I just changed”; status has paths | Working tree vs HEAD (staged, unstaged, untracked) |
| Uncommitted asked, status empty | **empty** — `Nothing to review.` |
| Named commit resolves | That commit vs its parent |
| Named commit missing or root (no parent) | **unresolvable** |
| Named branch / “this PR” / no target; three-dot file list nonempty | Merge-base of `<base>` … `<tip>` |
| Named branch / “this PR” / no target; file list empty or tip equals base | **empty** — `Nothing to review.` |
| Named diff/patch file against a parent | That patch vs the named parent |
| Ref missing | **unresolvable** |

User labels win.

## 2. Classify

| Signal | Comparison passed to the leaf |
|---|---|
| Uncommitted / working tree / “what I just changed” | Working tree vs HEAD (staged, unstaged, untracked) |
| Named commit | That commit vs its parent |
| Named branch, “this PR”, or no target | Merge-base of `<base>` … `<tip>` |
| Named diff/patch file | That patch vs the named parent |
| Plan / spec / design / charter / brief; no code diff | **Out of family** — stop |
| Empty or unresolvable | ask once, or `Nothing to review.` |

If two signals both appear, user label wins; if still tied, ask once. Stop until they answer unless they already said “just pick,” then prefer working tree when uncommitted changes exist, otherwise merge-base of `<base>` … `<tip>`.

**Commands to pass:**

- Working tree: `git diff HEAD` plus untracked (`git ls-files --others --exclude-standard`). File list is the union.
- Named commit: `git diff <commit>^ <commit>` (first parent for merges).
- Branch / PR / no-target: `git diff $(git merge-base <tip> <base>)...<tip>`. Not `...HEAD` when `<tip>` is a named **non-base** ref other than HEAD. Not `@{upstream}` as `<base>`. Not a named default as `<tip>`.
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
- Using the branch’s own upstream as `<base>` (self-diff → empty file list → fake `No findings.`)
- Treating a named default (`origin/main`, `main`, …) as `<tip>` (“against origin/main” → tip equals base → fake `Nothing to review.`)
- Using HEAD as `<tip>` when they named a different **non-base** branch
