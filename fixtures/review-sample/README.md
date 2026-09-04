# review-sample

Tiny pricing module used to test the review skill family.

Protocol: comparison still comes from cheap-resolve rules, now in `review-scope`. `review-changes` Follows `review-scope` **in the parent**, announces the comparison it returned, chooses the pack **once** from the caller (`full` default / `core` opt-in; do not infer `core` from “quick” / “light” / “small”), then fans `review-gather-pr` / `review-gather-design` / `review-gather-onboard` as **fresh children** and seeds from their **products**. Skip a gatherer only when the parent already holds that gatherer’s **product** (PR body / design excerpt). A held onboard summary is not that skip — onboard has no seat to seed, always fan that gatherer. Primer dump ≠ product. Default `full` then fans `review-blind`, `review-security`, `review-performance`, `review-logic`, `review-regression`, and `review-checklist` **in parallel**. Intent waits on the reconstructed-intent blob, then runs. Each seat runs isolated in a fresh context and still receives that same comparison (commands, file list, untracked first-class, no self-upstream, named default is `<base>` not `<tip>`). Identical comparison **bytes** across parallel seats stay GREEN. Do not stuff playbooks into that shared seed. Intent’s seed stays PR+design+blob — do not cache it with the others. `review-intent` gets the PR-body and design-excerpt products when present, plus the reconstruct blob. The blind candidate list (`title — path:line` entries, including leftovers) is not passed into that window. The blob may name what the diff appears to do. `review-blind` gets the comparison only — not the PR body, commit message, onboard dumps, orient dumps, gatherer products, gatherer follow transcripts, the implementing turn, GREEN tables / fixture protocol / scoring notes, or specialist playbooks / OWASP lists / CWE lists. Blind stays comparison-only on either pack. Blind still emits `candidates` / `No candidates.` plus a **separate** reconstructed-intent blob. Do not fold that blob into the candidate list. `review-security`, `review-performance`, `review-logic`, `review-regression`, and `review-checklist` still fan with blind when announced. Each window is the comparison plus its own playbook — child Read of that playbook is GREEN (checklist: plus a user-named file when they named one). The reconstruct blob is not in those windows. Then `review-verify` Follows **in the parent** on every announced seat list, Reads its own sibling `gates.md` from that skill’s directory (not cwd), and applies it. Isolation is not a duty of the verifier. Parent-held gatherer products in that window are GREEN. Parent-held reconstruct blob in that window is GREEN (same #30 shape). Parent-held specialist playbooks in that window are GREEN. Do not pass the pack name, the blob, those products, or those playbooks to verify as extra input. Seats emit candidates. They do not apply `gates.md` and do not write Findings / Assessment / Follow-ups. Gatherers return a product and stop. They do not write `Nothing to review.` Onboard has no seat to seed — `review-intent` gets PR body + design excerpt + the reconstruct blob. Do not pass onboard to `review-security` or the other specialists. The parent may hold the onboard product; that hold is not a verify leak. Score sequential letters on the dumps, not the agent. Score Follow-ups on the envelope; leftover emit still on dumps. Score packs on the dumps: the announced set versus the lists verify took.

Score HARNESS-STOP on the dumps: router dump stops without envelope; seat dumps absent. The stop covers nested Task missing, a CloudAgent launch that failed for an announced slot, and a partial helper return alike.

Score spawn letters on the helper dump: back end picked from harness facts; the whole announced set returned or one named stop; intent after the blob on either back end.

Score comparison on the dumps: each seat’s comparison command matches what `review-scope` returned. Wrong base/tip (self-upstream, named default as `<tip>`) stay RED — those letters live in `review-scope` prose. Wrong window is RED. Do not reopen the GREEN rows below.

Score gatherer products in the **parent seed**, not the gatherer follow transcript.

GREEN parent-held scope: `review-changes` Follows `review-scope` in the parent. The parent holds that comparison dump. Seats open fresh and receive that same comparison. Parent-held scope is not a leak.

RED fresh child for scope: the router opened a fresh context for `review-scope` instead of Following in the parent. Scope stays Follow-in-parent.

RED stuffed scope into blind: the parent copied the `review-scope` dump into the `review-blind` prompt or window, or the **blind** child fetched it.

GREEN fresh-child gatherer: after announce, the router opened a fresh context for each gatherer the parent did not already hold a **product** for (PR body / design excerpt). Onboard always gets a fresh child — a held onboard summary is not a skip. Fresh child for these is GREEN (the opposite of `review-scope`).

GREEN parent-seeded product: the parent seeded `review-intent` from the gatherer **product** (PR body, design excerpt when nonempty). Score that seed. The follow transcript is not the seed. Onboard has no seat to seed.

GREEN parent-held gatherer products in the verify Follow: the parent took the gatherer products, then `review-verify` Followed in that window. Parent-held there is GREEN (same #30 shape). The onboard product may sit in that window with no seat to seed. That hold is not a verify leak.

RED product or transcript in blind: the parent copied a gatherer product or follow transcript into the `review-blind` prompt or window, or the **blind** child fetched it.

RED gatherer dump extra-briefing verify: the parent pasted gatherer products into the `review-verify` prompt as a **fourth input**. Candidate lists only. Parent-held products already in that window are not this Failure.

GREEN gatherer skip-because-product: the router skipped a gatherer because the parent already held that gatherer’s **product** (PR body / design excerpt). A held onboard summary is not this GREEN. Parent-held PR / design product in the verify Follow stays GREEN.

RED skip onboard gatherer: the router skipped `review-gather-onboard` because the parent held an onboard summary or a primer dump. Onboard has no seat to seed — always fan. A held onboard summary is not skip GREEN (too close to a primer dump).

RED skip-because-primer: the router skipped a gatherer because the parent held a primer dump. Primer dump ≠ product. One Failure named skip-because-primer — not `skip-because-parent-has-orient`.

GREEN isolation is scored on the seat dump: the blind window received only the comparison. The reconstructed-intent blob in that dump is this seat’s own product, not extra briefing. It is not scored on the Findings block. Silence from `review-blind` is not a verify drop.

GREEN intent window: the intent dump has the comparison + PR-body and design-excerpt products + the reconstruct blob. The blob may name what the diff appears to do. Score the dump, not the agent. A reconstruct sentence that happens to name a helper is not this leak.

RED leftover titles in intent: the blind candidate list (`title — path:line` entries, including leftovers) was passed into the intent window. The list is the leak. Do not RED a reconstruct sentence that happens to name a helper.

RED reconstruct blob in security: the reconstruct blob was in the security window, or the security child Read it. Security still fans with blind. Comparison + own playbook only.

RED reconstruct blob stuffed into blind: the parent passed the blob back into the blind prompt or window as extra briefing (beyond blind producing it).

RED blob folded into candidates: the reconstruct blob was folded into the blind candidate list instead of remaining its own dump product.

GREEN parent-held reconstruct blob in the verify Follow: the parent held the blob, then `review-verify` Followed in that window. Parent-held there is GREEN (same #30 shape). Pasting the blob as extra briefing (a fourth input) is RED. All announced seat lists.

GREEN parent-held orient: a wrapper primed the parent with catch-me-up / orient-* on the file list `review-scope` returned, then invoked `review-changes`. The parent holds that dump. Seats open fresh. The blind dump has no orient. Parent-held orient is not a leak. `review-changes` does not run orient.

RED leaked orient: the parent copied orient into the `review-blind` prompt or window, or the child fetched it.

GREEN security playbook: the playbook is in the `review-security` dump only. The security seat Reads its own playbook in that window. That Read is GREEN. `review-changes` and `review-blind` do not Read it.

RED leaked playbook: the parent copied the security playbook / OWASP lists / CWE lists into the `review-blind` prompt or window, or the **blind** child fetched it. A `review-security` Read of its own playbook is not this Failure.

GREEN specialist playbook: each of `review-performance` / `review-logic` / `review-regression` / `review-checklist` is comparison plus own playbook (checklist: plus a user-named file when they named one). Child Read of that playbook is GREEN. `review-changes` and `review-blind` do not Read it.

RED leaked specialist playbook: the parent copied a specialist playbook into the `review-blind` prompt or window, or the **router** or **blind** child Read it. A specialist Read of its own playbook is not this Failure.

RED reconstruct blob in a specialist window: the reconstruct blob was in the performance / logic / regression / checklist window, or that child Read it. Those seats fan with blind. Comparison + own playbook only.

GREEN fan with blind: after gatherers, pack `full` (default) fanned `review-blind`, `review-security`, `review-performance`, `review-logic`, `review-regression`, and `review-checklist` in parallel. Intent still waits on the reconstruct blob.

RED specialists after intent: the router fanned those specialists after intent instead of with blind.

GREEN verify all announced lists: `review-verify` took every announced seat candidate list. Skip a specialist and leftovers are never-seen (same #31 miss).

RED skip a specialist list: the verifier merged a subset and skipped an announced seat.

GREEN pack full: pack `full` (default or caller-named) announced today’s six (blind, security, performance, logic, regression, checklist) in parallel plus intent sequential. Verify took every announced list.

GREEN pack core: caller named `core`. Announced blind + intent + security only. Verify took those three lists. Unannounced specialists (performance / logic / regression / checklist) are absent from the dumps. Absent unannounced is not never-seen. GREEN pack-core is only “caller named `core`.”

RED pack-core synonym-infer: the router chose `core` because the caller said “light / quick / small review” without naming `core`. Inferring `core` from those synonyms is RED.

RED missing announced list: an announced seat list never reached verify (same #31 never-seen). Unannounced specialists are not this Failure.

RED mid-run invent / dynamic omit: the router added a seat the pack did not announce, or dropped an announced seat because the diff “didn’t need” it. Pack is chosen once. Inventing a pack from the diff is this Failure.

GREEN blind comparison-only either pack: the blind dump is comparison only on `full` and on `core`.

GREEN shared comparison bytes: identical comparison bytes across parallel announced seats. Stuffing playbooks into that shared seed is RED (router / blind Read). Intent’s seed stays PR+design+blob — do not cache it with the others.

Score packs on the dumps: the announced set versus the lists verify took. Do not score the agent.

GREEN parent-held specialist playbooks in the verify Follow: the parent held those playbooks or products, then `review-verify` Followed in that window. Parent-held there is GREEN. Pasting them as extra briefing / extra input is RED. Candidate lists only.

GREEN verify sibling gates: `review-verify` Follows in the parent and Reads its own sibling `gates.md` from that skill’s directory, not cwd. That Read is GREEN.

RED child Read of gates.md: a seat dump or the router dump that Read `gates.md`. Child Read of `gates.md` stays RED for seats and the router. A `review-verify` sibling Read is not this Failure.

GREEN no checklist path: no user-named checklist file → exact `No candidates.` Do not invent a path.

GREEN regression comparison-only: `review-regression` stays comparison plus own playbook. Do not tour the repo.

Score playbook letters on the seat dumps. RED Failures are a blind-window playbook, a router Read, or a blind-child fetch — not a specialist-seat Read of `playbook.md`. Do not add an isolation-only fixture diff. Do not reopen the GREEN rows below.

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

`unusedFormatCents` in `pricing.js` and `refundOrder` in `refunds.js` are **pre-existing**. They must not become numbered findings on the clean diffs. GREEN nits-only / clean-rename stay `No findings.` GREEN is **seen-and-dropped**: a seat may emit them as candidates; the verifier drops them and leftover names appear under **Follow-ups** (`title — path:line`) — `unusedFormatCents` **and** `refundOrder` when seats emitted both. Omit the Follow-ups heading when there are none. Those leftover lines are not counted in the 1–3 sentence Assessment cap (that cap is target / comparison / test gaps only). Leftover names do not appear under Assessment. Compressing both names into the sentence cap is not GREEN. Silent never-seen is not GREEN. Repeating the same leftover every review is the tracker; dropping it because it was named last PR is never-seen again. Host-not-advertised (`host-gap`) stays a separate residual-or-empty one line under Assessment — not those leftover lines, not counted in the sentence cap, and not mixed with leftover titles. Security and other specialist leftovers visible in the comparison are the same leftover class: emit, never swallow. A category title, “could be A01” with no path, or a generic Top 10 recitation is not a security candidate. Do not name a gate in the output envelope.

GREEN leftover Follow-ups: leftover names appear under Follow-ups (`title — path:line`). Omit the heading when there are none.

RED leftover numbered as a finding: a leftover that failed gate 3 was numbered / P0–P3 in Findings. `unusedFormatCents` / `refundOrder` stay unnumbered.

RED G5 nits / speculative / `dropped: N` under Follow-ups: Follow-ups is only seat-emitted leftovers (`title — path:line`). A gate-5 nit, a speculative drop, or `dropped: N` under that heading is minor-bucket bleed.

RED leftover mixed into host-gap residual: leftover titles appear on the host-not-advertised residual line.

RED leftover stuffed into Assessment sentence cap: leftover names still appear under Assessment, or are squeezed into the 1–3 sentence slot.

Stop paths still skip the envelope (no Findings / Assessment / Follow-ups).

GREEN HARNESS-STOP: after a comparison was announced, a gatherer or an announced seat cannot start on this host — no nested Task tool and no CloudAgent launch primitive, or a CloudAgent launch for that slot was rejected / never returned, or `review-spawn-seats` handed back a subset. Router dump is a brief stop naming the slot and the primitive (cannot open a fresh context / cannot fan / cannot launch). No Findings / Assessment / Follow-ups. Seat dumps absent. This is not `Nothing to review.` and not a `shape-*` stop. Nested-Task-missing is one case of this letter, not the whole letter.

RED HARNESS-STOP envelope: after that hard stop, the router dump still has Findings / Assessment / Follow-ups.

RED HARNESS-STOP inline: the router reviewed inline as one agent (followed a gatherer or seat in this turn, or pretended seats ran). Same RED on a CloudAgent host: never review inline because a launch failed.

RED HARNESS-STOP empty pass: after HARNESS-STOP, the dump writes `No findings.` or an empty pass as if seats ran.

Procedure parent: `procedure/`. Those diffs are against that tree (`-p1` from `fixtures/review-sample/`). `SKILL.md` and `paths.md` are procedure files. README and `docs/plan.md` are not.

Hook parent: `hook/`. Those diffs are against that tree (`-p1` from `fixtures/review-sample/`). A this-PR advertised path is a finding. A host-not-advertised capability is residual-or-empty.

## Spawn helper letters (dual harness)

`review-changes` starts gatherers and announced seats through `review-spawn-seats`. That helper picks the back end from **harness facts** (nested Task / subagent tool present → Task nest; absent with a CloudAgent launch primitive present → CloudAgent fan; neither → HARNESS-STOP). `cloud-seat` is an invocation mode of the same router — same packs, same comparison-seed / intent-seed, same gates, same HARNESS-STOP. There is no `review-changes-cloud` sibling and no lighter cloud pack. Score these on the router dump and the helper dump, not the agent.

GREEN spawn-fail HARNESS-STOP: an announced seat or a required gatherer could not start (nested Task tool missing, CloudAgent launch rejected or never returned). The router dump is a brief HARNESS-STOP naming that slot. Verify took no lists. Pack was not re-announced. No slot was dropped. No Findings / Assessment / Follow-ups. No `No findings.`

RED spawn-fail thinner merge: after a slot failed to start, the seats that did start were merged and handed to verify (or the verifier merged them). An announced list that never existed is never-seen (same #31 miss).

RED spawn-fail synonym-core: after a slot failed to start (or because the host lacks a Task tool), the router re-announced `core` or dropped the failed seat so the run could finish. A harness miss never thins the pack. Same RED as pack-core synonym-infer, from a harness fact instead of a word.

GREEN host pick from harness facts: the helper dump shows the harness facts it probed and a pick that follows them — Task tool present → `task-nest`; Task tool absent and CloudAgent launch present → `cloud-fan`; neither → HARNESS-STOP. Basis is `harness-facts`.

RED wrong-primitive: the helper picked Task vs CloudAgent from a name or tier word (“Grok”, “Grok Bot”, “quick”, “light”, “Medium”, “small”, “cloud”, the model name) instead of harness facts, or the pick contradicts the facts (Task tool present but fanned CloudAgents; Task tool absent but claimed a Task nest).

GREEN full return for the announced set: the helper returned one dump per announced slot — the whole set — or returned no dumps with one named HARNESS-STOP. Intent launched only after the blind dump was back.

RED partial-return: the helper returned a nonempty subset of the announced set without a HARNESS-STOP, or returned dumps alongside a HARNESS-STOP. “Five of seven, the rest did not come back” is this letter.

RED cloud intent fanned with blind: on the CloudAgent back end, `review-intent` was launched with `review-blind` because agents can run concurrently. Intent waits on the reconstruct blob on every host.

GREEN verify parent-Follow either mode: `review-verify` Followed in the parent on a Task nest and in cloud-seat mode alike. It is not a spawned slot. Parent-held products / blob / playbooks / primer dumps in that Follow stay GREEN. Pasting them as a fourth input stays RED.

## Branch / PR comparison (not a stored patch)

The diffs above test named-patch reviews. “This PR” / no target / a named feature branch is a **different** comparison. Those letters live in `review-scope`:

Wrong: `git merge-base HEAD @{upstream}` when upstream is this same branch → empty file list → fake `No findings.`
Wrong: “review this against origin/main” treating `origin/main` as `<tip>` → tip equals base → fake `Nothing to review.`
Right: `git diff $(git merge-base <tip> <base>)...<tip>` where `<base>` is `origin/main` (or the repo default), never the branch tracking itself. A named default / “against X” / “into X” is `<base>`. `<tip>` is the feature/PR branch (HEAD when that is the subject), or a named *non-base* branch. Naming the PR branch while on `main` still diffs that tip against `main`.

Working tree: file list = `git diff HEAD --name-only` ∪ `git ls-files --others --exclude-standard`. Untracked files are first-class (Read or `git diff --no-index -- /dev/null <path>`). Do not `git add`. Untracked-only is not `Nothing to review.`

This is not a real product. Do not edit `src/` during review tests.

## Dump-letter scorer

Replay recorded seat/router window dumps (no live review agents):

```bash
./scripts/score-review-dump-letters.sh
./scripts/test-score-review-dump-letters.sh
```

Cases in `letters/` cite the GREEN/RED letter headings in this file. The nine-row Expected GREEN table is locked by `green-table.lock.md` — the scorer fails if those rows move.
