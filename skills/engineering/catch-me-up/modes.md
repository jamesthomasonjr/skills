# Catch Me Up modes

Depth skills apply these lenses. Do not rewrite them. Apply only the modes the router selected or inferred. If a mode has no signal, write one line and skip.

## Architecture

**When:** “how is this structured”, repo onboard, first look at a module.

**Sample:** top-level + depth-two; 3–5 key files; entry points and core data types. Skip `node_modules`, vendor, build, `.git`.

**Report:** boundaries, layers, entry points, data-model hierarchy, pattern (layered, modular, MVC, or “flat scripts”), where state lives. Use a table or one small mermaid. Not a file dump.

## Convention

**When:** “what’s the standard”, before writing new code, a module that looks unlike its neighbors.

**Sample:** 3–5 peers of the same kind; linters/formatters/CI; `AGENTS.md` / `CLAUDE.md` / contributing docs if present.

**Report:** naming, folder rules, error-handling style, test layout, do-this / don’t-do-this. Call out violations as observations, not moral failures.

## Feature Trace

**When:** “how does X work”, “walk me through”, a named user journey.

**Sample:** one path, request-in to effect-out. Follow calls. Do not tour siblings.

**Report:** numbered steps with `path:line` at each hop, data in/out at boundaries, where it is stored or returned. One mermaid sequence if the path crosses 3+ files.

## Syntax / API

**When:** unfamiliar idiom, dense function, “what does this API mean”, function-level asks.

**Sample:** the symbol and its public contract; 1–2 call sites; official docs only if the code is not enough.

**Report:** plain-language meaning, inputs, outputs, side effects, edge cases. For a function, this is the `orient-function` walkthrough.

## Testing

**When:** “how is this tested”, function/module briefing, Feature Trace that needs a reality check.

**Sample:** tests that name the unit or the journey; fixtures; mocks/intercepts. Read tests by default. Run them only if the user asks.

**Report:** what is guaranteed, what is mocked, what is not covered.

## History

**When:** “why is it like this”, surprising shape, conflict with current convention.

**Sample:** `git log` / blame on files already in scope (last ~15 commits or the introducing commit), plus a nearby ADR or PR if obvious. Never the whole tree.

**Report:** the decision and the edge case it was solving, in 3–6 bullets.

## Interactions

- Feature Trace may pull Testing for the same path.
- Architecture may pull Convention for “how folders mean things.”
- History never runs unbounded.
