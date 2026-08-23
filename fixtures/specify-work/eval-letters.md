# specify-work eval letters

Scorer rubric for the Superpowers-gap letters. Not user input.
GREEN prompts must not open this file, `weather-eval.md`,
`charge-eval.md`, or `house-eval.md`.

Input dumps: `weather-dump.md` (weather novel),
`charge-dump.md` (second novel), and `house-dump.md` plus
`house-repo/` (existing-repo novel). Grain (when needed) is
the parked card in `weather-eval.md`, `charge-eval.md`, or
`house-eval.md`. Ban: `docs/superpowers/**`. Not a third
scorer for the 8am Charge-C/D scan.

One leaf per turn. Before grain, mixed dump → `write-spec`. After
grain, mixed dump → `write-design`. No grain → stop for design/plan.
After a spike pick: stale → `write-spec` (wins over “design” /
“plan”). Not stale + they named only one document → that leaf.
Not stale + mixed / just the pick → unfinished-leaf / impact
routing. Do not auto-continue that loop.

Approaches ≠ spike options. Approaches = ways to build
(stack / architecture). Spike options = unsettled external /
product choices (vendor / API).

## GREEN requires

| Leaf | New required section |
|---|---|
| `write-spec` | **Approaches** — 2–3 real alternatives, trade-offs, recommended pick. Pick includes stack (language / bundler / test runner / page vs framework) when the dump did not settle one. **Open decisions spike** — at least two real vendor/product options, each with short pros/cons, compare/contrast, and whether it would change MVP In/Out, grain, later cuts, auth, data shape, or tests. |
| `write-design` | Every **cut** states error / failure states that cut owns, and how that cut is tested (faked vs real). Short notes, not test code. Interface + first impl **name the job** — synonym family, not one token. `${Location\|Position\|Coordinates\|similar}Provider` (or Client / Adapter / Gateway / Source) GREEN. Same weather dump: `DevicePosition` + `BrowserDevicePosition` GREEN. Requiring `LocationProvider` as the only accepted token RED. Charge dump: `CardCharger` + `StripeCardCharger` (or `PaymentClient` / `ChargeGateway` family) GREEN. Fail cute / poetry names (`Here`, `Place`, `TodayBoard`, `ComposeToday`, `Till`, `Gold`). Superpowers does not dictate type names. User class lists remain hints. |
| `write-plan` | **File map** before the stacked-PR list: exact paths + responsibility, using this design’s cut names. **Colocate by cut** (the rule, not “the Location tree”): capability folder first, port + first impl together, tests next to the file. Acceptable nests: `Capability/Provider/`, `Capability/CapabilityProvider/`, `CapabilityProvider/`. Weather synonyms (`src/DevicePosition/…`) and charge (`src/Charge/…` / `src/Payment/…`) both GREEN. Each stacked PR names the files it touches. Spike first as `shape-task` **with the same option/impact list**, not a one-liner. Fail a flat `src/*.ts` dump with every cut in one directory. Fail requiring `domain/` / `ports/` / `adapters/` / `views/` as the only legal tree. Fail a distant `tests/` tree. Fail a mixed-cut dump folder. Fail requiring `LocationProvider` paths as the only pass. Scaffold (`package.json`, `vite.config`, `index.html`) may sit at the page cut / composition PR. |
| `write-plan` (existing repo) | **Follow the house.** Not a Charge-C/D scorer. Input: `house-dump.md` + `house-repo/`. Match naming, functions vs classes, `tests/` vs colocated, flat `src` if that is already the tree. GREEN: `lib/geo/…` + `tests/geo/…`. RED: invents `src/Location/Provider/` + classes + tests-next-to-file against this house. Do **not** fail house-style `tests/` or flat `src` on this prompt. Greenfield Charge-C/D and `distant-tests` / `flat-src-map` stay as written for weather/charge dumps. |

Unchanged compose: weather API stays a **spike** unless demoted with
a named default **and** why later cuts would not change. Stack pick
is usually **explained**, not a substitute for that spike. Still
stop after `write-spec` and point at `size-work`. No auto-continue.
No 2–5 minute step list as the plan contract. No bake-off runner
code. This family points at `size-work` when grain is stale; it
does not edit size-work.

Sizer letters live in `fixtures/size-work/eval-letters.md`. Grain
inventory is 3–9 (five OK), not “one story.”

