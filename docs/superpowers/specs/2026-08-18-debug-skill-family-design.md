# Debug skill family

Date: 2026-08-18
Status: draft for review (revised: single escalation owner, Phase 4 retry loop, verification + sibling handoff)
Repo: jamesthomasonjr/skills

## Problem

Coding agents default to plausible patches. That fixes symptoms, misses root cause, and often creates thrash on hard or flaky bugs. Popular external skills already encode the right discipline — Superpowers `systematic-debugging` (root-cause-first) and mattpocock `diagnosing-bugs` (feedback-loop-first) — but they optimize different gates and should not be merged into one mega-skill. This repo needs a portable, agent-agnostic family that routes to the right method without depending on those installs.

## Goals

- One model-invoked entry point when the user asks for help fixing, debugging, or finding root cause.
- Route everyday / clear-repro cases to a root-cause-first process.
- Route hard / flaky / no-repro / perf cases to a feedback-loop-first process.
- Prefer the root-cause path when ambiguous; escalate to the loop path when investigation stalls.
- Ship full procedures in this repo (no Superpowers / mattpocock install required).
- Stay project-agnostic and agent-agnostic.

## Non-goals

- gstack freeze, learnings memory, telemetry, or Claude-only hooks.
- Depending on Superpowers or mattpocock skills being installed.
- A fourth standalone `debug-verify` skill (verification is folded into each depth skill’s closeout).
- Rewriting orient or size families.
- Production incident / on-call runbooks.
- Security exploit or offensive debugging playbooks.
- Merging both methodologies into one file with conflicting gates.

## Sources

| Source | What we take | What we drop |
|---|---|---|
| This repo’s catch-me-up / size-work families | Thin router → depth skills; shared vocabulary file; hard rules; sibling handoff; model-invoked router + user-invoked depth | Read-only briefing; work-level hierarchy |
| obra/superpowers `systematic-debugging` | Iron Law; four phases; multi-component boundary instrumentation; 3-fix → architecture; red-flag / rationalization tables | Superpowers skill cross-links as hard deps; host-specific hooks |
| obra/superpowers `verification-before-completion` | Evidence-before-claims closeout pattern | Separate promoted skill in this family |
| mattpocock `diagnosing-bugs` | Red-capable loop gate; loop construction catalog; minimise; 3–5 ranked hypotheses; tagged debug logs; correct-seam regression; cleanup | CONTEXT.md / ADR hard requirements; matt-specific skill handoffs; issue-tracker coupling |
| garrytan/gstack `/investigate` | (reference only) scope discipline and debug report ideas | Freeze scripts, learnings, preamble bash, Claude-only tooling |

## Architecture

Three promoted engineering skills. One sequential agent. Router classifies and hands off. Depth skills own the procedure. Router does not investigate.

```
skills/engineering/
  debug/
    SKILL.md              # router: classify, announce, hand off
    paths.md              # path definitions + classification / escalation signals
  debug-root-cause/
    SKILL.md              # four-phase root-cause-first process
  debug-feedback-loop/
    SKILL.md              # six-phase feedback-loop-first process
```

Hard rules for the whole family:

- No symptom-only patches. Fix the cause (root-cause path) or earn a red-capable loop before theorizing (feedback-loop path).
- One change at a time. Do not stack untested fixes.
- Create or reuse a failing regression (or the tight loop command) before claiming the bug is fixed.
- Fresh verification evidence before any “fixed” / “done” claim.
- Prefer `debug-root-cause` when ambiguous; escalate to `debug-feedback-loop` when stalled.
- Depth skills own procedure. The router only classifies and hands off.
- Mixed turn (“debug this, then add feature X”): finish the debug path, then **hand back**. Do not expand into unrelated work in the same turn.

## Invocation

| Skill | Invocation |
|---|---|
| `debug` | Model-invoked. Omit `disable-model-invocation`. |
| `debug-root-cause` | User-invoked (`disable-model-invocation: true`). Reached via router or explicit name. |
| `debug-feedback-loop` | User-invoked (`disable-model-invocation: true`). Reached via router or explicit name. |

### Router triggers (`debug` description)

Use when the user asks for help fixing, debugging, or finding the root cause of an issue; or reports something broken, throwing, failing, or regressing and wants it diagnosed. Description is trigger-only — do not summarize the path workflow in the description (SDO).

## Router (`debug`)

