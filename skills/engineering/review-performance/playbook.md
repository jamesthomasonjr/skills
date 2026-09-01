# Performance candidates

`review-performance` is **REQUIRED** to follow this file. This file
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

### Unbounded work

Work that grows without a bound the comparison can name — a loop,
recursion, or scan with no limit, page, or stop.

### N+1 / extra round-trips

A loop that does one query, fetch, or RPC per item when the
comparison still shows a way to batch, or an extra round-trip the
old side did not pay.

### Sync-in-request

Blocking or awaited work on a request path that the comparison
keeps synchronous — a lock, sleep, or remote call the handler
waits out.

### Missing backpressure or pagination

A producer, consumer, or list with no page, cursor, or bound, so
the comparison ships an unbounded fill.

### Lock / contention on a hot path

A lock, mutex, or exclusive section on a path the comparison
keeps hot.

## Not a candidate

- “Could be slow” with no sink
- A generic slowness recitation

Not a CWE list. Not STRENGTHS, NO FINDINGS, Nothing blocking,
REVIEW.md, or apply-fixes.
