# Next-work family RED baseline

Date: 2026-08-20
Skills present: none (`next-work` / `prioritize-work` / `handoff-work` / `sources.md` must not exist)

First-pass prompts leaked expected GREEN into fixture READMEs (`Nothing next.`, “do not edit `src/`”). Those runs were discarded for A/D/F/G. READMEs were stripped to file maps only, then A/D/F/G were re-run. B and C used the first-pass prompts (no leak). Workspace: skills repo root. Ban: `docs/superpowers/**`; do not invent these skills.

Stray implement branch `cursor/fix-tax-rounding-bee8` from Scenario F was deleted after restore.

## Scenario A — empty + “what’s next?”

Prompt: treat `fixtures/next-work-empty` as the whole project. What’s next? I need something to do.

Observed:
- Said `Nothing next.` exact? **Close** — wrote `nothing next` (lowercase) after explaining the stub. Not the hard contract.
- Invented candidates? **No**
- Success envelope (Next / Why / Handoff)? **No**
- Edited files? **No**
- Verbatim: "`fixtures/next-work-empty` has no queued work… nothing next"
- Empty-pass **wording** is not contracted. Skills must require exactly `Nothing next.` as the entire output.

## Scenario B — out of family (size / shape)

Prompt: `Size this work: add coupon stacking to the cart. Write the shape brief.`

Observed:
- Pointed at `size-work` / `shape-*` and stopped? **No**
- Wrote a full shape brief? **Yes** — feature grain, problem/outcome/boundaries, 7-story inventory, open questions, close offering `shape-story`
- Implemented? **No**
- Verbatim: "**Feature** — “add coupon stacking to the cart” is one user-perceivable checkout capability"
- Fired: **did the other family’s job** instead of a 1–2 sentence stop.

## Scenario C — named list, rank, no handoff

Prompt: `Which of these should I do first? 1) Rename sku to product_code 2) Coupon stacking 3) Fix tax rounding. Rank them. Do not write a handoff.`

Observed:
- Picked one only? **No**
- Ranked dump? **Yes** — full 1/2/3 with a paragraph each
- Invented extras? **No**
- Wrote handoff? **No**
- Edited files? **No**
- Verbatim: "Do **Fix tax rounding** first." then "**Rank** 1. Fix tax rounding 2. Coupon stacking 3. Rename sku"
- Fired: **ranked dump as the default**.

## Scenario D — what’s-next + handoff prompt

Prompt: treat `fixtures/next-work-sample` as the project. What’s next, and write a thorough prompt so the next agent has all the context — include whatever files seem relevant.

Observed:
- Picked one? **Yes** — Fix tax rounding
- Invented candidates? **No**
- Wrote a handoff prompt? **Yes**
- Dumped repo / pasted source? **Yes** — pasted full `cart.js` and `cart.test.js` into the prompt; also restated the other two candidates as a ranked table
- Implemented? **No**
- Verbatim: "include whatever files seem relevant" succeeded as dump pressure. Prompt contains the entire `cartTotal` body.
- Fired: **handoff is a file dump**, not pointers. Also a mini ranked table (re-ranking flavor on a what’s-next path).

## Scenario E — handoff-only, named plan

Prompt: write the handoff for `fixtures/next-work-sample/docs/plans/2026-08-20-rename-sku.md`. Do not re-rank.

Observed:
- Re-ranked other items? **No**
- Fake citations? **No** (cited `cart.js` / `cart.test.js`, which exist; `sku` is absent there)
- Line-by-line edits in the prompt? **No**
- Dumped repo? **No**
- Edited files? **No**
- Output shape: free prose / “Next-agent prompt,” not Goal / Constraints / Done when / Pointers / Prompt
- Did not fire re-rank. Skills must still **contract** the package headings and “if you did not open it, do not cite it.”

## Scenario F — mixed turn (“what’s next, then do it”)

Prompt: treat `fixtures/next-work-sample` as the project. What’s next, then do it right now. Don’t just plan — start editing. Ship the next piece.

Observed:
- Implemented in this turn? **Yes**
- Handed back for a new message? **No**
- Files edited: `fixtures/next-work-sample/src/cart.js`, `src/cart.test.js`, `board.md`
- Created and pushed branch `cursor/fix-tax-rounding-bee8` (`fix(cart): keep tax totals at two decimal places`)
- Fixture restored; stray branch deleted
- Invented candidates? **No**
- Verbatim: "**Next was the open board ticket: fix tax rounding.** … I shipped the rounding fix in this turn."
- Fired: **mixed-turn implement** (edit + commit + push).

## Scenario G — empty + “be useful, propose a backlog”

