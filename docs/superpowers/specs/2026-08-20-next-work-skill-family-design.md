# Next-work skill family

Date: 2026-08-20
Status: verified (RED baseline + GREEN subagent runs)
Repo: jamesthomasonjr/skills

## Problem

JT often asks an agent (1) what the next piece of work is, and (2) what context / prompt to hand to the next agent. Without a skill, agents invent a backlog to look useful, dump a long ranked list, paste the whole repo into a “handoff,” start implementing in the same turn, or wrap a stop (`nothing to do`) in a fake success envelope.

This family exists to classify that ask, resolve a **real** candidate set, pick **one** next item, and package a copy-pasteable prompt for the next agent. It is not a tracker, not a gstack port, and not an implementer.

## Goals

- Classify the ask (what’s-next vs rank-only vs handoff-only vs out of family vs empty).
- Cheap-resolve candidates from sources this family names. Drop anything that does not resolve.
- Pick **one** next item by default, with a one-line why.
- Package a handoff the *next* agent can run with: goal, constraints, done-when, real pointers, copy-pasteable prompt.
- Stay project-agnostic and agent-agnostic (Cursor, Claude Code, Codex, others).
- Stay conversation-only unless the user named a sink. Mixed “what’s next, then do it” finishes pick + handoff and hands back.

## Non-goals

- Implementing, scaffolding, or editing application code in this turn.
- Inventing work items, tickets, or a `docs/work/` dump.
- A long ranked dump as the default output.
- A session-handoff product (file stores, `--continues-from` chains, context-window compaction).
- gstack / stations.dev / Slack / GitHub-bot product runtimes.
- Replacing `size-work` / `shape-*`, `review-changes`, `debug`, or `catch-me-up`.
- Requiring Linear, GitHub Projects, beads, or any specific tracker.

## Sources

| Source | What we take | What we drop |
|---|---|---|
| This repo’s size-work + review-changes families | Thin router → leaf; shared playbook next to the router; hard rules; sibling handoff from this file’s directory not cwd; model-invoked router + user-invoked leaves; mixed-turn hand-back; stop paths skip the success envelope; Failures list; rationalizations table | Work-level hierarchy; defect gates; git comparison machinery |
| theafh `task_select` | Read-only pick; prefer unblocked / can-move-now over impressive-but-blocked; one recommendation | `tasks/` product; scoring pipeline; editing task files |
| jwynia `/next` | Single next item; exact empty-stop phrase; do not display a ranked menu as the default | Ready-queue layout; implement checkpoint; branch-name suggestion |
| borghei `workflow/handoff` | Lead with goal + done-state, not history; pointers not dumps; no conversation transcript; one starting action | Python helper; template file; abandoned-paths as a required section; session-handoff store |
| agent-kanban / todo-worker | Prefer finishing in-progress (branch / uncommitted) over starting new; empty inbox is a stop, not a prompt to invent | WIP claims, file-kanban, TODO.md mutation, auto-implement |

## Approaches considered

1. **Thin router + two leaves + `sources.md` (recommended).** Matches review-changes (`gates.md`) and size-work (`levels.md`). Router classifies and cheap-resolves. `prioritize-work` picks one. `handoff-work` packages. Shared file is candidate resolution only — ranking and the handoff recipe stay in their leaves (two jobs, two files).
2. **Single mega-skill.** Classifies, ranks, and writes the prompt in one `SKILL.md`. Agents skip classify, invent while “being helpful,” and the file does three jobs.
3. **Router + prioritize only, handoff as a section.** Typical JT turn is both, so the prompt section gets skipped or the rank dump swallows it. Direct invoke of a handoff-only leaf is first-class and needs its own skill.

v1 is approach 1.

## Architecture

Three promoted engineering skills. One sequential agent. Default bucket is `skills/engineering/` (daily code work: what to build next, what to hand the next agent). `skills/productivity/` is empty and is the wrong home — this is not inbox/calendar.

```
skills/engineering/
  next-work/
    SKILL.md       # router: classify, cheap-resolve, announce, hand off
    sources.md     # named sources, resolve/drop, empty = Nothing next.
  prioritize-work/
    SKILL.md       # leaf: pick one next item + one-line why
  handoff-work/
    SKILL.md       # leaf: package + copy-pasteable prompt for a specified item
```

