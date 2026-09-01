# review-sample

Tiny pricing module used to test the review skill family.

Protocol: `review-changes` classifies the comparison, then fans out. Each seat runs isolated in a fresh context. `review-intent` gets PR/docs context when present. `review-blind` gets the comparison only — not the PR body, commit message, onboard dumps, orient dumps, the implementing turn, GREEN tables / fixture protocol / scoring notes, or the security playbook / OWASP lists / CWE lists. `review-security`’s window is the comparison plus its own playbook — child Read of that playbook is GREEN. Then `review-verify` takes all three seat lists and applies `gates.md`. Isolation is not a duty of the verifier. Seats emit candidates. They do not apply `gates.md` and do not write Findings / Assessment / Close.

GREEN isolation is scored on the seat dump: the blind window contained only the comparison. It is not scored on the Findings block. Silence from `review-blind` is not a verify drop.

GREEN parent-held orient: a wrapper primed the parent with catch-me-up / orient-* on the cheap-resolve file list, then invoked `review-changes`. The parent holds that dump. Seats open fresh. The blind dump has no orient. Parent-held orient is not a leak. `review-changes` does not run orient.

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

The diffs above test named-patch reviews. “This PR” / no target / a named feature branch is a **different** comparison:

Wrong: `git merge-base HEAD @{upstream}` when upstream is this same branch → empty file list → fake `No findings.`
Wrong: “review this against origin/main” treating `origin/main` as `<tip>` → tip equals base → fake `Nothing to review.`
Right: `git diff $(git merge-base <tip> <base>)...<tip>` where `<base>` is `origin/main` (or the repo default), never the branch tracking itself. A named default / “against X” / “into X” is `<base>`. `<tip>` is the feature/PR branch (HEAD when that is the subject), or a named *non-base* branch. Naming the PR branch while on `main` still diffs that tip against `main`.

Working tree: file list = `git diff HEAD --name-only` ∪ `git ls-files --others --exclude-standard`. Untracked files are first-class (Read or `git diff --no-index -- /dev/null <path>`). Do not `git add`. Untracked-only is not `Nothing to review.`

This is not a real product. Do not edit `src/` during review tests.
