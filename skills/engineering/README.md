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

### Model-invoked

- **[catch-me-up](./catch-me-up/SKILL.md)** — Router for codebase orientation. Use when onboarding, catching up on a repo, or asking what a file, class, or function does.
- **[debug](./debug/SKILL.md)** — Router for debugging and bug fixing.
- **[review-changes](./review-changes/SKILL.md)** — Router for defect-first code review. Use when reviewing a change, PR, commit, or working tree. Uses `review-scope` (Follow-in-parent), then fans gatherers as fresh children, then blind+security+performance+logic+regression+checklist in parallel, then intent with the reconstruct blob, then the verifier; does not review.
- **[next-work](./next-work/SKILL.md)** — Router for choosing the next piece of work. Use when asking what’s next or for a handoff prompt. Classifies the path; does not rank and does not write the handoff.

Live path: `review-changes` Follows [review-scope](./review-scope/SKILL.md) in the parent, announces the comparison, then fans [review-gather-pr](./review-gather-pr/SKILL.md) / [review-gather-design](./review-gather-design/SKILL.md) / [review-gather-onboard](./review-gather-onboard/SKILL.md) as fresh children and seeds from their products. Then fans [review-blind](./review-blind/SKILL.md) + [review-security](./review-security/SKILL.md) + [review-performance](./review-performance/SKILL.md) + [review-logic](./review-logic/SKILL.md) + [review-regression](./review-regression/SKILL.md) + [review-checklist](./review-checklist/SKILL.md) in parallel, then [review-intent](./review-intent/SKILL.md) with the reconstruct blob, then [review-verify](./review-verify/SKILL.md) applies its sibling `gates.md` on every announced seat list. Scope stays Follow-in-parent. Seats stay isolated. A wrapper may still prime the parent with catch-me-up / orient-*; that is not a required router step. Specialist playbooks are only in their own windows. The reconstruct blob is only in the intent window (and may sit parent-held in the verify Follow). Inspired by [AntJanus/skillbox](https://github.com/AntJanus/skillbox) (verifier impact floor; isolation is a fresh context, not instruction-withhold) and [yeameen/claude-code-review-council](https://github.com/yeameen/claude-code-review-council) (blind-context compose).