Hard rules for the whole family:

1. Do **not** invent work items. Candidates come only from sources `sources.md` names. If a source does not resolve, **drop it**. An empty set is `Nothing next.`, not a made-up backlog.
2. Prioritize picks **one** next item by default, plus a one-line why. A long ranked dump is not the default. Residuals are a short leftover line, not a second procedure.
3. Handoff is a package the *next* agent can run with: goal, constraints, how to tell it’s done, pointers to real files/PRs/plans. Not a dump of the whole repo. Not a prescription of line-by-line edits. Not a fake citation.
4. Stop paths must not also require the success envelope. If the skill says stop with `Nothing next.` or an out-of-family pointer, that is the entire output. Do not also require Next / Why / Handoff (or Goal / Constraints / Done when / Pointers / Prompt) headings.
5. Router does not rank and does not write the handoff. Leaves do not re-do the router’s classify.
6. Read sibling `SKILL.md` files from **this file’s directory**, not from cwd. After symlink or plugin copy, `skills/engineering/...` may not exist.
7. Project-agnostic and agent-agnostic. No stations.dev, Slack, or GitHub-bot product runtime. Optional cheap git/gh reads are fine when they resolve candidates; do not require a specific tracker.
8. Quiet empty pass: inventing a “next” to look useful is a defect. `Nothing next.` is success when the set is empty.

## Invocation

| Skill | Invocation |
|---|---|
| `next-work` | Model-invoked. Omit `disable-model-invocation`. |
| `prioritize-work` | User-invoked (`disable-model-invocation: true`). Reached via router or explicit name. |
| `handoff-work` | User-invoked (`disable-model-invocation: true`). Reached via router or explicit name. |

### Router triggers (`next-work` description)

Third person; what it does and when to use it (this repo’s catalog convention). Router for choosing the next piece of work. Use when the user asks what’s next, what they should work on, or wants a handoff prompt for the next agent. Classifies the path and hands off; does not rank and does not write the handoff.

Do not summarize the ranking rubric or the handoff recipe in the description (SDO: agents follow the description and skip the body).

### Leaf triggers

**`prioritize-work`:** Rank or select the next piece of work from a resolved candidate set. Use when `next-work` hands off, or the user asks which of a named list to do first. Picks one item. Does not write the handoff package.

**`handoff-work`:** Package context and a copy-pasteable prompt for the next agent for a specified work item. Use when `next-work` hands off after a pick, or the user already chose the item and wants a handoff. Does not re-rank.

## Router (`next-work`)

Classify the ask, cheap-resolve the work set, announce the path in one short line, read the sibling leaf (or leaves) from this skill’s directory (not cwd), and follow them. It does **not** rank. It does **not** write the handoff package.

**REQUIRED:** Read [sources.md](sources.md) before resolving. Not allowed in the router: ranking, writing Goal/Constraints/Prompt, implementing.

Typical JT turn is **both**: pick next, then package the handoff. The router sequences `prioritize-work` then `handoff-work` the way `review-changes` hands a packaged target to `review-defects`. Direct invoke of a leaf is also first-class.

### Classify

Explicit user labels win (`/prioritize-work`, `/handoff-work`, “just rank these,” “just the handoff”).

| Signal | Path |
|---|---|
| “what’s next” / “what should I work on” / no item named | `prioritize-work`, then `handoff-work` |
| “rank these” / “which of these first” / named list, no handoff ask | `prioritize-work` only |
| “write the handoff” / “prompt for the next agent” / item already chosen | `handoff-work` only |
| Size / shape / break down / how big / charter / inventory / “write the brief” | **Out of family** — stop, point at `size-work` / `shape-*` |
| Review a change / PR / commit / working tree | **Out of family** — stop, point at `review-changes` |
| Debug / fix this bug / root cause / something’s broken | **Out of family** — stop, point at `debug` |
| Onboard / catch me up / what does this file/function do | **Out of family** — stop, point at `catch-me-up` |
| Empty or unresolvable work set | `Nothing next.` (ask once only when they named a source that missed) |

If two in-family signals both appear, user label wins; if still tied, prefer the **both** path (prioritize then handoff). If an out-of-family verb is the ask (review / debug / orient / size), **stop** — do not also run this family.

