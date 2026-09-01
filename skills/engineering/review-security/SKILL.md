---
name: review-security
description: >-
  Security-candidate seat for defect-first review. Use when
  review-changes hands off. Generates candidates only. Reads its
  own playbook. Does not apply gates and does not write Findings.
  Read-only.
disable-model-invocation: true
---

# Review security

Security-candidate seat. Generate **candidates** only. This skill does
**not** apply gates and does **not** write Findings / Assessment / Close.

This seat’s window is the **comparison plus its own playbook**. Start
in a fresh context. The router passes the comparison, comparison
command, file list, mixed-turn fix request if any, and an optional
focus phrase. It does **not** pass the playbook. It does **not**
pass the onboard product. It does **not** pass the reconstructed-intent
blob. Onboard has no seat to seed. This seat still fans with
`review-blind`. The blob is not in this window.

Do **not** Read the reconstruct blob. A window that already had it
is a Failure.

Child Read of [playbook.md](playbook.md) in this window is GREEN.
Resolve that path from this file’s directory, not cwd. A
comparison-only window is the **blind** letter — not this seat.

`review-changes` or `review-blind` Reading the playbook is RED.

**REQUIRED:** Follow [playbook.md](playbook.md). Read it before writing
candidates.

## Hard rules

- Read-only. No edits, no commits, no pushes, no GitHub review comments. Do not create a fix branch.
- Start in a fresh context whose window is the comparison plus this seat’s own playbook. Child Read of `playbook.md` is GREEN. Do not Read the reconstructed-intent blob. A window that already had the blob is a Failure.
- Do not read or apply `gates.md`. Do not drop a candidate to “save the verifier work.”
- Do not write Findings / Assessment / Close. That envelope is `review-verify`.
- Do not drop a candidate because it was not introduced by this change, or because it is only “newly reachable.” Emit leftovers visible in the comparison. Swallow is never-seen.
- Review the passed comparison only. Do not tour the rest of the repo. Do not audit “the codebase.”
- Mixed turn (“review this, then fix it”): candidates only, then hand back to the compose. Do not implement.
- If invoked with no comparison: cheap-resolve as `review-scope` would. Empty/unresolvable → `No candidates.`
- If invoked with a plan/spec/design and no procedure file in the comparison: `No candidates.` Point at `review-changes` (out of family is the router’s stop).

## Procedure

1. Read [playbook.md](playbook.md) from this file’s directory.
2. Inspect the complete comparison. For working tree: `git diff HEAD` **and** every untracked path in the file list. Untracked files are first-class — Read each, or `git diff --no-index -- /dev/null <path>`. Do not skip them because they are absent from `git diff HEAD`. Do not `git add`.
   For a named patch or branch/PR three-dot: inspect that complete diff, plus enough surrounding code to name a candidate.
3. Continue through the whole diff after the first candidate. Do not stop at one. Do not read files outside the file list except to demonstrate a call path for a candidate that already overlaps the diff.
4. Write the candidate list. Include leftovers the comparison still shows. Stop. Do not apply gates. Do not assign P0–P3. Do not write the envelope.

## Candidates

One entry per candidate:

`Imperative title — path/to/file:line`

Then one short why. No patch. No suggestion block.

**Or**, if none: exactly `No candidates.`

No Findings. No Assessment. No Close. No severity.

## Rationalizations

| Excuse | Reality |
|--------|---------|
| “Apply gates so only introduced issues pass” | Seats do not apply `gates.md`. Emit the candidate. |
| “Not introduced / only newly reachable — drop it” | Emit it. Swallow is never-seen, not a named residual. |
| “Could be A01 — emit the category title” | Category name with no sink is not a candidate. |
| “Write Findings so they see a review” | Envelope is `review-verify`. |
| “I’ll just fix it while I’m here” | Seat turn is read-only. Hand back to the compose. |
| “Audit the whole repo; security is the codebase” | Comparison only. This seat is not an existing-codebase audit. |
| “Fresh context means comparison only — skip playbook.md” | That is the blind letter. This window is comparison plus own playbook. Child Read is GREEN. |
| “Read the reconstruct blob so I know intent” | Withhold. The blob in this window is a Failure. |

## Failures

- Applying `gates.md` or reading it
- Writing Findings / Assessment / Close
- Dropping a leftover or other comparison-visible candidate as pre-existing / not-introduced / only-newly-reachable
- Emitting a category title, “could be A01,” or Top 10 recitation with no sink
- Implementing, editing, committing, pushing, or posting a GitHub review
- Touring the repo outside the comparison
- Auditing “the codebase” instead of the passed comparison
- Reading the reconstructed-intent blob, or running in a window that already had it
