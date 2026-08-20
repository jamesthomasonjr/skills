# Debug skill family RED baseline

Date: 2026-08-20
Skills present: none (`debug` / `debug-root-cause` / `debug-feedback-loop` must not exist)
Note: Cursor ambient skills (e.g. Superpowers `systematic-debugging`) may still have been available to subagents despite the hard ban on *inventing* this family’s names. Treat RED as “without this family’s router/depth skills,” not “zero debugging discipline.”

Four fresh `generalPurpose` subagents. Workspace: skills repo root. Fixture restored to broken after A/D patched it.

## Scenario A — clear failing test

Prompt: `The test fixtures/debug-sample/src/total.test.js is failing. Fix the bug.` (+ hard ban)

Observed:
- Investigated before patching (tax on pre-discount subtotal).
- Ran test before (`98 !== 97.2`) and after (pass).
- Patched and **committed** the fix (`86b4c88`) — later reverted for fixture integrity.
- No handoff through a `debug` router or named `debug-root-cause` path.
Verbatim: "The test expects: (100 - 10) * 1.08 = 97.2. Current calculation: subtotal=100, discount=10, tax=100*0.08=8, result=100-10+8=98. The fix should apply tax after discount."

## Scenario B — ambiguous

Prompt: `Checkout totals look wrong sometimes. Help me debug it.` (+ hard ban)

Observed:
- Disciplined: search → reproduce fixture failure → compare to orient-sample → diagnose.
- Effectively took a root-cause path without classifying via `paths.md` / announcing prefer-root-cause.
- Did not apply the fix (left fixture failing).
Verbatim: "Following Phase 1: locating checkout total code and running tests to reproduce before forming any hypothesis."

## Scenario C — flaky / no repro

Prompt: `Auth is flaky in CI — can't repro locally, keeps coming back after "fixes". Find the root cause.` (+ hard ban)

Observed:
- Correctly found no auth/CI in this repo; refused to invent a root cause.
- Did **not** enter a feedback-loop-first procedure (no loop-construction catalog, no “build a red-capable command” phase for the *described* flake).
- Asked for external CI artifacts instead of hypothesising — good instinct, not this family’s skill shape.
Verbatim: "There's no auth code, no CI config — I should NOT speculate root causes. Phase 1 requires reproduction or external evidence; neither exists here."

## Scenario D — mixed turn

Prompt: `fixtures/debug-sample/src/total.test.js is failing — fix that bug, then add a gift-card feature to cartTotal.` (+ hard ban)

Observed:
- Fixed tax bug only; **did not** start gift-card in the same turn.
- Did commit the fix (same `86b4c88` race with A); gift-card deferred.
Verbatim: "Applying the tax-after-discount fix only — gift-card stays out of this turn."

## Failures this family must close

Fired (or partially):

- **No family router.** A/B/D never classified via `debug` → `debug-root-cause` / `debug-feedback-loop` with an announce line.
- **No paths.md prefer-root-cause contract** for ambiguous asks (B behaved well but without the skill’s explicit prefer rule).
- **Flaky/no-repro does not enter feedback-loop skill** (C refused speculation but never ran Phase 1 loop-construction for the user’s flake description).
- **Ambient Superpowers may mask blind-patch RED** — A/B already investigated; GREEN must still prove *this* family’s handoff and gates under explicit skill instructions.

Did not fire strongly (still require GREEN coverage):

- Blind patch without any investigation (A investigated).
- Mixed-turn feature creep (D handed gift-card back) — still verify under skill instruction.

## Fixture note

After A/D, `total.js` was fixed and committed; reverted in `c2cbaa2` so `node --test fixtures/debug-sample/src/total.test.js` fails again for GREEN.

## GREEN

Skills present: `debug`, `debug-root-cause`, `debug-feedback-loop`, `paths.md`. Fresh subagents instructed to read `debug` (or `debug-root-cause` for E) first. Fixture kept broken after A/D via revert `d14aa96`.

### A — clear failing test

- Path: `debug-root-cause`
- Investigated before edit; reused failing `total.test.js`; fix made test PASS; root cause = tax on pre-discount subtotal
- **Pass**

### B — ambiguous

- Preferred `debug-root-cause`; no path menu; one-line announce
- **Pass** (note: fixture briefly green from concurrent A/D — classification still correct)

### C — flaky / no repro

- Handed off to `debug-feedback-loop`; stayed in Phase 1; asked for CI artifacts; refused hypotheses
- **Pass**

### D — mixed turn

- Stayed on debug path; no gift-card; handed back for feature work
- **Pass**

### E — Phase 3 escalate (direct invoke)

- Read `../debug/paths.md`; matched two-failed-hypotheses trigger; announced + read `debug-feedback-loop`
- **Pass**

All GREEN scenarios passed. Fixture restored to known-broken for future baselining.
