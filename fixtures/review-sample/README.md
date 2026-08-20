# review-sample

Tiny pricing module used to test the review skill family.

`src/` is the parent (pre-change). Each file in `changes/` is a proposed patch against that parent.

| Diff | What it is | Expected GREEN |
|---|---|---|
| `changes/clean-rename.diff` | Rename `couponRate` → `discountRate` | `No findings.` |
| `changes/nits-only.diff` | Comment, blank line, `subtotal` → `subTotal` | `No findings.` |
| `changes/tax-bug.diff` | Tax applied to subtotal, then discount subtracted | Finding: shopper with a coupon is overcharged |

`unusedFormatCents` in `pricing.js` and `refundOrder` in `refunds.js` are **pre-existing**. They must not become numbered findings on the clean diffs.

This is not a real product. Do not edit `src/` during review tests.
