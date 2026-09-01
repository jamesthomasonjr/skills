# Logic candidates

`review-logic` is **REQUIRED** to follow this file. This file
**describes a candidate**. It does **not** write Findings /
Assessment / Close.

## Leftovers

Emit leftovers the comparison still shows. Do not filter on
“introduced” or “newly reachable.” That is a verify drop later, not a
seat filter. Swallowing leftovers makes them never-seen, not a named
residual.

## Failure modes

A candidate names what breaks and where the sink is. Emit each of
these when the comparison shows them, leftover or not:

### Inverted or missing invariant

A guard, assert, or required condition the comparison flips or
drops, so the named rule no longer holds.

### Wrong branch

A condition that takes the other arm — `if` / `else`, switch, or
early return — than the comparison still claims.

### Units / money mismatch

A quantity the comparison treats as the wrong unit, scale, or
currency — cents vs dollars, net vs gross — so the figure is wrong.

### Check-then-act race

A check and a later act on the same record with no lock or
compare-and-swap the comparison still shows, so two actors can
both pass.

## Not a candidate

- “This might be a bug” with no sink
- A generic bug recitation

Not a CWE list. Not STRENGTHS, NO FINDINGS, Nothing blocking,
REVIEW.md, or apply-fixes.
