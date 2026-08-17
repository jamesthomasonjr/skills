# Codebase Orientation Skill Family Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship a read-only Catch Me Up family (`catch-me-up` router + `orient-repo` / `orient-module` / `orient-function`) that briefs a human on a repo, module, or function using the six exploration modes.

**Architecture:** One sequential agent. The router does a cheap path/symbol resolve, classifies onboard vs targeted depth, asks modes only on repo onboard, then hands off to a depth skill that applies lenses from shared `modes.md`. Skills are markdown process docs; the only executable code is a tiny JS fixture used to baseline and verify them.

**Tech Stack:** Agent skills (`SKILL.md` + `modes.md`), this repo’s catalog (`README.md`, `skills/engineering/README.md`, `.claude-plugin/plugin.json`), a Node-free-to-run JavaScript fixture under `fixtures/orient-sample/`. Spec: `docs/superpowers/specs/2026-08-17-codebase-orientation-design.md`.

---

## File map

| Path | Responsibility |
|---|---|
| `fixtures/orient-sample/README.md` | Fixture purpose; checkout journey in one paragraph |
| `fixtures/orient-sample/src/orders.js` | `processOrder` — function-depth target |
| `fixtures/orient-sample/src/server.js` | HTTP `POST /checkout` — Feature Trace entry |
| `fixtures/orient-sample/src/orders.test.js` | Pins `processOrder` edge cases (read, do not require running) |
| `docs/superpowers/plans/2026-08-17-codebase-orientation-baseline.md` | RED notes: verbatim failures from unskilled runs |
| `skills/engineering/catch-me-up/modes.md` | Six lens playbooks (single source) |
| `skills/engineering/catch-me-up/SKILL.md` | Router: resolve, classify, menu/infer, handoff, hand-back |
| `skills/engineering/orient-repo/SKILL.md` | Whole-repo briefing procedure |
| `skills/engineering/orient-module/SKILL.md` | File/module/class briefing procedure |
| `skills/engineering/orient-function/SKILL.md` | Function walkthrough procedure |
| `README.md` | Catalog the four skills |
| `skills/engineering/README.md` | Bucket catalog |
| `.claude-plugin/plugin.json` | Plugin `skills` array |
| `CLAUDE.md` | Task 1: allow `fixtures/`. Task 8: replace the hard 500-line cap |

Do not write `ONBOARDING.md`, `docs/ai/`, learning journals, or inline comments in target repos. This family is read-only.

---

### Task 1: Checked-in fixture (exists before RED)

**Files:**
- Modify: `CLAUDE.md` (one sentence — allow `fixtures/` before any JS is written)
- Create: `fixtures/orient-sample/README.md`
- Create: `fixtures/orient-sample/src/orders.js`
- Create: `fixtures/orient-sample/src/server.js`
- Create: `fixtures/orient-sample/src/orders.test.js`

RED cannot walk a function that does not exist. This fixture is the function-depth and targeted-journey target. Create it **before** any baseline run. Do not create the orientation skills in this task.

`CLAUDE.md` currently says the repo is markdown, scripts inside a skill, and the plugin manifest. Edit that **first** or an implementer following repo rules will refuse or relocate the JS.

- [ ] **Step 0: Allow `fixtures/` in `CLAUDE.md`**

Replace this sentence:

```markdown
This repository is a personal collection of agent skills. Skills are the product. Keep the repo itself small: markdown, optional scripts inside a skill, and the plugin manifest.
```

with:

```markdown
This repository is a personal collection of agent skills. Skills are the product. Keep the repo itself small: markdown, optional scripts inside a skill, the plugin manifest, and `fixtures/` samples used to baseline and verify skills.
```

- [ ] **Step 1: Write the fixture README**

```markdown
# orient-sample

Tiny checkout service used to test the codebase-orientation skill family.

There is one journey: a client `POST`s JSON to `/checkout`, `handleCheckout` in `src/server.js` reads the body, and `processOrder` in `src/orders.js` prices the cart.

This is not a real product. Do not add features during orientation tests.
```

- [ ] **Step 2: Write `processOrder`**

```javascript
// fixtures/orient-sample/src/orders.js
const COUPONS = {
  SAVE10: 0.1,
};

function processOrder(order) {
  if (!order || !Array.isArray(order.items) || order.items.length === 0) {
    throw new Error("order.items must be a non-empty array");
  }

  let subtotal = 0;
  for (const item of order.items) {
    if (typeof item.qty !== "number" || item.qty <= 0) {
      throw new Error("qty must be a positive number");
    }
    if (typeof item.price !== "number" || item.price < 0) {
      throw new Error("price must be a non-negative number");
    }
    subtotal += item.qty * item.price;
  }

  let discount = 0;
  if (order.coupon) {
    const rate = COUPONS[order.coupon];
    if (rate == null) {
      throw new Error("unknown coupon");
    }
    discount = subtotal * rate;
  }

  const total = Math.round((subtotal - discount) * 1.08 * 100) / 100;
  return { subtotal, discount, total };
}

module.exports = { processOrder, COUPONS };
```

