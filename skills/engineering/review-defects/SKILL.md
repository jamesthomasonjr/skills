---
name: review-defects
description: >-
  Defect-first read-only review of a specified comparison. Use when
  review-changes hands off, or the user explicitly wants findings against
  a named diff, commit, branch, or working tree. May return No findings.
  Does not implement.
disable-model-invocation: true
---

# Review defects

Read-only, defect-first review of **this change**. May return `No findings.`

**REQUIRED:** Follow [../review-changes/gates.md](../review-changes/gates.md). Read it before writing findings. Resolve that path from this file’s directory, not cwd. After `~/.cursor/skills/review-defects` symlink, a bare `gates.md` read misses.

Do not paste the six gates into this file. If any gate is shaky, **drop**. When in doubt, drop.

## Hard rules

- Read-only. No edits, no commits, no pushes, no GitHub review comments. Do not create a fix branch.
- Review the passed comparison only. Do not tour the rest of the repo.
- Mixed turn (“review this, then fix it”): finish this review, then **hand back**. Do not implement. **Do not edit in this turn even if the user already asked for a fix** — that message is the review, not an implement go-ahead. They must send a **new message** after the review. Do not discard the fix request.
- If invoked with a plan/spec/design and no code diff: stop. Out of family. Point at `shape-*`. Do not produce findings. Do not grill the prose.
- If invoked with no comparison: cheap-resolve as `review-changes` would. Empty/unresolvable → `Nothing to review.`

## Procedure

If this is a stop path (empty/unresolvable, or plan/spec/design with no code diff), skip steps 1–5. Write only the stop.

1. Inspect the complete comparison. For working tree: `git diff HEAD` **and** every untracked path in the file list. Untracked files are first-class — Read each, or `git diff --no-index -- /dev/null <path>`. Do not skip them because they are absent from `git diff HEAD`. Do not `git add`. Untracked-only is a real comparison: do not write `Nothing to review.` or `No findings.` without inspecting those files.
   For a named patch or branch/PR three-dot: inspect that complete diff, plus enough surrounding code and tests to confirm each candidate.
2. Continue through the whole diff after the first issue. Do not stop at one finding. Do not read files outside the file list except to demonstrate a call path for a candidate that already overlaps the diff.
3. Apply every gate in `gates.md` to each candidate. Drop if any is shaky.
4. Skip everything under Suppressions — including when they said “nits are fine” or “flag anything.”
5. Assign P0–P3 only to survivors.
6. If this is a **stop path**, write only that stop (below). Otherwise write the output contract. Then stop (or hand back).

## Stop paths (no three-block contract)

These are **not** empty reviews. Do **not** emit Findings, Assessment, or Close.

- Empty or unresolvable target: exactly `Nothing to review.`
- Plan / spec / design with no code diff: 1–2 sentences, point at `shape-*`, stop.

## Output contract (in order)

Skip this entire section on stop paths.

Otherwise always emit these three blocks, in this order, with these headings:

1. **Findings** — one entry per survivor, severity-first:

   `[P1] Imperative title — path/to/file:line`

   Then one short paragraph: affected scenario, concrete bad outcome, why the change is wrong. No second paragraph. No patch. No suggestion block.

   **Or**, if none survive: this block is exactly `No findings.`

2. **Assessment** — 1–3 sentences: target + comparison, material test gaps, residual pre-existing risk (at most one line). No merge stamp. No LGTM.

3. **Close** — required heading, one line. Mixed-turn: review is done; they must send a **new message** to implement. Otherwise: the review is finished (do not add findings).

No other sections. No “Nice to have.” No praise. No nit list after `No findings.`

## Rationalizations

| Excuse | Reality |
|---|---|
| “Empty report looks unfinished” | `No findings.` is success. Inventing a finding is the failure. |
| “Nits help the author” / “nits are fine” / “flag anything” | Nits are not findings. Drop them. Complete ≠ whitespace. |
| “This pre-existing bug is serious” | Residual-risk line in Assessment. Never a numbered finding. |
| “It might fail in production” | Speculative → drop. Demonstrate the call path or drop. |
| “When in doubt, flag it” | When in doubt, **drop**. |
| “I’ll just fix it while I’m here” | Review turn is read-only. Hand back. New message to implement. |
| “A Minor section keeps the nits somewhere” | There is no nit bucket. Drop them. Listing nits then calling them nits is still a fail. |
| “Thorough means more findings” | Thorough means every qualifying defect, and nothing else. |
| “They asked me to be a critical reviewer of a plan” | Out of family. Stop. Point at `shape-*`. Do not review prose here. |
| “Always emit Findings / Assessment / Close” | Only after a real comparison. Stop paths skip the contract. Do not wrap `Nothing to review.` |
| “git diff HEAD was empty, so nothing to review” | Untracked files are not in `git diff HEAD`. Inspect them. Do not `git add`. |

## Failures

- Invented findings on a clean change
- Style / naming / comment nits as findings
- Pre-existing issue as a numbered finding
- Whole-repo review outside the comparison
- Implementing, editing, committing, pushing, or posting a GitHub review
- A “Minor / nit / consider” bucket
- A finding with no concrete bad outcome
- Merge stamp / LGTM theater
- Reviewing a plan/spec/design as if it were a code diff
- Grilling a design instead of stopping out of family
- Wrapping `Nothing to review.` or a `shape-*` stop in Findings / Assessment / Close
- Skipping untracked working-tree files because `git diff HEAD` is empty
