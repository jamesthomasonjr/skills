# Review gates

Verifier playbook for the review family. `review-verify` is **REQUIRED**
to follow this file. The router does not apply it and does not restate
it. Seats generate candidates and do not apply this file.

Flag a finding only when **all five** are true. If any gate is shaky, **drop**. When in doubt about impact, drop — except a demonstrated unsatisfiable pair in a procedure file (see Procedure files) or a this-PR advertised-path miss (see Advertised paths).

## Five gates

1. Meaningful correctness / security / performance / maintainability.
2. Discrete and actionable.
3. Introduced by this change, not pre-existing.
4. Affected scenario or call path demonstrable from the code.
5. Names a **concrete bad outcome** (what breaks, for whom).

## Suppressions

Never a numbered finding:

- Style, naming, comment, or formatting nits — including when the user said “nits are fine” or “flag anything.”
- Extra blank lines, header comments that restate the filename, and local identifier renames with no behavior change.
- Anything a linter, formatter, or typechecker already enforces.
- Speculative “might break” with no demonstrable call path. A this-PR advertised-path miss is not speculative (see Advertised paths).
- Intentional behavior the diff is clearly aiming at. Designed idle-when-no-handoff does not cover a hook whose extractor can never see a handoff.
- Pre-existing issues — never a numbered finding. Host-not-advertised (example: native-worktree) is at most **one** Assessment residual line, separate from leftover lines, not counted in the 1–3 sentence cap. Seat-emitted leftovers that were dropped: Assessment names **each** leftover as extra lines under that heading (title + file:line), one leftover per line. Those leftover lines are not counted in the 1–3 sentence cap. Do not mix leftover titles with the host-not-advertised line. Do not number leftovers. A this-PR advertised-path miss is not residual.
- A “Minor / nit / consider” bucket. There is no such bucket. Listing nits then labeling them “nits only” is still a failed empty pass.

## Severity

Assign only to survivors:

- `P0` — universal release blocker or critical failure (does not depend on exotic inputs).
- `P1` — urgent defect that should be fixed next.
- `P2` — ordinary defect that should be fixed.
- `P3` — low-impact issue that is still worth fixing (and still passes all five gates).

A naming nit is not a P3. It is dropped.

## Empty pass vs stop

A **successful empty review** means a real comparison was inspected and nothing survived the gates. Write exactly `No findings.` as the Findings block, then Assessment and Close. Do not invent a finding. “Be thorough” / “complete review” / “flag anything” does not authorize nits.

**Stop paths** are not empty reviews. Write only `Nothing to review.` (empty or unresolvable target) or a 1–2 sentence `shape-*` pointer (plan / spec / design). Do not wrap those in Findings / Assessment / Close.

## Cite

Smallest `path:line` (or short range) that overlaps the reviewed diff.

## Procedure files

Only these, and only when they appear in the comparison:

- any `SKILL.md`
- a playbook a `SKILL.md` is **REQUIRED** to follow that is also in the comparison (`gates.md`, `levels.md`, `paths.md`, `modes.md`, and the same pattern: linked from a skill as required)

Not procedure: README, design spec, implementation plan, ordinary docs, comments in app code.

When a procedure file is in the comparison, an **unsatisfiable pair of instructions** is a finding. All five gates can be true:

1. Correctness of the procedure (the next agent cannot follow both letters).
2. Discrete and actionable (name the two letters and the file:line).
3. Introduced by this change.
4. Demonstrable from the procedure text and, if present, fixtures/GREEN that already follow one letter and violate the other. This is the call path. It does not require application runtime.
5. Concrete bad outcome: the next agent does the wrong stop, path, dispatch, empty pass, or drop of a required step. Victim is the next agent, not an end user.

Still **DROP**: wording nits, missing nice-to-have sections, “could be clearer,” a count band the author kept on purpose when the rest of the letter already agrees, speculative “an agent might misread,” ordinary README/docs prose, plan/spec/design with no procedure diff (still out of family → `shape-*`).

“When in doubt, drop” still applies to app code and to shaky procedure nits. It does **not** authorize dropping a demonstrated unsatisfiable pair in a procedure file.

Do not apply this rule to app-code contradictions unless they already pass today’s five gates the original way.

## Advertised paths

App-code gates stay tight except this class. Do not stretch the Procedure files rule onto `hooks.json` or ordinary docs.

**Residual** = the host has not advertised a capability yet (example: native-worktree). At most one Assessment residual line. Never a numbered finding.

**Finding** = this change’s own hook, header, or extractor cannot do what it claims.

Example: this PR registers a Stop hook and `HOST_EXEC` claims the host auto-executes via Stop, but `_extract_handoff` reads `id` / `from` / `on` while Stop stdin is `session_id` / `stop_hook_active`. Designed idle-when-no-handoff does **not** cover “this PR’s only registered Stop hook can never have a handoff.”

Gate 4: hook/tool stdin shape and the extractor in this comparison are the call path. Live harness eval is not required.

“No live harness eval” / “it might fail in production” is not a drop for that class. Do not park that class in Assessment residual.

All five gates can be true:

1. Correctness of the advertised path (the hook, header, or extractor cannot do what this change claims).
2. Discrete and actionable (name the claim and the stdin/extractor miss; file:line).
3. Introduced by this change.
4. Demonstrable from the hook/tool stdin shape and the extractor in this comparison. This is the call path. Live harness eval is not required.
5. Concrete bad outcome: the advertised auto-exec never runs for the victim of the claim. Designed idle-when-no-handoff does not cover a hook that can never see a handoff.

Still **DROP**: wording nits, speculative “might break” with no this-PR advertised path, pre-existing host gaps (at most one Assessment residual line), plan/spec with no procedure or advertised-path diff (still out of family → `shape-*`).

“When in doubt, drop” still applies to ordinary app code. It does **not** authorize dropping a this-PR advertised-path miss, and it does **not** authorize inventing findings for host-not-advertised residuals.