- [ ] **Step 3: Write the HTTP entry**

```javascript
// fixtures/orient-sample/src/server.js
const http = require("http");
const { processOrder } = require("./orders");

function handleCheckout(req, res) {
  let raw = "";
  req.on("data", (chunk) => {
    raw += chunk;
  });
  req.on("end", () => {
    try {
      const order = JSON.parse(raw || "{}");
      const result = processOrder(order);
      res.writeHead(200, { "Content-Type": "application/json" });
      res.end(JSON.stringify(result));
    } catch (err) {
      res.writeHead(400, { "Content-Type": "application/json" });
      res.end(JSON.stringify({ error: err.message }));
    }
  });
}

const server = http.createServer((req, res) => {
  if (req.method === "POST" && req.url === "/checkout") {
    handleCheckout(req, res);
    return;
  }
  res.writeHead(404);
  res.end();
});

if (require.main === module) {
  server.listen(3000);
}

module.exports = { handleCheckout, server };
```

- [ ] **Step 4: Write tests that pin edge cases (documentation, not a required runner)**

```javascript
// fixtures/orient-sample/src/orders.test.js
const assert = require("assert");
const { processOrder } = require("./orders");

assert.deepStrictEqual(
  processOrder({ items: [{ sku: "a", qty: 2, price: 10 }] }),
  { subtotal: 20, discount: 0, total: 21.6 }
);

assert.deepStrictEqual(
  processOrder({ items: [{ sku: "a", qty: 2, price: 10 }], coupon: "SAVE10" }),
  { subtotal: 20, discount: 2, total: 19.44 }
);

assert.throws(() => processOrder({ items: [] }), /non-empty/);
assert.throws(() => processOrder({ items: [{ sku: "a", qty: 0, price: 10 }] }), /qty/);
assert.throws(() => processOrder({ items: [{ sku: "a", qty: 1, price: 10 }], coupon: "NOPE" }), /unknown coupon/);

console.log("orders.test.js ok");
```

- [ ] **Step 5: Confirm the fixture is loadable**

Run:

```bash
node fixtures/orient-sample/src/orders.test.js
```

Expected: `orders.test.js ok` and exit 0.

- [ ] **Step 6: Commit**

```bash
git add CLAUDE.md fixtures/orient-sample/README.md fixtures/orient-sample/src/orders.js fixtures/orient-sample/src/server.js fixtures/orient-sample/src/orders.test.js
git commit -m "$(cat <<'EOF'
Add orient-sample fixture for orientation skill baselines.

Allow fixtures/ in repo rules, then give RED a real module, function, and checkout path before any skill files exist.
EOF
)"
```

---

### Task 2: RED baseline (no orientation skills)

**Files:**
- Create: `docs/superpowers/plans/2026-08-17-codebase-orientation-baseline.md`

Do **not** create `skills/engineering/catch-me-up/` or any `orient-*` skill yet. If those directories exist, stop — Task 1 was skipped or skills were written early.

Dispatch four **separate** subagents (`generalPurpose` or `explore`). Each prompt is the entire user message. Do not attach the orientation spec or this plan to those subagents. Do not tell them to be read-only.

Record what they actually did. Copy phrases verbatim into the baseline file.

- [ ] **Step 1: Write the empty baseline log**

