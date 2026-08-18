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
| Task | Atomic engineering chore with no meaningful user-facing story of its own |

## Classification signals

| Signal | Level |
|---|---|
| Platform / program / “become the X,” multiple pillars or products, year/quarter planning | Initiative |
| Named outcome with several capabilities under it; “epic”; multi-week | Epic |
| One capability users can name; “feature”; “add X to the product” (user-perceivable) | Feature |
| As a / I want / so that; one journey; “user story” | User story |
| Rename, migrate, wire CI, expand-contract; “add a retry|index|log|guard”; no user value alone | Task |

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
