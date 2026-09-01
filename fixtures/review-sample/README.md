# review-sample

Tiny pricing module used to test the review skill family.

Protocol: comparison still comes from cheap-resolve rules, now in `review-scope`. `review-changes` Follows `review-scope` **in the parent**, announces the comparison it returned, then fans `review-gather-pr` / `review-gather-design` / `review-gather-onboard` as **fresh children** and seeds from their **products**. Then fans `review-blind` and `review-security` **in parallel**. Intent waits on the reconstructed-intent blob, then runs. Each seat runs isolated in a fresh context and still receives that same comparison (commands, file list, untracked first-class, no self-upstream, named default is `<base>` not `<tip>`). `review-intent` gets the PR-body and design-excerpt products when present, plus the reconstruct blob. Leftover titles from the blind candidate list are not in that window. `review-blind` gets the comparison only — not the PR body, commit message, onboard dumps, orient dumps, gatherer products, gatherer follow transcripts, the implementing turn, GREEN tables / fixture protocol / scoring notes, or the security playbook / OWASP lists / CWE lists. Blind still emits `candidates` / `No candidates.` plus a **separate** reconstructed-intent blob. Do not fold that blob into the candidate list. `review-security` still fans with blind. Its window is the comparison plus its own playbook — child Read of that playbook is GREEN. The reconstruct blob is not in that window. Then `review-verify` Follows **in the parent** on the three seat lists and applies `gates.md`. Isolation is not a duty of the verifier. Parent-held gatherer products in that window are GREEN. Parent-held reconstruct blob in that window is GREEN (same #30 shape). Do not pass the blob to verify as a fourth input. Seats emit candidates. They do not apply `gates.md` and do not write Findings / Assessment / Close. Gatherers return a product and stop. They do not write `Nothing to review.` Onboard has no seat to seed — `review-intent` gets PR body + design excerpt + the reconstruct blob. Do not pass onboard to `review-security`. The parent may hold the onboard product; that hold is not a verify leak. Score sequential letters on the dumps, not the agent.

Score comparison on the dumps: each seat’s comparison command matches what `review-scope` returned. Wrong base/tip (self-upstream, named default as `<tip>`) stay RED — those letters live in `review-scope` prose. Wrong window is RED. Do not reopen the GREEN rows below.

Score gatherer products in the **parent seed**, not the gatherer follow transcript.

GREEN parent-held scope: `review-changes` Follows `review-scope` in the parent. The parent holds that comparison dump. Seats open fresh and receive that same comparison. Parent-held scope is not a leak.

RED fresh child for scope: the router opened a fresh context for `review-scope` instead of Following in the parent. Scope stays Follow-in-parent.

RED stuffed scope into blind: the parent copied the `review-scope` dump into the `review-blind` prompt or window, or the **blind** child fetched it.

GREEN fresh-child gatherer: after announce, the router opened a fresh context for each of `review-gather-pr`, `review-gather-design`, and `review-gather-onboard`. Fresh child for these is GREEN (the opposite of `review-scope`).

GREEN parent-seeded product: the parent seeded `review-intent` from the gatherer **product** (PR body, design excerpt when nonempty). Score that seed. The follow transcript is not the seed. Onboard has no seat to seed.

GREEN parent-held gatherer products in the verify Follow: the parent took the gatherer products, then `review-verify` Followed in that window. Parent-held there is GREEN (same #30 shape). The onboard product may sit in that window with no seat to seed. That hold is not a verify leak.

RED product or transcript in blind: the parent copied a gatherer product or follow transcript into the `review-blind` prompt or window, or the **blind** child fetched it.

RED gatherer dump extra-briefing verify: the parent pasted gatherer products into the `review-verify` prompt as a **fourth input**. Candidate lists only. Parent-held products already in that window are not this Failure.

RED skip-because-parent-has-orient: the router skipped a gatherer because the parent already held an orient / onboard dump.

GREEN isolation is scored on the seat dump: the blind window received only the comparison. The reconstructed-intent blob in that dump is this seat’s own product, not extra briefing. It is not scored on the Findings block. Silence from `review-blind` is not a verify drop.

GREEN intent window: the intent dump has the comparison + PR-body and design-excerpt products + the reconstruct blob. Leftover titles from the blind candidate list are absent. Score the dump, not the agent.

RED leftover titles in intent: leftover titles from the blind candidate list were in the intent window.

RED reconstruct blob in security: the reconstruct blob was in the security window, or the security child Read it. Security still fans with blind. Comparison + own playbook only.

RED reconstruct blob stuffed into blind: the parent passed the blob back into the blind prompt or window as extra briefing (beyond blind producing it).

RED blob folded into candidates: the reconstruct blob was folded into the blind candidate list instead of remaining its own dump product.

GREEN parent-held reconstruct blob in the verify Follow: the parent held the blob, then `review-verify` Followed in that window. Parent-held there is GREEN (same #30 shape). Pasting the blob as extra briefing (a fourth input) is RED. Three candidate lists.

GREEN parent-held orient: a wrapper primed the parent with catch-me-up / orient-* on the file list `review-scope` returned, then invoked `review-changes`. The parent holds that dump. Seats open fresh. The blind dump has no orient. Parent-held orient is not a leak. `review-changes` does not run orient.

RED leaked orient: the parent copied orient into the `review-blind` prompt or window, or the child fetched it.

GREEN security playbook: the playbook is in the `review-security` dump only. The security seat Reads its own playbook in that window. That Read is GREEN. `review-changes` and `review-blind` do not Read it.

RED leaked playbook: the parent copied the security playbook / OWASP lists / CWE lists into the `review-blind` prompt or window, or the **blind** child fetched it. A `review-security` Read of its own playbook is not this Failure.

Score playbook letters on the seat dumps. RED Failures are a blind-window playbook or a blind-child fetch — not a security-seat Read of `playbook.md`. Do not add an isolation-only fixture diff. Do not reopen the GREEN rows below.

`src/` is the parent (pre-change). Each file in `changes/` is a proposed patch against that parent.

| Diff | What it is | Expected GREEN |
|---|---|---|
| `changes/clean-rename.diff` | Rename `couponRate` → `discountRate` | `No findings.` |
| `changes/nits-only.diff` | Comment, blank line, `subtotal` → `subTotal` | `No findings.` |
| `changes/tax-bug.diff` | Tax applied to subtotal, then discount subtracted | Finding: shopper with a coupon is overcharged |
| `changes/procedure-clash.diff` | `paths.md` “not every child” vs “include every determining title / shared migration stays” | Numbered finding |
| `changes/procedure-nit.diff` | Procedure-file “could be clearer” | `No findings.` |
| `changes/readme-wording.diff` | README-only wording | `No findings.` |
| `changes/plan-only.diff` | Plan-only wording; no procedure file | `shape-*` stop or drop — not a numbered finding |
| `changes/advertised-path-miss.diff` | Stop stdin `session_id`/`stop_hook_active` vs `_extract_handoff` `id`/`from`/`on`; `HOST_EXEC` claims Stop auto-exec | Numbered finding |
| `changes/host-gap.diff` | Host has not advertised `native-worktree` yet | Residual-or-empty — not a numbered finding |

`unusedFormatCents` in `pricing.js` and `refundOrder` in `refunds.js` are **pre-existing**. They must not become numbered findings on the clean diffs. GREEN nits-only / clean-rename stay `No findings.` GREEN is **seen-and-dropped**: a seat may emit them as candidates; the verifier drops them and Assessment names **each** leftover a seat emitted as extra lines under that heading (title + file:line) — `unusedFormatCents` **and** `refundOrder` when seats emitted both. Those leftover lines are not counted in the 1–3 sentence cap (that cap is target / comparison / test gaps only). Compressing both names into the sentence cap is not GREEN. Silent never-seen is not GREEN. Repeating the same leftover every review is the tracker; dropping it because it was named last PR is never-seen again. Host-not-advertised (`host-gap`) stays a separate residual-or-empty one line — not those leftover lines, not counted in the sentence cap, and not mixed with leftover titles. Security leftovers visible in the comparison are the same leftover class: emit, never swallow. A category title, “could be A01” with no path, or a generic Top 10 recitation is not a security candidate. Do not name a gate in the output envelope.

Procedure parent: `procedure/`. Those diffs are against that tree (`-p1` from `fixtures/review-sample/`). `SKILL.md` and `paths.md` are procedure files. README and `docs/plan.md` are not.

Hook parent: `hook/`. Those diffs are against that tree (`-p1` from `fixtures/review-sample/`). A this-PR advertised path is a finding. A host-not-advertised capability is residual-or-empty.

## Branch / PR comparison (not a stored patch)

The diffs above test named-patch reviews. “This PR” / no target / a named feature branch is a **different** comparison. Those letters live in `review-scope`:

Wrong: `git merge-base HEAD @{upstream}` when upstream is this same branch → empty file list → fake `No findings.`
Wrong: “review this against origin/main” treating `origin/main` as `<tip>` → tip equals base → fake `Nothing to review.`
Right: `git diff $(git merge-base <tip> <base>)...<tip>` where `<base>` is `origin/main` (or the repo default), never the branch tracking itself. A named default / “against X” / “into X” is `<base>`. `<tip>` is the feature/PR branch (HEAD when that is the subject), or a named *non-base* branch. Naming the PR branch while on `main` still diffs that tip against `main`.

Working tree: file list = `git diff HEAD --name-only` ∪ `git ls-files --others --exclude-standard`. Untracked files are first-class (Read or `git diff --no-index -- /dev/null <path>`). Do not `git add`. Untracked-only is not `Nothing to review.`

This is not a real product. Do not edit `src/` during review tests.
