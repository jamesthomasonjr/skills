---
name: debug-root-cause
description: >-
  Use when debugging with a clear repro, stack trace, failing test, or recent
  regression, or when the debug router hands off the root-cause path.
disable-model-invocation: true
---

# Debug root cause

**Iron Law:** no fixes without root-cause investigation first.

**REQUIRED before escalating (and on direct invoke):** Read [../debug/paths.md](../debug/paths.md) with sibling-resolve (`../debug/paths.md` is next to this skill’s folder). After `~/.cursor/skills/debug-root-cause` symlink, a bare `paths.md` read misses. **Link-only** — do not paste the escalation list into this file.

Also: [../debug-feedback-loop/SKILL.md](../debug-feedback-loop/SKILL.md)

## Hard rules

- No symptom-only patches.
- One change at a time. Do not stack untested fixes.
- Fresh verification evidence before claiming fixed.
- Mixed-turn leftover (feature work after the fix): finish this path, then **hand back**.

## Phase 1 — Investigate

Before any fix:

1. Read errors and stack traces completely.
2. Reproduce. Prefer a re-runnable command when easy; do **not** block leaving Phase 1 solely because the repro is still manual.
3. Check recent changes (git log/diff, deps, config, environment).
4. Multi-component systems: instrument boundaries and gather evidence before guessing.
5. Trace bad values backward to the source; fix at source, not symptom.

## Phase 2 — Pattern

1. Find working analogues in the same codebase.
2. Diff working vs broken; list every difference.
3. Note dependencies, config, and assumptions.

## Phase 3 — Hypothesis

1. Form **one** falsifiable hypothesis; test with the smallest probe.
2. If wrong: **check [../debug/paths.md](../debug/paths.md) Escalation first**. If any trigger matches → escalate (see Escalation out). Otherwise return to Phase 1 with new evidence and form a **new** hypothesis — do not stack fixes.

## Phase 4 — Implement

Enter after a confirmed hypothesis. Steps in order:

1. **Create or reuse a failing regression** (automated test preferred; else a named agent-runnable command that goes red on this symptom).
2. If you **cannot** create that signal → escalate via [../debug/paths.md](../debug/paths.md). Do not patch without it.
3. Apply **one** root-cause fix.
4. Verify the original symptom with fresh evidence against that regression/command.
   - Works → Closeout.
   - Fails and attempts **under 3** → return to Phase 1 with new evidence.
   - Fails and attempts **3 or more** (count only after step 1’s tight signal exists) → stop and question architecture with the user. Do not attempt fix #4 without that discussion.

## Stop rules

- Three failed fixes against an existing tight signal → architecture discussion, not another guess.
- Without a creatable tight signal → escalate, do not invent an architecture stop.
- Red flags → return to Phase 1 (or escalate if paths.md matches): “quick fix for now,” multi-change thrash, skip verification, fix before tracing.

## Escalation out

When any trigger in [../debug/paths.md](../debug/paths.md) **Escalation** matches: announce in one line, read [../debug-feedback-loop/SKILL.md](../debug-feedback-loop/SKILL.md), follow it. Do not bounce through `debug`. Do not keep both procedures in play. Do not restate trigger bullets here.

## Closeout

Run verification of the original symptom; paste command + output / exit code. Remove throwaway debug logs. Then hand back any mixed-turn leftover.
