# Parked eval — weather page

GREEN must match this card unless the specify-work letters themselves force a change (they must not).

After `write-spec`, size-work would classify `shape-feature` (largest fit; `shape-story` is the adjacent ask-once).

| Slot | Value |
|---|---|
| Inventory | One story — today’s weather for my location on one page |
| Out | URL-query location; multi-day (3/7/10-day) forecast |
| Path | That story |
| Parallel | `None` |
| Separate | `shape-task` spike for which weather API |
| After grain | Class / ISP / stacked-PR work — not inventory |

Design names are **agent-chosen**. GREEN scores shape (interface + first impl per cut; steps cover the sized outcome; thin where a consumer would not need extra methods), not `LocationProvider` / `SingleDateProvider` spelling.

GREEN also requires the Superpowers-gap letters (score shape, not dump names).
Approaches ≠ spike options.

| Leaf | Required |
|---|---|
| `write-spec` | **Approaches** — 2–3 **build** alternatives (stack / architecture), trade-offs, recommended pick including stack (language / bundler / test runner / page vs framework) when the dump did not settle one. **Open decisions spike** — at least two real vendors, each with pros/cons and impact (key vs no key, forecast fields, whether In/Out, grain, later cuts, auth, data shape, or tests move). Weather API stays a **spike** unless demoted with a named default **and** why later cuts would not change. Stack pick is usually **explained**, not a substitute for that spike. Fail if silent on stack while inferring a weather spike. Fail if Approaches swallows the vendor. Fail if the spike is only “pick a weather API.” |
| `write-design` | Every cut also states **error / failure** states that cut owns, and **how that cut is tested** (faked vs real). Short notes, not test code, not a plan, not stories. Fail if a cut has interface + impl but no error note and no test note. Fail if a just-landed pick would change In/Out or grain and this leaf designs anyway. |
| `write-plan` | **File map** before the stacked-PR list: exact paths to create/modify and what each file is responsible for, using this design’s cut names. Each stacked PR names the files it touches. Spike still first as a `shape-task` **with options + impact**, not a one-liner. Fail if stacked PRs and no paths. Fail if the plan is a 2–5 minute code novel. |

Do not treat this file as a user prompt. The input dump is `weather-dump.md`.
Scorer letters: `eval-letters.md`.
