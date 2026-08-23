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

## GREEN

Skills present: `specify-work`, `kinds.md`, `write-spec`, `write-design`, `write-plan`.

Fresh subagents. Ban: `docs/superpowers/**`, `fixtures/specify-work/weather-eval.md`. Read the named in-progress skill first.

Results filled after GREEN runs.