## PIN (unlettered prose now scored)

Keep the gap letters above. These were already in the skills; they
were not in this file’s GREEN/RED tables.

| Id | Prompt pressure | GREEN if | Fail if |
|---|---|---|---|
| **conversation-only** | `write-spec` on the weather dump; no sink named | Conversation only. No spec file. No invented `docs/work/`. | Wrote or committed a spec file without a named sink |
| **named-sink** | Same dump + they named a path / tracker | Finished the document, then published **there** | Invented a different sink, or skipped publish |
| **then-build** | “spec this then build” | Finished `write-spec`, handed back. Did not build, design, plan, or size. | Built, or auto-continued to another leaf |
| **do-not-grill** | Weather dump already mixes outcome / later / standards | Separated the dump. Did not interview from scratch. | Grilled a stack of clarifying questions instead of writing the spec |
| **demote-ladder** | `write-spec`; agent wants to skip the weather-API spike | Spike stays, **or** demote names the default **and** why later cuts would not change | Demoted / silent / Approaches-default without that pair |
| **silent-only-forced** | `write-spec`; dump did not force a stack | Stack compared or explained. Silent only if the dump already forced the stack (or only one legal option). | Silent on stack while inferring a weather spike |
| **sibling-from-open-path** | Router handoff to a leaf | Read `../write-*/SKILL.md` from **this** `SKILL.md`’s directory, or from the path used to open it | Cwd-only `skills/in-progress/...` after a symlink / plugin copy, then stopped |

## Still-hold baselines (do not split scorers)

Copy/reference so this file and
`docs/superpowers/plans/2026-08-23-specify-work-family-baseline.md`
do not diverge on these ids:

| Id | Still holds | Note |
|---|---|---|
| **B** | Feature (not epic); Path of every determining title (no floor); Parallel `None` if they share the weather API / one page; API spike separate; not a class inventory | Inventory is **3–9** (five OK). The old “one story / Path that story / Parallel None” parked slot is **superseded**. If five determine done, Path lists five. |
| **E** | Class list as first ask → not inventory; `write-spec` → `size-work`; no document | Unchanged |
| **F** | Plan-only after grain → `write-plan`, not `write-spec` | Unchanged |
| **G** | kinds-literal mixed dump **separates**; does not abort | Unchanged |
| **H** | “design this”, no grain, no class list → stop + pointer | Unchanged |
| **I** | After grain, design + plan → `write-design` first; hand back | Unchanged |
| **J** | After grain, re-sent mixed dump → `write-design`, not a second spec | Unchanged |
| **L** | kinds-literal `write-spec`; weather API inferred as spike; not omitted for “no cuts yet” | Unchanged |

## RED catches

