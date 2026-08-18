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
| One capability users can name; “feature”; “add X to the product” | Feature |
| As a / I want / so that; one journey; “user story” | User story |
| Rename, migrate, wire CI, expand-contract chore; no user value alone | Task |

## Ambiguity

If two adjacent levels both fit: recommend one in a single sentence, ask once, then stop until they answer — unless they already said “just pick,” in which case pick the larger level and proceed.

## What each level must not emit

| Level | Forbidden in this family |
|---|---|
| Initiative / Epic / Feature | Full specs, design docs, implementation plans, Given/When/Then catalogs, file-path task lists, skipping to grandchildren |
| User story | Full Spec Kit `spec.md`, Superpowers design doc, implementation, scaffolding |
| Task | Fake “As a…” wrapper, implementation in the sizing turn |
