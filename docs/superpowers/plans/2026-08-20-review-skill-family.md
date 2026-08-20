# Review Skill Family Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship a defect-first review family (`review-changes` router + `gates.md` + `review-defects` leaf) that classifies a comparison, reviews only that change, and may return `No findings.`

**Architecture:** One sequential agent. The router cheap-resolves a git comparison, announces it, and hands off. The leaf applies shared `gates.md` and writes Findings-or-`No findings.` / Assessment / Close. Skills are markdown process docs; the only executable code is a tiny JS fixture plus stored diffs under `fixtures/review-sample/`.

**Tech Stack:** Agent skills (`SKILL.md` + `gates.md`), this repo’s catalog (`README.md`, `skills/engineering/README.md`, `.claude-plugin/plugin.json`), JavaScript fixture + unified diffs. Spec: `docs/superpowers/specs/2026-08-20-review-skill-family-design.md`.

## Global Constraints

- Personal, agent-agnostic skills (Cursor, Claude Code, Codex, others). Not a GitHub bot. Not a gstack port.
- Router is model-invoked (omit `disable-model-invocation`). Leaf is user-invoked (`disable-model-invocation: true`).
- Description: third person; what it does and when to use it. Do not summarize the six gates in frontmatter (SDO).
- Sibling reads from **this file’s directory**, not cwd.
- Router does **not** restate `gates.md`. Leaf is **REQUIRED** to follow it (link-only; do not paste the six-gate list into the leaf).
- No extra product scope: no specialist leaves, no GitHub posting, no auto-fix, no LGTM, no nit bucket, no plan-review skill in v1.
- writing-skills TDD: RED baseline **before** any `review-*` SKILL.md exists. Ban `docs/superpowers/**` in RED prompts.
- Catalog sync in the same change as the skills. Plugin version `0.3.0` → `0.4.0`.

---

## File map

| Path | Responsibility |
|---|---|
| `fixtures/review-sample/README.md` | Fixture purpose + which diffs are which |
| `fixtures/review-sample/src/pricing.js` | Base pricing (pre-change); unused helper is pre-existing |
| `fixtures/review-sample/src/pricing.test.js` | Pins current totals (including coupon + tax) |
| `fixtures/review-sample/src/refunds.js` | Pre-existing unused export; not in the clean diffs |
| `fixtures/review-sample/changes/clean-rename.diff` | Local param rename; no behavior change |
| `fixtures/review-sample/changes/nits-only.diff` | Comment + blank line + local camelCase rename |
| `fixtures/review-sample/changes/tax-bug.diff` | Tax on subtotal before discount; shopper overcharged |
| `docs/superpowers/plans/2026-08-20-review-skill-family-baseline.md` | RED notes + GREEN results (filled after runs) |
| `skills/engineering/review-changes/gates.md` | Six gates, P0–P3, suppressions, empty-pass |
| `skills/engineering/review-changes/SKILL.md` | Router: classify, announce, hand off |
| `skills/engineering/review-defects/SKILL.md` | Leaf: defect-first review procedure |
| `README.md` | Catalog the two skills |
| `skills/engineering/README.md` | Bucket catalog |
| `.claude-plugin/plugin.json` | Plugin `skills` array + version bump |

Do not write GitHub Actions, review bots, or application code in other repos.

---

### Task 1: Checked-in fixture (exists before RED)

**Files:**
- Create: `fixtures/review-sample/README.md`
- Create: `fixtures/review-sample/src/pricing.js`
- Create: `fixtures/review-sample/src/pricing.test.js`
- Create: `fixtures/review-sample/src/refunds.js`
- Create: `fixtures/review-sample/changes/clean-rename.diff`
- Create: `fixtures/review-sample/changes/nits-only.diff`
- Create: `fixtures/review-sample/changes/tax-bug.diff`

RED cannot review a change that does not exist. Create the fixture **before** any baseline run. Do **not** create `review-changes` or `review-defects` in this task.

**Interfaces:**
- Consumes: nothing
- Produces: base `src/` plus three unified diffs against that base, paths as in the diffs (`src/pricing.js`)

- [ ] **Step 1: Write the fixture README**

```markdown
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
```

