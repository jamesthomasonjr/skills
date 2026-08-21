# Review Procedure-Letter Findings Implementation Plan

> **For agentic workers:** After plan save, emit workflow outcomes `subagent-driven` or `inline` per human choice; do not hard-code the next skill. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** When a procedure file is in the comparison, an unsatisfiable pair of instructions is a finding — without a new skill, without loosening app-code gates, and without opening plan/spec review.

**Architecture:** `gates.md` stays the authoritative playbook. The same procedure-file letter is copied into `review-defects` so the two files cannot disagree. The router still only classifies. New stored patches under `fixtures/review-sample/` model the Path P2 clash, a procedure nit, README wording, and a plan-only diff.

**Tech Stack:** Agent skills (`gates.md` + `review-defects/SKILL.md`), existing review-sample fixture + new diffs, writing-skills TDD via subagents. Spec: `docs/superpowers/specs/2026-08-21-review-procedure-letters-design.md`.

## Global Constraints

- No new promoted skill. Do not add `review-skill` / `review-brief`. Do not touch `.claude-plugin/plugin.json` or catalog READMEs unless a one-liner is untrue (v1: leave them).
- Router classify table unchanged. Router does not review and does not restate the new rule.
- Do not loosen the six gates for application code.
- Do not open plan/spec review. Plan/spec/design with no procedure diff stays `shape-*`.
- Same letter in `gates.md` and the leaf. Do not paraphrase one into a weaker “prefer.”
- writing-skills TDD: RED against **current** gates/leaf **before** the procedure-file rule exists. Ban `docs/superpowers/**` in RED/GREEN prompts.
- Do not edit live `skills/engineering/size-work/paths.md` to reintroduce the clash. Fixture only.
- Do not open a PR against jeighty/supersuit.
- This change ran on linked supersuit (`~/.cursor/skills` or fallback `~/.cursor/skill-src/supersuit/skills`).

---

## File map

| Path | Responsibility |
|---|---|
| `fixtures/review-sample/procedure/SKILL.md` | Fixture skill; **REQUIRED** to follow `paths.md` |
| `fixtures/review-sample/procedure/paths.md` | Parent playbook (satisfiable) |
| `fixtures/review-sample/procedure/README.md` | Ordinary docs (not procedure) |
| `fixtures/review-sample/procedure/docs/plan.md` | Implementation plan (not procedure) |
| `fixtures/review-sample/changes/procedure-clash.diff` | Unsatisfiable pair in `paths.md` |
| `fixtures/review-sample/changes/procedure-nit.diff` | “could be clearer” only |
| `fixtures/review-sample/changes/readme-wording.diff` | README-only wording |
| `fixtures/review-sample/changes/plan-only.diff` | Plan-only wording; no procedure file |
| `fixtures/review-sample/README.md` | Name the new diffs + expected GREEN |
| `docs/superpowers/plans/2026-08-21-review-procedure-letters-baseline.md` | RED notes + GREEN results |
| `skills/engineering/review-changes/gates.md` | Authoritative procedure-file letter |
| `skills/engineering/review-defects/SKILL.md` | Same letter + rationalizations / Failures / hard rules |

Do not edit `review-changes/SKILL.md` classify table. Do not edit plugin.json or catalog READMEs.

---

### Task 1: Procedure fixtures (exist before RED)

**Files:**
- Create: `fixtures/review-sample/procedure/SKILL.md`
- Create: `fixtures/review-sample/procedure/paths.md`
- Create: `fixtures/review-sample/procedure/README.md`
- Create: `fixtures/review-sample/procedure/docs/plan.md`
- Create: `fixtures/review-sample/changes/procedure-clash.diff`
- Create: `fixtures/review-sample/changes/procedure-nit.diff`
- Create: `fixtures/review-sample/changes/readme-wording.diff`
- Create: `fixtures/review-sample/changes/plan-only.diff`
- Modify: `fixtures/review-sample/README.md`

RED cannot review a change that does not exist. Create the fixture **before** any baseline run. Do **not** edit `gates.md` or `review-defects` in this task.

**Interfaces:**
- Consumes: existing `fixtures/review-sample/` layout (parent + `changes/*.diff`)
- Produces: procedure parent tree + four unified diffs against that parent

- [ ] **Step 1: Write the fixture skill**

