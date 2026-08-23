# Specify-work skill family (in-progress draft)

Date: 2026-08-23
Status: verified (RED baseline + GREEN A–F; in-progress; not promoted)
Repo: jamesthomasonjr/skills

## Problem

Agents asked to “spec this” or handed a product dump (weather-style thought process: MVP, then how, then classes, then stacked PRs, then later ISP) collapse three jobs into one turn:

1. Sharpen one outcome and park later features.
2. Design classes / providers / seams.
3. Sequence implementation.

A single skill that designs and plans will either **auto-continue** (spec → design → plan → build) or treat **standards** (SOLID, ISP, stacked PRs) and **class lists** as size-work inventory. That bumps a one-story feature into an epic, or hands size-work a class inventory it must refuse.

This family is a **replacement / bake-off** with Superpowers-shaped specify+plan, **not a fork**. It does not copy brainstorming or writing-plans procedure, checklists, 2–5 minute steps, a `docs/superpowers/specs` write-and-commit flow, or “terminal state is invoke writing-plans.”

It is an **in-progress draft**. Not promoted. Cloud-agent install does not link it.

## Goals

- Classify which document they need (spec, design, or plan), announce, hand off.
- Sharpen **one** product outcome. Put later features in Out. Label standards. Stop. Point at `size-work`. Do not invoke it.
- Design classes only **after grain exists**. Seams for later features stay design notes, not new inventory.
- Plan in **stacked PR** units. Keep an open product/API spike as a separate `shape-task`. Do not implement.
- Keep **requirement** vs **standard** as one shared letter so size-work still sees a feature with one story, not an epic or a class list.
- Stay conversation-only unless they named a sink. Mixed “spec then build” finishes the named leaf and hands back.

## Non-goals

- Promoting the family (no root README Skills list, no `skills/engineering/README.md`, no `.claude-plugin/plugin.json`, no version bump).
- Editing the size-work family or retargeting `shape-story`’s suggested-next list.
- Implementing, scaffolding, or editing application code in a specify turn.
- Writing `docs/work/` or committing a spec file unless they named a sink.
- Auto-continuing spec → design → plan → build in one turn.
- A live bake-off against installed Superpowers in this PR (timing later).
- Copying Superpowers brainstorming / writing-plans text.

## Sources

| Source | What we take | What we drop |
|---|---|---|
| This repo’s size-work + next-work + review-changes families | Thin router → leaves; shared playbook next to the router; hard rules; sibling handoff from this file’s directory not cwd; model-invoked router + user-invoked leaves; mixed-turn hand-back; conversation-only Outcomes; Failures list; rationalizations table | Work-level hierarchy; Path compute; ranking; defect gates |
| size-work letters (`levels.md`) | Prefer largest fitting level; one-level rule; spikes are `shape-task`; class lists are not inventory; standards must not bump grain | Router or leaves that size, write Path, or emit inventories |
| Superpowers-shaped specify+plan (failure to replace) | The *job split*: one sharp outcome is not class design is not an implementation sequence | 2–5 minute steps; write-and-commit spec under `docs/superpowers/specs`; “then invoke writing-plans”; grilling from scratch when they already dumped a thought process; auto-continue |

## Approaches considered

1. **Thin router + three leaves + `kinds.md` (recommended).** Matches this repo. Router classifies. `write-spec` sharpens outcome. `write-design` does class design after grain. `write-plan` sequences stacked PRs. Shared letter is requirement vs standard. One sequential agent.
2. **Single mega-skill.** Spec, design, and plan in one `SKILL.md`. That is the RED failure: auto-continue, or SOLID/stacked PRs land in sizing.
3. **Two leaves (spec+design, then plan).** Class design still happens before grain. size-work still receives providers as children.

v1 is approach 1.

## Architecture

Four in-progress skills. One sequential agent. Router classifies, announces, hands off. Leaves write one document each. Router does not write. Leaves do not re-classify. Nobody sizes. Nobody implements.

```
skills/in-progress/
  specify-work/
    SKILL.md       # router: classify, announce, hand off
    kinds.md       # requirement vs standard (authoritative letter)
  write-spec/
    SKILL.md       # one sharp outcome; In / Out; spikes; standards as labels
  write-design/
    SKILL.md       # what vs how; providers; later-feature seams
  write-plan/
    SKILL.md       # stacked-PR units; spike first/separate
```

