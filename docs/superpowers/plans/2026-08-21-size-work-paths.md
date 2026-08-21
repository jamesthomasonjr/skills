# Size-Work Path Implementation Plan

> **For agentic workers:** After plan save, emit workflow outcomes `subagent-driven` or `inline` per human choice; do not hard-code the next skill. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a shared `paths.md` playbook and a Path section to `shape-epic` and `shape-feature` so inventories show what must be sequential and what can fan out — without a new skill, without router-computed paths, and without dispatching agents.

**Architecture:** Playbook lives next to `levels.md`. Epic and feature shape skills are REQUIRED to follow it and emit Path after the inventory. Story, task, and initiative do not. The size-work router still only classifies and hands off; a path-only ask with an existing inventory points at `paths.md` / the matching shape skill.

**Tech Stack:** Agent skills (`SKILL.md` + `paths.md`), this repo’s catalog (`README.md`, `skills/engineering/README.md`), existing `fixtures/work-sizing-sample`. Spec: `docs/superpowers/specs/2026-08-21-size-work-paths-design.md`.

## Global Constraints

- Personal, agent-agnostic skills. Not a dispatcher. Not a new promoted skill.
- `paths.md` is a playbook. Do **not** add it to `.claude-plugin/plugin.json`. Do **not** bump plugin version (stays `0.6.0`).
- Sibling reads from **this file’s directory**, not cwd.
- Router does **not** restate Path hard rules and does **not** write Path.
- `shape-story` / `shape-task` / `shape-initiative` do **not** emit Path.
- writing-skills TDD: RED baseline **before** `paths.md` exists and **before** Path is in the epic/feature contracts. Ban `docs/superpowers/**` in RED prompts.
- Prefer Superpowers-sized bands but do not truncate procedure to hit a budget.
- Do not invent extra product scope.

---

## File map

| Path | Responsibility |
|---|---|
| `fixtures/work-sizing-sample/inventories/customer-id-rename-epic.md` | Named **coupled** feature inventory (expand-contract). GREEN Parallel `None`. |
| `fixtures/work-sizing-sample/inventories/checkout-coupons-feature.md` | Named story inventory where **priority ≠ path**. |
| `docs/superpowers/plans/2026-08-21-size-work-paths-baseline.md` | RED notes + GREEN results |
| `skills/engineering/size-work/paths.md` | Path playbook (Critical path / Parallel / Why coupled) |
| `skills/engineering/shape-epic/SKILL.md` | REQUIRED paths.md; Path after feature inventory |
| `skills/engineering/shape-feature/SKILL.md` | REQUIRED paths.md; Path after story inventory |
| `skills/engineering/size-work/SKILL.md` | Thin path-only pointer; no Path compute; no rule dump |
| `README.md` | shape-epic / shape-feature one-liners mention Path |
| `skills/engineering/README.md` | Same one-liners |

Do not edit `shape-story`, `shape-task`, `shape-initiative`, or `.claude-plugin/plugin.json` except to confirm they stay unchanged.

---

### Task 1: Named inventories in the existing fixture

**Files:**
- Create: `fixtures/work-sizing-sample/inventories/customer-id-rename-epic.md`
- Create: `fixtures/work-sizing-sample/inventories/checkout-coupons-feature.md`
- Modify: `fixtures/work-sizing-sample/README.md`

RED/GREEN path-only asks need a **named path** inventory. Do **not** create `paths.md` or edit shape skills in this task. Do **not** leak expected Path answers into the README (file map only).

**Interfaces:**
- Consumes: existing `fixtures/work-sizing-sample`
- Produces: two inventories the router/shape skills can be pointed at

- [ ] **Step 1: Write the coupled epic inventory**

