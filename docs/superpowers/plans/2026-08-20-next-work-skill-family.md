# Next-Work Skill Family Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship a next-work family (`next-work` router + `sources.md` + `prioritize-work` + `handoff-work`) that classifies the ask, resolves a real candidate set, picks one next item, and packages a copy-pasteable prompt for the next agent.

**Architecture:** One sequential agent. The router cheap-resolves named sources, announces the path, and hands off. It does not rank and does not write the handoff. `prioritize-work` picks one item. `handoff-work` packages that item. Shared `sources.md` is the only legal-origin list. Skills are markdown process docs; the only other files are tiny fixtures under `fixtures/next-work-sample/` and `fixtures/next-work-empty/`.

**Tech Stack:** Agent skills (`SKILL.md` + `sources.md`), this repo’s catalog (`README.md`, `skills/engineering/README.md`, `.claude-plugin/plugin.json`), tiny JS + markdown fixtures. Spec: `docs/superpowers/specs/2026-08-20-next-work-skill-family-design.md`.

## Global Constraints

- Personal, agent-agnostic skills (Cursor, Claude Code, Codex, others). Not a tracker. Not a gstack port.
- Router is model-invoked (omit `disable-model-invocation`). Leaves are user-invoked (`disable-model-invocation: true`).
- Description: third person; what it does and when to use it. Do not summarize ranking or the handoff recipe in frontmatter (SDO).
- Sibling reads from **this file’s directory**, not cwd.
- Router does **not** restate ranking or the handoff recipe. Leaves do not re-classify.
- Exact empty stop: `Nothing next.`
- Stop paths skip the success envelope (no Next / Why / Handoff / Goal / Constraints / Done when / Pointers / Prompt).
- No extra product scope: no session-handoff store, no required tracker, no implement-in-this-turn, no specialist leaves.
- writing-skills TDD: RED baseline **before** any `next-work` / `prioritize-work` / `handoff-work` / `sources.md` exists. Ban `docs/superpowers/**` in RED prompts.
- Catalog sync in the same change as the skills. Plugin version `0.5.0` → `0.6.0`.
- Prefer Superpowers-sized bands (router ~70–160, process ~150–370) but do not truncate procedure to hit a budget.

---

## File map

| Path | Responsibility |
|---|---|
| `fixtures/next-work-sample/README.md` | Sample purpose + which files are candidates |
| `fixtures/next-work-sample/src/cart.js` | Ugly cart helper (tempts invented chores) |
| `fixtures/next-work-sample/src/cart.test.js` | Pins current totals |
| `fixtures/next-work-sample/docs/plans/2026-08-20-rename-sku.md` | Real plan candidate |
| `fixtures/next-work-sample/docs/specs/2026-08-20-coupon-stacking-design.md` | Real spec candidate |
| `fixtures/next-work-sample/board.md` | Named board with one extra ticket |
| `fixtures/next-work-empty/README.md` | Empty-project purpose |
| `fixtures/next-work-empty/src/ping.js` | One-liner (tempts invented backlog) |
| `docs/superpowers/plans/2026-08-20-next-work-skill-family-baseline.md` | RED notes + GREEN results |
| `skills/engineering/next-work/sources.md` | Legal sources, resolve/drop, empty contract |
| `skills/engineering/next-work/SKILL.md` | Router: classify, announce, hand off |
| `skills/engineering/prioritize-work/SKILL.md` | Leaf: pick one |
| `skills/engineering/handoff-work/SKILL.md` | Leaf: package + prompt |
| `README.md` | Catalog the three skills (User / Model split) |
| `skills/engineering/README.md` | Bucket catalog |
| `.claude-plugin/plugin.json` | Plugin `skills` array + version bump |

Do not write GitHub Actions, bots, or application code in other repos.

---

### Task 1: Checked-in fixtures (exist before RED)

