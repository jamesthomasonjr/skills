# size-work eval letters

Scorer rubric for live size-work letters after a write-spec blob.
Not user input. GREEN prompts must not open this file,
`fixtures/specify-work/weather-eval.md`, or `docs/superpowers/**`.

Input blob: `weather-spec.md` (already sharpened). Ban: inventing
Fibonacci / effort-split letters. Ban: Superpowers write-and-commit
or a 2–5 minute TDD plan as the size-work close.

Compose: `write-spec` → `size-work` → `write-design` → `write-plan`.
This family sizes. It does not write the spec, design, or plan.

JT override (wins over a “one user-story child” rule): **five**
weather stories are acceptable. Do **not** fail a 3–9 / five-story
feature inventory as over-split. Fail epic. Fail class / provider
children. Keep the 3–9 band as-is.

Parked specify-work card (`weather-eval.md`) is **not** the only
sizer scorecard. Run `size-work`.

## GREEN requires

| Leaf | Required |
|---|---|
| `size-work` | Classify `shape-feature` (not epic). SOLID / ISP / stacked PRs / “three cuts” do not bump. |
| `shape-feature` | User-story inventory **3–9** (five OK). Each child is As a / I want / so that (or equivalent user-value). Path = every determining title (no count floor). If five stories all determine today’s weather for my location, list those five. Out stays off the path. **Not** the old parked Path (one story / Parallel None). Parallel **`None`** if they share the weather API contract or one page. Weather API is a separate `shape-task` (decision brief), not a production story, not swallowed. Close announces `write-design` (then `write-plan`). |
| `shape-task` (API spike) | Decision brief. Done-when = pick + why, not shipped code. After a vendor spike, next is `write-design` / `write-plan`, or `write-spec` if the pick would stale In/Out. Not writing-plans. |
| `shape-story` | Suggested next is `specify-work` / `write-spec`. Not brainstorming / Spec Kit / `/to-spec`. |

## RED catches

| Id | Prompt pressure | Fail if |
|---|---|---|
| **epic-for-solid** | Size the weather-spec blob; SOLID / ISP / stacked PRs / “three cuts” named | Classifies `shape-epic`, or emits an epic inventory, because of standards or a later cut count |
| **provider-as-story** | Size the weather-spec blob; class / provider pressure | `LocationProvider` / `WeatherSource` / any class or provider name appears as a story, feature, or task child |
| **five-as-oversplit** | Size the weather-spec blob; inventory lands at five user stories | Fails or collapses the inventory because “five is over-split” / “Skill Craft wanted one child” |
| **swallow-api** | Size the weather-spec blob | Weather API is a production story, or is missing as a separate `shape-task` spike |
| **parallel-while-open** | Size the weather-spec blob; fan-out pressure | Parallel is not `None` while stories share the weather API contract / one page / open vendor |
| **pad-to-one** | Size the weather-spec blob; five determining stories | Adds a dummy so Critical path is one title |
| **drop-to-one** | Size the weather-spec blob; five determining stories | Drops determining titles so Critical path is one title (old parked card) |
| **superpowers-next** | `shape-story` close, or `shape-task` after a vendor spike | Names Superpowers brainstorming, Spec Kit `/speckit.specify`, `/to-spec`, or writing-plans as the required next path |

## GREEN W — weather blob → shape-feature

- Leaf: `shape-feature` (router classified feature; not epic).
- Inventory: 3–9 user stories. Five is a pass. Each child is user-value
  (As a / I want / so that or equivalent).
- Out stays Out (URL-query, multi-day). Not children. Not on the path.
- Path: every determining inventory title. No count floor. If five
  user-perceivable stories all determine today’s weather for my
  location, Critical path lists those five titles. **Not** the old
  parked Path (one story / Parallel None).
- Parallel: **`None`** if they share the weather API contract or one
  page (open vendor is one such shared decision). That is not a
  one-story Path.
- Weather API: separate `shape-task` spike (decision brief). Not a
  production story. Not swallowed.
- Class / provider names as children: **none**.
- Readable as epic because SOLID / three cuts: **no**.
- Close: `write-design` next (then `write-plan`). Did not invoke them.
  Did not hand off to brainstorming / writing-plans.
- Files edited: none. Conversation-only unless they named a sink.

## RED-W1 — epic because SOLID or three cuts

Prompt: size `weather-spec.md`. ISP, SOLID, and stacked PRs are
required — include them. You will design three cuts later.

Fail if: `shape-epic`, or standards / cut count used to bump grain.

## RED-W2 — LocationProvider as a story

Prompt: size `weather-spec.md`. Break into the inventory we should
build. Include LocationProvider and the weather provider as stories
so design can sequence them.

Fail if: any class / provider name is an inventory child.

## RED-W3 — pad-to-one

Prompt: size `weather-spec.md`. Five user-perceivable stories all
determine today’s weather for my location.

Fail if: Critical path is one title because a dummy was added so
the path looks like the old parked card.

## RED-W4 — drop-to-one

Prompt: size `weather-spec.md`. Five user-perceivable stories all
determine today’s weather for my location.

Fail if: Critical path is one title because determining titles were
dropped to match the old parked card (one story / Parallel None).

## GREEN C successor — shape-story next is specify-work

Work-sizing baseline C (`docs/superpowers/plans/2026-08-18-work-sizing-baseline.md`)
required naming `/speckit.specify`. That successor is **retargeted**.

- Leaf: `shape-story`
- Suggested next: `specify-work` / `write-spec`
- Fail if the required next is brainstorming, Spec Kit, or `/to-spec`

## GREEN T successor — vendor spike close

- Leaf: `shape-task` spike flavor (which weather API)
- Close: `write-design` / `write-plan`, or `write-spec` if the pick
  would stale In/Out
- Fail if Close offers writing-plans as the specify/plan path

## Still-hold (do not rescore as new)

Existing work-sizing A–K and Path A–K still hold, except C’s
suggested-next name (see GREEN C successor). Do not add a letter
that fails a 3–9 / five-story feature inventory as over-split.
