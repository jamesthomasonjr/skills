---
name: review-changes
description: >-
  Router for defect-first code review. Use when the user asks to review
  a change, PR, commit, working tree, or what they just changed. Follows
  review-scope, gathers products, announces a caller-named pack (full
  default, core opt-in), fans announced seats through review-spawn-seats
  on a nested-Task or CloudAgent host; does not review. Read-only.
---

# Review changes

Follow `review-scope`, announce the comparison it returned, choose the
caller-named pack once (`full` default, `core` opt-in), build the
**comparison-seed**, hand gatherers and that pack’s announced parallel
seats to `review-spawn-seats`, build the **intent-seed** once the
reconstructed-intent blob is back, hand intent to the same helper, then
Follow `review-verify` in the parent on every announced seat list.
This skill does **not** review and does **not** write findings.

One family on every host. When this host has no nested Task tool and
launches CloudAgents instead, that is **cloud-seat mode** of this same
router — same packs, same seeds, same gates, same HARNESS-STOP. It is
not a sibling skill. There is no `review-changes-cloud` and no
lighter “Medium” pack to advertise.

## Hard rules

- Read-only. No edits, no commits, no pushes, no GitHub review comments.
- Do not apply `gates.md`. Do not write findings. That is `review-verify`.
- Do not Read `gates.md` in this skill. Seats do not read it.
- Do not duplicate `review-scope` tables here. Follow that sibling; pass what it returned.
- Do not open a fresh child for `review-scope`. Scope stays Follow-in-parent.
- After announce, run each gatherer in a fresh context unless the parent already holds that gatherer’s **product** (PR body / design excerpt). Onboard always fans — a held onboard summary is not that skip. Primer dump ≠ product. Do not follow a gatherer in this turn. If a gatherer cannot start (no nested Task tool and no CloudAgent launch, or its launch was rejected), write a brief HARNESS-STOP naming the slot and the primitive and stop. No Findings / Assessment / Follow-ups. Do not write `No findings.` Do not review inline as one agent.
- Run each announced seat in a fresh context that contains only what this router passed. Do not follow a seat in this turn. If an announced seat cannot start (no nested Task tool and no CloudAgent launch, or its launch was rejected), write a brief HARNESS-STOP naming the slot and the primitive and stop. No Findings / Assessment / Follow-ups. Do not write `No findings.` Do not review inline as one agent. Withhold is not isolation.
- Start gatherers and announced seats through [../review-spawn-seats/SKILL.md](../review-spawn-seats/SKILL.md). That helper picks nested Task vs CloudAgent from **harness facts** (the tool list, a launch primitive) — never from “Grok,” “quick,” “light,” “Medium,” “small,” or “cloud.” It returns the **whole** set of slots handed in that call or one named HARNESS-STOP (announced set = this call’s slots; gatherers, parallel seats, and intent are separate calls). A subset back from one call is that HARNESS-STOP: stop, do not merge the seats that did return, do not re-announce `core`.
- Build seeds here, not in the helper. **comparison-seed** = comparison, comparison command, file list (plus mixed-turn fix request and optional focus phrase) — every gatherer and every parallel seat. **intent-seed** = comparison-seed + PR-body and design-excerpt products + procedure context + the reconstruct blob — intent only, built after blind returns. There is no third “shared brief.”
- After gatherers, fan that pack’s **announced** parallel seats. Intent waits on the reconstructed-intent blob, then runs. Do not fan intent with them — on a Task nest or a CloudAgent fan. Do not pass the blind candidate list (`title — path:line` entries) into intent. Do not pass the blob to security or the other announced specialists.
- Choose the pack **once** from the caller (named `full` / `core`, or default `full`). Do not infer `core` from “quick,” “light,” or “small.” Do not infer `core` from a missing Task tool or a failed launch. Do not invent a pack from the diff. Do not add or drop a seat mid-run.
- Wrapper priming is not a required step. It is not a seat. Do not skip a gatherer because the parent already holds a primer dump. Skip a gatherer only when the parent already holds that gatherer’s product (PR body / design excerpt). Onboard has no seat to seed — always fan that gatherer. A held onboard summary is not skip GREEN.
- Mixed turn (“review this, then fix it”): pass the fix request through. The verifier finishes the review, then hands back. Do not implement in this turn.
- Out of family (“review this plan / spec / design”): stop. Point at `shape-*` (or a later plan-review skill). Do not read the gatherers, seats, or `review-verify`. Do not grill the prose as a design reviewer. A `SKILL.md` or required playbook in the file list is not this signal — hand off.
- Empty or unresolvable target: ask once or stop with exactly `Nothing to review.`
- After a comparison was announced, if the harness cannot fan a gatherer or announced seat — nested Task missing with no CloudAgent launch, a CloudAgent launch rejected or never returning for an announced slot, or the helper handing back a subset: brief HARNESS-STOP naming the slot and the primitive, then stop. No Findings / Assessment / Follow-ups. Do not write `No findings.` Do not review inline as one agent. This is not `Nothing to review.` and not a `shape-*` stop.
- After the verifier envelope, the parent may hand that envelope onward (fix-now versus residual report). The parent does not re-judge the generation seats, reopen `gates.md`, or add a finding the verifier did not write.
- Focus is an optional user-named phrase, not a menu. Do not infer modes.

