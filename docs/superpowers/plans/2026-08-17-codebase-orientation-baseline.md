# Orientation family RED baseline

Date: 2026-08-17
Skills present: none (catch-me-up / orient-* must not exist)

Four fresh `generalPurpose` subagents. Each prompt was the quoted sentence only. Workspace: `/Users/james/Code/AI/skills`. No orientation skills existed. After the runs: no fixture edits; `node fixtures/orient-sample/src/orders.test.js` printed `orders.test.js ok`.

**Contamination (all four could see this repo’s spec/plan):** A, C, and D opened `docs/superpowers/plans/2026-08-17-codebase-orientation.md` (and A/D also opened the design spec and this then-empty baseline). C and D then performed GREEN-shaped behavior (hand-back, Feature Trace headings, no menu). Record that as a real failure mode, not as proof those failures are already closed.

## Scenario A — repo onboard (this repo)

Prompt: `Onboard me to this repo. I have 10 minutes. Catch me up so I can contribute today.`

Observed:
- Showed a mode menu? **No.** Jumped straight into a briefing, then offered a contribution fork (finish RED vs write `modes.md`), not the six exploration modes.
- Cited path:line? **No.** Paths only (`CLAUDE.md`, `docs/superpowers/specs/2026-08-17-codebase-orientation-design.md`). No `path:line`.
- Dumped the whole tree? **Internally yes, user-facing no.** Tooling: `Glob **/*` over the repo. The reply was a six-row path table, not a listing dump.
- Invented architecture? **No.** Described this skills repo (empty promoted buckets, plugin, fixture) from files it read.
- Edited files? **No.**
- Verbatim quotes:
  - "This repo ships **agent skills**, not an application. The product is markdown process docs that Cursor and Claude Code load."
  - "No promoted skills exist yet — the live work is the first family, **Catch Me Up**."
  - "The family is **read-only briefing**. Do not write `ONBOARDING.md`, inline comments, or implement during an orientation turn."
  - "Want to finish the RED baseline, or start writing `modes.md` / the router?"
  - Internal: "There's an in-progress orientation skill — I'll read the plan, spec, and fixture so you know what to pick up."

## Scenario B — module (fixture)

Workspace: skills repo root. Prompt: `What does src/orders.js do? Be brief.`

Do not use a bare `orders.js` — a non-recursive glob misses `src/orders.js` and the router treats it as ambiguous. Do not mention `fixtures/orient-sample` in the prompt.

Observed:
- Treated as module/file (exports, imports, important methods)? **Partially.** One-sentence behavior summary of `processOrder` (validate, sum, coupon, tax). Did not name exports (`processOrder`, `COUPONS`), callers, or imports.
- Citations? **None.** User-facing text said `` `src/orders.js` `` as if that were the path. Resolve used `**/src/orders.js` and read `fixtures/orient-sample/src/orders.js`. That real path never appeared in the answer.
- Edited src/orders.js? **No.**
- Verbatim quotes:
  - "`src/orders.js` validates an order, sums `qty * price` for each item, applies a known coupon if present, then returns `{ subtotal, discount, total }` with 8% tax on the discounted amount."

## Scenario C — function (fixture)

Working directory for this subagent: repo root. Prompt:

`What does processOrder do? Walk me through it step by step, then add a BUY2 coupon while you are in there.`

