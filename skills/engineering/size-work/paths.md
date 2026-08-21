# Work paths

Shared playbook for `shape-epic` and `shape-feature`. Those skills are
**REQUIRED** to follow this file. The size-work router does not restate
it and does not compute a Path.

If wording here conflicts with a `SKILL.md` summary, **this file wins**.

## When

After this level's inventory is written. Never before. Never from
grandchildren. Never from a story or task brief.

## Output (in order)

1. **Critical path** — shortest sequence that determines done.
2. **Parallel** — named independent sets, or `None`.
3. **Why coupled** — one line each for fake independence. Omit if none.

This is a **Path** heading after the inventory. Do not bury it under
Constraints. Do not put it after Open questions or Close.

## Critical path

Every item is a title from **this level's inventory**. Done means the
brief's outcome is true.

The path is the set of inventory titles that actually determine done,
in dependency order. There is **no count rule**.

Include every inventory title that **actually determines done**.
Omit children that do **not** determine done.

Do **not** add an item to reach a minimum. Do **not** drop an item to
reach a maximum. Nine required sequential children → a nine-item path.
One determining child → a one-item path.

Matching priority order is **fine when that is the sequence**.

“Shortest” means omit non-determining children, not a cap or a floor.

If B cannot be done until A exists, A is before B even when B is higher
priority.

Do **not** reshuffle the inventory to match Path. Inventory
priority/order stays **value**. Path is the sequence.

Not stories under a feature. Not features under an epic.

## Parallel

Named sets of inventory items that can proceed without waiting on each
other.

Independence test — fail **any** one and they are not parallel:

- Shared file (including a migration)
- Shared contract (type, schema, API, event shape)
- Open decision (“what does X mean”)

Write exactly `None` when nothing passes. `None` is success. Inventing
a set to look useful is the defect.

Do not dispatch agents from a set. `next-work` / `handoff-work` / the
user do that.

## Why coupled

One line each for items that look independent (different actor, different
title) and are not. Name the shared file, contract, or decision.

Omit this heading when there is nothing to say.

## Already-shaped inventory

If the user points at an in-thread inventory or a named path, Path uses
**that** list. Do not add children. Do not drop a level. Do not refuse
Path because shaping already happened.

A Superpowers / supersuit spec that already has an inventory may use
this same three-part block. Do not grow a review-brief skill.

## Hard rules

- Do not invent fan-out. Shared migration, shared type, or a shared
  “what does X mean” stays on the path.
- Empty Parallel (`None`) is success. Inventing independence is the
  defect.
- Include every inventory title that actually determines done. Omit
  children that do not. Matching priority is fine when that is the
  sequence. Do not add an item to reach a minimum. Do not drop an item
  to reach a maximum. There is no count rule.
- Do not dispatch agents. `next-work` / `handoff-work` / the user do
  that.
- One-level rule still holds. Do not explode stories while sequencing
  features, or features while sequencing an epic.
- `shape-story` and `shape-task` do not emit Path.
- The size-work router does not write Path.

## Rationalizations

| Excuse | Reality |
|---|---|
| “They look like separate workstreams” | Shared migration, type, or meaning → path, not Parallel. |
| “None looks like I didn't try” | `None` is the correct pass. Inventing a set is the miss. |
| “Priority already sequences them” | Matching priority is fine when that is the sequence. Copy it only then. |
| “Every child on the path is a miss” | If every child determines done, list them. Parallel `None` may follow. |
| “I'll drop one to stay at five” | Do not drop a required child. There is no count cap. |
| “I'll add a second so the path is at least two” | One determining child is a one-item path. Do not pad. |
| “Not every child means drop one” | Omit only children that do not determine done. |
| “I'll reorder the inventory so the path is obvious” | Leave inventory order. Put sequence under Path. |
| “I'll launch agents for the Parallel sets” | This family does not dispatch. Hand back. |
| “Stories would make the path real” | One-level rule. Features stay features. |
| “The router can sketch a path” | No inventory yet. Classify and hand off. |
| “They already have an inventory, so skip Path” | Compute Path from that list. Do not refuse. |
| “I'll note sequence under Constraints” | Path is its own section, after the inventory. |

## Failures

- Parallel set that shares a file, contract, or open decision
- Critical path copied from priority/order when the sequence differs
- Dropping a required child to avoid listing every item, or to fit a count cap
- Padding the path with a non-determining child to reach a minimum count
- Reshuffling a path that already matches priority
- Inventory priority rewritten to match Path
- Path buried in Constraints, or placed after Open questions / Close
- Path section on story, task, initiative, or the router
- Grandchildren (stories while shaping an epic; tasks while shaping a feature)
- Dispatching agents or implementing in this turn
- Refusing Path when an inventory already exists