## Packs

Choose the pack **once** from the caller. Named `full` or `core`, or
default `full`. Do not infer `core` from “quick,” “light,” or “small.”
Do not invent a pack from the diff. Do not add or drop a seat mid-run.

Light and heavy are **announce**, not omit.

- `full` (default): announce `review-blind`, `review-security`,
  `review-performance`, `review-logic`, `review-regression`, and
  `review-checklist` in parallel. Intent waits on the reconstructed-intent
  blob, then runs. Verify waits on every announced list (those six +
  intent).
- `core` (caller opt-in): announce `review-blind`, `review-intent`, and
  `review-security` only. Fan blind and security in parallel. Intent
  waits on the reconstruct blob, then runs. Verify waits on those three
  lists. Performance / logic / regression / checklist are **unannounced**
  — not never-seen.

A missing **announced** list is still #31 never-seen RED. An unannounced
specialist is not a missing list. Inventing a seat or silently omitting
an announced one is RED.

The pack does not depend on the host. A host with no nested Task tool
runs the same announced set on CloudAgents. A host with neither
primitive stops. Neither case thins the pack.

## Seeds

This router builds two seeds. `review-spawn-seats` receives them as
bytes and does not build or extend them.

- **comparison-seed** — announced comparison, comparison command, file list; mixed-turn fix request if any; optional focus phrase. Identical bytes to every gatherer and every parallel announced seat. Checklist additionally gets the user-named file when the caller named one. No playbook, no product, no blob, no primer dump.
- **intent-seed** — comparison-seed plus the `review-gather-pr` product (PR body) and `review-gather-design` product (design excerpt) when nonempty, commit message / procedure context when present, and the reconstruct blob `review-blind` emitted. Built after blind returns. Passed to `review-intent` only. Not the blind candidate list. Not the onboard product. Not a playbook.

Blind stays comparison-only: it receives the comparison-seed and nothing else, on every host.

## Invocation modes

The same router runs on two kinds of host. `review-spawn-seats` picks between them from harness facts; this router does not.

- **Task nest** — this host has a nested Task / subagent tool. Each gatherer and seat is a fresh context (Task child).
- **cloud-seat** — this host has no nested Task tool but launches CloudAgents. Each gatherer and seat is one CloudAgent whose window starts with its seed and its own `SKILL.md`. Same packs. Same seeds. Intent still waits on the blob. `review-verify` still Follows here in the parent. Same HARNESS-STOP when a launch fails.

Neither mode is a separate skill. Do not announce a mode from the request wording; the helper reads the host.

## 1. Resolve

**REQUIRED:** Follow [../review-scope/SKILL.md](../review-scope/SKILL.md) **in the parent**. Resolve that path from **this file’s directory**, not from cwd. Same sibling-path rule as the seats: `../review-scope/SKILL.md` means “next to this skill.” After `~/.cursor/skills/<name>` symlink or a plugin copy, `skills/engineering/review-*/SKILL.md` does not exist.

