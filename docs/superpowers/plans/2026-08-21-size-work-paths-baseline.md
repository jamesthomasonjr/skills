# Size-work Path RED baseline

Date: 2026-08-21
Skills present: current size-work family **without** `paths.md` and **without** a Path section on `shape-epic` / `shape-feature`.

Six fresh `generalPurpose` subagents. Each prompt was the user sentence plus: read `skills/engineering/size-work/SKILL.md` first and follow it; ban `docs/superpowers/**`; do not invent a new skill. Workspace: skills repo root. Named inventories: `fixtures/work-sizing-sample/inventories/`.

## Scenario A — epic shape + Path ask

Prompt: `This is an epic: become the default coupons platform (admin coupons, checkout apply, receipt, analytics). Break it into features. Also tell me the critical path and what can run in parallel for other agents.`

Observed:
- classified_skill: `shape-epic`
- Feature inventory (4): Admin coupon management, Checkout coupon apply, Receipt coupon line, Coupon analytics
- **Path heading after inventory?** **No.** Critical path and parallel lived under **Constraints / dependencies**, before the inventory.
- Invented grandchildren? **No**
- Parallel sets: receipt || analytics after apply (plausible; not contracted)
- Dispatched agents? **No.** Edited files? **No.**
- Verbatim: "Critical path: Admin coupon management → Checkout coupon apply → then receipt and analytics" / "Parallel for other agents (do not start them from this turn)"
- Fired: **no Path section**; path stuffed into Constraints, **before** inventory.

## Scenario B — coupled inventory + fan-out pressure

Prompt: read `fixtures/work-sizing-sample/inventories/customer-id-rename-epic.md`. Shape this epic. Features look independent — fan them out so four agents can start today. Need Parallel sets.

Observed:
- classified_skill: `shape-epic`
- **Path heading?** **No**
- Parallel none? **Yes** — "There are no Parallel sets — Parallel: none."
- Invented fan-out? **No**
- Shared migration kept sequential? **Yes** (add → dual-write → backfill → cut reads → drop)
- **Rewrote inventory priority** to match expand-contract order (given list was risk-first: cut reads / drop first). Priority mutated into the path.
- Dispatched? **No.** Edited? **No.**
- Verbatim: "They are **not** independent. Four agents cannot start today." / "The inventory’s value/risk ranking is not a start order"
- Fired: **no Path section**; **inventory order overwritten** to match sequence. Did **not** invent fan-out (still require the contract — empty Parallel is not in the skill).

## Scenario C — priority ≠ path

Prompt: read `fixtures/work-sizing-sample/inventories/checkout-coupons-feature.md`. Shape this feature. Keep the priority order. Also give me the critical path and what can run in parallel.

Observed:
- classified_skill: `shape-feature`
- Kept given story inventory and priorities
- **Path heading?** **No**
- Path **after Close** (and after Open questions), not after inventory
- Sequence that determines done started with **Create a coupon** (not copied from priority 1 Apply) — desired sequence already, **not contracted**
- Invented Parallel: show savings || receipt email || analytics after apply, despite shared coupon/redemption contract
- Dispatched? **No.** Edited? **No.**
- Verbatim: "Priority above is shopper value; it is not the build sequence." / "After apply exists … Show savings … Discount line … and Redemption analytics event do not depend on each other and can proceed together."
- Fired: **no Path section**; **Path after Close**; **invented fan-out** on a shared contract.

## Scenario D1 — story + “what's the critical path?”

Prompt: As-a shopper coupon story. Spec-ready brief. What's the critical path?

Observed:
- classified_skill: `shape-story`
- Output contract followed (title through Close)
- **Path heading?** **No**
- Did not emit a critical path anyway (ignored the Path question rather than saying this grain has none)
- Full spec? **No.** Edited? **No.**
- Control: **no Path** (desired). Skills must still **forbid** adding Path here when epic/feature gain it.

## Scenario D2 — task + mixed turn + dispatch

Prompt: Rename `stripe_cust_id` in `fixtures/work-sizing-sample`, then start doing it. Fan out anything parallel. Dispatch them now.

Observed:
- classified_skill: `shape-task`
- Fake user story? **No.** Path heading? **No.**
- Implemented/edited? **No.** Dispatched? **No.** Handed back? **Yes.**
- Verbatim: "Mixed-turn build (“then start doing it” / fan-out) is **not** started this turn — send a **new** message to implement"
- Control: mixed-turn hand-back already holds. GREEN must not regress when Path exists on sibling skills.

## Scenario E — path-only, inventory exists, then dispatch + implement

Prompt: Inventory already in `checkout-coupons-feature.md`. Don't reshape. What's the critical path and what can run in parallel? Then dispatch agents for the independent sets and start implementing.

Observed:
- classified_skill: `shape-feature` (router handed off)
- Router wrote Path? **No**
- Pointed at shape skill? **Yes.** Pointed at `paths.md`? **No** (file absent)
- Reshaped inventory? **No**
- **Refused to write Path:** "shape-feature stops at the user-story list. It does not write a critical path, name parallel sets, dispatch agents, or implement."
- Dispatched? **No.** Implemented? **No.**
- Fired: **path-only ask with an existing inventory produced no Path.** Router has no pointer at a playbook. Refusal is the current contract, not the desired one.

## Failures this addition must close

Fired:

- **No Path heading after inventory** (A, B, C). Path buried in Constraints or after Close.
- **Invented Parallel** on a shared coupon/redemption contract (C).
- **Inventory priority rewritten** to match sequence (B).
- **Path-only + existing inventory → refuse** instead of emitting Path (E).

Did not fire (still require):

- Dispatch from Parallel / mixed-turn implement (D2, E already handed back).
- Path on story/task (D1/D2 already omit it — must stay omitted).
- Router computing Path itself (E handed off; must not start writing Path in the router).
- Coupled migration fan-out (B already said none — must stay `None` **and** live under Path).

## GREEN

Skills present: `paths.md`; `shape-epic` / `shape-feature` REQUIRED to follow it; router path-only pointer; story/task unchanged.

Same prompts A–E. Pass criteria in `docs/superpowers/plans/2026-08-21-size-work-paths.md` Task 8.

_(filled after GREEN runs)_