```markdown
---
name: shape-sequence
description: >-
  Fixture skill. Shape a sequence inventory. Not a promoted catalog skill.
disable-model-invocation: true
---

# Shape sequence

Turn a description into an inventory, then a Path.

**REQUIRED:** Follow [paths.md](paths.md). Read it before writing Path.

## Hard rules

- Emit inventory titles from this level only.
- Follow [paths.md](paths.md) for Path. Do not invent a second playbook.
```

- [ ] **Step 2: Write the parent `paths.md` (satisfiable)**

```markdown
# Sequence paths

Shared playbook for `shape-sequence`. That skill is **REQUIRED** to follow
this file.

## Critical path

Include every inventory title that actually determines done.
Omit children that do not determine done.

Shared migration stays on the path.

There is no count rule. Do not drop a required child to fit a cap.
Do not add a child to reach a floor.
```

- [ ] **Step 3: Write the fixture README and plan**

`procedure/README.md`:

```markdown
# shape-sequence

Tiny fixture skill used to test procedure-file review.

`paths.md` is the required playbook. This README is ordinary docs.
```

`procedure/docs/plan.md`:

```markdown
# Implementation plan

Add a Path section after the inventory. Keep the existing output order.
```

- [ ] **Step 4: Write `changes/procedure-clash.diff`**

Modeled on the Path P2: “not every child” ban vs “include every determining title / shared migration stays on the path.”

```diff
--- a/procedure/paths.md
+++ b/procedure/paths.md
@@ -6,9 +6,14 @@
 
 ## Critical path
 
+The path is not every child. Do not list every inventory title.
+This is not the priority list.
+
 Include every inventory title that actually determines done.
 Omit children that do not determine done.
 
 Shared migration stays on the path.
 
 There is no count rule. Do not drop a required child to fit a cap.
 Do not add a child to reach a floor.
```

Both letters are in the same file after the patch. A next agent cannot omit a shared-migration child (hard rule) and also obey “not every child / do not list every inventory title” when every remaining title determines done.

- [ ] **Step 5: Write `changes/procedure-nit.diff`**

```diff
--- a/procedure/paths.md
+++ b/procedure/paths.md
@@ -6,6 +6,8 @@
 
 ## Critical path
 
+This section could be clearer about how to phrase titles.
+
 Include every inventory title that actually determines done.
 Omit children that do not determine done.
```

- [ ] **Step 6: Write `changes/readme-wording.diff`**

```diff
--- a/procedure/README.md
+++ b/procedure/README.md
@@ -1,5 +1,5 @@
 # shape-sequence
 
-Tiny fixture skill used to test procedure-file review.
+Tiny fixture skill used to test procedure-file review; the wording here could be tighter.
 
 `paths.md` is the required playbook. This README is ordinary docs.
```

- [ ] **Step 7: Write `changes/plan-only.diff`**

```diff
--- a/procedure/docs/plan.md
+++ b/procedure/docs/plan.md
@@ -1,3 +1,5 @@
 # Implementation plan
 
 Add a Path section after the inventory. Keep the existing output order.
+
+The plan could be clearer about which heading comes first.
```

- [ ] **Step 8: Append to `fixtures/review-sample/README.md`**

After the existing diffs table, add:

```markdown
| `changes/procedure-clash.diff` | `paths.md` “not every child” vs “include every determining title / shared migration stays” | Numbered finding |
| `changes/procedure-nit.diff` | Procedure-file “could be clearer” | `No findings.` |
| `changes/readme-wording.diff` | README-only wording | `No findings.` |
| `changes/plan-only.diff` | Plan-only wording; no procedure file | `shape-*` stop or drop — not a numbered finding |

Procedure parent: `procedure/`. Those diffs are against that tree (`-p1` from `fixtures/review-sample/`). `SKILL.md` and `paths.md` are procedure files. README and `docs/plan.md` are not.
```

- [ ] **Step 9: Confirm diffs apply cleanly (dry-run, then restore)**

```bash
cd fixtures/review-sample
patch -p1 --dry-run < changes/procedure-clash.diff
patch -p1 --dry-run < changes/procedure-nit.diff
patch -p1 --dry-run < changes/readme-wording.diff
patch -p1 --dry-run < changes/plan-only.diff
```

Expected: each reports `patching file` with no fuzz/rejects. Do not leave a patched parent.

- [ ] **Step 10: Commit**

```bash
git add fixtures/review-sample
git commit -m "test(fixtures): add procedure-letter review diffs"
```

---

### Task 2: RED baseline (current gates, no new rule)

**Files:**
- Create: `docs/superpowers/plans/2026-08-21-review-procedure-letters-baseline.md` (after the runs)

