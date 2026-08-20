---
name: debug-feedback-loop
description: >-
  Use when debugging flaky, unreproducible, recurring, or performance issues,
  or when no tight pass/fail signal exists yet, or when the debug router or
  debug-root-cause hands off the feedback-loop path.
disable-model-invocation: true
---

# Debug feedback loop

**Iron Law:** no hypothesis until a **tight, red-capable** feedback loop exists for *this* symptom.

## Hard rules

- Do not theorise before Phase 1’s command exists and has been run once (redacted output shown).
- One variable at a time when instrumenting.
- Fresh verification before claiming fixed.
- Mixed-turn leftover: finish this path, then **hand back**.

## Redact

Redact secrets in commands, outputs, and artifacts (`<REDACTED>`). Prefer env vars over pasting credentials. Quote only diagnostic lines from captured artifacts that may contain auth headers.

## Phase 1 — Build the loop

Spend disproportionate effort here.

Try in order until you have one agent-runnable command:

1. Failing test at a seam that reaches the bug
2. Curl / HTTP script against a running server
3. CLI + fixture, diff stdout
4. Headless browser (Playwright / Puppeteer)
5. Replay a captured trace/payload
6. Throwaway harness with mocked deps
7. Property / fuzz loop
8. Bisect harness (`git bisect run`)
9. HITL script only as last resort

**Done when** you can name **one command** already run once that is:

- **Red-capable** — asserts the user’s exact symptom
- **Deterministic** (or high reproduction rate for flakes)
- **Fast** — seconds, not minutes
- **Agent-runnable**

No Phase 2 without that command. If you cannot build a loop: list tries; ask for env access, redacted artifacts, or temporary prod instrumentation — **do not hypothesise**.

## Phase 2 — Reproduce + minimise

Confirm the loop shows the user’s failure mode. Shrink until every remaining element is load-bearing.

## Phase 3 — Hypothesise

Generate **3–5** ranked falsifiable hypotheses (each with a prediction). Show the ranking; do not block if the user is AFK.

## Phase 4 — Instrument

One variable at a time. Prefer debugger/REPL, then targeted logs tagged `[DEBUG-…]`. For performance: measure baseline first; bisect; do not spray logs.

## Phase 5 — Fix + regression

Write a failing regression at a **correct seam** before the fix when a seam exists. If no correct seam, note that after the fix. Apply the fix. Re-run the Phase 1 loop against the original (un-minimised) scenario.

## Phase 6 — Cleanup

- Original loop green
- Regression passes (or missing seam documented)
- Grep out `[DEBUG-…]` instrumentation
- State the winning hypothesis in the commit / PR message

## Closeout

Fresh verification of the original symptom before “fixed.” Then hand back any mixed-turn leftover.
