---
name: review-intent
description: >-
  Docs- and PR-aware candidate seat for defect-first review. Use when
  review-changes hands off. Generates candidates only. Does not apply
  gates and does not write Findings. Read-only.
disable-model-invocation: true
---

# Review intent

Docs- and PR-aware seat. Generate **candidates** only. This skill does
**not** apply gates and does **not** write Findings / Assessment / Close.

This seat also runs in a fresh context. That context **does** include the PR body / commit message / procedure context the router passed. Orient dumps are **not** automatic procedure context (same rule as GREEN tables). The security playbook is not procedure context. The router does not dump the whole orient transcript here.

The router passes the comparison plus PR body / procedure context when
those exist. This seat owns advertised-path and procedure-clash
candidates. It may also emit other intent- or docs-aware candidates.

## Hard rules

- Read-only. No edits, no commits, no pushes, no GitHub review comments. Do not create a fix branch.
- Run in a fresh context. That context includes the PR body / commit message / procedure context the router passed. Orient dumps are not procedure context. The security playbook is not procedure context.
- Do not read or apply `gates.md`. Do not drop a candidate to “save the verifier work.”
- Do not write Findings / Assessment / Close. That envelope is `review-verify`.
- Do not drop a candidate because it was not introduced by this change. Emit it.
- Review the passed comparison plus the PR / procedure context the router passed. Do not tour the rest of the repo.
- Mixed turn (“review this, then fix it”): candidates only, then hand back to the compose. Do not implement.
- If invoked with no comparison: cheap-resolve as `review-scope` would. Empty/unresolvable → `No candidates.`
- If invoked with a plan/spec/design and no procedure file in the comparison: `No candidates.` Point at `review-changes` (out of family is the router’s stop).

## Procedure

1. Inspect the complete comparison. For working tree: `git diff HEAD` **and** every untracked path in the file list. Untracked files are first-class — Read each, or `git diff --no-index -- /dev/null <path>`. Do not skip them because they are absent from `git diff HEAD`. Do not `git add`.
   For a named patch or branch/PR three-dot: inspect that complete diff, plus enough surrounding code to name a candidate.
2. Read the PR body / procedure context the router passed. Use it. Advertised-path misses and procedure clashes are this seat’s job when that context is present.
3. Continue through the whole diff after the first candidate. Do not stop at one. Do not read files outside the file list except to demonstrate a call path for a candidate that already overlaps the diff.
4. Write the candidate list. Stop. Do not apply gates. Do not assign P0–P3. Do not write the envelope.

## Candidates

One entry per candidate:

`Imperative title — path/to/file:line`

Then one short why. No patch. No suggestion block.

**Or**, if none: exactly `No candidates.`

No Findings. No Assessment. No Close. No severity.

## Rationalizations

| Excuse | Reality |
|---|---|
| “Apply gates so only good candidates pass” | Seats do not apply `gates.md`. Emit the candidate. |
| “Not introduced by this change — drop it” | Emit it. The verifier drops. |
| “Write Findings so they see a review” | Envelope is `review-verify`. |
| “No PR body, so skip advertised-path / procedure-clash” | Those classes are this seat when the router passed context. |
| “Parent has orient — treat it as procedure context” | Orient dumps are not procedure context. Use what the router passed. |
| “Parent has the security playbook — treat it as procedure context” | The playbook is not procedure context. Use what the router passed. |
| “I’ll just fix it while I’m here” | Seat turn is read-only. Hand back to the compose. |

## Failures

- Applying `gates.md` or reading it
- Writing Findings / Assessment / Close
- Dropping a candidate as pre-existing
- Implementing, editing, committing, pushing, or posting a GitHub review
- Skipping advertised-path or procedure-clash when the router passed that context
- Treating the security playbook as procedure context
- Touring the repo outside the comparison