Classifies, announces the path in one short line, reads the sibling depth skill from this skill’s directory (not cwd), and follows that skill. It does **not** run investigation steps itself. It does **not** own mid-run escalation.

### Classification (`paths.md`)

Canonical initial-routing table lives only in `paths.md`. Summary:

| Signal | Path |
|---|---|
| Clear repro, stack trace, failing test, recent regression, “fix this bug” with usable evidence | `debug-root-cause` |
| No reliable repro; flaky; performance regression; “keeps coming back”; agent already guessing without a signal | `debug-feedback-loop` |
| Explicit user label (`/debug-root-cause`, `/debug-feedback-loop`, “use the loop path”) | that path |
| Ambiguous | **Prefer `debug-root-cause`** |

### Escalation (not the router’s job)

Mid-run switches are owned **only** by `debug-root-cause`. The router never re-enters to re-classify mid-debug. Canonical escalation triggers live **only** in `paths.md` (one list); `debug-root-cause` links that list and must not invent a second one.

### Handoff contract

Read **sibling** skill files resolved from **this file’s directory**, not from cwd. `../debug-root-cause/SKILL.md` means “next to this skill,” i.e. the `debug-root-cause` folder beside `debug`. After `~/.cursor/skills/<name>` symlink or a plugin copy, `skills/engineering/debug-*/SKILL.md` does not exist.

If a cwd-relative Read of `../debug-root-cause/SKILL.md` misses (user workspace is a different repo), resolve the sibling from the path used to open **this** `SKILL.md`, or invoke the depth skill by name.

Required links in the router `SKILL.md`:

- [../debug-root-cause/SKILL.md](../debug-root-cause/SKILL.md)
- [../debug-feedback-loop/SKILL.md](../debug-feedback-loop/SKILL.md)
- [paths.md](paths.md)

Pass: chosen path, original symptom / user description, constraints they stated, evidence already provided (logs, stack, repro steps), mixed-turn leftover request if any.

Then follow that depth skill. Do not keep a second debugging procedure in the router.

## Path: `debug-root-cause`

**Iron Law:** no fixes without root-cause investigation first.

**Source shape:** Superpowers systematic-debugging, rewritten in this repo’s voice.

### Phases

1. **Investigate** — Read errors and stack traces completely. Reproduce. Check recent changes. For multi-component systems, add boundary instrumentation and gather evidence before guessing. Trace bad values backward to the source; fix at source, not symptom.
2. **Pattern** — Find working analogues in the same codebase. Diff working vs broken. List differences. Note dependencies, config, and assumptions.
3. **Hypothesis** — Form one falsifiable hypothesis. Test with the smallest possible change or probe. If the hypothesis is wrong, return to Phase 1 with the new evidence and form a **new** hypothesis — do not stack untested fixes.
4. **Implement** — Create a failing regression (automated test or tight repro command) → apply **one** root-cause fix → verify original symptom with fresh evidence.
   - Fix works → closeout.
   - Fix fails and attempts **&lt; 3** → return to Phase 1 with the new evidence. Do not stay in Phase 4 stacking another guess.
   - Fix fails and attempts **≥ 3** → stop and question architecture with the user (see Stop rules). Do not attempt fix #4 without that discussion.

### Stop rules

- After **three failed fix attempts**, stop and question architecture with the user (wrong architecture, not one more guess). The Phase 4 → Phase 1 retry loop is what makes this stop reachable.
- Red flags that force return to Phase 1: “quick fix for now,” changing multiple things at once, skipping verification, proposing fixes before tracing data flow.

### Escalation out (this skill owns it)

When any trigger in `paths.md` **Escalation** matches, announce the switch in one line, then read the sibling [../debug-feedback-loop/SKILL.md](../debug-feedback-loop/SKILL.md) (same sibling-resolve rules as the router) and follow it. Do **not** bounce back through `debug` to re-classify. Do not keep both procedures in play.

Canonical triggers (must match `paths.md`; do not shorten this list in the skill body):

- Cannot reproduce consistently
- Two or more hypotheses failed without a tight pass/fail signal
- Flaky or performance issue and still no tight red-capable command

### Closeout

Before claiming fixed: run verification of the original symptom, paste evidence (command + output / exit code). Remove throwaway debug logs if any were added.

## Path: `debug-feedback-loop`

**Iron Law:** no hypothesis until a **tight, red-capable** feedback loop exists for *this* symptom.

**Source shape:** mattpocock diagnosing-bugs, rewritten in this repo’s voice.

### Phases

