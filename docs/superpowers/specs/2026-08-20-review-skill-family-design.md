# Review skill family

Date: 2026-08-20
Status: verified (RED baseline + GREEN subagent runs)
Repo: jamesthomasonjr/skills

## Problem

Coding agents asked to “review this” default to helpful theater: style nits, naming suggestions, a “Minor / consider” bucket, praise, and a merge stamp. They treat pre-existing issues as new findings, review the whole repo instead of the change, refuse to emit an empty report, and sometimes implement the fix in the same turn. That is the opposite of a defect-first review.

This family exists to classify a review *target*, then produce a read-only defect report — or exactly `No findings.` It is not a GitHub bot, not a gstack port, and not an auto-fixer.

## Goals

- Classify the review target (working tree, commit, branch/PR/default) and announce the comparison.
- Hand off to a single defect-first leaf that inspects that comparison only.
- Flag a finding only when every gate in the shared playbook is true.
- Allow an empty pass: `No findings.` is success, not a failure to be thorough.
- Stay project-agnostic and agent-agnostic (Cursor, Claude Code, Codex, others).
- Stay read-only in the review turn. Mixed “review then fix” finishes the review and hands back.

## Non-goals

- GitHub review comments, PR posting, LGTM / merge stamps.
- Auto-fix, applying the patch, or implementing in the review turn.
- A security-specialist leaf, performance-specialist leaf, or plan/spec-review leaf.
- mattpocock Standards / Spec axes.
- gstack preambles, telemetry, completeness-gap “boil the ocean,” or product runtimes from Codex `$review-agent`.
- Inferring review “modes” from a menu. Focus is an optional user-named phrase, not a taxonomy.

## Sources

| Source | What we take | What we drop |
|---|---|---|
| This repo’s catch-me-up / size-work families | Thin router → one leaf; shared playbook file next to the router; hard rules; sibling handoff from this file’s directory not cwd; model-invoked router + user-invoked leaf; mixed-turn hand-back; Failures list; rationalizations table | Orientation briefing shape; work-level hierarchy |
| OpenAI Codex `$review-agent` | Defect-first; all-gates-must-be-true; `No findings.` empty pass; P0–P3; `[P1] Title — path:line` plus one short paragraph; smallest overlapping cite; author-would-fix; continue through the whole diff | JSON output schema; suggestion blocks; `overall_correctness` verdict; Codex product runtime |
| OpenAI Codex inline `review/rubric.md` | Discrete/actionable; introduced by this change; demonstrable call path; no speculation; no style nits; one comment per issue; matter-of-fact tone | JSON schema; suggestion blocks; repository-rule attribution machinery; “patch is correct” stamp |
| AntJanus/skillbox idea | When in doubt **DROP**; a finding must name a **concrete bad outcome** | Product packaging / extra axes |

## Approaches considered

1. **Thin router + one leaf + `gates.md` (recommended).** Matches catch-me-up (`modes.md`) and size-work (`levels.md`). Router owns target resolution. Leaf owns the review. Playbook lives in one file so the router does not restate gates.
2. **Single mega-skill.** Classifies and reviews in one `SKILL.md`. Agents skip classification, mix playbook with procedure, and the file does two jobs.
3. **Router + specialist leaves** (security, performance, nits). Explicitly out of v1. Focus is a phrase, not a menu.

v1 is approach 1.

## Architecture

Two promoted engineering skills. One sequential agent. Router classifies, announces the comparison, hands off. Leaf reviews. Router does not review. Leaf does not re-classify the target.

```
skills/engineering/
  review-changes/
    SKILL.md       # router: classify, announce comparison, hand off
    gates.md       # six gates, P0–P3, suppressions, empty-pass contract
  review-defects/
    SKILL.md       # leaf: defect-first read-only review
```

Hard rules for the whole family:

- Read-only. No edits, no commits, no pushes, no GitHub review comments.
- Review the classified comparison only. Do not tour the rest of the repo.
- Flag a finding only when **all six** gates in `gates.md` are true. If any gate is shaky, **drop**.
- When in doubt about impact, drop. Do not invent a finding.
- If nothing qualifies, write exactly `No findings.`
- Mixed turn (“review this, then fix it”): the leaf finishes the review, then **hands back**. Do not implement in this turn. They must send a **new message** to implement. Do not discard the fix request.
- Out of family (“review this plan / spec / design”): stop. Point at `shape-*` or a later plan-review skill. Do not review prose as if it were a code diff.

## Invocation

| Skill | Invocation |
|---|---|
| `review-changes` | Model-invoked. Omit `disable-model-invocation`. |
| `review-defects` | User-invoked (`disable-model-invocation: true`). Reached via router or explicit name. |

### Router triggers (`review-changes` description)

Third person; what it does and when to use it (this repo’s catalog convention). Router for defect-first code review. Use when the user asks to review a change, PR, commit, working tree, or what they just changed. Classifies the comparison and hands off; does not review.

Do not summarize the six gates in the description (SDO: agents follow the description and skip the body).

### Leaf triggers (`review-defects` description)

Defect-first read-only review of a specified comparison. Use when `review-changes` hands off, or the user explicitly wants findings against a named diff/commit/branch/working tree. May return `No findings.` Does not implement.

## Router (`review-changes`)

Classifies the review target, announces the comparison in one short line, reads the sibling leaf from this skill’s directory (not cwd), and follows that skill. It does **not** apply gates. It does **not** write findings.

**REQUIRED:** cheap-resolve the comparison (git) before handing off, so the leaf receives a concrete command and file list. Not allowed in the router: reading hunks to judge defects, applying gates, writing findings.

### Classify

Explicit user labels win.

| Signal | Comparison passed to the leaf |
|---|---|
| Uncommitted / working tree / “what I just changed” | Working tree vs HEAD (staged, unstaged, untracked) |
| Named commit | That commit vs its parent |
| Named branch, “this PR”, or no target | Merge-base of `<base>` … `<tip>` |

Assign **`<base>` before `<tip>`**. A named default/integration ref (`origin/main`, `main`, `origin/HEAD`, `master`, …) is `<base>`, never `<tip>`. “against X” / “into X” / “compared to X” / “vs X” assigns X as `<base>`.

**`<tip>`:** a named *non-base* branch; else HEAD when HEAD is that feature/PR branch. “Review this PR” with no extra ref: `<tip>` = current PR branch, `<base>` = default. Two named refs: the against/into/vs or default-looking one is `<base>`; the other is `<tip>`. Do not set both to `main`. If they only named the default and HEAD is a feature/PR branch, `<tip>` = HEAD.

**`<base>` when unset:** `origin/HEAD`, else `origin/main`, else `main`, else `master`. **Never** the tip’s self-upstream.

Naming a feature/PR branch while checked out on `main` still uses that non-base ref as `<tip>`. “this PR” while HEAD is already the default branch and they named no feature ref: unresolvable — ask once.

**Three-dot merge:** `git merge-base <tip> <base>`, then `git diff <merge-base>...<tip>` (the changes that would actually merge onto the default branch). Not `git merge-base HEAD <ref>` with `<ref>` = `@{upstream}` of the same branch. Not `...HEAD` when `<tip>` is a named ref other than the current checkout.

If the three-dot file list is empty or tip equals base: `Nothing to review.` Do not treat a self-diff as a successful empty pass.

**Working-tree command:** file list = union of `git diff HEAD --name-only` and `git ls-files --others --exclude-standard`. Inspect `git diff HEAD` for tracked changes **and** each untracked path (Read, or `git diff --no-index -- /dev/null <path>`). Do not `git add`. Untracked-only is a real comparison — not `Nothing to review.` Empty only when both lists are empty.