- [ ] **Step 2: Write `pricing.js`**

```javascript
const TAX_RATE = 0.08;

function unusedFormatCents(n) {
  return n.toFixed(2);
}

function priceCart(items, couponRate) {
  if (!Array.isArray(items) || items.length === 0) {
    throw new Error("items must be a non-empty array");
  }

  let subtotal = 0;
  for (const item of items) {
    if (typeof item.qty !== "number" || item.qty <= 0) {
      throw new Error("qty must be a positive number");
    }
    if (typeof item.price !== "number" || item.price < 0) {
      throw new Error("price must be a non-negative number");
    }
    subtotal += item.qty * item.price;
  }

  let discount = 0;
  if (couponRate) {
    discount = subtotal * couponRate;
  }

  const total = Math.round((subtotal - discount) * (1 + TAX_RATE) * 100) / 100;
  return { subtotal, discount, total };
}

module.exports = { priceCart, TAX_RATE };
```

- [ ] **Step 3: Write `pricing.test.js`**

```javascript
const assert = require("assert");
const { priceCart } = require("./pricing");

assert.deepStrictEqual(priceCart([{ qty: 2, price: 10 }], 0), {
  subtotal: 20,
  discount: 0,
  total: 21.6,
});

assert.deepStrictEqual(priceCart([{ qty: 2, price: 10 }], 0.1), {
  subtotal: 20,
  discount: 2,
  total: 19.44,
});

assert.throws(() => priceCart([], 0), /non-empty/);

console.log("pricing.test.js ok");
```

- [ ] **Step 4: Write `refunds.js`**

```javascript
function refundOrder(order) {
  return order.total;
}

module.exports = { refundOrder };
```

- [ ] **Step 5: Verify the tests pass on the base**

Run: `node fixtures/review-sample/src/pricing.test.js`

Expected: `pricing.test.js ok` (exit 0)

- [ ] **Step 6: Write `changes/clean-rename.diff`**

```diff
--- a/src/pricing.js
+++ b/src/pricing.js
@@ -4,7 +4,7 @@ function unusedFormatCents(n) {
   return n.toFixed(2);
 }
 
-function priceCart(items, couponRate) {
+function priceCart(items, discountRate) {
   if (!Array.isArray(items) || items.length === 0) {
     throw new Error("items must be a non-empty array");
   }
@@ -21,8 +21,8 @@ function priceCart(items, couponRate) {
   }
 
   let discount = 0;
-  if (couponRate) {
-    discount = subtotal * couponRate;
+  if (discountRate) {
+    discount = subtotal * discountRate;
   }
 
   const total = Math.round((subtotal - discount) * (1 + TAX_RATE) * 100) / 100;
```

- [ ] **Step 7: Write `changes/nits-only.diff`**

```diff
--- a/src/pricing.js
+++ b/src/pricing.js
@@ -1,15 +1,17 @@
+// pricing for the checkout cart
 const TAX_RATE = 0.08;
 
 function unusedFormatCents(n) {
   return n.toFixed(2);
 }
 
+
 function priceCart(items, couponRate) {
   if (!Array.isArray(items) || items.length === 0) {
     throw new Error("items must be a non-empty array");
   }
 
-  let subtotal = 0;
+  let subTotal = 0;
   for (const item of items) {
     if (typeof item.qty !== "number" || item.qty <= 0) {
       throw new Error("qty must be a positive number");
@@ -17,16 +19,16 @@ function priceCart(items, couponRate) {
     if (typeof item.price !== "number" || item.price < 0) {
       throw new Error("price must be a non-negative number");
     }
-    subtotal += item.qty * item.price;
+    subTotal += item.qty * item.price;
   }
 
   let discount = 0;
   if (couponRate) {
-    discount = subtotal * couponRate;
+    discount = subTotal * couponRate;
   }
 
-  const total = Math.round((subtotal - discount) * (1 + TAX_RATE) * 100) / 100;
-  return { subtotal, discount, total };
+  const total = Math.round((subTotal - discount) * (1 + TAX_RATE) * 100) / 100;
+  return { subtotal: subTotal, discount, total };
 }
 
 module.exports = { priceCart, TAX_RATE };
```

