---
name: review-changes
description: >-
  Router for defect-first code review. Use when the user asks to review
  a change, PR, commit, working tree, or what they just changed. Follows
  review-scope, gathers products in fresh children, then fans out; does
  not review. Read-only.
---

# Review changes

Follow `review-scope`, announce the comparison it returned, fan gatherers
as fresh children, then fan out to the three seats and fan in to the
verifier. This skill does **not** review and does **not** write findings.

## Hard rules

- Read-only. No edits, no commits, no pushes, no GitHub review comments.
- Do not apply [gates.md](gates.md). Do not write findings. That is `review-verify`.
- Do not Read `gates.md` in this skill. Seats do not read it.
- Do not duplicate `review-scope` tables here. Follow that sibling; pass what it returned.
- Do not open a fresh child for `review-scope`. Scope stays Follow-in-parent.
- After announce, run each gatherer in a fresh context. Do not follow a gatherer in this turn. If the harness cannot open a fresh context, stop and say so.
- Run each seat in a fresh context that contains only what this router passed. Do not follow a seat in this turn. If the harness cannot open a fresh context, stop and say so. Withhold is not isolation.
- Do not run catch-me-up / orient-*. Orient is wrapper priming, not a seat and not a required step in this skill. Do not skip a gatherer because the parent already holds that briefing.
- Mixed turn (“review this, then fix it”): pass the fix request through. The verifier finishes the review, then hands back. Do not implement in this turn.
- Out of family (“review this plan / spec / design”): stop. Point at `shape-*` (or a later plan-review skill). Do not read the gatherers, seats, or `review-verify`. Do not grill the prose as a design reviewer. A `SKILL.md` or required playbook in the file list is not this signal — hand off.
- Empty or unresolvable target: ask once or stop with exactly `Nothing to review.`
- Focus is an optional user-named phrase, not a menu. Do not infer modes.

## 1. Resolve

**REQUIRED:** Follow [../review-scope/SKILL.md](../review-scope/SKILL.md) **in the parent**. Resolve that path from **this file’s directory**, not from cwd. Same sibling-path rule as the seats: `../review-scope/SKILL.md` means “next to this skill.” After `~/.cursor/skills/<name>` symlink or a plugin copy, `skills/engineering/review-*/SKILL.md` does not exist.

If a cwd-relative Read of a sibling misses (user workspace is a different repo), resolve the sibling from the path you used to open **this** `SKILL.md`, or invoke the skill by name.

`review-scope` returns the comparison, comparison command, and file list — or **empty** / **unresolvable**. Do not re-run its tables. Do not invent a different comparison. Do not open a fresh child for `review-scope`.

## 2. Announce and gather

**Out of family:** one or two sentences, name `shape-*` (or a later plan-review skill), **stop**. Do not read a gatherer, a seat, or `review-verify`. Do not write a design critique. A `SKILL.md` or required playbook in the file list is in family — hand off.

**Empty / unresolvable:** if they can still name a target, ask once and stop. Otherwise write exactly `Nothing to review.` and stop.

Otherwise one line: which comparison `review-scope` returned and why (short).

Read **sibling** skill files resolved from **this file’s directory**, not from cwd.

Fan gatherers as **fresh children** — the opposite of `review-scope`. Each child contains only the announced comparison, comparison command, and file list (plus that gatherer’s own `SKILL.md`). Take the **product** back. Do not seed a gatherer follow transcript. Do not skip a gatherer because the parent already holds a briefing. Do not write `Nothing to review.` from a gatherer’s empty product — empty product means seed nothing for that slot.

- [../review-gather-pr/SKILL.md](../review-gather-pr/SKILL.md) — product: PR body
- [../review-gather-design/SKILL.md](../review-gather-design/SKILL.md) — product: design excerpt
- [../review-gather-onboard/SKILL.md](../review-gather-onboard/SKILL.md) — product: onboard summary of that file list

If this harness cannot open a fresh context for a gatherer, **stop** and say so. Do not follow that gatherer in this turn.

## 3. Hand off seats and verify

Read the **seats** first. Do **not** Read `review-verify` until all three seats have emitted candidates. Do **not** Read `gates.md` in this skill.

- [../review-intent/SKILL.md](../review-intent/SKILL.md)
- [../review-blind/SKILL.md](../review-blind/SKILL.md)
- [../review-security/SKILL.md](../review-security/SKILL.md)

Do **not** restate `gates.md`. Do **not** apply it. Do **not** Read the security playbook.

**Pass to all three seats:** the announced comparison, comparison command, and file list only, mixed-turn fix request if any, optional focus phrase if they named one. Do not pass a different comparison. Do not pass a gatherer follow transcript. Do not pass the `review-scope` follow transcript.

**Pass to `review-intent` only:** the `review-gather-pr` product (PR body) and the `review-gather-design` product (design excerpt) when those products are nonempty, plus commit message / procedure context when present. GREEN tables / fixture protocol / scoring notes / orient dumps / the onboard product are not procedure context. The security playbook is not procedure context. Do not dump a gatherer follow transcript into intent.

Onboard has no seat to seed. Do **not** pass the onboard product to `review-intent`, `review-blind`, or `review-security`. The parent may hold it.

A security seat Reads its own file. `review-changes` and `review-blind` do not. Do not copy playbook bytes into the blind prompt.

**Do not pass** the PR body, commit message, onboard dumps, orient dumps, gatherer products, gatherer follow transcripts, the implementing turn, GREEN tables / fixture protocol / scoring notes, the security playbook / OWASP lists / CWE lists, or the `review-scope` follow transcript to `review-blind`. Pass the announced comparison / command / file list only. Do not run `review-blind` in a window that already had those. Do not paste gatherer products into the `review-verify` prompt as a fourth input. Parent-held products in the verify Follow are not that leak.

