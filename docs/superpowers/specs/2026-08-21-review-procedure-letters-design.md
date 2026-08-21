# Review procedure-letter findings

Date: 2026-08-21
Status: approved (v1 gate addition; do not reopen)
Repo: jamesthomasonjr/skills

Increment to `docs/superpowers/specs/2026-08-20-review-skill-family-design.md`.
Does not replace that spec.

## Problem

In this catalog (and in supersuit), `SKILL.md` and the playbooks a skill is **REQUIRED** to follow **are** the product. Two instructions that cannot both be followed have a concrete bad outcome: the next agent takes the wrong stop, path, or dispatch.

Codex `$review-agent` reports that class. This family drops it.

JT used Codex on the size-work Path PR and got a real P2: `paths.md` said both “not every child / not the priority list” and “shared migration stays on the path,” which cannot both be followed. He then used `review-changes` → `review-defects` and commonly got `No findings.`

Example empty pass: cloud agent `bc-01a0249c-f75f-7705-aae2-f30db2f7108b` on **jeighty/supersuit PR #19** (not skills PR #10). Comparison was correct (`origin/main`…PR tip). The agent found ~5 candidates, including the same class of defect (brainstorming says load `visual-surface`; using-superpowers says treat it as a run action and do not load), then **dropped them**. Gate 5 wanted a runtime user break. “When in doubt, drop” did the rest. `review-defects` also says do not grill plan/spec prose.

Calibration gap, not a missing skill: the six gates can all be true for an unsatisfiable procedure pair, but today’s letter is written for application code. Agents read “call path from the code” and “what breaks, for whom” as requiring an end-user runtime, then drop.

## Goals

- When a **procedure file** is in the comparison, an **unsatisfiable pair of instructions** is a finding.
- Keep one review family. Router still classifies the git comparison and does **not** review.
- `gates.md` stays authoritative. The leaf is required to follow it. Same letter in gates + leaf so they cannot disagree.
- Do **not** loosen the six gates for application code.
- Still drop wording nits, “could be clearer,” README/docs prose, and plan/spec/design with no procedure diff.

## Non-goals

- A new promoted skill (`review-skill`, `review-brief`, or any other leaf).
- A new classify row that routes procedure files away from `review-defects`.
- Opening plan/spec review. Plan/spec/design with no procedure diff stays out of family → `shape-*`.
- Loosening gates for application-code contradictions.
- Catalog or plugin changes unless a one-liner would otherwise be untrue (v1: unchanged).
- Editing jeighty/supersuit. No PR against that repo.
- Authoring-quality review (“is this skill well-authored?” with no diff). Route to a separate skill later only if that ask appears; not this change.

## Sources

| Source | What we take | What we drop |
|---|---|---|
| Existing review family | Thin router; `gates.md` playbook; six gates; DROP; `No findings.`; P0–P3; output contract; sibling reads | New leaf; plan/spec review; nit bucket |
| Codex `$review-agent` on the Path PR | Unsatisfiable procedure pair is a real P2; victim is the next agent | JSON schema; suggestion blocks |
| supersuit PR #19 empty pass | Gate 5 + “when in doubt, drop” + “do not grill prose” are the drop path | Changing supersuit |

## Approaches considered

1. **Extra rule on existing gates + leaf (recommended, v1).** `gates.md` stays the playbook. When the file list includes procedure files, the leaf applies the extra rule while inspecting those files. Router classify table unchanged. Matches “keep one family.”
2. **New `review-skill` / `review-brief` leaf.** Rejected. JT decided: keep one family; route to a separate skill only later if the ask is “is this skill well-authored?” with no diff.
3. **Loosen gates 4–5 globally.** Rejected. That would invent findings on app-code “might break” speculation. App-code gates stay as they are.

v1 is approach 1.

## Architecture

No new promoted skills. One sequential agent. Same two skills.

```
skills/engineering/
  review-changes/
    SKILL.md       # router: unchanged classify. Does not review.
    gates.md       # six gates (app code unchanged) + procedure-file rule
  review-defects/
    SKILL.md       # leaf: follow gates.md; same procedure-file letter
```

Hard rules that stay true:

- Router classifies, announces, hands off. Does not apply gates. Does not write findings.
- Leaf reviews the passed comparison only.
- Flag a finding only when **all six** gates are true.
- App-code contradictions use today’s six-gate reading. Do not apply the procedure-file rule to app code unless the candidate already passes those gates the original way.
- Plan/spec/design with no procedure diff: still out of family. Do not grill that prose.

## Procedure files

Only these, and only when they appear in the comparison:

- any `SKILL.md`
- a playbook a `SKILL.md` is **REQUIRED** to follow that is also in the comparison (`gates.md`, `levels.md`, `paths.md`, `modes.md`, and the same pattern: linked from a skill as required)

Not procedure:

- README
- design spec
- implementation plan
- ordinary docs
- comments in app code

The leaf decides this from the file list the router already passed. No new classify row. If the file list includes procedure files, the leaf applies the extra rule **while inspecting those files**. Other files in the same comparison still use today’s gates.

## New rule (same letter in `gates.md` and the leaf)

When a procedure file is in the comparison, an **unsatisfiable pair of instructions** is a finding. All six gates can be true:

