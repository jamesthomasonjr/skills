---
name: review-changes
description: >-
  Router for defect-first code review. Use when the user asks to review
  a change, PR, commit, working tree, or what they just changed. Classifies
  the comparison and hands off; does not review. Read-only.
---

# Review changes

Classify the review target, announce the comparison, then fan out to both
seats and fan in to the verifier. This skill does **not** review and does
**not** write findings.

## Hard rules

- Read-only. No edits, no commits, no pushes, no GitHub review comments.
- Do not apply [gates.md](gates.md). Do not write findings. That is `review-verify`.
- Do not Read `gates.md` in this skill. Seats do not read it.
- Mixed turn (“review this, then fix it”): pass the fix request through. The verifier finishes the review, then hands back. Do not implement in this turn.
- Out of family (“review this plan / spec / design”): stop. Point at `shape-*` (or a later plan-review skill). Do not read the seats or `review-verify`. Do not grill the prose as a design reviewer. A `SKILL.md` or required playbook in the file list is not this signal — hand off.
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
| Uncommitted / working tree / “what I just changed”; tracked diff **or** untracked paths | Working tree vs HEAD (staged, unstaged, untracked) |
| Uncommitted asked; no tracked diff **and** no untracked paths | **empty** — `Nothing to review.` |
| Named commit resolves | That commit vs its parent |
| Named commit missing or root (no parent) | **unresolvable** |
| Named branch / “this PR” / no target; three-dot file list nonempty | Merge-base of `<base>` … `<tip>` |
| Named branch / “this PR” / no target; file list empty or tip equals base | **empty** — `Nothing to review.` |
| Named diff/patch file against a parent | That patch vs the named parent |
| Ref missing | **unresolvable** |

User labels win.

## 2. Classify

| Signal | Comparison passed to the seats |
|---|---|
| Uncommitted / working tree / “what I just changed” | Working tree vs HEAD (staged, unstaged, untracked) |
| Named commit | That commit vs its parent |
| Named branch, “this PR”, or no target | Merge-base of `<base>` … `<tip>` |
| Named diff/patch file | That patch vs the named parent |
| Plan / spec / design / charter / brief; no procedure file in the comparison | **Out of family** — stop |
| Empty or unresolvable | ask once, or `Nothing to review.` |

If two signals both appear, user label wins; if still tied, ask once. Stop until they answer unless they already said “just pick,” then prefer working tree when uncommitted changes exist, otherwise merge-base of `<base>` … `<tip>`.

**Commands to pass:**

- Working tree: file list = union of `git diff HEAD --name-only` and `git ls-files --others --exclude-standard`. Pass **both** the tracked diff command (`git diff HEAD`) **and** the untracked paths. Untracked files are first-class: the seats must Read each, or `git diff --no-index -- /dev/null <path>`. Do **not** `git add`. Untracked-only is a real comparison — not empty, not `Nothing to review.` `git diff HEAD` alone is not the comparison.
- Named commit: `git diff <commit>^ <commit>` (first parent for merges).
- Branch / PR / no-target: `git diff $(git merge-base <tip> <base>)...<tip>`. Not `...HEAD` when `<tip>` is a named **non-base** ref other than HEAD. Not `@{upstream}` as `<base>`. Not a named default as `<tip>`.
- Named patch: the diff file itself; file list from its hunks.

## 3. Announce and hand off

**Out of family:** one or two sentences, name `shape-*` (or a later plan-review skill), **stop**. Do not read a seat or `review-verify`. Do not write a design critique. A `SKILL.md` or required playbook in the file list is in family — hand off.

**Empty / unresolvable:** if they can still name a target, ask once and stop. Otherwise write exactly `Nothing to review.` and stop.

Otherwise one line: which comparison and why (short).

Read **sibling** skill files resolved from **this file’s directory**, not from cwd. `../review-intent/SKILL.md` means “next to this skill,” i.e. the `review-intent` folder that sits beside `review-changes`. After `~/.cursor/skills/<name>` symlink or a plugin copy, `skills/engineering/review-*/SKILL.md` does not exist.

If a cwd-relative Read of a sibling misses (user workspace is a different repo), resolve the sibling from the path you used to open **this** `SKILL.md`, or invoke the skill by name.

Read the **seats** first. Do **not** Read `review-verify` until both seats have emitted candidates. Do **not** Read `gates.md` in this skill.

- [../review-intent/SKILL.md](../review-intent/SKILL.md)
- [../review-blind/SKILL.md](../review-blind/SKILL.md)

Do **not** restate `gates.md`. Do **not** apply it.

**Pass to both seats:** comparison, comparison command, file list, mixed-turn fix request if any, optional focus phrase if they named one.

**Pass to `review-intent` only:** PR body / commit message / procedure context when present.

**Do not pass** the PR body or commit message to `review-blind`. That withhold is compose.

Fan out to both seats (they emit candidates only). Follow `review-blind` without the PR body or commit message. Follow `review-intent` with those. Do not skip a seat.

Then fan in: Read [../review-verify/SKILL.md](../review-verify/SKILL.md) and follow it with both candidate lists. Do not keep a second review procedure here. Do not skip the verifier.

## Red flags

- Writing findings in the router
- Applying gates in the router or telling a seat to read `gates.md`
- Skipping a seat or handing the diff straight to `review-verify`
- Passing the PR body or commit message to `review-blind`
- Reviewing the whole repo because the target was vague
- Inferring a focus menu
- Implementing because the bug is obvious
- Treating a plan/spec as a code review
- Grilling a design as if this family reviewed prose
- Using the branch’s own upstream as `<base>` (self-diff → empty file list → fake `No findings.`)
- Treating a named default (`origin/main`, `main`, …) as `<tip>` (“against origin/main” → tip equals base → fake `Nothing to review.`)
- Using HEAD as `<tip>` when they named a different **non-base** branch
- Inspecting only `git diff HEAD` and skipping untracked paths (fake `No findings.` / `Nothing to review.`)
- `git add` to make untracked files show up in `git diff`