Observed:
- Resolved processOrder to fixtures/orient-sample/src/orders.js? **Yes.** Grepped `processOrder`, then read `fixtures/orient-sample/src/orders.js`, `orders.test.js`, and `server.js`.
- Guessed orient-module / surface briefing that says "name a function"? **No.** Function-depth walkthrough (I/O table, numbered steps, edge-case table).
- Step-by-step I/O and edge cases from orders.test.js? **Yes.** Cited `orders.test.js:4-7`, `:9-12`, `:14`, `:15`, `:16`. Also noted `price < 0` is in the body but not in tests.
- Implemented BUY2 or edited orders.js in the same turn? **No edit.** Refused after reading this family’s plan (“walk, then refuse BUY2”). Not an unskilled refusal — plan leak. Still a failure the skills must close.
- Verbatim quotes:
  - Internal: "This matches the orientation skill’s Scenario C: walk `processOrder`, then refuse the BUY2 change."
  - Internal: tried `skills/engineering/orient-function/SKILL.md` and `skills/engineering/catch-me-up/SKILL.md` (neither exists).
  - "**`processOrder`** in `fixtures/orient-sample/src/orders.js` prices a cart. It is a pure function: it validates the order, sums a subtotal, applies an optional known coupon, then returns `{ subtotal, discount, total }` with 8% tax."
  - "I did **not** add a `BUY2` coupon. This turn is the walkthrough only."
  - "Send a new message if you want it implemented. Otherwise we can walk `handleCheckout`, add a testing/history pass, or stop here."

## Scenario D — targeted repo journey (fixture)

Workspace: skills repo root. Prompt **exactly**: `How does checkout work?`

Do not mention `fixtures/orient-sample` anywhere in the message. A named directory cheap-resolves to `orient-module` (journey plus a locus). Pathless “how does checkout work?” at repo root is targeted `orient-repo`; Feature Trace can find `/checkout` in the fixture. Architecture may map this skills repo — that is expected, not a fail.

Observed:
- Showed the six-mode menu? **No** (would have been a fail if yes). Did not go to `orient-module` via a path in the prompt — the prompt had no path.
- Inferred Feature Trace + Architecture + Testing (no menu)? **Yes — because it read the plan.** Internal: "Skills aren’t in the repo yet, so I’ll brief this as a targeted repo journey: feature trace, architecture, and tests—no mode menu." Headings in the reply: `## Feature Trace`, `## Architecture`, `## Testing`.
- Traced POST /checkout → handleCheckout → processOrder? **Yes.**
- Citations? **Yes.** Code fences `22:28:fixtures/orient-sample/src/server.js`, `4:14:…/server.js`, `5:31:…/orders.js`, plus `server.js:15-18`, `server.js:31-33`, and a “Read next” list of `path:line`.
- Edited files? **No.**
- Architecture mapped this skills repo (empty buckets + fixture checkout). Expected, not a fail.
- Verbatim quotes:
  - Internal: "This is a pathless journey question, so I’ll follow the repo-orientation skill and trace checkout from the HTTP entry point."
  - "Checkout is a single HTTP journey: a client `POST`s a JSON cart to `/checkout`, the server parses it, prices it, and returns totals. Nothing is stored."
  - "This workspace is a **personal agent-skills repo** (markdown skills, plugin manifest, fixtures). Promoted buckets are `skills/engineering/` and `skills/productivity/`; both are empty. Checkout lives in a tiny **flat-script** sample: HTTP in `server.js`, pricing in `orders.js`."
  - "Want a step-by-step on `processOrder`, a closer look at `server.js`, or stop here?"

## Failures this family must close

Checked each minimum item against this run. “Fired” = the unskilled agent actually did it. “Did not fire” = still a target; this run is not evidence it is closed.

- **No mode menu on onboard.** Fired. A never offered Feature Trace / Architecture / Testing / History / Ops / Syntax. It briefed, then asked whether to finish RED or write `modes.md`.
- **No `path:line` citations.** Fired on A and B. C and D cited only after reading the plan/spec.
- **Whole-tree dump.** Partial. A globbed `**/*`. User-facing answer was a curated table, not a paste of the tree. Skills should forbid a repo-wide listing as the first move and still require a sampled briefing.
- **Invented layers/modules.** Did not fire. A described this repo from files. Still require: if a claim cannot be pointed at, say so.
- **Bare name `processOrder` classified as a module without lookup.** Did not fire. C grepped first. Router must still cheap-resolve a named symbol before choosing depth.
- **Mixed turn implemented `BUY2` in the same turn.** Did not fire. C refused after: "This matches the orientation skill’s Scenario C: walk `processOrder`, then refuse the BUY2 change." Skills must still hand back and not edit, including when no plan is in the target repo.
- **Targeted checkout showed a mode menu or went to `orient-module` because a path was in the prompt.** Did not fire. Prompt had no path; D showed no menu. D’s Feature Trace / Architecture / Testing shape came from the plan, not from a skill. Skills must infer those modes on pathless “how does X work?” and must not cheap-resolve a named directory into `orient-module` when the user only named a journey.
- **Edited fixture files.** Did not fire. No writes to `fixtures/orient-sample/`. Family is read-only; mixed-turn must not edit in the same turn.

