# Specify-Work Family Implementation Plan

> **For agentic workers:** After plan save, emit workflow outcomes `subagent-driven` or `inline` per human choice; do not hard-code the next skill. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Land the specify-work family as an in-progress draft (router + `kinds.md` + three leaves) that splits outcome / class design / stacked-PR plan, and keeps standards out of size-work inventory.

**Architecture:** One sequential agent. Router classifies which document they need and hands off. `kinds.md` is the requirement-vs-standard letter. Leaves each write one document and stop. Skills are markdown process docs. Fixture is a weather thought-process dump plus a parked eval card. Not promoted.

**Tech Stack:** Agent skills (`SKILL.md` + `kinds.md`), in-progress index, tiny markdown fixtures. Spec: `docs/superpowers/specs/2026-08-23-specify-work-family-design.md`.

## Global Constraints

- In-progress draft only. Do **not** add these skills to the root README Skills list, `skills/engineering/README.md`, or `.claude-plugin/plugin.json`. Do **not** bump plugin version (stays `0.6.0`).
- Do **not** edit the size-work family or `shape-story`’s suggested-next list.
- Router is model-invoked (omit `disable-model-invocation`). Leaves are user-invoked (`disable-model-invocation: true`).
- Description: third person; what it does and when to use it. Do not summarize the three output contracts or the `kinds.md` letter in frontmatter (SDO).
- Sibling reads from **this file’s directory**, not cwd.
- Router does **not** write spec/design/plan. Leaves are **REQUIRED** to follow `kinds.md` (link-only; do not paste the letter).
- Not a Superpowers fork. Do not copy brainstorming or writing-plans text, 2–5 minute steps, `docs/superpowers/specs` write-and-commit, or “terminal state is invoke writing-plans.”
- writing-skills TDD: RED baseline **before** any `specify-work` / `write-spec` / `write-design` / `write-plan` / `kinds.md` exists. Ban `docs/superpowers/**` in RED and GREEN prompts.
- Prefer Superpowers-sized bands (router ~70–160, process ~150–370) but do not truncate procedure to hit a budget.
- Conversation-only default. Mixed turn finishes the named leaf and hands back.

---

## File map

| Path | Responsibility |
|---|---|
| `fixtures/specify-work/README.md` | File map only (no GREEN leak) |
| `fixtures/specify-work/weather-dump.md` | Thought-process dump (input for A/E) |
| `fixtures/specify-work/weather-eval.md` | Parked eval card (humans/baseline; GREEN prompts must not open it) |
| `docs/superpowers/plans/2026-08-23-specify-work-family-baseline.md` | RED notes + GREEN results |
| `skills/in-progress/specify-work/kinds.md` | Requirement vs standard letter |
| `skills/in-progress/specify-work/SKILL.md` | Router: classify, announce, hand off |
| `skills/in-progress/write-spec/SKILL.md` | Outcome / In / Out / spikes / labels; stop |
| `skills/in-progress/write-design/SKILL.md` | What vs how; providers; seams; no resize |
| `skills/in-progress/write-plan/SKILL.md` | Stacked-PR units; spike first/separate |
| `skills/in-progress/README.md` | Drafts index |

Do not write application code. Do not open a PR against supersuit.

---

### Task 1: Checked-in fixture (exists before RED)

**Files:**
- Create: `fixtures/specify-work/README.md`
- Create: `fixtures/specify-work/weather-dump.md`
- Create: `fixtures/specify-work/weather-eval.md`

RED cannot fail at auto-continue or SOLID-into-sizing unless there is a weather dump. Create the fixture **before** any baseline run. Do **not** create specify-work skills in this task. Do **not** leak expected GREEN into the README or the dump.

**Interfaces:**
- Consumes: nothing
- Produces: dump (input) + parked eval (expected grain). Dump must include MVP, how, classes, stacked PRs, later ISP — so a mega-skill is tempted to emit all three.

- [ ] **Step 1: Write the fixture README (file map only)**

```markdown
# specify-work

Thought-process dump used to test the specify-work draft family.

Treat `weather-dump.md` as the user message. Do not treat the skills
repo, `docs/superpowers/`, or `weather-eval.md` as the product.

| Path | What it is |
|---|---|
| `weather-dump.md` | User thought process (input) |
| `weather-eval.md` | Parked eval card (not input) |
```

