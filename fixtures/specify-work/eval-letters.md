# specify-work eval letters

Scorer rubric for the Superpowers-gap letters. Not user input.
GREEN prompts must not open this file or `weather-eval.md`.

Input dump: `weather-dump.md`. Grain (when needed) is the parked card
in `weather-eval.md`. Ban: `docs/superpowers/**`.

One leaf per turn. Before grain, mixed dump → `write-spec`. After
grain, mixed dump → `write-design`. No grain → stop for design/plan.
After a spike pick, follow kinds.md **After a spike pick** (do not
auto-continue that loop).

Approaches ≠ spike options. Approaches = ways to build
(stack / architecture). Spike options = unsettled external /
product choices (vendor / API).

## GREEN requires

| Leaf | New required section |
|---|---|
| `write-spec` | **Approaches** — 2–3 real alternatives, trade-offs, recommended pick. Pick includes stack (language / bundler / test runner / page vs framework) when the dump did not settle one. **Open decisions spike** — at least two real vendor/product options, each with short pros/cons, compare/contrast, and whether it would change MVP In/Out, grain, later cuts, auth, data shape, or tests. |
| `write-design` | Every **cut** states error / failure states that cut owns, and how that cut is tested (faked vs real). Short notes, not test code. |
| `write-plan` | **File map** before the stacked-PR list: exact paths + responsibility, using this design’s cut names. Each stacked PR names the files it touches. Spike first as `shape-task` **with the same option/impact list**, not a one-liner. |

Unchanged compose: weather API stays a **spike** unless demoted with
a named default **and** why later cuts would not change. Stack pick
is usually **explained**, not a substitute for that spike. Still
stop after `write-spec` and point at `size-work`. No auto-continue.
No 2–5 minute step list as the plan contract. No bake-off runner
code. This family points at `size-work` when grain is stale; it
does not edit size-work.

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

## GREEN A — write-spec (before grain, mixed dump)

- Leaf: `write-spec` only. Classes / cuts / plan: **none**.
- Outcome / In / Out / Standards-as-labels / Close → `size-work`: same as before.
- **Approaches** present: 2–3 **build** alternatives (stack / architecture), trade-offs, recommended pick includes stack. Not a vendor list.
- Open decisions: which weather service as a **spike** with **at least two vendors**, each with pros/cons and impact (key vs no key, forecast fields, whether In/Out or cuts move). Stack pick **explained** (named + why), not silent.
- Approaches did not swallow the vendor into a silent / default-without-ladder pick.
- Did not grill. Did not auto-continue.

## GREEN C — write-design (after grain)

- Steps + Cuts; every cut has interface + first impl; names free.
- Every cut also has an **error / failure** note and a **test** note (faked vs real).
- Notes are short. Not test code. Not a plan. Not size-work stories.
- Out items are seams only. No resize.

## GREEN D — write-plan (after grain)

- **Spike** first as `shape-task` with real options + impact (not “pick a weather API”). Not swallowed.
- **File map** before stacked PRs: exact paths + what each file owns; design cut names (not dump names).
- Each stacked PR names the files it touches.
- File-map paths match the PRs. No TBD. No 2–5 minute code novel.

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

## GREEN observed (after the letters)

Ban: `docs/superpowers/**`, `weather-eval.md`, this file. Fresh
`generalPurpose` subagents.

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

### D — write-plan after grain

- Agent: `825b63b7-7233-4f00-a1d9-d7c157e8a118`
- Spike first with Open-Meteo vs OpenWeatherMap + impact. File map
  (design cut names) before stacked PRs. Each PR names files. Paths
  match. No TBD. No 2–5 minute novel. Spike not swallowed. Pass.

### P — CityFormWeather + “Design the classes”

- Agent: `d39e1652-a1f5-47c0-8787-d6231f5d6723`
- Leaf: `write-spec` (pick would change In: device location → typed
  city). Pointed at `size-work`. No Cuts. No auto-continue. Pass.

### K — kinds-literal write-spec

- Agent: `361c5fde-4de1-4853-b266-d168991823c5`
- Approaches + stack pick. Weather spike with ≥2 vendors + impact.
  Not a one-liner. Not omitted for “dump didn’t say open” / “no
  cuts.” Not silent on stack. Pass.