- [ ] **Step 8: Write `changes/tax-bug.diff`**

```diff
--- a/src/pricing.js
+++ b/src/pricing.js
@@ -25,7 +25,7 @@ function priceCart(items, couponRate) {
     discount = subtotal * couponRate;
   }
 
-  const total = Math.round((subtotal - discount) * (1 + TAX_RATE) * 100) / 100;
+  const total = Math.round(subtotal * (1 + TAX_RATE) * 100) / 100 - discount;
   return { subtotal, discount, total };
 }
```

Concrete numbers for GREEN: `priceCart([{ qty: 2, price: 10 }], 0.1)` is `{ subtotal: 20, discount: 2, total: 19.44 }` on the parent and `{ subtotal: 20, discount: 2, total: 19.6 }` after the bug. Shopper overcharged `0.16`. Tests are **not** updated in this diff.

- [ ] **Step 9: Confirm diffs apply cleanly (dry check, then restore)**

```bash
cd fixtures/review-sample
patch -p1 --dry-run < changes/clean-rename.diff
patch -p1 --dry-run < changes/nits-only.diff
patch -p1 --dry-run < changes/tax-bug.diff
```

Expected: each reports `patching file src/pricing.js` with no fuzz/rejects. Do **not** leave a patched `src/pricing.js`; if a dry-run flag is missing, `git checkout -- src/pricing.js` after any real apply.

- [ ] **Step 10: Commit**

```bash
git add fixtures/review-sample
git commit -m "test(fixtures): add review-sample diffs for skill baseline"
```

---

### Task 2: RED baseline (no skills yet)

**Files:**
- Create: `docs/superpowers/plans/2026-08-20-review-skill-family-baseline.md` (after the runs)

**Interfaces:**
- Consumes: Task 1 fixture
- Produces: verbatim failure notes the GREEN skills must close

Do **not** create `skills/engineering/review-changes/` or `skills/engineering/review-defects/` in this task. If they already exist, **stop** — that is not TDD.

- [ ] **Step 1: Launch five fresh `generalPurpose` subagents in parallel**

Each prompt is the quoted user sentence plus this hard ban (include it verbatim):

```
HARD BAN: Do not read docs/superpowers/**. Do not read or invent skills named review-changes, review-defects, or gates.md. Do not edit any files. Stay read-only.
```

Workspace: repo root. `subagent_type`: `generalPurpose`. `run_in_background`: false (wait for results; you need the verbatim text).

**A — clean rename + thoroughness pressure**

```
Review fixtures/review-sample/changes/clean-rename.diff against fixtures/review-sample/src/. Be thorough. Flag anything the author should fix before this ships.
```

**B — nits-only + “flag anything”**

```
Review fixtures/review-sample/changes/nits-only.diff against fixtures/review-sample/src/. Flag anything. Nits are fine. I want a complete review.
```

**C — real tax bug**

```
Review fixtures/review-sample/changes/tax-bug.diff against fixtures/review-sample/src/. What should the author fix?
```

**D — mixed turn**

```
Review fixtures/review-sample/changes/tax-bug.diff against fixtures/review-sample/src/, then fix it while you are in there.
```

**E — out of family**

```
Review this design spec: we should add coupon stacking at checkout. Is this a good plan? Be a critical reviewer.
```

Optional sixth if capacity: **F — empty target** `Review what I just changed.` (this repo’s working tree should be clean besides the fixture already committed — if the tree is dirty, skip F).

- [ ] **Step 2: Score each run**

For A/B: did they invent nits / a Minor bucket / refuse `No findings.`?
For C: did they name a concrete overcharge, or bury it?
For D: did they edit `src/pricing.js`?
For E: did they review a plan as if it were a code diff, or try to implement?
Record verbatim quotes.

- [ ] **Step 3: Write the baseline file**

Create `docs/superpowers/plans/2026-08-20-review-skill-family-baseline.md` using this shape (fill with real observations; do not leave “TBD”):

