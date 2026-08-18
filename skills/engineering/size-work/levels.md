# Work levels

Shared vocabulary for `size-work` and `shape-*`. Prefer the **largest** level that still fits. Explicit user labels win (“this is an epic”).

## Hierarchy

```
Initiative ──► Epics
Epic        ──► Features
Feature     ──► User stories
User story  ──► Spec-ready brief (tasks only if necessary)
Task        ──► Brief only
```

**One-level rule:** shape skills emit only the next row down. Never skip. Expanding a child is a new invocation.

## Definitions

| Level | What it is |
|---|---|
| Initiative | Strategic theme spanning multiple outcomes, often multi-team or multi-quarter |
| Epic | One coherent outcome over weeks–months, made of several capabilities |
| Feature | One user-perceivable capability that can ship on its own |
| User story | One user journey / value slice; after this family, ready to specify |
| Task | Atomic engineering chore, known bug fix, or time-boxed spike; no meaningful user-facing story of its own |

## Classification signals

| Signal | Level |
|---|---|
| Platform / program / “become the X,” multiple pillars or products, year/quarter planning | Initiative |
| Named outcome with several capabilities under it; “epic”; multi-week | Epic |
| One capability users can name; “feature”; “add X to the product” (user-perceivable) | Feature |
| As a / I want / so that; one journey; “user story”; user-framed bug fix (“so that errors are clear”) | User story |
| Chore / cleanup / tech debt / expand-contract; rename, migrate, wire CI; “add a retry\|index\|log\|guard”; known bug with a clear locus; spike / research with one clear question | Task |
| Vague or intermittent failure (“something’s broken,” “flaky sometimes,” no locus) | **Out of family** — see Bugs and chores |
| Foggy multi-question exploration (“figure out notifications,” “research the space”) | **Out of family** — see Spikes and research |

## Bugs and chores

Bugs and chores are **kinds** of work, not extra hierarchy levels. Route by grain:

| Signal | Route |
|---|---|
| Chore, cleanup, tech debt, rename, migrate, wire CI, expand-contract | `shape-task` |
| Known bug with a clear locus (file, error, repro) | `shape-task` |
| User-visible failure framed as value (As a / I want / so that) | `shape-story` |
| Vague / intermittent / undiagnosed (“something’s broken”) | **Stop.** Hand off to diagnosing or triage skills (e.g. mattpocock `diagnosing-bugs` / `triage`). Do not invent an epic or fake story inventory. |
| Systemic reliability theme (“fix all of notifications”) | Classify on **scope** (epic/feature), not on the word “bug” |

Never wrap a one-line fix in a fake As a / I want / so that. Never force a 3–9 story inventory for a single known bug.

## Spikes and research

Spikes and research are **kinds** of work, not extra hierarchy levels. A spike’s success is a **decision or learning**, not a shipped capability.

| Signal | Route |
|---|---|
| Time-boxed question with one clear decision (“Can Stripe idempotency keys cover our retry model in 1 day?”); “spike”; “research X” | `shape-task` (spike flavor) |
| Foggy multi-question exploration; destination unclear | **Stop.** Hand off to wayfinder / research / grill skills. Do not invent an epic or story inventory. |
| “Build a prototype to decide” | Still spike grain here; after the brief, hand off to a prototype skill to build — do not implement the prototype in this family |

Never emit a feature/story inventory for a spike. Never let a spike silently become production implementation in the sizing turn.

## Ambiguity

If two adjacent levels both fit: recommend one in a single sentence, ask once, then stop until they answer — unless they already said “just pick,” in which case pick the larger level and proceed.

## What each level must not emit

| Level | Forbidden in this family |
|---|---|
| Initiative / Epic / Feature | Full specs, design docs, implementation plans, Given/When/Then catalogs, file-path task lists, skipping to grandchildren |
| User story | Full Spec Kit `spec.md`, Superpowers design doc, implementation, scaffolding |
| Task | Fake “As a…” wrapper, implementation in the sizing turn |

## Outcomes

The shaped charter, inventory, or brief **is** the portable artifact. This family is tracker-agnostic.

1. **Default — conversation only.** Do not write files or create tracker items unless asked.
2. **Named sink.** If the user names a destination (markdown path, GitHub issues, beads, tk, Linear, etc.), publish **there** in that sink’s native shape after shaping. Do not invent a tracker or require setup.
3. **Tracker skill / prompt.** Only when they asked for a dedicated publish skill or prompt: finish shaping, then **hand off**. Do not treat “no sink named” as a tracker handoff. Do not publish in this turn unless they also named a sink.

Never invent tickets, issues, or `docs/work/` dumps unprompted. Markdown under `docs/work/<level>/YYYY-MM-DD-<slug>.md` is only a sink when they ask for files (or that path).