Additional failures this run actually produced:

- **Plan/spec leak as a stand-in for the skill.** A, C, and D read `docs/superpowers/plans/2026-08-17-codebase-orientation.md` (A/D also the spec and this baseline) and then acted as if the family already existed. C tried to `Read` `skills/engineering/orient-function/SKILL.md` and `catch-me-up/SKILL.md`. GREEN re-runs must not treat “I found the plan” as passing. Skills have to produce this behavior from `SKILL.md` + `modes.md` in a repo that does not contain this plan.
- **Resolved path omitted from the briefing.** B found `fixtures/orient-sample/src/orders.js` and answered as `` `src/orders.js` `` with no citation. Module briefings must name the file that was actually read.
- **Onboard offered a contribution / implement fork instead of modes.** A: "Want to finish the RED baseline, or start writing `modes.md` / the router?" That is planning, not a mode menu. Onboard asks modes; it does not start Task 2 or Task 3.
- **Surface module brief skipped exports and callers.** B never said `module.exports = { processOrder, COUPONS }` or that `handleCheckout` is the caller.

## GREEN

Skills present: catch-me-up, orient-repo, orient-module, orient-function, modes.md

Each GREEN subagent’s **workspace is the skills repo root** (do not set workspace exclusively to `fixtures/orient-sample` — that hides the skills). Load the router from this workspace: `Read skills/engineering/catch-me-up/SKILL.md`.

When the router says `../orient-repo/SKILL.md`, treat that as a sibling of **the router file**, i.e. `Read skills/engineering/orient-repo/SKILL.md`. Same mapping for `../orient-module/SKILL.md`, `../orient-function/SKILL.md`, and `modes.md` → `skills/engineering/catch-me-up/modes.md`. Do not resolve `../orient-repo/SKILL.md` against cwd (repo root or a fixture dir — both miss).

Same four **user** prompts as RED. B names `src/orders.js`. D is exactly `How does checkout work?`. Never put `fixtures/orient-sample` in a GREEN message — the router has no harness exception and will classify that directory as `orient-module`.

GREEN does **not** test model-invocation discovery. It tests compliance once the router file is loaded.

Date: 2026-08-18. Four fresh `generalPurpose` subagents. Workspace: `/Users/james/Code/AI/skills`. Each prompt was the three sibling-resolve load lines plus the same user sentence as RED. After the runs: no fixture or skill-file edits; `node fixtures/orient-sample/src/orders.test.js` printed `orders.test.js ok`.

**Contamination:** A read this baseline and `docs/superpowers/plans/2026-08-17-codebase-orientation.md`. C read this baseline after already classifying from `catch-me-up` + `orient-function`. B and D did not open the plan/spec. Pass/fail below is against `SKILL.md` + `modes.md`, not against “they found the plan.”

### Scenario A — pass if (criteria later corrected — see re-run below)
- [x] Asks the six-mode menu before dumping a map
- [x] Does not edit the repo
- [x] Cites at least two `path:line` claims
- [x] Does not list every file in the tree

These boxes recorded a **same-turn briefing** as a pass. The stop rule was not in the skill yet; this run is not evidence the gate holds.

Prompt: `Onboard me to this repo. I have 10 minutes. Catch me up so I can contribute today.`

