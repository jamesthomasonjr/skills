# Debug Skill Family Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship a model-invoked `debug` router plus `debug-root-cause` and `debug-feedback-loop` depth skills that enforce root-cause-first vs feedback-loop-first debugging without external skill installs.

**Architecture:** Thin router classifies and hands off (no investigation). Depth skills own procedure. Shared `paths.md` is the only escalation trigger list (link-only from depth skill via `../debug/paths.md`). Skills are markdown process docs; a tiny JS fixture under `fixtures/debug-sample/` baselines and verifies investigate-before-fix.

**Tech Stack:** Agent skills (`SKILL.md` + `paths.md`), this repo’s catalog (`README.md`, `skills/engineering/README.md`, `.claude-plugin/plugin.json`), Node-runnable JavaScript fixture. Spec: `docs/superpowers/specs/2026-08-18-debug-skill-family-design.md`.

## Global Constraints

- Project-agnostic and agent-agnostic (no Superpowers/mattpocock/gstack install deps).
- `debug` model-invoked; depth skills `disable-model-invocation: true`.
- Escalation owner: `debug-root-cause` only; mechanism: sibling read of `debug-feedback-loop`.
- Escalation triggers: link-only to `debug/paths.md` — no verbatim copy in depth skill bodies.
- Descriptions are trigger-only (SDO): no workflow summary in YAML `description`.
- Catalog sync in the same change that promotes skills.
- Prefer Superpowers-sized bands (router ~70–160, process ~150–370) but do not truncate procedure to hit a budget.

---

## File map

| Path | Responsibility |
|---|---|
| `fixtures/debug-sample/README.md` | Fixture purpose; how to run the failing test |
| `fixtures/debug-sample/src/total.js` | Known-broken `cartTotal` (wrong tax) |
| `fixtures/debug-sample/src/total.test.js` | Failing test asserting correct tax math |
| `docs/superpowers/plans/2026-08-20-debug-skill-family-baseline.md` | RED notes from unskilled runs |
| `skills/engineering/debug/paths.md` | Classification + escalation (single source) |
| `skills/engineering/debug/SKILL.md` | Router |
| `skills/engineering/debug-root-cause/SKILL.md` | Four-phase root-cause path |
| `skills/engineering/debug-feedback-loop/SKILL.md` | Six-phase feedback-loop path |
| `README.md` | Catalog three skills |
| `skills/engineering/README.md` | Bucket catalog |
| `.claude-plugin/plugin.json` | Plugin `skills` array |
| `docs/superpowers/specs/2026-08-18-debug-skill-family-design.md` | Mark status verified after GREEN |

Do not depend on obra/superpowers or mattpocock skills being installed.

---

### Task 1: Checked-in fixture

**Files:**
- Create: `fixtures/debug-sample/README.md`
- Create: `fixtures/debug-sample/src/total.js`
- Create: `fixtures/debug-sample/src/total.test.js`

Create the fixture **before** RED. Do not create debug skills in this task.

- [ ] **Step 1: Write the fixture README**

Create `fixtures/debug-sample/README.md` with this body (use a fenced bash block for the run command in the real file):

```
# debug-sample

Tiny cart-total helper used to test the debug skill family.

Bug under test: `cartTotal` in `src/total.js` applies tax to the pre-discount
subtotal instead of the post-discount amount. `src/total.test.js` fails until
that is fixed.

Run: node --test fixtures/debug-sample/src/total.test.js

Do not fix the bug during RED baseline runs. GREEN may fix it only when following
`debug-root-cause` after investigation.
```

In the committed README, wrap the run line in a normal bash fence.
- [ ] **Step 2: Write the broken implementation**

```javascript
// fixtures/debug-sample/src/total.js
function cartTotal(items, couponRate, taxRate) {
  if (!Array.isArray(items) || items.length === 0) {
    throw new Error("items must be a non-empty array");
  }
  const subtotal = items.reduce((sum, item) => sum + item.qty * item.price, 0);
  const discount = subtotal * (couponRate || 0);
  // BUG: tax applied to pre-discount subtotal
  const tax = subtotal * (taxRate || 0);
  return Math.round((subtotal - discount + tax) * 100) / 100;
}

module.exports = { cartTotal };
```

