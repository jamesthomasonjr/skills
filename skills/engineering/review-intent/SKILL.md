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

This seat also runs in a fresh context. That context **does** include the comparison, the PR body / design excerpt / commit message / procedure context the router passed, and the reconstructed-intent blob. Orient dumps and the onboard product are **not** procedure context (same rule as GREEN tables). The blind candidate list (`title — path:line` entries, including leftovers) is **not** procedure context and is **not** a list of candidates to copy. The reconstruct blob may name what the diff appears to do. Specialist playbooks are not procedure context. The router does not dump a gatherer follow transcript here.

The router passes the comparison plus the PR-body and design-excerpt
products when those exist, plus the reconstruct blob. The router calls
that seed the **intent-seed**; it is built after `review-blind` returns
and is the same bytes on a nested Task child and on a CloudAgent. This
seat starts only after that blob exists — never with blind. This seat owns
advertised-path and procedure-clash candidates. It may also emit
other intent- or docs-aware candidates.

## Hard rules

- Read-only. No edits, no commits, no pushes, no GitHub review comments. Do not create a fix branch.
- Run in a fresh context. That context includes the comparison, the PR body / design excerpt / commit message / procedure context the router passed, and the reconstructed-intent blob. Orient dumps and the onboard product are not procedure context. The blind candidate list (`title — path:line` entries, including leftovers) is not procedure context and is not a list of candidates to copy. The reconstruct blob may name what the diff appears to do. Specialist playbooks are not procedure context. The blind candidate list in this window is a Failure. A reconstruct sentence that names a helper is not that Failure.
- Do not read or apply `gates.md`. Do not drop a candidate to “save the verifier work.”
- Do not write Findings / Assessment / Close. That envelope is `review-verify`.
- Do not drop a candidate because it was not introduced by this change. Emit it.
- Review the passed comparison plus the PR / design / procedure context and the reconstruct blob the router passed. Do not tour the rest of the repo. Do not treat the blind candidate list as candidates to copy.
- Mixed turn (“review this, then fix it”): candidates only, then hand back to the compose. Do not implement.
- If invoked with no comparison: cheap-resolve as `review-scope` would. Empty/unresolvable → `No candidates.`
- If invoked with a plan/spec/design and no procedure file in the comparison: `No candidates.` Point at `review-changes` (out of family is the router’s stop).

## Procedure

1. Inspect the complete comparison. For working tree: `git diff HEAD` **and** every untracked path in the file list. Untracked files are first-class — Read each, or `git diff --no-index -- /dev/null <path>`. Do not skip them because they are absent from `git diff HEAD`. Do not `git add`.
   For a named patch or branch/PR three-dot: inspect that complete diff, plus enough surrounding code to name a candidate.
2. Read the PR body / design excerpt / procedure context and the reconstruct blob the router passed. Use them. Advertised-path misses and procedure clashes are this seat’s job when that context is present. The blind candidate list is not this context.
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
| “Parent has orient / onboard — treat it as procedure context” | Orient dumps and the onboard product are not procedure context. Use what the router passed. |
| “Blind leftover titles are procedure context — copy them” | The sibling’s candidate list is not procedure context and not a list to copy. The blob is the seed. |
| “The blob named a leftover helper — this window is already dirty” | A reconstruct sentence that names a helper is not the list. The list is the leak. |
| “Parent has a specialist playbook — treat it as procedure context” | The playbook is not procedure context. Use what the router passed. |
| “I’ll just fix it while I’m here” | Seat turn is read-only. Hand back to the compose. |

## Failures

- Applying `gates.md` or reading it
- Writing Findings / Assessment / Close
- Dropping a candidate as pre-existing
- Implementing, editing, committing, pushing, or posting a GitHub review
- Skipping advertised-path or procedure-clash when the router passed that context
- Treating a specialist playbook, an orient dump, or the onboard product as procedure context
- Treating the blind candidate list (`title — path:line` entries, including leftovers) as procedure context or as candidates to copy
- The blind candidate list (`title — path:line` entries, including leftovers) was passed into this window. A reconstruct sentence that names a helper is not this Failure.
- Touring the repo outside the comparison