**Named-commit command:** `git diff <commit>^ <commit>` (or `git show` equivalent). First parent for merges. A commit with no parent (root) is unresolvable → ask once or `Nothing to review.`

### Empty or unresolvable

- Empty working tree when they asked for uncommitted / “what I just changed”: stop. Write exactly `Nothing to review.`
- Named ref that does not resolve: **ask once** for a commit, branch, or “working tree,” then stop until they answer. If they cannot or will not, stop with `Nothing to review.`
- Do not guess a different comparison. Do not review the whole repo.

### Out of family

“Review this plan / spec / design / charter / brief” with no code diff: stop in one or two sentences. Point at `shape-*` (or a later plan-review skill, which does not exist in v1). Do not read `review-defects`. Do not review markdown as if it were a patch.

### Focus

If the user named a focus phrase (“security”, “races”, “the checkout path”), pass it through. Focus is **not** a menu and **not** a filter. Do **not** infer modes. Do **not** invent a focus when they did not name one.

The leaf still applies the same six gates to the **whole** comparison. It may mention the phrase in Assessment. It must not invent in-focus nits to “honor” the phrase. Do not add a focus taxonomy.

### Ambiguity

If two signals both appear (e.g. “review this PR and also what I just changed”), user label wins; if still tied, ask once. Stop until they answer unless they already said “just pick,” then prefer working tree when uncommitted changes exist, otherwise merge-base of `<base>` … `<tip>`.

### Announce and hand off

One line: which comparison and why (short).

Read the **sibling** skill from this file’s directory (not cwd):

- [../review-defects/SKILL.md](../review-defects/SKILL.md)
- [gates.md](gates.md) — router links it as the family playbook; **does not restate** the six gates, P0–P3, or suppressions.

`../review-defects/SKILL.md` means “next to this skill,” i.e. the `review-defects` folder beside `review-changes`. After `~/.cursor/skills/<name>` symlink or a plugin copy, `skills/engineering/review-*/SKILL.md` does not exist.

If a cwd-relative Read of `../review-defects/SKILL.md` misses (user workspace is a different repo), resolve the sibling from the path used to open **this** `SKILL.md`, or invoke the leaf by name.

Pass:

- comparison (human-readable, e.g. `Working tree vs HEAD`)
- comparison command (the exact git invocation)
- file list (paths from that command; untracked included when working tree)
- mixed-turn fix request if any
- optional focus phrase if the user named one

Then follow `review-defects`. Do not keep a second review procedure in the router.

## Playbook (`gates.md`)

Single source for gates, severity, suppressions, and the empty-pass contract. The leaf is **REQUIRED** to read and follow it. The router does not restate it.

Canonical six gates — flag a finding only when **all six** are true:

1. Meaningful correctness / security / performance / maintainability.
2. Discrete and actionable.
3. Introduced by this change, not pre-existing.
4. Affected scenario or call path demonstrable from the code.
5. Names a **concrete bad outcome** (what breaks, for whom).
6. The author would probably fix it if they knew about it.

If any gate is shaky, **drop**. When in doubt about impact, drop.

### Suppressions (never a numbered finding)

- Style, naming, comment, or formatting nits.
- Anything a linter, formatter, or typechecker already enforces.
- Speculative “might break” with no demonstrable call path.
- Intentional behavior the diff is clearly aiming at.
- Pre-existing issues: at most **one residual-risk line** in Assessment, never a numbered finding.
- A “Minor / nit / consider” bucket. There is no such bucket.

### Severity

- `P0` — universal release blocker or critical failure (does not depend on exotic inputs).
- `P1` — urgent defect that should be fixed next.
- `P2` — ordinary defect that should be fixed.
- `P3` — low-impact issue that is still worth fixing (and still passes all six gates).

Do not inflate. A naming nit is not a P3; it is dropped.

### Empty pass vs stop

A **successful empty review** (a real comparison was inspected, nothing survived): write exactly `No findings.` as the Findings block, then Assessment and Close. Do not invent a finding.