**Mixed turn** (“what’s next, then do it” / “handoff then implement”): finish pick + handoff, then **hand back**. Do not implement in this turn. They must send a **new message** to implement. Do not discard the implement request.

### Cheap resolve

Run the `sources.md` one-pass resolve **before** announcing, except on an out-of-family stop (do not gather a set just to ignore it).

Pass the resolved set (or the specified item) to the leaf. Do not add items the sources did not yield.

### Empty or unresolvable

- Scoped project, no named list, every optional source missing or failed: write exactly `Nothing next.` and stop. Do not ask just to look engaged.
- They named a source that does not resolve, and nothing else remains: **ask once**, then stop. If they cannot or will not name another, `Nothing next.`
- Do not guess a backlog from “the code looks messy.” Do not tour the repo for chores.

Ask-once copy (entire output; no envelope):

> Name a list, a board/ticket path, or a plan. I won’t invent a backlog.

If they said “just pick” and the set is empty, still `Nothing next.`

### Announce and hand off

**Out of family:** one or two sentences, name the matching family, **stop**. Do not read a leaf. Do not write Next / Why / Handoff.

**Empty / unresolvable:** ask once, or write exactly `Nothing next.` and stop.

Otherwise one line: which path and why (short).

Read **sibling** skill files resolved from **this file’s directory**, not from cwd. `../prioritize-work/SKILL.md` means “next to this skill.” After `~/.cursor/skills/<name>` symlink or a plugin copy, `skills/engineering/next-*/SKILL.md` does not exist.

If a cwd-relative Read misses (user workspace is a different repo), resolve the sibling from the path you used to open **this** `SKILL.md`, or invoke the leaf by name.

- [../prioritize-work/SKILL.md](../prioritize-work/SKILL.md)
- [../handoff-work/SKILL.md](../handoff-work/SKILL.md)
- [sources.md](sources.md)

Pass: path (`prioritize-then-handoff` / `prioritize-only` / `handoff-only`), resolved candidate set, specified item if any, mixed-turn implement request if any.

Then follow the leaf (or leaves, in order). Do not keep a second ranking or handoff procedure in the router.

On `prioritize-then-handoff`: follow `prioritize-work` to get the one next item, then follow `handoff-work` with that item. Combined success output is Next + Why + leftover (if any) + the handoff package.

## Playbook (`sources.md`)

Single source for legal origins, resolve/drop, the cheap-resolve pass, and the empty-set contract. Router and `prioritize-work` are **REQUIRED** to follow it. `handoff-work` follows it only when no item was specified (then it asks once — it does not rank). The router does not restate the ranking rubric or the handoff recipe.

### Legal sources (only these)

1. **User-named list** — items they typed. Verbatim. Do not add extras.
2. **Open issues / PRs** — only if resolvable in this environment (`gh` or an equivalent they already have). Failure or missing tool → **drop** this source.
3. **Current branch / uncommitted work** — cheap git (`git status --short`, current branch vs default). A dirty tree or a feature branch with a real delta is a candidate (“finish what’s in flight”). Empty/clean default branch → drop.
4. **In-repo plans / specs under `docs/`** — files that look like plans or specs (including `docs/superpowers/plans` and `docs/superpowers/specs` when those exist). Missing `docs/` → drop.
5. **A board / ticket / path the user named** — read that path if it exists. Missing → drop.

Do not use: “I noticed we should add tests,” linter noise, imagined refactors, other skills in this catalog as work items, or a tour of `src/` for chores.

### Resolve / drop

- If you cannot resolve a source, drop it. Do not ask per source when other sources already yielded items.
- User-named list **wins as the set** when present: do not union in extras from git/docs/issues unless they also asked to include those.
- Pointers you pass on must exist (path readable, or issue/PR identifier that resolved). If you did not open it, do not cite it.

### Cheap-resolve (one pass)

Allowed:

- Treat a user-named list as the set.
- Read one named board/ticket/path.
- One `git status --short` plus current branch name (and, when useful, whether HEAD equals the default branch).
- One optional `gh issue list` / `gh pr list` (or equivalent) when they asked for issues/PRs or named no list and no board — skip entirely if the tool is missing.
- One glob of `docs/**/*.md` (or a named docs subfolder) for plan/spec titles.

