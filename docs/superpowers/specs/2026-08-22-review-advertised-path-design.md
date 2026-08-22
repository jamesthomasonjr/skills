# Review advertised-path findings

Date: 2026-08-22
Status: verified (RED baseline + GREEN subagent runs)
Repo: jamesthomasonjr/skills

Increment to `docs/superpowers/specs/2026-08-20-review-skill-family-design.md`
and `docs/superpowers/specs/2026-08-21-review-procedure-letters-design.md`.
Does not replace those specs.

## Problem

On **jeighty/supersuit PR #20**, `review-changes` (cloud agent
`bc-01a029ca-4a2d-7818-8909-d8974db86171`) found Bugbot **High 2** and
dropped it into Assessment residual.

High 2 (the RED model): Claude Stop stdin has `session_id` /
`stop_hook_active`, not `id` / `from` / `on`, so `_extract_handoff`
always misses. `HOST_EXEC` still tells the model the host auto-executes
via Stop. The skill treated **designed idle-when-no-handoff** as covering
“this PR’s only registered Stop hook can never have a handoff.”

That is the empty-pass class to close. It is **app code + this-PR
advertised path**, not the procedure-file unsatisfiable-pair rule from
PR #11.

Verified against current letters (`gates.md` / `review-defects` as of
PR #11):

- Gate 4 still reads “call path demonstrable from the code.”
- Suppressions still drop “speculative might-break with no demonstrable
  call path.”
- Pre-existing issues stay “at most one residual-risk line in
  Assessment.”
- The procedure-file exception applies only to `SKILL.md` + required
  playbooks. `hooks.json` and ordinary docs are explicitly not
  procedure.
- Rationalization “It might fail in production” → speculative → drop.

A reviewer who finds High 2 can therefore treat designed idle as
intentional, treat “no live harness eval” as a shaky gate 4, and park
the miss in Assessment residual. That is the same empty-pass shape as
PR #19’s procedure clash, on a different class.

## Goals

- When **this change’s own hook, header, or extractor cannot do what it
  claims**, that is a numbered finding.
- Residual stays the host-has-not-advertised-a-capability-yet class
  (example: native-worktree). At most one Assessment residual line.
- Keep one review family. Router still classifies and does **not**
  review.
- `gates.md` stays authoritative. Same letter in gates + leaf so they
  cannot disagree.
- Do **not** loosen the six gates for ordinary application code.
- Do **not** stretch the procedure-file unsatisfiable-pair rule onto
  `hooks.json` or ordinary docs.
- Still drop wording nits, speculative might-break with no this-PR
  advertised path, pre-existing host gaps, and plan/spec with no
  procedure or advertised-path diff.

## Non-goals

- A new promoted skill. No catalog or plugin change.
- Opening plan/spec review.
- Implementing the supersuit Stop / extractor hook fix. No PR against
  jeighty/supersuit.
- New Findings / Assessment / Close headings. No near-survivor /
  residual-risk / future-work sections. Empty pass stays empty.
- New output-contract sections. No drop-list / trace phrase added to
  `review-defects`.
- Changing mixed-turn or stop-path envelopes.
- Loosening “when in doubt, drop” for ordinary app code.

## Sources

| Source | What we take | What we drop |
|---|---|---|
| Existing review family + PR #11 | Thin router; `gates.md` playbook; six gates; procedure-file letter stays; `No findings.`; P0–P3; sibling reads | New leaf; stretching procedure-file onto hooks.json |
| Bugbot High 2 on supersuit PR #20 (commit `5ad2741`) | Stop stdin keys vs `_extract_handoff`; `HOST_EXEC` claims Stop auto-exec; idle-when-no-handoff is the cover story | Fixing the hook |
| Cloud agent `bc-01a029ca-4a2d-7818-8909-d8974db86171` | Candidate found, then parked as Assessment residual | Changing supersuit |

## Approaches considered

1. **Extra rule on existing gates + leaf (recommended).** `gates.md`
   stays the playbook. When this change advertises a hook/header/extractor
   path, a claim the extractor or hook cannot satisfy is a finding.
   Router classify table unchanged. Matches “keep one family.”
2. **Stretch the procedure-file rule onto `hooks.json`.** Rejected. The
   user letter forbids it. `hooks.json` is not a `SKILL.md` or a required
   playbook unless a skill is **REQUIRED** to follow it.
3. **Loosen gates 4–5 globally.** Rejected. That would invent findings
   on ordinary app-code “might break” speculation.

v1 is approach 1.

## Architecture

No new promoted skills. One sequential agent. Same two skills.

```
skills/engineering/
  review-changes/
    SKILL.md       # router: unchanged classify. Does not review.
    gates.md       # six gates (app code unchanged) + advertised-path letter
  review-defects/
    SKILL.md       # leaf: follow gates.md; same advertised-path letter
```

Hard rules that stay true:

- Router classifies, announces, hands off. Does not apply gates. Does
  not write findings.
- Leaf reviews the passed comparison only.
- Flag a finding only when **all six** gates are true.
- Ordinary app-code contradictions use today’s six-gate reading.
- Plan/spec/design with no procedure or advertised-path diff: still out
  of family. Do not grill that prose.
- Procedure-file unsatisfiable pairs stay as PR #11 defined them.

## New rule (same letter in `gates.md` and the leaf)

**Residual** = the host has not advertised a capability yet (example:
native-worktree). Finding = this change’s own hook, header, or
extractor cannot do what it claims.

Gate 4 for that class: hook/tool stdin shape and the extractor in this
comparison are the call path. Live harness eval is not required.

“No live harness eval” / “it might fail in production” is not a drop
for that class.

Do not park that class in Assessment residual.

Do not stretch the procedure-file unsatisfiable-pair rule onto
`hooks.json` or ordinary docs.

Still **DROP**: wording nits, speculative might-break with no this-PR
advertised path, pre-existing host gaps (those stay at most one
Assessment residual line), plan/spec with no procedure or advertised-path
diff.

App-code gates stay tight except this advertised-path class. Do not
loosen “when in doubt, drop” for ordinary app code.

All six gates can be true for a this-PR advertised-path miss:

1. Correctness of the advertised path (the hook, header, or extractor
   cannot do what this change claims).
2. Discrete and actionable (name the claim and the stdin/extractor
   miss; file:line).
3. Introduced by this change.
4. Demonstrable from the hook/tool stdin shape and the extractor in
   this comparison. This is the call path. Live harness eval is not
   required.
5. Concrete bad outcome: the advertised auto-exec (or equivalent claimed
   path) never runs for the victim of the claim. Designed
   idle-when-no-handoff does not cover “this PR’s only registered hook
   can never see a handoff.”
6. The author would probably fix it if they knew.

Put this letter in `gates.md` (authoritative) and the same letter in
`review-defects` so the two files cannot disagree. Do not paraphrase
one into a weaker “prefer” in the other.

## Router (`review-changes`)

Unchanged job. Classify the comparison, announce it, pass command +
file list, hand off.

Do **not** add a classify row for hooks or advertised paths. Do **not**
review. Do **not** restate the new rule.

A stored patch whose file list includes a hook, header, or extractor
is still a comparison — not out of family.

## Leaf (`review-defects`)

Still required to follow `gates.md`. Still read-only. Still may return
`No findings.`

Touch only what would otherwise contradict the new rule:

- Opening drop line: “when in doubt, drop” still applies to ordinary
  app code. It does not authorize dropping a this-PR advertised-path
  miss.
- Procedure step that applies gates: when this comparison’s own hook,
  header, or extractor advertises a path, apply the advertised-path
  letter. Live harness eval is not required for that class.
- Rationalizations: close the High 2 drop path (designed idle covers
  a never-visible handoff; no live harness; park in residual; stretch
  procedure-file onto `hooks.json`).
- Failures: dropping a this-PR advertised-path miss; parking that
  class in Assessment residual; stretching procedure-file onto
  `hooks.json` or ordinary docs.

Do not paste a second, different six-gate list. Do not invent a
seventh gate. Do not add output-contract sections. Do not add a
drop-list / trace phrase. Mixed-turn and stop-path envelopes stay.

## Fixture

Checked-in files under `fixtures/review-sample/` (existing app-code and
procedure diffs stay) plus a tiny hook parent and stored patches for
the advertised-path cases. Not a product. Do not add features during
review tests. Do not copy live supersuit files.

New parent: `fixtures/review-sample/hook/` — a CLI-only mediator
(SessionStart only; argv `--id` / `--from` / `--on`; no Stop claim).

| Diff | What it is | Expected GREEN |
|---|---|---|
| `changes/advertised-path-miss.diff` | High 2 model: Stop registered; `HOST_EXEC` claims Stop auto-exec; `_extract_handoff` reads `id`/`from`/`on`; Stop stdin is `session_id`/`stop_hook_active`; designed idle-when-no-handoff present | Numbered finding naming the extractor/hook claim miss; survives “no live harness” / residual habit |
| `changes/host-gap.diff` | native-worktree style: host has not advertised a capability yet; this change does not claim it | Residual-or-empty — **not** a numbered finding |
| existing `changes/readme-wording.diff` | README-only wording | `No findings.` |
| existing `changes/clean-rename.diff` | App-code rename; no behavior change | `No findings.` |
| existing `changes/plan-only.diff` | Implementation-plan wording; no procedure or advertised-path file | `shape-*` |
| existing `changes/procedure-clash.diff` | PR #11 unsatisfiable pair | Numbered finding (do not regress) |

## Catalog sync

No new promoted skill. Do not add a path to `.claude-plugin/plugin.json`.
Do not bump plugin version. Match the last playbook letters (`paths.md`,
procedure-file gate): catalog README and plugin stay unchanged.

## Verification

Apply writing-skills TDD (pressure scenarios with subagents). RED runs
against **current** `gates.md` / leaf (no advertised-path letter). Ban
reading `docs/superpowers/**` so the spec/plan cannot stand in for the
skill.

| Scenario | Without the new rule (expect fail) | With the new rule (expect pass) |
|---|---|---|
| A / A2. advertised-path miss (Stop stdin vs extractor) | `No findings.` or High 2 parked in Assessment residual | Numbered `[P#]` finding naming the extractor/hook claim miss; survives “no live harness” / residual habit |
| B. README / docs wording | (already drop) | Still `No findings.` |
| C. App-code clean rename | (already contracted) | Still `No findings.` |
| D. host has not advertised a capability yet | May invent a numbered host-gap finding | Residual-or-empty — **not** a numbered finding |
| E. plan-only | (already `shape-*`) | Still `shape-*` |
| F. procedure-file clash | (already a finding after PR #11) | Still a numbered finding; do not regress |

Document verbatim rationalizations in
`docs/superpowers/plans/2026-08-22-review-advertised-path-baseline.md`.

This change runs on the jamesthomasonjr/skills Cloud Agent environment
with linked [jeighty/supersuit](https://github.com/jeighty/supersuit)
(fallback: `~/.cursor/skill-src/supersuit/skills`). Do not open a PR
against supersuit.

## Success criteria

- `gates.md` and the leaf carry the same advertised-path letter. They
  do not contradict.
- Router classify table unchanged. Router does not review.
- Advertised-path miss → numbered finding. Not Assessment residual.
- Host-not-advertised (native-worktree style) → residual-or-empty.
- README / plan-only / clean rename stay drop or `shape-*`.
- Procedure-file clash still a finding.
- App-code gates not loosened except this advertised-path class.
- No new promoted skill. Catalog/plugin unchanged.
- RED baseline documented, then GREEN compliance.
- Spec/plan/baseline under `docs/superpowers/` dated 2026-08-22.