- [ ] **Step 3: Write the failing test**

```javascript
// fixtures/debug-sample/src/total.test.js
const { describe, it } = require("node:test");
const assert = require("node:assert/strict");
const { cartTotal } = require("./total");

describe("cartTotal", () => {
  it("applies tax after discount", () => {
    // items $100, 10% coupon, 8% tax → (100 - 10) * 1.08 = 97.2
    assert.equal(cartTotal([{ qty: 1, price: 100 }], 0.1, 0.08), 97.2);
  });
});
```

- [ ] **Step 4: Confirm the test fails**

Run: `node --test fixtures/debug-sample/src/total.test.js`  
Expected: FAIL (actual ≠ 97.2; typically 98)

- [ ] **Step 5: Commit**

```bash
git add fixtures/debug-sample
git commit -m "test(fixture): add debug-sample with known tax bug"
```

---

### Task 2: RED baseline (skills must not exist yet)

**Files:**
- Create: `docs/superpowers/plans/2026-08-20-debug-skill-family-baseline.md`

**Interfaces:**
- Consumes: `fixtures/debug-sample/` from Task 1
- Produces: documented failure modes the skills must close

Confirm `skills/engineering/debug*` do not exist. Dispatch fresh `generalPurpose` subagents. Ban reading `docs/superpowers/**` and inventing this family’s skill names. Workspace: skills repo root.

- [ ] **Step 1: Run Scenario A — clear failing test (fixture)**

Prompt:

```text
The test fixtures/debug-sample/src/total.test.js is failing. Fix the bug.
Hard ban: do not read docs/superpowers/**. Do not invent skills named debug,
debug-root-cause, or debug-feedback-loop.
```

Record: whether it patched immediately without stating root cause / phases; whether it ran the test before and after; verbatim excerpt.

- [ ] **Step 2: Run Scenario B — ambiguous**

Prompt:

```text
Checkout totals look wrong sometimes. Help me debug it.
Hard ban: do not read docs/superpowers/**. Do not invent debug / debug-root-cause / debug-feedback-loop.
```

Record: whether it preferred a disciplined path or guessed forever / jumped to hypothesising without evidence.

- [ ] **Step 3: Run Scenario C — flaky / no repro**

Prompt:

```text
Auth is flaky in CI — can't repro locally, keeps coming back after "fixes". Find the root cause.
Hard ban: do not read docs/superpowers/**. Do not invent debug / debug-root-cause / debug-feedback-loop.
```

Record: whether it speculated from reading code without a red-capable loop.

- [ ] **Step 4: Run Scenario D — mixed turn**

Prompt:

```text
fixtures/debug-sample/src/total.test.js is failing — fix that bug, then add a gift-card feature to cartTotal.
Hard ban: do not read docs/superpowers/**. Do not invent debug / debug-root-cause / debug-feedback-loop.
```

Record: whether it started gift-card work in the same turn.

- [ ] **Step 5: Write the baseline doc**

Use this skeleton (fill Observed / Failures from actual runs):

```markdown
# Debug skill family RED baseline

Date: 2026-08-20
Skills present: none (`debug` / `debug-root-cause` / `debug-feedback-loop` must not exist)

## Scenario A — clear failing test

Prompt: (as above)
Observed:
- ...
Verbatim: "..."

## Scenario B — ambiguous

...

## Scenario C — flaky / no repro

...

## Scenario D — mixed turn

...

## Failures this family must close

- A: ...
- B: ...
- C: ...
- D: ...
```

- [ ] **Step 6: Commit**

```bash
git add docs/superpowers/plans/2026-08-20-debug-skill-family-baseline.md
git commit -m "docs: record debug skill family RED baseline"
```

---

### Task 3: `paths.md` (classification + escalation)

**Files:**
- Create: `skills/engineering/debug/paths.md`

**Interfaces:**
- Produces: canonical Classification table + Escalation list consumed by router and `debug-root-cause`

- [ ] **Step 1: Write `paths.md`**

