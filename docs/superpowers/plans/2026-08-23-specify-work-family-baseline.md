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

Score **shape**, not dump names. Agent-chosen cut names are fine.

- Steps emitted? **Yes** (must cover the sized MVP; class names not required here)
- Cuts: every cut has interface + first impl? **Yes**
- Cuts cover the MVP (a location source, a weather source, a way to show it — names free)? **Yes**
- At least one thin cut, or a written reason a cut is not split? **Yes**
- Multi-day / URL pulled into inventory? **No** (seams only)
- Copied a dump class list as the design? **No** (slim dump has none)
- resized / wrote plan: **no**
- files edited: none
- Pass.

### D — write-plan after grain

- unit: stacked PR (interface + impl + tests + mock for dependents)
- units follow **this design’s cuts** (whatever names write-design chose); not a fixed `LocationProvider` list
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
- Emitted What / Steps / Cuts? **No.**
- Mandated bounce: “If grain does not exist, **stop** … A plain “design this” with no class list still bounces.”
- Files edited: none
- Pass. Closes the write-design no-grain hole.

### I — after grain, design + plan

- Leaf: **write-design** (not write-plan)
- Tie sentence: “After grain, if both design and plan are named, take `write-design` … then **hand back**.”
- Steps + Cuts derived (shape, not dump names)? **Yes.** Stacked-PR plan? **No.** Hand back after one leaf? **Yes.**
- Files edited: none
- Pass. Closes RED-I skip to write-plan.

### J — after grain, re-sent mixed dump / spec+design+plan

- leaf: **write-design** (not write-spec, not write-plan)
- Compose row: after grain, spec+design+plan / re-sent mixed dump → `write-design` first; do not re-run `write-spec`
- New Outcome/In/Out spec? **No.** Stacked-PR plan? **No.** size-work announced? **No.**
- Steps + Cuts derived (What/Steps/Cuts; names agent-chosen)? **Yes.** Hand back after one leaf? **Yes.**
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
- **C:** write-design; Steps + Cuts (shape, not names); no multi-day in inventory; no resize; no plan. Pass.
- **D:** write-plan; stacked-PR units follow this design’s cuts; spike first/separate; no 2–5 minute contract; no grain bump. Pass.
- **E:** class list first → not inventory; `write-spec` → `size-work`; no document. Pass.
- **F:** write-plan, not write-spec. Pass.

### RED-K — kinds.md-literal write-spec on slim dump (pre-ladder)

Skills present: old Open decisions wording (“An unanswered product or API choice … is a spike”). Fresh `generalPurpose` subagent. Ban: `docs/superpowers/**`, `weather-eval.md`. Follow `kinds.md` literally. Do not invent spikes the dump did not name.

- Agent: `eb70a477-642d-4540-abd0-01521fb78e97`
- Outcome / In / Out / standards: present
- Open decisions: **None.** Verbatim: “The dump did not name an unanswered product or API choice.”
- Weather service as spike? **No.**
- Controlling sentence: “An unanswered product or API choice (example: which weather service) is a spike.”
- Dump edited? **No.**
- Fired: **kinds-literal omit** — spike only if the dump already named the choice as unanswered. Hole vs parked `shape-task` for which weather API.

### Derive-cuts GREEN (slim dump; score shape)

Skills present after `e56fd81`. Fresh `generalPurpose` subagents. Ban: `docs/superpowers/**`, `fixtures/specify-work/weather-eval.md`. Grain parked: feature / one story (today’s weather for my location on one page) / Path that story / Parallel none / API spike separate. Design names agent-chosen.

#### C — write-design from slim dump after grain

- Agent: `445a2f0d-ed94-4f54-9209-2136bb9b9849`
- Prompt: after grain, write-design from the slim dump (or spec + parked grain). No class list in the prompt. Ban `docs/superpowers/**`.
- Leaf: **write-design**
- What: sized MVP (today’s weather for the user’s location on one page). In/Out unchanged.
- Steps: resolve place, load today’s conditions, show one page (wording free).
- Cuts (agent-chosen): `CurrentPlace` / `NavigatorCurrentPlace`; `TodayOutlook` / `HttpTodayOutlook`; `TodaySurface` / `SingleScreenToday`. Every cut has interface + first impl. Covers location source, weather source, a way to show it.
- Thin: yes (at least one thin cut). Multi-day / URL: seams only, not inventory.
- Copied a dump class list? **No** (slim dump has none). Resize? **No.** Plan? **No.**
- Files edited: none
- Pass.

