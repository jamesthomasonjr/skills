# Parked eval — existing forecast repo

GREEN must match this card unless the specify-work letters themselves force a change (they must not).

Not a Charge-C/D scorer. Not a third 8am novel. Greenfield
Charge-C/D and weather-only-pass stay on `charge-dump.md` /
`weather-dump.md`.

Existing tree: `house-repo/` — `lib/geo/` function modules,
`tests/geo/` (distant from `lib/`), not classes, not
`src/Location/Provider/`.

| Slot | Value |
|---|---|
| Grain | `shape-feature` (not epic). After grain, next is `write-design` (then `write-plan`). Do not invoke. |
| Inventory | User-journey stories for today’s temperature for the device position. Fail epic. Fail class / provider children. |
| Out | 7-day forecast |
| Separate | `shape-task` spike for which weather API (decision brief, not a production story, not swallowed) |
| House | `lib/geo/` function modules + `tests/geo/`. Follow the house. |
| After grain | Class / ISP / stacked-PR work — not inventory |

Design names follow the **house**: function / module names
(`getDevicePosition`), not a class / `LocationProvider` family.

File map scores **follow the house**, not colocate-by-cut.
GREEN: `lib/geo/…` + `tests/geo/…` (or the same house with new
files). RED: invents `src/Location/Provider/` + classes +
tests-next-to-file against this house.

Do not treat this file as a user prompt. The input dump is
`house-dump.md` plus `house-repo/`. Scorer letters:
`eval-letters.md`. GREEN prompts must not open this file,
`weather-eval.md`, `charge-eval.md`, or `eval-letters.md`.