| Id | Prompt pressure | Fail if |
|---|---|---|
| **omit-approaches** | kinds-literal / `write-spec` on the slim dump | No Approaches section, or no 2–3 alternatives + pick, or silent on stack while inferring a weather spike |
| **silent-vendor** | kinds-literal `write-spec` on the slim dump | Weather API omitted, silent, or swallowed into an Approaches default without the visibility ladder |
| **one-line-spike** | kinds-literal / `write-spec` on the slim dump | Spike only says “pick a weather API” (or equivalent) with no real options and no impact |
| **omit-cut-notes** | `write-design` after grain, slim dump, no class list | A cut has interface + first impl but no error note **and** no test note |
| **omit-file-map** | `write-plan` after grain + a design | Stacked PRs and no exact paths (no File map, and PRs do not name files) |
| **2-5-minute-plan** | `write-plan` after grain + a design | Plan contract is a 2–5 minute TDD step list / code novel |
| **stale-spec-after-pick** | After grain, a vendor pick that would change In/Out, plus “design the classes” | Continues to `write-design` without re-running `write-spec` (grain stale; should point at write-spec → size-work) |
| **plan-after-nonstale-pick** | After grain, settled non-stale vendor + “plan this”, **no design yet** | Takes `write-design` because the table says “next unfinished” / “no design yet” |
| **cute-cut-names** | `write-design` after grain, weather or charge dump, no class list | Interface + first impl are poetry / vibe / cute one-word names (`Here`, `Place`, `TodayBoard`, `ComposeToday`, `Till`, `Gold`) that need the design prose to decode |
| **location-token-only** | `write-design` after grain, weather dump | Treats `LocationProvider` as the only accepted token, or fails `DevicePosition` + `BrowserDevicePosition` (or Coordinates/Location synonym family) |
| **weather-only-pass** | `write-design` / `write-plan` after grain, **charge** dump | Weather Location names/tree are required, or charge synonym job names + colocate-by-cut fail |
| **flat-src-map** | `write-plan` after grain + a design (weather or charge) | File map dumps all cuts in `src/*.ts` with every cut in one directory |
| **hex-only-tree** | `write-plan` after grain + a design | File map requires `domain/` / `ports/` / `adapters/` / `views/` as the only legal tree |
| **distant-tests** | `write-plan` after grain + a design | File map requires a distant `tests/` tree instead of tests next to the file they cover |
| **any-grouping** | `write-plan` after grain + a design | File map groups files but not colocate-by-cut (mixed-cut dump, or “any folder” sold as GREEN) |
| **invent-convention** | `write-plan` after grain, `house-dump.md` + `house-repo/` | File map invents a second convention (`src/Location/Provider/` + classes, or tests-next-to-file) against the existing `lib/geo/` + `tests/` + function-module house |
| **wrote-file-no-sink** | `write-spec` on the weather dump; no sink named | Wrote or committed a spec file / invented `docs/work/` |
| **then-build-continued** | “spec this then build” | Built, designed, planned, or sized in the same turn |
| **grilled-dump** | Weather dump | Interviewed from scratch instead of separating the dump |
| **demote-without-ladder** | `write-spec` | Weather API demoted / silent / Approaches-default without a named default **and** why later cuts would not change |
| **silent-stack-unforced** | `write-spec`; dump did not force a stack | Silent on stack while inferring a weather spike |
| **cwd-sibling-miss** | Router handoff after a symlink / plugin copy | Cwd-only `skills/in-progress/...` Read, then stopped; did not resolve from the open `SKILL.md` path |

## GREEN A — write-spec (before grain, mixed dump)

- Leaf: `write-spec` only. Classes / cuts / plan: **none**.
- Outcome / In / Out / Standards-as-labels / Close → `size-work`: same as before.
- **Approaches** present: 2–3 **build** alternatives (stack / architecture), trade-offs, recommended pick includes stack. Not a vendor list.
- Open decisions: which weather service as a **spike** with **at least two vendors**, each with pros/cons and impact (key vs no key, forecast fields, whether In/Out or cuts move). Stack pick **explained** (named + why), not silent.
- Approaches did not swallow the vendor into a silent / default-without-ladder pick.
- Did not grill. Did not auto-continue.

## GREEN C — write-design (after grain, weather dump)

Score the **rule**, not the weather spelling.

- Steps + Cuts; every cut has interface + first impl.
- Interface + first impl **name the job**. Synonym family, not
  one token: `${Location|Position|Coordinates|similar}Provider`
  (or Client / Adapter / Gateway / Source). Same idea for the
  browser adapter, current-weather client + vendor adapter,
  and page/composer.
- Same weather dump: `DevicePosition` + `BrowserDevicePosition`
  GREEN. Coordinates/Location synonym family GREEN.
- Requiring `LocationProvider` as the only accepted token RED.
- Fail cute / poetry names (`Here`, `Place`, `TodayBoard`,
  `ComposeToday`). Fail cute one-word cuts.
- Superpowers does not dictate type names. User class lists
  remain hints.
- Every cut also has an **error / failure** note and a **test**
  note (faked vs real). Notes are short. Out items are seams
  only. No resize.

## GREEN D — write-plan (after grain, weather dump)

Score the **rule**, not the weather Location tree.

- **Spike** first as `shape-task` with real options + impact (not “pick a weather API”). Not swallowed.
- **File map** before stacked PRs: exact paths + what each file owns; this design’s cut names (synonym job names).
- **Colocate by cut:** capability folder first, port + first impl together, tests next to the file they cover.
- Acceptable nests (do not require one spelling): `Capability/Provider/`, `Capability/CapabilityProvider/`, `CapabilityProvider/`.
- Same weather dump: `src/DevicePosition/…` (or Coordinates/Location synonym folder) GREEN. Requiring `src/Location/…` + `LocationProvider` as the only pass RED.
- Fail a flat `src/*.ts` dump with every cut in one directory.
- Fail requiring `domain/` / `ports/` / `adapters/` / `views/` as the only legal tree.
- Fail a distant `tests/` tree. Fail a mixed-cut dump folder.
- Scaffold (`package.json`, `vite.config`, `index.html`) may sit at the page cut / composition PR, not inside every port folder.
- Each stacked PR names the files it touches.
- File-map paths match the PRs. No TBD. No 2–5 minute code novel.
- After-pick / Approaches ≠ spike / error+test notes unchanged.

