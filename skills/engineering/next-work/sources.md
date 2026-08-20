# Work sources

Shared playbook for `next-work`, `prioritize-work`, and `handoff-work`.
The router and `prioritize-work` are **REQUIRED** to follow this file.
`handoff-work` follows it only when no item was specified (then it asks
once — it does not rank). The router does not restate ranking or the
handoff recipe.

## Legal sources (only these)

1. **User-named list** — items they typed. Verbatim. Do not add extras.
2. **Open issues / PRs** — only if resolvable here (`gh` or an equivalent
   they already have). Failure or missing tool → **drop** this source.
3. **Current branch / uncommitted work** — cheap git.
   **Unscoped** (the repo is the project): `git status --short`, current
   branch vs default. Dirty tree or a feature branch with a real delta is
   a candidate (“finish what’s in flight”). Clean default branch → drop.
   **Scoped subdirectory — one rule:** keep uncommitted paths and
   branch-delta files **inside that scope**. Drop parent dirty / parent
   feature-branch files **outside** the scope. “Parent feature-branch
   delta” is **not** an automatic drop of source 3. Drop source 3 only
   when the in-scope uncommitted list and the in-scope branch-delta list
   are both empty.
4. **In-repo plans / specs under `docs/`** — plan or spec files, including
   `docs/superpowers/plans` and `docs/superpowers/specs` when those exist.
   Missing `docs/` → drop.
5. **A board / ticket / path the user named** — read that path if it exists.
   Missing → drop.

Do not use: “I noticed we should add tests,” linter noise, imagined
refactors, other skills in this catalog as work items, or a tour of `src/`
for chores.

## Resolve / drop

- If you cannot resolve a source, drop it. Do not ask per source when other
  sources already yielded items.
- User-named list **wins as the set** when present: do not union in extras
  from git/docs/issues unless they also asked to include those.
- Pointers you pass on must exist (path readable, or issue/PR identifier
  that resolved). If you did not open it, do not cite it.

## Cheap-resolve (one pass)

Allowed:

- Treat a user-named list as the set.
- Read one named board/ticket/path.
- One `git status --short` plus current branch name (and, when useful,
  whether HEAD equals the default branch). **Scoped:**
  `git status --short -- <scope>` and
  `git diff --name-only <base>...<tip> -- <scope>`. `<tip>` is HEAD (or
  the named feature/PR branch). `<base>` is `origin/HEAD`, else
  `origin/main`, else `main`, else `master`. Never the branch’s own
  `@{upstream}` when that upstream is the same branch (self-diff empties
  the list → fake `Nothing next.`). Paths outside the scope do not
  count. Drop source 3 only when both in-scope lists are empty.
- One optional `gh issue list` / `gh pr list` (or equivalent) when they
  asked for issues/PRs or named no list and no board — skip entirely if
  the tool is missing. **Scoped:** skip parent issues/PRs.
- One glob of `docs/**/*.md` (or a named docs subfolder) for plan/spec titles.
  **Scoped:** only `docs/` **inside that scope**.

Not allowed: reading every source file to start the work, ranking in the
resolver, implementing, inventing titles for files you did not see.

When the user scoped a subdirectory as the project, resolve sources
**inside that scope only**. Do not pull the parent repo’s `docs/`,
issues/PRs, or **out-of-scope** git (parent dirty paths and parent
feature-branch files **outside** the scope). In-scope uncommitted and
in-scope branch-delta files still count. After those drops, empty set
→ exactly `Nothing next.`

## Empty set

Zero candidates after drops:

- Scoped project, no named list, every optional source missing or failed:
  write exactly `Nothing next.` and stop.
- They named a source that does not resolve, and nothing else remains:
  ask once, then stop. If they cannot or will not name another:
  `Nothing next.`

Ask-once copy (entire output; no envelope):

> Name a list, a board/ticket path, or a plan. I won’t invent a backlog.

If they said “just pick” and the set is empty, still `Nothing next.`

`Nothing next.` is a **successful empty pass**, not a failure to be helpful.
Inventing a “next” to look useful is a defect.

“Be useful,” “propose a backlog,” “I need something to do,” and “that is
not a reason to stop” do **not** authorize invented items. The entire
output is exactly `Nothing next.`

## Empty pass vs stop

A **successful empty pass** means the set was resolved and it was empty.
Write exactly `Nothing next.` Do not invent an item. Do not add a preface.

**Stop paths** are the entire output. Do not wrap `Nothing next.` or an
out-of-family pointer in Next / Why / Leftover / Goal / Constraints /
Done when / Pointers / Prompt.