**Stop paths** (`Nothing to review.`, out-of-family `shape-*` pointer) are not empty reviews. Do not wrap them in Findings / Assessment / Close.

### Cite

Smallest `path:line` (or short range) that overlaps the reviewed diff. Do not cite unrelated files to look thorough.

## Leaf (`review-defects`)

Read-only defect-first review of the comparison the router passed (or that the user named on direct invoke).

**REQUIRED:** Read [../review-changes/gates.md](../review-changes/gates.md) before writing findings. Same sibling-resolve rule as the router. Do not paste the six-gate list into this file.

If invoked directly with no comparison: cheap-resolve as the router would (working tree if they said “what I just changed”; else merge-base of `<base>` … `<tip>`). If empty/unresolvable, `Nothing to review.` If the user pointed at a plan/spec/design, stop out of family — do not review it. Stop paths do **not** use the Findings / Assessment / Close envelope.

### Procedure

1. Inspect the complete diff for the passed comparison command, plus enough surrounding code and tests to confirm each candidate.
2. Continue through the whole diff after the first issue. Do not stop at one finding. Do not tour files outside the file list except to demonstrate a call path for a candidate that already overlaps the diff.
3. For each candidate, apply every gate in `gates.md`. Drop if any is shaky.
4. Skip anything listed under Suppressions.
5. Assign P0–P3 only to survivors.
6. If this is a stop path, write only that stop. Otherwise write the output contract. Then stop (or hand back on mixed turn).

### Output contract (in order)

**Stop paths skip this section** (`Nothing to review.` or a 1–2 sentence `shape-*` pointer). Do not fabricate Findings / Assessment / Close.

Otherwise:

1. **Findings** — one entry per surviving issue, severity-first:

   `[P1] Imperative title — path/to/file:line`

   Followed by one short paragraph: affected scenario, concrete bad outcome, why the change is wrong. No second paragraph. No patch. No suggestion block.

   **Or**, if none survive: exactly `No findings.`

2. **Assessment** — 1–3 sentences: target + comparison, material test gaps, residual pre-existing risk (at most one line for pre-existing). No merge stamp. No LGTM.

3. **Close** — stop, or mixed-turn hand-back: review is done; they must send a **new message** to implement. Do not discard the fix request. Do not edit.

No other sections. No “Nice to have.” No praise. No GitHub review comments.

### Rationalizations

| Excuse | Reality |
|---|---|
| “Empty report looks unfinished” | `No findings.` is success. Inventing a finding is the failure. |
| “Nits help the author” | Nits are not findings. Drop them. |
| “This pre-existing bug is serious” | Residual-risk line in Assessment. Never a numbered finding. |
| “It might fail in production” | Speculative → drop. Demonstrate the call path or drop. |
| “When in doubt, flag it” | When in doubt, **drop**. |
| “I’ll just fix it while I’m here” | Review turn is read-only. Hand back. New message to implement. |
| “A Minor section keeps the nits somewhere” | There is no nit bucket. Drop them. |
| “Thorough means more findings” | Thorough means every qualifying defect, and nothing else. |

### Failures

- Invented findings on a clean change
- Style / naming / comment nits as findings
- Pre-existing issue as a numbered finding
- Whole-repo review outside the comparison
- Implementing, editing, committing, or posting a GitHub review
- A “Minor / nit / consider” bucket
- A finding with no concrete bad outcome
- Merge stamp / LGTM theater
- Reviewing a plan/spec/design as if it were a code diff

## Fixture

Checked-in `fixtures/review-sample/` used to baseline and verify the family. Not a product. Do not add features during review tests.

Layout:

```
fixtures/review-sample/
  README.md              # purpose + which diffs are which
  src/pricing.js         # base (pre-change), includes a pre-existing unused helper
  src/pricing.test.js    # pins current totals
  src/refunds.js         # pre-existing unused export; not in the clean diffs
  changes/
    clean-rename.diff    # local rename; no behavior change → No findings
    nits-only.diff       # comment + identifier style + blank line → No findings
    tax-bug.diff         # tax applied before discount; shopper overcharged → real finding
```

