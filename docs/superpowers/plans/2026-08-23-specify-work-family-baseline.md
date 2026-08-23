# Specify-work family RED baseline

Date: 2026-08-23
Skills present: none (`specify-work` / `write-spec` / `write-design` / `write-plan` / `kinds.md` must not exist)

Two fresh `generalPurpose` subagents. Ban: `docs/superpowers/**`; do not invent these skills. Workspace: skills repo root. Input: `fixtures/specify-work/weather-dump.md`. Superpowers-shaped `brainstorming` / `writing-plans` and promoted `size-work` were available (not the family under test).

## Scenario RED-1 — weather dump, spec + design + plan

Prompt: read the dump; spec this, design the classes, and write the implementation plan in this turn. ISP, SOLID, and stacked PRs required. May use brainstorming / writing-plans.

Observed:
- Used **brainstorming** (architectural). Kept spec, class design, and plan **in the same turn**.
- Outcome sharpened (today’s weather for device location on one page). Out included URL-query and multi-day. Spike named.
- **Also emitted classes** in this turn: `LocationProvider`, `UserLocationProvider`, `SingleDateProvider`, `TodaysDateProvider`, `WeatherProvider`, plus later ISP types.
- **Also emitted a stacked-PR plan** in this turn (spike + four PRs).
- Stopped and only pointed at `size-work`? **No.**
- Files edited? **No.**
- Verbatim:
  - "I am not stopping at size-work."
  - "I am continuing into class design and the stacked-PR plan in this same turn because you asked for the spec, the classes, and the implementation plan together"
  - "You already named the outcome, the later work, and required ISP, SOLID, and stacked PRs **in this turn**, so I am keeping the spec, class design, and plan in conversation"

Fired: **auto-continue** (spec → design → plan in one turn). Mixed dump treated as permission to do all three jobs.

## Scenario RED-2 — weather dump, size this (SOLID pressure)

Prompt: read the dump; size this work; break into the inventory we should build; ISP, SOLID, and stacked PRs are required — include them. May use size-work.

Observed:
- Used **size-work** → `shape-feature`. One story. Path that story. Parallel `None`. Multi-day and URL-query in Out. Classes under Constraints, not children.
- SOLID / ISP / stacked PRs did **not** bump grain and did **not** become inventory children (promoted size-work already holds that letter when the agent follows it).
- Did not design classes or write a plan.
- Files edited? **No.**
- Verbatim: "ISP, SOLID, and stacked PRs are required standards on how we build this feature; they are not inventory children and they do not bump this from a feature to an epic."

Did not fire SOLID-into-sizing **when size-work was followed**. Skills must still make `write-spec` output **unreadable as an epic or class inventory**, so a later size-work pass cannot be handed providers as children. The family must not rely on the sizer to strip classes the specifier already emitted (RED-1).

## Failures this family must close

Fired:

- **Spec + design + plan in one turn** when the dump asked for all three. RED-1.
- **Classes in the specify turn.** RED-1.
- **Did not stop and point at size-work.** RED-1.
- **“They asked for all three” / “standards are required this turn” as permission to auto-continue.** RED-1.

Did not fire (still require):

- SOLID / stacked PRs as size-work inventory children (RED-2 was already clean **if** the agent used size-work on a dump, not on a class-filled spec).
- Class list as the first ask treated as inventory (not in this RED pair; GREEN E).
- 2–5 minute Superpowers step list as the plan contract (RED-1 used stacked PRs; GREEN D still forbids that contract).
- Writing `docs/work/` or committing a spec file (neither RED run did).

## Letter-clash RED (skills present, old wording)

Three fresh `generalPurpose` subagents against the pre-fix letters. Ban: `docs/superpowers/**`.

### RED-G — kinds.md-literal on weather dump

Prompt: follow `kinds.md` as authoritative; then `write-spec`; weather dump.

Observed:
- Emitted Outcome / In / Out? **No.**
- Stopped because classes arrived before grain? **Yes.**
- Controlling sentence: “If they arrive before grain exists, **stop**.”
- Wrote a class-free spec, or abort? **Abort.**
- Fired: **kinds.md class-list stop aborted write-spec** on the mixed dump (GREEN A).

### RED-H — “design this”, no grain, no class list

Prompt: follow `write-design` as written. No inventory. No class list. “Design this. I want the design for a weather page.”

Observed:
- This sample **stopped** and pointed at `write-spec` → `size-work`.
- Controlling sentence: “Requires a sized inventory, or an explicit ‘design this story/feature’ after grain exists.”
- The **letter hole** remains: bounce is only mandated for a class dump. The “or … after grain” clause can be read as a bypass. A later agent can proceed on a plain “design this.” Fix: same no-grain stop as `write-plan`.

### RED-I — after grain, design + plan

Prompt: follow the router. Grain set. “Design the classes and plan the implementation.”

Observed:
- Leaf: **write-plan**
- Tie-break used: “prefer `write-spec` when grain does not exist, else the named later leaf.”
- Stacked-PR plan? **Yes.** Class design? **No.**
- Fired: **tie-break skipped write-design.**

## GREEN

Skills present: `specify-work`, `kinds.md`, `write-spec`, `write-design`, `write-plan`.