If a cwd-relative Read of a sibling misses (user workspace is a different repo), resolve the sibling from the path you used to open **this** `SKILL.md`, or invoke the skill by name.

`review-scope` returns the comparison, comparison command, and file list — or **empty** / **unresolvable**. Do not re-run its tables. Do not invent a different comparison. Do not open a fresh child for `review-scope`.

## 2. Announce and gather

**Out of family:** one or two sentences, name `shape-*` (or a later plan-review skill), **stop**. Do not read a gatherer, a seat, or `review-verify`. Do not write a design critique. A `SKILL.md` or required playbook in the file list is in family — hand off.

**Empty / unresolvable:** if they can still name a target, ask once and stop. Otherwise write exactly `Nothing to review.` and stop.

Otherwise one line: which comparison `review-scope` returned and why (short). Announce the pack (`full` default / caller-named `core`) and that pack’s seats.

Read **sibling** skill files resolved from **this file’s directory**, not from cwd.

Fan gatherers in **fresh contexts (Task child or CloudAgent)** — the opposite of `review-scope`. Hand the gatherer slots and the comparison-seed to `review-spawn-seats`; each context contains only that seed (plus that gatherer’s own `SKILL.md`). Take the **product** back. Do not seed a gatherer follow transcript. Skip a gatherer only when the parent already holds that gatherer’s **product** (PR body / design excerpt). A held onboard summary is not that skip — onboard always fans. A primer dump is not that product. Skip-because-primer is RED. Do not write `Nothing to review.` from a gatherer’s empty product — empty product means seed nothing for that slot.

- [../review-gather-pr/SKILL.md](../review-gather-pr/SKILL.md) — product: PR body
- [../review-gather-design/SKILL.md](../review-gather-design/SKILL.md) — product: design excerpt
- [../review-gather-onboard/SKILL.md](../review-gather-onboard/SKILL.md) — product: onboard summary of that file list. Always fan. Parent-held onboard summary is not a skip.

**HARNESS-STOP:** after a comparison was announced, if a gatherer or announced seat cannot start — no nested Task tool and no CloudAgent launch on this host, a CloudAgent launch rejected or never returning for that slot, or `review-spawn-seats` handing back a subset — one or two sentences naming the slot and the primitive (cannot open a fresh context / cannot fan / cannot launch), **stop**. Do not emit Findings / Assessment / Follow-ups. Do not write `No findings.` Do not review inline as one agent. Do not merge the slots that did return. Do not re-announce `core`. Seat dumps stay absent. This is not `Nothing to review.` and not a `shape-*` stop.

If a gatherer cannot start, write that **HARNESS-STOP** and **stop**. Do not follow that gatherer in this turn.

## 3. Hand off seats and verify

Read the **announced** seats first. Do **not** Read `review-verify` until all announced seats have emitted candidates. Do **not** Read `gates.md` in this skill. Do not Read an unannounced specialist playbook. Do not fan an unannounced seat.

- [../review-intent/SKILL.md](../review-intent/SKILL.md)
- [../review-blind/SKILL.md](../review-blind/SKILL.md)
- [../review-security/SKILL.md](../review-security/SKILL.md)
- [../review-performance/SKILL.md](../review-performance/SKILL.md)
- [../review-logic/SKILL.md](../review-logic/SKILL.md)
- [../review-regression/SKILL.md](../review-regression/SKILL.md)
- [../review-checklist/SKILL.md](../review-checklist/SKILL.md)

This list is the family. Fan only the announced set. `review-spawn-seats` is the launcher, not a seat: it emits no candidates and is never announced or waited on as a list.

Do **not** restate `gates.md`. Do **not** apply it. Do **not** Read a specialist playbook.

**Pass to all announced seats:** the announced comparison, comparison command, and file list only, mixed-turn fix request if any, optional focus phrase if they named one. Do not pass a different comparison. Do not pass a gatherer follow transcript. Do not pass the `review-scope` follow transcript.