```markdown
# Orientation family RED baseline

Date:
Skills present: none (catch-me-up / orient-* must not exist)

## Scenario A — repo onboard (this repo)

Prompt: `Onboard me to this repo. I have 10 minutes. Catch me up so I can contribute today.`

Observed:
- Showed a mode menu? 
- Cited path:line? 
- Dumped the whole tree? 
- Invented architecture? 
- Edited files? 
- Verbatim quotes:

## Scenario B — module (fixture)

Workspace: skills repo root. Prompt: `What does src/orders.js do? Be brief.`

Do not use a bare `orders.js` — a non-recursive glob misses `src/orders.js` and the router treats it as ambiguous. Do not mention `fixtures/orient-sample` in the prompt.

Observed:
- Treated as module/file (exports, imports, important methods)?
- Citations?
- Edited src/orders.js?
- Verbatim quotes:

## Scenario C — function (fixture)

Working directory for this subagent: repo root. Prompt:

`What does processOrder do? Walk me through it step by step, then add a BUY2 coupon while you are in there.`

Observed:
- Resolved processOrder to fixtures/orient-sample/src/orders.js?
- Guessed orient-module / surface briefing that says "name a function"?
- Step-by-step I/O and edge cases from orders.test.js?
- Implemented BUY2 or edited orders.js in the same turn? (failure even if it "handed back" first)
- Verbatim quotes:

## Scenario D — targeted repo journey (fixture)

Workspace: skills repo root. Prompt **exactly**: `How does checkout work?`

Do not mention `fixtures/orient-sample` anywhere in the message. A named directory cheap-resolves to `orient-module` (journey plus a locus). Pathless “how does checkout work?” at repo root is targeted `orient-repo`; Feature Trace can find `/checkout` in the fixture. Architecture may map this skills repo — that is expected, not a fail.

Observed:
- Showed the six-mode menu? (failure if yes — this is targeted repo, not onboard)
- Inferred Feature Trace + Architecture + Testing (no menu)?
- Traced POST /checkout → handleCheckout → processOrder?
- Citations?
- Verbatim quotes:

## Failures this family must close

- 
```

- [ ] **Step 2: Run Scenario A**

Dispatch a subagent with only:

```
Onboard me to this repo. I have 10 minutes. Catch me up so I can contribute today.
```

Workspace: `/Users/james/Code/AI/skills` (or the current repo root).

- [ ] **Step 3: Run Scenario B**

Dispatch a fresh subagent. Workspace: skills repo root. Message is only:

```
What does src/orders.js do? Be brief.
```

- [ ] **Step 4: Run Scenario C**

Dispatch a fresh subagent. Working directory: repo root. Prompt only:

```
What does processOrder do? Walk me through it step by step, then add a BUY2 coupon while you are in there.
```

- [ ] **Step 5: Run Scenario D**

Dispatch a fresh subagent. Workspace: skills repo root. Message is only:

```
How does checkout work?
```

- [ ] **Step 6: Fill the baseline log**

Write the observed answers and a bullet list of failures the skills must prevent. Minimum failures to look for (check each; add others you saw):

- No mode menu on onboard
- No `path:line` citations
- Whole-tree dump
- Invented layers/modules
- Bare name `processOrder` classified as a module without lookup
- Mixed turn implemented `BUY2` in the same turn
- Targeted checkout showed a mode menu or went to `orient-module` because a path was in the prompt
- Edited fixture files

- [ ] **Step 7: Commit the baseline log**

```bash
git add docs/superpowers/plans/2026-08-17-codebase-orientation-baseline.md
git commit -m "$(cat <<'EOF'
Record RED baselines for the orientation skill family.

Capture unskilled failures so the skills close real rationalizations, not guessed ones.
EOF
)"
```

---

### Task 3: Shared mode playbooks

**Files:**
- Create: `skills/engineering/catch-me-up/modes.md`

Write the lenses first. Depth skills will link here and must not redefine when/sample/report.

- [ ] **Step 1: Write `modes.md`**

```markdown
# Catch Me Up modes

Depth skills apply these lenses. Do not rewrite them. Apply only the modes the router selected or inferred. If a mode has no signal, write one line and skip.

## Architecture

**When:** “how is this structured”, repo onboard, first look at a module.

**Sample:** top-level + depth-two; 3–5 key files; entry points and core data types. Skip `node_modules`, vendor, build, `.git`.

**Report:** boundaries, layers, entry points, data-model hierarchy, pattern (layered, modular, MVC, or “flat scripts”), where state lives. Use a table or one small mermaid. Not a file dump.

## Convention

**When:** “what’s the standard”, before writing new code, a module that looks unlike its neighbors.

**Sample:** 3–5 peers of the same kind; linters/formatters/CI; `AGENTS.md` / `CLAUDE.md` / contributing docs if present.

**Report:** naming, folder rules, error-handling style, test layout, do-this / don’t-do-this. Call out violations as observations, not moral failures.

## Feature Trace

**When:** “how does X work”, “walk me through”, a named user journey.

**Sample:** one path, request-in to effect-out. Follow calls. Do not tour siblings.

**Report:** numbered steps with `path:line` at each hop, data in/out at boundaries, where it is stored or returned. One mermaid sequence if the path crosses 3+ files.

## Syntax / API

**When:** unfamiliar idiom, dense function, “what does this API mean”, function-level asks.

**Sample:** the symbol and its public contract; 1–2 call sites; official docs only if the code is not enough.

**Report:** plain-language meaning, inputs, outputs, side effects, edge cases. For a function, this is the `orient-function` walkthrough.

## Testing

**When:** “how is this tested”, function/module briefing, Feature Trace that needs a reality check.

**Sample:** tests that name the unit or the journey; fixtures; mocks/intercepts. Read tests by default. Run them only if the user asks.

**Report:** what is guaranteed, what is mocked, what is not covered.

## History

**When:** “why is it like this”, surprising shape, conflict with current convention.

**Sample:** `git log` / blame on files already in scope (last ~15 commits or the introducing commit), plus a nearby ADR or PR if obvious. Never the whole tree.

**Report:** the decision and the edge case it was solving, in 3–6 bullets.

## Interactions

- Feature Trace may pull Testing for the same path.
- Architecture may pull Convention for “how folders mean things.”
- History never runs unbounded.
```

