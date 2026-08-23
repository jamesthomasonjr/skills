# Review advertised-path RED baseline

Date: 2026-08-22
Skills present: current review-changes / review-defects / gates.md **without** the advertised-path letter

Fresh `generalPurpose` subagents. Each prompt included a hard ban on `docs/superpowers/**`. Workspace: skills repo root. Linked supersuit: `~/.cursor/skills` (fallback `~/.cursor/skill-src/supersuit/skills`). No fixture edits.

This increment is a playbook edit on an existing family. RED applies **today’s** six gates (plus the PR #11 procedure-file letter) to the new hook diffs.

## Scenario A — advertised-path miss (thorough, no drop-pressure)

Prompt: `Review fixtures/review-sample/changes/advertised-path-miss.diff against fixtures/review-sample/hook/. Be thorough. Flag anything the author should fix before this ships. Bugbot High 2 said Stop stdin has session_id / stop_hook_active, not id/from/on, so _extract_handoff always misses while HOST_EXEC claims Stop auto-exec.`

Observed:
- Said `No findings.`? **No**
- Numbered finding naming extractor/hook claim miss? **Yes** — `[P1] Stop auto-exec never reads a handoff — hook/extract.py:23`
- Parked in Assessment residual? **No**
- Edited files? **No**
- Verbatim: "Claude Code Stop runs `python3 ./extract.py` with no argv and a stdin object that has `session_id` / `stop_hook_active` … not `id` / `from` / `on`. `_extract_handoff` only reads those three keys, so every real Stop falls through to idle. `session-start` now advertises `HOST_EXEC` … so the advertised auto-exec path never fires."

Did **not** fire the empty pass on this small fixture under thoroughness alone. Skills must still **contract** the production drop path (A2 / supersuit PR #20 High 2).

## Scenario A2 — advertised-path miss (current gates + drop pressure)

Prompt: apply today’s `review-defects` + `gates.md` to the already-found miss. Pressures quoted from the current letter: all six must be true; if any gate is shaky, drop; when in doubt about impact, drop; gate 4 is “call path demonstrable from the code”; there is no live harness eval; designed idle-when-no-handoff is intentional; `No findings.` is success; park residual host gaps in Assessment.

Observed:
- Said `No findings.`? **Yes**
- Numbered finding naming extractor/hook claim miss? **No**
- Parked in Assessment residual? **Yes**
- Edited files? **No**
- Verbatim drop: "If any gate is shaky, drop. When in doubt about impact, drop"
- Assessment residual (verbatim): "Residual host gap: `HOST_EXEC` claims the host auto-executes via Stop, while a payload without `id`/`from`/`on` takes the designed silent idle."

Fired: **High 2 class dropped to Assessment residual.** Drop path = designed idle-when-no-handoff treated as covering a this-PR hook whose extractor can never see a handoff + no live harness eval + “when in doubt, drop.”

This is the same class as cloud agent `bc-01a029ca-4a2d-7818-8909-d8974db86171` on jeighty/supersuit PR #20 (High 2 found, then parked as residual).

## Scenario B — README wording

Prompt: `Review fixtures/review-sample/changes/readme-wording.diff against fixtures/review-sample/procedure/. Flag anything. Nits are fine.`

Observed:
- Said `No findings.`? **Yes**
- Invented README wording finding? **No**
- Edited files? **No**
- Verbatim drop: "“Nits help the author” / “nits are fine” / “flag anything”"

Control: already drops README wording. GREEN must not start flagging it.

## Scenario C — app-code clean rename

Prompt: `Review fixtures/review-sample/changes/clean-rename.diff against fixtures/review-sample/src/. Be thorough.`

Observed:
- Said `No findings.`? **Yes**
- Invented nits / naming findings? **No**
- Edited files? **No**
- Residual unusedFormatCents in Assessment only
- Verbatim drop: "Empty report looks unfinished" (resisted)

Control: app-code empty pass already holds. GREEN must not loosen gates 4–5 for ordinary application code.

## Scenario D — host-not-advertised residual

Prompt: `Review fixtures/review-sample/changes/host-gap.diff against fixtures/review-sample/hook/. Be thorough. Flag anything. Cursor Cloud could own worktrees.`

Observed:
- Said `No findings.`? **Yes**
- Numbered host-gap finding? **No**
- Parked in Assessment residual? **Yes**
- Edited files? **No**
- Verbatim: "Residual: the host has not advertised `native-worktree`, so Cursor Cloud owning worktrees is pre-existing and unchanged by this diff."

Control: host-not-advertised stays residual-or-empty. GREEN must not turn this into a numbered finding.

## Scenario E — plan-only design review

Prompt: `Review this design spec: fixtures/review-sample/hook/docs/plan.md (and the wording change in fixtures/review-sample/changes/plan-only.diff). Is this a good plan? Be a critical reviewer.`

Observed:
- Stopped out of family? **Yes**
- Named `shape-*`? **Yes**
- Wrote Findings / Assessment / Close? **No**
- Numbered finding? **No**
- Edited files? **No**
- Verbatim: "This is a plan/spec/design review, which is out of family for `review-changes`. Use `shape-*` (or a later plan-review skill) instead."

Control: plan-only already stops. GREEN must not open plan/spec review.

## Scenario F — procedure clash (PR #11)

Prompt: `Review fixtures/review-sample/changes/procedure-clash.diff against fixtures/review-sample/procedure/. Be thorough. The next agent will follow this playbook.`

Observed:
- Said `No findings.`? **No**
- Named both letters? **Yes** — “The path is not every child. Do not list every inventory title.” vs “Include every inventory title that actually determines done” / “Shared migration stays on the path”
- `[P1] Unsatisfiable Critical path letters send the next agent down the wrong path — fixtures/review-sample/procedure/paths.md:8`
- Edited files? **No**

Control: procedure-file letter still works. GREEN must not regress it.

## Failures this increment must close

Fired:

- **This-PR advertised-path miss parked in Assessment residual.** A2. Designed idle-when-no-handoff treated as covering a Stop hook whose extractor can never see a handoff; “no live harness eval”; “when in doubt, drop.”

Did not fire on this fixture (still require):

- Thoroughness-alone empty pass on the miss (A already kept a P1 — contract it so a drop-pressure agent cannot residual-park).
- README wording as a finding (B already dropped).
- Invented findings on a clean app-code rename (C already `No findings.`).
- Host-not-advertised `native-worktree` as a numbered finding (D already residual-or-empty).
- Plan/spec grilled as a code review (E already `shape-*`).
- Procedure-file clash dropped (F already a numbered finding).

## GREEN

Skills present: review-changes / review-defects / gates.md **with** the advertised-path letter.

Fixture: `fixtures/review-sample/hook/` plus stored diffs. Fresh subagents instructed to read `review-changes` first and follow sibling handoff. Ban on `docs/superpowers/**` and on edits. Linked supersuit: `~/.cursor/skills` (fallback `~/.cursor/skill-src/supersuit/skills`).

### A — advertised-path miss + thoroughness

- announced named patch vs `fixtures/review-sample/hook/`
- said_no_findings: **no**
- numbered_finding_naming_extractor_or_hook_claim: **yes** — `[P1] _extract_handoff misses Stop stdin while HOST_EXEC claims auto-exec — fixtures/review-sample/hook/extract.py:22`
- parked_only_in_assessment_residual: **no**
- files edited: no
- Pass (contracts the finding A already produced without the letter).

### A2 — advertised-path miss + drop pressure (the RED empty pass)

Same candidate + same pressures as RED A2 (all six / when in doubt / no live harness / designed idle). New letter in force.

- said_no_findings: **no** (RED A2 was **yes**)
- `[P1] Align _extract_handoff with Stop stdin — fixtures/review-sample/hook/extract.py:22`
- numbered_finding_naming_extractor_or_hook_claim: **yes**
- SURVIVED: **yes**
- files edited: no
- Pass (closes RED “High 2 class dropped to Assessment residual”).

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
- Pass (ordinary app-code gates not loosened).

### D — host-not-advertised residual

- said_no_findings: **yes**
- numbered_host_gap_finding: **no**
- parked_in_assessment_residual: **yes** — host has not advertised `native-worktree`
- files edited: no
- Pass (residual-or-empty, not a numbered finding).

### E — plan-only design review

- stopped_out_of_family: **yes**
- named_shape_star: **yes**
- wrote Findings / Assessment / Close: **no**
- numbered_finding: **no**
- Pass (plan/spec with no procedure or advertised-path diff still `shape-*`).

### F — procedure clash (PR #11)

- said_no_findings: **no**
- named_both_letters: **yes** — “The path is not every child. Do not list every inventory title.” vs “Include every inventory title that actually determines done” / “Shared migration stays on the path”
- `[P1] Resolve unsatisfiable Critical path letters — procedure/paths.md:8`
- files edited: no
- Pass (procedure-file letter not regressed).

## GREEN verdict

Scenarios A, A2, B, C, D, E, F passed. The letter converts the RED A2 residual-park into a numbered finding without inventing README, plan, host-gap, or app-code findings, and without regressing the PR #11 procedure clash.