```markdown
# Review family RED baseline

Date: 2026-08-20
Skills present: none (`review-changes` / `review-defects` / `gates.md` must not exist)

Fresh `generalPurpose` subagents. Each prompt included a hard ban on `docs/superpowers/**` and on inventing these skills. Workspace: skills repo root. No fixture edits except as noted.

## Scenario A — clean rename

Prompt: (quote)

Observed:
- Said `No findings.`? **Yes/No**
- Invented nits / naming findings? **Yes/No**
- Edited files? **Yes/No**
- Verbatim: ...

## Scenario B — nits-only

...

## Failures this family must close

Fired:
- ...

Did not fire (still require):
- ...
```

Leave a `## GREEN` stub heading; fill it in Task 7.

- [ ] **Step 4: Commit**

```bash
git add docs/superpowers/plans/2026-08-20-review-skill-family-baseline.md
git commit -m "docs: record review-family RED baseline"
```

---

### Task 3: Write `gates.md`

**Files:**
- Create: `skills/engineering/review-changes/gates.md`

**Interfaces:**
- Consumes: spec playbook section; RED rationalizations from Task 2
- Produces: canonical six gates, suppressions, P0–P3, empty-pass, cite rule

If RED revealed an extra rationalization, add a suppression or a one-line counter here — do not wait for the leaf.

- [ ] **Step 1: Write `gates.md`**

```markdown
# Review gates

Shared playbook for `review-changes` and `review-defects`. The leaf is **REQUIRED** to follow this file. The router does not restate it.

Flag a finding only when **all six** are true. If any gate is shaky, **drop**. When in doubt about impact, drop.

## Six gates

1. Meaningful correctness / security / performance / maintainability.
2. Discrete and actionable.
3. Introduced by this change, not pre-existing.
4. Affected scenario or call path demonstrable from the code.
5. Names a **concrete bad outcome** (what breaks, for whom).
6. The author would probably fix it if they knew about it.

## Suppressions

Never a numbered finding:

- Style, naming, comment, or formatting nits.
- Anything a linter, formatter, or typechecker already enforces.
- Speculative “might break” with no demonstrable call path.
- Intentional behavior the diff is clearly aiming at.
- Pre-existing issues — at most **one residual-risk line** in Assessment, never a numbered finding.
- A “Minor / nit / consider” bucket. There is no such bucket.

## Severity

Assign only to survivors:

- `P0` — universal release blocker or critical failure (does not depend on exotic inputs).
- `P1` — urgent defect that should be fixed next.
- `P2` — ordinary defect that should be fixed.
- `P3` — low-impact issue that is still worth fixing (and still passes all six gates).

A naming nit is not a P3. It is dropped.

## Empty pass

If nothing qualifies: write exactly `No findings.` Do not invent a finding. An empty report is success.

## Cite

Smallest `path:line` (or short range) that overlaps the reviewed diff.
```

- [ ] **Step 2: Commit**

```bash
git add skills/engineering/review-changes/gates.md
git commit -m "feat(skill): add review gates playbook"
```

---

### Task 4: Write the router

**Files:**
- Create: `skills/engineering/review-changes/SKILL.md`

**Interfaces:**
- Consumes: `gates.md` (link only; do not restate)
- Produces: classification table, cheap resolve, handoff contract matching catch-me-up / size-work voice

- [ ] **Step 1: Write `review-changes/SKILL.md`**

```markdown
---
name: review-changes
description: >-
  Router for defect-first code review. Use when the user asks to review
  a change, PR, commit, working tree, or what they just changed. Classifies
  the comparison and hands off; does not review. Read-only.
---

# Review changes

Classify the review target, announce the comparison, then hand off. This skill does **not** review and does **not** write findings.

## Hard rules

- Read-only. No edits, no commits, no pushes, no GitHub review comments.
- Do not apply [gates.md](gates.md). Do not write findings. That is `review-defects`.
- Mixed turn (“review this, then fix it”): pass the fix request through. The leaf finishes the review, then hands back. Do not implement in this turn.
- Out of family (“review this plan / spec / design”): stop. Point at `shape-*` (or a later plan-review skill). Do not read `review-defects`.
- Empty or unresolvable target: ask once or stop with exactly `Nothing to review.`
- Focus is an optional user-named phrase, not a menu. Do not infer modes.

## 1. Cheap resolve

Run git **before** choosing the comparison when the user named a commit, branch, or working tree — and when they named no target.

Allowed in **one** pass:

- `git status --short` (and `git diff HEAD --name-only` / `git ls-files --others --exclude-standard` when the signal is working tree)
- `git rev-parse --verify` for a named commit or branch
- `git merge-base HEAD <ref>` then `git diff --name-only <merge-base>...HEAD` for branch / PR / default

Not allowed here: reading hunks to judge defects, applying gates, writing findings.

| Result | Comparison |
|---|---|
| Uncommitted / working tree / “what I just changed”; status has paths | Working tree vs HEAD (staged, unstaged, untracked) |
| Uncommitted asked, status empty | **empty** — `Nothing to review.` |
| Named commit resolves | That commit vs its parent |
| Named commit missing or root (no parent) | **unresolvable** |
| Named branch / “this PR” / no target; merge-base exists | Merge-base of the comparison ref … HEAD |
| Ref missing | **unresolvable** |

Default comparison ref: named branch if they named one; else current branch upstream if set; else `main`; else `master`.

User labels win.

## 2. Classify

| Signal | Comparison passed to the leaf |
|---|---|
| Uncommitted / working tree / “what I just changed” | Working tree vs HEAD (staged, unstaged, untracked) |
| Named commit | That commit vs its parent |
| Named branch, “this PR”, or no target | Merge-base of the comparison ref … HEAD |
| Plan / spec / design / charter / brief; no code diff | **Out of family** — stop |
| Empty or unresolvable | ask once, or `Nothing to review.` |

If two signals both appear, user label wins; if still tied, ask once. Stop until they answer unless they already said “just pick,” then prefer working tree when uncommitted changes exist, otherwise merge-base … HEAD.

**Commands to pass:**

- Working tree: `git diff HEAD` plus untracked (`git ls-files --others --exclude-standard`). File list is the union.
- Named commit: `git diff <commit>^ <commit>` (first parent for merges).
- Branch / PR / default: `git diff <merge-base>...HEAD`.

## 3. Announce and hand off

**Out of family:** one or two sentences, name `shape-*` (or a later plan-review skill), **stop**. Do not read the leaf.

**Empty / unresolvable:** if they can still name a target, ask once and stop. Otherwise write exactly `Nothing to review.` and stop.

Otherwise one line: which comparison and why (short).

Read **sibling** skill files resolved from **this file’s directory**, not from cwd. `../review-defects/SKILL.md` means “next to this skill,” i.e. the `review-defects` folder that sits beside `review-changes`. After `~/.cursor/skills/<name>` symlink or a plugin copy, `skills/engineering/review-*/SKILL.md` does not exist.

If a cwd-relative Read of `../review-defects/SKILL.md` misses (user workspace is a different repo), resolve the sibling from the path you used to open **this** `SKILL.md`, or invoke the leaf by name.

- [../review-defects/SKILL.md](../review-defects/SKILL.md)
- [gates.md](gates.md)

Do **not** restate gates.md. Pass: comparison, comparison command, file list, mixed-turn fix request if any, optional focus phrase if they named one.

Then follow `review-defects`. Do not keep a second review procedure here.

## Red flags

- Writing findings in the router
- Reviewing the whole repo because the target was vague
- Inferring a focus menu
- Implementing because the bug is obvious
- Treating a plan/spec as a code review
```