Fan out: run **each** seat in a fresh context that contains only what this router passed (plus that seat's own `SKILL.md` as procedure). The security seat’s window is that comparison plus its own playbook — child Read of `playbook.md` is GREEN. All three seats emit candidates only. Do not skip a seat.

The parent may hold gatherer **products** — it seeds intent from the PR body and design excerpt. That seed is GREEN. Onboard has no seat to seed; the parent may still hold that product. Seeding a gatherer follow transcript is RED. Product or transcript in the blind prompt or window is RED. After gatherers land, seed from those products; do not seed parent-held raw dumps in their place.

A wrapper may already have primed the parent with catch-me-up / orient-* on the file list `review-scope` returned, then invoked this router. That wrapper dump in the **verify** Follow stays GREEN. This skill does not run catch-me-up / orient-*. Orient is not a seat and not a required step here. Skipping a gatherer because that dump exists is RED. Reading sibling `SKILL.md` files to know what to dispatch is fine. Do not Read the security playbook to dispatch.

If this harness cannot open a fresh context for a seat, **stop** and say so. Do not follow that seat in this turn. Withhold is not isolation.

If two signals conflict, isolation wins over following a seat in this turn.

Then fan in: Read [../review-verify/SKILL.md](../review-verify/SKILL.md) and follow it **in the parent** with the three candidate lists. Isolation is not a duty of `review-verify`. Parent-held gatherer products in that window are GREEN (including onboard). Do not paste those products into the verify prompt as a fourth input — that extra-briefing is RED. Wrapper-then-router parent-held *wrapper* orient in that window stays GREEN. Candidate lists only. Do not keep a second review procedure here. Do not skip the verifier.

## Isolation

| Excuse | Reality |
|---|---|
| “Follow the seat in this turn; just don’t paste the body” | Isolation wins. Fresh context or stop. |
| “This harness cannot open a fresh context — withhold is enough” | Stop and say so. Withhold is not isolation. |
| “The parent already has the body; the seat will ignore it” | A window that already had it is a leak. |
| “The parent already has orient / onboard; the seat will ignore it” | Parent-held wrapper dumps are GREEN in verify. Copying them into the blind prompt or running the seat in that window is a leak. |
| “Skip the gatherer; the parent already has orient” | Skipping because the parent has orient is RED. Fan the gatherer. |
| “Follow the gatherer in the parent; I already have the files” | Fresh child for each gatherer is GREEN. Product back, then seed. |
| “Open a fresh child for review-scope so isolation is clean” | Follow `review-scope` in the parent. Fresh child for scope is still RED. |
| “Seed the gatherer follow transcript so the seat sees the research” | Seed the product only. Score the product in the parent seed, not the follow transcript. |
| “Copy the gatherer product into review-blind so it has context” | Product or transcript in blind is RED. |
| “Paste gatherer products into review-verify as a fourth input” | Extra-briefing is the paste. Candidate lists only. Parent-held products in that Follow window are GREEN. |
| “Withhold gatherer products from review-verify; the window already has them” | Verify Follows in the parent. Parent-held there (including onboard) is GREEN. A fourth-input paste is the leak. |
| “Withhold orient from review-verify; it Follows in the parent” | Verify runs in the parent. Wrapper-then-router parent-held wrapper orient there stays GREEN. |
| “Paste the review-scope follow transcript so the seat sees how we resolved” | Seats get the announced comparison / command / file list, not the follow transcript. Stuffing that dump into blind is RED. |
| “GREEN tables / fixture protocol / scoring notes are not the PR body” | They still brief the seat. Withhold. |
| “Orient the file list first, then fan out” | Wrapper priming may do that. This router does not. Gatherers write the products. |
| “Read the security playbook so I can brief the seats” | A security seat Reads its own file. `review-changes` and `review-blind` do not. |
| “Copy the playbook into the blind prompt so it knows the threats” | Playbook in the blind dump is a leak. |
| “The security child will ignore leftovers / apply gates” | Seats emit leftovers. Swallow is never-seen. Gates are `review-verify`. |

## Red flags

- Writing findings in the router
- Applying gates in the router or telling a seat to read `gates.md`
- Skipping a seat or handing the diff straight to `review-verify`
- Skipping a gatherer because the parent already holds orient / onboard
- Following a gatherer in this turn, or seeding its follow transcript
- Duplicating `review-scope` tables, or passing seats a different comparison than it returned
- Opening a fresh child for `review-scope` instead of Following in the parent
- Parent leaked the PR body (or commit message / onboard / orient dumps / gatherer products / gatherer follow transcripts / implementing turn / GREEN tables / fixture protocol / scoring notes / the security playbook / OWASP lists / CWE lists / the `review-scope` follow transcript) into the blind prompt or into the blind child's window
- Child fetched the PR body / commit message / onboard / orient dumps / gatherer products anyway
- Blind child fetched the security playbook / OWASP lists / CWE lists
- Gatherer products pasted into the `review-verify` prompt as a fourth input (parent-held in that Follow window is not this leak)
- A seat swallowed leftovers or applied gates
- Running catch-me-up / orient-* from this skill, or treating orient as a fourth seat
- Following a seat in this turn because the harness could not open a fresh context
- Reviewing the whole repo because the target was vague
- Inferring a focus menu
- Implementing because the bug is obvious
- Treating a plan/spec as a code review
- Grilling a design as if this family reviewed prose
