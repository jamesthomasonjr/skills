# Size-work Path (critical path + parallelization)

Date: 2026-08-21
Status: approved (v1 locked; RED/GREEN pending)
Repo: jamesthomasonjr/skills

## Problem

When JT sizes work or writes a spec, today’s inventories order children by **value** (priority/order). That ranking does not say what must be sequential, what can fan out to other agents, or which items look independent and are not.

Agents fill the gap by inventing fan-out, exploding grandchildren while sequencing, dispatching agents from a Parallel list, or treating the priority list as a critical path. None of that is the size-work family’s job.

## Goals

- After an **epic** or **feature** inventory, emit a **Path**: the shortest sequence that determines done, named parallel sets that are actually independent, and one-line coupling notes when independence is fake.
- Keep Path at **this level’s inventory only** (one-level rule).
- Keep empty Parallel (`None`) as success. Inventing independence is the defect.
- Keep dispatch out of this family. `next-work` / `handoff-work` / the user start other agents.
- Keep the size-work router a classifier. It does not compute a Path (it has no inventory yet).

## Non-goals

- A new skill family, take-home skill, or dispatcher.
- A promoted `path-work` / `sequence-work` skill. `paths.md` is a playbook, not a catalog entry.
- Path on `shape-initiative`, `shape-story`, or `shape-task`.
- Changing how priority/order is assigned on inventories (still value).
- Restating Path hard rules in the router.
- Building a review-brief skill for Superpowers/supersuit specs. A later spec that already has an inventory **may reuse this Path block**; that is a note, not a new product.
- Plugin version bump. This is a playbook + contract edit on an existing family (same class as PR #3), not new promoted skills (PR #8 was 0.6.0).

## Sources

| Source | What we take | What we drop |
|---|---|---|
| This repo’s size-work family | Thin router; `levels.md` vocabulary; one-level inventories; shape output contracts; mixed-turn hand-back; sibling reads from this file’s directory; Failures / rationalizations | Computing Path in the router; Path on atomic story/task briefs |
| This repo’s `debug/paths.md`, `review-changes/gates.md` | Shared playbook next to the router; leaves REQUIRED to follow it; router does not restate the playbook | Debug classification; review gates |
| This repo’s `next-work` / `prioritize-work` | Priority/order is a **value** ranking. Dispatch and handoff live in that family, not here | Ranking rubric; handoff package; inventing work |

## Approaches considered

1. **Shared `paths.md` + Path section on `shape-epic` and `shape-feature` (recommended, v1).** Playbook sits next to `levels.md`. Inventory-emitting epic/feature skills are REQUIRED to follow it. Router stays classify-and-hand-off. Story/task stay atomic. Matches how `gates.md` and debug `paths.md` work.
2. **Router computes Path.** Rejected. The router has no inventory. It would invent children or skip shaping.
3. **New promoted skill.** Rejected. JT asked for Path **on the existing family**, not a dispatcher and not a second catalog entry.

v1 is approach 1.

## Architecture

No new promoted skills. One sequential agent. Shape skills that already emit inventories grow one section. The playbook lives in one file so the router does not dump the rules.

```
skills/engineering/
  size-work/
    SKILL.md       # router: classify, hand off. Does not compute Path.
    levels.md      # hierarchy (unchanged grain). Path is not a level.
    paths.md       # NEW playbook: Critical path / Parallel / Why coupled
  shape-epic/
    SKILL.md       # REQUIRED to follow paths.md; Path after feature inventory
  shape-feature/
    SKILL.md       # REQUIRED to follow paths.md; Path after story inventory
  shape-initiative/  # no Path (out of v1)
  shape-story/       # no Path (atomic)
  shape-task/        # no Path (atomic)
```

Hard rules for Path (authoritative in `paths.md`, not restated in the router):

1. Do **not** invent fan-out. A shared migration, shared type, or a shared “what does X mean” stays on the critical path.
2. Empty Parallel (`None`) is success. Inventing independence is the defect.
3. Priority/order ≠ critical path. Inventory order stays value. Path is the sequence that determines done.
4. Do **not** dispatch agents. `next-work` / `handoff-work` / the user do that.
5. One-level rule still holds. Do not explode stories while sequencing features, or features while sequencing an epic.
6. `shape-story` and `shape-task` do **not** emit Path.
7. The size-work router does **not** write Path.

## Path section (output contract)

Add **one** section named **Path** to `shape-epic` and `shape-feature` only. Place it **after the inventory**, **before Open questions / Close**. Keep every existing section; do not reshuffle the rest.

In order inside Path:

1. **Critical path** — the shortest sequence that determines done. Two to five items, drawn from **this level’s inventory only**.
2. **Parallel** — named sets that do not share a file, a contract, or an open decision. `None` is a valid pass.
3. **Why coupled** — one line each for items that look independent and are not. **Omit** this subsection if none.

### `shape-epic` contract after this change

1. Title
2. Outcome
3. Boundaries
4. Success signals
5. Constraints / dependencies
6. **Feature inventory** — 3–9 features; title, one-liner, priority/order. No nested stories.
7. **Path** — follow `paths.md` (Critical path, Parallel, Why coupled).
8. Close — ask which feature to shape next (`shape-feature`), or stop. Do not dispatch.

### `shape-feature` contract after this change

1. Title
2. Problem
3. Outcome
4. Boundaries
5. Constraints
6. **User-story inventory** — 3–9 stories; title + As a / I want / so that + priority.
7. **Path** — follow `paths.md`.
8. Open questions
9. Close — ask which story to deepen with `shape-story`, or stop. Do not dispatch.

### What does not emit Path

| Skill | Why |
|---|---|
| `shape-initiative` | Out of v1. Do not add the section. |
| `shape-story` | Atomic brief. Sequencing children would skip a level or invent tasks. |
| `shape-task` | Atomic brief. No inventory of peers to sequence. |
| `size-work` | Router. No inventory yet. |

## Playbook (`paths.md`)

Sibling of `levels.md`. Voice matches this family: short, imperative, tables, Hard rules, rationalizations, Failures.

**REQUIRED** for `shape-epic` and `shape-feature`. Read from **this file’s directory** (shape skills link `../size-work/paths.md`). If wording drifts between a SKILL.md summary and `paths.md`, **this file wins**.

The playbook must define:

- How to pick the 2–5 critical-path items from the inventory (shortest sequence that determines done; not “everything”; not the priority list copied in order).
- Independence test for Parallel: no shared file, no shared contract, no open decision. Fail any one → not parallel.
- `None` as the entire Parallel body when the inventory is coupled. Do not hunt for a set to look useful.
- Why coupled: only for pairs/groups that **look** independent (different titles, different users) but share a file, contract, or decision. Omit the heading when there is nothing to say.
- Inventory already exists (in-thread or named path): compute Path from **that** list. Do not invent extra children. Do not explode one level down.
- Later Superpowers/supersuit spec with an inventory: same three-part Path block is legal. Do not grow a review-brief skill here.

Do **not** put dispatch steps, agent prompts, or `next-work` ranking in `paths.md`.

## Router (`size-work`)

Still only classifies grain and hands off. Still does not invent child lists. Still does not write Path.

Thin addition, no playbook dump:

- If the user asks only “what’s the critical path / what can run in parallel” **and** an inventory already exists in-thread or at a named path: announce the matching shape skill (feature inventory → `shape-epic`; story inventory → `shape-feature`) and hand off. Point at `paths.md` by link, not by pasting the rules.
- If they ask only for Path and the grain is story/task (or the artifact is a single brief with no inventory): say Path is not emitted at that grain. Do not invent a Path. Do not invent a new skill.
- Mixed turn that includes “then dispatch / fan out / launch agents”: classify, shape (Path included when epic/feature), then **hand back**. Do not implement. Do not dispatch.

Do not add Path to the router description (SDO: agents follow the description and skip the body). Catalog blurbs for the **leaves** may mention Path.

## Catalog

Update one-liners only where they would otherwise be untrue:

- `shape-epic`: epic brief, feature inventory, and Path.
- `shape-feature`: feature brief, user-story inventory, and Path.

Do **not** add `paths.md` to `.claude-plugin/plugin.json` as its own skill. Do **not** bump plugin version. Do **not** list Path as a User-invoked or Model-invoked skill.

## Failure modes this addition must prevent

- Inventing Parallel sets that share a migration, type, or open decision.
- Copying inventory priority/order into Critical path when the sequence that determines done is different.
- Emitting Path from `shape-story`, `shape-task`, or the size-work router.
- Exploding stories while sequencing an epic, or tasks while sequencing a feature.
- Dispatching agents because Parallel is nonempty.
- Implementing in a mixed “shape then build / then fan out” turn.
- Adding a new promoted skill so the catalog can say “path-work”.
- Restating the Path hard-rule list in the router.

## Testing

RED/GREEN scenarios live in `docs/superpowers/plans/2026-08-21-size-work-paths-baseline.md`.

RED: current family **without** `paths.md` and without Path in the epic/feature contracts. Ban `docs/superpowers/**`.

GREEN must cover at least:

1. Epic shape emits Path **after** the feature inventory, before Close.
2. Feature shape emits Path **after** the story inventory, before Open questions.
3. Parallel `None` on a truly coupled inventory (do not invent fan-out).
4. Shared contract / migration / decision stays on the critical path.
5. Priority/order ≠ Path sequence when they differ.
6. `shape-story` / `shape-task` emit no Path section.
7. size-work router still does not write Path (path-only ask with an existing inventory points at `paths.md` / the matching shape skill).
8. Mixed turn still does not implement and does not dispatch agents.

Fixture: `fixtures/work-sizing-sample` (existing mixed-turn rename). Inventories for Path cases may live in-thread or as a named file under that fixture; do not invent a second sample product.