Hard rules for the whole family:

1. Do **not** implement, scaffold, or edit application code.
2. Do **not** size, write Path, or emit a size-work inventory. After `write-spec`, announce `size-work` and **stop**. Do not invoke it.
3. Do **not** hand size-work a class list, provider list, or standard-as-child.
4. A **requirement** may change grain / inventory. A **standard** must never bump grain and must never appear as an inventory child.
5. Router does not write the spec, design, or plan. Leaves do not re-do the router’s classify.
6. Read sibling `SKILL.md` files from **this file’s directory**, not from cwd. After a later symlink or plugin copy, `skills/in-progress/...` may not exist.
7. Conversation-only unless they named a sink (same Outcomes idea as size-work). Do not invent `docs/work/` or commit a spec file.
8. Mixed turn (“spec this then build” / “plan then start”): finish the named leaf, then **hand back**. They must send a **new message** to build.
9. Do not auto-continue to the next specify leaf in this turn.

## Invocation

| Skill | Invocation |
|---|---|
| `specify-work` | Model-invoked. Omit `disable-model-invocation`. |
| `write-spec` | User-invoked (`disable-model-invocation: true`). |
| `write-design` | User-invoked (`disable-model-invocation: true`). |
| `write-plan` | User-invoked (`disable-model-invocation: true`). |

### Router description (`specify-work`)

Third person; what it does and when to use it (this repo’s catalog convention). Router for specifying work. Use when the user wants a spec, design, or implementation plan, or dumps a product idea to sharpen before sizing. Classifies which document they need and hands off; does not write the spec, design, or plan.

Do not summarize the three output contracts or the requirement/standard letter in the description (SDO).

### Leaf descriptions

- `write-spec` — Sharpen one product outcome. Use when `specify-work` hands off, or the user wants an outcome / MVP In / later-features Out before sizing. Does not design classes or write a plan.
- `write-design` — Design interfaces and providers. Use when `specify-work` hands off, or the user asks to design a story/feature after grain exists. Does not resize or write the implementation plan.
- `write-plan` — Sequence stacked-PR units. Use when `specify-work` hands off, or the user asks for an implementation plan after grain exists. Does not change grain or implement.

## Playbook (`kinds.md`)

Shared letter. **REQUIRED** for the router (before classify) and every leaf. If wording here conflicts with a `SKILL.md` summary, **this file wins**.

### Two kinds

| Kind | What it is | Where it lives | What it may change |
|---|---|---|---|
| **Requirement** | A product fact users can perceive (example: 10-day forecast; location from a URL query) | `write-spec` **MVP In** or **Later-features Out** | Grain and inventory. If it is in MVP In, size-work may pick a larger level. If it is in Out, it must not become an inventory child. |
| **Standard** | A quality or workflow constraint (example: ISP, SOLID, stacked PRs) | `write-spec` **Standards** as **labels only**; workflow detail in `write-plan`; seams in `write-design` | The **plan** (and labels on the spec). **Never** bumps a feature to an epic. **Never** appears as a size-work inventory child. |

size-work must still refuse a class list even if the spec is full of SOLID labels. This family must not hand size-work a class inventory.

### Class lists

`LocationProvider`, `DateProvider`, `WeatherProvider`, and ISP splits (`SingleDateProvider` / `DateRangeProvider`) are **not** requirements and **not** inventory. They are design.

**Stop** (point at `write-spec` → `size-work`) only when the **ask is the class list as the work**, or when `write-design` / `write-plan` would run **before grain**. `write-spec` on a mixed dump **separates**; it does not abort because classes appeared. No-grain for design/plan is the same stop even with no class list. “Design this story/feature after grain” still requires grain.

### Open decisions

An unanswered product or API choice (example: which weather service) is a **spike**. `write-spec` lists it under Open decisions. size-work would shape it as a separate `shape-task`. `write-plan` may list that spike first. It must not swallow the spike into a production implementation PR.

## Router (`specify-work`)

