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

## Skills

### Engineering

- **[catch-me-up](./skills/engineering/catch-me-up/SKILL.md)** — Router for codebase orientation. Use when onboarding, catching up on a repo, or asking what a file, class, or function does.
- **[orient-repo](./skills/engineering/orient-repo/SKILL.md)** — Whole-repo map: structure, entry points, architecture, selected Catch Me Up modes.
- **[orient-module](./skills/engineering/orient-module/SKILL.md)** — File, module, or class: purpose, public surface, important methods.
- **[orient-function](./skills/engineering/orient-function/SKILL.md)** — One function or method: step-by-step I/O, side effects, edge cases.
- **[size-work](./skills/engineering/size-work/SKILL.md)** — Router for work sizing. Use when classifying or breaking down initiatives, epics, features, stories, or tasks.
- **[shape-initiative](./skills/engineering/shape-initiative/SKILL.md)** — Initiative charter and epic inventory (one level down).
- **[shape-epic](./skills/engineering/shape-epic/SKILL.md)** — Epic brief and feature inventory.
- **[shape-feature](./skills/engineering/shape-feature/SKILL.md)** — Feature brief and user-story inventory.
- **[shape-story](./skills/engineering/shape-story/SKILL.md)** — Spec-ready user-story brief for a later specify step.
- **[shape-task](./skills/engineering/shape-task/SKILL.md)** — Atomic engineering-task brief without a fake user story.

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
2. List it in this README, linked to its `SKILL.md`.
3. List it in the matching bucket `README.md`.
4. Add its path to `.claude-plugin/plugin.json`.

See [CLAUDE.md](CLAUDE.md) for the full conventions.