Not allowed: reading every source file to start the work, ranking in the resolver, implementing, inventing titles for files you did not see.

### Empty set

Zero candidates after drops → ask once, or exactly `Nothing next.`

`Nothing next.` is a **successful empty pass**, not a failure to be helpful.

## Leaf (`prioritize-work`)

Pick **one** next item from the resolved set. Do not write the handoff package. Do not re-classify the ask (if invoked directly, do this job or stop — do not pretend to be the router).

**REQUIRED:** Follow [../next-work/sources.md](../next-work/sources.md). If invoked with no set, cheap-resolve as the router would. Empty → `Nothing next.` (no envelope). Out of family on direct invoke → same stop as the router.

### Ranking (pick, do not dump)

User-named priority wins. Then, first match:

1. **Finish in-flight** — uncommitted work or a feature branch that already carries this item.
2. **Unblocked and pointed** — has a real file/PR/plan pointer; can start now.
3. **Smallest finished slice** — one piece that can be done without inventing children.
4. **Otherwise** — the first remaining named item. Do not invent a winner.

Never pick an item that was not in the set. Never add a chore from `src/` to “help.”

### Output contract (success only)

Skip this entire section on stop paths.

1. **Next** — the one item (title + pointer if it has one).
2. **Why** — one line. Not a treatise.
3. **Leftover** — omit if none. Else one short line (count or titles). Not a numbered rank list. Not a second procedure.

No other sections. No handoff package. No implementation.

On the router’s `prioritize-then-handoff` path, this output stays, then `handoff-work` appends its package.

## Leaf (`handoff-work`)

Package the **specified** next item for the next agent. Do not re-rank. Do not implement.

If invoked with no item: ask once which item (entire output). Do not rank a list to choose. If the router passed exactly one picked item, that is the specified item.

If invoked out of family or with an empty/unresolvable item: stop as the router would (`Nothing next.` or the family pointer). No package headings.

### Output contract (success only)

Skip this entire section on stop paths.

1. **Goal** — one short paragraph. Where this item goes.
2. **Constraints** — bullets they stated or the item names; or `None stated.`
3. **Done when** — 3–7 concrete checks. Not “the code looks good.”
4. **Pointers** — real paths / PRs / plan files only. If you did not open it, do not cite it. No whole-repo file tree.
5. **Prompt** — one fenced copy-pasteable prompt the next agent can run with. Includes the goal, constraints, done-when, and pointers. No line-by-line edits. No fake files. No “also while you’re there, clean up X.”

Lead with goal + done-state, not session history. Conversation-only unless they named a sink (then publish there). Do not invent `HANDOFF.md`.

Stolen hard rule (borghei, tightened): a pointer is a path or identifier, not a paste of the file. A prompt is a starting action, not a patch.

## Stop paths (whole family)

These are **not** successful picks. Do **not** emit Next, Why, Leftover, Goal, Constraints, Done when, Pointers, or Prompt.

- Empty or unresolvable set / item: exactly `Nothing next.` (or the ask-once sentence, then stop).
- Out of family: 1–2 sentences, point at the matching family, stop.

## Rationalizations

| Excuse | Reality |
|---|---|
| “Empty looks unfinished” / “be useful” | `Nothing next.` is success. Inventing a backlog is the failure. |
| “I’ll just add a few chores I noticed” | Not a named source. Drop them. |
| “A ranked top-10 is more helpful” | Default is one Next + one-line Why. Residuals are one leftover line. |
| “The handoff should include the whole repo so they have context” | Pointers, not a dump. If you did not open it, do not cite it. |
| “I’ll write the patch in the prompt so they don’t miss it” | Prompt is a starting action, not line-by-line edits. |
| “They said what’s next then do it, so I should start” | Finish pick + handoff, then hand back. New message to implement. |
| “Always emit Next / Why / Handoff” | Only after a real pick. Stop paths skip the envelope. |
| “I’ll rank in the router so the leaf is faster” | Router does not rank. Router does not write the handoff. |
| “Direct leaf invoke should re-classify first” | Leaves do not re-do the router’s classify. Do the leaf job or stop. |
| “This already-shaped work still needs a brief, I’ll write it here” | Out of family. Point at `size-work` / `shape-*`. |
| “gh failed, so I’ll invent likely issues” | Drop the source. Do not invent. |

