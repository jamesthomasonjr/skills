---
name: orient-repo
description: >-
  Whole-repo orientation briefing. Use when catch-me-up hands off a repo
  onboard or a targeted journey with no code locus, or when the user
  explicitly asks to map project structure, entry points, or architecture.
  Read-only.
disable-model-invocation: true
---

# Orient repo

Read-only briefing of the current workspace. Apply only the modes the router passed. Lenses: [../catch-me-up/modes.md](../catch-me-up/modes.md).

If you have no mode list (direct invoke, or a leaked empty handoff): treat as **onboard**. Ask the six-mode menu, then **stop**. Do not gather. Do not list the tree, entry points, or test command. After the user picks modes, run Always gather and brief.

## Always gather

Do not run this section when the mode list is empty. Empty is unanswered onboard, not “some modes.”

Once at least one mode is selected:

1. What the project is (README, manifests, one-line purpose). Prefer code if README conflicts.
2. Directory layout: top-level + depth-two. Skip vendor/build/`.git`.
3. Entry points: main, HTTP, CLI, workers.
4. How to run tests, if obvious from manifests or README.

Do not swallow the repo. Architecture samples **3–5 key files** at top-level + depth-two.

## Hello Interview map (Architecture)

When Architecture is on, fill:

- Entry points
- Key functions (the hard core, not a list of every export)
- Class / data-model hierarchy
- Architectural pattern
- Public interfaces vs internals
- Where state lives
- Existing tests
- Constraints / assumptions in comments or config

## Feature Trace

When Feature Trace is on: follow one path as far as the path needs. Do not detour.

## History

When History is on (including onboard with History and no Feature Trace): `git log` / blame on files **already in the Architecture sample** (the 3–5 key files plus entry points from Always gather). Last ~15 commits or the introducing commit. Not the whole tree. If git is unavailable or the sample has no history, one line and skip.

## Briefing shape

1. Purpose (2–4 sentences)
2. Map (tree or table)
3. Entry points and data flow
4. One section per selected mode
5. Read these next (3–7 pointers with `path:line`)
6. Open questions / unverified claims
7. One close question: go deeper (name a module/function), add a mode, or stop

Cite `path:line` and a short snippet for every non-obvious claim. Tables for surfaces; at most one mermaid for one flow.

## Mixed turn

If the router passed a change request: finish this briefing, then hand back. Do not implement. Do not edit in this turn even if they already asked for a change. They must send a new message after the briefing.

## Failures

- No modes yet: menu, then stop. Gathering before a pick is a failed run.
- Empty tree: say so and stop.
- Monorepo: stay in the workspace root; say if you only mapped a package.
- Mode has no signal: one line, skip.