**Interfaces:**
- Consumes: Task 1 fixture; **current** `skills/engineering/review-changes/gates.md` and `review-defects/SKILL.md` (no procedure-file rule yet)
- Produces: verbatim drop excuses the GREEN letter must close

Do **not** edit `gates.md` or `review-defects` in this task. If those files already contain the procedure-file rule, **stop** — that is not TDD.

- [ ] **Step 1: Launch four fresh `generalPurpose` subagents in parallel**

Each prompt is the quoted user sentence plus this hard ban (include it verbatim):

```
Read skills/engineering/review-changes/SKILL.md first. Follow it end to end, including sibling handoff (read sibling SKILL.md from that file’s directory, not cwd). Apply gates.md as it exists today.

HARD BAN: Do not read docs/superpowers/**. Do not invent a new skill. Do not edit any files. Stay read-only.
```

Workspace: repo root. `subagent_type`: `generalPurpose`. Wait for results.

**A — procedure clash + thoroughness (the empty-pass case)**

```
Review fixtures/review-sample/changes/procedure-clash.diff against fixtures/review-sample/procedure/. Be thorough. Flag anything the author should fix before this ships. The next agent will follow this playbook.
```

**B — README wording**

```
Review fixtures/review-sample/changes/readme-wording.diff against fixtures/review-sample/procedure/. Flag anything. Nits are fine.
```

**C — app-code clean (regression)**

```
Review fixtures/review-sample/changes/clean-rename.diff against fixtures/review-sample/src/. Be thorough.
```

**D — procedure nit**

```
Review fixtures/review-sample/changes/procedure-nit.diff against fixtures/review-sample/procedure/. Flag anything. Nits are fine. I want a complete review.
```

Optional fifth if capacity: **E — plan-only** `Review this design spec:` then the contents of `fixtures/review-sample/procedure/docs/plan.md` (no code diff, no procedure file in the ask).

- [ ] **Step 2: Score each run**

For A: did they write `No findings.`? Did they name both letters? Which gate did they cite when dropping? Record verbatim (expect gate 5 / “when in doubt, drop” / “do not grill prose”).
For B/D: numbered finding, or drop?
For C: `No findings.` or invented nits?
For E (if run): `shape-*` stop, or grilled the plan?

- [ ] **Step 3: Write the baseline file**

Create `docs/superpowers/plans/2026-08-21-review-procedure-letters-baseline.md` using this shape (fill with real observations; do not leave “TBD”):

