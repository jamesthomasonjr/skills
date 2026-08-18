---
name: orient-function
description: >-
  Function or method walkthrough. Use when catch-me-up resolves a function
  or method, or when the user asks what a function does step by step,
  including inputs, outputs, side effects, and edge cases. Read-only.
disable-model-invocation: true
---

# Orient function

Read-only walkthrough of **one** function or method. Apply only the modes the router passed. Lenses: [../catch-me-up/modes.md](../catch-me-up/modes.md).

If invoked directly with no mode list: Syntax + Testing.

## Always gather

- Signature
- Callers (1–3)
- Callees
- Pre/post conditions visible in code or tests

## Required walkthrough (Syntax)

1. Inputs — types, invariants, who passes them
2. Steps in order — control flow, not a line-by-line recitation
3. Outputs and side effects
4. Edge cases and error paths from the body **and** tests
5. What it does **not** do

Testing is the check. History only if the body is otherwise inexplicable, and only `git log` / blame on this file.

## Briefing shape

1. Signature + one-sentence purpose
2. I/O table
3. Numbered steps
4. Edge cases
5. Tests that pin this behavior (`path:line`)
6. Related functions (names only, not a module dump)
7. One close question: another function, add a mode, or stop

Cite `path:line` and a short snippet for non-obvious steps. If there are no tests, say so in one line.

## Mixed turn

If the user also asked to change the function (new coupon, extra parameter, “fix it”): finish this walkthrough, then hand back. Do not edit the function **in this turn**, even though they already asked. That message is the briefing. Say orientation is done. They must send a **new message** to implement.
