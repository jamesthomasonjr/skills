# Review gates

Shared playbook for `review-changes` and `review-defects`. The leaf is **REQUIRED** to follow this file. The router does not restate it.

Flag a finding only when **all six** are true. If any gate is shaky, **drop**. When in doubt about impact, drop.

## Six gates

1. Meaningful correctness / security / performance / maintainability.
2. Discrete and actionable.
3. Introduced by this change, not pre-existing.
4. Affected scenario or call path demonstrable from the code.
5. Names a **concrete bad outcome** (what breaks, for whom).
6. The author would probably fix it if they knew about it.

## Suppressions

Never a numbered finding:

- Style, naming, comment, or formatting nits — including when the user said “nits are fine” or “flag anything.”
- Extra blank lines, header comments that restate the filename, and local identifier renames with no behavior change.
- Anything a linter, formatter, or typechecker already enforces.
- Speculative “might break” with no demonstrable call path.
- Intentional behavior the diff is clearly aiming at.
- Pre-existing issues — at most **one residual-risk line** in Assessment, never a numbered finding.
- A “Minor / nit / consider” bucket. There is no such bucket. Listing nits then labeling them “nits only” is still a failed empty pass.

## Severity

Assign only to survivors:

- `P0` — universal release blocker or critical failure (does not depend on exotic inputs).
- `P1` — urgent defect that should be fixed next.
- `P2` — ordinary defect that should be fixed.
- `P3` — low-impact issue that is still worth fixing (and still passes all six gates).

A naming nit is not a P3. It is dropped.

## Empty pass vs stop

A **successful empty review** means a real comparison was inspected and nothing survived the gates. Write exactly `No findings.` as the Findings block, then Assessment and Close. Do not invent a finding. “Be thorough” / “complete review” / “flag anything” does not authorize nits.

**Stop paths** are not empty reviews. Write only `Nothing to review.` (empty or unresolvable target) or a 1–2 sentence `shape-*` pointer (plan / spec / design). Do not wrap those in Findings / Assessment / Close.

## Cite

Smallest `path:line` (or short range) that overlaps the reviewed diff.
