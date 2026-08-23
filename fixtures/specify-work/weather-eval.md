# Parked eval — weather page

GREEN must match this card unless the specify-work letters themselves force a change (they must not).

After `write-spec`, run `size-work` (live letters). Scorer:
`fixtures/size-work/eval-letters.md`. This parked card is **not**
the only sizer scorecard, and it does not say “do not run size-work.”

| Slot | Value |
|---|---|
| Grain | `shape-feature` (not epic). Do not ask-once into a single story to shrink Path. After `shape-feature`, next is `write-design` (then `write-plan`). Do not invoke. |
| Inventory | 3–9 user stories (five OK). Fail epic. Fail class / provider children. Do **not** fail five as over-split. |
| Out | URL-query location; multi-day (3/7/10-day) forecast |
| Path | Every determining inventory title. No count floor. If five user-perceivable stories all determine today’s weather for my location, list those five titles. Omit only titles that do not determine done. Out (multi-day / URL-query) stays out of inventory and off the path. **Not** the old parked Path (one story / Parallel None). |
| Parallel | `None` if the stories share the weather API contract or one page (open vendor is one such shared decision). That is not a one-story Path. |
| Separate | `shape-task` spike for which weather API (decision brief, not a production story, not swallowed) |
| After grain | Class / ISP / stacked-PR work — not inventory |

Design names are **agent-chosen** and must **name the job**. GREEN
scores job-readable interface + first impl (file map alone is
enough), not Superpowers dump spelling. `LocationProvider` +
`BrowserGeolocationProvider` is a GREEN shape, not a required
fixture list. Fail cute / poetry-only names (`Here`, `Place`,
`TodayBoard`, `ComposeToday`).

GREEN also requires the Superpowers-gap letters (score job names
and colocation by cut, not dump strings or hexagonal folders).
Approaches ≠ spike options.

| Leaf | Required |
|---|---|
| `write-spec` | **Approaches** — 2–3 **build** alternatives (stack / architecture), trade-offs, recommended pick including stack (language / bundler / test runner / page vs framework) when the dump did not settle one. **Open decisions spike** — at least two real vendors, each with pros/cons and impact (key vs no key, forecast fields, whether In/Out, grain, later cuts, auth, data shape, or tests move). Weather API stays a **spike** unless demoted with a named default **and** why later cuts would not change. Stack pick is usually **explained**, not a substitute for that spike. Fail if silent on stack while inferring a weather spike. Fail if Approaches swallows the vendor. Fail if the spike is only “pick a weather API.” |
| `write-design` | Every cut also states **error / failure** states that cut owns, and **how that cut is tested** (faked vs real). Short notes, not test code, not a plan, not stories. Interface + first impl **name the job** (file map alone is enough). GREEN shape: `LocationProvider` + `BrowserGeolocationProvider`, `CurrentWeatherClient` + `OpenMeteoCurrentWeatherClient` (or equivalent). Fail cute / poetry names (`Here`, `Place`, `TodayBoard`, `ComposeToday`). Do not require Superpowers dump strings. Fail if a cut has interface + impl but no error note and no test note. Fail if a just-landed pick would change In/Out or grain and this leaf designs anyway. |
| `write-plan` | **File map** before the stacked-PR list: exact paths to create/modify and what each file is responsible for, using this design’s cut names. **Colocate by cut** (interface + first impl + fake + unit test together). Each stacked PR names the files it touches. Spike still first as a `shape-task` **with options + impact**, not a one-liner. Fail if stacked PRs and no paths. Fail a flat `src/*.ts` dump. Fail requiring `domain/` / `ports/` / `adapters/` / `views/` as the only legal tree. Fail if the plan is a 2–5 minute code novel. Fail if a non-stale vendor pick + “plan this” (no design yet) is taken as `write-design`. Scaffold may sit at the page cut / composition PR. |

Do not treat this file as a user prompt. The input dump is `weather-dump.md`.
Scorer letters: `eval-letters.md`.