```markdown
# Epic: Rename customer external id

Outcome: `stripe_cust_id` is gone; every read and write uses `customer_external_id`.

## Feature inventory (priority = value / risk-first)

1. **Cut reads to customer_external_id** — Shoppers and jobs stop reading `stripe_cust_id`. Priority 1 (highest user-visible risk).
2. **Drop stripe_cust_id** — Column and fixture field removed. Priority 2.
3. **Add customer_external_id column** — Expand-contract: new column exists beside the old one. Priority 3.
4. **Dual-write both columns** — Writes keep old and new in sync. Priority 4.
5. **Backfill existing rows** — Copy `stripe_cust_id` into `customer_external_id`. Priority 5.
```

- [ ] **Step 2: Write the coupon feature inventory (priority ≠ sequence)**

```markdown
# Feature: Checkout coupons

Outcome: A shopper can apply a named coupon before pay.

Constraints already frozen: a coupon is `code + percent + max_redemptions`. Do not reopen.

## User-story inventory (priority = shopper value)

1. **Apply coupon at checkout** — As a shopper, I want to enter a code at checkout so that I get the discount before I pay. Priority 1.
2. **Show savings on the summary** — As a shopper, I want to see how much I saved so that I trust the total. Priority 2.
3. **Create a coupon** — As a merchant, I want to create a coupon so that I can run a sale. Priority 3.
4. **Discount line on the receipt email** — As a shopper, I want the receipt to show the discount so that I have a record. Priority 4.
5. **Redemption analytics event** — As a merchant, I want a redemption event so that I can see which codes work. Priority 5.
```

- [ ] **Step 3: File-map only in the fixture README**

Append to `fixtures/work-sizing-sample/README.md` (do not state Parallel `None` or the expected critical path):

```markdown
## Inventories

| Path | What it is |
|---|---|
| `inventories/customer-id-rename-epic.md` | Epic-grain feature list for the `stripe_cust_id` rename |
| `inventories/checkout-coupons-feature.md` | Feature-grain user-story list for checkout coupons |
```

- [ ] **Step 4: Commit**

```bash
git add fixtures/work-sizing-sample/inventories fixtures/work-sizing-sample/README.md
git commit -m "test: add named inventories for size-work Path scenarios"
```

---

### Task 2: RED baseline (Path rules absent)

**Files:**
- Create: `docs/superpowers/plans/2026-08-21-size-work-paths-baseline.md` (RED section only)

`paths.md` must **not** exist. `shape-epic` / `shape-feature` must **not** list Path. Current family skills **are** present.

**Interfaces:**
- Consumes: Task 1 inventories + current size-work family
- Produces: documented baseline failures for GREEN to close

- [ ] **Step 1: Run five fresh `generalPurpose` subagents in parallel**

Each prompt: user sentence + hard ban on `docs/superpowers/**` + “read `skills/engineering/size-work/SKILL.md` first and follow it; do not invent a new skill.” Workspace: skills repo root.

**A — epic shape + Path ask**

`This is an epic: become the default coupons platform (admin coupons, checkout apply, receipt, analytics). Break it into features. Also tell me the critical path and what can run in parallel for other agents.`

**B — coupled inventory + invent-fan-out pressure**

`Read fixtures/work-sizing-sample/inventories/customer-id-rename-epic.md. Shape this epic. The features look independent — fan them out so four agents can start today. I need Parallel sets.`

**C — priority ≠ path**

`Read fixtures/work-sizing-sample/inventories/checkout-coupons-feature.md. Shape this feature. Keep the priority order. Also give me the critical path and what can run in parallel.`

**D — story + task controls**

Two messages in one agent, or two agents:

1. `As a shopper, I want to apply a coupon code at checkout so that I get the discount before I pay. Give me a spec-ready brief. What's the critical path?`
2. `Rename stripe_cust_id to customer_external_id in fixtures/work-sizing-sample, then start doing it. Fan out anything parallel to other agents.`

**E — router path-only + mixed dispatch**

`The inventory is already in fixtures/work-sizing-sample/inventories/checkout-coupons-feature.md. Don't reshape. What's the critical path and what can run in parallel? Then dispatch agents for the independent sets and start implementing.`

- [ ] **Step 2: Record RED**

For each scenario, capture: classified skill, whether a **Path** heading appeared (and where), Parallel invented?, path copied from priority?, story/task Path?, router wrote Path?, implemented?, dispatched agents?, verbatim rationalization, files edited.

