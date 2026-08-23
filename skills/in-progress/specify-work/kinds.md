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

**Before grain**, `write-spec` on a mixed dump (outcome + classes +
plan) **separates**. It emits a class-free spec. It does **not** abort.
Do not treat “classes appear in the dump” as “stop, do not write the
spec.” **After grain**, a re-sent mixed dump is `write-design` (see
Compose order), not a second spec.

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

## Compose order

```
write-spec → size-work → write-design → write-plan
```

Grain means a spec was already consumed. One leaf this turn. User
label wins when they name **only one** document.

| When | Ask | Leaf |
|---|---|---|
| **Before grain** | spec+design+plan, or a mixed dump | `write-spec`. Separate. Do not abort on classes. Stop. Point at size-work. |
| **After grain** | spec+design+plan, a re-sent mixed dump, or design+plan | `write-design` first, then hand back. Do **not** re-run `write-spec` unless they explicitly asked to rewrite the spec or change In/Out (requirements that can change grain). |
| **After grain** | spec only (explicit rewrite / In/Out change) | `write-spec` |
| **After grain** | plan only | `write-plan` |

## Rationalizations

| Excuse | Reality |
|---|---|
| “SOLID is in the spec, so this is an epic” | Labels do not bump grain. |
| “I’ll list LocationProvider as a story so size-work can sequence it” | Classes are not inventory. Design after grain. |
| “Stacked PRs are required, so they are children” | Standard → plan, not inventory. |
| “10-day is how we prove ISP, so it is MVP” | 10-day is a requirement. If it is later, it stays Out. |
| “They asked for spec, design, and plan together” **before grain** | `write-spec`. Separate the dump. Hand back. Point at size-work. |
| “They asked for spec, design, and plan together” **after grain** (or re-sent the mixed dump) | `write-design` first. Hand back. Do not re-run `write-spec` unless they asked to rewrite In/Out. |
| “Standards are required this turn, so I should design them” | Labels on the spec. Design after grain. |
| “Classes appear in the dump, so I must stop” | Before grain, separate. Do not abort. After grain, that is not a `write-spec` turn. |
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
- After grain, taking `write-plan` when design is in the ask
- After grain, re-running `write-spec` on a mixed dump / spec+design+plan unless they asked to rewrite In/Out