## GREEN Charge-C — write-design (after grain, charge dump)

Different domain, same letters. If weather Location is the only
pass, the letter does not scale.

- Input: `charge-dump.md`. Do not open `charge-eval.md`,
  `weather-eval.md`, or this file.
- Steps + Cuts; every cut has interface + first impl + error
  note + test note.
- Job names GREEN: `CardCharger` + `StripeCardCharger`,
  `PaymentClient` + `StripePaymentClient`, `ChargeGateway` +
  `BraintreeChargeGateway`, or equivalent synonym family.
- RED: cute names (`Till`, `Gold`, `TodayTill`,
  `ComposeCharge`). RED: requiring weather `LocationProvider`
  (or the weather Location tree) as the pass.

## GREEN Charge-D — write-plan (after grain, charge dump)

- Spike first (which payment processor) with real options +
  impact. Not a one-liner. Not swallowed.
- File map colocates by cut: capability folder first, port +
  first impl together, tests next to the file.
- GREEN: `src/Charge/…`, `src/Payment/…`, or
  `src/ChargeGateway/…` using any of the three accepted nests.
- RED: flat `src/*.ts` with every cut in one directory.
- RED: requiring the weather Location tree as the only pass.
- No TBD. No 2–5 minute code novel. Scaffold at the page /
  composition cut.

## GREEN House — write-plan (after grain, existing repo)

Not a Charge-C/D scorer. Not a third 8am novel. Charge-C/D
and weather-only-pass stay as written for `charge-dump.md` /
`weather-dump.md`.

- Input: `house-dump.md` + `house-repo/`. Do not open
  `house-eval.md`, `weather-eval.md`, `charge-eval.md`, or
  this file.
- Grain exists (parked in `house-eval.md`). Leaf: `write-plan`.
- File map **follows the house**: `lib/geo/` function modules,
  tests under `tests/geo/`, not `src/Location/Provider/`
  classes, not tests next to the file.
- GREEN: `lib/geo/…` + `tests/geo/…` (or the same house with
  new weather files next to those conventions).
- RED: invents `src/Location/Provider/` + classes +
  tests-next-to-file against this house.
- Do **not** fail house-style `tests/` or flat `src` on this
  prompt. Greenfield `distant-tests` / `flat-src-map` stay
  RED on weather/charge dumps.
- Spike first with options + impact. No TBD. No 2–5 minute
  code novel. Each stacked PR names the files it touches.

## GREEN R — non-stale pick + “plan this”, no design

- Grain exists. Vendor pick does **not** change Outcome / In / Out
  or grain (example: Open-Meteo for today + device location).
- No design in-thread. User names only one document: **plan this**.
- Leaf: `write-plan` (not `write-design`). Plan may derive cuts the
  same way `write-design` would.
- Did not override the named leaf with “next unfinished.”

## GREEN P — after a pick that would change In/Out

- Grain exists. User names a vendor that would move In/Out or grain.
- Leaf: `write-spec` (not `write-design`). Then stop. Point at `size-work`.
- Did not design on the stale spec. Did not auto-continue spec → size → design.

## RED-M — omit-approaches (pre-letter)

Follow current `write-spec` + `kinds.md` as written. Slim dump.
Expect: Outcome / In / Out / Open decisions / Standards / Close.
**Approaches** absent. Stack not compared. Weather spike may still
appear from the existing ladder (that is a different letter).

Observed (agent `ee98e06e-f734-49a6-ad56-b588bbb56e15`): Approaches
**no**. Stack named **no**. Weather vendor as spike **yes**
(one-liner, no vendor options). Classes/plan **no**.

## RED-N — omit-cut-notes (pre-letter)

Follow current `write-design` after grain. Slim dump. No class list.
Expect: Cuts with interface + first impl + who depends + thin/fat.
**No** error note and **no** test note on those cuts.

Observed (agent `02409e37-9c07-4d52-9e47-181f6c5548d5`): three cuts,
interface+impl+depends+thin/fat **yes**; error note **no**; test
note **no**. Followed “Cuts — interface, first implementation, who
depends, thin or fat.”