#### A — slim dump before grain → write-spec only

- Agent: `42c1e85f-b059-4c3e-9866-26a864d10149`
- Leaf: **write-spec**
- Outcome: one page, today’s weather for the user’s location
- Out: 3/7/10-day + URL-query location
- Spike: which weather service
- Standards labeled (`SOLID`, `ISP`, `stacked PRs`)
- Classes / cuts: **none**
- Plan: **no**
- Files edited: none
- Pass. GREEN A still holds after slimming the dump.

#### I — after grain, design + plan only

- Agent: `5e9a0c78-430d-4168-97f5-ada523c75421`
- Leaf: **write-design** (not write-plan)
- Steps + Cuts derived. Stacked-PR plan? **No.** Hand back? **Yes.**
- Files edited: none
- Pass.

#### J — after grain, re-sent slim dump / spec+design+plan

- Agent: `7bfc4f10-88ca-42ee-9fe5-dddd32caf21c`
- Leaf: **write-design** (not write-spec, not write-plan)
- New Outcome/In/Out spec? **No.** Steps + Cuts derived? **Yes.** Plan this turn? **No.** Hand back? **Yes.**
- Files edited: none
- Pass. After-grain compose letter holds.

#### D — write-plan uses C’s cuts

- Agent: `5adfa533-f687-4943-b12b-53c4dbbfebe6`
- Used C’s cuts (`CurrentPlace`, `TodayOutlook`, `TodaySurface`), not a fixed `LocationProvider` list
- Spike first and separate. No 2–5 minute contract. No grain bump.
- Files edited: none
- Pass.

### RED-L — kinds.md-literal write-spec, cut-gated WHEN (pre-reword)

Skills present: ladder gated on “When a cut would depend…”. Fresh `generalPurpose` subagent. Ban: `docs/superpowers/**`, `weather-eval.md`. Follow `kinds.md` WHEN as written. write-spec must not emit cuts.

- Agent: `f5c8a38f-c658-499c-9f31-e6b2d3329e90`
- Weather service as spike? **No.**
- Open decisions listed location-obtain, “today’s weather” facts, and units — not the vendor.
- Controlling WHEN: “When a cut would depend on an external service…” treated as unmet because write-spec has no cuts.
- Omitted because no cut depends yet / write-spec has no cuts? **Yes.** Dump edited? **No.**
- Fired: **cut-prerequisite omit** — same hole as RED-K, new gate.

### GREEN K — kinds.md-literal write-spec on slim dump (visibility ladder)

Skills present after `6938ba4`. Fresh `generalPurpose` subagent. Ban: `docs/superpowers/**`, `fixtures/specify-work/weather-eval.md`. Follow `kinds.md` literally.

- Agent: `30ec2b7e-31f5-4cc5-961d-44e3a7645803`
- Outcome / In / Out / standards: present. Classes / cuts: **none.**
- Open decisions: **which weather service / weather API / weather vendor** as a **spike** (`shape-task`). Not omitted. Not an explained pick.
- Omitted because the dump did not say “open”? **No.** Dump edited? **No.**
- Controlling sentences: “`write-spec` **infers** unanswered external or product choices. Do not require the dump to name them.” Spike default for an external service with no vendor. Never silent on an external vendor/API.
- Pass. Closes RED-K omit.

### A reconfirm (after visibility ladder)

- Agent: `1d582bb8-c410-41f7-8a3e-5ffe7fd6f997`
- Before grain, slim dump → **write-spec** only.
- Outcome: one page, today’s weather for the user’s location. Out: URL + 3/7/10-day. Standards labeled. Classes / cuts: **none.** Plan: **no.**
- Open decisions: **which weather service** as a **spike**. Dump edited? **No.**
- Pass.

