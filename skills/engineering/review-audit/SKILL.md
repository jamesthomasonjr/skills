---
name: review-audit
description: >-
  Existing-codebase audit. Use when the user asks to audit a path,
  module, or the codebase — leftovers and pre-existing defects are
  in-scope as findings. Not a change, PR, or working-tree review.
  Read-only.
disable-model-invocation: true
---

# Review audit

Read-only audit of a **named scope**. Tour that path, module, or
codebase. Leftover / pre-existing debt is a numbered finding.

This skill does **not** review a change. It does **not** Follow
`review-scope`. It does **not** fan change-review seats. It does
**not** apply `gates.md`.

## Hard rules

- Read-only. No edits, no commits, no pushes, no GitHub review comments.
  Do not create a fix branch.
- Resolve a **scope**, not a comparison. Do not Follow `review-scope`.
  Do not invent a git comparison for “the codebase.”
- Do not fan `review-blind`, `review-intent`, `review-security`,
  `review-performance`, `review-logic`, `review-regression`,
  `review-checklist`, or `review-verify`. Those seats stay
  comparison-only.
- Do not apply `gates.md`. Do not drop a leftover because it was not
  introduced by a change. Gate 3 is change-review’s merge bar, not
  this consumer.
- Do not plant `catch-me-up`, `orient-repo`, `orient-module`, or
  `orient-function` as required seats. Wrapper priming is not a
  required step. A parent-held primer product may seed the tour.
- Mixed turn (“audit this, then fix it”): finish this audit, then
  **hand back**. Do not implement. They must send a **new message**
  after the audit.
- Change / PR / commit / working tree / “what I just changed”: stop.
  Point at `review-changes`. Do not tour as a substitute review.
- Plan / spec / design with no code scope: stop. Point at `shape-*`.
- Empty or unresolvable scope: exactly `Nothing to audit.`
- Focus is an optional user-named phrase, not a menu. Do not infer
  modes.

## 1. Resolve scope

Cheap-resolve a **scope** before touring. Allowed in one pass:

- One path glob for a named file or folder (`**/<name>`)
- One symbol search for a named module / class / function
- Top-level listing when they named the codebase / this repo

Not allowed here: `review-scope` tables, merge-base, three-dot diffs,
fanning seats, applying `gates.md`, writing findings.

| Signal | Scope |
|---|---|
| Named path, file, or directory | That path |
| Named module, class, or file-level symbol | That module (the file or directory that holds it) |
| Named function only | The file that holds it — still a scope, not a comparison |
| “the codebase” / “this repo” / “audit everything” | Workspace codebase (skip vendor / build / `.git`) |
| Change / PR / commit / working tree / “what I just changed” | **out of family** → `review-changes` |
| Plan / spec / design, no code scope | **out of family** → `shape-*` |
| No target; they already said the codebase / this repo | Workspace codebase |
| No target | **ask once** for a path, module, or the codebase |

User labels win. Do not turn an audit ask into a working-tree or
merge-base comparison.

Return: `scope`, `scope_kind` (`path` / `module` / `codebase`), and a
file list for that scope — or **empty** / **unresolvable** / **out of
family**.

## 2. Seed, then tour

If this is a stop path, skip this section.

If the parent already holds an onboard summary or orient dump for
**this scope**, use that product as a primer (file list / map). Do
not re-run those skills. Do not treat a primer dump as a required
seat.

You may Follow `review-gather-onboard` for a file list of the
resolved scope. That is a **product**, not a seat. Skip it when the
parent already holds that product or when you already have the list.
Do not follow a gatherer for a git comparison. Do not Follow
`review-scope`.

Then tour the file list:

1. Read the files in scope. Skip vendor / build / `.git` /
   `node_modules`. For “the codebase,” start at top-level +
   depth-two and enough of the hard core to name defects. Do not
   shrink the scope by inventing a comparison.
2. Continue after the first finding. Do not stop at one.
3. Emit leftovers and other pre-existing defects the scope still
   shows: unused helpers, dead exports, broken call paths, real
   correctness / security / performance / maintainability bugs.
   Swallow is never-seen.
4. Do not read files outside the scope except to demonstrate a call
   path for a finding that already overlaps the scope.