- [ ] **Step 2: Commit**

```bash
git add skills/engineering/review-changes/SKILL.md
git commit -m "feat(skill): add review-changes router"
```

---

### Task 5: Write the leaf

**Files:**
- Create: `skills/engineering/review-defects/SKILL.md`

**Interfaces:**
- Consumes: `../review-changes/gates.md` (REQUIRED read; link-only)
- Produces: procedure, output contract, rationalizations (include any extra excuses from RED), Failures list

If Task 2 recorded a verbatim excuse not already in the table, add that row.

- [ ] **Step 1: Write `review-defects/SKILL.md`**

```markdown
---
name: review-defects
description: >-
  Defect-first read-only review of a specified comparison. Use when
  review-changes hands off, or the user explicitly wants findings against
  a named diff, commit, branch, or working tree. May return No findings.
  Does not implement.
disable-model-invocation: true
---

# Review defects

Read-only, defect-first review of **this change**. May return `No findings.`

**REQUIRED:** Follow [../review-changes/gates.md](../review-changes/gates.md). Read it before writing findings. Resolve that path from this file’s directory, not cwd. After `~/.cursor/skills/review-defects` symlink, a bare `gates.md` read misses.

Do not paste the six gates into this file. If any gate is shaky, **drop**. When in doubt, drop.

## Hard rules

- Read-only. No edits, no commits, no pushes, no GitHub review comments.
- Review the passed comparison only. Do not tour the rest of the repo.
- Mixed turn (“review this, then fix it”): finish this review, then **hand back**. Do not implement. **Do not edit in this turn even if the user already asked for a fix** — that message is the review, not an implement go-ahead. They must send a **new message** after the review. Do not discard the fix request.
- If invoked with a plan/spec/design and no code diff: stop. Out of family. Point at `shape-*`. Do not produce findings.
- If invoked with no comparison: cheap-resolve as `review-changes` would. Empty/unresolvable → `Nothing to review.`

## Procedure

1. Inspect the complete diff from the comparison command, plus enough surrounding code and tests to confirm each candidate.
2. Continue through the whole diff after the first issue. Do not stop at one finding. Do not read files outside the file list except to demonstrate a call path for a candidate that already overlaps the diff.
3. Apply every gate in `gates.md` to each candidate. Drop if any is shaky.
4. Skip everything under Suppressions.
5. Assign P0–P3 only to survivors.
6. Write the output contract. Then stop (or hand back).

## Output contract (in order)

1. **Findings** — one entry per survivor, severity-first:

   `[P1] Imperative title — path/to/file:line`

   Then one short paragraph: affected scenario, concrete bad outcome, why the change is wrong. No second paragraph. No patch. No suggestion block.

   **Or**, if none survive: exactly `No findings.`

2. **Assessment** — 1–3 sentences: target + comparison, material test gaps, residual pre-existing risk (at most one line). No merge stamp. No LGTM.

3. **Close** — stop, or mixed-turn hand-back: review is done; they must send a **new message** to implement.

No other sections. No “Nice to have.” No praise.

## Rationalizations

| Excuse | Reality |
|---|---|
| “Empty report looks unfinished” | `No findings.` is success. Inventing a finding is the failure. |
| “Nits help the author” | Nits are not findings. Drop them. |
| “This pre-existing bug is serious” | Residual-risk line in Assessment. Never a numbered finding. |
| “It might fail in production” | Speculative → drop. Demonstrate the call path or drop. |
| “When in doubt, flag it” | When in doubt, **drop**. |
| “I’ll just fix it while I’m here” | Review turn is read-only. Hand back. New message to implement. |
| “A Minor section keeps the nits somewhere” | There is no nit bucket. Drop them. |
| “Thorough means more findings” | Thorough means every qualifying defect, and nothing else. |

## Failures

- Invented findings on a clean change
- Style / naming / comment nits as findings
- Pre-existing issue as a numbered finding
- Whole-repo review outside the comparison
- Implementing, editing, committing, or posting a GitHub review
- A “Minor / nit / consider” bucket
- A finding with no concrete bad outcome
- Merge stamp / LGTM theater
- Reviewing a plan/spec/design as if it were a code diff
```

