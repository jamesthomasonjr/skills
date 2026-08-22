# Review procedure-letter RED baseline

Date: 2026-08-21
Skills present: current review-changes / review-defects / gates.md **without** the procedure-file rule

Fresh `generalPurpose` subagents. Each prompt included a hard ban on `docs/superpowers/**`. Workspace: skills repo root. Linked supersuit: `~/.cursor/skills` (fallback `~/.cursor/skill-src/supersuit/skills`). No fixture edits.

This increment is a playbook edit on an existing family. RED applies **today’s** six gates to the new procedure diffs.

## Scenario A — procedure clash (thorough, no drop-pressure)

Prompt: `Review fixtures/review-sample/changes/procedure-clash.diff against fixtures/review-sample/procedure/. Be thorough. Flag anything the author should fix before this ships. The next agent will follow this playbook.`

Observed:
- Said `No findings.`? **No**
- Named both letters? **Yes** — “Do not list every inventory title” vs “Include every inventory title that actually determines done.”
- `[P1] Reconcile contradictory Critical path inclusion rules — fixtures/review-sample/procedure/paths.md:8`
- Edited files? **No**
- Verbatim: "An agent cannot satisfy both: if the remaining titles all determine done, the new rule drops required titles from Path; if it keeps them, it violates the new rule."

Did **not** fire the empty pass on this small fixture under thoroughness alone. Skills must still **contract** the production drop path (A2 / supersuit PR #19).

## Scenario A2 — procedure clash (current gates + drop pressure)

Prompt: apply today’s `review-defects` + `gates.md` to the already-found clash. Pressures quoted from the current letter: all six must be true; if any gate is shaky, drop; when in doubt about impact, drop; gate 4 is “call path demonstrable from the code”; gate 5 is a concrete bad outcome (what breaks, for whom); do not grill plan/spec prose; this is markdown, not application runtime; `No findings.` is success.

Observed:
- Said `No findings.`? **Yes**
- Named both letters as a numbered finding? **No**
- Edited files? **No**
- Verbatim: "The patch only adds scoping lines on the critical-path playbook beside the existing include-what-determines-done and shared-migration rules; nothing in the comparison demonstrates a broken call path or a concrete bad outcome."

Fired: **empty pass on a demonstrated unsatisfiable pair.** Drop path = gate 4 (“from the code”) + gate 5 (no runtime user break) + “when in doubt, drop” + “do not grill prose.”

This is the same class as cloud agent `bc-01a0249c-f75f-7705-aae2-f30db2f7108b` on jeighty/supersuit PR #19 (comparison correct; candidates found; then dropped).

## Scenario B — README wording

Prompt: `Review fixtures/review-sample/changes/readme-wording.diff against fixtures/review-sample/procedure/. Flag anything. Nits are fine.`

Observed:
- Said `No findings.`? **Yes**
- Invented README wording finding? **No**
- Edited files? **No**
- Verbatim drop: "Style, naming, comment, or formatting nits — including when the user said ‘nits are fine’ or ‘flag anything.’"

Control: already drops README wording. GREEN must not start flagging it.

## Scenario C — app-code clean rename

Prompt: `Review fixtures/review-sample/changes/clean-rename.diff against fixtures/review-sample/src/. Be thorough.`

Observed:
- Said `No findings.`? **Yes**
- Invented nits / naming findings? **No**
- Edited files? **No**
- Residual unusedFormatCents in Assessment only
- Verbatim drop: "local identifier renames with no behavior change"

Control: app-code empty pass already holds. GREEN must not loosen gates 4–5 for application code.

## Scenario D — procedure nit

Prompt: `Review fixtures/review-sample/changes/procedure-nit.diff against fixtures/review-sample/procedure/. Flag anything. Nits are fine. I want a complete review.`

Observed:
- Said `No findings.`? **Yes**
- Flagged “could be clearer”? **No**
- Edited files? **No**
- Verbatim drop: "This section could be clearer about how to phrase titles" → style/comment nit; Gate 1 and Gate 5 shaky

Control: procedure nits already drop. GREEN must keep that.

## Scenario E — plan-only design review

Prompt: `Review this design spec: fixtures/review-sample/procedure/docs/plan.md (and the wording change in fixtures/review-sample/changes/plan-only.diff). Is this a good plan? Be a critical reviewer.`

Observed:
- Stopped out of family? **Yes**
- Named `shape-*`? **Yes** (`shape-task` / `shape-feature`)
- Wrote Findings / Assessment / Close? **No**
- Grilled the plan? **No**
- Edited files? **No**
- Verbatim: "This is a plan/spec/design review with no code or procedure diff… out of family for `review-changes` — use `shape-*`"

Control: plan-only already stops. GREEN must not open plan/spec review.

## Failures this increment must close

Fired:

- **Demonstrated procedure-file clash dropped under current gates.** A2. Gate 4 read as application call path; gate 5 read as runtime user break; “when in doubt, drop”; “do not grill prose” applied to a required playbook.

Did not fire on this fixture (still require):

- Thoroughness-alone empty pass on the clash (A already kept a P1 — contract it so a drop-pressure agent cannot empty-pass).
- README wording as a finding (B already dropped).
- Invented findings on a clean app-code rename (C already `No findings.`).
- Procedure “could be clearer” as a finding (D already dropped).
- Plan/spec grilled as a code review (E already `shape-*`).

## GREEN

Skills present: review-changes / review-defects / gates.md **with** the procedure-file letter.

Fixture: `fixtures/review-sample/procedure/` plus stored diffs. Fresh subagents instructed to read `review-changes` first and follow sibling handoff. Ban on `docs/superpowers/**` and on edits. Linked supersuit: `~/.cursor/skills` (fallback `~/.cursor/skill-src/supersuit/skills`).

### A — procedure clash + thoroughness

- announced named patch vs `fixtures/review-sample/procedure/`
- said_no_findings: **no**
- named_both_letters: **yes** — “Do not list every inventory title” vs “Include every inventory title that actually determines done” / “Shared migration stays on the path”
- `[P1] Resolve contradictory Critical path letters — procedure/paths.md:8`
- files edited: no
- Pass (contracts the finding A already produced without the letter).

### A2 — procedure clash + drop pressure (the RED empty pass)

Same candidate + same pressures as RED A2 (all six / when in doubt / markdown not runtime). New letter in force.

- said_no_findings: **no** (RED A2 was **yes**)
- `[P1] Unsatisfiable Path letters — procedure/paths.md:8`
- named_both_letters: **yes**
- SURVIVED: **yes**
- files edited: no
- Pass (closes RED “empty pass on a demonstrated unsatisfiable pair”).

### B — README wording + “flag anything”

- said_no_findings: **yes**
- numbered_readme_finding: **no**
- files edited: no
- Pass (still drop ordinary docs prose).

### C — app-code clean rename

- said_no_findings: **yes**
- invented_app_code_finding: **no**
- residual unusedFormatCents in Assessment only
- files edited: no
- Pass (app-code gates not loosened).

### D — procedure nit + “flag anything”

- said_no_findings: **yes**
- flagged_could_be_clearer: **no**
- files edited: no
- Pass (procedure nit still drops).

### E — plan-only design review

- stopped_out_of_family: **yes**
- named_shape_star: **yes**
- wrote Findings / Assessment / Close: **no**
- numbered_finding: **no**
- Pass (plan/spec with no procedure diff still `shape-*`).

## GREEN verdict

Scenarios A, A2, B, C, D, E passed. The letter converts the RED A2 empty pass into a numbered finding without inventing README, plan, procedure-nit, or app-code findings.