- [ ] **Step 2: Commit**

```bash
git add skills/engineering/catch-me-up/modes.md
git commit -m "$(cat <<'EOF'
Add Catch Me Up mode playbooks.

Keep the six lenses in one file so depth skills apply them instead of rewriting them.
EOF
)"
```

---

### Task 4: Router skill

**Files:**
- Create: `skills/engineering/catch-me-up/SKILL.md`

Close RED failures: guessing depth for a bare name, skipping the onboard menu, showing a menu on targeted journeys, implementing mixed turns.

- [ ] **Step 1: Write `catch-me-up/SKILL.md`**

```markdown
---
name: catch-me-up
description: >-
  Router for codebase orientation. Use when the user wants to onboard,
  catch me up on a repo, explain a file/module/class/function, walk through
  a symbol, or asks how a feature works. Classifies depth, selects Catch Me Up
  modes, and hands off. Read-only; does not implement.
---

# Catch Me Up

Build the **user’s** mental model. Do not implement. Do not write files.

This skill does **not** produce the briefing and does **not** walk call graphs. Resolve, classify, pick modes, hand off.

Then read the matching depth `SKILL.md` and [modes.md](modes.md) and work as that skill.

## Hard rules

- Read-only. No edits, no inline comments, no onboarding docs, no journals.
- Mixed turn (“explain this, then change it”): the depth skill finishes the briefing, then **hand back**. Do not implement. **Do not edit in this turn even if the user already asked for a change** — that message is the briefing, not an implement go-ahead. They must send a **new message** after the briefing. Do not discard the change request.
- If you cannot point at a claim, say so.

## 1. Cheap resolve

Run a named-target resolve **before** choosing a depth when the user named a symbol or path.

Allowed in **one** pass:

- One path glob for a named file/folder. Search `**/<name>` (e.g. `**/src/orders.js`), not a non-recursive cwd-only `orders.js`.
- One symbol search (exact identifier) for a named `X`.

Not allowed here: reading bodies to explain them, sampling 3–5 key files, git log, following imports.

| Result | Depth |
|---|---|
| Path to a file or directory | `orient-module` |
| Type / class / module symbol | `orient-module` |
| Function or method symbol | `orient-function` |
| Hits of more than one kind | ask once which they meant |
| Journey phrase, no code locus (“how does checkout work?”) | `orient-repo` **targeted** |
| Zero hits, or a bare name you did not resolve | **ambiguous** — ask once for a path, symbol, or depth. Do not guess `orient-module`. |

“What does `X` do?” is not a depth signal. Resolve `X`, then classify.

## 2. Classify

| Signal | Depth |
|---|---|
| “onboard me”, “catch me up on this repo”, “how is this project structured”, no target named | `orient-repo` **onboard** |
| Resolved file, folder, module, or type | `orient-module` |
| Resolved function or method | `orient-function` |
| Journey, no resolved locus | `orient-repo` **targeted** |
| Journey plus a resolved entry module | `orient-module` at that entry; Feature Trace required |
| Ambiguous after resolve | ask once, then continue |

## 3. Modes

Six modes: Architecture, Convention, Feature Trace, Syntax / API, Testing, History.

**Onboard** (`orient-repo` and no target or journey): ask every time:

> Which modes? Architecture / Convention / Feature Trace / Syntax / Testing / History
> (You can pick several. I’ll stay read-only and brief you.)

If they pick Feature Trace and have not named a journey: one top-level listing plus README/manifest glance, **offer** 1–3 candidate entry paths (CLI, HTTP, test runner). Do not walk them.

**Targeted** (named symbol, path, or journey): infer. Do **not** show the menu. User may add modes. User may not turn off a required lens this turn.

| Depth | Inferred modes |
|---|---|
| repo targeted journey | Feature Trace **required, stays on** + Architecture + Testing. Convention / Syntax / History only if asked or needed. |
| module/class/file | Architecture (local) + Convention + Syntax. Feature Trace required and stays on if they asked “how does it work”. Testing/History only if asked or needed. |
| function | Syntax + Testing. History only if the body is otherwise inexplicable. |

## 4. Hand off

Read **sibling** skill files resolved from **this file’s directory**, not from cwd. `../orient-repo/SKILL.md` means “next to this skill,” i.e. the `orient-repo` folder that sits beside `catch-me-up`. After `~/.cursor/skills/<name>` symlink or a plugin copy, `skills/engineering/orient-*/SKILL.md` does not exist.

If a cwd-relative Read of `../orient-repo/SKILL.md` misses (user workspace is a different repo), resolve the sibling from the path you used to open **this** `SKILL.md`, or invoke the depth skill by name.

- [../orient-repo/SKILL.md](../orient-repo/SKILL.md)
- [../orient-module/SKILL.md](../orient-module/SKILL.md)
- [../orient-function/SKILL.md](../orient-function/SKILL.md)
- [modes.md](modes.md)

Pass: depth, target path/symbol, onboard vs targeted, selected/inferred modes, mixed-turn change request if any.

Then follow that depth skill. Do not keep a second briefing procedure here.
```