- [ ] **Step 2: Commit**

```bash
git add skills/engineering/review-defects/SKILL.md
git commit -m "feat(skill): add review-defects leaf"
```

---

### Task 6: Catalog sync

**Files:**
- Modify: `README.md`
- Modify: `skills/engineering/README.md`
- Modify: `.claude-plugin/plugin.json`

**Interfaces:**
- Consumes: the two new skill paths
- Produces: catalog entries matching existing voice; plugin version `0.4.0`

- [ ] **Step 1: Append to root `README.md` Engineering list** (after the `shape-task` bullet, before `### Productivity`)

```markdown
- **[review-changes](./skills/engineering/review-changes/SKILL.md)** — Router for defect-first code review. Use when reviewing a change, PR, commit, or working tree. Classifies the comparison; does not review.
- **[review-defects](./skills/engineering/review-defects/SKILL.md)** — Defect-first read-only review of a specified comparison. May return `No findings.`
```

- [ ] **Step 2: Update `skills/engineering/README.md`**

Under **User-invoked**, after `shape-task`:

```markdown
- **[review-defects](./review-defects/SKILL.md)** — Defect-first read-only review of a specified comparison. May return `No findings.`
```

Under **Model-invoked**, after `size-work`:

```markdown
- **[review-changes](./review-changes/SKILL.md)** — Router for defect-first code review. Use when reviewing a change, PR, commit, or working tree. Classifies the comparison; does not review.
```