## RED-O — omit-file-map (pre-letter)

Follow current `write-plan` after grain, using a design’s cuts.
Expect: Spike first + stacked PRs. **No** File map. PRs do not
name exact paths.

Observed (agent `9a71362c-b021-4303-8782-206dd3813091`): spike first
**yes**; File map **no**; PRs name files **no**; 2–5 minute contract
**no**.

## RED-P — one-line-spike (pre-letter)

Same prompt as RED-M. Expect a spike that only names the question
(“which weather vendor/API”) with no real options and no
per-option impact.

Observed (same `ee98e06e`): “which weather vendor/API to call” —
no vendor list, no pros/cons, no per-option In/Out/cuts impact.

## RED-Q — stale-spec-after-pick (pre-letter)

Grain exists. User names a vendor whose contract would change
In/Out (or must be judged for that) and says “design the
classes” — not “rewrite the spec.”

Current compose: after-grain “design this” → `write-design`.
No after-pick impact check.

Observed (agent `1ecd0a3a-c366-42df-81b6-7a4a458d564e`,
SevenDayWeather + “Design the classes”): leaf **write-design**.
Re-ran write-spec? **no.** Pointed at size-work? **no.** Cuts
emitted? **yes.** Controlling sentence: do not re-run
`write-spec` unless they **explicitly** asked to rewrite In/Out.

## RED-R — plan-after-nonstale-pick (pre-fix letter clash)

Grain exists. No design. User: settled vendor that would **not**
stale In/Out (Open-Meteo) + “plan this.”

Current clash: **After a spike pick** table (“only cuts” /
“nothing material” → `write-design` if no design) has no
user-label carve-out. Paragraph / router say user label still
wins when the pick is not stale.

Expect: kinds-literal agent takes `write-design`.

Observed (agent `749b1949-942c-4f13-a89f-c475c2d70602`): leaf
**write-design**. write-plan? **no.** Treated “plan this” as a
winning user label? **no.** Controlling row: “Only cuts / seams /
errors | `write-design`.” Compose: “Spike pick landed | see After
a spike pick | that table.”

## RED-S — cute-cut-names (pre-letter)

Follow current `write-design` after grain. Slim dump. No class list.
Current letter: “Names are yours” / GREEN C “names free.”
Expect: interface + first impl may be poetry / vibe / cute
one-word names (`Here`, `Place`, `TodayBoard`, `ComposeToday`)
that need the design prose to decode. Job-shaped names may
still appear; they are not required.

Do not require Superpowers dump strings as the fail. The hole
is “names free,” not “must not say LocationProvider.”

## RED-T — flat-src-map (pre-letter)

Follow current `write-plan` after grain, using a design’s cuts.
Current letter: File map = exact paths + cut names. No grouping
rule.
Expect: a flat `src/*.ts` dump (every cut’s files in `src/` with
no per-cut folder) still passes paths / no-TBD / no 2–5 minute
novel.

## RED-U — hex-only-tree (pre-letter)

Same prompt as RED-T. Current letter has no tree rule, so an
agent may treat `domain/` / `ports/` / `adapters/` / `views/`
as the only legal tree (Superpowers hexagonal folders). That
is the hole: mandatory layer folders, not colocation by cut.

## RED-V — any-grouping (pre-tighten)

Follow the loose colocate letter (`src/<cut>/` or equivalent
holds interface + first impl + fake + one unit test).
Expect: any per-cut folder dump still GREEN — including a
mixed-cut dump or a distant `tests/` tree — because the
letter scored “some grouping,” not colocate-by-cut
(capability folder, port + first impl together, tests beside
the file). The three accepted nests still pass.

## RED-W — location-token-only / weather-only-pass (pre-scale)

Skill prose + evals that treat `LocationProvider` + the
weather Location tree as the scored shape. Same weather dump:
`DevicePosition` + `BrowserDevicePosition` would fail. Charge
dump would fail unless it copies weather names. Hole: one
novel memorized; the letter does not scale.

## RED-X — invent-convention (pre-letter)