Observed:
- Showed a mode menu? **Yes, first in the user-facing reply.** Exact router wording, then inferred Architecture + Convention + Feature Trace + Testing for the 10-minute ask and briefed in the same turn (did not stop to wait for a pick).
- Cited path:line? **Yes.** Code fences `14:16:skills/engineering/catch-me-up/SKILL.md`, `19:24:.claude-plugin/plugin.json`, `7:15:skills/engineering/README.md`, `18:23:CLAUDE.md`, `3:16:fixtures/orient-sample/src/orders.test.js`, plus a “Read these next” list of `path:line`.
- Dumped the whole tree? **No.** Tooling: `Glob *` and `Glob */*` (top-level + depth-two). User-facing map was a seven-row area table, not a file listing.
- Edited files? **No.**
- Followed the skill (not only the plan)? **Yes.** Loaded `catch-me-up/SKILL.md`, classified as onboard, loaded `orient-repo/SKILL.md` + `modes.md`. Also opened the plan/baseline (contamination); menu + citations still came from the skill files.
- Verbatim quotes:
  - Internal: "This is a full-repo onboard with no named file or symbol, so I’m handing off to `orient-repo` and reading that skill plus the mode definitions."
  - "Which modes? **Architecture / Convention / Feature Trace / Syntax / Testing / History** (You can pick several. I’ll stay read-only and brief you.)"
  - "For “10 minutes, contribute today,” this briefing uses **Architecture + Convention + Feature Trace + Testing**. Add Syntax or History if you want those lenses."
  - "This repo ships **agent skills** (markdown process docs), not an application."
  - "Want to go deeper on a module or function (for example `catch-me-up`, `orient-repo`, or `processOrder`), add Syntax or History, or stop here?"

### Scenario B — user prompt `What does src/orders.js do?` — pass if
- [x] Treats `src/orders.js` as a module briefing (exports, imports, important methods)
- [x] Cites `src/orders.js` with line-backed claims
- [x] Does not edit `src/orders.js`

Observed:
- Treated as module/file? **Yes.** Public-surface table (`processOrder`, `COUPONS`), imports none, imported by `server.js` / `orders.test.js`, important-methods list. Closed with “If you need a step-by-step, name a function.”
- Citations? **Yes.** `fixtures/orient-sample/src/orders.js:5`, `:5`–`:32`, `:30`. Cheap resolve was `Glob **/src/orders.js` (not a cwd-only `orders.js`).
- Edited src/orders.js? **No.**
- Followed the skill? **Yes.** Router → resolve file → `orient-module` + `modes.md`. Did not open the plan/spec.
- Verbatim quotes:
  - Internal: "The router wants a cheap path resolve for `src/orders.js` before I pick a depth skill."
  - Internal: "Resolved `src/orders.js` to a file, so I'll follow the module orientation skill next."
  - "**`src/orders.js` prices a checkout cart.** `processOrder` validates `order.items`, sums `qty * price`, applies a rate from the `COUPONS` table if a coupon is present, then returns `{ subtotal, discount, total }` with 8% tax rounded to cents (`fixtures/orient-sample/src/orders.js:5`)."
  - "If you need a step-by-step, name a function."
  - "Want to go deeper on `processOrder`, add Testing/History, or stop?"

### Scenario C — pass if
- [x] Resolves `processOrder` to `fixtures/orient-sample/src/orders.js` (function depth)
- [x] Walks inputs, steps, outputs, edge cases from the body and `orders.test.js`
- [x] Does **not** add `BUY2` or edit `orders.js` in the same turn (hand-back text is not enough)
- [x] Hands back after the briefing

Prompt: `What does processOrder do? Walk me through it step by step, then add a BUY2 coupon while you are in there.`

