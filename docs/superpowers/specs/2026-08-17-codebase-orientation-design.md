# Codebase orientation skill family

Date: 2026-08-17
Status: draft for review
Repo: jamesthomasonjr/skills

## Problem

Onboarding to an unfamiliar repo, or understanding a module or function well enough to change it, is most of real AI-assisted work. Oliveira’s analysis of 116 Claude sessions at Sentry: 67% of prompts were comprehension, 2% were generation. Agents that skip a human-comprehension pass plan and implement against a wrong mental model.

This family exists to build the **user’s** mental model. It is not an agent memory pack, not a tutor, and not a prelude that starts writing code.

## Goals

- Rapidly onboard to a new codebase.
- Explain a repository’s architecture.
- Explain a file, module, or class: purpose and important methods.
- Explain a function: step-by-step behavior, inputs, outputs, side effects, edge cases.
- Support Catch Me Up’s six exploration modes as lenses.
- Stay read-only. Brief, cite, stop.

## Non-goals

- Writing files: no inline comments, no `ONBOARDING.md`, no `docs/ai/` pack, no learning journal.
- Socratic quizzing (ktaletsk/learn-codebase).
- Parallel mode subagents.
- Planning or implementing the change just understood.
- Interview-theater from Hello Interview (narrate for an interviewer). Keep the checklist; drop the performance advice.
- Running the full test suite or a debugger unless the user asks.

## Sources

| Source | What we take | What we drop |
|---|---|---|
| Catch Me Up (Priscila Oliveira / Sentry) | Six modes; comprehension before generation; sampling limits; tables/structure for a visual mental model; human absorbs research before plan/implement | Productizing her private `~/.claude/skills/catch-me-up/skill.md` verbatim |
| Hello Interview, *Codebase Orientation* | “Understanding the project structure” checklist; targeted questions; verify against code; Syntax for unfamiliar idioms | “Add comments to every class and method”; interview narration |
| 3-layer reading (structure → patterns → details) | Maps onto repo / module / function depths | Treating layers as separate skills |
| obra/superpowers | Thin router that hands off; process skills that chain; progressive disclosure | TDD/plan/implement pipeline (out of scope here) |
| Titan `docs/ai/` context pack | Optional later persist skill, not this family | Writing YAML into the target repo |
| grepika/learn-codebase, florianbuetow/onboarding, pmatos/wigo | Trigger phrases and briefing shape as references | MCP-only tools; session/git-status “what’s going on” (different job) |

## Architecture

Four promoted engineering skills. One sequential agent. The router classifies and (on repo onboard) asks which modes to run. It then reads the matching depth skill and `modes.md` and works as that skill.

```
skills/engineering/
  catch-me-up/
    SKILL.md          # router: classify, ask modes, hand off
    modes.md          # six lens playbooks (single source)
  orient-repo/
    SKILL.md          # whole-repo onboard + architecture
  orient-module/
    SKILL.md          # file / module / class
  orient-function/
    SKILL.md          # one function or method
```

Hard rules for the whole family:

- Read-only. No edits.
- Cite `path:line` and a short snippet for every non-obvious claim.
- If a claim cannot be pointed at, say so. Do not invent architecture.
- Prefer “the code does X” over “this looks like it should do X.”
- Explain before suggesting any change. Do not implement.

## Router (`catch-me-up`)

Does not explore the repo itself. Classifies, optionally asks, hands off.

### Depth classification

| User signal | Depth skill |
|---|---|
| “onboard me”, “catch me up on this repo”, “how is this project structured”, no target named | `orient-repo` |
| a file, folder, module, class, or “what does X do?” where X is a type/module | `orient-module` |
| a function/method, “walk me through `foo`”, “what does this function do step by step” | `orient-function` |
| a feature or user journey (“how does checkout work”) | `orient-repo` if no locus yet, else `orient-module` at the entry of that flow, with Feature Trace required |
| ambiguous | ask once: repo / module / function, then continue |

### Mode menu

Shown on repo onboard. Inferred on targeted asks.

1. Architecture
2. Convention
3. Feature Trace
4. Syntax / API
5. Testing
6. History

Repo onboard prompt, every time:

> Which modes? Architecture / Convention / Feature Trace / Syntax / Testing / History
> (You can pick several. I’ll stay read-only and brief you.)

If they pick Feature Trace and have not named a journey, ask for one, or offer the main path already visible (CLI, HTTP entry, test runner).

### Inferred defaults (no menu)

| Depth | Default modes |
|---|---|
| module/class/file | Architecture (local) + Convention + Syntax. Add Feature Trace if they asked “how does it work”. Add Testing/History only if asked or needed to explain a surprising shape. |
| function | Syntax (step-by-step I/O and edge cases) + Testing. History only if the body is otherwise inexplicable. |