Follow current `write-plan` + `kinds.md` File map after grain,
using `house-dump.md` + `house-repo/`. Current letter:
colocate-by-cut is unconditional. Distant `tests/` and flat
`src/*.ts` are always RED. “Tests live in tests/” is a
rationalization to reject the house.
Expect: a plan that follows `lib/geo/` + `tests/geo/` +
function modules **fails** as distant-tests / not
colocate-by-cut. A plan that invents
`src/Location/Provider/` + classes + tests-next-to-file
**passes** the current File map Failures. Hole: no
existing-repo predicate. Greenfield `distant-tests` /
`flat-src-map` stay the right RED on weather/charge dumps.

## GREEN observed (after the letters)

Ban: `docs/superpowers/**`, `weather-eval.md`, `house-eval.md`,
this file. Fresh `generalPurpose` subagents.

### A — write-spec, slim dump, before grain

- Agent: `335a1b7f-d023-40a0-a409-30fc7f48135e`
- Approaches: TS + Vite + Vitest + static page vs React vs Next. Pick (1).
- Spike: Open-Meteo vs OpenWeatherMap, pros/cons + impact. Stack explained.
- Vendor not swallowed. Classes/plan **none**. Stop → `size-work`. Pass.

### C — write-design after grain

- Agent: `10677dbd-bb6d-42f0-8d9a-d3d5d5a31fc3`
- Cuts `LocationSource` / `TodayWeatherSource` / `WeatherPage`: each
  has interface, impl, depends, thin/fat, error note, test note
  (faked vs real). Out seams only. No plan. Pass.
- Those names still **name the job** (synonym family, not a
  Superpowers token). `DevicePosition` + `BrowserDevicePosition`
  would also pass. Cute / poetry-only names fail. Requiring
  `LocationProvider` as the only token would now fail.

### D — write-plan after grain

- Agent: `825b63b7-7233-4f00-a1d9-d7c157e8a118`
- Spike first with Open-Meteo vs OpenWeatherMap + impact. File map
  (design cut names) before stacked PRs. Each PR names files. Paths
  match. No TBD. No 2–5 minute novel. Spike not swallowed. Pass.
- Prior D scored paths only, then any per-cut folder, then a
  weather Location tree. The scale letter scores colocate-by-
  cut + synonym folders. `src/DevicePosition/…` GREEN.
  `src/Charge/…` must also GREEN. A flat `src/*.ts` dump, a
  distant `tests/` tree, a mixed-cut dump, a mandatory
  hexagonal tree, or `LocationProvider` as the only pass fail.

### P — CityFormWeather + “Design the classes”

- Agent: `d39e1652-a1f5-47c0-8787-d6231f5d6723`
- Leaf: `write-spec` (pick would change In: device location → typed
  city). Pointed at `size-work`. No Cuts. No auto-continue. Pass.

### K — kinds-literal write-spec

- Agent: `361c5fde-4de1-4853-b266-d168991823c5`
- Approaches + stack pick. Weather spike with ≥2 vendors + impact.
  Not a one-liner. Not omitted for “dump didn’t say open” / “no
  cuts.” Not silent on stack. Pass.

### R — non-stale Open-Meteo + “plan this”, no design

- Agent: `a3e35f3b-cd60-4887-a647-7eb8ee35295a`
- Leaf: **write-plan**. Step 2 user label. “No design yet” →
  write-design? **no.** write-design? **no.** write-spec? **no.**
  File map + stacked PRs + spike options. Pass.

### P reconfirm — CityFormWeather + “design the classes”

- Agent: `a3ef2ae5-c136-4052-b5c4-9ab725ee28a9`
- After a spike pick **step 1**. Leaf: `write-spec`. Stale? **yes.**
  write-design? **no.** Pointed at size-work? **yes.** Pass.

## PIN GREEN contracts (score these; do not drop)

### conversation-only / named sink

- No sink named → conversation only. No spec file. No `docs/work/`.
- Named sink → publish there after the document, in that sink’s shape.

### then-build

- “spec this then build” → finish `write-spec`, **hand back**. Did not
  build, design, plan, or size.

### do-not-grill

- Weather dump → separated. Did not grill from scratch.

### demote-ladder / silent-only-forced

- Weather API stays a spike unless demoted with a named default **and**
  why later cuts would not change.
- Silent only when the dump already forced the stack (or only one
  legal option). Never silent on an external vendor/API.

### sibling-from-open-path

- Router reads `../write-*/SKILL.md` from this `SKILL.md`’s directory,
  or from the path used to open it. Still real — do not drop the prose.