**Pass to `review-intent` only:** the `review-gather-pr` product (PR body) and the `review-gather-design` product (design excerpt) when those products are nonempty, plus commit message / procedure context when present, plus the reconstructed-intent blob `review-blind` emitted. GREEN tables / fixture protocol / scoring notes / primer dumps / the onboard product are not procedure context. The blind candidate list is not procedure context. Specialist playbooks are not procedure context. Do not dump a gatherer follow transcript into intent. Do not pass that list (`title — path:line` entries, including leftovers). A reconstruct sentence that names a helper is not that list.

**Pass to `review-checklist` only** (when that seat is announced): the user-named checklist path if the caller named one. If they did not name a file, seed no file. Do not invent a path. The seat then returns `No candidates.` Do not fan checklist when the pack left it unannounced.

Onboard has no seat to seed. Do **not** pass the onboard product to `review-intent`, `review-blind`, `review-security`, `review-performance`, `review-logic`, `review-regression`, or `review-checklist`. The parent may hold it.

A specialist seat Reads its own file. `review-changes` and `review-blind` do not. Do not copy playbook bytes into the blind prompt.

**Do not pass** the reconstructed-intent blob to `review-security` or to any other announced specialist. Announced specialists still fan with blind. Each window is comparison plus own playbook only (checklist: plus a user-named file when they named one). A window that already had the blob is a leak.

**Do not pass** the PR body, commit message, onboard dumps, primer dumps, gatherer products, gatherer follow transcripts, the reconstructed-intent blob as extra briefing, the implementing turn, GREEN tables / fixture protocol / scoring notes, specialist playbooks / OWASP lists / CWE lists, or the `review-scope` follow transcript to `review-blind`. Pass the announced comparison / command / file list only. Blind **produces** the blob; stuffing it into the blind window as extra briefing is RED. Do not run `review-blind` in a window that already had those withheld dumps. Do not paste the pack name, gatherer products, the reconstruct blob, or specialist playbooks into the `review-verify` prompt as extra input. Parent-held products, parent-held blob, and parent-held playbooks in the verify Follow are not that leak.