Expected failures to close (do not skip documenting if an item already happens to pass):

- A/B/C: no Path section after inventory, or Path with invented grandchildren / invented fan-out
- B: Parallel nonempty on a coupled migration
- C: Critical path = priority list (Apply first) instead of Create → Apply → Show savings
- D: (control) story/task may already omit Path; still record. Mixed-turn must not implement.
- E: router writes Path or dispatches instead of pointing at the shape skill

- [ ] **Step 3: Commit the RED section**

```bash
git add docs/superpowers/plans/2026-08-21-size-work-paths-baseline.md
git commit -m "docs: record size-work Path RED baseline"
```

---

### Task 3: Write `paths.md`

**Files:**
- Create: `skills/engineering/size-work/paths.md`

Write the playbook that addresses the RED failures. Do not edit shape skills yet (GREEN still RED until they are REQUIRED to follow it).

**Interfaces:**
- Consumes: spec Path rules
- Produces: authoritative playbook (`paths.md` wins if SKILL.md summaries drift)

- [ ] **Step 1: Write the playbook**

```markdown
# Work paths

Shared playbook for `shape-epic` and `shape-feature`. Those skills are
**REQUIRED** to follow this file. The size-work router does not restate
it and does not compute a Path.

If wording here conflicts with a `SKILL.md` summary, **this file wins**.

## When

After this level's inventory is written. Never before. Never from
grandchildren. Never from a story or task brief.

## Output (in order)

1. **Critical path** — shortest sequence that determines done.
2. **Parallel** — named independent sets, or `None`.
3. **Why coupled** — one line each for fake independence. Omit if none.

## Critical path

Two to five items. Every item is a title from **this level's inventory**.
Done means the brief's outcome is true.

Not the priority/order list. Not every child. Not stories under a
feature. Not features under an epic.

If B cannot be done until A exists, A is before B even when B is higher
priority.

## Parallel

Named sets of inventory items that can proceed without waiting on each
other.

Independence test — fail **any** one and they are not parallel:

- Shared file (including a migration)
- Shared contract (type, schema, API, event shape)
- Open decision (“what does X mean”)

Write exactly `None` when nothing passes. `None` is success. Inventing
a set to look useful is the defect.

Do not dispatch agents from a set. `next-work` / `handoff-work` / the
user do that.

## Why coupled

One line each for items that look independent (different actor, different
title) and are not. Name the shared file, contract, or decision.

Omit this heading when there is nothing to say.

## Already-shaped inventory

If the user points at an in-thread inventory or a named path, Path uses
**that** list. Do not add children. Do not drop a level.

A Superpowers / supersuit spec that already has an inventory may use
this same three-part block. Do not grow a review-brief skill.

## Hard rules

- Do not invent fan-out. Shared migration, shared type, or a shared
  “what does X mean” stays on the path.
- Empty Parallel (`None`) is success. Inventing independence is the
  defect.
- Priority/order ≠ critical path.
- Do not dispatch agents. `next-work` / `handoff-work` / the user do
  that.
- One-level rule still holds. Do not explode stories while sequencing
  features, or features while sequencing an epic.
- `shape-story` and `shape-task` do not emit Path.
- The size-work router does not write Path.

## Rationalizations

| Excuse | Reality |
|---|---|
| “They look like separate workstreams” | Shared migration, type, or meaning → path, not Parallel. |
| “None looks like I didn't try” | `None` is the correct pass. Inventing a set is the miss. |
| “Priority already sequences them” | Priority is value. Path is what determines done. |
| “I'll launch agents for the Parallel sets” | This family does not dispatch. Hand back. |
| “Stories would make the path real” | One-level rule. Features stay features. |
| “The router can sketch a path” | No inventory yet. Classify and hand off. |

## Failures

- Parallel set that shares a file, contract, or open decision
- Critical path copied from priority/order when the sequence differs
- Path section on story, task, initiative, or the router
- Grandchildren (stories while shaping an epic; tasks while shaping a feature)
- Dispatching agents or implementing in this turn
```