1. **Build the loop** — Name one agent-runnable command already run at least once that goes red on the user’s exact symptom, is deterministic (or high reproduction rate for flakes), and is fast (seconds). Construction catalog (try in order): failing test → curl/HTTP → CLI + fixture → headless browser → trace replay → throwaway harness → property/fuzz → bisect harness → HITL script. **No Phase 2 without this command.** If a loop cannot be built, list what was tried and ask for environment access, redacted artifacts, or permission for temporary production instrumentation — do not theorize.
2. **Reproduce + minimise** — Confirm the loop shows the user’s failure mode. Shrink inputs/steps until every remaining element is load-bearing.
3. **Hypothesise** — Generate 3–5 ranked falsifiable hypotheses (each with a prediction). Show the ranking; do not block if the user is AFK.
4. **Instrument** — One variable at a time. Prefer debugger/REPL, then targeted logs tagged with a unique prefix (e.g. `[DEBUG-a4f2]`). For performance: measure baseline first; bisect; do not spray logs.
5. **Fix + regression** — Write a failing regression at a **correct seam** before the fix when a seam exists. If no correct seam exists, note that as a finding after the fix (architecture prevents locking the bug down). Re-run the Phase 1 loop against the original (un-minimised) scenario.
6. **Cleanup** — Original loop green; regression passes (or missing seam documented); grep out tagged debug logs; state the winning hypothesis in the commit / PR message.

### Redact

When showing commands, outputs, and artifacts: redact secrets. Prefer env vars over pasting credentials. Quote only lines that carry diagnostic signal from captured artifacts that may contain auth headers.

### Closeout

Same evidence-before-claims rule as root-cause: fresh verification of the original symptom before “fixed.”

## Catalog sync

In the same change that adds the skills:

1. Top-level `README.md` — link each skill
2. `skills/engineering/README.md` — list under Model-invoked (`debug`) and User-invoked (depth skills)
3. `.claude-plugin/plugin.json` — add all three paths to `skills`

## `paths.md` contents

Single source for:

1. **Classification** — the initial-routing table (same rows as Router § Classification).
2. **Escalation** — the three mid-run triggers listed under `debug-root-cause` § Escalation out. No second copy with different wording.

Router `SKILL.md` and `debug-root-cause/SKILL.md` both say **REQUIRED: read `paths.md`** before classifying or escalating.

## Verification plan

Apply writing-skills TDD (pressure scenarios with subagents).

**Fixture:** ship a small checked-in `fixtures/debug-sample/` with a known-broken target (failing test or broken function + test) so “investigates before fix” is observable against real files — same lesson as the orientation family’s RED fixtures. Prompt-only is not enough for that gate. Classification / escalation / mixed-turn scenarios may stay prompt-only.

| Scenario | Without skill (expect fail) | With skill (expect pass) |
|---|---|---|
| Clear failing unit test / stack + “fix it” (against `fixtures/debug-sample/`) | Jumps to plausible patch | Takes `debug-root-cause`; investigates before fix |
| Ambiguous: symptom named, no clear repro *or* loop signal | Guesses a path or asks forever | Prefers `debug-root-cause` |
| “Flaky / can’t repro / keeps coming back” | Speculates root cause from reading code | Takes `debug-feedback-loop`; refuses hypothesis without red-capable loop |
| Root-cause path: two failed hypotheses, still no tight signal | Third random fix | Escalates via sibling read of `debug-feedback-loop` (not back through router) |
| Root-cause path: three failed Phase 4 fixes | Keeps patching | Stops and questions architecture |
| Mixed turn: “fix this, then add feature X” | Starts the feature in the same turn | Finishes debug path, then hands back |

## Success criteria

- Router classifies clear-repro → root-cause and no-repro/flaky/perf → feedback-loop.
- Ambiguous cases prefer root-cause.
- Root-cause skill blocks fixes before Phase 1; failed fixes return to Phase 1; stops at 3 failed fixes and questions architecture.
- Feedback-loop skill blocks hypothesising before a named red-capable command run once.
- Escalation has one owner (`debug-root-cause`), one trigger list (`paths.md`), and one mechanism (sibling read of `debug-feedback-loop`).
- Sibling handoff works under symlink/plugin install (directory-relative, not repo-tree paths).
- Family works without external skill installs.
- Catalog entries and plugin manifest stay in sync.
- Verification covers classification, investigate-before-fix (with fixture), escalation, 3-fix stop, and mixed-turn handback.