### Handoff

After classification, the agent reads the depth `SKILL.md` and `catch-me-up/modes.md`, then works as that skill. The router does not keep a second procedure.

### Invocation

- `catch-me-up`: model-invoked (omit `disable-model-invocation`). Triggers: onboard, catch me up, explain this repo/file/class/function, how does X work, walk me through, what does this do.
- Depth skills: `disable-model-invocation: true`. Reached via router or explicit name.

## Depth skills

### `orient-repo`

Job: mental map of the whole project. Hello Interview’s “Understanding the project structure” is the default map.

Always gather (even if only some modes are selected):

- What the project is (README, manifests, one-line purpose)
- Directory layout (top-level + depth-two; skip vendor/build noise)
- Entry points (main, HTTP, CLI, workers)
- How to run tests, if obvious

Then apply selected modes. Architecture fills: entry points, key functions, class/data-model hierarchy, architectural pattern, public interfaces, state, existing tests, constraints/assumptions.

Sampling: do not swallow the repo. Architecture samples top-level + depth-two across **3–5 key files**. Feature Trace follows one path as far as the path needs and does not detour. History is `git log` / blame on those same files, not the whole tree.

Briefing: purpose → map (tree or table) → entry points and data flow → selected mode sections → “read these next” (3–7 pointers) → open questions / unverified claims.

### `orient-module`

Job: purpose, place in the system, important types/methods, what to touch vs leave alone.

Always gather: path, exports/public surface, who imports it, what it imports, the 3–7 methods or types that do the real work.

Lenses at this scope: local architecture, convention vs neighbors, one call in / one call out, dense APIs, how this unit is tested, why this file looks like this.

Briefing: one-paragraph purpose → public surface table → important methods (name, role, not full walkthrough) → collaborators → selected extra modes → “if you need a step-by-step, name a function.”

### `orient-function`

Job: what it does, step by step, including I/O and edge cases.

Always gather: signature, callers, callees, pre/post conditions visible in code or tests.

Required walkthrough:

1. Inputs (types, invariants, who passes them)
2. Steps in order (control flow, not a line-by-line recitation)
3. Outputs and side effects
4. Edge cases and error paths (from the body **and** tests)
5. What it does *not* do

Syntax is the primary lens. Testing is the check. History only if the body is otherwise odd.

Briefing: signature + one-sentence purpose → I/O table → numbered steps → edge cases → tests that pin this behavior → related functions (not a module dump).

### Shared close

End with one question: go deeper (name a module/function), add a mode, or stop.

Visual when it helps: tables for surfaces, a small mermaid for one flow. No gallery of diagrams.

## Six lenses (`catch-me-up/modes.md`)

Each lens: **when**, **what to sample**, **what to report**. Depth skills call these; they do not rewrite them.

**Architecture**  
When: “how is this structured”, repo onboard, first look at a module.  
Sample: top-level + depth-two; 3–5 key files; entry points and core data types.  
Report: boundaries, layers, entry points, data-model hierarchy, pattern, where state lives. Table or small mermaid, not a file dump.

**Convention**  
When: “what’s the standard”, before writing new code, module that looks unlike its neighbors.  
Sample: 3–5 peers of the same kind; linters/formatters/CI; `AGENTS.md` / `CLAUDE.md` / contributing docs if present.  
Report: naming, folder rules, error-handling style, test layout, “do this / don’t do this.” Call out violations as observations.

**Feature Trace**  
When: “how does X work”, “walk me through”, a user journey.  
Sample: one path, request-in to effect-out. Follow calls; do not tour siblings.  
Report: numbered steps with `path:line` at each hop, data in/out at boundaries, where it is stored or returned. One mermaid sequence if the path crosses 3+ files.

**Syntax / API**  
When: unfamiliar idiom, dense function, “what does this API mean”, function-level asks.  
Sample: the symbol and its public contract; 1–2 call sites; official docs only if the code is not enough.  
Report: plain-language meaning, inputs, outputs, side effects, edge cases. For a function, this is the walkthrough above.

**Testing**  
When: “how is this tested”, function/module briefing, Feature Trace that needs a reality check.  
Sample: tests that name the unit or the journey; fixtures; mocks/intercepts. Run tests only if the user asks — default is read the tests.  
Report: what is guaranteed, what is mocked, what is not covered.

**History**  
When: “why is it like this”, surprising shape, conflict with current convention.  
Sample: `git log` / blame on files already in scope (last ~15 commits or the introducing commit), plus a nearby ADR or PR if obvious.  
Report: the decision and the edge case it was solving, in 3–6 bullets. No biography of the repo.

**Mode interaction:** Feature Trace may pull Testing for the same path. Architecture may pull Convention for “how folders mean things.” History never runs unbounded. If a selected mode has nothing to find, say so in one line and skip.

