# Installing jamesthomasonjr-skills for OpenCode

The plugin registers every skill in `skills/engineering/` and `skills/productivity/`. `personal/` and `in-progress/` are never registered. Skills are discovered natively; there is no bootstrap prompt.

## OpenCode V2 (2.0.4 or later)

```json
{
  "plugins": ["jamesthomasonjr-skills@git+https://github.com/jamesthomasonjr/skills.git"]
}
```

For a local checkout, use the absolute path of the repo directory (it contains `index.js`). V2 rejects direct file paths, and `~` is not expanded.

## OpenCode V1

```json
{
  "plugin": ["jamesthomasonjr-skills@git+https://github.com/jamesthomasonjr/skills.git"]
}
```

Restart OpenCode, then ask it to list skills with its `skill` tool.

## Pinning

Append a tag or commit: `...skills.git#v0.25.0`.

## Differences from the Claude Code shape

- Claude Code reads `.claude-plugin/plugin.json`, which lists each skill path. OpenCode runs a JS plugin and discovers skills by scanning bucket directories, so new promoted skills need no OpenCode edit.
- V1 uses `config.skills.paths`; V2 registers skills through `ctx.skill.transform()`.
- Tool names differ (V1 `task`/`todowrite`/`bash`, V2 `subagent`/`shell`, no todo tool). Skills here are written action-first and agent-agnostic, so no tool mapping is injected.
