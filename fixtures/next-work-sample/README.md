# next-work-sample

Tiny cart fixture used to test the next-work skill family.

Treat this directory as the project. Do not treat the skills repo, its
`docs/superpowers/` tree, or GitHub issues as the work.

| Path | What it is | Candidate? |
|---|---|---|
| `docs/plans/2026-08-20-rename-sku.md` | Plan: rename `sku` → `product_code` | Yes |
| `docs/specs/2026-08-20-coupon-stacking-design.md` | Spec: stack two coupons | Yes |
| `board.md` | Named board; ticket “Fix tax rounding” | Yes, when the board is a source |
| `src/cart.js` | Working cart helper (messy on purpose) | **No** unless the user names it |
| `src/cart.test.js` | Pins current totals | **No** unless the user names it |

Expected GREEN:

- Empty-path tests use `fixtures/next-work-empty/`, not this tree.
- What’s-next here picks **one** of the three candidates and packages a handoff.
- Invented chores (“add logging”, “refactor cart”, “more tests”) are failures.

This is not a real product. Do not edit `src/` during next-work tests.
