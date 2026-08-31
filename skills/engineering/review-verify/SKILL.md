---
name: review-verify
description: >-
  Verifier for defect-first review. Use when review-changes hands off
  after both seats. Combines candidates, applies gates, writes Findings /
  Assessment / Close. May return No findings. Does not implement.
disable-model-invocation: true
---

# Review verify

Read-only verifier for **this change**. Combines seat candidates, applies
gates, writes Findings / Assessment / Close. May return `No findings.`

Does **not** generate a fresh candidate list from the diff.

**REQUIRED:** Follow [../review-changes/gates.md](../review-changes/gates.md). Read it before writing findings. Resolve that path from this file’s directory, not cwd. After `~/.cursor/skills/review-verify` symlink, a bare `gates.md` read misses.

Do not paste the five gates into this file. If any gate is shaky, **drop**. When in doubt, drop — except a demonstrated unsatisfiable pair in a procedure file or a this-PR advertised-path miss.

**Procedure files** (same letter as `gates.md`; do not weaken it):

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

**Advertised paths** (same letter as `gates.md`; do not weaken it):

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

## Hard rules

- Read-only. No edits, no commits, no pushes, no GitHub review comments. Do not create a fix branch.
- Verify the merged seat candidates only. Do not generate a fresh candidate list from the diff. Do not tour the rest of the repo.
- Mixed turn (“review this, then fix it”): finish this review, then **hand back**. Do not implement. **Do not edit in this turn even if the user already asked for a fix** — that message is the review, not an implement go-ahead. They must send a **new message** after the review. Do not discard the fix request.
- If invoked with a plan/spec/design and no procedure file in the comparison: stop. Out of family. Point at `shape-*`. Do not produce findings. Do not grill that prose. A `SKILL.md` or required playbook in the file list is not a plan — inspect it.
- If invoked with no comparison: cheap-resolve as `review-changes` would. Empty/unresolvable → `Nothing to review.`
- If the seats have not handed over candidate lists, **stop**. Point at `review-changes`. Do not invent a list from the diff.

## Procedure

If this is a stop path (empty/unresolvable, plan/spec/design with no procedure file in the comparison, or seats have not handed over lists), skip steps 1–5. Write only the stop.

1. Take both seat candidate lists. Combine, dedupe, organize. Do not add a candidate that neither seat emitted.
2. Inspect enough of the comparison to apply the gates to those candidates — not to hunt a new list. For working tree: `git diff HEAD` **and** every untracked path in the file list when a candidate overlaps them. Untracked files are first-class — Read each, or `git diff --no-index -- /dev/null <path>`. Do not `git add`.
   For a named patch or branch/PR three-dot: inspect the overlapping hunks plus enough surrounding code and tests to confirm each merged candidate.
3. Apply every gate in `gates.md` to each merged candidate. Drop if any is shaky — except a demonstrated unsatisfiable pair in a procedure file or a this-PR advertised-path miss. When a procedure file is in the file list, apply the Procedure files letter. When this change’s own hook, header, or extractor advertises a path, apply the Advertised paths letter. Live harness eval is not required for that class. Do not require application runtime for a procedure-file pair.
4. Skip everything under Suppressions — including when they said “nits are fine” or “flag anything.”
5. Assign P0–P3 only to survivors.
6. If this is a **stop path**, write only that stop (below). Otherwise write the output contract. Then stop (or hand back).

## Stop paths (no three-block contract)

These are **not** empty reviews. Do **not** emit Findings, Assessment, or Close.

- Empty or unresolvable target: exactly `Nothing to review.`
- Plan / spec / design with no procedure file in the comparison: 1–2 sentences, point at `shape-*`, stop.
- Seats have not handed over candidate lists: 1–2 sentences, point at `review-changes`, stop.

## Output contract (in order)

Skip this entire section on stop paths.

Otherwise always emit these three blocks, in this order, with these headings:

1. **Findings** — one entry per survivor, severity-first:

   `[P1] Imperative title — path/to/file:line`

   Then one short paragraph: affected scenario, concrete bad outcome, why the change is wrong. No second paragraph. No patch. No suggestion block.

   **Or**, if none survive: this block is exactly `No findings.`