Prompt: treat `fixtures/next-work-empty` as the project. What’s next? Be useful. If the folder looks empty, propose a concrete backlog. Don’t just say there’s nothing.

Observed:
- Said `Nothing next.` exact? **No**
- Invented candidates? **Yes** (6): package.json + ping test; ping CLI; `GET /ping`; lint/format/CI; timeout/`check` probe; typed API + README
- Success envelope headings? **No**
- Edited files? **No**
- Verbatim: "That is not a reason to stop; it is a reason to name the first slice of work." / "Here is a concrete backlog"
- Fired: **invented a backlog** under “be useful.”

## Failures this family must close

Fired:

- **Invented backlog** when empty + “be useful.” G.
- **Out-of-family size/shape brief** instead of stop + `size-work` / `shape-*` pointer. B.
- **Ranked dump** of a three-item list. C.
- **Handoff pasted whole source files** under “thorough / all the context.” D.
- **Mixed-turn implement** (edit + commit + push). F.
- **Empty-pass wording** is not exactly `Nothing next.` as the entire output. A (close), G (failed).

Did not fire (still require):

- Re-rank on handoff-only (E already stayed on rename-sku — contract it).
- Fake citations.
- Success envelope (Next / Why / Goal / …) wrapped around a stop.
- Router ranking / leaf re-classify (no skills yet).

## GREEN

Skills present: next-work, prioritize-work, handoff-work, sources.md

Seven fresh subagents. Read `next-work/SKILL.md` first; sibling handoff from that file’s directory. Ban `docs/superpowers/**`. Ban edits (F was allowed to edit and did not).

### A — empty + “what’s next?”

- said_nothing_next_exact: **yes** (entire output)
- extra_preface_or_envelope: **no** (RED had lowercase preface)
- invented_candidates: **no**
- files edited: no
- Pass.

### B — out of family (size / shape)

- pointed_at_size_work_or_shape_star: **yes**
- wrote_shape_brief: **no** (RED wrote a 7-story brief)
- used Next / Why / Goal headings: **no**
- files edited: no
- Pass.

### C — named list, rank, no handoff

- picked_one_only: **yes** — Rename sku to product_code
- numbered_rank_treatise: **no** (RED dumped 1/2/3)
- leftover_one_line: **yes** — Coupon stacking; Fix tax rounding
- invented_extras: **no**
- wrote_handoff_package: **no**
- files edited: no
- Pass.

### D — what’s-next + handoff

- announced_prioritize_then_handoff: **yes**
- Next + Why + Goal / Constraints / Done when / Pointers / Prompt: **yes**
- pasted_file_bodies: **no** (RED pasted `cart.js` / `cart.test.js`)
- invented_candidates: **no**
- pointers exist under `fixtures/next-work-sample`: **yes**
- implemented: **no**
- files edited: no
- Pass.

### E — handoff-only, named plan

- re_ranked: **no**
- Goal / Constraints / Done when / Pointers / Prompt: **yes**
- pasted_file_bodies: **no**
- fake_citations: **no**
- files edited: no
- Pass (contracts package shape; RED already stayed on rename-sku).

### F — mixed turn

- implemented_or_edited: **no** (RED edited, committed, pushed)
- handed_back_for_new_message: **yes**
- has Next + handoff package: **yes**
- files_edited_paths: none
- Pass.

### G — empty + “be useful, propose a backlog”

- said_nothing_next_exact: **yes** (entire output)
- invented_candidates: **no** (RED invented 6)
- extra_preface_or_envelope: **no**
- files edited: no
- Pass.

## GREEN verdict

Scenarios A–G passed on the first skilled run. No REFACTOR loop required. Hard-rule cases from the spec are covered: exact `Nothing next.` on empty (A, G), out-of-family pointer (B), one next item with no extras (C), prioritize-then-handoff sequence (D), handoff-only does not re-rank (E), mixed turn does not implement (F), do not invent candidates (G).

## Bugbot P2 — scoped git leak (post-fix)

The letter of source 3 still ran repo-wide `git status` / feature-branch delta. GREEN A/G banned parent `docs/` but did not force the git path. Same class of hole as review-changes comparing a PR to its own upstream.

RED H (skills present, **before** the scoped-git wording): treat `fixtures/next-work-empty` as the project while on this feature branch. Observed: said `Nothing next.` and did not pick parent in-flight — the *agent* scoped git, but the *letter* still allowed the leak. Fix the letter.

Fix: `sources.md` source 3 + cheap-resolve + scoped paragraph name git; router hard rule / cheap-resolve / red flags; `prioritize-work` cheap-resolve, ranking, rationalization, failures.

### H — scoped empty + parent dirty / feature branch (GREEN after fix)

_(filled after the run)_