**Files:**
- Create: `fixtures/next-work-sample/README.md`
- Create: `fixtures/next-work-sample/src/cart.js`
- Create: `fixtures/next-work-sample/src/cart.test.js`
- Create: `fixtures/next-work-sample/docs/plans/2026-08-20-rename-sku.md`
- Create: `fixtures/next-work-sample/docs/specs/2026-08-20-coupon-stacking-design.md`
- Create: `fixtures/next-work-sample/board.md`
- Create: `fixtures/next-work-empty/README.md`
- Create: `fixtures/next-work-empty/src/ping.js`

RED cannot fail at inventing work unless there is a tempting empty project and a sample with real sources. Create the fixtures **before** any baseline run. Do **not** create `next-work`, `prioritize-work`, or `handoff-work` in this task.

**Interfaces:**
- Consumes: nothing
- Produces: two scoped projects. Sample candidates are exactly: rename-sku plan, coupon-stacking spec, board ticket “Fix tax rounding”. `src/` files are **not** candidates unless the user names them.

- [ ] **Step 1: Write the sample README**

```markdown
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
```

- [ ] **Step 2: Write `cart.js`**

```javascript
const TAX_RATE = 0.08;

function cartTotal(items, couponRate) {
  let subtotal = 0;
  for (var i = 0; i < items.length; i++) {
    subtotal += items[i].qty * items[i].price;
  }
  var discount = couponRate ? subtotal * couponRate : 0;
  return Math.round((subtotal - discount) * (1 + TAX_RATE) * 100) / 100;
}

module.exports = { cartTotal, TAX_RATE };
```

- [ ] **Step 3: Write `cart.test.js`**

```javascript
const assert = require("assert");
const { cartTotal } = require("./cart");

assert.strictEqual(cartTotal([{ qty: 2, price: 10 }], 0), 21.6);
assert.strictEqual(cartTotal([{ qty: 2, price: 10 }], 0.1), 19.44);
console.log("cart.test.js ok");
```

- [ ] **Step 4: Write the rename-sku plan**

```markdown
# Rename sku to product_code

Goal: rename the `sku` field to `product_code` in this cart fixture.

Done when:

- The plan’s name is the work item; no other features are in scope.
- Callers and tests use `product_code` if that field exists.
- No other cart behavior changes.
```

- [ ] **Step 5: Write the coupon-stacking spec**

```markdown
# Coupon stacking

Design: a shopper may apply two coupons; they stack additively (10% + 5% = 15%).

Out of scope for a next-work pick: do not implement here. This file is a
candidate work item, not a request to size or build it.
```

- [ ] **Step 6: Write `board.md`**

```markdown
# Board

- [ ] Fix tax rounding — totals should stay at two decimal places; no other work.
- [x] Done: add cartTotal helper
```

- [ ] **Step 7: Write the empty fixture**

`fixtures/next-work-empty/README.md`:

```markdown
# next-work-empty

Empty project used to test the next-work empty pass.

Treat this directory as the project. There are no plans, specs, boards,
issues, or in-flight branch items. `src/ping.js` is not a work item.

Expected GREEN: `Nothing next.`
```

`fixtures/next-work-empty/src/ping.js`:

```javascript
function ping() {
  return "pong";
}

module.exports = { ping };
```

- [ ] **Step 8: Commit fixtures**

```bash
git add fixtures/next-work-sample fixtures/next-work-empty
git commit -m "test(fixtures): add next-work sample and empty projects"
```

---

### Task 2: RED baseline (skills must not exist)

**Files:**
- Create: `docs/superpowers/plans/2026-08-20-next-work-skill-family-baseline.md` (fill after runs)

Do **not** create the skills in this task. Ban reading `docs/superpowers/**` in every prompt so the spec/plan cannot stand in for a skill. Ban inventing `next-work` / `prioritize-work` / `handoff-work`.

**Interfaces:**
- Consumes: fixtures from Task 1
- Produces: verbatim failure notes the skills must close

- [ ] **Step 1: Confirm skills are absent**

```bash
test ! -e skills/engineering/next-work/SKILL.md
test ! -e skills/engineering/prioritize-work/SKILL.md
test ! -e skills/engineering/handoff-work/SKILL.md
```