```markdown
# Debug paths

Shared vocabulary for `debug` and `debug-root-cause`. If wording here conflicts with a `SKILL.md` summary, **this file wins**.

## Classification

Explicit user labels win (`/debug-root-cause`, `/debug-feedback-loop`, “use the loop path”).

| Signal | Path |
|---|---|
| Clear repro, stack trace, failing test, recent regression, “fix this bug” with usable evidence | `debug-root-cause` |
| No reliable repro; flaky; performance regression; “keeps coming back”; agent already guessing without a signal | `debug-feedback-loop` |
| Explicit user label for a path | that path |
| Ambiguous | **Prefer `debug-root-cause`** |

## Escalation

Mid-run switches are owned only by `debug-root-cause`. When any trigger matches, announce once, then read sibling `../debug-feedback-loop/SKILL.md` and follow it. Do not bounce back through `debug`.

Triggers:

- Cannot reproduce consistently
- Two or more hypotheses failed without a tight pass/fail signal
- Flaky or performance issue and still no tight red-capable command
- Confirmed hypothesis but cannot create a re-runnable regression/command in Phase 4 (manual-only repro that cannot be automated or scripted for the agent)
```

- [ ] **Step 2: Commit**

```bash
git add skills/engineering/debug/paths.md
git commit -m "feat(skill): add debug paths.md classification and escalation"
```

---

### Task 4: Router `debug/SKILL.md`

**Files:**
- Create: `skills/engineering/debug/SKILL.md`

**Interfaces:**
- Consumes: `paths.md`
- Produces: handoff to `debug-root-cause` or `debug-feedback-loop`

- [ ] **Step 1: Write the router**

```markdown
---
name: debug
description: >-
  Router for debugging and bug fixing. Use when the user asks for help
  fixing, debugging, or finding the root cause of an issue; or reports
  something broken, throwing, failing, or regressing and wants it diagnosed.
---

# Debug

Classify the bug, then hand off. This skill does **not** investigate, hypothesise, or fix.

**REQUIRED:** Read [paths.md](paths.md) before classifying.

## Hard rules

- Do not investigate root cause in the router.
- Do not write fixes, add logs, or run “quick checks” that are really Phase 1 of a depth skill.
- Do not own mid-run escalation — that is `debug-root-cause` only.
- Mixed turn (“fix this, then add feature X”): hand off to the depth skill; when debugging finishes, **hand back**. Do not start the unrelated work in this turn.

## 1. Classify

Use [paths.md](paths.md). Explicit user labels win.

| Signal | Path |
|---|---|
| Clear repro / stack / failing test / recent regression / usable evidence | `debug-root-cause` |
| No reliable repro; flaky; perf; “keeps coming back”; guessing without a signal | `debug-feedback-loop` |
| Explicit path label | that path |
| Ambiguous | Prefer `debug-root-cause` |

If wording drifts, [paths.md](paths.md) wins.

## 2. Announce and hand off

One line: which path and why (short).

Read the **sibling** skill from this file’s directory (not cwd):

- [../debug-root-cause/SKILL.md](../debug-root-cause/SKILL.md)
- [../debug-feedback-loop/SKILL.md](../debug-feedback-loop/SKILL.md)
- [paths.md](paths.md)

`../debug-root-cause/SKILL.md` means “next to this skill.” After `~/.cursor/skills/<name>` symlink or a plugin copy, `skills/engineering/debug-*/SKILL.md` does not exist. If a cwd-relative Read misses, resolve the sibling from the path used to open **this** `SKILL.md`, or invoke the depth skill by name.

Pass: chosen path, original symptom / user description, constraints they stated, evidence already provided (logs, stack, repro steps), mixed-turn leftover request if any.

Then follow that depth skill. Do not keep a second debugging procedure here.

## Red flags

- Investigating or fixing inside the router
- Asking the user to choose a path when the table already prefers root-cause for ambiguous cases
- Re-entering the router mid-debug to “re-classify” (escalation is depth-owned)
- Starting unrelated feature work in a mixed turn
```

- [ ] **Step 2: Commit**

```bash
git add skills/engineering/debug/SKILL.md
git commit -m "feat(skill): add debug router"
```

---

### Task 5: `debug-root-cause/SKILL.md`

**Files:**
- Create: `skills/engineering/debug-root-cause/SKILL.md`

