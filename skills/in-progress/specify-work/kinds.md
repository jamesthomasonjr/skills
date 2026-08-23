# Specify kinds

Shared letter for `specify-work` and `write-*`. Those skills are
**REQUIRED** to follow this file. If wording here conflicts with a
`SKILL.md` summary, **this file wins**.

## Two kinds

| Kind | What it is | Where it lives | What it may change |
|---|---|---|---|
| **Requirement** | A product fact users can perceive (example: 10-day forecast; location from a URL query) | `write-spec` **MVP In** or **Later-features Out** | Grain and inventory. If it is in MVP In, size-work may pick a larger level. If it is in Out, it must not become an inventory child. |
| **Standard** | A quality or workflow constraint (example: ISP, SOLID, stacked PRs) | `write-spec` **Standards** as **labels only**; seams in `write-design`; workflow in `write-plan` | The **plan** (and labels on the spec). **Never** bumps a feature to an epic. **Never** appears as a size-work inventory child. |

size-work must still refuse a class list even if the spec is full of
SOLID labels. This family must not hand size-work a class inventory.

## Class lists

`LocationProvider`, `DateProvider`, `WeatherProvider`, and ISP splits
(`SingleDateProvider` / `DateRangeProvider`) are **not** requirements
and **not** inventory. They are design.

**Stop** (point at `write-spec` → `size-work`; do not treat providers
as stories, features, or tasks) only when:

- the **ask is the class list as the work** (no product outcome to
  sharpen; classes/providers are the request), or
- `write-design` or `write-plan` would run **before grain exists**.

`write-spec` on a mixed dump (outcome + classes + plan) **separates**.
It emits a class-free spec. It does **not** abort. Do not treat
“classes appear in the dump” as “stop, do not write the spec.”

**No grain** for `write-design` / `write-plan` is the same stop even
when they did not dump a class list. “Design this story/feature after
grain” still requires grain; it is not a bypass.

## Open decisions

An unanswered product or API choice (example: which weather service)
is a **spike**. `write-spec` lists it under Open decisions. size-work
would shape it as a separate `shape-task`. `write-plan` may list that
spike first. It must not swallow the spike into a production
implementation PR.

## After write-spec

The spec is a feature-shaped outcome plus In / Out / spikes / labels.
It is not an epic. It is not a class inventory. It is not a Path.
size-work reads requirements in In/Out, not Standards, not providers.

## Rationalizations

| Excuse | Reality |
|---|---|
| “SOLID is in the spec, so this is an epic” | Labels do not bump grain. |
| “I’ll list LocationProvider as a story so size-work can sequence it” | Classes are not inventory. Design after grain. |
| “Stacked PRs are required, so they are children” | Standard → plan, not inventory. |
| “10-day is how we prove ISP, so it is MVP” | 10-day is a requirement. If it is later, it stays Out. |
| “They asked for spec, design, and plan together” | One leaf this turn. Separate the dump. Hand back. |
| “Standards are required this turn, so I should design them” | Labels on the spec. Design after grain. |
| “Classes appear in the dump, so I must stop” | Separate. Stop only when the ask is the class list, or design/plan would run before grain. |
| “Design this — no grain, no class list, so proceed” | No grain. Stop. Same letter as write-plan. |
| “They asked for design and plan after grain, so take the later leaf” | `write-design` first. Hand back. Do not skip to `write-plan`. |

## Failures

- Standard listed as an inventory child, or used to bump feature → epic
- Class / provider list handed to size-work as children
- Out requirement pulled into MVP In during design or plan
- Spike swallowed into a production PR
- Aborting `write-spec` because a mixed dump mentioned classes
- Auto-continue spec → design → plan because the dump named all three
- `write-design` or `write-plan` running before grain
- After grain, taking `write-plan` when both design and plan were named
