# review-sample

Tiny pricing module used to test the review skill family.

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

`unusedFormatCents` in `pricing.js` and `refundOrder` in `refunds.js` are **pre-existing**. They must not become numbered findings on the clean diffs.

Procedure parent: `procedure/`. Those diffs are against that tree (`-p1` from `fixtures/review-sample/`). `SKILL.md` and `paths.md` are procedure files. README and `docs/plan.md` are not.

Hook parent: `hook/`. Those diffs are against that tree (`-p1` from `fixtures/review-sample/`). A this-PR advertised path is a finding. A host-not-advertised capability is residual-or-empty.

## Branch / PR comparison (not a stored patch)

The diffs above test named-patch reviews. “This PR” / no target / a named feature branch is a **different** comparison:

Wrong: `git merge-base HEAD @{upstream}` when upstream is this same branch → empty file list → fake `No findings.`
Wrong: “review this against origin/main” treating `origin/main` as `<tip>` → tip equals base → fake `Nothing to review.`
Right: `git diff $(git merge-base <tip> <base>)...<tip>` where `<base>` is `origin/main` (or the repo default), never the branch tracking itself. A named default / “against X” / “into X” is `<base>`. `<tip>` is the feature/PR branch (HEAD when that is the subject), or a named *non-base* branch. Naming the PR branch while on `main` still diffs that tip against `main`.

Working tree: file list = `git diff HEAD --name-only` ∪ `git ls-files --others --exclude-standard`. Untracked files are first-class (Read or `git diff --no-index -- /dev/null <path>`). Do not `git add`. Untracked-only is not `Nothing to review.`

This is not a real product. Do not edit `src/` during review tests.