**Interfaces:**
- Consumes: `../debug/paths.md` (escalation, link-only)
- Produces: investigation → fix, or sibling escalate to `debug-feedback-loop`

- [ ] **Step 1: Write the skill**

```markdown
---
name: debug-root-cause
description: >-
  Use when debugging with a clear repro, stack trace, failing test, or recent
  regression, or when the debug router hands off the root-cause path.
disable-model-invocation: true
---

# Debug root cause

**Iron Law:** no fixes without root-cause investigation first.

**REQUIRED before escalating (and on direct invoke):** Read [../debug/paths.md](../debug/paths.md) with sibling-resolve (`../debug/paths.md` is next to this skill’s folder). After `~/.cursor/skills/debug-root-cause` symlink, a bare `paths.md` read misses. **Link-only** — do not paste the escalation list into this file.

Also: [../debug-feedback-loop/SKILL.md](../debug-feedback-loop/SKILL.md)

## Hard rules

- No symptom-only patches.
- One change at a time. Do not stack untested fixes.
- Fresh verification evidence before claiming fixed.
- Mixed-turn leftover (feature work after the fix): finish this path, then **hand back**.

## Phase 1 — Investigate

Before any fix:

1. Read errors and stack traces completely.
2. Reproduce. Prefer a re-runnable command when easy; do **not** block leaving Phase 1 solely because the repro is still manual.
3. Check recent changes (git log/diff, deps, config, environment).
4. Multi-component systems: instrument boundaries and gather evidence before guessing.
5. Trace bad values backward to the source; fix at source, not symptom.

## Phase 2 — Pattern

1. Find working analogues in the same codebase.
2. Diff working vs broken; list every difference.
3. Note dependencies, config, and assumptions.

## Phase 3 — Hypothesis

1. Form **one** falsifiable hypothesis; test with the smallest probe.
2. If wrong: **check [../debug/paths.md](../debug/paths.md) Escalation first**. If any trigger matches → escalate (see Escalation out). Otherwise return to Phase 1 with new evidence and form a **new** hypothesis — do not stack fixes.

## Phase 4 — Implement

Enter after a confirmed hypothesis. Steps in order:

1. **Create or reuse a failing regression** (automated test preferred; else a named agent-runnable command that goes red on this symptom).
2. If you **cannot** create that signal → escalate via [../debug/paths.md](../debug/paths.md). Do not patch without it.
3. Apply **one** root-cause fix.
4. Verify the original symptom with fresh evidence against that regression/command.
   - Works → Closeout.
   - Fails and attempts **under 3** → return to Phase 1 with new evidence.
   - Fails and attempts **3 or more** (count only after step 1’s tight signal exists) → stop and question architecture with the user. Do not attempt fix #4 without that discussion.

## Stop rules

- Three failed fixes against an existing tight signal → architecture discussion, not another guess.
- Without a creatable tight signal → escalate, do not invent an architecture stop.
- Red flags → return to Phase 1 (or escalate if paths.md matches): “quick fix for now,” multi-change thrash, skip verification, fix before tracing.

## Escalation out

When any trigger in [../debug/paths.md](../debug/paths.md) **Escalation** matches: announce in one line, read [../debug-feedback-loop/SKILL.md](../debug-feedback-loop/SKILL.md), follow it. Do not bounce through `debug`. Do not keep both procedures in play. Do not restate trigger bullets here.

## Closeout

Run verification of the original symptom; paste command + output / exit code. Remove throwaway debug logs. Then hand back any mixed-turn leftover.
```

- [ ] **Step 2: Commit**

```bash
git add skills/engineering/debug-root-cause/SKILL.md
git commit -m "feat(skill): add debug-root-cause process skill"
```

---

### Task 6: `debug-feedback-loop/SKILL.md`

**Files:**
- Create: `skills/engineering/debug-feedback-loop/SKILL.md`

**Interfaces:**
- Consumes: handoff from router or escalate from `debug-root-cause`
- Produces: loop-first diagnosis and fix

- [ ] **Step 1: Write the skill**

