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
| Task | Atomic engineering chore, known bug/flake fix (with or without user-visible impact), or spike with one clear decision question (time box optional) |

## Classification signals

| Signal | Level |
|---|---|
| Platform / program / “become the X,” multiple pillars or products, year/quarter planning | Initiative |
| Named outcome with several capabilities under it; “epic”; multi-week | Epic |
| One capability users can name; “feature”; “add X to the product” (user-perceivable) | Feature |
| As a / I want / so that; one journey; “user story”; user-framed bug fix **with a known locus** | User story |
| Chore / cleanup / tech debt / expand-contract; rename, migrate, wire CI; “add a retry\|index\|log\|guard”; known bug/flake with a clear locus **and no As-a framing**; spike with **one clear decision question** (time box optional) | Task |
| Vague or intermittent failure with **no** actionable locus (“something’s broken,” “flaky sometimes” with no file/error/repro) | **Out of family** — see Bugs and chores |
| Foggy multi-question exploration (“figure out notifications,” “research the space,” bare “research …” / bare “figure out X” with no sharp A-or-B question) | **Out of family** — see Spikes and research |

## Bugs and chores

Bugs and chores are **kinds** of work, not extra hierarchy levels. Route by grain:

| Signal | Route |
|---|---|
| Chore, cleanup, tech debt, rename, migrate, wire CI, expand-contract | `shape-task` |
| User-visible failure framed as value (As a / I want / so that) **and** a known locus | `shape-story` — **wins** over known-locus → task when both match |
| Known bug or flake with a clear locus (file, error, repro), including “flaky sometimes” **when that locus is named** | `shape-task` — **wins** over intermittent → diagnosing when both match |
| Vague / intermittent / undiagnosed with **no** actionable locus (“something’s broken,” “flaky sometimes” alone) | **Stop.** Hand off to diagnosing or triage skills (e.g. mattpocock `diagnosing-bugs` / `triage`). Do not invent an epic or fake story inventory. |
| Thin As-a wrapping an **undiagnosed** failure (As-a present, **no** locus) | **Stop** / diagnosing — **wins** over `shape-story`. Do not brief a story you cannot point at. |
| Systemic reliability theme (“fix all of notifications”) | Classify on **scope** (epic/feature), not on the word “bug” |

Never wrap a one-line fix in a fake As a / I want / so that. Never force a 3–9 story inventory for a single known bug.

## Spikes and research

Spikes and research are **kinds** of work, not extra hierarchy levels. A spike’s success is a **decision or learning**, not a shipped capability.

| Signal | Route |
|---|---|
| One clear decision question (with or without an explicit time box); labeled “spike” | `shape-task` (spike flavor) |
| Foggy multi-question exploration; bare “research …” / “research the space” with **no** sharp question; destination unclear | **Stop.** Hand off to wayfinder / research / grill skills. Do not invent an epic or story inventory. Foggy wins when the question is not already sharp. |
| “Build a prototype to decide” | Still spike grain here; after the brief, hand off to a prototype skill to build — do not implement the prototype in this family |

Never emit a feature/story inventory for a spike. Never let a spike silently become production implementation in the sizing turn. Bare “research X” or bare “figure out X” is **not** enough for spike flavor unless X is already a single clear decision question (e.g. “figure out whether A or B”).

## Ambiguity

Ask-once only when two adjacent levels both **genuinely** fit.
Recommend one in a single sentence, ask once, then stop until they
answer — unless they already said “just pick,” in which case pick
the larger level and proceed.

A write-spec blob (one user-perceivable outcome; later features Out)
is **feature**. Do not ask-once into a single story to shrink Path.
If a genuine ask-once lands on story, that leaf’s next is
`write-spec` on the story — not `write-design`. See **After a
write-spec blob**.

## What each level must not emit

| Level | Forbidden in this family |
|---|---|
| Initiative / Epic / Feature | Full specs, design docs, implementation plans, Given/When/Then catalogs, file-path task lists, skipping to grandchildren |
| User story | Full Spec Kit `spec.md`, Superpowers design doc, implementation, scaffolding |
| Task | Fake “As a…” wrapper, implementation in the sizing turn |

## After a write-spec blob

A sharpened spec (one user-perceivable outcome; later features Out;
standards as labels; vendor/API still a spike) is **feature** grain
by default. Largest fit. It is **not** an epic.

Ask-once (`shape-story`) only when feature and story both
**genuinely** fit. Do not ask-once into a single story to shrink
Path. A write-spec blob remains **feature**.

**Next leaf follows the shape that ran.** Announce. Do not invoke.
Do not hand off to Superpowers brainstorming or writing-plans.

| Shape that ran | Next |
|---|---|
| `shape-feature` | `write-design` (then `write-plan`) |
| `shape-story` (they picked story at a genuine ask-once) | `specify-work` / `write-spec` on **that story**. Not `write-design`. Not Superpowers. |

Do **not** tell every shape leaf that `write-design` is next after
any write-spec blob. `write-design` needs a feature inventory.
`shape-story` does not emit one.

Standards (SOLID, ISP, stacked PRs) and a later cut count (“three
cuts”) **never** bump grain. They are not capabilities and not
inventory children.

Class / provider / interface names are **not** stories, features,
or tasks. Those are `write-design` cuts after grain. Listing one
as an inventory child is a fail.

`shape-feature` inventory stays **3–9** user stories. Five is in
band. Do not fail five as over-split. Do not add a “one user-story
child” rule.

Path follows [paths.md](paths.md): every determining inventory
title, no count floor. If five user-perceivable stories all
determine done, Critical path lists those titles. Out stays out
of inventory and off the path. Parallel `None` if they share a
vendor/API contract or one page — that is **not** a one-story
Path. Do not pad-to-one or drop-to-one to match an old Path.

An open vendor / API decision stays a separate `shape-task`
(spike flavor) — a **decision brief**, not a production story,
not swallowed into the feature inventory.

## Outcomes

The shaped charter, inventory, or brief **is** the portable artifact. This family is tracker-agnostic.

1. **Default — conversation only.** Do not write files or create tracker items unless asked.
2. **Named sink.** If the user names a destination (markdown path, GitHub issues, beads, tk, Linear, etc.), publish **there** in that sink’s native shape after shaping. Do not invent a tracker or require setup.
3. **Tracker skill / prompt.** Only when they asked for a dedicated publish skill or prompt: finish shaping, then **hand off**. Do not treat “no sink named” as a tracker handoff. Do not publish in this turn unless they also named a sink.

Never invent tickets, issues, or `docs/work/` dumps unprompted. Markdown under `docs/work/<level>/YYYY-MM-DD-<slug>.md` is only a sink when they ask for files (or that path).
