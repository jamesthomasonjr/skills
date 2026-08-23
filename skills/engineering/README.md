# Engineering

Daily code-work skills. Promoted: listed in the root README and shipped in the Claude Code plugin.

## Skills

### User-invoked

- **[orient-repo](./orient-repo/SKILL.md)** — Whole-repo map: structure, entry points, architecture, selected Catch Me Up modes.
- **[orient-module](./orient-module/SKILL.md)** — File, module, or class: purpose, public surface, important methods.
- **[orient-function](./orient-function/SKILL.md)** — One function or method: step-by-step I/O, side effects, edge cases.
- **[debug-root-cause](./debug-root-cause/SKILL.md)** — Root-cause-first debugging (clear repro / stack / failing test).
- **[debug-feedback-loop](./debug-feedback-loop/SKILL.md)** — Feedback-loop-first debugging (flaky / no repro / perf / recurring).
- **[review-defects](./review-defects/SKILL.md)** — Defect-first read-only review of a specified comparison. May return `No findings.`
- **[prioritize-work](./prioritize-work/SKILL.md)** — Rank or select the next piece of work from a resolved set. Picks one item. Does not write the handoff.
- **[handoff-work](./handoff-work/SKILL.md)** — Package context and a copy-pasteable prompt for the next agent for a specified item. Does not re-rank.

### Model-invoked

- **[catch-me-up](./catch-me-up/SKILL.md)** — Router for codebase orientation. Use when onboarding, catching up on a repo, or asking what a file, class, or function does.
- **[debug](./debug/SKILL.md)** — Router for debugging and bug fixing.
- **[review-changes](./review-changes/SKILL.md)** — Router for defect-first code review. Use when reviewing a change, PR, commit, or working tree. Classifies the comparison; does not review.
- **[next-work](./next-work/SKILL.md)** — Router for choosing the next piece of work. Use when asking what’s next or for a handoff prompt. Classifies the path; does not rank and does not write the handoff.
