---
name: review-verify
description: >-
  Verifier for defect-first review. Use when review-changes hands off
  after announced seats. Combines candidates, applies gates, writes Findings /
  Assessment / Follow-ups (omit if empty). May return No findings. Does not implement.
disable-model-invocation: true
---

# Review verify

Read-only verifier for **this change**. Combines seat candidates, applies
gates, writes Findings / Assessment / Follow-ups (omit Follow-ups when
there are no seat-emitted leftovers). May return `No findings.`

Does **not** generate a fresh candidate list from the diff.

**REQUIRED:** Follow [gates.md](gates.md). Read it before writing findings. `gates.md` is this skill’s sibling — resolve it from this file’s directory, not cwd. After `~/.cursor/skills/review-verify` symlink, a cwd-relative `gates.md` read misses.

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
- Verify the merged seat candidates only. Do not generate a fresh candidate list from the diff. Do not tour the rest of the repo. Every announced seat candidate list. Do not hard-code six. Unannounced specialists are not a missing list. A missing announced list is still a stop (same #31 miss). Do not take a pasted pack name, reconstructed-intent blob, gatherer product, or specialist playbook as a fourth / extra input. Parent-held gatherer products, parent-held reconstruct blob, and parent-held specialist playbooks in this Follow window are GREEN (same #30 shape). A pasted extra input is RED extra-briefing.
- Mixed turn (“review this, then fix it”): finish this review, then **hand back**. Do not implement. **Do not edit in this turn even if the user already asked for a fix** — that message is the review, not an implement go-ahead. They must send a **new message** after the review. Do not discard the fix request.
- If invoked with a plan/spec/design and no procedure file in the comparison: stop. Out of family. Point at `shape-*`. Do not produce findings. Do not grill that prose. A `SKILL.md` or required playbook in the file list is not a plan — inspect it.
- If invoked with no comparison: cheap-resolve as `review-scope` would. Empty/unresolvable → `Nothing to review.`
- If any announced seat has not handed over a candidate list, **stop**. Point at `review-changes`. Do not invent a list from the diff. Do not merge a subset and skip an announced seat. Do not wait on an unannounced specialist. A seat whose child or CloudAgent never started or never returned is this same missing list — the router owns that HARNESS-STOP; this leaf does not verify the seats that did return.
- This skill Follows in the parent on every host. It is not a spawned seat on a Task nest and not a CloudAgent in cloud-seat mode. Isolation is not its duty.

## Procedure

If this is a stop path (empty/unresolvable, plan/spec/design with no procedure file in the comparison, or any announced seat has not handed over a list), skip steps 1–5. Write only the stop.

1. Take every announced seat candidate list. Combine, dedupe, organize. Do not add a candidate that no seat emitted. Do not wait on a subset. Do not hard-code six lists. Do not take a pasted pack name, gatherer product, reconstructed-intent blob, or specialist playbook as extra input. Parent-held products, parent-held blob, and parent-held playbooks already in this window are GREEN.
2. Inspect enough of the comparison to apply the gates to those candidates — not to hunt a new list. For working tree: `git diff HEAD` **and** every untracked path in the file list when a candidate overlaps them. Untracked files are first-class — Read each, or `git diff --no-index -- /dev/null <path>`. Do not `git add`.
   For a named patch or branch/PR three-dot: inspect the overlapping hunks plus enough surrounding code and tests to confirm each merged candidate.
3. Apply every gate in `gates.md` to each merged candidate. Drop if any is shaky — except a demonstrated unsatisfiable pair in a procedure file or a this-PR advertised-path miss. When a procedure file is in the file list, apply the Procedure files letter. When this change’s own hook, header, or extractor advertises a path, apply the Advertised paths letter. Live harness eval is not required for that class. Do not require application runtime for a procedure-file pair.
4. Skip everything under Suppressions — including when they said “nits are fine” or “flag anything.”
5. Assign P0–P3 only to survivors.
6. If this is a **stop path**, write only that stop (below). Otherwise write the output contract. Then stop (or hand back).

## Stop paths (no envelope)

These are **not** empty reviews. Do **not** emit Findings, Assessment, or Follow-ups.

- Empty or unresolvable target: exactly `Nothing to review.`
- Plan / spec / design with no procedure file in the comparison: 1–2 sentences, point at `shape-*`, stop.
- Any announced seat has not handed over a candidate list: 1–2 sentences, point at `review-changes`, stop.

## Output contract (in order)

Skip this entire section on stop paths.

Otherwise emit these headings, in this order:

1. **Findings** — one entry per survivor, severity-first:

   `[P1] Imperative title — path/to/file:line`

   Then one short paragraph: affected scenario, concrete bad outcome, why the change is wrong. No second paragraph. No patch. No suggestion block.

   **Or**, if none survive: this block is exactly `No findings.`

   Mixed-turn (“review this, then fix it”): after this block, one line — they must send a **new message** to implement. Not a heading.

2. **Assessment** — still this heading:

   1–3 sentences: target + comparison, material test gaps only. No leftover names under this heading.

   Host-not-advertised residual: at most one separate line, never leftover titles. Not a leftover line. Not mixed into Follow-ups. Not counted in the sentence cap.

   No merge stamp. No LGTM. Do not name a gate here.

3. **Follow-ups** — only seat-emitted leftovers that failed gate 3. One leftover per line (`title — path:line`). Unnumbered. Name **each**. Same contents as leftover lines that used to sit under Assessment.

   Omit this heading when there are none. Do not require it.

   Not G5 nits. Not speculative drops. Not `dropped: N`. Those are minor-bucket bleed.

   Silent drop is a Failure. Same leftover every review is the tracker; dropping it because it was named last PR is never-seen again.

   Do not number leftovers. Do not mix leftover titles with the host-not-advertised residual.

No Close. No other sections. No “Nice to have.” No praise. No nit list after `No findings.`

## Rationalizations

| Excuse | Reality |
|---|---|
| “Empty report looks unfinished” | `No findings.` is success. Inventing a finding is the failure. |
| “Nits help the author” / “nits are fine” / “flag anything” | Nits are not findings. Drop them. Complete ≠ whitespace. |
| “This pre-existing bug is serious” | Follow-ups names each seat-emitted leftover. Never a numbered finding. Assessment stays 1–3 sentences. |
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
| “Always emit Findings / Assessment / Close” | Findings and Assessment after a real comparison. Follow-ups only when leftovers exist. No Close. Stop paths skip the envelope. Do not wrap `Nothing to review.` |
| “git diff HEAD was empty, so nothing to review” | Untracked files are not in `git diff HEAD`. Inspect them when a candidate overlaps. Do not `git add`. |
| “Designed idle-when-no-handoff covers this” | Idle is for no handoff. An extractor that can never see this hook’s stdin is a finding. |
| “No live harness eval” | Gate 4 for this class is stdin shape + extractor. Live eval is not required. |
| “Park it in Assessment residual” | Host-not-advertised residual is one line. Seat-emitted leftovers are named under Follow-ups, not this residual line. A this-PR advertised-path miss is a numbered finding. |
| “hooks.json is a procedure file / unsatisfiable pair” | Do not stretch that rule onto `hooks.json` or ordinary docs. Use the advertised-path letter. |
| “Host has not advertised native-worktree — finding” | Residual-or-empty. Never a numbered finding. |
| “I’ll scan the diff for anything the seats missed” | Do not generate a fresh list. Verify the merged candidates. |
| “Drop unused helpers before listing them” | Seats emit them. This leaf drops them. Follow-ups names each leftover. Not silent. |
| “At most one residual line — pick one leftover” | That cap is host-not-advertised only. Name each seat-emitted leftover under Follow-ups. |
| “1–3 sentences — compress leftovers to one” | That cap is target / comparison / test gaps only. Leftover names live under Follow-ups, not Assessment. |
| “We said this leftover last PR” | Repeating it every review is the tracker. Dropping it is never-seen again. |
| “A leftover heading is fourth-block bleed, so it can’t exist” | Isolation is fresh context or stop. Follow-ups is leftover home when seats emitted leftovers that failed gate 3. Omit when none. G5 nits / speculative / `dropped: N` under Follow-ups is the bleed. |
| “Fold leftover titles into the host-gap residual” | Mix reopens host-gap. Host-not-advertised is a separate one-line Assessment residual. Leftovers stay under Follow-ups. |
| “Put G5 nits / dropped: N under Follow-ups so they have a home” | Minor-bucket bleed. Drop them. Follow-ups is leftovers only. |
| “Always emit Follow-ups / Close” | Omit Follow-ups when there are none. Close is dropped. Mixed-turn is one line after Findings. |
| “Same bug class as last PR — number the leftover” | Gate 3 is the merge bar. Do not reopen GREEN. Numbering a leftover is still a finding. |
| “Both seats handed over — merge those two” | Every announced list. A skipped announced specialist list makes leftovers never-seen (same #31 miss). An unannounced specialist is not a skipped list. |
| “Regression’s CloudAgent never came back — merge the six that did” | Thinner merge is the same #31 miss. Stop. Point at `review-changes`; that is its HARNESS-STOP. |
| “Run me as a CloudAgent too so verify is isolated” | Verify Follows in the parent. Isolation is not this leaf’s duty. |
| “Wait for six lists; that is the family” | Announced set. Do not hard-code six. |
| “Pack is core, so a missing announced security list is fine” | Missing announced is still #31. |
| “Performance was unannounced — treat as never-seen leftover” | Unannounced is not never-seen. |
| “Paste the pack name so I know which lists” | Extra-briefing RED. Announced lists only. |
| “Paste gatherer products so verify has context” | All announced lists. A fourth-input / extra-input paste is RED. Parent-held in this window is GREEN. |
| “Paste the reconstruct blob as a fourth input” | All announced lists. Parent-held blob in this Follow is GREEN. The paste is RED extra-briefing. |
| “Paste specialist playbooks so verify has context” | All announced lists. Parent-held playbooks in this Follow are GREEN. The paste is RED extra-briefing. |
| “Withhold parent-held products; they leak verify” | This Follow is in the parent. Parent-held there is GREEN. |

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
- Wrapping `Nothing to review.` or a `shape-*` stop in Findings / Assessment / Follow-ups
- Skipping untracked working-tree files a candidate overlaps because `git diff HEAD` is empty
- Dropping a demonstrated unsatisfiable pair in a procedure file
- Treating a `SKILL.md` or required playbook as plan/spec prose
- Requiring application runtime before a procedure-file pair can survive
- Dropping a this-PR advertised-path miss (hook / header / extractor cannot do what it claims)
- Parking that class in Assessment residual
- Stretching the procedure-file rule onto `hooks.json` or ordinary docs
- Numbering a host-not-advertised capability gap
- Silent drop of a seat-emitted leftover
- Compressing leftover names to fit the 1–3 sentence cap
- Leftover names under Assessment
- Mixing leftover titles with the host-not-advertised residual
- G5 nits, speculative drops, or `dropped: N` under Follow-ups
- A required Follow-ups heading when there are none
- A Close heading
- Numbering leftovers
- Dropping a leftover because it was named last PR
- Merging a subset of lists and skipping an announced seat — including the seats that did return after one child or CloudAgent never started
- Waiting on an unannounced specialist, or hard-coding six lists
- Running as a spawned seat or CloudAgent instead of Following in the parent
- Taking a pasted pack name, reconstructed-intent blob, or a specialist playbook as a fourth / extra input (parent-held in this Follow window is not this leak)
