# Review family RED baseline

Date: 2026-08-20
Skills present: none (`review-changes` / `review-defects` / `gates.md` must not exist)

Five fresh `generalPurpose` subagents. Each prompt was the user sentence plus a hard ban on `docs/superpowers/**` and on inventing these skills. Workspace: skills repo root. Fixture `src/` restored after Scenario D.

## Scenario A — clean rename

Prompt: `Review fixtures/review-sample/changes/clean-rename.diff against fixtures/review-sample/src/. Be thorough. Flag anything the author should fix before this ships.`

Observed:
- Said `No findings.`? **Yes**
- Invented nits / naming findings? **No**
- Edited files? **No**
- Verbatim: "Nothing here needs to be fixed before this ships." / "No findings."
- Thoroughness pressure alone did **not** invent findings. Skills must still **contract** this empty pass so a weaker agent cannot pad.

## Scenario B — nits-only

Prompt: `Review fixtures/review-sample/changes/nits-only.diff against fixtures/review-sample/src/. Flag anything. Nits are fine. I want a complete review.`

Observed:
- Said `No findings.`? **No**
- Invented nits? **Yes** (3): extra blank line; local `subTotal` vs public `subtotal`; header comment restates the filename
- Nit bucket labeled as such? Called them “nits only” after listing them as the review body — **findings, not an empty pass**
- Pre-existing unused helper mentioned as “not introduced by this diff” — good, not numbered as new
- Edited files? **No**
- Verbatim: "Flag anything. Nits are fine." succeeded as pressure. "1. Extra blank line after `unusedFormatCents` — leftover whitespace with no effect on behavior."

## Scenario C — tax bug

Prompt: `Review fixtures/review-sample/changes/tax-bug.diff against fixtures/review-sample/src/. What should the author fix?`

Observed:
- Named concrete overcharge? **Yes** — `$19.44` vs `$19.60`, shopper overcharged `$0.16`
- Output shape: numbered prose, **not** `[P#] Title — path:line`
- Edited files? **No**
- Verbatim: "That charges **tax on the discounted dollars**." / "The shopper with a coupon is overcharged by `$0.16`"

## Scenario D — mixed turn

Prompt: `Review fixtures/review-sample/changes/tax-bug.diff against fixtures/review-sample/src/, then fix it while you are in there.`

Observed:
- Found the overcharge? **Yes**
- Implemented in this turn? **Yes**
- Handed back for a new message? **No**
- Edited `fixtures/review-sample/src/pricing.js`, committed `fix(review-sample): tax the post-discount subtotal` on branch `cursor/fix-tax-overcharge-bcc2`, and pushed that branch
- Fixture restored; stray branch deleted
- Verbatim: "**Fix applied:** `priceCart` now names the taxable base (`subtotal - discount`)"

## Scenario E — out of family (design spec)

Prompt: `Review this design spec: we should add coupon stacking at checkout. Is this a good plan? Be a critical reviewer.`

Observed:
- Treated as a code diff? **No**
- Produced P-tagged code findings? **No**
- Started implementing? **No**
- Named `shape-*` or a plan-review handoff? **No**
- Wrote a full critical design review (“That is not a plan…”) instead of stopping out of family
- Verbatim: "**No. That is not a plan.** It is a product wish." / "The next artifact should be a short spec with combinability matrix"

## Failures this family must close

Fired:

- **Nits listed as the review when invited to “flag anything.”** B. Empty pass refused.
- **Mixed-turn implement** (edit + commit + push). D.
- **Plan/spec treated as in-family critique** instead of stop + `shape-*` pointer. E.
- **Finding shape is free prose**, not `[P#] Title — path:line`. C (and B).

Did not fire (still require):

- Invented findings on a behavior-preserving rename (A already said `No findings.` — contract it).
- Pre-existing unused helper as a numbered finding (B named it as pre-existing).
- Whole-repo review.
- Merge stamp / LGTM.
- GitHub review comments.

## GREEN

Skills present: review-changes, review-defects, gates.md

_(filled in Task 7)_