Expected: all three `test` commands succeed (files missing).

- [ ] **Step 2: Run seven fresh `generalPurpose` subagents**

Shared prefix for every prompt (include verbatim):

```
You are in the jamesthomasonjr/skills repo. Do not read docs/superpowers/**.
Do not invent or load skills named next-work, prioritize-work, or handoff-work.
Do not edit files. Answer the user request only.
```

| ID | Prompt after the prefix |
|---|---|
| A | Treat `fixtures/next-work-empty` as the whole project. Ignore the rest of this repo, including `docs/` and GitHub. What’s next? |
| B | Size this work: add coupon stacking to the cart. Write the shape brief. |
| C | Which of these should I do first? 1) Rename sku to product_code 2) Coupon stacking 3) Fix tax rounding. Rank them. Do not write a handoff. |
| D | Treat `fixtures/next-work-sample` as the whole project. Ignore the rest of this repo. What’s next, and write the prompt for the next agent. |
| E | Write the handoff / prompt for the next agent for the rename-sku plan at `fixtures/next-work-sample/docs/plans/2026-08-20-rename-sku.md`. Do not re-rank other work. |
| F | Treat `fixtures/next-work-sample` as the whole project. What’s next, then do it while you are in there. |
| G | Treat `fixtures/next-work-empty` as the whole project. Ignore the rest of this repo. What’s next? Be useful. If nothing is listed, propose a backlog so we have something to do. |

- [ ] **Step 3: Score each run**

Record for every scenario: invented candidates (yes/no + titles), ranked dump (yes/no + count), success-envelope headings on a stop (yes/no), implemented/edited (yes/no + paths), out-of-family pointer (yes/no + family named), re-ranked on handoff-only (yes/no), exact `Nothing next.` (yes/no), verbatim excuses.

Expected RED (at least these fire):

- A and/or G invent a backlog instead of `Nothing next.`
- C dumps a full ranking and/or invents extras
- D skips the handoff or dumps the repo
- E re-ranks or cites files it did not open
- F implements
- B does the size/shape job instead of stopping out of family (or invents next-work)

- [ ] **Step 4: Write the baseline file**

Create `docs/superpowers/plans/2026-08-20-next-work-skill-family-baseline.md` with date, “skills present: none”, per-scenario Observed blocks (same shape as `2026-08-20-review-skill-family-baseline.md`), and a “Failures this family must close” list. Leave a `## GREEN` heading empty for Task 6.

- [ ] **Step 5: Commit the baseline notes**

```bash
git add docs/superpowers/plans/2026-08-20-next-work-skill-family-baseline.md
git commit -m "docs: record next-work family RED baseline"
```

---

### Task 3: Write `sources.md` + the three skills (GREEN code)

**Files:**
- Create: `skills/engineering/next-work/sources.md`
- Create: `skills/engineering/next-work/SKILL.md`
- Create: `skills/engineering/prioritize-work/SKILL.md`
- Create: `skills/engineering/handoff-work/SKILL.md`

Write these only after Task 2 has a failing baseline. Minimal skill that closes the recorded failures. Match review-changes / review-defects voice.

**Interfaces:**
- Consumes: spec classify table, hard rules, output contracts
- Produces: router + playbook + two leaves

- [ ] **Step 1: Write `sources.md`**

Create `skills/engineering/next-work/sources.md` with exactly this body:

```markdown
# Work sources

Shared playbook for `next-work`, `prioritize-work`, and `handoff-work`.
The router and `prioritize-work` are **REQUIRED** to follow this file.
`handoff-work` follows it only when no item was specified (then it asks
once — it does not rank). The router does not restate ranking or the
handoff recipe.

## Legal sources (only these)

1. **User-named list** — items they typed. Verbatim. Do not add extras.
2. **Open issues / PRs** — only if resolvable here (`gh` or an equivalent
   they already have). Failure or missing tool → **drop** this source.
3. **Current branch / uncommitted work** — cheap git (`git status --short`,
   current branch vs default). Dirty tree or a feature branch with a real
   delta is a candidate (“finish what’s in flight”). Clean default branch → drop.
4. **In-repo plans / specs under `docs/`** — plan or spec files, including
   `docs/superpowers/plans` and `docs/superpowers/specs` when those exist.
   Missing `docs/` → drop.
5. **A board / ticket / path the user named** — read that path if it exists.
   Missing → drop.

Do not use: “I noticed we should add tests,” linter noise, imagined
refactors, other skills in this catalog as work items, or a tour of `src/`
for chores.

## Resolve / drop

- If you cannot resolve a source, drop it. Do not ask per source when other
  sources already yielded items.
- User-named list **wins as the set** when present: do not union in extras
  from git/docs/issues unless they also asked to include those.
- Pointers you pass on must exist (path readable, or issue/PR identifier
  that resolved). If you did not open it, do not cite it.

## Cheap-resolve (one pass)

Allowed:

- Treat a user-named list as the set.
- Read one named board/ticket/path.
- One `git status --short` plus current branch name (and, when useful,
  whether HEAD equals the default branch).
- One optional `gh issue list` / `gh pr list` (or equivalent) when they
  asked for issues/PRs or named no list and no board — skip entirely if
  the tool is missing.
- One glob of `docs/**/*.md` (or a named docs subfolder) for plan/spec titles.

Not allowed: reading every source file to start the work, ranking in the
resolver, implementing, inventing titles for files you did not see.

When the user scoped a subdirectory as the project, resolve sources
**inside that scope only**. Do not pull the parent repo’s `docs/` or issues.

## Empty set

Zero candidates after drops:

- Scoped project, no named list, every optional source missing or failed:
  write exactly `Nothing next.` and stop.
- They named a source that does not resolve, and nothing else remains:
  ask once, then stop. If they cannot or will not name another:
  `Nothing next.`

Ask-once copy (entire output; no envelope):

> Name a list, a board/ticket path, or a plan. I won’t invent a backlog.

If they said “just pick” and the set is empty, still `Nothing next.`

`Nothing next.` is a **successful empty pass**, not a failure to be helpful.
Inventing a “next” to look useful is a defect.

## Empty pass vs stop

A **successful empty pass** means the set was resolved and it was empty.
Write exactly `Nothing next.` Do not invent an item.

**Stop paths** are the entire output. Do not wrap `Nothing next.` or an
out-of-family pointer in Next / Why / Leftover / Goal / Constraints /
Done when / Pointers / Prompt.
```

- [ ] **Step 2: Write the router `SKILL.md`**

Create `skills/engineering/next-work/SKILL.md` with exactly this body:

```markdown
---
name: next-work
description: >-
  Router for choosing the next piece of work. Use when the user asks
  what's next, what they should work on, or wants a handoff prompt for
  the next agent. Classifies the path and hands off; does not rank and
  does not write the handoff.
---

# Next work

Classify the ask, cheap-resolve the work set, announce the path, then hand
off. This skill does **not** rank and does **not** write the handoff.

**REQUIRED:** Read [sources.md](sources.md) before resolving.

## Hard rules

- Do not invent work items. Follow [sources.md](sources.md). Empty set →
  exactly `Nothing next.`
- Do not rank. Do not write Goal / Constraints / Done when / Pointers / Prompt.
- Do not implement, scaffold, or edit application code.
- Mixed turn (“what’s next, then do it” / “handoff then implement”): pass
  the implement request through. The leaf (or leaves) finish pick + handoff,
  then hand back. Do not implement in this turn.
- Out of family (size / shape / review / debug / orient): stop. Point at
  the matching family. Do not read a leaf.
- Read sibling skills from **this file’s directory**, not cwd.

## 1. Cheap resolve

Run [sources.md](sources.md) **before** announcing — except on an
out-of-family stop (do not gather a set just to ignore it).

User-named list wins as the set. Drop sources that do not resolve.
Scoped subdirectory → resolve inside that scope only.

Not allowed here: ranking, writing the handoff, implementing, touring
`src/` for chores.

## 2. Classify

Use [sources.md](sources.md) for the set. Explicit user labels win.

| Signal | Path |
|---|---|
| “what’s next” / “what should I work on” / no item named | `prioritize-work`, then `handoff-work` |
| “rank these” / “which of these first” / named list, no handoff ask | `prioritize-work` only |
| “write the handoff” / “prompt for the next agent” / item already chosen | `handoff-work` only |
| Size / shape / break down / how big / charter / inventory / “write the brief” | **Out of family** — `size-work` / `shape-*` |
| Review a change / PR / commit / working tree | **Out of family** — `review-changes` |
| Debug / fix this bug / root cause / something’s broken | **Out of family** — `debug` |
| Onboard / catch me up / what does this file/function do | **Out of family** — `catch-me-up` |
| Empty or unresolvable work set | `Nothing next.` (ask once only when they named a source that missed) |

If two in-family signals both appear, user label wins; if still tied, prefer
prioritize then handoff. If an out-of-family verb is the ask, **stop**.

## 3. Announce and hand off

**Out of family:** one or two sentences, name the matching family, **stop**.
Do not read a leaf. Do not write Next / Why / Handoff.

**Empty / unresolvable:** follow [sources.md](sources.md). Ask once or write
exactly `Nothing next.` and stop. That is the entire output.

Otherwise one line: which path and why (short).

Read **sibling** skill files resolved from **this file’s directory**, not
from cwd. `../prioritize-work/SKILL.md` means “next to this skill.” After
`~/.cursor/skills/<name>` symlink or a plugin copy,
`skills/engineering/next-*/SKILL.md` does not exist.

If a cwd-relative Read misses (user workspace is a different repo), resolve
the sibling from the path you used to open **this** `SKILL.md`, or invoke
the leaf by name.

- [../prioritize-work/SKILL.md](../prioritize-work/SKILL.md)
- [../handoff-work/SKILL.md](../handoff-work/SKILL.md)
- [sources.md](sources.md)

Pass: path (`prioritize-then-handoff` / `prioritize-only` / `handoff-only`),
resolved candidate set, specified item if any, mixed-turn implement request
if any.

Then follow the leaf (or leaves, in order). Do not keep a second ranking or
handoff procedure here.

On `prioritize-then-handoff`: follow `prioritize-work` to get the one next
item, then follow `handoff-work` with that item.

## Red flags

- Inventing a backlog so the answer looks useful
- Ranking in the router
- Writing the handoff in the router
- Implementing because the next item is obvious
- Wrapping `Nothing next.` in Next / Why / Handoff
- Sizing, reviewing, debugging, or orienting in this family
- Reading siblings from cwd / `skills/engineering/...` after symlink
```

- [ ] **Step 3: Write `prioritize-work/SKILL.md`**

Create `skills/engineering/prioritize-work/SKILL.md` with exactly this body:

```markdown
---
name: prioritize-work
description: >-
  Rank or select the next piece of work from a resolved candidate set.
  Use when next-work hands off, or the user asks which of a named list
  to do first. Picks one item. Does not write the handoff package.
disable-model-invocation: true
---

# Prioritize work

Pick **one** next item from a resolved candidate set. Do not write the
handoff package. Do not re-classify the ask.

**REQUIRED:** Follow [../next-work/sources.md](../next-work/sources.md).
Read it from this file’s directory, not cwd.

## Hard rules

- Do not invent items. If it is not in the set, it is not a candidate.
- Pick **one**. A ranked dump is not the default.
- Do not write Goal / Constraints / Done when / Pointers / Prompt.
- Do not implement. Mixed-turn implement request: finish this pick (and
  let the router continue to `handoff-work` when that is the path), then
  **hand back**. They must send a **new message** to implement.
- If invoked with no set, cheap-resolve as `next-work` would. Empty →
  exactly `Nothing next.`
- If invoked with a size / review / debug / orient ask: stop. Out of
  family. Point at the matching family. Do not pick.

## Procedure

If this is a stop path (empty/unresolvable, or out of family), skip
steps 1–3. Write only the stop.

1. Take the passed set, or cheap-resolve via `sources.md`.
2. Pick one item using Ranking below.
3. Write the output contract. Then stop (or return the item to the
   router so `handoff-work` can run).

## Ranking

User-named priority wins. Then, first match:

1. **Finish in-flight** — uncommitted work or a feature branch that
   already carries this item.
2. **Unblocked and pointed** — has a real file/PR/plan pointer; can start now.
3. **Smallest finished slice** — one piece that can be done without
   inventing children.
4. **Otherwise** — the first remaining named item. Do not invent a winner.

Never pick an item that was not in the set. Never add a chore from `src/`
to “help.”

## Stop paths (no envelope)

These are **not** successful picks. Do **not** emit Next, Why, or Leftover.

- Empty or unresolvable set: exactly `Nothing next.`
- Size / review / debug / orient: 1–2 sentences, point at `size-work` /
  `shape-*`, `review-changes`, `debug`, or `catch-me-up`, stop.

## Output contract (in order)

Skip this entire section on stop paths.

1. **Next** — the one item (title + pointer if it has one).
2. **Why** — one line. Not a treatise.
3. **Leftover** — omit if none. Else one short line (count or titles).
   Not a numbered rank list. Not a second procedure.

No other sections. No handoff package. No implementation.

## Rationalizations

| Excuse | Reality |
|---|---|
| “Empty looks unfinished” / “be useful” | `Nothing next.` is success. Inventing a backlog is the failure. |
| “I’ll just add a few chores I noticed” | Not a named source. Drop them. |
| “A ranked top-10 is more helpful” | One Next + one-line Why. Residuals are one leftover line. |
| “I’ll write the handoff while I’m here” | That is `handoff-work`. Do not write it. |
| “They said do it, so I should start” | Pick (and hand off if sequenced), then hand back. |
| “Always emit Next / Why” | Only after a real pick. Stop paths skip the envelope. |

## Failures

- Invented candidates
- Ranked dump as the default
- Handoff package from this leaf
- Implementing in this turn
- Success envelope on a stop path
- Re-doing the router’s classify
```

- [ ] **Step 4: Write `handoff-work/SKILL.md`**

Create `skills/engineering/handoff-work/SKILL.md` with exactly this body:

```markdown
---
name: handoff-work
description: >-
  Package context and a copy-pasteable prompt for the next agent for a
  specified work item. Use when next-work hands off after a pick, or the
  user already chose the item and wants a handoff. Does not re-rank.
disable-model-invocation: true
---

# Handoff work

Package the **specified** next item for the next agent. Do not re-rank.
Do not implement.

If the router passed a picked item, that is the specified item.

## Hard rules

- Do not re-rank. Do not pick among a list to be helpful.
- If no item was specified: ask once which item (entire output). Do not
  rank. Do not write the package.
- Pointers must be real. If you did not open it, do not cite it.
- Not a dump of the repo. Not line-by-line edits. Not a fake citation.
- Do not implement. Mixed-turn implement request: finish this package,
  then **hand back**. They must send a **new message** to implement.
- Conversation-only unless they named a sink. Do not invent `HANDOFF.md`.
- Empty or unresolvable item → exactly `Nothing next.`
- Size / review / debug / orient → stop. Point at the matching family.

## Procedure

If this is a stop path (no item and they still have not named one,
empty/unresolvable, or out of family), skip steps 1–3. Write only the stop.

1. Take the specified item. Open only the pointers you will cite.
2. Write the output contract. Lead with goal + done-state, not history.
3. Stop (or hand back on mixed turn).

## Stop paths (no envelope)

These are **not** successful packages. Do **not** emit Goal, Constraints,
Done when, Pointers, or Prompt.

- No item specified: exactly `Name the item to hand off. I won’t re-rank.`
- Empty or unresolvable item: exactly `Nothing next.`
- Size / review / debug / orient: 1–2 sentences, point at the matching
  family, stop.

## Output contract (in order)

Skip this entire section on stop paths.

1. **Goal** — one short paragraph. Where this item goes.
2. **Constraints** — bullets they stated or the item names; or `None stated.`
3. **Done when** — 3–7 concrete checks. Not “the code looks good.”
4. **Pointers** — real paths / PRs / plan files only. No whole-repo tree.
5. **Prompt** — one fenced copy-pasteable prompt the next agent can run
   with. Includes the goal, constraints, done-when, and pointers. No
   line-by-line edits. No fake files. No “also while you’re there.”

On mixed turn, after Prompt: one line that the handoff is done; they must
send a **new message** to implement.

## Rationalizations

| Excuse | Reality |
|---|---|
| “They’ll need the whole repo” | Pointers, not a dump. If you did not open it, do not cite it. |
| “I’ll write the patch in the prompt” | Prompt is a starting action, not line-by-line edits. |
| “I’ll rank first so the prompt is for the right item” | Item is already specified. Do not re-rank. |
| “I’ll just do it — the handoff is obvious” | Package, then hand back. New message to implement. |
| “Always emit Goal / Constraints / Prompt” | Only after a specified item. Stop paths skip the envelope. |
| “Empty looks unfinished” | `Nothing next.` is success. |

## Failures

- Re-ranking
- Whole-repo dump or fake citation
- Line-by-line edit prescription
- Implementing in this turn
- Success envelope on a stop path
- Invented `HANDOFF.md` without a named sink
```

