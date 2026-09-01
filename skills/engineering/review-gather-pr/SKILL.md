---
name: review-gather-pr
description: >-
  Job-only PR-body gatherer for defect-first review. Use when
  review-changes (or a later consumer) needs the PR body for a
  classified comparison. Does not review. Read-only.
disable-model-invocation: true
---

# Review gather PR

Return the **PR body** for the announced comparison. This skill does
**not** review, does **not** fan out, does **not** apply gates, and
does **not** write findings or candidates.

## Hard rules

- Read-only. No edits, no commits, no pushes, no GitHub review comments.
- Do not review. Do not write findings. Do not apply `gates.md`. Do not Read it.
- Do not fan out to seats. Do not Follow `review-intent`, `review-blind`, `review-security`, `review-performance`, `review-logic`, `review-regression`, `review-checklist`, or `review-verify`.
- Do not write candidates. Do not write Findings / Assessment / Close.
- Do not hand off to another skill. This skill writes the product.
- Return the product to the consumer, then stop. Do not announce. Do not write `Nothing to review.` or `No candidates.` — the consumer writes its own empty stop.

## 1. Fetch

The consumer passed the announced comparison, comparison command, and file list.

Allowed in **one** pass:

- Resolve the pull request for `<tip>` or the named PR (`gh pr view`, a PR URL the consumer named, or the host’s PR read)
- Read that PR’s **body** (description text)

Not allowed here: reading hunks to judge defects, applying gates, writing findings, fanning out, touring the repo for “more context.”

No pull request for this comparison → **empty**. A commit message is not this product. A named patch with no PR → **empty**.

## 2. Return

Return to the consumer, then stop:

- the PR body
- or **empty**

Do not summarize the body into a review. Do not add findings. The body text **is** the product.

## Red flags

- Reviewing, fanning out, applying gates, or writing findings / candidates
- Writing the consumer’s empty stop (`Nothing to review.` / `No candidates.`)
- Returning a commit message, diff, or file list labeled as the PR body
- Handing off to another skill instead of writing the product
