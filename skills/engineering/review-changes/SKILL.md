---
name: review-changes
description: >-
  Router for defect-first code review. Use when the user asks to review
  a change, PR, commit, working tree, or what they just changed. Classifies
  the comparison and hands off; does not review. Read-only.
---

# Review changes

Classify the review target, announce the comparison, then fan out to the
three seats and fan in to the verifier. This skill does **not** review and
does **not** write findings.

## Hard rules

- Read-only. No edits, no commits, no pushes, no GitHub review comments.
- Do not apply [gates.md](gates.md). Do not write findings. That is `review-verify`.
- Do not Read `gates.md` in this skill. Seats do not read it.
- Run each seat in a fresh context that contains only what this router passed. Do not follow a seat in this turn. If the harness cannot open a fresh context, stop and say so. Withhold is not isolation.
- Do not run catch-me-up / orient-*. Orient is wrapper priming, not a seat and not a required step in this skill.
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

Read the **seats** first. Do **not** Read `review-verify` until all three seats have emitted candidates. Do **not** Read `gates.md` in this skill.

- [../review-intent/SKILL.md](../review-intent/SKILL.md)
- [../review-blind/SKILL.md](../review-blind/SKILL.md)
- [../review-security/SKILL.md](../review-security/SKILL.md)

Do **not** restate `gates.md`. Do **not** apply it. Do **not** Read the security playbook.

**Pass to all three seats:** comparison, comparison command, file list, mixed-turn fix request if any, optional focus phrase if they named one.

**Pass to `review-intent` only:** PR body / commit message / procedure context when present. GREEN tables / fixture protocol / scoring notes / orient dumps are not procedure context. The security playbook is not procedure context. Do not dump the whole orient transcript into intent.

A security seat Reads its own file. `review-changes` and `review-blind` do not. Do not copy playbook bytes into the blind prompt.

**Do not pass** the PR body, commit message, onboard dumps, orient dumps, the implementing turn, GREEN tables / fixture protocol / scoring notes, or the security playbook / OWASP lists / CWE lists to `review-blind`. Do not run `review-blind` in a window that already had those.

Fan out: run **each** seat in a fresh context that contains only what this router passed (plus that seat's own `SKILL.md` as procedure). The security seat’s window is that comparison plus its own playbook — child Read of `playbook.md` is GREEN. All three seats emit candidates only. Do not skip a seat.

The parent may hold the PR body — it has to pass it to `review-intent`. The parent may already hold orient / onboard dumps from wrapper priming (catch-me-up / orient-* on the cheap-resolve file list, then this router). That is GREEN, not a leak. This skill does not run catch-me-up / orient-*. Orient is not a seat and not a required step here. Reading sibling `SKILL.md` files to know what to dispatch is fine. Do not Read the security playbook to dispatch.

If this harness cannot open a fresh context for a seat, **stop** and say so. Do not follow that seat in this turn. Withhold is not isolation.

If two signals conflict, isolation wins over following a seat in this turn.

Then fan in: Read [../review-verify/SKILL.md](../review-verify/SKILL.md) and follow it **in the parent** with the three candidate lists. Isolation is not a duty of `review-verify`. Parent-held orient / onboard dumps in that window are GREEN. Do not keep a second review procedure here. Do not skip the verifier.

## Isolation

| Excuse | Reality |
|---|---|
| “Follow the seat in this turn; just don’t paste the body” | Isolation wins. Fresh context or stop. |
| “This harness cannot open a fresh context — withhold is enough” | Stop and say so. Withhold is not isolation. |
| “The parent already has the body; the seat will ignore it” | A window that already had it is a leak. |
| “The parent already has orient / onboard; the seat will ignore it” | Parent-held dumps are GREEN. Copying them into the blind prompt or running the seat in that window is a leak. |
| “Withhold orient from review-verify; it Follows in the parent” | Verify runs in the parent. Parent-held dumps there are GREEN. |
| “GREEN tables / fixture protocol / scoring notes are not the PR body” | They still brief the seat. Withhold. |
| “Orient the file list first, then fan out” | Wrapper priming may do that. This router does not. |
| “Read the security playbook so I can brief the seats” | A security seat Reads its own file. `review-changes` and `review-blind` do not. |
| “Copy the playbook into the blind prompt so it knows the threats” | Playbook in the blind dump is a leak. |
| “The security child will ignore leftovers / apply gates” | Seats emit leftovers. Swallow is never-seen. Gates are `review-verify`. |

## Red flags

- Writing findings in the router
- Applying gates in the router or telling a seat to read `gates.md`
- Skipping a seat or handing the diff straight to `review-verify`
- Parent leaked the PR body (or commit message / onboard / orient dumps / implementing turn / GREEN tables / fixture protocol / scoring notes / the security playbook / OWASP lists / CWE lists) into the blind prompt or into the blind child's window
- Child fetched the PR body / commit message / onboard / orient dumps anyway
- Blind child fetched the security playbook / OWASP lists / CWE lists
- A seat swallowed leftovers or applied gates
- Running catch-me-up / orient-* from this skill, or treating orient as a fourth seat
- Following a seat in this turn because the harness could not open a fresh context
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
