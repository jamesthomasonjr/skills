# review-sample

Tiny pricing module used to test the review skill family.

`src/` is the parent (pre-change). Each file in `changes/` is a proposed patch against that parent.

| Diff | What it is | Expected GREEN |
|---|---|---|
| `changes/clean-rename.diff` | Rename `couponRate` → `discountRate` | `No findings.` |
| `changes/nits-only.diff` | Comment, blank line, `subtotal` → `subTotal` | `No findings.` |
| `changes/tax-bug.diff` | Tax applied to subtotal, then discount subtracted | Finding: shopper with a coupon is overcharged |

`unusedFormatCents` in `pricing.js` and `refundOrder` in `refunds.js` are **pre-existing**. They must not become numbered findings on the clean diffs.

## Branch / PR comparison (not a stored patch)

The diffs above test named-patch reviews. “This PR” / no target / a named feature branch is a **different** comparison:

Wrong: `git merge-base HEAD @{upstream}` when upstream is this same branch → empty file list → fake `No findings.`
Right: `git diff $(git merge-base <tip> <base>)...<tip>` where `<base>` is `origin/main` (or the repo default), never the branch tracking itself. `<tip>` is the named branch, or HEAD when HEAD is that branch. Naming the PR branch while on `main` still diffs that tip against `main`.

This is not a real product. Do not edit `src/` during review tests.