1. Read [kinds.md](../../../skills/in-progress/specify-work/kinds.md) before classifying.
2. Classify which document they need. Explicit user labels win.
3. Announce in one line. Pass the original dump, any named grain/inventory, and any mixed-turn build request.
4. Read the **sibling** leaf from this file’s directory (not cwd) and follow it.
5. Do not write the document in the router. Do not size. Do not implement.

### Classify

| Signal | Leaf |
|---|---|
| “spec this”; product dump; one outcome not yet sharpened; In/Out; foggy idea | `write-spec` |
| Thought-process dump that already mixes outcome + how + classes + plan (weather-style) | `write-spec` — **separate** the dump; do not grill from scratch; do not emit classes or the plan |
| “design this”; classes / interfaces / providers; what-vs-how; **after grain exists** | `write-design` |
| “plan this”; stacked PRs; implementation sequence; **after grain exists** | `write-plan` |
| Class / provider list as the **first** ask; no sized inventory; no “design this story/feature” after grain | **Stop** — do not treat as inventory. Point at `write-spec` → `size-work`. Do not read `write-design`. |
| Size / shape / break down / how big / inventory / Path | **Out of family** — `size-work` / `shape-*`. Stop. Do not read a leaf. |
| Review / debug / what’s next | **Out of family** — matching family. Stop. |

If they already have grain and ask only for design or only for plan, take that leaf. Do not send them through `write-spec` again.

If two in-family signals both appear, user label wins when they name only one. Before grain, a mixed dump still goes to `write-spec`. After grain, if both design and plan are named, take `write-design` (earlier in the sequence), then hand back. Do not skip to `write-plan`.

### Ambiguity

Questions only when the **idea** is still foggy (one outcome not sharp). That is `write-spec`’s job, not the router’s. The router does not grill.

## Leaves

### `write-spec`

Replacement for Superpowers brainstorming’s **one sharp outcome** job only.

**REQUIRED:** Follow `kinds.md`.

**Output contract (in order):**

1. **Outcome** — one sharp user-perceivable result.
2. **MVP In** — requirements that ship in the first cut.
3. **Later-features Out** — requirements that wait (URL-query location, multi-day forecast, …).
4. **Open decisions** — spikes (product/API questions). Not class names.
5. **Standards** — labels only (`stacked PRs`, `ISP`, `SOLID`). Do not design them.
6. **Close** — announce `size-work` as next. **Stop.** Do not invoke `size-work`, `write-design`, or `write-plan`.

**Must not emit:** classes, providers, Path, implementation plan, stacked-PR list, 2–5 minute steps, a committed spec file (unless they named a sink).

If they already dumped a thought process, **separate** it into the five headings. Do not interview from scratch. Ask only if one outcome is still not sharp.

### `write-design`

This is the class-design skill.

**Requires** grain (a sized inventory). “Design this story/feature after grain” still requires grain; it is not a bypass. If grain does not exist, **stop** and point at `write-spec` → `size-work` — same letter as `write-plan`. A plain “design this” with no class list still bounces. A class dump before sizing is the same stop.

**REQUIRED:** Follow `kinds.md`.

**Output contract (in order):**

1. **What** — the sized outcome (do not change In/Out).
2. **How** — interfaces / providers for the **current** inventory only.
3. **Later-feature seams** — ISP notes (narrow interfaces, fat adapter later). Design notes, **not** new inventory children.
4. **Close** — hand back. A plan needs a **new** message.

**Must not:** resize; add Out items to inventory; write the implementation plan; implement.

### `write-plan`

Bake-off against Superpowers writing-plans. The **unit of work is a stacked PR**: one interface + implementation + tests, plus a mock / test impl of that interface for dependents. Not a 2–5 minute Superpowers step.

**Requires** grain (sized inventory or an explicit plan-this-story/feature after grain). Do not change grain.

**REQUIRED:** Follow `kinds.md`.

**Output contract (in order):**

1. **Spike** — if `write-spec` named an open product/API decision, list it first as a separate `shape-task`. Do not swallow it into a production PR.
2. **Stacked PRs** — one PR per interface: interface + impl + tests + mock/test impl for dependents. Name the GitHub stacked-PR workflow as the standard, not as inventory.
3. **Close** — hand back. Do not implement.

**Must not:** a 2–5 minute step list as the contract; grain bump; class list as size-work children; implement.

## Weather fixture (parked eval)

