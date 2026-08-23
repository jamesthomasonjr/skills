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

Class and interface **cuts** are **not** requirements and **not**
inventory. Producing them is `write-design`’s job **after grain**.
`write-design` **derives** steps and cuts from the sized work. A user
class list is a **hint**, not required inventory and not a substitute
for that derivation.

**Stop** (point at `write-spec` → `size-work`; do not treat cuts as
stories, features, or tasks) only when:

- the **ask is the class list as the work** (no product outcome to
  sharpen; classes/providers are the request), or
- `write-design` or `write-plan` would run **before grain exists**.

**Before grain**, `write-spec` on a mixed dump **separates**. It emits
a class-free spec (no cuts). It does **not** abort. Do not treat
“classes appear in the dump” as “stop, do not write the spec.”
**After grain**, a re-sent mixed dump is `write-design` (see Compose
order), not a second spec.

**No grain** for `write-design` / `write-plan` is the same stop even
when they did not dump a class list. “Design this story/feature after
grain” still requires grain; it is not a bypass. After grain,
`write-design` does not wait for a class list.

## Open decisions

`write-spec` **infers** unanswered external or product choices. Do
not require the dump to name them.

Apply the visibility ladder **without a cut prerequisite**. Gate on
the **outcome / MVP In**, not on cuts. `write-spec` does not wait
for `write-design` cuts. “No cuts yet” is not a reason to omit an
Open decision.

If making the outcome true would use an external service, vendor,
library, or product option the dump did not settle, pick the most
visible option that still fits:

1. **Spike** (Open decisions → size-work `shape-task`) — default
   when unclear. Use when we would not write the implementation
   (vendor/API), more than one reasonable option exists, or the
   choice can change **later** cuts, auth, data shape, or tests.
   An external service with no vendor in the dump is this class
   unless demoted below. Example: which weather service.
2. **Explained decision** — only if one standard/free default is a
   no-brainer **and** the pick does not change grain or later
   cuts. Write the pick and why in Open decisions. Not a spike.
   Not silent.
3. **Silent** — only if the choice is forced by an already-stated
   stack or is the only legal option. Never silent on an external
   vendor/API.

If unclear, take the more visible option: spike > explanation >
silent.

“Cuts” in the spike/demote lines means **the later design would
change**, not “cuts must already exist.” An agent may **demote** a
weather-API (or any external vendor/API) from spike to explained
pick only if they name the default and say why a later spike would
not change those future cuts. External, not our code, stays a
spike unless demoted that way.

`write-spec` lists the chosen visibility under Open decisions.
size-work would shape a spike as a separate `shape-task`.
`write-plan` lists that spike first. It must not swallow the spike
into a production implementation PR.

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
| “I’ll list LocationProvider as a story so size-work can sequence it” | Cuts are not inventory. Design after grain. |
| “They didn’t name classes, so write-design cannot run” | Derive cuts from the sized work. |
| “Stacked PRs are required, so they are children” | Standard → plan, not inventory. |
| “10-day is how we prove ISP, so it is MVP” | 10-day is a requirement. If it is later, it stays Out. |
| “They asked for spec, design, and plan together” **before grain** | `write-spec`. Separate the dump. Hand back. Point at size-work. |
| “They asked for spec, design, and plan together” **after grain** (or re-sent the mixed dump) | `write-design` first. Hand back. Do not re-run `write-spec` unless they asked to rewrite In/Out. |
| “Standards are required this turn, so I should design them” | Labels on the spec. Design after grain. |
| “Classes appear in the dump, so I must stop” | Before grain, separate. Do not abort. After grain, that is not a `write-spec` turn. |
| “Design this — no grain, no class list, so proceed” | No grain. Stop. Same letter as write-plan. |
| “They asked for design and plan after grain, so take the later leaf” | `write-design` first. Hand back. Do not skip to `write-plan`. |
| “The dump didn’t say the service is still open, so no spike” | Infer. Do not require the dump to name the choice. |
| “I’ll stay silent; they’ll pick a weather API later” | Never silent on an external vendor/API. Spike unless demoted. |
| “OpenWeather is obvious, so I won’t mention it” | Explained decision only if you name the default and say why a later spike would not change those future cuts. Otherwise spike. |
| “No cuts yet, so the ladder does not apply” | False. Infer from the outcome. “No cuts yet” is not a reason to omit. |

## Failures

- Standard listed as an inventory child, or used to bump feature → epic
- Class / provider list or derived cuts handed to size-work as children
- `write-design` waiting for a class list, or copying a dump’s list as the design
- Out requirement pulled into MVP In during design or plan
- Spike swallowed into a production PR
- Omitting an inferred external/API spike because the dump did not name it as open
- Omitting an inferred external spike because cuts do not exist yet
- Silent on an external vendor/API
- Aborting `write-spec` because a mixed dump mentioned classes
- Auto-continue spec → design → plan because the dump named all three
- `write-design` or `write-plan` running before grain
- After grain, taking `write-plan` when design is in the ask
- After grain, re-running `write-spec` on a mixed dump / spec+design+plan unless they asked to rewrite In/Out
