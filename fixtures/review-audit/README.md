# review-audit

Tiny recorded dumps used to test the existing-codebase audit skill.

Protocol: `review-audit` takes a named path, module, or “the codebase.”
That scope is **not** a git comparison. Do not Follow `review-scope`.
Do not fan change-review seats. Do not apply `gates.md` / Gate 3.
Tour the named scope. Leftover / pre-existing debt is a **numbered
finding**, not a Follow-ups leftover. Catch-me-up / orient-* are not
required seats. A parent-held primer product may seed the tour.

Do not reopen the change-review GREEN table in
`fixtures/review-sample/`. Those nine rows stay comparison-only.
`unusedFormatCents` / `refundOrder` stay Follow-ups on clean diffs
for `review-changes`. This fixture scores a **different consumer**.

The sample tree for leftover letters is `fixtures/review-sample/src/`.
Do not name that helper in `review-audit`’s `SKILL.md`.

Replay (no live audit agents):

```bash
./scripts/score-review-audit-dump-letters.sh
./scripts/test-score-review-audit-dump-letters.sh
```

GREEN leftover is a numbered finding: an unused helper / dead export
visible in the named scope is `[P#] title — path:line` under Findings.
Not Follow-ups. Not silent drop. Pre-existing is expected.

RED leftover parked under Follow-ups: the leftover is only an unnumbered
Follow-ups line (change-review leftover home). Audit treats that class
as a finding.

GREEN codebase is a scope: “the codebase” / a named path / a named
module resolved as `path` / `module` / `codebase`. No comparison
command. `used_review_scope` is false. `used_review_regression` is
false.

RED codebase turned into a comparison: the dump Followed
`review-scope`, invented a git comparison, or toured via
`review-regression`.

GREEN parent-held primer: the parent already held an onboard / orient
product for this scope and the audit used it. Those skills were not
required seats.

RED planted orient seat: the dump required `catch-me-up` /
`orient-repo` / `orient-module` / `orient-function` as a seat step.

RED change-review reuse: the dump applied `gates.md`, Followed
`review-verify`, or dropped a leftover because it was not introduced
by a change (Gate 3).