`src/` is the parent. Each `changes/*.diff` is the proposed patch against that parent. RED/GREEN prompts name the diff file and forbid editing `src/`.

## Catalog sync

In the same change that adds the skills:

1. Top-level `README.md` — link `review-changes` and `review-defects`
2. `skills/engineering/README.md` — router under Model-invoked; leaf under User-invoked
3. `.claude-plugin/plugin.json` — both paths in `skills`; bump version `0.3.0` → `0.4.0`

## Verification

Apply writing-skills TDD (pressure scenarios with subagents). RED runs **before** `review-changes` / `review-defects` / `gates.md` exist. Ban reading `docs/superpowers/**` so the spec/plan cannot stand in for the skill.

Minimum scenarios:

| Scenario | Without skill (expect fail) | With skill (expect pass) |
|---|---|---|
| A. `clean-rename.diff` + “be thorough” | Invents nits / naming findings | Exactly `No findings.` (plus Assessment + Close) |
| B. `nits-only.diff` + “flag anything” | Nit bucket / consider comments | `No findings.`; no Minor section |
| C. `tax-bug.diff` | May find it, or bury it under nits | One (or few) P-tagged finding with concrete overcharge outcome; cite overlaps the diff |
| D. Clean rename; unused helper still in `pricing.js` / `refunds.js` | Flags pre-existing unused code as new | Residual-risk line at most; not a numbered finding |
| E. `tax-bug.diff` + “review this, then fix it” | Edits the fixture | Review, then hand back; no file edits |
| F. “Review this design spec” (no code diff) | Reviews the markdown as a patch | Out of family; points at `shape-*`; no Findings/Assessment/Close envelope |
| G. Empty / unresolvable target | Guesses the whole repo | `Nothing to review.` (not a three-block empty pass) |
| H. “this PR” / named feature branch vs default | Self-upstream empty diff → fake `No findings.` | `git diff $(git merge-base <tip> <base>)...<tip>`; `<base>` is `main` / repo default, never self-upstream; file list nonempty |
| I. “review this against origin/main” / “feature into main” | Named default becomes `<tip>` → tip equals base → `Nothing to review.` | Named default is `<base>`; `<tip>` is the feature/PR branch; file list is the real PR |
| J. Working tree, untracked-only file | `git diff HEAD` empty → fake `Nothing to review.` / `No findings.` | Inspect the untracked path; do not `git add`; not an empty review |

Document verbatim rationalizations in `docs/superpowers/plans/2026-08-20-review-skill-family-baseline.md`.

## Success criteria

- Router classifies working tree / commit / branch-or-PR per the table; user labels win.
- Branch / “this PR” / no-target uses `<tip>` vs default `<base>` (`git diff $(git merge-base <tip> <base>)...<tip>`), never the branch’s self-upstream. A named default / “against X” / “into X” is `<base>`, never `<tip>`.
- Router announces the comparison, passes command + file list + optional focus + mixed-turn request, and does not write findings.
- Empty or unresolvable target: ask once or `Nothing to review.`
- Out-of-family plan/spec/design: stop; point at `shape-*`. Stop paths do not use Findings / Assessment / Close.
- Leaf follows `gates.md`; DROP when shaky; `No findings.` on clean/nits-only diffs.
- Real defect gets a P0–P3 entry with concrete bad outcome and smallest overlapping `path:line`.
- Pre-existing is residual risk, not a numbered finding.
- Mixed-turn does not implement.
- No GitHub posting, no LGTM, no nit bucket, no specialist leaves.
- Sibling handoff works under symlink/plugin install (directory-relative, not repo-tree paths).
- Catalog entries and plugin manifest stay in sync.
- RED baseline documented, then GREEN compliance, including `No findings.` on a clean change.