- [ ] **Step 2: Write `weather-dump.md`**

Use the five-part thought process from the spec. Do not label which leaf owns which part. Do not say “this is a feature” or “one story.”

- [ ] **Step 3: Write `weather-eval.md`**

Parked card from the spec table (feature / one story / Path that story / Parallel none / API spike separate / classes after grain).

- [ ] **Step 4: Commit**

```bash
git add fixtures/specify-work
git commit -m "test: add specify-work weather fixture"
```

---

### Task 2: RED baseline (skills must not exist)

**Files:**
- Create: `docs/superpowers/plans/2026-08-23-specify-work-family-baseline.md` (RED section only)

**Interfaces:**
- Consumes: `fixtures/specify-work/weather-dump.md`
- Produces: verbatim RED notes. Expected failures: auto-continue spec→design→plan, and/or SOLID/stacked PRs/classes treated as sizing inventory.

- [ ] **Step 1: Confirm skills are absent**

```bash
test ! -e skills/in-progress/specify-work/SKILL.md
test ! -e skills/in-progress/write-spec/SKILL.md
```

- [ ] **Step 2: Run two fresh `generalPurpose` subagents in parallel**

Ban: `docs/superpowers/**`; do not invent `specify-work` / `write-spec` / `write-design` / `write-plan`. Workspace: repo root.

**RED-1 — weather dump, Superpowers-shaped specify+plan**

Prompt: read `fixtures/specify-work/weather-dump.md`. Spec this, design the classes, and write the implementation plan in this turn. You may use brainstorming / writing-plans if they apply.

Watch for: auto-continue; classes in the spec; committed spec file; 2–5 minute steps; invoking writing-plans after design.

**RED-2 — weather dump, size this (SOLID pressure)**

Prompt: read the dump. Size this work. ISP, SOLID, and stacked PRs are required. Break it into the inventory we should build.

Watch for: class/provider children; SOLID/stacked PRs as inventory; grain bump to epic; multi-day in inventory.

- [ ] **Step 3: Write the RED section of the baseline** (observed behavior, verbatim quotes, which failures fired)

- [ ] **Step 4: Commit**

```bash
git add docs/superpowers/plans/2026-08-23-specify-work-family-baseline.md
git commit -m "docs: record specify-work RED baseline"
```

---

### Task 3: Playbook `kinds.md`

**Files:**
- Create: `skills/in-progress/specify-work/kinds.md`

**Interfaces:**
- Consumes: spec letter
- Produces: authoritative requirement vs standard; class-list rule; spike rule; rationalizations; failures. Leaves REQUIRED to follow this file.

- [ ] **Step 1: Write `kinds.md`** (see spec **Playbook**. If wording conflicts with a SKILL.md summary, this file wins.)

Must include: requirement vs standard table; “never bump feature to epic”; “never inventory children”; size-work still refuses a class list; class lists are design; open decisions are spikes / `shape-task`.

- [ ] **Step 2: Commit**

```bash
git add skills/in-progress/specify-work/kinds.md
git commit -m "feat: add specify-work kinds letter"
```

---

### Task 4: Router `specify-work`

**Files:**
- Create: `skills/in-progress/specify-work/SKILL.md`

**Interfaces:**
- Consumes: `kinds.md`
- Produces: classify table, announce, sibling handoff. Does not write spec/design/plan. Does not size.

- [ ] **Step 1: Write the router** (see spec **Router**). Model-invoked. REQUIRED read `kinds.md` before classify. Sibling paths: `../write-spec/SKILL.md`, `../write-design/SKILL.md`, `../write-plan/SKILL.md`. Class-list-first → stop, point at write-spec → size-work. Out of family → size-work / other families. Mixed turn: pass through, leaf hands back.

- [ ] **Step 2: Commit**

```bash
git add skills/in-progress/specify-work/SKILL.md
git commit -m "feat: add specify-work router"
```

---

### Task 5: Leaf `write-spec`

**Files:**
- Create: `skills/in-progress/write-spec/SKILL.md`

