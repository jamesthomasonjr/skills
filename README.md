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

### Cursor Cloud Agents

Cloud Agents run on isolated VMs and do not inherit laptop `~/.cursor/skills`, Cursor plugin installs, or GitHub Remote Rules. They do load skills from `~/.cursor/skills/` on the VM.

This repo's [`.cursor/environment.json`](.cursor/environment.json) runs [`scripts/install-cloud-agent-skills.sh`](scripts/install-cloud-agent-skills.sh) in two places:

- `install` — during a Build, on the default-branch checkout. Clones [jeighty/supersuit](https://github.com/jeighty/supersuit) (and this repo if it is not already the workspace), then links skills.
- `start` — on each agent boot, after the requested branch is checked out. Runs `--link-only` so a feature branch that adds a promoted skill is linked without re-cloning supersuit.

The script is idempotent, works with bash 3.2, and does not install `personal/` or `in-progress/`.

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
- **[shape-initiative](./skills/engineering/shape-initiative/SKILL.md)** — Initiative charter and epic inventory (one level down).
- **[shape-epic](./skills/engineering/shape-epic/SKILL.md)** — Epic brief and feature inventory.
- **[shape-feature](./skills/engineering/shape-feature/SKILL.md)** — Feature brief and user-story inventory.
- **[shape-story](./skills/engineering/shape-story/SKILL.md)** — Spec-ready user-story brief for a later specify step.
- **[shape-task](./skills/engineering/shape-task/SKILL.md)** — Atomic task / chore / known-bug / spike brief (no fake user story).
- **[debug-root-cause](./skills/engineering/debug-root-cause/SKILL.md)** — Root-cause-first debugging for clear repros, stacks, and failing tests.
- **[debug-feedback-loop](./skills/engineering/debug-feedback-loop/SKILL.md)** — Feedback-loop-first debugging for flaky, unreproducible, recurring, or performance issues.
- **[review-defects](./skills/engineering/review-defects/SKILL.md)** — Defect-first read-only review of a specified comparison. May return `No findings.`

**Model-invoked**

- **[catch-me-up](./skills/engineering/catch-me-up/SKILL.md)** — Router for codebase orientation. Use when onboarding, catching up on a repo, or asking what a file, class, or function does.
- **[size-work](./skills/engineering/size-work/SKILL.md)** — Router for work sizing (initiative → epic → feature → story → task), including chores, bugs, and spikes.
- **[debug](./skills/engineering/debug/SKILL.md)** — Router for debugging. Use when fixing, debugging, or finding root cause.
- **[review-changes](./skills/engineering/review-changes/SKILL.md)** — Router for defect-first code review. Use when reviewing a change, PR, commit, or working tree. Classifies the comparison; does not review.

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