```markdown
---
name: debug-feedback-loop
description: >-
  Use when debugging flaky, unreproducible, recurring, or performance issues,
  or when no tight pass/fail signal exists yet, or when the debug router or
  debug-root-cause hands off the feedback-loop path.
disable-model-invocation: true
---

# Debug feedback loop

**Iron Law:** no hypothesis until a **tight, red-capable** feedback loop exists for *this* symptom.

## Hard rules

- Do not theorise before Phase 1’s command exists and has been run once (redacted output shown).
- One variable at a time when instrumenting.
- Fresh verification before claiming fixed.
- Mixed-turn leftover: finish this path, then **hand back**.

## Redact

Redact secrets in commands, outputs, and artifacts (`<REDACTED>`). Prefer env vars over pasting credentials. Quote only diagnostic lines from captured artifacts that may contain auth headers.

## Phase 1 — Build the loop

Spend disproportionate effort here.

Try in order until you have one agent-runnable command:

1. Failing test at a seam that reaches the bug
2. Curl / HTTP script against a running server
3. CLI + fixture, diff stdout
4. Headless browser (Playwright / Puppeteer)
5. Replay a captured trace/payload
6. Throwaway harness with mocked deps
7. Property / fuzz loop
8. Bisect harness (`git bisect run`)
9. HITL script only as last resort

**Done when** you can name **one command** already run once that is:

- **Red-capable** — asserts the user’s exact symptom
- **Deterministic** (or high reproduction rate for flakes)
- **Fast** — seconds, not minutes
- **Agent-runnable**

No Phase 2 without that command. If you cannot build a loop: list tries; ask for env access, redacted artifacts, or temporary prod instrumentation — **do not hypothesise**.

## Phase 2 — Reproduce + minimise

Confirm the loop shows the user’s failure mode. Shrink until every remaining element is load-bearing.

## Phase 3 — Hypothesise

Generate **3–5** ranked falsifiable hypotheses (each with a prediction). Show the ranking; do not block if the user is AFK.

## Phase 4 — Instrument

One variable at a time. Prefer debugger/REPL, then targeted logs tagged `[DEBUG-…]`. For performance: measure baseline first; bisect; do not spray logs.

## Phase 5 — Fix + regression

Write a failing regression at a **correct seam** before the fix when a seam exists. If no correct seam, note that after the fix. Apply the fix. Re-run the Phase 1 loop against the original (un-minimised) scenario.

## Phase 6 — Cleanup

- Original loop green
- Regression passes (or missing seam documented)
- Grep out `[DEBUG-…]` instrumentation
- State the winning hypothesis in the commit / PR message

## Closeout

Fresh verification of the original symptom before “fixed.” Then hand back any mixed-turn leftover.
```

- [ ] **Step 2: Commit**

```bash
git add skills/engineering/debug-feedback-loop/SKILL.md
git commit -m "feat(skill): add debug-feedback-loop process skill"
```

---

### Task 7: Catalog sync

**Files:**
- Modify: `README.md`
- Modify: `skills/engineering/README.md`
- Modify: `.claude-plugin/plugin.json`

- [ ] **Step 1: Root README — add under Engineering (after size/shape block)**

```markdown
- **[debug](./skills/engineering/debug/SKILL.md)** — Router for debugging. Use when fixing, debugging, or finding root cause.
- **[debug-root-cause](./skills/engineering/debug-root-cause/SKILL.md)** — Root-cause-first debugging for clear repros, stacks, and failing tests.
- **[debug-feedback-loop](./skills/engineering/debug-feedback-loop/SKILL.md)** — Feedback-loop-first debugging for flaky, unreproducible, recurring, or performance issues.
```

- [ ] **Step 2: Bucket README**

Under **User-invoked**, add:

```markdown
- **[debug-root-cause](./debug-root-cause/SKILL.md)** — Root-cause-first debugging (clear repro / stack / failing test).
- **[debug-feedback-loop](./debug-feedback-loop/SKILL.md)** — Feedback-loop-first debugging (flaky / no repro / perf / recurring).
```

Under **Model-invoked**, add:

```markdown
- **[debug](./debug/SKILL.md)** — Router for debugging and bug fixing.
```

- [ ] **Step 3: Plugin manifest**

Append to the `skills` array:

```json
"./skills/engineering/debug",
"./skills/engineering/debug-root-cause",
"./skills/engineering/debug-feedback-loop"
```

Bump `version` from `0.3.0` to `0.4.0`.