- [ ] **Step 2: Commit**

```bash
git add skills/engineering/catch-me-up/SKILL.md
git commit -m "$(cat <<'EOF'
Add the catch-me-up orientation router.

Resolve a named symbol before choosing depth, prompt modes only on onboard, and hand off without briefing.
EOF
)"
```

---

### Task 5: `orient-repo`

**Files:**
- Create: `skills/engineering/orient-repo/SKILL.md`

- [ ] **Step 1: Write `orient-repo/SKILL.md`**

```markdown
---
name: orient-repo
description: >-
  Whole-repo orientation briefing. Use when catch-me-up hands off a repo
  onboard or a targeted journey with no code locus, or when the user
  explicitly asks to map project structure, entry points, or architecture.
  Read-only.
disable-model-invocation: true
---

# Orient repo

Read-only briefing of the current workspace. Apply only the modes the router passed. Lenses: [../catch-me-up/modes.md](../catch-me-up/modes.md).

If you were invoked directly with no mode list: treat as **onboard** and ask the six-mode menu before gathering.

## Always gather

Even if only some modes are selected:

1. What the project is (README, manifests, one-line purpose). Prefer code if README conflicts.
2. Directory layout: top-level + depth-two. Skip vendor/build/`.git`.
3. Entry points: main, HTTP, CLI, workers.
4. How to run tests, if obvious from manifests or README.

Do not swallow the repo. Architecture samples **3–5 key files** at top-level + depth-two.

## Hello Interview map (Architecture)

When Architecture is on, fill:

- Entry points
- Key functions (the hard core, not a list of every export)
- Class / data-model hierarchy
- Architectural pattern
- Public interfaces vs internals
- Where state lives
- Existing tests
- Constraints / assumptions in comments or config

## Feature Trace

When Feature Trace is on: follow one path as far as the path needs. Do not detour.

## History

When History is on (including onboard with History and no Feature Trace): `git log` / blame on files **already in the Architecture sample** (the 3–5 key files plus entry points from Always gather). Last ~15 commits or the introducing commit. Not the whole tree. If git is unavailable or the sample has no history, one line and skip.

## Briefing shape

1. Purpose (2–4 sentences)
2. Map (tree or table)
3. Entry points and data flow
4. One section per selected mode
5. Read these next (3–7 pointers with `path:line`)
6. Open questions / unverified claims
7. One close question: go deeper (name a module/function), add a mode, or stop

Cite `path:line` and a short snippet for every non-obvious claim. Tables for surfaces; at most one mermaid for one flow.

## Mixed turn

If the router passed a change request: finish this briefing, then hand back. Do not implement. Do not edit in this turn even if they already asked for a change. They must send a new message after the briefing.

## Failures

- Empty tree: say so and stop.
- Monorepo: stay in the workspace root; say if you only mapped a package.
- Mode has no signal: one line, skip.
```

- [ ] **Step 2: Commit**

```bash
git add skills/engineering/orient-repo/SKILL.md
git commit -m "$(cat <<'EOF'
Add the orient-repo briefing skill.

Map structure and entry points, apply selected Catch Me Up modes, and stay read-only.
EOF
)"
```

---

### Task 6: `orient-module`

**Files:**
- Create: `skills/engineering/orient-module/SKILL.md`

- [ ] **Step 1: Write `orient-module/SKILL.md`**

