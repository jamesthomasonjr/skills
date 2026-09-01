---
name: review-changes
description: >-
  Router for defect-first code review. Use when the user asks to review
  a change, PR, commit, working tree, or what they just changed. Follows
  review-scope, announces the comparison, then fans out; does not review.
  Read-only.
---

# Review changes

Follow `review-scope`, announce the comparison it returned, then fan out
to the three seats and fan in to the verifier. This skill does **not**
review and does **not** write findings.

## Hard rules

- Read-only. No edits, no commits, no pushes, no GitHub review comments.
- Do not apply [gates.md](gates.md). Do not write findings. That is `review-verify`.
- Do not Read `gates.md` in this skill. Seats do not read it.
- Do not duplicate `review-scope` tables here. Follow that sibling; pass what it returned.
- Run each seat in a fresh context that contains only what this router passed. Do not follow a seat in this turn. If the harness cannot open a fresh context, stop and say so. Withhold is not isolation.
- Do not run catch-me-up / orient-*. Orient is wrapper priming, not a seat and not a required step in this skill.
- Mixed turn (“review this, then fix it”): pass the fix request through. The verifier finishes the review, then hands back. Do not implement in this turn.
- Out of family (“review this plan / spec / design”): stop. Point at `shape-*` (or a later plan-review skill). Do not read the seats or `review-verify`. Do not grill the prose as a design reviewer. A `SKILL.md` or required playbook in the file list is not this signal — hand off.
- Empty or unresolvable target: ask once or stop with exactly `Nothing to review.`
- Focus is an optional user-named phrase, not a menu. Do not infer modes.

## 1. Resolve

**REQUIRED:** Follow [../review-scope/SKILL.md](../review-scope/SKILL.md) **in the parent**. Resolve that path from **this file’s directory**, not from cwd. Same sibling-path rule as the seats: `../review-scope/SKILL.md` means “next to this skill.” After `~/.cursor/skills/<name>` symlink or a plugin copy, `skills/engineering/review-*/SKILL.md` does not exist.

If a cwd-relative Read of a sibling misses (user workspace is a different repo), resolve the sibling from the path you used to open **this** `SKILL.md`, or invoke the skill by name.

`review-scope` returns the comparison, comparison command, and file list — or **empty** / **unresolvable**. Do not re-run its tables. Do not invent a different comparison. Do not open a fresh child for `review-scope`. That is the gatherer shape, parked.

## 2. Announce and hand off

**Out of family:** one or two sentences, name `shape-*` (or a later plan-review skill), **stop**. Do not read a seat or `review-verify`. Do not write a design critique. A `SKILL.md` or required playbook in the file list is in family — hand off.

**Empty / unresolvable:** if they can still name a target, ask once and stop. Otherwise write exactly `Nothing to review.` and stop.

Otherwise one line: which comparison `review-scope` returned and why (short).

Read **sibling** skill files resolved from **this file’s directory**, not from cwd.

Read the **seats** first. Do **not** Read `review-verify` until all three seats have emitted candidates. Do **not** Read `gates.md` in this skill.

- [../review-intent/SKILL.md](../review-intent/SKILL.md)
- [../review-blind/SKILL.md](../review-blind/SKILL.md)
- [../review-security/SKILL.md](../review-security/SKILL.md)

Do **not** restate `gates.md`. Do **not** apply it. Do **not** Read the security playbook.

**Pass to all three seats:** the comparison, comparison command, and file list `review-scope` returned, mixed-turn fix request if any, optional focus phrase if they named one. Do not pass a different comparison.

**Pass to `review-intent` only:** PR body / commit message / procedure context when present. GREEN tables / fixture protocol / scoring notes / orient dumps are not procedure context. The security playbook is not procedure context. Do not dump the whole orient transcript into intent.

A security seat Reads its own file. `review-changes` and `review-blind` do not. Do not copy playbook bytes into the blind prompt.

**Do not pass** the PR body, commit message, onboard dumps, orient dumps, the implementing turn, GREEN tables / fixture protocol / scoring notes, or the security playbook / OWASP lists / CWE lists to `review-blind`. Do not run `review-blind` in a window that already had those.

Fan out: run **each** seat in a fresh context that contains only what this router passed (plus that seat's own `SKILL.md` as procedure). The security seat’s window is that comparison plus its own playbook — child Read of `playbook.md` is GREEN. All three seats emit candidates only. Do not skip a seat.

The parent may hold the PR body — it has to pass it to `review-intent`. The parent may already hold orient / onboard dumps from wrapper priming (catch-me-up / orient-* on the file list `review-scope` returned, then this router). That is GREEN, not a leak. This skill does not run catch-me-up / orient-*. Orient is not a seat and not a required step here. Reading sibling `SKILL.md` files to know what to dispatch is fine. Do not Read the security playbook to dispatch.

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
| “Open a fresh child for review-scope so isolation is clean” | Follow `review-scope` in the parent. A fresh child for scope is the gatherer shape, parked. |
| “GREEN tables / fixture protocol / scoring notes are not the PR body” | They still brief the seat. Withhold. |
| “Orient the file list first, then fan out” | Wrapper priming may do that. This router does not. |
| “Read the security playbook so I can brief the seats” | A security seat Reads its own file. `review-changes` and `review-blind` do not. |
| “Copy the playbook into the blind prompt so it knows the threats” | Playbook in the blind dump is a leak. |
| “The security child will ignore leftovers / apply gates” | Seats emit leftovers. Swallow is never-seen. Gates are `review-verify`. |

## Red flags

- Writing findings in the router
- Applying gates in the router or telling a seat to read `gates.md`
- Skipping a seat or handing the diff straight to `review-verify`
- Duplicating `review-scope` tables, or passing seats a different comparison than it returned
- Opening a fresh child for `review-scope` instead of Following in the parent
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