2. **Assessment** — 1–3 sentences: target + comparison, material test gaps, residual pre-existing risk (at most one line). When a seat emitted an unused helper or other pre-existing candidate and it was dropped, that drop is this residual line — seen, not silent. No merge stamp. No LGTM. Do not name a gate here.

3. **Close** — required heading, one line. Mixed-turn: review is done; they must send a **new message** to implement. Otherwise: the review is finished (do not add findings).

No other sections. No “Nice to have.” No praise. No nit list after `No findings.`

## Rationalizations

| Excuse | Reality |
|---|---|
| “Empty report looks unfinished” | `No findings.` is success. Inventing a finding is the failure. |
| “Nits help the author” / “nits are fine” / “flag anything” | Nits are not findings. Drop them. Complete ≠ whitespace. |
| “This pre-existing bug is serious” | Residual-risk line in Assessment. Never a numbered finding. |
| “It might fail in production” | Speculative → drop unless this PR advertised the path. For that class, stdin shape + extractor is the call path. Live eval is not required. |
| “When in doubt, flag it” | When in doubt, **drop** — except a demonstrated unsatisfiable pair in a procedure file or a this-PR advertised-path miss. |
| “Gate 5 wants a runtime user break” | Procedure victim is the next agent. Wrong stop / path / dispatch / empty pass / dropped step is the outcome. |
| “When in doubt, drop — so drop the clash” | That sentence does not authorize dropping a demonstrated unsatisfiable pair in a procedure file. |
| “Do not grill plan/spec prose, and this is markdown” | README/plan/spec stay out. `SKILL.md` and required playbooks are the product. Inspect them. |
| “An agent might misread this” | Speculative → drop. Two letters that cannot both be followed is not speculative. |
| “Could be clearer / missing a nice-to-have section” | Still a nit. Drop. |
| “nothing in the comparison demonstrates a broken call path” | Procedure call path is the playbook text (and fixtures/GREEN if present). Application runtime is not required. |
| “I’ll just fix it while I’m here” | Review turn is read-only. Hand back. New message to implement. |
| “A Minor section keeps the nits somewhere” | There is no nit bucket. Drop them. Listing nits then calling them nits is still a fail. |
| “Thorough means more findings” | Thorough means every qualifying defect, and nothing else. |
| “They asked me to be a critical reviewer of a plan” | Out of family when no procedure file is in the comparison. Stop. Point at `shape-*`. Do not grill that prose. |
| “Always emit Findings / Assessment / Close” | Only after a real comparison. Stop paths skip the contract. Do not wrap `Nothing to review.` |
| “git diff HEAD was empty, so nothing to review” | Untracked files are not in `git diff HEAD`. Inspect them when a candidate overlaps. Do not `git add`. |
| “Designed idle-when-no-handoff covers this” | Idle is for no handoff. An extractor that can never see this hook’s stdin is a finding. |
| “No live harness eval” | Gate 4 for this class is stdin shape + extractor. Live eval is not required. |
| “Park it in Assessment residual” | Residual is host-not-advertised or a dropped pre-existing candidate. A this-PR advertised-path miss is a numbered finding. |
| “hooks.json is a procedure file / unsatisfiable pair” | Do not stretch that rule onto `hooks.json` or ordinary docs. Use the advertised-path letter. |
| “Host has not advertised native-worktree — finding” | Residual-or-empty. Never a numbered finding. |
| “I’ll scan the diff for anything the seats missed” | Do not generate a fresh list. Verify the merged candidates. |
| “Drop unused helpers before listing them” | Seats emit them. This leaf drops them. Assessment residual, not silent. |

## Failures

- Invented findings on a clean change
- A fresh candidate list this leaf generated from the diff
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
- Skipping untracked working-tree files a candidate overlaps because `git diff HEAD` is empty
- Dropping a demonstrated unsatisfiable pair in a procedure file
- Treating a `SKILL.md` or required playbook as plan/spec prose
- Requiring application runtime before a procedure-file pair can survive
- Dropping a this-PR advertised-path miss (hook / header / extractor cannot do what it claims)
- Parking that class in Assessment residual
- Stretching the procedure-file rule onto `hooks.json` or ordinary docs
- Numbering a host-not-advertised capability gap
- Silent drop of a seat-emitted unused helper with no Assessment residual