```markdown
---
name: orient-module
description: >-
  File, module, or class orientation briefing. Use when catch-me-up
  resolves a path or type, or when the user explicitly asks what a
  file/module/class is for and which methods matter. Read-only.
disable-model-invocation: true
---

# Orient module

Read-only briefing of one file, folder, module, or type. Apply only the modes the router passed. Lenses: [../catch-me-up/modes.md](../catch-me-up/modes.md).

If invoked directly with no mode list: infer Architecture (local) + Convention + Syntax. Add Feature Trace if the user asked how it works.

## Always gather

- Path
- Exports / public surface
- Who imports it
- What it imports
- The 3–7 methods or types that do the real work (name and role, not a full walkthrough)

## Lenses at this scope

- Architecture: where it sits in the system
- Convention: match or clash with 3–5 peers
- Feature Trace: one call in, one call out (required if the router said so)
- Syntax: dense APIs
- Testing: how this unit is tested
- History: why this file looks like this (`git log` / blame on this path only)

## Briefing shape

1. One-paragraph purpose
2. Public surface table
3. Important methods (name, role)
4. Collaborators
5. Extra selected modes
6. “If you need a step-by-step, name a function.” (Skip this line if the user already named a function and the router should have sent them to `orient-function` — if that happened, you classified wrong; stop and hand back to `catch-me-up`.)
7. One close question: go deeper, add a mode, or stop

Cite `path:line`. Do not invent a public API. If README and code disagree, prefer code and note it.

## Mixed turn

Finish the briefing, then hand back. Do not implement. Do not edit in this turn even if they already asked for a change. They must send a new message after the briefing.
```

- [ ] **Step 2: Commit**

```bash
git add skills/engineering/orient-module/SKILL.md
git commit -m "$(cat <<'EOF'
Add the orient-module briefing skill.

Explain a file, module, or class surface without walking every function.
EOF
)"
```

---

### Task 7: `orient-function`

**Files:**
- Create: `skills/engineering/orient-function/SKILL.md`

This is the skill that must close Scenario C: resolve `processOrder`, walk I/O and tests, refuse `BUY2`.

- [ ] **Step 1: Write `orient-function/SKILL.md`**

```markdown
---
name: orient-function
description: >-
  Function or method walkthrough. Use when catch-me-up resolves a function
  or method, or when the user asks what a function does step by step,
  including inputs, outputs, side effects, and edge cases. Read-only.
disable-model-invocation: true
---

# Orient function

Read-only walkthrough of **one** function or method. Apply only the modes the router passed. Lenses: [../catch-me-up/modes.md](../catch-me-up/modes.md).

If invoked directly with no mode list: Syntax + Testing.

## Always gather

- Signature
- Callers (1–3)
- Callees
- Pre/post conditions visible in code or tests

## Required walkthrough (Syntax)

1. Inputs — types, invariants, who passes them
2. Steps in order — control flow, not a line-by-line recitation
3. Outputs and side effects
4. Edge cases and error paths from the body **and** tests
5. What it does **not** do

Testing is the check. History only if the body is otherwise inexplicable, and only `git log` / blame on this file.

## Briefing shape

1. Signature + one-sentence purpose
2. I/O table
3. Numbered steps
4. Edge cases
5. Tests that pin this behavior (`path:line`)
6. Related functions (names only, not a module dump)
7. One close question: another function, add a mode, or stop

Cite `path:line` and a short snippet for non-obvious steps. If there are no tests, say so in one line.

## Mixed turn

If the user also asked to change the function (new coupon, extra parameter, “fix it”): finish this walkthrough, then hand back. Do not edit the function **in this turn**, even though they already asked. That message is the briefing. Say orientation is done. They must send a **new message** to implement.
```

- [ ] **Step 2: Commit**

```bash
git add skills/engineering/orient-function/SKILL.md
git commit -m "$(cat <<'EOF'
Add the orient-function walkthrough skill.

Require I/O, control-flow steps, and test-backed edge cases, and refuse to implement mid-briefing.
EOF
)"
```

---

### Task 8: Promote the family and update repo rules

**Files:**
- Modify: `README.md`
- Modify: `skills/engineering/README.md`
- Modify: `.claude-plugin/plugin.json`
- Modify: `CLAUDE.md`

- [ ] **Step 1: Replace the Engineering section in the root README**

In `README.md`, replace:

```markdown
### Engineering

_None yet._
```

with:

```markdown
### Engineering

- **[catch-me-up](./skills/engineering/catch-me-up/SKILL.md)** — Router for codebase orientation. Use when onboarding, catching up on a repo, or asking what a file, class, or function does.
- **[orient-repo](./skills/engineering/orient-repo/SKILL.md)** — Whole-repo map: structure, entry points, architecture, selected Catch Me Up modes.
- **[orient-module](./skills/engineering/orient-module/SKILL.md)** — File, module, or class: purpose, public surface, important methods.
- **[orient-function](./skills/engineering/orient-function/SKILL.md)** — One function or method: step-by-step I/O, side effects, edge cases.
```

- [ ] **Step 2: Replace the Engineering bucket list**

In `skills/engineering/README.md`, replace:

```markdown
## Skills

_None yet._
```

with:

```markdown
## Skills

### User-invoked

- **[orient-repo](./orient-repo/SKILL.md)** — Whole-repo map: structure, entry points, architecture, selected Catch Me Up modes.
- **[orient-module](./orient-module/SKILL.md)** — File, module, or class: purpose, public surface, important methods.
- **[orient-function](./orient-function/SKILL.md)** — One function or method: step-by-step I/O, side effects, edge cases.

### Model-invoked

- **[catch-me-up](./catch-me-up/SKILL.md)** — Router for codebase orientation. Use when onboarding, catching up on a repo, or asking what a file, class, or function does.
```

- [ ] **Step 3: Register plugin paths**

In `.claude-plugin/plugin.json`, replace `"skills": []` with:

```json
  "skills": [
    "./skills/engineering/catch-me-up",
    "./skills/engineering/orient-repo",
    "./skills/engineering/orient-module",
    "./skills/engineering/orient-function"
  ]
```

Keep the rest of the JSON unchanged. Bump `"version"` from `0.1.0` to `0.2.0`.

- [ ] **Step 4: Replace the 500-line hard cap in `CLAUDE.md`**

The `fixtures/` sentence was added in Task 1. Do not revert it. Replace this bullet:

```markdown
- Keep `SKILL.md` under 500 lines; link one level deep to supporting files
```

with:

```markdown
- Split a skill when a file is doing two jobs (procedure vs playbook), not when it crosses a line count. Prefer Superpowers-sized bands (router ~70–160, process ~150–370) but do not truncate procedure to hit a budget. Link one level deep to supporting files.
```

- [ ] **Step 5: Commit**

```bash
git add README.md skills/engineering/README.md .claude-plugin/plugin.json CLAUDE.md
git commit -m "$(cat <<'EOF'
Promote the orientation family and drop the hard 500-line skill cap.

Catalog the four skills and split files by job so procedure is not truncated for a line budget.
EOF
)"
```

---

### Task 9: GREEN re-run (same four prompts, skills loaded)

**Files:**
- Modify: `docs/superpowers/plans/2026-08-17-codebase-orientation-baseline.md` (add a GREEN section)

- [ ] **Step 1: Append a GREEN section to the baseline log**

```markdown
## GREEN

Skills present: catch-me-up, orient-repo, orient-module, orient-function, modes.md

Each GREEN subagent’s **workspace is the skills repo root** (do not set workspace exclusively to `fixtures/orient-sample` — that hides the skills). Load the router from this workspace: `Read skills/engineering/catch-me-up/SKILL.md`.

When the router says `../orient-repo/SKILL.md`, treat that as a sibling of **the router file**, i.e. `Read skills/engineering/orient-repo/SKILL.md`. Same mapping for `../orient-module/SKILL.md`, `../orient-function/SKILL.md`, and `modes.md` → `skills/engineering/catch-me-up/modes.md`. Do not resolve `../orient-repo/SKILL.md` against cwd (repo root or a fixture dir — both miss).

Same four **user** prompts as RED. B names `src/orders.js`. D is exactly `How does checkout work?`. Never put `fixtures/orient-sample` in a GREEN message — the router has no harness exception and will classify that directory as `orient-module`.

GREEN does **not** test model-invocation discovery. It tests compliance once the router file is loaded.

### Scenario A — pass if
- [ ] Asks the six-mode menu before dumping a map
- [ ] Does not edit the repo
- [ ] Cites at least two `path:line` claims
- [ ] Does not list every file in the tree

### Scenario B — user prompt `What does src/orders.js do?` — pass if
- [ ] Treats `src/orders.js` as a module briefing (exports, imports, important methods)
- [ ] Cites `src/orders.js` with line-backed claims
- [ ] Does not edit `src/orders.js`

### Scenario C — pass if
- [ ] Resolves `processOrder` to `fixtures/orient-sample/src/orders.js` (function depth)
- [ ] Walks inputs, steps, outputs, edge cases from the body and `orders.test.js`
- [ ] Does **not** add `BUY2` or edit `orders.js` in the same turn (hand-back text is not enough)
- [ ] Hands back after the briefing

### Scenario D — user prompt `How does checkout work?` (pathless) — pass if
- [ ] Does **not** show the six-mode menu
- [ ] Uses `orient-repo` targeted defaults (Feature Trace required), not `orient-module`
- [ ] Feature Trace finds `/checkout` → `handleCheckout` → `processOrder` with `path:line` (Architecture may map this skills repo)
- [ ] Stays read-only
```

