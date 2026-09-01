---
name: review-scope
description: >-
  Job-only comparison classifier for defect-first review. Use when
  review-changes (or a later consumer) needs the comparison
  classified. Determines base/tip, working tree, named commit,
  named patch, or empty/unresolvable. Does not review. Read-only.
disable-model-invocation: true
---

# Review scope

Determine the comparison. This skill does **not** review, does
**not** fan out, does **not** apply gates, and does **not** write
findings.

## Hard rules

- Read-only. No edits, no commits, no pushes, no GitHub review comments.
- Do not review. Do not write findings. Do not apply `gates.md`. Do not Read it.
- Do not fan out to seats. Do not Follow `review-intent`, `review-blind`, `review-security`, or `review-verify`.
- Do not turn “the codebase” into a comparison. An existing-codebase audit is a later consumer, not this skill inventing a target.
- Focus is an optional user-named phrase, not a menu. Do not infer modes.
- Return the comparison to the consumer, then stop. Do not announce. Do not write `Nothing to review.` or `No candidates.` — the consumer writes its own empty stop.

## 1. Cheap resolve

Run git **before** choosing the comparison when the user named a commit, branch, or working tree — and when they named no target.

Allowed in **one** pass:

- `git status --short` (and `git diff HEAD --name-only` / `git ls-files --others --exclude-standard` when the signal is working tree)
- `git rev-parse --verify` for named commits/branches (then assign as `<tip>` or `<base>` — a named ref is **not** automatically `<tip>`)
- `git symbolic-ref refs/remotes/origin/HEAD` or `git rev-parse --verify` of `origin/main`, then `main`, then `master` when `<base>` is still unset
- `git merge-base <tip> <base>` then `git diff --name-only <merge-base>...<tip>` for branch / PR / no-target

Not allowed here: reading hunks to judge defects, applying gates, writing findings, fanning out. Do **not** use a branch’s own `@{upstream}` as `<base>` when that upstream is the same branch.

A stored patch the user named (`path/to/foo.diff` against a parent tree) **is** a comparison: that diff file vs the named parent. Resolve by reading the diff’s file list. Do not require a dirty git tree.

`<tip>` and `<base>` (branch / PR / no-target only). Assign **`<base>` before `<tip>`**:

- A named default/integration ref (`origin/main`, `main`, `origin/HEAD`, `master`, `origin/master`) is **`<base>`**, never `<tip>`.
- “against X” / “into X” / “compared to X” / “vs X” assigns X as **`<base>`**.
- **`<tip>`** — a named *non-base* branch (the feature/PR subject); else HEAD when HEAD is that feature/PR branch. “Review this PR” with no extra ref: `<tip>` = current PR branch, `<base>` = default.
- Two named refs (“review A into B”, “review A against B”): the one after against/into/vs, or the default-looking one, is `<base>`; the other is `<tip>`. Do not set both to `main`.
- Only named ref is a default branch and HEAD is a feature/PR branch: `<tip>` = HEAD, `<base>` = that default. Do **not** treat this as empty.
- Unset `<base>`: `origin/HEAD`, else `origin/main`, else `main`, else `master`. Never the tip’s self-upstream.
- Naming a feature/PR branch while checked out on `main` still uses that **non-base** ref as `<tip>`.
- “this PR” while HEAD is already the default branch and they named no feature ref: **unresolvable**.

| Result | Comparison |
|---|---|
| Uncommitted / working tree / “what I just changed”; tracked diff **or** untracked paths | Working tree vs HEAD (staged, unstaged, untracked) |
| Uncommitted asked; no tracked diff **and** no untracked paths | **empty** |
| Named commit resolves | That commit vs its parent |
| Named commit missing or root (no parent) | **unresolvable** |
| Named branch / “this PR” / no target; three-dot file list nonempty | Merge-base of `<base>` … `<tip>` |
| Named branch / “this PR” / no target; file list empty or tip equals base | **empty** |
| Named diff/patch file against a parent | That patch vs the named parent |
| Ref missing | **unresolvable** |

User labels win.

## 2. Classify

| Signal | Comparison |
|---|---|
| Uncommitted / working tree / “what I just changed” | Working tree vs HEAD (staged, unstaged, untracked) |
| Named commit | That commit vs its parent |
| Named branch, “this PR”, or no target | Merge-base of `<base>` … `<tip>` |
| Named diff/patch file | That patch vs the named parent |
| Empty or unresolvable | **empty** or **unresolvable** |

If two signals both appear, user label wins; if still tied, ask once. Stop until they answer unless they already said “just pick,” then prefer working tree when uncommitted changes exist, otherwise merge-base of `<base>` … `<tip>`.

Plan / spec / design / charter / brief with no procedure file is **not** a comparison this skill invents. Return the named patch or git comparison when one exists; the consumer decides out-of-family. Do not treat a plan file as “the codebase.”

**Commands to return:**

- Working tree: file list = union of `git diff HEAD --name-only` and `git ls-files --others --exclude-standard`. Return **both** the tracked diff command (`git diff HEAD`) **and** the untracked paths. Untracked files are first-class: consumers must Read each, or `git diff --no-index -- /dev/null <path>`. Do **not** `git add`. Untracked-only is a real comparison — not empty. `git diff HEAD` alone is not the comparison.
- Named commit: `git diff <commit>^ <commit>` (first parent for merges).
- Branch / PR / no-target: `git diff $(git merge-base <tip> <base>)...<tip>`. Not `...HEAD` when `<tip>` is a named **non-base** ref other than HEAD. Not `@{upstream}` as `<base>`. Not a named default as `<tip>`.
- Named patch: the diff file itself; file list from its hunks.

## 3. Return

Return to the consumer, then stop:

- comparison
- comparison command
- file list
- or **empty** / **unresolvable**

Do not announce. Do not fan out. Do not write findings.

## Red flags

- Reviewing, fanning out, applying gates, or writing findings
- Turning “the codebase” into a comparison
- Using the branch’s own upstream as `<base>` (self-diff → empty file list → fake `No findings.`)
- Treating a named default (`origin/main`, `main`, …) as `<tip>` (“against origin/main” → tip equals base → fake empty)
- Using HEAD as `<tip>` when they named a different **non-base** branch
- Inspecting only `git diff HEAD` and skipping untracked paths (fake empty)
- `git add` to make untracked files show up in `git diff`
- Writing the consumer’s empty stop (`Nothing to review.` / `No candidates.`)
