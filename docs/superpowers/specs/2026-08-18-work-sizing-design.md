# Work sizing skill family

Date: 2026-08-18
Status: verified (RED baseline + GREEN subagent runs)
Repo: jamesthomasonjr/skills

## Problem

Users describe work at wildly different grains — “rebuild billing,” “add a coupon field,” “migrate the auth table” — and agents collapse everything into a single spec or implementation plan. That skips hierarchy: initiatives and epics need child inventories, not specs; features need stories; only stories (and occasional tasks) should carry enough context for a later specify/brainstorm step.

## Goals

- Classify a work description as initiative, epic, feature, user story, or (when necessary) task.
- Route to a level skill that shapes that unit and decomposes **one level down**.
- Large units produce child inventories (initiative→epics, epic→features, feature→stories), not specs or plans.
- Stories and tasks produce **spec-ready briefs** — enough context for a future prompt to run brainstorming / Spec Kit specify / to-spec — without writing the full spec here.
- Stay project-agnostic and tracker-agnostic (conversation-first; optional markdown save).

## Non-goals

- Writing full product specs, Spec Kit `spec.md`, or Superpowers design docs.
- Writing implementation plans or executing code.
- Publishing to GitHub/Linear (no tracker setup required).
- Replacing brainstorming, writing-plans, Spec Kit, or mattpocock to-spec / to-tickets.
- Multi-level cascade in one turn (do not initiative→stories in one shot).

## Sources

| Source | What we take | What we drop |
|---|---|---|
| This repo’s catch-me-up family | Thin router → depth skills; shared vocabulary file; hard rules; handoff contract | Read-only / path:line briefing shape |
| obra/superpowers | Process chaining; “too large → decompose first” from brainstorming; plans only after design | Bite-sized implement tasks; TDD pipeline |
| github/spec-kit | Spec as requirements + user stories; success criteria; clarify before plan | Constitution/plan/tasks/implement commands; `.specify/` layout |
| mattpocock/skills | ask-matt routing map; to-spec story richness; to-tickets vertical slices + quiz; wayfinder for foggy large efforts | Issue-tracker publish; ready-for-agent labels; CONTEXT.md requirement |

## Architecture

Six promoted engineering skills. One sequential agent. Router classifies, confirms if ambiguous, hands off. Level skill shapes the unit and lists children (or a brief). Router does not shape.

```
skills/engineering/
  size-work/
    SKILL.md       # router: classify, confirm if needed, hand off
    levels.md      # hierarchy definitions + classification signals
  shape-initiative/
    SKILL.md       # charter + epic inventory
  shape-epic/
    SKILL.md       # epic brief + feature inventory
  shape-feature/
    SKILL.md       # feature brief + story inventory
  shape-story/
    SKILL.md       # spec-ready user-story brief
  shape-task/
    SKILL.md       # atomic task brief (escape hatch)
```

Hard rules for the whole family:

- Do **not** implement, scaffold, or edit application code.
- Do **not** write a full spec, design doc, or implementation plan inside this family.
- Decompose **exactly one level**. Never skip (initiative must not emit stories).
- Large levels emit **child titles + one-liners**, not acceptance criteria or Given/When/Then.
- Story/task briefs are **spec-ready**, not specs. Close by offering the next skill outside this family.
- If classification is ambiguous between two adjacent levels: recommend one, ask once, then continue.
- Mixed turn (“break this down, then build it”): finish sizing, then **hand back**. Do not implement in this turn.

## Hierarchy

| Level | Grain | Decomposes into | Output of shape skill |
|---|---|---|---|
| Initiative | Strategic theme; multi-team / multi-quarter; several outcomes | Epics | Charter + ordered epic list (title + one-liner each) |
| Epic | Coherent outcome over weeks–months; several capabilities | Features | Brief + ordered feature list (title + one-liner each) |
| Feature | User-perceivable capability; one shippable chunk | User stories | Brief + ordered story list (title + user-value one-liner) |
| User story | One user journey / value slice | Spec later (or tasks if necessary) | Spec-ready brief |
| Task | Atomic engineering chore; non-user-facing or too small for a story | — | Spec-ready / implement-ready brief |

### Classification signals (router)

Prefer the **largest** level that still fits. Explicit user labels win (“this is an epic”).

