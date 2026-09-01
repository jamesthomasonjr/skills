---
name: review-gather-onboard
description: >-
  Job-only onboard-summary gatherer for defect-first review. Use when
  review-changes (or a later consumer) needs a summary of the
  classified file list. Does not review. Read-only.
disable-model-invocation: true
---

# Review gather onboard

Return an **onboard summary** of the announced file list. This skill
does **not** review, does **not** fan out, does **not** apply gates,
and does **not** write findings or candidates.

## Hard rules

- Read-only. No edits, no commits, no pushes, no GitHub review comments.
- Do not review. Do not write findings. Do not apply `gates.md`. Do not Read it.
- Do not fan out to seats. Do not Follow `review-intent`, `review-blind`, `review-security`, `review-performance`, `review-logic`, `review-regression`, `review-checklist`, or `review-verify`.
- Do not write candidates. Do not write Findings / Assessment / Close.
- Do not hand off to another skill. This skill writes the product.
- Summarize **that file list**. Do not dump the whole repo.
- Return the product to the consumer, then stop. Do not announce. Do not write `Nothing to review.` or `No candidates.` — the consumer writes its own empty stop.

## 1. Read the list

The consumer passed the announced comparison, comparison command, and file list.

Allowed:

- Read each path on the file list (and enough of a sibling import to name a role)
- For working tree: the same untracked paths the comparison already listed

Not allowed here: reading hunks to judge defects, applying gates, writing findings, fanning out, mapping the rest of the repo, dispatching a briefing skill.

Empty file list → **empty**.

## 2. Summarize

For each path, or a tight cluster that shares a role: one or two sentences — what the file is. Not a walkthrough. Not a candidate list. Not a whole-repo architecture.

Do not add findings. The summary **is** the product.

## 3. Return

Return to the consumer, then stop:

- the onboard summary
- or **empty**

## Red flags

- Reviewing, fanning out, applying gates, or writing findings / candidates
- Writing the consumer’s empty stop (`Nothing to review.` / `No candidates.`)
- A whole-repo dump, or files that were not on the list
- Handing off to another skill instead of writing the product