Confirm dump still slim: `fixtures/specify-work/weather-dump.md` has no class list and no “picking the service is still open” sentence.

### GREEN L — kinds.md-literal write-spec (outcome-gated ladder)

Skills present after `6ad06dc`. Fresh `generalPurpose` subagent. Ban: `docs/superpowers/**`, `weather-eval.md`. Follow `kinds.md` literally, including every WHEN / IF. write-spec must not emit cuts.

- Agent: `38ce703a-6f20-4880-a1ec-d3460c428567`
- Open decisions: **which weather service / weather API / weather vendor** as a **spike**. Not omitted. Not an explained pick.
- Omitted because “no cut depends yet” / “write-spec has no cuts”? **No.** Dump edited? **No.**
- Controlling sentences: “Apply the visibility ladder **without a cut prerequisite**. Gate on the **outcome / MVP In**, not on cuts.” “No cuts yet” is not a reason to omit.
- Pass. Closes RED-L cut-prerequisite omit.

### K reconfirm (after outcome-gated ladder)

- Agent: `866b0a1d-cea3-47fa-ae7a-f179c60cae79`
- kinds-literal write-spec. Weather service as **spike**. Omitted because dump did not say “open”? **No.** Dump edited? **No.**
- Pass.

### A reconfirm (after outcome-gated ladder)

- Agent: `4541b5c7-57ac-4d3b-8575-908cb9c7fdaf`
- write-spec only. Outcome: one page, today’s weather for location. Out: URL + 3/7/10-day. Standards labeled. Classes / cuts: **none.** Plan: **no.**
- Open decisions: which weather service as a **spike**. Dump edited? **No.**
- Pass.

Dump still slim: no class list, no “picking the service is still open.”

## Superpowers-gap letters (Approaches / cut notes / File map / spike options)

RED against the pre-letter skills (agents followed then-current
`write-*` + `kinds.md`; ban `docs/superpowers/**`):

- **RED-M omit-approaches** (`ee98e06e`): Approaches **no**. Stack
  named **no**. Weather spike **yes** (one-liner).
- **RED-N omit-cut-notes** (`02409e37`): three cuts, interface+impl
  **yes**; error note **no**; test note **no**.
- **RED-O omit-file-map** (`9a71362c`): spike first **yes**; File map
  **no**; PRs name files **no**; 2–5 minute contract **no**.
- **RED-P one-line-spike** (same `ee98e06e`): “which weather
  vendor/API” — no options, no per-option impact.
- **RED-Q stale-spec-after-pick** (`1ecd0a3a`): SevenDayWeather +
  “Design the classes” → `write-design`. No write-spec. No
  size-work pointer.

GREEN after the letters (ban `docs/superpowers/**`,
`weather-eval.md`, `eval-letters.md`):

- **A** (`335a1b7f`): Approaches (TS+Vite+Vitest+page vs React vs
  Next) + Open-Meteo/OpenWeatherMap spike with impact + explained
  stack. Stop. Pass.
- **C** (`10677dbd`): every cut has error note + test note
  (faked vs real). Pass.
- **D** (`825b63b7`): File map + spike options + PRs name files.
  No 2–5 minute novel. Pass.
- **P** (`d39e1652`): CityFormWeather (no geolocation) + “Design
  the classes” → `write-spec`, point at `size-work`. Pass.
- **K** (`361c5fde`): kinds-literal; Approaches + spike options;
  not a one-liner; not silent on stack. Pass.

### After-pick user-label clash (RED-R / GREEN R)

- **RED-R** (`749b1949`, pre-fix): Open-Meteo + “plan this”, no
  design → `write-design` via “Only cuts / seams / errors.” User
  label ignored.
- **GREEN R** (`a3e35f3b`, after three-way letter): same prompt →
  `write-plan` (step 2). Did not take “no design yet” as
  write-design.
- **P reconfirm** (`a3ef2ae5`): CityFormWeather + “design the
  classes” still step 1 `write-spec`. Stale still wins.