1. Correctness of the procedure (the next agent cannot follow both letters).
2. Discrete and actionable (name the two letters and the file:line).
3. Introduced by this change.
4. Demonstrable from the procedure text and, if present, fixtures/GREEN that already follow one letter and violate the other. This is the call path. It does not require application runtime.
5. Concrete bad outcome: the next agent does the wrong stop, path, dispatch, empty pass, or drop of a required step. Victim is the next agent, not an end user.
6. The author would probably fix it if they knew.

Still **DROP**:

- wording nits
- missing nice-to-have sections
- “could be clearer”
- a count band the author kept on purpose when the rest of the letter already agrees
- speculative “an agent might misread”
- ordinary README/docs prose
- plan/spec/design with no procedure diff (still out of family → `shape-*`)

“When in doubt, drop” still applies to app code and to shaky procedure nits. It does **not** authorize dropping a demonstrated unsatisfiable pair in a procedure file.

Do not apply this rule to app-code contradictions unless they already pass today’s six gates the original way.

Put this letter in `gates.md` (authoritative) and the same letter in `review-defects` (rationalizations / Failures / hard rules) so the two files cannot disagree. Do not paraphrase one into a weaker “prefer” in the other.

## Router (`review-changes`)

Unchanged job. Classify the comparison, announce it, pass command + file list, hand off.

Do **not** add a classify row for procedure files. Do **not** review. Do **not** restate the new rule.

A stored patch whose file list includes `SKILL.md` or a required playbook is still a comparison — not out of family. Out of family remains plan/spec/design **with no procedure diff**.

## Leaf (`review-defects`)

Still required to follow `gates.md`. Still read-only. Still may return `No findings.`

Touch only what would otherwise contradict the new rule:

- Hard rules: “do not grill plan/spec prose” stays. It does not mean “do not inspect procedure files.”
- Procedure step that applies gates: when a procedure file is in the file list, apply the procedure-file letter. Do not require application runtime for that class.
- Rationalizations: close the drop path from the empty pass (gate 5 wants a user break; “when in doubt, drop”; “this is prose / a plan”).
- Failures: dropping a demonstrated unsatisfiable pair in a procedure file.

Do not paste a second, different six-gate list. Do not invent a seventh gate.

## Fixture

Checked-in files under `fixtures/review-sample/` (existing app-code diffs stay) plus new stored patches for procedure cases. Not a product. Do not add features during review tests.

New diffs (against a tiny procedure parent, not against live `skills/`):

| Diff | What it is | Expected GREEN |
|---|---|---|
| `changes/procedure-clash.diff` | `paths.md`-style pair: “not every child” ban vs “include every determining title / shared migration stays on the path” | Numbered finding; not `No findings.` |
| `changes/procedure-nit.diff` | Procedure-file wording (“could be clearer”) | Drop; `No findings.` |
| `changes/readme-wording.diff` | README-only wording | Drop; `No findings.` |
| `changes/plan-only.diff` | Implementation-plan wording; no procedure file | Out of family → `shape-*` (or drop if already in a named-patch comparison with no procedure file — still not a finding) |
| existing `changes/clean-rename.diff` | App-code rename; no behavior change | `No findings.` (do not invent) |

The clash parent is a **fixture** skill + required playbook, modeled on the Path P2. Do not edit live `skills/engineering/size-work/paths.md` to reintroduce the clash.

`src/` and the existing three diffs stay the app-code parent. Procedure diffs use their own parent tree beside them so RED/GREEN prompts can name a patch vs a parent the way today’s review-sample does.

## Catalog sync

No new promoted skill. Do not add a path to `.claude-plugin/plugin.json`. Do not bump plugin version.

Top-level README and `skills/engineering/README.md` stay as they are unless a one-liner would be untrue. v1 one-liners already say defect-first review / `No findings.` — they do not need to list procedure letters.

## Verification

Apply writing-skills TDD (pressure scenarios with subagents). RED runs against **current** `gates.md` / leaf (no procedure-file rule). Ban reading `docs/superpowers/**` so the spec/plan cannot stand in for the skill.

| Scenario | Without the new rule (expect fail) | With the new rule (expect pass) |
|---|---|---|
| A. procedure-file unsatisfiable pair (Path P2 model) | `No findings.` (gate 5 / “when in doubt, drop” / “do not grill prose”) | Numbered `[P#]` finding naming both letters and `path:line` |
| B. README or plan-only wording | May invent a docs finding, or grill the plan | Drop, or `shape-*` if no procedure diff |
| C. App-code clean rename | (already contracted) | Still `No findings.` Do not invent. |
| D. Procedure-file nit (“could be clearer”) | May flag it as a finding | Drop; `No findings.` |

Document verbatim rationalizations in `docs/superpowers/plans/2026-08-21-review-procedure-letters-baseline.md`.

This change ran on the jamesthomasonjr/skills Cloud Agent environment with linked [jeighty/supersuit](https://github.com/jeighty/supersuit) (fallback: `~/.cursor/skill-src/supersuit/skills`). Do not open a PR against supersuit.

## Success criteria

- `gates.md` and the leaf carry the same procedure-file letter. They do not contradict.
- Router classify table unchanged. Router does not review.
- Procedure-file unsatisfiable pair → numbered finding.
- README / plan-only / procedure nit → still drop (plan/spec with no procedure diff → `shape-*`).
- App-code clean change → still `No findings.`
- App-code gates not loosened.
- No new promoted skill. Catalog/plugin unchanged.
- RED baseline documented, then GREEN compliance.
- Spec/plan/baseline under `docs/superpowers/`.