Do **not** invent a different grain. GREEN must match this card unless the skill letters themselves force a change (they must not).

After `write-spec`, size-work **would** classify `shape-feature` (largest fit; `shape-story` is the adjacent ask-once).

| Slot | Value |
|---|---|
| Inventory | One story — today’s weather for my location on one page |
| Out | URL-query location; multi-day (3/7/10-day) forecast |
| Path | That story |
| Parallel | `None` |
| Separate | `shape-task` spike for which weather API |
| After grain | Class / ISP / stacked-PR work — not inventory |

Thought process, **separated across the three leaves** (do not dump all three from `write-spec`):

1. **write-spec MVP:** single page, today’s weather for the user’s location.
2. **write-spec Out / spike:** URL-query later; multi-day later; which weather API is the spike. Standards labeled only.
3. **write-design how:** get location; maybe today’s date; fetch weather; display. Providers: `LocationProvider` → `UserLocationProvider` (later URL); `DateProvider` → `TodaysDateProvider` (maybe unnecessary); `WeatherProvider` → service of choice (the spike picks it).
4. **write-design seams:** later 3/7/10-day → day vs range methods; `SingleDateProvider` + `DateRangeProvider`; fat `DateProvider` implements both. ISP. Not MVP. Not inventory.
5. **write-plan:** small stacked PRs, one interface + impl + tests each; mock for dependents. GitHub stacked PRs. Spike first and separate.

Input dump lives at `fixtures/specify-work/weather-dump.md`. The parked card lives in this spec and in `fixtures/specify-work/weather-eval.md` (file map only in the fixture README — do not leak GREEN into the dump).

## Artifacts / Outcomes

Same idea as size-work Outcomes:

1. **Default — conversation only.** Do not write files or commit a spec unless asked.
2. **Named sink.** If they name a destination, publish there after the leaf finishes.
3. Mixed-turn build request: finish the leaf, **hand back**. Do not build.

## Failure modes this family must prevent

- Auto-continue from spec into design, plan, or implementation in one turn.
- Classes or ISP splits in `write-spec` output.
- Standards (SOLID, ISP, stacked PRs) as size-work inventory children or as a grain bump (feature → epic).
- Class list as the first ask treated as inventory.
- `write-design` or `write-plan` before grain, without bouncing to `write-spec` → `size-work`.
- Multi-day or URL-query added to inventory during design or plan.
- Spike swallowed into a production implementation PR.
- 2–5 minute Superpowers step list as `write-plan`’s contract.
- Router writing the spec/design/plan.
- Writing `docs/work/` or committing a spec file with no named sink.
- Promoting the draft (catalog / plugin / version).

## Testing

RED/GREEN scenarios live in `docs/superpowers/plans/2026-08-23-specify-work-family-baseline.md`.

RED without the family (or against Superpowers-shaped behavior): a single skill that designs + plans will either auto-continue or put SOLID/stacked PRs into sizing.

GREEN (fresh subagents banned from `docs/superpowers/**`):

- **A:** weather dump → `write-spec` only. Out includes URL + multi-day. Standards labeled not designed. Classes absent. Stops; points at `size-work`.
- **B:** `write-spec` output + size-work letters → would be feature / one story / Path that story / Parallel none / API spike separate. Do not implement size-work. Assert the spec cannot be read as an epic or class inventory.
- **C:** `write-design` after that grain → providers/ISP seams; does not add multi-day to inventory; does not resize.
- **D:** `write-plan` → stacked-PR units, spike first/separate, no 2–5 minute step list as the contract, no grain bump.
- **E:** class list as the first ask → router/`write-spec` does not treat it as inventory; points at `write-spec` → `size-work`.
- **F:** plan-only or design-only ask after grain → correct leaf, not `write-spec`.
- **G:** weather-style mixed dump + `kinds.md`-literal → still emits Outcome/In/Out; does not stop at the class-list line.
- **H:** “design this” with no grain and no class list → stop + pointer, no design output.
- **I:** after grain exists, “design the classes and plan the implementation” → `write-design` (not `write-plan`); hand back.

## Catalog

`skills/in-progress/README.md` indexes the family as a draft. Promoted catalog and `.claude-plugin/plugin.json` stay unchanged. Plugin version stays `0.6.0`.
