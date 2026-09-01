# Checklist candidates

`review-checklist` is **REQUIRED** to follow this file. This file
**describes a candidate**. It does **not** write Findings /
Assessment / Close.

## Leftovers

Emit leftovers the comparison still shows. Do not filter on
“introduced” or “newly reachable.” That is a verify drop later, not a
seat filter. Swallowing leftovers makes them never-seen, not a named
residual.

## Failure modes

Named file only. The router passes a checklist path **when the
caller named one**. Each failed item on that file is a candidate.

No file → write exactly `No candidates.` Do not invent a path. Do
not Read a default checklist file.

## Not a candidate

- A failed item with no named file
- An invented checklist path
- A generic “they should have a checklist” recitation

Not a CWE list. Not STRENGTHS, NO FINDINGS, Nothing blocking,
REVIEW.md, or apply-fixes.
