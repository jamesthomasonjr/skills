---
name: review-gather-design
description: >-
  Job-only design-excerpt gatherer for defect-first review. Use when
  review-changes (or a later consumer) needs a design excerpt for a
  classified comparison. Does not review. Read-only.
disable-model-invocation: true
---

# Review gather design

Return a **design excerpt** that covers the announced file list. This
skill does **not** review, does **not** fan out, does **not** apply
gates, and does **not** write findings or candidates.

## Hard rules

- Read-only. No edits, no commits, no pushes, no GitHub review comments.
- Do not review. Do not write findings. Do not apply `gates.md`. Do not Read it.
- Do not fan out to seats. Do not Follow `review-intent`, `review-blind`, `review-security`, or `review-verify`.
- Do not write candidates. Do not write Findings / Assessment / Close.
- Do not hand off to another skill. This skill writes the product.
- Do not dump a whole design doc. Excerpt the sections that cover the file list.
- Return the product to the consumer, then stop. Do not announce. Do not write `Nothing to review.` or `No candidates.` — the consumer writes its own empty stop.

## 1. Find

The consumer passed the announced comparison, comparison command, and file list.

Allowed in **one** pass:

- Design / spec / plan files **on** the file list
- Design / spec / plan files that name those paths (nearby `docs/`, `*design*`, `*spec*`, `*plan*`)

Not allowed here: reading hunks to judge defects, applying gates, writing findings, fanning out, a whole-repo doc walk, grilling the prose as a design reviewer.

No covering design / spec / plan → **empty**. A README is not a design excerpt unless it is the only covering spec and the file list points at it.

## 2. Excerpt

Copy the sections that name the file-list paths or the change those paths implement. Keep enough to seed intent. Drop unrelated chapters.

Do not rewrite the design as a review. Do not add findings. The excerpt **is** the product.

## 3. Return

Return to the consumer, then stop:

- the design excerpt
- or **empty**

## Red flags

- Reviewing, fanning out, applying gates, or writing findings / candidates
- Writing the consumer’s empty stop (`Nothing to review.` / `No candidates.`)
- Dumping a whole design doc or the whole `docs/` tree
- Handing off to another skill instead of writing the product
- Grilling the design as if this family reviewed prose
