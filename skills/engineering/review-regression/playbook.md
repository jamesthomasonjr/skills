# Regression candidates

`review-regression` is **REQUIRED** to follow this file. This file
**describes a candidate**. It does **not** write Findings /
Assessment / Close.

## Leftovers

Emit leftovers the comparison still shows. Do not filter on
“introduced” or “newly reachable.” That is a verify drop later, not a
seat filter. Swallowing leftovers makes them never-seen, not a named
residual.

## Failure modes

A candidate names what breaks and where the sink is. This seat is
**comparison-only**. Emit a candidate when the comparison shows a
behavior the old side still had that this diff drops.

Do not tour the repo. Touring the repo is the parked audit skill,
not this playbook.

## Not a candidate

- A finding from files outside the comparison
- “The codebase still has X” from a repo tour
- An audit of untouched files

Not a CWE list. Not STRENGTHS, NO FINDINGS, Nothing blocking,
REVIEW.md, or apply-fixes.