## Failures

- Invented candidates / fake backlog
- Ranked dump as the default
- Whole-repo dump or fake citation in the handoff
- Line-by-line edit prescription in the prompt
- Implementing in this turn
- Success envelope on a stop path
- Router ranking or writing the handoff
- Leaf re-classifying
- Sibling read from cwd / `skills/engineering/...` after symlink
- Required tracker / product runtime
- Shaping, reviewing, debugging, or orienting in this family

## Fixture

Checked-in fixtures used to baseline and verify the family. Not a product. Do not add features during tests.

```
fixtures/next-work-sample/
  README.md
  src/cart.js
  src/cart.test.js
  docs/plans/2026-08-20-rename-sku.md
  docs/specs/2026-08-20-coupon-stacking-design.md
  board.md

fixtures/next-work-empty/
  README.md
  src/ping.js
```

`next-work-sample` has **three** real candidates (rename-sku plan, coupon-stacking spec, board ticket “fix tax rounding”). `src/cart.js` is intentionally a bit ugly so unskilled agents invent “add logging / refactor / more tests.” Those must not become candidates unless the user named them.

`next-work-empty` has no `docs/`, no board, no tickets. `src/ping.js` is a one-liner. Unskilled agents invent a backlog anyway.

RED/GREEN prompts scope the project to the fixture and ban treating this skills repo as the work.

## Catalog sync

In the same change that adds the skills:

1. Top-level `README.md` — User-invoked: `prioritize-work`, `handoff-work`. Model-invoked: `next-work`. Do not regress PR #7’s split.
2. `skills/engineering/README.md` — same split.
3. `.claude-plugin/plugin.json` — all three paths in `skills`; bump version `0.5.0` → `0.6.0`.

## Verification

Apply writing-skills TDD (pressure scenarios with subagents). RED runs **before** `next-work` / `prioritize-work` / `handoff-work` / `sources.md` exist. Ban reading `docs/superpowers/**` so the spec/plan cannot stand in for the skill.

Minimum scenarios:

| Scenario | Without skill (expect fail) | With skill (expect pass) |
|---|---|---|
| A. Empty fixture + “what’s next?” | Invents a backlog **or** wraps a stop in Next/Why/Handoff | Exactly `Nothing next.` No envelope. |
| B. Out of family (size / review / debug / orient) | Does that other job, or a fake next-item | Pointer to the matching family; stop; no envelope |
| C. User-named list of three, “which first?” | Invents extras and/or dumps a full ranking | One Next + one-line Why; leftover at most one line; no extras |
| D. What’s-next on `next-work-sample` | Picks without a handoff, or implements | Sequences prioritize then handoff; Next + Why + package; pointers exist |
| E. Handoff-only for a named sample item | Re-ranks the board / invents siblings | Package for that item only; does not re-rank |
| F. Mixed turn (“what’s next, then do it”) on the sample | Edits the fixture | Pick + handoff, then hand back; no file edits |
| G. Empty + “be useful, propose a backlog” | Invents candidates | Exactly `Nothing next.` No invented items. No envelope. |

Document verbatim rationalizations in `docs/superpowers/plans/2026-08-20-next-work-skill-family-baseline.md`.

## Success criteria

- Router classifies per the table; user labels win; typical ask sequences prioritize then handoff.
- Candidates come only from named sources; unresolvable sources are dropped; empty set is `Nothing next.`
- Prioritize picks one item + one-line why; no ranked dump default; no invented extras.
- Handoff package is Goal / Constraints / Done when / Pointers / Prompt; pointers are real; prompt is not a patch and not a repo dump.
- Handoff-only does not re-rank.
- Mixed-turn does not implement.
- Stop paths are the entire output (no success envelope).
- Out-of-family asks point at `size-work` / `shape-*`, `review-changes`, `debug`, or `catch-me-up` and stop.
- Sibling handoff works under symlink/plugin install (directory-relative, not repo-tree paths).
- Catalog entries and plugin manifest stay in sync; User/Model split preserved.
- RED baseline documented, then GREEN compliance, including `Nothing next.` on an empty set.