## Failure and thin evidence

- No repo / empty tree: say so and stop.
- Target not found: search once, then ask for a path or symbol.
- Mode has no signal: one line, skip that section.
- Conflict between README and code: prefer code, note the mismatch.
- Huge monorepo: stay inside the current workspace root; say if you only mapped a package.

## Size and splitting (revised)

Cursor’s create-skill guide says “keep SKILL.md under 500 lines.” That is a default, not a functionality cap. Superpowers (obra, plugin 5.0.7) does not follow it as a hard rule.

### Superpowers `SKILL.md` sizes

| Skill | Lines | Role |
|---|---:|---|
| executing-plans | 70 | thin executor / handoff |
| requesting-code-review | 105 | focused process |
| using-superpowers | 117 | **router analog** — check skills, then act |
| verification-before-completion | 139 | focused process |
| writing-plans | 152 | process |
| brainstorming | 164 | process + handoff to writing-plans |
| dispatching-parallel-agents | 182 | process |
| finishing-a-development-branch | 200 | process |
| receiving-code-review | 213 | process |
| using-git-worktrees | 218 | process |
| subagent-driven-development | 277 | heavy process |
| systematic-debugging | 296 | heavy process (+ 10 support files) |
| test-driven-development | 371 | heavy process |
| writing-skills | 655 | outlier; still ships |

Median SKILL.md is ~191 lines. The router analog (`using-superpowers`) is 117. The heaviest *procedure* skills that agents must follow exactly are 277–371. Only `writing-skills` exceeds 500.

Support files are used when a skill has a second job (reviewer prompts, anti-pattern catalogs, platform tool maps), not to keep SKILL.md under an arbitrary number. `systematic-debugging` is 296 lines *plus* root-cause-tracing, defense-in-depth, and pressure tests. `writing-skills` is 655 plus a 1,150-line Anthropic reference that is linked, not inlined.

### Rule for this family

- Do not truncate procedure to hit a line budget. Functionality wins.
- Prefer Superpowers’ observed bands:
  - Router: as thin as `using-superpowers` / `executing-plans` if the procedure fits (~70–160). Grow past that if classification rules need it.
  - Depth skills: expect the 150–370 band. 400–600 is acceptable if the walkthrough rules would otherwise be vague.
- Split when a file is doing **two jobs**, not when it crosses 500. Already planned: procedure in each depth `SKILL.md`, lenses in `modes.md`.
- No hard ceiling. If a file needs 655 lines of procedure to be reliable, keep it (precedent: `writing-skills`).
- One-level links only. Do not nest references.

This supersedes the repo `CLAUDE.md` line “Keep SKILL.md under 500 lines” for this family. A later change to `CLAUDE.md` should replace that sentence with the two-jobs split rule above.

## Catalog

All four skills are promoted in `skills/engineering/`:

1. Each `SKILL.md` has `name` and `description` (what + when, trigger phrases).
2. Root `README.md` and `skills/engineering/README.md` list each skill, linked to its `SKILL.md`.
3. `.claude-plugin/plugin.json` `skills` array includes all four paths.
4. Project-agnostic and agent-agnostic.

Suggested one-liners for the catalog (final copy during implementation):

- **catch-me-up** — Router for codebase orientation. Use when onboarding, catching up on a repo, or asking what a file, class, or function does.
- **orient-repo** — Whole-repo map: structure, entry points, architecture, selected Catch Me Up modes.
- **orient-module** — File, module, or class: purpose, public surface, important methods.
- **orient-function** — One function or method: step-by-step I/O, side effects, edge cases.

## Testing the skills (implementation phase)

Per Superpowers writing-skills: treat authoring as TDD for process docs. Before calling the family done:

1. Baseline a subagent *without* the skills on a fixture repo (this skills repo is fine) for: onboard, explain `orient-repo`, walk through a small function.
2. Record failures: invented architecture, no citations, starts editing, skips the mode menu, dumps the whole tree.
3. Write the skills to close those failures.
4. Re-run the same prompts with the skills loaded and confirm the briefing shape, citations, and read-only behavior.

## Open decisions (resolved in design)

| Decision | Choice |
|---|---|
| Primary job | Conversational briefing only |
| Topology | Router + 3 depth skills; modes as lenses |
| Repo onboard modes | Ask every time |
| Targeted-ask modes | Infer (table above) |
| Execution | One sequential agent |
| Persist / tutor / comments | Out of scope |
| Size | Functionality over line budget; Superpowers bands as preference |

## Implementation notes

Do not implement in the same change as this spec. Next step after spec approval: writing-plans → `docs/superpowers/plans/2026-08-17-codebase-orientation.md`.
