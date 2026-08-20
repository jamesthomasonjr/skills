---
name: prioritize-work
description: >-
  Rank or select the next piece of work from a resolved candidate set.
  Use when next-work hands off, or the user asks which of a named list
  to do first. Picks one item. Does not write the handoff package.
disable-model-invocation: true
---

# Prioritize work

Pick **one** next item from a resolved candidate set. Do not write the
handoff package. Do not re-classify the ask.

**REQUIRED:** Follow [../next-work/sources.md](../next-work/sources.md).
Read it from this file’s directory, not cwd.

## Hard rules

- Do not invent items. If it is not in the set, it is not a candidate.
- Pick **one**. A ranked dump is not the default. “Rank them” still
  means one Next + one leftover line, not a 1/2/3 treatise.
- Do not write Goal / Constraints / Done when / Pointers / Prompt.
- Do not implement. Mixed-turn implement request: finish this pick (and
  let the router continue to `handoff-work` when that is the path), then
  **hand back**. They must send a **new message** to implement.
- If invoked with no set, cheap-resolve as `next-work` would. Empty →
  exactly `Nothing next.`
- Scoped cheap-resolve: follow [sources.md](../next-work/sources.md).
  Parent git (dirty tree or feature-branch delta outside the scope) is
  not in-flight work.
- If invoked with a size / review / debug / orient ask: stop. Out of
  family. Point at the matching family. Do not pick.

## Procedure

If this is a stop path (empty/unresolvable, or out of family), skip
steps 1–3. Write only the stop.

1. Take the passed set, or cheap-resolve via `sources.md`.
2. Pick one item using Ranking below.
3. Write the output contract. Then stop (or return the item to the
   router so `handoff-work` can run).

## Ranking

User-named priority wins. Then, first match:

1. **Finish in-flight** — uncommitted work or a feature branch that
   already carries this item **inside the project scope**. Parent-repo
   dirt or a parent feature-branch delta does not qualify when the
   project is a subdirectory.
2. **Unblocked and pointed** — has a real file/PR/plan pointer; can start now.
3. **Smallest finished slice** — one piece that can be done without
   inventing children.
4. **Otherwise** — the first remaining named item. Do not invent a winner.

Never pick an item that was not in the set. Never add a chore from `src/`
to “help.”

## Stop paths (no envelope)

These are **not** successful picks. Do **not** emit Next, Why, or Leftover.

- Empty or unresolvable set: exactly `Nothing next.`
- Size / review / debug / orient: 1–2 sentences, point at `size-work` /
  `shape-*`, `review-changes`, `debug`, or `catch-me-up`, stop.

## Output contract (in order)

Skip this entire section on stop paths.

1. **Next** — the one item (title + pointer if it has one).
2. **Why** — one line. Not a treatise.
3. **Leftover** — omit if none. Else one short line (count or titles).
   Not a numbered rank list. Not a second procedure.

No other sections. No handoff package. No implementation.

## Rationalizations

| Excuse | Reality |
|---|---|
| “Empty looks unfinished” / “be useful” | `Nothing next.` is success. Inventing a backlog is the failure. |
| “That is not a reason to stop” / “propose a backlog” | Still not a named source. Exactly `Nothing next.` |
| “I’ll just add a few chores I noticed” | Not a named source. Drop them. |
| “They said rank them, so I need 1/2/3” | One Next + one leftover line. Not a ranked treatise. |
| “A ranked top-10 is more helpful” | One Next + one-line Why. Residuals are one leftover line. |
| “I’ll write the handoff while I’m here” | That is `handoff-work`. Do not write it. |
| “They said do it, so I should start” | Pick (and hand off if sequenced), then hand back. |
| “Always emit Next / Why” | Only after a real pick. Stop paths skip the envelope. |
| “We’re on a feature branch / the parent tree is dirty” | Scoped project: parent git is dropped. `Nothing next.` if nothing remains in scope. |

## Failures

- Invented candidates
- Ranked dump as the default
- Handoff package from this leaf
- Implementing in this turn
- Success envelope on a stop path
- Re-doing the router’s classify
- Picking parent in-flight work for a scoped empty project