Fan out: after gatherers, hand the pack’s **announced** parallel seats and the comparison-seed to `review-spawn-seats`. Each seat runs in a fresh context that contains only that seed (plus that seat's own `SKILL.md` as procedure). The same comparison **bytes** reach every parallel announced seat. That comparison-seed is GREEN. Do not stuff playbooks into it (`review-changes` / `review-blind` Read of a playbook is RED). Each announced specialist seat’s window is that comparison plus its own playbook — child Read of `playbook.md` is GREEN. Checklist also gets the user-named file when they named one; otherwise seed no file. Intent is the sequential edge: wait for the reconstruct blob, build the intent-seed (comparison-seed + PR-body and design-excerpt products + that blob), then hand `review-intent` alone to the helper. Do not cache the intent-seed with the parallel seats. Do not launch intent with blind because the host can run CloudAgents concurrently. Do not wait on leftover titles. All announced seats emit candidates only. Blind also emits the reconstruct blob as a separate product. Do not skip an announced seat. Do not invent an unannounced seat.

The helper returns every dump for the slots handed in that call, or one named HARNESS-STOP. **Announced set = the slots handed in this helper call only.** This router makes three calls — gatherers, then the parallel seats, then intent — and a full return for one call’s slots is GREEN even though the other calls’ seats ran earlier or later. Take the dumps as bytes. If a call returns fewer dumps than the slots handed in it, that is the HARNESS-STOP — write it and stop. Do not hand the subset to `review-verify`.

The parent may hold gatherer **products** — it seeds intent from the PR body and design excerpt. That seed is GREEN. The parent may hold the reconstruct blob — it seeds intent from that blob. That seed is GREEN. Onboard has no seat to seed; the parent may still hold that product. Seeding a gatherer follow transcript is RED. Product or transcript in the blind prompt or window is RED. The blind candidate list (`title — path:line` entries, including leftovers) in the intent window is RED. A reconstruct sentence that names a helper is not that leak. Reconstruct blob in a specialist window is RED. After gatherers land, seed from those products; do not seed parent-held raw dumps in their place.

A wrapper may already have primed the parent on the file list `review-scope` returned, then invoked this router. That parent-held primer dump in the **verify** Follow stays GREEN. Wrapper priming is not a required step. It is not a seat. Skipping a gatherer because that dump exists is RED. Skipping a gatherer because the parent already holds that gatherer’s **product** (PR body / design excerpt) is GREEN. Skipping onboard because the parent holds an onboard summary is RED. Reading sibling `SKILL.md` files to know what to dispatch is fine. Do not Read a specialist playbook to dispatch.

If an announced seat cannot start on this host (no Task nest, no CloudAgent launch, or its launch failed), write that **HARNESS-STOP** and **stop**. Do not follow that seat in this turn. Withhold is not isolation.

If two signals conflict, isolation wins over following a seat in this turn.

Then fan in: Read [../review-verify/SKILL.md](../review-verify/SKILL.md) and follow it **in the parent** with every announced seat candidate list. This Follow is the same on a Task nest and in cloud-seat mode — verify is never a spawned slot. Isolation is not a duty of `review-verify`. Parent-held gatherer products in that window are GREEN (including onboard). Parent-held reconstruct blob in that window is GREEN (same #30 shape). Parent-held specialist playbooks in that window are GREEN. Do not paste the pack name, those products, the blob, or those playbooks into the verify prompt as extra input — that extra-briefing is RED. Parent-held primer dumps in that Follow window stay GREEN. Candidate lists only. Do not keep a second review procedure here. Do not skip the verifier.

## Isolation

| Excuse | Reality |
|---|---|
| “Follow the seat in this turn; just don’t paste the body” | Isolation wins. Fresh context or stop. |
| “This harness cannot open a fresh context — withhold is enough” | HARNESS-STOP. Brief stop naming cannot open a fresh context / cannot fan. Withhold is not isolation. No Findings / Assessment / Follow-ups. Do not write `No findings.` Do not review inline. |
| “Cannot fan — emit Findings / Assessment / Follow-ups anyway” | HARNESS-STOP. Brief stop. No envelope. |
| “Cannot fan — review inline as one agent so seats still ran” | Isolation wins. Stop. Do not review inline. |
| “Cannot fan — write `No findings.` so the review looks finished” | That is an empty pass after HARNESS-STOP. Stop only. |
| “No Task tool on this host — the family cannot run here” | Check for a CloudAgent launch primitive through `review-spawn-seats`. Present → cloud-seat mode, same pack. Absent → HARNESS-STOP. |
| “No Task tool — announce `core` so there are fewer seats to launch” | Pack is chosen once from the caller. A harness miss changes the back end or stops the run; it never thins the pack. Synonym-`core` from a harness fact is RED. |
| “Regression’s CloudAgent never came back — verify the six that did” | Thinner merge is RED. An announced list that never existed is never-seen (#31). HARNESS-STOP naming that slot. |
| “The helper returned five of seven — good enough” | Partial return is the HARNESS-STOP. Do not hand a subset to verify. |
| “Grok Bot asked, so this is the CloudAgent path” / “quick review, so nest” | The helper picks from harness facts (tool list, launch primitive). Names and tier words never pick a primitive. |
| “CloudAgents run in parallel anyway — launch intent with blind” | Intent waits on the blob on every host. Build the intent-seed after blind returns. |
| “Spawn `review-verify` as a CloudAgent too” | Verify Follows in the parent. Not a spawned slot in either mode. |
| “Cloud-seat needs its own router / a lighter Medium pack” | One family. `cloud-seat` is an invocation mode of this router. No sibling skill, no extra pack. |
| “The parent already has the body; the seat will ignore it” | A window that already had it is a leak. |
| “The parent already has primer dumps; the seat will ignore it” | Parent-held primer dumps are GREEN in verify. Copying them into the blind prompt or running the seat in that window is a leak. |
| “Skip the gatherer; the parent already has a primer dump” | Skipping because the parent has a primer dump is RED. Fan the gatherer. |
| “Skip onboard; the parent already holds an onboard summary” | Onboard has no seat to seed. Always fan. A held onboard summary is not skip GREEN (too close to a primer dump). |
| “Skip the gatherer; the parent already holds the PR body / design excerpt” | Parent-held **product** is the skip. Primer dump ≠ product. Onboard summary is not this skip. That skip is GREEN. |
| “They asked for a light / quick / small review — announce core” | Do not infer `core` from those synonyms. GREEN pack-core is only “caller named `core`.” |
| “Follow the gatherer in the parent; I already have the files” | Fresh child unless the parent already holds that product. Follow-in-parent is still RED. |
| “Open a fresh child for review-scope so isolation is clean” | Follow `review-scope` in the parent. Fresh child for scope is still RED. |
| “Seed the gatherer follow transcript so the seat sees the research” | Seed the product only. Score the product in the parent seed, not the follow transcript. |
| “Copy the gatherer product into review-blind so it has context” | Product or transcript in blind is RED. |
| “Fan intent with blind and security; the blob can catch up” | Sequential edge is intent. Wait on the reconstruct blob, then run intent. |
| “Fan specialists after intent so they see the blob” | Specialists fan with blind. Intent waits on the blob. Specialists do not. |
| “Pass leftover titles from blind so intent can copy them” | The blind candidate list (`title — path:line`) in the intent window is RED. The blob is the seed. A reconstruct sentence that names a helper is not this leak. |
| “The blob named a leftover helper — RED the intent window” | The blob may name what the diff appears to do. The list is the leak, not a reconstruct sentence. |
| “Pass the reconstruct blob to security so it knows intent” | Blob in the security window is RED. Security fans with blind. Comparison + playbook only. |
| “Pass the reconstruct blob to performance / logic / regression / checklist” | Blob in a specialist window is RED. Those seats fan with blind. Comparison + playbook only. |
| “Stuff the blob back into blind as extra briefing” | Blind produces the blob. Extra briefing in that window is RED. |
| “Fold the blob into the blind candidate list so there is one dump” | The blob is its own dump product. Do not fold it into the candidate list. |
| “Paste the pack name into review-verify so it knows the set” | Extra-briefing is the paste. Every announced list. Do not paste the pack name as a fourth / extra input. |
| “Paste gatherer products into review-verify as a fourth input” | Extra-briefing is the paste. Candidate lists only. Parent-held products in that Follow window are GREEN. |
| “Paste the reconstruct blob into review-verify as a fourth input” | Extra-briefing is the paste. All announced seat lists. Parent-held blob in that Follow window is GREEN. |
| “Paste specialist playbooks into review-verify as extra input” | Extra-briefing is the paste. Candidate lists only. Parent-held playbooks in that Follow window are GREEN. |
| “Withhold gatherer products from review-verify; the window already has them” | Verify Follows in the parent. Parent-held there (including onboard and the reconstruct blob) is GREEN. A fourth-input paste is the leak. |
| “Withhold primer dumps from review-verify; it Follows in the parent” | Verify runs in the parent. Parent-held primer dumps in that Follow stay GREEN. |
| “Paste the review-scope follow transcript so the seat sees how we resolved” | Seats get the announced comparison / command / file list, not the follow transcript. Stuffing that dump into blind is RED. |
| “GREEN tables / fixture protocol / scoring notes are not the PR body” | They still brief the seat. Withhold. |
| “Prime the parent first, then fan out” | This skill does not prime the parent. Gatherers write the products. |
| “Read the security playbook so I can brief the seats” | A security seat Reads its own file. `review-changes` and `review-blind` do not. |
| “Read a specialist playbook so I can brief the seats” | A specialist Reads its own file. `review-changes` and `review-blind` do not. |
| “Copy the playbook into the blind prompt so it knows the threats” | Playbook in the blind dump is a leak. |
| “Skip performance / logic / regression / checklist; this diff looks clean” | Pack is chosen once. Mid-run omit of an announced seat is RED (same #31 miss). Choosing `core` because the diff looks clean is inventing a pack. |
| “Skip performance; pack is `core` so they were not announced” | Unannounced is not never-seen. That skip is the announce, not an omit. |
| “Add performance; this looks hot even though pack is `core`” | Inventing a seat mid-run is RED. |
| “Wait for six lists; that is the family” | Verify waits on every **announced** list. Do not hard-code six. |
| “Stuff playbooks into the comparison-seed so every seat has them” | Identical comparison bytes across parallel seats stay GREEN. Playbooks in that seed are RED (router / blind Read). |
| “Cache the intent-seed with the parallel seats” | The intent-seed stays PR+design+blob. Do not cache it with the others. |
| “Let the helper add the PR body to the seed for cloud seats” | Seeds are router-built. The helper receives bytes and does not extend them. |
| “Skip checklist; no file was named” | If checklist is announced: fan the seat. Seed no file. The seat returns `No candidates.` Missing announced list is never-seen leftovers. |
| “Invent CHECKLIST.md; they forgot to name one” | Seed no file. Do not invent a path. |
| “The security child will ignore leftovers / apply gates” | Seats emit leftovers. Swallow is never-seen. Gates are `review-verify`. |

## Red flags

- Writing findings in the router
- Applying gates in the router or telling a seat to read `gates.md`
- Skipping an announced seat or handing the diff straight to `review-verify`
- Skipping a gatherer because the parent already holds a primer dump
- Skipping onboard because the parent already holds an onboard summary
- Following a gatherer in this turn, or seeding its follow transcript
- Duplicating `review-scope` tables, or passing seats a different comparison than it returned
- Opening a fresh child for `review-scope` instead of Following in the parent
- Parent leaked the PR body (or commit message / onboard / primer dumps / gatherer products / gatherer follow transcripts / the reconstructed-intent blob as extra briefing / implementing turn / GREEN tables / fixture protocol / scoring notes / specialist playbooks / OWASP lists / CWE lists / the `review-scope` follow transcript) into the blind prompt or into the blind child's window
- Child fetched the PR body / commit message / onboard / primer dumps / gatherer products anyway
- Blind child fetched a specialist playbook / OWASP lists / CWE lists
- The blind candidate list (`title — path:line` entries, including leftovers) passed into the intent window (a reconstruct sentence that names a helper is not this leak)
- Reconstruct blob in a specialist window, or a specialist Read of that blob
- Fanning intent in parallel with blind and the specialists instead of waiting on the blob
- Fanning specialists after intent instead of with blind
- Pack name, gatherer products, the reconstruct blob, or specialist playbooks pasted into the `review-verify` prompt as extra input (parent-held in that Follow window is not this leak)
- A seat swallowed leftovers or applied gates
- Running wrapper priming from this skill, or treating wrapper priming as a seat
- Following a seat in this turn because the harness could not open a fresh context
- Emitting Findings / Assessment / Follow-ups after HARNESS-STOP
- Writing `No findings.` after HARNESS-STOP
- Reviewing inline as one agent when the harness cannot fan
- Merging the seats that did start after an announced seat or required gatherer failed to launch (thinner merge)
- Re-announcing `core` because the host lacks a Task tool or a launch failed
- Handing a partial helper return to `review-verify`
- Picking Task vs CloudAgent from “Grok,” “quick,” “light,” “Medium,” “small,” or “cloud” instead of harness facts
- Launching intent with blind on a CloudAgent host
- Spawning `review-verify` instead of Following it in the parent
- Advertising a `review-changes-cloud` sibling or a lighter cloud pack
- Reviewing the whole repo because the target was vague
- Inferring a focus menu
- Inferring `core` from “quick,” “light,” or “small,” or inventing a pack from the diff
- Inventing a seat or omitting an announced one mid-run
- Pasting the pack name into the `review-verify` prompt as extra input
- Inventing a checklist path
- Implementing because the bug is obvious
- Treating a plan/spec as a code review
- Grilling a design as if this family reviewed prose