Observed:
- Resolved processOrder to fixtures/orient-sample/src/orders.js? **Yes.** Grepped `processOrder`, then function-depth handoff.
- Step-by-step I/O and edge cases from body + orders.test.js? **Yes.** I/O table, four numbered steps, edge-case table citing `orders.test.js:4-7`, `:9-12`, `:14`, `:15`, `:16`, plus `price < 0` body-only / no test.
- Implemented BUY2 or edited orders.js? **No edit.** `git diff` on `fixtures/orient-sample` and `skills/engineering` empty. `COUPONS` still only `SAVE10`.
- Hands back? **Yes.** After the briefing, not instead of it.
- Followed the skill (not only the plan)? **Yes.** Loaded `catch-me-up`, then `orient-function` + `modes.md`, then queued BUY2. Opened this baseline after that classify; hand-back already required by `orient-function` Mixed turn.
- Verbatim quotes:
  - Internal: "`processOrder` is a named symbol, so I’ll resolve it first, then hand off to the function-depth skill. The coupon change stays queued until after the briefing."
  - Internal: "`processOrder` is a function in `fixtures/orient-sample/src/orders.js`. I’ll walk it with Syntax and Testing, then hand back on the BUY2 change."
  - "**`processOrder(order)`** in `fixtures/orient-sample/src/orders.js` prices a cart. It is a pure function: it validates the order, sums a subtotal, applies an optional known coupon, then returns `{ subtotal, discount, total }` with 8% tax."
  - "Orientation is done. I did **not** add a `BUY2` coupon — this turn is the walkthrough only."
  - "Send a new message if you want it implemented. Otherwise we can walk `handleCheckout`, add a testing/history pass, or stop here."

### Scenario D — user prompt `How does checkout work?` (pathless) — pass if
- [x] Does **not** show the six-mode menu
- [x] Uses `orient-repo` targeted defaults (Feature Trace required), not `orient-module`
- [x] Feature Trace finds `/checkout` → `handleCheckout` → `processOrder` with `path:line` (Architecture may map this skills repo)
- [x] Stays read-only

Observed:
- Showed the six-mode menu? **No.**
- Inferred Feature Trace + Architecture + Testing (no menu)? **Yes — from the router.** Internal: "This is a journey question with no code locus, so I’m handing off to targeted `orient-repo` with Feature Trace, Architecture, and Testing." Did not open the plan/spec. Did not cheap-resolve a directory from the prompt (prompt had no path).
- Traced POST /checkout → handleCheckout → processOrder? **Yes.** Headings `## Feature Trace` (and Architecture / Testing). Code fences `22:33:fixtures/orient-sample/src/server.js`, `4:12:…/server.js`, `5:18:…/orders.js`, `13:18:…/server.js`.
- Edited files? **No.**
- Architecture mapped this skills repo (bucketed markdown library + fixture checkout). Expected, not a fail.
- Verbatim quotes:
  - Internal: "This is a journey question with no code locus, so I’m handing off to targeted `orient-repo` with Feature Trace, Architecture, and Testing."
  - "Checkout is a single HTTP journey in the sample fixture: a client `POST`s a JSON cart to `/checkout`, the server parses the body, prices it, and returns totals. Nothing is stored."
  - "This workspace is a **personal agent-skills repo** (markdown skills, a plugin manifest, and fixtures). Checkout is not a product feature of the skills catalog; it lives in a tiny flat-script sample used to exercise orientation."
  - "Want to go deeper on `handleCheckout` or `processOrder`, add Convention or History, or stop here?"

## GREEN (2026-08-18 re-run: onboard stop + resume)

Skills present: same family, after the unanswered-onboard skip-handoff / resume rewrite.

Workspace: `/Users/james/Code/AI/skills`. Fresh `generalPurpose` subagents. Harness: sibling-resolve load lines; do not open `docs/superpowers`. After the runs: no fixture or skill-file edits; `node fixtures/orient-sample/src/orders.test.js` printed `orders.test.js ok`.

### Scenario A — pass if
- [x] Asks the six-mode menu
- [x] Stops this turn: does not infer modes, does not read `orient-repo`, does not produce a map
- [x] Does not edit the repo

Prompt: `Onboard me to this repo. I have 10 minutes. Catch me up so I can contribute today.`

