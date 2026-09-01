---
name: review-blind
description: >-
  Comparison-only candidate seat for defect-first review. Use when
  review-changes hands off. Generates candidates only. Does not receive
  the PR body, commit message, or the security playbook. Does not apply
  gates and does not write Findings. Read-only.
disable-model-invocation: true
---

# Review blind

Comparison-only seat. Generate **candidates** only. This skill does
**not** apply gates and does **not** write Findings / Assessment / Close.

This seat must start in a fresh context that contains only the
router-passed comparison, not the parent's window. The router does
**not** pass the PR body, commit message, onboard dumps, orient dumps,
GREEN tables / fixture protocol / scoring notes, or the security
playbook / OWASP lists / CWE lists. Do not fetch them. Do not read a
procedure dump the router withheld. Do not Read `orient-*` /
catch-me-up dumps. Do not Read the security playbook.

Fetching the PR body, commit message, onboard dumps, orient dumps,
GREEN tables / fixture protocol / scoring notes, or the security
playbook / OWASP lists / CWE lists is a Failure. Running in a window
that already had the PR body, onboard, orient dumps, implementing
turn, GREEN tables / fixture protocol / scoring notes, or the security
playbook is also a Failure — even if this skill says not to use it.

This seat may emit unused helpers and other comparison-only candidates,
including ones the intent seat would skip without the PR body.

## Hard rules

- Read-only. No edits, no commits, no pushes, no GitHub review comments. Do not create a fix branch.
- Start in a fresh context that contains only the router-passed comparison. A window that already had the PR body, onboard, orient dumps, implementing turn, GREEN tables / fixture protocol / scoring notes, or the security playbook is a Failure.
- Do not read the PR body, commit message, onboard dumps, orient dumps, GREEN tables / fixture protocol / scoring notes, the security playbook / OWASP lists / CWE lists, or other withheld dumps.
- Do not read or apply `gates.md`. Do not drop a candidate to “save the verifier work.”
- Do not write Findings / Assessment / Close. That envelope is `review-verify`.
- Do not drop a candidate because it was not introduced by this change. Emit unused helpers and similar comparison-only candidates.
- Review the passed comparison only. Do not tour the rest of the repo.
- Mixed turn (“review this, then fix it”): candidates only, then hand back to the compose. Do not implement.
- If invoked with no comparison: cheap-resolve as `review-changes` would. Empty/unresolvable → `No candidates.`

## Procedure

1. Inspect the complete comparison. For working tree: `git diff HEAD` **and** every untracked path in the file list. Untracked files are first-class — Read each, or `git diff --no-index -- /dev/null <path>`. Do not skip them because they are absent from `git diff HEAD`. Do not `git add`.
   For a named patch or branch/PR three-dot: inspect that complete diff, plus enough surrounding code to name a candidate.
2. Do not open the PR body, commit message, or the security playbook to “understand intent” or “know the threats.” Comparison only.
3. Continue through the whole diff after the first candidate. Do not stop at one. Do not read files outside the file list except to demonstrate a call path for a candidate that already overlaps the diff.
4. Write the candidate list. Include unused helpers when they are visible in the comparison. Stop. Do not apply gates. Do not assign P0–P3. Do not write the envelope.

## Candidates

One entry per candidate:

`Imperative title — path/to/file:line`

Then one short why. No patch. No suggestion block.

**Or**, if none: exactly `No candidates.`

No Findings. No Assessment. No Close. No severity.

## Rationalizations

| Excuse | Reality |
|---|---|
| “Read the PR so I understand intent” | Withhold is the job. Comparison only. |
| “Read orient-* so I understand the files” | Withhold. Do not fetch orient / onboard dumps. |
| “Read the security playbook so I know the threats” | Withhold. A security seat Reads its own file; this seat does not. |
| “I’m in the parent window but I won’t use the body” | The window already had it. Isolation failed. |
| “Apply gates.md; I’m being thorough” | Thorough is emit. Gates are `review-verify`. |
| “Unused helpers were not introduced by this change — drop” | Emit them. The verifier drops. |
| “Write Findings so they see a review” | Envelope is `review-verify`. |
| “I’ll just fix it while I’m here” | Seat turn is read-only. Hand back to the compose. |

## Failures

- Reading the PR body, commit message, onboard dumps, orient dumps, GREEN tables / fixture protocol / scoring notes, the security playbook / OWASP lists / CWE lists, or a withheld dump
- Running in a window that already had the PR body, onboard, orient dumps, implementing turn, GREEN tables / fixture protocol / scoring notes, or the security playbook
- Applying `gates.md` or reading it
- Writing Findings / Assessment / Close
- Dropping unused helpers or other comparison-only candidates as pre-existing
- Implementing, editing, committing, pushing, or posting a GitHub review
- Touring the repo outside the comparison
