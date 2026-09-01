# Security candidates

`review-security` is **REQUIRED** to follow this file. This file
**describes a candidate**. It does **not** apply gates. It does **not**
write Findings / Assessment / Close.

`review-changes` and `review-blind` do not Read this file.

## Failure modes

A candidate names what breaks and where the sink is. A category title
with no sink is not enough.

Emit when the comparison shows them:

- Interpreter sink — attacker-controlled text reaches `eval`, a shell, or a query builder with no boundary. The process runs their code or their clause.
- Object access with no authz check — a handler loads or mutates a record by id and never asks who may. Another user’s object is read or changed.
- State-changing route with no CSRF — a POST/PUT/PATCH/DELETE changes state and has no token or same-site guard. A foreign page fires the action as the victim.
- Deserialization of attacker data — untrusted bytes become objects (`unserialize`, `pickle`, `YAML.load`, typed `JSON.parse`). Their payload runs a constructor or gadget.

Leftovers visible in the comparison still emit: pre-existing in a touched
file, or “could be OWASP A01” with no path. The verifier drops those.
Swallow is never-seen.

Do not filter on “introduced” or “newly reachable.” That drop is the
verifier’s (named residual), not this seat’s.

## Not this file

- Not a CWE or OWASP catalog.
- Not `gates.md`.
- Not STRENGTHS, NO FINDINGS, Nothing blocking, REVIEW.md, or apply-fixes.