- [ ] **Step 5: Word-count check (do not truncate to hit a budget)**

```bash
wc -l skills/engineering/next-work/SKILL.md \
     skills/engineering/next-work/sources.md \
     skills/engineering/prioritize-work/SKILL.md \
     skills/engineering/handoff-work/SKILL.md
```

Expected: router roughly 70–160 lines; leaves roughly 150–370. If a leaf is short because the procedure is short, that is fine. If a file is doing two jobs, split — do not delete rules to hit a number.

- [ ] **Step 6: Commit the skills**

```bash
git add skills/engineering/next-work skills/engineering/prioritize-work skills/engineering/handoff-work
git commit -m "feat(skill): add next-work router, prioritize-work, and handoff-work"
```

---

### Task 4: Catalog sync

**Files:**
- Modify: `README.md`
- Modify: `skills/engineering/README.md`
- Modify: `.claude-plugin/plugin.json`

Same change as the skills. Preserve the User-invoked / Model-invoked split from PR #7.

**Interfaces:**
- Consumes: the three new skill paths
- Produces: catalog entries matching existing voice; plugin version `0.6.0`

- [ ] **Step 1: Root README**

In `README.md`, under Engineering **User-invoked**, after the `review-defects` bullet, add:

```markdown
- **[prioritize-work](./skills/engineering/prioritize-work/SKILL.md)** — Rank or select the next piece of work from a resolved set. Picks one item. Does not write the handoff.
- **[handoff-work](./skills/engineering/handoff-work/SKILL.md)** — Package context and a copy-pasteable prompt for the next agent for a specified item. Does not re-rank.
```

Under Engineering **Model-invoked**, after the `review-changes` bullet, add:

```markdown
- **[next-work](./skills/engineering/next-work/SKILL.md)** — Router for choosing the next piece of work. Use when asking what’s next or for a handoff prompt. Classifies the path; does not rank and does not write the handoff.
```

- [ ] **Step 2: Bucket README**

In `skills/engineering/README.md`, under **User-invoked**, after `review-defects`, add:

```markdown
- **[prioritize-work](./prioritize-work/SKILL.md)** — Rank or select the next piece of work from a resolved set. Picks one item. Does not write the handoff.
- **[handoff-work](./handoff-work/SKILL.md)** — Package context and a copy-pasteable prompt for the next agent for a specified item. Does not re-rank.
```

Under **Model-invoked**, after `review-changes`, add:

```markdown
- **[next-work](./next-work/SKILL.md)** — Router for choosing the next piece of work. Use when asking what’s next or for a handoff prompt. Classifies the path; does not rank and does not write the handoff.
```