| Signal | Level |
|---|---|
| Program / theme / “platform,” multiple products or teams, quarters+, several distinct outcomes | Initiative |
| Named outcome with multiple capabilities underneath; “epic”; weeks–months of work | Epic |
| One capability users can name; “feature”; “add X to the product” (user-perceivable); shippable alone | Feature |
| As-a / I-want / so-that; one journey; “story”; small vertical slice | User story |
| Migrate, rename, wire CI, “add a retry|index|log”; no user-facing value alone | Task |
| Ambiguous between two adjacent levels | Ask once with a recommendation |

### One-level rule

```
Initiative ──► Epics
Epic        ──► Features
Feature     ──► User stories
User story  ──► Spec-ready brief (optionally note candidate tasks; do not force)
Task        ──► Brief only
```

Expanding a child further requires a **new** invocation of this family (or the user naming that child).

## Router (`size-work`)

1. Read the work description (and any attached doc the user pointed at).
2. Classify using [levels.md](../../../skills/engineering/size-work/levels.md).
3. If ambiguous: one question with recommendation; stop until answered **or** proceed when the user already said “just pick.”
4. Announce classification in one line.
5. Read the matching `shape-*` sibling and work as that skill. Pass: level, original description, any constraints the user stated.

Router does not invent child lists. Router does not write files.

## Level skills

### `shape-initiative`

Produce:

1. Working title
2. Outcome / why (2–4 sentences)
3. Boundaries (in / out at initiative grain)
4. Success signals (measurable, not implementation)
5. Constraints / dependencies (known)
6. **Epic inventory** — 3–9 epics: title + one-liner + rough order/priority. No feature lists. No stories. No specs.
7. Close: pick an epic to shape next, or stop.

### `shape-epic`

Same shape at epic grain; **Feature inventory** instead of epics. No stories. No specs.

### `shape-feature`

Feature brief (problem, who benefits, outcome, boundaries, constraints for non-story dependencies) + **User story inventory** (title + “As a… I want… so that…” one-liner each). No full acceptance scenarios. No technical design. Close: pick a story to deepen, or stop.

### `shape-story`

Spec-ready brief:

- Title
- User story statement (As a / I want / so that)
- Problem & context (enough for a stranger agent)
- Scope in / out
- Acceptance sketch (3–7 bullets — not a full Spec Kit scenarios section)
- Edge cases to explore later
- Dependencies / assumptions
- Suggested next step: brainstorming, Spec Kit `/speckit.specify`, or mattpocock `/to-spec` — do not run those here unless the user explicitly asks in a **new** message after this brief.

Optional: if the story is still too large or mixes unrelated chores, offer to split into stories or note candidate tasks — do not silently become `shape-task`.

### `shape-task`

Use only when the work has no meaningful user-facing story, or the user explicitly asked for a task. Brief: goal, why, steps sketch, done-when, risks. Close: ready for implement / writing-plans — do not implement here.

## Artifacts / Outcomes

Tracker-agnostic. The shaped charter, inventory, or brief is the portable artifact.

1. **Default — conversation only.** Do not write files or create tracker items unless asked.
2. **Named sink.** If the user names a destination (markdown path, GitHub issues, beads, tk, Linear, etc.), publish there in that sink’s native shape after shaping. Do not invent a tracker or require setup.
3. **Tracker skill / prompt.** If they want a dedicated publish skill or prompt, finish shaping first, then hand off — do not publish in this turn unless they also named a sink.

Markdown under `docs/work/<level>/YYYY-MM-DD-<slug>.md` is only a sink when they ask for files (or that path).

## Failure modes this family must prevent

- Jumping from initiative/epic straight to a spec or implementation plan.
- Skipping levels (initiative → stories).
- Writing Given/When/Then catalogs at feature-or-above.
- Implementing or scaffolding in the sizing turn.
- Underspecified stories (“add auth”) with no problem/context/acceptance sketch.
- Treating every request as a feature.
- Cascade: shaping all child epics’ features in one turn.

## Testing

RED/GREEN scenarios live in `docs/superpowers/plans/2026-08-18-work-sizing-baseline.md`.

Minimum scenarios:

1. Initiative-scale description → classify initiative; epic inventory only.
2. Feature-scale → story inventory; no spec.
3. Clear user story → spec-ready brief; no implement.
4. Ambiguous epic-vs-feature → ask once.
5. Task-shaped chore → `shape-task`, not a fake user story.
6. Mixed turn (“break down then build”) → size, hand back, no code.