```markdown
# Review procedure-letter RED baseline

Date: 2026-08-21
Skills present: current review-changes / review-defects / gates.md **without** the procedure-file rule

Fresh `generalPurpose` subagents. Each prompt included a hard ban on `docs/superpowers/**`. Workspace: skills repo root. Linked supersuit: ~/.cursor/skills (fallback ~/.cursor/skill-src/supersuit/skills). No fixture edits.

## Scenario A — procedure clash

Prompt: (quote)

Observed:
- Said `No findings.`? **Yes/No**
- Named both letters? **Yes/No**
- Drop excuse (verbatim): ...
- Edited files? **Yes/No**

## Scenario B — README wording

...

## Failures this increment must close

Fired:
- ...

Did not fire (still require):
- ...
```

Leave a `## GREEN` stub heading; fill it in Task 5.

- [ ] **Step 4: Commit**

```bash
git add docs/superpowers/plans/2026-08-21-review-procedure-letters-baseline.md
git commit -m "docs: record procedure-letter RED baseline"
```

---

### Task 3: Write the procedure-file letter in `gates.md`

**Files:**
- Modify: `skills/engineering/review-changes/gates.md`

**Interfaces:**
- Consumes: spec “New rule” section; RED drop excuses from Task 2
- Produces: authoritative procedure-file letter. App-code six gates unchanged.

If RED revealed an extra drop excuse, add one suppression or one sentence here — do not wait for the leaf.

- [ ] **Step 1: Append this section to `gates.md` after `## Cite` (keep every existing section)**

Do not change the six-gate list for app code. After the existing body, add exactly:

```markdown
## Procedure files

Only these, and only when they appear in the comparison:

- any `SKILL.md`
- a playbook a `SKILL.md` is **REQUIRED** to follow that is also in the comparison (`gates.md`, `levels.md`, `paths.md`, `modes.md`, and the same pattern: linked from a skill as required)

Not procedure: README, design spec, implementation plan, ordinary docs, comments in app code.

When a procedure file is in the comparison, an **unsatisfiable pair of instructions** is a finding. All six gates can be true:

1. Correctness of the procedure (the next agent cannot follow both letters).
2. Discrete and actionable (name the two letters and the file:line).
3. Introduced by this change.
4. Demonstrable from the procedure text and, if present, fixtures/GREEN that already follow one letter and violate the other. This is the call path. It does not require application runtime.
5. Concrete bad outcome: the next agent does the wrong stop, path, dispatch, empty pass, or drop of a required step. Victim is the next agent, not an end user.
6. The author would probably fix it if they knew.

Still **DROP**: wording nits, missing nice-to-have sections, “could be clearer,” a count band the author kept on purpose when the rest of the letter already agrees, speculative “an agent might misread,” ordinary README/docs prose, plan/spec/design with no procedure diff (still out of family → `shape-*`).

“When in doubt, drop” still applies to app code and to shaky procedure nits. It does **not** authorize dropping a demonstrated unsatisfiable pair in a procedure file.

Do not apply this rule to app-code contradictions unless they already pass today’s six gates the original way.
```

Also amend the opening drop line so it cannot be read as authorizing that drop. Change:

```markdown
Flag a finding only when **all six** are true. If any gate is shaky, **drop**. When in doubt about impact, drop.
```

to:

```markdown
Flag a finding only when **all six** are true. If any gate is shaky, **drop**. When in doubt about impact, drop — except a demonstrated unsatisfiable pair in a procedure file (see Procedure files).
```

Do not rewrite gate 4 or gate 5 in the six-gate list. The procedure-file section is the only place those readings change.

- [ ] **Step 2: Commit**

```bash
git add skills/engineering/review-changes/gates.md
git commit -m "feat(skill): flag unsatisfiable procedure-file pairs"
```

---

### Task 4: Align the leaf so it cannot contradict `gates.md`

**Files:**
- Modify: `skills/engineering/review-defects/SKILL.md`

**Interfaces:**
- Consumes: the same letter as Task 3
- Produces: hard rules / procedure / rationalizations / Failures that agree

Do **not** add a classify table. Do **not** paste a second, different six-gate list.

- [ ] **Step 1: After the existing “Do not paste the six gates…” paragraph, add the same letter**

```markdown
**Procedure files** (same letter as `gates.md`; do not weaken it):

Only these, and only when they appear in the comparison:

- any `SKILL.md`
- a playbook a `SKILL.md` is **REQUIRED** to follow that is also in the comparison (`gates.md`, `levels.md`, `paths.md`, `modes.md`, and the same pattern: linked from a skill as required)

Not procedure: README, design spec, implementation plan, ordinary docs, comments in app code.

When a procedure file is in the comparison, an **unsatisfiable pair of instructions** is a finding. All six gates can be true:

1. Correctness of the procedure (the next agent cannot follow both letters).
2. Discrete and actionable (name the two letters and the file:line).
3. Introduced by this change.
4. Demonstrable from the procedure text and, if present, fixtures/GREEN that already follow one letter and violate the other. This is the call path. It does not require application runtime.
5. Concrete bad outcome: the next agent does the wrong stop, path, dispatch, empty pass, or drop of a required step. Victim is the next agent, not an end user.
6. The author would probably fix it if they knew.

Still **DROP**: wording nits, missing nice-to-have sections, “could be clearer,” a count band the author kept on purpose when the rest of the letter already agrees, speculative “an agent might misread,” ordinary README/docs prose, plan/spec/design with no procedure diff (still out of family → `shape-*`).

“When in doubt, drop” still applies to app code and to shaky procedure nits. It does **not** authorize dropping a demonstrated unsatisfiable pair in a procedure file.

Do not apply this rule to app-code contradictions unless they already pass today’s six gates the original way.
```

- [ ] **Step 2: Amend hard rules and procedure so “do not grill prose” cannot cover procedure files**

Change the plan/spec hard rule to:

```markdown
- If invoked with a plan/spec/design and no procedure file in the comparison: stop. Out of family. Point at `shape-*`. Do not produce findings. Do not grill that prose. A `SKILL.md` or required playbook in the file list is not a plan — inspect it.
```

Change procedure step 3 to:

```markdown
3. Apply every gate in `gates.md` to each candidate. Drop if any is shaky — except a demonstrated unsatisfiable pair in a procedure file. When a procedure file is in the file list, apply the Procedure files letter. Do not require application runtime for that class.
```

Keep “When in doubt, drop” on the intro line, then immediately:

```markdown
When in doubt, drop — except a demonstrated unsatisfiable pair in a procedure file.
```

- [ ] **Step 3: Add rationalization rows and Failures**

Add these rows (plus any verbatim excuse from Task 2 that is not already listed):

```markdown
| “Gate 5 wants a runtime user break” | Procedure victim is the next agent. Wrong stop / path / dispatch / empty pass / dropped step is the outcome. |
| “When in doubt, drop — so drop the clash” | That sentence does not authorize dropping a demonstrated unsatisfiable pair in a procedure file. |
| “Do not grill plan/spec prose, and this is markdown” | README/plan/spec stay out. `SKILL.md` and required playbooks are the product. Inspect them. |
| “An agent might misread this” | Speculative → drop. Two letters that cannot both be followed is not speculative. |
| “Could be clearer / missing a nice-to-have section” | Still a nit. Drop. |
```

Add to Failures:

```markdown
- Dropping a demonstrated unsatisfiable pair in a procedure file
- Treating a `SKILL.md` or required playbook as plan/spec prose
- Requiring application runtime before a procedure-file pair can survive
```

- [ ] **Step 4: Commit**

```bash
git add skills/engineering/review-defects/SKILL.md
git commit -m "fix(skill): keep review-defects aligned with procedure-file gates"
```

---

### Task 5: GREEN verification + baseline GREEN section

**Files:**
- Modify: `docs/superpowers/plans/2026-08-21-review-procedure-letters-baseline.md`

**Interfaces:**
- Consumes: skills from Tasks 3–4, fixture from Task 1, RED notes from Task 2
- Produces: GREEN pass/fail notes; REFACTOR the letter if a loophole fires

- [ ] **Step 1: Confirm fixture parents are unpatched**

```bash
git diff -- fixtures/review-sample/procedure fixtures/review-sample/src
node fixtures/review-sample/src/pricing.test.js
```

Expected: no diff; `pricing.test.js ok`.

- [ ] **Step 2: Launch GREEN subagents** (same A–D prompts as Task 2, **plus** this prefix)

```
Read skills/engineering/review-changes/SKILL.md first. Follow it end to end, including sibling handoff (read sibling SKILL.md from that file’s directory, not cwd). HARD BAN: Do not read docs/superpowers/**. Do not edit any files.
```

Treat each stored diff as the named-patch comparison. Do not require a dirty git tree.

If capacity: also re-run plan-only **E**.

- [ ] **Step 3: Pass criteria**

| Scenario | Pass |
|---|---|
| A | At least one `[P#]` finding. Paragraph names both letters (“not every child” / “do not list every inventory title” **and** “include every determining title” / “shared migration stays”). Cite overlaps `procedure/paths.md` and the new lines. Not `No findings.` |
| B | `No findings.` No numbered README wording finding. No file edits. |
| C | User-facing findings section is exactly `No findings.` No invented app-code nits. |
| D | `No findings.` “could be clearer” is not a numbered finding. |
| E (if run) | `shape-*` stop; no Findings/Assessment/Close envelope; no numbered finding |

If A writes `No findings.`, that is a **failed GREEN**. Do not interpret generously. REFACTOR: add the verbatim excuse to the rationalizations table, then re-run A.

If B or D invents a finding, that is a **failed GREEN**. Tighten DROP. Re-run.

If C invents a finding, the app-code gates were loosened. Revert that loosening.

- [ ] **Step 4: Fill `## GREEN` in the baseline file** with said_no_findings / named_both_letters / edited_files / verbatim, matching the review-family baseline voice.

- [ ] **Step 5: Commit**

```bash
git add docs/superpowers/plans/2026-08-21-review-procedure-letters-baseline.md
git add skills/engineering/review-changes/gates.md skills/engineering/review-defects/SKILL.md
git commit -m "docs: record procedure-letter GREEN results"
```

---

## Self-review

**Spec coverage:** procedure-file definition, same letter in gates + leaf, router unchanged, six-gate readings for procedure pairs, DROP list, app-code not loosened, no new skill, fixture + RED/GREEN, catalog unchanged, supersuit note — each has a task.

**Placeholders:** none. Fixture diffs and skill letters are inlined.

**Type consistency:** empty strings `No findings.` and `Nothing to review.`; stop `shape-*`; procedure files = `SKILL.md` + required playbooks; plugin stays `0.6.0`.