## 3. Audit bar

Emit a finding only when **all** of these are true. If any is shaky,
**drop**. When in doubt about impact, drop — except a leftover /
pre-existing defect that is discrete, in scope, and has a concrete
bad outcome.

1. Meaningful correctness / security / performance / maintainability.
2. Discrete and actionable (title + `path:line`).
3. Visible in the named scope. Pre-existing is expected. “Not
   introduced by this change” is **not** a drop.
4. Demonstrable from the code (call path or unused surface).
5. Names a **concrete bad outcome** (what breaks, for whom — including
   a dead export no caller can use, or a leftover helper that still
   ships).

Still **DROP**: style / naming / comment / formatting nits; anything
a linter already enforces; speculative “might break”; a “Minor / nit
/ consider” bucket. Listing nits then calling them nits is still a
fail.

Do **not** apply `gates.md`. Do not park a leftover under Follow-ups.
That heading is change-review’s leftover home. Here the leftover
**is** the finding.

## Output contract (in order)

Skip this entire section on stop paths.

1. **Findings** — one entry per survivor, severity-first:

   `[P1] Imperative title — path/to/file:line`

   Then one short paragraph: affected scenario, concrete bad outcome,
   why it is wrong. No second paragraph. No patch. No suggestion
   block.

   **Or**, if none survive: this block is exactly `No findings.`

   Mixed-turn (“audit this, then fix it”): after this block, one line
   — they must send a **new message** to implement. Not a heading.

2. **Assessment** — still this heading:

   1–3 sentences: named scope + what was toured. No leftover names
   stuffed here to avoid numbering them.

No Follow-ups. No Close. No other sections. No praise. No nit list
after `No findings.`

## Stop paths (no envelope)

These are **not** empty audits. Do **not** emit Findings / Assessment.

- Empty or unresolvable scope: exactly `Nothing to audit.`
- Change / PR / commit / working tree: 1–2 sentences, point at
  `review-changes`, stop.
- Plan / spec / design with no code scope: 1–2 sentences, point at
  `shape-*`, stop.

## Severity

Assign only to survivors:

- `P0` — universal / critical failure still present in scope.
- `P1` — urgent defect that should be fixed next.
- `P2` — ordinary defect that should be fixed.
- `P3` — low-impact issue that still passes the audit bar (including
  a leftover unused helper or dead export).

A naming nit is not a P3. It is dropped.

## Rationalizations

| Excuse | Reality |
|---|---|
| “This leftover is pre-existing — Follow-ups” | Audit numbers it. Follow-ups is change-review’s leftover home. |
| “Gate 3 / not introduced by this change — drop” | There is no change. The scope still has it. |
| “Apply `gates.md` so the bar matches review-verify” | `gates.md` is change-review. Do not apply it. |
| “Follow review-scope; the codebase is a comparison” | Scope, not comparison. `review-scope` stays change-review. |
| “Fan review-regression; it already looks for leftovers” | That seat is comparison-only. Do not teach it to tour. |
| “REQUIRED: catch-me-up / orient-* first” | Not a required seat. Use a parent-held primer if one exists. |
| “Skip the leftover; change-review already named it” | This consumer’s job is existing debt. Silent drop is never-seen. |
| “Nits are fine / flag anything” | Nits are still dropped. Leftovers are not nits. |
| “I’ll just fix it while I’m here” | Audit turn is read-only. Hand back. |
| “Review this PR as an audit so leftovers become findings” | That ask is `review-changes`. Gate-3-as-finding stays parked. |
| “Write Follow-ups so the envelope matches review-verify” | Findings + Assessment only. Leftovers are findings. |
| “Tour via a three-dot so I know what changed” | This skill does not review a change. |

## Failures

- Turning “the codebase” into a `review-scope` comparison
- Fanning a change-review seat or applying `gates.md`
- Parking a leftover under Follow-ups, or dropping it as Gate 3
- Planting catch-me-up / orient-* as a required seat
- Numbering a style nit
- Whole-repo swallow that ignores the named path
- Implementing, editing, committing, pushing, or posting a GitHub review
- Reviewing a PR / commit / working tree as if it were this skill
- A Close heading, or a required Follow-ups heading
- Inventing findings on a clean scope