**Interfaces:**
- Consumes: `../specify-work/kinds.md`
- Produces: Outcome; MVP In; Later-features Out; Open decisions; Standards as labels; Close announces size-work and **stops**.

- [ ] **Step 1: Write the leaf.** `disable-model-invocation: true`. REQUIRED kinds.md. Separate a dumped thought process. Questions only if one outcome is still foggy. No classes, Path, plan, auto-continue, or invoke of size-work / write-design / write-plan.

- [ ] **Step 2: Commit**

```bash
git add skills/in-progress/write-spec/SKILL.md
git commit -m "feat: add write-spec leaf"
```

---

### Task 6: Leaf `write-design`

**Files:**
- Create: `skills/in-progress/write-design/SKILL.md`

**Interfaces:**
- Consumes: `../specify-work/kinds.md`
- Produces: What / How / Later-feature seams / Close. Requires grain. No resize. No plan unless new message.

- [ ] **Step 1: Write the leaf.** `disable-model-invocation: true`. If classes arrive before sizing, stop and point at write-spec → size-work. ISP seams are notes, not inventory.

- [ ] **Step 2: Commit**

```bash
git add skills/in-progress/write-design/SKILL.md
git commit -m "feat: add write-design leaf"
```

---

### Task 7: Leaf `write-plan`

**Files:**
- Create: `skills/in-progress/write-plan/SKILL.md`

**Interfaces:**
- Consumes: `../specify-work/kinds.md`
- Produces: Spike first/separate as `shape-task`; stacked PRs (interface + impl + tests + mock for dependents); Close. No 2–5 minute step list as the contract. No grain bump. No implement.

- [ ] **Step 1: Write the leaf.** `disable-model-invocation: true`. Unit of work is a stacked PR, not a Superpowers 2–5 minute step.

- [ ] **Step 2: Commit**

```bash
git add skills/in-progress/write-plan/SKILL.md
git commit -m "feat: add write-plan leaf"
```

---

### Task 8: In-progress index

**Files:**
- Modify: `skills/in-progress/README.md`

**Interfaces:**
- Consumes: the four skill dirs
- Produces: drafts index. Keep this file a drafts index. Do not promote.

- [ ] **Step 1: Replace `_None yet._` with the family (router + three leaves + playbook note)**

- [ ] **Step 2: Confirm promoted catalog unchanged**

```bash
git diff main -- README.md skills/engineering/README.md .claude-plugin/plugin.json
# expected: empty
```

- [ ] **Step 3: Commit**

```bash
git add skills/in-progress/README.md
git commit -m "docs: index specify-work draft in in-progress"
```

---

### Task 9: GREEN A–F

**Files:**
- Modify: `docs/superpowers/plans/2026-08-23-specify-work-family-baseline.md`

Fresh `generalPurpose` subagents. Ban `docs/superpowers/**` and `fixtures/specify-work/weather-eval.md`. Instruct each to read the named in-progress skill first.

- [ ] **A:** weather dump → write-spec only (Out = URL + multi-day; standards labeled; classes absent; stops; points at size-work)
- [ ] **B:** write-spec output + size-work `levels.md` → would be feature / one story / Path that story / Parallel none / API spike separate. Do not implement size-work. Spec is not an epic or class inventory.
- [ ] **C:** write-design after that grain → providers/ISP seams; no multi-day in inventory; no resize
- [ ] **D:** write-plan → stacked-PR units; spike first/separate; no 2–5 minute contract; no grain bump
- [ ] **E:** class list as first ask → not inventory; points at write-spec → size-work
- [ ] **F:** plan-only or design-only after grain → correct leaf, not write-spec

- [ ] **Step 7: Record GREEN in the baseline and commit**

```bash
git add docs/superpowers/plans/2026-08-23-specify-work-family-baseline.md
git commit -m "docs: record specify-work GREEN A-F"
```

---

## Self-review

1. **Spec coverage:** Placement, kinds letter, four skills, weather grain, TDD A–F, no promotion, no size-work edit — each has a task.
2. **Placeholder scan:** none.
3. **Type consistency:** sibling paths `../write-*/SKILL.md` and `../specify-work/kinds.md` match the directory layout.

## Execution

This session executes **inline** (no follow-ups). RED before skills. GREEN after skills. PR against main; title says in-progress / draft.
