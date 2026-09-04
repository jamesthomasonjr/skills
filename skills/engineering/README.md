# Engineering

Daily code-work skills. Promoted: listed in the root README and shipped in the Claude Code plugin.

## Skills

### User-invoked

- **[orient-repo](./orient-repo/SKILL.md)** — Whole-repo map: structure, entry points, architecture, selected Catch Me Up modes.
- **[orient-module](./orient-module/SKILL.md)** — File, module, or class: purpose, public surface, important methods.
- **[orient-function](./orient-function/SKILL.md)** — One function or method: step-by-step I/O, side effects, edge cases.
- **[debug-root-cause](./debug-root-cause/SKILL.md)** — Root-cause-first debugging (clear repro / stack / failing test).
- **[debug-feedback-loop](./debug-feedback-loop/SKILL.md)** — Feedback-loop-first debugging (flaky / no repro / perf / recurring).
- **[prioritize-work](./prioritize-work/SKILL.md)** — Rank or select the next piece of work from a resolved set. Picks one item. Does not write the handoff.
- **[handoff-work](./handoff-work/SKILL.md)** — Package context and a copy-pasteable prompt for the next agent for a specified item. Does not re-rank.
- **[review-audit](./review-audit/SKILL.md)** — Existing-codebase audit of a named path, module, or the codebase. Leftovers and pre-existing defects are numbered findings. Not a change review.

### Model-invoked

- **[catch-me-up](./catch-me-up/SKILL.md)** — Router for codebase orientation. Use when onboarding, catching up on a repo, or asking what a file, class, or function does.
- **[debug](./debug/SKILL.md)** — Router for debugging and bug fixing.
- **[review-changes](./review-changes/SKILL.md)** — Router for defect-first code review. Use when reviewing a change, PR, commit, or working tree. Uses `review-scope` (Follow-in-parent), then fans gatherers as fresh children, then a caller-named pack (`full` default / `core` opt-in) through `review-spawn-seats` on a nested-Task or CloudAgent host, then the verifier on every announced seat list; does not review.
- **[next-work](./next-work/SKILL.md)** — Router for choosing the next piece of work. Use when asking what’s next or for a handoff prompt. Classifies the path; does not rank and does not write the handoff.

Live path: `review-changes` Follows [review-scope](./review-scope/SKILL.md) in the parent, announces the comparison, chooses the pack once (`full` default / `core` opt-in), then fans [review-gather-pr](./review-gather-pr/SKILL.md) / [review-gather-design](./review-gather-design/SKILL.md) / [review-gather-onboard](./review-gather-onboard/SKILL.md) as fresh children and seeds from their products (skip only a held PR body / design excerpt; onboard always fans). Pack `full` (default) fans [review-blind](./review-blind/SKILL.md) + [review-security](./review-security/SKILL.md) + [review-performance](./review-performance/SKILL.md) + [review-logic](./review-logic/SKILL.md) + [review-regression](./review-regression/SKILL.md) + [review-checklist](./review-checklist/SKILL.md) in parallel, then [review-intent](./review-intent/SKILL.md) with the reconstruct blob. Pack `core` (caller opt-in) announces blind + intent + security only. Then [review-verify](./review-verify/SKILL.md) applies its sibling `gates.md` on every announced seat list and writes Findings, Assessment, Follow-ups (omit if empty). No Close. Gatherers and announced seats start through [review-spawn-seats](./review-spawn-seats/SKILL.md), which picks a nested Task child or a CloudAgent per slot from harness facts (never from “Grok” / “quick” / “Medium”) and returns the whole announced set or one named HARNESS-STOP. `cloud-seat` is an invocation mode of the same router, not a sibling skill — same packs, same seeds (`comparison-seed` for every parallel seat, `intent-seed` for intent after the blob), same gates. If a gatherer or announced seat cannot start (no Task tool and no CloudAgent launch, a launch rejected, or a partial helper return), HARNESS-STOP: say so and stop. Never a thinner merge, never a re-announced `core`. That is a stop path, not an empty review. Scope stays Follow-in-parent. Verify Follows in the parent on either host. Seats stay isolated. A wrapper may still prime the parent with catch-me-up / orient-*; that is not a required router step. Specialist playbooks are only in their own windows. The reconstruct blob is only in the intent window (and may sit parent-held in the verify Follow). Inspired by [AntJanus/skillbox](https://github.com/AntJanus/skillbox) (verifier impact floor; isolation is a fresh context, not instruction-withhold) and [yeameen/claude-code-review-council](https://github.com/yeameen/claude-code-review-council) (blind-context compose).

Score review dump letters locally (no live review agents): `./scripts/score-review-dump-letters.sh`. Cases cite headings in [`fixtures/review-sample/README.md`](../../fixtures/review-sample/README.md). Meta-test: `./scripts/test-score-review-dump-letters.sh`.

Audit path: `review-audit` takes a named path, module, or “the codebase.” It tours that scope and writes Findings. Pre-existing debt is a numbered finding, not a Follow-ups leftover. It does not Follow `review-scope`, does not fan change-review seats, and does not apply `gates.md`. Parent-held orient/onboard products may seed the tour; those skills are not required seats. Score audit dump letters locally (no live audit agents): `./scripts/score-review-audit-dump-letters.sh`. Cases cite headings in [`fixtures/review-audit/README.md`](../../fixtures/review-audit/README.md). Meta-test: `./scripts/test-score-review-audit-dump-letters.sh`. Do not widen the review-sample GREEN table.
