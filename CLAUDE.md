# Working on this repo

This repository is a personal collection of agent skills. Skills are the product. Keep the repo itself small: markdown, optional scripts inside a skill, the plugin manifest, and `fixtures/` samples used to baseline and verify skills.

## Buckets

Skills live under `skills/`:

- `engineering/` — daily code work
- `productivity/` — daily non-code workflow tools
- `personal/` — tied to my own setup, not promoted
- `in-progress/` — drafts not yet ready to ship

`engineering/` and `productivity/` are the **promoted** buckets.

## Promotion rules

Every skill in a promoted bucket must have:

1. A `SKILL.md` with YAML frontmatter (`name`, `description`)
2. An entry in the top-level `README.md` that links the skill name to its `SKILL.md`
3. An entry in that bucket's `README.md`
4. A path in `.claude-plugin/plugin.json`'s `skills` array

Skills in `personal/` and `in-progress/` must not appear in the top-level README or the plugin manifest.

## Skill shape

```
skill-name/
├── SKILL.md
├── reference.md      # only if SKILL.md would otherwise grow too large
├── examples.md
└── scripts/
```

- `name`: lowercase letters, numbers, and hyphens; max 64 characters
- `description`: third person; include what the skill does and when to use it
- Keep `SKILL.md` under 500 lines; link one level deep to supporting files
- Default new skills to user-invoked (`disable-model-invocation: true`) unless the agent should pick them up from ambient context
- Write project-agnostic and agent-agnostic instructions unless the skill is in `personal/`

## Catalog sync

When you add, rename, remove, or change how a promoted skill is used, update the top-level README, the bucket README, and `.claude-plugin/plugin.json` in the same change.