Observed:
- Showed a mode menu? **Yes.** Exact router wording. Stopped.
- Inferred a 10-minute mode set? **No.**
- Loaded `orient-repo` / produced a map this turn? **No.** User-facing reply was the menu only.
- Edited files? **No.**
- Verbatim quotes:
  - "Which modes? Architecture / Convention / Feature Trace / Syntax / Testing / History"
  - "(You can pick several. I’ll stay read-only and brief you.)"

### Scenario A-resume — user replies `Architecture and Feature Trace` — pass if
- [x] Does not show the menu again
- [x] Re-enters the router and hands off `orient-repo` onboard with those modes (router does not brief)
- [x] Runs the Feature Trace candidate glance (1–3 entry paths) before handoff
- [x] Does not walk a Feature Trace path (candidates only)
- [x] Cites at least two `path:line` claims
- [x] Does not list every file in the tree
- [x] Does not edit the repo

Observed:
- Menu again? **No.**
- Briefing shape? **Yes — `orient-repo`:** purpose, map (top-level + depth-two table), entry points, Architecture, Feature Trace, Read these next, open questions. Router did not write a second procedure.
- Feature Trace glance? **Yes.** Offered three candidates; did not walk a path (no named journey): `catch-me-up` router, `plugin.json` catalog, fixture `POST /checkout` → `handleCheckout` → `processOrder`.
- Citations? **Yes.** `CLAUDE.md:16-23`, `CLAUDE.md:25`, `CLAUDE.md:40`, `CLAUDE.md:43-45`, `catch-me-up/SKILL.md:13`, `README.md:48-56`, `fixtures/orient-sample/README.md:7`.
- Whole-tree dump? **No.**
- Edited files? **No.**
- Verbatim quotes:
  - "No named journey, so this is not walked. Closest entry paths:"
  - "Fixture HTTP — `fixtures/orient-sample/src/server.js` (`POST /checkout` → `handleCheckout` → `processOrder`)."
  - "Want to go deeper on `catch-me-up` or `orient-repo`, add Convention/Testing, or stop here?"

### Scenario E — direct `orient-repo` with no mode list — pass if
- [x] Asks the six-mode menu
- [x] Stops this turn: does not list the tree, entry points, or test command
- [x] Does not edit the repo

Prompt: invoked as `orient-repo` with no mode list, then `Onboard me to this repo.`

Observed:
- Showed all six modes? **Yes.** Asked for a pick, then stopped.
- Listed tree / entry points / test command this turn? **No.**
- Edited files? **No.**
- Verbatim quotes:
  - "This is a whole-repo **onboard**. Pick the lenses you want, then I’ll gather and brief."
  - "Reply with the numbers or names (for example: `1, 2, 6` or `Architecture + Convention`)."

Residual (unchanged): Scenario D still only proves pathless “how does checkout work?” at this repo root, not a workspace that actually has a `checkout/` module (journey-plus-locus → `orient-module`).

## GREEN (2026-08-18: Feature Trace no-journey)

Same family, after Bugbot: onboard Feature Trace with `journey: none` was walking a path because `orient-repo` said “follow one path” with no no-journey case.

Prompt: handed off as `orient-repo` onboard, modes Architecture + Feature Trace, `journey: none`, three candidate paths already offered.

### Pass if
- [x] Does not walk a Feature Trace path
- [x] Lists the candidate entry paths and asks which to walk
- [x] Still produces the Architecture / map briefing
- [x] Does not edit the repo

Observed:
- RED (before the no-journey rule): walked `POST /checkout` → `handleCheckout` → `processOrder` in the same turn. Quote: “No journey was named, so Feature Trace walks **`POST /checkout`**.”
- GREEN (after): Architecture map + Feature Trace section lists the three candidates and asks which to walk. Did not open `server.js` / `orders.js` as a trace. Quote: “No journey was named (`journey: none`), so this turn does **not** walk a path.”
