---
name: handoff-work
description: >-
  Package context and a copy-pasteable prompt for the next agent for a
  specified work item. Use when next-work hands off after a pick, or the
  user already chose the item and wants a handoff. Does not re-rank.
disable-model-invocation: true
---

# Handoff work

Package the **specified** next item for the next agent. Do not re-rank.
Do not implement.

If the router passed a picked item, that is the specified item.

## Hard rules

- Do not re-rank. Do not pick among a list to be helpful.
- If no item was specified: ask once which item (entire output). Do not
  rank. Do not write the package.
- Pointers must be real. If you did not open it, do not cite it.
- A pointer is a path or identifier, **not** the file body. Do not paste
  source, tests, or whole docs into the prompt. “Thorough” / “all the
  context” does not authorize a dump.
- Not a dump of the repo. Not line-by-line edits. Not a fake citation.
- Do not implement. Mixed-turn implement request: finish this package,
  then **hand back**. They must send a **new message** to implement.
  **Do not edit in this turn even if they said “do it now” / “ship it.”**
- Conversation-only unless they named a sink. Do not invent `HANDOFF.md`.
- Empty or unresolvable item → exactly `Nothing next.`
- Size / review / debug / orient → stop. Point at the matching family.

## Procedure

If this is a stop path (no item and they still have not named one,
empty/unresolvable, or out of family), skip steps 1–3. Write only the stop.

1. Take the specified item. Open only the pointers you will cite.
2. Write the output contract. Lead with goal + done-state, not history.
3. Stop (or hand back on mixed turn).

## Stop paths (no envelope)

These are **not** successful packages. Do **not** emit Goal, Constraints,
Done when, Pointers, or Prompt.

- No item specified: exactly `Name the item to hand off. I won’t re-rank.`
- Empty or unresolvable item: exactly `Nothing next.`
- Size / review / debug / orient: 1–2 sentences, point at the matching
  family, stop.

## Output contract (in order)

Skip this entire section on stop paths.

1. **Goal** — one short paragraph. Where this item goes.
2. **Constraints** — bullets they stated or the item names; or `None stated.`
3. **Done when** — 3–7 concrete checks. Not “the code looks good.”
4. **Pointers** — real paths / PRs / plan files only. No whole-repo tree.
   No pasted file bodies.
5. **Prompt** — one fenced copy-pasteable prompt the next agent can run
   with. Includes the goal, constraints, done-when, and pointers. No
   line-by-line edits. No file dumps. No fake files. No “also while
   you’re there.”

On mixed turn, after Prompt: one line that the handoff is done; they must
send a **new message** to implement.

## Rationalizations

| Excuse | Reality |
|---|---|
| “They’ll need the whole repo” / “thorough context” | Pointers, not a dump. Do not paste file bodies. |
| “I’ll write the patch in the prompt” | Prompt is a starting action, not line-by-line edits. |
| “I’ll rank first so the prompt is for the right item” | Item is already specified. Do not re-rank. |
| “I’ll just do it — they said ship it now” | Package, then hand back. New message to implement. |
| “Always emit Goal / Constraints / Prompt” | Only after a specified item. Stop paths skip the envelope. |
| “Empty looks unfinished” | `Nothing next.` is success. |

## Failures

- Re-ranking
- Whole-repo dump, pasted file body, or fake citation
- Line-by-line edit prescription
- Implementing in this turn
- Success envelope on a stop path
- Invented `HANDOFF.md` without a named sink