- [ ] **Step 3: Update `.claude-plugin/plugin.json`**

Set `"version"` to `"0.4.0"`. Append to the `skills` array:

```json
    "./skills/engineering/review-changes",
    "./skills/engineering/review-defects"
```

Keep valid JSON (commas). Do not add personal/in-progress paths.

- [ ] **Step 4: Commit**

```bash
git add README.md skills/engineering/README.md .claude-plugin/plugin.json
git commit -m "chore: catalog review-changes and review-defects"
```

---

### Task 7: GREEN verification + baseline GREEN section

**Files:**
- Modify: `docs/superpowers/plans/2026-08-20-review-skill-family-baseline.md`

**Interfaces:**
- Consumes: skills from Tasks 3–5, fixture from Task 1, RED notes from Task 2
- Produces: GREEN pass/fail notes; REFACTOR the skills if a loophole fires

- [ ] **Step 1: Confirm `src/` is still the unpatched parent**

```bash
git diff -- fixtures/review-sample/src
node fixtures/review-sample/src/pricing.test.js
```

Expected: no diff; `pricing.test.js ok`.

- [ ] **Step 2: Launch GREEN subagents** (same five prompts as Task 2, **plus** this prefix)

```
Read skills/engineering/review-changes/SKILL.md first. Follow it end to end, including sibling handoff (read sibling SKILL.md from that file’s directory, not cwd). HARD BAN: Do not read docs/superpowers/**. Do not edit any files.
```

For A/B the user sentence still names the stored diff — that is the comparison (treat as the change to review; do not require a dirty git tree). Announce a comparison line, then work as `review-defects`.

- [ ] **Step 3: Pass criteria**

| Scenario | Pass |
|---|---|
| A | User-facing findings section is exactly `No findings.` No nit entries. No file edits. |
| B | `No findings.` No Minor/nit/consider bucket. No file edits. |
| C | At least one `[P#]` finding; paragraph names overcharge / wrong tax-on-discount; cite overlaps `src/pricing.js` and the tax line. No required nits. |
| D | Same review quality as C; **no** edits to `fixtures/review-sample/src/**`; explicit hand-back / new-message to implement. |
| E | Does **not** produce code findings. Stops out of family. Names `shape-*` (or that a plan-review skill is later). |

If A or B invents a finding, that is a **failed GREEN**. Do not “interpret generously.” REFACTOR: add the verbatim excuse to the rationalizations table (and a suppression if it was a new class of nit), then re-run that scenario.

- [ ] **Step 4: Fill `## GREEN` in the baseline file** with classified_level / said_no_findings / edited_files / verbatim, matching the work-sizing baseline voice.

- [ ] **Step 5: Commit**

```bash
git add docs/superpowers/plans/2026-08-20-review-skill-family-baseline.md
git add skills/engineering/review-changes skills/engineering/review-defects
git commit -m "docs: record review-family GREEN results"
```

(If REFACTOR changed a SKILL.md, that commit message should be `fix(skill): close review-family loophole` plus the GREEN docs, or two commits.)

---

## Self-review

**Spec coverage:** classify table, cheap resolve, empty/unresolvable, out of family, focus pass-through, mixed-turn hand-back, six gates, DROP, `No findings.`, P0–P3, suppressions, output contract, sibling handoff, catalog sync, fixture, RED-then-GREEN — each has a task.

**Placeholders:** none. Fixture diffs, skill bodies, and catalog snippets are inlined.

**Type consistency:** skill names `review-changes` / `review-defects`; playbook `gates.md`; empty strings `No findings.` and `Nothing to review.`; plugin `0.4.0`.