Fresh `generalPurpose` subagents. Ban: `docs/superpowers/**`, `fixtures/specify-work/weather-eval.md`. Each read the named in-progress skill first. No application files edited.

### A — weather dump → write-spec only

- leaf: **write-spec**
- Outcome: single page, today’s weather for the user’s location
- Out: URL-query location; 3-day; 7-day; 10-day
- Standards labeled only (`stacked PRs`, `ISP`, `SOLID`) — not designed
- Classes / providers in the document: **none**
- Plan / stacked-PR list: **no**
- Invoked size-work / write-design / write-plan: **no**
- Close: announced `size-work`; “design and a plan; those need a new message. Stopping here.”
- Files edited: none
- Pass. Closes RED-1 auto-continue.

### B — write-spec output + size-work letters (do not implement size-work)

Contract-faithful spec (same shape as A) + `levels.md` / `paths.md` only. No `shape-*` follow-through.

- largest fit: **feature**; adjacent ask-once: **story**
- inventory: **one story** (today’s weather for my location on one page)
- URL-query / multi-day: **not** children (Out)
- Path: that story. Parallel: **None**
- weather API: separate **shape-task** spike
- readable as epic: **no**
- readable as class inventory: **no** (SOLID/ISP/stacked PRs are labels)
- Pass.

### C — write-design after grain

- providers: LocationProvider → UserLocationProvider; DateProvider → TodaysDateProvider; WeatherProvider → service of choice
- later-feature seams: URL-query adapter; SingleDateProvider + DateRangeProvider; fat DateProvider later — notes, not inventory
- added multi-day / URL-query to inventory: **no**
- resized / wrote plan: **no**
- files edited: none
- Pass.

### D — write-plan after grain

- unit: stacked PR (interface + impl + tests + mock for dependents)
- 2–5 minute Superpowers step list as the contract: **no**
- spike first and separate (`shape-task`): **yes**
- grain bump / Out into inventory: **no**
- implemented: **no**
- files edited: none
- Pass.

### E — class list as the first ask

- treated as inventory: **no**
- followed write-design: **no**
- pointer: **write-spec → size-work**
- stopped without a spec/design/plan document: **yes**
- files edited: none
- Pass.

### F — plan-only after grain

- leaf: **write-plan** (not write-spec)
- re-ran write-spec as the main document: **no**
- stacked-PR plan: **yes**
- files edited: none
- Pass.

### G — kinds.md-literal mixed dump (letter clash)

- Emitted Outcome / In / Out? **Yes.** Outcome: single page, today’s weather for the user’s location. Out: URL-query + 3/7/10-day.
- Stopped at the class-list line and aborted? **No.**
- Controlling sentence: “`write-spec` on a mixed dump … **separates**. It emits a class-free spec. It does **not** abort.”
- Classes in the spec: **none.** Invoked write-design / write-plan: **no.**
- Files edited: none
- Pass. Closes RED-G abort.

### H — “design this”, no grain, no class list

- Stop + pointer `write-spec` → `size-work`? **Yes.**
- Emitted What / How / providers? **No.**
- Mandated bounce: “If grain does not exist, **stop** … A plain “design this” with no class list still bounces.”
- Files edited: none
- Pass. Closes the write-design no-grain hole.

### I — after grain, design + plan

- Leaf: **write-design** (not write-plan)
- Tie sentence: “After grain, if both design and plan are named, take `write-design` … then **hand back**.”
- Class design? **Yes.** Stacked-PR plan? **No.** Hand back after one leaf? **Yes.**
- Files edited: none
- Pass. Closes RED-I skip to write-plan.

### J — after grain, re-sent mixed dump / spec+design+plan

- leaf: **write-design** (not write-spec, not write-plan)
- Compose row: after grain, spec+design+plan / re-sent mixed dump → `write-design` first; do not re-run `write-spec`
- New Outcome/In/Out spec? **No.** Stacked-PR plan? **No.** size-work announced? **No.**
- Class design (What/How/providers)? **Yes.** Hand back after one leaf? **Yes.**
- Files edited: none
- Pass.

### A reconfirm (after compose-order rewrite)

- Before grain, same weather dump → **write-spec** only. Classes none. Out includes URL + multi-day. Close points at size-work. Pass.

### I reconfirm (after compose-order rewrite)

- After grain, design+plan only → **write-design**. No stacked-PR plan. Hand back. Pass.

### A–F reconfirm (after letter rewrite)

Same prompts as A–F. Fresh subagents. Ban: `docs/superpowers/**`.

- **A:** write-spec only; Out = URL + 3/7/10-day; standards labeled; classes none; stop; point at size-work. Pass.
- **B:** feature / one story / Path that story / Parallel none / API spike separate; not epic; not class inventory. Pass.
- **C:** write-design; providers + ISP seams; no multi-day in inventory; no resize; no plan. Pass.
- **D:** write-plan; stacked-PR unit; spike first/separate; no 2–5 minute contract; no grain bump. Pass.
- **E:** class list first → not inventory; `write-spec` → `size-work`; no document. Pass.
- **F:** write-plan, not write-spec. Pass.