- [ ] **Step 2: Re-run Scenarios A–D**

Dispatch four fresh subagents. Workspace: skills repo root. First lines of each prompt:

```
Read skills/engineering/catch-me-up/SKILL.md and follow it.
When it hands off to ../orient-repo/SKILL.md (or orient-module / orient-function / modes.md), resolve those paths as siblings of that router file: skills/engineering/orient-repo/SKILL.md, skills/engineering/orient-module/SKILL.md, skills/engineering/orient-function/SKILL.md, skills/engineering/catch-me-up/modes.md.
Do not resolve ../orient-repo/SKILL.md against cwd.
```

Then the same user sentence as Task 2 only (`What does src/orders.js do?` / `How does checkout work?`). Do not add a project-under-study line.

- [ ] **Step 3: Mark the GREEN checkboxes**

If any required box fails, do not start Task 10 until you write the missing rule into the specific skill (router vs depth) and re-run **that** scenario only.

- [ ] **Step 4: Commit GREEN notes**

```bash
git add docs/superpowers/plans/2026-08-17-codebase-orientation-baseline.md
git commit -m "$(cat <<'EOF'
Record GREEN pressure results for the orientation family.

Confirm menu, resolve-then-classify, citations, and mixed-turn hand-back against the same prompts as RED.
EOF
)"
```

---

### Task 10: Close leftover rationalizations

**Files:**
- Modify only the skill file that failed GREEN (one of the four `SKILL.md` files or `modes.md`)

Skip this task if Task 9 is all green.

- [ ] **Step 1: For each failed GREEN box, add one explicit counter-rule**

Examples of counters (use only what you observed):

- Still no menu on onboard → in `catch-me-up/SKILL.md`, put the onboard menu in a `HARD-GATE` box: do not read more than README until the user answers.
- Still implemented `BUY2` in the same turn → in `orient-function/SKILL.md`, first line after frontmatter: “If the prompt contains both explain and change, walkthrough only. Any edit in this turn is a failed run. Implement only after a later user message.”
- Still showed a menu on checkout → in `catch-me-up/SKILL.md`, add: “A journey phrase with no path is targeted `orient-repo`. No menu.”

- [ ] **Step 2: Re-run only the failed scenario**

Same prompt as Task 9 for that letter.

- [ ] **Step 3: Commit**

```bash
git add skills/engineering/catch-me-up/SKILL.md skills/engineering/catch-me-up/modes.md skills/engineering/orient-repo/SKILL.md skills/engineering/orient-module/SKILL.md skills/engineering/orient-function/SKILL.md
git commit -m "$(cat <<'EOF'
Close orientation-skill loopholes found in GREEN pressure runs.

Add the specific counters the unskilled-then-skilled loop still failed, not speculative rules.
EOF
)"
```

Only stage files you actually changed.

---

## Spec coverage (self-review)

| Spec requirement | Task |
|---|---|
| Fixture before RED | Task 1 |
| RED without skills; no `orient-repo` as a target | Task 2 (B uses `src/orders.js`, C uses `processOrder`, D is pathless checkout) |
| Sibling handoff resolved from the router file, not cwd | Tasks 4 and 9 |
| History without Feature Trace | Task 5 |
| Same-turn implement forbidden | Tasks 4–7, spec mixed-turn |
| `fixtures/` allowed in repo rules | Task 1 (before JS is written) |
| `modes.md` six lenses | Task 3 |
| Cheap resolve; ambiguous bare names | Task 4 |
| Onboard menu vs targeted infer; Feature Trace stays on | Task 4 |
| Mixed-turn hand-back | Tasks 4–7 |
| `orient-repo` Hello Interview map + sampling | Task 5 |
| `orient-module` surface, not full walkthrough | Task 6 |
| `orient-function` I/O / steps / edge cases / tests | Task 7 |
| Catalog + plugin + CLAUDE.md size rule | Task 8 |
| GREEN same prompts | Task 9 |
| Refactor leftover holes | Task 10 |
| Read-only / no persist / no Socratic / no parallel scouts | Hard rules in Tasks 4–7; no tasks add those features |

No placeholders remain. Names match the spec: `catch-me-up`, `orient-repo`, `orient-module`, `orient-function`, `processOrder`, `handleCheckout`, onboard vs targeted.
