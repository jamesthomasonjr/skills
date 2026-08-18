---
name: orient-module
description: >-
  File, module, or class orientation briefing. Use when catch-me-up
  resolves a path or type, or when the user explicitly asks what a
  file/module/class is for and which methods matter. Read-only.
disable-model-invocation: true
---

# Orient module

Read-only briefing of one file, folder, module, or type. Apply only the modes the router passed. Lenses: [../catch-me-up/modes.md](../catch-me-up/modes.md).

If invoked directly with no mode list: infer Architecture (local) + Convention + Syntax. Add Feature Trace if the user asked how it works.

## Always gather

- Path
- Exports / public surface
- Who imports it
- What it imports
- The 3–7 methods or types that do the real work (name and role, not a full walkthrough)

## Lenses at this scope

- Architecture: where it sits in the system
- Convention: match or clash with 3–5 peers
- Feature Trace: one call in, one call out (required if the router said so)
- Syntax: dense APIs
- Testing: how this unit is tested
- History: why this file looks like this (`git log` / blame on this path only)

## Briefing shape

1. One-paragraph purpose
2. Public surface table
3. Important methods (name, role)
4. Collaborators
5. Extra selected modes
6. “If you need a step-by-step, name a function.” (Skip this line if the user already named a function and the router should have sent them to `orient-function` — if that happened, you classified wrong; stop and hand back to `catch-me-up`.)
7. One close question: go deeper, add a mode, or stop

Cite `path:line`. Do not invent a public API. If README and code disagree, prefer code and note it.

## Mixed turn

Finish the briefing, then hand back. Do not implement. Do not edit in this turn even if they already asked for a change. They must send a new message after the briefing.