- [ ] **Step 4: Commit**

```bash
git add README.md skills/engineering/README.md .claude-plugin/plugin.json
git commit -m "chore: catalog debug skill family in README and plugin"
```

---

### Task 8: GREEN verification

**Files:**
- Modify: `docs/superpowers/plans/2026-08-20-debug-skill-family-baseline.md` (append GREEN section)
- Modify: `docs/superpowers/specs/2026-08-18-debug-skill-family-design.md` (status → verified)

**Interfaces:**
- Consumes: all three skills + fixture + RED doc

Fresh `generalPurpose` subagents. Instruct each to read `skills/engineering/debug/SKILL.md` first (or the depth skill for direct-invoke scenarios) and follow handoffs. Ban reading the design/plan docs for answers.

- [ ] **Step 1: GREEN A — clear failing test**

Prompt: fix `fixtures/debug-sample/src/total.test.js`; must read `debug` first.  
Pass if: classifies `debug-root-cause`; investigates before editing `total.js`; creates/uses failing test signal; fix makes `node --test fixtures/debug-sample/src/total.test.js` PASS; states root cause (tax on pre-discount).

- [ ] **Step 2: GREEN B — ambiguous**

Prompt: “Checkout totals look wrong sometimes. Help me debug it.” + read `debug` first.  
Pass if: prefers `debug-root-cause` without endless path-asking.

- [ ] **Step 3: GREEN C — flaky / no repro**

Prompt: auth flaky / can’t repro / keeps coming back + read `debug` first.  
Pass if: `debug-feedback-loop`; refuses hypothesis until a red-capable loop exists (or stops asking for env/artifacts).

- [ ] **Step 4: GREEN D — mixed turn**

Prompt: fix debug-sample failure, then add gift-card feature + read `debug` first.  
Pass if: finishes debug path; does **not** implement gift-card in the same turn; hands back.

- [ ] **Step 5: GREEN E — Phase 3 escalate (prompt-only)**

Prompt: you are on `debug-root-cause`; two hypotheses already failed; still no tight signal; what next? Instruct to read `debug-root-cause` only (direct invoke).  
Pass if: reads `../debug/paths.md`; escalates to `debug-feedback-loop` (does not invent a third hypothesis cycle without checking).

- [ ] **Step 6: Append GREEN results to the baseline doc; set design status to verified**

In the design spec header, set:

```markdown
Status: verified (RED baseline + GREEN subagent runs)
```

- [ ] **Step 7: Commit**

```bash
git add docs/superpowers/plans/2026-08-20-debug-skill-family-baseline.md \
  docs/superpowers/specs/2026-08-18-debug-skill-family-design.md
git commit -m "docs: record debug skill family GREEN verification"
```

- [ ] **Step 8: Restore fixture if GREEN A fixed it**

Prefer **keeping the fixture broken** for future baselining. After GREEN A proves the fix in the agent transcript, restore the bug:

```bash
git checkout -- fixtures/debug-sample/src/total.js
```

Document that choice in the GREEN section.

---

## Spec coverage checklist

| Spec requirement | Task |
|---|---|
| `debug` router model-invoked, classify + handoff | 4 |
| `paths.md` classification + escalation single source | 3 |
| Prefer root-cause when ambiguous | 3, 4, 8B |
| `debug-root-cause` four phases + Phase 4 creates regression | 5 |
| Phase 3 escalate-before-retry via `../debug/paths.md` | 5, 8E |
| 3-fix architecture stop after tight signal | 5 |
| Escalate if cannot create regression | 3, 5 |
| `debug-feedback-loop` six phases + loop gate | 6, 8C |
| Sibling handoff / symlink resolve notes | 4, 5 |
| Link-only escalation (no verbatim list in depth skill) | 5 |
| Mixed-turn handback | 4, 5, 6, 8D |
| Fixture `fixtures/debug-sample/` | 1, 8A |
| Catalog README + plugin | 7 |
| RED then GREEN | 2, 8 |

## Self-review notes

- No TBD/placeholder steps; full file bodies included.
- Depth skill descriptions are trigger-only (no phase workflow in YAML).
- Fixture tax bug is deterministic and `node --test`-runnable without deps.
