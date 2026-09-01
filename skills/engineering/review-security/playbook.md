# Security candidates

`review-security` is **REQUIRED** to follow this file. This file
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

### Injection

Interpreter sink taking untrusted data (`eval`, a shell, a query
builder with no boundary) — new or already in a touched file. The
process runs their code or their clause.

### Broken Access Control

Object access with no authz check — a handler loads or mutates a
record by id and never asks who may.

State-changing route with no CSRF — POST/PUT/PATCH/DELETE changes
state with no token or same-site guard. A foreign page fires the
action as the victim.

### Software or Data Integrity Failures

Deserialization of attacker-controlled data (`unserialize`,
`pickle`, `YAML.load`, typed `JSON.parse`). Their payload runs a
constructor or gadget.

### Security Misconfiguration

A misconfig that opens a service — bind to all interfaces, debug
left on, or auth disabled in the env this diff ships.

### Software Supply Chain Failures

Integrity of what this diff pulls in — a new dependency, lockfile
pin, or install script the comparison adds or rewrites.

## Not a candidate

- A category name with no sink
- “Could be A01” with no path
- A generic Top 10 recitation

Not a CWE list. Not STRENGTHS, NO FINDINGS, Nothing blocking,
REVIEW.md, or apply-fixes.
