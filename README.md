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

_None yet._

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