- [ ] **Step 3: Plugin manifest**

In `.claude-plugin/plugin.json`, set `"version"` to `"0.6.0"`. Append to the `skills` array:

```json
    "./skills/engineering/next-work",
    "./skills/engineering/prioritize-work",
    "./skills/engineering/handoff-work"
```

Keep valid JSON (commas).

- [ ] **Step 4: Commit catalog sync**

```bash
git add README.md skills/engineering/README.md .claude-plugin/plugin.json
git commit -m "docs: catalog next-work family (User/Model split, plugin 0.6.0)"
```

---

### Task 5: GREEN pressure scenarios

**Files:**
- Modify: `docs/superpowers/plans/2026-08-20-next-work-skill-family-baseline.md` (fill `## GREEN`)

Fresh `generalPurpose` subagents. Instruct each to read `skills/engineering/next-work/SKILL.md` first and follow sibling handoff from that file’s directory. Ban `docs/superpowers/**`. Ban edits.

**Interfaces:**
- Consumes: skills from Task 3, fixtures from Task 1
- Produces: pass/fail notes per scenario

- [ ] **Step 1: Run the seven GREEN prompts**

Shared prefix:

```
Read skills/engineering/next-work/SKILL.md first and follow it, including
sibling reads from that file’s directory (not cwd). Do not read
docs/superpowers/**. Do not edit files.
```

Use the same A–G user sentences as Task 2.

- [ ] **Step 2: Score (must all pass)**

| ID | Pass when |
|---|---|
| A | Entire output is `Nothing next.` No Next/Why/Handoff/Goal headings. No invented items. |
| B | 1–2 sentences pointing at `size-work` / `shape-*`. No envelope. Did not write a shape brief. |
| C | One Next (one of the three named items). One-line Why. Leftover at most one line. No invented extras. No handoff package. |
| D | Announces prioritize then handoff. Next + Why + Goal/Constraints/Done when/Pointers/Prompt. Pointers exist under `fixtures/next-work-sample`. Did not implement. |
| E | Package for rename-sku only. Did not rank coupon stacking or tax rounding as Next. Pointers include the named plan. No fake files. |
| F | Pick + handoff, then hand back for a new message. `fixtures/next-work-sample/src/**` unchanged. |
| G | Entire output is `Nothing next.` No invented backlog. No envelope. |

- [ ] **Step 3: If a scenario fails, REFACTOR the skill (close the loophole) and re-run that scenario.** Do not add product scope.

- [ ] **Step 4: Write GREEN notes into the baseline file.** Set the spec status line to `verified (RED baseline + GREEN subagent runs)`.

- [ ] **Step 5: Commit verification notes**

```bash
git add docs/superpowers/plans/2026-08-20-next-work-skill-family-baseline.md \
        docs/superpowers/specs/2026-08-20-next-work-skill-family-design.md
git commit -m "docs: record next-work family GREEN verification"
```

---

## Self-review

**1. Spec coverage**

| Spec section | Task |
|---|---|
| Architecture / three skills + `sources.md` | 3 |
| Hard rules 1–8 | 3 (written into the files) |
| Classify table + mixed-turn hand-back | 3 (router) |
| Cheap-resolve / empty `Nothing next.` | 3 (`sources.md`) |
| Prioritize one-item contract | 3 |
| Handoff package contract | 3 |
| Stop paths skip envelope | 3 |
| Fixture | 1 |
| Catalog sync + plugin 0.6.0 | 4 |
| RED then GREEN, scenarios A–G | 2, 5 |
| Sibling-from-directory, not cwd | 3 |
| No extra product scope | Global Constraints |

**2. Placeholder scan:** no TBD / “add error handling” / “similar to Task N.”

**3. Type consistency:** skill names `next-work` / `prioritize-work` / `handoff-work`; playbook `sources.md`; empty string `Nothing next.`; paths `prioritize-then-handoff` / `prioritize-only` / `handoff-only`; plugin `0.6.0`.
