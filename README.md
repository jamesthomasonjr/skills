# skills

Personal agent skills for [Cursor](https://cursor.com), [Claude Code](https://docs.anthropic.com/en/docs/claude-code), and other coding agents.

Inspired by [mattpocock/skills](https://github.com/mattpocock/skills) and [garrytan/gstack](https://github.com/garrytan/gstack).

## Install

Clone this repo (or use this working copy), then symlink each promoted skill into the agent directories you use:

```bash
# Cursor
mkdir -p ~/.cursor/skills
ln -sfn "$PWD/skills/engineering/<skill-name>" ~/.cursor/skills/<skill-name>

# Claude Code
mkdir -p ~/.claude/skills
ln -sfn "$PWD/skills/engineering/<skill-name>" ~/.claude/skills/<skill-name>
```

Claude Code can also load this repo as a plugin via [`.claude-plugin/plugin.json`](.claude-plugin/plugin.json).

Promoted skills live in `skills/engineering/` and `skills/productivity/`. Skills in `personal/` and `in-progress/` stay local to this repo.

### Cursor and Codex/ChatGPT Cloud Agents

Cloud Agents run on isolated VMs and do not inherit laptop skill installs, Cursor plugin installs, or GitHub Remote Rules. Cursor loads skills from `~/.cursor/skills/` on the VM; Codex/ChatGPT cloud uses `$CODEX_HOME/skills/`, which defaults to `~/.codex/skills/`.

This repo's [`.cursor/environment.json`](.cursor/environment.json) runs [`scripts/install-cloud-agent-skills.sh`](scripts/install-cloud-agent-skills.sh) in two places:

- `install` — during a Build, on the default-branch checkout. Clones [jeighty/supersuit](https://github.com/jeighty/supersuit) (and this repo if it is not already the workspace), then links skills into both Cursor and Codex skill homes.
- `start` — on each agent boot, after the requested branch is checked out. Runs `--link-only` so a feature branch that adds a promoted skill is linked without re-cloning supersuit.

The script is idempotent, works with bash 3.2, and does not install `personal/` or `in-progress/`. By default it uses `~/.cache/cloud-agent-skill-src` for cloned sources and links into `~/.cursor/skills` plus `${CODEX_HOME:-~/.codex}/skills`. Override `SKILL_TARGET_DIRS` with a colon-separated list to choose different targets.

```bash
./scripts/install-cloud-agent-skills.sh
./scripts/install-cloud-agent-skills.sh --link-only
```

## Skills

These split on one axis: who can invoke them. **User-invoked** skills are reached when you type them. **Model-invoked** skills can also be picked up from ambient context. A router (model-invoked) hands off to a leaf (user-invoked).

### Engineering

**User-invoked**

- **[orient-repo](./skills/engineering/orient-repo/SKILL.md)** — Whole-repo map: structure, entry points, architecture, selected Catch Me Up modes.
- **[orient-module](./skills/engineering/orient-module/SKILL.md)** — File, module, or class: purpose, public surface, important methods.
- **[orient-function](./skills/engineering/orient-function/SKILL.md)** — One function or method: step-by-step I/O, side effects, edge cases.
- **[debug-root-cause](./skills/engineering/debug-root-cause/SKILL.md)** — Root-cause-first debugging for clear repros, stacks, and failing tests.
- **[debug-feedback-loop](./skills/engineering/debug-feedback-loop/SKILL.md)** — Feedback-loop-first debugging for flaky, unreproducible, recurring, or performance issues.
- **[prioritize-work](./skills/engineering/prioritize-work/SKILL.md)** — Rank or select the next piece of work from a resolved set. Picks one item. Does not write the handoff.
- **[handoff-work](./skills/engineering/handoff-work/SKILL.md)** — Package context and a copy-pasteable prompt for the next agent for a specified item. Does not re-rank.

**Model-invoked**

- **[catch-me-up](./skills/engineering/catch-me-up/SKILL.md)** — Router for codebase orientation. Use when onboarding, catching up on a repo, or asking what a file, class, or function does.
- **[debug](./skills/engineering/debug/SKILL.md)** — Router for debugging. Use when fixing, debugging, or finding root cause.
- **[review-changes](./skills/engineering/review-changes/SKILL.md)** — Router for defect-first code review. Use when reviewing a change, PR, commit, or working tree. Uses `review-scope` (Follow-in-parent), then fans gatherers as fresh children, then seats then the verifier; does not review.
- **[next-work](./skills/engineering/next-work/SKILL.md)** — Router for choosing the next piece of work. Use when asking what’s next or for a handoff prompt. Classifies the path; does not rank and does not write the handoff.

Live path: `review-changes` Follows [review-scope](./skills/engineering/review-scope/SKILL.md) in the parent, announces the comparison, then fans [review-gather-pr](./skills/engineering/review-gather-pr/SKILL.md) / [review-gather-design](./skills/engineering/review-gather-design/SKILL.md) / [review-gather-onboard](./skills/engineering/review-gather-onboard/SKILL.md) as fresh children and seeds from their products. Then fans [review-intent](./skills/engineering/review-intent/SKILL.md) + [review-blind](./skills/engineering/review-blind/SKILL.md) + [review-security](./skills/engineering/review-security/SKILL.md) in fresh contexts, then [review-verify](./skills/engineering/review-verify/SKILL.md) applies `gates.md` on the three candidate lists. Scope stays Follow-in-parent. Seats stay isolated. A wrapper may still prime the parent with catch-me-up / orient-*; that is not a required router step. The security playbook is only in the security window.

The size-work family (`size-work`, `shape-initiative`, `shape-epic`, `shape-feature`, `shape-story`, `shape-task`) is in [`skills/in-progress/`](./skills/in-progress/) so it can be worked with specify-work as one workflow. It is not installed by the plugin.

### Productivity

_None yet._

## Layout

```
skills/
  engineering/     # daily code work (promoted)
  productivity/    # daily non-code workflows (promoted)
  personal/        # tied to my setup, not promoted
  in-progress/     # drafts
```

Each skill is a directory with a `SKILL.md`:

```
skill-name/
├── SKILL.md         # required
├── reference.md     # optional
├── examples.md      # optional
└── scripts/         # optional
```

## Authoring

When adding a promoted skill:

1. Create `skills/<bucket>/<skill-name>/SKILL.md` with `name` and `description` frontmatter.
2. List it in this README under the matching User-invoked or Model-invoked subsection, linked to its `SKILL.md`.
3. List it in the matching bucket `README.md`.
4. Add its path to `.claude-plugin/plugin.json`.

See [CLAUDE.md](CLAUDE.md) for the full conventions.