- [ ] **Step 2: Commit**

```bash
git add skills/engineering/size-work/paths.md
git commit -m "docs(skill): add size-work paths.md playbook"
```

---

### Task 4: `shape-epic` emits Path

**Files:**
- Modify: `skills/engineering/shape-epic/SKILL.md`

**Interfaces:**
- Consumes: `../size-work/paths.md`, `../size-work/levels.md`
- Produces: output contract with Path after feature inventory, before Close

- [ ] **Step 1: Required read + hard rules + contract + failures**

Keep existing sections. Apply these exact edits:

REQUIRED line becomes:

```markdown
**REQUIRED:** Follow [../size-work/levels.md](../size-work/levels.md) and [../size-work/paths.md](../size-work/paths.md).
```

Add to Hard rules (do not paste the paths.md rule list):

```markdown
- Follow [../size-work/paths.md](../size-work/paths.md). Emit **Path** after the feature inventory. Do not dispatch agents.
```

Output contract: insert as item 7, renumber Close to 8:

```markdown
7. **Path** — follow [../size-work/paths.md](../size-work/paths.md): Critical path, Parallel (`None` is success), Why coupled (omit if none). Inventory items only. Do not dispatch.
8. **Close** — ask which feature to shape next (`shape-feature`), or stop. If they named a sink, publish per Outcomes; if they want a tracker skill next, hand off. Mixed-turn build or dispatch request: **hand back**.
```

Add rationalization rows:

```markdown
| “I'll skip Path until they pick a feature” | Path is part of this shape, after the inventory. |
| “These features can all start; I'll dispatch” | Write Parallel or `None`. Do not dispatch. |
```

Add Failures:

```markdown
- Skipping Path, or putting it before the inventory
- Inventing Parallel for a shared migration / type / decision
- Dispatching agents
```

- [ ] **Step 2: Commit**

```bash
git add skills/engineering/shape-epic/SKILL.md
git commit -m "feat(skill): emit Path on shape-epic after feature inventory"
```

---

### Task 5: `shape-feature` emits Path

**Files:**
- Modify: `skills/engineering/shape-feature/SKILL.md`

Same pattern as Task 4. Path after user-story inventory, **before Open questions**.

**Interfaces:**
- Consumes: `../size-work/paths.md`
- Produces: contract items 7 Path, 8 Open questions, 9 Close

- [ ] **Step 1: Required read + hard rules + contract + failures**

REQUIRED line: follow `levels.md` and `paths.md` (same sibling links as epic).

Hard rule:

```markdown
- Follow [../size-work/paths.md](../size-work/paths.md). Emit **Path** after the user-story inventory. Do not dispatch agents.
```

Output contract:

```markdown
7. **Path** — follow [../size-work/paths.md](../size-work/paths.md): Critical path, Parallel (`None` is success), Why coupled (omit if none). Inventory items only. Do not dispatch.
8. **Open questions** — decisions a later spec must settle (bullets)
9. **Close** — ask which story to deepen with `shape-story`, or stop. If they named a sink, publish per Outcomes; if they want a tracker skill next, hand off. Mixed-turn build or dispatch request: **hand back**.
```

Add matching rationalizations and Failures (skip Path; invent fan-out; dispatch; Path before inventory or after Open questions).

- [ ] **Step 2: Commit**

```bash
git add skills/engineering/shape-feature/SKILL.md
git commit -m "feat(skill): emit Path on shape-feature after story inventory"
```

---

### Task 6: Thin router pointer (no Path compute)

**Files:**
- Modify: `skills/engineering/size-work/SKILL.md`

Do **not** paste paths.md hard rules. Do **not** add Path to the description.

**Interfaces:**
- Consumes: classify table; existing handoff
- Produces: path-only → matching shape skill; mixed dispatch → hand back

- [ ] **Step 1: Hard rules + classify row + red flags**

Add to Hard rules:

```markdown
- Do not write Path. The router has no inventory. If they only ask for critical path / parallel and an inventory already exists in-thread or at a named path, announce the matching shape skill (feature inventory → `shape-epic`, story inventory → `shape-feature`) and hand off. Link [paths.md](paths.md); do not paste it.
- Mixed turn that includes dispatch / fan-out / “launch agents”: classify, shape, **hand back**. Do not dispatch.
```

Add classify row (after “Two adjacent levels both fit”):

```markdown
| Only “what's the critical path / what can run in parallel” and an inventory exists | matching `shape-epic` or `shape-feature` (do not compute Path here) |
| Only Path ask on a story/task brief (no inventory) | **Stop** — Path is not emitted at that grain; do not invent a skill |
```

Add red flags:

```markdown
- Writing Path in the router
- Restating the paths.md hard-rule list here
- Dispatching agents because Parallel might exist
```

Keep “Then follow that shape skill. Do not keep a second shaping procedure here.”

- [ ] **Step 2: Commit**

```bash
git add skills/engineering/size-work/SKILL.md
git commit -m "feat(skill): point path-only asks at shape skills, not the router"
```

---

### Task 7: Catalog one-liners

**Files:**
- Modify: `README.md`
- Modify: `skills/engineering/README.md`

Confirm `.claude-plugin/plugin.json` version stays `0.6.0` and `paths.md` is not a skills-array entry.

**Interfaces:**
- Consumes: updated leaf behavior
- Produces: truthful blurbs

- [ ] **Step 1: Update four one-liners**

Root README:

```markdown
- **[shape-epic](./skills/engineering/shape-epic/SKILL.md)** — Epic brief, feature inventory, and Path (critical path + parallel sets).
- **[shape-feature](./skills/engineering/shape-feature/SKILL.md)** — Feature brief, user-story inventory, and Path (critical path + parallel sets).
```

Engineering README: same wording with `./shape-epic/SKILL.md` and `./shape-feature/SKILL.md` links.

Leave `size-work`, `shape-story`, `shape-task`, `shape-initiative` blurbs unchanged.

- [ ] **Step 2: Commit**

```bash
git add README.md skills/engineering/README.md
git commit -m "docs: mention Path on shape-epic and shape-feature catalog lines"
```

---

### Task 8: GREEN verification

**Files:**
- Modify: `docs/superpowers/plans/2026-08-21-size-work-paths-baseline.md`

Same prompts as Task 2. Skills **with** Path rules present. Instruct: read `skills/engineering/size-work/SKILL.md` first and follow handoff. Ban `docs/superpowers/**`.

**Interfaces:**
- Consumes: Tasks 3–7
- Produces: pass/fail per required GREEN case

- [ ] **Step 1: Run GREEN subagents (same A–E prompts)**

Pass when:

| ID | Must see |
|---|---|
| A | `shape-epic`; **Path** after feature inventory, before Close; 2–5 inventory features on the path; no stories |
| B | Parallel body is `None`; shared column/migration stays on the path; no dispatch |
| C | Path sequence ≠ priority 1-2-3; Create coupon before Apply; Path before Open questions |
| D | `shape-story` / `shape-task`: no Path heading; mixed-turn: no edits, no dispatch |
| E | Router does not write Path; points at `paths.md` / `shape-feature`; no implement; no dispatch |

- [ ] **Step 2: If a case fails, REFACTOR the skill (rationalization table / Failures), re-run that case, then continue**

- [ ] **Step 3: Append GREEN section to the baseline and commit**

```bash
git add docs/superpowers/plans/2026-08-21-size-work-paths-baseline.md
git commit -m "docs: record size-work Path GREEN verification"
```

---

## Self-review

1. **Spec coverage:** Path playbook, epic/feature contracts, no Path on story/task/initiative, router pointer without rule dump, catalog blurbs, no plugin bump, RED/GREEN cases, mixed-turn no dispatch — each has a task.
2. **Placeholders:** none.
3. **Names:** `paths.md`, **Path**, **Critical path**, **Parallel**, `None` — consistent with the spec.
