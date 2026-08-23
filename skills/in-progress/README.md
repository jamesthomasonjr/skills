# In progress

Drafts that are not ready to ship. Not promoted — do not list these in the root README or `.claude-plugin/plugin.json`.

## Skills

Size-work family (draft; not installed by the plugin — work with specify-work as one workflow):

- **[size-work](./size-work/SKILL.md)** — Router. Classifies grain (initiative → epic → feature → story → task) and hands off. Playbooks: [levels.md](./size-work/levels.md), [paths.md](./size-work/paths.md).
- **[shape-initiative](./shape-initiative/SKILL.md)** — Initiative charter and epic inventory.
- **[shape-epic](./shape-epic/SKILL.md)** — Epic brief, feature inventory, and Path (critical path + parallel sets).
- **[shape-feature](./shape-feature/SKILL.md)** — Feature brief, user-story inventory, and Path (critical path + parallel sets).
- **[shape-story](./shape-story/SKILL.md)** — Spec-ready user-story brief.
- **[shape-task](./shape-task/SKILL.md)** — Atomic task brief (chores, tech debt, known bugs, spikes).

Specify-work family (draft; replacement/bake-off with Superpowers-shaped specify+plan, not a fork):

- **[specify-work](./specify-work/SKILL.md)** — Router. Classifies which document they need (spec, design, or plan) and hands off. Playbook: [kinds.md](./specify-work/kinds.md) (requirement vs standard).
- **[write-spec](./write-spec/SKILL.md)** — One sharp outcome; MVP In; later-features Out; spikes; standards as labels. Stops. Points at `size-work`. Does not invoke it.
- **[write-design](./write-design/SKILL.md)** — Derives steps and SOLID cuts from sized work. Later-feature seams as design notes, not inventory. Does not resize.
- **[write-plan](./write-plan/SKILL.md)** — Stacked-PR units after grain. Spike first and separate. Does not implement.
