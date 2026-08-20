# Debug paths

Shared vocabulary for `debug` and `debug-root-cause`. If wording here conflicts with a `SKILL.md` summary, **this file wins**.

## Classification

Explicit user labels win (`/debug-root-cause`, `/debug-feedback-loop`, “use the loop path”).

| Signal | Path |
|---|---|
| Clear repro, stack trace, failing test, recent regression, “fix this bug” with usable evidence | `debug-root-cause` |
| No reliable repro; flaky; performance regression; “keeps coming back”; agent already guessing without a signal | `debug-feedback-loop` |
| Explicit user label for a path | that path |
| Ambiguous | **Prefer `debug-root-cause`** |

## Escalation

Mid-run switches are owned only by `debug-root-cause`. When any trigger matches, announce once, then read sibling `../debug-feedback-loop/SKILL.md` and follow it. Do not bounce back through `debug`.

Triggers:

- Cannot reproduce consistently
- Two or more hypotheses failed without a tight pass/fail signal
- Flaky or performance issue and still no tight red-capable command
- Confirmed hypothesis but cannot create a re-runnable regression/command in Phase 4 (manual-only repro that cannot be automated or scripted for the agent)
