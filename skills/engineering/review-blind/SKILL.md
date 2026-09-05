---
name: review-blind
description: >-
  Comparison-only candidate seat for defect-first review. Use when
  review-changes hands off. Emits candidates and a reconstructed-intent
  blob. Does not receive the PR body, commit message, or specialist
  playbooks. Does not apply gates and does not write Findings. Read-only.
disable-model-invocation: true
---

# Review blind

Comparison-only seat. Generate **candidates** and a separate
**reconstructed-intent blob**. This skill does **not** apply gates
and does **not** write Findings / Assessment / Close. Do **not**
fold the blob into the candidate list.

This seat must start in a fresh context that contains only the
router-passed comparison, not the parent's window. The router calls
that seed the **comparison-seed** — the same bytes on a nested Task
child and on a CloudAgent. This seat never receives the intent-seed.
The router does
**not** pass the PR body, commit message, onboard dumps, orient dumps,
gatherer products, gatherer follow transcripts, a reconstructed-intent
blob as extra briefing, GREEN tables / fixture protocol / scoring
notes, or specialist playbooks / OWASP lists / CWE lists. Do not
fetch them. Do not read a procedure dump the router withheld. Do not
Read gatherer products or follow transcripts. Do not Read a
specialist playbook. This seat **produces** the reconstruct blob; it
does not receive one.

Fetching the PR body, commit message, onboard dumps, orient dumps,
gatherer products, gatherer follow transcripts, a reconstructed-intent
blob as extra briefing, GREEN tables / fixture protocol / scoring
notes, or specialist playbooks / OWASP lists / CWE lists is a
Failure. Running in a window that already had the PR body, onboard,
orient dumps, gatherer products, a reconstructed-intent blob as extra
briefing, implementing turn, GREEN tables / fixture protocol /
scoring notes, or a specialist playbook is also a Failure — even if
this skill says not to use it.

This seat may emit unused helpers and other comparison-only candidates,
including ones the intent seat would skip without the PR body.

## Hard rules

- Read-only. No edits, no commits, no pushes, no GitHub review comments. Do not create a fix branch.
- Start in a fresh context that contains only the router-passed comparison. A window that already had the PR body, onboard, orient dumps, gatherer products, a reconstructed-intent blob as extra briefing, implementing turn, GREEN tables / fixture protocol / scoring notes, or a specialist playbook is a Failure.
- Do not read the PR body, commit message, onboard dumps, orient dumps, gatherer products, gatherer follow transcripts, a reconstructed-intent blob as extra briefing, GREEN tables / fixture protocol / scoring notes, specialist playbooks / OWASP lists / CWE lists, or other withheld dumps.
- Do not read or apply `gates.md`. Do not drop a candidate to “save the verifier work.”
- Do not write Findings / Assessment / Close. That envelope is `review-verify`.
- Do not drop a candidate because it was not introduced by this change. Emit unused helpers and similar comparison-only candidates.
- Review the passed comparison only. Do not tour the rest of the repo.
- Mixed turn (“review this, then fix it”): candidates and the reconstruct blob, then hand back to the compose. Do not implement.
- If invoked with no comparison: cheap-resolve as `review-scope` would. Empty/unresolvable → `No candidates.` Empty blob.

## Procedure

1. Inspect the complete comparison. For working tree: `git diff HEAD` **and** every untracked path in the file list. Untracked files are first-class — Read each, or `git diff --no-index -- /dev/null <path>`. Do not skip them because they are absent from `git diff HEAD`. Do not `git add`.
   For a named patch or branch/PR three-dot: inspect that complete diff, plus enough surrounding code to name a candidate.
2. Do not open the PR body, commit message, gatherer products, or a specialist playbook to “understand intent” or “know the threats.” Comparison only.
3. Continue through the whole diff after the first candidate. Do not stop at one. Do not read files outside the file list except to demonstrate a call path for a candidate that already overlaps the diff.
4. Write the candidate list. Include unused helpers when they are visible in the comparison. Then emit the reconstructed-intent blob (or beside the list). Stop. Do not apply gates. Do not assign P0–P3. Do not write the envelope. Do not fold the blob into the list.

## Candidates

One entry per candidate:

`Imperative title — path/to/file:line`

Then one short why. No patch. No suggestion block.

**Or**, if none: exactly `No candidates.`

The reconstructed-intent blob is **not** a candidate. Do not fold it into this list.

No Findings. No Assessment. No Close. No severity.

## Reconstructed intent

A short reconstruction of what this comparison appears to be doing,
from the diff only. Its own dump product. After or beside the
candidate list — never inside it.

Not leftover titles. Not Findings. Not gates. Not extra briefing
this seat was passed.

If this comparison exists: always emit the blob — including when
the candidate list is exactly `No candidates.` Intent needs it.

If there is no comparison (empty/unresolvable): empty blob. Write
exactly `No candidates.` and stop.

## Rationalizations

| Excuse | Reality |
|---|---|
| “Read the PR so I understand intent” | Withhold is the job. Comparison only. |
| “Read the gatherer product so I understand the files” | Withhold. Product or transcript in blind is RED. |
| “Read the security playbook so I know the threats” | Withhold. A specialist Reads its own file; this seat does not. |
| “I’m in the parent window but I won’t use the body” | The window already had it. Isolation failed. |
| “Apply gates.md; I’m being thorough” | Thorough is emit. Gates are `review-verify`. |
| “Unused helpers were not introduced by this change — drop” | Emit them. The verifier drops. |
| “Write Findings so they see a review” | Envelope is `review-verify`. |
| “Fold the reconstruct blob into the candidate list” | The blob is its own dump product. Candidates stay `title — path:line` or `No candidates.` |
| “Leftover titles are the reconstruction” | Reconstruct is what the diff appears to do. Not leftover titles. |
| “No candidates, so skip the blob” | A comparison still gets a blob. Empty blob only if no comparison. |
| “I’ll just fix it while I’m here” | Seat turn is read-only. Hand back to the compose. |

## Failures

- Reading the PR body, commit message, onboard dumps, orient dumps, gatherer products, gatherer follow transcripts, a reconstructed-intent blob as extra briefing, GREEN tables / fixture protocol / scoring notes, specialist playbooks / OWASP lists / CWE lists, or a withheld dump
- Running in a window that already had the PR body, onboard, orient dumps, gatherer products, a reconstructed-intent blob as extra briefing, implementing turn, GREEN tables / fixture protocol / scoring notes, or a specialist playbook
- Applying `gates.md` or reading it
- Writing Findings / Assessment / Close
- Folding the reconstructed-intent blob into the candidate list
- Writing leftover titles, Findings, or gates as the reconstruct blob
- Skipping the reconstruct blob when a comparison exists
- Dropping unused helpers or other comparison-only candidates as pre-existing
- Implementing, editing, committing, pushing, or posting a GitHub review
- Touring the repo outside the comparison
